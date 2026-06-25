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

import lazy { AccurateGroupHandleInfo } from './AccurateGroupInfo';
import lazy { AccurateUpdateItemsInfo } from './AccurateUpdateItemsInfo';
import lazy { AlbumInfo } from './browser/album/AlbumInfo';
import lazy { LoadingInfo } from './DataSource';
import lazy { MediaLibChangeInfo } from './MediaLibChangeInfo';

export interface TimelineLoadingInfo extends MediaLibLoadingInfo {
  readonly newGroupsHandleInfo: AccurateGroupHandleInfo;
  readonly newItemsUpdateInfo: AccurateUpdateItemsInfo;
  readonly albumInfo?: AlbumInfo
}

export interface MediaLibLoadingInfo extends LoadingInfo {
  readonly changeInfo: MediaLibChangeInfo;
}