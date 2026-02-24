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
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { common } from '@kit.AbilityKit';
import lazy { DataListener } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { FaCardDataSource } from '@ohos/common/src/main/ets/default/model/browser/album/FaCardDataSource';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { FaCardAlbumUtils } from '@ohos/dataprovider/src/main/ets/database/service/FaCardAlbumService';
import lazy {
  AlbumType as FATableAlbumType
} from '@ohos/dataprovider/src/main/ets/database/databaseconstant/FaCardTable';

const EDITOR_ENTRY_ALBUM_INDEX = 0;
const TAG: string = 'FaCardAlbumDataViewModel';

/* instrument ignore file */
export class FaCardAlbumDataViewModel {
  private static _instance?: FaCardAlbumDataViewModel;

  private constructor() {
  }

  public static getInstance(): FaCardAlbumDataViewModel {
    if (!FaCardAlbumDataViewModel._instance) {
      FaCardAlbumDataViewModel._instance = new FaCardAlbumDataViewModel();
    }
    return FaCardAlbumDataViewModel._instance;
  }

  // 普通相册 - 系统相册 自定义相册
  private albums?: FaCardDataSource;
  private sourceAlbums?: FaCardDataSource;
  private albumCallback?: Function;
  private faCardAlbumUtils?: FaCardAlbumUtils;

  initData(appBroadCast: BroadCast, context: common.Context, albumType?: FATableAlbumType) {
    Log.info(TAG, 'initData in. ')
    this.initAllData(appBroadCast, context);
  }

  initAllData(appBroadCast: BroadCast, context: common.Context) {
    this.albums = new FaCardDataSource(appBroadCast, context, 'normal');
    this.sourceAlbums = new FaCardDataSource(appBroadCast, context, 'source');
    // 设置normal 和 source 过滤条件
    this.albums.setFilterMediaType(AlbumDefine.FILTER_MEDIA_TYPE_IMAGE);
    this.sourceAlbums.setFilterMediaType(AlbumDefine.FILTER_MEDIA_TYPE_IMAGE);
    // 注册完成监听
    this.albums.addListener(this.albumDataListener);
    this.sourceAlbums.addListener(this.albumDataListener);
    // 初始化数据
    this.albums.initData();
    this.sourceAlbums.initData();
    this.faCardAlbumUtils = new FaCardAlbumUtils(context);
  }

  removeCallBack() {
    Log.info(TAG, 'removeCallBack. ');
    this.albumCallback = undefined;
  }

  destroy() {
    Log.info(TAG, 'destroy. ')
    // 移除完成监听
    this.albums?.removeListener(this.albumDataListener);
    this.sourceAlbums?.removeListener(this.albumDataListener);

    this.onInActive();
  }

  onInActive(): void {
    this.albums?.onInActive();
    this.sourceAlbums?.onInActive();
  }

  public getAlbums(): FaCardDataSource | undefined {
    return this.albums;
  }

  public getSourceAlbums(): FaCardDataSource | undefined {
    return this.sourceAlbums;
  }

  public checkTheAlbumIsEmpty(): boolean {
    let isAlbumEmpty: boolean = true;
    if (this.albums?.totalCount() || this.sourceAlbums?.totalCount()) {
      isAlbumEmpty = false;
    } else {
      isAlbumEmpty = true;
    }
    Log.info(TAG, `checkTheAlbumIsEmpty: ${isAlbumEmpty}`);
    return isAlbumEmpty;
  }

  async registerAlbumData(callback?: Function) {
    this.albumCallback = callback;
  }

  private readonly albumDataListener: DataListener<AlbumInfo> = {
    onLoadingFinished: () => {
      if (this.albumCallback) {
        this.albumCallback();
      }
      Log.info(TAG,
        `albumDataListener onLoadingFinished. `);
    },
  };
}