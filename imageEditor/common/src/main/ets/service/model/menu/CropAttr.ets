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
import { Rectangle } from '../../../common/util/types';
import { MenuAttr } from './MenuAttr';
import sdk from '../../native';
import { NullUtil } from '../../../common/util/NullUtil';
import { Asset } from '../../Asset';
import { HiLog } from '../../../common/util/HiLog';
import { AdjustValueItem, BaseEditor } from '../../BaseEditor';
import { MenuChangeType, App } from '../../../service/App';
import { TabName } from '../Enum';
import { CropScaleClass } from '../../model/CropModel';
import { DeviceUtil } from '../../../common/util/DeviceUtil';
import { ButtonItem, ResourceTextItem, TextItem } from '../../../feature/basic/common/view/SelectableProgressButton';
import { ScreenManager, } from '../../../common/util/ScreenManager';
import { ScreenUtil } from '../../../common/util/ScreenUtil';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { TextInterval } from '../tabTextEdit/util/TextConst';
import { CropIndex } from '../../../common/const';
import {
  ApsUtil,
  APS_SCENE_STATE_ON,
  APS_SCENE_STATE_OFF,
  PHOTO_IN_EDIT_CROP,
  PHOTO_BUNDLE_NAME
} from '../../../common/util/ApsUtil';
import { JsonUtil } from '../../../common/util/JsonUtil';
import { Filter } from '../../BaseEditor';

let cropModeTimeFn: number | undefined = undefined; // 控制裁剪模式开启时间
let cropBlurTimeFn: number | undefined = undefined; // 控制高斯模糊开启时间
let sizerShowTimeFn: number | undefined = undefined; // 控制裁剪框开启时间
let pictureAnimationTimeFn: number | undefined = undefined; // 控制图片动画时间

export class CropVal2 {
  public code: string = '';
  public left: number = 0;
  public top: number = 0;
  public right: number = 0;
  public bottom: number = 0;
}

export class CropVal3 {
  public code: number = 0;
  public vibration: number = 0;
}


let TAG: string = 'CropAttr';

