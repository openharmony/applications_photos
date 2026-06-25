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

import { FONT_SIZE_SCALE_KEY, FONT_SIZE_SCALE_M, FONT_SIZE_SCALE_S } from '../../../common/const';

/* instrument ignore file */

const TAG: string = 'ToolbarDialog';
const OTHER_HEIGHT: number = 152;
const DIALOG_HEIGHT_M: number = 216;
const DIALOG_HEIGHT_L: number = 256;

/**
 * 大字体底部顶部工具栏弹窗
 */
@CustomDialog
export struct ToolbarDialog {
  public controller?: CustomDialogController;
  public closeClick: () => void = () => {
  };
  @State rowHeight: number = 0;
  @State dialogSize: number = DIALOG_HEIGHT_M;
  @State isImage: boolean = true;
  @StorageProp('DIALOG_ICON') icon: Resource | undefined = undefined;
  @StorageProp('DIALOG_NAME') name: Resource | undefined = undefined;
  @StorageProp(FONT_SIZE_SCALE_KEY) @Watch('refreshDialog') fontSizeScale: number = 0;

  refreshDialog(): void {
    this.dialogSize = this.fontSizeScale > FONT_SIZE_SCALE_M ? DIALOG_HEIGHT_L : DIALOG_HEIGHT_M;
    this.rowHeight = this.dialogSize - OTHER_HEIGHT;
  }

  aboutToAppear(): void {
    this.refreshDialog();
  }

  build() {
    Column() {
      if (this.isImage) {
        Image(this.icon)
          .fillColor($r('sys.color.icon_primary'))
          .size({ height: '64vp', width: '64vp' })
          .margin({ bottom: '16vp' })
          .matchTextDirection(true)
      } else {
        SymbolGlyph(this.icon)
          .fontSize('64vp')
          .fontColor([$r('sys.color.icon_primary')])
          .margin({ bottom: '16vp' })
      }
      Row() {
        Text(this.name)
          .fontColor($r('sys.color.font_primary'))
          .fontSize('32fp')
          .maxLines(6)
          .textOverflow({
            overflow: TextOverflow.Ellipsis,
          })
          .textAlign(TextAlign.Center)
          .maxFontScale(this.fontSizeScale > FONT_SIZE_SCALE_M ? FONT_SIZE_SCALE_M :
            (this.fontSizeScale > FONT_SIZE_SCALE_S ? 1.45 : 1))
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .constraintSize({ minHeight: this.rowHeight })
    }
    .constraintSize({ minHeight: this.dialogSize })
    .backgroundColor(Color.Transparent)
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THIN)
    .shadow(ShadowStyle.OUTER_DEFAULT_LG)
    .borderRadius($r('sys.float.corner_radius_level10'))
    .size({ width: this.dialogSize })
    .alignItems(HorizontalAlign.Center)
    .padding({
      left: '8vp',
      right: '8vp',
      top: '48vp',
      bottom: '24vp',
    })
  }
}