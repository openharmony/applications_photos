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
import lazy { AnimatorResult } from '@kit.ArkUI';

@Observed
export class ImageToolInnerState {
  // 画中画宽高
  public _stackWidth: number = 0;
  public _stackHeight: number = 0;
  // 内部白框位置 和 宽高
  public _scrollX: number = 0;
  public _scrollY: number = 0;
  public _scrollWidth: number = 0;
  public _scrollHeight: number = 0;
  // 白框位置下方or右侧
  public _isRight: boolean = false;
  // 拖动手势offsetXY
  public _panOffsetX: number = 0;
  public _panOffsetY: number = 0;
  // 画中画自动隐藏定时器
  public _pTimeout: number = 0;
  // 画中画透明度
  public _stackVisibility: number = 0;
  // 画中画 右侧 margin
  public _stackRightMargin: number = 0;
  // 画中画 宽或高超过最大值，等比例压缩比例
  public _stackRatio: number = 1;

  public setIsRight(isRight: boolean): void {
    this._isRight = isRight;
  }
}