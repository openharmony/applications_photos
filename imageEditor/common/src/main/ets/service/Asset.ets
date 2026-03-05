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
// instrument ignore file
import { replaceExists } from '../common/util/misc';
import { HiLog } from '../common/util/HiLog';
import { BaseEditor, AdjustAttr, OperationArea } from './BaseEditor';
import { lpx } from '../common/jul';
import sdk from './native';
import { Rectangle } from '../common/util/types';
import { UiUtil } from '../common/util/UiUtil';
import {
  TAB_SIZE,
  TOOL_CONTAINER_HEIGHT,
  BOTTOM_NAVIGATION_HEIGHT,
  OVER_SEAL_SIZE,
  PAVE_SCREEN_ITEM,
  CropIndex
} from '../common/const';
import { CropScaleClass, CropType } from './model/CropModel';
import { DeviceUtil } from '../common/util/DeviceUtil';
import { NullUtil } from '../common/util/NullUtil';
import { CropAttr, CropVal2, CropVal3 } from './model/menu/CropAttr';
import { FillCropType, TabName } from './model/Enum';
import LightWeightMap from '@ohos.util.LightWeightMap';
import { MenuAttr } from './model/menu/MenuAttr';
import { image } from '@kit.ImageKit';
import { AdjustItem } from './model/menu/AdjustAttr';
import { promptAction } from '@kit.ArkUI';
import { ScreenManager } from '../common/util/ScreenManager';
import { TextEditAttr } from './model/menu/TextEditAttr';
import { MosaicAttr } from './model/menu/MosaicAttr';
import { Trace } from '../common/util/Trace';
import { ApsUtil, APS_SCENE_STATE_OFF, PHOTO_IN_EDIT_CROP, PHOTO_BUNDLE_NAME } from '../common/util/ApsUtil';

let TAG: string = 'Asset';

@Observed
export class Asset {
  public uid: string = '';
  public name: string = '';
  public duration: number = 1000;
  public originalWidth: number = 10;
  public originalHeight: number = 10;
  public timelineId: number = 0;
  public laneUid: string = '';
  public originalFps: number = 30;
  public rotationX: number = 0;
  public rotationY: number = 0;
  public extraRotation: number = 0;
  public isMute: number = 0;
  public mirror: number = 0;
  public cropRectLeft: number = 0;
  public cropRectTop: number = 0;
  public cropRectRight: number = 0;
  public cropRectBottom: number = 0;
  public isGestureOperate: boolean = false;
  public path: string = '';
  public thumbnailPixels: PixelMap[] = [] // 抽帧图片颜色数组
  public isClickUndoRedo: boolean = false;
  public cropAttr?: CropAttr;
  public textEditAttr?: TextEditAttr;
  private mosaicAttr?: MosaicAttr;
  public isBindXComponentFailed: boolean = false;
  public isTouching: boolean = false; // 是否操作中，用于控制公共组件是否可用
  public isPictureAnimation: boolean = false; // 是否裁剪框和其他选项框切换动画中，用于控制用户快速切换的场景
  private adjustAttr: AdjustAttr | null = null;
  private editor: BaseEditor;
  private artText: string = '';
  public isUnfoldPortrait: boolean = true;
  public menuMap: LightWeightMap<TabName, MenuAttr> = new LightWeightMap();
  public noStylusPixelMap: image.PixelMap | undefined = undefined; // 涂鸦底图
  public textEditPixelMap: image.PixelMap | undefined = undefined; // 文本标注图层
  public exportPixelMap: image.PixelMap | undefined = undefined;
  public exportPixelMapPromise: Promise<image.PixelMap> | undefined = undefined;
  public isShowCropRect: boolean = false; // 是否显示裁剪框
  public cropInterval: number = 200;
  public preIsCustomFilterCardShow = false;
  /**
   * 是否处于动效中
   */
  public isAnimating: boolean = false;
  public animateTimer: number = -1;

  constructor(editor: BaseEditor) {
    this.editor = editor;
  }

  public adjusts(): AdjustAttr {
    if (!this.adjustAttr) {
      this.adjustAttr = new AdjustAttr(this.editor, this);
    }
    return this.adjustAttr;
  }

  public crops(): CropAttr {
    if (!this.cropAttr) {
      this.cropAttr = new CropAttr(this.editor, this);
    }
    return this.cropAttr;
  }

