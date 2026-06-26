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
import lazy common from '@ohos.app.ability.common';
import lazy fs from '@ohos.file.fs';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { BusinessError } from '@ohos.base';
import lazy { TraceControllerUtils } from '../utils/TraceControllerUtils';
import lazy { AlbumDefine } from './browser/AlbumDefine';
import lazy { StringUtil } from '../utils/StringUtil';
import lazy { util } from '@kit.ArkTS';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';

export enum CacheType {
  /**
   * 人像
   */
  PORTRAIT = 'PORTRAIT',
  /**
   * 地图
   */
  MAP = 'MAP',
  /**
   * 分类
   */
  CATEGORY = 'CATEGORY',
  /**
   * 拍摄模式
   */
  SHOOT_MODE = 'SHOOT_MODE',
  /**
   * 来源相册
   */
  SOURCE = 'SOURCE',
  /**
   * 相册
   */
  ALBUMS = 'ALBUMS',
  /**
   * 时刻
   */
  HIGHLIGHT = 'HIGH_LIGHT',
  /**
   * 人像列表页-收藏人像
   */
  PORTRAIT_FAVORITES_ALBUMS = 'PORTRAIT_FAVORITES_ALBUMS',
  /**
   * 人像列表页-主页人像
   */
  PORTRAIT_HOMEPAGE_ALBUMS = 'PORTRAIT_HOMEPAGE_ALBUMS',
  /**
   * 人像列表页-主页及收藏人像
   */
  PORTRAIT_MAIN_ALBUMS = 'PORTRAIT_MAIN_ALBUMS',
  /**
   * 更多人像页面
   */
  PORTRAIT_MORE_ALBUMS = 'PORTRAIT_MORE_ALBUMS',
  /**
   * 大图详情页-人像列表
   */
  PORTRAIT_DETAIL_ALBUMS = 'PORTRAIT_DETAIL_ALBUMS',
  /**
   * 合影相册
   */
  GROUP_ALBUMS = 'GROUP_ALBUMS',
  /**
   * 分类列表宫格
   */
  CATEGORY_ALBUMS_LIST = 'CATEGORY_ALBUMS_LIST',
}

const TAG: string = 'AlbumSetCacheManager';
const PORTRAIT_CACHE_FILE: string = '/portrait.cache';
const MAP_CACHE_FILE: string = '/map.cache';
const CATEGORY_CACHE_FILE: string = '/category.cache';
const SHOOT_MODE_CACHE_FILE: string = '/shoot_mode.cache';
const SOURCE_CACHE_FILE: string = '/source.cache';
const ALBUMS_CACHE_FILE: string = '/albums.cache';
const HIGHLIGHT_CACHE_FILE: string = '/highlight.cache';
const PORTRAIT_FAVORITES_ALBUMS_CACHE_FILE: string = '/portrait_favorites_albums.cache';
const PORTRAIT_HOMEPAGE_ALBUMS_CACHE_FILE: string = '/portrait_homepage_albums.cache';
const PORTRAIT_MAIN_ALBUMS_CACHE_FILE: string = '/portrait_main_albums.cache';
const PORTRAIT_MORE_ALBUMS_CACHE_FILE: string = '/portrait_more_albums.cache';
const PORTRAIT_DETAIL_ALBUMS_CACHE_FILE: string = '/portrait_detail_albums.cache';
const GROUP_CACHE_FILE: string = '/group_albums.cache';
const CATEGORY_ALBUMS_FILE: string = '/category_albums.cache';

const CACHE_PATHS: Map<CacheType, string> = new Map([
  [CacheType.PORTRAIT, PORTRAIT_CACHE_FILE],
  [CacheType.MAP, MAP_CACHE_FILE],
  [CacheType.CATEGORY, CATEGORY_CACHE_FILE],
  [CacheType.SHOOT_MODE, SHOOT_MODE_CACHE_FILE],
  [CacheType.SOURCE, SOURCE_CACHE_FILE],
  [CacheType.ALBUMS, ALBUMS_CACHE_FILE],
  [CacheType.HIGHLIGHT, HIGHLIGHT_CACHE_FILE],
  [CacheType.GROUP_ALBUMS, GROUP_CACHE_FILE],
  [CacheType.CATEGORY_ALBUMS_LIST, CATEGORY_ALBUMS_FILE]
]);
/**
 * 非冷启动场景所需加载的缓存数据
 */
