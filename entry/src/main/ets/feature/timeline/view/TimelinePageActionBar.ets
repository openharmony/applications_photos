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

import {Logger} from '../utils/Logger'
import {Action} from '../../../common/view/browserOperation/Action'
import {ActionBar} from '../../../common/view/actionbar/ActionBar'
import {ActionBarProp} from '../../../common/view/browserOperation/ActionBarProp'
import {ActionBarMode, ActionBarSelectionMode} from '../../../common/view/browserOperation/ActionBarMode'
import {ScreenManager} from '../../../common/model/common/ScreenManager'

@Component
export struct TimelinePageActionBar {
    @Consume isSelectedMode: boolean;
    @Consume isAllSelected: boolean;
    @Consume('selectedCount') selectedCount: number;
    onMenuClicked: Function;
    logger: Logger = new Logger('TimelinePageActionBar');
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();

    private createHorizontalActionBar(): ActionBarProp {
        let menuList: Array<Action> = new Array<Action>();
        let actionBarProp: ActionBarProp = new ActionBarProp();
        actionBarProp
            .setHasTabBar(true)
            .setTitle($r('app.string.tab_timeline'))
            .setIsHeadTitle(true)
            .setMode(ActionBarMode.STANDARD_MODE);
        this.logger.info(`createActionBar, isSelectedMode: ${this.isSelectedMode}`);
        if (this.isSelectedMode) {
            menuList.push((Boolean(this.selectedCount) ? Action.SHARE : Action.SHARE_INVALID),
                (this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL),
                Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID, Action.MORE);
            actionBarProp
                .setLeftAction(Action.CANCEL)
                .setMenuList(menuList)
                .setMode(ActionBarMode.SELECTION_MODE)
                .setSelectionMode(ActionBarSelectionMode.MULTI);
        }
        return actionBarProp;
    }

    private createActionBar(): ActionBarProp {
        let menuList: Array<Action> = new Array<Action>();
        let actionBarProp: ActionBarProp = new ActionBarProp();
        actionBarProp
            .setHasTabBar(this.isSidebar)
            .setTitle($r('app.string.tab_timeline'))
            .setIsHeadTitle(true)
            .setMode(ActionBarMode.STANDARD_MODE);
        this.logger.info(`createActionBar, isSelectedMode: ${this.isSelectedMode}`);
        if (this.isSelectedMode) {
            actionBarProp
                .setLeftAction(Action.CANCEL)
                .setMenuList(menuList)
                .setMode(ActionBarMode.SELECTION_MODE)
                .setSelectionMode(ActionBarSelectionMode.MULTI);
        }
        return actionBarProp;
    }

    build() {
        Column() {
            if (this.isHorizontal) {
                ActionBar({
                    isShowBar: true,
                    actionBarProp: this.createHorizontalActionBar(),
                    onMenuClicked: this.onMenuClicked
                })
            } else {
                ActionBar({
                    isShowBar: true,
                    actionBarProp: this.createActionBar(),
                    onMenuClicked: this.onMenuClicked
                })
            }
        }
    }
}