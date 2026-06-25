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
import lazy { PCImageInfo } from './PCImageInfo';
import lazy window from '@ohos.window';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { AnimationParam, EventPipeline } from '@ohos/common/src/main/ets/default/model/browser/photo/EventPipeline';
import lazy {
  BigDataConstants,
  ReportToBigDataUtil
} from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy {
  Constants as BrowserConstants,
  FirstRotationDirection,
  EditType
} from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy {
  ColumnSize,
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
  WindowMode
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DateUtil } from '@ohos/common/src/main/ets/default/utils/DateUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { UserConstraintUtil } from '@ohos/common/src/main/ets/default/utils/UserConstraintUtil';
import lazy {
  MovingPhoto,
  PhotoAsset, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy { MultimodalInputManager } from '@ohos/common/src/main/ets/default/model/common/MultimodalInputManager';
import lazy { PhotoDataAdapter } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataAdapter';
import lazy { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import lazy { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';
import lazy { Thumbnail } from '@ohos/common/src/main/ets/default/model/browser/photo/Thumbnail';
import lazy { isFilterListEmpty } from '@ohos/common/src/main/ets/default/utils/ArrayUtil';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { UiUtil, VibrateType } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import lazy {
  AvPlayConstants,
  LoadProgressType,
  PlayType
} from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy Matrix4 from '@ohos.matrix4';
import lazy { LoadingPanel } from './LoadingPanel';
import lazy { PhotoPropertiesComponent } from './PhotoPropertiesComponent';
import lazy Curves from '@ohos.curves';
import lazy { VideoPlayer, VideoPlayerBigDataReport } from './VideoPlayer';
import lazy { Matrix4x4 } from '@ohos/common/src/main/ets/default/utils/Matrix4x4';
import lazy image from '@ohos.multimedia.image';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy display from '@ohos.display';
import lazy { CalcSubjectUtil } from '../utils/CalcSubjectUtil';
import lazy { PhotoScaleUtil } from '../utils/PhotoScaleUtil';
import lazy { PhotoRotateUtil } from '../utils/PhotoRotateUtil';
import lazy { FaceBeautyHelper } from '../utils/FaceBeautyHelper';
import lazy { BrowserCostReportManager } from '../utils/BrowserCostReportManager';
import lazy { FaceBeautyConstants } from '@ohos/common/src/main/ets/default/model/common/FaceBeautyConstants';
import lazy promptAction from '@ohos.promptAction';
import lazy { OcrCacheData } from './ImageAnalyzerOverlayAdapter';
import lazy { completed } from '@ohos/tools/src/main/interface/ArkUI';
import lazy { ScaleOpt } from '@ohos/tools/src/main/interface/PointData';
import lazy { ShortCut } from '@ohos/common/src/main/ets/default/model/ShortCut';
import lazy lockedScreenMgr from '@ohos/common/src/main/ets/default/utils/LockedScreen';
import lazy UDC from '@ohos.data.unifiedDataChannel';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { ImageModifier } from '@ohos.arkui.modifier';
import lazy Rsc from '@ohos/tools/src/main/global/RscString';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';
import lazy { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';
import lazy { AnalyzerUtil } from '@ohos/common/src/main/ets/default/utils/AnalyzerUtils';
import lazy { sendableImage } from '@kit.ImageKit';
import lazy { KeyCode } from '@kit.InputKit';
import lazy { VideoAnalyzerAdaptor } from '../controller/VideoAnalyzerAdaptor';
import lazy { RotateController } from '../controller/RotateController';
import lazy { PhotoItemImageModifier } from '../utils/CustomModifier';
import lazy { RequestQualityTask } from '@ohos/common/src/main/ets/default/task/RequestQualityTask';
import lazy { BrowserAnimController } from '@ohos/common/src/main/ets/default/model/BrowserAnimController';
import lazy ImageAdapterHelper from '../utils/ImageAdapterHelper';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { AssetHelper } from '@ohos/common/src/main/ets/default/utils/AssetHelper';

import lazy {
  ShortcutManager,
  ShortcutController
} from '../../../../../../browserCommon/src/main/ets/default/controller/ShortcutController';

import lazy { Scales } from '@ohos/common/src/main/ets/default/model/browser/photo/pipeline/variable';

import lazy GeometryIdManager from './GeometryIdManager';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy pointer from '@ohos.multimodalInput.pointer';
import lazy { ReplaceUriManager } from '@ohos/common/src/main/ets/default/model/ReplaceUriManager';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy performanceMonitor from '@ohos.arkui.performanceMonitor';
import lazy { IndexFocusOrder } from '@ohos/tools/src/main/variables/FocusCtrlManager';
import lazy { FoldUtil, FoldData } from '@ohos/common/src/main/ets/default/utils/FoldUtil';
import lazy { curves, LengthMetrics, Position, RectShape, UIContext } from '@kit.ArkUI';
import lazy { EditorPhotoContext, EditorStage } from '@ohos/common/src/main/ets/default/utils/EditorPhotoContext';
import lazy { PhotoPropertiesUtil } from '@ohos/common/src/main/ets/default/utils/PhotoPropertiesUtil';
import lazy {
  ImageToolConstants,
  ImageToolReportParams,
  EnterInnerPicWay
} from '@ohos/common/src/main/ets/default/model/common/ImageToolConstants';
import lazy { ImageToolInnerState } from './ImageToolInnerState';
import lazy { ImageToolBigDataReport } from '../utils/ImageToolReportManager'
import lazy { ApsUtil } from '@ohos/common/src/main/ets/default/utils/ApsUtil';
import lazy { FastPlayLabel } from './FastPlayLabel';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { PhotoItemVMFactory } from '../viewModel/base/PhotoItemVMFactory';
import lazy { PhotoItemVM } from '../viewModel/base/PhotoItemVM';
import lazy {
  PictureQualityConstants
} from '@ohos/common/src/main/ets/default/model/browser/photo/const/PictureQualityConstants';
import lazy { ImageDecodeUtils } from '@ohos/common/src/main/ets/default/model/browser/photo/ImageDecodeUtils';
import lazy { PhotoBrowserStateMachine } from '../viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { Throttle } from '@ohos/common/src/main/ets/default/utils/Throttle';
import lazy { ImageToolComponent } from './ImageToolComponent'
import lazy { PhotoBrowserExitAnimatingState } from '../viewModel/statemachine/PhotoBrowserExitAnimatingState';
import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';

import lazy { MediaLibraryData } from '../../../../../../common/src/main/ets/default/model/browser/photo/data/MediaData';
import lazy { RightClickMenu } from './RightClickMenu';
import lazy { ImageToolComponentVM } from '../viewModel/base/ImageToolComponentVM';
import lazy {
  EffectPhotoContext
} from '../../../../../../browserCommon/src/main/ets/default/utils/EffectPhotoContext';
const TAG: string = 'common_PhotoItem';

/**
 * divider固定宽度
 */
const DEFAULT_DIVIDER_WIDTH: number = 1;

/**
 * 除以 2 计算常数
 */
const HALF_DIVIDER: number = 2;

/**
 * 除以 4 计算常数
 */
const QUARTER_DIVIDER: number = 4;

/**
 * 点击事件移动阈值
 */
const distanceThreshold: number = 5;

/**
 * 最佳呈现,浅层交互一键美肤URI匿名化字符个数
 */
const ANONYMIZATION_COUNT: number = 9;

/**
 * 折叠屏展开态信息详情比例
 */
const FOLD_EXPANDED_PERCENTAGE: number = 0.5;

/**
 * 浅层交互loading边距
 */
const EDIT_LOADING_MARGIN: number = 40;

/**
 * loading尺寸
 */
const LOADING_SIZE: number = 24;

const ONE_HUNDRED: number = 100;

const PHOTO_SCALED: string = 'photo_scaled';

const FOCUS_COMMON_DELAY: number = 500;

const PAN_GESTURE_DISTANCE: number = 7;

const PAN_GESTURE_DISTANCE_DEFAULT: number = 5;

const DARK_BACK_GROUND_COLOR: string = '#000000';

const PLAY_BUTTON_SIZE: number = 24;

const UPDATE_OCR_BEAUTY_DURATION: number = 2000;

const SHADOW_COLOR: string = '#1A000000';

const IS_EDIT_SAVE: string = 'isEditSave';

const IS_THIRD_PICKER: string = 'isThirdPicker';

const PINCH_GESTURE: string = 'PINCH_GESTURE';

const DOUBLE_TAP: string = 'DOUBLE_TAP';

const PRELOAD_ORIGIN_MAX_SIZE: number = 4500;

interface UriMsg {
  uri: string;
  type: string;
}

interface OcrMsg {
  value: string;
  blocks: OcrBlocks[];
}

interface OcrBlocks {
  value: string;
  lines: OcrLines[];
}

interface OcrLines {
  value: string;
  words: OcrWords[];
  cornerPoints: ScaleOpt[];
}

interface OcrWords {
  value: string;
  cornerPoints: ScaleOpt[];
}

interface QualityMsg {
  quality: number;
}

class RectValue {
  public x: number = 0;
  public y: number = 0;
  public width: number = 0;
  public height: number = 0;
}

/* instrument ignore next */
@Concurrent
export async function doFaceBeauty(context: Context, photoAsset: PhotoAsset | undefined): Promise<boolean> {
  const isSuccess: boolean = await FaceBeautyHelper.setFaceBeauty(context, photoAsset);
  return isSuccess;
  // return false
}

/* instrument ignore next */
@Concurrent
export async function doCancelFaceBeauty(context: Context, photoAsset: PhotoAsset | undefined): Promise<boolean> {
  const isSuccess: boolean = await FaceBeautyHelper.cancelFaceBeauty(context, photoAsset);
  return isSuccess;
}

/**
 * 大图页图片控件
 */
@Component
export struct PhotoItem {
  @ObjectLink photoBrowserStateMachine: PhotoBrowserStateMachine;
  public browserAnimController: BrowserAnimController = new BrowserAnimController();
  /* instrument ignore next */
  @State private viewModel: PhotoItemVM = PhotoItemVMFactory.getPhotoItemVM(this.photoBrowserStateMachine);
  @LocalStorageLink('isDoingImmersiveAnimationPC') isDoingImmersiveAnimationPC: boolean = false;
  /* instrument ignore next */
  @LocalStorageLink('virtualKbKey') @Watch('isVirtualKbKeyPCChanged') virtualKbKeyPC: string = '';
  private isFromPCPhotoBrowserModule: boolean = false;
  /* instrument ignore next */
  @Prop @Watch('onIsDetailSelectedChanged') isDetailSelected: boolean;
  private replaceUriManager: ReplaceUriManager | undefined;
  /* instrument ignore next */
  @LocalStorageLink('lastUri') lastUri: string = '';
  /* instrument ignore next */
  @LocalStorageLink(BroadCastConstants.UPDATE_PICKER_IMAGE_DISPLAY_HEIGHT) pickerAreaRatio: number = 0;
  /* instrument ignore next */
  @LocalStorageLink('fastPixmap') fastPixmap: image.PixelMap | undefined = undefined;
  private albumInfo?: AlbumInfo;
  @State @Watch('onViewDataChanged') item: MediaItem = new MediaItem();
  @ObjectLink @Watch('onMediaResultChanged') mediaResult: MediaResult;
  @State @Watch('onMatrixChange') matrix: Matrix4.Matrix4Transit = Matrix4.identity().copy();
  private panOption: PanGestureOptions = new PanGestureOptions({
    direction: PanDirection.Vertical, distance: PAN_GESTURE_DISTANCE_DEFAULT,
  });
  private controllerTextArea: TextAreaController = new TextAreaController();
  private controllerTextInput: TextInputController = new TextInputController();
  private controllerPortraitInput: TextInputController = new TextInputController();
  private shortcutController: ShortcutController = ShortcutManager.getInstance();
  private swiperController?: SwiperController;
  private isNeedRightMenu: boolean = false;
  private isUserCreatedAlbum: boolean = false;
  /* instrument ignore next */
  private onPressEnter: Function = (): void => {
  };
  // 旋转与捏合共存 旋转开始 到 捏合结束的标志(不能单纯的用angle === 0,捏合的end在旋转的end之后)
  @State isInRotateState: boolean = false;
  // rotationAction 过程表示
  @State isInRotateAction: boolean = false;
  // 单次旋转 角度是否变化
  private isAngleChanged: boolean = false;
  // 旋转 最小触发手势角度适配
  private isFirstPositiveAngle: number = FirstRotationDirection.POSITIVE_ANGLE;
  /* instrument ignore next */
  @Prop private isVideoPlaying: boolean;
  @State private canShowRightMenu: boolean = false;
  /* instrument ignore next */
  @State curFoldStatus: number = FoldUtil.getInstance().getCurFoldStatus();
  /* instrument ignore next  */
  private foldDataChangeListener: (foldData: FoldData) => void = this.onFoldDataChange.bind(this);
  /* instrument ignore next  */
  private timer: number = -1;
  /* instrument ignore next  */
  private fastScrollModeTimer: number = -1;
  /* instrument ignore next */
  @Prop isPrivateHideState: boolean = false;
  /* instrument ignore next  */
  @StorageProp('change_background') @Watch('changeBackgroundStatus') isBackGround: boolean = false;
  /**
   * 视频显示封面状态
   */
  @State @Watch('isShowVideoChange') private isShowCoverPicture: boolean = true;
  /**
   * isThirdScene,第三方场景，例如：相机场景
   */
  private isThirdScene: boolean = true;

  /* instrument ignore next */
  private onFoldDataChange(foldData: FoldData) {
    this.curFoldStatus = foldData.curFoldStatus;
  }

  private isLargeImage(item: MediaItem | undefined) {
    if (!item) {
      /* instrument ignore next  */
      Log.info(TAG, `[checkOverSizeImage] item is null`);
      /* instrument ignore next  */
      return false;
    }
    const width: number = item?.imgOriginWidth ?? 0;
    const height: number = item?.imgOriginHeight ?? 0;
    const MAX_SIZE: number = PhotoDataAdapter.PHOTO_LARGE_IMAGE_SIZE * PhotoDataAdapter.PHOTO_LARGE_IMAGE_SIZE;
    Log.info(TAG, `[checkOverSizeImage] item overSize is ${width * height > MAX_SIZE}`);
    return width * height > MAX_SIZE;
  }
  /* instrument ignore next  */
  changeBackgroundStatus(): void {
    if (!this.mediaResult?.item?.uri) {
      Log.info(TAG, `[changeBackgroundStatus] return, mediaResult is null`);
      return;
    }
    Log.info(TAG, `[changeBackgroundStatus]`);
    if (!this.isLargeImage(this.mediaResult.item)) {
      Log.info(TAG, `[changeBackgroundStatus] return, uri: ${this.mediaResult.item.uri} is not large image`);
      return;
    }
    if (!this.isBackGround) {
      // 大图场景，从后台切回前台重新渲染该张图片
      if (this.mIsCurrent) {
        this.dataSource?.updatePixMapDataSource(this.viewModel.getCurrentIndex(), false);
        Log.info(TAG, `[changeBackgroundStatus] PhotoItem is onForeground`);
      }
    } else {
      // onChange事件释放超大图
      this.dataSource?.photoDataAdapter.clearCache();
      this.stringImageModifier.attribute?.visibility(Visibility.Visible);
      this.imageShowSourceOpacity = 0;
      this.pixmapImageModifier?.updateConstructorParams(ImageContent.EMPTY);
      this.imageShowPixMapSource?.release();
      this.imageShowPixMapSource = undefined;
      Log.info(TAG, `[changeBackgroundStatus] release current pixelmap ${JSON.stringify(this.mediaResult.item?.uri)}`);
    }
  }

  private onCurrentUriChange() {
    if (!this.mediaResult?.item?.uri) {
      /* instrument ignore next  */
      Log.info(TAG, `[onCurrentUriChange] return, mediaResult is null`);
      /* instrument ignore next  */
      return;
    }
    Log.info(TAG, `[onCurrentUriChange]`);
    if (!this.isLargeImage(this.mediaResult.item)) {
      Log.debug(TAG, `[onCurrentUriChange] return, uri: ${ImageUtil.encryptThumbnailUri(this.mediaResult.item.uri)} is not large image`);
      return;
    }
    if (!this.mIsCurrent) {
      this.stringImageModifier.attribute?.visibility(Visibility.Visible);
      this.imageShowSourceOpacity = 0;
      this.pixmapImageModifier?.updateConstructorParams(ImageContent.EMPTY);
      this.imageShowPixMapSource?.release();
      this.imageShowPixMapSource = undefined;
      Log.info(TAG, `[onCurrentUriChange] release current pixelmap ${JSON.stringify(this.mediaResult.item?.uri)}`);
    }
  }

  /**
   * 画中画布局相关变量
   */
  /* instrument ignore next */
  @State imageToolInnerState: ImageToolInnerState = new ImageToolInnerState();
  /**
   * 画中画ViewModel
   */
  @State imageToolVM: ImageToolComponentVM = new ImageToolComponentVM();
  /**
   * 画中画进入判断变量
   */
  @State @Watch('updateInnerPicInfo') enableEnterInnerPic: boolean = false;
  private enterInnerPicWay: EnterInnerPicWay = EnterInnerPicWay.PINCH;
  /**
   * 拍摄模式
   */
  private shootingMode: string = '';

  private updateAbleEnterInnerPic(): void {
    /* instrument ignore if */
    if (this.viewModel.disableEnterInnerPic()) {
      this.enableEnterInnerPic = false;
      return;
    }

    // media资源类型
    if (this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ||
    this.isMovingPhoto() || this.item.isGifOrWebpType()) {
      Log.info(TAG, 'media type not support innerPic');
      this.enableEnterInnerPic = false;
      return;
    }

    // 非多选模式且非沉浸式
    if (!this.isInSelectedMode && this.isShowBar) {
      Log.info(TAG, 'isShow & not selectMode not support innerPic');
      this.enableEnterInnerPic = false;
      return;
    }

    // 旋转过程中不支持画中画显示
    /* instrument ignore if */
    if (this.isInRotateAction) {
      Log.info(TAG, 'photo inRotate not support innerPic');
      this.enableEnterInnerPic = false;
      return;
    }
    // 多选模式 或 非多选且沉浸式

    // 全景照片（包含老的全景照片 和 5.1新增的百香果）：沉浸态浏览+放大
    if (this.imageToolVM.isPhotoAndDeviceSatisfy(this.viewModel)) {
      // 特殊比例图片：沉浸态浏览+放大
      if (!this.eventPipeline?.isPhotoScaled()) {
        Log.info(TAG,
          `photo with special aspect ratio, the scale is not larger than the default scale`);
        this.enableEnterInnerPic = false;
        return;
      }
    } else {
      // 其他照片：不做画中画
      Log.info(TAG, `not satisfy innerPhoto condition, not enter innerPhoto`);
      this.enableEnterInnerPic = false;
      return;
    }

    // 画中画进入条件
    // 1、沉浸式或者多选模式
    // 2.1、全景照片：沉浸态浏览 + 放大
    // 2.2、特殊比例图片：沉浸态浏览 + 放大
    this.enableEnterInnerPic = true;
  }

  /**
   * 多选态选择
   */

/* instrument ignore next */
  private isSelected: Function = (): boolean => {
    return false;
  };
  /* instrument ignore next */
  private selectStateChange: Function = (): void => {
  };
  // 摩尔纹图像
  private videoLcdPixelMap: string | image.PixelMap | undefined = undefined;
  /**
   * 广播，用于保存关键监听回调
   */
  /* instrument ignore next */
  @Link broadCast: BroadCast;
  /**
   * 图片可见属性
   */
  /* instrument ignore next */
  @State visible: Visibility = Visibility.Hidden;
  /**
   * 图片裁切属性
   */
  /* instrument ignore next */
  @State objectFit: ImageFit = ImageFit.Cover;
  /**
   * 图片缩略图 uri
   */
  @State @Watch('onShowImageChanged') thumbnail: Thumbnail = new Thumbnail();
  /**
   * 图片宽高比
   */
  @State ratio: number = 1.0;
  /**
   * 图片旋转角度
   */
  @State orientation: number = 0;
  /**
   * 图片是否发生解码错误
   */
  @State showError: boolean = false;
  /**
   * 图片 LCD 图是否更新
   */
  @State lcdPixelMapUpdate: boolean = false;
  /**
   * 图片原图 uri
   */
  @State src: string = this.item.uri;
  /**
   * 是否下拉拖动图片
   */
  @Consume @Watch('updatePipelinePullingDownStatus') isPullingDown: boolean;

  /**
   * 标记拉起大图页的页面来源
   */
  /* instrument ignore next */
  @Consume pageFrom: number;
  /* instrument ignore next */
  @Consume viewData: string;
  /**
   * 根据大图页来源确定movingPhoto组件拉起方
   */
  private movingPhotoPageFrom: number = Constants.ENTRY_FROM.NORMAL;
  /**
   * 是否退出大图浏览界面
   */
  @State isClickBackPress: boolean = false;
  /**
   * 大图旋转stack透明度
   */
  /* instrument ignore next */
  @State photoRotateStackOpacity: number = 1;
  /**
   * 图片在数据集中位置信息
   */
  @Provide mPosition: number = 0;
  /**
   * 是否为当前预览图片，需更新图片转场 transition index
   */
  @State @Watch('onTransitionChange') mIsCurrent: boolean = false;

  private imageKey: string = this.item?.uri;
  /**
   * Transition tag 信息
   */
  public transitionTag: string = '';
  /**
   * 图片正在加载中状态
   */
  @State isLoading: boolean = true;
  /**
   * 原图正在加载中状态
   */
  @State isOriginLoading: boolean = false;
  /**
   * 是否直接使用 pixelMap
   */
  /* instrument ignore next */
  @State usePixmap: boolean = false;
  @Provide listCardWidth: number = 0;
  /**
   * 图片放缩状态确认回调
   */
  /* instrument ignore next  */
  verifyPhotoScaled: (matrix: Matrix4.Matrix4Transit) => void = (matrix: Matrix4.Matrix4Transit): void => {
  };
  /**
   * 是否支持图片上滑
   */
  public canPullingUp: boolean = false;
  /**
   * 图片缩放系数，在下拉跟手动效中生效
   */
  @LocalStorageLink('geometryScale') @Watch('onGeometryScaleChange') geometryScale: number = 1;
  /**
   * 图片 x 轴方向位移，在下拉跟手动效中生效
   */
  @LocalStorageLink('geometryOffsetX') @Watch('onGeometryOffsetXChange') geometryOffsetX: number = 0;
  /**
   * 图片 y 轴方向位移，在下拉跟手动效中生效
   */
  /* instrument ignore next  */
  @LocalStorageLink('geometryOffsetY') @Watch('onGeometryOffsetYChange') geometryOffsetY: number = 0;
  @Link currentDeleteID: string;
  /**
   * 当前是否可以触发下拉跟手动画
   */
  @Link @Watch('onIsPullDownAndDragPhoto') isPullDownAndDragPhoto: boolean;
  /**
   * 标志当前是否正在执行切图东西哦啊
   */
  /* instrument ignore next  */
  @Prop isSwiperOffsetZero: Boolean = true;

  /* instrument ignore next  */
  @State imageTop: number = 0;
  /*
  * 是否是自由多窗
  * */
  /* instrument ignore next  */
  @StorageLink('windowPcmodeSwitchStatus') windowPcmodeSwitchStatus: boolean = false;
  /*
   * 窗口模式
   * */
  /* instrument ignore next  */
  @StorageLink('windowStatus') @Watch('onWindowStatusChange') windowStatus: number | undefined = undefined;

  private onWindowStatusChange(): void {
    Log.info(TAG, `onWindowStatusChange:${this.windowStatus}`);
  }

  /**
   * 标记当前屏幕是否是横屏状态
   */
  /* instrument ignore next  */
  @StorageLink('isHorizontal') @Watch('onRotationAngleChanged') isHorizontal: boolean =
    isOrientationHorizontal();
  /**
   * aiBar高度
   */
  /* instrument ignore next  */
  @StorageLink('navigationBarHeight') private navigationBarHeight: number = 0;
  /**
   * 标记当前图片是否被拉伸
   */
  @State isPhotoScaled: boolean = false;
  /**
   * 判断当前图片形状是否需要优先让宽度填满 image 组件
   */
  @State justifyWidth: boolean = true;
  /**
   * 图片宽度
   */
  @State imageWidth?: string = Constants.PERCENT_100;
  /**
   * 图片高度
   */
  @State imageHeight?: string = Constants.PERCENT_100;
  @State imageStackWidth?: string = Constants.PERCENT_100;
  @State imageStackHeight?: string = Constants.PERCENT_100;
  /* instrument ignore next  */
  @State isEdgeTop: boolean = true;
  /* instrument ignore next  */
  @State canScroll: boolean = true;
  /**
   * 判断当前是否正在执行一镜到底动效
   */
  /* instrument ignore next  */
  @Link @Watch('onIsRunningAnimation') isRunningAnimation: boolean;
  /**
   * 一镜到底动效配对 ID
   */
  @State geometryTransitionId: string = '';
  public geometryId: string = '';
  @State changTransitionId: boolean = true;
  /**
   * 一镜到底动效配对 ID，大图页查询结果
   */
  /* instrument ignore next  */
  @LocalStorageLink('geometryTransitionBrowserId') @Watch('onGeometryIdChange')
  public geometryTransitionBrowserId: string = '';
  @Consume @Watch('isShowVideoChange') isShowVideo: boolean;
  @StorageLink('isFullMode') private isFullMode: boolean = getScreen().isFullMode();
  private photoPropertiesComponentScrollY: number = 0;
  private skipCurrentPullUpAnimate: boolean = false;
  private lastUpdateTransition: number = -1;
  private propertiesDefaultWidth: number = 332;
  /**
   * 是否是pc相机场景拉起的大图
   */
  private isPcCameraPull: boolean = false;
  @State isEditor: boolean = false;
  /* instrument ignore next  */
  @State editorImageUri: string = '';
  private userId: number = -1;
  /**
   * 图片手势操作处理统一接口
   */
  private eventPipeline: EventPipeline | undefined = undefined;
  private animationOption?: AnimationParam;
  private animationEndMatrix?: Matrix4.Matrix4Transit;
  private imgScale: number = 1;
  private firstLoad: boolean = true;
  private scroller: Scroller = new Scroller();
  private albumUri: string = '';
  private currentAlbumUri = AppStorage.get<string>(Constants.KEY_OF_ALBUM_URI);
  private isThird: boolean = false;
  private isFromPickerMoireRotate: boolean = false;
  /**
   * 是否进大图动效未结束下划返回
   */
  @State slipBackEnd: boolean = false;
  /**
   * 是否pickerView化场景
   */
  private isFromPickerView: boolean = false;
  /**
   * 保存 onTouch 上一次上报的数据点，Y 坐标值
   */
  private lastTouchDownY: number = 0;
  /**
   * 保存 onTouch 上一次上报的数据点，X 坐标值
   */
  private lastTouchDownX: number = 0;
  /**
   * 判断是否处于选择模式
   */
  private isInSelectedMode: boolean = false;
  /**
   * 是否启用一镜到底动效
   */
  private geometryTransitionEnable: boolean = false;
  private panelTimer: number = Number.NaN;
  /**
   *  当前侧边栏宽度
   */
  /* instrument ignore next */
  @LocalStorageLink('sideBarWidth') sideBarWidth: number = 0;
  /* instrument ignore next */
  @LocalStorageLink('isShowSideBar') @Watch('isShowSideBarChanged') isShowSideBar: boolean = true;
  /* instrument ignore next */
  @Prop imageIndex: number = 0;
  /* instrument ignore next */
  @Prop currentIndex: number = 0;
  /* instrument ignore next */
  @Link imageList: PCImageInfo[];
  /* instrument ignore next */
  @Prop isPcPictureScene: boolean = false;
  //PC大图正在进出编辑动效中,进 true 出 false
  /* instrument ignore next */
  @LocalStorageLink('isPcShowingEditor') isPcShowingEditor: boolean = false;
  private fullComponentWidth: number | undefined = undefined;
  private fullComponentHeight: number | undefined = undefined;
  private isScrolling: boolean = false;
  private isFromFACard: boolean = false;
  /* instrument ignore next */
  @LocalStorageLink('previewStackHeight') previewStackHeight: number = 0;
  private isFullScreenKeyDown: boolean = false;
  /**
   * 大图页数据集，数据由媒体库查询得到
   */
  private dataSource: PhotoDataSource | undefined = undefined;
  private isDefaultFA: boolean = false;
  private onWinSizeChangedCallBack = (): void => this.onWinSizeChanged();
  /* instrument ignore next */
  @StorageLink('networkAvailable') @Watch('onNetworkAvailableChanged') networkAvailable: boolean = false;
  /* instrument ignore next */
  @Link @Watch('updateGeometryIdIfNeeded') isInAnimateToPosition: boolean;
  /* instrument ignore next */
  private animateToPositionFunc = (src: RectValue, dst: RectValue, duration: number, onAnimationFinished: Function,
    /* instrument ignore next  */
    showPreview: Function): void => this.animateToPosition(src, dst, duration, onAnimationFinished, showPreview);
  /* instrument ignore next  */
  private resetPositionFunc = (): void => this.resetPosition();
  /* instrument ignore next  */
  private resetMatrixFunc = (callBack: Function): void => this.resetMatrix(callBack);
  private onDataSizeChangedFunc: Function = (size: number): void => this.onDataSizeChanged(size);
  /**
   * 是否正在执行删除动效
   */
  /* instrument ignore next */
  @Link isDoingDeleteAnim: boolean;
  @Link @Watch('isDeleteAnimWatch') isLeftToRightAnim: boolean;
  /* instrument ignore next  */
  @State calcTouchOpacity: number = 0;
  public static readonly PULL_DOWN_ITEM_ANIM_DURATION: number = 100;
  public static readonly DELETE_PHOTO_ANIM_DURATION: number = 500;
  public static readonly DELETE_ALPHA_ANIM_DURATION: number = 150;

  @State private itemBlur: number = 0;
  /**
   * 大图上滑动效相关变量
   */
  @Link @Watch('onIsDoingImageSlideAnimation') isDoingImageSlideAnimation: boolean;
  private isDoingSlideUpAnimation: boolean = false;
  /* instrument ignore next  */
  @StorageLink('getFoldStatus') @Watch('foldStatusChange') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  /* instrument ignore next  */
  @StorageLink(Constants.FOLD_DISPLAY_MODE) @Watch('foldStatusChange') private foldDisplayMode:
    display.FoldDisplayMode =
    display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
  private imageSlideCurrentOffset: number = 0;
  private photoPropertiesCurrentOpacity: number = 0;
  private imageSlideCurrentScale: number = 1;
  private clipWidthCurrentPercentage: number = 1;
  private isTouchingPullUp: boolean = false;
  /* instrument ignore next  */
  @State isThirdJustifyWidth: boolean = false;
  @State imageTargetPullHeight: number = 0;
  /**
   * 图片是否解码完成
   */
  @State @Watch('onPhotoChanged') isComplete: boolean = false;
  /**
   * AI 组件相关变量，控制此时是否支持响应平移手势
   */
  /* instrument ignore next */
  @Link @Watch('onCanPanGestureResponse') canRespondPanGesture: boolean;
  /**
   * AI 组件相关变量，标志当前是否点击了 AI 组件气泡
   */
  /* instrument ignore next */
  @Link isTappingAiButton: boolean;
  /**
   * AI 组件相关变量，标志当前 isTappingAiButton 状态是否改变
   */
  /* instrument ignore next */
  @Link isTappingAiButtonChange: boolean;
  /**
   * AI 组件相关变量，标志当前是否显示了 AI Menu
   */
  /* instrument ignore next */
  @Link isMenuShow: boolean;
  /**
   * AI 组件相关变量，标志当前 isMenuShow 状态是否改变
   */
  /* instrument ignore next */
  @Link isMenuShowStatusChange: boolean;
  /**
   * AI 组件相关变量，标志当前是否在 AI 组件中选择文本
   */
  /* instrument ignore next */
  @Link hasSelectedText: boolean;
  /**
   * AI 组件相关变量，标志当前是否在 AI 组件中选择的文本是否有变化
   */
  /* instrument ignore next */
  @Link isSelectedTextChange: boolean;
  /**
   * AI 组件相关变量，标志当前拖动，多选文本
   */
  /* instrument ignore next */
  @Link isOnDragText: boolean;
  /**
   * ocr文字高亮相关
   */
  /* instrument ignore next */
  @Prop private curHiSearchWords: string = ''; // 当前全局搜索的词
  private curNewSearchWords: string = ''; // 当前搜索非胶囊词
  private curOcrSearchWords: string = ''; // 当前搜索胶囊词中包含ocr搜索域的词
  private highlightWords: string = ''; // 当前需要高亮的词
  /* instrument ignore next */
  @State private originOcrRect: RectValue[] = []; // 记录原始高亮框
  /* instrument ignore next */
  @State private highlightRect: RectValue[] = []; // 记录显示高亮框
  /* instrument ignore next */
  @State private hasHighlightRect: boolean = false;
  /* instrument ignore next */
  @State private dotScale: number = BrowserConstants.DOT_ORIGINAL_SCALE;
  /* instrument ignore next */
  @State private dotOpacity: number = 1;
  /**
   * 数据重载回调
   */
  private onDataReloadFunc: Function = (addCount: KeyEvent): void => this.onDataReload(addCount);
  /**
   * 图片恢复原图大小回调
   */
  private resetDefaultScaleFunc: Function = (): void => this.resetDefaultScale();
  private openClickDetailPullingUpAnimationFunc: Function = (uniqueId: string):
    void => this.openClickDetailPullingUpAnimation(uniqueId);
  private closeClickDetailPullingUpAnimationFunc: Function = (uri: string):
    void => this.closeClickDetailPullingUpAnimation(uri);
  private closeClickDetailByBackPressFun: Function = (): void => this.closeDetailPullingUp();
  private resetPhotoDefaultRotationFun: Function = (): void => this.resetphotoDefaultRotation();
  /* instrument ignore next  */
  private emitUpdateCardWidthFun: Function = (): void => this.emitUpdateCardWidth();
  private onWinModeChangedFunc: Function = (winMode: WindowMode): void => {
    this.viewModel.setIsOnlyShowProperties(getScreen().getDetailShow());
    this.viewModel.onWinModeChanged();
    this.imageTargetPullHeight = this.viewModel.imageSlideTargetOffset * this.viewModel.ratioOffset;
  };
  private clickBackPress: Function = (): void => {
    this.isClickBackPress = true
    /* instrument ignore if */
    if (this.isFromFACard && (this.angle % BrowserConstants.ROTATION_THREE_SIX_ZERO !== 0) &&
      !this.viewModel.isPropertiesShow()) {
      this.resetphotoDefaultRotation();
    }
    /* instrument ignore if */
    if (this.angle / BrowserConstants.ROTATION_NINETY % 2 !== 0 && !this.viewModel.isPropertiesShow()) {
      this.photoRotateStackOpacity = 0;
      this.resetphotoDefaultRotation();
    }
  };
  private playEnterAnimationSyncFunc: () => void = (): void => {
    Log.info(TAG, `playEnterAnimationAsyncFunc`)
    this.playEnterAnimationSync();
  };

  private playEnterEndAnimationSyncFunc: () => void = (): void => {
    Log.info(TAG, `playEnterEndAnimationSyncFunc ${this.imageShowPixMapSource} ${!this.isDoPixelMapOpacityAnimation} ${
      this.mPosition} ${this.ratio} ${this.endRatio}`);
    // 设置动画结束状态
    const endParams = this.browserAnimController?.getGridToBrowserAnimationParams();
    endParams.targetAspectRatio = this.endRatio;
    endParams.targetScale = { x: this.geometryScale, y: this.geometryScale };
    if (this.viewModel.isVideo()) {
      this.videoRatio = this.endRatio;
    } else {
      this.ratio = this.endRatio;
    }
    this.viewModel.videoButtonRowModifier?.updateVisibility(Visibility.Visible);
    this.viewModel.hideEnterAnimating();
    this.viewModel.playImageAnimationAsync(endParams, this.viewModel.getTargetIndex(), (index: number) => { }, () => { }, true, 0);
    // 由于进大图不会使用photoitem的原图做动画，因此需要增加每次lcd到原图的过渡动画
    if (this.imageShowPixMapSource && !this.isDoPixelMapOpacityAnimation) {
      this.stringImageModifier.attribute?.visibility(Visibility.Visible);
      this.imageShowSourceOpacity = 0;
      this.doPixelmapOpacityAnim();
    }
  };

  private playExitAnimationSyncFunc: () => void = (): void => {
    Log.info(TAG, `playExitAnimationAsyncFun`)
    this.playExitAnimationSync();
  };

  private playExitEndAnimationSyncFunc: () => void = (): void => {
    Log.info(TAG, `playExitEndAnimationSyncFunc`)
    performanceMonitor.end(this.browserAnimController.getExitAnimTraceName());
    this.viewModel.thumbImageStackModifier?.updateVisibility(Visibility.Hidden);
    this.viewModel.thumbImageColumnModifier?.updateVisibility(Visibility.Hidden);
  };

  handleValueChange(isShowCoverPicture: boolean, isForcePlayCast: boolean, isForcePlayCastChange?: boolean): void {
    this.isShowCoverPicture = isShowCoverPicture;
  }

  /**
   * 缓存图片缩放矩阵回调
   */
  /* instrument ignore next  */
  private saveScaleFunc: Function = (): void => this.saveScale();
 /* instrument ignore next  */
  @StorageLink('isVideoDownloading') isVideoDownloading: boolean = false;
  /* instrument ignore next  */
  @StorageLink('isDownloadingInterrupt') isDownloadingInterrupt: boolean = false;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private eventPipelineSizeChangeFunc?: Function;
  @Link currentImageWidth: number;
  @State private currentImageHeight: number = 0;
  public static displayImageWidth: number = 0;
  public static displayImageHeight: number = 0;
  //是否是视频播放滑动条触发平移手势，改为逐帧播放后，删除此变量
  /* instrument ignore next  */
  @Provide isProgressOnPanGesture: boolean = false;
  private thumbnailLoadedFunc: Function = (thumbnail: Thumbnail): void => this.onThumbnailLoaded(thumbnail);
  private mediaPosition: photoAccessHelper.PositionType = photoAccessHelper.PositionType.LOCAL;
  private aiDataPrepareTimer: number = 0;
  /* instrument ignore next  */
  @StorageLink('doSkinSmoothing') @Watch('onDoFaceBeauty') private doFaceSmooth: string = '0';
  @State dynamicRange: DynamicRangeMode = DynamicRangeMode.HIGH;
  /* instrument ignore next  */
  @State bright: number = 1.0;
  /* instrument ignore next  */
  @State beginBright: number = 0.0;
  /* instrument ignore next  */
  @State endBright: number = 1.0;
  /**
   * 上次的缩略图数据
   */
  private lastThumbnail: Thumbnail = new Thumbnail();
  /**
   * 大图是否全屏预览显示
   */
  @State @Watch('onBrowserFullShow') isBrowserFullShow: boolean = true;
  /**
   * 浅层交互是否处理结束
   */
  /* instrument ignore next  */
  @State isFastEditProcessing: boolean = false;
  /**
   * 浅层交互Loading在屏幕中的位置
   */
  private fastEditProcessingPosition: number[] = [];
  /**
   * 浅层交互是否弹出toast
   */
  private promptActionShow: boolean = true;
  private isClickRemoveOrHiddenDialog: boolean = false;
  private isClickRemoveOrHiddenDialogFunc: Function = (isClickRemoveOrHiddenDialog: boolean): void => {
    this.isClickRemoveOrHiddenDialog = isClickRemoveOrHiddenDialog;
  }
  private onLargePhotoComplete?: Function;

 /* instrument ignore next  */
  @State private shareIsShowPlayButton: boolean = true;
  private shareIsShowPlayButtonFunc: Function = (shareIsShowPlayButton: boolean): void => {
    /* instrument ignore next  */
    this.shareIsShowPlayButton = shareIsShowPlayButton;
  }

  setImageLoading(status: boolean): void {
    if (this.item.uri === EffectPhotoContext.getInstance().getUri()) {
      this.isOriginLoading = status;
    }
  }

  /* instrument ignore next */
  private replaceUriFunc: Function = (oriUri: string, replaceUri: string): void => {
    if (!this.isThird || this.item.uri !== oriUri) {
      return;
    }
    this.imageShowStringSource = replaceUri;
    this.isEditor = true;
    this.editorImageUri = replaceUri;
    this.ratio = ImageUtil
      .calcRatio({
        width: this.replaceUriManager?.getReplaceMediaItem(this.item)?.width ?? this.item.width,
        height: this.replaceUriManager?.getReplaceMediaItem(this.item)?.height ?? this.item.height,
      } as image.Size);
    if (this.isThird) {
      let areaRatio: number = ImageUtil.calcRatio({
        width: this.imageComponentWidth || 0,
        height: this.imageComponentHeight || 0
      } as image.Size);
      this.isThirdJustifyWidth = this.ratio > areaRatio;
    }
    if (this.item.mediaType !== UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.stringImageModifier.attribute?.visibility(Visibility.Visible);
      this.pixmapImageModifier.attribute?.visibility(Visibility.Hidden);
    }
  }

  //【视频】播放组件宽高
  @State private xComponentWidth: number = 0;
  @State private xComponentHeight: number = 0;
  //【视频】真实宽高
  @State private videoRealWidth: number = 0;
  @State private videoRealHeight: number = 0;
  //【视频】宽高比
  @State @Watch('onVideoRatioChanged') videoRatio: number = -1;
  //【视频】是否是支持的视频格式
  private isSupportedVideoType: boolean = true;
  //【视频】广播回调
  /* instrument ignore next  */
  private setIsSupportedVideoTypeFunc: Function = (isSupportedVideoType: boolean, src: string):
    void => this.setIsSupportedVideoType(isSupportedVideoType, src);
  private setImageSizeWhenZeroFunc: Function = (src: string, imageWidth: number, imageHeight: number):
    void => this.setImageSizeWhenZero(src, imageWidth, imageHeight);
  private setVideoRatioFunc: Function = (ratio: number, uri: string): void => this.setVideoRatio(ratio, uri);
  /* instrument ignore next  */
  private setXComponentSizeFunc: Function = (xComponentWidth: number, xComponentHeight: number, src: string): void => {
    this.setXComponentSize(xComponentWidth, xComponentHeight, src);
  }
  private setVideoRealSizeFunc: Function = (videoRealWidth: number, videoRealHeight: number, uri: string): void => {
    this.setVideoRealSize(videoRealWidth, videoRealHeight, uri);
  }
  //【视频】时长
  @State private videoDuration: number = 0;
  private itemBlurChangeFunc: Function = (): void => this.itemBlurChange();
  private costReportManager: BrowserCostReportManager = BrowserCostReportManager.getInstance();
  /* instrument ignore next */
  private downloadOriginPhotoResultFunc: Function =
 /* instrument ignore next  */
    (result: String, err: string): void => this.downloadOriginPhotoResult(result, err);
  private changeLoadingStatusFunc: Function = (status: boolean): void => this.changeLoadingStatus(status);
  private setImageLoadingFunc: Function = (status: boolean): void => this.setImageLoading(status);
  private dataHandler: photoAccessHelper.QuickImageDataHandler<image.Picture> | null = null;
  /* instrument ignore next  */
  private loadYuvPixelMapFunc: Function = async (pixelMap: PixelMap): Promise<void> => this.loadYuvPixelMap(pixelMap);
  /**
   * 大图image控件创建添加定时器维测
   */
  private imageOnCompleteTimer: number = -1;
  private timerDuration: number = 3000;
  // image组件完成渲染后的宽高
  private imageCompleteWidth: number | undefined = 0;
  private imageCompleteHeight: number | undefined = 0;
  private firstLookRatio: number = 1;
  private firstLookWidth: number = 0;
  private firstLookHeight: number = 0;
  // 旋转按钮
  @State private rotateButtonOffsetX: number = 0;
  @State private rotateButtonOffsetY: number = 0;
  // 视频长按显示加速label
  @State private isShowFastPlayLabel: boolean = false;
  private showFastPlayLabelFunc: Function = (show: boolean): void => {
    this.isShowFastPlayLabel = show;
  }
  // 双击缩放的动效曲线
  private doubleTapCurves = Curves.interpolatingSpring(0, 1, 228, 30);
  private pinchAnimationCurves = Curves.interpolatingSpring(0, 1, 480, 41);
  /* instrument ignore next  */
  @Link isPreviewListScrolling: boolean;
  /* instrument ignore next  */
  @StorageLink('statusBarHeight') @Watch('onStatusBarHeightChange') statusBarHeight: number = 0;
  // loading偏移量
  @State private isRequestOriginLoading: boolean = false;
  @State private isPhotoChangeLoading: boolean = false;
  private loadingDeviceOffsetX: number = -(this.viewModel.windowLayoutWidth / HALF_DIVIDER);
  private loadingDeviceOffsetY: number = -(this.viewModel.windowLayoutHeight / HALF_DIVIDER);
  @State private loadingOffsetX: number = this.loadingDeviceOffsetX;
  @State private loadingOffsetY: number = this.loadingDeviceOffsetY;
  private loadingOriginOffsetX: number = this.loadingDeviceOffsetX;
  private loadingOriginOffsetY: number = this.loadingDeviceOffsetY;
  private currentWidth: number = 0;
  private currentHeight: number = 0;
  private realLoadingOffsetX: number = 0;
  private realLoadingOffsetY: number = 0;
  private defaultScale: number = 1.0;
  /* instrument ignore next  */
  @Link @Watch('onShowChanged') isShowBar: boolean;
  /* instrument ignore next  */
  private onVideoPlayButtonClickFunc: Function = (): void => this.onVideoPlayButtonClick();
  /* instrument ignore next  */
  @State private isInDragMode: boolean = false;

  private isInDragPreviewArea: boolean = true;
  /* instrument ignore next  */
  @State private inDragDismissAnimShow: boolean = false;
  /* instrument ignore next  */
  private movingPhotoOnCompleteFunc: Function = (uri: string): void => {
    this.movingPhotoOnComplete(uri);
  };
  /* instrument ignore next  */
  private isGestureMove: boolean = false;
  private imageComponentHeight: number = 0;
  private imageComponentWidth: number = 0;
  /* instrument ignore next  */
  @Prop private pageStatus: boolean = false;
  @State private imageShowSource: string | sendableImage.PixelMap | image.PixelMap | undefined = '';
  // 去摩尔纹图
  @State private removeMoirePixelMap: image.PixelMap | undefined = undefined;
  @State private imageStringSourceOpacity: number = 1;
  /* instrument ignore next */
  @State private imageShowSourceOpacity: number = this.isFromFACard ? 1 : 0;
  /* instrument ignore next */
  private isDoPixelMapOpacityAnimation: boolean = false;
  /* instrument ignore next */
  @State private imageShowStringSource: string | undefined = undefined;
  /* instrument ignore next */
  private imageShowPixMapSource: image.PixelMap | undefined = undefined;
  /* instrument ignore next */
  @State isStackModifierChange: boolean = false;
  /* instrument ignore next */
  private pixmapImageModifier: PhotoItemImageModifier = new PhotoItemImageModifier();
  /* instrument ignore next */
  private stringImageModifier: PhotoItemImageModifier = new PhotoItemImageModifier();
  private isShowFastPixmap: boolean = false;
  private isShowPlayButton: boolean = false;
  @Link private videoCoverFrame: PixelMap[];
  /* instrument ignore next  */
  @Prop private isFrameExpand: boolean = false;
  /* instrument ignore next  */
  @Prop private isVideoToEnd: boolean = false;
  /* instrument ignore next  */
  @StorageLink('isShowPhotoSearchPage') isShowPhotoSearchPage: boolean = false;
  /**
   * 逐帧播放：视频未播放时点击展开后开始自动播放
   */

  // 捏合结束回弹动效中屏蔽捏合手势
  private isRunningPinchAnimation = false;
  private isRunningPanAnimation = false;
  // 在捏合手势中
  private isInPinch = false;
  @State private isFirstClickPlay: boolean = true;
  /**
   * 双指旋转相关
   * angle：双指旋转过程中叠加角度
   * rotateValue:最终旋转角度
   */
  @State angle: number = 0;
  @State rotateValue: number = 0;
  /* instrument ignore next */
  private handlePauseClickFunc: Function = (): void => {
    /* instrument ignore next  */
    this.handlePauseClick();
  };
  /* instrument ignore next */
  private editorBackPhotoItemFunc: Function = (): void => {
    this.editorBackPhotoItem();
  }

  /* instrument ignore next */
  private updateCastMPosition: Function = (): void => {
    this.appBroadCast.emit(BroadCastConstants.CAST_POSITION_CHANGED + this.item.uri, [this.mPosition]);
  }
  private isController: boolean = true;
  /* instrument ignore next */
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;
  @StorageLink(Constants.APP_STORAGE_KEY_DOWNLOAD_PROGRESS) @Watch('onDownloadProgressChange') downloadProgress:
    number = 0;
  @StorageLink('isDownloading') isDownloading: boolean = false;
  /* instrument ignore next */
  private onPhotoSingleClick: Function = (): void => {
  };
  private isUseImageCache: boolean = false;
  //宫格进大图LCD图ai使能延长时间,单图片适配后可以删除
  @State private aiDelay: boolean = true;
  private aiDelayId: number = 0;
  private isInBackPressEvent = false;
  private isEditorBack: boolean = false;
  private isMultiPick: boolean = false;
  private isHighQualityFirst: boolean = true;
  /* instrument ignore next */
  @State private pickerBrowserInDragOrBackPress: boolean = false;
  private readonly notifyThrottle: Throttle<void> = new Throttle<void>(UPDATE_OCR_BEAUTY_DURATION, TAG);
  private browserActiveCallback: Function = this.onPhotoBrowserActive.bind(this);
  /* instrument ignore next */
  @State private isEditSaveReload: boolean = false;
  @State isPixMapSourceReady: boolean = false;
  /* instrument ignore next */
  @LocalStorageLink('isOpenBrowser') @Watch('isOpenBrowserChange') isOpenBrowser: boolean = false;
  /* instrument ignore next */
  @State private imageBackgroundColor: ResourceColor = 'none';
  private startImageOnCompleteTimerId: number = -1;

  isOpenBrowserChange(): void {
    if (this.isOpenBrowser) {
      /* instrument ignore next */
      this.imageBackgroundColor = 'none';
    } else {
      this.getImageBackgroundColor();
    }
  }
  // 动态图片长按播放状态
  private isMovingPhotoLongPressOn: boolean = false;
  private isMovingPhotoLongPressOnFunc: Function = (isMovingPhotoLongPressOn: boolean): void => {
    Log.info(TAG, `isMovingPhotoLongPressOn ${isMovingPhotoLongPressOn}`);
    this.isMovingPhotoLongPressOn = isMovingPhotoLongPressOn;
  }


  // 原图的aspectRatio做一个记录，一镜到底动画需要使用
  private endRatio: number = 1;

  private onPhotoBrowserActive(isActive: boolean, transition: string): void {
    Log.info(TAG, `onPhotoBrowserActive ${isActive} ${transition}`);
    if (transition === Constants.PHOTO_TRANSITION_EDIT) {
      /* instrument ignore next */
      this.isEditSaveReload = isActive;
    }
  }

  /* instrument ignore next */
  private changeMoreMenuList: Function = () => {
  };

  private setPickerBrowserInDragOrBackPress(inDragOrBackPress: boolean): void {
    if (this.isThird && !this.isFromPickerView && this.pickerBrowserInDragOrBackPress !== inDragOrBackPress) {
      /* instrument ignore next */
      this.pickerBrowserInDragOrBackPress = inDragOrBackPress;
      /* instrument ignore next */
      Log.info(TAG, `setPickerBrowserInDragOrBackPress: ${this.pickerBrowserInDragOrBackPress}`);
    }
  }

  private geoIdMgr: GeometryIdManager = {
    canSetNewId: () => {
      Log.info(TAG, 'canSetNewId');
      return true;
    }
  }
  private isDelayRegisterUriBroadcast: boolean = false;

  // 云图放大时下载进度
  /* instrument ignore next */
  onDownloadProgressChange(): void {
    Log.info(TAG, `download dialog progress update: ${this.downloadProgress}`);
  }

  /**
   * 根据设备和图片来源确定不透明度值
   */
  private isShouldBeOpaque(): boolean {
    if (PhotoConfig.isLibrary()) {
      return true;
    } else if (this.isFromFACard) {
      return true;
    }
    return false;
  }

  /* instrument ignore next */
  private isSlideBarVisibility(isFromViewData?: boolean, isVideoPlay?: boolean, isSlideBarHover?: boolean): boolean {
    if (isSlideBarHover) {
      return true;
    }
    let totalCount = this.dataSource?.totalCount() ?? 0;
    return this.isShowBar && !this.isEditor && !this.isInSelectedMode && !isFromViewData &&
      (totalCount > 1 || this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO);
    return false;
  }

  private backPressEventFunc: Function =
    (isLoadLCD: boolean = false, index?: number, browserControllerId?: number): void => {
    Log.info(TAG, `getStateMachine BrowserControllerId: ${this.viewModel.getStateMachine()?.getBrowserControllerId()
      } browserControllerId: ${browserControllerId}`);
    if (this.viewModel.getStateMachine()?.getBrowserControllerId() !== browserControllerId &&
      browserControllerId !== undefined) {
      return;
    }
    this.viewModel.getStateMachine()?.processBackEndEvent();
    this.setPickerBrowserInDragOrBackPress(true);
    this.isInBackPressEvent = true;
    this.enableEnterInnerPic = false;
    this.viewModel.videoButtonRowModifier?.updateVisibility(Visibility.Hidden);
    let astcUri = isLoadLCD && (index == this.mPosition) ?
    ImageUtil.getLCDUri(this.item.uri, this.item.path, this.item.getDateModified?.()) :
    ImageUtil.getThumbnailAstcUri(this.item.uri, this.item.path, this.item.getDateModified?.());
    if (this.isEditor) {
      /* instrument ignore next */
      let mediaItem = this.replaceUriManager?.getReplaceMediaItem(this.mediaResult.item)
      /* instrument ignore next */
      astcUri = mediaItem?.uri ?? ''
    }
    if (this.userId > 0) {
      /* instrument ignore next */
      astcUri += (astcUri.includes('?') ? '&' : '?') + 'user=' + this.userId;
    }
    this.imageShowStringSource = astcUri;
    Log.info(TAG, `imageShowStringSource: ${this.imageShowStringSource}`);
    if (ImageUtil.isExitTransparentChannelImgMimeType(this.item)) {
      /* instrument ignore next */
      Log.info(TAG, 'png luminance is change');
      /* instrument ignore next */
      return;
    }

    Log.info(TAG, `imageShowPixMapSource: ${this.imageShowPixMapSource}`);
    if (!this.browserAnimController?.isTransitionEnable && this.imageShowPixMapSource) {
      this.stringImageModifier.attribute?.visibility(Visibility.Hidden);
    } else {
      this.stringImageModifier.attribute?.visibility(Visibility.Visible);
    }
    this.pixmapImageModifier.attribute?.visibility(Visibility.Hidden);
    /* instrument ignore next */
    animateTo({
      duration: 0,
    },
      /* instrument ignore next */
      (): void => {
        this.imageShowSourceOpacity = 1;
      })
  }
  // 进入大图动效复用时，重置url参数 
  /* instrument ignore next */
  private recoverImageShowSourceFunc: Function = (): void => {
    this.isPullingDown = false;
    this.isInBackPressEvent = false;
    this.imageShowStringSource = this.getActualStringImage();
    this.resetInPhotoScaleGeometry();
    if (ImageUtil.isExitTransparentChannelImgMimeType(this.item)) {
      /* instrument ignore next */
      return;
    }
    this.pixmapImageModifier.attribute?.visibility(Visibility.Visible);
    this.photoRotateStackOpacity = 1;
  };

  // 进大图动效打断做下划和缩放，重置参数 
  /* instrument ignore next */
  private resetInPhotoScaleGeometry(): void {
    Log.info(TAG, 'resetInPhotoScaleGeometry start');
    if (this.browserAnimController.isTransitionEnable) {
      UiUtil.resetGeometryTransitionParams();
    }
    this.isPhotoScaled = false;
    this.matrix = Matrix4.identity().copy();
    this.viewModel.stackModifier?.attribute?.transform(this.matrix);
    this.eventPipeline?.reset();
    this.updatePhotoScaledStatus();
    Log.info(TAG, 'resetInPhotoScaleGeometry end');
  }

  private onShowImageChanged(): void {
    Log.info(TAG, "onShowImageChanged");
    if (this.isBackGround) {
      /* instrument ignore next */
      this.thumbnail?.pixelMap?.release();
      /* instrument ignore next */
      this.dataSource?.photoDataAdapter.clearCache('');
      /* instrument ignore next */
      Log.info(TAG, `onShowImageChanged is background`);
      /* instrument ignore next */
      return;
    }
    const newImageSource = this.getActualImage();
    if (newImageSource && this.imageShowSource !== newImageSource) {
      this.imageShowSource = newImageSource;
    } else {
      Log.debug(TAG, `onShowImageChanged but imageSource not changed: ${this.mPosition}`);
    }

    this.setImagePixMapAndString();
  }

  private setImagePixMapAndString() {
    let newImageShowPixMapSource = this.getActualPixelMapImage();

    if (this.imageShowPixMapSource !== newImageShowPixMapSource && newImageShowPixMapSource) {
      Log.info(TAG, `imageShowPixMapSource changed newImageShowPixMapSource = ${
      newImageShowPixMapSource} imageShowPixMapSource = ${this.imageShowPixMapSource}`)
      this.imageShowPixMapSource = newImageShowPixMapSource;
      if (this.imageShowPixMapSource) {
        this.pixmapImageModifier?.updateConstructorParams(this.imageShowPixMapSource);
        this.removeMoirePixelMap = this.imageShowPixMapSource;
        this.onLCDReAdapt();
        this.isUseImageCache = false;
        this.isEditorBack = false;
      }
      // 美肤不能走单属性刷新逻辑
      if (!this.isUseImageCache) {
        // 编辑返回第二个Image置空
        if (this.isEditorBack && !this.imageShowPixMapSource) {
          /* instrument ignore next */
          Log.info(TAG, 'onShowImageChanged editorBack process ImageContent')
          /* instrument ignore next */
          this.stringImageModifier.attribute?.visibility(Visibility.Visible);
          /* instrument ignore next */
          this.pixmapImageModifier?.updateConstructorParams(ImageContent.EMPTY);
        }
      }
    } else {
      Log.info(TAG, `onShowImageChanged but imageShowPixMapSource not changed : ${this.mPosition}`);
    }
    let newImageShowStringSource = this.getActualStringImage();
    if (this.imageShowStringSource !== newImageShowStringSource &&
      (this.imageShowStringSource === undefined || this.isEditSaveReload)) {
      Log.info(TAG, `onshowImageChanged oldString: ${this.imageShowStringSource} new: ${newImageShowStringSource}`);
      this.imageShowStringSource = newImageShowStringSource;
      this.pixmapImageModifier.attribute?.visibility(Visibility.Visible);
    } else if (this.imageShowStringSource !== newImageShowStringSource &&
      this.item.imgOriginWidth * this.item.imgOriginHeight > PRELOAD_ORIGIN_MAX_SIZE * PRELOAD_ORIGIN_MAX_SIZE) {
      this.imageShowStringSource = newImageShowStringSource;
    } else {
      Log.info(TAG, `onShowImageChanged but newImageShowStringSource not changed : ${this.mPosition}`);
    }
  }

  private enterCompleteMethod(event: completed | undefined) {
    this.imageCompleteWidth = event?.width;
    this.imageCompleteHeight = event?.height;
    Log.info(TAG, `PixMapSource loadingStatus=${event?.loadingStatus},` +
      `imageCompleteWidth: ${this.imageCompleteWidth}，imageCompleteHeight: ${this.imageCompleteHeight},` +
      `image:${this.imageShowPixMapSource}`);
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      // 渲染完成后返回给父组件存起来
      this.fillPCPropertyData();
    }
    this.pixelMapComplete(event);
    this.imageComplete(event, true);
  }

  /**
   * 1、非PC跳过
   * 2、非编辑退出场景跳过
   * 3、通过当前uri获取getCachedThumbnail的值与当前imageShowStringSource不相等说明未加载成功
   *
   * @returns boolean
   */
  private isCompleteAfterExitEdit(): boolean {
    if (!DeviceInfo.isPc()) {
      return true;
    }
    if (!EditorPhotoContext.getInstance().getNotifyHideEditor()) {
      return true;
    }
    let newStringImage = this.dataSource?.photoDataAdapter.getCachedThumbnail(this.item.uri)?.url;
    if (this.imageShowStringSource !== newStringImage) {
      Log.info(TAG, `this.item.uri:${this.item.uri}, ${this.imageShowStringSource === this.getActualStringImage()},\
        this.imageShowStringSource:${this.imageShowStringSource}, newStringImage:${newStringImage}, need skip.`);
      return false;
    }
    return true;
  }

  private getActualStringImage(): string | undefined {
    if (this.isDefaultFA) {
      /* instrument ignore next */
      return this.thumbnail?.url;
    }
    if (this.item.isGifOrWebpType()) {
      /* instrument ignore if */
      let gifUri: string = this.item.uri;
      // 编辑覆盖uri不变，Image无法感知内容变化重新渲染，新增timestampApp参数
      if (this.item?.getDateModified?.() && EditorPhotoContext.getInstance().getNotifyHideEditor()) {
        gifUri += `${gifUri.includes('?') ? '&' : '?'}timestampApp=${this.item?.getDateModified?.()}&forceupdate=true`;
      } else if(this.item?.getDateModified?.()) {
        gifUri += `${gifUri.includes('?') ? '&' : '?'}timestampApp=${this.item?.getDateModified?.()}`;
      }
      if (this.userId > 0) {
        return gifUri + (gifUri.includes('?') ? '&' : '?') + 'user=' + this.userId;
      }
      return gifUri;
    }
    // instrument ignore if
    if (!this.thumbnail) {
      // 大图加载thumbnail错误
      const msg: Record<string, number | string | boolean> = {
        'index': this.mPosition
      };
      ReportToBigDataUtil.errEventReport(BigDataConstants.BROWER_THUMBNAIL_LOAD_ERROR, msg);
      Log.error(TAG, `getActualStringImage thumbnail object is null, index=${this.mPosition}`);
      return undefined;
    }
    // instrument ignore if
    if (ImageUtil.isExitTransparentChannelLocalImgMimeType(this.item)) {
      Log.info(TAG, `getActualStringImage transparent channel image, type=${this.item.mimeType}`);
      // 有透明通道的图是没有LCD图的，针对这类图直接在一开始就将lcd图透明度设置为1
      this.imageStringSourceOpacity = 1;
      if (this.userId > 0) {
        return this.thumbnail.url;
      }
      // png格式图片使用astc图代替LCD图
      return this.getPlaceHolderImage();
    }
    let lcdUrl: string = this.thumbnail.url;
    if (EditorPhotoContext.getInstance().getNotifyHideEditor()) {
      if (this.item?.getDateModified?.()) {
        lcdUrl += `${lcdUrl.includes('?') ? '&' : '?'}timestampApp=${this.item?.getDateModified?.()}&forceupdate=true`;
      } else {
        lcdUrl += `${lcdUrl.includes('?') ? '&' : '?'}timestampApp=${Date.now()}&forceupdate=true`;
      }
    }
    return lcdUrl;
  }

  private getActualPixelMapImage(): image.PixelMap | undefined {
    Log.info(TAG, `getActualPixelMapImage pixelmap ${this.imageShowPixMapSource} index=${this.mPosition}`);
    if (this.item.isGifOrWebpType()) {
      /* instrument ignore next */
      return undefined;
    }
    if (this.thumbnail.pixelMap) {
      /* instrument ignore next */
      Log.info(TAG, `getActualPixelMapImage pixelMap is not null, index=${this.mPosition}`);
      /* instrument ignore next */
      this.isPixMapSourceReady = true;
      /* instrument ignore next */
      return this.thumbnail.pixelMap as image.PixelMap;
    }
    if (this.thumbnail.yuvPixelMap) {
      Log.info(TAG, `getActualPixelMapImage yuvPixelMap is not null, index=${this.mPosition}`);
      this.isPixMapSourceReady = true;
      return this.thumbnail.yuvPixelMap;
    }
    return undefined;
  }

  /* instrument ignore next */
  private handleActionEnd(scale: number): void {
    Log.info(TAG, 'handleActionEnd');
    this.eventPipeline?.onResetIsFirstDownLoadOrigin();
    if (this.viewModel.isPropertiesShow() || this.isPullingDown) {
      Log.warn(TAG, 'Not allow to pinch when pullingUp or pullingDown');
      return;
    }
    if (this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE ||
      this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.eventPipeline?.onScaleEnd();
      this.calcLoadingPosition();
      if ((this.currentWidth / px2vp(this.currentImageWidth) > this.defaultScale) &&
        (this.currentWidth / px2vp(this.currentImageWidth) < this.viewModel.maxScale)) {
        this.isPhotoChangeLoading = false;
      }
      if (this.animationOption) {
        Log.info(TAG, 'handleActionEnd animationOption');
        animateTo({
          duration: 500,
          curve: 'ease',
          onFinish: (): void => {
            this.eventPipeline?.onAnimationEnd(this.animationEndMatrix as Matrix4.Matrix4Transit);
            this.animationOption = undefined;
            this.animationEndMatrix = undefined;
            this.isPhotoChangeLoading = false;
            this.viewModel.repeatScale(scale);
          }
        }, (): void => {
          this.matrix = this.animationEndMatrix as Matrix4.Matrix4Transit;
        })
        this.verifyPhotoScaled?.(this.matrix);
        this.updatePhotoScaledStatus();
      }
    }
  }

  // 半折态监听
  /* instrument ignore next */
  @StorageLink('isHalfFold') @Watch('startHalfFoldAnimation') isHalfFold: boolean = DeviceInfo.isHalfFoldState();
  /**
   * 半折状态image上移比例
   */
  /* instrument ignore next */
  @State private translateY: number | string =
    this.isHalfFold && !this.isHorizontal ? Constants.PERCENT_NEGATIVE_50 : '0%';
  /**
   * 半折状态image大小
   */
  /* instrument ignore next */
  @State private theImageHeight: Length = this.isHalfFold && !this.isHorizontal ? Constants.PERCENT_50 : '100%';
  // 内屏模式为false，外屏模式为true
  private isLemFoldState: boolean = display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_SUB;
  /**
   * 是否小外屏
   */
  /* instrument ignore next */
  @Prop isSubScreen: boolean = false;
  /* instrument ignore next */
  private continuePlayFromSubScreen: Function = (progress: number): void => this.playVideoFromSubScreen(progress);
  // 对接AI控件
  public isShowImageAnalyzer: boolean = true;
  private onVisibilityChangeFunc: Function = (): void => this.onVisibilityChange();
  /* instrument ignore next */
  private calcBarBottomHeightFunc: () => number = (): number =>
  this.viewModel.calcBarBottomHeight(this.isSlideBarVisibility());
  private resetToImageSlideInitStateFunc: Function = (): void => this.viewModel.resetImageSlideInitState();
  private resetImageSlideInitStateFunc: Function = (): void => this.viewModel.resetImageSlideInitState();
  /* instrument ignore next */
  @State pauseFromSubScreen: boolean = false;
  private xComponentController: XComponentController | undefined = new XComponentController();
  private rotateController: RotateController | undefined = undefined;
  /* instrument ignore next */
  @State testVOffset: number = 0;
  /* instrument ignore next */
  @State testHOffset: number = 0;
  /* instrument ignore next */
  @LocalStorageLink('isBrowserShow') isBrowserShow: boolean = true;
  private canShowSystemUi: boolean = false;
  private eventOnMainPhotoView: boolean = false;

  private onIsRunningAnimation(): void {
    this.onShowImageChanged();
    if (this.isRunningAnimation &&
      (!this.isPhotoScaled && !MediaLibraryData.isMediaLibraryUri(this.item.uri) && this.item.isInvalidImageSize())) {
      this.viewModel.stackModifier?.attribute?.transform(Matrix4.identity().copy());
    } else {
      this.viewModel.stackModifier?.attribute?.transform(this.matrix);
    }
    this.isInRotateAction = false;
    this.isInRotateState = false;
  }

  private onIsDoingImageSlideAnimation(): void {
  }

  private onIsPullDownAndDragPhoto(): void {
    Log.info(TAG, `this.isPullDownAndDragPhoto = ${this.isPullDownAndDragPhoto}, this.currentIndex = ${
    this.viewModel.getCurrentIndex()}`);
    this.onVisibilityChange();
  }

  private onIsOnSwiperAnimation(): void {
    if (this.isRunningAnimation) {
      /* instrument ignore next */
      return;
    }
    if (!MediaLibraryData.isMediaLibraryUri(this.item.uri) && this.item.isInvalidImageSize()) {
      /* instrument ignore next */
      this.viewModel.stackModifier?.attribute?.transform(Matrix4.identity().copy());
    } else {
      this.viewModel.stackModifier?.attribute?.transform(this.matrix);
    }
  }
  private isDeleteAnimWatch(): void {
    this.onLCDReAdapt();
  }

  /* instrument ignore next */
  private getSelectedStatus(): boolean | undefined {
    return false;
  }

  private setSwiperStatus(enableSwiper: boolean): void {
    /* instrument ignore if */
    if (enableSwiper) {
      this.eventPipeline?.setSwipeStatus(false);
      this.panOption.setDirection(PanDirection.Vertical);
    } else {
      /* instrument ignore next */
      this.eventPipeline?.setSwipeStatus(true);
      /* instrument ignore next */
      this.panOption.setDirection(PanDirection.All);
    }
  }

  private onVisibilityChange(isSwiperAniEnd?: boolean): void {
    this.appBroadCast.emit(BroadCastConstants.IS_PULLING_UP, [this.viewModel.isPropertiesShow()]);
  }

  onShowChanged() {
    Log.info(TAG, `photoItem onShowChanged: ${this.isShowBar}, currentIndex:${this.currentIndex}`);
    this.viewModel.isShowBar = this.isShowBar;
    this.calcLoadingPosition();
    this.viewModel.updateSystemUi();
    this.updateAbleEnterInnerPic();
    this.eventPipeline?.innerPicPinchAnimationEnd();
    if (DeviceInfo.isPc() && !this.isShowSideBar) {
      this.calculateImagePos();
    }
  }

  /**
   * photoItem 缩放或者移动，定时器清除
   */
  private innerPhotoDealTouchEvent(): void {
    // 画中画组件 上树时才操作
    if (this.enableEnterInnerPic) {
      // 此时隐藏状态, visibility = 1且重置定时器
      /* instrument ignore next */
      if (this.imageToolInnerState._stackVisibility === 0) {
        this.imageToolInnerState._stackVisibility = 1;
        /* instrument ignore else */
      } else {
        Log.debug(TAG, `innerPic clear timeout`);
        clearTimeout(this.imageToolInnerState._pTimeout);
      }
      /* instrument ignore next */
      this.imageToolInnerState._pTimeout = setTimeout(() => {
        Log.debug(TAG, `3s no use ImageTool, hide!`);
        this.imageToolInnerState._stackVisibility = 0;
      }, ImageToolConstants.IMAGE_TOOL_AUTOHIDE_DURATION);
    }
  }

  private updateInnerPicInfo(): void {
    // 退出画中画模式
    if (!this.enableEnterInnerPic) {
      Log.info(TAG, 'quit innerPic mode');
      return;
    }
    // 进入画中画模式  
    /* instrument ignore next */
    this.eventPipeline?.getInnerSmaPicInfo();
    /* instrument ignore next */
    let params: ImageToolReportParams = new ImageToolReportParams();
    /* instrument ignore next */
    params.uri = this.item.uri;
    /* instrument ignore next */
    params.imageWidth = this.item.width;
    /* instrument ignore next */
    params.imageHeight = this.item.height;
    /* instrument ignore next */
    params.enterInnerPicWay = this.enterInnerPicWay;
    /* instrument ignore next */
    params.curScale = this.eventPipeline?.lastScale ?? 1.0;
    /* instrument ignore next */
    ImageToolBigDataReport.reportEnterInnerPhoto(params);
  }

  /**
   * 画中画适配双指旋转 内层Rect - positionX
   * @returns
   */
  /* instrument ignore next */
  private getInnerPhotoRectX(): number {
    let curRotateValue: number = this.rotateValue % ImageToolConstants.IMAGE_TOOL_THREE_SIX_ZERO;
    curRotateValue = curRotateValue < 0 ?
      curRotateValue + ImageToolConstants.IMAGE_TOOL_THREE_SIX_ZERO : curRotateValue;
    if (curRotateValue === BrowserConstants.ROTATION_ZERO) {
      return this.imageToolInnerState._scrollX;
      /* instrument ignore next */
    } else if (curRotateValue === BrowserConstants.ROTATION_NINETY) {
      return this.imageToolInnerState._scrollY;
      /* instrument ignore next */
    } else if (curRotateValue === BrowserConstants.ROTATION_ONE_EIGHT_ZERO) {
      return this.imageToolInnerState._stackWidth -
        /* instrument ignore next */
      this.imageToolInnerState._scrollX - this.imageToolInnerState._scrollWidth;
    }
    // 270
    /* instrument ignore next */
    return this.imageToolInnerState._stackHeight -
    this.imageToolInnerState._scrollY - this.imageToolInnerState._scrollHeight;
  }

  /**
   * 画中画适配双指旋转 内层Rect - positionY
   * @returns
   */
  /* instrument ignore next */
  private getInnerPhotoRextY(): number {
    let curRotateValue: number = this.rotateValue % BrowserConstants.ROTATION_THREE_SIX_ZERO;
    curRotateValue = curRotateValue < 0 ? curRotateValue + BrowserConstants.ROTATION_THREE_SIX_ZERO : curRotateValue;
    if (curRotateValue === BrowserConstants.ROTATION_ZERO) {
      return this.imageToolInnerState._scrollY;
      /* instrument ignore next */
    } else if (curRotateValue === BrowserConstants.ROTATION_NINETY) {
      return this.imageToolInnerState._stackWidth -
      this.imageToolInnerState._scrollX - this.imageToolInnerState._scrollWidth;
      /* instrument ignore next */
    } else if (curRotateValue === BrowserConstants.ROTATION_ONE_EIGHT_ZERO) {
      return this.imageToolInnerState._stackHeight -
      this.imageToolInnerState._scrollY - this.imageToolInnerState._scrollHeight;
    }
    /* instrument ignore next */
    return this.imageToolInnerState._scrollX;
  }

  private onGeometryScaleChange(): void {
    this.viewModel.setGeometryScale(this.geometryScale);
  }

  private onGeometryOffsetXChange(): void {
    this.viewModel.setGeometryOffsetX(this.geometryOffsetX);
  }

  private onGeometryOffsetYChange(): void {
    this.viewModel.setGeometryOffsetY(this.geometryOffsetY);
  }

  private broadCastWhenShowBarChanged(): void {
    if (this.isOpenTouchGuide) {
      /* instrument ignore next */
      Log.info(TAG, `isMenuShow: ${this.isMenuShow}`);
      /* instrument ignore if */
      if (this.isShowBar) {
        AccessibilityUtil.sendAnnounceAccessibilityEvent(`${Rsc.toString($r('app.string.open_menu_bar'))}, ${
        this.getImageItemGridAccessibilityText()}`);
      } else {
        /* instrument ignore next */
        AccessibilityUtil.sendAnnounceAccessibilityEvent(`${Rsc.toString($r('app.string.collapse_menu_bar'))}, ${
        /* instrument ignore next */
        this.getImageItemGridAccessibilityText()}`);
      }
    }
  }

  /* instrument ignore next */
  downloadOriginPhotoResult(result: String, err: string): void {
    Log.info(TAG, `download Origin Photo process: ${result}, thumbnail.url: ${this.thumbnail.url}`);
    if (result === 'start' || result === 'running') {
      this.isRequestOriginLoading = true;
    } else if (result === 'completed') {
      this.isRequestOriginLoading = false;
      this.item?.setPosition(photoAccessHelper.PositionType.LOCAL);
    } else if (result === 'failed') {
      this.isRequestOriginLoading = false;
      AppStorage.setOrCreate<number>(Constants.APP_STORAGE_KEY_DOWNLOAD_PROGRESS, Constants.INVALID);
      if (err === BigDataConstants.NETWORK_UNAVAILABLE) {
        UiUtil.showToast($r('app.string.moving_photo_export_error'));
      } else {
        UiUtil.showToast($r('app.string.download_failed'));
      }
    } else if (result === 'stopped') {
      this.isRequestOriginLoading = false;
    }
  }

  changeLoadingStatus(status: boolean): void {
    this.isPhotoChangeLoading = status;
  }

  isDoGestureSwipeWatchFunc(): void {
    this.onShowImageChanged();
    if (this.viewModel.isOnSwiperAnimation() && this.viewModel.isPropertiesShow()) {
      this.controllerTextArea.stopEditing();
      this.controllerTextInput.stopEditing();
      this.controllerPortraitInput.stopEditing();
    }
  }

  /* instrument ignore next */
  getFoldExpandedPercentage() {
    const unFolderWidth = this.getUnFolderVerticalDeviceWidth();
    return 1 - unFolderWidth / this.viewModel.windowLayoutWidth;
  }

  /* instrument ignore next */
  foldStatusChange(): void {
    let width: number = 0
    let height: number = 0
    try {
      width = px2vp(display.getDefaultDisplaySync().width);
      height = px2vp(display.getDefaultDisplaySync().height);
    } catch (err) {
      Log.error(TAG, `onFoldStatusChanged display.getDefaultDisplaySync, error code : ${err.code}`)
    }
    this.resetFirstLookStatus();
    Log.info(TAG, `foldStatusChange ${width} ${height} ${this.foldDisplayMode} ${this.mIsCurrent}`)
    if (this.isFoldExpanded) {
      this.viewModel.clipWidthTargetPercentage = this.getFoldExpandedPercentage() || FOLD_EXPANDED_PERCENTAGE;
      this.viewModel.imageSlideTargetOffset = width / QUARTER_DIVIDER;
    } else {
      this.viewModel.imageSlideTargetOffset =
        !DeviceInfo.isPc() ? Math.abs(width / HALF_DIVIDER - height / HALF_DIVIDER) : height / QUARTER_DIVIDER;
      if (Math.max(width, height) !== 0) {
        this.viewModel.clipWidthTargetPercentage = Math.min(width, height)
          / Math.max(width, height);
      }
    }
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      this.viewModel.propertiesIndex = 2;
    }

    this.viewModel.updatePropertiesIndex();
    this.viewModel.setIsOnlyShowProperties(getScreen().getDetailShow());
    this.viewModel.onWinModeChanged();
    this.imageTargetPullHeight = this.viewModel.imageSlideTargetOffset * this.viewModel.ratioOffset;

    this.viewModel.updateSystemUi();
    Log.info(TAG,
      `foldStatusChange: ${this.isFoldExpanded}, isFoldable:${DeviceInfo.isFoldable()}, TargetPercentage: ${this.viewModel.clipWidthTargetPercentage}, TargetOffset${this.viewModel.imageSlideTargetOffset}`);
  }

  isVirtualKbKeyPCChanged(): void {
    Log.info(TAG, `isVirtualKbKeyPCChanged: ${this.virtualKbKeyPC}`);
  }

  onMediaResultChanged(): void {
    // todo 先注释这里注释后暂时没看见有什么影响，但是方法一直在执行有可能卡死问题是这里导致的
    // uri showthub captureID this.mPosition
    // Log.info(TAG, `onMediaResultChanged captureId: ${this.mediaResult.captureId},
    //   isShowThumbnail: ${this.mediaResult.isShowThumbnail}, mPosition: ${this.mPosition}, item.uri:${this.item.uri},
    //   patch:${this.mediaResult.path}, isCurrent: ${this.mIsCurrent} `);
    // if (this.mIsCurrent) {
    //   AppStorage.setOrCreate<MediaItem>('targetItem', this.item);
    // }
    // if (this.isDelayRegisterUriBroadcast && this.item.uri && this.item.uniqueId) {
    //   /* instrument ignore next */
    //   this.registerUriBroadcast();
    // }
    //
    // if (!this.thumbnail) {
    //   /* instrument ignore next */
    //   Log.error(TAG, 'thumbnail is undefined');
    //   /* instrument ignore next */
    //   return;
    // }
    // Log.info(TAG,`onMediaItemResult, this.thumbnail: ${JSON.stringify(this.thumbnail)}`
    //   + ` mediaResult.thumbnail: ${JSON.stringify(this.mediaResult.thumbnail)}`);
    // if (this.thumbnail != this.mediaResult.thumbnail) {
    //   Log.info(TAG, `onMediaItemResult, isCurrent: ${this.mIsCurrent}`);
    // }
    //
    // if (this.mediaResult.dateModified !== this.item.dateModified) {
    //   Log.info(TAG, `onMediaItemResult, dateModified is changed from ${this.item.dateModified} to ${
    //   this.mediaResult.dateModified} for ${this.mediaResult.path}`);
    // }
    //
    // if (this.mediaResult.pos !== undefined) {
    //   this.viewModel.updatemPosition(this.mediaResult.pos);
    // }
    //
    // if (this.mediaResult?.item) {
    //   this.updateBroadcastWithItem?.(this.mediaResult.item);
    // }
    // if (this.dataSource) {
    //   this.mPosition = this.dataSource?.getDataIndexByUri?.(this.item.uri ? this.item.uri : this.item.captureId);
    //   this.appBroadCast.emit(BroadCastConstants.CAST_POSITION_CHANGED + this.src, [this.mPosition]);
    // }
    //
    // if (this.mediaResult?.item?.getPosition) {
    //   this.mediaPosition = this.mediaResult.item.getPosition();
    // }
    // if (this.mediaResult.thumbnail) {
    //   if (PhotoConfig.isFromMeetime) {
    //     /* instrument ignore next */
    //     this.thumbnail = this.mediaResult.thumbnail;
    //   } else {
    //     this.thumbnail = this.dataSource?.photoDataAdapter.getThumbnail(this.item) ?? new Thumbnail;
    //   }
    // }
    // if (this.mediaResult.orientation != undefined) {
    //   this.orientation = this.mediaResult.orientation;
    // }
    // this.updateIsCurrent();
    // this.rotateController?.init(this.item, this.videoRealWidth, this.videoRealHeight, this.isShowBar);
    // this.rotateController?.setComponentSize(vp2px(this.viewModel.windowLayoutWidth),
    //   vp2px(this.viewModel.windowLayoutHeight));
    // this.setRotateButtonOffset();
    // this.onPhotoChanged();
    // if (!LocalStorage.getShared()?.get<Context>('photoLibraryContext') &&
    //   !LocalStorage.getShared()?.get<Context>(Constants.PHOTO_PICKER_SESSION_KEY) &&
    //   !LocalStorage.getShared()?.get<Context>('geometryEnable')) {
    //   this.onGeometryIdChange();
    // }
  }

  private updateIsCurrent() {
    if (this.mediaResult && this.mediaResult.pos !== undefined) {
      this.mIsCurrent = this.viewModel.getCurrentIndex() === this.mediaResult.pos;
    }
  }

  /**
   * 图片内容切换回调
   */
  onPhotoChanged() {
    if (!this.isDoingImmersiveAnimationPC) {
      this.calculateImagePos();
    }
    UiUtil.setBundleNameValue(true, LocalStorage.getShared());
    this.onCurrentUriChange();
    if (!this.mIsCurrent) {
      return;
    }
    Log.debug(TAG, `onPhotoChanged: this.mPosition = ${this.mPosition}, currentIndex= ${this.mIsCurrent}, uri = ${
    this.item.uri}, ratio = ${this.ratio}, size = (${
    this.imageWidth}, ${this.imageHeight})`);
    AppStorage.setOrCreate<number>('isSelectedItemMediaType', this.item?.mediaType);
    // 此处index开始刷新
    let tmpMoreList: Action[] = [];
    if (this.pageFrom !== Constants.ENTRY_FROM.HIDDEN &&
    PhotoPropertiesUtil.isValidFormatToSetWallPaper(this.item.uri) &&
      !UserConstraintUtil.isConstraintUserModifyWallpaper()) {
      tmpMoreList.push(Action.SET_WALLPAPER);
    }
    Log.info(TAG, `changeMoreMenuList: mediaType--${this.item?.mediaType}`);
    this.changeMoreMenuList(this.viewModel.isVideo() ? [] : tmpMoreList, this.viewModel.getCurrentIndex());
  }

  /* instrument ignore next */
  onCanPanGestureResponse() {
    Log.debug(TAG, `canResponse change：canRespondPanGesture: ${this.canRespondPanGesture}`)
    if (this.canRespondPanGesture) {
      this.eventPipeline?.setSwipeStatus(false);
      this.panOption.setDirection(PanDirection.Vertical);
    } else {
      this.eventPipeline?.setSwipeStatus(true);
      this.panOption.setDirection(PanDirection.All);
    }
  }

  /**
   * 图片缩放矩阵变化回调
   */
  onMatrixChange() {
    if (!this.mIsCurrent || !this.viewModel.stackModifier?.attribute) {
      Log.info(TAG, `onMatrixChange mIsCurrent = ${this.mIsCurrent} stackModifier.attribute = ${
      this.viewModel.stackModifier?.attribute}`);
      return;
    }
    TraceControllerUtils.startTrace('onMatrixChange PhotoItem');

    this.viewModel?.stackModifier.attribute?.transform(this.matrix);
    this.viewModel?.thumbImageStackModifier?.attribute?.transform(this.matrix)
    if (!this.animationOption) {
      this.onPixelmapReAdapt()
    }

    if (this.isInPinch) {
      this.viewModel.stackModifier?.attribute?.transform(this.matrix);
    }
    // 在this.isInPinch为true时，不更新图片缩放状态标志位
    if (!this.isInPinch && !this.isDoingImmersiveAnimationPC) {
      this.calculateImagePos();
      // 搜索ocr旋转适配
      if (this.isAngleChanged && this.isShowHighlight()) {
        this.hasHighlightRect = false;
        this.changeHighlightRectPos();
      }
      this.calculateXComponentSize();
    }
    TraceControllerUtils.finishTrace('onMatrixChange PhotoItem');
  }

  isShowVideoChange() {
    let matrix: Matrix4.Matrix4Transit = Matrix4.identity().copy();
  }

  isTabletOrTriExpand(): boolean {
    const isTablet = DeviceInfo.isTablet() || DeviceInfo.isSuperLauncher();
    const isTriExpand = FoldUtil.isTriExpand(this.curFoldStatus);
    const result = isTablet || isTriExpand;
    return result;
  }

  /**
   * 适配 PC 场景下，窗口尺寸缩放回调
   */
  private onChangeWindow(): void {
    Log.info(TAG, 'onChangeWindow');
    if (this.viewModel.isUpdateSlideTargetOffset()) {
      /* instrument ignore next */
      this.viewModel.imageSlideTargetOffset = this.viewModel.windowLayoutHeight / QUARTER_DIVIDER;
      /* instrument ignore next */
      this.viewModel.onResetPullingUpState();
    }
    this.loadingDeviceOffsetX = -(this.viewModel.windowLayoutWidth / HALF_DIVIDER);
    this.loadingDeviceOffsetY = -(this.viewModel.windowLayoutHeight / HALF_DIVIDER);
  }

  /**
   *  侧边栏发生变化时，重新计算图片位置
   */
  /* instrument ignore next */
  isShowSideBarChanged(): void {
    if (!this.isDoingImmersiveAnimationPC) {
      this.calculateImagePos();
    }
  }

  /* instrument ignore next */
  onNetworkAvailableChanged(): void {
    Log.info(TAG, `networkAvailable Changed: ${this.networkAvailable}`);
  }

  private initImageTool(): void {
    this.calculateImageToolParam();
    this.updateAbleEnterInnerPic();
  }

  private calculateImageToolParam(): void {
    if (!this.eventPipeline) {
      /* instrument ignore next */
      return;
    }

    let stackHeight: number = 0;
    let stackWidth: number = 0;
    if (this.eventPipeline?.width >= this.eventPipeline?.height) {
      this.imageToolInnerState.setIsRight(false);
      stackHeight = ImageToolConstants.IMAGE_TOOL_SINGLE_LEN;
      stackWidth = this.eventPipeline?.getImageToolLenByRatio();

      let maxStackWidth: number = px2vp(this.eventPipeline?.componentWidth) - Constants.COLUMN_MARGIN * 2;
      // 极限场景 画中画宽度大于最大宽度
      if (maxStackWidth < stackWidth) {
        /* instrument ignore next */
        this.imageToolInnerState._stackRatio = maxStackWidth / stackWidth;
        /* instrument ignore next */
        this.imageToolInnerState._stackWidth = maxStackWidth;
        // 等比例计算stackHeight
        /* instrument ignore next */
        this.imageToolInnerState._stackHeight = stackHeight / stackWidth * maxStackWidth;
      } else {
        this.imageToolInnerState._stackRatio = 1;
        this.imageToolInnerState._stackWidth = stackWidth;
        this.imageToolInnerState._stackHeight = stackHeight;
      }
    } else {
      this.imageToolInnerState.setIsRight(true);
      stackWidth = ImageToolConstants.IMAGE_TOOL_SINGLE_LEN;
      stackHeight = this.eventPipeline?.getImageToolLenByRatio();

      let maxStackHeight: number = px2vp(this.eventPipeline?.componentHeight) - Constants.COLUMN_MARGIN * 2;
      // 极限场景 画中画宽度大于最大宽度
      if (maxStackHeight < stackHeight) {
        /* instrument ignore next */
        this.imageToolInnerState._stackRatio = maxStackHeight / stackHeight;
        /* instrument ignore next */
        this.imageToolInnerState._stackHeight = maxStackHeight;
        // 等比例计算stackHeight
        /* instrument ignore next */
        this.imageToolInnerState._stackWidth = stackWidth / stackHeight * maxStackHeight;
      } else {
        this.imageToolInnerState._stackRatio = 1;
        this.imageToolInnerState._stackHeight = stackHeight;
        this.imageToolInnerState._stackWidth = stackWidth;
      }
    }
    this.imageToolInnerState._stackRightMargin = getScreen().getColumnMargin();
    Log.info(TAG, `calculateImageTool stackWidth:${this.imageToolInnerState._stackWidth}
      stackHeight:${this.imageToolInnerState._stackHeight} stackRightMargin:${this.imageToolInnerState._stackRightMargin}`);
  }

  /**
   * 获取图片缩放倍率
   */
  getPhotoScaledRatio(matrix: Matrix4.Matrix4Transit): number {
    let scale: number = 1;
    if (matrix) {
      let mat: number[] | undefined = (matrix?.copy() as Matrix4x4)?.matrix4x4;
      if (mat) {
        scale = mat[0];
      }
    }
    return scale;
  }

  /**
   * 刷新图片 geometryTransitionId，当执行删除图片操作时候不刷新
   */
  updateGeometryIdIfNeeded(): void {
    if (!this.isDoingDeleteAnim && !this.isInAnimateToPosition) {
      this.onGeometryIdChange();
    }
  }

  /**
   * 刷新图片 geometryTransitionId
   */
  onGeometryIdChange(): void {
    let uriStartIndex = this.geometryTransitionBrowserId?.indexOf('/');
    let uriEndIndex: number;
    if (PhotoConfig.isLibrary()) {
      /* instrument ignore next */
      uriEndIndex = -1;
    } else {
      uriEndIndex = this.geometryTransitionBrowserId?.length;
    }
    let uniqueId: string = this.geometryTransitionBrowserId?.substring(uriStartIndex, uriEndIndex);
    Log.info(TAG,
      `onGeometryIdChange geometryTransitionId = ${this.geometryTransitionBrowserId}, uniqueId = ${uniqueId} item.uniqueId = ${this.item.uniqueId}`);
    // todo lishang 图库场景修改数据源后，这部分需要恢复
    if (uniqueId !== '' && this.item.uniqueId !== uniqueId) {
      Log.info(TAG,
        `onGeometryIdChange: uniqueId != item.uniqueId}`);
      return;
    }
    if (this.dataSource) {
      this.mPosition = this.dataSource.getDataIndexByUri(this.item.uri ? this.item.uri : this.item.captureId);
      this.appBroadCast.emit(BroadCastConstants.CAST_POSITION_CHANGED + this.src, [this.mPosition]);
    }
    const mIsPrepared: boolean = this.viewModel.getTargetIndex() === this.mediaResult.pos;
    if (mIsPrepared && this.mPosition >= 0 && this.geoIdMgr.canSetNewId()) {
      if (this.geometryTransitionBrowserId) {
        this.geoIdMgr.setGeoId?.(this.mPosition.toString(), true);
      }
      this.geometryTransitionId = this.geometryTransitionBrowserId;
    } else {
      this.geoIdMgr.deleteGeoId?.(this.mPosition.toString());
      this.geometryTransitionId = '';
    }
    Log.info(TAG,
      `onGeometryIdChange item.uri = ${this.item.uri}, geometryTransitionId = ${this.geometryTransitionId},\
      this.mPosition = ${this.mPosition} , this.mIsCurrent = ${this.mIsCurrent}`);
  }

  private requestOcrInfo(): void {
    if (!this.item || this.isThird) {
      /* instrument ignore next */
      Log.info(TAG, 'Invalid item');
      /* instrument ignore next */
      return;
    }
    Log.debug(TAG, `requestOcrInfo, uri = ${this.item.uri}`);
    UserFileManagerAccess.getInstance().getOcrInfoByUri(this.item.uri).then(
      (ocrCacheData: string | undefined): void => {
        if (!ocrCacheData) {
          /* instrument ignore next */
          Log.warn(TAG, 'requestOcrInfo ocrCacheData undefined');
          /* instrument ignore next */
          return;
        }
        try {
          let ocrDataObjectArray: Object[] = JSON.parse(ocrCacheData);
          Log.info(TAG, `requestOcrInfo, ocrCacheData.length = ${ocrCacheData.length}, \
        ocrDataObjectArray.length = ${ocrDataObjectArray.length}`);
          if (ocrDataObjectArray?.length > 0) {
            this.item.ocrCacheData = JSON.stringify(ocrDataObjectArray[0]);
            this.item.ocrCacheDataFlag = true;
          } else if (ocrCacheData.length > 0 && ocrCacheData !== '[]') {
            /* instrument ignore next */
            this.item.ocrCacheData = ocrCacheData;
            /* instrument ignore next */
            this.item.ocrCacheDataFlag = true;
          }
          this.broadCast?.emit(BroadCastConstants.AI_OCR_CACHE_DATA_IS_READY,
            [this.item.uri, this.item.ocrCacheData]);
          /* instrument ignore next */
        } catch (err) {
          /* instrument ignore next */
          Log.error(TAG, `ocr parse fail ${err}`);
        }
        Log.info(TAG, `requestOcrInfo finish, uri = ${this.item.uri}, ocrCacheDataFlag = ${this.item.ocrCacheDataFlag}, \
        ocrCacheData.length = ${this.item.ocrCacheData.length}`);

        // 融合搜索提供hitInfo字段后，可优化
        if (this.highlightWords !== '') {
          /* instrument ignore next */
          this.getHighlightWordsInfo();
        }
      });
  }

  /* instrument ignore next */
  private getHighlightWordsInfo(): void {
    if (!this.item.ocrCacheDataFlag) {
      Log.debug(TAG, 'Invalid ocrCacheData');
      return;
    }
    this.highlightRect = [];
    this.originOcrRect = [];
    let ocrObj: OcrCacheData = JSON.parse(this.item.ocrCacheData) as OcrCacheData;
    let ocrWidth = ocrObj.width ?? 0;
    let ocrHeight = ocrObj.height ?? 0;
    let msgStr: string = ocrObj.ocr_text_msg ?? '';
    if (msgStr === '') {
      Log.debug(TAG, 'Invalid ocrObj.ocr_text_msg');
      return;
    }
    let msgData: OcrMsg = JSON.parse(msgStr) as OcrMsg;
    for (let blockItem of msgData.blocks) {
      let lastTextLine: OcrLines | undefined;
      Log.info(TAG, `new blockItem`)
      for (let textLine of blockItem.lines) {
        Log.info(TAG, `this.highlightWords: ${this.highlightWords}, textline value: ${textLine.value}`)
        if (textLine.value === null || textLine.value === '') {
          continue;
        }
        let upperWords = this.highlightWords.toUpperCase();
        if (upperWords.includes(textLine.value.toUpperCase()) || textLine.value.toUpperCase().includes(upperWords)) {
          this.getWords(textLine);
        }
        if (upperWords.length > 1 && lastTextLine) {
          this.getLastAndWord(lastTextLine, textLine);
        }
        lastTextLine = textLine;
      }
    }
    this.calculateHighlightRect(ocrWidth, ocrHeight);
    this.hasHighlightRect = this.highlightRect.length !== 0;
    if (this.hasHighlightRect) {
      const msg: Record<string, number | string | boolean> = {
        'highlightWords': this.highlightWords,
        'wordsLength': this.highlightWords.length
      };
      ReportToBigDataUtil.report(BigDataConstants.PHOTO_BROWSER_HIGHLIGHT_WORDS, msg);
    }
  }

  private getLastAndWord(lastTextLine: OcrLines, textLine: OcrLines): void {
    let upperWords = this.highlightWords.toUpperCase();
    let newLine = lastTextLine.value.toUpperCase() + textLine.value.toUpperCase();
    Log.info(TAG, `getLastAndWord newLine:${newLine}, includes: ${newLine.toUpperCase().includes(upperWords)}`);
    if (!newLine.toUpperCase().includes(upperWords)) {
      return;
    }
    let pos = newLine.indexOf(upperWords);
    let position = -1;
    while (pos > -1) {
      if (pos < lastTextLine.value.length && pos + upperWords.length >= lastTextLine.value.length) {
        position = pos;
        break;
      }
      pos = newLine.indexOf(upperWords, pos + 1);
    }
    Log.info(TAG, `getLastAndWord pos:${pos}, position: ${position}`);
    if (position === -1) {
      return;
    }
    let textWords: OcrWords[] = textLine.words;
    let textWordsExpand: OcrWords[] = [];
    let textStr = this.getWordText(textWords, textWordsExpand);
    let lastTextWords: OcrWords[] = lastTextLine.words;
    let lastTextWordsExpand: OcrWords[] = [];
    let lastTextStr = this.getWordText(lastTextWords, lastTextWordsExpand);
    Log.info(TAG, `getLastAndWord textStr:${textStr}, textWordsExpand: ${textWordsExpand.length},
    lastTextStr: ${lastTextStr}, lastTextWordsExpand: ${lastTextWordsExpand.length}`);
    // 前一行
    let lastHighlightWordRect: RectValue[] = [];
    for (let index = position; index < lastTextStr.length; index++) {
      if (!this.isValidOcrPos(upperWords[index - position], lastTextWordsExpand[index].value)) {
        continue;
      }
      let curWordRect: RectValue = this.getCurWordRect(lastTextWordsExpand[index]);
      lastHighlightWordRect.push(curWordRect);
    }
    if (lastHighlightWordRect.length === 0) {
      //若换行字段有一个未被识别，另一个应该也不显示
      return;
    }
    let highlightWordRectLength = lastHighlightWordRect.length;
    Log.info(TAG, `getLastAndWord lastTextWordsExpand highlightWordRect: ${lastHighlightWordRect.length}`)
    let newLength = lastTextStr.length - position < textStr.length ? lastTextStr.length - position : textStr.length;
    let highlightWordRect: RectValue[] = [];
    for (let index = 0; index < newLength; index++) {
      if (highlightWordRectLength + index >= upperWords.length) {
        break;
      }
      if (!this.isValidOcrPos(upperWords[highlightWordRectLength + index], textWordsExpand[index].value)) {
        continue;
      }
      let curWordRect: RectValue = this.getCurWordRect(textWordsExpand[index]);
      highlightWordRect.push(curWordRect);
    }
    Log.info(TAG, `getLastAndWord textWordsExpand highlightWordRect: ${highlightWordRect.length}`);
    if (highlightWordRect.length === 0) {
      //若换行字段有一个未被识别，另一个应该也不显示
      return;
    }
    this.getOriginOcrRect(lastHighlightWordRect);
    this.getOriginOcrRect(highlightWordRect);
  }

  /* instrument ignore next */
  private getWords(textLine: OcrLines): void {
    let words: OcrWords[] = textLine.words;
    let wordsExpand: OcrWords[] = [];
    let wordsText = this.getWordText(words, wordsExpand);

    let upperWords = this.highlightWords.toUpperCase();
    let subStrPosition = this.searchSubStr(wordsText, upperWords);
    if (!Array.isArray(subStrPosition) || subStrPosition.length === 0) {
      Log.error(TAG, 'subStrPosition.length === 0');
      return;
    }
    for (let pos = 0; pos < subStrPosition.length; pos++) {
      let highlightWordRect: RectValue[] = [];
      for (let index = 0; index < upperWords.length; index++) {
        let curWordIndex = subStrPosition[pos] + index;
        if (!this.isValidOcrPos(upperWords[index], wordsExpand[curWordIndex].value)) {
          continue;
        }
        let curWordRect: RectValue = this.getCurWordRect(wordsExpand[curWordIndex]);

        // 相同位置，过滤重复信息
        if (this.isSameWordRect(highlightWordRect, wordsExpand, curWordIndex, curWordRect)) {
          Log.debug(TAG, 'searchWords position duplicate');
          continue;
        }
        // 每个字的位置
        highlightWordRect.push(curWordRect);
      }
      this.getOriginOcrRect(highlightWordRect);
    }
  }

  /* instrument ignore next */
  private getCurWordRect(curWord: OcrWords): RectValue {
    let minX = Number.MAX_VALUE;
    let minY = Number.MAX_VALUE;
    let maxX = 0;
    let maxY = 0;
    for (let point of curWord.cornerPoints) {
      minX = Math.min(minX, point.x);
      minY = Math.min(minY, point.y);
      maxX = Math.max(maxX, point.x);
      maxY = Math.max(maxY, point.y);
    }
    let curWordRect: RectValue = {
      x: minX,
      y: minY,
      width: (maxX - minX),
      height: (maxY - minY),
    };
    return curWordRect;
  }

  /* instrument ignore next */
  private getWordText(words: OcrWords[], position: OcrWords[]): string {
    let text = '';
    words.forEach((word: OcrWords): void => {
      let value = word.value.toUpperCase();
      text = text.concat(value);
      for (let i = 0; i < value.length; i++) {
        position.push({
          value: value,
          cornerPoints: word.cornerPoints,
        });
      }
    });
    return text;
  }

  /* instrument ignore next */
  private isValidOcrPos(upperWord: string, posWord: string): boolean {
    if (!upperWord.includes(posWord) && !posWord.includes(upperWord)) {
      Log.error(TAG, 'error position, searchWords not include word.value');
      const msg: Record<string, number | string | boolean> = { 'index': this.mPosition };
      ReportToBigDataUtil.errEventReport(BigDataConstants.BROWER_HIGHLIGHT_DATA_ERROR, msg);
      return false;
    }
    return true;
  }

  /* instrument ignore next */
  private onDoFaceBeauty(): void {
    Log.info(TAG, `face state change item path: ${this.item.path}, ${this.doFaceSmooth}, ${this.mIsCurrent}, ${this.item.uri}`);
    if (this.doFaceSmooth === '0') {
      return;
    }
    if (this.mIsCurrent) {
      AppStorage.setOrCreate<string>('doSkinSmoothing', '0');
    }
  }

  /* instrument ignore next */
  private getOriginOcrRect(highlightWordRect: RectValue[]): void {
    let textLineX = Number.MAX_VALUE;
    let textLineY = Number.MAX_VALUE;
    let textLineXR: number = 0;
    let textLineYR: number = 0;

    // 计算一行中高亮框的左上角坐标，右下角坐标
    highlightWordRect.forEach((wordsRect: RectValue): void => {
      textLineX = Math.min(textLineX, wordsRect.x);
      textLineY = Math.min(textLineY, wordsRect.y);
      textLineXR = Math.max(textLineXR, wordsRect.x + wordsRect.width);
      textLineYR = Math.max(textLineYR, wordsRect.y + wordsRect.height);
    });
    let textLineWidth: number = textLineXR - textLineX;
    let textLineHeight: number = textLineYR - textLineY;
    Log.debug(TAG, `highlightLine.height: ${px2vp(textLineHeight)}, highlightLine.width: ${px2vp(textLineWidth)}`);
    this.originOcrRect.push({
      x: textLineX,
      y: textLineY,
      width: textLineWidth,
      height: textLineHeight,
    });
  }

  /* instrument ignore next */
  private searchSubStr(upperText: string, upperWords: string): number[] {
    let positions: number[] = [];
    let pos = upperText.indexOf(upperWords);
    while (pos > -1) {
      positions.push(pos);
      pos = upperText.indexOf(upperWords, pos + 1);
    }
    return positions;
  }

  /* instrument ignore next */
  private isSameWordRect(highlightWordRect: RectValue[], wordsExpand: OcrWords[], curWordIndex: number,
    curWordRect: RectValue): boolean {
    let rectLen = highlightWordRect.length;
    if (rectLen !== 0 && curWordIndex !== 0 &&
      wordsExpand[curWordIndex].value === wordsExpand[curWordIndex - 1].value) {
      let preWordRect = highlightWordRect[rectLen - 1];
      if (preWordRect.x === curWordRect.x && preWordRect.y === curWordRect.y &&
        preWordRect.width === curWordRect.width && preWordRect.height === curWordRect.height) {
        return true;
      }
    }
    return false;
  }

  /* instrument ignore next */
  private requestFaceBeautyInfo(): void {
    if (!this.isShowImageAnalyzer && this.viewModel.isVideo()) {
      Log.info(TAG, 'isShowImageAnalyzer is false return');
      return;
    }
    FaceBeautyHelper.isBeauty(this.item).then((state: string) => {
      if (state !== FaceBeautyConstants.AI_FAILURE_FACE_BEAUTY_STATE) {
        this.item.beautyState = state;
        Log.info(TAG, `requestFaceBeautyInfo is ${this.item.beautyState}`);
      }
    });
  }

  private changeStringIfEditor() {
    this.isEditor = false
    /* instrument ignore next */
    if (this.replaceUriManager?.hasReplaceMediaItem(this.mediaResult.item)) {
      let media: MediaItem | undefined = this.replaceUriManager?.getReplaceMediaItem(this.mediaResult.item)
      if (!media) {
        return
      }
      this.editorImageUri = media.uri;
      this.isEditor = true;
      if (this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        this.ratio = ImageUtil
          .calcRatio({
            width: this.replaceUriManager?.getReplaceMediaItem(this.item)?.width ?? this.item.width,
            height: this.replaceUriManager?.getReplaceMediaItem(this.item)?.height ?? this.item.height,
          } as image.Size);
        if (this.isThird) {
          let areaRatio: number = ImageUtil.calcRatio({
            width: this.imageComponentWidth || 0,
            height: this.imageComponentHeight || 0
          } as image.Size);
          this.isThirdJustifyWidth = this.ratio > areaRatio;
        }
        return;
      }
      this.editorImageUri = media.uri;
      this.imageShowStringSource = media.uri;
      this.stringImageModifier.attribute?.visibility(Visibility.Visible);
      this.pixmapImageModifier.attribute?.visibility(Visibility.Hidden);
      Log.info(TAG, `imageShowStringSource: ${this.imageShowStringSource}`);
    } else {
      if (this.imageShowPixMapSource) {
        this.imageShowSourceOpacity = 1;
      } else {
        this.imageShowStringSource = this.getActualStringImage();
      }
    }
  }

  private initMediaResult(): void {
    getScreen().on(ScreenManager.ON_WIN_MODE_CHANGE, this.onWinModeChangedFunc);
    if (!this.isRunningAnimation) {
      this.aiDelay = false;
    }
    if (this.mediaResult.item) {
      this.item = this.mediaResult.item;
    }
    if (this.mediaResult.item) {
      this.item = this.mediaResult.item;
    }
    Log.info(TAG, `aboutToAppear ${this.item.uri}, item.width: ${this.item.width}, item.height: ${
      this.item.height}, ${getScreen().getDetailShow()}, isThird: ${this.isThird},` +
      `isVideo:${this.viewModel.isVideo()}, winWidth: ${this.viewModel.windowLayoutWidth}, winHeight: ${
      this.viewModel.windowLayoutHeight}`);
    if (this.mediaResult.pos != undefined) {
      this.mPosition = this.mediaResult.pos;
      this.viewModel.updatemPosition(this.mediaResult.pos);
      this.appBroadCast.emit(BroadCastConstants.CAST_POSITION_CHANGED + this.src, [this.mPosition]);
    }
    if (this.mediaResult.item?.getPosition) {
      this.mediaPosition = this.mediaResult.item.getPosition();
    }
    Log.info(TAG, "initMediaResult: " + this.mediaResult.thumbnail?.url + " " + this.thumbnail.url);
    if (this.mediaResult.thumbnail) {
      if (PhotoConfig.isFromMeetime) {
        /* instrument ignore next */
        this.thumbnail = this.mediaResult.thumbnail;
      } else {
        this.thumbnail = this.dataSource?.photoDataAdapter.getThumbnail(this.item) ?? new Thumbnail;
      }
    }
    Log.info(TAG, `aboutToAppeargetCurrentIndex ${this.viewModel.getCurrentIndex()}, this.mediaResult.pos: ${this.mediaResult.pos}`);
    this.updateIsCurrent();
    if (this.mediaResult.orientation != undefined) {
      this.orientation = this.mediaResult.orientation;
    }
    this.imageShowSource = this.getActualImage();
    this.imageShowPixMapSource = this.getActualPixelMapImage();
    this.changeStringIfEditor();

    this.isRequestOriginLoading = false;
    if (!this.mIsCurrent) {
      this.imageStringSourceOpacity = 1;
    }
    this.curNewSearchWords = '';
    this.curOcrSearchWords = '';
    return;
  }

  aboutToAppear(): void {
    /* instrument ignore next */
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().subscribe(this.foldDataChangeListener);
    }
    if (!this.isDownloading) {
      this.downloadProgress = 0;
    }
    AppStorage.setOrCreate(IS_THIRD_PICKER, this.isThird);
    this.userId = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY)?.userId ?? -1;
    ShortCut.isInPhotoItem = true;
    this.eventPipeline = new EventPipeline(this.broadCast, this.mediaResult.item ?? this.item, this, this.isSubScreen, this.imageToolInnerState);
    this.viewModel.onCreate({
      item: this.mediaResult.item ?? this.item,
      isHorizontal: this.isHorizontal,
      isThird: this.isThird,
      isInSelectedMode: this.isInSelectedMode,
      isShowBar: this.isShowBar,
      eventPipeline: this.eventPipeline,
      /* instrument ignore next */
      uiContext: this.getUIContext(),
      onScaleAnimationEnd: (scale: number) => {
        this.handleActionEnd(scale);
      },
      onPhotoChanged: () => {
        this.updateIsCurrent();
        this.onPhotoChanged();
      },
      updateAnalyzerVisibility: () => {
      },
      onIsOnSwiperAnimation: () => {
        this.isDoGestureSwipeWatchFunc();
        this.onIsOnSwiperAnimation();
      },
      setIsRunningAnimationFunc: this.setIsRunningAnimationFunc,
      onEnterStartAnim: this.playEnterAnimationSyncFunc,
      onEnterEndAnim: this.playEnterEndAnimationSyncFunc,
      onExitStartAnim: this.playExitAnimationSyncFunc,
      onExitEndAnim: this.playExitEndAnimationSyncFunc,
      updateTargetPullHeight: (imageTargetPullHeight: number) => {
        this.updateTargetPullHeight(imageTargetPullHeight)
      },
      browserAnimController: this.browserAnimController,
    });
    this.initMediaResult();
    this.highlightWords = this.curNewSearchWords || this.curOcrSearchWords || this.curHiSearchWords || '';
    this.shootingMode = this.item.getShootingMode();
    this.initIfVideo();
    this.canPullingUp = true;
    Log.debug(TAG, `this.curNewSearchWords: ${this.curNewSearchWords}, this.curOcrSearchWords: ${this.curOcrSearchWords},
     this.hiSearchWords: ${this.curHiSearchWords}, this.highlightWords: ${this.highlightWords}`);
    this.viewModel.setIsOnlyShowProperties(getScreen().getDetailShow());
    WindowUtil.prepareWinRouter();
    this.viewModel.maxScale = this.eventPipeline.maxScale;
    this.defaultScale = this.eventPipeline.defaultScale;
    if (!DeviceInfo.isPc() && !DeviceInfo.isTv() && this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.rotateController = new RotateController(this.calcBarBottomHeightFunc);
      this.rotateController?.init(this.item, this.videoRealWidth, this.videoRealHeight, this.isShowBar);
      this.setRotateButtonOffset();
    }
    this.eventPipeline.setCanPullingUp(this.canPullingUp);
    this.viewModel.updatePipelinePullingUpStatus();
    this.eventPipeline.setSwipeStatus(false);
    this.isPhotoScaled = false;
    this.firstLoad = true;
    /* instrument ignore next */
    this.eventPipelineSizeChangeFunc = (): void => this.eventPipelineSizeChange();
    this.isEditorBack = false;
    this.isHighQualityFirst = this.item.isHighQuality;
    this.viewModel.initCalcClipWidth();
    this.registerBroadcast();
    this.viewModel.initSaliencyImageCenter();
    if (!this.mIsCurrent) {
      this.onTransitionChange();
    }
    this.onViewDataChanged();
    this.updateListCardWidth();
    this.onPhotoChanged();
    this.updateGeometryIdIfNeeded();
    let matrix: Matrix4.Matrix4Transit | undefined =
      LocalStorage.getShared()?.get<Matrix4.Matrix4Transit>(BrowserConstants.MATRIX);
    if (this.mIsCurrent && matrix) {
      /* instrument ignore next */
      this.matrix = matrix;
      /* instrument ignore next */
      this.updatePhotoScaledStatus();
    }
    this.appBroadCast.emit(BroadCastConstants.CAST_POSITION_CHANGED + this.item.uri, [this.mPosition]);
    if (LocalStorage.getShared()?.get<Context>(Constants.PHOTO_PICKER_SESSION_KEY) ||
    LocalStorage.getShared()?.get<Context>('geometryEnable')) {
      this.geometryTransitionId = this.geometryId;
    }
    Log.info(TAG, `aboutToAppear ${this.item.uri} end, isPullingDown is ${this.isPullingDown}`);
    this.viewModel.onResetPullingUpState();
    this.initImageTool();
    this.imageOnCompleteTimer = setTimeout((): void => {
      Log.error(TAG, `image onComplete timeout ${this.thumbnail?.url}`);
    }, this.timerDuration);
    this.appBroadCast.on(BroadCastConstants.PHOTO_BROWSER_ACTIVE, this.browserActiveCallback);
    this.appBroadCast.on(BroadCastConstants.SHARE_IS_SHOW_PLAY_BUTTON, this.shareIsShowPlayButtonFunc);
    this.broadCast.on(BroadCastConstants.REPLACE_PHOTO_PICKER_PREVIEW, this.replaceUriFunc);
    this.appBroadCast.on(BroadCastConstants.IS_CLICK_REMOVE_OR_HIDDEN_DIALOG, this.isClickRemoveOrHiddenDialogFunc);
    this.appBroadCast.on(BroadCastConstants.SHOW_FAST_PLAY_LABEL, this.showFastPlayLabelFunc);
    this.appBroadCast.on(BroadCastConstants.IS_MOVING_PHOTO_LONG_PRESS_ON, this.isMovingPhotoLongPressOnFunc);
    Log.info(TAG,
      `aboutToAppear init isHorizontal:${this.isHorizontal}, isFoldExpanded:${this.isFoldExpanded},` +
        ` isFoldable:${DeviceInfo.isFoldable()}, uri:${ReportToBigDataUtil.urlAnonymize(this.item?.uri)},` +
        ` index:${this.item.index}, mPosition: ${this.mPosition},currentIndex:${this.viewModel.getCurrentIndex()}` +
        ` name:${StringUtil.garbleExtFileName(this.item?.displayName)}, detailTime:${this.item?.getDetailTime?.()}, ` +
        ` dateTaken:${this.item?.getDateTaken?.()} shootingMode:${this.item?.getShootingMode()};`);
    if (this.viewModel.isVideo()) {
      this.endRatio = this.videoRatio;
    }
    // 单属性创建需要在动画之后
    this.viewModel.createAttributeModifier();
    this.viewModel.setImagePixMap = this.setImagePixMap;
    Log.info(TAG, `aboutToAppear currentState = ${this.viewModel.getStateMachine().getCurrentState()?.stateName}`);
    Log.info(TAG, `aboutToAppear dataSource: ` + this.dataSource);
  }

  private setImagePixMap: () => void = (): void => {
    Log.info(TAG, `setImagePixMapAndString, mediaPosition:${this.item.getPosition()} index: ${this.mPosition}}`)
    if (!this.imageShowPixMapSource) {
      this.setImagePixMapAndString();
    }
    this.onVisibilityChange(true);
  }

  private initIfVideo(): void {
    if (this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO && this.mPosition !== -1) {
      Log.info(TAG,
        `[videoPlayer] initIfVideo prepare calculate xComponent size.video width: ${this.item.coverWidth}, height: ${this.item.coverHeight}, src: ${this.item.uri}`);
      let coverRadio =
        Math.floor(((this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.coverWidth ?? 0 :
        this.item.coverWidth) /
          (this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.coverHeight ?? 1 :
          this.item.coverHeight)) * ONE_HUNDRED) / ONE_HUNDRED;
      let videoRadio = Math.floor(((this.isEditor ?
        this.replaceUriManager?.getReplaceMediaItem(this.item)?.width ?? 0 :
      this.item.width) /
        (this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.height ?? 1 : this.item.height)) *
        ONE_HUNDRED) / ONE_HUNDRED;
      if (coverRadio === videoRadio) {
        this.videoRealWidth =
          this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.width ?? 0 : this.item.width;
        this.videoRealHeight =
          this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.height ?? 0 : this.item.height;
      } else {
        /* instrument ignore next */
        this.videoRealWidth = this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.coverWidth ??
          0 :
          /* instrument ignore next */
        this.item.coverWidth;
        /* instrument ignore next */
        this.videoRealHeight =
          this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.coverHeight ?? 0 :
          this.item.coverHeight;
      }
      this.src = this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.uri ?? '' : this.item.uri;
      this.videoDuration =
        this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.duration ?? 0 : this.item.duration;
      this.videoRatio = ImageUtil.calcRatio({ width: this.videoRealWidth, height: this.videoRealHeight } as image.Size);
      Log.info(TAG, `initIfVideo, coverRadio:${coverRadio}, videoRadio:${videoRadio}, uri:${this.item.uri}`)
    }
  }
  /* instrument ignore next */
  private isFloatingSmallSize(): boolean {
    if (getScreen().getWinWidth() < getScreen().getWinHeight()) {
      return true;
    }
    return false;
  }

  private isTabletSamllFloating(): boolean {
    if (DeviceInfo.isTablet() && this.windowStatus === window.WindowStatusType.FLOATING &&
      !this.windowPcmodeSwitchStatus && this.isFloatingSmallSize()) {
      /* instrument ignore next */
      return true;
    }
    return false;
  }

  private registerUriBroadcast(): void {
    this.isDelayRegisterUriBroadcast = false;
    Log.info(TAG, `registerUriBroadcast uri = ${ImageUtil.encryptThumbnailUri(this.item.uri)} uniqueId = ${this.item.uniqueId}`);
    this.appBroadCast.on(BroadCastConstants.DOWNLOAD_ORIGIN_PHOTO_RESULT + this.item.uri,
      this.downloadOriginPhotoResultFunc);
    this.broadCast.on(BrowserConstants.RESET_DEFAULT_SCALE + this.item.uri, this.resetDefaultScaleFunc);
    // 防止重复注册，重复注册会导致callBack函数多次执行，且需要多次取消注册
    if (!this.broadCast.has(BroadCastConstants.ANIMATE_TO_POSITION + this.item.uri)) {
      this.broadCast.on(BroadCastConstants.ANIMATE_TO_POSITION + this.item.uri, this.animateToPositionFunc);
    }
    this.broadCast.on(BroadCastConstants.RESET_POSITION + this.item.uniqueId, this.resetPositionFunc);
    this.broadCast.on(BroadCastConstants.JUMP_TO_BURST + this.item.uri, this.resetMatrixFunc);
    this.broadCast.on(PhotoDataAdapter.EVENT_THUMBNAIL_LOADED_PREFIX + this.item.uniqueId, this.thumbnailLoadedFunc);
    this.appBroadCast.on(BroadCastConstants.FIRST_CLICK_TO_PLAY_VIDEO + this.item.uri, this.handlePauseClickFunc);
    this.broadCast.on(BrowserConstants.OPEN_CLICK_DETAIL_PULLING_UP + this.item.uniqueId,
      this.openClickDetailPullingUpAnimationFunc);
    this.broadCast.on(BrowserConstants.CLOSE_CLICK_DETAIL_PULLING_UP + this.item.uniqueId,
      this.closeClickDetailPullingUpAnimationFunc);
    this.broadCast.on(BrowserConstants.CLOSE_CLICK_DETAIL_BY_BACK_PRESS + this.item.path,
      this.closeClickDetailByBackPressFun);
    this.broadCast.on(BrowserConstants.PHOTO_RESET_ROTATION + this.item.uniqueId,
      this.resetPhotoDefaultRotationFun);
  }

  private registerBroadcast() {
    if (this.dataSource) {
      this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFunc);
    }

    this.isDelayRegisterUriBroadcast = !this.item.uri || !this.item.uniqueId;
    if (!this.isDelayRegisterUriBroadcast) {
      this.registerUriBroadcast();
    }
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    this.broadCast.on(BroadCastConstants.RESET_TO_IMAGE_SLIDE_INIT_STATE, this.resetToImageSlideInitStateFunc);
    this.broadCast.on(BroadCastConstants.RESET_IMAGE_SLIDE_INIT_STATE, this.resetImageSlideInitStateFunc);
    this.broadCast.on(BroadCastConstants.CHANGE_LOADING_STATUS, this.changeLoadingStatusFunc);
    this.appBroadCast.on(BroadCastConstants.CHANGE_IMAGE_LOADING, this.setImageLoadingFunc);
    this.broadCast.on(BrowserConstants.CLOSE_CLICK_DETAIL_BY_BACK_PRESS, this.closeClickDetailByBackPressFun);
    this.broadCast.on(BrowserConstants.SAVE_SCALE, this.saveScaleFunc);
    this.appBroadCast.on(BrowserConstants.LOAD_YUV_PIXEL_MAP, this.loadYuvPixelMapFunc);
    this.appBroadCast.on(BrowserConstants.SET_IS_SUPPORTED_VIDEO_TYPE, this.setIsSupportedVideoTypeFunc);
    this.appBroadCast.on(BrowserConstants.UPDATE_CARD_WIDTH, this.emitUpdateCardWidthFun);
    this.appBroadCast.on(BrowserConstants.SET_IMAGE_SIZE_WHEN_ZERO, this.setImageSizeWhenZeroFunc);
    this.appBroadCast.on(BrowserConstants.SET_VIDEO_COMPONENT_SIZE, this.setXComponentSizeFunc);
    this.appBroadCast.on(BrowserConstants.SET_VIDEO_RATIO, this.setVideoRatioFunc);
    this.appBroadCast.on(BrowserConstants.SET_VIDEO_REAL_SIZE, this.setVideoRealSizeFunc);
    this.appBroadCast.on(BrowserConstants.ITEM_BLUR_CHANGE, this.itemBlurChangeFunc);
    this.appBroadCast.on(BrowserConstants.CLICK_BACK_PRESS, this.clickBackPress);
    this.viewModel.registerBroadCast(this.appBroadCast);
    this.appBroadCast.on(BrowserConstants.CONTINUE_PLAY_FROM_SUB_SCREEN, this.continuePlayFromSubScreen);
    this.appBroadCast.on(BrowserConstants.MOVING_PHOTO_ON_COMPLETE, this.movingPhotoOnCompleteFunc);
    this.appBroadCast.on(BrowserConstants.PHOTO_PHOTO_BACK_PRESS, this.backPressEventFunc);
    this.appBroadCast.on(BroadCastConstants.RECOVER_SHOW_RESOURCE, this.recoverImageShowSourceFunc);
    this.appBroadCast.on(BroadCastConstants.EDITOR_SAVE_BACK_PHOTOITEM, this.editorBackPhotoItemFunc);
    this.appBroadCast.on(BroadCastConstants.CAST_UPDATE_POSITION + this.item.uri, this.updateCastMPosition);
    this.broadCast.on(BrowserConstants.DATA_SIZE_CHANGED, this.onDataSizeChangedFunc);
  }

  private unRegisterBroadcast() {
    if (this.dataSource) {
      this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFunc);
    }
    this.broadCast.off(BroadCastConstants.RESET_TO_IMAGE_SLIDE_INIT_STATE, this.resetToImageSlideInitStateFunc);
    this.broadCast.off(BroadCastConstants.RESET_IMAGE_SLIDE_INIT_STATE, this.resetImageSlideInitStateFunc);
    this.broadCast.off(BrowserConstants.RESET_DEFAULT_SCALE + this.item.uri, this.resetDefaultScaleFunc);
    this.broadCast.off(BrowserConstants.OPEN_CLICK_DETAIL_PULLING_UP + this.item.uniqueId,
      this.openClickDetailPullingUpAnimationFunc);
    this.broadCast.off(BrowserConstants.CLOSE_CLICK_DETAIL_PULLING_UP + this.item.uniqueId,
      this.closeClickDetailPullingUpAnimationFunc);
    this.broadCast.off(BrowserConstants.CLOSE_CLICK_DETAIL_BY_BACK_PRESS + this.item.path,
      this.closeClickDetailByBackPressFun);
    this.broadCast.off(BrowserConstants.CLOSE_CLICK_DETAIL_BY_BACK_PRESS, this.closeClickDetailByBackPressFun);
    this.broadCast.off(BrowserConstants.PHOTO_RESET_ROTATION + this.item.uniqueId,
      this.resetPhotoDefaultRotationFun);
    /* instrument ignore next */
    this.closeClickDetailByBackPressFun = (): void => {
    };
    this.broadCast.off(BroadCastConstants.CHANGE_LOADING_STATUS, this.changeLoadingStatusFunc);
    this.appBroadCast.off(BroadCastConstants.DOWNLOAD_ORIGIN_PHOTO_RESULT + this.item.uri,
      this.downloadOriginPhotoResultFunc);
    this.broadCast.off(BroadCastConstants.ANIMATE_TO_POSITION + this.item.uri, this.animateToPositionFunc);
    this.broadCast.off(BroadCastConstants.RESET_POSITION + this.item.uniqueId, this.resetPositionFunc);
    this.broadCast.off(BroadCastConstants.JUMP_TO_BURST + this.item.uri, this.resetMatrixFunc);
    this.broadCast.off(BrowserConstants.SAVE_SCALE, this.saveScaleFunc);
    this.broadCast.off(PhotoDataAdapter.EVENT_THUMBNAIL_LOADED_PREFIX + this.item.uniqueId, this.thumbnailLoadedFunc);
    this.appBroadCast.off(BroadCastConstants.CHANGE_IMAGE_LOADING, this.setImageLoadingFunc);
    this.appBroadCast.off(BrowserConstants.LOAD_YUV_PIXEL_MAP, this.loadYuvPixelMapFunc);
    this.appBroadCast.off(BrowserConstants.SET_IS_SUPPORTED_VIDEO_TYPE, this.setIsSupportedVideoTypeFunc);
    this.appBroadCast.off(BrowserConstants.UPDATE_CARD_WIDTH, this.emitUpdateCardWidthFun);
    this.appBroadCast.off(BrowserConstants.SET_IMAGE_SIZE_WHEN_ZERO, this.setImageSizeWhenZeroFunc);
    this.appBroadCast.off(BrowserConstants.SET_VIDEO_COMPONENT_SIZE, this.setXComponentSizeFunc);
    this.appBroadCast.off(BrowserConstants.SET_VIDEO_RATIO, this.setVideoRatioFunc);
    this.appBroadCast.off(BrowserConstants.SET_VIDEO_REAL_SIZE, this.setVideoRealSizeFunc);
    this.appBroadCast.off(BrowserConstants.ITEM_BLUR_CHANGE, this.itemBlurChangeFunc);
    this.appBroadCast.off(BrowserConstants.CLICK_BACK_PRESS, this.clickBackPress);
    this.viewModel.unRegisterBroadCast(this.appBroadCast);
    this.appBroadCast.off(BrowserConstants.CONTINUE_PLAY_FROM_SUB_SCREEN, this.continuePlayFromSubScreen);
    this.appBroadCast.off(BrowserConstants.MOVING_PHOTO_ON_COMPLETE, this.movingPhotoOnCompleteFunc);
    this.appBroadCast.off(BrowserConstants.PHOTO_PHOTO_BACK_PRESS, this.backPressEventFunc);
    this.appBroadCast.off(BroadCastConstants.FIRST_CLICK_TO_PLAY_VIDEO + this.item.uri, this.handlePauseClickFunc);
    this.appBroadCast.off(BroadCastConstants.RECOVER_SHOW_RESOURCE, this.recoverImageShowSourceFunc);
    this.appBroadCast.off(BroadCastConstants.EDITOR_SAVE_BACK_PHOTOITEM, this.editorBackPhotoItemFunc);
    this.appBroadCast.off(BroadCastConstants.CAST_UPDATE_POSITION + this.item.uri, this.updateCastMPosition);
    this.broadCast.off(BrowserConstants.DATA_SIZE_CHANGED, this.onDataSizeChangedFunc);
  }

  private onDataSizeChanged(size: number): void {
    this.changTransitionId = (size !== 0);
    Log.info(TAG, `DataSizeChanged, size is ${size} and changTransitionId is ${this.changTransitionId}`);
  }

  private itemBlurChange(): void {
    animateTo({
      duration: BrowserConstants.BLUR_DURATION,
      curve: Curve.Sharp,
      onFinish: () => {
        this.itemBlur = BrowserConstants.INIT_BLUR_VALUE;
      },
      delay: BrowserConstants.BLUR_DELAY,
    }, () => {
      this.itemBlur = BrowserConstants.MAX_BLUR_VALUE;
    })
  }
  /* instrument ignore next */
  private async loadYuvPixelMap(pixelMap: PixelMap): Promise<void> {
    Log.info(TAG, `requestQuickImage resulet : ${pixelMap}`)
    if (!pixelMap) {
      return;
    }
    if (this.item?.orientation !== 0) {
      await pixelMap.rotate(this.item.orientation);
    }
    this.thumbnail.yuvPixelMap = pixelMap;
    pixelMap.getImageInfo().then((value: image.ImageInfo) => {
      if (value) {
        Log.info(TAG,
          `RequestQualityTask imageInfo width: ${value.size?.width}, height : ${value.size?.height}, pixelFormat : ${
          value.pixelFormat}, orientation : ${this.item?.orientation} `);
      }
    })
  }

  /* instrument ignore next */
  private async requestQualityImage(index?: number): Promise<void> {
    let imageIndex = index ?? this.viewModel.getCurrentIndex();
    Log.info(TAG,
      `request quality image condition: ${this.item.uri} && ${this.mIsCurrent} && ${index} && ${this.viewModel.getCurrentIndex()} && ${this.mPosition}`);
    if (!this.checkRequestQuality(imageIndex)) {
      Log.info(TAG, 'request quality image, check fail');
      return;
    }
    if (this.mediaResult?.thumbnail?.pixelMap) {
      Log.info(TAG, 'request quality image, already exits');
      return;
    }
    const asset: photoAccessHelper.PhotoAsset | undefined = await this.generateCurrentPhotoAsset();
    if (!asset) {
      Log.error(TAG, 'request quality image, current photoAsset is not exist');
    }
    this.dataHandler = {
      onDataPrepared(data: image.Picture, imageSource: image.ImageSource): void {
        Log.info(TAG, `onDataPrepared called : ${ReportToBigDataUtil.urlAnonymize(asset?.uri ?? '')}`);
        if (!data) {
          Log.error(TAG, 'fail to request yuv image');
          return;
        }
        let pixelMap: image.PixelMap = data?.getMainPixelmap();
        if (!pixelMap) {
          Log.error(TAG, 'getStubPixelMap to request quality image');
          return;
        }
        BroadCastManager.getInstance().getBroadCast().emit(BrowserConstants.LOAD_YUV_PIXEL_MAP, [pixelMap]);
        Log.info(TAG, 'success to request quality image');
      }
    }

    const costTime: number = await RequestQualityTask.requestQuickImage(getContext(this), asset, this.dataHandler);
    this.costReportManager.requestImage(costTime);
  }

  /* instrument ignore next */
  private checkRequestQuality(currentShowImageIndex: number): boolean {
    if (this.isPreviewListScrolling) {
      Log.error(TAG, 'checkRequestQuality isPreviewListScrolling')
      return false;
    }
    if (this.thumbnail.pixelMap) {
      Log.error(TAG, 'checkRequestQuality pixelMap exist')
      return false;
    }
    if (this.thumbnail.yuvPixelMap) {
      Log.error(TAG, 'checkRequestQuality yuvPixelMap exist')
      return false;
    }
    if (!MediaLibraryData.isMediaLibraryUri(this.item.uri)) {
      Log.error(TAG, 'checkRequestQuality not media source')
      return false;
    }
    if (this.viewModel.isVideo()) {
      Log.error(TAG, 'checkRequestQuality video')
      return false;
    }
    if (this.item?.getPosition() === UserFileManagerAccess.FILE_LOCATION_CLOUD) {
      Log.error(TAG, 'checkRequestQuality cloud source')
      return false;
    }
    if (this.mPosition !== currentShowImageIndex) {
      Log.error(TAG, 'checkRequestQuality mPosition fail')
      return false;
    }
    return true;
  }

  /* instrument ignore next */
  private async generateCurrentPhotoAsset(): Promise<photoAccessHelper.PhotoAsset | undefined> {
    // 正常大图浏览
    const photoDataImpl: PhotoDataImpl | undefined = this.dataSource?.getPhotoDataImpl();
    return await photoDataImpl?.getSinglePhotoAsset(this.item.uri);
  }

  /* instrument ignore next */
  animateToPosition(src: RectValue, dst: RectValue, duration: number, onAnimationFinished: Function,
    showPreview: Function): void {
    Log.info(TAG, `animateToPosition ${this.item.uri}: ${JSON.stringify(src)} => ${JSON.stringify(dst)}`);
    this.angle = 0;
    if (src) {
      this.matrix = this.calcMatrixOfRect(src);
    }
    let matrixTo = this.calcMatrixOfRect(dst);
    // 比动效早10ms显示预览区，避免黑闪
    this.timer && clearTimeout(this.timer);
    this.timer = setTimeout(() => {
      showPreview();
    }, duration - 10);
    this.isInAnimateToPosition = true;
    performanceMonitor.begin('ANIMATE_TO_POSITION', performanceMonitor?.ActionType.LAST_UP);
    this.viewModel.stackModifier?.attribute?.transform(this.matrix);
    animateTo({
      duration: duration,
      curve: Curve.Friction,
      onFinish: (): void => {
        performanceMonitor.end('ANIMATE_TO_POSITION');
        Log.info(TAG, 'animateToPosition finished');
        if (!dst) {
          // 动画到初始位置时才可显示播放按钮
          this.isInAnimateToPosition = false;
          this.eventPipeline?.reset();
          this.calculateImagePos();
          // 画中画变量重新初始化
          this.initImageTool();
        }
        // 大图旋转回0度
        this.angle = 0;
        // 旋转后eventPipeLine变量更新
        this.eventPipeline?.onRotateEnd(this.angle);
        this.rotateValue = 0;
        this.isInRotateState = false;
        this.requestFaceBeautyInfo();
        onAnimationFinished();
        this.onVisibilityChange();
      }
    }, (): void => {
      if (this.angle != 0) {
        this.angle = PhotoRotateUtil.getRecentZero(this.angle);
        this.calculateImagePos();
        Log.info(TAG, `Enter editorPage rotate angle:${this.angle}`);
      }
      this.matrix = matrixTo;
    });
  }

  /* instrument ignore next */
  resetPosition(): void {
    this.matrix = Matrix4.identity().copy();
    this.viewModel.stackModifier?.attribute?.transform(this.matrix);
  }

  /* instrument ignore next */
  resetMatrix(callBack: Function): void {
    animateTo({
      curve: this.doubleTapCurves,
      onFinish: (): void => {
        callBack();
      }
    }, (): void => {
      this.matrix = Matrix4.identity().copy();
    })
    this.verifyPhotoScaled?.(this.matrix);
    this.updatePhotoScaledStatus();
  }

  /**
   * 计算将图片完整显示到指定位置时所需的matrix
   * @param rect 完整显示的指定位置
   * @returns 所需的matrix
   */
  /* instrument ignore next */
  calcMatrixOfRect(rect: RectValue): Matrix4.Matrix4Transit {
    let matrixTo = Matrix4.identity().copy();
    if (rect) {
      let origin = this.calculateImageAbsolutePos(true);
      matrixTo.scale({
        x: rect.width / origin.width,
        y: rect.height / origin.height,
      });
      matrixTo.translate({
        x: (rect.x + rect.width / HALF_DIVIDER) - (origin.x + origin.width / HALF_DIVIDER),
        y: (rect.y + rect.height / HALF_DIVIDER) - (origin.y + origin.height / HALF_DIVIDER),
      });
    }
    return matrixTo;
  }

  eventPipelineSizeChange(): void {
    if (this.isThird) {
      /* instrument ignore next */
      this.eventPipeline?.onComponentSizeChanged(vp2px(this.imageComponentWidth), vp2px(this.imageComponentHeight));
    } else {
      this.eventPipeline?.onComponentSizeChanged(vp2px(this.viewModel.windowLayoutWidth),
        vp2px(this.viewModel.windowLayoutHeight));
    }
  }

  aboutToDisappear(): void {
    this.releaseFastPixmap();
    this.viewModel.onDestroy();
    this.dataHandler = null;
    if (DeviceInfo.isGRLFoldScreen()) {
      /* instrument ignore next */
      FoldUtil.getInstance().unSubscribe(this.foldDataChangeListener);
    }
    getScreen().off(ScreenManager.ON_WIN_MODE_CHANGE, this.onWinModeChangedFunc);
    this.appBroadCast.off(BroadCastConstants.PHOTO_BROWSER_ACTIVE, this.browserActiveCallback);
    this.appBroadCast.off(BroadCastConstants.IS_CLICK_REMOVE_OR_HIDDEN_DIALOG, this.isClickRemoveOrHiddenDialogFunc);
    this.appBroadCast.off(BroadCastConstants.SHARE_IS_SHOW_PLAY_BUTTON, this.shareIsShowPlayButtonFunc);
    this.broadCast.off(BroadCastConstants.REPLACE_PHOTO_PICKER_PREVIEW, this.replaceUriFunc);
    this.appBroadCast.off(BroadCastConstants.SHOW_FAST_PLAY_LABEL, this.showFastPlayLabelFunc);
    this.appBroadCast.off(BroadCastConstants.IS_MOVING_PHOTO_LONG_PRESS_ON, this.isMovingPhotoLongPressOnFunc);
    UiUtil.setBundleNameValue(false, LocalStorage.getShared());
    Log.info(TAG, `aboutToDisappear ${this.item.uri}`);
    if (this.isVideoDownloading) {
      /* instrument ignore if */
      if (!this.item) {
        Log.error(TAG, 'downloading photo item is null');
      }
    }
    clearTimeout(this.imageOnCompleteTimer);
    clearTimeout(this.panelTimer);
    this.isLoading = false;
    this.isRequestOriginLoading = false;
    this.dataSource?.releaseCachedMediaResult(this.mediaResult);
    if (this.dataSource?.totalCount() === 0) {
      /* instrument ignore next */
      AppStorage.setOrCreate<boolean>('isDoingDeleteBigPhotoAnim', false);
      /* instrument ignore next */
      AppStorage.setOrCreate<boolean>('isBigPhotoLeftToRightAnim', false);
    }
    if (this.mIsCurrent) {
      LocalStorage.getShared()?.delete(BrowserConstants.MATRIX);
      this.cameraSceneReset();
      Log.info(TAG, 'aboutToDisappear of current image');
    }
    if (this.aiDataPrepareTimer > 0) {
      /* instrument ignore next */
      clearTimeout(this.aiDataPrepareTimer);
      /* instrument ignore next */
      this.aiDataPrepareTimer = 0;
    }
    if (this.fastScrollModeTimer >= 0) {
      clearTimeout(this.fastScrollModeTimer);
      this.fastScrollModeTimer = -1;
    }
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedCallBack);
    /* instrument ignore next */
    this.onWinSizeChangedCallBack = (): void => {
    };
    this.rotateController?.deinit();
    this.isPullingDown = false;
    this.lcdPixelMapUpdate = false;
    this.promptActionShow = false;
    this.unRegisterBroadcast();
    ShortCut.isInPhotoItem = false;
    Log.info(TAG, `PhotoItem aboutToDisappear ${this.item.uri} end, isPullingDown is ${this.isPullingDown}`);
  }

  private cameraSceneReset() {
    if (!PhotoConfig.isLibrary()) {
      return;
    }
    Log.info(TAG, 'PhotoConfig is library, setting properties state to false');
    this.viewModel.setPropertiesState(false)
  }

  private onThumbnailLoaded(thumbnail: Thumbnail): void {
    let msg: string[] = ['onThumbnailLoaded isCurrent: ' + (this.mIsCurrent)];
    msg.push(`old: ${JSON.stringify(this.thumbnail)}`);
    msg.push(`new: ${JSON.stringify(thumbnail)}`);
    msg.push(`index${this.mPosition}`);
    Log.info(TAG, msg.join(', '));
    if (thumbnail?.equals(this.thumbnail) || !thumbnail) {
      return;
    }
    this.thumbnail?.release();
    this.thumbnail = thumbnail;
    Log.info(TAG, `onThumbnailLoaded isCurrent: ${this.mIsCurrent} ${JSON.stringify(this.thumbnail)}`);
    this.appBroadCast.emit(PhotoDataAdapter.EVENT_THUMBNAIL_LOADED_PREFIX + this.item.uniqueId, [thumbnail]);
  }

  onViewDataChanged(): void {
    if (this.eventPipeline == undefined || this.item == undefined) {
      return;
    }
    TraceControllerUtils.startTrace('onViewDataChanged PhotoItem');
    this.viewModel.item = this.item;
    if (!this.usePixmap && !this.isDefaultFA) {
      if (this.item.width === 0 || this.item.height === 0) {
        /* instrument ignore next */
        this.ratio = ImageUtil.calcRatio({
          width: this.imageCompleteWidth || 0,
          height: this.imageCompleteHeight || 0
        } as image.Size);
      } else {
        this.endRatio = this.isSubScreen ? 1 : ImageUtil
          .calcRatio({
            width: this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.width ?? this.item.width :
            this.item.width,
            height: this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.height ?? this.item.height :
            this.item.height
          } as image.Size);
        if (this.viewModel.getStateMachine().getCurrentState() !== PhotoBrowserExitAnimatingState.getInstance()) {
          this.ratio = this.endRatio;
        }
      }
    }
    if (this.isThird) {
      /* instrument ignore next */
      let areaRatio: number = ImageUtil.calcRatio({
        width: this.imageComponentWidth || 0,
        height: this.imageComponentHeight || 0
      } as image.Size);
      /* instrument ignore next */
      if (DeviceInfo.isPhoneUx() && !this.isMultiPick && this.ratio > this.pickerAreaRatio && this.ratio <= 1) {
        this.isThirdJustifyWidth = true;
      } else {
        this.isThirdJustifyWidth = this.ratio > areaRatio;
      }
    }
    Log.info(TAG, `onViewDataChanged-ratio:${this.ratio}-${this.imageCompleteWidth}-${this.imageCompleteHeight},
       this.item:${this.item.width}-${this.item.height}`);
    if (!this.firstLoad) {
      this.eventPipeline?.onDataChanged(this.item);
      TraceControllerUtils.finishTrace('onViewDataChanged PhotoItem');
      return;
    }

    this.updatePhotoScaledStatus();
    this.eventPipeline?.setDefaultScale(1);

    this.eventPipeline?.onDataChanged(this.item);
    this.firstLoad = false;
    Log.info(TAG, 'onViewDataChanged, index: ' + this.mPosition + ', usePixmap: ' + this.usePixmap +
      ', ratio: ' + this.ratio + ', thumbnail: ' + JSON.stringify(this.thumbnail));
    TraceControllerUtils.finishTrace('onViewDataChanged PhotoItem');
  }

  onTouchEventRespond(matrix: Matrix4.Matrix4Transit, isInPinch: boolean = false): void {
    if (this.isInBackPressEvent) {
      /* instrument ignore next */
      return;
    }
    Log.debug(TAG, `isRunningPinchAnimation:${this.isRunningPinchAnimation},` +
      `isRunningPanAnimation:${this.isRunningPanAnimation}`)
    if (this.isRunningPinchAnimation) {
      /* instrument ignore next */
      animateTo({
        duration: 0,
        curve: this.pinchAnimationCurves,
        onFinish: (): void => {
          this.isRunningPinchAnimation = false;
        }
        /* instrument ignore next */
      }, (): void => {
        this.matrix = matrix;
      })
    } else if (this.isRunningPanAnimation) {
      // 滑动走的这里
      animateTo({
        curve: Curves.springMotion(0.426, 1.01),
        onFinish: (): void => {
          this.isRunningPanAnimation = false;
        }
      }, (): void => {
        this.matrix = matrix;
        if (this.enableEnterInnerPic) {
          this.eventPipeline?.innerPicPanAnimationEnd();
        }
      })
    } else if (isInPinch) {
      this.matrix = matrix;
  
      if (this.mIsCurrent && this.viewModel.stackModifier?.attribute) {
        this.viewModel.stackModifier.attribute.transform(this.matrix);
      }
    } else {
      this.matrix = matrix;
    }
    this.updateAbleEnterInnerPic();

    // 在this.isInPinch为true时，不更新图片缩放状态标志位
    if (!this.isInPinch) {
      this.updatePhotoScaledStatus();
    }
  }

  onDirectionChangeRespond(direction: PanDirection): void {
    Log.info(TAG, `item: ${this.item.uri}, direction: ${direction}`);
    this.panOption.setDirection(direction);
  }

  /**
   * 点击详情按钮上滑拖出详情
   *
   */
  doOpenClickDetailPullingUpAnimation(): void {
    this.viewModel.setPropertiesState(true);
    this.onEventPullUpRespond();
    this.eventPipeline?.setSwipeStatus(false);
    this.isDoingImageSlideAnimation = true;
    this.isDoingSlideUpAnimation = true;
    this.viewModel.clipWidthPercentage = this.viewModel.clipWidthStartPercentage;
    this.eventPipeline?.resetTransitionStatus();
    this.updateAbleEnterInnerPic();
    this.viewModel.printSaliencyStatus(BigDataConstants.PHOTO_SALIENCY_CLICK_DETAIL);

    // 大图详情栏出现的动画
    animateTo({
      duration: Constants.DURATION_PHOTO_DETAIL_OPEN,
      curve: Curve.Friction,
      onFinish: (): void => {
        if (this.isDoingSlideUpAnimation) {
          this.isDoingImageSlideAnimation = false;
        }
        this.focusToDetailComponent();
        let msg: UriMsg = {
          uri: this.item.uri,
          type: BigDataConstants.PHOTO_DETAIL_CLICK,
        }
        ReportToBigDataUtil.report(BigDataConstants.PHOTO_DETAIL_OPEN_COUNT, msg);
      }
    }, (): void => {
      this.viewModel.toImageSlideTargetState();
    })
  }

  /**
   * 单击图片下滑收起详情
   *
   */
  doCloseClickDetailPullingUpAnimation(bYBackPress: boolean): void {
    this.isDoingImageSlideAnimation = true;
    this.isDoingSlideUpAnimation = false;
    this.controllerTextArea.stopEditing();
    this.controllerTextInput.stopEditing();
    this.controllerPortraitInput.stopEditing();
    animateTo({
      duration: Constants.DURATION_PHOTO_DETAIL_CLOSE,
      curve: Curve.Friction,
      onFinish: (): void => {
        this.isPhotoChangeLoading = false;
        this.isDoingImageSlideAnimation = false;
        if (this.isRunningAnimation) {
          /* instrument ignore next */
          Log.info(TAG, `doCloseClickDetailPullingUpAnimation onFinish: isRunningAnimation=true, 
            but isDoingImageSlideAnimation has been reset`);
          return;
        }
        if (!this.isDoingSlideUpAnimation && this.isDoingImageSlideAnimation) {
          /* instrument ignore next */
          this.viewModel.clipWidthPercentage = 1;
        }
      }
    }, (): void => {
      this.viewModel.initSaliencyImageSlide();
      this.viewModel.resetImageSlideInitState();
    })
    this.viewModel.setPropertiesState(false);
    this.broadCast.emit(BrowserConstants.SHOW_BARS, [$r('sys.color.comp_background_gray')]);
  }

  /**
   * 图片复位原大小回调，执行图片复位原大小动画
   * @param matrix 图片缩放矩阵
   */
  resetScaleAnimation(matrix: Matrix4.Matrix4Transit): void {
    if (this.eventPipeline?.isDefaultScale()) {
      return;
    }
      /* instrument ignore next */
    this.eventPipeline?.startAnimation(matrix);
    /* instrument ignore next */
    animateTo({
      duration: (this.animationOption as AnimationParam).duration,
      curve: (this.animationOption as AnimationParam).curve as Curve,
      onFinish: (): void => {
        this.eventPipeline?.onAnimationEnd(this.animationEndMatrix as Matrix4.Matrix4Transit);
        this.animationOption = undefined;
        this.animationEndMatrix = undefined;
      }
    },
      /* instrument ignore next */
      (): void => {
        this.matrix = this.animationEndMatrix as Matrix4.Matrix4Transit;
        this.updatePhotoScaledStatus();
      })
  }

  onAnimationEventRespond(animationOption: AnimationParam, animationEndMatrix: Matrix4.Matrix4Transit): void {
    Log.info(TAG, `onAnimationEventRespond: item=${this.item.uri}, animationOption=${JSON.stringify(animationOption)}, isFullMode=${this.isFullMode}`);
    this.animationOption = animationOption;
    this.animationEndMatrix = animationEndMatrix;
  }

  /**
   * 更新图片是否缩放状态标志位
   */
  updatePhotoScaledStatus(): void {
    let matrix: Matrix4.Matrix4Transit = this.matrix;
    if (matrix) {
      let mat: number[] | undefined = (matrix?.copy() as Matrix4x4).matrix4x4;
      if (mat) {
        let xScale: number = mat[0];
        let yScale: number = mat[5];
        Log.debug(TAG, `photo in PhotoItem has Scaled x scale: ${xScale}, y scale: ${yScale}, mat: ${mat}`);
        this.isPhotoScaled = (xScale != 1 || yScale != 1);
        this.rotateController?.setMatrix(matrix);
        this.setRotateButtonOffset();
      }
    /* instrument ignore else */
    } else {
      this.isPhotoScaled = false;
    }
    this.broadCast.emit(PHOTO_SCALED, [this.isPhotoScaled]);
  }

  onEventPullUpRespond(): void {
    if (MediaLibraryData.isMediaLibraryUri(this.item.uri) && this.mIsCurrent) {
      if (this.viewModel.isPropertiesShow()) {
        this.broadCast.emit(BrowserConstants.HIDE_BARS, [$r('sys.color.comp_background_gray')]);
      } else {
        this.broadCast.emit(BrowserConstants.SHOW_BARS, [$r('sys.color.comp_background_gray')]);
      }
    }
  }

  private getActualImage(): string | image.PixelMap | sendableImage.PixelMap | undefined {
    Log.info(TAG, `getActualImage loading Image : ${this.thumbnail?.url}`);
    if (this.isDefaultFA) {
      /* instrument ignore next  */
      return this.thumbnail?.url;
    }
    if (this.item.isGifOrWebpType()) {
      /* instrument ignore if  */
      if (this.userId > 0) {
        return this.item.uri + (this.item.uri.includes('?') ? '&' : '?') + 'user=' + this.userId;
      }
      /* instrument ignore next  */
      return this.item.uri;
    }
    if (!this.thumbnail) {
      // 大图加载thumbnail错误
      const msg: Record<string, number | string | boolean> = {
        'index': this.mPosition
      };
      ReportToBigDataUtil.errEventReport(BigDataConstants.BROWER_THUMBNAIL_LOAD_ERROR, msg);
      Log.error(TAG, `getActualImage thumbnail object is null, index=${this.mPosition}`);
      return undefined;
    }
    if (this.thumbnail.pixelMap) {
      /* instrument ignore next  */
      Log.info(TAG, `getActualImage pixelMap is not null, index=${this.mPosition}`);
      /* instrument ignore next  */
      return this.thumbnail.pixelMap as PixelMap;
    }
    if (this.thumbnail.yuvPixelMap) {
      /* instrument ignore next  */
      Log.info(TAG, `getActualImage yuvPixelMap is not null, index=${this.mPosition}`);
      /* instrument ignore next  */
      return this.thumbnail.yuvPixelMap;
    }
    // instruments ignore if
    if (ImageUtil.isExitTransparentChannelLocalImgMimeType(this.item)) {
      Log.info(TAG, `getActualImage transparent channel image, type=${this.item.mimeType}`);
      return '';
    }
    return this.thumbnail.url;
  }

  private getPlaceHolderImage(): string {
    Log.debug(TAG, `start loading placeHolder : ${this.thumbnail?.url}`);
    if (!this.item) {
      /* instrument ignore next  */
      Log.error(TAG, `Invalid item=${this.item}`);
      /* instrument ignore next  */
      return '';
    }
    if (ImageUtil.isExitTransparentChannelImgMimeType(this.item)) {
      /* instrument ignore next  */
      Log.info(TAG ,`${this.item.uri} transparent channel image ,place holder is astc`);
      return `${this.item.uri}?timestampApp=${this.item.getDateModified?.()}&oper=astc&path=${this.item.path}`;
    }
    if (this.item.path && this.item.getDateModified?.()) {
      Log.info(TAG ,`${this.item.uri} place holder is thumbnail`);
      return `${this.item.uri}?timestampApp=${this.item.getDateModified?.()}&oper=thumbnail&path=${this.item.path}`;
    }
    let placeholderUri: string | undefined = AppStorage.get<string>('placeholderForGeometryTransition');
      /* instrument ignore if */
    if (placeholderUri) {
      Log.info(TAG, `placeholderForGeometryTransition: ${placeholderUri}`);
      return placeholderUri;
    }
    if (this.item.uri) {
      Log.info(TAG ,`place holder is astc ${this.item.uri}?oper=astc&path=${this.item.path}` );
      return `${this.item.uri}?oper=astc&path=${this.item.path}`;
    }
  /* instrument ignore next  */
    Log.info(TAG ,`${this.item.uri} place holder is empty`);
    return '';
  }

  // 获取图片或视频的无障碍播报内容  
  /* instrument ignore next */
  private getImageItemGridAccessibilityText(): string {
    let text: string = '';
    if (this.item?.data) {
      let dateNumber = Number(AssetHelper.get(this.item.data,
        photoAccessHelper.PhotoKeys.DATE_ADDED_MS.toString()));
      let photoDate: string = DateUtil.getLocalizedDate(dateNumber);
      let timeAndLocation: string = DateUtil.getLocalizedTime(dateNumber);
      if (this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
        text = `${Rsc.toString($r('app.string.album_photos'))} ${(this.viewModel.getCurrentIndex() + 1)}, ${photoDate} ${
        timeAndLocation}`;
      } else if (this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        let videoDuration: string = DateUtil.getFormattedDurationForScreenReader(this.videoDuration ?? 0);
        text = `${Rsc.toString($r('app.string.album_video'))} ${this.viewModel.getCurrentIndex() + 1}, ${
        Rsc.toString($r('app.string.duration'))}${videoDuration}, ${photoDate} ${timeAndLocation}`;
      }
    }
    return text;
  }

  /**
   * 获取视频播放类型
   * 合入逐帧播放需求后，打开视频即自动播放；仅picker场景(isThird)、畅连场景(isFromMeetime)保留原始中央播放按钮，点击后才开始播放
   */
  private getPlayType(): PlayType {
    return (this.isThird ||
    PhotoConfig.isFromMeetime || !Global.getBoolean('autoPlayEnable') || this.isInSelectedMode) ?
    PlayType.CLICK_TO_PLAY : PlayType.AUTOPLAY;
  }

  /**
   * 获取进度条类型
   * 合入逐帧播放需求后，视频预览条合入list组件；仅picker场景(isThird)、畅连场景(isFromMeetime)使用原始线式进度条
   */
  private getProgressType(): LoadProgressType {
    return (this.isThird || PhotoConfig.isFromMeetime || this.isInSelectedMode) ? LoadProgressType.SLIDER :
    LoadProgressType.PREVIEW;
  }

  private getImageAnalysisStatus(): boolean {
    return false;
  }

  private getImageSource(): image.PixelMap | string | undefined {
    if (this.isEditorBack && EditorPhotoContext.getInstance().getNotifyHideEditor()) {
      this.imageShowStringSource = this.getActualStringImage();
    }
    if (this.isEditorBack) {
      return this.getImageShowStringSourceByTemper();
    }

    if (!this.isShowFastPixmap) {
      this.isShowFastPixmap = !!this.lastUri && !!this.fastPixmap &&
      StringUtil.isSamePhotoAsset(this.mediaResult.captureId, this.mediaResult.thumbnailUri,
        this.item.uri, this.lastUri) && !this.isEditorBack;
    }

    if (this.isShowFastPixmap) {
      /* instrument ignore next  */
      return this.fastPixmap;
    }

    if (this.item.thumbnailPixmap) {
      /* instrument ignore next  */
      return this.item.thumbnailPixmap;
    }

    return this.getImageShowStringSourceByTemper();
  }

  private getImageShowStringSourceByTemper(): string | undefined {
    if (this.imageShowStringSource === undefined) {
      Log.warn(TAG, `Failed to get image show string source by temper. isEditorBack:${this.isEditorBack}`);
      return undefined;
    }
    if (this.isEditor) {
      Log.info(TAG, `return this.imageShowStringSource`);
      return this.imageShowStringSource;
    }
    let newimageShowStringSource: string = this.imageShowStringSource;
    if (ImageDecodeUtils.isHighTemperatureControll()) {
      Log.info(TAG, `getImageSource LCD will decode by SDR`);
      newimageShowStringSource += `&decodeDynamicRange=${image.DecodingDynamicRange.SDR}`;
    }
    return newimageShowStringSource;
  }

  /**
   * 拦截手势检测
   * 对于非动效过程中的手势不拦截，对于动效过程中的下划和缩放手势不拦截
   */
  private detectGesture(gestureInfo: GestureInfo, event: BaseGestureEvent): boolean {
    Log.info(TAG, `do detectGesture: tag=${gestureInfo.tag}, isRunningAnimation=${this.isRunningAnimation}`);
    if (gestureInfo.tag == 'DoubleTap') {
      Log.info(TAG, 'detectGesture: always allow DoubleTap gesture');
      return true;
    }
    // 非动效过程中其它手势也不拦截
    if (!this.isRunningAnimation) {
      this.slipBackEnd = false;
      Log.info(TAG, 'detectGesture: not in animation, allow gesture');
      return true;
    }
    /* instrument ignore next */
    switch (gestureInfo.type) {
      // 缩放场景不拦截
      case GestureControl.GestureType.PINCH_GESTURE:
        Log.info(TAG, 'animation begin into pinch');
        return true;
      case GestureControl.GestureType.PAN_GESTURE:
        let panEvent = event as PanGestureEvent;
        const isMouseScrolling = panEvent.source === SourceType.Mouse && panEvent.sourceTool === SourceTool.MOUSE;
        Log.info(TAG, `panEvent offsetY: ${panEvent.offsetY}`);
        if (panEvent.offsetY >= 0) {
          // 下划场景不拦截
          Log.info(TAG, 'animation begin into pan slip');
          if (DeviceInfo.isPc()) {
            this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_BACK_PRESS_EVENT, [false, isMouseScrolling]);
            this.slipBackEnd = true;
          }
          return true;
        } else {
          // 上划场景拦截
          return false;
        }
      default:
        return false;
    }
  }

  private lcdDynamicRangeMode(): DynamicRangeMode {
    if (this.fastPixmap && !this.fastPixmap.getImageInfoSync()?.isHdr) {
      /* instrument ignore next  */
      return DynamicRangeMode.STANDARD;
    }
    return this.dynamicRange;
  }

  private getImageBackgroundColor(): void {
    if (!DeviceInfo.isSupportClosePNGBrowserBackGroundEnabled()) {
      return;
    }
    /* instrument ignore if  */
    if (!this.item.uri || this.item.uri.split('.')[this.item.uri.split('.').length - 1].toUpperCase() !== 'PNG') {
      return;
    }
    let currentMode: ConfigurationConstant.ColorMode | undefined = AppStorage.get('currentColorMode');
    Log.info(TAG, `getImageBackgroundColor:currentMode:${currentMode}, this.item.uri${this.item.uri}`);
    /* instrument ignore if  */
    if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.imageBackgroundColor = $r('sys.color.background_secondary');
    } else if (currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.imageBackgroundColor = $r('app.color.black');
    } else {
      this.imageBackgroundColor = 'none';
    }
  }

  /**
   * 图片组件子树
   */
  @Builder
  buildImage() {
    Stack() {
      Stack() {
        Image(this.getImageSource(), {
          types: [AnalyzerUtil.SUBJECT_TYPE, AnalyzerUtil.TEXT_TYPE, AnalyzerUtil.SEARCH_TYPE],
        })
          .hitTestBehavior(HitTestMode.Transparent)
          .draggable(false)
          .dynamicRangeMode(DeviceInfo.isTv() ? undefined : this.lcdDynamicRangeMode())
          .attributeModifier(this.stringImageModifier)
          .alt(this.getPlaceHolderImage())
          .opacity(this.isRunningAnimation ? this.imageStringSourceOpacity : 1)
          .objectFit(ImageFit.Cover)
          .autoResize(false)
          .width(Constants.PERCENT_100)
          .height(Constants.PERCENT_100)
          .clip(true)
          .onComplete((event?: completed): void => {
            this.imageCompleteWidth = event?.width;
            this.imageCompleteHeight = event?.height;
            Log.info(TAG, `onComplete ImageSource loadingStatus=${event?.loadingStatus}, ` +
              `imageCompleteWidth: ${this.imageCompleteWidth}，imageCompleteHeight: ${this.imageCompleteHeight},` +
              `image:${this.getImageSource()}, imageIndex:${this.imageIndex}`);
            /* instrument ignore next */
            if (DeviceInfo.isPc()) {
              // 渲染完成后返回给父组件存起来
              this.fillPCPropertyData();
            }
            this.lcdComplete(event);
            const editTrigger: boolean = this.item.isGifOrWebpType();
            this.imageComplete(event, editTrigger);
            if (this.mIsCurrent && event?.loadingStatus === 1) {
              this.broadCast.emit(BroadCastConstants.CURRENT_LCD_LOAD_COMPLETED, []);
            }
          })
          /* instrument ignore next  */
          .onError((event: ImageError): void => {
            if (!this.imageShowStringSource) {
              return;
            }
            this.imageError(event, 'buildImage failed by stringSource');
          })
          .enableAnalyzer((this.imageShowPixMapSource === undefined) && this.getImageAnalysisStatus())
          .focusable((this.imageShowPixMapSource === undefined) && this.getImageAnalysisStatus() && DeviceInfo.isPc())
          .focusOnTouch(DeviceInfo.isPc())
          .onMouse((event: MouseEvent) => {
            if (DeviceInfo.isPc() && event?.action === 2) {
              focusControl.requestFocus('image_source');
            }
          })
          .id('image_source')
          .accessibilityLevel((this.imageShowPixMapSource === undefined) && this.getImageAnalysisStatus() ? 'yes' :
            'no')

        Image(this.imageShowPixMapSource, {
          types: [AnalyzerUtil.SUBJECT_TYPE, AnalyzerUtil.TEXT_TYPE, AnalyzerUtil.SEARCH_TYPE],
        })
          .hitTestBehavior(HitTestMode.Transparent)
          .draggable(false)
          .dynamicRangeMode(DeviceInfo.isTv() ?
            undefined : (this.isPixMapSourceReady ? this.dynamicRange : DynamicRangeMode.STANDARD))
          .attributeModifier(this.pixmapImageModifier)
          .opacity(this.imageShowSourceOpacity)
          .width(Constants.PERCENT_100)
          .height(Constants.PERCENT_100)
          .objectFit(ImageFit.Cover)
          .autoResize(false)
          .clip(true)
          .onComplete((event?: completed): void => {
            if (this.startImageOnCompleteTimerId !== -1) {
              clearTimeout(this.startImageOnCompleteTimerId);
            }
            if (this.isCompleteAfterExitEdit()) {
              this.enterCompleteMethod(event);
              return;
            }
            this.startImageOnCompleteTimerId = setTimeout((): void => {
              this.enterCompleteMethod(event);
              this.startImageOnCompleteTimerId = -1;
            }, 1000);
          })
          .onError((event: ImageError): void => {
            if (!this.imageShowPixMapSource) {
              return;
            }
            this.imageError(event, 'buildImage failed by pixMapSource');
          })
          .enableAnalyzer((this.imageShowPixMapSource !== undefined) && this.getImageAnalysisStatus())
          .focusable((this.imageShowPixMapSource !== undefined) && this.getImageAnalysisStatus() && DeviceInfo.isPc())
          .focusOnTouch(DeviceInfo.isPc())
          .onMouse((event: MouseEvent) => {
            if (DeviceInfo.isPc() && event?.action === 2) {
              focusControl.requestFocus('image_pixmap');
            }
          })
          .id('image_pixmap')
          .accessibilityLevel((this.imageShowPixMapSource !== undefined) && this.getImageAnalysisStatus() ? 'yes' :
            'no')
          .backgroundColor(this.imageBackgroundColor)
      }
      .width(this.getImageWidth(this.imageStackWidth))
      .height(this.getImageHeight(this.imageStackHeight))
      .attributeModifier(this.viewModel.thumbImageStackModifier)
      .borderColor(Color.White)
      .rotate({ angle: this.angle })
      .clip(true)
      .opacity(this.photoRotateStackOpacity)
    }
    .tabIndex(IndexFocusOrder.PHOTO_GRID_VIEW)
    /* instrument ignore next  */
    .onMouse((event: MouseEvent): void => {
      if (!DeviceInfo.isPc() || this.isPcCameraPull) {
        return;
      }
      if (event.button === 2 && event.action === 1) {
        // 鼠标右键
        this.canShowRightMenu = true;
      }
    })
    .attributeModifier(this.isStackModifierChange ? this.viewModel.stackModifier : this.viewModel.stackModifier)
    .blur(this.isSupportBlurEnabled() ? this.itemBlur : 0)
    .bindImageStyle()
    .bindMainPhotoViewArea()
    .bindImageCommonParams()
  }

  public setIsRunningAnimationFunc: (isRunningAnimation: boolean) => void = (isRunningAnimation: boolean) => {
    Log.info(TAG, `onRunningAnimationChanged ${isRunningAnimation}`);
    this.isRunningAnimation = isRunningAnimation;
  }

  private playEnterAnimationSync(): void {
    // 动画播放结束或不是当前正在看的图，则默认为退出大图前的状态
    if (!this.browserAnimController?.isTransitionEnable) {
      Log.info(TAG, `playEnterAnimationSync ${this.mPosition} no enter ${this.browserAnimController?.isTransitionEnable}`);
      const params = this.browserAnimController?.getGridToBrowserAnimationParams();
      if (this.viewModel.isVideo()) {
        this.videoRatio = this.endRatio;
      } else {
        this.ratio = this.endRatio;
      }
      this.viewModel.playImageAnimationAsync(params, this.viewModel.getTargetIndex(), (index: number) => { }, () => { }, false, 0);
      return;
    }
  }

  private playExitAnimationSync(): void {
    if (this.mPosition !== this.viewModel.getTargetIndex() || this.browserAnimController?.isTransitionEnable) {
      Log.info(TAG, `playExitAnimationSync ${this.mPosition} no enter`);
      this.viewModel.thumbImageStackModifier?.updateVisibility(Visibility.Hidden);
      this.viewModel.thumbImageColumnModifier?.updateVisibility(Visibility.Hidden);
      return;
    }
    Log.info(TAG, `playExitAnimationSync ${this.mPosition} enter`);
    if (this.isDoingImageSlideAnimation) {
      this.isDoingImageSlideAnimation = false;
      this.photoRotateStackOpacity = 0;
    }
    const startParams = this.browserAnimController?.getGridToBrowserAnimationParams();
    if (this.viewModel.isVideo()) {
      startParams.targetAspectRatio = this.videoRatio;
    } else {
      startParams.targetAspectRatio = this.ratio;
    }
    startParams.targetScale = { x: this.geometryScale, y: this.geometryScale };
    this.viewModel.thumbImageColumnModifier?.updateOffset({ x: this.geometryOffsetX, y: this.geometryOffsetY });
    this.viewModel.thumbImageColumnModifier?.attribute?.transform(Matrix4.identity().copy());
    this.viewModel.playImageAnimationAsync(startParams, this.viewModel.getTargetIndex(), (index: number) => { }, () => { }, true, 0);
    if (this.viewModel.isVideo()) {
      this.videoRatio = this.endRatio;
    } else {
      this.ratio = this.endRatio;
    }
    this.viewModel.thumbImageColumnModifier?.attribute?.visibility(Visibility.Visible);
    const endParams = this.browserAnimController?.getBrowserToGridAnimationParams(this.mPosition, this.item.uri);
    // todo 先加个40给他强行挤下去
    if(endParams.targetTranslate){
      endParams.targetTranslate.y = Number(endParams.targetTranslate.y) + 40
    }
    performanceMonitor.begin(this.browserAnimController.getExitAnimTraceName(),
      performanceMonitor?.ActionType.LAST_UP);
    this.viewModel.playImageAnimationAsync(endParams, this.viewModel.getTargetIndex(), (index: number) => {
      Log.info(TAG,
        `playExitAnimationAsyncFinish ${this.photoBrowserStateMachine.getTargetIndex()} ${index} currentState = ${
        this.viewModel.getStateMachine().getCurrentState()?.stateName}`);
      if (this.photoBrowserStateMachine.getTargetIndex() === index) {
        this.viewModel.getStateMachine()?.processExitAnimationEndEvent();
      }
    }, () => {
      LocalStorage.getShared()?.setOrCreate<number>('geometryOpacity', 0);
      if (this.viewModel.isVideo()) {
        this.videoRatio = endParams.targetAspectRatio ?? 1;
      } else {
        this.ratio = endParams.targetAspectRatio ?? 1;
      }
      this.geometryOffsetX = 0;
      this.geometryOffsetY = 0;
      this.viewModel.thumbImageColumnModifier?.updateVisibility(Visibility.Hidden);
      // TODO 临时规避宫格进大图下拉返回动效问题
      if (this.browserAnimController.getControllerTypeCamera()) {
        this.viewModel.setGeometryScale(1);
      }
    }, false);
  }

  private getThumbnailImageUrl(): image.PixelMap | string | undefined {
    if (!this.isShowFastPixmap) {
      this.isShowFastPixmap = !!this.lastUri && !!this.fastPixmap &&
      StringUtil.isSamePhotoAsset(this.mediaResult.captureId, this.mediaResult.thumbnailUri,
        this.item.uri, this.lastUri) && !this.isEditorBack;
    }

    if (this.isShowFastPixmap) {
      let imageInfo = this.fastPixmap?.getImageInfoSync();
      Log.info(TAG, `[enterLibrary] fastPixmap width:${imageInfo?.size?.width} height:${
      imageInfo?.size?.height}`);
      if (!imageInfo?.size?.width || !imageInfo?.size?.height) {
        Log.info(TAG, '[enterLibrary] fastPixmap size undefind, not support fast thumbnail');
      } else {
        return this.fastPixmap;
      }
    }
    return ImageUtil.getThumbnailAstcUri(this.item.uri, this.item.path,
      this.item.getDateModified?.());
  }

  @Builder
  buildThumbnailImage() {
    Image(this.getThumbnailImageUrl())
      .onComplete((event?: completed): void => {
        Log.info(TAG, `buildThumbnailImage event = ${event?.componentHeight} ${event?.componentWidth}`);
        if (event?.loadingStatus !== 1) {
          this.viewModel.thumbImageColumnModifier?.updateVisibility(Visibility.Hidden);
          return;
        }
        this.viewModel.isThumbnailComplete = true;
        this.viewModel.readyToPlayAnim();
      })
      .onError((event: ImageError): void => {
        this.imageError(event, 'buildImage failed by ThumbnailImage');
        // 图片加载错误后还是要保障动画播放
        this.viewModel.isThumbnailComplete = true;
        this.viewModel.readyToPlayAnim();
      })
      .clip(true)
      .width(Constants.PERCENT_100)
      .height(Constants.PERCENT_100)
      .objectFit(ImageFit.Cover)
  }

  @Styles
  bindMainPhotoViewArea() {
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      // 旋转后swiper 和 该pangesture手势 冲突，导致无法滑动，提前拦截 --- 旋转横向拉详情 详情反复下滑导致无法在图片区域pangesture下滑退出详情
      if (gestureInfo.type === GestureControl.GestureType.PAN_GESTURE &&
        this.angle / BrowserConstants.ROTATION_NINETY % 2 !== 0) {
        /* instrument ignore next  */
        Log.info(TAG, `photoViewArea gesture reject`);
        /* instrument ignore next  */
        return GestureJudgeResult.REJECT;
      }
      return GestureJudgeResult.CONTINUE;
    })
    .gesture(PanGesture(this.panOption)
      .onActionStart((event: GestureEvent) => {
        this.eventOnMainPhotoView = true;
      })
    )
  }

  resetEventOnMainPhotoView() {
    if (this.eventOnMainPhotoView) {
      this.eventOnMainPhotoView = false;
    }
  }

  @Styles
  bindImageStyle() {
    /* instrument ignore next  */
    .onKeyEvent((event: KeyEvent): void => {
      /* instrument ignore next  */
      event && this.handleKeyEvent(event);
    })
    .onKeyPreIme((event: KeyEvent) => {
      if (DeviceInfo.isPc() && event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_DOWN) {
        /* instrument ignore next  */
        return true;
      }
      return false;
    })
    .onAppear((): void => {
      this.onImageAppear();
    })
    .onDisAppear((): void => {
      Log.info(TAG, `image onDisAppear mPosition: ${this.mPosition}, url: ${
      this.thumbnail?.url},geometryTransitionId: ${this.geometryTransitionId}`);
    })
    .onAreaChange((oldValue: Area, newValue: Area) => {
      if (this.mIsCurrent && !this.viewModel.isOnSwiperAnimation()) {
        Log.debug(TAG, `Image onAreaChange width: ${newValue.width}, height: ${
        newValue.height}, posX:${newValue.position.x}, posY:${newValue.position.y}`);
      }
    })
    .gesture(TapGesture({
      count: 1,
    })
      .onAction((event: GestureEvent): void => {
        if (!DeviceInfo.isPc()) {
          this.onImageTapGestureAction(event);
        } else {
          this.getUIContext().getFocusController().clearFocus();
        }
      })
    )
  }

  private releaseFastPixmap(): void {
    if (!!this.lastUri && this.isShowFastPixmap) {
      /* instrument ignore next  */
      this.fastPixmap?.release();
      /* instrument ignore next  */
      this.fastPixmap = undefined;
      Log.info(TAG, `releaseFastPixmap`);
    }
  }

  private onImageTapGestureAction(event: GestureEvent) {
    Log.info(TAG, `image single tab gesture ${this.viewModel.isPropertiesShow()} ${this.isTouchingPullUp}`);
    if (this.viewModel.isPropertiesShow() && !this.isTouchingPullUp) {
      this.broadCast.emit(BrowserConstants.CLOSE_CLICK_DETAIL_PULLING_UP + this.item.uniqueId,
        [this.item.uniqueId]);
    }
  }
  /* instrument ignore next  */
  private requestFocusForTV(): void {
    setTimeout(() => {
      let ret: boolean = focusControl.requestFocus('browserFocus_');
      if (!ret) {
        Log.error(TAG, `requestFocus faild, ret:${ret}`);
      }
    }, 1000);
  }

  private onImageAppear(): void {
    Log.info(TAG, `image onAppear mPosition: ${this.mPosition}, url : ${
    this.thumbnail?.url},geometryTransitionId: ${this.geometryTransitionId}`);
    if (this.mIsCurrent) {
      /* instrument ignore next */
      if (DeviceInfo.isTv()) {
        this.requestFocusForTV();
        return;
      }
      let ret: boolean = focusControl.requestFocus('browserFocus_');
      if (!ret) {
        /* instrument ignore next  */
        Log.error(TAG, `requestFocus faild, ret:${ret}`);
      }
    }
  }

  private getImageWidth(originalVal?: Length): Length | undefined {
    if (!this.isThird) {
      return originalVal;
    }
    // picker view化场景
    /* instrument ignore if  */
    if (this.isFromPickerView && !this.viewModel.isVideo()) {
      return (this.isThirdJustifyWidth || this.isRunningAnimation) ? originalVal : undefined;
    }
    // 普通picker场景
    /* instrument ignore next  */
    return this.isThirdJustifyWidth ? Constants.PERCENT_100 : undefined;
  }

  private getImageHeight(originalVal?: Length): Length | undefined {
    if (!this.isThird) {
      Log.info(TAG, `originalVal=${originalVal}`);
      return originalVal;
    }
    // picker view化场景
    if (this.isFromPickerView && !this.viewModel.isVideo()) {
      Log.info(TAG,
        `isThirdJustifyWidth=${this.isThirdJustifyWidth},isRunningAnimation=${this.isRunningAnimation},originalVal=${originalVal}`);
      return (this.isThirdJustifyWidth && !this.isRunningAnimation) ? undefined : originalVal;
    }
    // 普通picker场景
    Log.info(TAG, `isThirdJustifyWidth=${this.isThirdJustifyWidth}`);
    return this.isThirdJustifyWidth ? undefined : Constants.PERCENT_100;
  }

  @Styles
  bindImageCommonParams() {
    .key(`browserFocus_${this.imageKey}`)
    .focusable(this.isBrowserShow && !this.isShowPhotoSearchPage)
    .opacity(this.isInDragMode ? Constants.BUTTON_INVALID_OPACITY : 1)
    .aspectRatio(this.ratio)
    .width(this.needJustifyWidth() ? this.getImageWidth(this.imageWidth) : undefined)
    .height(this.needJustifyWidth() ? undefined : this.getImageHeight(this.imageHeight))
    .clip(
      this.isRunningAnimation ? true : (this.isInRotateAction ||
      this.isInRotateState ? false : ((this.isSubScreen && !DeviceInfo.isPhonePSD()) ? new Circle({ width: '100%', height: '100%' }) : true)))
    .geometryTransition(this.geometryTransitionChange())
    .focusBox({
      strokeWidth: LengthMetrics.px(0),
    })
  }

  /* instrument ignore next */
  @Builder
  RightClickMenuBuilder() {
    RightClickMenu({
      isVideoPlaying: this.isVideoPlaying,
      item: this.item,
      isFirstClickPlay: this.isFirstClickPlay,
      broadCast: this.broadCast,
      albumUri: this.albumUri,
      isPcCameraPull: this.isPcCameraPull,
      isUserCreatedAlbum: this.isUserCreatedAlbum,
      isInSelectedMode: this.isInSelectedMode,
      isFromPCPhotoBrowserModule: this.isFromPCPhotoBrowserModule,
      selectStateChange: this.selectStateChange,
      handlePauseClick: this.handlePauseClickFunc,
      isSelected: this.isSelected,
      isUseCustomShortKey: DeviceInfo.isPc() && this.isThirdScene,
    })
  }

  /* instrument ignore next */
  private onPreDragFun(preDragStatus: PreDragStatus): void {
    if (preDragStatus === PreDragStatus.READY_TO_TRIGGER_DRAG_ACTION && !this.isPullDownAndDragPhoto) {
      this.isInDragMode = true;
      this.viewModel.isDragFocus = true;
    } else if (preDragStatus === PreDragStatus.PREVIEW_LIFT_FINISHED) {
      this.viewModel.isDragFocus = false;
    } else if (preDragStatus === PreDragStatus.PREVIEW_LANDING_FINISHED ||
      preDragStatus === PreDragStatus.ACTION_CANCELED_BEFORE_DRAG) {
      this.isInDragMode = false;
    }
    Log.info(TAG, `onPreDrag, preDragStatus = ${preDragStatus},
       isDragFocus : ${this.viewModel.isDragFocus}, isDragging : ${this.isInDragMode}`)
  }

  /* instrument ignore next */
  private onDropFun(event: DragEvent): void {
    Log.info(TAG, `onDrop, event=${event.getResult()}, isInDragMode : ${this.isInDragMode}`)
    event.useCustomDropAnimation = this.isInDragPreviewArea;
    event.setResult(DragResult.DRAG_CANCELED);
  }

  /* instrument ignore next */
  @Builder
  buildHighlightOverlay() {
    Stack() {
      Stack() {
        ForEach(this.highlightRect, (item: RectValue): void => {
          this.drawHighlightOverlay(item);
        })
      }
      .backgroundColor($r('sys.color.ohos_id_color_mask_thin'))
      .width(this.getImageWidth(this.imageStackWidth) ?? Constants.PERCENT_100)
      .height(this.getImageHeight(this.imageStackHeight) ?? Constants.PERCENT_100)
      .rotate({ angle: this.angle })
    }
    .animation({ curve: Curve.Sharp, duration: BrowserConstants.OVERLAY_PULLING_ANIM_DURATION })
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({
        duration: BrowserConstants.OVERLAY_APPEAR_ANIM_DURATION,
        curve: Curve.Sharp,
      }),
      TransitionEffect.OPACITY.animation({
        duration: 0,
        curve: Curve.Sharp,
      })
    ))
    .accessibilityLevel('no')
    .draggable(false)
    .aspectRatio(this.ratio)
    .focusable(true)
    .transform(
      (this.isRunningAnimation ||
        (!MediaLibraryData.isMediaLibraryUri(this.item.uri) &&
          this.item.isInvalidImageSize()))
        ? Matrix4.identity().copy()
        : this.matrix
    )
    .width(this.imageWidth as string)
    .height(this.imageHeight as string)
    .attributeModifier(this.viewModel.highlightStackModifier)
    .clip(this.isInRotateAction || this.isInRotateState ? false : true)
    .hitTestBehavior(HitTestMode.Transparent)
  }

  /* instrument ignore next */
  @Builder
  drawHighlightOverlay(item: RectValue) {
    if (this.needHighlightFlashing(item)) {
      Image($r('app.media.img_ocr_highlight'))
        .scale({ x: this.dotScale, y: this.dotScale })
        .width(Rsc.toPxStr(vp2px(this.getDotDiameter() * HALF_DIVIDER)))
        .height(Rsc.toPxStr(vp2px(this.getDotDiameter() * HALF_DIVIDER)))
        .opacity(this.dotOpacity)
        .position({
          x: Rsc.toPxStr(item.x + item.width / HALF_DIVIDER - vp2px(this.getDotDiameter())),
          y: Rsc.toPxStr(item.y + item.height / HALF_DIVIDER - vp2px(this.getDotDiameter())),
        })
        .onAppear((): void => {
          this.getDotOpacity();
          this.getDotScale();
        })
        .accessibilityLevel('no')
    }
    if (this.needDrawHighlightDot(item)) {
      Circle()
        .fill($r('sys.color.ohos_id_color_text_primary_activated'))
        .width(Rsc.toPxStr(vp2px(this.getDotDiameter())))
        .height(Rsc.toPxStr(vp2px(this.getDotDiameter())))
        .position({
          x: Rsc.toPxStr(item.x + item.width / HALF_DIVIDER - vp2px(this.getDotDiameter() / HALF_DIVIDER)),
          y: Rsc.toPxStr(item.y + item.height / HALF_DIVIDER - vp2px(this.getDotDiameter() / HALF_DIVIDER)),
        })
        .accessibilityLevel('no')
    }
    if (this.needDrawHighlightRect(item)) {
      Rect()
        .width(Rsc.toPxStr(item.width))
        .height(Rsc.toPxStr(item.height))
        .fill($r('sys.color.ohos_id_color_text_highlight_bg_contrary'))
        .position({
          x: Rsc.toPxStr(item.x),
          y: Rsc.toPxStr(item.y),
        })
        .radius(BrowserConstants.RECT_RADIUS)
        .accessibilityLevel('no')
    }
  }

  /* instrument ignore next */
  private getDotDiameter(): number {
    return BrowserConstants.DOT_THRESHOLD / this.getPhotoScaledRatio(this.matrix);
  }

  /* instrument ignore next */
  private getDotScale(): void {
    animateTo({
      duration: BrowserConstants.DOT_ANIM_DURATION,
      curve: Curve.Smooth,
      iterations: BrowserConstants.DOT_ANIM_ITERATION,
      onFinish: (): void => {
        this.dotScale = BrowserConstants.DOT_ORIGINAL_SCALE;
      }
    }, (): void => {
      this.dotScale = 1;
    })
  }

  /* instrument ignore next */
  private getDotOpacity(): void {
    animateTo({
      duration: BrowserConstants.DOT_ANIM_DURATION,
      curve: Curve.FastOutLinearIn,
      iterations: BrowserConstants.DOT_ANIM_ITERATION,
      onFinish: (): void => {
        this.dotOpacity = 1;
      }
    }, (): void => {
      this.dotOpacity = 0;
    })
  }

  private isShowHighlight(): boolean {
    if (!this.hasHighlightRect) {
      return false;
    }
    if (this.isRunningAnimation) {
      return false;
    }
    if (this.isTappingAiButton) {
      return false;
    }
    if (!this.isShowBar) {
      return false;
    }
    return true;
  }

  /* instrument ignore next */
  private needDrawHighlightDot(item: RectValue): boolean {
    return Math.min(px2vp(item.width), px2vp(item.height)) * this.getPhotoScaledRatio(this.matrix) <
    BrowserConstants.RECT_THRESHOLD;
  }

  /* instrument ignore next */
  private needDrawHighlightRect(item: RectValue): boolean {
    return Math.min(px2vp(item.width), px2vp(item.height)) * this.getPhotoScaledRatio(this.matrix) >=
    BrowserConstants.DOT_THRESHOLD;
  }

  /* instrument ignore next */
  private needHighlightFlashing(item: RectValue): boolean {
    return Math.min(px2vp(item.width), px2vp(item.height)) * this.getPhotoScaledRatio(this.matrix) <
    BrowserConstants.DOT_THRESHOLD;
  }

  private setStringImageHidden(): void {
    if (this.isBackGround) {
      /* instrument ignore next */
      Log.info(TAG, 'setStringImageHidden returns, app is background');
      /* instrument ignore next */
      return;
    }
    if (!this.isInBackPressEvent && !this.isEditor && this.mIsCurrent) {
      this.stringImageModifier.attribute?.visibility(Visibility.Hidden);
    }
  }

  private pixelMapComplete(event?: completed): void {
    if (this.isEditor) {
      Log.info(TAG, `pixelMapComplete event: isEditor`);
      /* instrument ignore next */
      this.stringImageModifier.attribute?.visibility(Visibility.Visible);
      /* instrument ignore next */
      this.pixmapImageModifier.attribute?.visibility(Visibility.Hidden);
      /* instrument ignore next */
      return;
    }
    Log.info(TAG, `pixelMapComplete event?.loadingStatus = ${event?.loadingStatus} this.imageShowSourceOpacity = ${
    this.imageShowSourceOpacity} this.mIsCurrent = ${this.mIsCurrent}`);
    if (event?.loadingStatus === 1 && this.item.uri === EffectPhotoContext.getInstance().getUri()
      && EffectPhotoContext.getInstance().getIsSwitching() === false) {
      this.appBroadCast.emit(BroadCastConstants.CHANGE_IMAGE_LOADING, [false]);
    }
    if (event?.loadingStatus === 1 && !this.isDoPixelMapOpacityAnimation) {
      if (this.imageShowSourceOpacity === 1) {
        // 初始化、编辑保存、美肤后imageShowSourceOpacity等于1时，直接隐藏LCD图，不做动效。
        Log.info(TAG, 'set lcd image hidden after edit, abouttoappear or beautifying');
        this.setStringImageHidden();
        return;
      }
      this.doPixelmapOpacityAnim();
    }
  }

  private doPixelmapOpacityAnim(): void {
    if (this.mIsCurrent || DeviceInfo.isPc()) {
      Log.info(TAG, `do pixelMap image opacity animation mPosition = ${this.mPosition}, isHighQualityFirst ${
      this.isHighQualityFirst}`);
      this.isDoPixelMapOpacityAnimation = true;
      animateTo({
        duration: this.isHighQualityFirst ? 800 : 3000,
        curve: Curve.Ease,
        onFinish: (): void => {
          this.onLargePhotoComplete?.(this.item);
          this.isDoPixelMapOpacityAnimation = false;
          this.setStringImageHidden();
          this.releaseFastPixmap();
        }
      }, (): void => {
        this.imageShowSourceOpacity = 1;
      })
    } else {
      // 非当前展示页面，不做pixelMap透明度动效
      this.imageShowSourceOpacity = 1;
      this.setStringImageHidden();
    }
  }

  /* instrument ignore next */
  private fillPCPropertyData(): void {
    let imageInfo: PCImageInfo = new PCImageInfo();
    imageInfo.imageCompleteWidth = this.imageCompleteWidth;
    imageInfo.imageCompleteHeight = this.imageCompleteHeight;
    imageInfo.index = this.imageIndex;
    this.imageList.push(imageInfo);
  }

  private lcdComplete(event?: completed): void {
    if (event?.loadingStatus === 1) {
      if ( this.imageStringSourceOpacity !== 1) {
      Log.info(TAG, 'do lcd image opacity animation');
      animateTo({
        duration: 200,
        curve: Curve.Linear,
        onFinish:  () => {
        }
      }, () => {
        this.imageStringSourceOpacity = 1;
      })}
    }
  }

  private imageComplete(event?: completed, editTrigger: boolean = true): void {
    if (this.currentIndex === this.imageIndex) {
      Log.info(TAG, `imageLoadCompleted: ${this.imageIndex}`);
      this.appBroadCast.emit(BroadCastConstants.COMP_LOAD_COMPLETED, []);
    }
    this.appBroadCast.emit(BroadCastConstants.LARGE_PHOTO_COMPLETED,
      [this.item.captureId, this.item.thumbnailUri, this.item.uri, this.mPosition]);
    // 兜底方案：图片加载完成后依赖image组件解码获取图片宽高
    if (event?.loadingStatus === 0 && this.item.isInvalidImageSize()) {
      /* instrument ignore next */
      this.item.width = event?.width;
      /* instrument ignore next */
      this.item.height = event?.height;
      /* instrument ignore next */
      this.eventPipeline?.recalculateImgSizeAndScales();
      /* instrument ignore next */
      Log.info(TAG, `Decode image size by <Image>: ${event?.width}, ${event?.height}`);
    }

    let msg: string[] = ['imageComplete index: ' + this.mPosition];
    msg.push(`cur: ${this.mIsCurrent}`);
    msg.push(`thumb: ${JSON.stringify(this.thumbnail)}`);
    msg.push(`event: ${JSON.stringify(event)}`);
    msg.push(`orientation: ${this.item?.orientation}`);
    msg.push('size: ' + this.item?.width + `, ${this.item?.height}`);
    Log.info(TAG, msg.join(', '));
    clearTimeout(this.imageOnCompleteTimer);

    /* instrument ignore next */
    if (event?.loadingStatus === 1 && editTrigger && this.editorToImage()) {
      Log.info(TAG, '[EditorPhotoContext] emit CURRENT_PHOTO_LOAD_COMPLETED');
      /* instrument ignore next */
      this.broadCast.emit(BroadCastConstants.CURRENT_PHOTO_LOAD_COMPLETED, [this.item]);
      AppStorage.setOrCreate(IS_EDIT_SAVE, true);
    }

    if (this.lastThumbnail === this.thumbnail) {
      Log.info(TAG, `imageComplete`)
      return;
    }

    this.lastThumbnail = this.thumbnail;
    this.showError = false;
    this.isLoading = false;
    this.onPhotoChanged();
    if (this.mIsCurrent) {
      this.broadCast.emit(BrowserConstants.PHOTO_SHOW_STATE, [true]);
    }
    this.isComplete = true;
  }

  private editorToImage(): boolean {
    const editorContext: EditorPhotoContext = EditorPhotoContext.getInstance();
    if (editorContext.getNotifyHideEditor()) {
      return true;
    }
    if (editorContext.getEditorStage() === EditorStage.EXIT && editorContext.getEditorType() === EditType.MOVING_PHOTO
      && this.item?.uri === editorContext.getEditorUriOnExit()) {
      Log.warn(TAG, `[editorPhotoContext] editorToImage ${this.item?.uri}`);
      return true;
    }
    return false;
  }

  imageError(event: ImageError, scene: string): void {
    // 大图image加载错误
    if (!ImageUtil.isExitTransparentChannelLocalImgMimeType(this.item)) {
      ReportToBigDataUtil.errEventReport(BigDataConstants.BROWER_IMAGE_LOAD_ERROR,
        {
          'imagePosition': this.item?.getPosition?.(),
          'error': `scene: ${scene}, err: ${event?.message}`,
        });
    }
    Log.error(TAG,
      `load error, scene: ${scene} item: ${this.item?.uri}, ${JSON.stringify(this.thumbnail)}, imagePosition: ${this.item?.getPosition?.()}, error: ${event?.message}`);
    clearTimeout(this.imageOnCompleteTimer);
    this.showError = true;
    this.isLoading = false;
    if (this.mIsCurrent) {
      this.broadCast.emit(BrowserConstants.PHOTO_SHOW_STATE, [false]);
    }
  }

  /**
   * 视频播放控件子树
   */
  @Builder
  buildVideo() {
    Stack() {
      VideoPlayer({
        stateMachine: this.photoBrowserStateMachine,
        isEditor: this.isEditor,
        item: this.item,
        replaceUriManager: this.replaceUriManager,
        /* instrument ignore next */
        src: this.isEditor ? this.editorImageUri : this.item.uri,
        path: this.item.path,
        /* instrument ignore next */
        coverWidth: this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.coverWidth ?? 0 :
        this.item.coverWidth,
        /* instrument ignore next */
        coverHeight: this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.coverHeight ?? 0 :
        this.item.coverHeight,
        dateModified: this.item.getDateModified?.(),
        thumbnail: this.thumbnail,
        imageShowSource: this.imageShowPixMapSource,
        /* instrument ignore next */
        imageComplete: (event?: completed): void => this.imageComplete(event, true),
        /* instrument ignore next */
        imageError: (event: ImageError): void => this.imageError(event, 'buildVideo'),
        placeHolderImage: this.getPlaceHolderImage(),
        isRunningAnimation: $isRunningAnimation,
        broadCast: this.broadCast,
        mediaPosition: this.mediaPosition,
        /* instrument ignore next */
        maxTime: this.isEditor ? this.replaceUriManager?.getReplaceMediaItem(this.item)?.duration ?? 0 :
        this.item.duration,
        videoRealWidth: this.videoRealWidth,
        videoRealHeight: this.videoRealHeight,
        videoRatio: this.videoRatio,
        xComponentHeight: $xComponentHeight,
        onVideoPlayButtonClick: this.onVideoPlayButtonClickFunc,
        geometryTransitionId: $geometryTransitionId,
        pauseFromSubScreen: this.pauseFromSubScreen,
        pageStatusValue: this.pageStatus,
        xComponentController: this.xComponentController,
        mIsCurrent: this.mIsCurrent,
        videoCoverFrame: this.videoCoverFrame,
        isFrameExpand: this.isFrameExpand,
        playType: this.getPlayType(),
        progressType: this.getProgressType(),
        isFromPickerView: this.isFromPickerView,
        geometryOffsetX: this.geometryOffsetX,
        geometryOffsetY: this.geometryOffsetY,
        albumInfo: this.albumInfo,
        /* instrument ignore next */
        isThird: this.isThird,
        canFastPlay: this.canFastPlay(),
        onValueChange: this.handleValueChange.bind(this),
        hideThumbnailImageFunc: this.viewModel.hideThumbnailImageFunc
      })
        .width(Constants.PERCENT_100)
        .height(Constants.PERCENT_100)
        .attributeModifier(this.viewModel.thumbImageStackModifier)
        .borderColor(Color.White)
        .clip(!this.isFromPickerView)
    }
    .accessibilityLevel('no')
    .attributeModifier(this.isStackModifierChange ? this.viewModel.stackModifier : this.viewModel.stackModifier)
    .blur(this.isSupportBlurEnabled() ? this.itemBlur : 0)
    .focusable(true)
    .width(this.getImageWidth(DeviceInfo.isPc() ? this.imageWidth : this.xComponentWidth))
    .height(this.getImageHeight(DeviceInfo.isPc() ? this.imageHeight : this.xComponentHeight))
    .aspectRatio(this.videoRatio)
    .geometryTransition(this.isFromPickerView ? '' : this.geometryTransitionChange())
    .offset({
      x: this.isFromPickerView ? 0 : this.geometryOffsetX,
      y: this.isFromPickerView ? 0 : this.geometryOffsetY,
    })
    .clip(!this.isFromPickerView)
    .onClick((event: ClickEvent) => {
      if (this.isThird || this.isInSelectedMode) {
        /* instrument ignore next */
        this.handlePauseClick();
      }
      if (DeviceInfo.isPhoneOrTablet() && this.viewModel.isPropertiesShow() && !this.isTouchingPullUp) {
        this.broadCast.emit(BrowserConstants.CLOSE_CLICK_DETAIL_PULLING_UP + this.item.uniqueId,
          [this.item.uniqueId]);
      }
    }, distanceThreshold as number)
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      // 旋转后swiper 和 该pangesture手势 冲突，导致无法滑动，提前拦截 --- 旋转横向拉详情 详情反复下滑导致无法在图片区域pangesture下滑退出详情
      if (gestureInfo.type === GestureControl.GestureType.PAN_GESTURE &&
        this.angle / BrowserConstants.ROTATION_NINETY % 2 !== 0) {
        /* instrument ignore next  */
        Log.info(TAG, `photoViewArea gesture reject`);
        /* instrument ignore next  */
        return GestureJudgeResult.REJECT;
      }
      return GestureJudgeResult.CONTINUE;
    })
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        TapGesture({
          count: 1,
        })
          .onAction((event?: GestureEvent): void => {
            Log.info(TAG, `image single tab gesture ${!this.viewModel.isPropertiesShow()} ${this.isTouchingPullUp} ${this.isShowVideo} isInSelectedMode:${this.isInSelectedMode}`);
            if (this.viewModel.isPropertiesShow() && !this.isTouchingPullUp && !DeviceInfo.isPc()) {
              this.broadCast.emit(BrowserConstants.CLOSE_CLICK_DETAIL_PULLING_UP + this.item.uniqueId,
                [this.item.uniqueId]);
            }
            if (this.isSubScreen && this.isShowVideo) {
              /* instrument ignore next */
              this.appBroadCast.emit(BroadCastConstants.PAUSE_FROM_SUB_SCREEN, []);
            }
          }),
        PanGesture(this.panOption)
          .onActionStart((event: GestureEvent) => {
            this.eventOnMainPhotoView = true;
          })
      )
    )
  }

  private handlePauseClick(): void {
    if (!this.item.uri) {
      /* instrument ignore next */
      Log.warn(TAG, 'handle PauseClick, this.item.uri is invalid');
      /* instrument ignore next */
      return;
    }
    Log.info(TAG,
      `handlePauseClick isFirstClickPlay:${this.isFirstClickPlay}, isSupportedVideoType:${this.isSupportedVideoType}, isShowVideo:${this.isShowVideo}, pauseFromSubScreen:${this.pauseFromSubScreen}`)
    if (this.isFirstClickPlay) {
      this.isFirstClickPlay = false;
    }
    if (this.isSupportedVideoType) {
      if (this.isShowVideo && !DeviceInfo.isTv()) {
        /* instrument ignore next */
        this.broadCast.emit(BroadCastConstants.CHANGE_IS_PAUSE, []);
        /* instrument ignore next */
        Log.debug(TAG, `isSupportedVideoType: isShowVideo`);
        /* instrument ignore next */
        this.isShowVideo = !this.isShowVideo;
        /* instrument ignore next */
      } else {
        ShortCut.videoStoppable = false;
        if (this.pauseFromSubScreen) {
          this.appBroadCast.emit(BroadCastConstants.PLAY_FROM_SUB_SCREEN, []);
          Log.debug(TAG, `isSupportedVideoType: pauseFromSubScreen`);
          this.isShowVideo = !this.isShowVideo;
        } else {
          Log.debug(TAG, `isSupportedVideoType: non pauseFromSubScreen`);
          this.onVideoPlayIconClicked();
          /* instrument ignore next */
          if (DeviceInfo.isTv()) {
            this.isShowVideo = !this.isShowVideo;
          }
        }
      }
      /* instrument ignore else */
    } else {
      Log.info(TAG, `PhotoItem handlePauseClick isSupportedVideo ${this.isSupportedVideoType}`);
      UiUtil.showToast($r('app.string.unsupported_video_type'));
    }
  }
  /* instrument ignore next */
  private editorBackPhotoItem(): void {
    Log.info(TAG, '[editorPhotoContext] editorBackPhotoItem set isEditorBack true');
    this.isEditorBack = true;
  }

  private showVideoPlayButton(): boolean {
    Log.info(TAG, `[videoPlayer] show video button, uri: ${this.item.uri} !this.isDoingDeleteAnim:${
    !this.isDoingDeleteAnim}, !isPullDownAndDragPhoto : ${!this.isPullDownAndDragPhoto}, !isRunningAnimation:${
    !this.isRunningAnimation}, !isInAnimateToPosition ${!this.isInAnimateToPosition}, !isShowVideo:${
    !this.isShowVideo}, isVideoPlaying: ${this.isVideoPlaying}, isShowPlayButton: ${this.isShowPlayButton}, isClickPlay: ${(this.isShowPlayButton ||
      this.getPlayType() === PlayType.CLICK_TO_PLAY)}, ${
    !(this.viewModel.isPropertiesShow() && this.isFullMode)}, shareIsShowPlayButton: ${this.shareIsShowPlayButton}`);
    return !this.isDoingDeleteAnim && !this.isPullDownAndDragPhoto && !this.isInAnimateToPosition &&
      (!this.isShowVideo || (DeviceInfo.isTv() && this.isVideoPlaying)) &&
      (this.isShowPlayButton || this.getPlayType() === PlayType.CLICK_TO_PLAY) &&
      !(this.viewModel.isPropertiesShow() && this.isFullMode) && this.shareIsShowPlayButton &&
      !(this.viewModel.isPropertiesShow() && DeviceInfo.isPCMode());
  }

  private showRotateButton(): boolean {
    Log.info(TAG, `showRotateButton: !this.isDoingDeleteAnim:${
    !this.isDoingDeleteAnim}, !isPullDownAndDragPhoto : ${!this.isPullDownAndDragPhoto}, !isRunningAnimation:${
    !this.isRunningAnimation}, !isInAnimateToPosition ${!this.isInAnimateToPosition}, isPhoneOrTablet ${
    DeviceInfo.isPhoneOrTablet()}, isFullMode: ${getScreen().isFullMode()}, isVerdefolable: ${
    DeviceInfo.isVerdeFoldable()}, isThird:${this.isThird}, isFromFACard: ${
    this.isFromFACard}, isInSelectedMode: ${this.isInSelectedMode}`);
    return !this.isDoingDeleteAnim && !this.isPullDownAndDragPhoto &&
      !this.isRunningAnimation && !this.isInAnimateToPosition && DeviceInfo.isPhoneOrTablet() &&
      !this.isPullingDown && !this.viewModel.isPropertiesShow() && this.isShowBar && this.viewModel.isVideo() &&
    getScreen().isFullMode() && !DeviceInfo.isVerdeFoldable() && !this.isThird && !this.isFromFACard &&
      !this.isInSelectedMode;
  }

  private setRotateButtonOffset(): void {
    if (this.rotateController) {
      this.rotateController.setButtonOffsetY();
      this.rotateButtonOffsetX = this.rotateController.getButtonOffsetX();
      this.rotateButtonOffsetY = this.rotateController.getButtonOffsetY();
    }
  }

  // 判断是否从宫格、picker、fa卡片进入
  private canFastPlay(): boolean {
    return !this.isThird && !this.isFromFACard && !this.isInSelectedMode;
  }


  updateBroadcastWithItem(item: MediaItem): void {
    if (this.item === item) {
      /* instrument ignore next */
      return;
    }
    this.broadCast.off(BroadCastConstants.ANIMATE_TO_POSITION + this.item.uri, this.animateToPositionFunc);
    this.item = item;
    // 防止重复注册，重复注册会导致callBack函数多次执行，且需要多次取消注册
    if (!this.broadCast.has(BroadCastConstants.ANIMATE_TO_POSITION + this.item.uri)) {
      this.broadCast.on(BroadCastConstants.ANIMATE_TO_POSITION + this.item.uri, this.animateToPositionFunc);
    }
  }
  /* instrument ignore next */
  onStatusBarHeightChange(): void {
    this.calcLoadingPosition();
  }

  // 计算图片变化后loading的位置
  private calcLoadingPosition(): void {
    if (this.mIsCurrent) {
      let currentScale = this.eventPipeline?.currentScale ?? this.defaultScale;
      this.currentWidth = px2vp(this.currentImageWidth) * currentScale;
      this.currentHeight = px2vp(this.currentImageHeight) * currentScale;
      this.realLoadingOffsetX = this.currentWidth / px2vp(this.currentImageWidth) * this.loadingOriginOffsetX;
      this.realLoadingOffsetY = this.currentHeight / px2vp(this.currentImageHeight) * this.loadingOriginOffsetY;

      // 沉浸式的loading位置处理
      if (this.currentWidth >= this.viewModel.windowLayoutWidth &&
        this.currentHeight >= this.viewModel.windowLayoutHeight) {
        this.loadingOffsetX = this.loadingDeviceOffsetX;
        this.loadingOffsetY = this.loadingDeviceOffsetY;
      } else if (this.currentWidth === px2vp(this.currentImageWidth) &&
        this.currentHeight === px2vp(this.currentImageHeight)) {
        this.loadingOffsetX = this.loadingOriginOffsetX;
        this.loadingOffsetY = this.loadingOriginOffsetY;
        /* instrument ignore next */
      } else if (this.currentWidth >= this.viewModel.windowLayoutWidth) {
        this.loadingOffsetX = this.loadingDeviceOffsetX;
        this.loadingOffsetY = this.realLoadingOffsetY;
        /* instrument ignore next */
      } else if (this.currentHeight >= this.viewModel.windowLayoutHeight) {
        this.loadingOffsetY = this.loadingDeviceOffsetY;
        this.loadingOffsetX = this.realLoadingOffsetX;
      }

      // 非沉浸式，顶部条高度
      if (this.isShowBar && !this.isInSelectedMode) {
        let actionBarHeight = this.viewModel.calcBarTopHeight(this.statusBarHeight);
        if (((this.viewModel.windowLayoutHeight - this.currentHeight) / HALF_DIVIDER) < actionBarHeight) {
          this.loadingOffsetY = this.loadingDeviceOffsetY + actionBarHeight;
        }
      }
    }
  }

  /* instrument ignore next */
  @Builder
  buildMovingPhoto() {
    Stack() {
      Stack() {
      }
      .width(this.getImageWidth(this.imageStackWidth))
      .height(this.getImageHeight(this.imageStackHeight))
      .attributeModifier(this.viewModel.thumbImageStackModifier)
      .borderColor(Color.White)
      .rotate({ angle: this.angle })
      .clip(true)
      .opacity(this.photoRotateStackOpacity)
    }
    .onAppear((): void => {
      Log.info(TAG, `movingPhoto geometryID: ${this.geometryTransitionId}`);
    })
    .accessibilityLevel('no')
    .attributeModifier(this.isStackModifierChange ? this.viewModel.stackModifier : this.viewModel.stackModifier)
    .blur(this.isSupportBlurEnabled() ? this.itemBlur : 0)
    .onKeyEvent((event: KeyEvent): void => {
      event && this.handleKeyEvent(event);
    })
    .focusable(true)
    .aspectRatio(this.ratio)
    .width(this.getImageWidth(this.imageWidth))
    .height(this.getImageHeight(this.imageHeight))
    .clip(
      this.isRunningAnimation ? true : (this.isInRotateAction || this.isInRotateState ? false : true))
    .geometryTransition(this.geometryTransitionChange())
    .bindMainPhotoViewArea()
    .gesture(
      TapGesture({
        count: 1,
      })
        .onAction((event: GestureEvent): void => {
          Log.info(TAG, `image single tab gesture ${this.viewModel.isPropertiesShow()} ${this.isTouchingPullUp}`);
          if (this.viewModel.isPropertiesShow() && !this.isTouchingPullUp) {
            this.broadCast.emit(BrowserConstants.CLOSE_CLICK_DETAIL_PULLING_UP + this.item.uniqueId,
              [this.item.uniqueId]);
          }
        })
    )
  }

  // 折叠屏展开态获取折叠态竖屏宽度
  /* instrument ignore next */
  getUnFolderVerticalDeviceWidth(): number {
    let data: display.FoldCreaseRegion = display.getCurrentFoldCreaseRegion();
    let rectArea = data?.creaseRects[0] || {
      width: 0,
      left: 0,
      top: 0,
      height: 0,
    };
    let foldWidth = (rectArea.width / 2) - rectArea.height + Constants.FOLD_CREASE_REGION_DIFF_SIZE;
    return px2vp(foldWidth);
  }

  /* instrument ignore next */
  handleOnPhotoPropertiesComponentScrollChange = (offsetResult: OffsetResult) => {
    this.photoPropertiesComponentScrollY = offsetResult.yOffset;
  }

  // 判断图片或者视频是否需要截断
  isClipImage(): boolean {
    if (((DeviceInfo.isPhoneUx() && !FoldUtil.isTriExpand(this.curFoldStatus)) &&
    this.isHorizontal) || (this.isFoldExpanded && this.isFullMode)) {
      return false;
    }
    if (this.isHalfFold) {
      return !this.isClickBackPress && !this.isPullingDown;
    }
    return this.viewModel.isOnSwiperAnimation() && !this.isPhotoScaled;
  }

  build() {
    Stack() {
      // 加载浅层交互loading状态
      /* instrument ignore next */
      if (this.isFastEditProcessing) {
        Stack() {
          LoadingProgress()
            .color($r('sys.color.icon_secondary'))
            .width($r('app.float.fast_edit_loading_size'))
            .height($r('app.float.fast_edit_loading_size'))
            .position({
              x: px2vp(this.fastEditProcessingPosition[0]) - EDIT_LOADING_MARGIN,
              y: px2vp(this.fastEditProcessingPosition[1]) - EDIT_LOADING_MARGIN,
            })
        }
        .width(Constants.PERCENT_100)
        .height(Constants.PERCENT_100)
        .zIndex(2)
      }
      // 加载图标文字组件
      //for enter animation
      if (!this.browserAnimController?.isTransitionEnable) {
        Column() {
          Column() {
            this.buildThumbnailImage()
          }
          .attributeModifier(this.viewModel.thumbImageModifier)
          .width(this.getImageWidth(this.imageWidth))
          .height(this.getImageHeight(this.imageHeight))
          .clip(true)
          .borderColor(Color.White)
        }
        .attributeModifier(this.viewModel.thumbImageColumnModifier)
        .justifyContent(FlexAlign.Center)
        .clip(true)
        .enabled(false)
      }
      Column() {
        Stack({ alignContent: Alignment.TopStart }) {
          Column() {
            Column() {
              // Photo Component
              if (this.viewModel.isVideo()) {
                Stack() {
                  this.buildVideo();
                  if (!DeviceInfo.isPc() && !DeviceInfo.isTv() && this.isShowFastPlayLabel &&
                    !this.isDoingDeleteAnim && !this.isPullDownAndDragPhoto && !this.isRunningAnimation &&
                    !this.isInAnimateToPosition) {
                    /* instrument ignore next */
                    FastPlayLabel({
                      isHorizontal: this.isHorizontal,
                      isPullingUp: this.viewModel.isPropertiesShow()
                    })
                  }
                }
                .clip(false)
              } else if (this.isMovingPhoto() && !this.isEditor && this.editorImageUri == '') {
                Stack() {
                  this.buildMovingPhoto();
                  if (this.isShowHighlight()) {
                    this.buildHighlightOverlay();
                  }
                }
                .clip(false)
                .width(Constants.PERCENT_100)
                .height(Constants.PERCENT_100)
              } else if (this.editorImageUri !== undefined) {
                Stack() {
                  this.buildImage();
                  if (this.isShowHighlight()) {
                    this.buildHighlightOverlay();
                  }
                }
                .clip(false)
                .accessibilityLevel('no')
                .attributeModifier(this.viewModel.imageStackModifier)
              }
            }
            .onAreaChange((oldValue: Area, newValue: Area) => {
              /* instrument ignore if */
              if (this.isThird) {
                let areaRatio: number = ImageUtil.calcRatio({
                  width: Number(newValue.width) || 0,
                  height: Number(newValue.height) || 0
                } as image.Size);
                this.isThirdJustifyWidth = this.ratio > areaRatio;
                this.imageComponentWidth = Number(newValue.width);
                this.imageComponentHeight = Number(newValue.height);
                this.eventPipelineSizeChange();
              }
              this.viewModel.onPhotoDisplaySizeChange();
            })
            .key(`browserFocusColumn${this.item?.uri}`)
            .translate({
              x: this.viewModel.getImageTranslateX(this.isFullMode),
              y: this.isHalfFoldStateEnable() && !this.isHorizontal ? this.translateY :
                this.viewModel.getImageTranslateY(this.isFullMode)
            })
            // Inner width and height should be absolute to avoid the effects of clipping.
            .clip(this.isClipImage())
            .width(this.isThird ? Constants.PERCENT_100 :
              (this.isFoldExpanded && this.isFullMode ? Constants.PERCENT_100 :
                (this.viewModel.isPropertiesShow() || this.isDoingImageSlideAnimation) ?
                  this.viewModel.windowLayoutWidth - (DeviceInfo.isPc() && this.isShowSideBar ? this.sideBarWidth : 0) :
                (this.isDoingDeleteAnim || this.isInRotateState ? Constants.PERCENT_100 : '')))
            .height(this.isHalfFoldStateEnable() && !this.isHorizontal ? this.theImageHeight :
              !this.isHorizontal && !this.isFoldExpanded && this.isFullMode && !this.isThird &&
                !(this.isTabletOrTriExpand() &&
                  !this.isHorizontal && getScreen().getWinMode() !== WindowMode.FLOATING) ?
              this.viewModel.clipColumnHeight : Constants.PERCENT_100)
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .stateStyles({
              focused: {
                .borderWidth(0)
              }
            })
          }
          // clip image while pulling up in vertical screen
          .key('browserFocusColumn')
          .height(((this.isFoldExpanded && getScreen().getWinMode() !== WindowMode.PRIMARY) || this.isHorizontal ||
            ((getScreen().getWinMode() === WindowMode.FLOATING &&
              this.isTabletOrTriExpand() ||
              this.isTabletOrTriExpand() && !this.isHorizontal && getScreen()
                .getWinMode() !== WindowMode.FLOATING ||
              getScreen().getWinMode() === WindowMode.UNDEFINED &&
                (((DeviceInfo.isPhoneUx() && !FoldUtil.isTriExpand(this.curFoldStatus)) &&
                  this.viewModel.isPropertiesShow() && !this.isFoldExpanded && !this.isThird && getScreen()
                  .getWinMode() !== WindowMode.UNDEFINED))) && this.viewModel.isPropertiesShow())) ?
          Constants.PERCENT_100 :
            (this.isHalfFold && !this.isHorizontal) ? Constants.PERCENT_100 :
              `${this.viewModel.clipHeightPercentage * 100}%`)
          // clip image while pulling up in horizontal screen
          .width(this.viewModel.getPhotoColumnWidth(this.isFullMode, this.isHalfFold))
          .clip(!this.pickerBrowserInDragOrBackPress)
          .zIndex(1)
          .alignItems(this.viewModel.getPhotoColumnAlignItems(this.isFullMode, this.isDoingImageSlideAnimation))
          .justifyContent(FlexAlign.Center)

          if (this.canPullingUp &&
            (this.viewModel.isPropertiesShow() || this.isDoingImageSlideAnimation) && !this.isPcPictureScene) {
            Column() {
              Row() {
                if (this.isHorizontal || (DeviceInfo.isFoldable() && !this.isThird &&
                  getScreen().getWinMode() !== WindowMode.UNDEFINED) || (this.isTabletOrTriExpand() &&
                  getScreen().getWinMode() !== WindowMode.FLOATING && !this.isTabletSamllFloating() &&
                  !this.isHorizontal)) {
                  Divider()
                    .vertical(true)
                    .color($r('sys.color.comp_divider'))
                    .height(Constants.PERCENT_100)
                }
                Column() {
                  if (!this.isHorizontal && !(this.isTabletOrTriExpand() &&
                    getScreen().getWinMode() !== WindowMode.FLOATING) || this.isTabletSamllFloating()) {
                    Divider()
                      .vertical(false)
                      .color($r('sys.color.comp_divider'))
                      .width(Constants.PERCENT_100)
                  }
                  Column() {
                    PhotoPropertiesComponent({
                      stateMachine: this.photoBrowserStateMachine,
                      albumUri: this.albumUri,
                      item: $item,
                      broadCast: this.broadCast,
                      mIsCurrent: this.mIsCurrent,
                      controllerTextArea: this.controllerTextArea,
                      controllerTextInput: this.controllerTextInput,
                      controllerPortraitInput: this.controllerPortraitInput,
                      imageCompleteWidth: this.imageCompleteWidth,
                      imageCompleteHeight: this.imageCompleteHeight,
                      onScrollChange: this.handleOnPhotoPropertiesComponentScrollChange,
                      dataSource: this.dataSource,
                      imageTargetPullHeight: this.imageTargetPullHeight,
                      albumInfo: this.albumInfo,
                      isDoingImageSlideAnimation: this.isDoingImageSlideAnimation,
                    })
                  }
                  .width('100%')
                  .onAppear((): void => {
                    if (!this.isScrolling) {
                      this.scroller.scrollEdge(Edge.Bottom);
                    }
                  })
                  .onDisAppear((): void => {
                    if (!this.isScrolling) {
                      this.scroller.scrollEdge(Edge.Top);
                    }
                  })
                  .gesture(
                    /* instrument ignore next */
                    TapGesture({ count: 1 }).onAction((event: GestureEvent) => {
                      this.broadCast?.emit(BroadCastConstants.ON_PROPERTIES_ITEM_CLICKED, []);
                    })
                  )
                }
                .translate({
                  x: Constants.PERCENT_0,
                  y: this.isHalfFold && !this.isHorizontal ?
                  Constants.PHOTO_PROPERTIES_TRANSLATE_Y : Constants.PERCENT_0
                })
                .height(Constants.PERCENT_100)
                .width(DeviceInfo.isTv() ? Constants.TV_DETAIL_WIDTH :
                  (getScreen().getWinMode() === WindowMode.UNDEFINED && !this.isTabletSamllFloating() &&
                    this.isTabletOrTriExpand() ?
                  Constants.SPLIT_LIST_CARD_WIDTH : this.viewModel.calculatePhotoDetailWidth()))
                .backgroundColor(DeviceInfo.isTv() ? $r('app.color.tv_detail_bg_color') :
                $r('sys.color.background_secondary'))
              }
            }
            .opacity(this.viewModel.photoPropertiesOpacity)
            .borderRadius($r('sys.float.corner_radius_level16'))
            .zIndex(this.viewModel.propertiesIndex)
            .translate({
              x: this.viewModel.getPropertiesTranslateX(),
              y: this.viewModel.getPropertiesTranslateY(this.isFullMode, this.windowPcmodeSwitchStatus),
            })
            .position({
              x: this.viewModel.getPropertiesPositionX(),
              y: this.viewModel.getPropertiesPositionY(),
            })
            .key('detailColumn')
            .width(Constants.PERCENT_100)
            .height(Constants.PERCENT_100)
            .alignItems(this.viewModel.getPhotoPropertiesAlignItems(this.isFullMode,
              this.isDoingImageSlideAnimation))
            .transition(DeviceInfo.isPc() ? TransitionEffect.OPACITY.animation({
              duration: 200,
              curve: Curve.Sharp,
            }) : undefined)
          }
        }
      }
      .focusable(!(DeviceInfo.isPc() && this.viewModel.isVideo()))
      .accessibilityRole(AccessibilityRoleType.IMAGE)
      .accessibilityGroup(true)
      .accessibilityLevel('yes')
      .key('photoItem_Column')
      .accessibilityText(this.isOpenTouchGuide ? this.getImageItemGridAccessibilityText() : '')
      .attributeModifier(this.viewModel.oriImageColumnModifier)
      .clip(false)
      .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
        Log.info(TAG, `gestureInfo.type is ${gestureInfo.type}`);
        if (gestureInfo.type === GestureControl.GestureType.PAN_GESTURE && this.eventPipeline?.canPanInAnimation) {
          return GestureJudgeResult.CONTINUE;
        }
        if (this.isSupportRejectGesture(gestureInfo)) {
          /* instrument ignore next */
          return GestureJudgeResult.REJECT;
        }
        // 屏蔽视频在photoitem中长按手势
        if (gestureInfo.type === GestureControl.GestureType.LONG_PRESS_GESTURE &&
          (!this.viewModel.isVideo() || this.isVideoPlaying)) {
          /* instrument ignore next */
          Log.info(TAG, 'Long press from videoPlayer reject!');
          /* instrument ignore next */
          return GestureJudgeResult.REJECT;
        }
        // 人像详情弹窗弹出时，拒绝事件
        if (this.viewModel.getStateMachine().isShowDetailPortraitTips()) {
          Log.info(TAG, 'DetailPortraitTips is showing reject!');
          return GestureJudgeResult.REJECT;
        }
        // 大图旋转开关
        if (this.isThird &&
          gestureInfo.type === GestureControl.GestureType.ROTATION_GESTURE) {
          /* instrument ignore next */
          Log.info(TAG, `rotate from picker reject!`);
          /* instrument ignore next */
          return GestureJudgeResult.REJECT;
        }
        // 拦截部分手势
        if (!this.detectGesture(gestureInfo, event)) {
          /* instrument ignore next */
          Log.info(TAG, 'Not allow to some gesture when isRunningAnimation');
          /* instrument ignore next */
          return GestureJudgeResult.REJECT;
        }
        // 视频和GIF图拦截旋转手势
        if ((this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ||
          this.item.mimeType?.toLowerCase().indexOf('gif') !== -1) &&
          gestureInfo.type === GestureControl.GestureType.ROTATION_GESTURE) {
          /* instrument ignore next */
          Log.info(TAG, `rotate with video and gif reject!`);
          /* instrument ignore next */
          return GestureJudgeResult.REJECT;
        }
        // 画中画下屏蔽旋转手势
        if (this.enableEnterInnerPic &&
          gestureInfo.type === GestureControl.GestureType.ROTATION_GESTURE) {
          /* instrument ignore next */
          Log.info(TAG, `inner photo totate reject!`);
          /* instrument ignore next */
          return GestureJudgeResult.REJECT;
        }
        return GestureJudgeResult.CONTINUE;
      })
      .parallelGesture(
        GestureGroup(GestureMode.Parallel,
          RotationGesture({ fingers: 2, angle: BrowserConstants.ROTATION_TRIGGER_ANGLE })
            .onActionStart(
              /* instrument ignore next */
              (event: GestureEvent) => {
                if (!this.viewModel.isAllowRotate()) {
                  return;
                }
                /* instrument ignore next */
                this.isInRotateState = true;
                /* instrument ignore next */
                this.isInRotateAction = true;
                /* instrument ignore next */
                this.isAngleChanged = false;
                /* instrument ignore next */
                this.eventPipeline?.setIsAngleChange(this.isAngleChanged);
                this.viewModel.hideThumbnailImageFunc();
                // 双指旋转进入沉浸式
                if (this.isShowBar) {
                  this.broadCast.emit(BrowserConstants.HIDE_BARS, []);
                }
                // 最小触发角度适配，防止旋转手势一开始 触发角度 内闪跳
                this.isFirstPositiveAngle = event.angle > 0 ?
                FirstRotationDirection.POSITIVE_ANGLE : FirstRotationDirection.NEGATIVE_ANGLE;
                /* instrument ignore next */
                Log.info(TAG, `RotationGesture start angle:${event.angle}`);
              })
            /* instrument ignore next */
            .onActionUpdate(
              /* instrument ignore next */(event: GestureEvent) => {
              if (event) {
                if (!this.viewModel.isAllowRotate()) {
                  return;
                }
                this.isInRotateAction = true;
                this.angle = this.rotateValue + event.angle +
                  BrowserConstants.ROTATION_TRIGGER_ANGLE * (this.isFirstPositiveAngle);
              }
            })
            /* instrument ignore next */
            .onActionEnd(
    /* instrument ignore next */(event: GestureEvent) => {
    /* instrument ignore next */
              if (!this.viewModel.isAllowRotate()) {
                return;
              }
              Log.info(TAG, `angleBefore : ${this.rotateValue} angleNew: ${this.angle}`);
              /* instrument ignore next */
              animateTo({
                duration: BrowserConstants.PHOTO_ROTATION_DURATION,
                curve: Curve.Ease,
                onFinish: () => {
                  this.isInRotateAction = false;
                  // 旋转后eventPipeLine变量更新
                  this.eventPipeline?.onRotateEnd(this.angle);
                  // 画中画对应参数修改
                  this.initImageTool();
                  // 画中画 隐藏定时器更新
                  this.innerPhotoDealTouchEvent();
                  this.eventPipeline?.innerPicPanAnimationEnd();
                  // 动态照片手势结束后restart
                  if (this.isMovingPhoto() && !this.isEditor && this.editorImageUri == '') {
                    this.appBroadCast.emit(BroadCastConstants.MOVING_PHOTO_RESTART, [this.item.uri]);
                  }
                }
              }, () => {
                this.angle = PhotoRotateUtil.convertAngleToTarget(this.angle);
              })
              // 旋转后角度不同，需回到scale = 1的状态
              // 旋转后角度不变，当前scale不更改
              /* instrument ignore next */
              if (this.rotateValue != this.angle) {
                this.isAngleChanged = true;
                this.eventPipeline?.setIsAngleChange(this.isAngleChanged);
              }
              this.rotateValue = this.angle;
              this.resetFirstLookStatus();
              // 在没有捏合手势共存 且 大图旋转角度发生变化， 大图回到默认scale
              /* instrument ignore next */
              if (!this.isInPinch && this.isAngleChanged) {
                Log.info(TAG, `rotation with no pinch and angle not changed, photo scale to one!`);
                this.eventPipeline?.photoToDefaultScale();
                // 动画复原撑满效果
                /* instrument ignore next */
                animateTo({
                  curve: this.pinchAnimationCurves,
                  onFinish: (): void => {
                    this.eventPipeline?.onAnimationEnd(this.animationEndMatrix as Matrix4.Matrix4Transit);
                    this.hasHighlightRect = this.highlightRect.length !== 0;
                    this.animationOption = undefined;
                    this.animationEndMatrix = undefined;
                    this.isAngleChanged = false;
                    this.eventPipeline?.setIsAngleChange(this.isAngleChanged);
                  }
                }, (): void => {
                  this.matrix = this.animationEndMatrix as Matrix4.Matrix4Transit;
                })
              }
              Log.info(TAG, 'RotationGesture end')
            })
            .onActionCancel(
              /* instrument ignore next */() => {
              // 旋转过程强行打断，如旋转时横竖屏切换
              if (this.isInRotateState || this.isInRotateAction) {
                animateTo({
                  duration: BrowserConstants.PHOTO_ROTATION_DURATION,
                  curve: Curve.Ease,
                  onFinish: () => {
                    this.isInRotateAction = false;
                    // pinch适配ActionCancel后可删除
                    /* instrument ignore next */
                    if (this.angle === 0) {
                      this.isInRotateState = false;
                    }
                  }
                }, () => {
                  this.angle = PhotoRotateUtil.convertAngleToTarget(this.angle);
                })
                if (this.rotateValue != this.angle) {
                  this.isAngleChanged = true;
                  this.eventPipeline?.setIsAngleChange(this.isAngleChanged);
                }
                this.rotateValue = this.angle;
                this.resetFirstLookStatus();
              }
            }),
          GestureGroup(GestureMode.Exclusive,
            PinchGesture({
              fingers: 2,
            })
            /* instrument ignore next */
              .onActionStart((event: GestureEvent): void => {
                performanceMonitor.begin('CUSTOM_ANIMATOR BrowerPinchGesture',
                  performanceMonitor?.ActionType.LAST_DOWN);
                if (!this.isExistGestureEvent(event)) {
                  return;
                }
                if (this.canShowRightMenu) {
                  return;
                }
                Log.info(TAG,
                  `PinchGesture start scale: ${event.scale}, cx: ${event.pinchCenterX}, cy: ${event.pinchCenterY},
                  speed: ${event.speed}`);
                if (!this.viewModel.isAllowPinch()) {
                  return;
                }
                this.viewModel.hideThumbnailImageFunc();
                this.enterInnerPicWay = EnterInnerPicWay.PINCH;
                this.panOption.setDistance(PAN_GESTURE_DISTANCE);
                this.isPhotoChangeLoading = true;
                this.isGestureMove = false;
                this.eventPipeline?.downloadForScaleIfNeeded(event.scale);
                this.isInPinch = true;
                Log.info(TAG, `PinchGesture onActionStart isInPinch = ${this.isInPinch}`);
                this.eventPipeline?.onScaleStart(event.scale, event.pinchCenterX, event.pinchCenterY);
              })
              /* instrument ignore next */
              .onActionUpdate((event: GestureEvent): void => {
                if (!this.isExistGestureEvent(event)) {
                  return;
                }
                Log.debug(TAG,
                  `PinchGesture onActionUpdate scale: ${event.scale} isInPinch = ${this.isInPinch}}`);
                if (!this.viewModel.isAllowPinch()) {
                  return;
                }
                if (this.canShowRightMenu) {
                  Log.info(TAG, `PinchGesture onActionUpdate canShowRightMenu = ${this.canShowRightMenu}`);
                  return;
                }
                this.eventPipeline?.downloadForScaleIfNeeded((event as GestureEvent).scale);
                this.eventPipeline?.onPinchScale(event.scale);
                // 大图缩放，清除画中画隐藏定时器
                this.innerPhotoDealTouchEvent();
              })
              /* instrument ignore next */
              .onActionEnd(
                (event: GestureEvent): void => {
                  performanceMonitor.end('CUSTOM_ANIMATOR BrowerPinchGesture');
                  Log.info(TAG, 'PinchGesture onActionEnd');
                  this.eventPipeline?.onResetIsFirstDownLoadOrigin();
                  if (!this.viewModel.isAllowPinch()) {
                    return;
                  }
                  this.panOption.setDistance(PAN_GESTURE_DISTANCE_DEFAULT);
                  this.isGestureMove = true;
                  // 调用对比度算法
                  this.onPixelmapReAdapt();
                  // 保证 this.isInPinch 在 this.eventPipeline?.onScaleEnd(); 前面
                  this.isInPinch = false;
                  this.isGestureMove = true;
                  Log.info(TAG, `PinchGesture onActionEnd isInPinch = ${this.isInPinch}`);
                  this.eventPipeline?.onScaleEnd();
                  this.calcLoadingPosition();
                  if ((this.currentWidth / px2vp(this.currentImageWidth) > this.defaultScale) &&
                    (this.currentWidth / px2vp(this.currentImageWidth) < this.viewModel.maxScale)) {
                    this.isPhotoChangeLoading = false;
                  }
                  reportImageEnlargeWay(PINCH_GESTURE, event.scale);
                  if (this.animationOption) {
                    Log.info(TAG, `pinchGesture actionEnd with animate`);
                    this.isRunningPinchAnimation = true;
                    this.eventPipeline?.setCanPanInAnimation(true);
                    animateTo({
                      curve: this.pinchAnimationCurves,
                      onFinish: (): void => {
                        this.eventPipeline?.setCanPanInAnimation(false);
                        this.isGestureMove = true;
                        this.hasHighlightRect = this.highlightRect.length !== 0;
                        this.eventPipeline?.onAnimationEnd(this.animationEndMatrix as Matrix4.Matrix4Transit);
                        this.animationOption = undefined;
                        this.animationEndMatrix = undefined;
                        this.isPhotoChangeLoading = false;
                        this.isRunningPinchAnimation = false;
                        this.isAngleChanged = false;
                        this.eventPipeline?.setIsAngleChange(this.isAngleChanged);
                        Log.info(TAG, `pinchAnimationEnd scale:${this.eventPipeline?.lastScale}`);
                      }
                    }, (): void => {
                      this.matrix = this.animationEndMatrix as Matrix4.Matrix4Transit;
                      if (this.enableEnterInnerPic) {
                        this.eventPipeline?.innerPicPinchAnimationEnd();
                      }
                    })
                    this.verifyPhotoScaled?.(this.matrix);
                    this.updatePhotoScaledStatus();
                    this.updateAbleEnterInnerPic();
                  } else {
                    Log.info(TAG, 'pinchGesture actionEnd no animate');
                    this.updatePhotoScaledStatus();
                    this.updateAbleEnterInnerPic();
                  }
                  if (this.angle === 0) {
                    this.isInRotateState = false;
                  }
                  Log.info(TAG, `pinch end`);
                })
              /* instrument ignore next */
              .onActionCancel((): void => {
                Log.info(TAG, `PinchGesture onActionCancel`);
    /* instrument ignore next */
                if (!this.viewModel.isAllowPinch()) {
                  return;
                }
                this.isInPinch = false;
                this.isGestureMove = true;
                Log.info(TAG,
                  `PinchGesture onActionCancel isInPinch = ${this.isInPinch} animationEndMatrix:${this.animationEndMatrix}`);
                this.eventPipeline?.onScaleEnd();
                this.eventPipeline?.onAnimationEnd(this.animationEndMatrix as Matrix4.Matrix4Transit);
                this.animationOption = undefined;
                this.animationEndMatrix = undefined;
                this.updatePhotoScaledStatus();
                Log.info(TAG, `pinch cancel`);
              }),
            PanGesture(this.panOption)
              .onActionStart((event: GestureEvent): void => {
                performanceMonitor.begin('CUSTOM_ANIMATOR BrowerPanGesture', performanceMonitor?.ActionType.LAST_DOWN);
                if (this.slipBackEnd) {
                  /* instrument ignore next */
                  return;
                }
                if (DeviceInfo.isTv() && !this.isPhotoScaled) {
                  return;
                }
                if (event.source === SourceType.Mouse && event.sourceTool === SourceTool.MOUSE &&
                  event.fingerList[0].id === 0) {
                  /* instrument ignore next */
                  return;
                }
                this.canShowSystemUi = true;
                if (this.isClickRemoveOrHiddenDialog) {
                  /* instrument ignore next */
                  return;
                }
                Log.info(TAG,
                  `isExistGestureEvent: ${this.isExistGestureEvent(event)}, isPullDownOnHorizontal: ${this.isPullDownOnHorizontal(event)}`);
                if (!this.isExistGestureEvent(event) || this.isPullDownOnHorizontal(event)) {
                  /* instrument ignore next */
                  return;
                }
                Log.info(TAG,
                  `PanGesture start, this.isPhotoScaled = ${this.isPhotoScaled} this.eventPipeline?.isInAnimation = ${this.eventPipeline?.isInAnimation}`);
                if (!this.isAllowPan(event)) {
                  /* instrument ignore next */
                  return;
                }
                this.viewModel.hideThumbnailImageFunc();
                this.isPhotoChangeLoading = true;
                this.isGestureMove = false;
                // The first operation is sliding up or has slipped up.
                if ((!this.isPhotoScaled && event.offsetY < 0 || this.viewModel.isPropertiesShow())) {
                  if (this.eventPipeline?.canPan() && !this.isPullDownAndDragPhoto &&
                  this.canPullingUp && MediaLibraryData.isMediaLibraryUri(this.item.uri) && !DeviceInfo.isPc()) {
                    // 详情相关
                    this.onPullUpStart(event);
                    this.viewModel.hideThumbnailImageFunc();
                  }
                } else {
                  if (!this.isDoingDeleteAnim) {
                    /* instrument ignore next */
                    if (DeviceInfo.isPc() && this.isPhotoScaled) {
                      /* instrument ignore next */
                      Log.info(TAG, 'PanGesture onActionStart isPhotoScaled setCursor HAND_GRABBING');
                      /* instrument ignore next */
                      cursorControl.setCursor(pointer.PointerStyle.HAND_GRABBING);
                    }
                    ApsUtil.enableBrowserThrowsApsState();
                    this.isRunningPanAnimation = true;
                    this.eventPipeline?.onMoveStart(event);
                  }
                }
              })
              .onActionUpdate((event: GestureEvent): void => {
                if (this.slipBackEnd) {
                  /* instrument ignore next */
                  return;
                }
                if (DeviceInfo.isTv() && !this.isPhotoScaled) {
                  return;
                }
                if (event.source === SourceType.Mouse && event.sourceTool === SourceTool.MOUSE &&
                  event.fingerList[0].id === 0) {
                  // Temporarily block pan gesture from mouse
                  /* instrument ignore next */
                  return;
                }
                if (this.isClickRemoveOrHiddenDialog) {
                  /* instrument ignore next */
                  return;
                }
                if (!this.isExistGestureEvent(event) || this.isPullDownOnHorizontal(event) ||
                this.isSwitchLibrarySwiper()) {
                  /* instrument ignore next */
                  return;
                }
                Log.debug(TAG, `onActionUpdate ${this.canShowRightMenu} ${this.isPcCameraPull}`);
                if (this.canShowRightMenu) {
                  /* instrument ignore next */
                  return;
                }
                Log.debug(TAG,
                  `PanGesture onActionUpdate scale: ${event.scale}`);
                if (!this.isAllowPan(event)) {
                  /* instrument ignore next */
                  return;
                }
                if (this.viewModel.isPropertiesShow()) {
                  this.doImageSlideByHand(event);
                  return;
                }
                if (this.isNeedShieldPullUpEvent(event)) {
                  /* instrument ignore next */
                  return;
                }
                if (!this.isPhotoScaled && event.offsetY < 0 && this.eventPipeline?.canPan() &&
                  !this.isPullDownAndDragPhoto && this.canPullingUp &&
                  MediaLibraryData.isMediaLibraryUri(this.item.uri) && !DeviceInfo.isPc()) {
                  if (!this.isTouchingPullUp) {
                    this.onPullUpStart(event);
                  }
                  this.doImageSlideByHand(event);
                  return;
                }
                let isNewDragPhoto = this.eventPipeline?.canPullDownAndDragPhoto() ?? false;
                if (isNewDragPhoto !== this.isPullDownAndDragPhoto && !(this.isDetailSelected && DeviceInfo.isPc())) {
                  this.isPullDownAndDragPhoto = isNewDragPhoto;
                  Log.debug(TAG,
                    `isPullDownAndDragPhoto: ${this.isPullDownAndDragPhoto}, geometryTransitionEnable: ${this.geometryTransitionEnable}` +
                      `isOnSwiperAnimation: ${this.viewModel.isOnSwiperAnimation()}, isFromFACard: ${this.isFromFACard}, isDoingDeleteAnim: ${this.isDoingDeleteAnim}`);
                }
                if (this.isPullDownAndDragPhoto && this.geometryTransitionEnable &&
                  !this.viewModel.isOnSwiperAnimation() && !this.isFromFACard && !this.isDoingDeleteAnim) {
                  this.isBrowserFullShow = false;
                  this.doDragPhoto(event.offsetX, event.offsetY);
                  // 将设置状态栏样式的逻辑放到手势移动过程中
                  if (!this.isShowBar && !this.isPhotoScaled && !PhotoConfig.isLibrary() && this.canShowSystemUi) {
                    /* instrument ignore next */
                    getScreen().setSystemUi(true);
                    /* instrument ignore next */
                    getScreen().setImmersiveStatusBarProperties(Constants.COLOR_TRANSPARENT);
                    // 控制状态栏样式只设置一次
                    /* instrument ignore next */
                    this.canShowSystemUi = false;
                  }

                } else {
                  this.eventPipeline?.onMove(event);
                  // 大图移动，清除画中画隐藏定时器
                  this.innerPhotoDealTouchEvent();
                }
              })
              .onActionEnd((event: GestureEvent): void => {
                performanceMonitor.end('CUSTOM_ANIMATOR BrowerPanGesture');
                if (this.slipBackEnd) {
                  /* instrument ignore next */
                  return;
                }
                if (DeviceInfo.isTv() && !this.isPhotoScaled) {
                  return;
                }
                if (event.source === SourceType.Mouse && event.sourceTool === SourceTool.MOUSE &&
                  event.fingerList[0].id === 0) {
                  /* instrument ignore if */
                  if (event.offsetY > 0) {
                    this.swiperController?.showPrevious();
                    /* instrument ignore next */
                  } else if (event.offsetY < 0) {
                    this.swiperController?.showNext();
                  }
                  /* instrument ignore next */
                  return;
                }
                if (this.isClickRemoveOrHiddenDialog) {
                  /* instrument ignore next */
                  return;
                }
                if (!this.isExistGestureEvent(event) || this.isPullDownOnHorizontal(event) ||
                this.isSwitchLibrarySwiper()) {
                  /* instrument ignore next */
                  return;
                }
                Log.info(TAG, `PanGesture end offsetX:${vp2px(event.offsetX)}, offsetY:${vp2px(event.offsetY)},
                    isOnSwiperAnimation:${this.viewModel.isOnSwiperAnimation()},
                    isProgressOnPanGesture:${this.isProgressOnPanGesture},
                    canRespondPanGesture:${this.canRespondPanGesture},
                    propertiesState:${this.viewModel.isPropertiesShow()}, isInSelectedMode:${this.isInSelectedMode},
                    isPhotoScaled:${this.isPhotoScaled}, isPullingDown:${this.isPullingDown},
                    isNeedShieldPullUpEvent:${this.isNeedShieldPullUpEvent(event)},
                    isInRotate:${this.isInRotateAction}`);
                //是否是视频播放滑动条触发，改为逐帧播放后，删除此判断
                if (this.isProgressOnPanGesture) {
                  /* instrument ignore next */
                  this.resetEventOnMainPhotoView();
                  /* instrument ignore next */
                  return;
                }
                  /* instrument ignore next */
                if (!this.canRespondPanGesture) {
                  Log.debug(TAG, 'onActionEnd: is selecting text in ai component, do not respond with panGesture');
                  this.canRespondPanGesture = !this.canRespondPanGesture;
                  this.resetEventOnMainPhotoView();
                  return;
                }
                if (this.viewModel.isPropertiesShow()) {
                  this.doImageSlideOffHand(event);
                  this.resetEventOnMainPhotoView();
                  return;
                }
                if (!this.isShowBar) {
                  getScreen().setSystemUi(false, true, true);
                }
                if (event.offsetY < 0 && this.isInSelectedMode && !this.isPhotoScaled && !this.isPullingDown) {
                  /* instrument ignore next */
                  this.resetEventOnMainPhotoView();
                  /* instrument ignore next */
                  return;
                }
                if (this.viewModel.isOnSwiperAnimation() || this.isNeedShieldPullUpEvent(event) ||
                  this.isInRotateAction) {
                  /* instrument ignore next */
                  this.resetEventOnMainPhotoView();
                  /* instrument ignore next */
                  return;
                }
                /* instrument ignore next */
                if (DeviceInfo.isPc() && this.isPhotoScaled) {
                  /* instrument ignore next */
                  Log.info(TAG, 'PanGesture onActionEnd isPhotoScaled setCursor DEFAULT');
                  /* instrument ignore next */
                  cursorControl.setCursor(pointer.PointerStyle.DEFAULT);
                }
                this.isGestureMove = true;
                this.isRunningPanAnimation = true;
                this.eventPipeline?.onMoveEnd(event, (): void => {
                  /* instrument ignore if */
                  if (!(this.isPhotoScaled && !this.eventPipeline?.canTouch()) && this.animationOption) {
                    animateTo({
                      duration: this.animationOption.duration,
                      curve: this.animationOption.curve as Curve,
                      onFinish: (): void => {
                        this.setPickerBrowserInDragOrBackPress(false);
                        this.eventPipeline?.onAnimationEnd(this.animationEndMatrix as Matrix4.Matrix4Transit);
                        this.animationOption = undefined;
                        this.animationEndMatrix = undefined;
                        this.isPullDownAndDragPhoto = this.eventPipeline?.canPullDownAndDragPhoto() ?? false;
                        this.isBrowserFullShow = true;
                        this.isPhotoChangeLoading = false;
                        this.resetEventOnMainPhotoView();
                        this.isPullingDown = false;
                      }
                    }, (): void => {
                      this.matrix = this.animationEndMatrix as Matrix4.Matrix4Transit;
                      this.isStackModifierChange = !this.isStackModifierChange;
                      UiUtil.resetGeometryTransitionParams();
                      LocalStorage.getShared()?.setOrCreate<number>(Constants.BAR_GEOMETRY_OPACITY, 1);
                    })
                    this.verifyPhotoScaled?.(this.matrix);
                    this.updatePhotoScaledStatus();
                  } else {
                    if (!this.isPullDownAndDragPhoto && this.isPhotoScaled) {
                      this.isPhotoChangeLoading = false;
                    }
                    this.isPullDownAndDragPhoto = this.eventPipeline?.canPullDownAndDragPhoto() ?? false;
                  }
                  this.isRunningPanAnimation = false;
                  ApsUtil.disableBrowserThrowsApsState();
                }, DeviceInfo.isPc() && this.isDetailSelected ? true : undefined,
                  this.virtualKbKeyPC === Constants.PC_VIRTUAL_KB_SHOWN);
              })
              /* instrument ignore next */
              .onActionCancel((): void => {
                this.isPullingDown = false;
                /* instrument ignore if */
                if (DeviceInfo.isPc() && this.isPhotoScaled) {
                  Log.info(TAG, 'PanGesture onActionCancel isPhotoScaled setCursor DEFAULT');
                  cursorControl.setCursor(pointer.PointerStyle.DEFAULT);
                }
                // 大图下拉跟手状态时窗口失焦，事件取消，触发大图回到宫格
                /* instrument ignore if */
                if (this.isPullDownAndDragPhoto) {
                  Log.info(TAG, 'onActionCancel back to grid');
                  this.broadCast.emit(BrowserConstants.PULL_DOWN_END, []);
                }
              }),
            TapGesture({
              count: 2,
            })
              .tag('DoubleTap')
              .onAction((event: GestureEvent): void => {
                if (!this.isExistGestureEvent(event)) {
                  /* instrument ignore next */
                  return;
                }
                this.viewModel.hideThumbnailImageFunc();
                /* instrument ignore next */
                if (DeviceInfo.isPc() && this.viewModel.isVideo()) {
                  /* instrument ignore next */
                  this.appBroadCast.emit(BroadCastConstants.STATE_INVERSION, [this.item.uri]);
                  /* instrument ignore next */
                  return;
                }
                /* instrument ignore next */
                if (DeviceInfo.isPc() && this.isDetailSelected) {
                  return;
                }
                reportImageEnlargeWay(DOUBLE_TAP, event.scale);
                Log.info(TAG, `onDoubleTap event: ${JSON.stringify(event)},
                  isRunningAnimation=${this.isRunningAnimation},
                  isDoingImageSlideAnimation=${this.isDoingImageSlideAnimation}`);
                if (!this.isAllowDoubleTap()) {
                  Log.warn(TAG, 'onDoubleTap: isAllowDoubleTap returned false, aborting');
                  return;
                }
                Log.info(TAG, 'onDoubleTap: calling handleTapGestureEvent');
                this.enterInnerPicWay = EnterInnerPicWay.DOUBLE_TAP;
                this.handleTapGestureEvent(event);
              }),
            TapGesture({
              count: 1,
            })
              .onAction((event: GestureEvent): void => {
                if (!this.isExistGestureEvent(event)) {
                  /* instrument ignore next */
                  return;
                }
                Log.info(TAG,
                  `single tab gesture ${this.isDoingImageSlideAnimation}, currentIndex = ${
                  this.viewModel.getCurrentIndex()}, event = ${JSON.stringify(event)}`);
                if (!this.isAllowSingelTap()) {
                  return;
                }
                /* instrument ignore next */
                if (PhotoConfig.isFromMeetime) {
                  this.onPhotoSingleClick();
                  // 非视频场景，畅连接收到单击回调后会退出大图预览，不需要执行后续逻辑
                  if (!this.viewModel.isVideo()) {
                    return;
                  }
                }
                /* instrument ignore if */
                if (this.isTappingAiButton) {
                  this.isTappingAiButtonChange = false;
                  return;
                }
                /* instrument ignore if */
                if (this.isMenuShow || this.isMenuShowStatusChange) {
                  this.isMenuShowStatusChange = false;
                  return;
                }
                // AI 组件文本选择状态发生变化，例如拖动选择文字，点击空白处等等，此时可能清空了已选中文本
                /* instrument ignore if */
                if (this.isSelectedTextChange || this.hasSelectedText) {
                  this.isSelectedTextChange = false;
                  Log.debug(TAG, `onAction: do not respond with TapGesture, this.isSelectedTextChange = ${
                  this.isSelectedTextChange}, this.hasSelectedText = ${this.hasSelectedText}`);
                  return;
                }
                // if ((!this.isShowVideo) && !(this.isDetailSelected)) {
                //   this.broadCast.emit(BrowserConstants.TOGGLE_BAR, [undefined]);
                // }
                if (!(this.isDetailSelected)) {
                  this.broadCast.emit(BrowserConstants.TOGGLE_BAR, [undefined]);
                }
                if (this.isThird) {
                  /* instrument ignore next */
                  AccessibilityUtil.sendAnnounceAccessibilityEvent(this.getImageItemGridAccessibilityText());
                } else {
                  this.broadCastWhenShowBarChanged();
                }
              }),
            LongPressGesture()
              .onAction((event: GestureEvent): void => {
              })
          )
        )
      )
      .clip(!this.pickerBrowserInDragOrBackPress)
      .onTouch((event: TouchEvent): void => {
        if (this.isInPinch || this.viewModel.isPropertiesShow() || this.viewModel.isDragFocus) {
          return;
        }
        if (event) {
          this.dealTouchEvent(event, true);
          this.eventPipeline?.onTouch(event);
          this.innerPhotoDealTouchEvent();
        }
        Log.debug(TAG, `onTouch: canRespondPanGesture = ${this.canRespondPanGesture}, hasSelectedText = ${
        this.hasSelectedText}`);
      })

      // 视频播放按钮，非自动播放场景保留
      if (this.showVideoPlayButton()) {
        if (this.viewModel.isVideo() && !this.isMeeTimeLoadingStatus()) {
          Row() {
            /* instrument ignore next */
            if (DeviceInfo.isTv()) {
              this.playButtonForTV();
            } else {
              Image($r('app.media.ic_camera_parabar_story_play'))
                .width($r('app.float.icon_video_size'))
                .height($r('app.float.icon_video_size'))
                .objectFit(ImageFit.Contain)
                .playButtonStyle()
            }
          }
          .attributeModifier(this.viewModel.videoButtonRowModifier)
          .onAppear(() => {
            if (!DeviceInfo.isPc()) {
              focusControl.requestFocus('VideoPlayButton');
            }
          })
          .translate(this.isHalfFold && !this.isHorizontal && this.isHalfFoldStateEnable() ?
            { x: 0, y: this.viewModel.windowLayoutHeight / 4 } : {
              x: (this.isFoldExpanded || this.isHorizontal) ? this.viewModel.getImageSlidePullUpOffset() : 0,
              y: (this.isFoldExpanded || this.isHorizontal) ? 0 : this.viewModel.getImageSlidePullUpOffset()
            })
        }
      }

      // 旋转按钮
      if (this.showRotateButton()) {
        Stack({alignContent: Alignment.Center}) {
          Column()
            .width(Constants.PERCENT_100)
            .height(Constants.PERCENT_100)
            .borderRadius(Constants.PERCENT_50)
            .backgroundColor($r('sys.color.ohos_id_blur_style_component_regular_color_dark'))
            .backgroundBlurStyle(BlurStyle.COMPONENT_REGULAR, {
              colorMode: ThemeColorMode.DARK,
            })
          Column()
            .width(Constants.PERCENT_100)
            .height(Constants.PERCENT_100)
            .backgroundColor('#33808080')
            .borderRadius(Constants.PERCENT_50)
          if (this.isHorizontal) {
            Image($r('app.media.ic_rotate_landscape_to_portrait'))
              .width(Constants.ROTATE_BUTTON_ICON_SIZE)
              .height(Constants.ROTATE_BUTTON_ICON_SIZE)
              .fillColor($r('sys.color.ohos_id_color_primary_dark'))
              .draggable(false)
              .matchTextDirection(true)
              .onComplete((event?: completed): void => {
                Log.debug(TAG, `rotateButtonIcon onComplete: isHorizontal:${
                  this.isHorizontal}, loadingStatus:${event?.loadingStatus}, uri:${this.item.uri}`);
              })
          } else {
            Image($r('app.media.ic_rotate_portrait_to_landscape'))
              .width(Constants.ROTATE_BUTTON_ICON_SIZE)
              .height(Constants.ROTATE_BUTTON_ICON_SIZE)
              .fillColor($r('sys.color.ohos_id_color_primary_dark'))
              .draggable(false)
              .matchTextDirection(true)
              .onComplete((event?: completed): void => {
                Log.debug(TAG, `rotateButtonIcon onComplete: isHorizontal:${
                this.isHorizontal}, loadingStatus:${event?.loadingStatus}, uri:${this.item.uri}`);
              })
          }
        }
        .alignContent(Alignment.Center)
        .width(Constants.ROTATE_BUTTON_BACKGROUND_HEIGHT)
        .height(Constants.ROTATE_BUTTON_BACKGROUND_HEIGHT)
        .borderRadius(Constants.PERCENT_50)
        .shadow({
          radius: Constants.ROTATE_BUTTON_SHADOW_RADIUS,
          color: $r('app.color.ohos_id_color_whiteIcon_blackPlane'),
          offsetX: Constants.ROTATE_BUTTON_SHADOW_OFFSET,
          offsetY: Constants.ROTATE_BUTTON_SHADOW_OFFSET,
        })
        .position({
          end: LengthMetrics.vp(Constants.ROTATE_BUTTON_POSITION),
          bottom: LengthMetrics.vp(Constants.ROTATE_BUTTON_POSITION),
        })
        .markAnchor({
          start: LengthMetrics.vp(this.rotateButtonOffsetX),
          top: LengthMetrics.vp(this.rotateButtonOffsetY),
        })
        .key('RotateButton')
        .accessibilityLevel('yes')
        .accessibilityText($r('app.string.phone_rotate'))
        .accessibilityGroup(true)
        .accessibilityRole(AccessibilityRoleType.BUTTON)
        .direction(Direction.Auto)
        /* instrument ignore next */
        .onClick((event: ClickEvent) => {
          if (this.rotateController) {
            this.rotateController.handlePhoneRotate();
            AccessibilityUtil.sendFocusAccessibilityEvent('RotateButton', 500);
          }
        })
      }

      if (!this.isDoingDeleteAnim && !this.isPullingDown && !this.isPullDownAndDragPhoto &&
        !this.isRunningAnimation && !this.isInAnimateToPosition && !this.isShowVideo &&
        !(this.viewModel.isPropertiesShow() && this.isFullMode) && !this.viewModel.isVideo()) {
        // 用于监听上面的值，然后focus
        Column() {
        }
        .visibility(Visibility.None)
        .onAppear((): void => {
          /* instrument ignore next */
          if (DeviceInfo.isPc() && !AppStorage.get<boolean>('hasDeleteDialog')) {
            focusControl.requestFocus(`browserFocusColumn${this.item?.uri}`);
          }
        })
      }
      // ackUI在position=0时不会走complete回调，在此规避
      if (this.isShowLoadingPanel()) {
        LoadingPanel();
      }

      if (this.enableEnterInnerPic) {
        /* instrument ignore next  */
        ImageToolComponent({
          item: this.item,
          imageToolInnerState: this.imageToolInnerState,
          eventPipeline: this.eventPipeline,
          rotateValue: this.rotateValue
        })
      }
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_100)
    .onAreaChange((oldValue: Area, newValue: Area) => {
      if (typeof newValue?.width === 'number' && typeof newValue?.height === 'number') {
        this.fullComponentWidth = vp2px(newValue.width);
        this.fullComponentHeight = vp2px(newValue.height);
        if (this.isShowHighlight()) {
          /* instrument ignore next  */
          this.changeHighlightRectPos();
        }
      }
    })
    .bindContextMenu(this.RightClickMenuBuilder, this.isNeedResponseType() ? ResponseType.RightClick : -1,
      this.PCContext())
    .bindContextMenu(this.RightClickMenuBuilder, this.isNeedResponseType() ? ResponseType.LongPress : -1,
      this.PCContext())
    .onAttach(() => {
      Log.info(TAG, `browserAnimController.isTransitionEnable: ${this.browserAnimController?.isTransitionEnable}`);
      if (!this.browserAnimController?.isTransitionEnable) {
        this.photoBrowserStateMachine.processInitialAnimationEvent();
        this.viewModel.readyToPlayAnim();
      }
    });
  }

  // 是否拦截手势
  private isSupportRejectGesture(gestureInfo: GestureInfo): boolean {
    if (!this.item.getIsMovingPhoto?.()) {
      return false;
    }
    /* instrument ignore next */
    if (gestureInfo.type !== GestureControl.GestureType.TAP_GESTURE) {
      return false;
    }
    /* instrument ignore next  */
    return true;
  }

  // 是否加载loading图标
  private isShowLoadingPanel(): boolean {
    Log.info(TAG, `isLoading: ${this.isLoading}, isRunningAnimation: ${this.isRunningAnimation},
      isFromFACard: ${this.isFromFACard}, mIsCurrent: ${this.mIsCurrent}, isOriginLoading ${this.isOriginLoading}`);
    if (this.isFromFACard) {
      return this.isOriginLoading;
    }
    if (this.isRunningAnimation) {
      return false;
    }
    if (!this.mIsCurrent) {
      return false;
    }
    return this.isLoading || this.isOriginLoading;
  }

  // 是否支持删除时执行模糊动效
  private isSupportBlurEnabled(): boolean {
    // nova规格： nova去除模糊动效
    /* instrument ignore next */
    if (DeviceInfo.isSupportRemoveBlurEnabled()) {
      return false;
    }
    if (this.item.uniqueId !== this.currentDeleteID) {
      return false;
    }
    return true;
  }

  /* instrument ignore next */
  @Builder
  playButtonForTV() {
    Button({ type: ButtonType.Circle }) {
      SymbolGlyph($r('sys.symbol.play_fill')).fontSize(PLAY_BUTTON_SIZE).fontColor([$r('sys.color.icon_primary')]);
    }
    .width(Constants.TV_PLAY_BUTTON_WIDTH_HEIGHT)
    .height(Constants.TV_PLAY_BUTTON_WIDTH_HEIGHT)
    .backgroundColor('#66F1F3F5')
    .borderWidth(0.5)
    .borderColor($r('app.color.tv_icon_button_border_color'))
    .backdropBlur(50)
    .shadow({
      radius: 8,
      color: SHADOW_COLOR,
      offsetX: 0,
      offsetY: 4,
    })
    .playButtonStyle()
  }

  /* instrument ignore next */
  @Styles
  playButtonStyle() {
    .draggable(false)
    .key('VideoPlayButton')
    .accessibilityLevel('yes')
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .accessibilityText($r('app.string.play'))
    .onClick((): void => {
      this.getUIContext()?.getFocusController()?.clearFocus();
      this.handlePauseClick()
      AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_BUTTON_BrowserBack);
    })
    /* instrument ignore next  */
    .onKeyPreIme((event: KeyEvent) => {
      if (DeviceInfo.isPc() && event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_DOWN) {
        return true;
      }
      /* instrument ignore next  */
      return false;
    })
    .focusBox({
      strokeWidth: LengthMetrics.px(0),
    })
    .tabIndex(IndexFocusOrder.PHOTO_GRID_VIEW)
  }

  private handleTapGestureEvent(event: GestureEvent): void {
    Log.info(TAG, `handleTapGestureEvent entry, isFullMode=${this.isFullMode}, animationOption=${this.animationOption}`);
    event.fingerList = isFilterListEmpty(event.fingerList);
    if (event.fingerList.length > 0) {
      this.isPhotoChangeLoading = true;
      let componentWidth: number =
        vp2px(this.viewModel.windowLayoutWidth - ((DeviceInfo.isPc() && this.isShowSideBar) ? this.sideBarWidth :
          0) - ((DeviceInfo.isPc() && this.isDetailSelected) ? Constants.PROPERTIES_WIDTH : 0));

      let phoneComponentHeight: number = DeviceInfo.isHalfFoldState() ?
        vp2px(getScreen().getWinLayoutHeight()) / 2 : vp2px(getScreen().getWinLayoutHeight());
      let currentComponentHeight = DeviceInfo.isPc() ? vp2px(getScreen().getWinHeight()) : phoneComponentHeight;
      let componentHeight: number = currentComponentHeight - ((DeviceInfo.isPc() && this.isShowBar) ?
        vp2px(this.previewStackHeight + this.viewModel.calcBarTopHeight(this.statusBarHeight)) : 0);

      Log.info(TAG, `handleTapGestureEvent calling onDoubleTap, localX=${event.fingerList[0].localX}, localY=${event.fingerList[0].localY}`);
      this.eventPipeline?.onDoubleTap(event.fingerList[0].localX,
        this.isHalfFold && (event.fingerList[0].localY >= this.viewModel.windowLayoutHeight / 2) ?
          (event.fingerList[0].localY - this.viewModel.windowLayoutHeight / 2) :
        event.fingerList[0].localY, componentWidth, componentHeight);
      Log.info(TAG, `handleTapGestureEvent after onDoubleTap, animationOption=${this.animationOption}`);
      this.calcLoadingPosition();
    }
    if (this.animationOption) {
      Log.info(TAG, `TapGesture animateTo start, isFullMode=${this.isFullMode}`);
      this.eventPipeline?.setSwipeStatus(false);
      this.eventPipeline?.setCanPanInAnimation(true);
      animateTo({
        duration: this.animationOption.duration,
        curve: this.doubleTapCurves,
        onFinish: (): void => {
          this.eventPipeline?.setCanPanInAnimation(false);
          this.eventPipeline?.onAnimationEnd(this.animationEndMatrix as Matrix4.Matrix4Transit);
          this.animationOption = undefined;
          this.animationEndMatrix = undefined;
          this.isPhotoChangeLoading = false;
          this.isGestureMove = true;
        }
      }, (): void => {
        this.matrix = this.animationEndMatrix as Matrix4.Matrix4Transit;
        this.viewModel.stackModifier?.attribute?.transform(this.matrix);
      })
      this.verifyPhotoScaled?.(this.matrix);
      this.updatePhotoScaledStatus();
      this.updateAbleEnterInnerPic();
      // 全屏图片，不通过watch 初始化小图位置大小
      if (this.enableEnterInnerPic) {
        /* instrument ignore next  */
        this.eventPipeline?.getInnerSmaPicInfo();
      }
    } else {
      Log.warn(TAG, `handleTapGestureEvent: animationOption is undefined, cannot start animation, isFullMode=${this.isFullMode}`);
    }
  }
  /* instrument ignore next  */
  private isFromFileManager(): boolean {
    Log.info(TAG, `isFromFileManager viewData:${this.viewData}`);
    const fileManagerStr = 'file://docs';
    return this.viewData.includes(fileManagerStr);
  }

  private isNeedResponseType(): boolean {
    return DeviceInfo.isPc() && this.isNeedRightMenu && !this.isFromFileManager();
  }

  /* instrument ignore next */
  private PCContext(): ContextMenuOptions {
    return {
      modalMode: ModalMode.TARGET_WINDOW,
      onAppear: () => {
        Log.info(TAG, 'photoItem bindContextMenu onAppear');
        this.canShowRightMenu = true;
      },
      aboutToDisappear: () => {
        Log.info(TAG, 'photoItem bindContextMenu aboutToDisappear');
        setTimeout((): void => {
          this.canShowRightMenu = false;
        }, 100);
      }
    };
  }

  /* instrument ignore next */
  public onVideoPlayButtonClick(): void {
    Log.info(TAG, `onVideoPlayButtonClick isSupportedVideoType:${this.isSupportedVideoType}`);
    if (this.isSupportedVideoType) {
      this.onVideoPlayIconClicked();
    } else {
      UiUtil.showToast($r('app.string.unsupported_video_type'));
    }
  }

  public async onVideoPlayIconClicked(): Promise<void> {
    TraceControllerUtils.startTraceWithTaskId('videoPlayerClickButton', AvPlayConstants.TRACE_ID_OF_PLAY_BUTTON);
    Log.info(TAG,
      `[videoPlayer] video play thumbail: ${JSON.stringify(this.thumbnail)}, duration: ${this.item.duration}, orientation: ${this.item.orientation}`);
    // 文件位置信息，目前不支持position字段变更通知，需要实时查询
    let fileAsset: PhotoAsset;
    if (UserFileManagerAccess.isRecycleBin(this.albumUri)) {
      /* instrument ignore next  */
      fileAsset = await UserFileManagerAccess.getInstance().getTrashAssetByUri(this.item.uri) as PhotoAsset;
    } else {
      fileAsset = await UserFileManagerAccess.getInstance()
        .getObject(AlbumDefine.getFileFetchOptByUri(this.item.uri)) as PhotoAsset;
    }
    if (fileAsset) {
      let filePosition: photoAccessHelper.PositionType =
        fileAsset.get(photoAccessHelper.PhotoKeys.POSITION.toString()) as photoAccessHelper.PositionType;
      if (filePosition === UserFileManagerAccess.FILE_LOCATION_CLOUD) {
        /* instrument ignore next  */
        let networkStatus: boolean | undefined = AppStorage.get(Constants.APP_STORAGE_KEY_OF_NETWORK_AVAILABLE);
        /* instrument ignore next  */
        Log.info(TAG,
          `[videoPlayer] play video from cloud, photoItem networkAvailable: ${this.networkAvailable}, global networkStatus: ${networkStatus}`);
        /* instrument ignore if  */
        if (!this.networkAvailable) {
          // 网络不可用
          UiUtil.showToast($r('app.string.no_network'));
          VideoPlayerBigDataReport.cloudVideoNetworkNoService();
          return;
        }
        this.animatePlayVideo(true);
        return;
      }
    }
    this.animatePlayVideo(false);
  }

  private animatePlayVideo(isCloud: boolean): void {
    if (this.isVideoToEnd && this.isFrameExpand) {
      /* instrument ignore next  */
      animateTo({
        curve: BrowserConstants.CLICK_PLAY_FRAME_EXPAND_LIST_CURVE,
        onFinish: (): void => {
          this.cloudOrLocalPlayVideo(isCloud);
        }
        /* instrument ignore next  */
      }, (): void => {
        this.broadCast.emit(BrowserConstants.VIDEO_SCROLL_TO_START, []);
      })
    } else {
      this.cloudOrLocalPlayVideo(isCloud);
    }
  }

  private cloudOrLocalPlayVideo(isCloud: boolean): void {
    if (isCloud) {
      /* instrument ignore next  */
      this.playVideoFromCloudSync();
    } else {
      this.playVideo();
    }
  }

  /* instrument ignore next */
  downloadFile(): void {
    // 原图只在云端，需要先下载
    if (!this.networkAvailable) {
      // 网络不可用，提示无法下载
      UiUtil.showToast($r('app.string.no_network'));
      return;
    }
    // 重复触发下载，会导致进度混乱
    if (this.isVideoDownloading) {
      Log.warn(TAG, 'repeated download is prohibited.');
      return;
    }
    let startTime: number;

    // 图片下载完毕的回调
    let downloadFinishCallback: Function = (err: string = ''): void => {
      ReportToBigDataUtil.downloadOriginReport(BigDataConstants.DOWNLOAD_FOR_VIDEO_PLAY, Date.now() - startTime, err);
      if (err) {
        return;
      }
      this.isVideoDownloading = false;
      Log.info(TAG, `downloadFinishCallback video: ${this.item.uri}`);
      // 下载完成打点
      interface Msg {
        scene: string;
        network: string;
        size: number;
        timeCost: number;
      }

      let msg: Msg = {
        scene: BigDataConstants.DOWNLOAD_FOR_VIDEO_PLAY,
        network: this.networkAvailable ? BigDataConstants.NETWORK_AVAILABLE : BigDataConstants.NETWORK_UNAVAILABLE,
        size: this.item.size,
        timeCost: Date.now() - startTime,
      }
      ReportToBigDataUtil.report(BigDataConstants.DOWNLOAD_ORIGIN_PHOTO_ID, msg);
      // 下载完成后跳转
      this.playVideoFromCloudSync();
    }
    // 下载起始时间
    startTime = Date.now();
    Log.info(TAG, `startDownload current click video: ${this.item.uri}`);
    this.isVideoDownloading = true;
    this.broadCast.emit(BroadCastConstants.SHOW_DOWNLOAD_PROGRESS_DIALOG, [this.item.uri]);
    return;
  }

  private playVideo() {
    this.exitImmersiveMode();
    this.appBroadCast.emit(BroadCastConstants.UPDATE_MENU_BEFORE_PLAY_VIDEO, []);
    this.appBroadCast.emit(BroadCastConstants.PLAY_VIDEO, [false, this.item.uniqueId]);
    this.isShowVideo = true;
    if (!this.isFrameExpand && !this.isInSelectedMode) {
      this.broadCast.emit(BroadCastConstants.PLAY_ICON_CLICK_FRAME_EXPAND, [this.item.uri, true]);
    }
  }

  /* instrument ignore next */
  private playVideoFromCloudSync() {
    this.exitImmersiveMode();
    this.appBroadCast.emit(BroadCastConstants.UPDATE_MENU_BEFORE_PLAY_VIDEO, []);
    this.appBroadCast.emit(BroadCastConstants.PLAY_VIDEO, [true, this.item.uniqueId]);
    this.isShowVideo = true;
    if (!this.isFrameExpand && !this.isInSelectedMode) {
      this.broadCast.emit(BroadCastConstants.PLAY_ICON_CLICK_FRAME_EXPAND, [this.item.uri, true]);
    }
  }

  private isMeeTimeLoadingStatus(): boolean {
    const isMeeTimeLoadingStatus = this.item && PhotoConfig.isFromMeetime && this.item.isResourceLoading === true;
    Log.info(TAG, `[isMeeTimeLoadingStatus] ${isMeeTimeLoadingStatus}`);
    return isMeeTimeLoadingStatus;
  }

  private isMovingPhoto(): boolean {
    if (this.item.isThumbnailMovingPhoto && !this.item.uri) {
      Log.info(TAG, `isThumbnailMovingPhoto: ${this.item.isThumbnailMovingPhoto}`);
      /* instrument ignore next  */
      return true;
    }

    let currentIsMovingPhoto: boolean = this.item && this.item.getIsMovingPhoto?.();
    // Log.info(TAG, `check isMovingPhoto:${currentIsMovingPhoto}, exist: ${this.item.getMovingPhoto()}`);
    if (!currentIsMovingPhoto) {
      return false;
    }
    this.movingPhotoPageFrom = this.pageFrom;
    return true;
  }

  /* instrument ignore next */
  showFastEditProcessing(): void {
    this.fastEditProcessingPosition = PhotoScaleUtil.getCornerPosition(
      this.item.width, this.item.height, this.getPhotoScaledRatio(this.matrix)
    );
    this.isFastEditProcessing = true;
    Log.info(TAG, 'start showFastEditProcessing loading: ' + this.fastEditProcessingPosition[0] +
      ',' + this.fastEditProcessingPosition[1]);
  }

  /* instrument ignore next */
  printFastEditStatus(type: string): void {
    let index = this.item.uri?.lastIndexOf('\/');
    let imageUri = this.item.uri?.substring(0, index);
    let indexPrev = imageUri?.lastIndexOf('\/');
    if (index - indexPrev > ANONYMIZATION_COUNT) {
      imageUri = this.item.uri?.substring(0, indexPrev + ANONYMIZATION_COUNT);
    } else {
      imageUri = this.item.uri?.substring(0, index);
    }
    imageUri += '***';
    let msg: UriMsg = {
      uri: imageUri,
      type: type,
    }
    Log.info(TAG, `printFastEditStatus: ${type}`);
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_FAST_EDIT_BEAUTY, msg);
    return;
  }

  /**
   * 手势响应事件是否存在
   */
  private isExistGestureEvent(event: GestureEvent): boolean {
    if (!event) {
      /* instrument ignore next */
      Log.warn(TAG, 'gesture event does not exist');
      /* instrument ignore next */
      return false;
    }
    return true;
  }

  /**
   * 是否允许响应滑动事件
   */
  private isAllowPan(event: GestureEvent): boolean {
    //是否是视频播放滑动条触发，改为逐帧播放后，删除此判断
    if (this.isProgressOnPanGesture || (this.viewModel.isPropertiesShow()) || this.viewModel.isDragFocus || this.isInRotateAction) {
      Log.warn(TAG, 'Not allow to pan');
      return false;
    }
    if (!this.canRespondPanGesture) {
      Log.debug(TAG, 'onActionStart: is selecting text in ai component, do not respond with panGesture');
      return false;
    }

    if (event.offsetY < 0 && this.isInSelectedMode && !this.isPhotoScaled && !this.isPullingDown) {
      /* instrument ignore next */
      return false;
    }
    return true;
  }

  /**
   * 是否允许响应双击事件
   */
  private isAllowDoubleTap(): boolean {
    if (this.viewModel.isPropertiesShow() || this.isDoingImageSlideAnimation ||
    this.item.isInvalidImageSize()) {
      Log.warn(TAG, `Not allow to double tap: isPropertiesShow=${this.viewModel.isPropertiesShow()}, 
        isDoingImageSlideAnimation=${this.isDoingImageSlideAnimation}, 
        isInvalidImageSize=${this.item.isInvalidImageSize()}`);
      return false;
    }
    // 下拉过程屏蔽双击
    if (this.isPullingDown) {
      Log.info(TAG, `Not allow to double tap when pullingDown: ${this.isPullingDown}`);
      return false;
    }
    // 外屏视频双击屏蔽放大
    if (this.isSubScreen && this.viewModel.isVideo()) {
      Log.info(TAG, `Not allow to double tap: isSubScreen=${this.isSubScreen}, isVideo=${this.viewModel.isVideo()}`);
      return false;
    }

    // tv屏蔽双击放大
    if (DeviceInfo.isTv()) {
      Log.info(TAG, 'Not allow to double tap on TV device');
      return false;
    }
    Log.info(TAG, 'isAllowDoubleTap: allowed');
    return true;
  }

  /**
   * 是否允许响应单击事件
   */
  private isAllowSingelTap(): boolean {
    if (this.viewModel.isPropertiesShow() || this.isDoingImageSlideAnimation) {
      return false;
    }
    return true;
  }

  /**
   * 大图上滑启动
   */
  private onPullUpStart(event: GestureEvent): void {
    Log.info(TAG, 'onPullUpStart');
    if ((this.skipCurrentPullUpAnimate && this.photoPropertiesComponentScrollY == 0) || this.eventOnMainPhotoView) {
      this.skipCurrentPullUpAnimate = false;
    }
    if (event.offsetY < 0 && (event.offsetY + this.viewModel.getImageSlidePullUpOffset() +
    this.viewModel.imageSlideTargetOffset) < 0 && this.isFullMode) {
      this.isTouchingPullUp = true;
      Log.info(TAG, `PanGesture start pull up ${event.offsetY}`);
      return;
    }
    this.imageSlideCurrentOffset = this.viewModel.getImageSlidePullUpOffset();
    this.photoPropertiesCurrentOpacity = this.viewModel.photoPropertiesOpacity;
    this.imageSlideCurrentScale = this.viewModel.isVideo() ? 1 : this.viewModel.getImageSlideScale();
    this.broadCast.emit(BrowserConstants.HIDE_BARS, [$r('sys.color.comp_background_gray')]);
    if (event.offsetY < 0) {
      this.viewModel.clipWidthPercentage = this.viewModel.clipWidthStartPercentage;
      this.viewModel.printSaliencyStatus(BigDataConstants.PHOTO_SALIENCY_PULL_UP);
      if (AlbumUtils.useReleaseDayGrid()) {
        this.getUIContext().getFocusController().clearFocus();
      }
    } else {
      this.controllerTextArea.stopEditing();
      this.controllerTextInput.stopEditing();
      this.controllerPortraitInput.stopEditing();
      focusControl.requestFocus(`browserFocusColumn${this.item?.uri}`);
    }
    this.clipWidthCurrentPercentage = this.viewModel.clipWidthPercentage;
    this.viewModel.setPropertiesState(true);
    if (((this.photoPropertiesComponentScrollY == 0 && (this.viewModel.getImageSlidePullUpOffset() +
    this.viewModel.imageSlideTargetOffset) == 0)) || this.eventOnMainPhotoView) {
      this.isDoingImageSlideAnimation = true;
    }
    this.isTouchingPullUp = true;
    Log.info(TAG, `PanGesture start pull up ${event.offsetY}`);
  }

  /**
   * 大图上滑跟手动效
   */
  private doImageSlideByHand(event: GestureEvent): void {
    Log.debug(TAG, 'pull up by hand');
    this.isDoingSlideUpAnimation = event.offsetY < 0;
    if (event.offsetY <= 0 && this.viewModel.getImageSlidePullUpOffset() + this.viewModel.imageSlideTargetOffset >
      0 && (!this.skipCurrentPullUpAnimate || this.eventOnMainPhotoView)) {
      // 上滑详情页
      animateTo({
        curve: Curves.responsiveSpringMotion(),
      }, (): void => {
        this.viewModel.setImageSlidePullUpOffset(event.offsetY + this.imageSlideCurrentOffset);
        if (this.viewModel.getImageSlidePullUpOffset() + this.viewModel.imageSlideTargetOffset <= 0) {
          this.viewModel.setImageSlidePullUpOffset(-this.viewModel.imageSlideTargetOffset);
        }
        this.viewModel.photoPropertiesOpacity =
          Math.abs(event.offsetY / this.viewModel.imageSlideTargetOffset) + this.photoPropertiesCurrentOpacity;
        if (this.viewModel.isVideo()) {
          this.viewModel.setImageSlideScale(1);
        } else if (this.viewModel.getOnlyShowProperties()) {
          this.viewModel.setImageSlideScale(this.imageSlideCurrentScale);
        } else {
          this.viewModel.setImageSlideScale(Math.abs(event.offsetY * (this.viewModel.imageSlideTargetScale -
            1) / this.viewModel.imageSlideTargetOffset) + this.imageSlideCurrentScale);
        }
        this.viewModel.clipWidthPercentage = this.clipWidthCurrentPercentage - Math.abs(event.offsetY *
          (this.viewModel.clipWidthStartPercentage - this.viewModel.clipWidthTargetPercentage) /
        this.viewModel.imageSlideTargetOffset);
        this.viewModel.clipWidthPercentage = Math.max(this.viewModel.clipWidthTargetPercentage,
          this.viewModel.clipWidthPercentage);
        this.viewModel.calcSaliencyImageSlide();
      })
    } else if (event.offsetY > 0 && ((this.photoPropertiesComponentScrollY === 0 &&
      !this.skipCurrentPullUpAnimate) || this.eventOnMainPhotoView)) {
      // 下滑详情页
      animateTo({
        curve: Curves.responsiveSpringMotion(),
      }, (): void => {
        this.viewModel.setImageSlidePullUpOffset(event.offsetY + this.imageSlideCurrentOffset);
        if (this.viewModel.getImageSlidePullUpOffset() >= 0) {
          this.viewModel.setImageSlidePullUpOffset(0);
        }
        let toolBarHeightAndBottom: number = Constants.ToolBarHeight + this.viewModel.aiBarBottomHeight;
        this.viewModel.photoPropertiesOpacity = this.photoPropertiesCurrentOpacity - event.offsetY /
          (this.viewModel.imageSlideTargetOffset - toolBarHeightAndBottom / this.viewModel.ratioOffset);
        if (this.viewModel.isVideo()) {
          this.viewModel.setImageSlideScale(1);
        } else {
          let currentImageSlideScale = this.imageSlideCurrentScale - Math.abs(event.offsetY *
            (this.viewModel.imageSlideTargetScale - 1) / this.viewModel.imageSlideTargetOffset);
          this.viewModel.setImageSlideScale(currentImageSlideScale > 1 ? currentImageSlideScale : 1);
        }
        this.viewModel.clipWidthPercentage = Math.abs(event.offsetY * (this.viewModel.clipWidthStartPercentage -
          this.viewModel.clipWidthTargetPercentage) / this.viewModel.imageSlideTargetOffset) +
          this.clipWidthCurrentPercentage;
        this.viewModel.calcSaliencyImageSlide();
      })
    }

    if (event.offsetY > 0 && this.photoPropertiesComponentScrollY !== 0 && (this.viewModel.imageSlideTargetOffset +
    this.viewModel.getImageSlidePullUpOffset() === 0) && !this.eventOnMainPhotoView) {
      this.skipCurrentPullUpAnimate = true;
    }
  }

  private focusToDetailComponent(): void {
    if (this.isOpenTouchGuide) {
      /* instrument ignore next  */
      Log.info(TAG, 'Photo properties pulled up,focus to detail component');
      /* instrument ignore next  */
      AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_TEXT_INPUT, FOCUS_COMMON_DELAY);
    }
  }

  private focusToBackButton(): void {
    if (this.isOpenTouchGuide) {
      Log.info(TAG, 'Photo properties pulled down,focus to back Button ');
      AccessibilityUtil.sendFocusAccessibilityEvent(Constants.COMPONENT_KEY_BUTTON_BrowserBack, FOCUS_COMMON_DELAY);
    }
  }

  /**
   * 大图上滑离手动效
   */
  private doImageSlideOffHand(event: GestureEvent): void {
    if (event.offsetY <= 0) {
      animateTo({
        // 弹簧设置:默认刚性阻尼228 30
        curve: Curves.springMotion(0.416, 0.99),
        onFinish: (): void => {
          if (this.isDoingSlideUpAnimation) {
            this.isDoingImageSlideAnimation = false;
            Log.info(TAG, `doImageSlideOffHand finished`);
            let msg: UriMsg = {
              uri: this.item.uri,
              type: BigDataConstants.PHOTO_DETAIL_PULL_UP,
            }
            ReportToBigDataUtil.report(BigDataConstants.PHOTO_DETAIL_OPEN_COUNT, msg);
          }
        }
      }, (): void => {
        this.viewModel.setImageSlidePullUpOffset(this.viewModel.updateImageSlideTargetOffset());
        this.viewModel.photoPropertiesOpacity = 1;
        this.viewModel.setImageSlideScale(this.viewModel.isVideo() ? 1 : this.viewModel.imageSlideTargetScale);
        this.viewModel.clipWidthPercentage = this.viewModel.clipWidthTargetPercentage;
        this.imageTargetPullHeight = this.viewModel.imageSlideTargetOffset * this.viewModel.ratioOffset;
        this.viewModel.toSaliencyImageSlideTargetState();
        this.focusToDetailComponent();
      })
    } else if (event.offsetY > 0 && (!this.skipCurrentPullUpAnimate || this.eventOnMainPhotoView)) {
      animateTo({
        // 弹簧设置:默认刚性阻尼228 30
        curve: Curves.springMotion(0.416, 0.99),
        onFinish: (): void => {
          if (this.isRunningAnimation) {
            /* instrument ignore next  */
            return;
          }
          if (!this.isDoingSlideUpAnimation && this.isDoingImageSlideAnimation) {
            this.isDoingImageSlideAnimation = false;
            this.isPhotoChangeLoading = false;
            this.viewModel.clipWidthPercentage = 1;
          }
        }
      }, (): void => {
        this.viewModel.resetImageSlideInitState();
        this.viewModel.initSaliencyImageSlide();
      });
      Log.info(TAG, `doImageSlideOffHand`);
      this.viewModel.setPropertiesState(false);
      this.broadCast.emit(BrowserConstants.SHOW_BARS, [$r('sys.color.comp_background_gray')]);
      this.focusToBackButton();
    }

    if ((event.offsetY > 0 && this.photoPropertiesComponentScrollY !== 0) &&
      ((this.viewModel.imageSlideTargetOffset + this.viewModel.getImageSlidePullUpOffset()) === 0) &&
      !this.eventOnMainPhotoView) {
      this.isDoingImageSlideAnimation = false;
      this.skipCurrentPullUpAnimate = true;
    }
    /* instrument ignore next  */
    this.isTouchingPullUp = false;
    /* instrument ignore next  */
    this.onEventPullUpRespond();
  }

  /**
   * 下拉跟手动效具体实现，用于更新图片组件的 scale 和 offset 属性，已经大图页面其他组件的 opacity 不透明度属性
   *
   * @param offsetX 用户手指当前较解除屏幕时刻的水平偏移值，单位 dp
   * @param offsetY 用户手指当前较解除屏幕时刻的竖直偏移值，单位 dp
   */
  doDragPhoto(offsetX: number, offsetY: number): void {
    Log.debug(TAG, 'PanGestureUpdate isPullDownAndDragPhoto');
    this.setPickerBrowserInDragOrBackPress(true);
    animateTo({
      duration: BrowserConstants.DRAG_ANIMATION_DURATION,
    }, (): void => {
      let distanceY = Math.abs(offsetY);
      this.geometryOffsetX = offsetX;
      this.geometryOffsetY = offsetY;

      // Calculate image size by distance Y, min size is 50%
      let calcGeometryScale = 1 - distanceY * BrowserConstants.DRAG_SCALE;
      this.geometryScale = calcGeometryScale > BrowserConstants.MIN_DRAG_SCALE ?
        calcGeometryScale : BrowserConstants.MIN_DRAG_SCALE;
      Log.info(TAG, `doGragPhoto: geometryScale: ${this.geometryScale} calcGeometryScale: ${calcGeometryScale} BrowserConstants.MIN_DRAG_SCALE: ${BrowserConstants.MIN_DRAG_SCALE}`);
      // 通过modifier单属性刷新，避免状态变量变更导致重新布局
      this.viewModel.onStable();

      // Calculate image opacity by distance Y, min opacity is 0
      let calcTouchOpacity = 1 - distanceY / (this.viewModel.windowLayoutHeight / 2);
      this.calcTouchOpacity = calcTouchOpacity;
      let touchOpacity = calcTouchOpacity > 0 ? calcTouchOpacity : 0;
      let offY = vp2px(offsetY);
      if (offY > Constants.PULLDOWN_OPACITY_THRESHOLD) {
        animateTo(
          {
            duration: Constants.PULLDOWN_OPACITY_ANIMATE_TIME,
            curve: Curve.Sharp,
          }, () => {
          LocalStorage.getShared()?.setOrCreate<number>(Constants.BAR_GEOMETRY_OPACITY, 0);
        })
      }
      LocalStorage.getShared()?.setOrCreate<number>('geometryOpacity', touchOpacity);
    })
  }

  private onRotationAngleChanged(): void {
    /* instrument ignore next */
    this.viewModel.isHorizontal = this.isHorizontal;
    this.updateRatioOffset()
    this.viewModel.initCalcClipWidth();
    this.viewModel.onResetPullingUpState();
    this.calcLoadingPosition();
    this.setRotateButtonOffset();
    this.viewModel.updateSystemUi();
    // 画中画参数 更新
    this.initImageTool();
    // 画中画 隐藏定时器更新
    this.innerPhotoDealTouchEvent();
    this.eventPipeline?.innerPicPanAnimationEnd();

    // 切换横屏驱动刷新OCR
    if (this.isShowHighlight() && this.isHorizontal) {
      this.hasHighlightRect = false;
    }
  }

  /*
   * phone模式,折叠屏非展开状态，横屏卡片300，竖屏自适应计算，方式变更，横竖屏切换时需重置相关变量
   */
  updateRatioOffset(): void {
    if ((DeviceInfo.isPhoneUx() && !FoldUtil.isTriExpand(this.curFoldStatus)) &&
      getScreen().getWinMode() !== WindowMode.UNDEFINED && !this.isFoldExpanded && !this.isThird) {
      this.viewModel.updatePhoneRatioOffset(this.currentImageWidth, this.currentImageHeight);
      this.updateListCardWidth();
    }
    if (this.isTabletOrTriExpand() &&
      getScreen().getWinMode() == WindowMode.PRIMARY && !this.isHorizontal) {

      /* instrument ignore next  */
      this.viewModel.resetImageSlideInitState();
    }
  }

  private updateTargetPullHeight(imageTargetPullHeight: number): void {
    this.imageTargetPullHeight = imageTargetPullHeight;
  }

  /**
   * 大图上滑动效相关变量计算
   */
  private calculateImageSlideInfo(): void {
    Log.debug(TAG, `calculateImageSlideInfo, item is ${this.item.getTitle?.()}, propertiesState is ${
      this.viewModel.isPropertiesShow()}, mIsCurrent is ${this.mIsCurrent}`);
    let screenWidth = vp2px(this.viewModel.windowLayoutWidth);
    let screenHeight = vp2px(this.viewModel.windowLayoutHeight);
    if (this.viewModel.isVideo()) {
      this.viewModel.imageSlideTargetScale = 1;
    } else if (this.viewModel.minWidthOrHeight !== 0) {
      this.viewModel.imageSlideTargetScale = Math.min(screenWidth, screenHeight) / this.viewModel.minWidthOrHeight;
    }
    this.viewModel.updateImageSlideInfo(this.currentImageWidth, this.currentImageHeight);
    this.viewModel.updatePropertiesIndex();
    this.imageTargetPullHeight = this.viewModel.imageSlideTargetOffset * this.viewModel.ratioOffset;
    // has been pulled up when vertical => Horizontal
    if (this.viewModel.isPropertiesShow() && this.mIsCurrent) {
      this.viewModel.onResetPullingUpState();
    } else if (this.viewModel.isPropertiesShow()) {
      this.viewModel.toSaliencyImageSlideTargetState();
      if (this.isHorizontal) {
        // 竖屏下调用，会导致，打开详情页，编辑名称后保存。关闭详情页，左右滑动，大图页面截断（下半部为空白）。
        /* instrument ignore next  */
        this.viewModel.toImageSlideTargetState();
      }
    }
  }

  /**
   * 计算图片展示信息
   */
  private calculateImageAbsolutePos(isEdit: boolean = false): RectValue {
    let screenWidth: number = vp2px(this.viewModel.windowLayoutWidth - (DeviceInfo.isPc() &&
      (this.isDetailSelected || this.viewModel.isPropertiesShow()) ? Constants.PROPERTIES_WIDTH : 0));
    let screenHeight: number = vp2px(this.viewModel.windowLayoutHeight);
    let imageLeft: number;
    let imageTop: number;
    let imageWidth: number;
    let imageHeight: number;
    // pc规格 - 对于小于屏宽高资源适配
    /* instrument ignore if */
    if (!this.viewModel.checkNeedJustify()) {
      imageWidth = this.item?.width;
      imageHeight = this.item?.height;
      imageLeft = (screenWidth - imageWidth) / HALF_DIVIDER;
      imageTop = (screenHeight - imageHeight) / HALF_DIVIDER;
    } else if (!this.needJustifyWidth(isEdit)) {
      imageTop = 0;
      imageWidth = screenHeight * this.ratio;
      imageHeight = screenHeight;
      imageLeft = (screenWidth - imageWidth) / HALF_DIVIDER;
    } else {
      imageLeft = 0;
      imageWidth = screenWidth;
      imageHeight = screenWidth / this.ratio;
      imageTop = (screenHeight - imageHeight) / HALF_DIVIDER;
    }
    this.item?.setDisplayedWidth?.(imageWidth);
    let needReCalc = this.mIsCurrent || (this.isTabletOrTriExpand() &&
      getScreen().getWinMode() !== WindowMode.FLOATING ||
      ((DeviceInfo.isPhoneUx() && !FoldUtil.isTriExpand(this.curFoldStatus))) &&
        getScreen().getWinMode() !== WindowMode.UNDEFINED);
    this.currentImageWidth = imageWidth;
    this.currentImageHeight = imageHeight;
    this.setDisplayImageData(imageWidth, imageHeight);

    if (needReCalc) {
      // 计算loading在图片左上角的位置
      if (this.currentImageWidth === screenWidth) {
        this.loadingOriginOffsetX = this.loadingDeviceOffsetX;
        this.loadingOriginOffsetY = this.loadingDeviceOffsetY + px2vp(screenHeight - imageHeight) / HALF_DIVIDER;
      }
      if (this.currentImageHeight === screenHeight) {
        this.loadingOriginOffsetX = this.loadingDeviceOffsetX + px2vp(screenWidth - imageWidth) / HALF_DIVIDER;
        this.loadingOriginOffsetY = this.loadingDeviceOffsetY;
      }
      this.viewModel.maxScale = this.eventPipeline?.maxScale ?? this.viewModel.maxScale;
      this.defaultScale = this.eventPipeline?.defaultScale ?? this.defaultScale;
      this.calcLoadingPosition();
    } else {
      Log.info(TAG, `calculateImageAbsolutePos invoked, needReCalc: ${needReCalc}`)
    }
    Log.debug(TAG,
      `calculate image size: left ${imageLeft}, top ${imageTop}, width ${imageWidth}, height ${imageHeight}, ratio ${this.ratio}`);
    return {
      x: imageLeft,
      y: imageTop,
      width: imageWidth,
      height: imageHeight,
    };
  }

  /**
   * 设置当前图片显示的宽高
   *
   * @param imageWidth 图片宽度
   * @param imageHeight 图片高度
   */
  private setDisplayImageData(imageWidth: number, imageHeight: number): void {
    if (!this.mIsCurrent) {
      return;
    }
    PhotoItem.displayImageWidth = imageWidth;
    PhotoItem.displayImageHeight = imageHeight;
  }

  /**
   * 计算图片在 Image 组件中的具体宽高值
   */
  private calculateImagePos(): void {
    if (this.viewModel.checkNeedJustify()) {
      this.justifyWidth = this.needJustifyWidth();
      if (this.angle / BrowserConstants.ROTATION_NINETY % 2 === 0) {
        this.imageWidth = this.justifyWidth ? Constants.PERCENT_100 : undefined;
        this.imageHeight = !this.justifyWidth ? Constants.PERCENT_100 : undefined;
        this.imageStackWidth = this.imageWidth;
        this.imageStackHeight = this.imageHeight;
        Log.info(TAG, `angle = 0 imageWidth:${this.imageWidth} imageHeight:${this.imageHeight}`);
        /* instrument ignore next */
      } else if (this.angle / BrowserConstants.ROTATION_NINETY % 2 !== 0) {
        /* instrument ignore if */
        if (this.justifyWidth) {
          /* instrument ignore next */
          let winWidthTmp = this.viewModel.windowLayoutWidth;
          this.imageStackHeight = winWidthTmp?.toString();
          this.imageStackWidth = (winWidthTmp * this.ratio).toString();
          Log.info(TAG, `winWidthTmp=${winWidthTmp}`);
          /* instrument ignore next */
        } else {
          let winHeightTmp = this.viewModel.windowLayoutHeight;
          this.imageStackWidth = winHeightTmp.toString();
          this.imageStackHeight = (winHeightTmp / this.ratio).toString();
          Log.info(TAG, `winHeightTmp=${winHeightTmp},ratio=${this.ratio}`);
        }
      }
      /* instrument ignore next */
    } else {
      this.imageWidth = px2vp(this.item?.width)?.toString();
      this.imageHeight = px2vp(this.item?.height)?.toString();
    }
    let pos = this.calculateImageAbsolutePos();
    this.viewModel.imgWidth = pos.width;
    this.viewModel.imgHeight = pos.height;
    this.imageTop = pos.y;
    this.viewModel.minWidthOrHeight = Math.min(pos.height, pos.width);
    this.calculateImageSlideInfo();
    Log.debug(TAG, `calculate image size: top ${this.imageTop}`);
  }

  /**
   * 计算高亮框在 Image 组件中的具体位置
   */
  /* instrument ignore next */
  private calculateHighlightRect(ocrWidth: number, ocrHeight: number): void {
    if (this.originOcrRect.length === 0) {
      return;
    }
    this.highlightRect = [];
    let winWidth = vp2px(getScreen().getWinLayoutWidth());
    let winHeight = vp2px(getScreen().getWinLayoutHeight(this.isPcCameraPull) -
      (DeviceInfo.isPc() ? (this.previewStackHeight + this.viewModel.calcBarTopHeight(this.statusBarHeight)) : 0));
    this.justifyWidth = this.needJustifyWidth();
    if (DeviceInfo.isPc() && !this.isShowBar && this.windowStatus === window.WindowStatusType.FULL_SCREEN) {
      try {
        let winDisplay = display.getDefaultDisplaySync();
        winWidth = winDisplay.width;
        winHeight = winDisplay.height;
      } catch (error) {
        Log.error(TAG, `getDefaultDisplaySync error msg: ${error?.msg}, code: ${error?.code}`);
      }
    } else if (((DeviceInfo.isPc() && this.windowStatus !== window.WindowStatusType.FULL_SCREEN) ||
      (DeviceInfo.isTablet() && DeviceInfo.isPCMode())) &&
    this.fullComponentWidth && this.fullComponentHeight) {
      winWidth = this.fullComponentWidth;
      winHeight = this.fullComponentHeight;
    }
    let width: number = 0;
    let height: number = 0;
    let ratio: number = 0;
    if (this.angle / BrowserConstants.ROTATION_NINETY % 2 === 0) {
      width = ocrWidth || this.item.width;
      height = ocrHeight || this.item.height;
      ratio = this.justifyWidth ? winWidth / width : winHeight / height;
    } else {
      width = vp2px(Number(this.imageStackWidth));
      height = vp2px(Number(this.imageStackHeight));
      ratio = this.justifyWidth ? width / (ocrWidth || this.item.width) :
        height / (ocrHeight || this.item.height);
    }
    this.originOcrRect.forEach((rect: RectValue): void => {
      let highlightX = rect.x;
      let highlightY = rect.y;
      let highlightWidth = rect.width;
      let highlightHeight = rect.height;
      if (this.viewModel.checkNeedJustify()) {
        highlightX *= ratio;
        highlightY *= ratio;
        highlightWidth *= ratio;
        highlightHeight *= ratio;
      }

      this.highlightRect.push({
        x: highlightX,
        y: highlightY,
        width: highlightWidth,
        height: highlightHeight,
      });
      Log.debug(TAG, `HighlightRect.x: ${rect.x}, HighlightRect.y: ${rect.y}, HighlightRect.width: ${rect.width},
      HighlightRect.height: ${rect.height}`)
    });
    Log.debug(TAG, `calculate highlightRect length: ${this.highlightRect.length}, url: ${this.item.uri}`);
  }

  /**
   * 计算详情卡片宽度
   *
   */
  private updateListCardWidth(): void {
    this.listCardWidth = this.viewModel.getListCardWidth(this.listCardWidth)
    Log.info(TAG,
      `PhotoItem.updateListCardWidth start windowColumns:${this.viewModel.windowColumns},listCardWidth:${this.listCardWidth}`);
  }

  private exitImmersiveMode(): void {

  }

  private handleWorkByFastScrollCondition(): void {
    if (this.fastScrollModeTimer !== -1) {
      clearTimeout(this.fastScrollModeTimer);
      this.fastScrollModeTimer = -1;
    }
    let isInFastScrollMode = AppStorage.get<boolean>(Constants.APP_STORAGE_KEY_IS_IN_FAST_MODE);
  }

  private async onTransitionChange(): Promise<void> {
    this.viewModel.isCurrent = this.viewModel.getCurrentIndex() === this.mediaResult?.pos;
    if (!this.isDoingDeleteAnim) {
      this.onLCDReAdapt();
    }
    this.canShowRightMenu = false;
    Log.info(TAG, `onTransitionChange start, mIsCurrent: ${this.mIsCurrent}, mPosition: ${this.mPosition}, ` +
      `isShowBar: ${this.isShowBar}, isPullingDown: ${this.isPullingDown}, uri:${this.item.uri}`);
    this.eventPipeline?.setIsVideo(this.viewModel.isVideo());
    this.handleWorkByFastScrollCondition();
    TraceControllerUtils.startTrace('onTransitionChange');
    if (this.mIsCurrent) {
      Log.info(TAG, `this.item.isHighQuality ${this.item.isHighQuality}`);
      reportPictureQuality(this.item.isHighQuality);
      let asset = this.item.data;
      await this.viewModel.reportLargePhotosBrowser(this.albumUri, asset);
      this.broadCast.emit(BrowserConstants.PHOTO_SHOW_STATE, [!this.showError]);
    } else {
      if (this.imageShowPixMapSource) {
        this.onPixelmapReAdapt(true);
      }
      this.isPullingDown = false;
    }
    // 将图片缩放矩阵复原
    /* instrument ignore if */
    if (this.isPhotoScaled) {
      TraceControllerUtils.startTrace('onTransitionChange matrix');
      this.matrix = Matrix4.identity().copy();
      this.viewModel.stackModifier?.attribute?.transform(this.matrix);
      this.eventPipeline?.reset();
      this.updatePhotoScaledStatus();
      TraceControllerUtils.finishTrace('onTransitionChange matrix');
    }
    // 画中画变量逻辑更新
    this.updateAbleEnterInnerPic();
    this.updateInnerPicInfo();
    Log.info(TAG, `onTransitionChange end, isPullingDown: ${this.isPullingDown}`);
    TraceControllerUtils.finishTrace('onTransitionChange');
    this.onPhotoChanged();
  }

  private updatePipelinePullingDownStatus(): void {
    this.viewModel.setPullingDown(this.isPullingDown);
    this.appBroadCast.emit(BroadCastConstants.IS_PULLING_DOWN, [this.isPullingDown]);
  }

  /**
   * 利用图片宽高值，计算图片在 Image 中是否应该优先宽度充满整个控件
   *
   * @returns 返回 True 如果应该宽度优先充满控件
   */
  private needJustifyWidth(isEdit: boolean = false): boolean {
    let maxWidth = vp2px(this.viewModel.windowLayoutWidth - ((DeviceInfo.isPc() && this.isShowSideBar && !isEdit) ?
    this.sideBarWidth : 0) - ((DeviceInfo.isPc() && this.isDetailSelected) ? Constants.PROPERTIES_WIDTH : 0));
    let maxHeight =
      vp2px(this.viewModel.windowLayoutHeight -
        (DeviceInfo.isPc() && !this.isThird && this.isShowBar ? (this.previewStackHeight +
        this.viewModel.calcBarTopHeight(this.statusBarHeight)) : 0));
    if (this.isHalfFold && !this.isHorizontal) {
      /* instrument ignore next */
      maxHeight = maxHeight / 2;
    }

    if (DeviceInfo.isPc() && !this.isShowBar && this.windowStatus === window.WindowStatusType.FULL_SCREEN) {
      try {
        let winDisplay = display.getDefaultDisplaySync();
        maxHeight = winDisplay.height;
      } catch (error) {
        Log.error(TAG, `getDefaultDisplaySync error msg: ${error?.msg}, code: ${error?.code}`);
      }
    }

    // 适配xxx视频上云再下行宽高异常后，pc显示不完全问题，此处videoRatio值由视频封面解析得出
    let curRatio = (DeviceInfo.isPc() && this.viewModel.isVideo()) ? this.videoRatio : this.ratio;
    let justifyWidth: boolean = (this.angle / BrowserConstants.ROTATION_NINETY % 2 === 0 ?
      curRatio : 1 / curRatio) >= (maxWidth / maxHeight) && !this.isSubScreen;
    let matrix: Matrix4.Matrix4Transit = this.matrix;
    if (this.getPhotoScaledRatio(matrix) > 1 && this.isHalfFold && !this.isHorizontal) {
      /* instrument ignore next */
      justifyWidth = true;
    }
    Log.debug(TAG,
      `maxWidth:${maxWidth}, maxHeight:${maxHeight}, angle: ${this.angle}, ratio:${this.ratio}, justifyWidth:${justifyWidth}`);
    return justifyWidth;
  }

  /**
   * TouchEvent 预处理，配置 onTouch 使用
   *
   * @param event 用户触屏事件
   * @param dealScroll 当前是否处理的是滑动事件
   */
  private dealTouchEvent(event: TouchEvent, dealScroll: boolean): void {
    if (this.eventPipeline === undefined) {
      /* instrument ignore next */
      return;
    }
    if (this.eventPipeline?.canPullDownAndDragPhoto() || this.isOnDragText) {
      return;
    }
    if (!this.eventPipeline?.canTouch() || this.viewModel.isOnSwiperAnimation() || event.touches.length > 1 ||
    this.isPhotoScaled || (this.isInSelectedMode && !this.isPullingDown) || this.isDefaultFA) {
      return;
    }
    if (event.type == TouchType.Move && !this.isSubScreen) {
      let yOffset = event.touches[0].screenY - this.lastTouchDownY;
      let xOffset = event.touches[0].screenX - this.lastTouchDownX;
      this.lastTouchDownY = event.touches[0].screenY;
      this.lastTouchDownX = event.touches[0].screenX;
      if (yOffset == undefined || xOffset == undefined) {
        /* instrument ignore next */
        Log.info(TAG, 'dealTouchEvent screenY or screenX undefined');
        /* instrument ignore next */
        return;
      }

    } else if (event.type == TouchType.Down) {
      this.lastTouchDownY = event.touches[0].screenY;
      this.lastTouchDownX = event.touches[0].screenX;
    }
  }

  /**
   * 适配键盘事件
   *
   * @param event 键盘按键事件
   */
  /* instrument ignore next */
  private handleKeyEvent(event: KeyEvent): void {
    Log.info(TAG, `type=${event.type}, keyCode=${event.keyCode}`);
    /* instrument ignore if */
    if (event.type === 0 &&
      (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER ||
        event.keyCode === MultimodalInputManager.KEY_CODE_SPACE)) {
      this.shortcutController.listen(event);
    }
    /* instrument ignore next */
    let storage = LocalStorage.GetShared();
    /* instrument ignore if */
    if (this.isInSelectedMode && event.type === KeyType.Up && event.keyCode === KeyCode.KEYCODE_ENTER && this.isThird &&
      !storage?.has(Constants.PHOTO_PICKER_SESSION_KEY) && !this.isFromPickerView) {
      this.onPressEnter();
    }
    /* instrument ignore next */
    Log.info(TAG, 'on key event Up, default');
  }

  private isNeedShieldPullUpEvent(event: GestureEvent): boolean {
    return UserFileManagerAccess.isRecycleBin(this.albumUri) &&
      event.offsetY < 0 &&
      !this.isPhotoScaled && !this.isPullingDown;
  }

  /**
   * 窗口大小变化回调
   */
  private onWinSizeChanged(): void {
    let winLayoutW = getScreen().getWinLayoutWidth();
    let winLayoutH = this.viewModel.getWindowLayoutHeight();
    if (winLayoutW === 0 || winLayoutH === 0) {
      try {
        /* instrument ignore next */
        let displayClass: display.Display = display?.getDefaultDisplaySync();
        /* instrument ignore next */
        winLayoutW = getScreen().getCorrectPx2vp(displayClass.width);
        /* instrument ignore next */
        winLayoutH = getScreen().getCorrectPx2vp(displayClass.height);
      } catch (err) {
        Log.error(TAG, `onWinSizeChanged display.getDefaultDisplaySync, error code : ${err.code}`)
      }
    }
    this.isFromPickerMoireRotate = true;
    if (this.viewModel.windowLayoutWidth !== winLayoutW || this.viewModel.windowLayoutHeight !== winLayoutH) {
      this.onWinSizeChangedInner(winLayoutW, winLayoutH);
    }
  }

  private onWinSizeChangedInner(winLayoutW: number, winLayoutH: number): void {
    let isReachLowestBound: boolean = this.viewModel.isReachLowestBound(winLayoutW);

    Log.debug(TAG, `size change. oldWH: [${this.viewModel.windowLayoutWidth}, ${this.viewModel.windowLayoutHeight}]` +
      `, newWH: [${winLayoutW}, ${winLayoutH}], isReachLowestBound: ${isReachLowestBound}`);
    if (this.isHorizontal && DeviceInfo.isSmallFoldScreen()) {
      /* instrument ignore next */
      this.translateY = '0%';
      /* instrument ignore next */
      this.theImageHeight = '100%';
    }
    this.viewModel.windowLayoutWidth = winLayoutW;
    this.viewModel.windowLayoutHeight = winLayoutH;
    this.onChangeWindow();
    this.viewModel.windowColumns = getScreen().getScreenColumns();
    this.eventPipelineSizeChange();
    this.rotateController?.setComponentSize(vp2px(this.viewModel.windowLayoutWidth),
      vp2px(this.viewModel.windowLayoutHeight));
    this.setRotateButtonOffset();
    if (AppStorage.get<boolean>('windowPcmodeSwitchStatus')) {
      /* instrument ignore next */
      return;
    }
    this.updateListCardWidth();
    if (isReachLowestBound && this.viewModel.isPropertiesShow() && !this.isTouchingPullUp &&
      !((DeviceInfo.isPhoneUx() && !FoldUtil.isTriExpand(this.curFoldStatus)) && this.isHorizontal && getScreen()
        .getWinMode() !== WindowMode.UNDEFINED && !this.isFoldExpanded && !this.isThird) &&
      !(DeviceInfo.isFoldable() && getScreen().getWinMode() === WindowMode.FLOATING)) {
      /* instrument ignore next */
      this.doCloseClickDetailPullingUpAnimation(false);
    }
    this.onPhotoChanged();
    if (this.isShowHighlight()) {
      /* instrument ignore next */
      this.changeHighlightRectPos();
    }
    this.viewModel.onSaliencyPullUpPrepare();
    if (this.viewModel.isPropertiesShow()) {
      this.viewModel.toImageSlideTargetState();
      if (this.viewModel.isVideo()) {
        this.viewModel.setImageSlideScale(1);
      }
    }
    if (this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
      this.calculateXComponentSize();
    }
    // 画中画参数 更新
    this.initImageTool();
    // 画中画 隐藏定时器更新
    this.innerPhotoDealTouchEvent();
    this.eventPipeline?.innerPicPanAnimationEnd();
    this.viewModel.setIsOnlyShowProperties(getScreen().getDetailShow());
    this.viewModel.onWinModeChanged();
    this.imageTargetPullHeight = this.viewModel.imageSlideTargetOffset * this.viewModel.ratioOffset;
  }

  private changeHighlightRectPos(): void {
    let ocrObj: OcrCacheData = {};
    if (this.item.ocrCacheData) {
      ocrObj = JSON.parse(this.item.ocrCacheData) as OcrCacheData;
    }
    /* instrument ignore next */
      let ocrWidth = ocrObj.width ?? 0;
    /* instrument ignore next */
      let ocrHeight = ocrObj.height ?? 0;
    /* instrument ignore next */
      this.calculateHighlightRect(ocrWidth, ocrHeight);
  }

  private onDataReload(addCount: KeyEvent): void {
    Log.info(TAG, `onDataReload exec, addCount:${addCount}`);
    let item: MediaItem | undefined = this.dataSource?.getItemByUri(this.item.uri);
    if (!item) {
      return;
    }
    if (item.uri) {
      if (item.getIsMovingPhoto?.() || DeviceInfo.isPc()) {
        this.dataSource?.resetPhotoRequest(item.uri);
      }
      this.item = item;
      if (this.dataSource) {
        this.mPosition = this.dataSource.getDataIndexByUri(this.item.uri ? this.item.uri : this.item.captureId);
      }
      Log.info(TAG, `Item[${this.item.uri}] is changed`);
      return;
    } else {
      this.mPosition = Constants.NOT_FOUND;
    }
    item = this.dataSource?.getItemByPath(this.item.path);
    if (!item?.uri) {
      return;
    }
    if (item.getIsMovingPhoto?.() || DeviceInfo.isPc()) {
      this.dataSource?.resetPhotoRequest(item.uri);
    }
    /* instrument ignore next */
    this.item = item;
    /* instrument ignore next */
    Log.debug(TAG, `Item[${this.item.uri}] is changed`);
  }

  /**
   * 图片缩放矩阵复位回调
   */
  private resetDefaultScale(): void {
    this.resetScaleAnimation(Matrix4.identity().copy());
  }

  /**
   * 点击详情按钮上滑动效
   *
   * @param uniqueId 当前图片的唯一标识
   */
  private openClickDetailPullingUpAnimation(uniqueId: string): void {
    if (this.item.uniqueId === uniqueId && !this.isPcPictureScene) {
      Log.info(TAG, `detail Pulling Up by click icon ${this.item.uniqueId}`);
      this.viewModel.isPropertiesShow() ? this.doCloseClickDetailPullingUpAnimation(false) :
        this.doOpenClickDetailPullingUpAnimation();
    }
    Log.info(TAG, `openClickDetailPullingUpAnimation ${this.isPcPictureScene}, ${this.viewModel.isPropertiesShow()}`);
  }

  /**
   * 点击图片/侧滑详情收起动效
   *
   * @param uniqueId 当前图片的唯一标识
   */
  private closeClickDetailPullingUpAnimation(uniqueId: string): void {
    if (this.item.uniqueId === uniqueId) {
      Log.info(TAG, `detail Pulling Down by click icon ${this.item.uniqueId}`);
      this.doCloseClickDetailPullingUpAnimation(false);
    }
  }
  /* instrument ignore next */
  private emitUpdateCardWidth(): void {
    Log.info(TAG, 'emitUpdateCardWidth');
    ScreenManager.getInstance().updateSize();
    this.updateListCardWidth();
    this.viewModel.updateSlideOffset();
    this.viewModel.onResetPullingUpState();
    if ((DeviceInfo.isPhoneUx() && !FoldUtil.isTriExpand(this.curFoldStatus)) && !this.viewModel.isPropertiesShow()) {
      this.viewModel.clipColumnHeight = Constants.PERCENT_100;
    }
  }

  private closeDetailPullingUp(): void {
    Log.info(TAG, 'onbackpress closeDetailPullingUp');
    this.doCloseClickDetailPullingUpAnimation(true);
  }

  private resetphotoDefaultRotation(): void {
    Log.info(TAG, `reset photo rotation`);
    this.angle = 0;
    this.rotateValue = 0;
    this.isInRotateState = false;
    this.calculateImagePos();
    // 旋转后eventPipeLine变量更新
    this.eventPipeline?.onRotateEnd(this.angle);
  }

  /**
   * 缓存图片缩放矩阵回调
   */
  /* instrument ignore next */
  private saveScale(): void {
    if (this.mIsCurrent) {
      LocalStorage.getShared()?.setOrCreate<Matrix4.Matrix4Transit | undefined>(BrowserConstants.MATRIX, this.matrix);
    }
  }

  /**
   * 大图是屏预览显示状态的监听回调
   */
  /* instruments ignore next */
  private onBrowserFullShow(): void {
    this.broadCast.emit(BrowserConstants.BROWSER_FULL_SHOW, [this.isBrowserFullShow]);
  }

  /**
   * 是否是支持的视频格式
   * @param isSupportedVideoType
   * @param src
   */
  /* instrument ignore next */
  private setIsSupportedVideoType(isSupportedVideoType: boolean, src: string): void {
    if (this.item.uri === src) {
      this.isSupportedVideoType = isSupportedVideoType;
    }
  }

  /**
   * 如果宽高为0，则根据avplayer上报的视频宽高覆盖原宽高
   *
   * @param src
   * @param imageWidth
   * @param imageHeight
   */
  private setImageSizeWhenZero(src: string, imageWidth: number, imageHeight: number): void {
    /* instrument ignore next */
    if (this.item.uri === src && (this.item.width === 0 || this.item.height === 0)) {
      Log.info(TAG,
        `[videoPlayer] setImageSizeWhenZero, this.item.width: ${this.item.width}, this.item.height: ${this.item.height}, this.item.uri: ${this.item.uri}, src: ${src}`);
      this.item.width = imageWidth;
      this.item.height = imageHeight;
      this.item.imgWidth = imageWidth;
      this.item.imgHeight = imageHeight;
      this.item.setDisplayedWidth(imageWidth);
      //解决宽高为0的视频，上滑详情时视频消失的问题
      this.calculateImagePos();
    }
  }

  /* instrument ignore next */
  private setXComponentSize(xComponentWidth: number, xComponentHeight: number, src: string): void {
    if (this.item.uri === src &&
      (this.xComponentWidth !== xComponentWidth || this.xComponentHeight !== xComponentHeight)) {
      Log.info(TAG,
        `[videoPlayer] playWindowSize setXComponentSize: ${xComponentWidth}, ${xComponentHeight}, src: ${src}`);
      this.xComponentWidth = xComponentWidth;
      this.xComponentHeight = xComponentHeight;
    }
  }

  /**
   * 设置当前播放视频的ratio
   *
   * @param ratio
   * @param uri
   */
  private setVideoRatio(ratio: number, uri: string): void {
    if (uri === this.item.uri && this.videoRatio !== ratio) {
      /* instrument ignore next */
      Log.info(TAG,
        `[videoPlayer] playWindowSize setVideoRatio currentRatio: ${this.videoRatio}, newRatio: ${ratio}, uri: ${uri}`);
      /* instrument ignore next */
      this.videoRatio = ratio;
    }
  }

  private setVideoRealSize(videoRealWidth: number, videoRealHeight: number, uri: string): void {
    if (this.item.uri === uri) {
      Log.info(TAG, `[videoPlayer] playWindoSize setVideoRealSize: ${videoRealWidth}, ${videoRealHeight}, uri: ${uri}`);
      this.videoRealWidth = videoRealWidth;
      this.videoRealHeight = videoRealHeight;
      this.rotateController?.resetVideoWidthAndHeight(videoRealWidth, videoRealHeight);
      this.setRotateButtonOffset();
    }
  }

  private calculateXComponentSize(): void {
    let winWidth: number = vp2px(getScreen().getWinLayoutWidth());
    let winHeight: number = vp2px(getScreen().getWinLayoutHeight(this.isPcCameraPull));
    if (this.isHalfFold && this.isHalfFoldStateEnable() && (winWidth < winHeight)) {
      /* instrument ignore next */
      winHeight = vp2px(getScreen().getWinLayoutHeight(this.isPcCameraPull) / 2);
    } else {
      winHeight = vp2px(getScreen().getWinLayoutHeight(this.isPcCameraPull));
    }
    if (winWidth === 0 || winHeight === 0) {
      try {
        /* instrument ignore next */
        let displayClass: display.Display = display?.getDefaultDisplaySync();
        /* instrument ignore next */
        winWidth = displayClass.width;
        /* instrument ignore next */
        winHeight = displayClass.height;
      } catch (err) {
        Log.error(TAG, `calculateXComponentSize display.getDefaultDisplaySync, error code : ${err.code}`)
      }
    }
    let isWindowPcmodeSwitchStatus = this.windowPcmodeSwitchStatus;
    if (DeviceInfo.isPcOrTablet() && isWindowPcmodeSwitchStatus) {
      winHeight = winHeight - Constants.ActionBarHeight;
    }
    Log.info(TAG, `[videoPlayer] playWindowSize calculateXComponentSize start, winWidth: ${winWidth},
      winHeight: ${winHeight}, src: ${this.item.uri}, windowPcmodeSwitchStatus: ${isWindowPcmodeSwitchStatus}`);
    let matrix: Matrix4.Matrix4Transit = this.matrix;
    if (this.viewModel.checkNeedJustifyForVideo(this.videoRealWidth, this.videoRealHeight)) {
      let winRatio = winWidth / winHeight;
      if (winRatio > this.videoRatio) {
        if (this.isSubScreen && this.getPhotoScaledRatio(matrix) <= 1) {
          /* instrument ignore next */
          this.xComponentHeight = this.getCorrectPx2vp(winHeight);
          /* instrument ignore next */
          this.xComponentWidth = this.getCorrectPx2vp(winHeight * this.videoRatio) + 35;
        } else {
          this.xComponentHeight = this.getCorrectPx2vp(winHeight);
          this.xComponentWidth = this.getCorrectPx2vp(winHeight * this.videoRatio);
        }
      } else {
        this.xComponentWidth = this.getCorrectPx2vp(winWidth);
        this.xComponentHeight = this.getCorrectPx2vp(winWidth / this.videoRatio);
      }
      Log.info(TAG, `[videoPlayer] playWindowSize calculateXComponentSize checkNeedJustify true${this.videoRatio}`);
    } else {
      /* instrument ignore next */
      this.xComponentWidth = this.getCorrectPx2vp(this.videoRealWidth);
      /* instrument ignore next */
      this.xComponentHeight = this.getCorrectPx2vp(this.videoRealHeight);
      /* instrument ignore next */
      Log.info(TAG,
        `[videoPlayer] playWindowSize calculateXComponentSize checkNeedJustify false, videoRealWidth: ${this.videoRealWidth}, videoRealHeight: ${this.videoRealHeight}`);
    }
    Log.info(TAG,
      `[videoPlayer] playWindowSize calculateXComponentSize end, xComponentWidth: ${this.xComponentWidth},xComponentHeight: ${this.xComponentHeight}, videoRatio: ${this.videoRatio}, src: ${this.item.uri}`);
  }

  public getCorrectPx2vp(value: number): number {
    try {
      const disTempValue: number | undefined = this.getUIContext()?.px2vp(value);
      return disTempValue ? disTempValue : px2vp(value);
      /* instrument ignore next */
    } catch (error) {
      Log.error(TAG, `getCorrectPx2vp error: ${error}, code: ${error?.code}`);
    }
    /* instrument ignore next */
    return px2vp(value);
  }

  private onVideoRatioChanged(): void {
    Log.info(TAG,
      `[videoPlayer] playWindowSize onVideoRatioChanged current value is ${this.videoRatio}, this.src: ${this.item.uri}`);
    this.calculateXComponentSize();
    if (DeviceInfo.isPc()) {
      /* instrument ignore next */
      this.calculateImagePos();
    }
  }

  /* instrument ignore next */
  private startHalfFoldAnimation(): void {
    if (!this.isHalfFoldStateEnable() || this.isHorizontal) {
      Log.info(TAG, 'Not Supported fold state change, the halfState no need update');
      return;
    }
    animateTo({
      duration: Constants.DELAY_HALF_SECOND,
      curve: Curve.EaseOut,
      onFinish: (): void => {
        Log.info(TAG, 'play end');
      }
    }, (): void => {
      try {
        if (display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED) {
          this.translateY = '0%';
          this.theImageHeight = '100%';
          this.calculateXComponentSize();
          this.calculateImagePos();
          if (this.isThird) {
            this.eventPipelineComponentChange(vp2px(this.imageComponentWidth), vp2px(this.imageComponentHeight));
          } else {
            this.eventPipelineComponentChange(vp2px(this.viewModel.windowLayoutWidth),
              vp2px(this.viewModel.windowLayoutHeight));
          }
        } else if (display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_HALF_FOLDED) {
          this.translateY = Constants.PERCENT_NEGATIVE_50;
          this.theImageHeight = Constants.PERCENT_50;
          this.calculateXComponentSize();
          this.calculateImagePos();
          if (this.isThird) {
            this.eventPipelineComponentChange(vp2px(this.imageComponentWidth), vp2px(this.imageComponentHeight) / 2);
          } else {
            this.eventPipelineComponentChange(vp2px(this.viewModel.windowLayoutWidth),
              vp2px(this.viewModel.windowLayoutHeight) / 2);
          }
        }
      } catch (err) {
        Log.error(TAG, `startHalfFoldAnimation display.getFoldStatus, error code : ${err.code}`);
      }
    })
  }

  private isHalfFoldStateEnable(): boolean {
    return DeviceInfo.isSmallFoldScreen() && !this.isLemFoldState;
  }

  /* instrument ignore next */
  private eventPipelineComponentChange(componentWidth: number, componentHeight: number): void {
    this.eventPipeline?.onComponentSizeChanged(componentWidth, componentHeight);
  }

  /* instrument ignore next */
  private playVideoFromSubScreen(progress: number): void {
    this.onVideoPlayIconClicked();
  }

  /* instrument ignore next */
  private movingPhotoOnComplete(uri: string): void {
    // 当前item不会响应其他item的onComplete回掉
    if (uri !== this.item.uri) {
      Log.info(TAG, `[EditorPhotoContext] uri ${uri} !== this.item.uri ${this.item.uri}`);
      return;
    }
    if (this.lastThumbnail === this.thumbnail) {
      return;
    }
    this.lastThumbnail = this.thumbnail;
    this.showError = false;
    this.isLoading = false;
    this.isComplete = true;
    if (this.mIsCurrent) {
      this.broadCast.emit(BrowserConstants.PHOTO_SHOW_STATE, [true]);
    }
    if (EditorPhotoContext.getInstance().getNotifyHideEditor() && this.mIsCurrent) {
      Log.info(TAG, `[EditorPhotoContext] emit CURRENT_PHOTO_LOAD_COMPLETED`);
      this.broadCast.emit(BroadCastConstants.CURRENT_PHOTO_LOAD_COMPLETED, [this.item]);
    }
  }

  /**
   * 是否是大图组件横屏下拉返回,是则不处理本次下拉手势事件
   *
   * @param event 手势事件
   * @returns 是否是大图组件横屏下拉返回
   */
  private isPullDownOnHorizontal(event: GestureEvent): boolean {
    return !DeviceInfo.isPc() && PhotoConfig.isLibrary() && this.isHorizontal && !this.viewModel.isPropertiesShow() &&
      event.offsetY > 0 && !this.isPhotoScaled;
  }

  private isSwitchLibrarySwiper(): boolean {
    return PhotoConfig.isLibrary() && PhotoConfig.isSwitchSwiper;
  }
  /* instrument ignore next */
  onIsDetailSelectedChanged(): void {
    this.calculateImagePos();
  }

  // 加载/重置第一次查看图片的参数
  resetFirstLookStatus(): void {
    this.firstLookRatio = ImageAdapterHelper.calculateRatio(
      this.thumbnail.width, this.thumbnail.height, this.angle) ?? 1;
    this.firstLookWidth = Math.ceil(this.thumbnail.width * this.firstLookRatio);
    this.firstLookHeight = Math.ceil(this.thumbnail.height * this.firstLookRatio);
  }

  onPixelmapReAdapt(reset: boolean = false): void {
    if (this.isThird) {
      /* instrument ignore next */
      return;
    }
    Log.info(TAG, `onPixelmapReAdapt angle: ${this.angle} ${((this.angle % 360) + 360) % 360}`)

    ImageAdapterHelper.onPixelmapReAdapt({
      reset: reset,
      mIsCurrent: reset ? reset : this.mIsCurrent,
      matrix: this.matrix,
      firstLookWidth: this.firstLookWidth,
      firstLookHeight: this.firstLookHeight,
      firstLookRatio: this.firstLookRatio,
      maxScale: this.eventPipeline?.maxScale,
      pixelmap: this.removeMoirePixelMap,
      width: this.thumbnail.width,
      height: this.thumbnail.height,
      isGestureMove: this.isGestureMove,
      duration: this.animationOption?.duration ?? 0,
      mPosition: this.mPosition,
      isRunningAnimation: this.isRunningAnimation,
      angle: ((this.angle % 360) + 360) % 360,
    });
  }

  onLCDReAdapt(): void {
    if (this.isThird) {
      /* instrument ignore next */
      return;
    }
    this.resetFirstLookStatus();
    ImageAdapterHelper.onLCDReAdapt({
      mIsCurrent: this.mIsCurrent,
      pixelmap: this.removeMoirePixelMap,
      mPosition: this.mPosition,
      firstLookRatio: this.firstLookRatio,
    });
  }

  geometryTransitionChange(): string {
    if (!this.browserAnimController?.isTransitionEnable) {
      return '';
    }
    Log.info(TAG, ``)
    return this.isRunningAnimation && this.changTransitionId ? this.geometryTransitionId : '';
  }

}

function reportImageEnlargeWay(imageEnlargeWay: string, imageScale: number): void {
  let msgEnlargeWay: ImageEnlargeWayMsg = {
    imageEnlargeWay: imageEnlargeWay,
    imageScale: imageScale,
  }
  ReportToBigDataUtil.report('IMAGE_ENLARGE_WAY', msgEnlargeWay);
}

interface ImageEnlargeWayMsg {
  imageEnlargeWay: string;
  imageScale: number;
}

function reportPictureQuality(isHighQuality: boolean): void {
  let quality: number;
  if (isHighQuality) {
    quality = PictureQualityConstants.PICTURE_QUALITY_HUNDRED_SCORE;
  } else {
    quality = PictureQualityConstants.PICTURE_QUALITY_EIGHTY_SCORE;
  }
  Log.info(TAG, `reportPictureQuality quality: ${quality}.`);
  let msgQ: QualityMsg = {
    quality: quality,
  };
  if (PhotoConfig.isLibrary() || AppStorage.get(PictureQualityConstants.IS_EDIT_SAVE) ||
  AppStorage.get(PictureQualityConstants.IS_THIRD_PICKER)) {
    AppStorage.setOrCreate(PictureQualityConstants.IS_EDIT_SAVE, false);
    Log.info(TAG, 'quality not report.');
  } else {
    Log.info(TAG, 'quality report.');
    ReportToBigDataUtil.report(PictureQualityConstants.PICTURE_QUALITY, msgQ);
  }
}