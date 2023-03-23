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
import { ActionBar } from '../../../common/view/actionbar/ActionBar';
import { ActionBarProp } from '../../../common/view/browserOperation/ActionBarProp';
import { ActionBarMode, ActionBarColorMode } from '../../../common/view/browserOperation/ActionBarMode';
import { Constants } from '../../../common/model/common/Constants';
import { Log } from '@ohos/base/src/main/ets/utils/Log';

@Component
export struct PhotoBrowserActionBar {
    @Consume @Watch('updateActionBar') menuList: Action[];
    onMenuClicked: Function;
    isVideoPage: boolean = false;
    @State actionBarProp: ActionBarProp = new ActionBarProp();

    updateActionBar(): void {
        Log.info('PhotoBrowserActionBar', 'updateActionBar');
        this.actionBarProp = this.createActionBar();
    }

    private createActionBar(): ActionBarProp {
        let actionBarProp: ActionBarProp = new ActionBarProp();
        actionBarProp
            .setHasTabBar(false)
            .setLeftAction(Action.BACK)
            .setAlpha(ActionBarProp.PHOTO_BROWSER_ACTIONBAR_ALPHA)
            .setMode(ActionBarMode.TOP_MODE)
            .setColorMode(this.isVideoPage ? ActionBarColorMode.TRANSPARENT : ActionBarColorMode.NORMAL)
            .setMenuList(this.menuList)
        return actionBarProp;
    }

    aboutToAppear(): void {
        this.actionBarProp = this.createActionBar();
    }

    build() {
        Column() {
            ActionBar({
                actionBarProp: $actionBarProp,
                onMenuClicked: this.onMenuClicked,
                isVideoPage: this.isVideoPage
            }).sharedTransition("actionBar", {
                    type:SharedTransitionEffectType.Static,
                    duration: Constants.SHARE_TRANSITION_DURATION,
                    zIndex: 2,
                })

        }
        .markAnchor({ x: '0%', y: '0%' })
        .position({ x: '0%', y: '0%' })
    }
}