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
import { BaseEditor, TabName, MenuChangeType, App } from '../../App';
import { Asset } from '../../Asset';
import { MenuAttr } from './MenuAttr';
import { FrameSize, RectValue } from '../../EditorSDK';
import { HiLog } from '../../../common/util/HiLog';
import { image } from '@kit.ImageKit';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { PaintController } from '../mosaic/PaintController';
import { ResourceButtonItem } from '../../../feature/basic/common/view/SelectableProgressButton';
import sdk from '../../native';
import { ScreenManager } from '../../../../../../index';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { ComposeIndex, ComposeUtil, tabNameMap } from '../../../common/util/ComposeUtil';
import { ANIMATION_COST, WAIT_FOR_FLUSH } from '../mosaic/const';
import { PixelMapUtil } from '../../../common/util/PixelMapUtil';
import { GestureController } from '../mosaic/GestureController';
import { GetExportDataOptions } from '../../IEditor';

const TAG = 'MosaicAttr';

const EXPORT_DELAY = 400;

const WATERMARK_FROM_DAILY = 250;

enum Delay {
  defaultSaveDelay = 50,
  HighPixelSaveDelay = 200,
  defaultCallbackDelay = 500,
  HighPixelCallbackDelay = 2000,
}

const sleep = (dr: number): Promise<void> => new Promise(resolve => {
  setTimeout(() => resolve(), dr);
});

let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

@Observed
export class MosaicAttr extends MenuAttr {
  public pageName: string = 'mosaic_canvas';
  public rect: RectValue = new RectValue(0, 0, 0, 0);
  public editData: string = '';
  public tabIndex: number = 0;
  public isComparing: boolean = false;
  public onSave: boolean = false;
  public isInMosaicTab: boolean = false;
  public canUndo: boolean = false;
  public canRedo: boolean = false;
  public paintController?: PaintController;
  public isClickUndoRedo: boolean = false;
  public selectMosaicSize: number = 2; // 马赛克画笔默认2（中画笔）
  public selectMosaicIndex: number = 1; // 马赛克选中的类型默认下标为1（经典马赛克）
  public selectMosaicKey: string = 'mosaic_1'; // 马赛克选中的类型默认经典马赛克
  private exportTimer: number = -1;
  public listener: BroadCast;
  private exportReject?: () => void;
  public isModified: boolean = false;
  public composedTimes: number = 0; // 马赛克界面 合成的次数
  public previewRect?: RectValue;
  public leaveAnimPromise?: Promise<void>;
  public isLeaving: boolean = false;
  public watermarkFrameSize: FrameSize = { top: 0, bottom: 0, left: 0, right: 0 };
  public gestureController?: GestureController;
  public mosaicImageList = [
    new ResourceButtonItem($r('sys.symbol.eraser_line'), 'mosaic_0', 0), // 橡皮擦
    new ResourceButtonItem($r('app.media.ic_gallery_edit_mosaic_1'), 'mosaic_1', 0), // 经典马赛克
    new ResourceButtonItem($r('app.media.ic_gallery_edit_mosaic_2'), 'mosaic_2', 0), // 编织马赛克
    new ResourceButtonItem($r('app.media.ic_gallery_edit_mosaic_3'), 'mosaic_3', 0), // 星星马赛克
    new ResourceButtonItem($r('app.media.ic_gallery_edit_mosaic_4'), 'mosaic_4', 0), // 天蓝马赛克
    new ResourceButtonItem($r('app.media.ic_gallery_edit_mosaic_5'), 'mosaic_5', 0), // 波点马赛克
    new ResourceButtonItem($r('app.media.ic_gallery_edit_mosaic_6'), 'mosaic_6', 0), // 万花筒马赛克
    new ResourceButtonItem($r('app.media.ic_gallery_edit_mosaic_7'), 'mosaic_7', 0), // 卡通马赛克
    new ResourceButtonItem($r('app.media.ic_gallery_edit_mosaic_8'), 'mosaic_8', 0), // 三角形马赛克
    new ResourceButtonItem($r('app.media.ic_gallery_edit_mosaic_9'), 'mosaic_9', 0), // 彩块马赛克
  ];
  public mosaicTypeText = [
    $r('app.string.mosicac_eraser'),
    $r('app.string.mosicac_typ_classic'),
    $r('app.string.mosicac_type_weaving'),
    $r('app.string.mosicac_type_star'),
    $r('app.string.mosicac_type_sky_blue'),
    $r('app.string.mosicac_type_polka_dot'),
    $r('app.string.mosicac_type_kaleidoscope'),
    $r('app.string.mosicac_type_cartoon'),
    $r('app.string.mosicac_type_triangle'),
    $r('app.string.mosicac_type_color_block'),
  ];
  public baseImagePromise?: Promise<PixelMap>;

