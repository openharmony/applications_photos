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
export class TabItem {
  public name: Resource;
  public iconResource: Resource;
  public iconSelectedResource: Resource;
  private iconDefault: Resource = $r('sys.color.icon_fourth');
  public iconSelected: Resource | null = null;
  private textColorDefault: Resource = $r('sys.color.font_primary');
  private textColorSelected: Resource = $r('sys.color.font_emphasize');
  public textFamilyDefault: Resource = $r('sys.string.ohos_id_text_font_family_medium');
  public textFamilySelected: Resource = $r('sys.string.ohos_id_text_font_family_medium');
  isSelected: boolean;
  componentKey: string;

  constructor(name: Resource, iconResource: Resource, iconSelectedResource: Resource,
    isSelected: boolean, textColorDefault: Resource, componentKey: string) {
    this.name = name;
    this.iconResource = iconResource;
    this.iconSelectedResource = iconSelectedResource;
    this.isSelected = isSelected;
    this.textColorDefault = textColorDefault;
    this.componentKey = componentKey;
  }

  /* instrument ignore next */
  getConditionIcon(isSelected: boolean): Resource {
    return isSelected ? this.iconSelected as Resource : this.iconDefault;
  }

  /* instrument ignore next */
  getIcon(isSelected: boolean): Resource {
    return isSelected ? this.iconSelectedResource : this.iconResource;
  }

  /* instrument ignore next */
  getTextColor(): Resource {
    return this.isSelected ? this.textColorSelected : this.textColorDefault;
  }

  /* instrument ignore next */
  getTextFamily(): Resource {
    return this.isSelected ? this.textColorSelected : this.textColorDefault;
  }
}

// Tab Bar which only has text
// For Album Set
@Observed
/* instrument ignore next */
export class TabItemWithText {
  public name: Resource;
  public isSelected: boolean;
  private textSizeDefault: Resource = $r('sys.float.Body_L');
  private textSizeSelected: Resource = $r('sys.float.Subtitle_M');
  public textWeightDefault: FontWeight = FontWeight.Regular;
  public textWeightSelected: FontWeight = FontWeight.Medium;
  private textColorDefault: Resource = $r('sys.color.icon_secondary');
  private textColorSelected: Resource = $r('sys.color.font_emphasize');

  constructor(name: Resource, isSelected: boolean) {
    this.name = name;
    this.isSelected = isSelected;
  }

  /* instrument ignore next */
  getTextSize(): Resource {
    return this.isSelected ? this.textSizeSelected : this.textSizeDefault;
  }

  /* instrument ignore next */
  getTextWeight(): FontWeight {
    return this.isSelected ? this.textWeightSelected : this.textWeightDefault;
  }

  /* instrument ignore next */
  getTextColor(): Resource {
    return this.isSelected ? this.textColorSelected : this.textColorDefault;
  }
}