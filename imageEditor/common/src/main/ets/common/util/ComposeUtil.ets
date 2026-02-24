/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { RectValue } from '../../service/EditorSDK';
import { HiLog } from './HiLog';
import { image } from '@kit.ImageKit';
import { BaseEditor, TabName } from '../../service/BaseEditor';
import { App } from '../../service/App';
import { PHOTO_BUNDLE_NAME } from '../const';
import sdk from '../../service/native';
import { componentSnapshot } from '@kit.ArkUI';
import { PixelMapUtil } from './PixelMapUtil';

const TAG = 'ComposeUtil';

enum Delay {
  defaultSaveDelay = 300,
  HighPixelSaveDelay = 300,
  WaitForSetInputData = 100,
}

export enum ComposeIndex {
  DEFAULT = 0,
  CROP = 1,
  STYLUS = 2,
  AI = 3,
  MOSAIC = 4,
  TEXT = 5,
}

export const tabNameMap: Map<TabName, ComposeIndex> = (() => {
  const map: Map<TabName, ComposeIndex> = new Map([
    [TabName.TabCrop, ComposeIndex.CROP],
    [TabName.TabMosaic, ComposeIndex.MOSAIC],
    [TabName.TabTextEdit, ComposeIndex.TEXT],
  ]);
  Object.values(TabName).forEach((tab) => {
    if (map.has(tab as TabName)) {
      return;
    } else {
      map.set(tab as TabName, ComposeIndex.DEFAULT);
    }
  });
  HiLog.i(TAG, JSON.stringify(map));
  return map;
})();

const defaultResolve = (pm: PixelMap) => {
  HiLog.i(TAG, 'test cacheResolve');
};
let cacheResolve = defaultResolve;

const needUseCache = (dstTab: ComposeIndex) => {
  return dstTab === ComposeIndex.STYLUS || dstTab === ComposeIndex.AI || dstTab === ComposeIndex.TEXT ||
    dstTab === ComposeIndex.MOSAIC;
};

