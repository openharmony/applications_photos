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

import { Logger } from '../utils/Logger'
import { Action } from '../../../common/view/browserOperation/Action'
import { ToolBar } from '../../../common/view/actionbar/ToolBar'

@Component
export struct TimelinePageToolBar {
    @Consume @Watch('updateToolbar') isSelectedMode: boolean;
    @Consume @Watch('updateToolbar') isAllSelected: boolean;
    @Consume('selectedCount') @Watch('updateToolbar') selectedCount: number;
    onMenuClicked: Function;
    logger: Logger = new Logger('TimelinePageToolBar');
    @Provide toolMenuList: Array<Action> = new Array<Action>();

    aboutToAppear(): void {
        this.updateToolbar();
    }

    private updateToolbar(): void {
        this.logger.info('updateToolbar');
        if (this.isSelectedMode) {
            this.logger.info('pushActionToolbar');
            this.toolMenuList = [];
            this.toolMenuList.push(
                (Boolean(this.selectedCount) ? Action.SHARE : Action.SHARE_INVALID),
                (this.isAllSelected ? Action.DESELECT_ALL : Action.SELECT_ALL),
                (Boolean(this.selectedCount) ? Action.DELETE : Action.DELETE_INVALID), Action.MORE);
        }
    }

    build() {
        ToolBar({
            onMenuClicked: this.onMenuClicked
        })
    }
}