  public textEdit(): TextEditAttr {
    if (!this.textEditAttr) {
      HiLog.i(TAG, 'textEditAttr init');
      this.textEditAttr = new TextEditAttr(this.editor, this);
    }
    return this.textEditAttr;
  }

  public mosaic(): MosaicAttr {
    if (!this.mosaicAttr) {
      this.mosaicAttr = new MosaicAttr(this.editor, this);
    }
    return this.mosaicAttr;
  }

  public getMenuAttr(tabIndex: TabName = this.editor.tabIndex): MenuAttr {
    if (this.menuMap.length == 0) {
      this.menuMap.set(TabName.TabCrop, this.crops());
      this.menuMap.set(TabName.TabAdjust, this.adjusts());
      this.menuMap.set(TabName.TabTextEdit, this.textEdit());
      this.menuMap.set(TabName.TabMosaic, this.mosaic());
    }
    HiLog.i(TAG, `getMenuAttr index:${tabIndex}`);
    return this.menuMap.get(tabIndex);
  }

  initData(asset: LanAsset): void {
    if (asset === null || asset === undefined) {
      HiLog.e(TAG, 'init asset failed, asset is undefined');
      return;
    }
    // 首次有的属性，全部复制
    replaceExists(asset, this);
    // 复制Crop属性
    let crop = this.crops();
    replaceExists(asset, crop);

    // 移除了自由旋转功能，只设置水平和垂直校正
    if (crop.cropTabs.length > CropIndex.HORIZONTAL) {
      crop.cropTabs[CropIndex.HORIZONTAL]?.setChangeValues?.(asset.rotationY, 1);
    }
    if (crop.cropTabs.length > CropIndex.VERTICAL) {
      crop.cropTabs[CropIndex.VERTICAL]?.setChangeValues?.(asset.rotationX, 1);
    }
    crop.cropRect.left = asset.cropRectLeft;
    crop.cropRect.top = asset.cropRectTop;
    crop.cropRect.right = asset.cropRectRight;
    crop.cropRect.bottom = asset.cropRectBottom;
    if (crop.cropRect.width() == 0 || crop.cropRect.height() == 0) {
      crop.cropRect.left = lpx(40);
      crop.cropRect.top = lpx(220);
      crop.cropRect.right = lpx(640);
      crop.cropRect.bottom = lpx(1180);
    }
    HiLog.i(TAG, `initData cropRect ${crop.cropRect.toString()}`);
    crop.scale = asset.clipRatio;
    crop.mirrorFlag = asset.mirror;
    crop.clipRatio = asset.clipRatio;
    crop.isCropSizeModified = asset.isAssetPosChange;
    let cropIndex: number = 1;
    cropIndex = this.crops().videoScaleList.findIndex((item: CropScaleClass) => item.ratio === asset.chooseRatio)
    cropIndex = cropIndex < 0 ? 1 : cropIndex;
    crop.ratio = this.crops().videoScaleList[cropIndex].ratio;
    crop.scale = this.crops().videoScaleList[cropIndex].value;
    crop.isEnableMask = !asset.isPreviewMode; // 图片编辑默认进入裁剪tab,蒙层和模糊都显示
    crop.isEnableBlur = !asset.isPreviewMode;
    if (crop.scale == PAVE_SCREEN_ITEM) {
      if ((asset.cropRectBottom - asset.cropRectTop) != 0) {
        crop.clipRatio = (asset.cropRectRight - asset.cropRectLeft) / (asset.cropRectBottom - asset.cropRectTop);
      } else {
        crop.clipRatio = asset.originalWidth / asset.originalHeight;
      }
    } else {
      crop.clipRatio = crop.scale;
    }

    this.handleSupportSealSize();
  }

  handleSupportSealSize() {
    if (this.editor.editData) {
      const viewportSize: Record<string, number> = JSON.parse(this.editor.editData)?.imageEffect?.filters?.[1]?.values;
      HiLog.i(TAG, `init image size: ${viewportSize?.viewportX} ${viewportSize?.viewportY}`);
      const minSize = Math.min(viewportSize?.viewportX, viewportSize?.viewportY);
      this.editor.isSupportSealSize = minSize < OVER_SEAL_SIZE ? false : true;
    } else {
      this.overSizePrompt();
    }
  }

  // instrument ignore next
  isEditWatermark() {
    return false;
  }

