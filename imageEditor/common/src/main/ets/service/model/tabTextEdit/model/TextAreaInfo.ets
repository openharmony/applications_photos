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
import { HiLog } from '../../../../common/util/HiLog';
import { UiUtil } from '../../../../common/util/UiUtil';
import { Constants } from '../util/Const';
import { UiFontColor } from '../util/FontColor';

const TAG = 'TextAreaInfo';

@Observed
export class TextAreaInfo {
  public id: string;
  public index: string;
  public content: string = '';
  public width: number = Constants.DEFAULT_TEXTAREA_WIDTH;
  public height: number = Constants.DEFAULT_TEXTAREA_HEIGHT;
  public textEditMenuWidth: number = 0;
  public fontColor: Color | string | Resource = UiFontColor.WHITE;
  public fontStyle: FontStyle = Constants.DEFAULT_TEXTAREA_FONT_STYLE;
  public fontWeight: string = Constants.DEFAULT_TEXTAREA_FONT_WEIGHT;
  public fontSize: number = Constants.DEFAULT_TEXTAREA_FONT_SIZE;
  public fontFamily: string = Constants.DEFAULT_TEXTAREA_FONT_FAMILY;
  public textAlign: TextAlign = TextAlign.Center; //对齐方式
  public isBackground: boolean = false; //设置背景颜色
  public isBold: boolean = false; //粗体
  public isItalic: boolean = false; //斜体
  public isUnderline: boolean = false; //下划线
  public isTextShadow: boolean = true; //阴影
  public isTextStroke: boolean = false; //描边
  public angle: number = 0;
  // 1 获焦 0 未获焦
  public editState: number;
  public positionX: number;
  public positionY: number;
  //用于位置计算，仅在初始化和文本框缩放时改变
  public localPositionX: number;
  public localPositionY: number;
  public isShownMenu: boolean = true;
  public isShownBorder: boolean = true;
  public richEditorController: RichEditorController;

  constructor(
    positionX: number, positionY: number,
    editState: number, localPositionX: number, localPositionY: number
  ) {
    this.id = generateUniqueId();
    this.index = generateUniqueId();
    this.positionX = positionX;
    this.positionY = positionY;
    this.editState = editState;
    this.localPositionX = localPositionX;
    this.localPositionY = localPositionY;
    this.richEditorController = new RichEditorController();
  }

  getShowColor(): Color | string | Resource {
    HiLog.i(TAG, `getShowColor isBackground:${this.isBackground}, Color:${this.isBackground ?
      (this.fontColor === UiFontColor.WHITE ? UiFontColor.BLACK_OPAQUE : UiFontColor.WHITE) :
    this.fontColor}`);
    return this.isBackground ?
      (this.fontColor === UiFontColor.WHITE ? UiFontColor.BLACK_OPAQUE : UiFontColor.WHITE) :
    this.fontColor;
  }

  toString() {
    return `[id: ${this.id}, index: ${this.index},content:${this.content},width:${this.width},height:${this.height},fontColor:${JSON.stringify(this.fontColor)},fontStyle:${JSON.stringify(this.fontStyle)},
    fontWeight:${this.fontWeight},fontSize:${this.fontSize},fontFamily:${this.fontFamily},textAlign:${JSON.stringify(this.textAlign)},isBackground:${this.isBackground},isBold:${this.isBold},isItalic:${this.isItalic},
    isUnderline: ${this.isUnderline},isTextShadow: ${this.isTextShadow},isTextStroke: ${this.isTextStroke},angle: ${this.angle},positionX: ${this.positionX}, positionY: ${this.positionY}]`;
  }
}

export function deepCopy(textArea: TextAreaInfo | undefined, index?: string): TextAreaInfo {
  const newTextArea: TextAreaInfo = new TextAreaInfo(0, 0, 0, 0, 0);
  if (!textArea) {
    return newTextArea;
  }
  newTextArea.id = textArea.id;
  newTextArea.index = index === undefined ? textArea.index : index;
  newTextArea.content = textArea.content;
  newTextArea.width = textArea.width;
  newTextArea.height = textArea.height;
  newTextArea.textEditMenuWidth = textArea.textEditMenuWidth;
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
  newTextArea.angle = textArea.angle;
  newTextArea.editState = textArea.editState;
  newTextArea.positionX = textArea.positionX;
  newTextArea.positionY = textArea.positionY;
  newTextArea.localPositionX = textArea.localPositionX;
  newTextArea.localPositionY = textArea.localPositionY;
  newTextArea.isShownMenu = textArea.isShownMenu;
  newTextArea.isShownBorder = textArea.isShownBorder;
  newTextArea.richEditorController = textArea.richEditorController;
  return newTextArea;
}

// true 已改变
export function isChanged(preTextArea: TextAreaInfo, curTextArea: TextAreaInfo) {
  return preTextArea.toString() !== curTextArea.toString();
}

export function displayOption(textArea: TextAreaInfo,
  isShownBorder: boolean | undefined, isShownMenu: boolean | undefined, editState?: number) {
  if (textArea === undefined) {
    HiLog.e(TAG, 'unexpected textArea');
    return;
  }
  if (isShownBorder !== undefined) {
    HiLog.i(TAG, 'update isShownBorder: %{public}s', isShownBorder);
    textArea.isShownBorder = isShownBorder;
  }
  if (isShownMenu !== undefined) {
    HiLog.i(TAG, 'update isShownMenu: %{public}s', isShownMenu);
    textArea.isShownMenu = isShownMenu;
  }
  if (editState !== undefined) {
    HiLog.i(TAG, 'update editState: %{public}i', editState);
    textArea.editState = editState;
  }
}

export function generateUniqueId(): string {
  const timestamp: number = Date.now();
  const randomPart: number = Math.floor(Math.random() * 1000000);
  return `${timestamp}-${randomPart}`;
}