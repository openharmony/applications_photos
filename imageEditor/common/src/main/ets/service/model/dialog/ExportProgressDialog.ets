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
import intl from '@ohos.intl';
import i18n from '@ohos.i18n';
import { ColumnSize, Event, HiLog, ScreenManager } from '../../../../../../index';
import { SAVE_PROGRESS_KEY } from '../stylus/Const';

/**
 * 导出进度弹窗
 */
@CustomDialog
export struct ExportProgressDialog {
  public controller?: CustomDialogController;
  public closeClick: () => void = Event;
  // 百分比数字格式化
  private percentFmt: intl.NumberFormat = new intl.NumberFormat(i18n.System.getSystemLocale(), {
    style: 'unit',
    unit: 'percent',
  })
  @StorageProp(SAVE_PROGRESS_KEY) progress: number = 0

  /* instrument ignore file */
  build() {
    Row() {
      Column() {
        Flex({
          direction: FlexDirection.Row,
          justifyContent: FlexAlign.SpaceBetween,
          alignItems: ItemAlign.Center,
          wrap: FlexWrap.Wrap,
        }) {
          Text($r('app.string.saving_media_imageEdit'))
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.ohos_id_color_text_primary'))
            .margin({ bottom: 4 })
            .maxFontScale(3.2)

          Text(this.percentFmt.format(this.progress))
            .fontSize($r('sys.float.Body_M'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .maxFontScale(3.2)
        }
        .margin({ right: 48 })

        Row() {
          Progress({ value: this.progress, total: 100, type: ProgressType.Linear })
            .id('petalClip_ExportProgressDialog_Progress')
            .layoutWeight(1)
            .margin({ right: 8 })
          Column() {
            SymbolGlyph($r('sys.symbol.xmark_circle_fill'))
              .fontSize('24vp')
              .fontColor([$r('sys.color.ohos_id_color_tertiary')])
          }
          .width(40)
          .height(40)
          .id('petalClip_ExportProgressDialog_close')
          .justifyContent(FlexAlign.Center)
          .onClick((): void => {
            HiLog.i('ExportProgressDialog', 'close click');
            this.closeClick();
          })
        }
      }
      .height('auto')
      .constraintSize({ maxWidth: '400vp' })
    }.padding({
      left: 24,
      top: 24,
      bottom: 24,
      right: 16,
    })
  }
}