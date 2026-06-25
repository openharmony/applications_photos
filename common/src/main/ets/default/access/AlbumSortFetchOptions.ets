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

import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy {
  AlbumOrderSection,
  AlbumOrderType,
  SYSTEM_SOURCE_ALBUM_LPATH_ARRAY
} from '../model/common/AlbumSortConstants';
import lazy { QueryAlbumParam } from '../interface/BrowserDataInterface'
import lazy { SHARE_ALBUM_LPATH } from './PhotoAccessHelperAccess';
import lazy { Log } from '../utils/Log';

type FetchOptions = photoAccessHelper.FetchOptions;


const TAG: string = 'AlbumSortFetchOptions';


/**
 * 获取移动到页面排序相册数量FetchOption
 * @returns
 */
export function getMovePageAlbumsCountFilterUnionAlbumsFetchOption(): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates()
    // 整体条件：(普通相册 OR 更多相册) AND 排除子类型
    .beginWrap()
      // 普通相册 OR 更多相册
      .beginWrap()
        // 普通相册区域条件
        .beginWrap()
          // 已排序到普通相册区域的相册进行筛选
          .beginWrap()
            .beginWrap()
              .equalTo('order_section', AlbumOrderSection.SYSTEM_ALBUMS_AREA)
              .or()
              .equalTo('order_section', AlbumOrderSection.MY_ALBUMS_AREA)
            .endWrap()
            .and()
            .beginWrap()
              // 子条件1：用户相册（允许count任意）
              .beginWrap()
                .equalTo('album_type', photoAccessHelper.AlbumType.USER)
              .endWrap()
              .or()
              // 子条件2：特定lpath且count≠0
              .beginWrap()
                .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
              .or()
              // 子条件3：来源相册且count≠0
              .beginWrap()
                .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
            .endWrap()
          .endWrap()
          .or()
          .beginWrap()
            .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
            .and()
            .beginWrap()
              .equalTo('album_type', photoAccessHelper.AlbumType.USER)
              .or()
              .beginWrap()
                .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
            .endWrap()
          .endWrap()
        .endWrap()
        .or()
        // 更多相册区域条件（修正后，包含系统相册和特定路径的count≠0情况）
        .beginWrap()
          // 情况1：明确的更多相册区域（order_section=1）
          .beginWrap()
            .equalTo('order_section', AlbumOrderSection.SOURCE_ALBUMS_AREA)
            .and()
            .beginWrap()
              // 子条件1：用户相册（允许count任意）
              .beginWrap()
                .equalTo('album_type', photoAccessHelper.AlbumType.USER)
              .endWrap()
              .or()
              // 子条件2：特定lpath且count≠0
              .beginWrap()
                .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
              .or()
              // 子条件3：来源相册且count≠0
              .beginWrap()
                .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
            .endWrap()
          .endWrap()
          .or()
          // 情况2：未排序区域（order_section=-1）且满足更多相册逻辑条件
          .beginWrap()
            .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
            .and()
            .beginWrap()
              .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
              .and()
              .notEqualTo('count', 0)
              .and()
              .notIn('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .endWrap()
          .endWrap()
        .endWrap()
      .endWrap()
    .endWrap()
    // 公共排除子类型条件（仅需写一次）
    .and()
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.IMAGE,
      photoAccessHelper.AlbumSubtype.VIDEO,
      photoAccessHelper.AlbumSubtype.FAVORITE,
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    .and()
    .beginWrap()
    // 过滤融合相册数量
    .or()
    .isNull('lpath')
    .endWrap()
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  return fetchOptions;
}

/**
 * 获取移动到页面相册数据FetchOption
 * @param param
 * @returns
 */
