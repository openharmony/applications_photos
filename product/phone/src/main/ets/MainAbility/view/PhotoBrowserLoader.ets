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
import lazy { PhotoBrowserLoaderParams } from '@ohos/common/src/main/ets/default/interface/PhotoBrowserLoaderParams';
import lazy { SelectPhotoBrowserView } from './SelectPhotoBrowserView';
import lazy { PhotoBrowserViewLoaderParams } from '@ohos/common/src/main/ets/default/interface/PhotoBrowserViewLoaderParams';
import lazy { PhotoBrowserView } from '@ohos/browserlibrary/src/main/ets/view/PhotoBrowserView';

@Builder
export function PhotoBrowserViewLoader($$: PhotoBrowserViewLoaderParams) {
  PhotoBrowserView({
    isShowBar: $$.isShowBar,
    pageStatus: $$.pageStatus,
    hidePhotoBrowser: $$.hidePhotoBrowser,
    isRunningAnimation: $$.isRunningAnimation,
    isShowMenu: $$.isShowMenu,
    canPullingUp: $$.canPullingUp,
    isShowThumbSource: $$.isShowThumbSource,
    isShowImageAnalyzer: $$.isShowImageAnalyzer,
    reportStartTime: $$.reportStartTime,
    onDeleteAllPhoto: $$.onDeleteAllPhoto,
  })
}

@Builder
export function SelectPhotoBrowserLoader($$: PhotoBrowserLoaderParams) {
  SelectPhotoBrowserView({
    pageStatus: $$.pageStatus,
    geometryTransitionEnable: $$.geometryTransitionEnable,
    isRunningAnimation: $$.isRunningAnimation,
    selectManager: $$.selectManager,
  })
}