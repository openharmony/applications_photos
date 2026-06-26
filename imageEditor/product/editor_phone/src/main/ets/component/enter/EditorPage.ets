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
  App,
  BaseEditor,
  MediaType,
  TabName
} from '@oh-image-editor/editor-common/src/main/ets/service/App'
import {
  AppColor,
  APP_STORAGE_KEY_DOWNLOAD_PROGRESS,
  USER_LOGIN_STATUS,
  CANVAS_RECT,
  DEVICE_FOLD_STATUS,
  DOWNLOAD_STATUS,
  FIRST_FRAME_STATUS,
  SCREEN_ORIENTATION_PORTRAIT,
  TOP_BAR_HEIGHT,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY
} from '@oh-image-editor/editor-common/src/main/ets/common/const'
import { BreakPointSystem } from '@oh-image-editor/editor-common/src/main/ets/common/util/BreakPointSystem'
import { Constants } from '@oh-image-editor/editor-common/src/main/ets/common/util/Constants'
import {
  EditorMsg,
  EditorParams,
  EditorStatus,
  RectValue
} from '@oh-image-editor/editor-common/src/main/ets/service/EditorSDK'
import { HiLog } from '@oh-image-editor/editor-common/src/main/ets/common/util/HiLog'
import { CropAttr, Timeline } from '@oh-image-editor/editor-common/src/main/ets/service/BaseEditor'
import { ScreenManager } from '@oh-image-editor/editor-common/src/main/ets/common/util/ScreenManager'
import { UiUtil } from '@oh-image-editor/editor-common/src/main/ets/common/util/UiUtil'
import { VideoPlay } from '@oh-image-editor/editor-common/src/main/ets/feature/basic/view/VideoPlay'
import { DeviceUtil } from '@oh-image-editor/editor-common/src/main/ets/common/util/DeviceUtil'
import { BottomToolbar } from '../menu/BottomToolbar';
import { ScreenTool } from '../common/ScreenTool'
import { TopToolbar } from '../menu/TopToolbar'
import window from '@ohos.window'
import { AlertDialog } from '@ohos.arkui.advanced.Dialog'
import { EditorPixelMapManager } from '@oh-image-editor/editor-common/src/main/ets/common/EditorPixelMapManager'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { image } from '@kit.ImageKit'
import { AccessibilityManager, FormatUtil, Service} from '@oh-image-editor/editor-common'
import { Trace } from '@oh-image-editor/editor-common/src/main/ets/common/util/Trace'
import PhotoAssetUtil from '@oh-image-editor/editor-common/src/main/ets/common/util/PhotoAssetUtil'
import { common } from '@kit.AbilityKit'
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager'
import { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants'
import { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo'
import { display } from '@kit.ArkUI'
import { TextEditView } from '@oh-image-editor/editor-common/src/main/ets/service/model/tabTextEdit/view/TextEditView';
import {
  TextAreaManager
} from '@oh-image-editor/editor-common/src/main/ets/service/model/tabTextEdit/viewModel/TabTextAreaManager';
import {
  UndoRedoManager
} from '@oh-image-editor/editor-common/src/main/ets/service/model/tabTextEdit/viewModel/TabUndoRedoManager';
import {
  TextInputEditItem
} from '@oh-image-editor/editor-common/src/main/ets/service/model/tabTextEdit/view/TextInputEditItem';
import {
  TextAreaInfo,
  deepCopy
} from '@oh-image-editor/editor-common/src/main/ets/service/model/tabTextEdit/model/TextAreaInfo';
import { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import { MosaicView } from '@oh-image-editor/editor-common/src/main/ets/service/model/mosaic/MosaicView';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast'
import Bundles, { BUNDLE_NAMES } from '../../../../../../../../tools/src/main/utils/Bundle';
import settings from '@ohos.settings';
import ResourceCleaner from '@oh-image-editor/editor-common/src/main/ets/common/util/ResourceCleaner'
import { DownLoading } from '@oh-image-editor/editor-common/src/main/ets/common/components/DownLoading'

const TAG = 'EditorPage';
let timeFn: number | undefined = undefined;

let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

@Component
struct LoginStatusLoading {
  @State params: EditorParams | undefined = undefined // 工程初始化参数
  @StorageProp(USER_LOGIN_STATUS) @Watch('onUserLoginStatusChange') userLoginStatus: boolean = false;
  @State previewRect: RectValue = new RectValue(0, 0, 0, 0);
  @State private loadingWidth: number = 0;
  @State private loadingHeight: number = 0;
  private loadingSize: number = 32;
  @StorageProp(WIN_WIDTH_KEY) @Watch('getLoadingPosition') winWidth: number = ScreenManager.getInstance().width;
  @StorageProp(WIN_HEIGHT_KEY) @Watch('getLoadingPosition') winHeight: number = ScreenManager.getInstance().height;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('getLoadingPosition') isScreenPortrait: boolean =
    ScreenManager.getInstance().isScreenPortrait();

  aboutToAppear(): void {
    this.getLoadingPosition(this.loadingWidth != 0 ? 400 : 0);
  }

  public onUserLoginStatusChange() {
    HiLog.i(TAG, 'onUserLoginStatusChange, loginStatus: %{public}s, APP UserLogin: %{public}s',
      this.userLoginStatus,
      ScreenManager.getInstance().getIsQueryUserLogin()
    );
  }

  getLoadingPosition(delay: number = 0) {
    let width = this.params?.rectInfo?.width as number;
    let height = this.params?.rectInfo?.height as number;
    let ratio = width / height;
    this.previewRect = ScreenManager.getInstance().getPreviewRect(ratio, this.isScreenPortrait);
    if (delay) {
      setTimeout((): void => {
        this.loadingWidth = px2vp(this.previewRect.x + (this.previewRect.width / 2)) - this.loadingSize / 2;
        this.loadingHeight = px2vp(this.previewRect.y + (this.previewRect.height / 2)) - this.loadingSize / 2;
      }, delay)
    } else {
      this.loadingWidth = px2vp(this.previewRect.x + (this.previewRect.width / 2)) - this.loadingSize / 2;
      this.loadingHeight = px2vp(this.previewRect.y + (this.previewRect.height / 2)) - this.loadingSize / 2;
    }
  }

  build() {
    Column() {
      LoadingProgress()
        .color($r('sys.color.white'))
        .width(this.loadingSize)
        .height(this.loadingSize)
        .visibility(this.userLoginStatus ? Visibility.Visible : Visibility.Hidden)
    }
    .key('ProgressOfLoadingPanel')
    .position({
      x: this.loadingWidth, y: this.loadingHeight,
    })
    .hitTestBehavior(HitTestMode.None)
  }
}

@Component
export struct EditorMain {
  // 外部传入参数
  @State params: EditorParams | undefined = undefined // 工程初始化参数
  @ObjectLink @Watch('onStatusChanged') status: EditorStatus // 编辑组件界面状态控制
  @StorageProp(WIN_HEIGHT_KEY) @Watch('onFoldChanged') winHeight: number = ScreenManager.getInstance().height;
  @StorageProp(WIN_WIDTH_KEY) @Watch('onFoldChanged') winWidth: number = ScreenManager.getInstance().width;
  // 内部参数
  @State app: App = App.getInstance();
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State @Watch('stylusModeChanged') stylusMode: boolean = App.getInstance().myEditor().stylusMode;
  @State isLoading: boolean = true;
  @State @Watch('backDeal') toolBarBackState: boolean = false;
  @State firstFrameLoaded: boolean = false;
  // 直接进入涂鸦是否第一次加载完成
  @State @Watch('onStylusOrAiEntryOnceFinished') isStylusOrAiEntryOnceFinished: boolean = false;
  @State animOpacity: number = 0;
  @State originalColorMode: number = 0;
  @State showEmptyBackground: boolean = false;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('onPortraitChange') isPortrait: boolean = ScreenManager.getInstance()
    .isScreenPortrait();
  @StorageProp(DEVICE_FOLD_STATUS) @Watch('refreshDialogsFoldChange') isFolded: boolean = ScreenManager.getInstance()
    .isDeviceFold();
  @StorageProp(FIRST_FRAME_STATUS) isFirstFrameStatue: boolean = ScreenManager.getInstance().getIsFirstFrame();
  @StorageLink(APP_STORAGE_KEY_DOWNLOAD_PROGRESS) @Watch('refreshTime') downloadProgress: number = 0;
  @StorageLink('windowStatus') @Watch('refreshDialogs') windowStatus: number | undefined = undefined;
  @StorageLink('isSplitMode') isSplitMode: boolean = getScreen().isSplitMode();
  @StorageLink('isFloatMode') isFloatMode: boolean = getScreen().isFloatMode();
  @StorageLink('editor_statusBarHeight') @Watch('buildDialog') statusBarHeightCutOut: number = 0;
  @State isDialogCenter: boolean = false;
  private downloadFinishCallback: Function | undefined = undefined;
  private lastStartFadeoutAnimStatus: boolean = false;
  private backSureDialogOpenFlag: boolean = false;
  private backSureDialog: CustomDialogController | undefined = undefined;
  private breakPoint: BreakPointSystem = new BreakPointSystem();
  private currenTime: number = 0;
  private downloadFailDialog: CustomDialogController | undefined = undefined;
  private downLoadTimeout: number = -1;
  private isRemoteResource: boolean = false;
  private isButtonClick: boolean = false;
  private downloadDialogOpen: boolean = false;
  private isDownloadFinish: boolean = false;
  onMessageCallback = (msg: EditorMsg): boolean => { // 消息回调函数
    return false;
  }
  private onIsAiEditFunc: Function = (): void => this.onIsAiEdit();
  private onEditPhotoEnterFunc: Function = (): void => {
    HiLog.i(TAG, `autoBack when enter EditorPage`);
    this.autoBack(true);
  };
  @State private previewRect: RectValue | undefined = this.params?.rectInfo;
  @State textCanUndo: boolean = false;
  @State textCanRedo: boolean = false;
  @State textCanClickStyle: boolean = false;
  @State isShowInPopup: boolean = false;
  @State currentFontColor: Color | string | Resource = '#FFFFFF';
  @State currentFontSize: number = 16;
  @State isShowBorder: boolean = true;
  @State isFontSizeChange: boolean = false;
  @State previousTextArea: TextAreaInfo | undefined = undefined;
  @State realTimeContent: string | undefined = undefined;
  @State @Watch('keyboardHeightChange') keyboardHeight: number = 0;
  @StorageLink('change_background') @Watch('onBackGroundChange') onBackGround:boolean = false;
  @State textInputAreaHide: boolean = false;
  @State isFromMovingPhoto: boolean = false;
  @State onBackProgress: boolean = false;
  @Provide isInMosaicView: boolean = false;
  textAreaManager: TextAreaManager = TextAreaManager.getInstance();
  undoRedoManager: UndoRedoManager = UndoRedoManager.getInstance();
  @Provide isButtonFreeze: boolean = true; // 按钮是否冻结(防止出现蒙层闪烁)  设置为false时 取消按钮冻结
  // 是否需要直接显示个性风格调色盘, 由演示APP拉起图库跳转编辑的场景会被置成true, 正常从大图进编辑时值为false
  @StorageLink('is_entry_XTStyle') showXTStyleDirectly: boolean = false;
  @StorageLink('isCustomFilterCardShow') isCustomFilterCardShow: boolean = false;
  @State curMirrorMode: boolean = UiUtil.isMirrorMode();
  private isCamera = Bundles.getInfo().name === BUNDLE_NAMES['camera'];

  keyboardHeightChange() {
    AccessibilityManager.getInstance().isKeyboardStateChange(this.keyboardHeight > 0);
  }

  private onBackGroundChange(): void {
    if (this.editor.tabIndex != TabName.TabSeal) {
      App.getInstance().myEditor().previewStarter.updatePreview();
    }
  }

  private onIsAiEdit(): void {
  }

  refreshTime() {
    this.setDownLoadTimeOut();
  }

  refreshDialogs() {
    // 大图也做了状态栏颜色监听，这里延迟设置
    setTimeout((): void => {
      UiUtil.isSystemStatus();
    }, 100)
  }

  /* instrument ignore next */
  refreshDialogsFoldChange() {
    this.isDialogCenter = true;
    this.buildDialog(true);
  }

  onPortraitChange() {
    this.buildDialog(true);
    this.refreshDialogs();
    this.editor.rotateMode = true;
    setTimeout((): void => {
      this.editor.rotateMode = false;
    }, 400)
  }

  buildDialog(refreshDialog: boolean) {
    let isWinOrSplitMode = ScreenManager.getInstance().isWindowMode() || ScreenManager.getInstance().isSplitMode();
    let isFollow = !this.isDialogCenter && !isWinOrSplitMode && ((DeviceUtil.isFoldable() && !this.isFolded) ||
    DeviceUtil.isPad());
    let backSureDialogTopRight: boolean = false;
    let paddingStart : number = px2vp(UiUtil.getResourceNumber($r('sys.float.ohos_id_max_padding_start')));
    if(this.curMirrorMode && (DeviceUtil.isPad() || DeviceUtil.isTriFoldFullExpanded() ||
    DeviceUtil.isTriFoldLandScape())) {
      backSureDialogTopRight = true;
    }
    if (this.isCamera) {
      HiLog.i(TAG, 'isCamera by hsp');
    }
    let topHeight = TOP_BAR_HEIGHT + (this.isCamera || this.statusBarHeightCutOut === 0 ?
      App.getInstance().screenClass.avoidTop : 0);
    HiLog.i(TAG, `buildDialog isFollow ${isFollow}`);
    if (this.statusBarHeightCutOut === 0) {
      topHeight += App.getInstance().screenClass.avoidTop;
    }
    if (this.backSureDialogOpenFlag && this.backSureDialog && refreshDialog) {
      this.backSureDialog.close();
    }
    this.backSureDialog = new CustomDialogController({
      builder: AlertDialog({
        content: $r('app.string.discard_all_changes_imageEdit'),
        primaryButton: {
          value: $r('app.string.subtitle_delete_cancel_imageEdit'),
          action: () => {
            this.backSureDialogOpenFlag = false;
          },
        },
        secondaryButton: {
          value: $r('app.string.discard_imageEdit'),
          action: () => {
            this.backSureDialogOpenFlag = false;
            HiLog.i(TAG, 'sure button clicked');
            setTimeout((): void => {
              // 等待弹框消失动画完成后再开始退出动画
              this.autoBack(true);
            }, 200);
          },
          role: ButtonRole.ERROR,
        },
      }),
      cancel: () => {
        this.backSureDialogOpenFlag = false;
      },
      customStyle: false,
      autoCancel: false,
      // 返回确认弹窗固定居中展示，避免受跟随模式状态影响出现在左上角
      alignment: DialogAlignment.Center,
      offset: {
        dy: 0,
        dx: 0,
      }
    });
    ResourceCleaner.registerDialogController(this.backSureDialog);
    if (this.backSureDialogOpenFlag && refreshDialog) {
      HiLog.i(TAG, `open backSureDialog: [${this.backSureDialogOpenFlag}, ${refreshDialog}]`);
      this.backSureDialog.open();
    }
  }

  /* instrument ignore next */
  stylusModeChanged() {
    HiLog.i(TAG, `stylusModeChanged ${JSON.stringify(this.stylusMode)}`);
    animateTo({ duration: Constants.EDITOR_SWITCH_OUT_DURATION }, () => {
      this.animOpacity = this.editor.stylusMode ? 0 : 1;
    })
  }

  onStatusChanged() {
    HiLog.i(TAG, `onStatusChanged ${JSON.stringify(this.status)}`);
    if (!this.lastStartFadeoutAnimStatus && this.status.startFadeoutAnim) {
      HiLog.i(TAG, 'start fadeout anim');
      animateTo({ duration: Constants.EDITOR_SWITCH_OUT_DURATION }, () => {
        this.animOpacity = 0;
      })
      this.lastStartFadeoutAnimStatus = true;
    }
  }

  private onFoldChanged(): void {
    HiLog.i(TAG, `onFoldChanged isVerdeFolded: ${DeviceInfo.isVerdeFoldable()}`);
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      App.getInstance().myEditor().closeDialog(true);
      this.backSureDialog?.close();
      this.autoBack(true, true);
    }
  }

  onMosaicViewChange = (display: boolean) => {
    this.isInMosaicView = display;
    HiLog.i(TAG, 'isInMosaicView: ' + this.isInMosaicView);
  };

  aboutToDisappear() {
    HiLog.i(TAG, 'aboutToDisappear');

    setTimeout((): void => {}, Constants.DELAY_QUARTER_SECOND);
    // 注销无障碍模式
    AccessibilityManager.getInstance().unregisterAccessibilityModeListener();
    this.backSureDialog?.close();
    this.downloadFailDialog?.close();

    this.editor.asset.mosaic()
      .listener
      .off('onMosaicViewChange', this.onMosaicViewChange);
    this.breakPoint.unregisterOrientationChange();
    ScreenManager.getInstance().setDownLoadFail(false);
    ScreenManager.getInstance().destroyMainWindow();
    ScreenManager.getInstance().setIsQueryUserLogin(false);
    // 动图落盘为静态照片，图片编辑返回时，不显示状态栏
    if (!this.status?.isInEmbedded) {
      UiUtil.resetStatusAndNavigation();
    }
    App.getInstance().instanceData().onBaseEditorBackPress = undefined;
    /* instrument ignore if */
    if (!App.getInstance().myEditor().isEditorClosed) {
      HiLog.w(TAG, 'close project in aboutToDisappear');
      App.getInstance().myEditor().cancel();
      App.getInstance().myEditor().close((code: number) => {
        HiLog.i(TAG, `project closed(${code}` + '), reason=aboutToDisappear');
      });
    }

    if (this.params) {
      this.params.closeFinish = true;
    }
    appBroadCast.off(BroadCastConstants.EDIT_PHOTO_ENTER, this.onEditPhotoEnterFunc);
    ResourceCleaner.releaseAll();
  }

  public async aboutToAppear() {
    HiLog.i(TAG, `enterEditorPage date is ${FormatUtil.nameByDate(false)}`);
    Service.changeOrientationMode(window.Orientation.LOCKED);
    if (this.showXTStyleDirectly) {
      HiLog.i(TAG, 'init XTStyleAnimation');
    } else {
      // 调色盘展开时退出编辑, isCustomFilterCardShow不会被置成false
      // 进入编辑时置成false, 防止点击个性风格缩略图时调色盘无法展开
      this.isCustomFilterCardShow = false;
    }
    Trace.begin('initPenKit');
    this.initPenKit();
    Trace.end('initPenKit');
    // 注册无障碍模式监听
    AccessibilityManager.getInstance().initAccessibilityModeListener();
    this.currenTime = Date.now();
    this.buildDialog(false);
    this.editor.isSaveVideoDialog = false;
    this.breakPoint.registerOrientationChange();
    let windowStage: window.WindowStage | undefined = App.getInstance().instanceData().windowStage;
    /* instrument ignore if */
    if (!windowStage && !ScreenManager.getInstance().isUIExtensionEnv()) {
      HiLog.e('aboutToAppear', 'windowStage is undefined and not isUIExtensionEnv');
      return;
    }

    // 从MovingPhoto进入编辑时，继承动态照片编辑中的横竖屏状态
    let defaultIsPortrait: boolean | undefined = undefined;
    if (this.params?.entryType !== EditorParams.PARAM_ENTRY_TYPE_DEFAULT &&
    AppStorage.has(SCREEN_ORIENTATION_PORTRAIT)) {
      defaultIsPortrait = AppStorage.get<boolean>(SCREEN_ORIENTATION_PORTRAIT);
      HiLog.i(TAG, `Entry editor from ${this.params?.entryType}, use storage cached isPortrait: ${defaultIsPortrait}`);
    }
    ScreenManager.getInstance().initWindowSize(defaultIsPortrait);

    // app数据esmodule模块化之共享数据，没有更新和重置数据，app.init()重置myProject()数据
    App.getInstance().clearAppData();
    this.editor = App.getInstance().myEditor();
    HiLog.i(TAG, 'aboutToAppear');
    App.getInstance().instanceData().onBaseEditorBackPress = this.onBackPress;
    App.getInstance().editorParams = this.params;

    this.editor.asset.mosaic()
      .listener
      .on('onMosaicViewChange', this.onMosaicViewChange);

    // aboutToAppear中一次更新完UI，避免UI首帧过程多次flushlayout
    this.initUi();

    // entryType为空、undefined或者default时，进行初始化完成操作
    if (!this.params?.entryType || this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_DEFAULT) {
      this.setInitComplete();
    }
    appBroadCast.on(BroadCastConstants.EDIT_PHOTO_ENTER, this.onEditPhotoEnterFunc);
    /* instrument ignore if */
    if (this.params?.position) {
      Trace.begin('checkRemoteResource');
      this.params.position = Constants.FILE_LOCATION_LOCAL as number;
      Trace.end('checkRemoteResource');
    }

    // 等待云图下载
    /* instrument ignore if */
    if (this.params?.position === Constants.FILE_LOCATION_CLOUD) {
      this.buildDownloadFailDialog();
      this.checkRemoteResource();
      HiLog.i(TAG, 'PhotoSource is cloud, Downloading...')
      return;
    }
    this.autoOpen();
  }

  async initPenKit(): Promise<void> {
  }

  /* instrument ignore next */
  onStylusOrAiEntryOnceFinished(): void {
    HiLog.i(TAG, 'onStylusOrAiEntryOnceFinished');
    // 涂鸦显示完成之后处理初始化基础编辑工具组件
    this.setInitComplete();
    // 直接进入涂鸦或AI修图时，涂鸦或AI修图加载完成后再回调发送第一帧加载完成消息
    this.sendFirstFrameLoadCallback();
    if (this.params?.entryType !== EditorParams.PARAM_ENTRY_TYPE_DEFAULT) {
      this.openAnimation(false);
    }
  }

  setInitComplete(): void {
    setTimeout((): void => {
      // 使用setTimeout，减少一次UI首帧刷新的JSAnimateTo
      animateTo({
        duration: Constants.EDITOR_SWITCH_IN_DURATION,
        onFinish: () => {
          App.getInstance().myEditor().isInitComp = true
        }
      }, () => {
        this.animOpacity = 1;
      });
    }, Constants.EDITOR_SWITCH_OUT_DURATION);
  }

  /**
   * 初始化UI
   */
  initUi(): void {
    /* instrument ignore if */
    if (!this.params) {
      HiLog.w(TAG, 'initUi params is null');
      return;
    }
    this.editor.mediaType = MediaType.IMAGE;
    this.editor.tabIndex = TabName.TabCrop;

    this.editor.albumUri = this.params.albumUri;
    let thumbnail: string = this.params.thumbnail;
    HiLog.i(TAG, `initUi thumbnail=${thumbnail},albumUri = ${this.params.albumUri}`);
    // 首帧仅显示黑色背景，提升入场动画响应性能
    this.showEmptyBackground = true;
  }

  public async autoOpen(): Promise<void> {
    /* instrument ignore if */
    if (!this.params) {
      HiLog.e(TAG, 'autoOpen params is null');
      return;
    }
    let asset: photoAccessHelper.PhotoAsset | undefined = this.params.asset;
    /* instrument ignore if */
    if (!asset) {
      HiLog.e(TAG, 'autoOpen asset is null');
      return;
    }
    App.getInstance().myEditor().setImportResultCallback((message: number) => {
      Trace.end('ImageEditorOpenAsset')
      /* instrument ignore if */
      if (App.getInstance().myEditor().isEditorClosed) {
        HiLog.w(TAG, 'import result ignored, project already closed');
        return;
      }
      /* instrument ignore if */
      if (message !== 0) {
        UiUtil.showToast($r('app.string.current_file_cannot_import_imageEdit'), 2000, '15%')
        setTimeout((): void => {
          HiLog.e(TAG, 'import failed');
          let msg: EditorMsg = new EditorMsg(EditorMsg.MSG_ID_ON_EXIT);
          this.onMessageCallback(msg);
        }, 2000)
      } else {
        HiLog.i(TAG, 'on first frame, cost time is ' + (Date.now() - this.currenTime));
        App.getInstance().myEditor()?.releaseDownLoadingLcd();
        this.firstFrameLoaded = true;
        // 初始化对比快照：将“进入编辑页时的画面”缓存为对比基准，避免编辑后对比无差异
        App.getInstance().myEditor().refreshCompareEffectList();
        if (!this.params?.entryType || this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_DEFAULT) {
          this.openAnimation();
        }
      }
      Service.changeOrientationMode(window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    })
    HiLog.i(TAG, 'project.openByUri begin');
    Trace.begin('ImageEditorOpenAsset');
    this.openAsset(asset);
  }

  private sendFirstFrameLoadCallback(): void {
    Trace.begin('sendFirstFrameLoadCallback')
    let msg: EditorMsg = new EditorMsg(EditorMsg.MSG_ID_ON_FIRST_FRAME);
    if (this.params?.position != Constants.FILE_LOCATION_CLOUD) {
      ScreenManager.getInstance().setIsFirstFrame(true);
    }
    this.onMessageCallback(msg);
    Trace.end('sendFirstFrameLoadCallback')
  }

  private async openAnimation(needCallback: boolean = true): Promise<void> {
    Trace.begin('openAnimation')
    if (this.editor.hasSeal && this.editor.hasSealResource) {
      await this.sealOpenAnimation();
    } else {
      this.editor.isOpenAnimation = false;
      // 首次进入大图编辑时兜底同步一次裁剪态，避免出现“图片比裁剪框大”的首帧错位。
      this.editor.asset.switchCropMode();
      this.editor.asset.crops().setCropAreaEnable(false);
      setTimeout((): void => {
        if (this.editor.tabIndex === TabName.TabCrop) {
          this.editor.asset.switchCropMode();
          this.editor.asset.crops().setCropAreaEnable(false);
        }
      }, 80);
      this.isButtonFreeze = false;
    }
    if (this.params !== undefined) {
      this.params.position = Constants.FILE_LOCATION_LOCAL;
    }
    needCallback && this.sendFirstFrameLoadCallback();
    Trace.end('openAnimation')
  }

  private async sealOpenAnimation(): Promise<void> {
    Trace.begin('sealOpenAnimation')
    let isFromMovingSeal = this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_SEAL;
    this.editor.asset.crops().setCropAreaEnable(true);
    // 等待第1帧带水印图渲染完成
    await UiUtil.sleep(100);
    let isEntryCrop = this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_DEFAULT ||
      this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_STYLUS;
    this.editor.asset.crops().sizerAnimation(isEntryCrop, () => {
      this.editor.isOpenAnimation = false;
      if (isEntryCrop) {
        this.editor.asset.crops().setCropAreaEnable(false);
      }
      this.isButtonFreeze = false;
      Trace.end('sealOpenAnimation')
    });
  }

  openAsset(asset: photoAccessHelper.PhotoAsset) {
    this.editor.requestUri = this.params?.uri;
    Trace.begin('isMovingPhoto');
    /* instrument ignore if */
    if (PhotoAssetUtil.isMovingPhoto(asset) && this.editor.requestUri && this.params?.editData) {
      HiLog.i(TAG, `MovingPhoto request editData: ${this.params.editData}`);
      this.editor.editData = this.params.editData;
    }
    Trace.end('isMovingPhoto');
    App.getInstance().myEditor()?.openAsset(asset, this.editor.mediaType, undefined, (timeLine: Timeline) => {
      App.getInstance().myEditor().isLoading = false;
      HiLog.i(TAG, 'project.openByUri end');
      this.isLoading = false;
      this.editor.isPageBackLoading = false;
      App.getInstance().myEditor()?.releaseDownLoadingLcd();
    })
  }

  /* instrument ignore next */
  public async checkRemoteResource() {
    this.isRemoteResource = this.params?.position === Constants.FILE_LOCATION_CLOUD;
    HiLog.i(TAG, `checkRemoteResource is ${this.isRemoteResource}`);
    if (this.isRemoteResource) {
      this.editor.isCloudResource = true;
      ScreenManager.getInstance().setIsFirstFrame(false);
      this.downloadOriginPhoto(this.params?.uri);
      setTimeout((): void => {
        this.sendFirstFrameLoadCallback();
      }, 400)
    } else {
      ScreenManager.getInstance().setIsFirstFrame(true);
      this.autoOpen();
    }
  }

  /* instrument ignore next */
  private downloadOriginPhoto(uri: string | undefined): void {
    HiLog.i(TAG, `downloadOriginPhoto current photo: ${this.params?.uri}`);
    // 图片下载完毕的回调
    this.buildDownloadFinishCallback(uri);
    this.setDownLoadTimeOut();
  }

  /* instrument ignore next */
  private setDownLoadTimeOut(): void {
    clearTimeout(this.downLoadTimeout);
    if (this.params?.position === Constants.FILE_LOCATION_LOCAL) {
      return;
    }
    this.downLoadTimeout = setTimeout((): void => {
      this.downLoad()
    }, 10000)
  }

  /* instrument ignore next */
  private downLoad() {
    if (this.downloadFinishCallback) {
      ScreenManager.getInstance().setDownLoadFail(true)
      if (!this.downloadDialogOpen) {
        this.downloadFailDialog?.open()
        this.isDownloadFinish = false
        this.downloadDialogOpen = true
      }
    }
  }

  /* instrument ignore next */
  buildDownloadFinishCallback(uri: string | undefined): void {
    let startTime: number;
    this.downloadFinishCallback = (err: string = '', downLoadUri: string = '') => {
      HiLog.i(TAG,
        `downloadFinishCallback result is ${downLoadUri}, uri: ${uri}, downloadFinishCallback===undefined:${this.downloadFinishCallback ===
          undefined}`);
      if (this.isDownloadFinish && downLoadUri === uri || downLoadUri !== uri || this.downloadFinishCallback ===
        undefined) {
        // 云图下载成功多次回调场景 及 下载回调uri与当前图片uri不一致场景
        return;
      }
      this.isDownloadFinish = true;
      clearTimeout(this.downLoadTimeout);
      if (err) {
        ScreenManager.getInstance().setDownLoadFail(true);
        if (!this.downloadDialogOpen) {
          this.downloadFailDialog?.open();
          this.isDownloadFinish = false;
          this.downloadDialogOpen = true;
        }
        HiLog.e(TAG, 'downloadOriginPhoto failed')
        return;
      }
      this.editor.isCloudResource = false;
      ScreenManager.getInstance().setDownLoadFail(false);
      HiLog.i(TAG, 'downloadFinishCallback success, photo: ' + uri + ', costTime ' + (Date.now() - startTime));
      let asset: photoAccessHelper.PhotoAsset | undefined = this.params?.asset;
      if (!asset) {
        HiLog.e(TAG, 'openAsset failed photoAsset is undefined');
        return;
      }
      this.cloudOpenAnimation(() => {
        this.status.isPreviewHidden = true;
        this.autoOpen().then(() => {
          clearTimeout(this.downLoadTimeout);
          this.downloadFinishCallback = undefined;
        });
      });
    }
    startTime = Date.now();
  }

  /* instrument ignore next */
  private cloudOpenAnimation(cloudAnimationFinishCallback: () => void) {
    this.editor.getCloudAnimationEnv(this.params?.asset).then(() => {
      if (!this.editor.hasSealResource) {
        cloudAnimationFinishCallback();
        return;
      }
      this.resetOriginImage();
      HiLog.i(TAG, `cloudAnimation  previewRect`);
      animateTo({
        duration: Constants.EDITOR_CLOUD_WATERMARK_DURATION,
        curve: Curve.Sharp,
        onFinish: cloudAnimationFinishCallback,
      }, () => {
        if (this.params) {
        }
      });
    })
  }

  /* instrument ignore next */
  private resetOriginImage() {
    // 相机拍摄的原始图片
    if ((this.editor.editData !== '') && !this.editor.isEdit) {
      let imageSource: image.ImageSource = image.createImageSource(this.editor.fd);
      if (!imageSource || imageSource === undefined) {
        HiLog.e(TAG, `create imageSource Failed, imageFd: ${this.editor.fd}`);
        return;
      }

      let imageInfo: image.ImageInfo = imageSource.getImageInfoSync();
      if (imageInfo) {
        HiLog.i(TAG, `imageInfo:${JSON.stringify(imageInfo)}`);
      } else {
        HiLog.e(TAG, 'Failed to get the image information.');
      }
      imageSource?.release();
    }
  }

  onBackPress: () => boolean = (): boolean => {
    HiLog.i(TAG, 'EditorPage onBackPress');
    if (AppStorage.get('isNonTapGesture')) {
      // 手指还在调色盘点阵上时不响应侧滑返回, 防止侧滑退出编辑时清理undo执行栈与执行XXX滤镜效果抢锁导致appFreeze
      HiLog.i(TAG, 'onBackPress when LongPressGesture or panGesture');
      return true;
    }
    /* instrument ignore if */
    if (this.editor.isOpenFilterCardView) {
      HiLog.i(TAG, 'onBackPress when isOpenFilterCardView');
      return true;
    }
    /* instrument ignore if */
    if (this.editor.isPageBackLoading) {
      HiLog.i(TAG, 'onBackPress when isPageBackLoading');
      return true;
    }
    this.backDeal(true);
    return true;
  }

  backDeal(isLeftBack: boolean = false): void {
    // 返回确认弹窗统一居中，避免工具栏返回触发时被定位到左上角
    this.isDialogCenter = true;
    HiLog.i(TAG, 'backDeal onBackPress isModify :' + (App.getInstance().myEditor().isEdited()) + '  isDialogCenter: ' +
    this.isDialogCenter);
    if (App.getInstance().needConfirmBack() && this.backSureDialog) {
      HiLog.i(TAG, `open backSureDialog, backDeal: ${this.backSureDialog}`);
      this.buildDialog(true);
      this.backSureDialog.open();
      this.backSureDialogOpenFlag = true;
    } else {
      HiLog.i(TAG, 'this.autoBack(false)');
      this.autoBack(false);
    }
  }

  autoBack(isDiscard: boolean, isVdeFoldChanged?: boolean): void {
    HiLog.i(TAG, `autoBack discard=${isDiscard}, isVdeFoldChanged=${isVdeFoldChanged}`);
    clearTimeout(timeFn);
    clearTimeout(this.downLoadTimeout);
    this.downloadFinishCallback = undefined;
    this.editor.isStopScrolling = true;
    if (this.params) {
      this.params.closeFinish = false;
    }
    timeFn = setTimeout((): void => {
      this.editor.isStopScrolling = false;
    }, 50);
    this.autoBackAnimation(isDiscard, isVdeFoldChanged);
  }

  private autoBackCallback(isDiscard: boolean, isVdeFoldChanged?: boolean) {
    let msg: EditorMsg = new EditorMsg(isDiscard ? EditorMsg.MSG_ID_ON_EXIT_DISCARD_MODIFICATION :
    EditorMsg.MSG_ID_ON_EXIT,
      isDiscard ? this.editor.asset.crops()
        .cropRect
        .width() / this.editor.asset.crops()
        .cropRect
        .height() : undefined)

    // verde手机内外切换时调用
    /* instrument ignore if */
    if (isVdeFoldChanged) {
      HiLog.i(TAG, `isVdeFoldChanged (${isVdeFoldChanged}), reason=autoBack`);
      msg.isVdeFoldChanged = isVdeFoldChanged;
    }

    let needAnimationType: boolean = this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_TEXTEDIT ||
      this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_MOSAIC ||
      this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_XT_STYLE ||
      this.params?.entryType === EditorParams.PARAM_ENTRY_TYPE_SEAL;
    HiLog.i(TAG, `need:${needAnimationType},index:${this.params?.entryIndex}`);
    // 从动图裁剪页跳转到文本/马赛克/水印需要模拟执行动画
    /* instrument ignore if */
    if (needAnimationType && this.params?.entryIndex === 1) {
      HiLog.i(TAG, 'execute back animation, 300');
      appBroadCast.emit('backMovingPhotoAnimation');
      setTimeout(() => {
        // 从动图跳转过来，左滑返回时，等待模拟动画结束再执行回调
        this.messageToEditorController(msg);
      }, 250);
      return;
    }
    this.messageToEditorController(msg);
  }

  private messageToEditorController(msg: EditorMsg) {
    appBroadCast.emit('backToMovingPhoto');
    if (this.onMessageCallback(msg)) {
      HiLog.i(TAG, `messageToEditorController, reason=autoBack`);
      this.editor.isPageBackLoading = true;
      App.getInstance().myEditor().cancel();
      App.getInstance().myEditor().close((code: number) => {
        HiLog.i(TAG, `project closed(${code}` + '), reason=autoBack');
      });
    }
  }

  private autoBackAnimation(isDiscard: boolean, isVdeFoldChanged?: boolean) {
    if (this.editor.tabIndex != TabName.TabCrop) {
      this.autoBackCallback(isDiscard, isVdeFoldChanged);
      return;
    }

    HiLog.i(TAG, 'autoBackAnimation: sizerAnimation');
    this.editor.asset.crops().setCropAreaEnable(true);
    // verde手机内外切换
    /* instrument ignore if */
    if (isVdeFoldChanged) {
      this.autoBackCallback(isDiscard, isVdeFoldChanged);
    } else {
      this.editor.asset.crops().sizerAnimation(false, () => {
        this.autoBackCallback(isDiscard, isVdeFoldChanged);
      });
    }
    /* instrument ignore if */
    if (this.editor.hasSeal && this.editor.hasSealResource) {
      HiLog.i(TAG, 'autoBackAnimation: SealAnimation');
      this.editor.asset.DoSealAnimation(true);
      this.editor.asset.crops().isEnableMask = false;
      this.editor.asset.crops().isEnableBlur = false;
    }
  }

  /* instrument ignore next */
  private buildDownloadFailDialog() {
    this.downloadFailDialog = new CustomDialogController({
      builder: AlertDialog({
        content: $r('app.string.download_failed_retry'),
        primaryButton: {
          value: $r('app.string.subtitle_delete_cancel_imageEdit'),
          action: () => {
            this.downloadDialogOpen = false;
            this.autoBack(true);
          },
        },
        secondaryButton: {
          value: $r('app.string.retry_imageEdit'),
          action: () => {
            ScreenManager.getInstance().setDownLoadFail(false);
            // 双击会导致触发两次下载，出现多个弹窗叠加，1000ms内不允许多次下载重试
            if (this.isButtonClick) {
              return;
            }
            this.isButtonClick = true;
            this.downloadDialogOpen = false;
            setTimeout(async (): Promise<void> => {
              this.isButtonClick = false;
              // 下载重试
              if (this.params?.position != undefined) {
                this.params.position = Constants.FILE_LOCATION_LOCAL as number;
              }
              this.checkRemoteResource();
            }, 1000);
          },
        },
      }),
      cancel: () => {
        this.autoBack(true);
      },
      customStyle: false,
      autoCancel: false,
      alignment: DialogAlignment.Center,
      offset: {
        dy: 0,
        dx: 0,
      }
    });
    ResourceCleaner.registerDialogController(this.downloadFailDialog);
  }

  @Builder
  aiImageView() {
  }

  @Builder
  textEditView() {
    TextEditView({
      textCanUndo: this.textCanUndo,
      textCanRedo: this.textCanRedo,
      textCanClickStyle: this.textCanClickStyle,
      isShowInPopup: this.isShowInPopup,
      isShowBorder: this.isShowBorder,
      currentFontColor: this.currentFontColor,
      currentFontSize: this.currentFontSize,
      isFontSizeChange: this.isFontSizeChange,
      previousTextArea: this.previousTextArea,
      realTimeContent: this.realTimeContent,
      keyboardHeight: this.keyboardHeight,
      textInputAreaHide: this.textInputAreaHide,
    })
      .position({ x: 0, y: 0 })
  }

  @Builder
  TextInputEditItem() {
    TextInputEditItem({
      currentFontColor: this.currentFontColor,
      currentFontSize: this.currentFontSize,
      textInputAreaHide: this.textInputAreaHide,
      keyboardHeight: this.keyboardHeight,
      canUndo: this.textCanUndo,
      canRedo: this.textCanRedo,
      previousTextArea: this.previousTextArea,
      realTimeContent: this.realTimeContent,
      isFontSizeChange: this.isFontSizeChange,
      textCanClickStyle: this.textCanClickStyle,
      fromId: 'tab',
    })
      .id('textedit_textInputEditItem')
      .position({
        x: 0,
        y: 0,
      })
  }

  @Builder
  apertureImageView() {
  }

  @Builder
  mosaicView() {
    if (this.isInMosaicView) {
      MosaicView({
        status: $status,
      });
    }
  }

  private isCropOverlayTab(): boolean {
    return this.editor.tabIndex === TabName.TabAdjust || this.editor.tabIndex === TabName.TabTextEdit;
  }

  private isCropOverlayVisible(): boolean {
    return this.isCropOverlayTab() &&
      this.editor.asset.crops().cropRect.width() > 0 &&
      this.editor.asset.crops().cropRect.height() > 0;
  }

  private getCropLeft(): number {
    return this.editor.asset.crops().cropRect.left;
  }

  private getCropTop(): number {
    return this.editor.asset.crops().cropRect.top;
  }

  private getCropWidth(): number {
    return this.editor.asset.crops().cropRect.width();
  }

  private getCropHeight(): number {
    return this.editor.asset.crops().cropRect.height();
  }

  private getCropRight(): number {
    return this.getCropLeft() + this.getCropWidth();
  }

  private getCropBottom(): number {
    return this.getCropTop() + this.getCropHeight();
  }

  private getMaskExtend(): number {
    return 10000;
  }

  private getMaskColor(): string {
    // 框外遮罩需要完全不透出内容
    return '#FF000000';
  }

  @Builder
  editorPage() {
    Stack() {
      if (!this.showEmptyBackground) {
        VideoPlay({
          status: this.status,
          aiView: (() => {
            this.aiImageView();
          }),
          textEditView: () => {
            this.textEditView();
          },
          apertureView: (() => {
            this.apertureImageView();
          }),
          mosaicView: () => {
            this.mosaicView();
          },
        })
          .id('petalClip_VideoPlay')

        if (this.isCropOverlayVisible()) {
          // 仅叠加遮罩和边框，不改动VideoPlay树，降低渲染风险。
          Stack() {
            // 上
            Stack() {}
              .position({ x: -this.getMaskExtend(), y: -this.getMaskExtend() })
              .width(this.getMaskExtend() * 2 + this.getCropRight() + 1)
              .height(this.getMaskExtend() + this.getCropTop())
              .backgroundColor(this.getMaskColor());
            // 下
            Stack() {}
              .position({ x: -this.getMaskExtend(), y: this.getCropBottom() })
              .width(this.getMaskExtend() * 2 + this.getCropRight() + 1)
              .height(this.getMaskExtend())
              .backgroundColor(this.getMaskColor());
            // 左
            Stack() {}
              .position({ x: -this.getMaskExtend(), y: this.getCropTop() })
              .width(this.getMaskExtend() + this.getCropLeft())
              .height(this.getCropHeight())
              .backgroundColor(this.getMaskColor());
            // 右
            Stack() {}
              .position({ x: this.getCropRight(), y: this.getCropTop() })
              .width(this.getMaskExtend())
              .height(this.getCropHeight())
              .backgroundColor(this.getMaskColor());
            // 裁切框
            Stack() {}
              .position({ x: this.getCropLeft(), y: this.getCropTop() })
              .width(this.getCropWidth())
              .height(this.getCropHeight())
              .border({
                width: 2,
                color: '#FFFFFFFF'
              });
          }
          .width('100%')
          .height('100%')
          .hitTestBehavior(HitTestMode.Transparent);
        }

        Column() {
          TopToolbar({
            params: this.params,
            clickBackState: $toolBarBackState,
            firstFrameLoaded: this.firstFrameLoaded,
            onMessageCallback: this.onMessageCallback,
            status: this.status,
            textCanUndo: this.textCanUndo,
            textCanRedo: this.textCanRedo,
            textCanClickStyle: this.textCanClickStyle,
            keyboardHeight: this.keyboardHeight,
            textInputAreaHide: this.textInputAreaHide,
            isShowInPopup: this.isShowInPopup,
          })
            .enabled(this.originalColorMode === 0 ? true : false)
            .backgroundColor(AppColor.black((this.editor.tabIndex === TabName.TabCrop) ? 0 : 0.8))
          Flex({
            direction: this.isPortrait ? FlexDirection.Column : FlexDirection.Row,
          }) {
            ScreenTool({
              originalColorMode: $originalColorMode
            })
              .id('editor_page_operation_area')
              .layoutWeight(1)
              .visibility(this.isFromMovingPhoto && this.onBackProgress ? Visibility.Hidden : Visibility.Visible)
              .hitTestBehavior((this.editor.asset.textEdit().isInTextTab || this.isInMosaicView ||
              this.editor.apertureMode) && this.originalColorMode === 0 ?
              HitTestMode.Transparent : HitTestMode.Default)
              .onAreaChange((_: Area, newValue: Area) => {
                HiLog.i(TAG, `ScreenTool onAreaChange new width ${newValue.width} height ${newValue.height}`);
                this.editor.screenToolArea = newValue;
                // 视频可操作区域，上下左右留白lpx(20)
                ScreenManager.getInstance().getStatusBarHeight();
                App.getInstance().myEditor().previewStarter.onOperationAreaChanged(newValue);
                if (this.isSplitMode || this.isFloatMode || this.curMirrorMode !== UiUtil.isMirrorMode()) {
                  HiLog.i(TAG, `isSplitMode:${this.isSplitMode},isFloatMode:${this.isFloatMode}, resize`);
                  this.curMirrorMode = UiUtil.isMirrorMode();
                  appBroadCast.emit('refreshTextEditView');
                }
              }) //占位，留空，后面留给适配操控组件
            BottomToolbar({
              params: this.params,
              status: this.status,
              firstFrameLoaded: this.firstFrameLoaded,
              isStylusOrAiEntryOnceFinished: $isStylusOrAiEntryOnceFinished,
              clickBackState: $toolBarBackState,
              textCanUndo: this.textCanUndo,
              textCanRedo: this.textCanRedo,
              textCanClickStyle: this.textCanClickStyle,
              isShowInPopup: this.isShowInPopup,
              isShowBorder: this.isShowBorder,
              currentFontColor: this.currentFontColor,
              currentFontSize: this.currentFontSize,
              isFontSizeChange: this.isFontSizeChange,
              textInputAreaHide: this.textInputAreaHide,
              isFromMovingPhoto: this.isFromMovingPhoto,
              onBackProgress: this.onBackProgress
            })
              .visibility(this.editor.rotateMode ? (Visibility.Hidden) :
                  this.editor.isQueryExifFinished ? Visibility.Visible : Visibility.Hidden)
              .enabled(this.originalColorMode === 0 && this.isFirstFrameStatue)
              .opacity((this.isFirstFrameStatue ? 1 : 0.4))
              .backgroundColor(AppColor.black((this.editor.tabIndex === TabName.TabCrop) ?
                0 : 0.8))
              .onAreaChange((oldValue, newValue)=>{
                HiLog.i(TAG, `BottomToolbar onAreaChange: ${oldValue.width} ${oldValue.height}, ${newValue.width} ${newValue.height}`);
              })
          }.layoutWeight(1)
          // 及时更新OperationArea，以便计算正确的预览区域，解决横竖屏旋转动画卡顿问题
          .onSizeChange((_: SizeOptions, newValue: SizeOptions) => {
            App.getInstance().myEditor().previewStarter.updatePreview(false);
          })
        }
        .visibility(this.editor.stylusMode ? Visibility.Hidden : Visibility.Visible)
        .opacity(this.animOpacity)
        .hitTestBehavior(this.editor.asset.textEdit().isInTextTab || this.isInMosaicView ||
        this.editor.apertureMode ?
        HitTestMode.Transparent : HitTestMode.Default)
        .id('editor_page_global_area')

        // 云图下载loading
        DownLoading({
          params: this.params,
          tab: this.editor.tabIndex,
          previewRect: this.previewRect,
        })

        LoginStatusLoading({
          params: this.params,
        })

        Column() {
        }
        .width('100%')
        .height('100%')
        .visibility(this.textInputAreaHide ? Visibility.Visible : Visibility.Hidden)
        .onClick(() => {
          HiLog.i(TAG, 'text_input_edit_background onClick');
          appBroadCast.emit('clickTextInputMask');
          this.textInputAreaHide = false;
        })
        .id('text_input_edit_background')
        .backgroundColor($r('sys.color.black'))
        .opacity(0.5)

        if (this.editor.asset.textEdit().isInTextTab) {
          this.TextInputEditItem();
        }

        if (this.editor.hasCustomFilterStackCardViewInitiated) {
        }

      }
    }
    .backgroundColor(Color.Black)
    .onAppear((): void => {
      HiLog.i(TAG, 'onAppear');
      UiUtil.isSystemStatus();
      setTimeout((): void => {
        // 空背景被挂载后，等待一帧时间再切换到显示真实内容
        this.showEmptyBackground = false;
      }, 16);
    })
    .height('100%')
    .width('100%')
  }

  build() {
    Stack() {
      this.editorPage();
      if (this.editor.stylusMode) {
      }
    }
    .keyboardShortcut('s', [ModifierKey.CTRL], (): void => {
      HiLog.i(TAG, 'keyboardShortcut ctrl + s');
      appBroadCast.emit(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_SAVE_OVERRIDE);
    })
    .keyboardShortcut('s', [ModifierKey.CTRL, ModifierKey.SHIFT], (): void => {
      HiLog.i(TAG, 'keyboardShortcut ctrl + shift + s');
      appBroadCast.emit(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_SAVE_AS);
    })
    .keyboardShortcut('z', [ModifierKey.CTRL], (): void => {
      HiLog.i(TAG, 'keyboardShortcut ctrl + z');
      appBroadCast.emit(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_UNDO);
    })
    .keyboardShortcut('y', [ModifierKey.CTRL], (): void => {
      HiLog.i(TAG, 'keyboardShortcut ctrl + y');
      appBroadCast.emit(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_REDO);
    })
    .keyboardShortcut('z', [ModifierKey.CTRL, ModifierKey.SHIFT], (): void => {
      HiLog.i(TAG, 'keyboardShortcut ctrl + shift + z');
      appBroadCast.emit(BroadCastConstants.PHONE_EDIT_PAGE_PRESS_REDO);
    })
  }
}