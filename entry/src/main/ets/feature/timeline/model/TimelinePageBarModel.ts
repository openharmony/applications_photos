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
import  screenManager  from '@ohos/base/src/main/ets/manager/ScreenManager';
import { Action } from '../../../common/view/browserOperation/Action';
import { ActionBarMode, ActionBarSelectionMode } from '../../../common/view/browserOperation/ActionBarMode';
import { ActionBarProp } from '../../../common/view/browserOperation/ActionBarProp';

export class TimelinePageBarModel {
    createActionBar(isSelectedMode: boolean, selectedCount: number, isAllSelected: boolean): ActionBarProp {
        let actionBarProp: ActionBarProp = new ActionBarProp();
        let isHorizontal = screenManager.isHorizontal();
        if (isHorizontal) {
            this.updateHorizontalActionBar(actionBarProp, isSelectedMode, selectedCount, isAllSelected);
        } else {
            this.updateVerticalActionBar(actionBarProp, isSelectedMode);
        }
        return actionBarProp;
    }

    updateActionBar(actionBarProp: ActionBarProp, isSelectedMode: boolean,
                    selectedCount: number, isAllSelected: boolean): void {
        let isHorizontal = screenManager.isHorizontal();
        if (isHorizontal) {
            this.updateHorizontalActionBar(actionBarProp, isSelectedMode, selectedCount, isAllSelected);
        } else {
            this.updateVerticalActionBar(actionBarProp, isSelectedMode);
        }
    }

    private updateHorizontalActionBar(actionBarProp: ActionBarProp, isSelectedMode: boolean,
                                      selectedCount: number, isAllSelected: boolean): ActionBarProp {
        actionBarProp
            .setHasTabBar(true)
            .setTitle($r('app.string.tab_timeline'))
            .setIsHeadTitle(true)
            .setMode(ActionBarMode.STANDARD_MODE);
        if (isSelectedMode) {
            actionBarProp
                .setLeftAction(Action.CANCEL)
                .setMenuList(this.getMenuList(isSelectedMode, selectedCount, isAllSelected))
                .setMode(ActionBarMode.SELECTION_MODE)
                .setSelectionMode(ActionBarSelectionMode.MULTI);
        }
        return actionBarProp;
    }

    private updateVerticalActionBar(actionBarProp: ActionBarProp, isSelectedMode: boolean): void {
        let isSidebar: boolean = screenManager.isSidebar();
        actionBarProp
            .setHasTabBar(isSidebar)
            .setTitle($r('app.string.tab_timeline'))
            .setIsHeadTitle(true)
            .setMode(ActionBarMode.STANDARD_MODE);
        if (isSelectedMode) {
            actionBarProp
                .setLeftAction(Action.CANCEL)
                .setMode(ActionBarMode.SELECTION_MODE)
                .setSelectionMode(ActionBarSelectionMode.MULTI);
        }
    }

    getMenuList(isSelectedMode: boolean, selectedCount: number, isAllSelected: boolean): Array<Action> {
        let menuList: Array<Action> = new Array<Action>();
        menuList.push(Boolean(selectedCount) ? Action.SHARE : Action.SHARE_INVALID)
        menuList.push(isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL)
        menuList.push(Boolean(selectedCount) ? Action.DELETE : Action.DELETE_INVALID, Action.MORE)
        return menuList
    }
}