const SUB_CACHE_PATHS: Map<CacheType, string> = new Map([
  [CacheType.PORTRAIT_FAVORITES_ALBUMS, PORTRAIT_FAVORITES_ALBUMS_CACHE_FILE],
  [CacheType.PORTRAIT_HOMEPAGE_ALBUMS, PORTRAIT_HOMEPAGE_ALBUMS_CACHE_FILE],
  [CacheType.PORTRAIT_MAIN_ALBUMS, PORTRAIT_MAIN_ALBUMS_CACHE_FILE],
  [CacheType.PORTRAIT_MORE_ALBUMS, PORTRAIT_MORE_ALBUMS_CACHE_FILE],
  [CacheType.PORTRAIT_DETAIL_ALBUMS, PORTRAIT_DETAIL_ALBUMS_CACHE_FILE],
]);


/**
 * 冷启时在MainAbility创建时即加载，理论上界面加载使用时已经能取到，但是也可能由于没有缓存/缓存加载慢，这时则舍弃；
 */
export class AlbumSetCacheManager {
  /**
   * LocalStorage中存储对象的key值
   */
  public static readonly STORAGE_KEY: string = 'com.ohos.photos.albumset.cache';
  public readonly instanceId: number;
  private context: common.Context;
  private readonly caches: Map<CacheType, Object | undefined> = new Map();
  private readonly cachesBuffer: Map<CacheType, object | undefined> = new Map();
  private readonly cachesIsWriting: Map<CacheType, boolean> = new Map();
  private readonly readReqCache: util.LRUCache<CacheType, Promise<Object | undefined>> =
    new util.LRUCache(CACHE_PATHS.size);

  public constructor(context: common.Context) {
    this.context = context;
    this.instanceId = Math.round(Math.random() * 100_000);
    Log.info(TAG, `Album cache mgr created with instanceId ${this.instanceId}`);
    if (!context) {
      Log.warn(TAG, 'invalid context');
    }
  }

  private updateContext(context: common.Context): void {
    this.context = context;
  }

  public load(): void {
    this.readReqCache.clear();
    CACHE_PATHS.forEach((value: string, key: CacheType) => {
      this.readReqCache.put(key, this.getCacheFromFile(key, value));
    });
  }

  public async loadCacheWithKey(key: CacheType, filePath: string): Promise<Object | undefined> {
    // 如果内存中已经加载过对应key的缓存数据，则无需重新从File中读取
    if (this.caches.has(key)) {
      return this.caches.get(key);
    }
    let cache: Object | undefined = await this.getCacheFromFile(key, filePath);
    return cache;
  }

  /* instrument ignore next */
  private async getCacheFromFile(cacheType: CacheType, filePath: string): Promise<Object | undefined> {
    Log.info(TAG, `getCacheFromFile start ${cacheType} with instanceId ${this.instanceId}`);
    let start: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId(`getCacheFromFile:${cacheType}`, start);
    try {
      let content: string = await fs.readText(this.context.filesDir + filePath);
      Log.info(TAG, `getCacheFromFile cost: ${Date.now() - start}, type: ${cacheType} with instanceId ${this.instanceId}`);
      if (content === undefined || content.trim().length === 0) {
        this.caches.set(cacheType, undefined);
        return undefined;
      }
      let cache: Object = JSON.parse(content.trim());
      if (cacheType !== CacheType.PORTRAIT_MAIN_ALBUMS && cacheType !== CacheType.PORTRAIT_MORE_ALBUMS) {
        Log.info(TAG, `getCacheFromFile with instanceId ${this.instanceId} ${JSON.stringify(cache, AlbumDefine.albumNameReplacer)}`);
      }
      this.caches.set(cacheType, cache);
      return cache;
    } catch (err) {
      let businessErr: BusinessError = err as BusinessError;
      Log.error(TAG, `failed to get cache: ${cacheType}, err: ${businessErr?.name}, ${businessErr?.message}`);
      this.caches.set(cacheType, undefined);
      return undefined;
    } finally {
      this.readReqCache.remove(cacheType);
      TraceControllerUtils.finishTraceWithTaskId(`getCacheFromFile:${cacheType}`, start);
    }
  }

