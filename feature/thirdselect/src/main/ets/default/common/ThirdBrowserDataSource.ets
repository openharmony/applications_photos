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

import lazy {
  DataListener,
  DataSource,
  LoadingInfo,
  LoadingResult, LoadingTask } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { PageData } from '@ohos/common/src/main/ets/default/model/PageData';
import lazy { MediaResult } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaResult';
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';

/* instrument ignore file */
const TAG: string = 'ThirdBrowserDataSource';

class DifferenceListLoadingTask extends LoadingTask<MediaItem> {
  public async start(): Promise<LoadingResult<MediaItem>> {
    // 求差集
    let differenceList: MediaItem[];
    let selectManager: ThirdSelectManager | undefined =
      LocalStorage.getShared()?.get<ThirdSelectManager>(Constants.THIRD_SELECT_MANAGER);
    let selectedItems: MediaItem[] = selectManager?.getSelectItems() ?? [];
    let selectedUris: string[] = selectedItems.filter(asset => {
      if (!asset) {
        Log.error(TAG, 'DifferenceListLoadingTask invalid asset');
        return false;
      }
      return true;
    }).map(asset => asset.uri);
    let albumUris: string[] = [];
    let datasource: MediaDataSource | undefined =
      LocalStorage.getShared()?.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER);
    let albumInfo: AlbumInfo | undefined = datasource?.albumInfo;
    if (albumInfo && albumInfo.unionAlbumUris.length > 0) {
      albumUris = albumInfo.unionAlbumUris;
    } else if (datasource?.albumUri) {
      const albumUri = datasource?.albumUri;
      if (albumUri) {
        albumUris.push(albumUri);
      }
    }
    let albumUriList: string[] | undefined =
      await datasource?.photoDataImpl.checkMediaItemsInDataSource(selectedUris, albumUris ?? []);

    if (!albumUriList) {
      Log.error(TAG, `albumUriList is undefined.`);
      return {
        info: this.info,
        oldPageData: this.pageData,
        newPageData: new PageData(this.loadVersion, [], 0, 0),
      } as LoadingResult<MediaItem>;
    }
    differenceList = [];

    const albumMediaItemUris = new Set(albumUriList);

    for (let selectedItem of selectedItems) {
      if (!albumMediaItemUris.has(selectedItem.uri)) {
        differenceList.push(selectedItem);
      }
    }
    Log.info(TAG, `this.differenceSet=${differenceList.length}`);

    return {
      info: this.info,
      oldPageData: this.pageData,
      newPageData: new PageData(this.loadVersion, differenceList, 0, 0),
    } as LoadingResult<MediaItem>;
  }
}

class DifferenceListUpdater extends DataSource<MediaItem> {

  public constructor() {
    super();
  }

  protected buildLoadingTask(info: LoadingInfo): LoadingTask<MediaItem> | undefined {
    return new DifferenceListLoadingTask(info, this, this.pageData);
  }
}
/**
 * 用于预览已选中的图片的dataSource
 * 数据源取自selectManager的当前已选中图片+当前数据集内的图片
 */
export class ThirdBrowserDataSource extends PhotoDataSource {
  private isSelectMode = false;
  private isAllMode = false;
  private browserSelectMode: number = 0;
  private selectedItems: MediaItem[] = [];
  // 已选择数据和当前album数据的差集
  public differenceList: MediaItem[] = [];
  // 是否完成差集的计算
  private hasCompleted: boolean = false;
  private differenceListUpdater: DifferenceListUpdater = new DifferenceListUpdater();
  private readonly differenceListDataListener: DataListener<MediaItem> = {
    onLoadingFinished: (result: LoadingResult<MediaItem>) => {
      this.onDifferenceListFetched(result);
    },
  };
  private isFirstEnter: boolean = true;
  private uriToShowAfterDifferenceListFetched: string = '';

  constructor(stateMachine: PhotoBrowserStateMachine) {
    super(stateMachine);
    this.differenceListUpdater.addListener(this.differenceListDataListener);
  }

  public setUriToShowAfterDifferenceListFetched(uri: string): void {
    if (!this.isFirstEnter) {
      return;
    }
    this.uriToShowAfterDifferenceListFetched = uri;
  }

