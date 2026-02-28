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
import bundleManager from '@ohos.bundle.bundleManager';
import sdk from './native';
import { HiLog } from '../common/util/HiLog';
import { Trace } from '../common/util/Trace';
import window from '@ohos.window';
import { App, TabName } from './App';
import { UiUtil } from '../common/util/UiUtil';
import { GlobalThisUtil } from '../common/util/GlobalThisUtil';
import emitter from '@ohos.events.emitter';
import { Constants } from '../common/util/Constants';
import { HOT_SPOT_HEIGHT, HOT_SPOT_WIDTH, PREVIEW_HEIGHT_OFFSET } from '../common/const';
import { ScreenManager } from '../common/util/ScreenManager';
import { DeviceUtil } from '../common/util/DeviceUtil';
import display from '@ohos.display';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
const TAG: string = 'EditorSDK';
const PADDING_VAL: number = 8;

export interface FrameSize {
  top: number,
  bottom: number,
  left: number,
  right: number,
}

/**
 * EditorMain组件的消息回调
 */
export class EditorMsg {
  public static readonly MSG_ID_ON_EXIT: string = 'exit';
  public static readonly MSG_ID_ON_EXIT_DISCARD_MODIFICATION: string = 'exit_discard_modification';
  public static readonly MSG_ID_ON_FIRST_FRAME: string = 'first_frame';
  public static readonly MSG_ID_ON_FINISH_STYLUS: string = 'finish_stylus';
  public id: string;
  public extra?: Object;
  public isVdeFoldChanged?: boolean;
  public isOverride: boolean = true;

  constructor(id: string, extra?: Object) {
    this.id = id;
    this.extra = extra;
  }
}

/**
 * EditorMain组件的状态控制
 */
@Observed
export class EditorStatus {
  public isPreviewHidden: boolean = false; // 入场动画过程中需要预览隐藏，切换完成后再显示
  public startFadeoutAnim: boolean = false; // 控制开始进行出场动画
  public isInEmbedded: boolean = false; // 是否嵌入在动图编辑中
}

/**
 * EditorMain组件的初始化参数
 */
export class EditorParams {
  public static readonly MEDIA_TYPE_IMAGE: string = 'IMAGE';
  public static readonly MEDIA_TYPE_VIDEO: string = 'VIDEO';
  public static readonly PARAM_ENTRY_TYPE_STYLUS: string = 'stylus';
  public static readonly PARAM_ENTRY_TYPE_TEXTEDIT: string = 'textEdit';
  public static readonly PARAM_ENTRY_TYPE_MOSAIC: string = 'mosaic';
  public static readonly PARAM_ENTRY_TYPE_SEAL: string = 'seal';
  public static readonly PARAM_ENTRY_TYPE_AI: string = 'ai_edit';
  public static readonly PARAM_ENTRY_TYPE_XT_STYLE: string = 'xt_style';
  public static readonly PARAM_ENTRY_TYPE_DEFAULT: string = 'default';
  public uri: string = '';
  public mediaType: string = '';
  public thumbnail: string = '';
  public albumUri: string = '';
  public asset: photoAccessHelper.PhotoAsset | undefined = undefined;
  public position: number = 0;
  public rectInfo: RectValue = new RectValue(0, 0, 0, 0);
  /** 源界面裁剪框位置，从图片退出返回到源界面时做动效用 */
  public fromRectInfo: RectValue = new RectValue(0, 0, 0, 0);
  /** 打开进入的界面，default：进入默认编辑界面，stylus：直接进入涂鸦界面，ai_edit：直接AI修图界面 */
  public entryType: string = EditorParams.PARAM_ENTRY_TYPE_DEFAULT;
  // 从动态图跳转时，动态图当前处于的Tab
  public entryIndex: number = -1;
  public editData: string | undefined; //编辑数据
  public isFromPicker: boolean = false;
  public closeFinish: boolean = true;
}

/**
 * 编辑功能的全局SDK接口
 */
export class EditorSDK {
  public static sHasInitialized: boolean = false;

