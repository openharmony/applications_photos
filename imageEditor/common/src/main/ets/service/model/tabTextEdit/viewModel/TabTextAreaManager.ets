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
// instrument ignore file
import { HiLog } from '../../../../common/util/HiLog';
import { Constants } from '../util/Const';
import { deepCopy, displayOption, generateUniqueId, TextAreaInfo } from '../model/TextAreaInfo';
import { Operation } from '../model/Operation';
import { ScaleValues } from '../model/ScaleValues';
import { UndoRedoManager } from './TabUndoRedoManager';
import { DeviceUtil } from '../../../../common/util/DeviceUtil';
import { ScreenManager } from '../../../../common/util/ScreenManager';
import { App } from '../../../App';

const TAG = 'TextAreaManager';

@ObservedV2
export class TextAreaManager {
  private static instance: TextAreaManager;
  @Trace protected textAreaList: TextAreaInfo[] = [];
  @Trace protected scaleValueX: number = 1;
  @Trace protected scaleValueY: number = 1;
  protected lastTextArea: TextAreaInfo = new TextAreaInfo(0, 0, 0, 0, 0);
  protected currentWidth: number = 0;
  protected currentHeight: number = 0;
  private undoRedoManager: UndoRedoManager = UndoRedoManager.getInstance();

  private constructor() {

  }

  public static getInstance() {
    if (!TextAreaManager.instance) {
      TextAreaManager.instance = new TextAreaManager();
    }
    return TextAreaManager.instance;
  }

  public setCurrentWidth(value: number) {
    this.currentWidth = value;
  }

  public setCurrentHeight(value: number) {
    this.currentHeight = value;
  }

  public getCurrentWidth() {
    return this.currentWidth;
  }

  public getCurrentHeight() {
    return this.currentHeight;
  }

  public getTextAreaList() {
    return this.textAreaList;
  }

  public clear() {
    this.textAreaList.splice(0);
    this.undoRedoManager.clear();
    this.initLastTextArea();
  }

  public initLastTextArea() {
    this.lastTextArea = new TextAreaInfo(0, 0, 0, 0, 0);
  }

  public getLastTextArea() {
    return this.lastTextArea;
  }

  public register(width: number, height: number, isPortrait: boolean) {
    HiLog.i(TAG, 'TextAreaManager register');
    if (DeviceUtil.isLandscape() || (DeviceUtil.isFoldable() && !ScreenManager.getInstance().isDeviceFold())) {
      this.scaleValueX = 1;
      this.scaleValueY = 1;
    } else {
      this.scaleValueX = isPortrait ? 1 : this.scaleValueX;
      this.scaleValueY = isPortrait ? 1 : this.scaleValueY;
    }
    HiLog.i(TAG, `width:${width},height:${height},
    this.scaleValueX:${this.scaleValueX}, this.scaleValueY:${this.scaleValueY}`);
    let newTextArea: TextAreaInfo = this.createDefaultTextArea(width, height);
    //复制上一次编辑的样式
    this.copyStyle(newTextArea, this.lastTextArea);
    HiLog.i(TAG, `new TextArea, id:${newTextArea.id},
    positionX:${newTextArea.positionX}, positionY:${newTextArea.positionY}`);
    // 创建时，最新的文本框获焦
    this.textAreaList.forEach(textAreaInfo => {
      textAreaInfo.editState = 0;
      textAreaInfo.isShownMenu = false;
      textAreaInfo.isShownBorder = false;
    })
    this.textAreaList.push(newTextArea);
    this.undoRedoManager.push(
      new Operation(Constants.CREATE_TEXTAREA, newTextArea.id, deepCopy(newTextArea), deepCopy(newTextArea)));
  }

  public checkTextNumber(): boolean {
    if (this.textAreaList.length >= 20) {
      HiLog.i(TAG, `Maximum number of text boxes reached`);
      return true;
    }
    return false;
  }

