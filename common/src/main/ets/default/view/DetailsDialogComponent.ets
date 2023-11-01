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
import { Constants } from '../model/common/Constants';

@Component
export struct DetailsDialogComponent {
  title?: Resource;
  content: string | Resource = '';
  colon: string = ': ';
  isLast: boolean = false;
  keyForAutoTest: string = '';

  build() {
    Row() {
      Text(this.title)
        .key('KeyOf' + this.keyForAutoTest)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))

      Text(this.colon)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))

      Text(this.content)
        .key('ValueOf' + this.keyForAutoTest)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .margin({
          right: $r('app.float.details_dialog_text_margin_right')
        })
    }
    .width('100%')
    .margin({
      bottom: this.isLast ? $r('sys.float.ohos_id_elements_margin_vertical_l') : $r('sys.float.ohos_id_text_paragraph_margin_s')
    })
    .alignItems(VerticalAlign.Top)
  }
}