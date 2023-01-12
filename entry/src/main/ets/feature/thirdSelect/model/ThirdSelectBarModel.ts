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
import { ActionBarMode } from '../../../common/view/browserOperation/ActionBarMode';

export class ThirdSelectBarModel {
    createActionBar(originLeftAction: Action, originTitle: string | Resource, isMultiPick: boolean,
		    selectedCount: number, maxSelectCount: number, isSelectPhotoGrid: boolean): ActionBarProp {
        let leftAction: Action = originLeftAction;
        let title: string | Resource = originTitle;
        let menuList: Action[];
        if (isSelectPhotoGrid == true) {
            menuList = [Action.NAVIGATION_ALBUMS];
        } else {
            if (isMultiPick && selectedCount > 0 && maxSelectCount > 0) {
                title = ActionBarProp.getCountDetailExternalSelectedTitle(selectedCount, maxSelectCount);
                menuList = [Action.OK];
            } else {
                menuList = [];
            }
        }

        let actionBarProp: ActionBarProp = new ActionBarProp();
        actionBarProp
            .setLeftAction(leftAction)
            .setTitle(title)
            .setMenuList(menuList)
            .setMode(ActionBarMode.STANDARD_MODE)
            .setMaxSelectCount(maxSelectCount);
        return actionBarProp;
    }
}