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

/* instrument ignore file */

import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DataListener, LoadingResult } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { FormStateTypeUtils, GridFormFsm } from '../statemanager/GridFormFsm';
import lazy { GridStateProxy } from '../statemanager/GridStateProxy';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import { PhotosHmBrowserController } from '@ohos/browserlibrary';

const TAG: string = 'BrowserJumper';
const FQDN_PREFIX: string = 'com.ohos.photos.movie_';

export class BrowserJumper {
  private instanceId: number = 0;
  private dataSource: MediaDataSource | undefined;
  private browserController: PhotosHmBrowserController | undefined;
  private targetItem: MediaItem | undefined;
  private readonly dataListener: DataListener<MediaItem> = {
    onLoadingFinished: (result: LoadingResult<MediaItem>) => this.onDataLoadingFinished(result),
  } as DataListener<MediaItem>;

  public init(instanceId: number, dataSource: MediaDataSource | undefined,
    browserController: PhotosHmBrowserController | undefined): void {
    this.instanceId = instanceId;
    this.dataSource = dataSource;
    this.browserController = browserController;
    this.dataSource?.addListener(this.dataListener);
  }

  public release(): void {
    this.dataSource?.removeListener(this.dataListener);
  }

  public setTargetItem(item: MediaItem | undefined): void {
    this.targetItem = item;
  }

  private onDataLoadingFinished(result: LoadingResult<MediaItem>): void {
    let oldVersion: number = result.oldPageData.version;
    let newVersion: number = result.newPageData.version;
    if (newVersion <= oldVersion || this.targetItem === undefined || this.dataSource === undefined) {
      return;
    }
    // 如果当前数据集里就能找到，不需要调用查询，否则调用查询接口查找index
    let index: number = this.dataSource.getDataIndex(this.targetItem);
    if (index > 0) {
      this.showBrowser(index, this.targetItem);
      this.targetItem = undefined;
      return;
    }

    // 调用查询接口查询index，但是查完targetItem可能发生变化，需要存下来，查询完对比
    let itemNow: MediaItem | undefined = this.targetItem;
    this.dataSource?.getItemIndexByUri(this.targetItem.uri, (index: number) => {
      Log.info(TAG, `onJumpPhotoBrowser, currentIndex: index: ${index}`);
      let rawData = this.dataSource?.getRawData(index);
      if (this.targetItem === undefined || this.targetItem !== itemNow || index < 0 ||
        rawData?.uri != this.targetItem.uri) {
        return;
      }
      if (!this.targetItem.hashCode && rawData) {
        this.targetItem = rawData;
      }
      this.showBrowser(index, this.targetItem);
      this.targetItem = undefined;
    });
  }

  private showBrowser(index: number, item: MediaItem): void {
    let formFsm: GridFormFsm = GridStateProxy.getInstance(this.instanceId).formFsm;
    if (!FormStateTypeUtils.isInDayState(formFsm.currentState) &&
      !FormStateTypeUtils.isInGroupDayState(formFsm.currentState)) {
      return;
    }

    let scene: string =
      FormStateTypeUtils.isInGroupDayState(formFsm.currentState) ? Constants.PHOTO_TRANSITION_TIMELINE_GROUP :
      Constants.PHOTO_TRANSITION_TIMELINE;

    interface Msg {
      position: number;
      transition: string;
      leftBlank: number[];
      item: MediaItem;
    }

    const params: Msg = {
      position: index,
      transition: scene,
      leftBlank: getScreen().getLeftBlank(),
      item: item,
    };
    AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.dataSource);
    this.browserController?.showBrowser(index, scene + item.hashCode, scene, params, {
      caller: scene,
      targetIndex: index,
      geometryTransitionString: scene + item.hashCode,
      leftBlank: getScreen().getLeftBlank()
    })
  }
}