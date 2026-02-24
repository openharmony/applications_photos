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

import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy dataSharePredicates from '@ohos.data.dataSharePredicates';
import lazy { AlbumDefine, QueryType } from '../model/browser/AlbumDefine';
import lazy { QueryParam } from '../interface/BrowserDataInterface'
import lazy { FilterConditions } from '../model/FilterConditions'
import lazy { SelectConstants } from '../model/common/SelectParams';
import type { FetchOptions } from './UserFileData';
import lazy { UserFileData } from './UserFileData';
import lazy { Log } from '../utils/Log';
import lazy { FileFetchOptionBuilder } from '../model/FetchOption'
import lazy { Constants } from './common/Constants';

export function toString(obj: Object | undefined): string {
  return JSON.stringify(obj);
}
const TAG: string = 'PickerFilterEnhanceBuilder';

// 单个type最长50，做多10个，算是逗号和括号
const MAX_MIME_TYPE_LENGTH: number = 511;
/**
 * 过滤条件接口
 */
interface FilterTypeAndExclude {
  /**
   * 过滤的类型
   */
  type: string;

  /**
   * 是否排除该类型
   */
  isExcluded: boolean;
}

/**
 * 媒体文件类型过滤器接口
 */
export interface MediaTypeFilter {
  /**
   * 文件基本类型过滤：image, video
   */
  photoType: FilterTypeAndExclude;
  /**
   * 文件类型subType过滤,每个元素包含过滤类型和排除规则：movingPhoto, all
   */
  photoSubTypes: Array<FilterTypeAndExclude>;
  /**
   * MIME类型的过滤规则数组，每个元素包含过滤类型和排除规则
   */
  mimeTypes: Array<FilterTypeAndExclude>;
}

/**
 * 相册fetchOption
 */
export class PickerAlbumsFilterEnhanceBuilder {
  private fetchOption: photoAccessHelper.FetchOptions;
  private storage?: LocalStorage;

  public constructor(fetchOpt?: photoAccessHelper.FetchOptions, storage?: LocalStorage) {
    if (fetchOpt) {
      this.fetchOption = fetchOpt;
    } else {
      this.fetchOption = {
        predicates: new dataSharePredicates.DataSharePredicates(),
        fetchColumns: [],
      };
    }
    if (storage) {
      this.storage = storage;
    }
  }

  public order(key: string, isAsc = true): PickerAlbumsFilterEnhanceBuilder {
    if (isAsc) {
      //升序
      this.fetchOption.predicates.orderByAsc(key);
    } else {
      //降序
      this.fetchOption.predicates.orderByDesc(key);
    }
    return this;
  }

  public addColumn(column: string): PickerAlbumsFilterEnhanceBuilder {
    this.fetchOption.fetchColumns.push(column);
    return this;
  }

  public setColumn(columns: string[]): PickerAlbumsFilterEnhanceBuilder {
    this.fetchOption.fetchColumns = columns;
    return this;
  }

  public select(start: number, count: number): PickerAlbumsFilterEnhanceBuilder {
    this.fetchOption.predicates.limit(count, start);
    return this;
  }

  public setOwnAlbumIds(albumOwnIds: string[]): PickerAlbumsFilterEnhanceBuilder {
    let predicates: dataSharePredicates.DataSharePredicates = this.fetchOption.predicates;
    predicates.beginWrap();
    for (let i = 0; i < albumOwnIds.length; i++) {
      predicates.equalTo('owner_album_id', albumOwnIds[i]);
      if (i < albumOwnIds.length - 1) {
        predicates.or();
      }
    }
    predicates.endWrap();
    return this;
  }

  public groupBy(fields: string[]): PickerAlbumsFilterEnhanceBuilder {
    this.fetchOption.predicates.groupBy(fields);
    return this;
  }

  private checkMimeTypeArray(param: QueryParam): boolean {
    if (param.filterConditions?.photoViewMimeTypeFilter) {
      for (let filterType of param.filterConditions.photoViewMimeTypeFilter.mimeTypeArray) {
        let mediaString = AlbumDefine.getFilterMediaType(filterType);
        Log.info(TAG, 'convertQueryAndFilterMap filterType:' + filterType + '. mediaString:' + mediaString);
        if (mediaString === photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE) {
          return false;
        }
      }
      return param.filterConditions.photoViewMimeTypeFilter.mimeTypeArray.length > 0;
    }
    return false;
  }

