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
import { DateUtil } from '../../../utils/DateUtil';
export class MediaItem {
    index?: number;
    id: number;
    mediaType: number;
    uri: string;
    thumbnail: string;
    duration: number;
    title: string;
    size: number;
    dateTaken: number;
    dateModified: number;
    orientation: number;
    width: number;
    height: number;
    isFavor: boolean;
    type: string;
    displayName: string;
    filePath: string;
    path: string;

    constructor(data) {
        if (data == null) {
            return;
        }

        this.id = data.id;
        this.mediaType = data.mediaType;
        this.uri = data.uri;
        this.duration = data.duration;
        this.title = data.title;
        this.size = data.size;
        this.dateTaken = data.dateAdded * DateUtil.MILLISECONDS_PER_SECOND;   // TODO dateTaken is not supported, use dateAdded
        this.dateModified = data.dateModified * 1000;
        this.orientation = data.orientation;
        if (this.orientation == 90 || this.orientation == 270) {
            this.width = data.height;
            this.height = data.width;
        } else {
            this.width = data.width;
            this.height = data.height;
        }
        this.displayName = data.displayName;
        this.path = data.relativePath;
    }

    setThumbnail(thumbnail: string) {
        this.thumbnail = thumbnail;
    }

    setFavorite(isFavorite: boolean) {
        this.isFavor = isFavorite;
    }
}