  public copyStyle(newTextArea: TextAreaInfo, textArea: TextAreaInfo) {
    newTextArea.fontColor = textArea.fontColor;
    newTextArea.fontStyle = textArea.fontStyle;
    newTextArea.fontWeight = textArea.fontWeight;
    newTextArea.fontSize = textArea.fontSize;
    newTextArea.fontFamily = textArea.fontFamily;
    newTextArea.textAlign = textArea.textAlign;
    newTextArea.isBackground = textArea.isBackground;
    newTextArea.isBold = textArea.isBold;
    newTextArea.isItalic = textArea.isItalic;
    newTextArea.isUnderline = textArea.isUnderline;
    newTextArea.isTextShadow = textArea.isTextShadow;
    newTextArea.isTextStroke = textArea.isTextStroke;
  }

  private createDefaultTextArea(width: number, height: number): TextAreaInfo {
    let positionX = (width - Constants.DEFAULT_TEXTAREA_WIDTH * this.scaleValueX) / 2 -
      Constants.DEFAULT_TEXTAREA_MARGIN_LEFT * this.scaleValueX;
    let positionY = (height - Constants.DEFAULT_TEXTAREA_HEIGHT * this.scaleValueY) / 2;
    return new TextAreaInfo(positionX, positionY, 1, positionX, positionY);
  }

  public copy(width: number, height: number, isRightEdge: boolean, isBottomEdge: boolean) {
    HiLog.i(TAG, 'TextAreaManager copy');
    let newTextArea: TextAreaInfo = this.createDefaultTextArea(width, height);
    let currentTextArea = this.getEditingTextArea();
    if (currentTextArea) {
      newTextArea = deepCopy(currentTextArea);
      newTextArea.id = generateUniqueId();
      newTextArea.index = generateUniqueId();
      newTextArea.richEditorController = new RichEditorController();
    }
    //偏移位置
    if (isRightEdge) {
      newTextArea.positionX = newTextArea.positionX - Constants.TEXT_COPY_OFFSET
    } else {
      newTextArea.positionX = newTextArea.positionX + Constants.TEXT_COPY_OFFSET
    }
    if (isBottomEdge) {
      newTextArea.positionY = newTextArea.positionY - Constants.TEXT_COPY_OFFSET
    } else {
      newTextArea.positionY = newTextArea.positionY + Constants.TEXT_COPY_OFFSET
    }
    HiLog.i(TAG, `copy TextArea, positionX:${newTextArea.positionX}, positionY:${newTextArea.positionY}`);
    // 创建时，最新的文本框获焦
    this.textAreaList.forEach(textAreaInfo => {
      textAreaInfo.editState = 0;
      textAreaInfo.isShownMenu = false;
      textAreaInfo.isShownBorder = false;
    })
    this.textAreaList.push(newTextArea);
    this.undoRedoManager.push(
      new Operation(Constants.CREATE_TEXTAREA, newTextArea.id, deepCopy(newTextArea), deepCopy(newTextArea)));
  }

  public unRegister(textAreaId: string) {
    const indexToDelete: number = this.textAreaList.findIndex(item => item.id === textAreaId);
    if (indexToDelete >= 0) {
      let textArea: TextAreaInfo = this.textAreaList.splice(indexToDelete, 1)[0];
      this.undoRedoManager.push(
        new Operation(Constants.DELETE_TEXTAREA, textArea.id, deepCopy(textArea), deepCopy(textArea)));
    }
  }

  public undo() {
    HiLog.i(TAG, 'start undo');
    let topItem: Operation | undefined = this.undoRedoManager.undo();
    if (topItem === undefined) {
      return;
    }
    this.flush(topItem.operateId);
    HiLog.i(TAG, 'operateType %{public}i', topItem.operateType);
    const currentIndex: number = this.textAreaList.findIndex(item => item.id === topItem?.operateId);
    HiLog.i(TAG, 'currentIndex: %{public}i', currentIndex);
    if (topItem.operateType === Constants.CREATE_TEXTAREA) {
      HiLog.i(TAG, 'undo create');
      this.textAreaList.splice(currentIndex, 1);
      return;
    }
    if (topItem.operateType === Constants.DELETE_TEXTAREA && topItem.currentTextArea) {
      HiLog.i(TAG, 'undo delete');
      this.textAreaList.push(topItem.currentTextArea);
      return;
    }
    // 非创建/删除文本框操作
    if (topItem.previousTextArea === undefined || currentIndex === -1) {
      HiLog.e(TAG, 'undo unexpected text or index');
      return;
    }
    topItem.previousTextArea.isShownMenu = true;
    topItem.previousTextArea.isShownBorder = true;
    topItem.previousTextArea.editState = 1;
    App.getInstance().myEditor().isInTextArea = true;
    this.textAreaList[currentIndex] = deepCopy(topItem.previousTextArea, generateUniqueId());
  }

