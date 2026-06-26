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

/**
 * Record parameters passed from outside module: FA/third apps
 * These parameters should not be modified after read from want
 */
import lazy { Constants } from './Constants';
import type { DisplayName } from './DataTypes';
import lazy { CustomColors } from '@ohos.arkui.theme';
import lazy { MediaItem } from '../browser/photo/MediaItem';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { PickerColorMode, PickerOrientation, SingleLineConfig, PreselectedInfo } from '@ohos.file.PhotoPickerComponent';

export const FILTER_MEDIA_TYPE_ALL: string = 'FILTER_MEDIA_TYPE_ALL';

export class SelectConstants {
  //XXX色彩模式
  public static readonly RECOMMEND_TYPE_COLOR_STYPE: number = 12;
}

export enum SingleSelectionMode {
  BROWSER_MODE,
  SELECT_MODE,
  BROWSER_AND_SELECT_MODE
}

export enum ItemDisplayRatio {
  SQUARE_RATIO = 0,
  ORIGINAL_SIZE_RATIO = 1,
}

export class PickedMediaInfo {
  public uriArray: string[] = [];
  public mediaArray: MediaItem[] = [];
  public mediaType: number = 0;
}

export class SelectParams {
  /* max select count */
  public maxSelectCount: number = Constants.DEFAULT_MAX_THIRD_SELECT_COUNT;
  /* max select count */
  public maxPhotoSelectNumber: number = Constants.LIMIT_MAX_THIRD_SELECT_PHOTO_COUNT;
  /* max select count */
  public maxVideoSelectNumber: number = Constants.LIMIT_MAX_THIRD_SELECT_VIDEO_COUNT;
  public maxSelectedReminderMode: number = Constants.TOAST_REMIND_MODE;
  /* picker orientation */
  public orientation: PickerOrientation = PickerOrientation.VERTICAL;
  /* picker singleLineConfig */
  public singleLineConfig: SingleLineConfig | undefined = undefined;
  /* picker uiComponentColorMode */
  public uiComponentColorMode?: number = PickerColorMode.AUTO;
  /* select media type */
  public filterMediaType: string = FILTER_MEDIA_TYPE_ALL;
  public isFromWallpaper: boolean = false;
  /* whether entered from FA */
  public isFromFa: boolean = false;
  /* whether entered from pick photos in FA */
  public isFromFaPhoto: boolean = false;
  /* whether is multiple pick */
  public isMultiPick: boolean = false;
  /* caller bundle name */
  public bundleName: string = '';
  /* caller tokenId */
  public tokenId: number = 0;
  /* caller appId */
  public appId: string = '';
  /* Indicates the app clone index of caller. */
  public appCloneIndex: number = 0;
  /* whether picker from Camera */
  public cameraAble: boolean = true;
  /* whether picker can edit */
  public editAble: boolean = true;
  /* whether picker can search */
  public searchAble: boolean = true;
  public recommendationType: number = -1;
  /* Whether a single photo can be selected multiple times*/
  public isRepeatSelectSupported: boolean = false;
  public uri: string = '';
  public itemDisplayName: DisplayName | undefined = undefined;
  public itemId: string = '';
  public isFirstEnter: boolean = false;
  public itemCount: number = 0;
  public itemCoverUri: string = '';
  public remainingOfWallpapers: number = 0;
  public albumName: string = '';
  public albumUri: string = '';
  public isNewAlbum: boolean = false;
  public preData?: string[];
  public isUseSmartRecommendTabUri?: boolean;
  public isFromPickerView: boolean = false;
  public isHighlightPickerView: boolean = false; // 是否为时刻页面拉起picker
  public highlightPickerType: string = ''; // 具体时刻按钮拉起picker
  public isNeedActionBar: boolean = true;
  public isNeedSelectBar: boolean = true;
  public isOriginalSupported: boolean = true;
  public isPreviewForSingleSelectionSupported: boolean = true;
  public singleSelectionMode: number = SingleSelectionMode.BROWSER_MODE;
  public isPhotoBrowserCheckboxVisible: boolean = true;
  public isPhotoBrowserBackButtonVisible: boolean = true;
  public gridMargin: Margin = {};
  public photoBrowserMargin: Margin = {};
  public gridStartOffset: number = 0;
  public gridEndOffset: number = 0;
  public fontSize?: number | string;
  public statusBarHeight: number = 0;
  /**
   * 是否显示序号
   */
  public isShowSerialNum: boolean = false;
  public checkBoxColor: string = '';
  public checkboxTextColor: string = '';
  public backgroundColor: string = '';
  public themeColorMode: number = 0;
  public photoBrowserBackgroundColorMode: number = 0;
  public customColor: CustomColors | undefined = undefined;
  public completeButtonText: number = Number.NaN;
  public albumUriForRecover: string = '';
  public timeAnchorForRecover: number = 0;
  public displayNameForRecover: string = '';
  public dataIndexForRecover: number = 0;
  public isRecoverAlbum: boolean = false;
  public recoverSceneEnabled: boolean = false;
  public hasGotRecoverAnchor: boolean = false;
  public recommendationTypeForRecover: number = 0;
  public selectedRecommendationType: number = 0;
  public isSlidingSelectionSupported: boolean = false;
  public photoBrowserCheckboxPosition: [number, number] = [0, 0];
  public isImmersiveCompared: boolean = false;
  public isCollagePageEnter: boolean = false;
  public isFromAlbumSetPage: boolean = false;
  public unionAlbumUris: string[] = [];
  public userId: number = -1;
  public photoViewMimeTypeFilter?: photoAccessHelper.MimeTypeFilter;
  public fileSizeFilter?: photoAccessHelper.FileSizeFilter;
  public videoDurationFilter?: photoAccessHelper.VideoDurationFilter;
  public photoViewMimeTypeFileSizeFilters?: Array<photoAccessHelper.PhotoViewMimeTypeFileSizeFilter>;
  public combinedMediaTypeFilter?: Array<string>;
  public isCombinedMediaTypeFilterError?: boolean;
  // 调用方pid
  public callerPid?: string;
  // 调用方AbilityName
  public callerAbilityName?: string;
  public pickerIndex: number = -1;
  public preselectedInfos: PreselectedInfo[] = [];

