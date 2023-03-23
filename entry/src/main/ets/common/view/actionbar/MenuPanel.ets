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

import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { ActionBarProp } from '../browserOperation/ActionBarProp';
import { Action } from '../browserOperation/Action';
import { ActionBarButton } from './ActionBarButton';

// MenuPanel，Right menu button panel
@Component
export struct MenuPanel {
    private TAG: string = 'MenuPanel';
    @Link actionBarProp: ActionBarProp;
    @State menuList: Action[] = [];
    onMenuClicked: Function;

    aboutToAppear(): void {
        Log.info(this.TAG, 'aboutToAppear.');
        this.onActionBarPropChanged();
    }

    private onActionBarPropChanged(): void {
        this.menuList = this.actionBarProp.getMenuList();
        Log.info(this.TAG, `onActionBarPropChanged, menu's size: ${this.menuList.length}`);
        this.menuList.forEach((menu: Action) => {
            Log.info(this.TAG, `ActionId: ${menu.actionID}`);
        })
    }

    private onBuildDone(): void {
        Log.info(this.TAG, `onBuildDone, menu's size: ${this.menuList.length}`);
    }

    build() {
        Row() {
            ForEach(this.actionBarProp.getMenuList(), (menu: Action) => {
                ActionBarButton({
                    res: menu.iconRes,
                    action: menu,
                    onMenuClicked: this.onMenuClicked,
                    isAutoTint: menu.isAutoTint,
                    colorMode: this.actionBarProp.getColorMode()
                })
            }, menu => JSON.stringify(menu.actionID))
        }
        .alignItems(VerticalAlign.Center)
    }
}