/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import lazy { Action } from './browserOperation/Action';
import lazy {
  RightClickMenuGroup,
  MenuController,
  MenuPopUpParams,
  PopType
} from './menu/MenuController';
import lazy { MenuPopUp } from './menu/MenuView';

@Component
export struct GridRightClickMenu {
  @Prop private controller: MenuController;
  @Prop gridRightClickMenuList: RightClickMenuGroup[] = [];
  @Prop isPasteboardHasData: boolean;
  @Prop canRedo: boolean;
  @Prop canUndo: boolean;
  private onMenuClick: Function = (action: Action): void => {
  };

  private getMenuPopUpParams(): MenuPopUpParams {
    const params: MenuPopUpParams = {
      type: PopType.GRID,
      isPasteboardHasData: this.isPasteboardHasData,
      canRedo: this.canRedo,
      canUndo: this.canUndo,
      onMenuClick: (menu: Action): void => this.onMenuClick(menu),
    }
    return params;
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Start,
      alignItems: ItemAlign.Start,
    }) {
      MenuPopUp({
        controller: this.controller,
        menuPopUpParams: this.getMenuPopUpParams(),
      })
      .key('grid_RightClickMenu')
    }
  }
}