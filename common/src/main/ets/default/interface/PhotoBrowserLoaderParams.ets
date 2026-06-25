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

import lazy { SelectManager } from '../model/browser/SelectManager';

export interface PhotoBrowserLoaderParams {
  operationPosition?: number;
  pageStatus: boolean;
  geometryTransitionEnable: boolean;
  isRunningAnimation: boolean;
  isFromPortrait?: boolean;
  isFromPortraitCoverSet?: boolean;
  selectManager?: SelectManager;
  isShowSideBar?: boolean;
  isShowSearchPage?: boolean;
  isFromGalleryCleanupPage?: boolean;
  isShowPhotoClassifieds?: boolean;
  isShowPortraitAlbumsView?: boolean;
  navigationPageInfos?: NavPathStack;
}