  /**
   * 初始化全局变量及加载native so
   *
   * @param abilityStageContext abilityStage的context
   * @param abilityContext ability的context
   * @param windowStage windowStage实例
   * @param moduleContext 被hsp集成时需要额外传入hsp对应的module context，以访问hsp中的rawfile资源
   */
  public static initialize(abilityStageContext: Context, abilityContext: Context, windowStage: window.WindowStage,
    moduleContext?: Context, mainWindow?: window.Window) {
    Trace.begin('EditorSDK initialize');
    if (EditorSDK.sHasInitialized) {
      HiLog.w(TAG, 'EditorSDK.sHasInitialized');
    }
    EditorSDK.sHasInitialized = false;
    HiLog.w(TAG, `initialize abilityStage=${abilityStageContext} abilityContext=${abilityContext},` +
      `windowStage=${windowStage} moduleContext=${moduleContext}`);
    if (!abilityStageContext || !abilityContext) {
      HiLog.e(TAG, 'initialize failed, parameter invalid');
      Trace.end('EditorSDK initialize');
      return;
    }
    EditorSDK.initNapiSdk();

    App.getInstance().init();
    GlobalThisUtil.setProperty('editor_abilityContext', abilityContext);
    GlobalThisUtil.setProperty('editor_stageContext', abilityStageContext);
    GlobalThisUtil.setProperty('editor_moduleContext', (moduleContext ? moduleContext : abilityStageContext));

    EditorSDK.sHasInitialized = true;
    HiLog.w(TAG, 'initialize finished');
    Trace.end('EditorSDK initialize');
  }

  public static initNapiSdk() {
    Trace.begin('EditorSDK getBundleInfoForSelf');
    let bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
    if (!bundleInfo) {
      HiLog.w(TAG, 'init native material without version.');
      sdk?.NAPIMaterial_InitEnv('');
      return;
    }
    Trace.end('EditorSDK getBundleInfoForSelf');
    HiLog.i(TAG, `init native material for version: ${bundleInfo.versionName}`);
    if (sdk) {
      sdk.NAPIMaterial_InitEnv(bundleInfo.versionName);
      HiLog.i(TAG, 'init native material finished');
      return;
    }
    HiLog.e(TAG, 'sdk is empty! try again later');
    let count = 0;
    let maxRetryNum = 5;
    let interval = 100;
    let index = setInterval(() => {
      count++;
      if (sdk) {
        sdk.NAPIMaterial_InitEnv(bundleInfo.versionName);
      }
      if (count == maxRetryNum || sdk) {
        clearInterval(index);
      }
      HiLog.i(TAG, `try init env: ${count}`);
    }, interval)
    HiLog.i(TAG, 'init native material finished');
  }

  /**
   * 通知用户进行back动作
   *
   * @returns true表示back事件被编辑业务消费，调用方不继续传递back事件
   */
  public static onBackPress(): boolean {
    // instrument ignore if
    if (!EditorSDK.sHasInitialized) {
      HiLog.e(TAG, 'onBackPress ignored, EditorSDK not initialized');
      return false;
    }
    let onBackPress = App.getInstance().instanceData().onBaseEditorBackPress;
    let onStylusBackPress = App.getInstance().instanceData().onStylusBackPress;
    let onAiEditorBackPress = App.getInstance().instanceData().onAiEditorBackPress;

    // 优先涂鸦界面响应返回手势
    if (onStylusBackPress) {
      HiLog.i(TAG, 'onStylusBackPress');
      return onStylusBackPress();
    }

    // 判断是否正在执行AI操作，增在执行时不能退出编辑
    if (onAiEditorBackPress) {
      HiLog.i(TAG, 'onAiEditorBackPress back handleBackPress return true');
      return true;
    }

    if (onBackPress) {
      HiLog.i(TAG, 'onBackPress');
      return onBackPress();
    }
    HiLog.e(TAG, 'onBackPress ignored, onBackPress and onStylusBackPress is not implemented');
    return false;
  }


  public static handleTermination(storage?: LocalStorage): boolean {
    // instrument ignore if
    if (!EditorSDK.sHasInitialized) {
      HiLog.e(TAG, 'handleTermination ignored, EditorSDK not initialized');
      return false;
    }

    if (App.getInstance(storage).myEditor().isEditorClosed) {
      HiLog.e(TAG, 'handleTermination ignored, currentWindow is not editorPage');
      return false;
    }

    HiLog.w(TAG, 'handleTermination');

    const editor = App.getInstance(storage).myEditor();
    const stopTerminating = editor.isEdited() || editor.stylusModifying;
    if (stopTerminating) {
      let innerEvent: emitter.InnerEvent = {
        eventId: Constants.PREPARE_TERMINATE_EVENT_ID,
      };
      emitter.emit(innerEvent);
    }
    return stopTerminating;
  }