export function getMovePageAlbumsFetchOption(param: QueryAlbumParam): FetchOptions {
  const predicates = new dataSharePredicates.DataSharePredicates()
    // 整体条件：(普通相册 OR 更多相册) AND 排除子类型
    .beginWrap()
      // 普通相册 OR 更多相册
      .beginWrap()
        // 普通相册区域条件
        .beginWrap()
          // 情况1：已排序到普通相册区域的相册进行筛选
          .beginWrap()
            .beginWrap()
              .equalTo('order_section', AlbumOrderSection.SYSTEM_ALBUMS_AREA)
              .or()
              .equalTo('order_section', AlbumOrderSection.MY_ALBUMS_AREA)
            .endWrap()
            .and()
            .beginWrap()
              // 子条件1：用户相册（允许count任意）
              .beginWrap()
                .equalTo('album_type', photoAccessHelper.AlbumType.USER)
              .endWrap()
              .or()
              // 子条件2：特定lpath且count≠0
              .beginWrap()
                .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
              .or()
              // 子条件3：来源相册且count≠0
              .beginWrap()
                .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
            .endWrap()
          .endWrap()
          .or()
          // 情况2：未排序区域（order_section=-1）但满足普通相册筛选条件
          .beginWrap()
            .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
            .and()
            .beginWrap()
              .equalTo('album_type', photoAccessHelper.AlbumType.USER)
              .or()
              .beginWrap()
                .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
            .endWrap()
          .endWrap()
        .endWrap()
        .or()
        // 更多相册区域条件（修正后，包含系统相册和特定路径的count≠0情况）
        .beginWrap()
          // 情况1：明确的更多相册区域（order_section=1）
          .beginWrap()
            .equalTo('order_section', AlbumOrderSection.SOURCE_ALBUMS_AREA)
            .and()
            .beginWrap()
              // 子条件1：用户相册（允许count任意）
              .beginWrap()
                .equalTo('album_type', photoAccessHelper.AlbumType.USER)
              .endWrap()
              .or()
              // 子条件2：特定lpath且count≠0
              .beginWrap()
                .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
              .or()
              // 子条件3：来源相册且count≠0
              .beginWrap()
                .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
            .endWrap()
          .endWrap()
          .or()
          // 情况2：未排序区域（order_section=-1）且满足更多相册逻辑条件
          .beginWrap()
            .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
            .and()
            .beginWrap()
              .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
              .and()
              .notEqualTo('count', 0)
              .and()
              .notIn('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .endWrap()
          .endWrap()
        .endWrap()
      .endWrap()
    .endWrap()
    // 公共排除子类型条件（仅需写一次）
    .and()
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.IMAGE,
      photoAccessHelper.AlbumSubtype.VIDEO,
      photoAccessHelper.AlbumSubtype.FAVORITE,
      photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT,
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    .orderByAsc(
      '-- 第一优先级：相册区域（普通在前，更多在后）\n' +
        '  CASE\n' +
        '    WHEN (order_section = ' + AlbumOrderSection.SYSTEM_ALBUMS_AREA +
        '     OR order_section = ' + AlbumOrderSection.MY_ALBUMS_AREA +
        '     OR (order_section = -1 AND (album_type IN (0, 1024) ' +
        '     OR lpath IN (\'/DCIM/Camera\', \'/Pictures/Screenshots\', \'/Pictures/Screenrecords\')))) THEN 0\n' +
        '    WHEN order_section = ' + AlbumOrderSection.SOURCE_ALBUMS_AREA +
        '     OR (order_section = -1 AND album_type NOT IN (0, 1024) ' +
        '     AND lpath NOT IN (\'/DCIM/Camera\', \'/Pictures/Screenshots\', \'/Pictures/Screenrecords\')) THEN 1\n' +
        '    ELSE 999999\n' +
        '  END,\n' +
        '-- 第二优先级：各区域内部的排序规则\n' +
        '  CASE\n' +
        '    -- 普通相册区域排序规则（保持不变）\n' +
        '    WHEN (order_section = ' + AlbumOrderSection.SYSTEM_ALBUMS_AREA +
        '     OR order_section = ' + AlbumOrderSection.MY_ALBUMS_AREA +
        '     OR (order_section = -1 AND (album_type IN (0, 1024) ' +
        '     OR lpath IN (\'/DCIM/Camera\', \'/Pictures/Screenshots\', \'/Pictures/Screenrecords\')))) THEN\n' +
        '      CASE\n' +
        '        -- 优先级1：lpath路径\n' +
        '        WHEN albums_order = -1 AND lpath = \'/DCIM/Camera\' THEN 5 -- 相机\n' +
        '        WHEN albums_order = -1 AND lpath = \'/Pictures/Screenshots\' THEN 6 -- 截屏\n' +
        '        WHEN albums_order = -1 AND lpath = \'/Pictures/Screenrecords\' THEN 7 -- 录屏\n' +
        '        -- 优先级2 区域优先级（albums_order≠-1的情况）：albums_order != -1\n' +
        '        WHEN albums_order != -1 THEN\n' +
        '          CASE\n' +
        '            WHEN order_section = ' + AlbumOrderSection.SYSTEM_ALBUMS_AREA + ' THEN 8 + albums_order\n' +
        '            WHEN order_section = ' + AlbumOrderSection.MY_ALBUMS_AREA + ' THEN 90000 + albums_order\n' +
        '          END\n' +
        '        -- 优先级3：albums_order=-1且album_type≠1024的自定义相册\n' +
        '        WHEN albums_order = -1 AND album_type != 1024 THEN 100000 ' +
        '      END\n' +
        '    -- 更多相册区域排序规则（修改后）\n' +
        '    WHEN (order_section = ' + AlbumOrderSection.SOURCE_ALBUMS_AREA +
        '     OR (order_section = -1 AND album_type NOT IN (0, 1024) ' +
        '     AND lpath NOT IN (\'/DCIM/Camera\', \'/Pictures/Screenshots\', \'/Pictures/Screenrecords\'))) THEN\n' +
        '      CASE\n' +
        '        -- 优先级1：albums_order=-1且lpath=分享（保持不变）\n' +
        '        WHEN albums_order = -1 AND lpath = \'' + SHARE_ALBUM_LPATH + '\' THEN 100 -- 分享\n' +
        '        -- 优先级2：albums_order≠-1（按albums_order升序，保持不变）\n' +
        '        WHEN albums_order != -1 THEN 101 + albums_order\n' +
        '        -- 优先级3：albums_order=-1且lpath≠分享（按count倒序，count相同按album_id升序）\n' +
        '        WHEN albums_order = -1 THEN 300000 - count -- 通过count倒序（count越大值越小，排在越前）\n' +
        '        ELSE 999999\n' +
        '      END\n' +
        '    ELSE 999999\n' +
        '  END,\n' +
        '-- 新增：更多相册区域中albums_order=-1且count相同的情况，按album_id升序\n' +
        '  CASE\n' +
        '    WHEN (\n' +
        '      (order_section = ' + AlbumOrderSection.SOURCE_ALBUMS_AREA + ' OR order_section = -1)\n' +
        '      AND albums_order = -1\n' +
        '    ) THEN album_id\n' +
        '    ELSE 0 -- 其他情况不影响排序\n' +
        '  END,\n' +
        '-- 规格：albums_order≠-1且值相同的情况下，按 albumName 排序\n' +
        '  CASE\n' +
        '    WHEN albums_order != -1 THEN album_name\n' +
        '    ELSE \'\'  -- albums_order=-1 时统一返回空字符串，避免干扰排序\n' +
        '  END,\n' +
        '-- 最终稳定排序（保持不变）\n' +
        '  album_id'
    )
    .limit(param?.count, param?.start);
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  return fetchOptions;
}

/**
 * 获取所有排序相册数据FetchOption
 * @param param
 * @returns
 */
export function getAllSortedAlbumsFetchOption(param: QueryAlbumParam): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates()
  // 整体条件：(普通相册 OR 更多相册) AND 排除子类型
    .beginWrap()
      // 普通相册 OR 更多相册
      .beginWrap()
        // 普通相册区域条件
        .beginWrap()
          // 已排序到普通相册区域的相册进行筛选
          .beginWrap()
            .beginWrap()
              .equalTo('order_section', AlbumOrderSection.SYSTEM_ALBUMS_AREA)
              .or()
              .equalTo('order_section', AlbumOrderSection.MY_ALBUMS_AREA)
            .endWrap()
            .and()
            .beginWrap()
              // 子条件1：用户相册（允许count任意）
              .beginWrap()
                .equalTo('album_type', photoAccessHelper.AlbumType.USER)
              .endWrap()
              .or()
              // 子条件2：系统相册且count≠0
              .beginWrap()
                .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
              .or()
              // 子条件3：特定lpath且count≠0
              .beginWrap()
                .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
              .or()
              // 子条件4：来源相册且count≠0
              .beginWrap()
                .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
            .endWrap()
          .endWrap()
          .or()
          // 未排序但属于普通相册区域的相册进行筛选
          .beginWrap()
            .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
            .and()
            .beginWrap()
              .equalTo('album_type', photoAccessHelper.AlbumType.USER)
              .or()
              .beginWrap()
                .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
              .or()
              .beginWrap()
                .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
            .endWrap()
          .endWrap()
        .endWrap()
        .or()
        // 更多相册区域筛选条件
        .beginWrap()
          // 已排序到更多相册区域的相册进行筛选
          .beginWrap()
            .equalTo('order_section', AlbumOrderSection.SOURCE_ALBUMS_AREA)
            .and()
            .beginWrap()
              // 子条件1：用户相册（允许count任意）
              .beginWrap()
                .equalTo('album_type', photoAccessHelper.AlbumType.USER)
              .endWrap()
              .or()
              // 子条件2：系统相册或特定lpath且count≠0
              .beginWrap()
                .beginWrap()
                  .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
                  .or()
                  .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
                .endWrap()
                .and()
                .notEqualTo('count', 0)
              .endWrap()
              .or()
              // 子条件3：来源相册且count≠0
              .beginWrap()
                .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
                .and()
                .notEqualTo('count', 0)
              .endWrap()
            .endWrap()
          .endWrap()
          .or()
          // 未排序相册但是属于更多相册区域的相册进行筛选
          .beginWrap()
            .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
            .and()
            .beginWrap()
              .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
              .and()
              .notEqualTo('count', 0)
              .and()
              .notIn('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .endWrap()
          .endWrap()
        .endWrap()
      .endWrap()
    .endWrap()
    // 公共排除子类型条件（仅需写一次）
    .and()
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    .orderByAsc(
      '-- 第一优先级：相册区域（普通在前，更多在后）\n' +
        '  CASE\n' +
        '    WHEN (order_section = ' + AlbumOrderSection.SYSTEM_ALBUMS_AREA +
        '     OR order_section = ' + AlbumOrderSection.MY_ALBUMS_AREA +
        '     OR (order_section = -1 AND (album_type IN (0, 1024) ' +
        '     OR lpath IN (\'/DCIM/Camera\', \'/Pictures/Screenshots\', \'/Pictures/Screenrecords\')))) THEN 0\n' +
        '    WHEN (order_section = ' + AlbumOrderSection.SOURCE_ALBUMS_AREA +
        '     OR (order_section = -1 AND album_type NOT IN (0, 1024) ' +
        '     AND lpath NOT IN (\'/DCIM/Camera\', \'/Pictures/Screenshots\', \'/Pictures/Screenrecords\'))) THEN 1\n' +
        '    ELSE 999999\n' +
        '  END,\n' +
        '-- 第二优先级：各区域内部的排序规则\n' +
        '  CASE\n' +
        '    -- 普通相册区域排序规则（最终修正版）\n' +
        '    WHEN (order_section = ' + AlbumOrderSection.SYSTEM_ALBUMS_AREA +
        '     OR order_section = ' + AlbumOrderSection.MY_ALBUMS_AREA +
        '     OR (order_section = -1 AND (album_type IN (0, 1024) ' +
        '     OR lpath IN (\'/DCIM/Camera\', \'/Pictures/Screenshots\', \'/Pictures/Screenrecords\')))) THEN\n' +
        '      CASE\n' +
        '        -- 第一组：固定位置的系统相册（albums_order=-1且满足特定条件）\n' +
        '        WHEN albums_order = -1 AND album_type = 1024 AND album_subtype = 1031 THEN 1 -- 图片\n' +
        '        WHEN albums_order = -1 AND album_type = 1024 AND album_subtype = 1026 THEN 2 -- 视频\n' +
        '        WHEN albums_order = -1 AND album_type = 1024 AND album_subtype = 1025 THEN 3 -- 我的收藏\n' +
        '        WHEN albums_order = -1 AND album_type = 1024 AND album_subtype = 1032 THEN 4 -- AI云增强\n' +
        '        WHEN albums_order = -1 AND lpath = \'/DCIM/Camera\' THEN 5 -- 相机\n' +
        '        WHEN albums_order = -1 AND lpath = \'/Pictures/Screenshots\' THEN 6 -- 截屏\n' +
        '        WHEN albums_order = -1 AND lpath = \'/Pictures/Screenrecords\' THEN 7 -- 录屏\n' +
        '        -- 第二组：区域优先级（albums_order≠-1的情况）\n' +
        '        WHEN albums_order != -1 THEN\n' +
        '          CASE\n' +
        '            WHEN order_section = ' + AlbumOrderSection.SYSTEM_ALBUMS_AREA + ' THEN 8 + albums_order\n' +
        '            WHEN order_section = ' + AlbumOrderSection.MY_ALBUMS_AREA + ' THEN 90000 + albums_order\n' +
        '          END\n' +
        '        -- 第三组：albums_order=-1且album_type≠1024的自定义相册\n' +
        '        WHEN albums_order = -1 AND album_type != 1024 THEN 100000 ' +
        '      END\n' +
        '    -- 更多相册区域排序规则（保持不变）\n' +
        '    WHEN (order_section = ' + AlbumOrderSection.SOURCE_ALBUMS_AREA +
        '     OR (order_section = -1 AND album_type NOT IN (0, 1024) ' +
        '     AND lpath NOT IN (\'/DCIM/Camera\', \'/Pictures/Screenshots\', \'/Pictures/Screenrecords\'))) THEN\n' +
        '      CASE\n' +
        '        WHEN albums_order = -1 AND lpath = \'' + SHARE_ALBUM_LPATH + '\' THEN 100 -- 分享\n' +
        '        WHEN albums_order != -1 THEN 101 + albums_order\n' +
        '        WHEN albums_order = -1 THEN 300000 - count\n' +
        '        ELSE 999999\n' +
        '      END\n' +
        '    ELSE 999999\n' +
        '  END,\n' +
        '-- 第三优先级：albums_order≠-1且值相同的情况下，按albumName排序\n' +
        '  CASE\n' +
        '    WHEN albums_order != -1 THEN album_name\n' +
        '    ELSE \'\'\n' +
        '  END,\n' +
        '-- 最终稳定排序\n' +
        '  album_id'
    )
    .limit(param?.count, param?.start);

  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  return fetchOptions;
}

/**
 * 获取排序的普通相册区域数据FetchOption
 * @param param
 * @returns
 */
export function getSortedNormalAlbumsFetchOption(param: QueryAlbumParam): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates()
    .beginWrap()
      .beginWrap() // 普通相册区域条件（order_section=0）
        .beginWrap()
          .equalTo('order_section', AlbumOrderSection.SYSTEM_ALBUMS_AREA)
          .or()
          .equalTo('order_section', AlbumOrderSection.MY_ALBUMS_AREA)
        .endWrap()
        .and()
        .beginWrap()
          // 子条件1：用户相册（允许count任意）
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .endWrap()
          .or()
          // 子条件2：系统相册且count≠0
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件3：特定lpath且count≠0
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件4：来源相册且count≠0
          .beginWrap()
            .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
      .or()
      // 未排序区域的普通相册筛选逻辑
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
        .and()
        .beginWrap()
          .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .or()
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
    .endWrap()
    .and()
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    .orderByAsc('-- 普通相册区域排序规则\n' +
      '  CASE\n' +
      '    -- 第一优先级：系统相册子类型（按指定顺序）\n' +
      '    WHEN albums_order = -1 AND album_type = 1024 AND album_subtype = 1031 THEN 1 -- 图片\n' +
      '    WHEN albums_order = -1 AND album_type = 1024 AND album_subtype = 1026 THEN 2 -- 视频\n' +
      '    WHEN albums_order = -1 AND album_type = 1024 AND album_subtype = 1025 THEN 3 -- 我的收藏\n' +
      '    WHEN albums_order = -1 AND album_type = 1024 AND album_subtype = 1032 THEN 4 -- AI云增强\n' +
      '    -- 第二优先级：lpath路径（按指定顺序）\n' +
      '    WHEN albums_order = -1 AND lpath = \'/DCIM/Camera\' THEN 5 -- 相机\n' +
      '    WHEN albums_order = -1 AND lpath = \'/Pictures/Screenshots\' THEN 6 -- 截屏\n' +
      '    WHEN albums_order = -1 AND lpath = \'/Pictures/Screenrecords\' THEN 7 -- 录屏\n' +
      '    -- 第三优先级：albums_order != -1（按albums_order升序）\n' +
      '    -- 区域优先级（albums_order≠-1的情况）\n' +
      '        WHEN albums_order != -1 THEN\n' +
      '          CASE\n' +
      '            WHEN order_section = ' + AlbumOrderSection.SYSTEM_ALBUMS_AREA + ' THEN 8 + albums_order\n' +
      '            WHEN order_section = ' + AlbumOrderSection.MY_ALBUMS_AREA + ' THEN 90000 + albums_order\n' +
      '          END\n' +
      '    -- 第四优先级：albums_order = -1且非系统相册（按album_id升序）\n' +
      '    WHEN albums_order = -1 AND album_type != 1024 THEN 100000\n' +
      '    ELSE 999999\n' +
      '  END,\n' +
      '-- 第三优先级：albums_order≠-1且值相同的情况下，按 albumName 排序\n' +
      '  CASE\n' +
      '    WHEN albums_order != -1 THEN album_name\n' +
      '    ELSE \'\'  -- albums_order=-1 时统一返回空字符串，避免干扰排序\n' +
      '  END,\n' +
      '-- 最终稳定排序\n' +
      '  album_id'
    )
    .limit(param?.count, param?.start);
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  return fetchOptions;
}

