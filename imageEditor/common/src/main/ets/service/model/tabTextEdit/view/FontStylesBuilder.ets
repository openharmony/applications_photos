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
import { ScreenManager } from '../../../../common/util/ScreenManager';
import { DeviceUtil } from '../../../../common/util/DeviceUtil';
import { DEVICE_FOLD_STATUS } from '../../../../common/const';
import { FontColorTool, FontSizeTool, FontStyleTool } from './FontTools';
import { TextAreaManager } from '../viewModel/TabTextAreaManager';
import { deepCopy, displayOption, isChanged, TextAreaInfo } from '../model/TextAreaInfo';
import { Operation } from '../model/Operation';
import { Constants } from '../util/Const';
import { UndoRedoManager } from '../viewModel/TabUndoRedoManager';

const TAG = 'fontStylesBuilder';

@Component
export struct FontStylesBuilder {
  // 样式builder是否显示在popup组件中
  @Link @Watch('isShowInPopupChange') isShowInPopup: boolean;
  @State isHovered: boolean = false;
  @Link @Watch('isShowChange') isShow: boolean;
  @StorageProp(DEVICE_FOLD_STATUS) @Watch('onFoldChange') isFold: boolean = ScreenManager.getInstance()
    .isDeviceFold()
  @Link currentFontColor: Color | string | Resource;
  @Link currentFontSize: number;
  @Link isFontSizeChange: boolean;
  @Link canUndo: boolean;
  @Link canRedo: boolean;
  @Link textCanClickStyle: boolean;
  @State textArea: TextAreaInfo | undefined = undefined;
  private preTextArea: TextAreaInfo | undefined = undefined;
  undoRedoManager: UndoRedoManager = UndoRedoManager.getInstance();

  onFoldChange() {
    this.isShow = false;
  }

  isShowInPopupChange() {
    this.isShow = this.isShowInPopup && !(DeviceUtil.isFoldable() && !ScreenManager.getInstance().isDeviceFold()) &&
      !DeviceUtil.isPad() && !DeviceUtil.isPc();
  }

  isShowChange() {
    this.isShowInPopup = this.isShow;
  }

  onWillAppear = () => {
    // 优先使用当前正在编辑的文本框；如果没有，则使用 lastTextArea 作为“默认样式”的载体
    this.textArea = TextAreaManager.getInstance().getEditingTextArea();
    if (this.textArea !== undefined) {
      displayOption(this.textArea, undefined, false);
      this.preTextArea = deepCopy(this.textArea);
    } else {
      this.textArea = TextAreaManager.getInstance().getLastTextArea();
    }
  }
  onWillDisAppear = () => {
    if (this.textArea !== undefined) {
      if (this.textArea.editState === 1) {
        displayOption(this.textArea, true, true);
      }
      if (this.preTextArea !== undefined && isChanged(this.preTextArea, this.textArea)) {
        const curTextArea: TextAreaInfo = deepCopy(this.textArea);
        UndoRedoManager.getInstance().push(
          new Operation(Constants.UPDATE_FONT, this.textArea.id, this.preTextArea, curTextArea));
      }
    }
  }

  @Builder
  divider() {
    Divider()
      .padding({ left: 16, right: 16 })
      .strokeWidth('1px')
      .width('100%')
      .color($r('sys.color.ohos_id_color_list_separator'))
  }

  @Builder
  fontStylesBuilder() {
    if (!DeviceUtil.isPad()) {
      Column() {
        // 字体大小
        FontSizeTool({
          currentFontSize: this.currentFontSize,
          textArea: this.textArea,
          canUndo: this.canUndo,
          canRedo: this.canRedo,
          isFontSizeChange: this.isFontSizeChange,
        })
          .width('100%')
          .height(40)
          .padding({
            left: 16,
            right: 16,
          })
          .margin({ bottom: 8 })

        // 字体颜色
        FontColorTool({
          currentFontColor: this.currentFontColor,
          textArea: this.textArea,
          canUndo: this.canUndo,
          canRedo: this.canRedo,
        })
          .width('100%')
          .height(40)
          .padding({
            left: 16,
            right: 16,
          })
          .margin({ bottom: 16 })

        //字体样式
        FontStyleTool({
          currentFontColor: this.currentFontColor,
          textArea: this.textArea,
          canUndo: this.canUndo,
          canRedo: this.canRedo,
        })
          .width('100%')
          .height(48)
          .padding({
            left: 16,
            right: 16,
          })
      }
      .margin({ bottom: 16 })
    }
  }

  build() {
    Column() {

    }
    .opacity($r('sys.float.ohos_id_alpha_content_primary'))
    .borderRadius({
      topLeft: 32,
      topRight: 32,
    })
    .renderGroup(true)
    .width('100%')
    .padding({ bottom: 16 })
    .bindSheet($$this.isShow, this.fontStylesBuilder(), {
      height: 260,
      maskColor: Color.Transparent,
      backgroundColor: $r('sys.color.comp_background_tertiary'),
      blurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
      title: {
        title: $r('app.string.style_imageEdit'),
      },
      showClose: true,
      onWillAppear: this.onWillAppear,
      onWillDisappear: this.onWillDisAppear,
      enableOutsideInteractive: true,
    })
  }
}
