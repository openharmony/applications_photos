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
import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { GridInitConfigSyncer } from '../../view/adapter/GridInitConfigSyncer';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { BindSheetController } from '../view/AlbumPhotoGridView'
import { PhotosHmBrowserController } from '@ohos/browserlibrary';

export interface AlbumPhotoGridLoaderParams {
  pageStatus: boolean;
  isShowPhotoBrowser: boolean;
  currentTabBarHeight: number;
  isSelectedModeIndex: boolean;
  tabsPaddingBottom: number;
  initTabsPaddingBottom: number;
  isShowHiddenGridView: boolean;
  isShowSearchPage: boolean
  isSelectedMode: boolean;
  isShowTabAndSegmentButton: boolean;
  navigationPageInfos: NavPathStack;
  sideBarWidth: number;
  isShowSdCardTip: boolean;
  cardNameUris: string[];
  actionBarController: ActionBarController;
  importDataSource?: AlbumDataSource | MediaDataSource;
  gridInitConfigSyncer?: GridInitConfigSyncer;
  navPathStack: NavPathStack;
  bindSheetController: BindSheetController;
  browserController: PhotosHmBrowserController;
}