  /*
     * @param cb              滤镜缩略图回调函数
     * cb param laneId        泳道ID
     * cb param assetId       素材assetID
     * cb param filterId      滤镜ID
     * cb param pts           滤镜缩略图对应的时间戳timestamp
     * cb param buffer        滤镜缩略图HmcImage的buffer
     * cb param width         滤镜缩略图宽尺寸
     * cb param height        滤镜缩略图高尺寸
     * */
  setFilterThumbnailCallback(cb: (laneId: string, assetId: string, filterId: string, pts: number,
    pixelmap: image.PixelMap, width: number, height: number) => void): void {
    sdk.EditorContext_setFilterThumbnailCallback(this.editor.timeline.id, cb);
  }

  /* 请求滤镜缩略图 */
  requestFilterThumbnail(): void {
    sdk.Asset_requestFilterThumbnail(this.editor.timeline.id, this.uid);
  }

  /* 个性风格缩略图回调函数 */
  setXTStyleThumbnailCallback(cb: (pixelmap: image.PixelMap, jsonStr: string) => void): void {
    sdk.EditorContext_setXTStyleThumbnailCallback(this.editor.timeline.id, cb);
  }

  /* 个性风格缩略图初始化部分参数 */
  initializeXTStyleThumbnail(): void {
    sdk.Asset_initializeXTStyleThumbnail(this.editor.timeline.id, this.uid);
  }

  /* 请求个性风格缩略图 */
  requestXTStyleThumbnail(): void {
  }

  /**
   * 设置Asset新的的裁剪区域，裁剪后会自动进行centerInside规则放大并返回给UI。
   *
   * @param left 裁剪框位置left，旋转需要以裁剪框中心点旋转，并自动缩放以填充裁剪框
   * @param top 裁剪框位置top，旋转需要以裁剪框中心点旋转，并自动缩放以填充裁剪框
   * @param right 裁剪框位置right，旋转需要以裁剪框中心点旋转，并自动缩放以填充裁剪框
   * @param bottom 裁剪框位置bottom，旋转需要以裁剪框中心点旋转，并自动缩放以填充裁剪框
   * @param animMs 自动放大&移动的动画时长
   * @param type 自由比例裁剪为0；固定比例裁剪为1；拖动裁剪框为2
   * @param callback 返回centerInside规则后的新的rect
   */
  setCropRect(left: number, top: number, right: number, bottom: number, animMs: number, type: number,
    chooseRatio: string, callback: (jsonPos: string) => void): boolean {
    HiLog.i(TAG, 'Asset: setCropRect ' + left + `,${top}` + ',' + right + ',' + bottom);
    return sdk.Asset_setCropRect(this.editor.timeline.id, this.uid, left, top, right, bottom, animMs, type,
      chooseRatio, callback);
  }

