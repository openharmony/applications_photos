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

import lazy { collections } from '@kit.ArkTS';
import lazy { UserFileData } from '../model/UserFileData';
import lazy { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import lazy { Log } from '../utils/Log';
import lazy { SendablePhotoAlbum } from '../access/SendablePhotoAccessHelper';
import lazy { PhotoAccessHelperAccess } from '../access/PhotoAccessHelperAccess';
import lazy { RelationStoreUtil } from '../utils/RelationStoreUtil';
import lazy { AlbumInfo } from './browser/album/AlbumInfo';
import lazy { PhotoAlbum } from '../utils/PhotoBrowserUtils';
import lazy systemParameter from '@ohos.systemparameter';
import lazy { StringUtil } from '../utils/StringUtil';

@Sendable
export class SortRuleString {
  public static DESC: string = 'DESC';
  public static ASC: string = 'ASC';
  private formatChar: string = ',';
  private formatStr: string = '';

  constructor(inputRuleOrType?: AlbumGridSortRule, inputType?: string) {
    this.formatStr = inputRuleOrType ? [inputRuleOrType, inputType].filter(Boolean).join(this.formatChar) : '';
  }

  static get defaultType() {
    return SortRuleString.DESC;
  }

  get rule() {
    return this.formatStr.split(this.formatChar)[0] || '';
  }

  get type() {
    return this.formatStr.split(this.formatChar)[1] || SortRuleString.defaultType;
  }

  toString() {
    return [this.rule, this.type].join(this.formatChar);
  }
}


@Sendable
export class AlbumGridSortRule {
  // 拍摄时间
  public static SHOOT_TIME: string = 'SHOOT_TIME';
  //  创建时间
  public static CREATE_TIME: string = 'CREATE_TIME';
  // 文件名称
  public static FILE_NAME: string = 'FILE_NAME';
  // 文件大小
  public static FILE_SIZE: string = 'FILE_SIZE';
}

/**
 * 宫格排序工具类
 * 子线程中获取不到主线程的单例，需要使用Sendable能力
 */
@Sendable
export class AlbumGridSortHelper {
  private static instance: AlbumGridSortHelper = new AlbumGridSortHelper();
  public sortRuleMap: collections.Map<string, SortRuleString> = new collections.Map<string, SortRuleString>();
  private static readonly tag: string = 'common_AlbumGridSortUtil';
  private shareAlbumUri: string = '';
  private _isOpenGridSort: boolean = false;

  public get isOpenGridSort(): boolean {
    return this._isOpenGridSort;
  }

  public setShareAlbumUri(value: string) {
    this.shareAlbumUri = value;
  }

  public getShareAlbumUri(): string {
    return this.shareAlbumUri;
  }

  constructor() {
    // 打开宫格排序特性：hdc shell param set const.sys.photos.gridSort.enable on
    const GRID_SORT_ENABLE: string = 'const.sys.photos.gridSort.enable';
    const GRID_SORT_ON: string = 'on';
    let param: string = systemParameter.getSync(GRID_SORT_ENABLE, GRID_SORT_ON); // 获取配置项
    this._isOpenGridSort = StringUtil.size(param) !== 0 && param === GRID_SORT_ON;
    Log.info('common_AlbumGridSortUtil', `current gridSort enable: ${this._isOpenGridSort}`);
  }

  public static getInstance(): AlbumGridSortHelper {
    if (!AlbumGridSortHelper.instance) {
      AlbumGridSortHelper.instance = new AlbumGridSortHelper();
    }
    return AlbumGridSortHelper.instance;
  }

  /**
   * 从数据库恢复相册排序规则列表
   * @param context 上下文
   */
  public resume(context: Context | undefined): void {
    Log.info(AlbumGridSortHelper.tag, `resume`);
    if (!this.isOpenGridSort) {
      return;
    }

    RelationStoreUtil.getInstance().queryAllSortRuleFromDb(context, this.sortRuleMap);
  }

  /**
   * 保存相册宫格排序规则
   * @param albumKey 相册数据库唯一标识（subType+lpath)
   * @param rule 排序规则
   */
  public setSortRule(albumKey: string, rule: AlbumGridSortRule, sortType: string): void {
    Log.info(AlbumGridSortHelper.tag, `setSortRule: albumKey: ${StringUtil.getAnonymizeString(albumKey)}, rule: ${rule}, sortType:${sortType}`);
    this.sortRuleMap.set(albumKey, new SortRuleString(rule, sortType));
    // 持久化
    RelationStoreUtil.getInstance().insertSortRule(albumKey, rule.toString(), sortType);
  }

  /**
   * 保存相册宫格排序规则 -- 克隆流程
   * @param albumKey 相册数据库唯一标识（subType+lpath)
   * @param rule 排序规则
   */
  public setSortRuleEx(context: Context, albumKey: string, rule: AlbumGridSortRule, sortType: string): void {
    Log.info(AlbumGridSortHelper.tag, `setSortRule: albumKey: ${StringUtil.getAnonymizeString(albumKey)}, rule: ${rule}, sortType:${sortType}`);
    this.sortRuleMap.set(albumKey, new SortRuleString(rule, sortType));
    // 持久化
    RelationStoreUtil.getInstance().insertSortRuleEx(context, albumKey, rule.toString(), sortType);
  }

  /**
   * 获取相册排序规则
   * @param albumUri 相册uri
   * @param selfInstance 主线程util实例
   * @returns 排序规则
   */
  public getSortRule(callFrom: string, albumKey: string, selfInstance?: AlbumGridSortHelper): SortRuleString {
    Log.info(AlbumGridSortHelper.tag, `getSortRule: callFrom: ${callFrom}, albumKey: ${StringUtil.getAnonymizeString(albumKey)}` +
      ` , rule: ${this.sortRuleMap.get(albumKey)}`);
    if (!this.isOpenGridSort) {
      return new SortRuleString();
    }
    return (selfInstance ?? this).sortRuleMap.get(albumKey) || new SortRuleString();
  }

  public static transferRuleToOrderProp(rule: AlbumGridSortRule | undefined): string | undefined {
    switch (rule) {
      case AlbumGridSortRule.SHOOT_TIME:
        return UserFileData .FILE_KEY_DATE_TAKEN_MS.toString();
      case AlbumGridSortRule.CREATE_TIME:
        return UserFileData .FILE_KEY_DATE_ADDED.toString();
      case AlbumGridSortRule.FILE_NAME:
        return UserFileData .FILE_KEY_DISPLAY_NAME.toString();
      case AlbumGridSortRule.FILE_SIZE:
        return UserFileData .FILE_KEY_SIZE.toString();
      default:
        Log.error(AlbumGridSortHelper.tag, `unexpected rule: ${rule}`);
        return undefined;
    }
  }

  public static transferOrderPropToRule(prop: string): AlbumGridSortRule | undefined {
    switch (prop) {
      case UserFileData .FILE_KEY_DATE_TAKEN_MS.toString():
        return AlbumGridSortRule.SHOOT_TIME;
      case UserFileData .FILE_KEY_DATE_ADDED.toString():
        return AlbumGridSortRule.CREATE_TIME;
      case UserFileData .FILE_KEY_DISPLAY_NAME.toString():
        return AlbumGridSortRule.FILE_NAME;
      case UserFileData .FILE_KEY_SIZE.toString():
        return AlbumGridSortRule.FILE_SIZE;
      default:
        Log.error(AlbumGridSortHelper.tag, `transferOrderPropToRule unexpected prop: ${prop}`);
        return undefined;
    }
  }

  /**
   * 获取指定相册的排序字段
   * @param albumUri 相册uri
   * @param albumKey 数据库key值
   * @param selfInstance 图库主线程实例
   * @returns 宫格排序字段
   */
  public static getOrderPropByAlbumUri(albumUri: string, albumKey?: string | undefined, selfInstance?: AlbumGridSortHelper): string {
    Log.info(AlbumGridSortHelper.tag, `getOrderPropByAlbumUri:, albumUri: ${albumUri}, albumKey: ${StringUtil.getAnonymizeString(albumKey)}`);
    let helper: AlbumGridSortHelper = selfInstance ?? AlbumGridSortHelper.getInstance();
    // 传了albumKey，是系统相册、来源相册或用户相册，需要去数据库中查询对应规则
    if (helper.isOpenGridSort && albumKey !== undefined) {
      const persistOrderProp: string | undefined =
        AlbumGridSortHelper.transferRuleToOrderProp(helper
          .getSortRule('getOrderPropByAlbumUri', albumKey)
          .rule);
      return persistOrderProp ?? AlbumGridSortHelper.getDefaultOrderProp(albumUri, selfInstance);
    }
    // 没传albumKey，则按照albumUri查询默认排序规则返回
    return AlbumGridSortHelper.getDefaultOrderProp(albumUri);
  }

  public static getDefaultOrderProp(albumUri: string, selfInstance?: AlbumGridSortHelper): string {
    // 相册未指定过排序规则，按照默认规则
    // 相册页“图片”“视频”相册按照保存时间dateAdded倒序显示
    // 非“图片”“视频”相册（不含隐藏相册，最近删除），按照拍摄时间dateTaken倒序显示
    const isOrderByDateTaken: boolean = AlbumGridSortHelper.isOrderByDateTaken(albumUri, selfInstance);
    if (isOrderByDateTaken) {
      return UserFileData .FILE_KEY_DATE_TAKEN_MS.toString();
    } else {
      return UserFileData .FILE_KEY_DATE_ADDED.toString();
    }
  }

  /**
   * 获取指定相册的排序字段
   * @param albumUri 相册uri
   * @param selfInstance 主线程util实例
   * @returns 宫格排序字段
   */
  public static getOrderPropByAlbum(album: SendablePhotoAlbum | undefined, selfInstance?: AlbumGridSortHelper): string {
    let instance: AlbumGridSortHelper | undefined = undefined;
    let photoKey: string | undefined = undefined;
    let sortRuleString: SortRuleString | undefined = undefined;
    try {
      instance = selfInstance ?? AlbumGridSortHelper.getInstance();
      photoKey = AlbumGridSortHelper.getAlbumKeyByPhotoAlbum(album);
      sortRuleString = instance.getSortRule('getOrderPropByAlbum', photoKey);
    } catch (e) {
      Log.info(AlbumGridSortHelper.tag, `instance=${instance}, photoKey=${photoKey}, sortRuleString=${sortRuleString}`);
    }
    const persistOrderProp: string | undefined = AlbumGridSortHelper.transferRuleToOrderProp(sortRuleString?.rule);
    if (AlbumGridSortHelper.getInstance().isOpenGridSort && persistOrderProp !== undefined) {
      return persistOrderProp;
    }
    // 相册未指定过排序规则，按照默认规则
    // 相册页“图片”“视频”相册按照保存时间dateAdded倒序显示
    // 非“图片”“视频”相册（不含隐藏相册，最近删除），按照拍摄时间dateTaken倒序显示
    const isOrderByDateTaken: boolean =
      album ? (!PhotoAccessHelperAccess.isVideoAlbum(album) && !PhotoAccessHelperAccess.isPhotoAlbum(album) &&
        !PhotoAccessHelperAccess.isShareAlbum(album)) : false;
    if (isOrderByDateTaken) {
      return UserFileData .FILE_KEY_DATE_TAKEN_MS.toString();
    } else {
      return UserFileData .FILE_KEY_DATE_ADDED.toString();
    }
  }

  public static isOrderByDateTaken(albumUri: string, selfInstance?: AlbumGridSortHelper): boolean {
    if (albumUri === (selfInstance ?? AlbumGridSortHelper.getInstance()).getShareAlbumUri()) {
      return false;
    }
    return albumUri ? (!UserFileManagerAccess.isVideoAlbumUri(albumUri) &&
      !(UserFileManagerAccess.isImageAlbumUri(albumUri))) : false;
  }

  public static isAsc(album: SendablePhotoAlbum | undefined, selfInstance?: AlbumGridSortHelper) {
    if (!AlbumGridSortHelper.getInstance().isOpenGridSort) {
      return false;
    }
    return AlbumGridSortHelper.getInstance()
      .getSortRule('isAsc', AlbumGridSortHelper.getAlbumKeyByPhotoAlbum(album), selfInstance)
      .type === SortRuleString.ASC;
  }

  public static getAlbumKeyByAlbumInfo(albumInfo: AlbumInfo | undefined): string {
    return albumInfo?.subType + (albumInfo?.lpath ?? '');
  }

  public static getAlbumKeyByPhotoAlbum(album: SendablePhotoAlbum | PhotoAlbum | undefined): string {
    return album?.albumSubtype + (album?.lpath ?? '');
  }
}