  constructor(editor: BaseEditor, asset: Asset) {
    super(editor, asset);
    HiLog.i(TAG, 'mosaic attr init');
    this.listener = new BroadCast();
  }

  isAnimationSealType() {
  }

  async enterMenu() {
    super.enterMenu();
    /* instrument ignore if */
    if ((TabName.TabMosaic === this.changeTabIndex || this.editor.tabIndex === this.changeTabIndex) &&
      (this.editor.tabIndex != TabName.TabCrop) && !ScreenManager.getInstance().isScreenPortrait()) {
      App.getInstance().screenClass.screenChangeType = MenuChangeType.NO_CROP_TO_NO_CROP;
      HiLog.i(TAG, `change screen type: ${App.getInstance().screenClass.screenChangeType}`);
    }
    HiLog.i(TAG, 'MosaicAttr enterMenu');
    // 预览图片恢复到默认大小的动画
    this.editor.switchTabWidthWatermarkAnim(1);

    this.changeView(true);
    this.prepareBaseImg();
  }

  async leaveMenu(index: TabName, close = false) {
    this.isLeaving = true;
    this.exportReject?.();
    clearTimeout(this.exportTimer);
    const needCompose = !close && this.canUndo;
    if (needCompose) {
      this.asset.adjusts().isResetSelected = true;
    }
    // 合成或放大均需要ets 做Image动效
    const needAnim = needCompose || this.gestureController?.imgScale !== 1 || close;

    let isNeedAutoFlush = false;
    isNeedAutoFlush = true;

    HiLog.i(TAG, `leave menu needCompose=${needCompose}` +
      ` scale=${this.gestureController?.imgScale} close=${close} isNeedAutoFlush=${isNeedAutoFlush}`);

    if (needAnim) {
      // 需要合成时 先等待水印动效完成，再做合成处理
      await sleep(20);
      // 触发image动效
      this.listener.emit('beforeLeaveMosaicView', [index]);
    } else {
      BroadCastManager.getInstance().getBroadCast().emit('LeaveMosaicView');
      this.asset.clearComposedCache();
      this.isLeaving = false;
    }
    isNeedAutoFlush && this.editor.asset.setAutoFlush(true);

    const compose: Promise<void> = needCompose ? this.beforeLeave(tabNameMap.get(index)!) : Promise.resolve();
    // 需要image动效时，等合与动效全部完成后，马赛克页面下树
    if (needAnim) {
      await Promise.all([
        compose,
        this.leaveAnimPromise,
      ]).then(async () => {
        await sleep(WAIT_FOR_FLUSH);
        appBroadCast.emit('LeaveMosaicView');
        if (index === TabName.TabTextEdit) {
          this.editor.previewStarter.updatePreview();
        }
        this.isLeaving = false;
        this.asset.clearComposedCache();
      });
    }
    this.baseImagePromise = undefined;
    this.previewRect = undefined;
    this.canUndo = false;
    this.canRedo = false;
  }

  public watermarkParamInit(width: number, height: number, scale: number) {
  }

  private prepareBaseImg() {
    const exportDelayTime = this.tabIndex === TabName.TabSeal ? WATERMARK_FROM_DAILY : EXPORT_DELAY;
    const start = Date.now();
    /* instrument ignore if */
    if (this.baseImagePromise) {
      this.exportReject?.();
    }
    this.baseImagePromise = new Promise<PixelMap>((resolve, reject) => {
      this.exportReject = reject;
      clearTimeout(this.exportTimer);
      /* instrument ignore if */
      if (this.asset.exportPixelMapPromise !== undefined) {

        // 使用其他合成页面的导出图
        this.asset.exportPixelMapPromise.then((pm) => {
          resolve(pm);
          HiLog.i(TAG, 'get export image has cache');
        }).catch(() => {
          reject('cachePixelMapPromise get error');
        });
        return;
      }
      this.exportTimer = setTimeout(() => {
        this.editor.isComposing = true;
        HiLog.i(TAG, 'get export image no cache');
        let options = new GetExportDataOptions().setNeedAddWatermark(false);
        this.editor.getExportData((pixelMap: image.PixelMap, exportInfo: string) => {
          this.editor.isComposing = false;
          PixelMapUtil.setMemoryNameSync(pixelMap, 'EnterMosaicExportPixelMap');
          resolve(pixelMap);
          HiLog.i(TAG, 'export cost: ' + (Date.now() - start));
        }, options);
      }, exportDelayTime);
    });
  }

