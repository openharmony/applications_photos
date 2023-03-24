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

import { Action } from '../../../common/view/browserOperation/Action';
import { ActionBarProp } from '../../../common/view/browserOperation/ActionBarProp';
import { ActionBarMode, ActionBarSelectionMode } from '../../../common/view/browserOperation/ActionBarMode';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';

export class PhotoGridBarModel {
    private isDistributedAlbum: boolean = false;
    private albumId: string = '';

    setAlbumId(albumId: string) {
        this.albumId = albumId;
    }

    setDistributedAlbum(isDistributedAlbum: boolean) {
        this.isDistributedAlbum = isDistributedAlbum;
    }

    createActionBar(title: string | Resource, isSelectedMode: boolean, selectedCount: number,
                    isAllSelected: boolean, isEmpty: boolean): ActionBarProp {
        let actionBarProp: ActionBarProp = new ActionBarProp();
        let isHorizontal = screenManager.isHorizontal()
        if (isHorizontal) {
            this.updateHorizontalActionBar(actionBarProp, title, isSelectedMode, selectedCount, isAllSelected, isEmpty);
        } else {
            this.updateVerticalActionBar(actionBarProp, title, isSelectedMode);
        }
        return actionBarProp;
    }

    updateActionBar(actionBarProp: ActionBarProp, title: string | Resource, isSelectedMode: boolean,
                    selectedCount: number, isAllSelected: boolean, isEmpty: boolean): void {
        let isHorizontal = screenManager.isHorizontal()
        if (isHorizontal) {
            this.updateHorizontalActionBar(actionBarProp, title, isSelectedMode, selectedCount, isAllSelected, isEmpty);
        } else {
            this.updateVerticalActionBar(actionBarProp, title, isSelectedMode);
        }
    }

    private updateHorizontalActionBar(actionBarProp: ActionBarProp, title: string | Resource, isSelectedMode: boolean,
                                      selectedCount: number, isAllSelected: boolean, isEmpty: boolean): ActionBarProp {
        actionBarProp
            .setLeftAction(Action.BACK)
            .setTitle(title)
            .setMode(ActionBarMode.STANDARD_MODE);
        let menuList: Array<Action> = this.getMenuList(isSelectedMode, selectedCount, isAllSelected, isEmpty);
        if (isSelectedMode) {
            actionBarProp
                .setLeftAction(Action.CANCEL)
                .setMode(ActionBarMode.SELECTION_MODE)
                .setSelectionMode(ActionBarSelectionMode.MULTI);
        } else {
            if (!MediaConstants.ALBUM_DISABLE_NEW_LIST.has(this.albumId) && !this.isDistributedAlbum) {
                menuList.push(Action.NEW);
            }
        }
        actionBarProp.setMenuList(menuList);
        return actionBarProp;
    }

    private updateVerticalActionBar(actionBarProp: ActionBarProp, title: string | Resource, isSelectedMode: boolean): ActionBarProp {
        let menuList: Array<Action> = new Array<Action>();

        if (!MediaConstants.ALBUM_DISABLE_NEW_LIST.has(this.albumId) && !this.isDistributedAlbum) {
            menuList.push(Action.NEW);
        }

        actionBarProp
            .setLeftAction(Action.BACK)
            .setTitle(title)
            .setMenuList(menuList)
            .setMode(ActionBarMode.STANDARD_MODE);
        if (isSelectedMode) {
            menuList = [];
            actionBarProp
                .setLeftAction(Action.CANCEL)
                .setMenuList(menuList)
                .setMode(ActionBarMode.SELECTION_MODE)
                .setSelectionMode(ActionBarSelectionMode.MULTI);
        }

        return actionBarProp;
    }

    getMenuList(isSelectedMode: boolean, selectedCount: number, isAllSelected: boolean, isEmpty: boolean): Array<Action> {
        let menuList: Array<Action> = new Array<Action>();
        if (isSelectedMode) {
            if (this.albumId == MediaConstants.ALBUM_ID_RECYCLE) {
                menuList.push(Boolean(selectedCount) ? Action.RECOVER : Action.RECOVER_INVALID);
                menuList.push(Boolean(selectedCount) ? Action.DELETE : Action.DELETE_INVALID);
                menuList.push(isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL);
            } else if (this.isDistributedAlbum) {
                menuList.push(isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL);
                menuList.push(Boolean(selectedCount) ? Action.SHARE : Action.SHARE_INVALID);
                menuList.push(Boolean(selectedCount) ? Action.DOWNLOAD : Action.DOWNLOAD_INVALID);
            } else {
                menuList.push(Boolean(selectedCount) ? Action.SHARE : Action.SHARE_INVALID);
                menuList.push(isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL);
                menuList.push(Boolean(selectedCount) ? Action.DELETE : Action.DELETE_INVALID, Action.MORE);
            }
        } else {
            if (this.albumId == MediaConstants.ALBUM_ID_RECYCLE && !isEmpty) {
                menuList.push(Action.CLEAR_RECYCLE);
            }
        }
        return menuList;
    }
}