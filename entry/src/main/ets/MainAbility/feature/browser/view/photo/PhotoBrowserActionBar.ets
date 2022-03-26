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
import {ActionBarMode, ActionBarColorMode} from '../../../../common/model/browser/operation/ActionBarMode.ets'
import {ScreenManager} from '../../../../common/model/common/ScreenManager'

@Component
export struct PhotoBrowserActionBar {
    @Consume isShowBar: boolean;
    @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
    @StorageLink('leftBlank') leftBlank: [number, number, number, number]
        = [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
    onMenuClicked: Function;
    isVideoPage: boolean = false;

    private createActionBar(): ActionBarProp {
        let actionBarProp: ActionBarProp = new ActionBarProp();
        actionBarProp
            .setHasTabBar(false)
            .setLeftAction(Action.BACK)
            .setAlpha(ActionBarProp.PHOTO_BROWSER_ACTIONBAR_ALPHA)
            .setMode(ActionBarMode.TOP_MODE)
            .setColorMode(this.isVideoPage ? ActionBarColorMode.TRANSPARENT : ActionBarColorMode.NORMAL);
        return actionBarProp;
    }

    build() {
        Column() {
            if (this.isShowBar) {
                ActionBar({
                    isShowBar: true,
                    actionBarProp: this.createActionBar(),
                    onMenuClicked: this.onMenuClicked,
                    isVideoPage: this.isVideoPage
                })
            }
        }
        .markAnchor({x: '0%', y: '0%'})
        .position({x: '0%', y: this.leftBlank[1]})
    }
}