  private handlePhotoType(item: MediaTypeFilter): void {
    let photoType: string = item.photoType.type;
    let isExcluded: boolean = item.photoType.isExcluded;
    if (isExcluded) {
      if (photoType === Constants.MEDIA_TYPE_IMAGE) {
        this.fetchOption.predicates.notEqualTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE.toString(),
          photoAccessHelper.PhotoType.IMAGE);
      } else if (photoType === Constants.MEDIA_TYPE_VIDEO) {
        this.fetchOption.predicates.notEqualTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE.toString(),
          photoAccessHelper.PhotoType.VIDEO);
      }
    } else {
      if (photoType === Constants.MEDIA_TYPE_IMAGE) {
        this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE.toString(),
          photoAccessHelper.PhotoType.IMAGE);
      } else if (photoType === Constants.MEDIA_TYPE_VIDEO) {
        this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE.toString(),
          photoAccessHelper.PhotoType.VIDEO);
      }
    }
  }

  private handleSubtype(item: MediaTypeFilter): void {
    let subTypeArray: FilterTypeAndExclude[] = item.photoSubTypes;
    if (subTypeArray.length > 0) {// 长度为0说明过滤条件为*，实际不过滤
      Log.info(TAG, `处理subType  ${toString(subTypeArray)}`);
      this.fetchOption.predicates.beginWrap();
      this.fetchOption.predicates.and();
      subTypeArray.forEach((subType: FilterTypeAndExclude, subTypeIndex: number) => {
        subType.type = this.convertSubType(subType.type)
        if (subType.isExcluded) {
          this.fetchOption.predicates.notIn(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(),
            [subType.type.toString()]);
        } else {
          this.fetchOption.predicates.in(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(),
            [subType.type.toString()]);
        }
        if (subTypeIndex < subTypeArray.length - 1) {
          this.fetchOption.predicates.or();
        }
      });
      this.fetchOption.predicates.endWrap();
    }
  }

  private convertSubType(originalType: string): string {
    let newType: string = photoAccessHelper.PhotoSubtype.DEFAULT.toString();
    if (originalType === Constants.MOVING_PHOTO || originalType === Constants.MOVING_PHOTO_EXCLUDE) {
      newType = photoAccessHelper.PhotoSubtype.MOVING_PHOTO.toString();
    }
    return newType;
  }

  private handleMimetype(item: MediaTypeFilter): void {
    let mimeTypeArray: FilterTypeAndExclude[] = item.mimeTypes;
    if (mimeTypeArray.length > 0) {
      Log.info(TAG, `处理mimetype  ${toString(mimeTypeArray)}`);
      this.fetchOption.predicates.beginWrap();
      this.fetchOption.predicates.and();

      // 使用 Set 判断是否同时存在 true 和 false；
      // Set 的 size 大于 1 表示存在混合，等于 1 表示统一。
      const exclusions = new Set<boolean>(mimeTypeArray.map((item) => item.isExcluded));
      let typeList: string[];
      let isNotIn: boolean;
      if (exclusions.size === 1) {
        // 全部为 true 或 全部为 false
        const allExcluded = exclusions.has(true);
        typeList = mimeTypeArray.map((item) => `${item.type}`);
        isNotIn = allExcluded ? true : false;
      } else {
        // 既有 true 也有 false，即：排除xxx格式的同时（OR连接）支持xxx格式，取 true 的 type 即可
        typeList = mimeTypeArray.filter((item) => item.isExcluded).map((item) => `${item.type}`);
        isNotIn = true;
      }
      Log.info(TAG, `typeList = ${typeList}, isNotIn=${isNotIn}`);
      if (isNotIn) {
        this.fetchOption.predicates.notIn(UserFileData.FETCH_COLUMNS_MIME_TYPE.toString(), typeList);
      } else {
        this.fetchOption.predicates.in(UserFileData.FETCH_COLUMNS_MIME_TYPE.toString(), typeList);
      }
      this.fetchOption.predicates.endWrap();
    }
  }

  private setPhotoTypeFilter(param: QueryParam): PickerAlbumsFilterEnhanceBuilder {
    if (!param || !param.filterConditions) {
      return this;
    }
    if (param.filterConditions?.combinedMediaTypeFilter) {
      let photoTypeArray: string[] = param.filterConditions.combinedMediaTypeFilter;
      let parsedPhotoTypeArray: MediaTypeFilter[] = this.parsePhotoTypeArray(photoTypeArray);

      Log.info(TAG, `setPhotoTypeFilter  photoTypeArray=${toString(photoTypeArray)},
      parsedPhotoTypeArray=${toString(parsedPhotoTypeArray)}`);
      this.fetchOption.predicates.beginWrap();
      parsedPhotoTypeArray.forEach((item: MediaTypeFilter, photoTypeIndex: number) => {
        if (!item.mimeTypes || !item.photoSubTypes || !item.mimeTypes) { // 查询出null
          return ;
        }

        // 处理photoType, 处理非逻辑
        this.handlePhotoType(item);

        // 处理subType
        this.handleSubtype(item);

        // 处理mimetype
        this.handleMimetype(item);

        if (photoTypeIndex < parsedPhotoTypeArray.length - 1) {
          this.fetchOption.predicates.or();
        }
      });
      this.fetchOption.predicates.endWrap();
    }
    return this;
  }

  /**
   * @throws { Error } Invalid format.
   */
  private parseItemType(itemStr: string): MediaTypeFilter | undefined {
    const trimmed = itemStr.trim();
    const parts = trimmed.split('|');

    if (parts.length !== 3) {
      throw new Error(`Invalid format, each string ${itemStr} must have 3 parts.`);
    }

    const photoTypeRaw: string = parts[0];  //  替换了解构语法
    const photoSubTypeStr = parts[1];
    const mimeTypeStr = parts[2];
    let isExcludePhotoType: boolean = false;

    // 验证第一段是否为 image 或 video
    if (photoTypeRaw === Constants.MEDIA_TYPE_IMAGE || photoTypeRaw === Constants.MEDIA_TYPE_VIDEO) {
      isExcludePhotoType = false;
    } else if (photoTypeRaw === Constants.MEDIA_TYPE_IMAGE_EXCLUDE ||
      photoTypeRaw === Constants.MEDIA_TYPE_VIDEO_EXCLUDE) {
      isExcludePhotoType = true;
    } else {
      throw new Error('Invalid photoType must be "image" or "video" .');
    }

    // 解析 photoSubtype
    let photoSubTypes: Array<FilterTypeAndExclude> | undefined = [];
    if (photoSubTypeStr === 'movingPhoto') {
      // 如果是 movingPhoto，加入数组，isExcluded 为 false
      photoSubTypes.push({
        type: photoSubTypeStr,
        isExcluded: false
      });
    } else if (photoSubTypeStr === '(movingPhoto)') {
      // 如果是 (movingPhoto)，加入数组，isExcluded 为 true
      photoSubTypes.push({
        type: photoSubTypeStr,
        isExcluded: true
      });
    } else if (photoSubTypeStr === '*') {
      // 如果是 *，不处理
    } else {
      // 其他情况为非法值，抛出异常
      throw new Error(`Invalid photoSubType: ${photoSubTypeStr}`);
    }

    // 解析 mimetypes
    const mimeTypes: Array<FilterTypeAndExclude> | undefined = this.parseMimeTypeList(mimeTypeStr);

    // 为undefined：非法值；length为0：过滤条件为*，时机不过滤
    if (!photoSubTypes || !mimeTypes) {
      Log.error(TAG, `Type list cannot be empty for ${itemStr}`);
      return undefined;
    }

    return {
      photoType: { type:photoTypeRaw, isExcluded: isExcludePhotoType } as FilterTypeAndExclude,
      photoSubTypes,
      mimeTypes
    };
  }

  /**
   * check brackets
   * @throws { Error } Invalid format for brackets .
   */
  private splitItems(input: string): string[] {
    const result: string[] = [];
    let current = '';
    let inBrackets = false;

    for (const char of input) {  // 遍历整个字符串，逐字符处理
      if (char === '(' && !inBrackets) {
        if (inBrackets) {
          throw new Error('Invalid format: Nested brackets are not supported.');
        }
        inBrackets = true;       // 进入括号内
        current += char;         // 添加左括号
      } else if (char === ')') {
        if (!inBrackets) {
          // 已在括号外，再次遇到右括号则视为不匹配
          throw new Error('Invalid format: Unmatched brackets.');
        }
        inBrackets = false;      // 离开括号内
        current += char;         // 添加右括号
      } else if (char === ',' && !inBrackets) {
        result.push(current);    // 拆分项
        current = '';            // 重置缓存
      } else {
        current += char;         // 其他字符按顺序拼接
      }
    }

    // 添加剩余字符（最后一个项）
    if (current) {
      result.push(current);
    }

    // 校验括号数量（是否为闭合的一对括号）
    const bracketsCount = result
      .map(item => item.match(/\(/g)?.length || 0)
      .reduce((a, b) => a + b, 0);
    const closingBrackets = result
      .map(item => item.match(/\)/g)?.length || 0)
      .reduce((a, b) => a + b, 0);

    if (bracketsCount !== closingBrackets) {
      throw new Error('Invalid format: Unmatched brackets.');
    }

    return result;
  }

  /**
   * check mimeType and subType
   * @throws { Error } Invalid format for mimeType and subType .
   */
  private parseMimeTypeList(input: string): Array<FilterTypeAndExclude> | undefined {
    if (input.includes(' ')) {
      throw new Error(`Invalid format: ${input} must not contain spaces.`);
    }

    if (input.includes('*') && input.length > 1) {
      throw new Error(`Invalid format: '*' is incompatible with other string.`);
    }

    if (input.length > MAX_MIME_TYPE_LENGTH) { // 最大程度校验
      throw new Error(`Invalid format: ${input.length} must lest than 511.`);
    }

    const items = this.splitItems(input); // 过滤括号
    // 非法值和空值，抛出异常
    if (!items.length || items.length === 0) {
      throw new Error(`Invalid format: ${input} must have at least one item.`);
    }

    if (items.length > 10) {
     Log.warn(TAG, `Type list exceeds maximum count of 10 items, is ${items.length}; truncated to 10.`);
      items.splice(10); // 只保留前10个
    }

    let needFilter = true;
    let bracketItemCount: number = 0;

    for (let item of items) {
      // 单个mimetype长度最大为50
      item = item.length > 50 ? item.substring(0, 50) : item;
      if (item.startsWith('(') && item.endsWith(')')) {
        bracketItemCount++;

        const content = item.substring(1, item.length - 1);
        if (content === '') {
          throw new Error(`Invalid item: ${item}. Empty content within brackets is not allowed.`);
        }
      }
    }

    // 限制仅允许一个括号包裹项
    if (bracketItemCount > 1) {
      throw new Error('Multiple bracketed items are not allowed.');
    }

    // 使用 reduce 处理多个 item → 多个对象
    const result = items.reduce((acc, item) => {
      if (item === '*') { // * 不添加任何内容
        needFilter = false;
        return acc;
      }

      if (item.startsWith('(') && item.endsWith(')')) {// 需要排除的类型 isExcluded = true;
        const content = item.substring(1, item.length - 1);
        // 逗号分隔
        const types = content.split(',');

        // 生成多个对象，isExcluded 为 true
        return acc.concat(types.map(type => ({
          type: type,
          isExcluded: true,
        } as FilterTypeAndExclude)));
      } else {
        // 需要添加类型
        return acc.concat([{
          type: item,
          isExcluded: false,
        }]);
      }
    }, [] as FilterTypeAndExclude[]);

    if (!needFilter) {
      return [];
    }
    return result;
  }

  /**
   * 解析整个数组
   * @throws { Error } Invalid combinedMediaTypeFilter or length is zero.
   */
  public parsePhotoTypeArray(inputArray: string[]): Array<MediaTypeFilter> {
    const result: MediaTypeFilter[] = [];
    if (!inputArray || inputArray.length === 0) {
      throw new Error(`Invalid combinedMediaTypeFilter or length is zero.`);
    }
    for (const item of inputArray) {
      const parsed: MediaTypeFilter | undefined = this.parseItemType(item);
      if (parsed) {
        result.push(parsed);
      }
    }
    return result;
  }

  private setMimeTypeFilter(param: QueryParam): PickerAlbumsFilterEnhanceBuilder {
    if (!param || !param.filterConditions) {
      return this;
    }
    if (param.filterConditions.photoViewMimeTypeFilter && this.checkMimeTypeArray(param)) {
      let map = AlbumDefine.convertQueryAndFilterMap(param?.filterConditions?.photoViewMimeTypeFilter.mimeTypeArray);
      this.fetchOption.predicates.beginWrap();
      let index: number = 0;
      for (let entry of map) {
        if (entry[0] === QueryType.MEDIA) {
          this.fetchOption.predicates.in(photoAccessHelper.PhotoKeys.PHOTO_TYPE.toString(), entry[1]);
        } else if (entry[0] === QueryType.SUBTYPE) {
          this.fetchOption.predicates.in(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(), entry[1]);
        } else if (entry[0] === QueryType.MIME_TYPE || entry[0] === QueryType.INVALID) {
          this.fetchOption.predicates.in(UserFileData.FETCH_COLUMNS_MIME_TYPE.toString(), entry[1]);
        }
        if (index < map.size - 1) {
          this.fetchOption.predicates.or();
        }
        index++;
      }
      this.fetchOption.predicates.endWrap();
    }
    return this;
  }

  private isFileSizeFilterInvalid(filterConditions: FilterConditions): boolean | undefined {
    return filterConditions.fileSizeFilter &&
      (!filterConditions.photoViewMimeTypeFileSizeFilters ||
        filterConditions.photoViewMimeTypeFileSizeFilters.length === 0);
  }

  private setFileSizeAndVideoDuration(filterConditions: FilterConditions): PickerAlbumsFilterEnhanceBuilder {
    let filterOptions: FilterOptions;
    // 当photoViewMimeTypeFileSizeFilters不为空时，fileSizeFilter配置失效
    if (this.isFileSizeFilterInvalid(filterConditions)) {
      let filterOperator: photoAccessHelper.FilterOperator = (
        filterConditions.fileSizeFilter as photoAccessHelper.FileSizeFilter
      ).filterOperator;
      let firstFileSize: photoAccessHelper.FilterOperator = (
        filterConditions.fileSizeFilter as photoAccessHelper.FileSizeFilter
      ).fileSize;
      let extraFileSize: photoAccessHelper.FilterOperator = (
        filterConditions.fileSizeFilter as photoAccessHelper.FileSizeFilter
      ).extraFileSize ?? -1;
      filterOptions = {
        isFilterFileSize: true,
        filterOperator: filterOperator,
        firstFileSize: firstFileSize,
        extraFileSize: extraFileSize,
        mimeType: undefined,
        hasMovingPhoto: undefined
      };
      this.setFileSizeOrDuration(filterOptions);
    }
    if (filterConditions.photoViewMimeTypeFileSizeFilters &&
      filterConditions.photoViewMimeTypeFileSizeFilters.length > 0) {
      let index: number = 0;
      let hasMovingPhoto = false;
      for (let specificMimeTypeFileSizeFilter of filterConditions.photoViewMimeTypeFileSizeFilters) {
        if (specificMimeTypeFileSizeFilter.photoViewMimeType ===
        photoAccessHelper.PhotoViewMIMETypes.MOVING_PHOTO_IMAGE_TYPE) {
          hasMovingPhoto = true;
        }
      }
      this.fetchOption.predicates.beginWrap();
      for (let specificMimeTypeFileSizeFilter of filterConditions.photoViewMimeTypeFileSizeFilters) {
        this.fetchOption.predicates.beginWrap();
        let mimeType: photoAccessHelper.PhotoViewMIMETypes = specificMimeTypeFileSizeFilter.photoViewMimeType;
        let filterOperator: photoAccessHelper.FilterOperator =
          specificMimeTypeFileSizeFilter.sizeFilter.filterOperator;
        let firstFileSize: photoAccessHelper.FilterOperator = specificMimeTypeFileSizeFilter.sizeFilter.fileSize;
        let extraFileSize: photoAccessHelper.FilterOperator =
          specificMimeTypeFileSizeFilter.sizeFilter.extraFileSize ?? -1;
        filterOptions = {
          isFilterFileSize: true,
          filterOperator: filterOperator,
          firstFileSize: firstFileSize,
          extraFileSize: extraFileSize,
          mimeType: mimeType,
          hasMovingPhoto: hasMovingPhoto
        };
        this.setFileSizeOrDuration(filterOptions);
        this.fetchOption.predicates.endWrap();
        if (index > 1) {
          Log.info(TAG, `index: ${index}, filterCondiction=${toString(filterConditions)}`);
          break;
        }
        if (index < filterConditions.photoViewMimeTypeFileSizeFilters.length - 1) {
          this.fetchOption.predicates.or();
        }
        index++;
      }
      this.fetchOption.predicates.endWrap();
    }
    if (filterConditions.videoDurationFilter) {
      let filterOperator: photoAccessHelper.FilterOperator = filterConditions.videoDurationFilter.filterOperator;
      let firstDuration: photoAccessHelper.FilterOperator = filterConditions.videoDurationFilter.videoDuration;
      let extraDuration: photoAccessHelper.FilterOperator =
        filterConditions.videoDurationFilter.extraVideoDuration ?? -1;
      let filterOptions: FilterOptions = {
        isFilterFileSize: false,
        filterOperator: filterOperator,
        firstFileSize: firstDuration,
        extraFileSize: extraDuration,
        mimeType: undefined,
        hasMovingPhoto: undefined
      };
      this.setFileSizeOrDuration(filterOptions);
    }
    return this;
  }

  private setPositionAndSubtype(filterConditions: FilterConditions): PickerAlbumsFilterEnhanceBuilder {
    if (filterConditions.position) {
      Log.info(TAG, `getFetchOpt position: ${filterConditions.position}`);
      if (filterConditions.position === UserFileData.GET_ASSERT_WITHOUT_LOCAL) {
        this.fetchOption.predicates.notEqualTo(photoAccessHelper.PhotoKeys.POSITION.toString(), 1);
      } else if (filterConditions.position === UserFileData.GET_ASSERT_WITHOUT_CLOUD) {
        this.fetchOption.predicates.notEqualTo(photoAccessHelper.PhotoKeys.POSITION.toString(), 2);
      } else {
        this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.POSITION.toString(),
          filterConditions.position);
      }
    } else if (filterConditions.positionFilter) {
      Log.info(TAG, `getFetchOpt positionFilter: ${filterConditions.positionFilter}`);
      UserFileData.convertPosition(this.fetchOption.predicates, filterConditions.positionFilter);
    }
    if (filterConditions.subtype) {
      Log.info(TAG, `getFetchOpt subtype: ${filterConditions.subtype}`);
      if (filterConditions.subtype === UserFileData.GET_ASSERT_WITHOUT_BURST_PHOTO) {
        this.fetchOption.predicates.notEqualTo(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(), 4);
      } else {
        this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE.toString(),
          filterConditions.subtype);
      }
    }
    return this;
  }

  private isMimeTypeFilterValid(param: QueryParam): boolean {
    if (!param || !param.filterConditions) {
      return false;
    }
    return !param.filterConditions.combinedMediaTypeFilter;
  }

  public setFilterParam(param?: QueryParam): PickerAlbumsFilterEnhanceBuilder {
    // 目前只处理param.filterConditions + 目前只处理param.filterMediaType
    Log.info(TAG, `param.filterConditions=${toString(param?.filterConditions)},
          param.filterMediaType=${param?.filterMediaType}`);
    if (param && param.filterMediaType && !param.filterConditions?.photoViewMimeTypeFilter) {
      let builder = new FileFetchOptionBuilder(this.fetchOption);
      AlbumDefine.setFilterMediaType(builder, param.filterMediaType);
    }

    if (!param || !param.filterConditions) {
      return this;
    }

    this.setPositionAndSubtype(param.filterConditions);
    // 当配置combinedMediaTypeFilter参数时，MimeType参数失效
    if (this.isMimeTypeFilterValid(param)) {
      this.setMimeTypeFilter(param);
    }

    this.setPhotoTypeFilter(param);

    this.setFileSizeAndVideoDuration(param.filterConditions);

    if (param.filterConditions.recommendationType === SelectConstants.RECOMMEND_TYPE_COLOR_STYPE) {
      Log.info(TAG, 'getFetchOpt recommendationType filter');
      this.fetchOption.predicates.equalTo('is_style_photo', 1);
    }
    return this;
  }

  setFileSizeMimeType(mimeType: photoAccessHelper.PhotoViewMIMETypes, hasMovingPhoto: boolean): void {
    if (mimeType === photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE) {
      this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE, UserFileData.MEDIA_TYPE_IMAGE);
      if (hasMovingPhoto) {
        this.fetchOption.predicates.and();
        this.fetchOption.predicates.notEqualTo(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE,
          photoAccessHelper.PhotoSubtype.MOVING_PHOTO);
      }
    } else if (mimeType === photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE) {
      this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE, UserFileData.MEDIA_TYPE_VIDEO);
    } else if (mimeType === photoAccessHelper.PhotoViewMIMETypes.MOVING_PHOTO_IMAGE_TYPE) {
      this.fetchOption.predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_SUBTYPE,
        photoAccessHelper.PhotoSubtype.MOVING_PHOTO);
    }
    if (mimeType !== photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE) {
      this.fetchOption.predicates.and();
    }
  }

  private setFileSizeOrDuration(filterOptions : FilterOptions): void {
    let filterColumn: string = '';
    if (filterOptions.mimeType && filterOptions.hasMovingPhoto !== undefined) {
      this.setFileSizeMimeType(filterOptions.mimeType, filterOptions.hasMovingPhoto);
    }
    if (filterOptions.isFilterFileSize) {
      filterColumn = photoAccessHelper.PhotoKeys.SIZE.toString();
    } else {
      filterColumn = photoAccessHelper.PhotoKeys.DURATION.toString()
    }
    switch (filterOptions.filterOperator) {
      case photoAccessHelper.FilterOperator.EQUAL_TO:
        this.fetchOption.predicates.equalTo(filterColumn, filterOptions.firstFileSize);
        break;
      case photoAccessHelper.FilterOperator.NOT_EQUAL_TO:
        this.fetchOption.predicates.notEqualTo(filterColumn, filterOptions.firstFileSize);
        break;
      case photoAccessHelper.FilterOperator.MORE_THAN:
        this.fetchOption.predicates.greaterThan(filterColumn, filterOptions.firstFileSize);
        break;
      case photoAccessHelper.FilterOperator.LESS_THAN:
        this.fetchOption.predicates.lessThan(filterColumn, filterOptions.firstFileSize);
        break;
      case photoAccessHelper.FilterOperator.MORE_THAN_OR_EQUAL_TO:
        this.fetchOption.predicates.greaterThanOrEqualTo(filterColumn, filterOptions.firstFileSize);
        break;
      case photoAccessHelper.FilterOperator.LESS_THAN_OR_EQUAL_TO:
        this.fetchOption.predicates.lessThanOrEqualTo(filterColumn, filterOptions.firstFileSize);
        break;
      case photoAccessHelper.FilterOperator.BETWEEN:
        this.fetchOption.predicates.between(filterColumn, filterOptions.firstFileSize, filterOptions.extraFileSize);
        break;
      default:
        Log.error(TAG, `Unsupported filter operator: ${filterOptions.filterOperator}`);
    }
  }

  public build(): FetchOptions {
    return this.fetchOption;
  }
}

//提供筛选条件的选项
interface FilterOptions {
  isFilterFileSize: boolean;
  filterOperator: photoAccessHelper.FilterOperator;
  firstFileSize: number;
  extraFileSize: number;
  mimeType: photoAccessHelper.PhotoViewMIMETypes | undefined;
  hasMovingPhoto: boolean | undefined;
}