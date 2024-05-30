/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { PhotoEditMode } from '../base/PhotoEditType';
import {
  BigDataConstants,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  Constants,
  Log,
  ReportToBigDataUtil,
  UiUtil,
  WindowUtil
} from '@ohos/common';
import { PhotoEditorManager } from '../PhotoEditorManager';
import { PhotoEditCrop } from '../crop/PhotoEditCrop';
import router from '@ohos.router';
import { Router } from '@ohos.arkui.UIContext';

const TAG: string = 'editor_TitleBar';

@Component
export struct TitleBar {
  @Consume isRedo: boolean;
  @Consume isUndo: boolean;
  @State name: Resource | undefined = undefined;
  @State isPcStyle: boolean = true;
  @Consume('selected') selectedMode: number;
  @Consume broadCast: BroadCast;
  @Consume isVerticalScreen: boolean;
  @State isImmersive: boolean = false;
  @Consume editorManager: PhotoEditorManager;
  @Consume cropEdit: PhotoEditCrop;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private newImageId: number = -1;
  private immersiveClick: Function = (): void => {};
  private onBackAfterSaveComplete: Function = (): void => {};

  saveAsNewCallback() {
    Log.debug(TAG, 'saveAsNewCallback called');
    interface Msg {
      saveType: string;
    }
    let msg: Msg = {
      saveType: BigDataConstants.SAVE_AS_NEW
    }
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_EDIT_SAVE_ID, msg);
    PhotoEditorManager.getInstance().save(false, (uri: string): void => this.saveImageCallback(uri));
  }

  replaceOriginalCallback(): void {
    Log.debug(TAG, 'replaceOriginalCallback called');
    interface Msg {
      saveType: string;
    }
    let msg: Msg = {
      saveType: BigDataConstants.SAVE_REPLACE
    }
    ReportToBigDataUtil.report(BigDataConstants.PHOTO_EDIT_SAVE_ID, msg);
    PhotoEditorManager.getInstance().save(true, (uri: string): void => this.saveImageCallback(uri));
  }

  discardCallback() {
    Log.debug(TAG, 'discardCallback called');
  }

  saveImageCallback(uri: string) {
    Log.debug(TAG, `saveImageCallback uri = ${uri}`);
    if (uri == undefined || uri == null || uri.length == 0) {
      this.broadCast.emit(BroadCastConstants.EXIT_SAVE_PROGRESS_CLOSE, []);
      UiUtil.showToast($r('app.string.edit_photo_save_fail'));
      router.back();
    } else {
      AppStorage.setOrCreate(BroadCastConstants.PHOTO_EDIT_SAVE_URI, uri);
      this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, Constants.PHOTO_TRANSITION_EDIT]);
    }
  }

  backAfterSaveComplete() {
    Log.debug(TAG, `backAfterSaveComplete called`);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, Constants.PHOTO_TRANSITION_EDIT]);
    this.broadCast.emit(BroadCastConstants.EXIT_SAVE_PROGRESS_CLOSE, []);
    AppStorage.setOrCreate(BroadCastConstants.PHOTO_EDIT_SAVE_URI, '');
    router.back();
  }

  aboutToAppear() {
    this.immersiveClick = (isImmersive: boolean): void => this.immersive(isImmersive);
    this.broadCast.on(Constants.IS_IMMERSIVE, this.immersiveClick);
    this.onBackAfterSaveComplete = (): void => this.backAfterSaveComplete();
    this.appBroadCast.on(BroadCastConstants.PHOTO_EDIT_SAVE_COMPLETE, this.onBackAfterSaveComplete);
  }

  aboutToDisappear() {
    this.broadCast.off(Constants.IS_IMMERSIVE, this.immersiveClick);
    this.appBroadCast.off(BroadCastConstants.PHOTO_EDIT_SAVE_COMPLETE, this.onBackAfterSaveComplete);
  }

  immersive(isImmersive: boolean) {
    this.isImmersive = isImmersive;
  }

  onBackClicked(): void {
    Log.debug(TAG, 'back clicked');
    if (this.isRedo || this.isUndo) {
      this.broadCast.emit(BroadCastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG, [(): void => this.discardCallback()]);
    } else if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP && this.cropEdit.couldReset()) {
      this.broadCast.emit(BroadCastConstants.SHOW_EDIT_EXIT_PHOTO_DIALOG, [(): void => this.discardCallback()]);
    } else {
      router.back({
        url: '',
        params: {}
      });
    }
  }

  onSaveClicked(): void {
    Log.info(TAG, 'save clicked');
    if (this.isRedo || this.isRedo) {
      this.broadCast.emit(BroadCastConstants.SHOW_SAVE_PHOTO_DIALOG,
        [(): void => this.saveAsNewCallback(), (): void => this.replaceOriginalCallback()]);
    } else if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP && this.cropEdit.couldReset()) {
      this.broadCast.emit(BroadCastConstants.SHOW_SAVE_PHOTO_DIALOG,
        [(): void => this.saveAsNewCallback(), (): void => this.replaceOriginalCallback()]);
    } else {
      router.back({
        url: '',
        params: {}
      });
    }
  }

  build() {
    if (!this.isImmersive) {
      Row() {
        Column() {
          if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP) {
            Row() {
              Flex({
                direction: FlexDirection.Column,
                justifyContent: FlexAlign.Center,
                alignItems: ItemAlign.Center
              }) {
                Image($r('app.media.ic_gallery_public_back'))
                  .key('PhotoEditBackButton')
                  .width($r('app.float.ic_size_default'))
                  .height($r('app.float.ic_size_default'))
                  .fillColor($r('app.color.default_white_color'))
              }
              .height($r('app.float.buttonWithoutText'))
              .width($r('app.float.buttonWithoutText'))
              .margin({
                left: $r('app.float.bottom_bar_padding'),
                right: $r('app.float.adjust_text_margin_left')
              })
              .onClick(() => {
                this.onBackClicked()
              })

              Row() {
                Text(this.name)
                  .fontSize($r('sys.float.ohos_id_text_size_headline8'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor($r('app.color.default_white_color'))
                  .margin({
                    left: $r('app.float.adjust_text_margin_bottom'),
                    right: $r('app.float.adjust_text_margin_left')
                  })
              }
            }
          }
        }
        .alignItems(HorizontalAlign.Start)
        .width('50%')

        Column() {
          Row() {
            if (this.selectedMode == PhotoEditMode.EDIT_MODE_CROP) {
              Flex({
                direction: FlexDirection.Column,
                justifyContent: FlexAlign.Center,
                alignItems: ItemAlign.Center
              }) {
                Image(this.isPcStyle ? $r('app.media.ic_gallery_public_ok') : $r('app.media.ic_gallery_public_save'))
                  .key('PhotoEditSaveButton')
                  .width($r('app.float.ic_size_default'))
                  .height($r('app.float.ic_size_default'))
                  .fillColor($r('app.color.default_white_color'))
              }
              .height($r('app.float.buttonWithoutText'))
              .width($r('app.float.buttonWithoutText'))
              .margin({ right: $r('app.float.actionbar_first_icon_margin') })
              .onClick(() => {
                this.onSaveClicked()
              })
              .zIndex(100)
            }
          }
        }
        .alignItems(HorizontalAlign.End)
        .width('50%')
      }
    }
  }
}