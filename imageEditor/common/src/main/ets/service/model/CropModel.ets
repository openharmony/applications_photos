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
export class CropScaleClass {
  public value: number;
  public ratio: string;
  public cropIndex: number;
  public text: string | Resource;
  public key: string = '';

  constructor(value: number, ratio: string, cropIndex: number, text: string | Resource, key?: string) {
    this.value = value;
    this.ratio = ratio;
    this.cropIndex = cropIndex;
    this.text = text;
    key && (this.key = key);
  }
}

export class DownPos {
  public left: number;
  public top: number;
  public bottom: number;
  public right: number;

  constructor(left: number, top: number, bottom: number, right: number) {
    this.left = left;
    this.top = top;
    this.bottom = bottom;
    this.right = right;
  }
}

export class DragObj {
  public x: number;
  public y: number;
  public dragging: boolean;
  public action: Action;
  public downPos: DownPos;
  public multiCrop: boolean;

  constructor(dragging: boolean, x: number = 0, y: number = 0,
    action: Action = new Action(false, false, false, false),
    downPos: DownPos = new DownPos(0, 0, 0, 0), multiCrop: boolean = false) {
    this.dragging = dragging;
    this.x = x;
    this.y = y;
    this.action = action;
    this.downPos = downPos;
    this.multiCrop = multiCrop;
  }
}

export class Action {
  public left: boolean;
  public top: boolean;
  public right: boolean;
  public bottom: boolean;

  constructor(left: boolean, top: boolean, right: boolean, bottom: boolean) {
    this.left = left;
    this.top = top;
    this.right = right;
    this.bottom = bottom;
  }
}

export enum CropType {
  FREE_CROP,
  FIXED_RATIO,
  FRAME_CROP
}