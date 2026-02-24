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
import { TabName } from '../../../../../service/App';
import { AiTabName } from '../../../../../service/model/Enum';

@Observed
export class TabType {
  public name: Resource;
  public index: TabName;
  public icon: Resource;
  public isSymbolGlyph: boolean;

  constructor(name: Resource, index: TabName, icon: Resource, isSymbolGlyph: boolean = true) {
    this.name = name;
    this.index = index;
    this.icon = icon;
    this.isSymbolGlyph = isSymbolGlyph;
  }
}

@Observed
export class AiTabType {
  public name: Resource | string;
  public index: AiTabName;
  public key: string;
  public icon?: Resource;

  constructor(name: Resource | string, index: AiTabName, key: string, icon?: Resource) {
    this.name = name;
    this.index = index;
    this.key = key;
    if (icon) {
      this.icon = icon;
    }
  }
}


@Observed
export class ButtonBubble {
  public icon?: Resource;
  public name: Resource | string;
  public isShow: boolean;
  public isHover: boolean;
  public isPress: boolean;

  constructor(name: Resource | string, isShow: boolean, isPress: boolean, isHover: boolean, icon?: Resource) {
    this.icon = icon;
    this.name = name;
    this.isShow = isShow;
    this.isHover = isHover;
    this.isPress = isPress;
  }
}

/* instrument ignore next */
@Observed
export class UnSupportDialog {
  public title: Resource | string;
  public context: Resource | string;
  public key?: string;

  constructor(title: Resource | string, context: Resource | string, key?: string) {
    this.title = title;
    this.context = context;
    if (key) {
      this.key = key;
    }
  }
}