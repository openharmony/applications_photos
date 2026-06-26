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
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { GridInitConfigSyncer } from './adapter/GridInitConfigSyncer';

export interface TimelinePageLoaderParams {
  isShowPhotoBrowser: boolean;
  isInCurrentTab: boolean;
  currentTabBarHeight: number;
  isSelectedModeIndex: boolean;
  tabsPaddingBottom: number;
  initTabsPaddingBottom: number;
  pageStatus: boolean;
  isShowSearchPage: boolean;
  isShowGallerySettingBasePage: boolean;
  isShowAboutGalleryPage: boolean;
  isShowTabAndSegmentButton: boolean;
  sideBarWidth: number;
  isShowSdCardTip: boolean;
  cardNameUris: string[];
  isChangeByClickTab: boolean;
  navPathStack: NavPathStack;
  isShowTabBar: boolean;
  gridInitConfigSyncer?: GridInitConfigSyncer;
  isConfigReady: boolean;
}