  changeView(display: boolean) {
    this.listener.emit('onMosaicViewChange', [display]);
  }

  async beforeEnterStylus() {
    await this.baseImagePromise;
    if (this.canUndo) {
      await new Promise<void>((resolve) => {
        ComposeUtil.prepare(this.pageName, this.editor, ComposeIndex.STYLUS, 0,
          () => {
            this.composedTimes++;
            resolve();
          }, false);
      });
    }
    this.listener.emit('beforeEnterStylus');
    this.canUndo = false;
    this.canRedo = false;
    this.paintController?.clearPaths();
  }

  async beforeEnterAi() {
    HiLog.i(TAG, 'beforeEnterAi');
    await this.baseImagePromise;
    if (this.canUndo) {
      HiLog.i(TAG, 'beforeEnterAi compose');
      await new Promise<void>((resolve) => {
        ComposeUtil.prepare(this.pageName, this.editor, ComposeIndex.AI, 0,
          () => {
            this.composedTimes++;
            resolve();
          }, false);
      });
    }
    this.listener.emit('beforeEnterAI');
    this.canUndo = false;
    this.canRedo = false;
    this.paintController?.clearPaths();
  }

  updateUndoRedo() {
    if (this.paintController) {
      if (this.canUndo !== this.paintController.canUndo()) {
        this.canUndo = this.paintController.canUndo();
        this.editor.mosaicModified = this.canUndo || !!this.composedTimes;
      }
      if (this.canRedo !== this.paintController.canRedo()) {
        this.canRedo = this.paintController.canRedo();
      }
    }
  }

  undo() {
    if (this.paintController) {
      HiLog.i(TAG, 'mosaic undo cilck');
      this.paintController.undo();
      this.updateUndoRedo();
    }
  }

  redo() {
    if (this.paintController) {
      HiLog.i(TAG, 'mosaic redo cilck');
      this.paintController.redo();
      this.updateUndoRedo();
    }
  }

  public beforeLeave = async (dstTab: ComposeIndex) => {
    /* instrument ignore if */
    const start = Date.now();
    await new Promise<void>((resolve) => {
      ComposeUtil.prepare(this.pageName, this.editor, dstTab, 0, () => {
        resolve();
        this.composedTimes++;
        HiLog.i(TAG, 'leave mosaic compose cost:' + (Date.now() - start));
      }, false);
    });
  };
  public save = (dstTab: number) => {
    return new Promise<void>((resolve) => {
      /* instrument ignore if */
      if (!this.canUndo) {
        resolve();
        return;
      }
      ComposeUtil.save(this.pageName, this.editor, dstTab, 0, () => {
        resolve();
      });
    });
  };

  public getPreviewRect(): RectValue | void {
    if (this.previewRect) {
      return new RectValue(vp2px(this.previewRect.x), vp2px(this.previewRect.y),
        vp2px(this.previewRect.width), vp2px(this.previewRect.height));
    }
  }

  public setComparing(flag: boolean) {
    /* instrument ignore if */
    if (flag === this.isComparing) {
      return;
    }
    this.isComparing = flag;
  }

  setPreviewRect(rect: RectValue) {
    this.previewRect = rect;
  }

  getExportRect(): Promise<RectValue> {
    return new Promise(resolve => {
      sdk.EditorContext_getExportRect(this.editor.timeline.id, this.asset.uid, (width: number, height: number) => {
        resolve(new RectValue(0, 0, width, height));
      });
    });
  }

  getComposedPixelMap(pm: PixelMap, areaInfo: RectValue): Promise<PixelMap> {
    return new Promise(
      (resolve) => {
        sdk.Asset_AddStylus(this.editor.timeline.id, this.asset.uid, pm,
          areaInfo.x, areaInfo.y, areaInfo.width, areaInfo.height, (composed: image.PixelMap) => {
            resolve(composed);
          });
      }
    );
  }
}
