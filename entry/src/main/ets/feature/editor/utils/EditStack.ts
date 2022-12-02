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

export class EditStack<T> {
    private stack: T[] = [];
    private currentPosition: number = -1;

    isRedoValid(): boolean {
        return (this.currentPosition < this.stack.length - 1);
    }

    isUndoValid(): boolean {
        return (this.currentPosition >= 0);
    }

    redo(): number {
        if (this.isRedoValid()) {
            this.currentPosition++;
        }
        return this.currentPosition;
    }

    undo(): number {
        if (this.isUndoValid()) {
            this.currentPosition--;
        }
        return this.currentPosition;
    }

    reset() {
        this.stack.length = 0;
        this.currentPosition = -1;
    }

    getLength(): number {
        return this.stack.length;
    }

    getPosition(): number {
        return this.currentPosition;
    }

    at(index: number): T {
        return this.stack[index];
    }

    push(obj: T) {
        let reserveLength = this.currentPosition + 1;
        if (reserveLength < this.stack.length) {
            this.stack.length = reserveLength;
        }
        this.currentPosition = this.stack.push(obj) - 1;
    }

    executeEach(action: Function, count: number) {
        for (let i = 0; i < count; ++i) {
            action(this.stack[i]);
        }
    }
}