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

import { ActionButtonInfo } from './MainMenuInfo';
import { Constants } from '../../../common/model/common/Constants';

export class RefreshActionMenu {
    isChanged: number;
    menuArray: Array<ActionButtonInfo>;

    constructor(isChanged: number, menuArray: Array<ActionButtonInfo>) {
        this.isChanged = isChanged;
        this.menuArray = menuArray;
    }
}

export class ActionChangedEvent {
    static allChanged(menuChanged: RefreshActionMenu) {
        if (menuChanged.isChanged == Constants.NEGATIVE_1 || menuChanged.isChanged > menuChanged.menuArray.length
        || menuChanged.isChanged == Constants.NEGATIVE_2) {
            menuChanged.isChanged = Constants.NEGATIVE_1;
            return;
        }
        for (let i = 0; i < menuChanged.menuArray.length; i++) {
            if (i == menuChanged.isChanged) {
                menuChanged.menuArray[i].isActive = !menuChanged.menuArray[i].isActive;
            } else {
                menuChanged.menuArray[i].isActive = false;
            }
        }
        menuChanged.isChanged = Constants.NEGATIVE_1;
    }

    static itselfChanged(menuChanged: RefreshActionMenu) {
        if (menuChanged.isChanged == Constants.NEGATIVE_1 || menuChanged.isChanged > menuChanged.menuArray.length) {
            return;
        }
        for (let i = 0; i < menuChanged.menuArray.length; i++) {
            if (i == menuChanged.isChanged) {
                menuChanged.menuArray[i].isActive = !menuChanged.menuArray[i].isActive;
            }
        }
        menuChanged.isChanged = Constants.NEGATIVE_1;
    }

    static isActiveNotChanged(menuChanged: RefreshActionMenu) {
        if (menuChanged.isChanged == Constants.NEGATIVE_1 || menuChanged.isChanged > menuChanged.menuArray.length) {
            return;
        }
        for (let i = 0; i < menuChanged.menuArray.length; i++) {
            if (i == menuChanged.isChanged) {
                if (!menuChanged.menuArray[i].isActive) {
                    menuChanged.menuArray[i].isActive = !menuChanged.menuArray[i].isActive;
                }
            } else {
                menuChanged.menuArray[i].isActive = false;
            }
        }
        menuChanged.isChanged = Constants.NEGATIVE_1;
    }
}