  /**
   * 裁剪后重新获取裁剪区域
   * 恢复区域动画时长 duration： 300ms
   * canvas比例 canvasToDesignRatio
   *
   * @param aniDuration 动画时长
   * @param setType 裁剪类型
   * @param chooseRatio 固定比例下选中的比例项
   */
  setClipCropRect(aniDuration: number, setType: number, isConvertRec: boolean = true, chooseRatio: string = '0'): void {
    if (!this.cropAttr) {
      HiLog.w(TAG, 'setClipCropRect cropAttr is null');
      HiLog.i(TAG, 'setClipCropRect, close setApsSceneState begin, cropAttr is null');
      ApsUtil.setApsSceneState(PHOTO_BUNDLE_NAME, PHOTO_IN_EDIT_CROP, APS_SCENE_STATE_OFF);
      HiLog.i(TAG, 'setClipCropRect, close setApsSceneState end, cropAttr is null');
      return;
    }
    let duration = aniDuration;
    let crop = this.cropAttr.cropRect;
    let canvasCropRect = new Rectangle(vp2px(crop.left), vp2px(crop.top), vp2px(crop.right), vp2px(crop.bottom));
    HiLog.i(TAG, 'Asset: setClipCropRect input=[' + canvasCropRect.left + `,${canvasCropRect.top}` + ',' +
    canvasCropRect.right + ',' + canvasCropRect.bottom + ']');
    this.crops()
      .isCropSizeModified = this.setCropRect(canvasCropRect.left, canvasCropRect.top, canvasCropRect.right,
      canvasCropRect.bottom, duration, setType, chooseRatio, (res: string) => {
        let result: Rectangle = JSON.parse(res);
        if (NullUtil.isObjNull(result)) {
          HiLog.e('setClipCropRect', 'setClipCropRect json return is null.');
          HiLog.i(TAG, 'setClipCropRect, close setApsSceneState begin, json return is null');
          ApsUtil.setApsSceneState(PHOTO_BUNDLE_NAME, PHOTO_IN_EDIT_CROP, APS_SCENE_STATE_OFF);
          HiLog.i(TAG, 'setClipCropRect, close setApsSceneState end, json return is null');
          return;
        }
        let last = new Rectangle(px2vp(result.left), px2vp(result.top), px2vp(result.right), px2vp(result.bottom));
        // 裁剪后恢复动画
        if (duration > 0) {
          setTimeout((): void => {
            animateTo({
              duration: duration, // 动画时长
              iterations: 1, // 播放次数 -1无限次
              curve: Curve.Linear, // 动画模式
              onFinish: () => {
                HiLog.i(TAG, 'setClipCropRect, close setApsSceneState begin, animate finish');
                ApsUtil.setApsSceneState(PHOTO_BUNDLE_NAME, PHOTO_IN_EDIT_CROP, APS_SCENE_STATE_OFF);
                HiLog.i(TAG, 'setClipCropRect, close setApsSceneState end, animate finish');
              }
            }, () => {
              crop.left = last.left;
              crop.top = last.top;
              crop.right = last.right;
              crop.bottom = last.bottom;
            })
          }, 15);
        } else {
          crop.left = last.left;
          crop.top = last.top;
          crop.right = last.right;
          crop.bottom = last.bottom;
        }
      })
  }

  /**
   * 移动素材
   *
   * @param offsetX x轴增量移动距离，基于Canvas坐标系
   * @param offsetY y轴增量移动距离，基于Canvas坐标系
   */
  public translate(offsetX: number, offsetY: number, moveType: number = 0): number {
    console.log('Asset: translate ' + offsetX + `,${offsetY}`);
    return sdk.Asset_translate(this.editor.timeline.id, this.uid, offsetX, offsetY, moveType);
  }

  /**
   * 缩放素材
   *
   * @param ratio 增量缩放倍数
   * @param centerX 缩放的中心点x，基于Canvas坐标系
   * @param centerY 缩放的中心点y，基于Canvas坐标系
   */
  public scale(ratio: number, centerX: number, centerY: number): void {
    console.log('Asset: scale ' + ratio + ` center=${centerX}` + ',' + centerY);
    sdk.Asset_scale(this.editor.timeline.id, this.uid, ratio, centerX, centerY);
  }

  public getCropSize(cb?: (width: number, height: number) => void): void {
    HiLog.i('Asset: getCropSize ', 'calculate image size');
    sdk.Asset_calculateCropSize(this.editor.timeline.id, this.uid, cb);
  }

  // 最短边尺寸小于400不支持水印效果
  overSizePrompt(): void {
    this.getCropSize((width: number, height: number) => {
      HiLog.e('Asset: overSizePrompt', 'overSizePrompt image size：%{public}i, %{public}i', width, height);
      const minSize = Math.min(width, height);
      if (minSize < OVER_SEAL_SIZE) {
        if (this.editor.hasSeal && this.editor.isSupportSealSize) {
          this.overSizeShowToast();
        }

        if (this.editor.isSupportSeal && this.editor.hasSealResource && this.editor.isSupportSealSize) {
        }

        this.editor.isSupportSealSize = false;
        console.error('image size less than 400, width * height:', width, height);
      } else {
        this.editor.isSupportSealSize = true;
      }
    });
  }

  overSizeShowToast() {
  }

  // instrument ignore next
  public async inertialMove(event?: GestureEvent) {
    if (this.editor.tabIndex == TabName.TabAperture) {
      return;
    }
    if (event === undefined) {
      return;
    }
    let durationTime: number = sdk.Motion_ResetFrictionMotion(0.6, 0, event.velocity);
    let offsetX: number = 0;
    let offsetY: number = 0;
    let cos: number = event.velocityX / event.velocity;
    let sin: number = event.velocityY / event.velocity;
    let moveTime: number = 10;
    let interval: number = 1;
    while (moveTime <= durationTime && !this.isGestureOperate) {
      await UiUtil.sleep(10);
      let position: number = sdk.Motion_GetPosition(moveTime);
      HiLog.i(TAG, 'moveNum:' + moveTime + `,position:${position}`)
      let x: number = position * cos;
      let y: number = position * sin;
      let isBoundary: boolean = this.translate(x - offsetX, y - offsetY, 2) == 1;
      isBoundary && (interval *= 1.2);
      offsetX = x;
      offsetY = y;
      moveTime += 10 * interval;
    }
  }