/**
 * 获取普通相册数据FetchOption
 * @param param
 * @returns
 */
export function getNormalAlbumsFetchOption(param: QueryAlbumParam): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates()
    .beginWrap()
      .beginWrap() // 普通相册区域条件（order_section=0）
        .beginWrap()
          .equalTo('order_section', AlbumOrderSection.SYSTEM_ALBUMS_AREA)
          .or()
          .equalTo('order_section', AlbumOrderSection.MY_ALBUMS_AREA)
        .endWrap()
        .and()
        .beginWrap()
          // 子条件1：用户相册（允许count任意）
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .endWrap()
          .or()
          // 子条件2：系统相册且count≠0
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件3：特定lpath且count≠0
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件4：来源相册且count≠0
          .beginWrap()
            .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
      .or()
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
        .and()
        .beginWrap()
          .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .or()
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
    .endWrap()
    .and()
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    .limit(param?.count, param?.start);
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  return fetchOptions;
}

/**
 * 构建“系统相册”区域的相册数据FetchOption
 * @param param
 * @returns
 */
export function getSortedSystemAlbumsFetchOption(param: QueryAlbumParam): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates()
    .beginWrap()
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.SYSTEM_ALBUMS_AREA)
        .and()
        .beginWrap()
          // 子条件1：用户相册（允许count任意）
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .endWrap()
          .or()
          // 子条件2：系统相册且count≠0
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件3：特定lpath且count≠0
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件4：来源相册且count≠0
          .beginWrap()
            .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
      .or()
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
        .and()
        .beginWrap()
          .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .or()
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
    .endWrap()
    .and()
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    .limit(param?.count, param?.start);
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  return fetchOptions;
}