@Observed
export class CropAttr extends MenuAttr {
  public isResetCrop: boolean = false;
  public rotation: AdjustValueItem = new AdjustValueItem(0, false, 0); // 旋转角度
  public horizontalCorrection: AdjustValueItem = new AdjustValueItem(0, false, 0); // 水平校正
  public verticalCorrection: AdjustValueItem = new AdjustValueItem(0, false, 0); // 垂直校正
  public cropRect: Rectangle = new Rectangle(50, 150, 250, 550); // 裁剪框（白框）在UI坐标系下的位置
  public maxRect: Rectangle = new Rectangle(50, 150, 250, 550);
  public clipRatio: number = 0;
  public isCropSizeModified: boolean = false;
  public scale: number = 0;
  public mirrorFlag: number = 0; // mirrorFlag 镜像标志: 0-非镜像 1-镜像
  public mirrorType: number = 1; // mirrorType 0-垂直镜像 1-水平镜像
  public hasSplitLine: boolean = false; // 裁剪是否显示九宫格
  public enableRatio: boolean = false; // 是否跳转到比例页
  public ratio: string = '';
  public isRotateAndMirrorStatus: boolean = false; // 是否90度旋转和镜像反转动画状态  false 否 true 是
  public rotateNum: number = 0; // 记录当前第几次点击旋转
  public isMaskNeedChange: boolean = false; // 旋转、镜像时，蒙层不需要添加动画时延
  public isScrolling: boolean = false; // 是否正在拖动滚轮滚动
  public isClickUndoRedo: boolean = false;
  public redoCropItem: string = '';
  public isDragCrop: boolean = false; // 是否正在拖动裁剪框
  public cropMenuIndex: number = CropIndex.VERTICAL; // 比例功能的新索引
  public isEnableMask: boolean = true; // 旋转过程中隐藏蒙层，避免遮挡预览区
  public isEnableBlur: boolean = true;
  public correctionValue: number = 361;
  public cropTabs = [
    new ButtonItem($r('app.string.crop_intelligent_correction_imageEdit'),
      $r('app.media.intelligent_correction'), false, 'intelligentCorrection', -45, 45, 1),
    new ButtonItem($r('app.string.crop_horizontal_correction_imageEdit'),
      $r('sys.symbol.trapezoid_and_line_horizontal'), true, 'horizontalCorrection', -45, 45, 1, 2, 0, true, false),
    new ButtonItem($r('app.string.crop_vertical_correction_imageEdit'),
      $r('sys.symbol.trapezoid_and_line_vertical'), true, 'verticalCorrection', -45, 45, 1, 2, 0, true, false),
    new ButtonItem($r('app.string.crop_ratio_imageEdit'), $r('sys.symbol.aspect_ratio'), true, 'ratio', 0, 100, 1)
  ]
  public tabTexts = [
    new TextItem($r('app.string.tabs_crop_selected'), 'crop'),
    new TextItem($r('app.string.tabs_adjust_selected'), 'adjust'),
    new TextItem($r('app.string.tabs_xt_style_selected'), 'xtStyle'),
    new TextItem($r('app.string.tabs_filter_selected'), 'filter'),
    new TextItem($r('app.string.tabs_aperture_selected'), 'aperture'),
    new TextItem($r('app.string.tabs_watermark_selected'), 'watermark'),
  ]
  public cropTexts = [
    new TextItem($r('app.string.cropTab_intelligent_correction_on'), 'intelligentCorrection'),
    new TextItem($r('app.string.cropTab_horizontalCorrection_on'), 'horizontalCorrection'),
    new TextItem($r('app.string.cropTab_verticalCorrection_on'), 'verticalCorrection'),
    new TextItem($r('app.string.cropTab_ratio_on'), 'ratio')
  ]
  public cropScrollerTexts = [
    new TextItem((...params) => $r('app.string.voice_crop_rulerScroller_horizontalCorrection_imageEdit', ...params),
      'horizontalCorrection'),
    new TextItem((...params) => $r('app.string.voice_crop_rulerScroller_verticalCorrection_imageEdit', ...params),
      'verticalCorrection'),
  ]
  public cropAngleAdjustmentTexts = [
    new TextItem((...params) => $r('app.string.voice_crop_rulerScroller_horizontalCorrection_adjust', ...params),
      'horizontalCorrection'),
    new TextItem((...params) => $r('app.string.voice_crop_rulerScroller_verticalCorrection_adjust', ...params),
      'verticalCorrection'),
  ]
  public scaleDataList = [
    new CropScaleClass(-1, '-1', 0, $r('app.string.crop_original_imageEdit'), 'original'),
    new CropScaleClass(0, '0', 1, $r('app.string.crop_free_imageEdit'), 'free_ratio'),
    new CropScaleClass(-2, '-2', 2, $r('app.string.crop_pave_imageEdit'), 'pave_screen'),
    new CropScaleClass(1, '1:1', 3, '1:1', '1:1'),
    new CropScaleClass(3 / 2, '3:2', 4, '3:2', '3:2'),
    new CropScaleClass(2 / 3, '2:3', 5, '2:3', '2:3'),
    new CropScaleClass(4 / 3, '4:3', 6, '4:3', '4:3'),
    new CropScaleClass(3 / 4, '3:4', 7, '3:4', '3:4'),
    new CropScaleClass(9 / 16, '9:16', 8, '9:16', '9:16'),
    new CropScaleClass(16 / 9, '16:9', 9, '16:9', '16:9'),
  ]
  public scaleDataText = [
    new ResourceTextItem($r('app.string.cropTab_ratio_1_1_on'), $r('app.string.cropTab_ratio_1_1')),
    new ResourceTextItem($r('app.string.cropTab_ratio_3_2_on'), $r('app.string.cropTab_ratio_3_2')),
    new ResourceTextItem($r('app.string.cropTab_ratio_2_3_on'), $r('app.string.cropTab_ratio_2_3')),
    new ResourceTextItem($r('app.string.cropTab_ratio_4_3_on'), $r('app.string.cropTab_ratio_4_3')),
    new ResourceTextItem($r('app.string.cropTab_ratio_3_4_on'), $r('app.string.cropTab_ratio_3_4')),
    new ResourceTextItem($r('app.string.cropTab_ratio_9_16_on'), $r('app.string.cropTab_ratio_9_16')),
    new ResourceTextItem($r('app.string.cropTab_ratio_16_9_on'), $r('app.string.cropTab_ratio_16_9')),
  ];
  public videoScaleList = [
    new CropScaleClass(-1, '-1', 0, $r('app.string.crop_original_imageEdit'), 'original'),
    new CropScaleClass(0, '0', 1, $r('app.string.crop_free_imageEdit'), 'free_ratio'),
    new CropScaleClass(-2, '-2', 2, $r('app.string.crop_pave_imageEdit'), 'pave_screen'),
    new CropScaleClass(1, '1:1', 3, '1:1', '1:1'),
    new CropScaleClass(3 / 2, '3:2', 4, '3:2', '3:2'),
    new CropScaleClass(2 / 3, '2:3', 5, '2:3', '2:3'),
    new CropScaleClass(4 / 3, '4:3', 6, '4:3', '4:3'),
    new CropScaleClass(3 / 4, '3:4', 7, '3:4', '3:4'),
    new CropScaleClass(9 / 16, '9:16', 8, '9:16', '9:16'),
    new CropScaleClass(16 / 9, '16:9', 9, '16:9', '16:9'),
    new CropScaleClass(9 / 21, '9:21', 10, '9:21', '9:21'),
    new CropScaleClass(21 / 9, '21:9', 11, '21:9', '21:9')
  ];
  private animateTime: number = -1;