  /**
   * 自动缩放&移动素材进行填充裁剪框空白区域
   *
   * @param aniDuration 动画时长
   * @param type 调用接口场景 0：中断场景;1：单指移动开始;2：单指移动结束;3：双指缩放开始;4：双指缩放结束
   */
  // instrument ignore next
  fillCropRect(aniDuration: number, type: FillCropType, cb: () => void = () => {
  }): boolean {
    if (!this.cropAttr) {
      HiLog.w(TAG, 'fillCropRect cropAttr is null');
      return false;
    }
    let crop = this.cropAttr.cropRect;
    let canvasCropRect = new Rectangle(vp2px(crop.left), vp2px(crop.top), vp2px(crop.right), vp2px(crop.bottom));
    HiLog.i(TAG, 'Asset: fillCropRect');
    return sdk.Asset_fillCropRect(this.editor.timeline.id, this.uid, type, aniDuration, canvasCropRect.left,
      canvasCropRect.top, canvasCropRect.right, canvasCropRect.bottom, (jsonStr: string) => {
        let ret: CropVal3 = JSON.parse(jsonStr);
        if (NullUtil.isObjNull(ret) || ret.code === -1) {
          HiLog.e(TAG, `fillCropRect callback no handler, content=${ret}`);
        }
        if (ret.vibration === 1) {
          if (DeviceUtil.isPhone()) {
            UiUtil.vibrateById(UiUtil.CAMERA_GEAR_SLIP_LIGHT_ID)
          }
        } else {
          HiLog.i(TAG, `fillCropRect result=${ret}`);
        }
        cb();
      });
  }

  switchPreviewMode(): void {
    HiLog.i(TAG, 'Asset: switchPreviewMode');
    sdk.Asset_switchPreviewMode(this.editor.timeline.id, this.uid);
  }

  switchCropMode(): void {
    HiLog.i(TAG, 'Asset: switchCropMode');
    sdk.Asset_switchCropMode(this.editor.timeline.id, this.uid);
  }

  /**
   * 页面切换前可以先做一次渲染进行缓存数据，防止动效卡顿
   */
  switchPageRender(): void {
    HiLog.i(TAG, 'Asset: switchPageRender');
    sdk.Asset_switchPageRender(this.editor.timeline.id, this.uid);
  }

  public doPreviewAvoidanceAnimation(canvasSize: number[]): void {
    clearTimeout(this.animateTimer);
    this.isAnimating = true;
    this.animateTimer = setTimeout(() => {
      this.isAnimating = false;
    }, 400);
    sdk.Asset_DoPreviewAvoidanceAnimation(this.editor.timeline.id, this.uid, canvasSize, (res: string): void => {});
  }

  public doXtStyleTriFoldAnimation(isOpen: boolean, operationArea: OperationArea, noAnimation: boolean,
    updateArea: (res: string) => void): void {
    HiLog.i(TAG, `Asset: doXtStyleTriFoldAnimation${isOpen}， 10vp ${vp2px(10)}`);
    sdk.Asset_FinishAnimation(this.editor.timeline.id, this.uid);
    this.preIsCustomFilterCardShow = isOpen;
    let listParam = operationArea.asNapiParam();
    // 动画参数 直板机形态还是200
    let animationCost = ('' === DeviceUtil.currDevicePosture() || !ScreenManager.getInstance().isShowLayoutSwitching()) ?
      200 : 300;
    listParam.push(animationCost);
    HiLog.i(TAG, `Asset: doXtStyleTriFoldAnimation${isOpen}， animationCost ${animationCost}`);
    // 规避预处理场景导致的动画卡顿
    if (!noAnimation && DeviceUtil.currDevicePosture() != '') {
      setTimeout(() => {
        sdk.Asset_DoXtStyleTriFoldAnimation(this.editor.timeline.id, this.uid, listParam, noAnimation,
          isOpen, updateArea);
      }, 100)
    } else {
      sdk.Asset_DoXtStyleTriFoldAnimation(this.editor.timeline.id, this.uid, listParam, noAnimation,
        isOpen, updateArea);
    }
  }

