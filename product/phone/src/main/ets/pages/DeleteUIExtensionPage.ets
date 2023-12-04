/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import ability from '@ohos.ability.ability';
import { Constants, Log } from '@ohos/common';

const TAG: string = 'DeleteUIExtensionPage';
const FOREGROUND_PHOTO_WIDTH: number = 576;
const BACKGROUND_PHOTO_WIDTH: number = 512;
const FOREGROUND_PHOTO_HEIGHT: number = 344;
const BACKGROUND_PHOTO_HEIGHT: number = 360;

let storage = LocalStorage.getShared();

@Entry(storage)
@Component
export struct DeleteUIExtensionPage {
  private uris: Array<string> = [];
  private thirdAppName: string = '';
  private session: UIExtensionContentSession =
    storage.get<UIExtensionContentSession>('session') as UIExtensionContentSession;
  private phoneAlignRule: Record<string, Record<string, string | VerticalAlign | HorizontalAlign>> = {
    'bottom': { 'anchor': '__container__', 'align': VerticalAlign.Bottom },
    'middle': { 'anchor': '__container__', 'align': HorizontalAlign.Center }
  };

  onPageShow() {
    this.session.setWindowBackgroundColor('#00000000');
  }

  aboutToAppear() {
    this.uris = AppStorage.get('uris') as string[];
    Log.info(TAG, 'aboutToAppear uris:' + JSON.stringify(this.uris));
    this.thirdAppName = AppStorage.get('appName') as string;
    Log.info(TAG, 'aboutToAppear appName:' + this.thirdAppName);
  }

  private setDeleteResult(isDelete: boolean): void {
    let abilityResult: ability.AbilityResult = {
      resultCode: isDelete ? 0 : -1
    }
    Log.info(TAG, 'terminateSelfWithResult start, isDelete:' + isDelete);
    this.session.terminateSelfWithResult(abilityResult)
  }

  private getThumbnail(isForeground: boolean): string {
    if (this.uris.length == 0) {
      return '';
    }
    if (this.uris.length == 1) {
      return `${this.uris[0]}?oper=thumbnail&width=${FOREGROUND_PHOTO_WIDTH}&height=${BACKGROUND_PHOTO_HEIGHT}`;
    } else if (isForeground) {
      return `${this.uris[0]}?oper=thumbnail&width=${FOREGROUND_PHOTO_WIDTH}&height=${FOREGROUND_PHOTO_HEIGHT}`;
    } else {
      return `${this.uris[1]}?oper=thumbnail&width=${BACKGROUND_PHOTO_WIDTH}&height=${BACKGROUND_PHOTO_HEIGHT}`;
    }
  }

  build() {
    RelativeContainer() {
      Column() {
        Column() {
          Stack({ alignContent: Alignment.Bottom }) {
            if (this.uris.length > 1) {
              Image(this.getThumbnail(false))
                .objectFit(ImageFit.Fill)
                .border({ radius: '12vp' })
                .height('100%')
                .width('100%')
                .padding({ left: '16vp', right: '16vp' })
            }

            Image(this.getThumbnail(true))
              .objectFit(ImageFit.Fill)
              .border({ radius: '12vp' })
              .height(this.uris.length > 1 ? '172vp' : '100%')
              .width('100%')
          }
          .width('100%')
          .height('180vp')
          .alignContent(Alignment.Top)

          Text($r('app.string.third_delete_dialog_message', this.thirdAppName, this.uris.length))
            .textAlign(TextAlign.Center)
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontWeight(FontWeight.Regular)
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .margin({ top: '16vp' })
        }
        .alignItems(HorizontalAlign.Center)
        .width('100%')
        .padding({ top: '24vp', bottom: '8vp', left: '24vp', right: '24vp' })

        Stack({ alignContent: Alignment.Top }) {
          Row() {
            Column() {
              Button() {
                Text($r('app.string.dialog_cancel'))
                  .fontSize($r('sys.float.ohos_id_text_size_button1'))
                  .fontColor($r('app.color.color_control_highlight'))
                  .fontWeight(FontWeight.Medium)
                  .width('100%')
                  .textAlign(TextAlign.Center)
              }
              .backgroundColor($r('app.color.transparent'))
              .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
              .height('40vp')
              .onClick(() => {
                this.setDeleteResult(false);
              })
            }.width('50%')


            Divider()
              .vertical(true)
              .height(Constants.DEFAULT_DIVIDER_HEIGHT)
              .color(Constants.DEFAULT_DIVIDER_COLOR)

            Column() {
              Button() {
                Text($r('app.string.dialog_delete'))
                  .fontSize($r('sys.float.ohos_id_text_size_button1'))
                  .fontColor($r('sys.color.ohos_id_color_warning'))
                  .fontWeight(FontWeight.Medium)
                  .width('100%')
                  .textAlign(TextAlign.Center)
              }
              .backgroundColor($r('app.color.transparent'))
              .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
              .height('40vp')
              .onClick(() => {
                this.setDeleteResult(true);
              })
            }.width('50%')

          }
        }
        .width('100%')
        .height('56vp')
      }
      .borderRadius($r('sys.float.ohos_id_corner_radius_dialog'))
      .backgroundColor(Color.White)
      .width('410vp')
      .height('303vp')
      .alignItems(HorizontalAlign.Center)
      .shadow({
        radius: $r('app.float.dialog_defult_shadow_m_radio'),
        color: $r('app.color.dialog_defult_shadow_m_color'),
        offsetX: $r('app.float.dialog_defult_shadow_m_offsetX'),
        offsetY: $r('app.float.dialog_defult_shadow_m_offsetY')
      })
      .margin({ bottom: '16vp' })
      .alignRules(this.phoneAlignRule)
      .id('Column')
    }
    .width('100%')
    .height('100%')
  }
}