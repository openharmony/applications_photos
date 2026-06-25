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
import { UiUtil } from '../../../../common/util/UiUtil';

type ParamResourceFn = (...params: Array<number | string>) => Resource;

const DEFAULT_RESOURCE = $r('app.string.none');

class BaseResource {
  public text: Resource = DEFAULT_RESOURCE;
  private textFn: ParamResourceFn = (...params) => DEFAULT_RESOURCE;

  constructor(input: Resource | ParamResourceFn) {
    if (typeof input === 'function') {
      this.textFn = input;
    } else {
      this.text = input;
    }
  }

  getResource(...params: Array<number | string>) {
    if (this.textFn) {
      return this.textFn(...params.map(String));
    }
    return DEFAULT_RESOURCE;
  }

  getString(...params: Array<number | string>) {
    return UiUtil.getResourceString(this.getResource(...params), ...params);
  };
}

@Observed
export class ItemType {
  public text: Resource;
  public icon: string;
  public key: string;
  public min: number;
  public max: number;

  constructor(text: Resource, icon: string, key: string, min: number, max: number) {
    this.text = text;
    this.icon = icon;
    this.key = key;
    this.min = min;
    this.max = max;
  }
}

@Observed
export class ResourceButtonItem {
  public icon: Resource;
  public key: string;
  public state: number; //0代表未选中，1代表选中且高亮，2代表锁定置灰

  constructor(icon: Resource, key: string, state: number) {
    this.icon = icon;
    this.key = key;
    this.state = state;
  }
}

@Observed
export class BaseButton extends BaseResource {
  public icon: Resource;
  public key: string;

  constructor(input: Resource | ParamResourceFn, icon: Resource, key: string) {
    super(input);
    this.icon = icon;
    this.key = key;
  }
}

@Observed
export class ButtonItem extends BaseButton {
  public min: number;
  public max: number;
  public opacity: number;
  public value: number;
  public closed: boolean;
  public state: number; //0代表未选中，1代表选中且高亮，2代表锁定置灰
  public isCheck: boolean;
  public isSymbolGlyph: boolean;

  constructor(input: Resource | ParamResourceFn, icon: Resource, isSymbolGlyph: boolean, key: string, min: number,
    max: number,
    opacity: number, state: number = 0, value: number = 0, closed: boolean = true, isCheck: boolean = false) {
    super(input, icon, key);
    this.isSymbolGlyph = isSymbolGlyph;
    this.min = min;
    this.max = max;
    this.opacity = opacity;
    this.value = value;
    this.closed = closed;
    this.state = state;
    this.isCheck = isCheck;
  }

  setChangeValues(value: number, state: number) {
    this.value = value;
    this.state = state;
  }
}

@Observed
export class TextItem extends BaseResource {
  public key: string

  constructor(input: Resource | ParamResourceFn, key: string) {
    super(input);

    this.key = key;
  }
}

@Observed
export class ResourceTextItem extends BaseResource {
  public key: Resource

  constructor(input: Resource | ParamResourceFn, key: Resource) {
    super(input);

    this.key = key;
  }
}