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

import lazy { DataSource, LoadingInfo, LoadingTask } from './DataSource';
import lazy { MediaDataSource } from './browser/photo/MediaDataSource';
import lazy { MediaItem } from './browser/photo/MediaItem';
import lazy { ViewData } from './browser/photo/ViewData';
import lazy { TimelineData } from './browser/photo/TimelineData';
import lazy { Log } from '../utils/Log';
import lazy { ViewType } from './browser/photo/ViewType';
import lazy { GridViewMode } from '../view/grid/GridView';
import lazy { IndexConvertor } from './IndexConvertor';

export const TITLE_DATA_INDEX: number = -1;

const TAG: string = 'common_DataSourceWrapper';


export class DataSourceWrapper extends DataSource<MediaItem> implements IDataSource, IndexConvertor {
  public viewMode: GridViewMode = GridViewMode.GRID;
  private dataSource: MediaDataSource | undefined;
  public isShowPlaceHolder: boolean = false;

  public constructor() {
    super();
    this.tag = TAG;
  }

  public layoutToData(index: number): number {
    if (!this.dataSource || this.viewMode === GridViewMode.GRID) {
      return this.isShowPlaceHolder ? index - 1 : index;
    }
    let groupData: TimelineData[] = this.dataSource.getGroupData();
    /* instrument ignore if */
    if (groupData.length === 0) {
      return index;
    }

    let currentFirstLayout: number = 0; // 当前组第一个元素的layoutIndex
    let currentFirstData: number = 0; // 当前组第一个元素的dataIndex
    /* instrument ignore next */
    for (let i: number = 0; i < groupData.length; i++) {
      let data: TimelineData = groupData[i];

      // 落到标题
      if (index === currentFirstLayout) {
        return TITLE_DATA_INDEX;
      }

      // 落到当前分组内，算得其在分组内的位置，加上前面所有分组的数据量
      if (index <= currentFirstLayout + data.count) {
        let dataIndex: number = index - currentFirstLayout - 1 + currentFirstData;
        Log.debug(TAG, `layoutToData ${index}->${dataIndex}, group: ${i}`);
        return dataIndex;
      }
      currentFirstLayout += data.count + 1;
      currentFirstData += data.count;
    }
    return index;
  }

  public dataToLayout(index: number): number {
    if (!this.dataSource || this.viewMode === GridViewMode.GRID) {
      return index;
    }
    let groupData: TimelineData[] = this.dataSource.getGroupData();
    /* instrument ignore if */
    if (groupData.length === 0) {
      return index;
    }

    let currentFirstLayout: number = 1; // 当前组第一个元素的layoutIndex
    let currentFirstData: number = 0; // 当前组第一个元素的dataIndex
    /* instrument ignore next */
    for (let i: number = 0; i < groupData.length; i++) {
      let data: TimelineData = groupData[i];

      // 落到当前分组内，算得其在分组内的位置，加上前面所有分组的数据量
      if (index < currentFirstData + data.count) {
        let layoutIndex: number = index - currentFirstData + currentFirstLayout;
        Log.debug(TAG, `dataToLayout ${index}->${layoutIndex}, group: ${i}`);
        return layoutIndex;
      }
      currentFirstLayout += data.count + 1;
      currentFirstData += data.count;
    }
    Log.info(TAG, `dataToLayout out of range: ${index}`);
    return index;
  }

  public onDataChange(index: number): void {
    super.onDataChange(this.dataToLayout(index));
  }

  public totalCount(): number {
    if (!this.dataSource) {
      return 0;
    }
    if (this.viewMode === GridViewMode.GROUP) {
      return this.dataSource.totalCount() + this.dataSource.getGroupData().length;
    }
    return this.dataSource.totalCount();
  }

  public getData(index: number): ViewData | undefined {
    if (!this.dataSource) {
      return ViewData.getEmptyInstance();
    }
    if (this.viewMode === GridViewMode.GRID) {
      let result: ViewData | undefined = this.dataSource.getData(index);
      return result;
    }

    let groupData: TimelineData[] = this.dataSource.getGroupData();
    /* instrument ignore if */
    if (groupData.length === 0) {
      Log.info(this.tag, `getData groupData is empty`);
      return ViewData.getEmptyInstance();
    }

    let currentFirstLayout: number = 0; // 当前组第一个元素的layoutIndex
    let currentFirstData: number = 0; // 当前组第一个元素的dataIndex
    /* instrument ignore next */
    for (let i: number = 0; i < groupData.length; i++) {
      let data: TimelineData = groupData[i];

      // 落到标题
      if (index === currentFirstLayout) {
        let item: MediaItem | undefined = this.dataSource.getPageData(currentFirstData);
        let title: ViewData = new ViewData();
        title.viewType = ViewType.GROUP_TITLE;
        title.viewData = data;
        title.viewIndex = i;
        title.mediaItem = item;
        Log.info(this.tag, `getData ${index} group: ${i}, date: ${data.startDate}`);
        return title;
      }

      // 落到当前分组内，算得其在分组内的位置，加上前面所有分组的数据量
      if (index <= currentFirstLayout + data.count) {
        let dataIndex: number = index - currentFirstLayout - 1 + currentFirstData;
        let result: ViewData | undefined = this.dataSource.getData(dataIndex);
        Log.info(this.tag, `getData: ${index}, data: ${dataIndex}, uri: ${result?.mediaItem?.uri}`);
        return result;
      }
      currentFirstLayout += data.count + 1;
      currentFirstData += data.count;
    }
    Log.warn(this.tag, `index out of range, dataCount: ${this.dataSource.totalCount()}, groups: ${groupData.length}`);
    return this.dataSource.getData(index);
  }

  public setDataSource(dataSource: MediaDataSource | undefined): void {
    Log.info(this.tag, `setDataSource ${dataSource}`);
    this.dataSource = dataSource;
    this.onDataReloaded();
  }

  public changeMode(newMode: GridViewMode | undefined): void {
    let mode: GridViewMode = newMode ?? GridViewMode.GRID;
    if (this.viewMode === mode) {
      return;
    }

    Log.info(this.tag, `changeMode ${this.viewMode} -> ${mode}`);
    this.viewMode = mode;
    this.onDataReloaded();
  }

  /* instrument ignore next */
  protected buildLoadingTask(info: LoadingInfo): LoadingTask<MediaItem> | undefined {
    return undefined;
  }

  public setIsShowPlaceHolder(isShow: boolean): void {
    this.isShowPlaceHolder = isShow;
  }
}