/**
 * 构建“我的相册”区域的相册数据FetchOption
 * @param param
 * @returns
 */
export function getSortedMyAlbumsFetchOption(param: QueryAlbumParam): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates()
    .beginWrap()
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.MY_ALBUMS_AREA)
        .and()
        .beginWrap()
          // 子条件1：用户相册（允许count任意）
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .endWrap()
          .or()
          // 子条件2：系统相册且count≠0
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件3：特定lpath且count≠0
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件4：来源相册且count≠0
          .beginWrap()
            .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
      .or()
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
        .and()
        .beginWrap()
          .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .or()
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
    .endWrap()
    .and()
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    .limit(param?.count, param?.start);
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  return fetchOptions;
}

/**
 * 获取过滤融合相册的普通相册区域相册数量FetchOption
 * @returns
 */
export function getNormalAlbumCountFilterUnionAlbumsFetchOption(): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates()
    .beginWrap()
      .beginWrap() // 普通相册区域条件（order_section=0）
        .beginWrap()
          .equalTo('order_section', AlbumOrderSection.SYSTEM_ALBUMS_AREA)
          .or()
          .equalTo('order_section', AlbumOrderSection.MY_ALBUMS_AREA)
        .endWrap()
        .and()
        .beginWrap()
          // 子条件1：用户相册（允许count任意）
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .endWrap()
          .or()
          // 子条件2：系统相册且count≠0
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件3：特定lpath且count≠0
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件4：来源相册且count≠0
          .beginWrap()
            .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
      .or()
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
        .and()
        .beginWrap()
          .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .or()
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
    .endWrap()
    .and()
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    // 过滤融合相册数量
    .beginWrap()
    .or()
    .isNull('lpath')
    .endWrap();
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  return fetchOptions;
}

