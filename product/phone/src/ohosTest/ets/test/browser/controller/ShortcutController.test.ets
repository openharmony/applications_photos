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
import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  ShortcutController,
  ShortcutManager,
  Node
} from '@ohos/browsercommon/src/main/ets/default/controller/ShortcutController';
import { IntentionCode, KeyCode, KeyEvent } from '@kit.InputKit';

let shortcutController: ShortcutController | undefined = undefined;

export default function ShortcutControllerTest() {
  describe('ShortcutControllerTest', () => {

    beforeEach(() => {
      shortcutController = ShortcutManager.getInstance();
    });

    afterEach(() => {
      shortcutController = undefined;
    });

    it('buildList', 0, () => {
      buildList();
    });
    it('listen', 0, () => {
      listen();
    });
    it('removeListener', 0, () => {
      removeListener();
    });
    it('addListener', 0, () => {
      addListener();
    });
    it('removeList', 0, () => {
      removeList();
    });
  })
}

function buildList() {
  if (shortcutController == undefined) {
    return;
  }
  let curNode: Node = new Node(1, 1);
  let keys: number[] = [];
  let depth: number = 1;
  let cb: Function = () => {
  };
  (shortcutController as ESObject).buildList(curNode, keys, depth, cb);

  keys = [1];
  (shortcutController as ESObject).buildList(curNode, keys, depth, cb);

  keys = [1];
  (shortcutController as ESObject).buildList(curNode, keys, depth, cb);
}

function listen() {
  if (shortcutController == undefined) {
    return;
  }
  let event: ESObject = new Object() as ESObject;
  event.type = KeyType.Up;
  event.keyCode = KeyCode.KEYCODE_DPAD_LEFT;
  shortcutController.listen(event);

  event.type = KeyType.Up;
  event.keyCode = KeyCode.KEYCODE_PAGE_UP;
  shortcutController.listen(event);

  event.type = KeyType.Up;
  event.keyCode = KeyCode.KEYCODE_PAGE_DOWN;
  shortcutController.listen(event);

  event.type = KeyType.Down;
  event.keyCode = KeyCode.KEYCODE_A;
  shortcutController.listen(event);

  event.type = KeyType.Up;
  event.keyCode = KeyCode.KEYCODE_A;
  (shortcutController as ESObject).lastNode = { keyCode: KeyCode.KEYCODE_B };
  shortcutController.listen(event);

  event.type = KeyType.Up;
  event.keyCode = KeyCode.KEYCODE_A;
  (shortcutController as ESObject).lastNode = { keyCode: KeyCode.KEYCODE_A };
  shortcutController.listen(event);

  event.type = KeyType.Up;
  event.keyCode = KeyCode.KEYCODE_DPAD_RIGHT;
  shortcutController.listen(event);
  expect((shortcutController as ESObject).flag).assertTrue();
}

function removeListener() {
  if (shortcutController == undefined) {
    return;
  }
  let keys: number[] = [];
  let uid: number = 1;
  shortcutController.removeListener(keys, uid);

  keys = [5];
  uid = 1;
  (shortcutController as ESObject).nextNodesMap = [5];
  (shortcutController as ESObject).nextNode = [new Node(1, 1), new Node(1, 1)];
  let mocker: MockKit = new MockKit();
  let mockfunc: Function = mocker.mockFunc(shortcutController, (shortcutController as ESObject).removeList);
  shortcutController.removeListener(keys, uid);

  keys = [5];
  (shortcutController as ESObject).nextNodesMap = [0];
  shortcutController.removeListener(keys, uid);
  mocker.ignoreMock(shortcutController, (shortcutController as ESObject).removeList);
}

function addListener() {
  if (shortcutController == undefined) {
    return;
  }
  let cb: Function = () => {
  };
  let keys: number[] = [1];
  shortcutController.addListener(keys, cb);

  keys = [5];
  (shortcutController as ESObject).nextNodesMap = [5];
  shortcutController.addListener(keys, cb);

  keys = [];
  let result: number = shortcutController.addListener(keys, cb);
  expect(result).assertEqual(-1);
}

function removeList() {
  if (shortcutController == undefined) {
    return;
  }
  let mocker: MockKit = new MockKit();
  let mockfunc: Function = mocker.mockFunc(shortcutController, (shortcutController as ESObject).removeCb);

  let curNode: Node = new Node(1, 1);
  let keys: number[] = [];
  let uid: number = 1;
  (shortcutController as ESObject).removeList(curNode, keys, uid);

  keys = [1];
  curNode.nextNodesMap = [1];
  (shortcutController as ESObject).removeList(curNode, keys, uid);

  keys = [1];
  curNode.nextNodesMap = [];
  (shortcutController as ESObject).removeList(curNode, keys, uid);
  mocker.ignoreMock(shortcutController, (shortcutController as ESObject).removeCb);
}