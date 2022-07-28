/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
export class MediaData {
    formId: string = '0';
    albumName: string = '';
    albumId: string = '';
    displayName: string = '';
    currentUri: string = '';
    currentIndex: number = 0;
    intervalTime: number = 0;
    //数据持久化保存布尔型目前存在问题，使用数字类型保存。
    isShowAlbumName: number = 0;
    arkUri: number = 0;

    constructor(formId: string, displayName: string, albumName: string,
                albumId: string, currentUri: string, currentIndex: number,
                intervalTime: number, isShowAlbumName: number, arkUri: number) {
        this.formId = formId;
        this.albumId = albumId;
        this.displayName = displayName;
        this.albumName = albumName;
        this.currentUri = currentUri;
        this.currentIndex = currentIndex;
        this.intervalTime = intervalTime;
        this.isShowAlbumName = isShowAlbumName;
        this.arkUri = arkUri;
    }
}
