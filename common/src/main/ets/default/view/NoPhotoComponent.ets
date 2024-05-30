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

import { ScreenManager } from '../model/common/ScreenManager';
import { Constants } from '../model/common/Constants';
import { Log } from '../utils/Log';

const TAG: string = 'common_NoPhotoComponent';

@Component
export struct NoPhotoComponent {
  title?: Resource;

  // set an initial value temporarily, later change to 0.
  @State offSetY: number = Constants.EMPTY_PAGE_DEFAULT_OFFSET;
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @State bigScreen: boolean = false;
  private updateImageLayoutFunc: Function = (): void => this.updateImageLayout();

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear`);
    ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.updateImageLayoutFunc);
    this.updateImageLayout();
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.updateImageLayoutFunc);
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Center
    }) {
      Column() {
        Image($r('app.media.no_image_icon'))
          .height(this.bigScreen ? $r('app.float.empty_page_picture_size_large') : $r('app.float.empty_page_picture_size'))
          .width(this.bigScreen ? $r('app.float.empty_page_picture_size_large') : $r('app.float.empty_page_picture_size'))
          .margin({
            bottom: $r('sys.float.ohos_id_elements_margin_vertical_m'),
          })
        Text(this.title)
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('app.color.tertiary_title_text_color'))
      }
      .width('100%')
      .offset({ x: 0, y: this.offSetY })
      .padding({ left: $r('app.float.max_padding_start'), right: $r('app.float.max_padding_start') })
    }
    .width('100%')
  }

  private updateImageLayout(): void {
    this.bigScreen = Math.min(ScreenManager.getInstance().getWinHeight(), ScreenManager.getInstance()
      .getWinWidth()) > Constants.BIG_SCREEN_WIDTH
    let halfImageHeight = this.bigScreen ? Constants.BIG_EMPTY_ICON_SIZE / 2 : Constants.SMALL_EMPTY_ICON_SIZE / 2
    let screenHeight = ScreenManager.getInstance().getWinHeight() - this.leftBlank[1] - this.leftBlank[3]
    if (this.isHorizontal) {
      if (this.isSidebar) {
        // Pad landscape
        this.offSetY = screenHeight / Constants.NUMBER_2 - halfImageHeight - Constants.ActionBarHeight;
      } else {
        // Phone landscape
        this.offSetY = (screenHeight - Constants.ActionBarHeight) / Constants.NUMBER_2 - halfImageHeight;
      }
    } else {
      // Phone vertical screen
      this.offSetY = screenHeight * Constants.EMPTY_PAGE_OFFSET_RADIO -
      Constants.ActionBarHeight - halfImageHeight;
    }
    Log.info(TAG, `isHorizontal: ${this.isHorizontal}, offSetY: ${this.offSetY}, bigScreen: ${this.bigScreen}`);
  }
}