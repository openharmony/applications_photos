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

import { PhotoEditMode } from '../base/PhotoEditType';

export enum ID {
  CROP = 100,
  CROP_ROTATE,
  CROP_MIRROR,
  DEFAULT
}

export interface ActionInfo {
  src ?: Resource;
  isActive ?: boolean;
  actionID?: number | PhotoEditMode;
  text ?: Resource;
  mode ?: number;
  height ?: Resource;
  width ?: Resource
  color ?: Resource;
  uri ?: string;
  componentKey ?: string;
}

export class ActionButtonInfo {
  public src?: Resource;
  public isActive: boolean;
  public isDoubleClicked: boolean;
  public actionID?: number;
  public text: Resource | null = null;
  public mode: number = 0;
  public height: Resource | null = null;
  public width: Resource | null = null;
  public color: Resource | null = null;
  public uri: string = '';
  public componentKey: string;

  constructor(action: ActionInfo) {
    this.src = action.src == undefined ? undefined : action.src;
    this.actionID = action.actionID as number;
    this.isDoubleClicked = false;
    this.componentKey = action.componentKey as string;
    if (action.isActive != undefined) {
      this.isActive = action.isActive;
    } else {
      this.isActive = false;
    }
    if (action.text != undefined) {
      this.text = action.text;
    }
    if (action.mode != undefined) {
      this.mode = action.mode;
    }
    if (action.height != undefined) {
      this.height = action.height;
    }
    if (action.width != undefined) {
      this.width = action.width;
    }
    if (action.color != undefined) {
      this.color = action.color;
    }
    if (action.uri != undefined) {
      this.uri = action.uri;
    }
  }
}

