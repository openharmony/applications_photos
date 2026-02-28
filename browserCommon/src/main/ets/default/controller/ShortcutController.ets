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
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { KeyCode } from '@ohos.multimodalInput.keyCode';

const TAG: string = 'ShortcutController';

let uid: number = 0;

export class ShortcutManager {
  public static getUid(): number {
    return uid++;
  }

  public static getInstance(): ShortcutController {
    if (!ShortcutManager.instance) {
      let manager = AppStorage.get<ShortcutController>(TAG);
      if (manager) {
        ShortcutManager.instance = manager;
        return manager;
      }
      ShortcutManager.instance = new ShortcutController();
      AppStorage.setOrCreate(TAG, ShortcutManager.instance);
    }
    return ShortcutManager.instance;
  }

  public static instance: ShortcutController | undefined = undefined;
}

export class Node {
  public keyCode: number | undefined = undefined;
  public depth: number = 0;
  public nextNodes: Node[] = [];
  public nextNodesMap: number[] = [];
  public callbacks: number[] = [];

  constructor(keyCode: number, depth: number) {
    this.keyCode = keyCode;
    this.depth = depth;
  }
}

export class ShortcutController {
  private cbMap = new Map<number, Function | undefined>();
  private timer = -1;
  private flag = true;
  // 根节点下子节点
  private nextNodes: Node[] = [];
  private nextNodesMap: number[] = [];
  private lastNode: Node | undefined = undefined;
  // 遍历到的当前节点下的子节点
  private curNodes: Node[] = [];
  private curNodesMap: number[] = [];

  /* instrument ignore next */
  private runCb(node: Node): void {
    let callbacks: number[] = node.callbacks;
    callbacks.forEach((cbKey: number): void => {
      let cb = this.cbMap.get(cbKey);
      cb && cb();
    })
  }

  private setCb(curNode: Node, cb: Function): number {
    let uid: number = ShortcutManager.getUid();
    curNode.callbacks.push(uid);
    this.cbMap.set(uid, cb);

    return uid;
  }

  /* instrument ignore next */
  private removeCb(curNode: Node, uid: number): void {
    let index: number = curNode.callbacks.indexOf(uid);
    if (index > -1) {
      curNode.callbacks.splice(index, 1);
      Log.info(TAG, `removeCb ${uid}`);
      this.cbMap.set(uid, undefined);
    }
  }

  private buildList(curNode: Node, keys: number[], depth: number, cb: Function): number {
    if (!keys.length) {
      return this.setCb(curNode, cb);
    }
    let index = curNode.nextNodesMap.indexOf(keys[0]);
    let uid: number = -1;
    if (index === -1) {
      let newNode = new Node(keys[0], depth + 1);
      curNode.nextNodes.push(newNode);
      curNode.nextNodesMap.push(keys[0]);
      keys.shift();
      uid = this.buildList(newNode, keys, depth + 1, cb);
    } else {
      keys.shift();
      uid = this.buildList(curNode.nextNodes[index], keys, depth + 1, cb);
    }

    return uid;
  }

  private removeList(curNode: Node, keys: number[], uid: number): void {
    if (!keys.length) {
      this.removeCb(curNode, uid);
      return;
    }
    let index = curNode.nextNodesMap.indexOf(keys[0]);
    if (index > -1) {
      keys.shift();
      this.removeList(curNode.nextNodes[index], keys, uid);
    }
  }

  public addListener(keys: number[], cb: Function): number {
    if (!keys.length) {
      return -1;
    }
    let index = this.nextNodesMap.indexOf(keys[0]);
    let uid: number = -1;
    if (index === -1) {
      this.nextNodesMap.push(keys[0]);
      let newNode = new Node(keys[0], 0);
      this.nextNodes.push(newNode);
      keys.shift();
      uid = this.buildList(newNode, keys, 0, cb);
    } else {
      let startNode = this.nextNodes[index];
      keys.shift();
      uid = this.buildList(startNode, keys, 0, cb);
    }
    this.resetCurrentNode();
    return uid;
  }

  public removeListener(keys: number[], uid: number): void {
    if (!keys.length) {
      return;
    }
    let index = this.nextNodesMap.indexOf(keys[0]);
    if (index > -1) {
      let startNode = this.nextNodes[index];
      keys.shift();
      this.removeList(startNode, keys, uid);
    }
  }

  public listen(event: KeyEvent): void {
    // 左右键弹起后,切换图片不用额外的限流
    if (event.type === KeyType.Up && event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
      Log.info(TAG, 'left key up');
      this.flag = true;
    } else if (event.type === KeyType.Up && event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
      Log.info(TAG, 'right key up');
      this.flag = true;
    } else if (event.type === KeyType.Up && event.keyCode === KeyCode.KEYCODE_PAGE_UP) {
      Log.info(TAG, 'page_up key up');
      this.flag = true;
    } else if (event.type === KeyType.Up && event.keyCode === KeyCode.KEYCODE_PAGE_DOWN) {
      Log.info(TAG, 'page_up key up');
      this.flag = true;
    }

    if (event.type === KeyType.Down) {
      this.listenDfs(event);
    } else if (this.lastNode?.keyCode !== event.keyCode) {
      this.resetCurrentNode();
    }
  }

  /* instrument ignore next */
  private listenDfs(event: KeyEvent): void {
    let keyCode = event.keyCode;
    let index = this.curNodesMap.indexOf(keyCode);
    if (this.lastNode?.keyCode === keyCode) {
      if (this.flag) {
        this.runCb(this.lastNode);
        this.flag = false;
        this.timer = setTimeout((): void => {
          this.flag = true;
          clearTimeout(this.timer);
        }, 300);
      }
      this.resetCurrentNode();
    } else if (index === -1) {
      this.resetCurrentNode();
    } else {
      let curNode = this.curNodes[index];
      this.lastNode = curNode;
      this.curNodes = curNode.nextNodes;
      this.curNodesMap = curNode.nextNodesMap;
      if (this.flag) {
        this.runCb(curNode);
        this.flag = false;
        this.timer = setTimeout((): void => {
          this.flag = true;
          clearTimeout(this.timer);
        }, 300);
      }
      this.resetCurrentNode();
    }
  }

  private resetCurrentNode(): void {
    Log.info(TAG, 'resetCurrentNode');
    this.lastNode = undefined;
    this.curNodes = this.nextNodes;
    this.curNodesMap = this.nextNodesMap;
  }
}