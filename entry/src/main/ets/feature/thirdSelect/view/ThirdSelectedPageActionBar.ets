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

import {Action} from '../../../common/view/browserOperation/Action'
import {ActionBar} from '../../../common/view/actionbar/ActionBar'
import {ActionBarProp} from '../../../common/view/browserOperation/ActionBarProp'
import {ActionBarMode} from '../../../common/view/browserOperation/ActionBarMode'

@Component
export struct ThirdSelectedPageActionBar {
    @State menuList: Array<Action> = new Array<Action>();
    @State isUpdate: boolean = false;
    @Consume isSelectedMode: boolean;
    @Consume('selectedCount') @Watch('onSelectedCountChanged') selectedCount: number;
    @Consume maxSelectCount: number;
    isMultiPick: boolean;
    onMenuClicked: Function;
    leftAction: Action = Action.BACK;
    title: Resource;

    aboutToAppear(): void {
        if (this.isMultiPick == true) {
            this.onSelectedCountChanged();
        }
    }

    private createActionBar(): ActionBarProp {
        let actionBarProp: ActionBarProp = new ActionBarProp();
        actionBarProp
            .setLeftAction(this.leftAction)
            .setTitle(this.title)
            .setMenuList(this.menuList)
            .setMode(ActionBarMode.STANDARD_MODE)
            .setMaxSelectCount(this.maxSelectCount);
        return actionBarProp;
    }

    onSelectedCountChanged() {
        if (this.selectedCount == 0 || !this.isMultiPick) {
            this.title = ActionBarProp.SINGLE_UNSELECT_TITLE;
            this.menuList = [];
        } else {
            this.title = ActionBarProp.getCountDetailExternalSelectedTitle(this.selectedCount, this.maxSelectCount);
            this.menuList = [Action.OK];
        }
        this.isUpdate = !this.isUpdate;
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