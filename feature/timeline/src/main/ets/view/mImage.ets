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
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { YearMonthViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthViewData';
import lazy { MViewType } from '../model/Constants';
import lazy { completed } from '@ohos/tools/src/main/interface/ArkUI';
import lazy { ActionBarVar } from '@ohos/tools/src/main/variables/ActionBarVar';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { YearMonthMediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/YearMonthMediaItem';
import lazy { FoldUtil, FoldData } from '@ohos/common/src/main/ets/default/utils/FoldUtil';

const TAG = 'mImage';

// General grid picture control
@Component
export struct mImage {
  @State mediaItems: YearMonthMediaItem[] = [];
  // 行数
  private rows: number = 10;
  // 列数
  @Link cols: number;
  @Link cachedImageWidth: number;
  @State dateTakenList: number[] = [];
  @State uris: string[] = [];
  @State itemCount: number = 1;
  @ObjectLink @Watch('onViewDataChanged') viewData: YearMonthViewData;
  private index: number = 0;
  @State imageHeight: number = 0;
  private viewType: MViewType = 0; // 1.7号之后的版本放开，切需要更改SDK中CachedImage内容
  private viewKey: string = '';
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private onViewDataChangedFunc: Function = (): void => this.onViewDataChanged();
  private foldDataChangeListener: (foldData: FoldData) => void = this.onFoldDataChange.bind(this);
  private curFoldStatus: number = FoldUtil.getInstance().getCurFoldStatus();
  private startTime: number = 0;

  private onFoldDataChange(foldData: FoldData) {
    this.curFoldStatus = foldData.curFoldStatus;
  }

  // 计算imageSize
  private calcImageSize(): void {
    this.rows = Math.ceil(this.itemCount / this.cols);
    let sideBarWidth: number = ActionBarVar.isShowSideBar ? ActionBarVar.sideBarWidth : 0;
    /* instrument ignore next */
    if (DeviceInfo.isGRLFoldScreen()) {
      let isTriExpand = FoldUtil.isTriExpand(this.curFoldStatus);
      sideBarWidth = ActionBarVar.isShowSideBar && isTriExpand ? ActionBarVar.sideBarWidth : 0;
    }
    this.imageHeight = (this.cachedImageWidth - sideBarWidth) / this.cols * this.rows;
    Log.debug(TAG, `calcImageSize, itemCount:${this.itemCount}, rows:${this.rows}, cols:${this.cols}` +
      `, sideBarWidth:${sideBarWidth}, cachedImageWidth:${this.cachedImageWidth}, imageHeight:${this.imageHeight}`);
  }

  private onViewDataChanged(): void {
    this.uris = this.viewData.data.uris;
    this.dateTakenList = this.viewData.data.dateTakenList;
    this.mediaItems = this.viewData.data.mediaItems;
    this.itemCount = this.viewData.data.itemCount;
    this.calcImageSize();
    Log.debug(TAG, `onViewDataChanged for ${this.viewData.viewKey}, uris.length = ${this.uris.length},` +
      `first :${this.uris[0]}, last: ${this.uris[this.uris.length - 1]}`);
  }

  // mImage年月组件创建标识
  aboutToAppear() {
    /* instrument ignore next */
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().subscribe(this.foldDataChangeListener);
    };
    this.startTime = Date.now();
    this.calcImageSize();
    Log.info(TAG, `CachedImage aboutToAppear index ${this.index} key ${this.viewKey} uris len ${this.uris.length}, ` +
      `first :${this.uris[0]}, last: ${this.uris[this.uris.length - 1]}` + `,startTime ${Date.now()}`);
    for (let i = 0; i < this.uris.length; i++) {
      let uri: string = this.uris[i];
      // 一个item中存在空uri时打印item的index
      if (!uri) {
        Log.info(TAG, `CachedImage aboutToAppear:${this.index}`);
      }
    }

    this.appBroadCast.on(BroadCastConstants.ON_SIDEBAR_CHANGED, this.onViewDataChangedFunc);
    this.appBroadCast.on(BroadCastConstants.ON_SIDEBAR_WIDTH_CHANGED, this.onViewDataChangedFunc);
  }

  // mImage年月组件销毁
  aboutToDisappear() {
    Log.i(TAG,
      `CachedImage aboutToDisappear index ${this.index} key ${this.viewKey} uris len ${this.uris.length}`);
    if (DeviceInfo.isGRLFoldScreen()) {
      FoldUtil.getInstance().unSubscribe(this.foldDataChangeListener);
    }
    this.appBroadCast.off(BroadCastConstants.ON_SIDEBAR_CHANGED, this.onViewDataChangedFunc);
    this.appBroadCast.off(BroadCastConstants.ON_SIDEBAR_WIDTH_CHANGED, this.onViewDataChangedFunc);
  }

  private isUriNull(): void {
    for (let i = 0; i < this.uris.length; i++) {
      let uri: string = this.uris[i];
      // 一个item中存在空uri时打印item的index
      if (!uri) {
        Log.info(TAG, `CachedImage isUriNull:${this.index}`);
      }
    }
  }

  build() {
    Stack() {
      MediaCachedImage({
        sources: this.uris,
        column: this.cols,
      })
        .height(this.imageHeight)
        .width('100%')
        .sourceSize({
          width: px2vp(this.viewType === MViewType.MONTH ? 128 : 64),
          height: px2vp(this.viewType === MViewType.MONTH ? 128 : 64),
        })
        .onAppear(() => {
          Log.info(TAG, `CachedImage onAppear:${this.index} key ${this.viewKey}, uriList len:${this.uris.length}`);
        })
        .draggable(false)
        .interpolation(ImageInterpolation.Low)
        .onComplete((event?: completed): void => {
          Log.info(TAG, `CachedImage onComplete ${this.index} key ${this.viewKey}, uriList len:${this.uris.length}` +
            `, first :${this.uris[0]}, last: ${this.uris[this.uris.length - 1]}` +
            `, ${event?.loadingStatus}, width:${event?.componentWidth}, height:${event?.componentHeight}` +
            `, cost: ${Date.now() - this.startTime}`);
          this.isUriNull();
          if (event?.loadingStatus === 0) {
            TraceControllerUtils.startTrace(`image_onComplete_${this.index}`)
          } else {
            TraceControllerUtils.finishTrace(`image_onComplete_${this.index}`)
          }
        })
        .onError((error?: ImageError) => {
          Log.e(TAG,
            `CachedImage error index: ${this.index}, key: ${this.viewKey}, error: ${error?.message}, cost: ${Date.now() -
            this.startTime}`);
        })
    }
  }
}