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

class ActionInfo {
    src : Resource | null = null;
    isActive : boolean | null = null;
    actionID: number | null = null;
    text : Resource | null = null;
    mode : number | null = null;
    height : Resource | null = null;
    width : Resource | null = null;
    color : Resource | null = null;
    uri : string | null = null;
}

export class ActionButtonInfo {
    src: Resource;
    isActive: boolean;
    isDoubleClicked: boolean;
    actionID: number;
    text: Resource;
    mode: number;
    height: Resource;
    width: Resource
    color: Resource
    uri: string;

    constructor(action: ActionInfo) {
        this.src = action.src == null ? null : action.src;
        this.actionID = action.actionID;
        this.isDoubleClicked = false;
        if (action.isActive != null) {
            this.isActive = action.isActive;
        } else {
            this.isActive = false;
        }
        if (action.text != null) {
            this.text = action.text;
        }
        if (action.mode != null) {
            this.mode = action.mode;
        }
        if (action.height != null) {
            this.height = action.height;
        }
        if (action.width != null) {
            this.width = action.width;
        }
        if (action.color != null) {
            this.color = action.color;
        }
        if (action.uri != null) {
            this.uri = action.uri;
        }
    }
}

