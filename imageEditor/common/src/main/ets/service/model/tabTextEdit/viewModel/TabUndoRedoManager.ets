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
import { HiLog } from '../../../../common/util/HiLog';
import { Operation } from '../model/Operation';
import { ScaleValues } from '../model/ScaleValues';

const TAG = 'UndoRedoManager';

export class UndoRedoManager {
  private static instance: UndoRedoManager;
  protected undoList: Operation[] = [];
  protected redoList: Operation[] = [];

  private constructor() {
  }

  public static getInstance() {
    if (!UndoRedoManager.instance) {
      UndoRedoManager.instance = new UndoRedoManager();
    }
    return UndoRedoManager.instance;
  }

  public getUndoList() {
    return this.undoList;
  }

  public getRedoList() {
    return this.redoList;
  }

  public clear() {
    this.undoList.splice(0);
    this.redoList.splice(0);
  }

  private checkToClear() {
    HiLog.i(TAG, 'clear redoStack');
    this.redoList.splice(0);
  }

  public push(operation: Operation) {
    this.undoList.push(operation);
    this.checkToClear();
    this.print();
  }

  public refresh(scaleValues: ScaleValues) {
    this.refreshOperationList(this.undoList, scaleValues);
    this.refreshOperationList(this.redoList, scaleValues);
  }

  /* instrument ignore next */
  private refreshOperationList(operationList: Operation[], scaleValues: ScaleValues) {
    operationList.forEach(operation => {
      if (operation && operation.currentTextArea) {
        operation.currentTextArea.positionX = operation.currentTextArea.positionX * scaleValues.scaleValueX;
        operation.currentTextArea.positionY = operation.currentTextArea.positionY * scaleValues.scaleValueY;
      }
      if (operation && operation.previousTextArea) {
        operation.previousTextArea.positionX = operation.previousTextArea.positionX * scaleValues.scaleValueX;
        operation.previousTextArea.positionY = operation.previousTextArea.positionY * scaleValues.scaleValueY;
      }
    })
  }

  public canUndo() {
    return this.undoList.length > 0;
  }

  public canRedo() {
    return this.redoList.length > 0;
  }

  public undo() {
    let topItem: Operation | undefined = this.undoList.pop();
    /* instrument ignore if */
    if (!topItem) {
      HiLog.i(TAG, 'empty undoStack');
      return;
    }
    this.redoList.push(topItem);

    this.print();
    return topItem;
  }

  public redo() {
    let topItem: Operation | undefined = this.redoList.pop();
    /* instrument ignore if */
    if (!topItem) {
      HiLog.i(TAG, 'empty redoStack');
      return;
    }
    this.undoList.push(topItem);

    this.print();
    return topItem;
  }

  public print() {
    this.undoList.forEach((value) => {
      HiLog.i(TAG, `undoList, value.operateId:${value.operateId},value.operateType:${value.operateType}`);
    });
    this.redoList.forEach((value) => {
      HiLog.i(TAG, `undoList, value.operateId:${value.operateId},value.operateType:${value.operateType}`);
    });
  }
}