  private onDifferenceListFetched(result: LoadingResult<MediaItem>): void {
    if (result.newPageData) {
      this.differenceList = result.newPageData.data as MediaItem[];
      this.hasCompleted = true;
      Log.info(TAG, `hasCompleted=${this.hasCompleted},differenceList=${this.differenceList?.length}`);
      if (this.isFirstEnter && this.getAllMode()) {
        let selectManager: ThirdSelectManager | undefined =
          LocalStorage.getShared()?.get<ThirdSelectManager>(Constants.THIRD_SELECT_MANAGER);
        // PreSelectedUris is Set
        let isTotalSelectedItemUriListExist =
          selectManager?.totalSelectedItemUriList && selectManager?.totalSelectedItemUriList.length > 0;
        // PreselectedInfo is Set
        let isTotalSelectedItemUriWithPickerIndexExist = selectManager?.totalSelectedItemUriWithPickerIndex
          && selectManager?.totalSelectedItemUriWithPickerIndex.length > 0;
        if (isTotalSelectedItemUriListExist || isTotalSelectedItemUriWithPickerIndexExist) {
          Log.info(TAG, 'isFirstEnter');
          this.broadCast?.emit(
            BroadCastConstants.SET_PHOTO_BROWSER_ITEM, [
              this.uriToShowAfterDifferenceListFetched || this.selectedItems[0]?.uri
          ]);
        }
        this.isFirstEnter = false;
      }
    }
  }


  totalCount(): number {
    if (this.isSelectMode) {
      Log.info(TAG, `totalCount sta1: ${this.selectedItems.length}`)
      return this.selectedItems.length;
    }

    if (!this.isAllMode) {
      return super.totalCount();
    }
    let result: number = !this.hasCompleted ? this.selectedItems.length + super.totalCount() :
      this.differenceList.length + super.totalCount();
    Log.debug(TAG, `totalCount sta2: ${result}`);
    return result;
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo, isForceUpdate?: boolean | undefined): void {
    let selectManager: ThirdSelectManager | undefined =
      LocalStorage.getShared()?.get<ThirdSelectManager>(Constants.THIRD_SELECT_MANAGER);
    this.setSelectMode(selectManager,this.isSelectMode);
    this.differenceListUpdater.notifyDirty();
    Log.info(TAG, `hasCompleted=${this.hasCompleted},differenceList=${this.differenceList.length}`);
  }

  public getAllMode(): boolean {
    Log.info(TAG, `getAllMode isAllMode: ${this.isAllMode}`);
    return this.isAllMode;
  }

  public setAllMode(isAllMode: boolean): void {
    Log.info(TAG, `setAllMode isAllMode: ${isAllMode}`);
    this.isAllMode = isAllMode;
  }

  getSelectedItem(index: number): MediaItem | undefined {
    const mediaItem: MediaItem | undefined = this.selectedItems?.[index];
    return mediaItem;
  }

  getData(index: number): MediaResult | undefined {
    if (this.isSelectMode) {
      Log.info(TAG, `getData sta1: ${this.isSelectMode}`)
      const mediaItem: MediaItem | undefined = this.selectedItems?.[index];
      if (!mediaItem) {
        Log.error(TAG, `Get item undefined, index: ${index}`);
        return undefined;
      }
      return this.packDataWithCache(index, mediaItem);
    }
    let result: MediaResult | undefined;
    if (this.isAllMode) {
      Log.info(TAG, `getData sta2, index=${index}`);
      result = this.getDataResult(index)
    } else {
      Log.info(TAG, `getData sta3, index=${index}`);
      result = super.getData(index);
    }
    return result;
  }

  private getDataResult(index: number): MediaResult | undefined {
    Log.info(TAG, `selectedItems[index]=${index}`);
    let mediaItemSet: MediaItem[] = this.hasCompleted ? this.differenceList : this.selectedItems;
    if (index < mediaItemSet.length) {
      const mediaItem: MediaItem | undefined = mediaItemSet?.[index];
      if (!mediaItem) {
        Log.error(TAG, `Get mediaItem undefined, index: ${index}`);
        return undefined;
      }
      return this.packDataWithCache(index, mediaItem) as MediaResult;
    } else {
      return super.getData(index - mediaItemSet.length);
    }
  }

