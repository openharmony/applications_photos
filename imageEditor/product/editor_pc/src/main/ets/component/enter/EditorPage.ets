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
  APP_STORAGE_KEY_DOWNLOAD_PROGRESS,
  CANVAS_RECT,
  DOWNLOAD_STATUS,
  FIRST_FRAME_STATUS,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY
} from '@oh-image-editor/editor-common/src/main/ets/common/const'
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
import { ScreenTool } from '../common/ScreenTool'
import { RightMenuTool } from '../menu/RightMenuTool'
import { TopNavBar } from '../menu/TopNavBar'
import emitter from '@ohos.events.emitter';
import common from '@ohos.app.ability.common';
import { AlertDialog } from '@ohos.arkui.advanced.Dialog'
import { EditorPixelMapManager } from '@oh-image-editor/editor-common/src/main/ets/common/EditorPixelMapManager'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { image } from '@kit.ImageKit'
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants'
import { Service } from '@oh-image-editor/editor-common/src/main/ets/common/util/Service';
import pointer from '@ohos.multimodalInput.pointer';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast'
import { DownLoading } from '@oh-image-editor/editor-common/src/main/ets/common/components/DownLoading'
import settings from '@ohos.settings';

const TAG = 'PcEditorPage';

@Component
export struct EditorMain {
  // 外部传入参数
  @State params: EditorParams | undefined = undefined // 工程初始化参数
  @ObjectLink @Watch('onStatusChanged') status: EditorStatus // 编辑组件界面状态控制
  // 内部参数
  @State app: App = App.getInstance();
  @State h: number = 0;
  @State w: number = 0;
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State isLoading: boolean = true;
  @State @Watch('backDeal') toolBarBackState: boolean = false;
  @State originalColorMode: number = 0;
  @State showEmptyBackground: boolean = false;
  @StorageProp(FIRST_FRAME_STATUS) isFirstFrameStatue: boolean = ScreenManager.getInstance().getIsFirstFrame();
  // 直接进入涂鸦是否第一次加载完成
  @State @Watch('onStylusOrAiEntryOnceFinished') isStylusOrAiEntryOnceFinished: boolean = false;
  @StorageLink(APP_STORAGE_KEY_DOWNLOAD_PROGRESS) @Watch('refreshTime') downloadProgress: number = 0;
  @State animOpacity: number = 0;
  private terminateId: number = Constants.PREPARE_TERMINATE_EVENT_ID;
  private initPenKitTimer?: number = undefined;
  private isWindowClose: boolean = false;
  private lastStartFadeoutAnimStatus: boolean = false;
  private downloadFailDialog: CustomDialogController | undefined = undefined;
  private downLoadTimeout: number = -1;
  private downloadFinishCallback: Function | undefined = undefined;
  private isRemoteResource: boolean = false;
  private isButtonClick: boolean = false;
  private downloadDialogOpen: boolean = false;
  private isDownloadFinish: boolean = false;
  private isDialogOpen: boolean = false;
  // private shortcutController: ShortcutController = ShortcutManager.getInstance();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  onMessageCallback = (msg: EditorMsg): boolean => { // 消息回调函数
    return false;
  }

  refreshTime() {
    this.setDownLoadTimeOut();
  }

  private onEditPhotoEnterFunc: Function = (): void => {
    HiLog.i(TAG, `autoBack when enter EditorPage`);
    this.autoBack(true);
  };

  onStatusChanged() {
    HiLog.i(TAG, `onStatusChanged ${JSON.stringify(this.status)}`);
    if (!this.lastStartFadeoutAnimStatus && this.status.startFadeoutAnim) {
      HiLog.i(TAG, 'start fadeout anim');
      this.lastStartFadeoutAnimStatus = true;
    }
  }

  aboutToDisappear() {
    HiLog.i(TAG, 'aboutToDisappear');
    if (this.initPenKitTimer !== undefined) {
      clearTimeout(this.initPenKitTimer);
      this.initPenKitTimer = undefined;
    }
    setTimeout((): void => {}, Constants.DELAY_QUARTER_SECOND);
    App.getInstance().instanceData().onBaseEditorBackPress = undefined;
    ScreenManager.getInstance().setDownLoadFail(false);
    this.downloadFailDialog?.close();
    //还原
    UiUtil.setWindowSystemBarProperties(false, getContext(this))
    if (!App.getInstance().myEditor().isEditorClosed) {
      HiLog.w(TAG, 'close project in aboutToDisappear');
      App.getInstance().myEditor().cancel();
      App.getInstance().myEditor().close((code: number) => {
        HiLog.i(TAG, `project closed(${code}` + '), reason=aboutToDisappear');
      });
    }
    App.getInstance().myEditor().editModified = false;
    emitter.off(this.terminateId);
    this.removeKeyboardInputListener();
    if (this.params) {
      this.params.closeFinish = true;
    }
    this.appBroadCast.off(BroadCastConstants.EDIT_PHOTO_ENTER, this.onEditPhotoEnterFunc);
    Service.changeMouseShape(pointer.PointerStyle.DEFAULT)
  }

  public async aboutToAppear() {
    HiLog.i(TAG, 'aboutToAppear');
    if (this.initPenKitTimer !== undefined) {
      clearTimeout(this.initPenKitTimer);
      this.initPenKitTimer = undefined;
    }
    this.initPenKitTimer = setTimeout((): void => {
      this.initPenKit();
    }, 500);
    // app数据esmodule模块化之共享数据，没有更新和重置数据，app.init()重置myProject()数据
    App.getInstance().clearAppData();
    this.editor = App.getInstance().myEditor();
    ScreenManager.getInstance().initWindowSize(true);
    App.getInstance().instanceData().onBaseEditorBackPress = this.onBackPress;
    this.addKeyboardInputListener();
    // aboutToAppear中一次更新完UI，避免UI首帧过程多次flushlayout
    this.initUi();
    UiUtil.setWindowSystemBarProperties(true, getContext(this))
    let innerEvent: emitter.InnerEvent = {
      eventId: this.terminateId,
    };
    emitter.on(innerEvent, this.emitterCallback);
    this.appBroadCast.on(BroadCastConstants.EDIT_PHOTO_ENTER, this.onEditPhotoEnterFunc);


    // if (this.params?.position) {
    //   this.params.position = await CloudDriveUtil.isRemoteResource(this.params?.uri) ? Constants.FILE_LOCATION_CLOUD :
    //     Constants.FILE_LOCATION_LOCAL as number;
    // }
    // 等待云图下载
    if (this.params?.position === Constants.FILE_LOCATION_CLOUD) {
      this.buildDownloadFailDialog();
      this.checkRemoteResource();
      HiLog.i(TAG, 'PhotoSource is cloud, Downloading...')
      return;
    }
    this.autoOpen();
  }

  emitterCallback: () => void = (): void => {
    const editor = App.getInstance().myEditor();
    if (editor.isEdited() || editor.stylusModifying) {
      // 打开弹窗
      this.isWindowClose = true;
      if (!this.isDialogOpen) {
        this.isDialogOpen = true;
      }
    } else {
      // 直接关闭窗口
      let context = getContext(this) as common.UIAbilityContext;
      context.terminateSelf();
    }
  }

  async initPenKit(): Promise<void> {
  }

  /**
   * 初始化UI
   */
  initUi(): void {
    if (!this.params) {
      HiLog.w(TAG, 'initUi params is null');
      return;
    }
    this.editor.mediaType = MediaType.IMAGE;
    this.editor.tabIndex = TabName.TabCrop;

    this.editor.albumUri = this.params.albumUri;
    let thumbnail = this.params.thumbnail;
    HiLog.i(TAG, `initUi thumbnail=${thumbnail},albumUri = ${this.params.albumUri}`);
    // 首帧仅显示黑色背景，提升入场动画响应性能
    this.showEmptyBackground = true;
  }

  public async autoOpen(): Promise<void> {
    if (!this.params) {
      HiLog.w(TAG, 'autoOpen params is null');
      return;
    }
    let asset: photoAccessHelper.PhotoAsset | undefined = this.params.asset;
    if (!asset) {
      HiLog.w(TAG, 'autoOpen asset is null');
      return;
    }
    App.getInstance().myEditor().setImportResultCallback((message: number) => {
      if (App.getInstance().myEditor().isEditorClosed) {
        HiLog.w(TAG, 'import result ignored, project already closed');
        return;
      }
      if (message !== 0) {
        UiUtil.showToast($r('app.string.current_file_cannot_import_imageEdit'), 2000, '15%')
        setTimeout((): void => {
          HiLog.e(TAG, 'import failed');
          let msg = new EditorMsg(EditorMsg.MSG_ID_ON_EXIT);
          this.onMessageCallback(msg);
        }, 2000)
      } else {
        HiLog.i(TAG, 'on first frame');
        App.getInstance().myEditor()?.releaseDownLoadingLcd();
        ScreenManager.getInstance().setIsFirstFrame(true);
        if (this.params !== undefined) {
          this.params.position = Constants.FILE_LOCATION_LOCAL;
        }
        let msg = new EditorMsg(EditorMsg.MSG_ID_ON_FIRST_FRAME);
        this.onMessageCallback(msg);
      }
    })

    HiLog.i(TAG, 'project.openByAsset begin');
    App.getInstance().myEditor()?.openAsset(asset, this.editor.mediaType, undefined, (timeLine: Timeline) => {
      App.getInstance().myEditor().isLoading = false;
      HiLog.i(TAG, 'project.openByAsset end');
      this.isLoading = false;
      this.editor.isPageBackLoading = false;
      App.getInstance().myEditor()?.releaseDownLoadingLcd();
      if (!this.params) {
        HiLog.w(TAG, 'autoOpen params is null');
        return;
      }
      let mediaType = this.params.mediaType;
      if (!mediaType) {
        HiLog.w(TAG, 'autoOpen mediaType is null');
        return;
      }
    })
  }

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

  private downloadOriginPhoto(uri: string | undefined): void {
    HiLog.i(TAG, `downloadOriginPhoto current photo: ${this.params?.uri}`);
    this.buildDownloadFinishCallback(uri);
    this.setDownLoadTimeOut();
  }

  private setDownLoadTimeOut(): void {
    clearTimeout(this.downLoadTimeout);
    this.downLoadTimeout = setTimeout((): void => {
      if (this.downloadFinishCallback) {
        ScreenManager.getInstance().setDownLoadFail(true);
        if (!this.downloadDialogOpen) {
          this.downloadFailDialog?.open();
          this.isDownloadFinish = false;
          this.downloadDialogOpen = true;
        }
      }
    }, 10000)
  }

  private buildDownloadFinishCallback(uri: string | undefined) {
    let startTime: number;
    // 图片下载完毕的回调
    this.downloadFinishCallback = (err: string = '', downLoadUri: string = '') => {
      HiLog.i(TAG,
        `downloadFinishCallback result is ${downLoadUri}, uri: ${uri}, downloadFinishCallback===undefined:${this.downloadFinishCallback ===
          undefined}`);
      if (this.isDownloadFinish && downLoadUri === uri || downLoadUri !== uri || this.downloadFinishCallback ===
        undefined) {
        // 云图下载成功会执行3次回调，这里只执行1次
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
      this.autoOpen().then(() => {
        clearTimeout(this.downLoadTimeout);
        this.downloadFinishCallback = undefined;
      });
    }
    startTime = Date.now();
  }

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
              // if (this.params?.position != undefined) {
              //   this.params.position = await CloudDriveUtil.isRemoteResource(this.params?.uri) ?
              //   Constants.FILE_LOCATION_CLOUD : Constants.FILE_LOCATION_LOCAL as number;
              // }
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
  }

  onStylusOrAiEntryOnceFinished(): void {
    // 涂鸦显示完成之后处理初始化基础编辑工具组件
    this.setInitComplete();
    this.status.isPreviewHidden = this.params?.entryType !== EditorParams.PARAM_ENTRY_TYPE_DEFAULT;
    // 直接进入涂鸦或AI修图时，涂鸦或AI修图加载完成后再回调发送第一帧加载完成消息
    this.sendFirstFrameLoadCallback();
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

  private sendFirstFrameLoadCallback(): void {
    let msg: EditorMsg = new EditorMsg(EditorMsg.MSG_ID_ON_FIRST_FRAME);
    if (this.params?.position != Constants.FILE_LOCATION_CLOUD) {
      ScreenManager.getInstance().setIsFirstFrame(true);
    }
    this.onMessageCallback(msg);
  }

  onBackPress: () => boolean = (): boolean => {
    HiLog.i(TAG, 'onBackPress');
    if (this.editor.isPageBackLoading) {
      HiLog.i(TAG, 'onBackPress when isPageBackLoading');
      return true;
    }
    this.backDeal();
    return true;
  }
  private shortcutUid: number = -1;

  private addKeyboardInputListener(): void {
    this.getUIContext()?.getFocusController()?.clearFocus();
    // this.shortcutUid =
    //   this.shortcutController.addListener([MultimodalInputManager.KEY_CODE_KEYBOARD_ESC], this.onBackPress);
  }

  private removeKeyboardInputListener(): void {
    // this.shortcutController.removeListener([MultimodalInputManager.KEY_CODE_KEYBOARD_ESC], this.shortcutUid);
  }

  enterShortCut() {
    HiLog.i(TAG, 'enterShortCut is not handle');
  }

  backDeal(): void {
    HiLog.i(TAG, 'onBackPress isModify :' + App.getInstance().myEditor().isEdited());
    if (App.getInstance().myEditor().isEdited()) {
      HiLog.i(TAG, 'back button clicked show dialog');
      this.isWindowClose = false;
      Service.changeMouseShape(pointer.PointerStyle.DEFAULT);
    } else {
      this.autoBack(false);
    }
  }

  autoBack(isDiscard: boolean): void {
    HiLog.i(TAG, `autoBack discard=${isDiscard}`);
    clearTimeout(this.downLoadTimeout);
    this.downloadFinishCallback = undefined;
    if (this.params) {
      this.params.closeFinish = false;
    }
    if (this.isWindowClose) {
      let context = getContext(this) as common.UIAbilityContext;
      context.terminateSelf();
      return;
    }
    let msg = new EditorMsg(isDiscard ? EditorMsg.MSG_ID_ON_EXIT_DISCARD_MODIFICATION : EditorMsg.MSG_ID_ON_EXIT,
      isDiscard ? this.editor.asset.crops()
        .cropRect
        .width() / this.editor.asset.crops()
        .cropRect
        .height() : undefined)
    if (this.onMessageCallback(msg)) {
      this.editor.isPageBackLoading = true;
      App.getInstance().myEditor().cancel();
      App.getInstance().myEditor().close((code: number) => {
        HiLog.i(TAG, `project closed(${code}` + '), reason=autoBack');
      });
    }
  }

  build() {
    Stack() {
      if (!this.showEmptyBackground) {
        Column() {
          Flex({ direction: FlexDirection.Column }) {
            TopNavBar({
              clickBackState: $toolBarBackState,
              onMessageCallback: this.onMessageCallback,
            })
              .enabled(this.originalColorMode === 0 ? true : false)
            Row() {
              Column() {
                ScreenTool({
                  isLoading: this.isLoading,
                  status: this.status,
                  originalColorMode: $originalColorMode,
                })
                  .id('editor_page_operation_area')
                  .layoutWeight(1)
                  .onAreaChange((_: Area, newValue: Area) => {
                    App.getInstance().myEditor().previewStarter.onOperationAreaChanged(newValue);
                    App.getInstance().myEditor().timeline = App.getInstance().myEditor().previewStarter.timeline;
                  })
              }
              .layoutWeight(1)
              .onAreaChange((_: Area, newVal: Area) => {
                this.editor.containerWidth = newVal.width as number;
              })

              Column() {
                RightMenuTool()
                  .enabled(this.originalColorMode === 0 ? true : false)
              }.height(this.h).width($r('app.float.right_bar_width'))
            }
            .layoutWeight(1)
            .onAreaChange((_: Area, newVal: Area) => {
              this.h = newVal.height as number;
            })
          }.height('100%').width('100%')
        }
        .id('editor_page_global_area')

        // 云图下载loading
        DownLoading({
          params: this.params,
          tab: this.editor.tabIndex,
        })
      }
      if (this.editor.stylusMode) {
      }
    }
    .onAppear((): void => {
      HiLog.i(TAG, 'onAppear');
      setTimeout((): void => {
        // 空背景被挂载后，等待一帧时间再切换到显示真实内容
        HiLog.d(TAG, 'onAppear, start showing content');
        this.showEmptyBackground = false;
      }, 16);
    })
    .backgroundColor(Color.Black)
    .height('100%')
    .width('100%')
    .keyboardShortcut('s', [ModifierKey.CTRL], (): void => {
      HiLog.i(TAG, 'index keyboardShortcut ctrl + s');
      this.appBroadCast.emit(BroadCastConstants.SAVE_IMAGE, []);
    })
    .keyboardShortcut('y', [ModifierKey.CTRL], (): void => {
      HiLog.i(TAG, 'index keyboardShortcut ctrl + y');
      this.appBroadCast.emit(BroadCastConstants.EDIT_REDO, []);
    })
    .keyboardShortcut('z', [ModifierKey.CTRL], (): void => {
      HiLog.i(TAG, 'index keyboardShortcut ctrl + z');
      this.appBroadCast.emit(BroadCastConstants.EDIT_UNDO, []);
    })
    .keyboardShortcut('z', [ModifierKey.CTRL, ModifierKey.SHIFT], (): void => {
      HiLog.i(TAG, 'index keyboardShortcut ctrl + shift + z');
      this.appBroadCast.emit(BroadCastConstants.EDIT_REDO, []);
    })
    .keyboardShortcut('s', [ModifierKey.CTRL, ModifierKey.SHIFT], (): void => {
      HiLog.i(TAG, 'index keyboardShortcut ctrl + shift + s');
      this.appBroadCast.emit(BroadCastConstants.SAVE_AS_IMAGE, []);
    })
    .keyboardShortcut(FunctionKey.DPAD_UP, [ModifierKey.SHIFT], (): void => {
      HiLog.i(TAG, 'index keyboardShortcut shift + ↑');
      this.appBroadCast.emit(BroadCastConstants.CROP_HEIGHT_ADD, []);
    })
    .keyboardShortcut(FunctionKey.DPAD_DOWN, [ModifierKey.SHIFT], (): void => {
      HiLog.i(TAG, 'index keyboardShortcut shift + ↓');
      this.appBroadCast.emit(BroadCastConstants.CROP_HEIGHT_SUB, []);
    })
    .keyboardShortcut(FunctionKey.DPAD_LEFT, [ModifierKey.SHIFT], (): void => {
      HiLog.i(TAG, 'index keyboardShortcut shift + ←');
      this.appBroadCast.emit(BroadCastConstants.CROP_WIDTH_SUB, []);
    })
    .keyboardShortcut(FunctionKey.DPAD_RIGHT, [ModifierKey.SHIFT], (): void => {
      HiLog.i(TAG, 'index keyboardShortcut shift + →');
      this.appBroadCast.emit(BroadCastConstants.CROP_WIDTH_ADD, []);
    })
  }
}
