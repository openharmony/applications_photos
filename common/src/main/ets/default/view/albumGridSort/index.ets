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
import lazy { sortOptionType, SortSelectMenuParamType, selectEmitType, optionType } from './type';
import lazy { AlbumGridSortRule, AlbumGridSortHelper, SortRuleString } from '../../model/AlbumGridSortHelper';
import lazy { Log } from '../../utils/Log';
import lazy SelectPicker from './SelectPicker';
import lazy SubMenuPicker from './SubMenuPicker';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';

interface AlbumSortReportType {
  albumType: number,
  sortRule: string,
  sortType: string,
  clickSource: string,
}

export interface sortChangeParam {
  albumUri: string,
  albumKey: string,
  selected: string,
  selectEmit: selectEmitType,
  albumSubType: number,
  clickSource: string,
}

const TAG: string = 'common_SortSelect';

export const sortOptions: sortOptionType[] = [
  {
    dialogLabel: $r('app.string.album_photo_sort_dialog_item_shoot_time'),
    titleLabel: $r('app.string.album_sort_by_shoot_time'),
    key: AlbumGridSortRule.SHOOT_TIME,
  },
  {
    dialogLabel: $r('app.string.album_photo_sort_dialog_item_creation_time'),
    titleLabel: $r('app.string.album_sort_by_creation_time'),
    key: AlbumGridSortRule.CREATE_TIME,
  },
  {
    dialogLabel: $r('app.string.album_photo_sort_dialog_item_name'),
    titleLabel: $r('app.string.album_sort_by_name'),
    key: AlbumGridSortRule.FILE_NAME,
  },
  {
    dialogLabel: $r('app.string.album_photo_sort_dialog_item_size'),
    titleLabel: $r('app.string.album_sort_by_size'),
    key: AlbumGridSortRule.FILE_SIZE,
  }
]

export const emitSortChange = (param: sortChangeParam) => {
  if (!param) {
    Log.error(TAG, `emitSortChange param undefined`);
    return;
  }
  let albumDefaultSelected =
    AlbumGridSortHelper.transferOrderPropToRule(AlbumGridSortHelper.getDefaultOrderProp(param.albumUri));
  let sortRule = param.selected === RESUME_DEFAULT ? '' : param.selected;
  let oldSortRule =
    AlbumGridSortHelper.getInstance().getSortRule('emitSortChange', param.albumKey)?.rule || albumDefaultSelected;
  let sortType = getSortType(oldSortRule as string, sortRule, param.albumKey);
  Log.info(TAG,
    `sort select change, albumKey:${param.albumKey}, selected:${param.selected}, sortRule:${sortRule}, sortType:${sortType}`);
  if (sortRule === albumDefaultSelected && sortType === SortRuleString.defaultType) {
    sortRule = '';
  }
  let msg: AlbumSortReportType = {
    albumType: param.albumSubType,
    sortRule: param.selected,
    sortType: sortType,
    clickSource: param.clickSource,
  };
  ReportToBigDataUtil.report(BigDataConstants.ALBUM_GRID_SORT_RULE, msg);
  AlbumGridSortHelper.getInstance().setSortRule(param.albumKey, sortRule, sortType);
  param.selectEmit?.(sortRule, sortType);
}

export let getSortType = (oldSelected: string, newSelected: string, albumKey: string): string => {
  if (oldSelected != newSelected) {
    return SortRuleString.defaultType;
  } else {
    let currentSortType = AlbumGridSortHelper.getInstance().getSortRule('getSortType', albumKey).type;
    return currentSortType == SortRuleString.DESC ? SortRuleString.ASC : SortRuleString.DESC;
  }
}

export const RESUME_DEFAULT = 'RESUME_DEFAULT';

export { SelectPicker, SubMenuPicker, SortSelectMenuParamType }
