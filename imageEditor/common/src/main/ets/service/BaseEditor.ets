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
import { PreviewStarter } from './manager/PreviewStarter';
import { copyAttrTo } from '../common/util/misc';
import { Event, lpx } from '../common/jul';
import { HiLog } from '../common/util/HiLog';
import sdk from './native';
import { Asset, LanAsset } from './Asset';
import { Cmd, Message } from './model/CommonModel';
import { App, MediaType, } from './App';
import { DeviceUtil } from '../common/util/DeviceUtil';
import { CropType } from './model/CropModel';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { NullUtil } from '../common/util/NullUtil';
import { ScreenUtil } from '../common/util/ScreenUtil';
import { FillCropType, TabName } from './model/Enum';
import { Trace } from '../common/util/Trace';
import { image } from '@kit.ImageKit';
import { AdjustAttr, AdjustItem, AdjustValueItem } from './model/menu/AdjustAttr';
import { CropAttr } from './model/menu/CropAttr';
import { MosaicAttr } from './model/menu/MosaicAttr';
import { GetExportDataOptions, IEditor, SourceFlowType } from './IEditor';
import { ImageEffectChangeParams, RectValue } from './EditorSDK';
import {
  AVOID_LEFT_OFFSET,
  CropIndex,
  PC_TOP_BAR_HEIGHT,
  PHOTO_BUNDLE_NAME,
  TOP_BAR_HEIGHT,
  XT_STYLE_OFF
} from '../common/const';
import { fileIo } from '@kit.CoreFileKit';
import PhotoAssetUtil from '../common/util/PhotoAssetUtil';
import { BusinessError, systemParameter, systemParameterEnhance } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { dataSharePredicates } from '@kit.ArkData';
import { BaseEditorCommonUtil } from '@ohos/common/src/main/ets/default/utils/BaseEditorCommonUtil';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { TextInterval } from './model/tabTextEdit/util/TextConst';
import { UiUtil } from '../common/util/UiUtil';
import Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';
import { ShootingModeType } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import { ExportInfo, ImgInfo, MediaSaveManager } from '../feature/basic/model/common/MediaSaveManager';
import { contextConstant } from '@kit.AbilityKit';
import { FormatUtil } from '../common/util/FormatUtil';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import ExifUtil from '../common/util/ExifUtil';
import { PersistInfo, PersistInfoUtils } from './EditDataPersist';
import settings from '@ohos.settings';
import i18n from '@ohos.i18n';
import { geoLocationManager } from '@kit.LocationKit';
import { EffectDetail, ImageEffectState } from './EditorSDK';
import { ImageMediaLibraryProxy } from '../common/proxy/MediaLibraryProxy';
import { PixelMapUtil } from '../common/util/PixelMapUtil';

const TAG = 'BaseEditor';
// 光圈功能在商分体现时间
const APERTURE_ALLOW_DAY = 20250515;
const XTSTYLE_REQUIRED_FIELDS = ['templateIndex', 'type', 'colorTemperature', 'saturation', 'lightShadow'];

enum LaneType {
  LANE_TYPE_VIDEO,
  LANE_TYPE_TEXT
}

class Params {
  public code: number = 0;
}

class Params2 {
  public id: string = '';
}

class Params3 {
  public result: number = 0;
}

class Params4 {
  public uid: string = '';
}

interface EditData {
  imageEffect: ImageEffect,
}

interface ImageEffect {
  filters: Filter[],
}

export interface Filter {
  name: string,
  values: FilterParam,
}

interface FilterParam {
  inputHeight: number,
  inputWidth: number,
  isFrameSticker: boolean,
  isFestivalSticker: boolean,
  rotationZ?: number,
}
interface filtersObj {
  name: string;
  values: object;
}

let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

class SDKFuncResultData {
}

class SDKFuncResult {
  public result: number = 0;
  public msg: string = 'success';
  public data: SDKFuncResultData = new SDKFuncResultData();
}

class ApplyEditDataResultData extends SDKFuncResultData {
  public lane: string = '';
  public asset: string = '';
}

@Observed
class Lane {
  public type: LaneType = LaneType.LANE_TYPE_VIDEO;
  public id: string = '';

  constructor(type: LaneType) {
    this.type = type;
  }
}

@Observed
export class OperationArea {
  public status: number = 0;
  public operWidth: number = lpx(640);
  public operHeight: number = lpx(1080);
  public operTop: number = 68;
  public operLeft: number = 36;
  public previewOperationAreaWidth: number = 0;
  public previewOperationAreaHeight: number = 0;

  public asNapiParam() {
    return [this.operLeft,
      this.operTop,
      this.operLeft + this.operWidth,
      this.operHeight + this.operTop,
      this.previewOperationAreaWidth,
      this.previewOperationAreaHeight]
  }
}

@Observed
export class Timeline {
  public canvasWidth: number = 1080 // px单位，当前Timeline的播放宽度，绑定xComponent时返回
  public canvasHeight: number = 2230 // px单位，当前Timeline的播放长度，绑定xComponent时返回
  public operWidth: number = lpx(640);
  public operHeight: number = lpx(1080);
  public operTop: number = 68;
  public operLeft: number = 36;
  public canvasToDesignRatio: number = 1; // px/lpx(屏幕像素/屏幕宽度)比例值
  public timeProgressImmersiveMode: boolean = false // 时间抽沉浸式标志
  public lane: Lane = new Lane(LaneType.LANE_TYPE_VIDEO);
  public textLane: Lane = new Lane(LaneType.LANE_TYPE_TEXT);
  public id: number = 0;
}

@Observed
export class OperationTip {
  public name: Resource | string; // 滤镜、调节选中项的名称
  public value: string = ''; // 滤镜、调节数值
  public isBigText: boolean = false; // 是否为大字体显示
  public disabled: boolean = false; // 调节按钮是否为禁用态
  public immersiveMode: boolean = false; // 控制滤镜、调节服务名和值的显示。在调整值过程中，控制按钮可见
  public position: number = 0;
  public adaptationWidth: number = 60;
  public tips: boolean = true // tip是否显示
  public isShowNum: boolean = false;

  constructor(name: Resource | string, value: string, isBigText: boolean, disabled: boolean, immersiveMode: boolean,
    position: number) {
    this.name = name;
    this.value = value;
    this.isBigText = isBigText;
    this.disabled = disabled;
    this.immersiveMode = immersiveMode;
    this.position = position;
  }

  setName(name: Resource | string) {
    this.name = name;
  }

  setValue(value: string | number) {
    this.value = String(value);
    HiLog.i('OperationTip setValue:', String(value))
  }


  setDisabled(disabled: boolean) {
    this.disabled = disabled;
  }


  setPosition(pos: number) {
    this.position = pos;
  }
}

let fTimeout: number | null = null;

