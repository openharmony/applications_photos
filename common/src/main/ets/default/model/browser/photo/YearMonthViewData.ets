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

import lazy { Constants } from '../../common/Constants';
import lazy { ImageUtil } from '../../../utils/ImageUtil';
import lazy { YearMonthMediaItem } from './YearMonthMediaItem';
import lazy { YearMonthUtil } from './YearMonthUtil';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { DateUtil } from '../../../utils/DateUtil';
import lazy { UiUtil } from '../../../utils/UiUtil';
import lazy sendablePhotoAccessHelper from '@ohos.file.sendablePhotoAccessHelper';

const THUMBNAIL_MONTH_WIDTH: number = 128;

const THUMBNAIL_YEAR_WIDTH: number = 64;

const TAG: string = 'YearMonthViewData';

class YearMonthViewDataBody {
  public mediaItems: YearMonthMediaItem[];
  public dateTakenList: number[];
  public uris: string[];
  public itemCount: number;
  public dateModifiedAvg: number;
  public thumbnailSize: number;

  constructor() {
    this.mediaItems = [];
    this.dateTakenList = [];
    this.uris = [];
    this.itemCount = 0;
    this.dateModifiedAvg = 0;
    this.thumbnailSize = 0;
  }
}

/**
 * 年月数据构建参数
 */
export class YearMonthViewDataBuilder {
  private _viewData?: YearMonthViewData;

  public viewKey(viewKey: string): YearMonthViewDataBuilder {
    this.getViewData().viewKey = viewKey;
    return this;
  }

  public currentView(currentView: string): YearMonthViewDataBuilder {
    this.getViewData().currentView = currentView;
    return this;
  }

  public viewWidth(viewWidth: number): YearMonthViewDataBuilder {
    this.getViewData().viewWidth = viewWidth;
    return this;
  }

  public column(column: number): YearMonthViewDataBuilder {
    this.getViewData().column = column;
    return this;
  }

  public groupIndex(groupIndex: number): YearMonthViewDataBuilder {
    this.getViewData().groupIndex = groupIndex;
    return this;
  }

  public fillPosition(fillPosition: number): YearMonthViewDataBuilder {
    this.getViewData().fillPosition = fillPosition;
    return this;
  }

  public build(mediaItems: YearMonthMediaItem[], count: number): YearMonthViewData {
    const viewData = this.getViewData();
    viewData.updateViewData(viewData.currentView, viewData.viewWidth, mediaItems, count);
    this._viewData = undefined;
    return viewData;
  }

  private getViewData(): YearMonthViewData {
    if (!this._viewData) {
      this._viewData = new YearMonthViewData();
    }
    return this._viewData;
  }
}

@Observed
export class YearMonthViewData {
  public viewKey: string = '';
  public currentView: string = '';
  public viewWidth: number = 0;
  public column: number = 0;
  public groupIndex: number = 0;
  public fillPosition: number = 0;
  public data: YearMonthViewDataBody = new YearMonthViewDataBody();

  // 无障碍 包含的图片和视频数量
  private imageCount: number = 0;
  private videoCount: number = 0;

  /**
   * 刷新ViewData。由于刷新比较耗时（涉及上百个uri的组装），因此在刷新前，比对当前参数和新参数，有差异时才进行刷新
   *
   * @param currentView 当前视图
   * @param viewWidth 视图组件宽度
   * @param mediaItems 元数据集
   * @param itemCount 单个宫格元数据个数
   */
  public updateViewDataIfNeed(currentView: string, viewWidth: number,
    mediaItems: YearMonthMediaItem[], itemCount: number): void {
    if (this.needUpdateViewData(currentView, viewWidth, mediaItems, itemCount)) {
      this.updateViewData(currentView, viewWidth, mediaItems, itemCount);
    }
  }

