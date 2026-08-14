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
import {
  AdjustAttr,
  App,
  Asset,
  BaseEditor,
  CropAttr,
  DeviceUtil,
  EditorParams,
  EditorStatus,
  MosaicAttr,
  SCREEN_ORIENTATION_PORTRAIT,
  ScreenManager,
  TabName,
  TabType,
  VideoAdjustTool,
  VideoCropTool,
  VideoTextTool,
  AccessibilityManager
} from '@oh-image-editor/editor-common';
import { HiLog } from '@oh-image-editor/editor-common/src/main/ets/common/util/HiLog';
import { MenuAttr } from '@oh-image-editor/editor-common/src/main/ets/service/model/menu/MenuAttr';
import {
  AI_TEXT_CONTAINER_PORTRAIT_HEIGHT,
  AIErrorCode,
  BOTTOM_AVOID_HEIGHT,
  BOTTOM_HEIGHT,
  BOTTOM_HEIGHT_SPLIT,
  BOTTOM_NAVIGATION_HEIGHT,
  CONTAINER_WIDTH,
  DEVICE_FOLD_STATUS,
  DIALOG_ICON_KEY,
  DIALOG_NAME_KEY,
  EACH_BUTTON_ANIME_DELAY,
  FONT_SIZE_SCALE_KEY,
  FONT_SIZE_SCALE_S,
  LANDSCAPE_LENGTH_RATIO,
  LANDSCAPE_TABS_SPACE,
  LANDSCAPE_TOP_MARGIN,
  NETWORK_TOAST_PORTRAIT_BOTTOM,
  PORTRAIT_MARGIN,
  PORTRAIT_TABS_SPACE,
  SCROLL_SHADOW_WIDTH,
  TAB_SIZE,
  TABS_CONTENT_HEIGHT,
  TABS_DEFINE_ANIME_DURATION,
  THIRD_TOOL_BAR_HEIGHT,
  TOOL_CONTAINER_HEIGHT,
  TOP_OFFSET_PHONE,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY,
  WINDOW_MODE_DECOR_BAR,
  WINDOW_STATUS_KEY,
  PromptState,
} from '@oh-image-editor/editor-common/src/main/ets/common/const';
import { ScreenClass } from '@oh-image-editor/editor-common/src/main/ets/service/App';
import { AiTabType } from '@oh-image-editor/editor-common/src/main/ets/feature/basic/model/menu/data/TabType';
import { AiTabName, Algorithms, EditorType } from '@oh-image-editor/editor-common/src/main/ets/service/model/Enum';
import { Configuration, KeyboardAvoidMode, LengthMetrics, LengthUnit, promptAction, window } from '@kit.ArkUI';
import { AccountRepository } from '@ohos/privacy/src/main/ets/about/consent/AccountRepository';
import { AlertDialog } from '@ohos.arkui.advanced.Dialog';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { CustomDialogView } from '@ohos/common/src/main/ets/default/view/dialog/CustomDialogView';
import { BusinessError, commonEventManager, systemParameter } from '@kit.BasicServicesKit';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { UiUtil } from '@oh-image-editor/editor-common/src/main/ets/common/util/UiUtil';
import { ToolbarDialog } from '@oh-image-editor/editor-common/src/main/ets/service/model/dialog/ToolbarDialog';
import { PermissionPopup } from '@ohos/privacy/src/main/ets/about/consent/PermissionPopup';
import {
  TextAreaManager
} from '@oh-image-editor/editor-common/src/main/ets/service/model/tabTextEdit/viewModel/TabTextAreaManager';
import {
  UndoRedoManager
} from '@oh-image-editor/editor-common/src/main/ets/service/model/tabTextEdit/viewModel/TabUndoRedoManager';
import { TextInterval } from '@oh-image-editor/editor-common/src/main/ets/service/model/tabTextEdit/util/TextConst';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { VideoMosaicTool } from '../mosaic/VideoMosaicTool';
import { ComposeIndex, tabNameMap } from '@oh-image-editor/editor-common/src/main/ets/common/util/ComposeUtil';
import { text } from '@kit.ArkGraphics2D';
import { ConflictContent, ConflictFunc, getMutuallyExclusiveDesc } from './Consts';
import ResourceCleaner from '@oh-image-editor/editor-common/src/main/ets/common/util/ResourceCleaner';
import { ScaleAnimator } from '@oh-image-editor/editor-common/src/main/ets/common/animators/ScaleAnimator';
import { TabsManager } from '@oh-image-editor/editor-common/src/main/ets/service/manager/TabsManager'

@Extend(Text)
function tabSize(selected: boolean, disabled: boolean, numOfRotations: number) {
  .fontColor(disabled ? 'rgba(255,255,255,0.4)' : (selected ? '#5291FF' : ' #FFFFFF'))
  .lineHeight(14)
  .maxFontSize(10)
  .minFontSize(9)
  .margin({ top: 4 })
  .maxFontScale(1)
  .maxLines(1)
  .textOverflow({ overflow: selected && numOfRotations < 3 ? TextOverflow.MARQUEE : TextOverflow.Ellipsis })
}

@Extend(SymbolGlyph)
function tabSymbolGlyph(selected: boolean, disabled: boolean) {
  .fontSize('24vp')
  .fontColor([disabled ? 'rgba(255,255,255,0.4)' : (selected ? '#5291FF' : ' #FFFFFF')])
  .opacity(1)
}

@Extend(Image)
function tabSymbolImageStyle(selected: boolean) {
  .fillColor(selected ? '#5291FF' : '#FFFFFF')
  .borderRadius('50%')
  .alignSelf(ItemAlign.Center)
  .width('24vp')
  .height('24vp')
  .draggable(false)
}

@Extend(Image)
function symbolImageStyle(selected: boolean) {
  .fillColor(selected ? '#5291FF' : '#FFFFFF')
  .alignSelf(ItemAlign.Center)
  .width(24)
  .height(24)
}

@Extend(Divider)
function tabDivider(isScreenPortrait: boolean) {
  .vertical(isScreenPortrait)
  .height(isScreenPortrait ? 40 : 1)
  .width(isScreenPortrait ? 1 : 40)
  .color(Color.White)
  .opacity(0.6)
}

//instrument ignore next
@Extend(Column)
function longPressGesture(icon: Resource, name: Resource, toolbarDialog: CustomDialogController | undefined,
  fontSizeScale: number) {
  .gesture(
    LongPressGesture({ fingers: 1, duration: 500 })
      .onAction(() => {
        if (fontSizeScale < FONT_SIZE_SCALE_S) {
          return;
        }
        AppStorage.setOrCreate(DIALOG_ICON_KEY, icon);
        AppStorage.setOrCreate(DIALOG_NAME_KEY, name);
        toolbarDialog?.open();
      })
      .onActionEnd(() => {
        if (fontSizeScale < FONT_SIZE_SCALE_S) {
          return;
        }
        toolbarDialog?.close();
      })
      .onActionCancel(() => {
        if (fontSizeScale < FONT_SIZE_SCALE_S) {
          return;
        }
        toolbarDialog?.close();
      })
  )
  .accessibilityDescription(
    fontSizeScale < FONT_SIZE_SCALE_S
      ? UiUtil.getResourceString($r('app.string.accessibility_event_click_action'))
      : ''
  )
}

interface AuthMessage {
  code: number,
  data: string,
  subCode: number,
};

let TAG: string = 'BottomToolbar';
const APP_STORAGE_KEY_OF_NETWORK_AVAILABLE: string = 'networkAvailable';
// 等待登录界面显示时间
const WAIT_LOGIN_UI_SHOW_TIME = 800;
const AI_RETOUCH_PRIVACY_PROTOCOL = 10734;
// 系统资源 sys.symbol 资源type值
const RESOURCE_TYPE_SYS: number = 40000;
const USER_LOGIN_CANCEL_CODE = 1001502012; // 取消登录账号
const USER_LOGIN_NETWORK_ERROR_CODE = 1001502005; // 网络错误
const KEYBOARD_AVOID_MODE_NONE: number = 4;
const HEIC: string = '.heic';
const HEIF: string = '.heif';
const JPG: string = '.jpg';
const TAB_AI: string = 'ai';
const TAB_MOSAIC: string = 'mosaic';
const TAB_TEXT: string = 'text';
const TAB_MARKUP: string = 'markup';
const TAB_TOOL_WIDTH: number = 52;
const TAB_TOOL_HEIGHT: number = 48;