  public static defaultParam(): SelectParams {
    return {
      maxSelectCount: Constants.DEFAULT_MAX_THIRD_SELECT_COUNT,
      maxPhotoSelectNumber: Constants.LIMIT_MAX_THIRD_SELECT_PHOTO_COUNT,
      maxVideoSelectNumber: Constants.LIMIT_MAX_THIRD_SELECT_VIDEO_COUNT,
      maxSelectedReminderMode: Constants.TOAST_REMIND_MODE,
      orientation: PickerOrientation.VERTICAL,
      singleLineConfig: undefined,
      uiComponentColorMode: PickerColorMode.AUTO,
      filterMediaType: FILTER_MEDIA_TYPE_ALL,
      isFromWallpaper: false,
      isFromFa: false,
      isFromFaPhoto: false,
      isMultiPick: false,
      isOriginalSupported: true,
      isPreviewForSingleSelectionSupported: true,
      singleSelectionMode: SingleSelectionMode.BROWSER_MODE,
      bundleName: '',
      tokenId: 0,
      appId: '',
      appCloneIndex: 0,
      cameraAble: true,
      editAble: true,
      searchAble: true,
      isRepeatSelectSupported: false,
      uri: '',
      itemDisplayName: undefined,
      itemId: '',
      isFirstEnter: false,
      itemCount: 0,
      itemCoverUri: '',
      remainingOfWallpapers: 0,
      albumName: '',
      albumUri: '',
      recommendationType: 0,
      isNewAlbum: false,
      isShowSerialNum: false,
      isFromPickerView: false,
      isHighlightPickerView: false,
      highlightPickerType: '',
      isNeedActionBar: true,
      isNeedSelectBar: true,
      checkBoxColor: '',
      checkboxTextColor: '',
      backgroundColor: '',
      themeColorMode: 0,
      photoBrowserBackgroundColorMode: 0,
      customColor: undefined,
      completeButtonText: 0,
      albumUriForRecover: '',
      timeAnchorForRecover: 0,
      displayNameForRecover: '',
      dataIndexForRecover: 0,
      isRecoverAlbum: false,
      recoverSceneEnabled: false,
      hasGotRecoverAnchor: false,
      recommendationTypeForRecover: 0,
      selectedRecommendationType: 0,
      isSlidingSelectionSupported: false,
      photoBrowserCheckboxPosition: [0, 0],
      isPhotoBrowserCheckboxVisible: true,
      isPhotoBrowserBackButtonVisible: true,
      isImmersiveCompared: false,
      isCollagePageEnter: false,
      isFromAlbumSetPage: false,
      unionAlbumUris: [],
      gridMargin: {},
      photoBrowserMargin: {},
      gridStartOffset: 0,
      gridEndOffset: 0,
      fontSize: 0,
      statusBarHeight: 0,
      userId: -1,
      pickerIndex: -1,
      preselectedInfos : [],
    };
  }
}