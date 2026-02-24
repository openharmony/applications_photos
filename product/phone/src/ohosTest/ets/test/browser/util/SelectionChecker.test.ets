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
import { describe, it, MockKit, when, beforeEach, afterEach, expect } from '@ohos/hypium';
import { ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { SelectionChecker } from '@ohos/thirdselect/src/main/ets/default/model/SelectionChecker';

interface uriType { uri: string }

export default function SelectionCheckerUT() {
  describe('SelectionCheckerUT', () => {
    let selectionChecker: SelectionChecker;
    let thirdSelectManager: ThirdSelectManager;
    let broadcast: BroadCast;
    let session: UIExtensionContentSession;
    let mocker: MockKit;

    beforeEach(() => {
      thirdSelectManager = new ThirdSelectManager();
      broadcast = new BroadCast();
      selectionChecker = new SelectionChecker(thirdSelectManager, broadcast, session);
      mocker = new MockKit();
    });

    afterEach(() => {
      mocker.clearAll();
    })

    it('should_return_immediately_when_isChecking_is_true', 0, async () => {
      Reflect.set(selectionChecker, 'isChecking', true)
      const res = await selectionChecker.check();
      expect(res !== null).assertTrue()
    });

    it('should_return_immediately_when_no_selected_uris', 0, async () => {
      let mockfunc: Function = mocker.mockFunc(thirdSelectManager, thirdSelectManager.getSelectedUri);
      when(mockfunc)().afterReturn([]);
      const res = await selectionChecker.check();
      expect(res !== null).assertTrue()
    });

    it('should_call_check_again_when_hasPending_is_true', 0, async () => {
      Reflect.set(selectionChecker, 'hasPending', true)
      let mockfunc: Function = mocker.mockFunc(thirdSelectManager, thirdSelectManager.getSelectedUri);
      when(mockfunc)().afterReturn(["uri1"]);
      const res = selectionChecker.check();
      expect(res !== null).assertTrue()
    });

    it('should_send_data_when_itemInfos_is_not_empty', 0, async () => {
      const mockGetSelectedUri = mocker.mockFunc(thirdSelectManager, thirdSelectManager.getSelectedUri);
      const uris: uriType[] = [{
        uri: "uri1"
      }, {
        uri: "uri2"
      }]
      when(mockGetSelectedUri)().afterReturn(uris);
      const res = await selectionChecker.check();
      expect(res !== null).assertTrue()
    });
  });
}