  public static isAiEditorEnabled(): boolean {
    return false;
  }

  public static isSupportEffect(name: string): boolean {
    return App.getInstance().myEditor().isSupportEffect(name);
  }

  public static async selectEffects(params: ImageEffectChangeParams,
    cb: (msg: ImageEffectChangeMsg) => void): Promise<void> {
    Trace.begin('StaticEdit_SelectEffects_Enter');
    let callback: (succ: boolean) => void = (succ: boolean): void => {
      Trace.end('StaticEdit_SelectEffects_Enter');
      if (succ) {
        cb(new ImageEffectChangeMsg(ImageEffectChangeMsg.SUCCESS));
      } else {
        cb(new ImageEffectChangeMsg(ImageEffectChangeMsg.FAILED));
      }
    };
    await App.getInstance().myEditor().selectEffects(params, callback);
  }
}

export class ImageEffectState {
  public static readonly OPEN: number = 1;
  public static readonly CLOSE: number = 2;
}

export interface EffectValue {
  type: string,
  value: string
}

export interface EffectDetail {
  effectName: string | undefined;
  effectStatus: ImageEffectState | undefined;
  effectValues : EffectValue[] | undefined;
}

export interface ImageEffectChangeParams {
  effectDetails: EffectDetail[] | undefined;
  context: Context | undefined;
  asset: photoAccessHelper.PhotoAsset | undefined;
}

export class ImageEffectChangeMsg {
  public static readonly SUCCESS: number = 0;
  public static readonly FAILED: number = 1;
  public result: number;

  constructor(result: number) {
    this.result = result;
  }
}

@Observed
export class RectValue {
  public x: number;
  public y: number;
  public width: number;
  public height: number;

  constructor(x: number, y: number, width: number, height: number) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
}

export class WinSize {
  public width: number = 0;
  public height: number = 0;
}

/**
 * 提供编辑组件入场&出场的一镜到底动效能力接口
 */
export class SwitchAnimator {
  /**
   * 获取编辑页预览区域的rect位置
   *
   * @param winSize 应用当前窗口宽高，单位vp
   * @param ratio 素材的宽高比（宽/高）
   * @param mediaType 素材的类型（IMAGE:图片，VIDEO:视频）
   * @returns rect in px
   */
  public static getEditorPreviewRect(winSize: WinSize, ratio: number, mediaType: string, isRealPortrait?:
    boolean, stickerFilterName: string = '', editData: string = ''): RectValue {
    if (isRealPortrait === undefined) {
      ScreenManager.getInstance().onRotationChanged(ScreenManager.getInstance().isDisplayPortrait());
    }
    // instrument ignore if
    if (!EditorSDK.sHasInitialized) {
      HiLog.e(TAG, 'getEditorPreviewRect failed, EditorSDK not initialized');
      return new RectValue(0, 0, 0, 0);
    }
    let context = App.getInstance().instanceData().context;
    // instrument ignore if
    if (!context) {
      HiLog.e(TAG, 'getEditorPreviewRect failed, context is null');
      return new RectValue(0, 0, 0, 0);
    }

    let previewRect: RectValue = SwitchAnimator.getPreviewPosition(winSize, isRealPortrait);
    let mirrorOffsetx = vp2px(UiUtil.getPreviewRectOffset());
    previewRect.x += mirrorOffsetx;
    HiLog.i(TAG, `getEditorPreviewRect ${JSON.stringify(previewRect)}`);

    let width = previewRect.width;
    let height = previewRect.height;
    let left = previewRect.x;
    let top = previewRect.y;

    let cropWidth = width;
    let cropHeight = height;
    let frameSize: FrameSize = { top : 0, bottom : 0, left : 0, right : 0};
    if (ratio > width / height) {
      cropHeight = width / ratio;
    } else {
      cropWidth = height * ratio;
    }
    sdk?.Asset_CalculateFrameSize(cropWidth, cropHeight, stickerFilterName, editData, (jsonStr: string) => {
      HiLog.i(TAG, 'Asset_CalculateFrameSize:' + jsonStr);
      try {
        frameSize = JSON.parse(jsonStr) as FrameSize
      } catch (ignored) {
        frameSize = { top : 0, bottom : 0, left : 0, right : 0};
      }
    })

    HiLog.i(TAG, `cropHeight:${cropHeight} cropWidth:${cropWidth} ratio:${ratio} frameSize:${frameSize}`);
    if (ratio > width / height) {
      return new RectValue(left - frameSize.left, top + (height - cropHeight) / 2 - frameSize.top,
             width + frameSize.left + frameSize.right, cropHeight + frameSize.bottom + frameSize.top);
    }
    return new RectValue(left + (width - cropWidth) / 2 - frameSize.left, top - frameSize.top,
      cropWidth + frameSize.left + frameSize.right, height + frameSize.bottom + frameSize.top);
  }

