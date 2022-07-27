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

import {Logger} from '../../utils/Logger'
import {ActionBarProp} from '../browserOperation/ActionBarProp'
import {Action} from '../browserOperation/Action'
import {ActionBarMode} from '../browserOperation/ActionBarMode'
import {SingleTitle} from './SingleTitle'
import {DetailTitle} from './DetailTitle'
import {SelectionTitle} from './SelectionTitle'
import {MenuPanel} from './MenuPanel'
import {DetailMenuPanel} from './DetailMenuPanel'
import {Constants} from '../../model/common/Constants'
import {ActionBarButton} from './ActionBarButton'

// ActionBar，It consists of action on the left, title in the middle and menu panel on the right
@Component
export struct ActionBar {
    @State isShowBar: boolean = true;
    @State actionBarProp: ActionBarProp = new ActionBarProp();
    onMenuClicked: Function;
    logger: Logger = new Logger('ActionBar');
    isVideoPage: boolean = false;
    @State hasTabBar: boolean = this.actionBarProp.getHasTabBar();

    private onBuildDone(): void {
        this.logger.info(`onBuildDone,actionBarProp:${this.actionBarProp.getHasTabBar()}, isShowBar:${this.isShowBar}`);
    }

    build() {
        Flex({
            direction: FlexDirection.Row,
            alignItems: ItemAlign.Center
        }) {
            if (!this.actionBarProp.getLeftAction().equals(Action.NONE)) {
                ActionBarButton({
                    res: this.actionBarProp.getLeftAction().iconRes,
                    action: this.actionBarProp.getLeftAction(),
                    onMenuClicked: this.onMenuClicked,
                    isLeft: true,
                    isAutoTint: this.actionBarProp.getLeftAction().isAutoTint,
                    colorMode: this.actionBarProp.getColorMode(),
                    isFirst: true
                })
            }
            if (this.actionBarProp.getMode() === ActionBarMode.DETAIL_MODE) {
                DetailMenuPanel({ actionBarProp: this.actionBarProp, onMenuClicked: this.onMenuClicked, isLeft: true })
            } else if (this.actionBarProp.getMode() === ActionBarMode.SELECTION_MODE) {
                Stack({alignContent: Alignment.Start}) {
                    SelectionTitle({ actionBarProp: this.actionBarProp })
                }.flexGrow(1)
                MenuPanel({ actionBarProp: this.actionBarProp, onMenuClicked: this.onMenuClicked })
            } else if (this.actionBarProp.getMode() === ActionBarMode.TOP_MODE) {
                Stack({alignContent: Alignment.Start}) {
                    DetailTitle({isVideoPage: this.isVideoPage})
                }.flexGrow(1)
                DetailMenuPanel({ actionBarProp: this.actionBarProp, onMenuClicked: this.onMenuClicked, isLeft: false })
            } else {
                Stack({ alignContent: Alignment.Start }) {
                    SingleTitle({ actionBarProp: this.actionBarProp })
                }.flexGrow(1)
                MenuPanel({ actionBarProp: this.actionBarProp, onMenuClicked: this.onMenuClicked })
            }
        }
        .height(Constants.ActionBarHeight)
            .zIndex(3)
            .width('100%')
            .backgroundColor(this.actionBarProp.getBackgroundColor())
            .opacity(this.actionBarProp.getAlpha())
            .padding({ right: $r('app.float.default_actionbar_padding_right'),
                left: (this.hasTabBar ?
                    $r('app.float.default_padding_start_with_tab_bar') :
                    $r('app.float.default_actionbar_padding_start_without_tab_bar'))
            })
            .visibility(this.isShowBar ? Visibility.Visible : Visibility.Hidden)
    }
}