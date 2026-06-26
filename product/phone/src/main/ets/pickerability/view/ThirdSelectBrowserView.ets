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
import lazy {
  ImageEditorMain,
  ImageEditorMsg
} from 'browsercommonphone';
import lazy { EditorController } from 'browsercommonphone/src/main/ets/controller/EditorController';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { ThirdSelectPhotoBrowserBase } from '@ohos/thirdselect/src/main/ets/default/view/ThirdSelectPhotoBrowserBase';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy window from '@ohos.window';
import lazy { ThirdSelectGridController, } from '@ohos/thirdselect/src/main/ets/default/view/ThirdSelectPhotoGridBase';
import lazy { ReplaceUriManager } from '@ohos/common/src/main/ets/default/model/ReplaceUriManager';

/* instrument ignore file */
const TAG: string = 'ThirdSelectBrowserView';

@Component
export struct ThirdSelectBrowserView {
  replaceUriManager: ReplaceUriManager | undefined = undefined;
  @State editorController: EditorController = new EditorController();
  @State isRunningAnimation: boolean = false;
  private broadCast: BroadCast = new BroadCast();
  @Prop private pageStatus: boolean = false;
  @State @Watch('updateAnimationStatus') browserController: BrowserController = new BrowserController(true);
  @State private thirdSelectController: ThirdSelectGridController = new ThirdSelectGridController();

  aboutToAppear(): void {
    this.editorController.init(this.broadCast, window.Orientation.AUTO_ROTATION_UNSPECIFIED);
    this.editorController.updateIsFormPickerToEditor(true);
  }

  aboutToDisappear(): void {
    this.editorController.release();
    this.editorController.updateIsFormPickerToEditor(false);
  }

  onBackPress(): boolean | void {
    if (this.editorController.onBackPress()) {
      return true;
    }
  }

  /**
   * @Watch browserController
   */
  private updateAnimationStatus(): void {
    this.isRunningAnimation = this.browserController.isAnimating;
  }

  private updateshowClose(msg: ImageEditorMsg): void {
    let msgId: string | undefined = msg?.id;
    if (msgId === ImageEditorMsg.MSG_ID_ON_FIRST_FRAME) {
      this.broadCast?.emit(Constants.UPDATE_SHEETCONTAINER_SHOECLOSE, [false]);
    }
    if (msgId === ImageEditorMsg.MSG_ID_ON_EXIT ||
      msgId === ImageEditorMsg.MSG_ID_ON_EXIT_DISCARD_MODIFICATION) {
      this.broadCast?.emit(Constants.UPDATE_SHEETCONTAINER_SHOECLOSE, [true]);
    }
  }

  @Builder
  buildImageEditor() {
    // 图片编辑组件
    Column() {
      ImageEditorMain({
        params: this.editorController.imageEditorParams,
        status: this.editorController.imageEditorStatus,
        onMessageCallback: (msg: ImageEditorMsg) => {
          Log.info(TAG, 'onMessageCallback ImageEditorMain');
          // 规避屏幕朗读打开后，锁屏再解锁，错误聚焦到关闭按钮的问题
          this.updateshowClose(msg);
          return this.editorController.onEditorMessageCallback(msg);
        }
      })
    }
  }

  @Builder
  buildMovingEditor() {
    // 视频编辑组件
    Column() {
    }
  }

  build() {
    Stack() {

      Stack() {
      }.width('100%')
      .height('100%')
      .bindContentCover($$this.editorController.isImageEditorShown, this.buildImageEditor(), {
        modalTransition: ModalTransition.DEFAULT,
        transition: TransitionEffect.asymmetric(TransitionEffect.move(TransitionEdge.END),
          TransitionEffect.move(TransitionEdge.END)).animation({ duration: 100, curve: Curve.LinearOutSlowIn }),
        onWillDismiss: ((dismissContentCoverAction: DismissContentCoverAction) => {
          this.editorController.onBackPress();
        }),
      })

      Stack() {
      }.width('100%')
      .height('100%')
      .bindContentCover($$this.editorController.isMovingPhotoEditorShown, this.buildMovingEditor(), {
        transition: TransitionEffect.asymmetric(TransitionEffect.move(TransitionEdge.END),
          TransitionEffect.move(TransitionEdge.END)).animation({ duration: 100, curve: Curve.LinearOutSlowIn }),
        onWillDismiss: ((dismissContentCoverAction: DismissContentCoverAction) => {
          this.editorController.onBackPress();
        }),
      })

      ThirdSelectPhotoBrowserBase({
        replaceUriManager: this.replaceUriManager,
        pageStatus: this.pageStatus,
        geometryTransitionEnable: this.browserController.geometryTransitionEnable,
        isRunningAnimation: $isRunningAnimation,
        browserController: this.browserController,
        canEditVideo: true,
        onEnterEdit: (item: MediaItem, albumUri: string, isRemoteSource: boolean) => {
          if (isRemoteSource) {
            this.editorController.imageEditorParams.position = UserFileManagerAccess.FILE_LOCATION_CLOUD;
          }
          this.editorController.showEditor(albumUri, item);
        },
        thirdSelectController: this.thirdSelectController,
      })
        .visibility(this.editorController.isBrowserShown ? Visibility.Visible : Visibility.Hidden)
    }
    .hitTestBehavior(this.editorController.isInSwitchAnimation ? HitTestMode.Block : HitTestMode.Default)
    .width('100%')
    .height('100%')
    .transition(TransitionEffect.asymmetric(TransitionEffect.opacity(0.99), TransitionEffect.opacity(0.99)))
  }
}