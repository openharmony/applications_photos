import { Constants } from './Constants';
/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
  public iconDefault: Resource = $r('sys.color.ohos_id_color_bottom_tab_icon_off');
  public iconSelected: Resource | null = null;
  public textColorDefault: Resource = $r('sys.color.ohos_id_color_text_primary');
  public textColorSelected: Resource = $r('sys.color.ohos_id_color_bottom_tab_text_on');
  public textFamilyDefault: Resource = $r('sys.string.ohos_id_text_font_family_medium');
  public textFamilySelected: Resource = $r('sys.string.ohos_id_text_font_family_medium');
  public isSelected: boolean;
  public componentKey: string;

  constructor(name: Resource, iconResource: Resource, iconSelectedResource: Resource,
              isSelected: boolean, textColorDefault: Resource, componentKey: string) {
    this.name = name;
    this.iconResource = iconResource;
    this.iconSelectedResource = iconSelectedResource;
    this.isSelected = isSelected;
    this.textColorDefault = textColorDefault;
    this.componentKey = componentKey;
  }

  getConditionIcon(isSelected: boolean): Resource {
    return isSelected ? this.iconSelected as Resource : this.iconDefault;
  }

  getIcon(isSelected: boolean): Resource {
    return isSelected ? this.iconSelectedResource : this.iconResource;
  }

  getTextColor(): Resource {
    return this.isSelected ? this.textColorSelected : this.textColorDefault;
  }

  getTextFamily(): Resource {
    return this.isSelected ? this.textColorSelected : this.textColorDefault;
  }
}

// Tab Bar which only has text
// For Album Set
@Observed
export class TabItemWithText {
  public name: Resource;
  public isSelected: boolean;
  public textSizeDefault: Resource = $r('sys.float.ohos_id_text_size_body1');
  public textSizeSelected: Resource = $r('sys.float.ohos_id_text_size_sub_title2');
  public textWeightDefault: FontWeight = FontWeight.Regular;
  public textWeightSelected: FontWeight = FontWeight.Medium;
  public textColorDefault: Resource = $r('sys.color.ohos_id_color_bottom_tab_text_off');
  public textColorSelected: Resource = $r('app.color.color_system_highlight');

  constructor(name: Resource, isSelected: boolean) {
    this.name = name;
    this.isSelected = isSelected;
  }

  getTextSize(): Resource {
    return this.isSelected ? this.textSizeSelected : this.textSizeDefault;
  }

  getTextWeight(): FontWeight {
    return this.isSelected ? this.textWeightSelected : this.textWeightDefault;
  }

  getTextColor(): Resource {
    return this.isSelected ? this.textColorSelected : this.textColorDefault;
  }
}