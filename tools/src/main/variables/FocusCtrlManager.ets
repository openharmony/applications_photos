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
import lazy { Log } from '../utils/Log';

const TAG: string = 'FocusCtrlManager';

export enum IndexFocusOrder {
  SIDEBAR = 1,
  SIDEBAR_DRAWER_BUTTON,
  ACTIONBAR_BUTTON,
  SEARCH_VIEW,
  SD_CARD_VIEW,
  PHOTO_GRID_VIEW,
  DETAIL_VIEW,
}
 
export class FocusCtrlManager {
  private static instance: FocusCtrlManager | undefined = undefined;
  // tab选择的相册元素
  private focusItemKey: string = '';

  private focusItemUri: string = '';

  private tabIndex: number = 0;

  private deleteCountBeforeFocus: number = 0;

  private focusItemIndex: number | undefined = undefined;
 
  private constructor() {
    Log.info(TAG, 'FocusCtrlManager constructor');
  }
 
  public static getInstance(): FocusCtrlManager {
    if (FocusCtrlManager.instance) {
      Log.debug(TAG, 'FocusCtrlManager singletonInstance exist');
      return FocusCtrlManager.instance;
    }
    let manager = AppStorage.get<FocusCtrlManager>('focusCtrl_manager');
    if (manager) {
      Log.info(TAG, `appStorage-FocusCtrlManager exist`);
      FocusCtrlManager.instance = manager;
      return manager;
    } else {
      Log.info(TAG, `appStorage-FocusCtrlManager not exist`);
      FocusCtrlManager.instance = new FocusCtrlManager();
      AppStorage.setOrCreate('focusCtrl_manager',
        FocusCtrlManager.instance);
      return FocusCtrlManager.instance;
    }
  }

  public static handleSideBarKeyEvent = (event: KeyEvent): void => {
    if (event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_RIGHT ||
      event.keyCode === MultimodalInputManager.KEY_CODE_KEYBOARD_LEFT
    ) {
      event.stopPropagation();
    }
  }
 
  public setFocusItemKey(str: string): void {
    Log.info(TAG, `setFocusItemKey ${str}`);
    this.focusItemKey = str;
  }

  public getFocusItemKey(): string {
    Log.info(TAG, `getFocusItemKey ${this.focusItemKey}`);
    return this.focusItemKey;
  }
  
  public setFocusItemUri(str: string): void {
    Log.info(TAG, `setFocusItemUri ${str}`);
    this.focusItemUri = str;
  }
  
  public getFocusItemUri(): string {
    Log.info(TAG, `getFocusItemUri ${this.focusItemUri}`);
    return this.focusItemUri;
  }

  public setTabIndex(index: number): void {
    this.tabIndex = index;
  }

  public getTabIndex(): number {
    return this.tabIndex;
  }

  public setDeleteCountBeforeFocus(count: number): void {
    this.deleteCountBeforeFocus = count;
  }

  public getDeleteCountBeforeFocus(): number {
    return this.deleteCountBeforeFocus;
  }

  public setFocusItemIndex(index: number | undefined): void {
    Log.info(TAG, `setFocusItemIndex ${index}`);
    this.focusItemIndex = index;
  }

  public getFocusItemIndex(): number | undefined {
    Log.info(TAG, `getFocusItemIndex ${this.focusItemIndex}`);
    return this.focusItemIndex;
  }
}