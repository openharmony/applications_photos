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

export class AlbumInfo {
    id: string;
    coverUri: any;
    coverOrientation: number;
    name: string;
    uri: string;
    displayName: string;
    count: number;
    videoCount: number;
    isDisableRename: boolean;
    isDisableDelete: boolean;
    deviceId: string;
    deviceName: string;
    relativePath: string;
    innerId: string;

    constructor(id, uri, name, displayName, count, deviceId, relativePath) {
        this.id = id;
        this.coverUri = uri;
        this.name = name;
        this.displayName = displayName;
        this.count = count;
        this.isDisableRename = false;
        this.isDisableDelete = false;
        this.videoCount = 0;
        this.deviceId = deviceId;
        this.relativePath = relativePath;
    }
}