  /**
   * 刷新ViewData
   *
   * @param currentView 当前视图
   * @param viewWidth 视图组件宽度
   * @param mediaItems 元数据集
   * @param itemCount 单个宫格元数据个数
   */
  public updateViewData(currentView: string, viewWidth: number,
    mediaItems: YearMonthMediaItem[], itemCount: number): void {
    if (!YearMonthUtil.isYearMonthView(currentView)) {
      return;
    }
    if (viewWidth < 0 || mediaItems === null || mediaItems === undefined || itemCount < 0) {
      return;
    }

    this.viewWidth = viewWidth;
    let data: YearMonthViewDataBody = new YearMonthViewDataBody();
    data.mediaItems = mediaItems;
    data.itemCount = itemCount;
    data.thumbnailSize = currentView === Constants.MONTH ? THUMBNAIL_MONTH_WIDTH : THUMBNAIL_YEAR_WIDTH;

    let msg: string[] = [];
    let len: number = mediaItems?.length ?? 0;
    if (len > 0) {
      data.dateModifiedAvg = this.computeAverageDateModified(mediaItems);
      let thumbnailSuffix: string = currentView === Constants.MONTH ?
        Constants.MONTH_DEFAULT_URI_SUFFIX : Constants.YEAR_DEFAULT_URI_SUFFIX;
      if (this.groupIndex === 0 && this.fillPosition > 0) {
        data.uris = new Array(this.fillPosition).fill(
          `${Constants.YEAR_MONTH_DEFAULT_URI_PREFIX}0${thumbnailSuffix}-1`);
        data.dateTakenList = new Array(this.fillPosition).fill(0);
      }
      // 图片和视频数量
      for (let index: number = 0; index < len && data.uris.length < itemCount; index++) {
        let item: YearMonthMediaItem | undefined = mediaItems[index];
        if (!item) {
          continue;
        }
        let modifiedDate: number = item.dateModified;
        let timeId: string = ImageUtil.generateTimeId(String(item.dateTaken), String(item.fileId));
        let modifyDate: number = (index === 0) ? this.data.dateModifiedAvg : modifiedDate;
        let thumbnail: string = `${Constants.YEAR_MONTH_DEFAULT_URI_PREFIX}${modifyDate}${thumbnailSuffix}${timeId}`;
        data.uris.push(thumbnail);
        data.dateTakenList.push(item.dateTaken);
        if (itemCount < Constants.YEAR_ITEM_COUNT_PER_GROUP) {
          msg.push(timeId);
        }
        // 无障碍播报 统计图片和视频数量
        switch (item.mediaType) {
          case sendablePhotoAccessHelper.PhotoType.IMAGE:
            this.imageCount++;
            break;
          case sendablePhotoAccessHelper.PhotoType.VIDEO:
            this.videoCount++;
            break;
        }
      }
      if (itemCount < Constants.YEAR_ITEM_COUNT_PER_GROUP) {
        Log.info(TAG, `updateViewData: ${msg.join(',')}`);
      }
    }
    this.data = data;
  }

  // 无障碍播报信息
  public getAccessibilityText(): Resource {
    // 日期时间
    const len = this.data.dateTakenList.length;
    if (len === 0) {
      return $r('app.string.no_distributed_photo_head_title_album');
    }
    const beginDate = DateUtil.getLocalizedDate(this.data.dateTakenList[len - 1]);
    const beginTime = DateUtil.getLocalizedTime(this.data.dateTakenList[len - 1]);
    const endDate = DateUtil.getLocalizedDate(this.data.dateTakenList[0]);
    const endTime = DateUtil.getLocalizedTime(this.data.dateTakenList[0]);
    let imageVideoCount: ResourceStr = '';
    if (this.imageCount > 0 && this.videoCount > 0) {
      imageVideoCount = $r('app.string.broadcast_multi_video_and_photo_num',
          UiUtil.getPluralStringSync($r('app.plural.broadcast_photo_num'), this.imageCount),
          UiUtil.getPluralStringSync($r('app.plural.broadcast_video_num'), this.videoCount));
    } else if (this.imageCount > 0) {
      imageVideoCount = $r('app.plural.broadcast_photo_num', this.imageCount, this.imageCount);
    } else if (this.videoCount > 0) {
      imageVideoCount = $r('app.plural.broadcast_video_num', this.videoCount, this.videoCount);
    } else {
      Log.info(TAG, `no images or videos`);
    }
    return $r('app.string.year_month_grid_message', beginDate + ' ' + beginTime, endDate + ' ' + endTime, imageVideoCount);
  }

  /**
   * 判断是否需要刷新ViewData。由于调用updateViewData进行刷新比较耗时（涉及上百个uri的组装），
   * 因此在刷新前，需要比对当前参数和新参数，有差异时才进行刷新
   *
   * @param currentView 当前视图
   * @param viewWidth 视图组件宽度
   * @param mediaItems 元数据集
   * @param itemCount 单个宫格元数据个数
   * @returns 是否需要刷新ViewData
   */
  private needUpdateViewData(currentView: string, viewWidth: number,
    mediaItems: YearMonthMediaItem[], itemCount: number): boolean {
    if (!YearMonthUtil.isYearMonthView(currentView)) {
      return false;
    }
    if (viewWidth < 0 || mediaItems === null || mediaItems === undefined || itemCount < 0) {
      return false;
    }
    if (this.currentView !== currentView) {
      return true;
    }
    if (this.viewWidth !== viewWidth) {
      return true;
    }
    if (this.data.itemCount !== itemCount) {
      return true;
    }
    if (this.data.mediaItems.length !== mediaItems.length) {
      return true;
    }

    // 通过dateModified平均值来比对mediaItems数组的差异
    let dateModifiedAvg: number = this.computeAverageDateModified(mediaItems);
    if (this.data.dateModifiedAvg === 0 || dateModifiedAvg === 0 || this.data.dateModifiedAvg !== dateModifiedAvg) {
      return true;
    }
    return false;
  }

  private computeAverageDateModified(mediaItems: YearMonthMediaItem[]): number {
    let len: number = mediaItems?.length ?? 0;
    if (len > 0) {
      let modifiedDateTotal: number = 0;
      for (let index: number = 0; index < len; index++) {
        modifiedDateTotal += mediaItems[index]?.dateModified ?? 0;
      }
      return modifiedDateTotal / len;
    }
    return 0;
  }
}