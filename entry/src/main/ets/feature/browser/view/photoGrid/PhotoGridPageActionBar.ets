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

import {Action} from '../../../../common/model/browser/operation/Action.ets'
import {ActionBar} from '../../../../common/view/actionbar/ActionBar.ets'
import {ActionBarProp} from '../../../../common/model/browser/operation/ActionBarProp.ets'
import {ActionBarMode, ActionBarSelectionMode} from '../../../../common/model/browser/operation/ActionBarMode.ets'
import {Logger} from '../../utils/Logger'
import {ScreenManager} from '../../../../common/model/common/ScreenManager'
import { AlbumDefine } from '../../../../common/model/browser/AlbumDefine.ets';

@Component
export struct PhotoGridPageActionBar {
    @Consume isSelectedMode: boolean;
    @Consume isAllSelected: boolean;
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @Consume('selectedCount') selectedCount: number;
    title: Resource | string;
    deviceName: string;
    albumName: string;
    isRecycle: boolean;
    onMenuClicked: Function;
    logger: Logger = new Logger('PhotoGridPageActionBar');
    isDistributedAlbum: boolean;

    private createHorizontalActionBar(): ActionBarProp {
        let menuList: Array<Action> = new Array<Action>();
        let actionBarProp: ActionBarProp = new ActionBarProp();

        actionBarProp
            .setLeftAction(Action.BACK)
            .setTitle(this.title)
            .setMode(ActionBarMode.STANDARD_MODE);
        if (this.isSelectedMode) {
            if (this.isRecycle) {
                menuList.push(
                    Boolean(this.selectedCount) ? Action.RECOVER : Action.RECOVER_INVALID,
                    Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID,
                        this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL);
            } else if (this.isDistributedAlbum) {
                menuList.push(
                    (this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL),
                    (Boolean(this.selectedCount) ? Action.SHARE : Action.SHARE_INVALID),
                    (Boolean(this.selectedCount) ? Action.DOWNLOAD : Action.DOWNLOAD_INVALID));
            } else {
                menuList.push(
                    (Boolean(this.selectedCount) ? Action.SHARE : Action.SHARE_INVALID),
                    (this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL),
                    Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID, Action.MORE);
            }
            actionBarProp
                .setLeftAction(Action.CANCEL)
                .setMode(ActionBarMode.SELECTION_MODE)
                .setSelectionMode(ActionBarSelectionMode.MULTI);
        } else {
            if (!AlbumDefine.ALBUM_DISABLE_DELETE_LIST.has(this.albumName) && this.isDistributedAlbum == false) {
                menuList.push(Action.NEW);
            }
            if (this.isRecycle) {
                menuList.push(Action.CLEAR_RECYCLE);
            }
        }
        actionBarProp.setMenuList(menuList);
        return actionBarProp;
    }

    private createActionBar(): ActionBarProp {
        let menuList: Array<Action> = new Array<Action>();
        let actionBarProp: ActionBarProp = new ActionBarProp();

        if (!AlbumDefine.ALBUM_DISABLE_DELETE_LIST.has(this.albumName) && this.isDistributedAlbum == false) {
            menuList.push(Action.NEW);
        }

        actionBarProp
            .setLeftAction(Action.BACK)
            .setTitle(this.title)
            .setSubTitle(this.deviceName ? $r('app.string.distribute_album_title_holder', this.deviceName) : null)
            .setMenuList(menuList)
            .setMode(ActionBarMode.STANDARD_MODE);
        this.logger.info(`createActionBar, isSelectedMode: ${this.isSelectedMode}`);
        if (this.isSelectedMode) {
            menuList = [];
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