@Component
export struct BottomToolbar {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  params: EditorParams | undefined = undefined // 工程初始化参数
  @Link status: EditorStatus;
  @Link clickBackState: boolean;
  @Prop @Watch('onFirstFrameStateChange') firstFrameLoaded: boolean;
  @State @Watch('getIsSupportTabScroll') private tabsManager: TabsManager = TabsManager.getInstance();
  @State isTabDefineFirstLoaded: boolean = true;
  // 直接进入AI修图是否第一次加载完成
  @Link isStylusOrAiEntryOnceFinished: boolean;
  @State cropAttr: CropAttr = App.getInstance().myEditor().asset.crops();
  @State adjustAttr: AdjustAttr = App.getInstance().myEditor().asset.adjusts();
  @State mosaicAttr: MosaicAttr = App.getInstance().myEditor().asset.mosaic();
  @State isSplitMode: boolean = false;
  @State @Watch('refreshTabsDefineReact') screenClass: ScreenClass = App.getInstance().screenClass;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('refreshTabsDefineReact') isScreenPortrait: boolean =
    ScreenManager.getInstance().isScreenPortrait();
  @StorageProp(DEVICE_FOLD_STATUS) @Watch('refreshTabsDefineReact') isFold: boolean =
    ScreenManager.getInstance().isDeviceFold();
  @StorageProp(WINDOW_STATUS_KEY) @Watch('refreshTabsDefineReact') isSmallWindowMode: boolean =
    ScreenManager.getInstance().getSmallWindowMode();
  @StorageLink(CONTAINER_WIDTH) containerWidth: number = ScreenManager.getInstance().width;
  @StorageProp(WIN_HEIGHT_KEY) @Watch('refreshHeight') winHeight: number = ScreenManager.getInstance().height;
  @StorageProp(WIN_WIDTH_KEY) @Watch('refreshHeight') winWidth: number = ScreenManager.getInstance().width;
  @StorageProp(FONT_SIZE_SCALE_KEY) fontSizeScale: number = 0;
  @State textPaddingLeftAndRight: number =
    ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight();
  private scrollerMenu: Scroller = new Scroller();
  private aiScrollerMenu: Scroller = new Scroller();
  @State tabsDefineWidth: number = this.winWidth - TAB_SIZE - LANDSCAPE_TABS_SPACE - PORTRAIT_TABS_SPACE;
  @State tabsDefineHeight: number = (this.winHeight - BOTTOM_NAVIGATION_HEIGHT - TOP_OFFSET_PHONE) * 0.6
    - TAB_SIZE - LANDSCAPE_TABS_SPACE;
  @State scrollHeight: number = (this.winHeight - TOP_OFFSET_PHONE - this.screenClass.avoidTop -
    BOTTOM_NAVIGATION_HEIGHT) - TAB_SIZE - LANDSCAPE_TABS_SPACE;
  @State scrollWidth: number = this.winWidth - this.screenClass.avoidLeft - this.screenClass.avoidRight
    - TAB_SIZE - LANDSCAPE_TABS_SPACE;
  @State isLandscapeLayout: boolean = ScreenManager.getInstance().isLandscapeLayout();
  @State aiRetouchTriggerValue: number = -1;
  @State aiTabsDefineSpace: number = PORTRAIT_TABS_SPACE;
  @State marginLeftAndRight: number = PORTRAIT_MARGIN;
  @State @Watch('onAuthProcessClose') private isHsp: boolean = false;
  @State tabsDefineSpace: number = ((this.winHeight - this.screenClass.avoidTop - BOTTOM_NAVIGATION_HEIGHT -
    TOP_OFFSET_PHONE - (ScreenManager.getInstance().isPhoneLR() ? 8 : 0)) *
    (ScreenManager.getInstance().isFoldAndPadLR() ? 0.6 : 1) - TAB_SIZE) - TAB_SIZE;
  @State isFoldAndPadLR: boolean = ScreenManager.getInstance().isFoldAndPadLR();
  @Provide({ allowOverride: 'headTitle' }) headTitle: Resource | undefined = undefined;
  @Provide({ allowOverride: 'subTitle' }) subTitle: Resource | undefined = undefined;
  @Provide({ allowOverride: 'confirmText' }) confirmText: Resource | undefined = undefined;
  @State broadCast: BroadCast = new BroadCast();

  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private networkConnectionStatus: boolean = false;
  private aiRetouchTime: number = -1;
  private entryFinishedWhenLoginTime: number = -1;
  private statusEventId: string = Constants.STATUS_BAR_EVENT_ID;
  private subscriber: commonEventManager.CommonEventSubscriber | null = null;
  // 进入AI修图界面初始化完成回调
  private enterAiStatusOkCallback: Function | undefined;
  private userInfo: PermissionPopup.UserInfo = {
    userId: '',
    accessToken: '',
  };
  private isBigHsp: boolean = false;
  @State isShowShadowStart: boolean = false;
  @State isShowShadowEnd: boolean = true;
  @State scrollDistance: number = 0;
  @State shadowRate: number = 0;
  @State isAiShowShadowStart: boolean = false;
  @State isAiShowShadowEnd: boolean = true;
  @State aiScrollDistance: number = 0;
  @State aiShadowRate: number = 0;
  private refreshHeightTimer: number = -1;
  private toolbarDialog?: CustomDialogController;
  private aiMoveRevertSureDialogOpenFlag: boolean = false;
  private aiMoveRevertSureDialog: CustomDialogController | undefined = undefined;
  @StorageLink('isCustomFilterCardShow') isCustomFilterCardShow: boolean = false; // 是否展示选色卡
  public onClickTabIndex: number = -1; // 当前点击的tab下标，AI修图：-1
  public unSupportIndexArr = [-1, TabName.TabTextEdit, TabName.TabStylus, TabName.TabMosaic];
  @Link textCanUndo: boolean;
  @Link textCanRedo: boolean;
  @Link textCanClickStyle: boolean;
  @Link isShowInPopup: boolean;
  @Link isShowBorder: boolean;
  @Link currentFontColor: Color | string | Resource;
  @Link currentFontSize: number;
  @Link isFontSizeChange: boolean;
  @Link textInputAreaHide: boolean;
  @Link isFromMovingPhoto: boolean;
  @Link onBackProgress: boolean;
  @State isAiTabHover: boolean = false;
  @State tabHoverStates: boolean[] = Array(0).fill(false);
  private textAreaManager: TextAreaManager = TextAreaManager.getInstance();
  private undoRedoManager: UndoRedoManager = UndoRedoManager.getInstance();
  private highPixelDelay: number = 500;
  private commonPixelDelay: number = 100;
  // 是否需要直接显示个性风格调色盘, 由演示APP拉起图库跳转编辑的场景会被置成true, 正常从大图进编辑时值为false
  @StorageLink('is_entry_XTStyle') showXTStyleDirectly: boolean = false;
  private changeTabToXTStyleTimer: number = -1;
  @State isSupportTabScroll: boolean = true;
  private wideApertureStatus: boolean = UiUtil.checkAlgorithms(Algorithms.WideAperture);
  private xTStyleStatus: boolean = UiUtil.checkAlgorithms(Algorithms.XTStyle);
  // 避免循环更新，tabsContainerWidth不使用状态声明，仅在布局变更时调用，更新isSupportTabScroll
  private tabsContainerWidth: number = 0;
  private scrollTimer: number = -1;
  // tab文本轮播次数
  @State numOfRotations: number = 0;

  // 判断当前点击的Tab是否在unSupportIndexArr中
  private getUnSupportTabIndex() {
    return this.unSupportIndexArr.findIndex(item => item === this.onClickTabIndex);
  }

  // 获取各功能冲突时弹窗的标题和内容
  private getConflictDesc(): ConflictContent {
    let title = $r('app.string.some_functions_unsupport_ai');
    let type = ConflictFunc.AI;
    switch (this.onClickTabIndex) {
      case TabName.TabMosaic:
        title = $r('app.string.some_functions_unsupport_mosaic');
        type = ConflictFunc.MOSAIC;
        break;
      case TabName.TabTextEdit:
        title = $r('app.string.some_functions_unsupport_word');
        type = ConflictFunc.TEXT;
        break;
      case TabName.TabStylus:
        title = $r('app.string.some_functions_unsupport_markup');
        type = ConflictFunc.STYLUS;
        break;
      default:
        break;
    }
    // 获取各功能冲突时弹窗的内容参数
    const params: Resource[] = [];
    // 添加光圈参数
    if (this.wideApertureStatus && this.editor.isSupportApertureEdit) {
      params.push($r('app.string.some_functions_unsupport_param_aperture'));
      HiLog.i(TAG, 'unSupportDialog Context isSupportApertureEdit');
    }
    if (this.editor.isSupportXTStyleEdit) { // 添加个性色卡参数
      params.push($r('app.string.some_functions_unsupport_param_style'));
      HiLog.i(TAG, 'unSupportDialog Context isSupportXTStyleEdit');
    }
    const key = ['static', type, params.length].join('_');
    return {
      title,
      content: getMutuallyExclusiveDesc(key, ...params)
    }
  }

