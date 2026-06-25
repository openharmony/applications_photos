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
import lazy { ActionViewModel } from '../view/actionbar/Menu';
import lazy { MenuContext } from '../view/browserOperation/MenuContext';

/**
 * 大图多选界面：选择按钮viewModel
 */
export class ThirdSelectedViewModel implements ActionViewModel {
  private readonly handler: () => void;

  /**
   * 构造函数
   * @param handler 处理器
   */
  public constructor(handler?: () => void) {
    this.handler = handler ?? ((): void => {
    });
  }

  public doAction(menuContext?: MenuContext | undefined): void {
    this.handler?.();
  }

  public release(): void {
  }
}