  constructor(editor: BaseEditor, asset: Asset) {
    super(editor, asset);
  }

  setPictureAnimationTime(ms: number) {
    clearTimeout(pictureAnimationTimeFn);
    this.asset.isPictureAnimation = true;
    pictureAnimationTimeFn = setTimeout((): void => {
      HiLog.i(TAG, 'pictureAnimationTimeFn');
      this.asset.isPictureAnimation = false;
    }, ms)
  }

  enterMenu(startSizeAnimation: boolean = true) {
    super.enterMenu();
    this.setPictureAnimationTime(300);
    if (this.editor.tabIndex === this.changeTabIndex && !ScreenManager.getInstance().isScreenPortrait()) {
      App.getInstance().screenClass.screenChangeType = MenuChangeType.NO_CROP_TO_CROP;
      clearTimeout(cropBlurTimeFn);
      cropBlurTimeFn = setTimeout((): void => {
        this.isEnableMask = true;
        this.isEnableBlur = true;
      }, 450)
      clearTimeout(cropModeTimeFn);
      cropModeTimeFn = setTimeout((): void => {
        this.setCropAreaEnable(false);
      }, 470)
      // 裁剪框延时500ms执行淡入
      clearTimeout(sizerShowTimeFn);
      sizerShowTimeFn = setTimeout((): void => {
        HiLog.i(TAG, 'sizerShowAnimation');
        this.asset.crops().sizerAnimation(true);
      }, 500)
    } else {
      clearTimeout(cropBlurTimeFn);
      cropBlurTimeFn = setTimeout((): void => {
        this.isEnableMask = true;
        this.isEnableBlur = true;
      }, 200)
      clearTimeout(cropModeTimeFn);
      cropModeTimeFn = setTimeout((): void => {
        HiLog.i(TAG, 'setCropAreaEnable');
        this.setCropAreaEnable(false);
      }, 220)
      if (startSizeAnimation) {
        // 裁剪框延时200ms执行淡入
        clearTimeout(sizerShowTimeFn);
        sizerShowTimeFn = setTimeout((): void => {
          HiLog.i(TAG, 'sizerShowAnimation');
          this.asset.crops().sizerAnimation(true);
        }, 200);
      }

      this.asset.switchCropMode();
    }
  }

  public sizerAnimation(isShown: boolean, callback?: () => void) {
    animateTo({
      duration: isShown ? 200 : 100, curve: Curve.Sharp, onFinish: callback,
    }, () => {
    });
  }

  leaveMenu(index: TabName) {
    this.setPictureAnimationTime(450);
    this.editor.interrupt && this.editor.setCropReactInterrupt();
    this.setCropAreaEnable(true);
    setTimeout(() => {
      this.isEnableMask = false;
      this.isEnableBlur = false;
    }, 200);
    if (index === this.changeTabIndex && !ScreenManager.getInstance().isScreenPortrait()) {
      App.getInstance().screenClass.screenChangeType = MenuChangeType.CROP_TO_NO_CROP;
    } else {
      clearTimeout(cropModeTimeFn);
      cropModeTimeFn = setTimeout((): void => {
        this.asset.switchPreviewMode();
      }, 180)
      this.asset.crops().sizerAnimation(false);
    }
  }

  animateShowSplitLine(isShow: boolean) {
    animateTo({
      duration: 100, // 动画时长
      playMode: PlayMode.Alternate, // 动画模式
    }, () => {
      this.hasSplitLine = isShow;
    })
  }

  public onDisappear(): void {
    clearTimeout(cropModeTimeFn);
    cropModeTimeFn = undefined;
    clearTimeout(cropBlurTimeFn);
    cropBlurTimeFn = undefined;
    clearTimeout(sizerShowTimeFn);
    sizerShowTimeFn = undefined;
    clearTimeout(pictureAnimationTimeFn);
    pictureAnimationTimeFn = undefined;
  }