/**
 * 获取过滤融合相册的“系统相册”区域相册数量FetchOption
 * @returns
 */
export function getSystemAlbumCountFilterUnionAlbumsFetchOption(): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates()
    .beginWrap()
      .beginWrap() // 普通相册区域条件（order_section=0）
        .equalTo('order_section', AlbumOrderSection.SYSTEM_ALBUMS_AREA)
        .and()
        .beginWrap()
          // 子条件1：用户相册（允许count任意）
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .endWrap()
          .or()
          // 子条件2：系统相册且count≠0
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件3：特定lpath且count≠0
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件4：来源相册且count≠0
          .beginWrap()
            .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
      .or()
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
        .and()
        .beginWrap()
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
    .endWrap()
    .and()
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    // 过滤融合相册数量
    .beginWrap()
    .or()
    .isNull('lpath')
    .endWrap();
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  return fetchOptions;
}

/**
 * 获取过滤融合相册的“我的相册”区域相册数量FetchOption
 * @returns
 */
export function getMyAlbumCountFilterUnionAlbumsFetchOption(): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates()
    .beginWrap()
      .beginWrap() // 普通相册区域条件（order_section=0）
        .equalTo('order_section', AlbumOrderSection.MY_ALBUMS_AREA)
        .and()
        .beginWrap()
          // 子条件1：用户相册（允许count任意）
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .endWrap()
          .or()
          // 子条件2：系统相册且count≠0
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件3：特定lpath且count≠0
          .beginWrap()
            .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件4：来源相册且count≠0
          .beginWrap()
            .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
      .or()
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
        .and()
        .beginWrap()
          .equalTo('album_type', photoAccessHelper.AlbumType.USER)
        .endWrap()
      .endWrap()
    .endWrap()
    .and()
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    // 过滤融合相册数量
    .beginWrap()
    .or()
    .isNull('lpath')
    .endWrap();
  return {
    fetchColumns: [],
    predicates
  };
}