  /**
   * 中心点保持不变，计算素材&cropOperationArea范围内 最大符合比例的rect，基于Canvas坐标系
   *
   * @param left cropOperationArea的left
   * @param top cropOperationArea的top
   * @param right cropOperationArea的right
   * @param bottom cropOperationArea的bottom
   */
  calcOptimalRectUnderRatio(ratio: number, duration: number): void {
    if (ratio == 0) {
      this.crops().clipRatio = 0;
      return;
    }

    if (ratio == -1) {
      ratio = this.originalWidth / this.originalHeight;
    }
    this.crops().clipRatio = ratio;
    let ret: string = sdk.Asset_calcOptimalRectUnderRatio(
      this.editor.timeline.id,
      this.uid,
      vp2px(this.editor.timeline.operLeft),
      vp2px(this.editor.timeline.operTop),
      vp2px(this.editor.timeline.operLeft + this.editor.timeline.operWidth),
      vp2px(this.editor.timeline.operTop + this.editor.timeline.operHeight),
      ratio
    );
    HiLog.i(TAG, `Asset: calcOptimalRectUnderRatio ret=${ret}`);
    try {
      this.calcOptimalRectUnderRatioRet(ret, duration);
    } catch {
      HiLog.e(TAG, 'Asset: calcOptimalRectUnderRatio error');
    }
  }

  calcOptimalRectUnderRatioRet(ret: string, duration: number): void {
    let json: CropVal2 = JSON.parse(ret);
    if (json?.code === undefined) {
      this.setCropRect(json.left, json.top, json.right, json.bottom, duration, CropType.FIXED_RATIO, this.crops()
        .ratio, (res: string) => {
        let result: Rectangle = JSON.parse(res);
        if (NullUtil.isObjNull(result)) {
          HiLog.w('calcOptimalRectUnderRatioRet', 'calcOptimalRectUnderRatioRet json return is null.');
          return;
        }
        let last = new Rectangle(px2vp(result.left), px2vp(result.top), px2vp(result.right), px2vp(result.bottom));
        // 裁剪后恢复动画
        animateTo({
          duration: duration, // 动画时长
          iterations: 1, // 播放次数 -1无限次
          playMode: PlayMode.Alternate, // 动画模式
          onFinish: () => {
          }
        }, () => {
          this.crops().cropRect.left = last.left;
          this.crops().cropRect.top = last.top;
          this.crops().cropRect.right = last.right;
          this.crops().cropRect.bottom = last.bottom;
        });
        HiLog.i(TAG, `Asset: calcOptimalRectUnderRatioRet calResult ${JSON.stringify(result)}`);
      })
    } else {
      HiLog.e(TAG, 'Asset: calcOptimalRectUnderRatioRet return code error');
    }
  }

  getReachableCropRect(left: number, top: number, right: number, bottom: number, ratio: number,
    directionLeft: number, directionTop: number, directionRight: number, directionBottom: number,
    pressure: number = 1): Object | undefined {
    console.log('Asset: getReachableCropRect input=[' + left + `,${top}` + ',' + right + ',' + bottom + '] ratio=' +
      ratio);

    // 超出可操作区域的 异常输入分支 兜底
    let timeline = this.editor.timeline;
    let ret: string = '';
    if (left < timeline.operLeft - 10e-2 ||
      top < timeline.operTop - 10e-2 ||
      right > timeline.operLeft + timeline.operWidth + 10e-2 ||
      bottom > timeline.operTop + timeline.operHeight + 10e-2) {
      HiLog.i(TAG, 'out crop range');
      Trace.begin('outEditorCropRange');
      let cropRect = this.crops().cropRect;
      if (cropRect.left - left >= 4 || right - cropRect.right >= 4 || cropRect.top - top >= 4 ||
        bottom - cropRect.bottom >= 4) {
        HiLog.i(TAG, 'begin reverse crop');
        ret = sdk.Asset_ReverseCrop(timeline.id, this.uid,
          [vp2px(left), vp2px(top), vp2px(right), vp2px(bottom), vp2px(cropRect.left), vp2px(cropRect.top),
            vp2px(cropRect.right), vp2px(cropRect.bottom)], ratio,
          [directionLeft, directionTop, directionRight, directionBottom], pressure)
        Trace.end('outEditorCropRange');
      } else {
        Trace.end('outEditorCropRange');
        HiLog.i(TAG, 'begin max crop');
        return undefined;
      }
    } else {
      // SDK层限制裁剪框不超出 素材边缘
      Trace.begin('inEditorCropRange');
      ret = sdk.Asset_getReachableCropRect(timeline.id, this.uid,
        vp2px(left), vp2px(top), vp2px(right), vp2px(bottom), ratio,
        directionLeft, directionTop, directionRight, directionBottom, () => {
        });
      Trace.end('inEditorCropRange');
      HiLog.i(TAG, 'in crop range');
    }
    try {
      let json: CropVal2 = JSON.parse(ret);
      if (NullUtil.isObjNull(json) || json.code !== undefined) {
        HiLog.e(TAG, 'getReachableCropRect failed. result is empty');
        return undefined;
      }
      this.rectTo(json, px2vp);
      HiLog.i(TAG, 'Asset: getReachableCropRect output=[' + json.left + `,${json.top}` + ',' +
      json.right + ',' + json.bottom + ']');
      return json;
    } catch {
      return undefined;
    }
  }

