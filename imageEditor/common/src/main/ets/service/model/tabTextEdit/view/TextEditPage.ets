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
import { TextEditItem } from './TextEditItem';
import { TextAreaInfo } from '../model/TextAreaInfo';
import { UndoRedoManager } from '../viewModel/TabUndoRedoManager';
import { BaseEditor } from '../../../BaseEditor';
import { RectValue } from '../../../EditorSDK';
import { App } from '../../../App';
import { HiLog } from '../../../../common/util/HiLog';
import { TextAreaManager } from '../viewModel/TabTextAreaManager';
import { ScreenManager } from '../../../../common/util/ScreenManager';
import { SCREEN_ORIENTATION_PORTRAIT, WIN_HEIGHT_KEY } from '../../../../common/const';
import { DeviceUtil } from '../../../../common/util/DeviceUtil';
import { ScaleValues } from '../model/ScaleValues';

const TAG = 'TextEditPage';

@Component
export struct TextEditPage {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @Prop portraitScale: ScaleValues;
  @Prop scaleX: number;
  @Prop scaleY: number;
  @Prop imageViewWidth: number;
  @Prop imageViewHeight: number;
  @Prop imagePostionX: number;
  @Prop imagePostionY: number;
  @Prop foldStatus: boolean;
  @Link canUndo: boolean;
  @Link canRedo: boolean;
  @Link textCanClickStyle: boolean;
  @Link isShowInPopup: boolean;
  @Link textInputAreaHide: boolean;
  @Link keyboardHeight: number;
  @Link isShowBorder: boolean;
  @Link currentFontColor: Color | string | Resource;
  @Link currentFontSize: number;
  @Link isFontSizeChange: boolean;
  private undoRedoManager: UndoRedoManager = UndoRedoManager.getInstance();
  private textAreaManager: TextAreaManager = TextAreaManager.getInstance();
  @Prop isGestureRunning: boolean;

  aboutToAppear(): void {
    HiLog.i(TAG, 'TextEditPage aboutToAppear');
    // 异常退出时兜底
    this.textAreaManager.clear();
    this.isShowInPopup = false;
    this.textCanClickStyle = false;
  }

  aboutToDisappear(): void {
    HiLog.i(TAG, 'TextEditPage aboutToDisappear');
    this.textAreaManager.clear();
    this.isShowInPopup = false;
    this.textCanClickStyle = false;
  }

  build() {
    Column() {
      ForEach(this.textAreaManager.getTextAreaList(), (textArea: TextAreaInfo) => {
        TextEditItem({
          isShowInPopup: this.isShowInPopup,
          textCanClickStyle: this.textCanClickStyle,
          textInputAreaHide: this.textInputAreaHide,
          textArea: textArea,
          canUndo: this.canUndo,
          canRedo: this.canRedo,
          paintViewWidth: this.imageViewWidth,
          paintViewHeight: this.imageViewHeight,
          imagePositionX: this.imagePostionX,
          imagePositionY: this.imagePostionY,
          keyboardHeight: this.keyboardHeight,
          isShowBorder: this.isShowBorder,
          portraitScale: this.portraitScale,
          currentFontColor: this.currentFontColor,
          currentFontSize: this.currentFontSize,
          isFontSizeChange: this.isFontSizeChange,
          isGestureRunning: this.isGestureRunning,
        })
      }, (textArea: TextAreaInfo) => textArea.index);
    }
  }
}