  getDataWithoutCache(index: number): MediaResult | undefined {
    Log.info(TAG, `getDataWithoutCache index: ${index}`)
    return this.getData(index);
  }

  getDataInTimeLine(index: number): MediaResult {
    Log.info(TAG, `getDataInTimeLine index: ${index}`)
    return super.getDataWithoutCache(index) as MediaResult;
  }

  public setSelectMode(manager: ThirdSelectManager | undefined, isSelectedOnly?: boolean): void {
    if (!manager) {
      return;
    }
    this.selectedItems = manager.getSelectItems();
    this.isSelectMode = isSelectedOnly ? isSelectedOnly : false;
    Log.info(TAG, `isSelectMode: ${this.isSelectMode}, isAllMode=${this.isAllMode}`);
    if (this.isSelectMode || !this.isAllMode) {
      return;
    }

    // 求差集
    this.differenceListUpdater.notifyDirty();
  }

  getDataIndex(item: MediaItem): number {
    if (this.isSelectMode) {
      Log.info(TAG, 'getDataIndex sta1');
      for (let i = 0; i < this.selectedItems.length; i++) {
        let clicked: MediaItem = this.selectedItems[i];
        if (clicked?.uri === item?.uri) {
          Log.info(TAG, `getDataIndex sta1 i: ${i}`)
          return i;
        }
      }
      Log.info(TAG, `getDataIndex sta1 i: ${Constants.NOT_FOUND}`)
      return Constants.NOT_FOUND;
    }
    Log.info(TAG, `getDataIndex sta2, isAllMode= ${this.isAllMode}`);
    let result: number;
    if (this.isAllMode) {
      let mediaItemList: MediaItem[] = this.hasCompleted ? this.differenceList : this.selectedItems;
      Log.info(TAG, `mediaItemList.length=${mediaItemList.length}, hascompleted=${this.hasCompleted}`);
      if (mediaItemList.length > 0) {
        for (let index = 0; index < mediaItemList.length; index++) {
          const tmpItem: MediaItem = mediaItemList[index];
          if (item.equals(tmpItem)) {
            return index;
          }
        }
      }
      result = super.getDataIndex(item) + mediaItemList.length;
    } else {
      result = super.getDataIndex(item);
      Log.info(TAG, `getDataIndex sta3, result: ${result}`);
    }
    return result;
  }

  getSelectMode(): boolean {
    Log.info(TAG, `getSelectMode isSelectMode ${this.isSelectMode}`);
    return this.isSelectMode;
  }

  getDataIndexByUri(uri?: string): number {
    Log.info(TAG, `getDataIndexByUri uri: ${uri}`)
    if (this.isSelectMode) {
      Log.info(TAG, 'getDataIndexByUri sta1');
      for (let i = 0; i < this.selectedItems.length; i++) {
        if (this.selectedItems[i]?.uri === uri) {
          return i;
        }
      }
      return Constants.NOT_FOUND;
    }
    Log.info(TAG, `getDataIndexByUri sta2, this.isAllMode= ${this.isAllMode}`);
    let result: number =
        this.isAllMode ? super.getDataIndexByUri(uri) + this.differenceList.length : super.getDataIndexByUri(uri);
    return result;
  }

  public async getIndexByUri(uri?: string): Promise<number> {
    Log.info(TAG, `getDataIndexByUri uri: ${uri}`)
    if (this.isSelectMode) {
      Log.info(TAG, 'getDataIndexByUri sta1');
      for (let i = 0; i < this.selectedItems.length; i++) {
        if (this.selectedItems[i]?.uri === uri) {
          return i;
        }
      }
      return Constants.NOT_FOUND;
    }

    // 1.差集里查询
    for (let i = 0; i < this.selectedItems.length; i++) {
      if (this.differenceList[i]?.uri === uri) {
        return i;
      }
    }

    // 2.滑窗内查询
    let albumDataIndex: number = super.getDataIndexByUri(uri);
    if (albumDataIndex !== Constants.NOT_FOUND) {
      Log.debug(TAG, `albumDataIndex=${albumDataIndex}, this.differenceList.length=${this.differenceList.length}`);
      return this.isAllMode ? albumDataIndex + this.differenceList.length : albumDataIndex;
    }
    return Constants.NOT_FOUND;
  }
}