  //当前编辑模式组件动效
  private getListReleaseAnimation(): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect
        .IDENTITY,
      TransitionEffect
        .OPACITY
        .animation({ duration: TABS_DEFINE_ANIME_DURATION, curve: Curve.Sharp })
    )
  }

  //目标编辑模式组件-单个图标动效
  private getEachShowAnimation(
    scaleDuration: number,
    opacityDuration: number,
    delay: number, index: number
  ): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect
        .scale({ x: 0, y: 0 })
        .animation({
          duration: scaleDuration,
          delay: delay + index * EACH_BUTTON_ANIME_DELAY,
          curve: Curve.Friction,
        })
        .combine(
          TransitionEffect
            .OPACITY
            .animation({
              duration: opacityDuration,
              delay: delay + index * EACH_BUTTON_ANIME_DELAY,
            })),
      TransitionEffect
        .IDENTITY
    )
  }

  private async getAccountInfo(forceRefresh: boolean): Promise<void> {
    HiLog.i(TAG, 'getAccountInfo called');
    AccountRepository.getInstance().setAccountContext(getContext(this));
    try {
      // await AccountRepository.getInstance().signIn(true);
      HiLog.i(TAG, 'getAccountInfo call signIn finish');
      this.userInfo.accessToken = await AccountRepository.getInstance().getAccessToken(forceRefresh);
      HiLog.i(TAG, 'getAccountInfo call getAccessToken finish');
      this.userInfo.userId = AccountRepository.getInstance().getAccount().userId;
    } catch (err) {
      HiLog.e(TAG, `getAccountInfo failed: code: ${err?.code}, data: ${err?.data}, subCode: ${err?.subCode}`);
    }
  }

  refreshHeight() {
    HiLog.i(TAG, `refreshHeight enter is ${this.winHeight}`);
    if (this.refreshHeightTimer !== -1) {
      clearTimeout(this.refreshHeightTimer);
    }
    this.refreshHeightTimer = setTimeout((): void => {
      this.isSplitMode = ScreenManager.getInstance().isSplitMode();
      this.textPaddingLeftAndRight = ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight();
      this.isLandscapeLayout = ScreenManager.getInstance().isLandscapeLayout();
      this.refreshTabsDefineReact();
      this.tabsDefineSpace = ((this.winHeight - this.screenClass.avoidTop - BOTTOM_NAVIGATION_HEIGHT -
        TOP_OFFSET_PHONE - (ScreenManager.getInstance().isPhoneLR() ? 8 : 0)) *
        (ScreenManager.getInstance().isFoldAndPadLR() ? 0.6 : 1) - TAB_SIZE) - TAB_SIZE;
      this.refreshHeightTimer = -1;
    }, 50);
    this.scrollDistance = 0;
    this.aiScrollDistance = 0;
    this.handleScroll();
    this.handleAiScroll();
    this.getIsSupportTabScroll();
  }

  // ai修图时，状态判断
  aiImageProcessStatusCheck(): boolean {
    // 非ai修图页面
    if (App.getInstance().getType() !== EditorType.AI) {
      return true;
    }
    return true;
  }

  initStatusBarSubscriber(): void {
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [this.statusEventId],
    };

    // 创建状态栏订阅者回调
    commonEventManager.createSubscriber(subscribeInfo,
      (err: BusinessError, data: commonEventManager.CommonEventSubscriber) => {
        // instrument ignore if
        if (err) {
          HiLog.e(TAG,
            `Failed to create subscriber. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        this.subscriber = data;
        if (this.subscriber) {
          commonEventManager.subscribe(this.subscriber,
            (err: BusinessError, data: commonEventManager.CommonEventData) => {
              // instrument ignore if
              if (err) {
                HiLog.e(TAG,
                  `Failed to subscribe common event. Code is ${err.code}, message is ${err.message}`);
                return;
              }
              let res: string = data.data || '';
              if (res === 'close') {
                UiUtil.isPrivacyPage = false;
                UiUtil.isSystemStatus();
              } else if (res === 'open') {
                UiUtil.isPrivacyPage = true;
                UiUtil.showStatusBar(false)
                UiUtil.resetStatusAndNavigation();
              }
            })
        }
      })
  }

  refreshApertureTab(): void {
    HiLog.i(TAG, 'refreshApertureTab');
    HiLog.i(TAG,
      `wideApertureStatus: ${this.wideApertureStatus}, isPhotosEditData: ${this.editor.isPhotosEditData},
            isSupportApertureEdit: ${this.editor.isSupportApertureEdit}, isHWSharedPhoto: ${this.editor.isHWSharedPhoto}`);
    let tabIndex = this.editor.tabIndex === TabName.TabAperture ? TabName.TabCrop : this.editor.tabIndex;
    if (this.editor.tabIndex === TabName.TabMosaic) {
      return;
    }
    let enterMenu: MenuAttr = this.editor.asset.getMenuAttr(tabIndex);
    enterMenu.enterMenu();
    enterMenu.changeMenuAnimate(tabIndex);

  }

  aboutToAppear(): void {
    HiLog.i(TAG, 'bottomToolBar aboutToAppear');
    // 关闭APP的文字渲染高对比度配置
    text.setTextHighContrast(text.TextHighContrast.TEXT_APP_DISABLE_HIGH_CONTRAST)
    this.appBroadCast.on('hideXTStyleAperture', this.hideXTStyleAperture);
    this.appBroadCast.on('enterFromMovingPhoto', this.enterFromMovingPhoto);
    this.appBroadCast.on('backMovingPhotoAnimation', this.backMovingPhotoAnimation);
    this.appBroadCast.on('queryExifFinished', this.queryExifFinished);
    if (!this.showXTStyleDirectly) {
    } else {
      this.appBroadCast.on('changeTabToXTStyle', () => {
        clearTimeout(this.changeTabToXTStyleTimer);
        this.changeTabToXTStyleTimer = setTimeout(() => {
          this.changeCurrentTab(TabName.TabXTStyle);
          HiLog.i(TAG, `changeTabTo XTStyle`);
          this.appBroadCast.emit('openCustomFilterCard');
          this.appBroadCast.off('changeTabToXTStyle');
        }, 800);
      });
    }

    this.isSplitMode = ScreenManager.getInstance().isSplitMode();
    this.refreshTabsDefineReact();
    this.refreshSealTab();
    this.refreshXTStyleTab();
    this.refreshApertureTab();
    App.getInstance()
      .myEditor()
      .asset
    this.getIsSupportTabScroll();
  }

  onCloseSportTab = (): void => {
    const needToCrop = this.editor.tabIndex === TabName.TabSport;
    if (needToCrop) {
      let enterMenu: MenuAttr = this.editor.asset.getMenuAttr(TabName.TabCrop);
      enterMenu.enterMenu();
      enterMenu.changeMenuAnimate(TabName.TabCrop);
    }
  }

  refreshSealTab(): void {
    let showSealTab = this.editor.isSupportSeal && this.editor.hasSealResource;
    HiLog.i(TAG,
      `isSupportSeal:${this.editor.isSupportSeal} hasSealResource:${this.editor.hasSealResource}`);
  }

  private addWindowWaterMark(): void {
    let isWindowWaterMarkSwitchOpened: boolean = systemParameter.getSync('const.product.hide', 'false') === 'true';
    HiLog.i(TAG, `isWindowWaterMarkSwitchOpened: ${isWindowWaterMarkSwitchOpened}`);
    if (isWindowWaterMarkSwitchOpened) {
      let isPicker: boolean = AppStorage?.get('isPickerPage') ?? false;
      let mainWindow: window.Window | undefined =
        isPicker ? LocalStorage.getShared()?.get<window.Window>('photosUiExtensionStage') :
          LocalStorage.getShared()?.get<window.Window>('mainWindow');
      if (mainWindow) {
        mainWindow.setWaterMarkFlag(true, (err: BusinessError<void>): void => {
          if (err.code) {
            HiLog.e(TAG, `Failed to set window water mark. Cause: ${err}`);
            return;
          }
          HiLog.i(TAG, 'Succeeded in setting window water mark.');
        });
      }
    }
  }

  refreshXTStyleTab(stylusModified: boolean = false): void {
    let fileNameSuffix: string = '.' + this.editor.mediaUri.split('.')
    [this.editor.mediaUri?.split('.').length - 1].toLowerCase();
    let xTStyleType: number = -1;
    try {
    } catch (err) {
      HiLog.e(TAG, `refreshXTStyleTab get enterValue[0] Error. err: ${err.code}, ${err.message}`);
    }
    HiLog.i(TAG, `refreshXTStyleTab fileNameSuffix:${fileNameSuffix} stylusModified:${stylusModified}
    xTStyleType:${xTStyleType}`);
    let isLiveToPhoto: boolean = false;
    isLiveToPhoto = this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_TEXTEDIT ||
      this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_MOSAIC ||
      this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_AI ||
      this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_SEAL;
    let isAllowEditXtStyle = this.editor.isAllowEditXtStyle();
    this.editor.isSupportXTStyleEdit =
      this.xTStyleStatus && !isLiveToPhoto && isAllowEditXtStyle &&
        (fileNameSuffix === HEIC || fileNameSuffix === HEIF || fileNameSuffix === JPG);
    if (this.editor.isSupportXTStyleEdit) {
      this.addWindowWaterMark();
    }
    if (!this.editor.isSupportXTStyleEdit) {
    }
    HiLog.i(TAG, `refreshXTStyleTab isSupportXTStyleEdit:${this.editor.isSupportXTStyleEdit},
      xTStyleStatus:${this.xTStyleStatus},
      isLiveToPhoto:${isLiveToPhoto}, fileNameSuffix:${fileNameSuffix},
      isAllowEditXtStyle:${isAllowEditXtStyle}`
    );
  }

  buildToolbarDialog(isImage: boolean): CustomDialogController {
    return new CustomDialogController({
      builder: ToolbarDialog({ isImage: isImage }),
      customStyle: true,
      autoCancel: false,
      alignment: DialogAlignment.Center,
    })
  }

  aboutToDisappear(): void {
    HiLog.i(TAG, 'BottomToolBar aboutToDisappear');
    this.aiMoveRevertSureDialog?.close();
    ResourceCleaner.releaseAll();
    text.setTextHighContrast(text.TextHighContrast.TEXT_FOLLOW_SYSTEM_HIGH_CONTRAST)
    if (this.changeTabToXTStyleTimer) {
      clearTimeout(this.changeTabToXTStyleTimer);
    }
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
    this.appBroadCast.off('hideXTStyleAperture', this.hideXTStyleAperture);
    this.appBroadCast.off('enterFromMovingPhoto', this.enterFromMovingPhoto);
    this.appBroadCast.off('backMovingPhotoAnimation', this.backMovingPhotoAnimation);
    this.appBroadCast.off('changeTabToXTStyle');
    this.appBroadCast.off('queryExifFinished', this.queryExifFinished);
    if (this.entryFinishedWhenLoginTime !== -1) {
      clearTimeout(this.entryFinishedWhenLoginTime);
    }
    if (this.subscriber) {
      commonEventManager.unsubscribe(this.subscriber, (err: BusinessError) => {
        if (err) {
          HiLog.e(TAG, `UnsubscribeCallBack err = ${JSON.stringify(err)}`);
        } else {
          HiLog.i(TAG, 'Unsubscribe success');
          this.subscriber = null;
        }
      })
    }
    // 获取AI编创隐私协议最新签署状态
    if (this.userInfo?.userId) {
      PermissionPopup.queryAgreementRecordCloud(getContext(this), this.userInfo, AI_RETOUCH_PRIVACY_PROTOCOL);
    }
  }

  onFirstFrameStateChange(): void {
    this.appBroadCast.emit('onFirstFrameStateChange');
    // 进入方式为非默认时，第一帧加载完成后，直接跳入界面
    if (this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_AI) {
      HiLog.i(TAG, `direct enter ai editor, isHsp: ${this.isInHspOrPicker()}`);
      this.aiRetouchTriggerValue += 1;
      // 区分相机或Picker的HSP方式进入和图库进入，处理方式不同
      if (this.isInHspOrPicker()) {
        this.isHsp = true;
        this.isBigHsp = true;
      } else {
        this.isBigHsp = true;
      }
      this.isTabDefineFirstLoaded = false;
    } else if (this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_TEXTEDIT ||
      this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_MOSAIC ||
      this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_SEAL) {
      HiLog.i(TAG, 'from moving photo text or mosaic');
      this.isStylusOrAiEntryOnceFinished = !this.isStylusOrAiEntryOnceFinished;
    }
    // 动态照片点击个性风格按钮
    if (this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_XT_STYLE) {
      HiLog.i(TAG, `direct enter ai editor, isHsp: ${this.isInHspOrPicker()}`);
      this.setXtStyleEnterFinished();
    }
  }

  enterFromMovingPhoto = () => {
    let leaveIndex: number = 0;
    let enterIndex: number = 0;
    if (this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_TEXTEDIT) {
      enterIndex = TabName.TabTextEdit;
      // 键盘升起时，设置不影响 原有布局 避让模式
      this.getUIContext()?.setKeyboardAvoidMode(KEYBOARD_AVOID_MODE_NONE);
    } else if (this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_MOSAIC) {
      enterIndex = TabName.TabMosaic;
    } else if (this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_XT_STYLE) {
      enterIndex = TabName.TabXTStyle;
    } else if (this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_SEAL) {
      enterIndex = TabName.TabSeal;
    } else {
      return;
    }
    // 模拟跳转不触发onclick，需设置是否展示水印
    this.editor.setShowWatermarkValue(this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_SEAL ? true : false);
    this.isFromMovingPhoto = true;
    HiLog.i(TAG, `enter tab: ${enterIndex}`);
    let leaveMenu: MenuAttr = this.editor.asset.getMenuAttr(leaveIndex);
    let enterMenu: MenuAttr = this.editor.asset.getMenuAttr(enterIndex);
    setTimeout(() => {
      this.switchMenu(enterMenu, leaveMenu, enterIndex);
      this.scrollToTargetTabIndex(enterIndex);
    }, 100);
  }
  backMovingPhotoAnimation = () => {
    // 返回时，恢复默认键盘避让模式
    this.getUIContext()?.setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
    let leaveMenu: MenuAttr = this.editor.asset.getMenuAttr(this.editor.tabIndex);
    let enterMenu: MenuAttr = this.editor.asset.getMenuAttr(0);
    // 隐藏静态图基础编辑页底部Tab栏，规避Tab栏切换到动态图的跳变
    this.onBackProgress = true;
    if (this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_XT_STYLE) {
      setTimeout(() => {
        this.switchMenu(enterMenu, leaveMenu, 0);
      }, 30); // 静图返回动图，规避预览底部原图闪烁
      return;
    }
    // 走关闭逻辑，马赛克仅做动效，不合成
    this.switchMenu(enterMenu, leaveMenu, 0, true);
  }

  queryExifFinished = () => {
    HiLog.i(TAG, 'query exif finished, refresh tabs');
    this.refreshApertureTab();
    this.refreshXTStyleTab();
  }

  private delayEntryFinishedWhenLogin(): void {
    HiLog.i(TAG, 'direct enter ai editor, setTimeout notify enter ai finished.');
    if (this.entryFinishedWhenLoginTime !== -1) {
      clearTimeout(this.entryFinishedWhenLoginTime);
    }

    // 延迟到登录界面显示后回调
    this.entryFinishedWhenLoginTime = setTimeout((): void => {
      HiLog.i(TAG, `entryFinishedWhenLoginTime start.`);
      this.setAiEnterFinished();
      this.entryFinishedWhenLoginTime = -1;
    }, WAIT_LOGIN_UI_SHOW_TIME);
  }

  private enterAiLoginFailCallback(): void {
    HiLog.i(TAG, 'direct enter ai editor, login canceled and back to vedio editor.');
    this.clickBackState = !this.clickBackState;
  }

  private setAiEnterFinished(): void {
    HiLog.i(TAG, `setAiEnterFinished start,${this.params?.entryType},${this.isStylusOrAiEntryOnceFinished}`);
    if (this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_AI && !this.isStylusOrAiEntryOnceFinished) {
      HiLog.i(TAG, 'direct enter ai editor load finished.');
      this.isStylusOrAiEntryOnceFinished = true;
    }
  }

  private setXtStyleEnterFinished(): void {
    HiLog.i(TAG, `setXtStyleEnterFinished start,${this.params?.entryType},${this.isStylusOrAiEntryOnceFinished}`);
    if (this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_XT_STYLE && !this.isStylusOrAiEntryOnceFinished) {
      HiLog.i(TAG, 'direct enter xt style load finished.');
      this.isStylusOrAiEntryOnceFinished = true;
    }
  }

  private isInHspOrPicker(): boolean {
    return LocalStorage.getShared()?.get<Context>('photoLibraryContext') !==
      undefined || (this.params?.isFromPicker ?? false);
  }

  onAuthProcessClose(): void {
    // HSP销毁，置为false时才处理的逻辑
    if (this.isHsp) {
      return;
    }
    HiLog.i(TAG, `onAuthProcessClose`);
    ScreenManager.getInstance().setIsQueryUserLogin(false);
    if (this.params?.entryType !== EditorParams.PARAM_ENTRY_TYPE_AI) {
      return;
    }
  }

  private getTabsContentHeight(): number | string {
    return this.isScreenPortrait ? 160 : this.isFoldAndPadLR ? '60%' : '100%';
  }

  @Builder
  TabsContent() {
    Column() {
      if (this.editor.isInitComp) {
        VideoAdjustTool().visibility(this.editor.tabIndex === TabName.TabAdjust ?
          Visibility.Visible : Visibility.None)
          .transition(this.switchTabContentTransitionEffect());
        VideoTextTool({
          textCanUndo: this.textCanUndo,
          textCanRedo: this.textCanRedo,
          isShowInPopup: this.isShowInPopup,
          textCanClickStyle: this.textCanClickStyle,
          isShowBorder: this.isShowBorder,
          currentFontColor: this.currentFontColor,
          currentFontSize: this.currentFontSize,
          isFontSizeChange: this.isFontSizeChange,
          textInputAreaHide: this.textInputAreaHide,
        })
          .visibility(this.editor.tabIndex === TabName.TabTextEdit ?
            Visibility.Visible : Visibility.None)
          .transition(this.switchTabContentTransitionEffect());
        VideoMosaicTool().visibility(this.editor.tabIndex === TabName.TabMosaic ?
          Visibility.Visible : Visibility.None)
          .transition(this.switchTabContentTransitionEffect());
      }
    }
    .visibility(this.showXTStyleDirectly ? Visibility.Hidden : Visibility.Visible)
    .padding({ top: this.isPhoneOrFoldSplitLR() ? 8 : 0 })
    .height(this.getTabsContentHeight())
    .width(this.isScreenPortrait ? '100%' : 160)
  }

  private switchTabContentTransitionEffect(): TransitionEffect {
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({
        delay: 100,
        duration: 100,
        curve: Curve.Sharp,
      }),
      TransitionEffect.opacity(0).animation({
        duration: 100,
        curve: Curve.Sharp,
      })
    );
  }

  getIsSupportTabScroll() {
    // 防抖 布局变更时调用可能有多处监听会调用此方法
    clearTimeout(this.scrollTimer);
    /**
     * 布局变更时，tabsContainerWidth还未获取到最新的值，这里做延迟处理
     * 直接监听tabsContainerWidth变更
     * isSupportTabScroll改变，可能会引起tabsContainerWidth改变，从而再次调用getIsSupportTabScroll，导致死循环
     * **/
    const len = this.tabsManager.size();
    this.scrollTimer = setTimeout(() => {
      const tabsWidth = len * TAB_SIZE + (len - 1) * (this.isScreenPortrait ? 12 : 10);
      this.isSupportTabScroll = this.tabsContainerWidth < tabsWidth;
    }, 100);
  }

  handleScroll(state?: ScrollState) {
    if (!this.scrollerMenu.currentOffset()) {
      return;
    }
    const scrollDistance = (
        this.isScreenPortrait ? this.scrollerMenu.currentOffset().xOffset : this.scrollerMenu.currentOffset().yOffset
    ) ?? 0;
    this.isShowShadowStart = scrollDistance > 0 ? true : false;
    if (!this.isShowShadowEnd && state !== undefined && state === ScrollState.Fling) {
      return;
    }
    this.isShowShadowEnd = this.scrollDistance === 0 || scrollDistance < this.scrollDistance ? true : false;
  }

  handleAiScroll(state?: ScrollState) {
    if (!this.aiScrollerMenu.currentOffset()) {
      return;
    }
    const aiScrollDistance = (
        this.isScreenPortrait ? this.aiScrollerMenu.currentOffset().xOffset
        : this.aiScrollerMenu.currentOffset().yOffset) ?? 0;
    this.isAiShowShadowStart = aiScrollDistance > 0 ? true : false;
    if (!this.isAiShowShadowEnd && state !== undefined && state === ScrollState.Fling) {
      return;
    }
    this.isAiShowShadowEnd = this.aiScrollDistance === 0 || aiScrollDistance < this.aiScrollDistance ? true : false;
  }

  calcEndPadding() {
    return ScreenManager.getInstance().width * 0.1 - 26;
  }

  caleTabsDefineSpace() {
    return ((this.winHeight - this.screenClass.avoidTop - BOTTOM_NAVIGATION_HEIGHT -
      TOP_OFFSET_PHONE - (ScreenManager.getInstance().isPhoneLR() ? 8 : 0)) *
      (ScreenManager.getInstance().isFoldAndPadLR() ? 0.6 : 1) - TAB_SIZE) - TAB_SIZE;
  }

  @Builder
  TabsDefine() {
    Column() {
      Scroll(this.scrollerMenu) {
        Flex({
          direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
          justifyContent: this.isSupportTabScroll ? FlexAlign.Start : FlexAlign.SpaceBetween,
          alignItems: ItemAlign.Center,
          space: { main: this.isScreenPortrait ? LengthMetrics.vp(12) : LengthMetrics.vp(10) },
        }) {
          if (!this.editor.immersiveMode) {
            ForEach(this.tabsManager.tabs, (item: TabType, index: number) => {
              this.TabName(item.name, item.index, index, item.icon, item.isSymbolGlyph);
            })
          }
        }
        .width(this.isSupportTabScroll ? 'auto' : '100%')
        .height(this.isSupportTabScroll ? 'auto' : '100%')
        .padding({
          left: UiUtil.isMirrorMode() ?
            (this.isScreenPortrait && this.isSupportTabScroll ? this.calcEndPadding() : 0) :
            (this.isScreenPortrait ? 12 : 0),
          right: !UiUtil.isMirrorMode() ?
            (this.isScreenPortrait && this.isSupportTabScroll ? this.calcEndPadding() : 0) :
            (this.isScreenPortrait ? 12 : 0),
          // top: !this.isScreenPortrait ? (this.isSupportTabScroll ? 10 : this.caleTabsDefineSpace()) : 0
          top: !this.isScreenPortrait ? (this.isSupportTabScroll ? 10 : 10) : 0
        })
        .id('petalClip_bottomToolBar_TabsBar')
      }
      .scrollable(this.isScreenPortrait ? ScrollDirection.Horizontal : ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .scrollBar(BarState.Off)
      .height('100%')
      .width('100%')
      .transition(this.getListReleaseAnimation())
      .align(Alignment.Start)
      .onDidScroll((x: number, y: number, state: ScrollState): void => {
        this.handleScroll(state);
      })
      .onScrollEdge((side: Edge) => {
        if (side === Edge.Start || side === Edge.Top) {
          this.isShowShadowStart = false;
        } else {
          this.isShowShadowStart = true;
        }
        if (side === 3 || side === Edge.Bottom) { // 3: Edge.End
          this.scrollDistance = (this.isScreenPortrait ? this.scrollerMenu.currentOffset().xOffset :
            this.scrollerMenu.currentOffset().yOffset) ?? 0;
          this.isShowShadowEnd = false;
        } else {
          this.isShowShadowEnd = true;
        }
      })
      // .blendMode(BlendMode.SRC_IN, BlendApplyType.OFFSCREEN)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.shadowRate = SCROLL_SHADOW_WIDTH / Number(this.isScreenPortrait ? newValue.width : newValue.height);
        this.tabsContainerWidth = (this.isScreenPortrait ? newValue.width : newValue.height) as number;
      })
      .onAppear(() => {
        this.getIsSupportTabScroll();
      })
    }
    .height(this.isScreenPortrait ? TAB_TOOL_HEIGHT : ('100%'))
    .width(this.isScreenPortrait ? ('100%') : TAB_TOOL_HEIGHT)
    .linearGradient({
      angle: this.isScreenPortrait ? 90 : 180,
      colors: [
        ['rgba(0, 0, 0, 0)', 0],
        ['rgba(0, 0, 0, 0)', this.isSupportTabScroll && this.isShowShadowStart ? this.shadowRate : 0],
        ['rgba(0, 0, 0, 0)', this.isSupportTabScroll && this.isShowShadowEnd ? 1 - this.shadowRate : 1],
        ['rgba(0, 0, 0, 0)', 1]]
    })
    // .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
  }

  private changeCurrentTab(index: number = TabName.TabXTStyle): void {
    HiLog.i(TAG, 'click menu tab');
    if (index === this.editor.tabIndex || this.asset.isGestureOperate || this.asset.isTouching ||
    this.asset.isPictureAnimation || this.editor.isComposing || this.mosaicAttr.isLeaving ||
      this.cropAttr?.isRotateAndMirrorStatus) {
      HiLog.e(TAG, `click same tab index: ${index}, tabIndex: ${this.editor.tabIndex},` +
        `isGestureOperate: ${this.asset.isGestureOperate}, isTouching: ${this.asset.isTouching},` +
        `isPictureAnimation: ${this.asset.isPictureAnimation}, isComposing: ${this.editor.isComposing}` +
        `isLeaving: ${this.mosaicAttr.isLeaving}, isRotateAndMirrorStatus: ${this.cropAttr?.isRotateAndMirrorStatus}`);
      return;
    }
    this.onClickTabIndex = index;
    if (this.isCustomFilterCardShow) {
      this.isCustomFilterCardShow = false;
      if (index !== TabName.TabCrop) {
      } else {
        App.getInstance().myEditor().previewStarter.updatePreview();
      }
    }

    if (((this.xTStyleStatus && this.editor.isSupportXTStyleEdit) ||
      (this.wideApertureStatus && this.editor.isSupportApertureEdit)) &&
      this.getUnSupportTabIndex() !== -1) {
    } else {
      if (index === TabName.TabStylus) {
        this.switchStylusAdapter();
        return;
      }
      this.handleEnterToTab(index);
      this.editor.refreshCompareEffectList();
    }
  }

  @Builder
  TabName(name: Resource, index: number, indicator: number, icon: Resource, isSymbolGlyph: boolean = true) {
    Column() {
      if (isSymbolGlyph) {
        SymbolGlyph(icon)
          .tabSymbolGlyph(index === this.editor.tabIndex,
            (index === TabName.TabSeal && !this.editor.isSupportSealSize))
          .id('petalClip_bottomToolBar_image_' + (index + 1))
      } else {
        Image(icon).tabSymbolImageStyle(index === this.editor.tabIndex)
          .id('petalClip_bottomToolBar_image_' + (index + 1))
      }
      Text(name)
        .tabSize(
          index == this.editor.tabIndex,
          index === TabName.TabSeal && !this.editor.isSupportSealSize,
          this.numOfRotations
        )
        .onMarqueeStateChange(this.handleTabTextMarqueeStateChange)
        .id('petalClip_bottomToolBar_text_' + (index + 1))
    }
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .width(TAB_TOOL_WIDTH)
    .height(TAB_TOOL_HEIGHT)
    .enabled(this.isTabEnabled(index))
    .opacity(this.isTabEnabled(index) ? 1 : 0.5)
    .transition(this.getEachShowAnimation(
        this.isTabDefineFirstLoaded ? 0 : 400, this.isTabDefineFirstLoaded ? 0 : 100, 150, index))
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .id('petalClip_bottomToolBar_' + (index + 1))
    .accessibilityLevel('yes')
    .accessibilitySelected(index === this.editor.tabIndex)
    .accessibilityText(this.tabTextResource(index, this.editor.tabIndex, this.tabsManager.tabs[indicator]))
    .accessibilityDescription(index == this.editor.tabIndex ? ' ' : '')
    .onClick((): void => {
      this.changeCurrentTab(index);
    })
    .focusOnTouch(true)
    .longPressGesture(icon!, name,
      this.buildToolbarDialog(!isSymbolGlyph), this.fontSizeScale)
    .focusBox({ margin: LengthMetrics.vp(-2) })
    .borderRadius(8)
    .backgroundColor(this.tabHoverStates[index] ? $r('sys.color.ohos_id_color_hover_transparent') : Color.Transparent)
    .onHover((isHover: boolean) => {
      this.tabHoverStates[index] = isHover;
    })
  }

  handleEnterToTab(index: number) {
    this.textInputAreaHide = false;
    if (this.editor.tabIndex === TabName.TabAperture) {
    }
    // 从文本Tab切换
    if (this.editor.tabIndex === TabName.TabTextEdit) {
      const needWaitComposeForMosaic = index === TabName.TabMosaic;
      const deferSwitch = this.fromTextTab(index, needWaitComposeForMosaic ? () => {
        HiLog.i(TAG, 'fromTextTab compose finished, continue switch to mosaic');
        this.doSwitchMenu(index);
      } : undefined);
      this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
      if (needWaitComposeForMosaic && deferSwitch) {
        return;
      }
    }
    this.doSwitchMenu(index);
  }

  private doSwitchMenu(index: number) {
    if (index === TabName.TabTextEdit) {
      // KeyboardAvoidMode.None; 避免拉起键盘时，触发ScreenTool onAreaChange
      this.getUIContext().setKeyboardAvoidMode(KEYBOARD_AVOID_MODE_NONE);
    }

    if (this.editor.mosaicModified) { // 马赛克存在修改
      this.editor.isSupportApertureEdit = false;
      this.hideXTStyleAperture();
    }
    if (index === TabName.TabSeal && !this.editor.isSupportSealSize) {
      HiLog.i(TAG, 'image size not support seal!');
      this.editor.asset.overSizeShowToast();
      return;
    }
    let leaveMenu: MenuAttr = this.editor.asset.getMenuAttr(this.editor.tabIndex);
    let enterMenu: MenuAttr = this.editor.asset.getMenuAttr(index);
    HiLog.i(TAG, `switchMenu leaveMenuIndex: ${this.editor.tabIndex}, enterMenu: ${index}`);
    this.setShowWatermarkValue(index);
    this.switchMenu(enterMenu, leaveMenu, index);
    this.numOfRotations = 0;
  }

  private switchStylusAdapter() {
    this.appBroadCast.emit('checkBeforeSwitchStylus');
  }

  private isTabEnabled(index: number): boolean {
    if (![
      TabName.TabAperture,
      TabName.TabXTStyle,
      TabName.TabSport,
    ].includes(index)) {
      return true;
    }
    if (this.editor.mosaicModified) { // 马赛克存在修改
      return false;
    }
    return this.textAreaManager.getTextAreaList().length === 0;
  }

  hideXTStyleAperture = () => {
    HiLog.i(TAG, 'hide XTStyle');
    HiLog.i(TAG, 'hide Aperture');
  }

  private fromTextTab(toIndex: number, onComposeDone?: () => void): boolean {
    this.textAreaManager.initLastTextArea();
    // 清空undo/redo信息
    this.textCanUndo = false;
    this.textCanRedo = false;
    let reportNum: number = this.textAreaManager.getTextAreaList().length;
    this.asset.textEdit().textNum = reportNum;
    if (reportNum !== 0) {
      this.textAreaManager.flush('');
      this.textCanClickStyle = false;
      this.isShowInPopup = false;

      let dstTab: ComposeIndex = tabNameMap.get(toIndex)!;
      // 隐藏时机 1、切换到裁剪 2、有画框水印，切换到了需要显示画框水印的页面
      if (toIndex === TabName.TabCrop) {
        this.appBroadCast.emit('switchTab', [TextInterval.SWITCH_TAB]);
        dstTab = ComposeIndex.CROP;
      }
      HiLog.i(TAG, 'BottomToolBar composeBeforeEnter');
      this.asset.textEdit().composeBeforeEnter(dstTab, this.asset.textEdit().textRect, reportNum, () => {
        let hideDelay: boolean = this.editor.imageSourceHeight >= 8192 || this.editor.imageSourceWidth >= 8192;
        setTimeout(() => {
          this.appBroadCast.emit('clearText');
        }, hideDelay ? this.highPixelDelay : this.commonPixelDelay);
        this.editor.textEditModified = true;
        this.editor.isSupportApertureEdit = false;
        this.hideXTStyleAperture();
        this.refreshXTStyleTab();
        if (toIndex === TabName.TabCrop || toIndex === TabName.TabAdjust) {
          this.editor.previewStarter.updatePreview();
        }
        onComposeDone?.();
      });
      return true;
    } else {
      this.asset.clearComposedCache();
      return false;
    }
  }

  private switchMenu(enterMenu: MenuAttr, leaveMenu: MenuAttr, index: number, close = false): void {
    const enterTargetMenu = (): void => {
      enterMenu.enterMenu();
      enterMenu.changeMenuAnimate(index);
    };
    const leaveResult = leaveMenu.leaveMenu(index, close) as Promise<void> | void;
    if (leaveResult !== undefined && typeof (leaveResult as Promise<void>).then === 'function') {
      (leaveResult as Promise<void>).then(() => {
        enterTargetMenu();
      }).catch((err: Error | BusinessError) => {
        HiLog.e(TAG, `switchMenu leaveMenu failed: ${JSON.stringify(err)}`);
        enterTargetMenu();
      });
      return;
    }
    enterTargetMenu();
  }

  scrollToTargetTabIndex(index: number) {
    const targetIndex = this.tabsManager.tabs.findIndex(item => item.index === index);
    if (targetIndex == -1) {
      return;
    }
    const offset: ScrollOptions = this.isScreenPortrait ?
      { xOffset: TAB_TOOL_WIDTH * targetIndex, yOffset: 0 } :
      { xOffset: 0, yOffset: TAB_TOOL_HEIGHT * targetIndex };
    this.scrollerMenu.scrollTo(offset);
  }

  handleTabTextMarqueeStateChange = (state: MarqueeState) => {
    if (state === MarqueeState.BOUNCE) {
      this.numOfRotations++;
    }
  };

  setShowWatermarkValue(to: TabName) {
    // 当前页是否需要展示水印
    this.editor.setShowWatermarkValue(this.editor.isShowWatermarkTab(to));
  }

  tabTextResource(curIndex: number, index: number, buttonItem: TabType): string {
    return UiUtil.getResourceString(buttonItem.name);
  }

  @Builder
  AiTabsContent() {
    Column() {
    }
    .alignItems(HorizontalAlign.End)
    .justifyContent(FlexAlign.Center)
    .width(this.isScreenPortrait ? '100%' : TABS_CONTENT_HEIGHT)
    .height(this.isScreenPortrait ? TABS_CONTENT_HEIGHT : '100%')
    .padding({ top: this.isPhoneOrFoldSplitLR() ? 8 : 0 })
  }

  @Builder
  AiTabsDefine() {
    Stack() {
      Scroll(this.aiScrollerMenu) {
        this.AiTabsListBuilder()
      }
      .height(this.isScreenPortrait ? TAB_TOOL_HEIGHT : this.isScrollMode() ? this.scrollHeight : this.tabsDefineHeight)
      .width(this.isScreenPortrait ? (this.isScrollMode() ? this.scrollWidth : this.tabsDefineWidth) : TAB_TOOL_HEIGHT)
      .scrollable(!this.isScrollMode() ? ScrollDirection.None :
        (this.isScreenPortrait ? ScrollDirection.Horizontal : ScrollDirection.Vertical))
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .onDidScroll((x: number, y: number, state: ScrollState): void => {
        this.handleAiScroll(state);
      })
      .onScrollEdge((side: Edge) => {
        if (side === Edge.Start || side === Edge.Top) {
          this.isAiShowShadowStart = false;
        } else {
          this.isAiShowShadowStart = true;
        }
        if (side === 3 || side === Edge.Bottom) { // 3: Edge.End
          this.aiScrollDistance = (this.isScreenPortrait ? this.aiScrollerMenu.currentOffset().xOffset :
            this.aiScrollerMenu.currentOffset().yOffset) ?? 0;
          this.isAiShowShadowEnd = false;
        } else {
          this.isAiShowShadowEnd = true;
        }
      })
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.aiShadowRate = SCROLL_SHADOW_WIDTH / Number(this.isScreenPortrait ? newValue.width : newValue.height);
      })
    }
    .linearGradient({
      angle: this.isScreenPortrait ? 90 : (UiUtil.isMirrorMode() ? 0 : 180),
      colors: UiUtil.isMirrorMode() ? [
        ['rgba(0, 0, 0, 0)', 0],
        ['rgba(0, 0, 0, 1)', this.isScrollMode() && this.isAiShowShadowEnd ? this.aiShadowRate : 0],
        ['rgba(0, 0, 0, 1)', this.isScrollMode() && this.isAiShowShadowStart ? 1 - this.aiShadowRate : 1],
        ['rgba(0, 0, 0, 0)', 1]] : [
        ['rgba(0, 0, 0, 0)', 0],
        ['rgba(0, 0, 0, 1)', this.isScrollMode() && this.isAiShowShadowStart ? this.aiShadowRate : 0],
        ['rgba(0, 0, 0, 1)', this.isScrollMode() && this.isAiShowShadowEnd ? 1 - this.aiShadowRate : 1],
        ['rgba(0, 0, 0, 0)', 1]]
    })
    .layoutWeight(1)
  }

  @Builder
  AiTabsListBuilder() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
      alignItems: ItemAlign.Center,
      justifyContent: this.isScrollMode() ? FlexAlign.Start : FlexAlign.SpaceBetween,
      space: { main: new LengthMetrics(this.handleAiTabsDefineSpace(this.aiTabsDefineSpace), LengthUnit.VP) },
    }) {
    }
    .id('petalClip_bottomToolBar_AiTabsBar')
    .transition(this.getListReleaseAnimation())
    .width(this.isScreenPortrait ? (this.isScrollMode() ? this.getScrollLength() : this.tabsDefineWidth) : TAB_SIZE)
    .height(this.isScreenPortrait ? TAB_SIZE : (this.isScrollMode() ? this.getScrollLength() : this.tabsDefineHeight))
  }

  @Builder
  AiTabName(name: Resource | string, index: number, icon?: Resource) {
    Column() {
      if (RESOURCE_TYPE_SYS === icon?.type) {
        SymbolGlyph(icon!)
          .tabSymbolGlyph(false, false)
      } else {
        Image(icon).symbolImageStyle(false)
          .hitTestBehavior(HitTestMode.None)
      }
      Text(name)
        .tabSize(false, false, this.numOfRotations)
        .onMarqueeStateChange(this.handleTabTextMarqueeStateChange)
    }
    .accessibilityLevel('yes')
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .accessibilitySelected(false)
    .accessibilityText(UiUtil.getResourceString(name))
    .accessibilityDescription('')
    .transition(this.getEachShowAnimation(400, 100, 150, index))
    .justifyContent(FlexAlign.Center)
    .width(TAB_SIZE)
    .height(TAB_SIZE)
    .onClick((): void => {
      // 修图有进行中的过程，不允许切换页签
      const canChangeOtherBottom: boolean = this.aiImageProcessStatusCheck();
      if (!canChangeOtherBottom) {
        HiLog.i(TAG, `processing is ANALYSIS or GENERATING, can not change tabindex
        ${App.getInstance().getType()}`);
        return;
      }
      this.doOnClick(index);
    })
    .longPressGesture(icon!, name as Resource,
      this.buildToolbarDialog(!(RESOURCE_TYPE_SYS === icon?.type)), this.fontSizeScale)
    .focusBox({ margin: LengthMetrics.vp(-2) })
    .borderRadius(8)
    .backgroundColor(Color.Transparent)
    .onHover((isHover: boolean) => {
    })
  }

  doOnClick(index: number): void {
    this.processOfOnClick(index);
    this.numOfRotations = 0;
  }

  processOfExpandImage(index: number): void {
    HiLog.i(TAG, 'isEnterExpandImage');
    let networkAvailable: boolean =
      (AppStorage.get<boolean>(APP_STORAGE_KEY_OF_NETWORK_AVAILABLE))?? false;
    HiLog.i(TAG, `networkAvailable res = ${networkAvailable}`);
    if (!networkAvailable) {
      this.checkNetworkToast(networkAvailable);
      return;
    }
    this.processOfOnClick(index);
  }

  processOfRefineMaster(index: number): void {
  }

  processOfReflect(index: number): void {
    let networkAvailable: boolean =
      (AppStorage.get<boolean>(APP_STORAGE_KEY_OF_NETWORK_AVAILABLE))?? false;
    HiLog.i(TAG, `networkAvailable res = ${networkAvailable}`);
    if (!networkAvailable) {
      this.checkNetworkToast(networkAvailable);
      return;
    }
    this.processOfOnClick(index);
  }

  processOfOnClick(index: number): void {
  }

  buildAIMoveRevertSureDialog(index: number) {
    this.aiMoveRevertSureDialog = new CustomDialogController({
      builder: AlertDialog({
        primaryTitle: $r('app.string.ai_move_toast_title'),
        content: $r('app.string.ai_move_toast_content'),
        primaryButton: {
          value: $r('app.string.subtitle_delete_cancel_imageEdit'),
          action: () => {
            this.aiMoveRevertSureDialogOpenFlag = false;
          },
        },
        secondaryButton: {
          value: $r('app.string.exit_imageEdit'),
          fontColor: $r('sys.color.warning'),
          action: () => {
            this.aiMoveRevertSureDialogOpenFlag = false;
            HiLog.i(TAG, 'sure button clicked');
            setTimeout((): void => {
            }, 200);
          },
        },
      }),
      cancel: () => {
        this.aiMoveRevertSureDialogOpenFlag = false;
      },
      customStyle: false,
      autoCancel: false,
    });
  }

  private toastHandle(res: Resource | string) {
    HiLog.i(TAG, 'toastHandle start, isScreenPortrait: %{public}s', this.isScreenPortrait);
    try {
    } catch (err) {
      HiLog.e(TAG, `showToast err: ${err.code}, ${err.message}`);
    }
    HiLog.i(TAG, 'toastHandle end.');
  }

  @State aiBtnScale: ScaleAnimator = new ScaleAnimator();

  private async checkUserInfo(): Promise<boolean> {
    if (!this.userInfo.userId) {
      await this.getAccountInfo(false);
      if (!this.userInfo.userId) {
        // 用户信息查询异常也可以进入AI修图页面
        App.getInstance().setType(EditorType.AI, () => {
        });
        return false;
      }
    }
    return true;
  }

  public checkNetworkToast(networkAvailable: boolean) {
    if (!networkAvailable) {
    }
    HiLog.i(TAG, `checkNetworkToast networkAvailable is ${networkAvailable}`);
  }

  private getCustomFilterStackCardViewPosition() {
  }

  build() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Column : FlexDirection.Row,
      alignItems: ItemAlign.Center,
    }) {
      this.switchTabsContent();
      this.tabsBuilder()
      CustomDialogView({ broadCast: $broadCast })
    }
    .id('petalClip_bottomToolBar_bottomToolBar')
    .height(this.isScreenPortrait ?
      (this.screenClass.avoidBottom !== 0 ? BOTTOM_HEIGHT_SPLIT + this.screenClass.avoidBottom :
        BOTTOM_HEIGHT + this.screenClass.avoidBottom
      ) : `100%`)
    .width(this.isScreenPortrait ? '100%' :
        UiUtil.isMirrorMode() ? BOTTOM_HEIGHT_SPLIT - 6 + this.screenClass.avoidLeft :
        BOTTOM_HEIGHT_SPLIT + this.textPaddingLeftAndRight - 6 + this.screenClass.avoidRight)
    .visibility(this.isFromMovingPhoto && this.onBackProgress ? Visibility.Hidden : Visibility.Visible)
    .padding({
      left: 0,
      right: 0,
      bottom: this.screenClass.avoidBottom
    })
    // .bindContentCover($$this.isHsp, this.loginExtensionComponent(), {
    //   modalTransition: ModalTransition.NONE,
    // })
    .enabled(!this.editor.isSaveVideoDialog)
  }

  @Builder
  tabsBuilder() {
    Stack() {
      Flex({
        direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
        alignItems: ItemAlign.Center,
        space: {
          main: new LengthMetrics(0, LengthUnit.VP)
        },
        justifyContent: this.isScreenPortrait ?
          FlexAlign.Start : FlexAlign.SpaceBetween
      }) {
        // Divider()
        //   .tabDivider(this.isScreenPortrait)
        //   .visibility(this.isShowDivider() ? Visibility.Visible : Visibility.Hidden);
        this.switchTabsDefine();
      }
    }
    .visibility(this.showXTStyleDirectly ? Visibility.Hidden : Visibility.Visible)
    .accessibilityLevel(this.isCustomFilterCardShow ? 'no-hide-descendants' : 'yes')
    .width(this.isScreenPortrait ? '100%' : TAB_TOOL_HEIGHT)
    .height(this.isScreenPortrait ? TAB_TOOL_HEIGHT : this.isFoldAndPadLR ? '60%' : '100%')
    .padding(this.isScreenPortrait ? {
      left: UiUtil.isMirrorMode() ? this.handleTabsBuilderPadding() : 'calc(10% - 26vp)',
      right: UiUtil.isMirrorMode() ? 'calc(10% - 26vp)' : this.handleTabsBuilderPadding(),
    } : {
      top: this.isFoldAndPadLR ? 0 : 8,
    })
  }

  private handleTabsBuilderPadding(): Length {
    return this.isSupportTabScroll ? 0 : 'calc(10% - 26vp)';
  }

  private isPhoneOrFoldSplitLR(): boolean {
    return ScreenManager.getInstance().isPhoneLR() ||
      (DeviceUtil.isFoldable() && this.isSplitMode && !this.isScreenPortrait);
  }

  @Builder
  switchTabsDefine() {
    this.TabsDefine();
  }

  @Builder
  switchTabsContent() {
    this.TabsContent();
  }

  @Builder
  loginExtensionComponent() {
    UIExtensionComponent({
      bundleName: 'com.ohos.photos',
      abilityName: 'AuthExtensionAbility',
      parameters: {
        'ability.want.params.uiExtensionType': 'sys/commonUI',
        'requestType': 'requestAiRetouchProtocol', // 获取登录和协议签署信息
        'isBigHsp': this.isBigHsp
      }
    })
      .onRemoteReady((data: UIExtensionProxy) => {
        // UIExtensionAbility连接完成时的回调, 此时登录界面可能还没有显示出来
        HiLog.i(TAG, 'direct enter ai editor login page UI extension ready.');
        this.delayEntryFinishedWhenLogin();
        ScreenManager.getInstance().setIsQueryUserLogin(true);
      })
      .onTerminated((data: TerminationInfo) => {
        try {
          let resultParam = this.getResultParam(data);
          this.handleLoginResult(resultParam);
        } catch (err) {
          HiLog.e(TAG, `loginExtensionComponent onTerminated. err: ${err.code}, ${err.message}`);
        }
      })
      .size({
        width: '100%',
        height: '100%',
      })
  }

  private getResultParam(data: TerminationInfo) {
    let resultParam = data.want?.parameters as Record<string, Object> ?? undefined;
    HiLog.i(TAG, `loginExtensionComponent onTerminated getResultParam resultParam=${JSON.stringify(resultParam)}`);
    return resultParam;
  }

  private handleLoginResult(resultParam: Record<string, Object>) {
    ScreenManager.getInstance().setIsQueryUserLogin(false);
    if (resultParam) {
      let success = resultParam['success'] as boolean ?? false;
      if (success) {
        App.getInstance().setType(EditorType.AI, () => {
        });
        this.isHsp = false;
        HiLog.i(TAG, 'loginExtensionComponent login success');
      } else {
        this.handleLoginResultError(resultParam);
        this.isHsp = false;
        HiLog.e(TAG, 'loginExtensionComponent login fail');
      }
    }
  }

  private handleLoginResultError(resultParam: Record<string, Object>) {
    let message: string = resultParam?.['message'] as string;
    let messageParam: AuthMessage = message.indexOf('{') !== -1 ? JSON.parse(message) : message ?? '';
    if ((messageParam?.subCode === USER_LOGIN_NETWORK_ERROR_CODE) || resultParam['errorCode'] === '10005') {
      this.checkNetworkToast(false);
      return;
    }
    if (messageParam?.subCode === USER_LOGIN_CANCEL_CODE) {
      HiLog.e(TAG, 'cancel login');
      return;
    }
    if (resultParam['message'] === 'cancelNetworkConnection') {
      HiLog.e(TAG, 'AiRetouchNetworkConnectionManager cancelNetworkConnectionDialog');
      return;
    }
    if (resultParam['message'] === 'cancelAiProtocolDialog') {
      HiLog.e(TAG, 'AiRetouchPrivacyManager cancelAiProtocolDialog');
      return;
    }
    HiLog.e(TAG, 'loginExtensionComponent login fail, enter AI retouch page');
    // 用户登录异常也可以进入AI修图页面
    App.getInstance().setType(EditorType.AI, () => {
    });
  }

  private initNetworkConnectContent(): void {
    this.confirmText = $r('app.string.Switch_on');
    this.headTitle = $r('app.string.gallery_open_network_link');
    this.subTitle = $r('app.string.enable_gallery_network_connection');
  }

  private setNetworkConnectionConfirmCallback: () => void = (): void => {
    App.getInstance().setType(EditorType.AI, () => {
    });
  }

  private isShowDivider(): boolean {
    return !this.editor.immersiveMode && !(this.cropAttr?.isScrolling)
  }

  private isShowAiRetouchButton(): boolean {
    return !this.editor.immersiveMode;
  }

  private isPadLayout(): boolean {
    return (DeviceUtil.isPad() || (DeviceUtil.isPad() && this.isSplitMode));
  }

  private refreshTabsDefineReact(): void {
    // 旋转后手势操作状态置为false
    this.asset.isGestureOperate = false;

    this.winHeight = ScreenManager.getInstance().height;
    this.winWidth = ScreenManager.getInstance().width;
    HiLog.i(TAG, `refreshHeightTimer finish winHeight ${this.winHeight} winWidth is ${this.winWidth}`);
    this.tabsDefineSpace = ((this.winHeight - this.screenClass.avoidTop - BOTTOM_NAVIGATION_HEIGHT -
      TOP_OFFSET_PHONE - (ScreenManager.getInstance().isPhoneLR() ? 8 : 0)) *
      (ScreenManager.getInstance().isFoldAndPadLR() ? 0.6 : 1) - TAB_SIZE) - TAB_SIZE;
    this.isFoldAndPadLR = ScreenManager.getInstance().isFoldAndPadLR();
    HiLog.i(TAG, `refreshTabsDefineReact avoid is ${JSON.stringify(this.screenClass)} winHeight is ${this.winHeight}`);
    this.marginLeftAndRight = (this.winWidth / 5 - TAB_SIZE) / 2;
    this.scrollHeight = (this.winHeight - TOP_OFFSET_PHONE - this.screenClass.avoidTop - BOTTOM_NAVIGATION_HEIGHT)
      - TAB_SIZE - LANDSCAPE_TABS_SPACE;
    this.tabsDefineWidth = this.winWidth - TAB_SIZE - this.aiTabsDefineSpace - this.marginLeftAndRight * 2 -
    this.screenClass.avoidLeft - this.screenClass.avoidRight;
    if (this.isFoldableLayout()) {
      this.foldableLayoutHandle();
    } else if (this.isPadLayout()) {
      this.padLayoutHandle();
      this.tabsDefineWidth = this.winWidth - TAB_SIZE - this.aiTabsDefineSpace - this.marginLeftAndRight * 2 -
      this.screenClass.avoidLeft - this.screenClass.avoidRight;
    } else {
      this.normalLayoutHandle();
      this.tabsDefineWidth = this.winWidth - TAB_SIZE - this.aiTabsDefineSpace - this.marginLeftAndRight * 2 -
      this.screenClass.avoidLeft - this.screenClass.avoidRight;
    }
    HiLog.i(TAG, `refreshTabsDefineReact tabsDefineWidth: ${this.tabsDefineWidth}, marginLeftAndRight is ${
    this.marginLeftAndRight}, aiTabsDefineSpace is ${this.aiTabsDefineSpace}`);

    this.scrollDistance = 0;
    this.aiScrollDistance = 0;
    this.handleScroll();
    this.handleAiScroll();
    this.getIsSupportTabScroll();
  }

  private normalLayoutHandle() {
    HiLog.i(TAG, 'refreshTabsDefineReact normalLayout');
    // 直板手机、xxx机非xxx
    this.marginLeftAndRight = this.isScreenPortrait ? this.marginLeftAndRight : 0;
    if (!this.isScrollMode()) {
      HiLog.i(TAG, `refreshTabsDefineReact Not ScrollMode, ScreenPortrait is ${this.isScreenPortrait}`);
    } else {
      this.aiTabsDefineSpace = this.isScreenPortrait ? PORTRAIT_TABS_SPACE : LANDSCAPE_TABS_SPACE;
    }
    this.tabsDefineHeight = this.winHeight - TAB_SIZE - this.aiTabsDefineSpace - this.screenClass.avoidTop -
      BOTTOM_NAVIGATION_HEIGHT - TOP_OFFSET_PHONE - LANDSCAPE_TOP_MARGIN;
    HiLog.i(TAG, `refreshTabsDefineReact tabsDefineHeight is ${
    this.tabsDefineHeight}, tabsDefineWidth is ${this.tabsDefineWidth}`);
  }

  private padLayoutHandle() {
    HiLog.i(TAG, `refreshTabsDefineReact isPadLayout winHeight is ${this.winHeight}`);

    let decorBar: number = ScreenManager.getInstance().isWindowMode() ? WINDOW_MODE_DECOR_BAR : 0;
    this.marginLeftAndRight = this.isScreenPortrait ? this.marginLeftAndRight : 0;
    this.tabsDefineHeight =
      (this.winHeight - this.screenClass.avoidTop - BOTTOM_AVOID_HEIGHT - TOP_OFFSET_PHONE - decorBar) *
        LANDSCAPE_LENGTH_RATIO - TAB_SIZE - this.aiTabsDefineSpace;
  }

  // instrument ignore next
  private foldableLayoutHandle() {
    HiLog.i(TAG, `refreshTabsDefineReact isFoldableLayout: true, isUnfoldPortrait: ${this.asset.isUnfoldPortrait},
      ${DeviceUtil.isLandscape()}`);
    if (this.asset.isUnfoldPortrait) {
      this.tabsDefineWidth = this.winWidth - TAB_SIZE - this.aiTabsDefineSpace - this.marginLeftAndRight * 2 -
      this.screenClass.avoidLeft - this.screenClass.avoidRight;
      // xxx全xxx的竖屏 或者 双xxx的横屏
      if ((DeviceUtil.isTriFoldFullExpanded() && !DeviceUtil.isLandscape()) ||
        (!DeviceUtil.isTriFoldScreen() && DeviceUtil.isLandscape())) {
        this.tabsDefineWidth = this.winWidth - TAB_SIZE - this.aiTabsDefineSpace - this.marginLeftAndRight * 2;
      }
    } else {
      // xxxxxx左右横竖屏布局
      this.marginLeftAndRight = 0;
      this.tabsDefineHeight = (this.winHeight - TOP_OFFSET_PHONE - this.screenClass.avoidTop -
        BOTTOM_AVOID_HEIGHT) * LANDSCAPE_LENGTH_RATIO - TAB_SIZE - this.aiTabsDefineSpace;
      this.tabsDefineWidth = this.winWidth - TAB_SIZE - this.aiTabsDefineSpace - this.marginLeftAndRight * 2 -
      this.screenClass.avoidLeft - this.screenClass.avoidRight;
    }
    HiLog.i(TAG, `refreshTabsDefineReact isUnfoldLandscape tabsDefineHeight is ${
    this.tabsDefineHeight}, tabsDefineWidth is ${this.tabsDefineWidth}`);

    // xxxxxx，横竖屏切换（非按钮操作）触发
    UiUtil.isSystemStatus();
  }

  private isFoldableLayout(): boolean {
    return DeviceUtil.isFoldable() && !this.isFold && !this.isSplitMode && !this.isSmallWindowMode;
  }

  private isScrollMode(): boolean {
    let tabsDefineMiniHeight: number = this.winHeight * (!this.isScreenPortrait && this.isFoldAndPadLR ? 0.6 : 1) -
      BOTTOM_NAVIGATION_HEIGHT - TOP_OFFSET_PHONE - LANDSCAPE_TOP_MARGIN;
    let tabsDefineMiniWidth: number = this.winWidth - this.marginLeftAndRight * 2;
    return false;
  }

  private getScrollLength(): number {
    return 0;
  }

  // AI修圖的Tabs的间距左右最小10，上下最小12
  private handleAiTabsDefineSpace(tempSpace: number): number {
    if (this.isFoldableLayout() && (DeviceUtil.isPhone() && !this.asset.isUnfoldPortrait)) {
      return tempSpace > LANDSCAPE_TABS_SPACE ? tempSpace : LANDSCAPE_TABS_SPACE;
    } else {
      return tempSpace > PORTRAIT_TABS_SPACE ? tempSpace : PORTRAIT_TABS_SPACE;
    }
  }
}
