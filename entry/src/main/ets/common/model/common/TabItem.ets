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
    name: Resource;
    iconResource: Resource;
    iconSelectedResource: Resource;
    iconDefault: Resource = $r('sys.color.ohos_id_color_bottom_tab_icon_off');
    iconSelected: Resource;
    textColorDefault: Resource = $r('sys.color.ohos_id_color_bottom_tab_text_off');
    textColorSelected: Resource = $r('app.color.color_system_highlight');
    isSelected: boolean;

    constructor(name: Resource, iconResource: Resource, iconSelectedResource: Resource, isSelected: boolean) {
        this.name = name;
        this.iconResource = iconResource;
        this.iconSelectedResource = iconSelectedResource;
        this.isSelected = isSelected;
    }

    getConditionIcon(isSelected: boolean): Resource {
        return isSelected ? this.iconSelected : this.iconDefault;
    }

    getIcon(isSelected: boolean): Resource {
        return isSelected ? this.iconSelectedResource : this.iconResource;
    }

    getTextColor(isSelected: boolean): Resource {
        return isSelected ? this.textColorSelected : this.textColorDefault;
    }
}

// Tab Bar which only has text
// For Album Set
@Observed
export class TabItemWithText {
    name: Resource;
    isSelected: boolean;
    textSizeDefault: Resource = $r('sys.float.ohos_id_text_size_body1');
    textSizeSelected: Resource = $r('sys.float.ohos_id_text_size_sub_title2');
    textWeightDefault: FontWeight = FontWeight.Regular;
    textWeightSelected: FontWeight = FontWeight.Medium;
    textColorDefault: Resource = $r('sys.color.ohos_id_color_bottom_tab_text_off');
    textColorSelected: Resource = $r('app.color.color_system_highlight');

    constructor(name: Resource, isSelected: boolean) {
        this.name = name;
        this.isSelected = isSelected;
    }

    getTextSize(isSelected: boolean): Resource {
        return isSelected ? this.textSizeSelected : this.textSizeDefault;
    }

    getTextWeight(isSelected: boolean): FontWeight {
        return isSelected ? this.textWeightSelected : this.textWeightDefault;
    }

    getTextColor(isSelected: boolean): Resource {
        return isSelected ? this.textColorSelected : this.textColorDefault;
    }
}