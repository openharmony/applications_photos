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
import lazy { AttributeUpdater } from "@kit.ArkUI";

export class BaseAttributeUpdater<T extends CommonAttribute = CommonAttribute> extends AttributeUpdater<T> {

  /**
   * 放缩系数
   */
  protected scaleOptions: ScaleOptions = {};

  /**
   * 不透明度
   */
  protected opacity: number = 1.0;

  /**
   * 显隐控制
   */
  protected visibility: Visibility = Visibility.None;

  /**
   * 高度
   */
  protected height?: Length;

  /**
   * 宽度
   */
  protected width?: Length;

  /**
   * 偏移
   */
  protected offset?: Position | Edges | LocalizedEdges;

  /**
   * 位移translate
   */
  protected translate?: TranslateOptions;

  /**
   * 边界弧度
   */
  protected borderRadius?: number;

  /**
   * 边界宽度
   */
  protected borderWidth?: Length | EdgeWidths | LocalizedEdgeWidths;

  /**
   * 组件宽高比
   */
  protected aspectRatio?: number;

  /**
   * 是否裁剪
   */
  protected clip?: boolean;

  public override initializeModifier(instance: T): void {
    this.initInstance(instance);
  }

  public override onComponentChanged(instance: T): void {
    this.initInstance(instance);
  }

  /**
   * 初始化实例
   *
   * @param instance 实例
   */
  protected initInstance(instance: T): void {
    instance
      .scale(this.scaleOptions)
      .opacity(this.opacity)
    if (this.height) {
      instance.height(this.height);
    }
    if (this.offset) {
      instance.offset(this.offset);
    }
  }

  /**
   * 更新放缩系数
   *
   * @param scaleOptions 放缩系数
   */
  public updateScale(scaleOptions: ScaleOptions): void {
    this.scaleOptions = scaleOptions;
    this.attribute?.scale(this.scaleOptions);
  }

  /**
   * 更新高度
   *
   * @param height 高度
   */
  public updateHeight(height: Length): void {
    this.height = height;
    this.attribute?.height(this.height);
  }

  /**
   * 更新宽度
   *
   * @param width 宽度
   */
  public updateWidth(width: Length): void {
    this.width = width;
    this.attribute?.width(this.width);
  }

  /**
   * 更新偏移
   *
   * @param offset 偏移
   */
  public updateOffset(offset: Position | Edges | LocalizedEdges): void {
    this.offset = offset;
    if (this.offset) {
      this.attribute?.offset(this.offset);
    }
  }

  /**
   * 更新不透明度
   *
   * @param opacity 不透明度
   */
  public updateOpacity(opacity: number): void {
    this.opacity = opacity;
    this.attribute?.opacity(this.opacity);
  }

  public updateClip(clip: boolean): void {
    this.clip = clip;
    this.attribute?.clip(this.clip);
  }

  public updateVisibility(visibility: Visibility): void {
    this.visibility = visibility;
    this.attribute?.visibility(this.visibility);
  }

  public updateTranslate(translate: TranslateOptions): void {
    this.translate = translate;
    this.attribute?.translate(translate);
  }

  public updateBorderRadius(borderRadius: number): void {
    this.borderRadius = borderRadius;
    this.attribute?.borderRadius(borderRadius);
  }

  public updateBorderWidth(borderWidth: Length | EdgeWidths | LocalizedEdgeWidths): void {
    this.borderWidth = borderWidth;
    this.attribute?.borderWidth(borderWidth);
  }

  public updateAspectRatio(aspectRatio: number): void {
    this.aspectRatio = aspectRatio;
    this.attribute?.aspectRatio(aspectRatio);
  }

  public getVisibility() {
    return this.visibility;
  }
}