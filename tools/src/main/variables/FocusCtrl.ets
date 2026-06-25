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

import lazy {
  MultimodalInputManager
} from '../../../../common/src/main/ets/default/model/common/MultimodalInputManager';

/**
 * 业务: 焦点
 */
export namespace FocusCtrl {
  // tab选择的相册元素
  export let focusItemKey: string = '';

  export let focusItemUri: string = '';

  export let tabIndex: number = 0;

  export let deleteCountBeforeFocus: number = 0;

  export let focusItemIndex: number | undefined = undefined;

  export enum IndexFocusOrder {
    SIDEBAR = 1,
    SIDEBAR_DRAWER_BUTTON,
    ACTIONBAR_BUTTON,
    SEARCH_VIEW,
    SD_CARD_VIEW,
    PHOTO_GRID_VIEW,
    DETAIL_VIEW,
  }

  export const handleSideBarKeyEvent = (event: KeyEvent): void => {
    if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_RIGHT ||
      event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_LEFT
    ) {
      event.stopPropagation();
    }
  }
}