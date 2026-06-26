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
import lazy { IGridController } from '@ohos/common/src/main/ets/default/model/BrowserAnimController';
import lazy { PhotoAlbum } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

export interface ShowBrowserParam {
  // 调用者
  caller: string;
  // 目标跳转图片的index
  targetIndex: number;
  // 一境到底动效共享元素id
  geometryTransitionString: string;
  leftBlank: number[];
  isFromPortrait?: boolean;
  // 是否从人像卡片进入
  isFromPortraitCard?: boolean;
  // 时刻相册数据
  highlightPhotoAlbum?: PhotoAlbum;
  // 宫格gridController
  gridController?: IGridController;
  isFromGroup?: boolean;
}

export enum BrowserCaller {
  // 相机拉起
  CAMERA_PAGE = 'PhotoBrowserView',
  // 照片页
  TIMELINE_PAGE = 'TimelinePage',
  TIMELINE_PAGE_GROUP = 'TimelinePageGroup',
  // 相册页
  ALBUM_PAGE = 'PhotoGridPage',
  HIDDEN_ALBUM = 'PhotoHiddenView',
  HIDDEN_GRID_ALBUM = 'PhotoHiddenGridView',
  // 时刻页
  HIGHLIGHT_PAGE = 'ArtGridPage',
  // 搜索页
  SEARCH_GRID_PAGE = 'RealTimeGridView',
  SEARCH_GRID_PAGE_PC = 'RealTimeGridViewPC',
  SEARCH_SLOT_ITEM_PAGE = 'RealTimeSearchSlotItem',
  // 人像相册
  PORTRAIT_PHOTO_GRID_PAGE = 'PortraitPhotoGridPage',
  // 地点相册
  LOCATION_PHOTO_GRID_PAGE = 'LocationPhotoGridPage',
  // 主角星球
  PROTAGONIST_GRID_PAGE = 'ProtagonistPlanetGridPage',
  PROTAGONIST_ITEM_PAGE = 'ProtagonistPlanetPage',
  // 分享、录屏、桌面搜索
  VIEWDATA_PAGE = 'ViewData',
  // 拼图保存
  PUZZLE_PAGE = 'PuzzlePage',
  MOVIE_PAGE = 'MoviePage',

  // 上述calller在对应拉起大图入口设置
  // 自定义-正常回收站进入pageFrom为PhotoGridPage-（基于albumUri判断删除相册）
  RECYCLE = 'RecycleAlbum',
  // 自定义-FA卡片
  FACARD = 'FACard',
}

// 归一后browserCaller和归一前pageFrom转换关系
export const browserCallerMap: Map<string, number> = new Map<string, number>([
  [BrowserCaller.VIEWDATA_PAGE, Constants.ENTRY_FROM.VIEW_DATA],
  [BrowserCaller.HIDDEN_ALBUM, Constants.ENTRY_FROM.HIDDEN],
  [BrowserCaller.HIDDEN_GRID_ALBUM, Constants.ENTRY_FROM.HIDDEN],
]);