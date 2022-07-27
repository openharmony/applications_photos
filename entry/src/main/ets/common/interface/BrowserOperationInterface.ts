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

export interface BrowserOperationInterface {
    create(param: any): any;
    delete(uri: string): any;
    trash(uri: string, isTrash: boolean): any;
    copy(source: any, target: any): any;
    favor(uri: string, isFavor: boolean): void;
    setName(source: any, name: string): void;
    setOrientation(source: any, orientation: number): void;
    setRelativePath(source: any, relativePath: string): void;
    commitChanges(source :any): any;
}