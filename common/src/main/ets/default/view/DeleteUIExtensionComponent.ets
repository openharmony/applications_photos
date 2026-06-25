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
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy ability from '@ohos.ability.ability';
import lazy { Constants } from '../model/common/Constants';
import lazy { Log } from '../utils/Log';
import lazy { MediaLibraryData } from '../model/browser/photo/data/MediaData';

/* instrument ignore file */
const FOREGROUND_PHOTO_HEIGHT: number = 344;

const BACKGROUND_PHOTO_HEIGHT: number = 360;
const DELETE_RESULT_SUCCESS: number = 0;
const DELETE_RESULT_FAILED: number = -1;
const TAG: string = 'DeleteUIExtensionComponent';
const CONTENT_MAX_SIZE_FONT = 3.2;
const IMAGE_MAX_SIZE_FONT = 2;

@Component
export struct DeleteUIExtensionComponent {
  private uris: string[] = [];
  private thirdAppName: string = '';
  private isPc: boolean = false;
  private foregroundPhotoWidth: number = 0;
  private backgroundPhotoWidth: number = 0;
  private session: UIExtensionContentSession | undefined;
  private storage: LocalStorage | undefined;
  private alignRule: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {};

  aboutToAppear() {
    this.uris = this.storage?.get(Constants.APP_KEY_DELETE_UI_EXT_URIS) as string[];
    this.thirdAppName = this.storage?.get(Constants.APP_KEY_DELETE_UI_EXT_NAME) as string;
  }

  private setDeleteResult(isDelete: boolean): void {
    Log.warn(TAG, 'setDeleteResult terminateSelfWithResult');
    let abilityResult: ability.AbilityResult = {
      resultCode: isDelete ? DELETE_RESULT_SUCCESS : DELETE_RESULT_FAILED,
    }
    this.session?.terminateSelfWithResult(abilityResult);
  }

  private getThumbnail(isForeground: boolean): string {
    let result: string = '';
    if (this.uris.length == 1) {
      result = `${this.uris[0]}?oper=thumbnail&width=${this.foregroundPhotoWidth}&height=${BACKGROUND_PHOTO_HEIGHT}`;
    } else if (isForeground) {
      result = `${this.uris[0]}?oper=thumbnail&width=${this.foregroundPhotoWidth}&height=${FOREGROUND_PHOTO_HEIGHT}`;
    } else {
      result = `${this.uris[1]}?oper=thumbnail&width=${this.backgroundPhotoWidth}&height=${BACKGROUND_PHOTO_HEIGHT}`;
    }
    return MediaLibraryData.isMediaLibraryUri(result) ? result : '';
  }

  @Builder
  buildImage() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.uris.length > 1) {
        Image(this.getThumbnail(false))
          .objectFit(ImageFit.Fill)
          .border({ radius: $r('app.float.delete_dialog_image_border_radius') })
          .height('100%')
          .width('100%')
          .padding({ left: $r('app.float.delete_dialog_iamge_padding') , right: $r('app.float.delete_dialog_iamge_padding')  })
          .onError((error: ImageError) => {
            Log.error(TAG, `DeleteUIExtensionComponent Image onError, path: ${
            this.getThumbnail(false)}, error: ${error}`);
          })
      }
      Image(this.getThumbnail(true))
        .objectFit(ImageFit.Fill)
        .border({ radius: $r('app.float.delete_dialog_image_border_radius') })
        .height(this.uris.length > 1 ? $r('app.float.delete_dialog_iamge_height') : '100%')
        .width('100%')
        .onError((error: ImageError) => {
          Log.error(TAG, `DeleteUIExtensionComponent Image isForeground onError, path: ${
          this.getThumbnail(true)}, error: ${error}`);
        })
    }
    .width('100%')
    .height('180vp')
    .alignContent(Alignment.Top)
  }

  build() {
    RelativeContainer() {
      Column() {
        Column() {
          this.buildImage();

          Text($r('app.plural.third_delete_message', this.uris.length, this.thirdAppName, this.uris.length))
            .textAlign(TextAlign.Center)
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.font_primary'))
            .margin({ top:  $r('app.float.delete_dialog_text_border_radius')  })
            .maxFontScale(CONTENT_MAX_SIZE_FONT)
            .textAlign(TextAlign.Center)
            .width('100%')
        }
        .alignItems(HorizontalAlign.Center)
        .width('100%')
        .padding({
          top: $r('app.float.delete_dialog_text_padding'),
          bottom: $r('app.float.delete_dialog_text_padding_bottom'),
          left: $r('app.float.delete_dialog_text_padding'),
          right: $r('app.float.delete_dialog_text_padding'),
        })

        Stack({ alignContent: Alignment.Top }) {
          Row() {
            Column() {
              Button() {
                Text($r('app.string.dialog_cancel'))
                  .fontSize($r('sys.float.ohos_id_text_size_button1'))
                  .fontColor($r('sys.color.font_emphasize'))
                  .fontWeight(FontWeight.Medium)
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .maxFontScale(IMAGE_MAX_SIZE_FONT)
              }
              .backgroundColor(Color.Transparent)
              .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
              .height($r('app.float.delete_dialog_button_height'))
              .onClick((): void => {
                this.setDeleteResult(false);
              })
            }.width('50%')

            Divider()
              .vertical(true)
              .color(Constants.DEFAULT_DIVIDER_COLOR)
              .height(Constants.DEFAULT_DIVIDER_HEIGHT)

            Column() {
              Button() {
                Text($r('app.string.dialog_delete'))
                  .fontSize($r('sys.float.ohos_id_text_size_button1'))
                  .fontColor($r('sys.color.warning'))
                  .fontWeight(FontWeight.Medium)
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .maxFontScale(IMAGE_MAX_SIZE_FONT)
              }
              .backgroundColor(Color.Transparent)
              .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
              .height($r('app.float.delete_dialog_button_height'))
              .onClick((): void => {
                this.setDeleteResult(true);
              })
            }.width('50%')
          }
        }
        .width('100%')
        .height($r('app.float.delete_dialog_button_combine_height'))
      }
      .borderRadius($r('sys.float.ohos_id_corner_radius_dialog'))
      .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
      .width(this.isPc ? $r('app.float.delete_dialog_pc_width') : $r('app.float.delete_dialog_phone_width'))
      .constraintSize({
        maxHeight: '90%',
        minHeight:  $r('app.float.delete_dialog_minHeight')
      })
      .alignItems(HorizontalAlign.Center)
      .shadow({
        radius: $r('app.float.dialog_default_shadow_m_radio'),
        color: $r('sys.color.ohos_id_shadow_default_xs'),
        offsetX: $r('app.float.dialog_default_shadow_m_offsetX'),
        offsetY: $r('app.float.dialog_default_shadow_m_offsetY'),
      })
      .margin({ bottom: $r('app.float.delete_dialog_margin_bottom') })
      .alignRules(this.alignRule)
      .id('Column')
    }
    .width('100%')
    .height('100%')
  }
}