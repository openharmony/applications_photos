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

/* instrument ignore file */

import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';
import lazy { TimelineView } from '@ohos/timeline/src/main/ets/view/TimelineView';
import lazy { TimelinePageLoaderParams } from '@ohos/timeline/src/main/ets/view/TimelinePageLoaderParams';
import lazy { TimelineAppBarManager } from '../../viewmodel/TimelineAppBarManager'

@Builder
export function TimelinePageLoader($$: TimelinePageLoaderParams) {
  /* instrument ignore if */
  if (AlbumUtils.useNewPhotoGrid()) {
    TimelineView({
      isShowPhotoBrowser: $$.isShowPhotoBrowser,
      isInCurrentTab: $$.isInCurrentTab,
      currentTabBarHeight: $$.currentTabBarHeight,
      isSelectedModeIndex: $$.isSelectedModeIndex,
      tabsPaddingBottom: $$.tabsPaddingBottom,
      initTabsPaddingBottom: $$.initTabsPaddingBottom,
      pageStatus: $$.pageStatus,
      isShowSearchPage: $$.isShowSearchPage,
      isShowGallerySettingBasePage: $$.isShowGallerySettingBasePage,
      isShowAboutGalleryPage: $$.isShowAboutGalleryPage,
      isShowTabAndSegmentButton: $$.isShowTabAndSegmentButton,
      isShowSdCardTip: $$.isShowSdCardTip,
      cardNameUris: $$.cardNameUris,
      isChangeByClickTab: $$.isChangeByClickTab,
      navPathStack: $$.navPathStack,
      gridAppBarManager: new TimelineAppBarManager(),
      isShowTabBar: $$.isShowTabBar,
      gridInitConfigSyncer: $$.gridInitConfigSyncer,
      isConfigReady: $$.isConfigReady,
    })
  }
}