@Observed
export class BaseEditor extends IEditor {
  public operationArea: OperationArea = new OperationArea();
  public previewStarter: PreviewStarter = new PreviewStarter();
  public asset: Asset = new Asset(this);
  public timeline: Timeline = new Timeline();
  public operationTip: OperationTip = new OperationTip('', '', false, false, false, 0);
  public tabIndex: TabName = TabName.TabCrop; // 初始tab页 .TabCrop
  public isScreenClassInit: boolean = false;
  /** 沉浸式标志 */
  public immersiveMode: boolean = false;
  /** 横竖屏旋转标志 */
  public rotateMode: boolean = false;
  public stylusMode: boolean = false;
  public isInTextArea: boolean = false;
  /** 当前工程是否有马赛克的修改 */
  public mosaicModified: boolean = false;
  /** 当前工程是否有文本标注的修改 */
  public textEditModified: boolean = false;
  /** 当前工程是否有涂鸦编辑的修改 */
  public stylusModified: boolean = false;
  /** 当前工程是否有正在进行的涂鸦编辑修改 */
  public stylusModifying: boolean = false;
  /** 保存视频遮罩弹框 */
  public isSaveVideoDialog: boolean = false;
  public onCmd: Cmd = new Cmd(this);
  /** 控制组件是否初始化 */
  public isInitComp: boolean = false;
  public exportProgressCallback: Function | undefined = undefined;
  public exportResultCallback: Function | undefined = undefined;
  public importResultCallback: Function | undefined = undefined;
  public isEditorClosed: boolean = false;
  /** 退出保存草稿时阻止多次点击触发 */
  public isPageBackLoading: boolean = false;
  public isLoading: boolean = true;
  public mediaType: MediaType = MediaType.IMAGE;
  /** 是否需要打断裁剪框的1s时延动效 */
  public interrupt: boolean = false;
  /** 裁剪框刷新定时器 */
  public timeStartZoom: number = 0;
  /** 高斯模糊刷新定时器 */
  public timeBlur: number = 0;
  /** 画布移动复原定时器 */
  public imageMove: number = 0;
  /** 是否已经导入失败 */
  public isImportFailed: boolean = false;
  /** 画布是否移动或者缩放移动中(调节/滤镜中用) */
  public isImageMove: boolean = false;
  /** 打开编辑资源PhotoAsset中的uri */
  public mediaUri: string = '';
  /** 请求参数中的uri，三方入口，如MovingPhoto进入涂鸦、AI传入的图库沙箱uri */
  public requestUri: string | undefined;
  public mediaAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
  public albumUri: string = '';
  public thumbnailUri: string = '';
  public isStartOperate: boolean = false;
  public isStopScrolling: boolean = false;
  /** PC设备截取组件外层容器宽度 */
  public containerWidth: number = 0;
  /** PC设备底部截取组件高度 */
  public bottomHeight: number = 100;
  public refreshThumbnail: RefreshThumbnail = new RefreshThumbnail();
  /** 点击复原的时候，此状态用于刷新UI界面 */
  public isReset: boolean = false;
  /** 刷新滤镜数据 */
  public isResetFilter: boolean = false;
  /** 刷新滤镜数据 */
  public isResetXTStyle: boolean = false;
  /** 是否编辑过的图片（媒体库识别） */
  public isEdit: boolean = false;
  /** 是否编创框架的编辑数据，仅做调节滤镜等编辑，为true时表示可用原图计算生成 */
  public isSystemEditData: boolean = false;
  /** 是否图库（PenKit，AI）编辑数据，为true时是效果图，无法用原图计算生成 */
  public isPhotosEditData: boolean = false;
  /** 是否相机（水印、滤镜）编辑数据 */
  public isCameraEditData: boolean = false;
  /** 编辑数据 */
  public editData: string = '';
  /** 编辑数据format标识 */
  public editDataCompatibleFormat: string = '';
  /** 是否支持水印编辑 */
  public fd: number = -1; //原图fd
  public lcdPixelMap: image.PixelMap | undefined = undefined;
  /** 是否显示复原按钮 */
  public isShowRevert: boolean = false;
  public isEditNoData: boolean = false;
  public isOpenInitReset: boolean = false;
  public isOpenInit: boolean = false;
  /** 是否是云图资源 */
  public isCloudResource: boolean = false;
  /** 获取photoAccessHelper */
  public pah?: photoAccessHelper.AbsAlbum;
  public fetchOptions?: photoAccessHelper.FetchOptions;
  public afterLoadCb: (timeline: Timeline) => void = Event;
  public isHiddenSource: boolean = false;
  public hoverTime: number = 300;
  public isHdrShowOpen: boolean = true;
  /** 是否支持水印编辑 */
  public isSupportSeal: boolean = false;
  /** 图片是否带有水印 */
  public hasSeal: boolean = false;
  /*
   * 图片携带的媒体库字段：标识支持水印编辑的类型
   * DEFAULT：默认值 BRAND_COMMON：都支持 2、COMMON：内嵌 3、BRAND：画框
   */
  public sealEnable: photoAccessHelper.MemberType = photoAccessHelper.WatermarkType.BRAND_COMMON;
  public watermarkTypeArr =
    ['InplaceSticker', 'FrameSticker', 'RenewalSticker', 'BorderSticker', 'FrostedSticker', 'XtStyleSticker',
      'TimingSticker', 'FestivalSticker', 'PersonalizedStickerStyle1', 'PersonalizedStickerStyle2'];
  /** 是否带有水印资源 */
  public hasSealResource: boolean = false;
  /** 是否尺寸不小于400，支持水印编辑 */
  public isSupportSealSize: boolean = true;
  /** 是否支持水印-色卡参数编辑 */
  public isSupportColorParamEdit: boolean = false;
  public isOpenAnimation: boolean = true;
  /** 文本标注开关 */
  public isBaseTextEditEnabled: boolean = false;
  public isSupportXTStyleEdit: boolean = false;
  public isOpenFilterCardView: boolean = false;
  /** 当前工程是否有个性风格编辑的修改 */
  public xtStyleModified: boolean = false;
  public hasCustomFilterStackCardViewInitiated: boolean = false;
  /** 是否带有个性风格数据 */
  public hasXTStyleResource: boolean = false;
  public isSupportApertureEdit: boolean = false;
  /** 大光圈编辑 */
  public apertureMode: boolean = false;
  /** 图片是否支持大光圈编辑 */
  public isSupportApertureSys = true;
  /** 图片是否是分享过来的水印图 */
  public isHWSharedPhoto = false;
  /** 是否全质量图 false:低分辨率图  true:高分辨率图 */
  public isImageFullQuality: boolean = true;
  /** 是否连拍图 */
  public isBurstImage: boolean = false;
  private xtStyleIndex2Type: Array<string> =
    ['close_xtStyle', 'standard_xtStyle', 'films_xtStyle', 'romance_xtStyle', 'anime_xtStyle', 'vivid_xtStyle',
      'bright_xtStyle', 'mono_xtStyle'];
  public lastStyleIndex: number = -1;
  public lastHue: number = -1;
  public lastSaturation: number = -1;
  public lastLightShadow: number = -1;
  public lastTemplateIndex: number = -1;
  public userXtStyleName: string = '';
  public closeDialog: (isVerdeFolded: boolean) => void = Event;
  /** 页面中展示的图片实际大小（可裁剪） px */
  public imageSourceWidth: number = 0;
  public imageSourceHeight: number = 0;
  public isComposing: boolean = false;
  public exifXmageColorMode = -1;
  /** 原图的XTstyleTemplate的index */
  public exifXTSourceStyleIndex = -1;
  public exifHasWatermark = false;
  public composedTabs = [TabName.TabTextEdit, TabName.TabMosaic];
  public isFrontCamera: boolean = false;
  public exifXtStyleParam = [-1, -1, -1, -1];
  public editCounter: number = 0;
  public persistInfo = new PersistInfo();
  public hasPersistInfo = false;
  /** 媒体库一键回退失败后的状态 */
  public resetStatus: boolean = true;
  /** 查询Exif结束才能显示bottomToolBar */
  public isQueryExifFinished: boolean = false;
  /** 图片来源 */
  public photoFromType: number = -1;
  public photoSourceType: number = -1;
  public changeLoading = false;
  public isExportFromBrowser = false; // 是否是大图直接调用编辑能力

  public setQueryExifFinishedStatus(status: boolean) {
    HiLog.i(TAG, `setQueryExifFinishedStatus status to ${status}`);
    appBroadCast.emit('queryExifFinished');
    this.isQueryExifFinished = status;
  }

  public longitude: string = ''; // 图片exif信息 - 经度
  public latitude: string = ''; // 图片exif信息 - 纬度
  public locationParam: string = ''; // 拍摄地点
  public picShotTime: string = ''; // 图片拍摄时间
  public picUpdateTime: string = ''; // 图片修改时间

  public setLastEditStatus() {
    this.editCounter = 0; // 更新当前参与对比的算子 调节、滤镜、XXX、大光圈
  }

  public increaseEditCounter(isEdit: boolean = true) {
    if (isEdit && this.editCounter < 0) {
      this.editCounter = 0;
    }
    this.editCounter++;
    HiLog.i(TAG, `increase editCounter = ${this.editCounter}`);
  }

  public reduceEditCounter() {
    this.editCounter--;
    HiLog.i(TAG, `reduce editCounter = ${this.editCounter}`);
  }

  public isComposedTab() {
    return this.composedTabs.includes(this.tabIndex);
  }

  public screenToolArea: Area | undefined = undefined;
  public releaseDownLoadingLcd: () => void = Event; // 释放DownLoading中的lcd图

  public isShowWatermarkTab(index: TabName) {
    return index === TabName.TabSeal;
  }

  /* instrument ignore next */
  public setCropReactInterrupt(isBlur: boolean = true) {
    clearTimeout(this.timeStartZoom);
    clearTimeout(this.timeBlur);
    this.asset.setClipCropRect(0, CropType.FRAME_CROP);
    this.interrupt = false;
    this.asset.crops().hasSplitLine = false;
    this.asset.crops().isCropSizeModified = this.asset.fillCropRect(0, FillCropType.Interrupt);
    this.stopEditorOperate();
    this.asset.crops().isEnableBlur = isBlur;
  }

  /* instrument ignore next */
  public resetLastStyleIndex(): void {
    this.lastStyleIndex = -1;
  }

  public init(): void {
    // 不能保存构造/成员变量初始化时的this，否则界面无法刷新
    this.asset = new Asset(this);
    this.onCmd = new Cmd(this);
    this.isBaseTextEditEnabled = BaseEditorCommonUtil.isBaseTextEditEnabled()
  }

  pause(): void {
    if (this.tabIndex === TabName.TabMosaic) {
      this.asset.mosaic().listener.emit('hideImage');
    }
  };

  resume(): void {
    if (this.tabIndex === TabName.TabMosaic) {
      this.asset.mosaic().listener.emit('showImage');
    }
  };

  animateChangeImmersive(immersive: boolean) {
    setTimeout((): void => {
      this.immersiveMode = immersive;
    }, 100)
  }

  setDeviceType(deviceType: string) {
    HiLog.i(TAG, `BaseEditor Asset_setDeviceType: ${deviceType}`);
    sdk.Asset_setDeviceType(this.timeline.id, this.asset.uid, deviceType);
  }

  /* instrument ignore next */
  private setSupportNewWatermark(supportNewWatermark: boolean) {
    HiLog.i(TAG, 'BaseEditor Asset_setSupportNewWatermark: ' + supportNewWatermark);
    sdk.Asset_setSupportNewWatermark(this.timeline.id, this.asset.uid, supportNewWatermark);
  }

  setEditDataType(editDataType: string) {
    HiLog.i(TAG, `BaseEditor Asset_setEditDataType: ${editDataType}`);
    sdk.Asset_setEditDataType(this.timeline.id, this.asset.uid, editDataType);
  }

  updateThumbnail(): void {
    HiLog.i(TAG, 'current index %{public}s', App.getInstance().myEditor().tabIndex.toString());
    /* instrument ignore if */
    if (App.getInstance().myEditor().tabIndex === TabName.TabXTStyle) {
      App.getInstance().myEditor().asset.requestXTStyleThumbnail();
    }
    if (App.getInstance().myEditor().tabIndex === TabName.TabFilter) {
      App.getInstance().myEditor().asset.requestFilterThumbnail();
    }
  }

  // 同步XXX水印缓存
  public syncXTStyleCacheParams(jsonStr: string): void {
    let jsonObject: Record<string, string>;
    //JSON读取异常处理
    try {
      jsonObject = JSON.parse(jsonStr);
    } catch (e) {
      HiLog.i(TAG, 'parse XTStyleCacheJsons failed.');
      return;
    }
    //JSON空值处理
    if (!jsonObject || Object.keys(jsonObject).length === 0) {
      HiLog.i(TAG, 'XTStyleCacheJsons is null||undefined||empty.');
      return;
    }
    //键校验,只要有一个键不在里面，就返回true
    let missingField = XTSTYLE_REQUIRED_FIELDS.some(field => !Object.keys(jsonObject).includes(field));
    if (missingField) {
      HiLog.i(TAG, 'XTStyleCacheJsons miss field.');
      return;
    }
    this.lastTemplateIndex = Number(jsonObject.templateIndex);
    this.lastStyleIndex = Number(jsonObject.type);
    this.lastHue = Number(jsonObject.colorTemperature);
    this.lastSaturation = Number(jsonObject.saturation);
    this.lastLightShadow = Number(jsonObject.lightShadow);
  }

