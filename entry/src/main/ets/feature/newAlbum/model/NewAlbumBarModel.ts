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
import { ActionBarMode, ActionBarSelectionMode } from '../../../common/view/browserOperation/ActionBarMode';
import { ActionBarProp } from '../../../common/view/browserOperation/ActionBarProp';

export class NewAlbumBarModel {
    createActionBar(isSelectedMode: boolean, selectedCount: number): ActionBarProp {
        let menuList: Array<Action> = new Array<Action>();
        let actionBarProp: ActionBarProp = new ActionBarProp();
        menuList.push(Boolean(selectedCount) ? Action.OK : Action.OK_DISABLE)
        actionBarProp
            .setLeftAction(Action.CANCEL)
            .setMode(ActionBarMode.SELECTION_MODE)
            .setSelectionMode(ActionBarSelectionMode.MULTI)
            .setMenuList(menuList);
        return actionBarProp;
    }
}