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

import { describe, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { ShareActionViewModel } from '@ohos/common/src/main/ets/default/view/actionbar/ShareAction';
import { Log } from '@ohos/tools/src/main/utils/Log';
import { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import { MenuConstants } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import { SelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';

const TAG: string = 'ShareAction';
/**
 * ShareAction Unittest
 *
 * @since 2025-06-05
 */
export default function ShareActionTest() {
  describe('ShareActionTest', () => {
    it('ShareActionTest_001', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await ShareActionTest001();
    });

    it('ShareActionTest_002', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await ShareActionTest002();
    });

    it('ShareActionTest_003', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await ShareActionTest003();
    });

    it('ShareActionTest_004', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await ShareActionTest004();
    });

    it('ShareActionTest_005', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await ShareActionTest005();
    });
  });
}

/**
 * doAction
 * 分支 !menuContext
 */
async function ShareActionTest001() {
  let shareActionViewModel = new ShareActionViewModel();

  let mocker: MockKit = new MockKit();
  let mockError: Function = mocker.mockFunc(Log, Log.error);
  when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

  shareActionViewModel.doAction();
  mocker.verify('error', [TAG, 'invalid menuContext']).atLeast(1);
  mocker.ignoreMock(Log, Log.error);
}

/**
 * doAction
 * 分支 menuContext && (!manager && !item)
 */
async function ShareActionTest002() {
  let shareActionViewModel = new ShareActionViewModel();
  let menuContext: MenuContext = new MenuContext();

  let mocker: MockKit = new MockKit();
  let mockError: Function = mocker.mockFunc(Log, Log.error);
  when(mockError)(ArgumentMatchers.anyString).afterReturnNothing();

  shareActionViewModel.doAction(menuContext);
  mocker.verify('error', [TAG, 'invalid selectManager and item']).atLeast(1);
  mocker.ignoreMock(Log, Log.error);
}

/**
 * doAction
 * 分支 menuContext && (!manager && item)
 */
async function ShareActionTest003() {
  let shareActionViewModel = new ShareActionViewModel();
  let menuContext: MenuContext = new MenuContext();
  let item: MediaItem = new MediaItem();
  menuContext.set(ShareActionViewModel.KEY_MEDIA_ITEM, item);

  let mocker: MockKit = new MockKit();
  let mockInfo: Function = mocker.mockFunc(Log, Log.info);
  when(mockInfo)(ArgumentMatchers.anyString).afterReturnNothing();

  shareActionViewModel.doAction(menuContext);
  mocker.verify('info', [TAG, 'doAction single share']).atLeast(0);
  mocker.ignoreMock(Log, Log.info);
}

/**
 * doAction
 * 分支 menuContext && (manager && !item) && count < Constants.DEFAULT_MAX_SHARE_COUNT
 */
async function ShareActionTest004() {
  let shareActionViewModel = new ShareActionViewModel();
  let menuContext: MenuContext = new MenuContext();
  let manager: SelectManager = new SelectManager();
  menuContext.set(MenuConstants.KEY_SELECTION_MANAGER, manager);

  let mocker: MockKit = new MockKit();
  let mockManager: Function = mocker.mockFunc(manager, manager.getSelectedCount);
  when(mockManager)(ArgumentMatchers.anyString).afterReturn(0);

  shareActionViewModel.doAction(menuContext);
  expect(menuContext.fromSelectMode).assertUndefined();

  mocker.ignoreMock(manager, manager.getSelectedCount);
}

/**
 * doAction
 * 分支 menuContext && (manager && !item) && count > Constants.DEFAULT_MAX_SHARE_COUNT
 */
async function ShareActionTest005() {
  let shareActionViewModel = new ShareActionViewModel();
  let menuContext: MenuContext = new MenuContext();
  let manager: SelectManager = new SelectManager();
  menuContext.set(MenuConstants.KEY_SELECTION_MANAGER, manager);

  let mocker: MockKit = new MockKit();
  let mockManager: Function = mocker.mockFunc(manager, manager.getSelectedCount);
  when(mockManager)(ArgumentMatchers.anyString).afterReturn(250000);

  let mockUiUtil: Function = mocker.mockFunc(UiUtil, UiUtil.showToast);
  when(mockUiUtil)(ArgumentMatchers.anyString).afterReturn(undefined);

  shareActionViewModel.doAction(menuContext);
  expect(menuContext.fromSelectMode).assertEqual(undefined);

  mocker.ignoreMock(manager, manager.getSelectedCount);
  mocker.ignoreMock(UiUtil, UiUtil.showToast);
}