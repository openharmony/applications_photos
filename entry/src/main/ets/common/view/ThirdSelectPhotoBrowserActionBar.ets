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

import { Action } from './browserOperation/Action';
import { ActionBar } from './actionbar/ActionBar';
import { ActionBarProp } from './browserOperation/ActionBarProp';
import { ActionBarMode, ActionBarColorMode, ActionBarSelectionMode } from './browserOperation/ActionBarMode';
import { Constants } from '../model/common/Constants';

@Component
export struct ThirdSelectPhotoBrowserActionBar {
    @StorageLink('leftBlank') leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    @State isMultiPick: boolean = false;
    @Consume @Watch('updateActionBar') isSelected: boolean;
    onMenuClicked: Function;
    @State actionBarProp: ActionBarProp = new ActionBarProp;

    aboutToAppear(): void {
        this.actionBarProp = this.createActionBar();
    }

    updateActionBar(): void {
        this.actionBarProp = this.createActionBar();
    }

    private createActionBar(): ActionBarProp {
        let actionBarProp: ActionBarProp = new ActionBarProp();
        let menuList
            = [this.isMultiPick ? (this.isSelected ? Action.SELECTED : Action.MATERIAL_SELECT) : Action.OK];
        actionBarProp
            .setLeftAction(Action.BACK)
            .setMode(ActionBarMode.SELECTION_MODE)
            .setSelectionMode(this.isMultiPick ? ActionBarSelectionMode.MULTI : ActionBarSelectionMode.SINGLE)
            .setColorMode(ActionBarColorMode.TRANSPARENT)
            .setAlpha(ActionBarProp.PHOTO_BROWSER_ACTIONBAR_ALPHA)
            .setMenuList(menuList);
        return actionBarProp;
    }

    build() {
        Stack({ alignContent: Alignment.TopStart }) {
            Image($r('app.media.gradientBasePlate')).width('100%')
                .height('100%').objectFit(ImageFit.Fill)
            ActionBar({
                actionBarProp: $actionBarProp,
                onMenuClicked: this.onMenuClicked
            })
        }
        .height(Constants.ActionBarHeight)
        .hitTestBehavior(HitTestMode.Transparent)
        .markAnchor({ x: '0%', y: '0%' })
        .position({ x: '0%', y: '0%' })
    }
}