/**
 * 构建相册查询条件
 * @param param 查询参数
 * @param albumFlag 相册标识
 * @returns 查询选项
 */
export function getUnionAlbumsCountFetchOption(param: QueryAlbumParam, albumFlag: number): FetchOptions {
  const predicates = new dataSharePredicates.DataSharePredicates();
  predicates.notEqualTo('count', 0);
  // 处理相册区域条件
  processAlbumSectionCondition(predicates, param);
  // 处理融合相册条件
  processAlbumFlagCondition(predicates, albumFlag);
  return {
    fetchColumns: [],
    predicates
  };
}

/**
 * 处理相册区域相关条件
 */
function processAlbumSectionCondition(predicates: dataSharePredicates.DataSharePredicates,
  param: QueryAlbumParam): void {
  if (!param?.orderSection || !Array.isArray(param.orderSection) || param.orderSection.length === 0) {
    return;
  }
  let orderSection: number[] = param.orderSection;
  // 开始相册区域条件包裹
  predicates.beginWrap();
  if (orderSection.length === 2) {
    // 系统相册和我的相册区域
    predicates
      .equalTo('order_section', AlbumOrderSection.SYSTEM_ALBUMS_AREA)
      .or()
      .equalTo('order_section', AlbumOrderSection.MY_ALBUMS_AREA);
  } else if (orderSection[0] === AlbumOrderSection.SOURCE_ALBUMS_AREA) {
    // 更多相册区域
    predicates
      .equalTo('order_section', AlbumOrderSection.SOURCE_ALBUMS_AREA)
      .or()
      .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA);
  } else if ([AlbumOrderSection.SYSTEM_ALBUMS_AREA, AlbumOrderSection.MY_ALBUMS_AREA].includes(orderSection[0])) {
    // 单独系统相册或我的相册区域
    predicates.equalTo('order_section', orderSection[0]);
  }
  // 结束相册区域条件包裹
  predicates.endWrap();
}

/**
 * 处理融合相册标识相关条件
 */
function processAlbumFlagCondition(predicates: dataSharePredicates.DataSharePredicates, albumFlag: number): void {
  const albumPathMap: Record<number, string[]> = {
    0: [
      '/Pictures/WeiXin',
      '/Pictures/WeChat',
      '/tencent/MicroMsg/WeChat',
      '/Tencent/MicroMsg/WeiXin'
    ],
    1: [
      '/Pictures/weibo',
      '/sina/weibo/save',
      '/sina/weibo/storage/photoalbum_save/weibo',
      '/sina/weibo/weibo'
    ]
  };
  let paths: string[] = albumPathMap[albumFlag];
  if (paths) {
    // 使用AND连接路径条件（保持原代码逻辑）
    predicates.and().beginWrap().in('lpath', paths).endWrap();
  }
}

/**
 * 获取排序的列表区相册区域数据FetchOption
 * @param param
 * @returns
 */
