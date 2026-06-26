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
import { AttributeUpdater } from '@kit.ArkUI';

export class AttributeInitParam{
  public visibility?: Visibility = Visibility.Visible;
  public blurNum?: number = 0;
  public opacity?: number = 1;

}

export class InitAttributeUpdater<T extends CommonAttribute = CommonAttribute> extends AttributeUpdater<T> {
  /**
   * 显隐控制
   */
  protected visibility: Visibility = Visibility.Visible;

  /**
   * 静态模糊
   */
  protected blurNum: number = 0;

  /**
   * 透明度
   */
  protected opacity: number = 1.0;

  constructor(initParam: AttributeInitParam) {
    super();
    this.visibility = initParam.visibility ?? Visibility.Visible;
    this.blurNum = initParam.blurNum ?? 0;
    this.opacity = initParam.opacity ?? 1.0;
  }

  public override initializeModifier(instance: T): void {
    this.initInstance(instance);
  }

  /**
   * 初始化实例
   *
   * @param instance 实例
   */
  protected initInstance(instance: T): void {
    instance
      .visibility(this.visibility)
      .blur(this.blurNum)
      .opacity(this.opacity)
  }

  public updateVisibility(visibility: Visibility): void {
    this.visibility = visibility;
    this.attribute?.visibility(visibility);
  }

  public updateBlurNum(blur: number): void {
    this.blurNum = blur;
    this.attribute?.blur(blur);
  }

  public updateOpacity(opacity: number): void {
    this.opacity = opacity;
    this.attribute?.opacity(opacity);
  }
}