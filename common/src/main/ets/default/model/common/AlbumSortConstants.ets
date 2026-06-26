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

export class AlbumSortConstants {
  /**
   * “我的相册”区域标题索引
   */
  public static readonly MY_ALBUMS_AREA_HEADER_INDEX = 0;
  /**
   * “来自应用”区域标题索引
   */
  public static readonly SOURCE_ALBUMS_AREA_HEADER_INDEX = 1;
  /**
   * 恢复默认排序方式
   */
  public static readonly ON_RESTORE_DEFAULT_SORT_RULE: string = 'onRestoreDefaultSortRule';
  /**
   * 相册排序
   */
  public static readonly COMPONENT_KEY_SORT_ALBUMS: string = 'Sort Albums';
  /**
   * 顶部AppBar的高度
   */
  public static readonly APPBAR_HEIGHT: number = 56;
  /**
   * 排序页面内容顶部偏移量
   */
  public static readonly LIST_CONTENT_START_OFFSET: number = 8;
  /**
   * 排序页面内容底部偏移量
   */
  public static readonly LIST_CONTENT_END_OFFSET: number = 44;
  /**
   * 相册ListItem的间距
   */
  public static readonly LIST_ITEM_SPACE: number = 12;
  /**
   * ListItem圆角
   */
  public static readonly LIST_ITEM_BORDER_RADIUS: number = 20;
  /**
   * 相册封面圆角
   */
  public static readonly ALBUM_IMAGE_BORDER_RADIUS: number = 12;
  /**
   * 标题与ListItem的间距
   */
  public static readonly HEADER_BOTTOM: number = 8;
  /**
   * 小智慧相册封面的尺寸大小
   */
  public static readonly SMALL_SMART_ALBUM_COVER_SIZE: number = 24;
  /**
   * 相册封面尺寸大小
   */
  public static readonly ALBUM_COVER_SIZE: number = 48;
  /**
   * 相册封面右间距
   */
  public static readonly ALBUM_COVER_MARGIN_LEFT: number = 16;
  /**
   * 相册名称lineHeight
   */
  public static readonly ALBUM_NAME_LINE_HEIGHT: number = 19;
  /**
   * 分类相册/
   */
  public static readonly SMALL_SMART_ALBUM_BORDER_RADIUS: number = 4;
  /**
   * 相册ListItem的padding
   */
  public static readonly LIST_ITEM_PADDING: number = 12;
  /**
   * 相册ListItem的高度
   */
  public static readonly LIST_ITEM_HEIGHT: number = 72;
  /**
   * 置灰透明度
   */
  public static readonly GRAYSCALE_OPACITY: number = 0.4;
  /**
   * 小智慧相册行间距
   */
  public static readonly SMALL_SMART_ALBUM_ROW_GAP: number = 1;
  /**
   * 小智慧相册列间距
   */
  public static readonly SMALL_SMART_ALBUM_COLUMN_GAP: number = 1;
  /**
   * 小图标Size
   */
  public static readonly SMALL_ICON_FONT_SIZE: number = 20;
  /**
   * 排序页面挖空区避让空间
   */
  public static readonly DIGGING_HOLE_CAMERA_AREA: number = 22;
  /**
   * 排序页面横屏下栅格外边距
   */
  public static readonly PAGE_HORIZONTAL_MARGIN: number = 24;
  /**
   * 排序页面竖屏下栅格外边距
   */
  public static readonly PAGE_VERTICAL_MARGIN: number = 16;
  /**
   * 排序页面栅格布局槽间距
   */
  public static readonly PAGE_GUTTER: number = 16;
  /**
   * 相册封面顶部内边距
   */
  public static readonly IMAGE_COVER_PADDING_TOP: number = 12;
  /**
   * 相册封面底部内边距
   */
  public static readonly IMAGE_COVER_PADDING_BOTTOM: number = 12;
  /**
   * 相册封面右侧内边距
   */
  public static readonly IMAGE_COVER_PADDING_RIGHT: number = 16;
  /**
   * 相册封面左侧内边距
   */
  public static readonly IMAGE_COVER_PADDING_LEFT: number = 16;
  /**
   * 相册数据加载完成的广播标记
   */
  public static readonly ON_DATA_LOADING_FINISH: string = 'onDataLoadingFinish';
  /**
   * 相册排序页面
   */
  public static readonly ALBUM_SORT_PAGE: string = 'ALBUM_SORT_PAGE';
  /**
   * 侧边栏拖拽排序
   */
  public static readonly SIDEBAR_DRAG_SORT: string = 'SIDEBAR_DRAG_SORT';
}

/**
 * 相册排序接口设备区分
 */
export enum OrderStyle {
  PHONE_AND_PAD = 0,
  PC = 1
}

/**
 * PhotoAlbum表OrderStatus字段
 */
export enum AlbumOrderStatus {
  /**
   * 默认为无效
   */
  INVALID = 0,
  /**
   * 有效
   */
  VALID = 1
}

/**
 * 相册区域
 */
export enum AlbumOrderSection {
  /**
   * 未排序相册区域
   */
  UNSORTED_ALBUMS_AREA = -1,
  /**
   * 系统相册区域
   */
  SYSTEM_ALBUMS_AREA = 0,
  /**
   * 我的相册区域
   */
  MY_ALBUMS_AREA = 1,
  /**
   * 来自应用(来源相册)区域
   */
  SOURCE_ALBUMS_AREA = 2,
}

/**
 * 相册排序类型
 */
export enum AlbumOrderType {
  /**
   * 自定义排序
   */
  CUSTOM_SORT = 0,
  /**
   * 按名称排序
   */
  SORT_BY_NAME = 1
}

/**
 * 相册排序页面内对应区域相册数量
 */
export interface AlbumSortCount {
  /**
   * 系统相册区域的相册数量
   */
  systemAlbumAreaCount: number,
  /**
   * 我的相册区域的相册数量
   */
  myAlbumAreaCount: number,
}

/**
 * 相机、截图、屏幕录制
 */
export const SYSTEM_SOURCE_ALBUM_LPATH_ARRAY: string[] = [
  '/DCIM/Camera',
  '/Pictures/Screenshots',
  '/Pictures/Screenrecords'
]