export class ComposeUtil {
  /**
   * 切页面切直接合成
   * editor 当前BaseEditor
   * dstTab 目标Tab
   * rect 当前页图片显示Rect
   * num DFX记录个数
   * callback 执行回调
   */
  public static prepare = (pageName: string, editor: BaseEditor, dstTab: number,
    num: number, callback: Function, delay: boolean = true) => {
    HiLog.i(TAG, 'prepare start');
    editor.isInTextArea = false;
    /* instrument ignore if */
    if (editor.isComposing) {
      HiLog.i(TAG, 'switch composing return');
      return;
    }
    editor.isComposing = true;
    // 合成后不支持XXX编辑，关闭弹窗
    editor.isSupportXTStyleEdit = false;
    if (needUseCache(dstTab)) {
      editor.asset.exportPixelMapPromise = new Promise<PixelMap>(resolve => {
        cacheResolve = resolve;
      });
    }
    editor.getExportRect((width: number, height: number) => {
      editor.imageSourceWidth = width;
      editor.imageSourceHeight = height;
      let delayTimeout = dstTab === ComposeIndex.CROP || dstTab === ComposeIndex.MOSAIC ?
        Delay.HighPixelSaveDelay : Delay.defaultSaveDelay
      // 裁剪页动画效果较长
      if (delay) {
        setTimeout(
          () => {
            this.save(pageName, editor, dstTab, num, callback);
          },
          delayTimeout
        );
      } else {
        this.save(pageName, editor, dstTab, num, callback);
      }
    });
  }
  // 保存时合成
  public static save = (pageName: string, editor: BaseEditor, dstTab: number,
    num: number, callback?: Function) => {
    HiLog.i(TAG, 'start saving');
    let snapshotMap: image.PixelMap | undefined = this.getSnapShotPixelMap(
      pageName, editor.imageSourceWidth, editor.imageSourceHeight, num);
    /* instrument ignore if */
    if (snapshotMap === undefined) {
      HiLog.e(TAG, 'unexpected getSnapShotPixelMap');
      editor.isComposing = false;
      callback?.();
      return;
    }
    PixelMapUtil.setMemoryNameSync(snapshotMap, 'snapshotMap');
    this.compose(editor, dstTab, snapshotMap, callback);
  }
  private static isHighPixel = (editor: BaseEditor) => {
    return editor.imageSourceWidth * editor.imageSourceHeight >= 3072 * 4096;
  };
  public static compose = (editor: BaseEditor, dstTab: number, snapshotMap: image.PixelMap, callback?: Function) => {
    HiLog.i(TAG, `compose isResetSelected:${editor.asset.adjusts().isResetSelected}`);
    let areaInfo = new RectValue(0, 0, editor.imageSourceWidth, editor.imageSourceHeight);
    let startTime = new Date().getTime();
    editor.asset.setAutoFlush(false);
    this.sdkCompose(editor, snapshotMap, areaInfo, (pixelmapCompose: image.PixelMap) => {
      PixelMapUtil.setMemoryNameSync(pixelmapCompose, 'ComposePixelMap');
      App.getInstance().curEditor().setInputData(pixelmapCompose);
      if (needUseCache(dstTab)) {
        let tmpPixelMap = editor.asset.exportPixelMap;
        editor.asset.exportPixelMap = pixelmapCompose;
        cacheResolve(pixelmapCompose);
        HiLog.i(TAG, 'get new cachePixelMap');
        tmpPixelMap?.release();
      } else {
        // 切到不需要合成图的页面释放缓存，下次进入重新获取合成图
        HiLog.i(TAG, 'release cachePixelMap');
        editor.asset.exportPixelMap?.release();
        editor.asset.exportPixelMap = undefined;
        editor.asset.exportPixelMapPromise = undefined;
        pixelmapCompose?.release();
      }
      cacheResolve = defaultResolve;
      HiLog.i(TAG, 'compose cost: %{public}i', new Date().getTime() - startTime);
      editor.setEditDataType(PHOTO_BUNDLE_NAME);

      // 重置编辑数据
      App.getInstance().curEditor().resetData(() => {
        setTimeout(() => {
          callback?.();
          editor.isComposing = false;
        }, this.isHighPixel(editor) ? Delay.WaitForSetInputData : 0);
      });
      snapshotMap?.release();
      editor.asset.setAutoFlush(true);
      HiLog.i(TAG, 'end saving, total cost: %{public}i', new Date().getTime() - startTime);
    });
  }
  private static sdkCompose = (editor: BaseEditor, dstPixelMap: image.PixelMap | undefined, areaInfo: RectValue,
    callback: (pixelMap: image.PixelMap) => void) => {
    /* instrument ignore if */
    if (!dstPixelMap) {
      HiLog.e(TAG, 'dstPixelMap null');
      return;
    }
    sdk.Asset_AddStylus(editor.timeline.id, editor.asset.uid, dstPixelMap,
      areaInfo.x, areaInfo.y, areaInfo.width, areaInfo.height, callback);
  }
  private static getSnapShotPixelMap = (pageName: string, originWidth: number,
    originHeight: number, num: number): image.PixelMap | undefined => {
    let msg: Record<string, number | string | boolean> = {
      'TEXT_BOX_NUM': num
    };

    const startTime: number = new Date().getTime();
    let snapshotMap: image.PixelMap | undefined = undefined;
    try {
      snapshotMap = componentSnapshot.getSync(pageName);
    } catch (e) {
      HiLog.e(TAG, `getSync error:${JSON.stringify(e)}`);
    }
    HiLog.i(TAG, 'componentSnapshot cost: %{public}i', new Date().getTime() - startTime);
    /* instrument ignore if */
    if (snapshotMap === undefined) {
      HiLog.e(TAG, 'unexpected componentSnapshot');
      return undefined;
    }
    const info = snapshotMap.getImageInfoSync();
    const previewWidth = info.size.width;
    const previewHeight = info.size.height;
    let scaleX = originWidth / previewWidth;
    let scaleY = originHeight / previewHeight;
    HiLog.i(TAG, `
      originWidth:${originWidth}, originHeight:${originHeight},
      previewWidth:${previewWidth}, previewHeight:${previewHeight},
      scaleX:${scaleX},scaleY:${scaleY}`);
    snapshotMap.flipSync(false, true);
    snapshotMap.scaleSync(scaleX, scaleY);
    let pixelSize: image.Size = snapshotMap.getImageInfoSync().size;
    HiLog.i(TAG, `pixelSize.width:${pixelSize.width},pixelSize.height:${pixelSize.height}`);
    if (pixelSize.width > originWidth || pixelSize.height > originHeight) {
      let cropSize: image.Size = pixelSize;
      cropSize.width = Math.min(originWidth, pixelSize.width);
      cropSize.height = Math.min(originHeight, pixelSize.height);
      snapshotMap.cropSync({
        size: cropSize,
        x: 0,
        y: 0,
      })
    }
    return snapshotMap;
  }

  /**
   *  复制（深拷贝）一个新的PixelMap
   *
   * @param pixelMap - 被复制的PixelMap。
   * @param desiredPixelFormat - 新PixelMap的像素格式。如果不指定，则仍使用原PixelMap的像素格式。
   * @returns 新PixelMap。
   **/
  public static clonePixelMap(pixelMap: PixelMap, desiredPixelFormat?: image.PixelMapFormat): PixelMap {
    // 获取当前PixelMap的图片信息。
    const imageInfo = pixelMap.getImageInfoSync();
    // 读取当前PixelMap的图像像素数据，并按照当前PixelMap的像素格式写入缓冲区数组。
    const buffer = new ArrayBuffer(pixelMap.getPixelBytesNumber());
    pixelMap.readPixelsToBufferSync(buffer);
    // 根据当前PixelMap的图片信息，生成初始化选项。
    const options: image.InitializationOptions = {
      // 当前PixelMap的像素格式。
      srcPixelFormat: imageInfo.pixelFormat,
      // 新PixelMap的像素格式。
      pixelFormat: desiredPixelFormat ?? imageInfo.pixelFormat,
      // 当前PixelMap的尺寸大小。
      size: imageInfo.size,
    };
    // 根据初始化选项和缓冲区数组，生成新PixelMap。
    return image.createPixelMapSync(buffer, options);
  }
}