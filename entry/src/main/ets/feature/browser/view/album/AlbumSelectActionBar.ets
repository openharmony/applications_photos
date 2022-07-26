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

import {Action} from '../../../../common/view/browserOperation/Action'
import {ActionBar} from '../../../../common/view/actionbar/ActionBar'
import {ActionBarProp} from '../../../../common/view/browserOperation/ActionBarProp'
import {ActionBarMode, ActionBarSelectionMode} from '../../../../common/view/browserOperation/ActionBarMode'
import {ScreenManager} from '../../../../common/model/common/ScreenManager'
import {Logger} from '../../utils/Logger'

@Component
export struct AlbumSelectActionBar {
    @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
    @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();

    onMenuClicked : Function;
    logger: Logger = new Logger('AlbumSetPageActionBar');

    private createActionBar(): ActionBarProp {
        let menuList: Array<Action> = new Array<Action>();
        let actionBarProp: ActionBarProp = new ActionBarProp();
        menuList.push(Action.OK);
        actionBarProp
            .setLeftAction(Action.CANCEL)
            .setMode(ActionBarMode.SELECTION_MODE)
            .setSelectionMode(ActionBarSelectionMode.MULTI)
            .setMenuList(menuList);
        return actionBarProp;
    }

    build() {
        Column() {
            ActionBar({
                isShowBar: true,
                actionBarProp: this.createActionBar(),
                onMenuClicked: this.onMenuClicked
            })
        }
    }
}