  setOriginalColorMode(originalColorMode: number): void {
    HiLog.i(TAG, `setOriginalColorMode =  ${originalColorMode}`);
    sdk.Asset_SetOriginalColorMode(this.editor.timeline.id, this.uid, originalColorMode);
  }

  getOriginalColorMode(): number {
    console.log('getOriginalColorMode  ');
    let mode: number = sdk.Asset_GetOriginalColorMode(this.editor.timeline.id, this.uid);
    console.log(`mode= ${mode}`);
    return mode;
  }

  /**
   * 设置用户自定义数据
   *
   * @param key 自定义数据key，需要全局唯一
   * @param value key定义的值（当前只支持number类型）
   */
  public setUserData(key: string, value: number): void {
    console.log('setUserData: key ' + key + `, value ${value}`);
    sdk.Asset_SetUserData(this.editor.timeline.id, this.uid, key, value);
  }

  /**
   * 获取用户自定义数据
   *
   * @param key 自定义数据key，需要全局唯一
   * @return 返回key对应的值
   */
  public getUserData(key: string): number {
    console.log(`getUserData: key ${key}`);
    let value: number = sdk.Asset_GetUserData(this.editor.timeline.id, this.uid, key);
    return value;
  }

  /**
   * 获取水印艺术签名数据
   */
  /* instrument ignore next */
  public getEditDataShotSign(): string {
    // 水印编辑数据
    let editSign: string = '';
    HiLog.i(TAG, 'getEditDataShotSign sealVal ' + this.editor.editData);
    try {
      if (this.editor.editData.includes('FILTER_SHOT_ARTISTIC_TEXT')) {
        JSON.parse(this.editor.editData, (key: string, value: string) => {
          if (key == 'FILTER_SHOT_ARTISTIC_TEXT') {
            editSign = value;
            return;
          }
        })
      } else {
        return this.artText;
      }
    } catch (error) {
      HiLog.e(TAG, `getEditDataShotSign parse error: ${error}, code: ${error?.code}`);
    }
    HiLog.i(TAG, 'getEditDataShotSign: editSign ' + editSign);
    return typeof editSign === 'string' ? editSign.toString() : '';
  }

  /**
   * 更新水印艺术签名数据
   */
  // instrument ignore next
  public setEditDataShotSign(editSign: string) {
    // 水印编辑数据
    HiLog.i(TAG, 'setEditDataShotSign editSign ' + editSign);
    try {
      this.artText = editSign;
      this.editor.editData = JSON.stringify(JSON.parse(this.editor.editData,
        (key: string, value: Object | undefined | null): Object | undefined | null => {
          if (key == 'FILTER_SHOT_ARTISTIC_TEXT') {
            return editSign;
          }
          return value;
        }
      ));
    } catch (error) {
      HiLog.e(TAG, `setEditDataShotSign parse error: ${error}, code: ${error?.code}`);
    }
    HiLog.i(TAG, 'setEditDataShotSign: sealVal ' + this.editor.editData);
  }