  public static getPreviewPosition(winSize: WinSize, isRealPortrait?: boolean): RectValue {
    let isInTabCrop: boolean = true;
    if (App.getInstance().hasBaseEditorExist() && !App.getInstance().myEditor().isEditorClosed) {
      isInTabCrop = App.getInstance().myEditor().tabIndex === TabName.TabCrop;
    }

    // 在裁剪tab时，需要增加expandedHotspotsLength的padding
    let paddingLR: number = vp2px(DeviceUtil.isPc() ? 48 : HOT_SPOT_WIDTH);
    let paddingTB: number = vp2px(DeviceUtil.isPc() ? 48 : HOT_SPOT_HEIGHT);
    let isScreenPortrait = SwitchAnimator.isWindPortrait(isRealPortrait);

    // 首次从大图页进入时需要刷新规避区域
    if (!DeviceUtil.isPc()) {
      ScreenManager.getInstance().getStatusBarHeight();
    }
    let operationArea = UiUtil.getOperationArea(paddingLR, paddingTB, winSize, isScreenPortrait);
    let top = operationArea.top;
    let bottom = operationArea.bottom;
    // 左右规避区域适配
    let isRTL = ScreenManager.getInstance().isRTL();
    const avoidLeft = App.getInstance().screenClass.avoidLeft;
    const avoidRight = App.getInstance().screenClass.avoidRight;
    operationArea.right -= isRTL ? vp2px(avoidLeft + avoidRight) : vp2px(avoidRight);
    operationArea.left += isRTL ? 0 : vp2px(avoidLeft);
    let width = operationArea.right - operationArea.left;
    let height = bottom - top;
    HiLog.i(TAG, 'getEditorPreviewRect top ' + top + ` left ${operationArea.left}` + ' width ' + width + ' height ' +
      height + ' avoidRight:' + App.getInstance().screenClass.avoidRight +
      ' avoidLeft:' + App.getInstance().screenClass.avoidLeft);
    return new RectValue(operationArea.left, top, width, height);
  }

  private static isWindPortrait(isRealPortrait: boolean | undefined): boolean {
    try {
      // 图库首次进入一镜到底时ScreenManager属性尚未赋值，横屏状态恒为true，此处使用display获取横竖屏状态
      let orientation: display.Orientation = display.getDefaultDisplaySync().orientation;
      let windPortrait = orientation === display.Orientation.PORTRAIT ||
        orientation === display.Orientation.PORTRAIT_INVERTED;
      if (isRealPortrait != undefined) {
        windPortrait = isRealPortrait;
      } else {
        let winMode = ScreenManager.getInstance().isWindowMode();
        let splitMode = ScreenManager.getInstance().isSplitMode();
        let isDeviceFold = ScreenManager.getInstance().isDeviceFold();
        if (winMode || (splitMode && !isDeviceFold)) {
          windPortrait = true;
        }
        if (windPortrait && !ScreenManager.getInstance().isScreenPortrait()) {
          windPortrait = false;
        } else if (!windPortrait && ScreenManager.getInstance().isScreenPortrait()) {
          windPortrait = true;
        }
      }
      return windPortrait;
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      HiLog.e(TAG, `isWindPortrait error code is ${code}, message is ${message}`);
    }
    return false;
  }

  // 获取顶部偏移量，与startPreviewIfNeeded方法计算的坐标保持一致
  public static getTopOffset(isScreenPortrait: boolean): number {
    let topOffset = 0;
    // instrument ignore else
    if (!isScreenPortrait) {
      // instrument ignore else
      if (DeviceUtil.isPhone()) {
        topOffset = vp2px(PADDING_VAL);
      } else {
        topOffset = vp2px(PADDING_VAL + PREVIEW_HEIGHT_OFFSET / 2);
      }
    } else if (DeviceUtil.isPad()) {
      topOffset = vp2px(PADDING_VAL + PREVIEW_HEIGHT_OFFSET / 2);
    }
    return topOffset;
  }
}