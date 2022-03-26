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

import {Action} from '../model/browser/operation/Action.ets'
import {ActionBar} from './actionbar/ActionBar.ets'
import {ActionBarProp} from '../model/browser/operation/ActionBarProp.ets'
import {ActionBarMode, ActionBarColorMode, ActionBarSelectionMode} from '../model/browser/operation/ActionBarMode.ets'
import {Logger} from '../utils/Logger.ets'
import {ScreenManager} from '../model/common/ScreenManager.ets';

@Component
export struct ThirdSelectPhotoBrowserActionBar {
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    @State isMultiPick: boolean = false;
    @Consume isSelected: boolean;
    onMenuClicked: Function;
    private logger: Logger = new Logger('ThirdSelectPhotoBrowserActionBar');

    private createActionBar(): ActionBarProp {
        let actionBarProp: ActionBarProp = new ActionBarProp();
        let menuList
            = [this.isMultiPick ? (this.isSelected ? Action.SELECTED : Action.MATERIAL_SELECT) : Action.OK];
        actionBarProp
            .setLeftAction(Action.BACK)
            .setMode(ActionBarMode.SELECTION_MODE)
            .setSelectionMode(this.isMultiPick ? ActionBarSelectionMode.MULTI : ActionBarSelectionMode.SINGLE)
            .setColorMode(ActionBarColorMode.NORMAL)
            .setAlpha(ActionBarProp.PHOTO_BROWSER_ACTIONBAR_ALPHA)
            .setMenuList(menuList);
        return actionBarProp;
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            ActionBar({
                isShowBar: true,
                actionBarProp: this.createActionBar(),
                onMenuClicked: this.onMenuClicked
            })
        }
        .markAnchor({x: '0%', y: '0%'})
        .position({x: '0%', y: this.leftBlank[1]})
    }
}