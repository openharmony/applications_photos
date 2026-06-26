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

import lazy { MediaItem } from '../browser/photo/MediaItem';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { ViewData } from '../browser/photo/ViewData';
import lazy { AlbumSimpleInfo } from '../browser/album/AlbumDataImpl';
import lazy { TimelineData } from '../browser/photo/TimelineData';
import lazy data_preferences from '@ohos.data.preferences';
import lazy { PhotoAsset } from '../../access/PhotoAccessHelperAccess';
import lazy { AlbumInfo } from '../browser/album/AlbumInfo';

export interface AsyncCallback<T = TBrowser.Group> {
  callback: Function;
}

export namespace TBrowser {
  export type Individual = MediaItem | AlbumInfo | ViewData | PhotoAsset;

  export type Group = Individual | Individual[] | Map<string, Individual> | AlbumSimpleInfo |
  TimelineData[] | data_preferences.Preferences | number | boolean ;

  export type MayVoid = Group | photoAccessHelper.Album | void;

  export interface AsyncCallback<T = TBrowser.Group> {
    callback(t?: T, param?: string): void;
  }
}