  redo(): void {
    /* instrument ignore if */
    if (!App.getInstance().undoRedoInfo.canRedo) {
      return;
    }
    /* instrument ignore if */
    if (App.getInstance().undoRedoInfo.redoMap.length === 0) {
      App.getInstance().undoRedoInfo.initRedoMap();
    }
    let jsonStr: string = sdk.EditorContext_redo();
    HiLog.i(TAG, `EditorContext_redo result=${jsonStr}`);
    /* instrument ignore if */
    if (!jsonStr) {
      return;
    }
    let res: Params2 = JSON.parse(jsonStr);
    /* instrument ignore if */
    if (NullUtil.isObjNull(res)) {
      HiLog.e(TAG, 'redoRes is empty!');
      return;
    }
    let redoType: string = res.id;
    let redoModel = App.getInstance().undoRedoInfo.redoMap.get(redoType);
    /* instrument ignore else */
    if (redoModel) {
      HiLog.i(TAG, 'Redo type: %{public}s', redoType);
      redoModel.redoClass.cascadeOperation(jsonStr, false);
      App.getInstance().undoRedoInfo.redoInfo = redoModel.redoTips;

      if (fTimeout != null) {
        clearTimeout(fTimeout);
      }
      //如果redoType是XXX类型，刷新XXX水印
      if (this.xtStyleIndex2Type.includes(redoType)) {
        this.syncXTStyleCacheParams(jsonStr);
      }
      App.getInstance().undoRedoInfo.isShowRedoInfo = true;
      fTimeout = setTimeout((): void => {
        App.getInstance().undoRedoInfo.isShowRedoInfo = false;
      }, 2000)
    } else {
      HiLog.e('undefined redo type', String(redoType));
    }
    this.updateThumbnail();
    this.increaseEditCounter(false);
  }

  /* instrument ignore next */
  public changeTextLayer(type: string): boolean {
    return type === 'clipRatio' || type === 'ninetyRotate' || type === 'crop' || type === 'frame_sticker';
  }

  undo(): void {
    /* instrument ignore if */
    if (!App.getInstance().undoRedoInfo.canUndo) {
      return;
    }
    if (App.getInstance().undoRedoInfo.redoMap.length === 0) {
      App.getInstance().undoRedoInfo.initRedoMap();
    }
    let jsonStr: string = sdk.EditorContext_undo();
    HiLog.i(TAG, `EditorContext_undo result=${jsonStr}`);
    /* instrument ignore if */
    if (!jsonStr) {
      return;
    }
    let res: Params2 = JSON.parse(jsonStr);
    /* instrument ignore if */
    if (NullUtil.isObjNull(res)) {
      HiLog.e(TAG, 'undoRes is empty!');
      return;
    }
    let undoType: string = res.id;
    let undoModel = App.getInstance().undoRedoInfo.redoMap.get(undoType);
    /* instrument ignore else */
    if (undoModel) {
      HiLog.i(TAG, 'Undo type: %{public}s', undoType);
      undoModel.redoClass.cascadeOperation(jsonStr, true);
      App.getInstance().undoRedoInfo.redoInfo = undoModel.undoTips;

      if (fTimeout != null) {
        clearTimeout(fTimeout);
      }
      //如果undoType是XXX类型，刷新XXX水印
      if (this.xtStyleIndex2Type.includes(undoType)) {
        this.syncXTStyleCacheParams(jsonStr);
      }
      App.getInstance().undoRedoInfo.isShowRedoInfo = true;
      fTimeout = setTimeout((): void => {
        App.getInstance().undoRedoInfo.isShowRedoInfo = false;
      }, 2000)
    } else {
      this.asset.isClickUndoRedo = false;
      HiLog.e('undefined undo type', String(undoType));
    }
    this.updateThumbnail();
    this.reduceEditCounter();
  }

  resetData(cb: Function, refreshExif: boolean = false, refreshThumbnail: boolean = true, assetId?: string): void {
    this.editModified = false; // 重置基础编辑
    this.isEditorContextReseting = true;
    sdk.EditorContext_reset(this.timeline.id, refreshExif, assetId, (ret: string) => {
      if (JSON.parse(ret).result == 0) {
        HiLog.i(TAG, 'EditorContext_reset begin');
        HiLog.i(TAG, `EditorContext_reset resetData isResetSelected:${this.asset.adjusts().isResetSelected}`);
        sdk.EditorContext_UndoRedoManagerClear();
        this.isResetFilter = true;
        this.isResetXTStyle = true;
        let resetAllData: LanAsset = JSON.parse(ret).data;
        resetAllData.cropRectLeft = px2vp(resetAllData.cropRectLeft);
        resetAllData.cropRectTop = px2vp(resetAllData.cropRectTop);
        resetAllData.cropRectRight = px2vp(resetAllData.cropRectRight);
        resetAllData.cropRectBottom = px2vp(resetAllData.cropRectBottom);
        HiLog.i(TAG, 'resetAllData.cropRect: %{public}s, %{public}s, %{public}s, %{public}s',
          resetAllData.cropRectLeft,
          resetAllData.cropRectTop,
          resetAllData.cropRectRight,
          resetAllData.cropRectBottom
        );
        this.asset.initData(resetAllData);
        this.asset.crops().isResetCrop = true;
        let adjustData: AdjustItem[] = resetAllData.adjust;
        this.asset.adjusts().SyncDataFromSdk(adjustData);
        this.isShowRevert = false;
        this.isReset = true;

        //刷新缩略图
        if (refreshThumbnail) {
          this.refreshThumbnail.ifRefreshThumbnail = true;
          this.asset.requestFilterThumbnail();
        }
        cb();
        this.isEditorContextReseting = false;
        HiLog.i(TAG, 'EditorContext_reset end');
      } else {
        this.isEditorContextReseting = false;
      }
    })
  }


  /**
   * 滚轮等连续操作的动作开始记录
   */
  startEditorOperate() {
    HiLog.i(TAG, 'start operation');
    sdk.EditorContext_Start();
  }

  /**
   * 滚轮等连续操作的动作停止记录
   */
  stopEditorOperate() {
    HiLog.i(TAG, 'stop operation');
    sdk.EditorContext_Stop();
  }

  initPreviewStartedCallback(): void {
    // WARNING: callback监听放到constructor()中初始化会导致属性修改后界面不刷新，所以这里增加了一个 initialize 方法
    sdk.EditorContext_setConfigChangeCallback(this.timeline.id, (isDefaultConfig: boolean) => {
      HiLog.i(TAG, `isDefaultConfig = ${isDefaultConfig}`);
      this.editModified = !isDefaultConfig;
      /* instrument ignore if */
      if (this.isEdit) {
        this.isShowRevert = !this.isEdited();
      }
    })
    sdk.EditorContext_RegUndoRedoStateChangeCb((undoEnable: boolean, redoEnable: boolean) => {
      HiLog.i('EditorContext_RegUndoRedoStateChangeCb undoEnable', String(undoEnable));
      HiLog.i('EditorContext_RegUndoRedoStateChangeCb redoEnable', String(redoEnable));
      App.getInstance().undoRedoInfo.canRedo = redoEnable;
      App.getInstance().undoRedoInfo.canUndo = undoEnable;
      App.getInstance().undoRedoInfo.isShowUnRedoButton = redoEnable || undoEnable;
    })
  }

  setExportProgressCallback(callback: Function | undefined): void {
    console.log('EditorContext: setExportProgressCallback');
    this.exportProgressCallback = callback;
  }

  setImportResultCallback(callback: Function | undefined): void {
    console.log('EditorContext: setImportResultCallback');
    this.importResultCallback = callback;
  }

  setExportResultCallback(callback: Function | undefined): void {
    console.log('EditorContext: setExportResultCallback');
    this.exportResultCallback = callback;
  }

  // 1、打开原始图片2、解析editdata并将editdata效果作用到原始图片上 sdk.ApplyEditData
  ApplyEditData(timelineId: number, sourceFileFd: number, editData: string, mediaType: number,
    cb: (jsonStr: string) => void, updatePreEffectParams?: () => void): void {
    sdk.EditorContext_applyEditData(timelineId, sourceFileFd, editData, mediaType, cb, (assetId: string)=>{
      this.asset.uid = assetId;
      updatePreEffectParams?.()
    });
  }

  LaneGetAsset(reEdit: boolean, timelineId: number, laneId: string, cb: (timeline: Timeline) => void,
    updatePreEffectParams?: () => void): void {
    sdk.Lane_getAsset(timelineId, laneId, (result2: string) => {
      HiLog.i(TAG, `Lane_getAsset result=${result2}`);
      Trace.begin('Lane_getAsset');
      let asset: LanAsset = JSON.parse(result2);
      /* instrument ignore if */
      if (NullUtil.isObjNull(asset)) {
        HiLog.e(TAG, `openByUri -> get asset failed! result=${result2}`);
        return;
      }
      this.asset.initData(asset);
      updatePreEffectParams?.();

      this.initPreviewStartedCallback();
      this.previewStarter.onAssetInitialized(this.asset, reEdit);
      HiLog.i(TAG, `Asset_SetRefreshRate refreshRate: ${ScreenUtil.getRefreshRate()}`)
      sdk.Asset_SetRefreshRate(this.timeline.id, this.asset.uid, ScreenUtil.getRefreshRate());
      this.SyncDataFromSDK();
      cb(this.timeline);
      /* instrument ignore if */
      if (this.isSupportXTStyleEdit) {
      }
      this.setDeviceType(DeviceUtil.getDeviceType());
      this.setSupportNewWatermark(DeviceUtil.isSupportArkSignWatermark());
      // 如果发现是新数据方案，则直接走编辑数据处理。
      if (this.hasPersistInfo) {
        this.userXtStyleName = this.persistInfo.filterXtDefinition;
        if (this.persistInfo.filterStickerDefinition) {

        }
        HiLog.i(TAG, `curr editLoadCurrTemplateName name is ${this.userXtStyleName} customText:`);
      } else {
        let xtStyleName: string = sdk.Asset_GetXtStyleName(this.timeline.id, this.asset.uid);
        HiLog.i(TAG, `curr editLoadCurrTemplateName name is ${xtStyleName}`);
        // 判断是否用户自定义的 XXX滤镜名称
        this.userXtStyleName = ''
      }
      // 原始图默认system;有编辑数据，根据类型setType,三方保持原有format;
      let type = 'system';
      HiLog.i(TAG, `Lane_getAsset isEdit = ${this.isEdit}, isPhotosEditData = ${this.isPhotosEditData}`);
      if (this.isEdit || this.isPhotosEditData) {
        HiLog.i(TAG, `Lane_getAsset editDataCompatibleFormat = ${this.editDataCompatibleFormat}`)
        type = this.isPhotosEditData ? PHOTO_BUNDLE_NAME : this.editDataCompatibleFormat === '' ?
          'third' : this.editDataCompatibleFormat;
      }
      this.setEditDataType(type);
      this.loadExifXtStyleParam();
      this.getLocationParam();

      this.isOpenInitReset = false;
      Trace.end('Lane_getAsset');
      HiLog.i(TAG, 'Lane_getAsset finish');
    })
  }

