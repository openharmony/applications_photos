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
    favor(uri: string, isFavor: boolean): void;

    delete(uri: string, callback: any): void;
    move(uri: string, albumInfo: any, callback: any, isReplace: boolean, replaceUri?: string): void;
    copy(uri: string, albumInfo: any, callback: any, isReplace: boolean): void;
    trash(uri: string, callback: any): void;
    rename(oldName:any, newName:any): void;

    remark(): void;
}