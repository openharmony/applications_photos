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

import { Action } from './Action';
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { ActionBarProp } from './ActionBarProp';
import { ActionBarMode } from './ActionBarMode';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { MediaOperationType } from '@ohos/base/src/main/ets/data/MediaOperationType';

@Component
export struct MediaOperationActionBar {
    @Consume pageType: string;
    @Consume @Watch('updateActionBar') loadingFinish: boolean;
    onMenuClicked: Function;
    @StorageLink('isHorizontal') isHorizontal: boolean = screenManager.isHorizontal();
    @State actionBarProp: ActionBarProp = new ActionBarProp();

    updateActionBar(): void {
        this.actionBarProp = this.createActionBar();
    }

    private createActionBar(): ActionBarProp {
        let menuList: Array<Action> = new Array<Action>();
        let actionBarProp: ActionBarProp = new ActionBarProp();
        if (this.loadingFinish) {
            menuList.push(Action.NEW);
        }
        actionBarProp
            .setHasTabBar(false)
            .setTitle((this.pageType == MediaOperationType.Move) ? $r('app.string.move_to') : $r('app.string.copy_to'))
            .setMode(ActionBarMode.STANDARD_MODE)
            .setMenuList(menuList)
            .setLeftAction(Action.CANCEL);
        return actionBarProp;
    }

    aboutToAppear(): void {
        this.actionBarProp = this.createActionBar();
    }

    build() {
        Column() {
            ActionBar({
                actionBarProp: $actionBarProp,
                onMenuClicked: this.onMenuClicked
            })
        }
    }
}