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

import {Action} from '../../../../common/model/browser/operation/Action'
import {ActionBar} from '../../../../common/view/actionbar/ActionBar.ets'
import {ActionBarProp} from '../../../../common/model/browser/operation/ActionBarProp.ets'
import {ActionBarMode, ActionBarSelectionMode} from '../../../../common/model/browser/operation/ActionBarMode.ets'
import {ScreenManager} from '../../../../common/model/common/ScreenManager.ets'
import {Logger} from '../../utils/Logger.ets'

@Component
export struct AlbumSetPageActionBar {
    @Consume isAlbumSetSelectedMode: boolean;
    @Consume ('selectedCount') selectedAlbumsCount: number;
    @Consume isDisableRename: boolean;
    @Consume isDisableDelete: boolean;

    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();

    onMenuClicked : Function;
    logger: Logger = new Logger('AlbumSetPageActionBar');

    private createHorizontalActionBar(): ActionBarProp {
        this.logger.info(`createHorizontalActionBar, isAlbumSetSelectedMode: ${this.isAlbumSetSelectedMode}`);

        let menuList: Array<Action> = new Array<Action>();
        let actionBarProp: ActionBarProp = new ActionBarProp();

        actionBarProp
            .setHasTabBar(this.isSidebar)
            .setTitle($r('app.string.tab_albums'))
            .setIsHeadTitle(true);

        if (this.isAlbumSetSelectedMode) {
            menuList.push(
                ((!this.isDisableRename && this.selectedAlbumsCount == 1) ? Action.RENAME : Action.RENAME_INVALID),
                ((!this.isDisableDelete && this.selectedAlbumsCount > 0) ? Action.DELETE :Action.DELETE_INVALID));
            actionBarProp
                .setLeftAction(Action.CANCEL)
                .setMenuList(menuList)
                .setMode(ActionBarMode.SELECTION_MODE)
                .setSelectionMode(ActionBarSelectionMode.MULTI);
        } else {
            menuList.push(Action.NEW)
            actionBarProp
                .setMenuList(menuList)
                .setMode(ActionBarMode.STANDARD_MODE);
        }

        return actionBarProp;
    }

    private createActionBar(): ActionBarProp {
        this.logger.info(`createActionBar, isAlbumSetSelectedMode: ${this.isAlbumSetSelectedMode}`);

        let menuList: Array<Action> = new Array<Action>();
        let actionBarProp: ActionBarProp = new ActionBarProp();

        menuList.push(Action.NEW);

        actionBarProp
            .setHasTabBar(this.isSidebar)
            .setTitle($r('app.string.tab_albums'))
            .setIsHeadTitle(true);

        if (this.isAlbumSetSelectedMode) {
            actionBarProp
                .setLeftAction(Action.CANCEL)
                .setMode(ActionBarMode.SELECTION_MODE)
                .setSelectionMode(ActionBarSelectionMode.MULTI);
        } else {
            actionBarProp
                .setMenuList(menuList)
                .setMode(ActionBarMode.STANDARD_MODE);
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