  /**
   * 设置Asset镜像。
   *
   * @param mirrorFlag 镜像标志: 0-非镜像 1-镜像
   * @param mirrorType 0-垂直镜像 1-水平镜像
   */
  public setMirror(mirrorFlag: number, mirrorType: number): void {
    if (this.editor.isImageMove || this.asset.isTouching) {
      HiLog.i(TAG, 'setMirror when moving and touching');
      return;
    }
    clearTimeout(this.animateTime);
    if (this.isEnableMask) {
      this.setCropAreaEnable(true);
      this.animateTime = setTimeout((): void => {
        this.isEnableMask = false;
        this.isEnableBlur = false;
      }, 20)
    }
    this.mirrorFlag = mirrorFlag;
    this.isRotateAndMirrorStatus = true;
    HiLog.i(TAG, 'setMirror, open setApsSceneState begin.');
    ApsUtil.setApsSceneState(PHOTO_BUNDLE_NAME, PHOTO_IN_EDIT_CROP, APS_SCENE_STATE_ON);
    HiLog.i(TAG, 'setMirror, open setApsSceneState end.');
    clearTimeout(cropModeTimeFn);
    this.editor.timeline.timeProgressImmersiveMode = true;
    this.isScrolling = false;
    console.log('Asset: mirrorFlag ' + this.mirrorFlag + `mirrorType ${mirrorType}`);
    sdk.Asset_setMirror(this.editor.timeline.id, this.asset.uid, mirrorFlag, mirrorType, (ret: string) => {
      // 镜像动画结束
      if (ret) {
        this.isRotateAndMirrorStatus = false; // 控制裁剪框
        this.applyAnimate();
      }
      HiLog.i(TAG, 'setMirror, close setApsSceneState begin.');
      ApsUtil.setApsSceneState(PHOTO_BUNDLE_NAME, PHOTO_IN_EDIT_CROP, APS_SCENE_STATE_OFF);
      HiLog.i(TAG, 'setMirror, close setApsSceneState end.');
    });
  }

  public setRotation(cropName: string, rotation: number): void {
    let axis: number = -1;

    switch (cropName) {
      case 'intelligentCorrection':
        axis = 3;
        break;
      case 'rotation':
        axis = 2;
        break;
      case 'horizontalCorrection':
        axis = 1;
        break;
      case 'verticalCorrection':
        axis = 0;
        break;
      default:
        HiLog.e(TAG, 'unexpected axis');
        axis = -1;
    }
    HiLog.i(TAG, `Asset: setRotation rotation ${rotation} axis ${axis}`);
    sdk.Asset_setRotation(this.editor.timeline.id, this.asset.uid, rotation, axis);
  }

  public updateIsModify(): void {
    sdk.EditorContext_CalConfigChangeCallback(this.editor.timeline.id);
  }

  public setCropAreaEnable(isEnable: boolean) {
    HiLog.i(TAG, `setCropAreaEnable:${isEnable}, isExportFromBrowser:${this.editor.isExportFromBrowser}`);
    if (this.editor.isExportFromBrowser) {
      return;
    }
    sdk.Asset_SetCropAreaEnable(this.editor.timeline.id, this.asset.uid, isEnable);
  }

  private rotate90AcwBefore(timeout: number): void {
    clearTimeout(this.animateTime);
    if (DeviceUtil.isPhone() || this.editor.tabIndex === TabName.TabCrop) {
      if (this.isEnableMask) {
        this.setCropAreaEnable(true);
        this.animateTime = setTimeout((): void => {
          this.isEnableMask = false;
          this.isEnableBlur = false;
        }, timeout)
      }
    }
  }