  public setAutoFlush(autoFlush: boolean): number {
    console.log(`setAutoFlush: autoFlush ${autoFlush}`);
    let value: number = sdk.EditorContext_SetAutoFlush(this.editor.timeline.id, autoFlush);
    return value;
  }

  private rectTo(rect: CropVal2, func: (x: number) => number): boolean {
    if (rect?.code == undefined) {
      rect.left = func(rect.left);
      rect.top = func(rect.top);
      rect.right = func(rect.right);
      rect.bottom = func(rect.bottom);
      return true;
    }
    return false;
  }

  /**
   * 重置素材位置，恢复到默认translate和scale
   *
   * @param callback 返回重置后的裁剪框位置
   */
  resetPosition(callback: Function): void {
    console.log('Asset: resetPosition');
    sdk.Asset_resetPosition(this.editor.timeline.id, this.uid, callback);
  }

  /**
   * 手动开启自动刷新
   */
  SetEditorAutoFlush() {
    HiLog.i(TAG, 'Asset: SetEditorAutoFlush');
    sdk.Asset_SetEditorAutoFlush(this.editor.timeline.id, this.uid);
  }

  /**
   * 获取图片宽高
   */
  public getExportSize(callback: (width: number, height: number) => void): void {
    try {
      HiLog.i(TAG, 'Asset: getExportSize');
      sdk.Asset_GetExportSize(this.editor.timeline.id, this.uid, callback);
    } catch (err) {
      HiLog.e(TAG, `request previewWideAperture failed. :${err?.code}---${err}`);
    }
  }

  /**
   * 刷新水印
   *
   * @param callback  回调函数
   */
  public refreshSeal( callback: (jsonPos: string) => void): void {
  }

  /**
   * 将xtStyleParam的属性 添加到 水印中
   */
  public addXtStyleParamToWatermark(xtStyleTextParams: Array<string>, autoFlush = false,
    needInitCache: boolean = false): void {
    HiLog.i(TAG, `Asset: addXtStyleParamToWatermark, xtStyleTextParams = ${xtStyleTextParams} autoFlush ${autoFlush}`);
    sdk.Asset_AddXtStyleParamToWatermark(this.editor.timeline.id, this.uid,
      xtStyleTextParams, autoFlush, needInitCache);
  }

  /**
   * 一镜到底水印动画
   *
   * @param callback  回调函数
   */
  public DoSealAnimation(isShow: boolean): void {
    let animMs = isShow ? 100 : 200;
    sdk.Asset_DoWatermarkAnimation(this.editor.timeline.id, this.uid, isShow, animMs,
      (jsonPos: string) => {
        HiLog.i(TAG, 'DoSealAnimation animMs: ' + animMs + ` result: ${jsonPos}`);
      });
  }

  clearComposedCache() {
    this.exportPixelMap?.release();
    this.exportPixelMap = undefined;
    this.exportPixelMapPromise = undefined;
  }
}

export class LanAsset {
  public clipRatio: number = 0;
  public chooseRatio: string = '';
  public cropRectBottom: number = 0;
  public cropRectLeft: number = 0;
  public cropRectRight: number = 0;
  public cropRectTop: number = 0;
  public customText: string = '';
  public endTime: number = 0;
  public extraRotation: number = 0;
  public isAssetPosChange: boolean = false;
  public isMute: number = 0;
  public masterTape: number = 0;
  public mirror: number = 0;
  public originalBitRate: number = 0;
  public originalDuration: number = 0;
  public originalFps: number = 30;
  public originalHeight: number = 10;
  public originalWidth: number = 10;
  public path: string = '';
  public rotationX: number = 0;
  public rotationY: number = 0;
  public speed: number = 0;
  public startTime: number = 0;
  public trimIn: number = 0;
  public trimOut: number = 0;
  public uid: string = '';
  public adjust: AdjustItem[] = [];
  public isPreviewMode: boolean = false;
  public watermarkType: number = 0;
  public isContainShotParm: number = 0;
  public isContainShotDate: number = 0;
  public isContainColorParam: number = 0;
  public isContainLocationParam: number = 0;
  public frameBackground: number = 0;
  public frameColor: number = 0;
  public frameTextStr: string = '';
  public festivalParam: number = 0;
  public fNum: number = 16;
  public positionX: number = 0;
  public positionY: number = 0;
  public filterShotSign: string = '';
}