  /**
   * 读取缓存内容到内存中,以便在适当的时候使用
   *
   * @param cacheType 缓存类型
   */
  public async setCacheData(cacheType: CacheType): Promise<void> {
    let filePath: string | undefined = CACHE_PATHS.get(cacheType);
    if (!filePath) {
      Log.info(TAG, 'setCacheData file path is invalid ');
      return;
    }
    Log.info(TAG, `setCacheData start ${cacheType} with instanceId ${this.instanceId}`);
    let start: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId(`getCacheFromFile:${cacheType}`, start);
    try {
      if (!this.context) {
        this.updateContext(global.uiAbilityContext());
      }
      let content: string = await fs.readText(this.context.filesDir + filePath);
      Log.info(TAG, `setCacheData cost: ${Date.now() - start}, type: ${cacheType} with instanceId ${this.instanceId}`);
      if (content === undefined || content.trim().length === 0) {
        Log.info(TAG, 'setCacheData content length is 0 ');
        this.caches.set(cacheType, undefined);
        return;
      }
      let cache: Object = JSON.parse(content);
      this.caches.set(cacheType, cache);
      Log.info(TAG, `setCacheData content: ${JSON.stringify(cache, AlbumDefine.albumNameReplacer)}`);
    } catch (err) {
      let businessErr: BusinessError = err as BusinessError;
      Log.error(TAG,
        `setCacheData failed to set cache: ${cacheType}, err: ${businessErr?.name}, ${businessErr?.message}`);
      this.caches.set(cacheType, undefined);
    } finally {
      TraceControllerUtils.finishTraceWithTaskId(`setCacheData:${cacheType}`, start);
    }
  }

  public getCache(cacheType: CacheType | undefined): Object | undefined {
    if (!cacheType) {
      return undefined;
    }
    return this.caches.get(cacheType);
  }

  public async getCacheAsync(cacheType: CacheType | undefined): Promise<Object | undefined> {
    if (!cacheType) {
      return undefined;
    }
    if (this.caches.get(cacheType)) {
      Log.info(TAG, `read from caches, type: ${cacheType} with instanceId ${this.instanceId}`);
      return this.caches.get(cacheType);
    }
    Log.info(TAG, `read from readReqCache, type: ${cacheType} with instanceId ${this.instanceId}`);
    return this.readReqCache.get(cacheType);
  }

  public syncMemoryCache(cacheType: CacheType, cache: Object | undefined): void {
    if(!this.caches) {
      return;
    }
    this.caches.set(cacheType, cache);
  }

  public async writeCache(cacheType: CacheType, cache: Object | undefined): Promise<void> {
    let filePath: string | undefined = CACHE_PATHS.get(cacheType);
    if (!filePath) {
      filePath = SUB_CACHE_PATHS.get(cacheType);
    }
    if (!filePath) {
      return;
    }
    this.cachesBuffer.set(cacheType, cache);
    Log.info(TAG, `writeCache, start ${cacheType} with instanceId ${this.instanceId}`);
    let start: number = Date.now();
    let cacheFile: fs.File | undefined = undefined;
    try {
      if (!this.cachesIsWriting.get(cacheType)) {
        // 在单个cache写的过程中，新增的内容只只设置到buffer，不写入
        this.cachesIsWriting.set(cacheType, true);
        cacheFile = await fs.open(this.context.filesDir + filePath,
          fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
        let content: string = `${JSON.stringify(cache)}`;
        await fs.write(cacheFile.fd, content);
        Log.info(TAG, `writeCache cost: ${Date.now() - start}, type: ${cacheType}, with instanceId ${this.instanceId} ` +
          `content: ${this.getCacheContent(cacheType, cache)}`);
        this.cachesIsWriting.set(cacheType, false);
        // 保证写入期间设置到buffer的最新一个写入
        let bufferCache = this.cachesBuffer.get(cacheType);
        if (bufferCache) {
          let bufferContent = `${JSON.stringify(bufferCache)}`;
          if (bufferContent !== content) {
            Log.info(TAG, `re-write cache by buffer content with instanceId ${this.instanceId}`);
            await fs.write(cacheFile.fd, bufferContent);
          }
        }
      }
    } catch (err) {
      let businessErr: BusinessError = err as BusinessError;
      Log.error(TAG, `writeCache, failed: ${cacheType}, err: ${businessErr?.name}, ${businessErr?.message} with instanceId ${this.instanceId}`);
    } finally {
      if (cacheFile) {
        Log.info(TAG, `[fd flag] writeCache ,fs close fd: ${cacheFile.fd}`);
        await fs.close(cacheFile);
      }
    }
  }

  private getCacheContent(cacheType: CacheType, cache: Object | undefined): string {
    if (cacheType === CacheType.SOURCE) {
      return `${JSON.stringify(cache, this.sourceAlbumNameReplacer)}`;
    }
    if (cacheType === CacheType.PORTRAIT_MAIN_ALBUMS || cacheType === CacheType.PORTRAIT_MORE_ALBUMS) {
      return `portrait album do not need print`;
    }

    return `${JSON.stringify(cache, AlbumDefine.albumNameReplacer)}`;
  }

  private sourceAlbumNameReplacer(key: string, value: string): string {
    return key === 'name' ? StringUtil.getAnonymizeString(value) : value;
  }
}