  /**
   * 逆时针旋转90度
   */
  public rotate90Acw(): void {
    if (this.editor.isImageMove || this.asset.isTouching) {
      HiLog.i(TAG, 'rotate90Acw when moving and touching');
      return;
    }
    this.rotateNum = this.rotateNum + 1;
    HiLog.i(TAG, `rotate90Acw start ${this.rotateNum}`);
    performanceMonitor.begin('CUSTOM_ANIMATOR rotate90Acw', performanceMonitor?.ActionType.LAST_UP);
    // 旋转过程中隐藏蒙层不重复处理，避免预处理中异步处理造成状态交叉导致判断错误
    if (!this.isRotateAndMirrorStatus) {
      this.isRotateAndMirrorStatus = true;
      let freshRate = 1000 / ScreenUtil.getRefreshRate();
      this.rotate90AcwBefore(2 * freshRate);
    }

    this.editor.timeline.timeProgressImmersiveMode = true;
    this.isScrolling = false;
    if (this.scale > 0) {
      this.scale = 1 / this.scale;
    }
    this.clipRatio = (this.clipRatio === 0) ? 0 : 1 / this.clipRatio;
    HiLog.i(TAG, 'rotate90Acw, open setApsSceneState begin.');
    ApsUtil.setApsSceneState(PHOTO_BUNDLE_NAME, PHOTO_IN_EDIT_CROP, APS_SCENE_STATE_ON);
    HiLog.i(TAG, 'rotate90Acw, open setApsSceneState end.');
    sdk.Asset_rotate90Acw(this.editor.timeline.id, this.asset.uid, this.rotateNum, (ret: string) => {
      if (DeviceUtil.isPhone() || this.editor.tabIndex === TabName.TabCrop) {
        this.isEnableMask = true;
      }
      let json: Rectangle = JSON.parse(ret);
      if (NullUtil.isObjNull(json)) {
        HiLog.e('rotate90Acw', 'rotate90Acw json return is null.');
        HiLog.i(TAG, 'rotate90Acw, close setApsSceneState begin, json return is null.');
        ApsUtil.setApsSceneState(PHOTO_BUNDLE_NAME, PHOTO_IN_EDIT_CROP, APS_SCENE_STATE_OFF);
        HiLog.i(TAG, 'rotate90Acw, close setApsSceneState end, json return is null.');
        return;
      }

      // 区别手机端与PC端单位换算
      let last = new Rectangle(
        px2vp(json.left),
        px2vp(json.top),
        px2vp(json.right),
        px2vp(json.bottom)
      );
      this.cropRect.left = last.left;
      this.cropRect.top = last.top;
      this.cropRect.right = last.right;
      this.cropRect.bottom = last.bottom;
      this.isRotateAndMirrorStatus = false; // 控制是否显示裁剪框
      // instrument ignore if
      if (DeviceUtil.isPc() && this.editor.tabIndex != TabName.TabCrop) {
        HiLog.i(TAG, 'PC rotate 90 not in crop tab');
        this.editor.timeline.timeProgressImmersiveMode = false // 控制进度条
        return;
      }
      this.applyAnimate();
      performanceMonitor.end('CUSTOM_ANIMATOR rotate90Acw');
    });
  }

  public switchCropPage(pageId: number): void {
    sdk.Asset_SwitchCropPage(this.editor.timeline.id, this.asset.uid, pageId);
  }

  /**
   * 根据key获取对应属性
   *
   * @param key ButtonItem.key
   * @returns AdjustValueItem
   */
  getValueByKey(key: string): AdjustValueItem | null {
    switch (key) {
      case 'rotation':
        return this.rotation;
      case 'horizontalCorrection':
        return this.horizontalCorrection;
      case 'verticalCorrection':
        return this.verticalCorrection;
      default:
        return null;
    }
  }

  getInitCropRotation(editData: string) {
    let rotation = 0;
    try {
      const baseRotation =
        JsonUtil.getValueFromJson<number>(editData, 'extra_info.bridge_data.asset.base_rotation') ?? 0;
      const filters = JsonUtil.getValueFromJson<Array<Filter>>(editData, 'imageEffect.filters');
      const rotationZ: number = filters?.find(i => i?.name === 'HMCEFilter')?.values?.rotationZ ?? 0;
      rotation = rotationZ - baseRotation;
    } catch (e) {
      HiLog.e(TAG, `getInitCropRotation error: ${e?.code} ${e?.message}`);
    }
    HiLog.i(TAG, `getInitCropRotation=${rotation}`);
    return rotation;
  }

  /**
   * 90度旋转、镜像结束后渐显动画
   */
  private applyAnimate() {
    this.isEnableMask = true;
    this.isEnableBlur = true;
    clearTimeout(this.animateTime);
    this.animateTime = setTimeout((): void => {
      if (this.isRotateAndMirrorStatus) {
        HiLog.w(TAG, 'isRotateAndMirrorStatus skip applyAnimate.');
        return;
      }
      this.editor.timeline.timeProgressImmersiveMode = false // 控制进度条
      this.setCropAreaEnable(false);
      HiLog.i(TAG, 'applyAnimate, close setApsSceneState begin.');
      ApsUtil.setApsSceneState(PHOTO_BUNDLE_NAME, PHOTO_IN_EDIT_CROP, APS_SCENE_STATE_OFF);
      HiLog.i(TAG, 'applyAnimate, close setApsSceneState end.');
    }, 100)
  }

  public getExitRatio(): number | undefined {
    return this.cropRect.width() / this.cropRect.height();
  }
}
