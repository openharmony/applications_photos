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
import lazy { Log } from '../../utils/Log';
import lazy { CustomContentDialog } from '@kit.ArkUI';
import lazy { Constants } from '../../model/common/Constants';

/* instrument ignore file */
const TAG: string = 'common_FACardLoadingDialog';

const CONTENT_HEIGHT = 48;
const TEXT_HEIGHT = 21;
const ICON_WIDTH = 40;
const NORMAL_ITEM_ROW_SPACE = 12;

export class FACardLoadingDialogController {
  // 单实例内容
  private static instance: FACardLoadingDialogController;
  public controller?: CustomDialogController;
  public openDialog: () => void = () => {
  };
  public closeDialog: () => void = () => {
  };

  public constructor() {

  }

  // 获取单实例
  public static getInstance(): FACardLoadingDialogController {
    if (!FACardLoadingDialogController.instance) {
      FACardLoadingDialogController.instance = new FACardLoadingDialogController();
    }
    return FACardLoadingDialogController.instance;
  }

  public setOpenDialog(callback: () => void): void {
    this.openDialog = () => {
      callback();
    };
  }

  public setCloseDialog(callback: () => void): void {
    this.closeDialog = () => {
      callback();
    };
  }
}

@CustomDialog
export struct FACardLoadingDialog {
  public controller?: CustomDialogController;

  aboutToAppear() {
    Log.info(TAG, 'FACardLoadingDialog aboutToAppear');
  }

  aboutToDisappear() {

  }

  build() {
    CustomContentDialog({
      contentBuilder: () => {
        this.buildContent();
      },
    })
  }

  @Builder
  buildContent() {
    Flex({
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Center,
      direction: FlexDirection.Row,
    }) {
      Text($r('app.string.image_loading'))
        .fontSize($r('sys.float.Subtitle_M'))
        .lineHeight(TEXT_HEIGHT)
        .textAlign(TextAlign.Start)
        .width(Constants.FULL_PERCENT)
        .flexGrow(1)
        .flexShrink(1)
      Row() {
      }
      .flexBasis(NORMAL_ITEM_ROW_SPACE)
      .flexGrow(0)
      .flexShrink(0)

      LoadingProgress()
        .flexBasis(ICON_WIDTH)
        .flexGrow(0)
        .flexShrink(0)
    }
    .height(CONTENT_HEIGHT)
  }
}