  public redo() {
    HiLog.i(TAG, 'start redo');
    let topItem: Operation | undefined = this.undoRedoManager.redo();
    if (topItem === undefined) {
      return;
    }
    this.flush(topItem.operateId);
    HiLog.i(TAG, 'operateType %{public}i', topItem.operateType);
    const currentIndex: number = this.textAreaList.findIndex(item => item.id === topItem?.operateId);
    HiLog.i(TAG, 'currentIndex: %{public}i', currentIndex);
    if (topItem.operateType === Constants.CREATE_TEXTAREA && topItem.currentTextArea) {
      HiLog.i(TAG, 'redo create');
      this.textAreaList.push(topItem.currentTextArea);
      return;
    }
    if (topItem.operateType === Constants.DELETE_TEXTAREA) {
      HiLog.i(TAG, 'redo delete');
      this.textAreaList.splice(currentIndex, 1);
      return;
    }
    // 非创建/删除文本框操作
    if (topItem.currentTextArea === undefined || currentIndex === -1) {
      HiLog.e(TAG, 'redo unexpected text or index');
      return;
    }
    topItem.currentTextArea.isShownMenu = true;
    topItem.currentTextArea.isShownBorder = true;
    topItem.currentTextArea.editState = 1;
    App.getInstance().myEditor().isInTextArea = true;
    this.textAreaList[currentIndex] = deepCopy(topItem.currentTextArea, generateUniqueId());
  }

  public OnPortraitChange(newPaintViewX: number, newPaintViewY: number) {
    HiLog.i(TAG, 'OnPortraitChange');
    let scaleX: number = newPaintViewX / this.currentWidth;
    let scaleY: number = newPaintViewY / this.currentHeight;
    this.textAreaList.forEach((textAreaInfo: TextAreaInfo, index) => {
      textAreaInfo.positionX *= scaleX;
      textAreaInfo.positionY *= scaleY;
      let newTextAreaInfo = deepCopy(textAreaInfo, generateUniqueId());
      this.textAreaList.splice(index, 1, newTextAreaInfo);
    });
    this.scaleValueX = scaleX;
    this.scaleValueY = scaleY;
    this.currentWidth = newPaintViewX;
    this.currentHeight = newPaintViewY;
    let scaleValues = new ScaleValues(scaleX, scaleY);
    this.undoRedoManager.refresh(scaleValues);
    return scaleValues;
  }

  public onPositionChange(scaleX: number, scaleY: number) {
    this.undoRedoManager.refresh(new ScaleValues(scaleX, scaleY));
    this.textAreaList.forEach((textAreaInfo: TextAreaInfo, index: number) => {
      textAreaInfo.positionX *= scaleX;
      textAreaInfo.positionY *= scaleY;
      this.textAreaList.splice(index, 1, deepCopy(textAreaInfo, generateUniqueId()));
    });
  }

  public OnFontsizeChange(height: number) {
    HiLog.i(TAG, 'OnFontsizeChange');
    let index = this.textAreaList.findIndex(item => item.editState === 1);
    if (index !== -1) {
      let textArea: TextAreaInfo = this.textAreaList[index];
      textArea.height = height;
      this.textAreaList.splice(index, 1, deepCopy(textArea, generateUniqueId()));
    }
  }

  public getEditingTextArea(): TextAreaInfo | undefined {
    let textArea: TextAreaInfo[] = this.textAreaList.filter(item => item.editState === 1);
    if (textArea.length !== 0) {
      return textArea[0];
    }
    return undefined;
  }

  public flush(textAreaId: string) {
    this.textAreaList.forEach(textArea => {
      if (textArea.id !== textAreaId) {
        displayOption(textArea, false, false, 0);
      } else {
        displayOption(textArea, true, true, 1);
      }
    });
  }
}