export function getSortedListAreaAlbumsFetchOption(param: QueryAlbumParam): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates()
  // 更多相册区域条件（修正后，包含系统相册和特定路径的count≠0情况）
    .beginWrap()
      // 情况1：明确的更多相册区域（order_section=1）
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.SOURCE_ALBUMS_AREA)
        .and()
        .beginWrap()
          // 子条件1：用户相册（允许count任意）
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .endWrap()
          .or()
          // 子条件2：系统相册或特定lpath且count≠0
          .beginWrap()
            .beginWrap()
              .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
              .or()
              .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .endWrap()
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件3：来源相册且count≠0
          .beginWrap()
            .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
      .or()
      // 情况2：未排序区域（order_section=-1）且满足更多相册逻辑条件
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
        .and()
        .beginWrap()
          .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
          .and()
          .notEqualTo('count', 0)
          .and()
          .notIn('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
        .endWrap()
      .endWrap()
    .endWrap()
    .and()
    // 公共排除子类型条件
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    // 更多相册区域排序规则
    .orderByAsc(
      '-- 更多相册区域排序规则\n' +
        '  CASE\n' +
        '    -- 优先级1：albums_order=-1且lpath=分享\n' +
        '    WHEN lpath = \'' + SHARE_ALBUM_LPATH + '\' AND albums_order = -1 THEN 100 -- 分享\n' +
        '    -- 优先级2：albums_order≠-1（按albums_order升序）\n' +
        '    WHEN albums_order != -1 THEN 101 + albums_order\n' +
        '    -- 优先级3：albums_order=-1且lpath≠分享（按count倒序，count相同则按album_id升序）\n' +
        '    WHEN albums_order = -1 THEN 300000 - count\n' + // 使用减法实现倒序
        '    ELSE 999999\n' +
        '  END,\n' +
        '-- 第二优先级：albums_order=-1且count相同的情况下，按 album_id 排序\n' +
        '  CASE\n' +
        '    WHEN albums_order = -1 THEN album_id\n' +
        '    ELSE 0  -- albums_order≠-1 时统一返回0，避免干扰排序\n' +
        '  END,\n' +
        '-- 第三优先级：albums_order≠-1且值相同的情况下，按 albumName 排序\n' +
        '  CASE\n' +
        '    WHEN albums_order != -1 THEN album_name\n' +
        '    ELSE \'\'  -- albums_order=-1 时统一返回空字符串，避免干扰排序\n' +
        '  END,\n' +
        '-- 最终稳定排序\n' +
        '  album_id'
    )
    .limit(param?.count, param?.start);

  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  return fetchOptions;
}

/**
 * 获取列表区相册区域数据FetchOption
 * @param param
 * @returns
 */
export function getListAreaAlbumsFetchOption(param: QueryAlbumParam): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates()
    // 更多相册区域条件（修正后，包含系统相册和特定路径的count≠0情况）
    .beginWrap()
      // 情况1：明确的更多相册区域（order_section=1）
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.SOURCE_ALBUMS_AREA)
        .and()
        .beginWrap()
          // 子条件1：用户相册（允许count任意）
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .endWrap()
          .or()
          // 子条件2：系统相册或特定lpath且count≠0
          .beginWrap()
            .beginWrap()
              .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
              .or()
              .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .endWrap()
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件3：来源相册且count≠0
          .beginWrap()
            .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
      .or()
      // 情况2：未排序区域（order_section=-1）且满足更多相册逻辑条件
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
        .and()
        .beginWrap()
          .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
          .and()
          .notEqualTo('count', 0)
          .and()
          .notIn('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
        .endWrap()
      .endWrap()
    .endWrap()
    .and()
    // 公共排除子类型条件
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    .limit(param?.count, param?.start);
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  return fetchOptions;
}

/**
 * 获取过滤融合相册的更多相册区域相册数量FetchOption
 * @returns
 */
export function getListAreaAlbumCountFilterUnionAlbumsFetchOption(): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates()
    // 更多相册区域条件（修正后，包含系统相册和特定路径的count≠0情况）
    .beginWrap()
      // 情况1：明确的更多相册区域（order_section=1）
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.SOURCE_ALBUMS_AREA)
        .and()
        .beginWrap()
          // 子条件1：用户相册（允许count任意）
          .beginWrap()
            .equalTo('album_type', photoAccessHelper.AlbumType.USER)
          .endWrap()
          .or()
          // 子条件2：系统相册或特定lpath且count≠0
          .beginWrap()
            .beginWrap()
              .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
              .or()
              .in('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
            .endWrap()
            .and()
            .notEqualTo('count', 0)
          .endWrap()
          .or()
          // 子条件3：来源相册且count≠0
          .beginWrap()
            .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
            .and()
            .notEqualTo('count', 0)
          .endWrap()
        .endWrap()
      .endWrap()
      .or()
      // 情况2：未排序区域（order_section=-1）且满足更多相册逻辑条件
      .beginWrap()
        .equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA)
        .and()
        .beginWrap()
          .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
          .and()
          .notEqualTo('count', 0)
          .and()
          .notIn('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
        .endWrap()
      .endWrap()
    .endWrap()
    .and()
    // 公共排除子类型条件
    .notIn('album_subtype', [
      photoAccessHelper.AlbumSubtype.SCREENSHOT,
      photoAccessHelper.AlbumSubtype.CAMERA,
      photoAccessHelper.AlbumSubtype.TRASH
    ])
    // 过滤融合相册数量
    .beginWrap()
    .or()
    .isNull('lpath')
    .endWrap();
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  return fetchOptions;
}

/**
 * 获取对应区域AlbumOrder的FetchOption
 * @param param
 * @returns
 */
export function getPhotoAlbumOrderFetchOption(param: QueryAlbumParam): FetchOptions {
  if (param?.orderSection?.length === 2) {
    // 普通相册区域
    return getNormalAlbumsFetchOption(param);
  } else if (param?.orderSection?.length === 1) {
    switch (param.orderSection[0]) {
      // 系统相册区域
      case AlbumOrderSection.SYSTEM_ALBUMS_AREA:
        return getSortedSystemAlbumsFetchOption(param);
      case AlbumOrderSection.MY_ALBUMS_AREA:
        return getSortedMyAlbumsFetchOption(param);
      case AlbumOrderSection.SOURCE_ALBUMS_AREA:
        return getListAreaAlbumsFetchOption(param);
    }
  }
  Log.error(TAG, 'getPhotoAlbumOrderFetchOption param?.orderSection?.length === 0');
  return {
    fetchColumns: [],
    predicates: new dataSharePredicates.DataSharePredicates()
  };
}

