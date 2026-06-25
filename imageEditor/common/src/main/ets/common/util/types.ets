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
@Observed
export class Rectangle {
  public left: number;
  public top: number;
  public right: number;
  public bottom: number;

  public static createRectangleByLTWH(left: number, top: number, width: number, height: number) {
    return new Rectangle(left, top, left + width, top + height);
  }

  constructor(left: number, top: number, right: number, bottom: number) {
    this.left = left;
    this.top = top;
    this.right = right;
    this.bottom = bottom;
  }

  centerY(): number {
    return this.top + this.height() / 2;
  }

  centerX(): number {
    return this.left + this.width() / 2;
  }

  ratio(): number {
    return this.width() / this.height();
  }

  width(): number {
    return this.right - this.left;
  }

  height(): number {
    return this.bottom - this.top;
  }


  roundLeft(): number {
    return Math.floor(vp2px(this.left));
  }

  roundRight(): number {
    return Math.floor(vp2px(this.right));
  }

  roundTop(): number {
    return Math.floor(vp2px(this.top));
  }

  roundBottom(): number {
    return Math.floor(vp2px(this.bottom));
  }

  roundWidth(): number {
    return this.roundRight() - this.roundLeft();
  }

  roundHeight(): number {
    return this.roundBottom() - this.roundTop();
  }


  clone(): Rectangle {
    return new Rectangle(this.left, this.top, this.right, this.bottom);
  }

  toString() {
    return 'Rect[' + this.left + `,${this.top}` + ',' + this.right + ',' + this.bottom + ']';
  }
}

// 实现裁剪框动画效果
export class RectangleAnimated implements AnimatableArithmetic<RectangleAnimated> {
  left: number;
  top: number;
  right: number;
  bottom: number;

  constructor(left: number, top: number, right: number, bottom: number) {
    this.left = left;
    this.top = top;
    this.right = right;
    this.bottom = bottom;
  }

  plus(rhs: RectangleAnimated): RectangleAnimated {
    return new RectangleAnimated(this.left + rhs.left, this.top + rhs.top, this.right + rhs.right,
      this.bottom + rhs.bottom)
  }
  subtract(rhs: RectangleAnimated): RectangleAnimated {
    return new RectangleAnimated(this.left - rhs.left, this.top - rhs.top, this.right - rhs.right,
      this.bottom - rhs.bottom)
  }
  multiply(scale: number): RectangleAnimated {
    return new RectangleAnimated(this.left * scale, this.top * scale, this.right * scale, this.bottom * scale)
  }
  equals(rhs: RectangleAnimated): boolean {
    return this.left === rhs.left && this.top === rhs.top && this.right === rhs.right && this.bottom === rhs.bottom
  }

  roundLeft(): number {
    return Math.floor(vp2px(this.left));
  }

  roundRight(): number {
    return Math.floor(vp2px(this.right));
  }

  roundTop(): number {
    return Math.floor(vp2px(this.top));
  }

  roundBottom(): number {
    return Math.floor(vp2px(this.bottom));
  }
}

export interface AiEditorStatusMsg {
  STATUS: number;
}

export interface AiEditorRemoveMsg {
  COSTTIME: number;
  OPERATIONPOLICY: number;
}

export interface AiEditorFinishMsg {
  STATUS: number;
  DURATION: number;
}

export interface AiEditorReplaceSrcMsg {
  INCOMING: number;
  DURATION: number;
  OUTGOING: number;
  STATUS: number;
  REASON: string;
}

export interface AiEditorReplaceEmoMsg {
  INDEX: number;
  COUNT: number;
  REASON: string;
  DURATION: number;
}

export interface AiEditorCancelRemoveMsg {
  COSTTIME: number;
}

export interface AiEditorRemoveExitMsg {
  operationFlag: number;
}

export class AiEditorMoveSubmitMsg {
  public MAJOR: number = 0;
  public TOTAL: number = 0;
  public SCALE: number = 0;
  public IMAGE_NUM: number = 0;
  public PICKER_MAJOR: number = 0;
  public PICKER_NUM: number = 0;
  public MOVE: number = 0;
  public COPY: number = 0;
  public ZOOM: number = 0;
  public DELETE: number = 0;
  public SAVE_PICKER: number = 0;
  public SWIPE_TOTAL: number = 0;
  public LOSE_FOCUS: number = 0;
  public ADD_PICKER: number = 0;
  public DELETE_PICKER: number = 0;
  public WISE: number = 0;
  public MANUAL: number = 0;
  public MANUAL_PAINT: number = 0;
  public ERASER: number = 0;
  public ERASER_PAINT: number = 0;
  public PICKER: number = 0;
  public FUSION: number = 1;
  public UNDO: number = 0;
  public REDO: number = 0;
}

export interface AiEditorMoveFinishMsg {
  STATUS: number;
  DURATION: number;
  FUSION_TYPE: number;
  IMAGE_REUPLOAD_TIME: number;
}

export interface AiEditorEnterMoveMsg {
  WIDTH: number;
  HEIGHT: number;
}

export interface AiEditorMoveSegFailEMsg {
  TYPE: string;
  TOTAL: number;
}

export interface AiEditorCancelMoveMsg {
  DURATION: number;
}

export interface AiEditorMoveExitMsg {
  OPERATION_FLAG: number;
  TOTAL: number;
  START_TIMESTAMP: number;
  EXIT_TIMESTAMP: number;
}

export interface AiEditorBlurMsg {
  DEGREE: number;
}

export interface AiEditorSaveMsg {
  costTime: number;
  result: number;
}

export interface AiEditorBackgroundStatMsg {
  blurAvgDuration: number;
  decolorizationAvgDuration: number;
  enableBlurAvgDuration: number;
  blurLevel: number;
  decolorizationEnable: boolean;
  blurEnable: boolean;
}
