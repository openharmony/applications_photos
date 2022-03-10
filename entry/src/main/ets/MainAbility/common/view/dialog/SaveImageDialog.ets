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

import {BroadCastConstants} from '../../../common/model/common/BroadCastConstants'
import {BroadCast} from '../../../common/utils/BroadCast.ets'
import {ScreenManager} from '../../model/common/ScreenManager'
import {Constants} from '../../model/common/Constants.ets';

@CustomDialog
export struct SaveImageDialog {
  @Consume broadCast: BroadCast
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('leftBlank') leftBlank: [number, number, number, number]
    = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  controller: CustomDialogController;

  controllerClose() {
    this.controller.close()
  }

  aboutToAppear() {
    this.broadCast.on(BroadCastConstants.EXIT_SAVE_PROGRESS_CLOSE, this.controllerClose.bind(this));
  }

  build() {
    Column() {
      Text($r("app.string.edit_save_picture_text")).fontSize($r('sys.float.ohos_id_text_size_body1'))
        .margin({bottom : $r('app.float.dialog_content_margin'), top : $r('app.float.dialog_content_margin')})
    }
    .alignItems(HorizontalAlign.Start)
    .width(ScreenManager.getInstance().getColumnsWidth(4))
    .backgroundColor($r('app.color.white'))
    .borderRadius($r('app.float.dialog_content_margin'))
    .margin({
      right: $r('app.float.dialog_content_margin'),
      left: $r('app.float.dialog_content_margin'),
      bottom: this.isHorizontal || this.isSidebar ? 0 : Constants.DIALOG_BOTTOM_OFFSET + this.leftBlank[3]
    })
    .padding({left: $r('app.float.dialog_content_margin'), right: $r('app.float.dialog_content_margin')})
  }
}