  SyncDataFromSDK() {
    this.asset.adjusts().getAdjustProperty();
  }

  queryMediaProperties() {
    let uri = this.mediaUri;
    HiLog.i(TAG, `queryMediaProperties uri: ${uri}`);
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    try {
      let predicate = new dataSharePredicates.DataSharePredicates();
      predicate.equalTo(photoAccessHelper.PhotoKeys.URI, uri);
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [
          photoAccessHelper.PhotoKeys.SUPPORTED_WATERMARK_TYPE,
          photoAccessHelper.PhotoKeys.BURST_KEY,
          photoAccessHelper.PhotoKeys.DATE_DAY,
          'photo_quality' as photoAccessHelper.PhotoKeys,
          'shooting_mode_tag' as photoAccessHelper.PhotoKeys,
          'all_exif' as photoAccessHelper.PhotoKeys,
        ],
        predicates: predicate,
      };
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
    } catch (err) {
      this.isSupportApertureEdit = false;
      HiLog.e(TAG, `query media properties failed, err: ${err}, code: ${err?.code}`);
    } finally {
      phAccessHelper?.release();
    }
  }

  /* instrument ignore next */
  async queryHiddenMediaProperties() {
    let uri = this.mediaUri;
    let albumFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.Album> | undefined = undefined;
    let assetFetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> | undefined = undefined;
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    try {
      let context = getContext(this);
      if (context === undefined) {
        HiLog.e(TAG, 'getContext return undefined');
        return;
      }
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      albumFetchResult =
        await phAccessHelper.getHiddenAlbums(photoAccessHelper.HiddenPhotosDisplayMode.ASSETS_MODE);
      const hiddenAlbum: photoAccessHelper.Album = await albumFetchResult.getFirstObject();
      if (hiddenAlbum === undefined) {
        HiLog.e(TAG, 'getHiddenAlbums return undefined');
        return;
      }

      let opt: photoAccessHelper.FetchOptions = {
        predicates: new dataSharePredicates.DataSharePredicates(),
        fetchColumns: [
          photoAccessHelper.PhotoKeys.SUPPORTED_WATERMARK_TYPE,
          photoAccessHelper.PhotoKeys.DATE_DAY,
          'photo_quality' as photoAccessHelper.PhotoKeys,
          'shooting_mode_tag' as photoAccessHelper.PhotoKeys,
          'all_exif' as photoAccessHelper.PhotoKeys,
        ]
      }
      opt.predicates.equalTo(photoAccessHelper.PhotoKeys.URI, uri);
      assetFetchResult = await hiddenAlbum.getAssets(opt);
      let photoAsset = await assetFetchResult.getFirstObject();
      if (photoAsset) {
        this.sealEnable = photoAsset.get(photoAccessHelper.PhotoKeys.SUPPORTED_WATERMARK_TYPE);
        HiLog.i(TAG, `queryHiddenMediaProperties  sealEnable: ${this.sealEnable}`);
        let shootingMode: string | undefined = photoAsset.get('shooting_mode_tag')?.toString();
        let dateDay: photoAccessHelper.MemberType = photoAsset.get(photoAccessHelper.PhotoKeys.DATE_DAY) ?? 0;
        this.isImageFullQuality = (photoAsset.get('photo_quality') as number) === 0;
        this.isSupportApertureEdit = [ShootingModeType.PORTRAIT_ALBUM, ShootingModeType.WIDE_APERTURE_ALBUM].
                                     includes(shootingMode as ShootingModeType) && (this.isImageFullQuality) &&
                                     dateDay > APERTURE_ALLOW_DAY;
        HiLog.i(TAG, `queryMediaProperties shootingDate ${dateDay}, allowAperture data: ${APERTURE_ALLOW_DAY}`);
        HiLog.i(TAG, `queryHiddenMediaProperties, isImageFullQuality: ${this.isImageFullQuality},
          pre check isSupportAperture:${this.isSupportApertureEdit}}`);
      }
    } catch (err) {
      HiLog.e(TAG, `query hidden media properties failed, err: ${err}, code: ${err?.code}`);
    } finally {
      albumFetchResult?.close();
      assetFetchResult?.close();
      HiLog.i(TAG, `albumFetchResult and assetFetchResult is close.`);
      phAccessHelper?.release();
    }
  }

  public async getEditData(asset: photoAccessHelper.PhotoAsset): Promise<void> {
    Trace.begin('getEditData');
    try {
      this.resetStatus = true;
      let isHidden: boolean = App.getInstance().myEditor().isHiddenSource;
      HiLog.i(TAG, `getEditData isHidden:${isHidden}`);
      /* instrument ignore if */
      if (isHidden) {
        await this.queryHiddenMediaProperties();
      } else {
        this.queryMediaProperties();
      }
      /* instrument ignore if */
      if (this.isCloudResource) {
        HiLog.i(TAG, 'currentPhoto is cloudResource, can not getEditData');
        this.setQueryExifFinishedStatus(true);
        return;
      }

      Trace.begin('getEditData');
      let data = await asset.getEditData();
      let editData: string = data.data;
      this.isEdit = await asset.isEdited();
      this.editDataCompatibleFormat = data.compatibleFormat;
      HiLog.i(TAG, 'isEdited: ' + this.isEdit + `, editData is ${editData}` + ' editDataCompatibleFormat: ' +
      this.editDataCompatibleFormat);
      let isMovingPhotoUri: boolean = PhotoAssetUtil.isMovingPhoto(asset) && this.requestUri !== undefined;
      Trace.end('getEditData');
      /* instrument ignore if */
      if (isMovingPhotoUri) {
        // MovingPhoto不能使用原始Asset基础编辑数据，如果要使用编辑数据，需要从参数传入
        editData = this.editData;
        this.editDataCompatibleFormat = editData === '' ? data.compatibleFormat : 'system';
        HiLog.i(TAG, `MovingPhoto request and has edit data: ${this.editData}`);
      }
      this.isCameraEditData = (editData !== '') && !this.isEdit;
      this.isEditNoData = false;
      /* instrument ignore if */
      if (editData === '' && this.isEdit) {
        this.isEditNoData = true;
      }
      let persistInfoResult = PersistInfoUtils.parsePersistInfo(editData);
      this.persistInfo = persistInfoResult.data;
      this.hasPersistInfo = persistInfoResult.hasPersistInfo;
      editData = persistInfoResult.reFormatEditData;
      if (editData !== '') {
        let isEditNoData: string = JSON.parse(editData)['system'];
        /* instrument ignore if */
        if (isEditNoData === '') {
          HiLog.i(TAG, 'getEditData system is null')
          this.isPhotosEditData = false;
          this.isEditNoData = true;
          this.resetStatus = false;
        } else if (this.editDataCompatibleFormat === '') {
          // 更新旧版本的编辑数据为system数据
          this.isSystemEditData = sdk.EditorContext_isSystemEditData(editData);
          this.isPhotosEditData = sdk.EditorContext_isThirdEditData(editData);
          this.editData = sdk.EditorContext_updateEditData(editData);
        } else {
          // 查看是否支持产品差异化算法
          let status: number = sdk.IsSupports_DifferentiatedAlgorithms(editData);
          HiLog.i(TAG, 'getEditData Asset_Restore status:' + status);
          if (status !== 0) {
            HiLog.i(TAG, 'getEditData restore failed');
            this.editDataCompatibleFormat = PHOTO_BUNDLE_NAME;
          }
          // 动图沙箱路径图片不适用PhotoAsset的编辑数据
          this.editData = editData;
          this.isSystemEditData = (this.editDataCompatibleFormat === 'system');
          HiLog.i(TAG, 'getEditData this.isSystemEditData:' + this.isSystemEditData);
          // 更新旧版本的third为photos
          this.isPhotosEditData = (this.editDataCompatibleFormat === 'third' ||
            this.editDataCompatibleFormat === PHOTO_BUNDLE_NAME);
          HiLog.i(TAG, 'getEditData this.isPhotosEditData:' + this.isPhotosEditData);
        }
        /* instrument ignore if */
        if (sdk.EditorContext_IsOldFilterEditData(this.editData)) {
          this.isSystemEditData = false;
          this.isPhotosEditData = true;
        }
        // 判断图片是否支持水印编辑
        this.hasSeal = sdk.EditorContext_HasWatermarkEffect(this.editData, (jsonStr: string) => {
        });
        HiLog.i(TAG, `hasSeal: ${this.hasSeal}`);
        /* instrument ignore if */
        if (isMovingPhotoUri) {
          HiLog.d(TAG, 'the edit data is movingphoto, fetch request uri fd.');
          await this.fetchRequestFd();
        } else {
          Trace.begin('requestSource');
          this.fd = await asset.requestSource();
          Trace.end('requestSource');
        }
        HiLog.i(TAG, 'isSystemEditData:' + this.isSystemEditData + ' isPhotosEditData:' + this.isPhotosEditData +
          ' isCameraEditData:' + this.isCameraEditData);
      }

      let imageFd = this.fd === -1 ? await asset.requestSource() : this.fd;
      await this.checkImageModel(imageFd);

      /* instrument ignore if */
      if (this.hasSeal && !this.hasSealResource) {
        // 判断相机认为带水印，且当前无水印资源，当效果图处理
        this.isSystemEditData = false;
        this.isPhotosEditData = true;
      }
      /* instrument ignore if */
      if (editData === '' && this.exifHasWatermark) {
        // exif有水印但是编辑数据为空，视为分享图
        HiLog.i(TAG, 'editData is empty but exifHasWatermark');
        this.isHWSharedPhoto = true;
      }
      let stickerFilters: filtersObj[] = this.getStickerFilters(editData);
      this.isSupportSeal = this.handleIsSupportSealEdit(editData, asset, stickerFilters);
      HiLog.i(TAG, `hasSeal:${this.hasSeal}, hasSealResource:${this.hasSealResource},
        isSupportSeal:${this.isSupportSeal}, isPhotosEditData:${this.isPhotosEditData}`);

      if (isMovingPhotoUri && App.getInstance().editorParams?.entryType !== 'default' &&
        App.getInstance().editorParams?.entryType !== 'xt_style') {
        this.isPhotosEditData = true;
      }

      // 移除了自由旋转功能，跳过相关操作
      const cropRotation = this.isPhotosEditData ? 0 : this.asset.crops().getInitCropRotation(editData);

      if (this.isPhotosEditData || !this.isImageFullQuality) {
        this.isSupportApertureSys = false;
      }
      HiLog.i(TAG, 'isPhotosEditData:' + this.isPhotosEditData + ' isSupportApertureSys:' + this.isSupportApertureSys +
        ' isImageFullQuality:' + this.isImageFullQuality);
    } catch (err) {
      HiLog.e(TAG, `getEditData failed. :${err?.code}---${err}`);
    } finally {
      this.setQueryExifFinishedStatus(true);
      Trace.end('getEditData');
      HiLog.i(TAG, `getEditData isPhotosEditData = ${this.isPhotosEditData}`);
    }
  }

  handleIsSupportSealEdit(editData: string, asset: photoAccessHelper.PhotoAsset, stickerFilters: filtersObj[]) {
    HiLog.i(TAG, 'handleIsSupportSealEdit enter');
    // 编辑数据丢失或异常场景
    if (this.isEdit && editData === '') {
      HiLog.i(TAG, 'handleIsSupportSealEdit editData is empty, res: false');
      return false;
    }
    let isSpringWaterMark: boolean = editData.includes('FestivalSticker');
    // 春节/国庆水印支持编辑
    if (isSpringWaterMark) {
      if (this.sealEnable === photoAccessHelper.WatermarkType.DEFAULT) {
        let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
        try {
          const mediaRequest: photoAccessHelper.MediaAssetChangeRequest =
            new photoAccessHelper.MediaAssetChangeRequest(asset);
          mediaRequest.setSupportedWatermarkType(photoAccessHelper.WatermarkType.BRAND_COMMON);
          phAccessHelper.applyChanges(mediaRequest).then(() => {
            phAccessHelper?.release();
          });
        } catch (err) {
          phAccessHelper?.release();
          HiLog.e(TAG, `FestivalSticker setSupportedWatermarkType failed. ${err?.code}`);
        }
      }
      HiLog.i(TAG, `handleIsSupportSealEdit isSpringWaterMark: true`);
      return true;
    }
    // 不支持水印的照片、三方照片
    if (this.sealEnable === photoAccessHelper.WatermarkType.DEFAULT) {
      HiLog.i(TAG, 'handleIsSupportSealEdit sealEnable: 0, res: false');
      return false;
    }
    // 相机拍照无水印，无编辑数据
    if (editData === '') {
      HiLog.i(TAG, 'handleIsSupportSealEdit editData is empty, res: true');
      return true;
    }
    // 相机拍照无水印，有编辑数据
    if (stickerFilters.length === 0) {
      HiLog.i(TAG, 'handleIsSupportSealEdit stickerFilters.length: 0, res: true');
      return true;
    } else {
      let isSupportedWatermarkType = stickerFilters.some(item => this.watermarkTypeArr.includes(item?.name));
      HiLog.i(TAG, `handleIsSupportSealEdit isSupportedWatermarkType: ${isSupportedWatermarkType}`);
      return isSupportedWatermarkType;
    }
  }

  getStickerFilters(editData: string) {
    if (editData === '') {
      return [];
    }
    let stickerFilters: filtersObj[] = [];
    try {
      let filters: filtersObj[] = JSON.parse(editData)?.imageEffect?.filters ?? [];
      if (filters?.length !== 0) {
        stickerFilters = filters.filter((item: filtersObj) => (item?.name ?? '').toLowerCase().includes('sticker'));
      }
    } catch (err) {
      HiLog.e(TAG, `getStickerFilters failed. ${err?.code}`);
    }
    HiLog.i(TAG, `getStickerFilters stickerFilters: ${JSON.stringify(stickerFilters)}`);
    return stickerFilters;
  }

  private checkSealResource(imageModel: string): void {
    try {
      let sourcePath: string = '';
      let isHide: string = systemParameterEnhance.getSync('const.mspes.camera_watermark');
      let devModel: string = systemParameterEnhance.getSync('const.product.name');
      let custDevModel: string = systemParameterEnhance.getSync('const.cust.devmodel');
      HiLog.i(TAG, `isHide:${isHide} devModel:${devModel} imageModel:${imageModel}`);
      /* instrument ignore else */
      if (imageModel === 'unknown' && isHide === 'true') {
        sourcePath = '/sys_prod/resource/camera/camouflage/';
      } else if (imageModel === devModel) {
        sourcePath = '/sys_prod/resource/camera/';
      } else {
        return;
      }
      let res = fs.accessSync(sourcePath + custDevModel);
      /* instrument ignore if */
      if (res) {
        HiLog.i(TAG, `watermark resource file exists. path:${sourcePath}` + custDevModel);
      } else {
        HiLog.i(TAG, 'watermark resource file not exists.');
        res = fs.accessSync(sourcePath);
        if (res) {
          HiLog.i(TAG, `watermark resource file exists. path:${sourcePath}`);
        } else {
          HiLog.i(TAG, `watermark resource file not exists.${sourcePath}`);
        }
      }
      this.hasSealResource = res;
      return;
    } catch (error) {
      HiLog.i(TAG, `readWatermarkPath get error ${error}`);
    }
  }

  public async checkImageModel(imageFd: number): Promise<void> {
    const imageSource: image.ImageSource = image.createImageSource(imageFd);
    /* instrument ignore if */
    if (!imageSource || imageSource === undefined) {
      HiLog.e(TAG, `create imageSource Failed, imageFd: ${imageFd}`);
      return;
    }
    try {
      let options: image.ImagePropertyOptions = { index: 0, defaultValue: '' }
      let imageModel = await imageSource.getImageProperty(image.PropertyKey.MODEL, options);
      this.exifXmageColorMode = await ExifUtil.readIntVal(imageSource, 'HwMnoteXmageColorMode', options, -1);
      this.exifHasWatermark = await ExifUtil.hasKey(imageSource, image.PropertyKey.XMAGE_MODE, options);
      this.exifXTSourceStyleIndex = await ExifUtil.readIntVal(imageSource, 'HwMnoteXtStyleTemplateName', options, -1);
      // 是否前置摄像头拍照的照片
      this.isFrontCamera = await imageSource.getImageProperty(
        image.PropertyKey.FRONT_CAMERA, options) === '1';
      HiLog.i(TAG,
        `checkImageModel getImageProperty isFontCamera: ${this.isFrontCamera} xmageCodeMode: ${this.exifXmageColorMode} SourceStyleIndex${
        this.exifXTSourceStyleIndex} exifHasWatermark${this.exifHasWatermark}`);
      if (this.isFrontCamera) {
        this.isSupportApertureEdit = false;
      }
      // 如果是 AI,马赛克，文字，等效果图，则不支持光圈编辑
      if (this.isPhotosEditData) {
        HiLog.i(TAG,
          `checkImageModel isSupportApertureEdit change to false because isPhotosEditData : ${this.isPhotosEditData}`);
        this.isSupportApertureEdit = false;
      }
      if (!imageModel) {
        HiLog.e(TAG, `do not have seal Resource. imageMode:${imageModel}`);
        return;
      }
      this.checkSealResource(imageModel);

      try {
        this.longitude = await imageSource.getImageProperty(image.PropertyKey.GPS_LONGITUDE);
        this.latitude = await imageSource.getImageProperty(image.PropertyKey.GPS_LATITUDE);
      } catch (err) {
        HiLog.e(TAG, `getImageProperty longitude or latitude failed. ${err?.code}---${err}`);
      }
      try {
        this.picShotTime = await imageSource.getImageProperty(image.PropertyKey.DATE_TIME_ORIGINAL);
        this.picUpdateTime = await imageSource.getImageProperty(image.PropertyKey.DATE_TIME);
        HiLog.i(TAG, `checkImageModel getImageProperty picShotTime: ${this.picShotTime
        } picUpdateTime: ${this.picUpdateTime}`);
      } catch (err) {
        HiLog.e(TAG, `getImageProperty picShotTime or picUpdateTime failed. ${err?.code}---${err}`);
      }
    } catch (err) {
      HiLog.e(TAG, `checkImageModel failed. ${err?.code}---${err}`);
    } finally {
      imageSource?.release();
    }
  }

  handleLocationToDigital(location: string): number {
    let list = location.split(', ');
    if (location?.length < 3) {
      HiLog.e(TAG, 'location is invalid');
      return 0;
    }
    return Number(list[0]) + Number(list[1]) / 60 + Number(list[2]) / 3600;
  }

  public getLocationParam() {
    HiLog.i(TAG, 'getLocationParam enter');
    if (this.longitude === '' || this.latitude === '') {
      this.locationParam = '';
      HiLog.e(TAG, 'getLocationParam longitude or latitude not exist');
      return;
    }
    let systemLocale: string = '';
    try {
      systemLocale = i18n.System.getSimplifiedLanguage(); // 获取当前系统语言的简化表示
      HiLog.i(TAG, `getLocationParam systemLocale: ${systemLocale}`);
    } catch (error) {
      this.locationParam = '';
      let err: BusinessError = error as BusinessError;
      HiLog.e(TAG, `getLocationParam getSystemLocale failed, error code: ${err.code}, message: ${err.message}.`);
    }

    let latitude = this.handleLocationToDigital(this.latitude);
    let longitude = this.handleLocationToDigital(this.longitude);
    if (latitude === 0 || longitude === 0) {
      this.locationParam = '';
      HiLog.e(TAG, 'getLocationParam get latitude or longitude failed.');
      return;
    }
    // 通过location模块的接口，由经纬度信息转化为市级信息，获取市级字段
    let reverseGeocodeRequest: geoLocationManager.ReverseGeoCodeRequest = {
      'locale': systemLocale,
      'latitude': latitude,
      'longitude': longitude,
      'maxItems': 1,
    };

    try {
      geoLocationManager.getAddressesFromLocation(reverseGeocodeRequest, (err, data) => {
        let locationParam = '';
        if (err || !data || !data[0]) {
          HiLog.e(TAG, 'getAddressesFromLocation: err=' + JSON.stringify(err));
        } else if (data[0].subAdministrativeArea) {
          HiLog.i(TAG, 'getAddressesFromLocation: subAdministrativeArea');
          locationParam = data[0].subAdministrativeArea;
        } else if (data[0].locality) {
          HiLog.i(TAG, 'getAddressesFromLocation: locality');
          locationParam = data[0].locality;
        } else {
          HiLog.e(TAG, 'getAddressesFromLocation: failed');
        }
        this.locationParam = locationParam;
      });
    } catch (err) {
      this.locationParam = '';
      HiLog.e(TAG, 'getAddressesFromLocation errCode:' + (err as BusinessError).code + ',errMessage:' +
      (err as BusinessError).message);
    }
  }

  /* instrument ignore next */
  private async fetchRequestFd(): Promise<void> {
    try {
      if (this.requestUri === undefined) {
        return;
      }
      let file: fileIo.File = await fileIo.open(this.requestUri, fileIo.OpenMode.READ_ONLY);
      this.fd = file?.fd ?? this.fd;
      HiLog.i(TAG, `getEditData the request uri fd: ${this.fd}`);
    } catch (e) {
      HiLog.e(TAG, `fetchRequestFd error ${e}`);
    }
  }

  /* instrument ignore next */
  public async getCloudAnimationEnv(asset: photoAccessHelper.PhotoAsset | undefined) {
    if (!asset) {
      HiLog.e(TAG, 'cloudOpenAnimation failed photoAsset is undefined');
      return;
    }
    this.mediaUri = asset.uri;
    let isHidden: boolean = App.getInstance().myEditor().isHiddenSource;
    HiLog.i(TAG, `getCloudAnimationEnv isHidden:${isHidden}`);
    if (isHidden) {
      await this.queryHiddenMediaProperties();
    } else {
      this.queryMediaProperties();
    }

    let data = await asset.getEditData();
    this.editData = data.data;
    this.isEdit = await asset.isEdited();

    this.fd = await asset.requestSource();
    await this.checkImageModel(this.fd);
    HiLog.i(TAG, 'getCloudAnimationEnv  finish');
  }

  /**
   * 从图库打开时，传入PhotoAsset，媒体类型, lcd缩略图
   * @param asset,mediaType,lcdPixelMap
   */
  openAsset(asset: photoAccessHelper.PhotoAsset | undefined, mediaType: MediaType,
    lcdPixelMap: image.PixelMap | undefined, cb: (timeline: Timeline) => void, openSuccCb?: () => void) {
    /* instrument ignore if */
    if (!asset) {
      HiLog.e(TAG, 'openAsset failed photoAsset is undefined');
      return;
    }
    let hdrSwitch = AppStorage.get<boolean>('hdr_picture_switch');
    this.isHdrShowOpen = (hdrSwitch !== false);
    let isWatermarkHideResource = systemParameter.getSync('const.mspes.camera_watermark', 'false') !== 'false';
    HiLog.i(TAG, `isHdrShownOpen: ${this.isHdrShowOpen}`);
    this.mediaUri = asset.uri;
    this.mediaAsset = asset;
    this.isHiddenSource = asset.get(photoAccessHelper.PhotoKeys.HIDDEN.toString()) as boolean ?? false;
    const isAiWatermarkEnabled = settings.getValueSync(getContext(this), 'ai_compose_flag', 'false') === 'true';
    HiLog.i(TAG, 'isAiWatermarkEnabled: ' + isAiWatermarkEnabled);

    this.isOpenInitReset = true;
    this.afterLoadCb = cb;
    this.lcdPixelMap = lcdPixelMap;
    HiLog.i(TAG, 'EditorContext_createTimeline start uri=' + asset.uri + ` isHiddenSource = ${this.isHiddenSource}`);
    // 打开时先获取编辑数据
    this.getEditData(asset).then(() => {
      Trace.begin('createTimeline');
      sdk.Asset_SetProjectConfigValue('UltraPhoto', false);
      HiLog.i(TAG, `set isEdit = ${this.isEdit}`);
      const isEdit = this.isEdit ? '1' : '0';
      sdk.Asset_SetProjectConfigValue('ReEdit', isEdit);
      sdk.EditorContext_createTimeline('', mediaType, this.isHdrShowOpen, this.onSdkMessage,
        async (jsonStr: string) => {
          Trace.end('createTimeline');
          HiLog.i(TAG, `EditorContext_createTimeline result=${jsonStr}`);
          this.timeline = new Timeline();
          let ret: Params3 = JSON.parse(jsonStr);
          /* instrument ignore if */
          if (NullUtil.isObjNull(ret)) {
            HiLog.e(TAG, 'createTimeline result is empty!');
            return;
          }
          /* instrument ignore if */
          if (ret.result != 0) {
            HiLog.e(TAG, 'EditorContext_createTimeline import failed');
            this.importResult(ret.result);
            return;
          }
          copyAttrTo(ret, this.timeline);
          this.previewStarter.onTimelineInitialized(this.timeline);
          HiLog.i(TAG, 'Timeline_appendVideoLane start');

          openSuccCb?.();
        }, (this.isEdit || this.isCameraEditData) && this.isSystemEditData ? this.editData : '',
        isWatermarkHideResource, isAiWatermarkEnabled);

      if (AppStorage.get('is_entry_XTStyle') && !this.isPhotosEditData) {
        // 如果需要进编辑直接显示调色盘则先在这里初始化XXX数据, 目前只有直接由演示hap拉图库进编辑才会走这里。大图点击编辑按钮走正常流程
        this.initXtStyleData();
      } else {
        // 直接展开调色盘场景用这个变量控制bottomToolBar显示与隐藏
        // 如果调色盘不需要直接展开则需要将它置成false, 让bottomToolBar显示出来
        AppStorage.setOrCreate('is_entry_XTStyle', false);
        HiLog.i(TAG, `no need to open customFilterCard: ${AppStorage.get('is_entry_XTStyle')},` +
          `${this.isPhotosEditData}`);
      }
    });
  }

  public loadExifXtStyleParam() {
    this.exifXtStyleParam = sdk.Asset_GetExifXtStyleParam(this.timeline.id, this.asset.uid)
    HiLog.i(TAG, `load exif xtStyleParam is ${this.exifXtStyleParam}`);
  }

  private initXtStyleData(): void {
    this.queryMediaProperties();
    let res: string = sdk.EditorContext_HasXTStyleEffect(this.editData);
    let hasXTStyleResource: boolean = false;
    if (hasXTStyleResource && this.isImageFullQuality) {
      let editor: BaseEditor = App.getInstance().myEditor();
      appBroadCast.on('CustomFilterStackCardViewInitiated', () => {
        this.hasCustomFilterStackCardViewInitiated = true;
        appBroadCast.off('CustomFilterStackCardViewInitiated');
      });
    }
  }

  afterLoad(cb: (timeline: Timeline) => void, updatePreEffectParams?: () => void) {
    HiLog.i(TAG,
      'afterLoad:' + this.isEdit + ', camera ' + this.isCameraEditData + ', system ' + this.isSystemEditData);
    if ((this.isEdit || this.isCameraEditData) && this.isSystemEditData) {
      this.isOpenInit = true;
      //页面展示复原按钮
      if (!this.isCameraEditData) {
        this.isShowRevert = true;
      }
      HiLog.i(TAG, `isShowRevertTest:${this.isShowRevert}`);
      //获取编辑前源文件fd
      HiLog.i(TAG, `requestSourceTest:${this.fd}`)
      //将editData效果作用到原始图片上
      Trace.begin('ApplyEditData');

      this.ApplyEditData(this.timeline.id, this.fd, this.editData, MediaType.IMAGE, (result: string) => {
        HiLog.i(TAG, `EditorContext_applyEditData result = ${result}`);
        let applyResult: SDKFuncResult = JSON.parse(result);
        updatePreEffectParams?.();
        /* instrument ignore if */
        if (NullUtil.isObjNull(applyResult)) {
          HiLog.e(TAG, 'EditorContext_applyEditData result is empty!');
          return;
        }
        /* instrument ignore if */
        if (applyResult.result == -100003) {
          // 没有编辑组件的extra_info
          if (!this.isCameraEditData) {
            this.isShowRevert = true;
          }
          let lane: Params4 = JSON.parse(sdk.Timeline_appendVideoLane(this.timeline.id));
          HiLog.i(TAG, `Timeline_appendVideoLane result=${JSON.stringify(lane)}`);
          this.timeline.lane.id = lane.uid;
          HiLog.i(TAG, `Lane_appendAsset start${JSON.stringify(this.lcdPixelMap)}`);
          sdk.Lane_appendAsset(this.timeline.id, lane.uid, 'fd://' + this.fd, MediaType.IMAGE, this.lcdPixelMap,
            (result: string) => {
              HiLog.i(TAG, `Lane_appendAsset result=${result}`);
              let assetInfo: object = JSON.parse(result);
              copyAttrTo(assetInfo, this.asset);
              updatePreEffectParams?.();
              this.LaneGetAsset(false, this.timeline.id, lane.uid, cb);
            }, this.editData, false, false, this.isFrontCamera, this.isCameraEditData)
          return;
        } else if (applyResult.result != 0) {
          HiLog.e(TAG, 'apply edit data failed: ' + applyResult.msg + `(${applyResult.result}` + ')');
          return;
        }
        let data: ApplyEditDataResultData = applyResult.data as ApplyEditDataResultData;
        this.timeline.lane.id = data.lane;
        HiLog.i(TAG, `EditorContext_applyEditData success, lane uid = ${data.lane}, asset uid = ${data.asset}`);
        this.LaneGetAsset(true, this.timeline.id, data.lane, cb, updatePreEffectParams);
      }, updatePreEffectParams)
      Trace.end('ApplyEditData');
    } else {
      this.isShowRevert = this.isEdit ? true : false;
      this.isOpenInit = true;
      let lane: Params4 = JSON.parse(sdk.Timeline_appendVideoLane(this.timeline.id));
      HiLog.i(TAG, `Timeline_appendVideoLane result=${JSON.stringify(lane)}`);
      if (NullUtil.isObjNull(lane)) {
        HiLog.e(TAG, 'Timeline_appendVideoLane result is empty!');
        return;
      }
      this.timeline.lane.id = lane.uid;
      HiLog.i(TAG, `Lane_appendAsset start, fd is ${this.fd}`);
      let appendUri = PhotoAssetUtil.isMovingPhoto(this.mediaAsset) &&
      this.requestUri ? this.requestUri : this.mediaUri;
      let isNeedEditData = this.hasSealResource && this.hasSeal;
      HiLog.i(TAG, `isNeedEditData: ${isNeedEditData}`);
      sdk.Lane_appendAsset(this.timeline.id, lane.uid, appendUri, MediaType.IMAGE, this.lcdPixelMap,
        (result: string) => {
          HiLog.i(TAG, `Lane_appendAsset result=${result}`);
          let assetInfo: object = JSON.parse(result);
          if (NullUtil.isObjNull(assetInfo)) {
            HiLog.e(TAG, 'Lane_appendAsset result is empty!');
            return;
          }
          copyAttrTo(assetInfo, this.asset);
          updatePreEffectParams?.();
          this.LaneGetAsset(false, this.timeline.id, lane.uid, cb);
        }, isNeedEditData ? this.editData : '', true, this.isSupportSeal && this.hasSealResource, this.isFrontCamera,
        this.isCameraEditData)
    }
  }

  setInputData(pixelMap: image.PixelMap | undefined) {
    sdk.Asset_SetSourceByPixelMap(this.timeline.id, this.asset.uid, pixelMap);
  }

  public importResult(message: number): void {
    this.isImportFailed = message !== 0;
    this.importResultCallback?.(message);
  }

  public onSdkMessage = (msg: string): void => {
    HiLog.i('EditorContext: onSdkMessage:', msg);
    let message: Message = JSON.parse(msg);
    /* instrument ignore if */
    if (NullUtil.isObjNull(message)) {
      HiLog.e(TAG, 'EditorContext: onSdkMessage: message is empty!')
      return;
    }
    let ret: number = message.importResult;
    /* instrument ignore if */
    if (ret + 1 === ret) {
      HiLog.i('EditorContext: onSdkMessage infinity:', String(ret));
      message = JSON.parse(msg);
      if (NullUtil.isObjNull(message)) {
        HiLog.e(TAG, 'EditorContext: onSdkMessage infinity: message is empty!')
        return;
      }
    }
    let cmd = message._cmd;
    message._cmd = '';
    this.onCmd.getFunction(cmd, message);
  }

  /* instrument ignore next */
  save(callback: (s: number) => void): void {
    console.log('EditorContext_saveProject start');
    sdk.EditorContext_saveProject(this.timeline.id, (result: string) => {
      let json: Params = JSON.parse(result);
      HiLog.i(TAG, `EditorContext_saveProject ret=${result}`);
      if (NullUtil.isObjNull(json)) {
        HiLog.e(TAG, 'EditorContext_saveProject: result is empty!')
        return;
      }
      callback(json.code);
    });
  }

  close(callback: (s: number) => void): void {
    /* instrument ignore if */
    HiLog.i(TAG, 'close project begin');
    if (!this.timeline) {
      return;
    }
    this.editData = '';
    this.lcdPixelMap?.release();
    this.isEditorClosed = true;
    this.cancel();
    this.asset.noStylusPixelMap?.release();
    this.asset.textEditPixelMap?.release();
    this.asset.exportPixelMap?.release();
    this.isPhotosEditData = false;
    this.tabIndex = TabName.TabCrop;

    sdk.EditorContext_closeProject(this.timeline.id, (result: string) => {
      HiLog.i(TAG, 'close project end');
      ImageMediaLibraryProxy.closeSportFile();
      let json: Params = JSON.parse(result);
      if (NullUtil.isObjNull(json)) {
        HiLog.e(TAG, 'release: result is empty!')
        return;
      }
      callback(json.code);
    });
  }

  getExportRect(callback: (width: number, height: number) => void) {
    HiLog.i(TAG, `getExportRect this.timeline.id:${this.timeline.id},this.asset.uid${this.asset.uid}`);
    sdk.EditorContext_getExportRect(this.timeline.id, this.asset.uid, callback);
  }

  getExportData(callback: (pixelmap: image.PixelMap, exportInfo: string, waterMarkInfo: string) => void,
    options?: GetExportDataOptions) {
    this.compileTimelinePixelMap(this.timeline, options?.getIsOriginColor() ? true : false, '', this.asset.uid,
      this.mediaType, callback, options?.getIsToAiPage() ? true : false, options?.getNeedAddWatermark() ? true : false,
      options?.getIsSave());
  }

  releaseFlowSource(flowType: SourceFlowType): void {
    sdk.EditorContext_releaseFlowSource(flowType);
  }

  getAssetData(callback: (mediaAsset: photoAccessHelper.PhotoAsset | undefined) => void) {
    HiLog.i(TAG, 'EditorContext: getAssetData mediaUri =' + this.mediaAsset?.uri);
    callback(this.mediaAsset);
  }

  public async compileTimeline(timeline: Timeline, startTime: number, endTime: number, outputPath: string,
    assertUid: string, mediaType: MediaType, mimeType: string, callback: (exportInfo: string, type: string) => void) {
    console.log('EditorContext: compileTimeline range[' + startTime + ',' + endTime +
      ']' + ' assertUid=' + assertUid);
    sdk.Asset_FinishAnimation(timeline.id, assertUid);
    // 保存导出时，最后一个参数autoFlush不需要刷新，避免EXIF旋转预览时显示异常
    Trace.begin('EditorContext_compileTimeline');
    let tempCallback = (exportInfo: string, type: string) => {
      Trace.end('EditorContext_compileTimeline')
      if (this.hasPersistInfo) {
        // 同步用户自定义模板名称到 persistInfo 节点。
        this.persistInfo.filterXtDefinition = this.userXtStyleName;
        callback(PersistInfoUtils.merge(exportInfo, this.persistInfo), type);
      } else {
        callback(exportInfo, type);
      }
    };
    sdk.EditorContext_compileTimeline(timeline.id, outputPath, assertUid, mediaType, mimeType, tempCallback, false);
  }

  /**
   * 直接pixelMap保存
   */
  /* instrument ignore next */
  public encodePixelMap(timeline: Timeline, outputPath: string, assertUid: string, editData: string, mimeType: string,
    pixelMap: image.PixelMap, waterMarkInfo: string,
    callback: (exportInfo: string, type: string) => void) {
    Trace.begin('EditorContext_encodePixelMap');
    let tempCallback = (exportInfo: string, type: string) => {
      Trace.end('EditorContext_encodePixelMap');
      pixelMap?.release();
      callback(exportInfo, type);
    };
    sdk.EditorContext_encodePixelMap(timeline.id, outputPath, assertUid, editData, mimeType, pixelMap, waterMarkInfo,
      tempCallback);
  }

  public async compileTimelinePixelMap(timeline: Timeline, isOriginColor: boolean, outputPath: string,
    assertUid: string, mediaType: MediaType,
    callback: (pixelmap: image.PixelMap, exportInfo: string, waterMarkInfo: string) => void, isToAiPage: boolean,
    needAddWatermark: boolean, isSave?: boolean) {
    HiLog.i(TAG, 'EditorContext: compileTimeline isOriginColor =' + isOriginColor + ',' +
      ' assertUid=' + assertUid + ' isToAiPage=' + isToAiPage);
    Trace.begin('EditorContext_compileTimelinePixelMap');
    let tempCallback = (pixelmap: image.PixelMap, exportInfo: string, waterMarkInfo: string) => {
      Trace.end('EditorContext_compileTimelinePixelMap')
      callback(pixelmap, exportInfo, waterMarkInfo);
    };
    sdk.Asset_FinishAnimation(timeline.id, assertUid);
    sdk.EditorContext_compileTimelinePixelMap(timeline.id, outputPath, isOriginColor, assertUid, mediaType,
      tempCallback, isToAiPage, needAddWatermark, isSave);
  }

  /* instrument ignore next */
  cancelCompileTimeline(timeline: Timeline, assertUid: string, callback: () => void): void {
    console.log('EditorContext: cancelCompileTimeline');
    sdk.EditorContext_cancelCompileTimeline(timeline.id, assertUid, callback);
  }

  /* instrument ignore next */
  clearCache(): void {
    console.log('EditorContext: clearCache');
    sdk.EditorContext_clearCache();
  }

  /* instrument ignore next */
  setPreviewPeriodRange(startTime: number, endTime: number): void {
    console.log('EditorContext: setProjectDuration');
    sdk.EditorContext_setPreviewPeriodRange(this.timeline.id, startTime, endTime);
  }

  cancel(): void {
    /* instrument ignore if */
    if (!this.timeline || !this.asset) {
      return;
    }
    HiLog.i(TAG, 'cancelThumbnail begin');
    // 如果还在加载缩略图的过程中，需取消对缩略图的请求操作
    sdk.Asset_cancelThumbnail(this.timeline.id, this.asset.uid);
  }

  /* instrument ignore next */
  replaceSource(path: string | undefined, cb: (res: number) => void): void {
    sdk.Lane_replaceSource(this.timeline.id, this.timeline.lane.id, path, cb);
  }

  public isEdited(): boolean {
    return this.editModified || this.stylusModified || this.textEditModified || this.mosaicModified;
  }

  public getCurPreviewRect(): RectValue {
    if (this.tabIndex === TabName.TabMosaic && this.asset.mosaic().getPreviewRect()) {
      return this.asset.mosaic().getPreviewRect() as RectValue;
    }
    return this.getCurXcPreviewRect();
  }

  public getCurXcPreviewRect() {
    try {
      let json: string = sdk.Asset_getCanvasPosition(this.timeline.id, this.asset.uid);
      /* instrument ignore if */
      if (json === '' || json === '{}') {
        HiLog.e(TAG, 'getCurPreviewRect empty json: %{public}s', json);
        return new RectValue(0, 0, 0, 0);
      } else {
        HiLog.i(TAG, `getCurPreviewRect:${json}`);
        let rect: RectValue = JSON.parse(json);
        /* instrument ignore if */
        if (DeviceUtil.isPc()) {
          rect.y += vp2px(PC_TOP_BAR_HEIGHT);
        }
        return rect;
      }
    } catch (e) {
      HiLog.e(TAG, `getCurPreviewRect fail, reason is :${e.message}`);
      return new RectValue(0, 0, 0, 0);
    }
  }

  switchStylusMode(reportNum?: number): void {
    /* instrument ignore if */
    if (this.interrupt) {
      HiLog.i(TAG, 'stylus setCropReactInterrupt');
      this.setCropReactInterrupt(this.tabIndex === TabName.TabCrop);
    }
    /* instrument ignore if */
    if (this.stylusModified && !this.editModified && !this.textEditModified && !this.mosaicModified) {
      return;
    }
    if (!this.isComposedTab()) {
      this.enterStylusByExport();
      return;
    }
    if (this.asset.exportPixelMap !== undefined) {
      // 已合成过
      HiLog.i(TAG, 'switch with exist map, reportNum: %{public}i', reportNum);
      const needRelease = this.asset.noStylusPixelMap !== this.asset.exportPixelMap;
      const releasePixelMap = this.asset.noStylusPixelMap;
      this.asset.noStylusPixelMap = this.asset.exportPixelMap;
      if (needRelease) {
        releasePixelMap?.release()
      }
      this.asset.exportPixelMap = undefined;
    } else {
      this.enterStylusByExport();
    }
  }

  private enterStylusByExport() {
    // 首次进入涂鸦界面或者涂鸦不在顶层时，需要释放旧底图,导出新底图
    HiLog.i(TAG, 'first enter stylus or editModified');
    this.getExportData((pixelmap: image.PixelMap, exportInfo: string, waterMarkInfo: string) => {
      PixelMapUtil.setMemoryNameSync(pixelmap, 'enterStylusByExport');
      this.asset.noStylusPixelMap?.release();
      this.asset.noStylusPixelMap = pixelmap;
      HiLog.d(TAG, `first enter stylus or exportInfo${exportInfo}`);
    });
  }

  // 下发个性风格参数
  /* instrument ignore next */
  public addXTStyle(xtStyleParams: Array<number>, repeat: boolean = false): void {
    if (!this.isNeedAddXTStyle(xtStyleParams) && !repeat) {
      HiLog.i(TAG, `addXTStyle pause`);
      return;
    }
  }

  /* instrument ignore next */
  private isNeedAddXTStyle(xtStyleParams: Array<number>): boolean {
    if (xtStyleParams.length == 6) {
      if ((this.lastStyleIndex === -1 && this.lastTemplateIndex === -1 &&
        this.lastHue === -1 && this.lastSaturation === -1 && this.lastLightShadow === -1) ||
        this.lastStyleIndex !== xtStyleParams[0] || this.lastHue !== xtStyleParams[1] ||
        this.lastSaturation !== xtStyleParams[2] || this.lastLightShadow !== xtStyleParams[3] ||
        this.lastTemplateIndex !== xtStyleParams[4]) {
        this.lastStyleIndex = xtStyleParams[0];
        this.lastHue = xtStyleParams[1];
        this.lastSaturation = xtStyleParams[2];
        this.lastLightShadow = xtStyleParams[3];
        this.lastTemplateIndex = xtStyleParams[4];
        return true;
      }
    }
    return false;
  }

  /**
   * 是否允许XXX编辑
   * @returns
   */
  public isAllowEditXtStyle(): boolean {
    HiLog.i(TAG,
      `isAllowEditXtStyle: exifXTSourceStyleIndex:${this.exifXTSourceStyleIndex}`);
    if (!this.isImageFullQuality) {
      //80分图 不支持
      HiLog.i(TAG, `isAllowEditXtStyle: false, not ImageFullQuality`);
      return false;
    }
    if (this.isBurstImage) {
      //连拍图 不支持
      HiLog.i(TAG, `isAllowEditXtStyle: false, isBurstImage`);
      return false;
    }
    //涂鸦 文本 马赛克 编辑后变为效果图，不支持XtStyle
    if (this.stylusModified || this.mosaicModified || this.textEditModified || this.isPhotosEditData) {
      HiLog.i(TAG, `isAllowEditXtStyle: false,  stylus/mosaic/text/AI change`);
      return false;
    }

    if (this.exifXTSourceStyleIndex > 0) {
      if (this.hasXTStyleResource) {
        //使用XXX滤镜 并且 有编辑数据
        HiLog.i(TAG, `isAllowEditXtStyle: true,hasXTStyle and StyleIndex:${this.exifXTSourceStyleIndex}`);
        return true;
      } else {
        //使用XXX滤镜 并且 没有编辑数据（分享过来）
        HiLog.i(TAG, `isAllowEditXtStyle: false,hasXTStyle and StyleIndex:${this.exifXTSourceStyleIndex}`);
        return false;
      }
    } else if (this.exifXTSourceStyleIndex === 0) {
      //原色：无XXX滤镜
      if (this.exifXmageColorMode === 0) {
        if (this.isCameraEditData) {
          //有相机数据 说明是本地图
          HiLog.i(TAG, `isAllowEditXtStyle: true,Camera:${this.isCameraEditData}`);
          return true;
        } else if (!this.exifHasWatermark) {
          //无编辑数据 同时也没有水印 说明是分享图
          HiLog.i(TAG, `isAllowEditXtStyle: true, no Camera/System/Watermark`);
          return true;
        } else {
          //无相机数据 还有水印 为分享图
          HiLog.i(TAG, `isAllowEditXtStyle: false, no EditData and hasWatermark`);
          return false;
        }
      } else {
        //非原色，不支持编辑
        HiLog.i(TAG, `isAllowEditXtStyle: false,exifXmageColorMode:${this.exifXmageColorMode}`);
        return false;
      }
    } else {
      HiLog.i(TAG, `isAllowEditXtStyle: false,StyleIndex:${this.exifXTSourceStyleIndex}`);
      return false;
    }
  }

  public getCurrentXtStyleParams(): string {
    let params: string = '';
    params = sdk.Asset_GetCurrentXtStyleParams(this.timeline.id, this.asset.uid);
    HiLog.i(TAG, 'getCurrentXtStyleParams value = %{public}s', params);
    return params;
  }

  public setShowWatermarkValue(value: boolean) {
    HiLog.i(TAG, 'setShowWatermarkValue value = %{public}s', value);
    sdk.Asset_SetShowWatermarkValue(this.timeline.id, this.asset.uid, value);
  }

  public refreshCompareEffectList() {
    HiLog.i(TAG, 'refreshCompareEffectList ets');
    sdk.Asset_RefreshCompareEffectList(this.timeline.id, this.asset.uid);
  }

  public switchTabWidthWatermarkAnim(type: number, cost: number = 250) {
    sdk.Asset_SwitchTabWidthWatermarkAnim(this.timeline.id, this.asset.uid, type, cost);
  }

  public refreshWatermarkCache() {
    sdk.Asset_RefreshWatermarkCache(this.timeline.id, this.asset.uid);
  }

  public aiMasterGetIsDoRefineMasterValue(): boolean {
    let res: boolean = sdk.AIEditorContext_GetIsDoRefineMasterValue();
    HiLog.i(TAG, 'isDoRefineValue = %{public}s', res);
    return res;
  }

  public isSupportEffect(name: string): boolean {
    let res: boolean = sdk.Asset_IsSupportEffect(name);
    HiLog.i(TAG, 'isSupportEffect ' + name + ': ' + res);
    return res;
  }

  public async selectEffects(params: ImageEffectChangeParams, callback: (succ: boolean) => void): Promise<void> {
    let effectDetails: EffectDetail[] | undefined = params.effectDetails;
    let context: Context | undefined = params.context;
    let asset: photoAccessHelper.PhotoAsset | undefined = params.asset;
    if (effectDetails === undefined || context === undefined || asset === undefined) {
      callback(false);
      return;
    }
    HiLog.i(TAG, `selectEffects params = ${JSON.stringify(params)}`);
    Trace.begin('StaticEdit_SelectEffects_OpenAsset');
    this.openAsset(asset, MediaType.IMAGE, undefined, () => {
    }, () => {
      HiLog.i(TAG, `cancel face beauty open photo success`);
      Trace.end('StaticEdit_SelectEffects_OpenAsset');
      sdk.EditorContext_checkEditData(this.editData);
      this.isExportFromBrowser = true;
      Trace.begin('StaticEdit_SelectEffects_Prepare');
      this.afterLoad(() => {
        sdk.EditorContext_processExifInfo(this.timeline.id, this.asset.uid);
        sdk.EditorContext_waitTaskFinish(this.timeline.id, () => {
          Trace.end('StaticEdit_SelectEffects_Prepare');
        });
      }, () => {
      });
    });
  }

  public GetWideApertureInitInfos(cb: (x: number, y: number, fNum: number) => void): void {
    sdk.EditorContext_GetInitWideApertureInfos(this.timeline.id, this.asset.uid, cb);
  }
}

@Observed
export class RefreshThumbnail {
  public ifRefreshThumbnail: boolean = false;
}

export {
  Asset,
  TabName,
  AdjustAttr,
  AdjustValueItem,
  CropAttr,
  MosaicAttr
}