/**
 * 获取判断是否有未排序相册的FetchOption
 * @param param
 * @returns
 */
export function getCheckForUnsortedAlbumsFetchOption(param: QueryAlbumParam): FetchOptions {
  let predicates = new dataSharePredicates.DataSharePredicates();
  // 设置基础条件：属于未排序相册区域
  predicates.equalTo('order_section', AlbumOrderSection.UNSORTED_ALBUMS_AREA);
  // 根据不同区域类型添加不同条件
  if (param?.orderSection?.length === 2) {
    // 普通相册区域的未排序相册条件
    addNormalAlbumAreaCondition(predicates);
  } else if (param?.orderSection?.length === 1) {
    // 处理单个区域类型的条件
    switch (param.orderSection[0]) {
      case AlbumOrderSection.SOURCE_ALBUMS_AREA:
        // 更多相册区域的未排序相册条件
        addSourceAlbumAreaCondition(predicates);
        break;
      case AlbumOrderSection.SYSTEM_ALBUMS_AREA:
        // 系统相册区域的未排序相册条件
        addSystemAlbumAreaCondition(predicates);
        break;
      case AlbumOrderSection.MY_ALBUMS_AREA:
        // 我的相册区域的未排序相册条件
        addMyAlbumAreaCondition(predicates);
        break;
    }
  }
  // 设置分页限制
  predicates.limit(1, 0);
  return {
    predicates,
    fetchColumns: []
  };
}

/**
 * 添加普通相册区域的未排序相册条件
 */
function addNormalAlbumAreaCondition(predicates: dataSharePredicates.DataSharePredicates): void {
  predicates.and()
    .beginWrap()
      // 条件1：用户相册
      .beginWrap()
        .equalTo('album_type', photoAccessHelper.AlbumType.USER)
      .endWrap()
      .or()
      // 条件2：系统相册且count≠0
      .beginWrap()
        .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
        .and()
        .notEqualTo('count', 0)
      .endWrap()
      .and()
      // 条件3：不在系统来源相册路径中且count≠0
      .beginWrap()
        .notIn('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
        .and()
        .notEqualTo('count', 0)
      .endWrap()
    .endWrap();
}

/**
 * 添加更多相册区域的未排序相册条件
 */
function addSourceAlbumAreaCondition(predicates: dataSharePredicates.DataSharePredicates): void {
  predicates.and()
    .beginWrap()
      .equalTo('album_subtype', photoAccessHelper.AlbumSubtype.SOURCE_GENERIC)
      .and()
      .notEqualTo('count', 0)
      .and()
      .notIn('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
    .endWrap();
}

/**
 * 添加系统相册区域的未排序相册条件
 */
function addSystemAlbumAreaCondition(predicates: dataSharePredicates.DataSharePredicates): void {
  predicates.and()
    .beginWrap()
      .equalTo('album_type', photoAccessHelper.AlbumType.SYSTEM)
      .and()
      .notEqualTo('count', 0)
    .endWrap()
    .and()
    .beginWrap()
      .notIn('lpath', SYSTEM_SOURCE_ALBUM_LPATH_ARRAY)
      .and()
      .notEqualTo('count', 0)
    .endWrap();
}

/**
 * 添加我的相册区域的未排序相册条件
 */
function addMyAlbumAreaCondition(predicates: dataSharePredicates.DataSharePredicates): void {
  predicates.and().equalTo('album_type', photoAccessHelper.AlbumType.USER);
}

/**
 * 获取判断对应区域相册是否为按名称排序的FetchOption
 * @param param
 * @returns
 */
export function getJudgeAlbumSortedByNameFetchOption(param: QueryAlbumParam): FetchOptions {
  const predicates = new dataSharePredicates.DataSharePredicates();
  // 设置相册区域条件
  setAlbumSectionPredicate(predicates, param);
  // 添加排序类型条件
  predicates.and().equalTo('order_type', AlbumOrderType.SORT_BY_NAME);
  // 设置分页限制
  predicates.limit(1, 0);
  return {
    predicates,
    fetchColumns: []
  };
}

/**
 * 设置相册区域查询条件
 */
function setAlbumSectionPredicate(predicates: dataSharePredicates.DataSharePredicates, param: QueryAlbumParam): void {
  if (!param?.orderSection || !Array.isArray(param.orderSection) || param.orderSection.length === 0) {
    return;
  }
  let orderSection: number[] = param.orderSection;
  if (orderSection.length === 2) {
    // 同时查询系统相册和我的相册区域
    predicates.beginWrap()
      .equalTo('order_section', AlbumOrderSection.SYSTEM_ALBUMS_AREA)
      .or()
      .equalTo('order_section', AlbumOrderSection.MY_ALBUMS_AREA)
      .endWrap();
  } else if (orderSection.length === 1) {
    // 查询单个相册区域
    const section = orderSection[0];
    predicates.equalTo('order_section', section);
  }
}
