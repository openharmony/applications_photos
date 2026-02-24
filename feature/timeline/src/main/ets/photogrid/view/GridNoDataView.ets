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

import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DiggingHoleCameraArea, ScreenManager } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { TabbarShowController } from '@ohos/common/src/main/ets/default/model/common/TabbarShowController';
import lazy  {
  EmptyPageProp,
  NoPhotoIndexComponent
} from '@ohos/common/src/main/ets/default/view/NoPhotoIndexComponent';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { GridNoDataVc } from '../viewcontroller/GridNoDataVc';
import lazy { DefaultVm } from '../viewmodel/DefaultVm';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { NoPhotoComponent } from '@ohos/common/src/main/ets/default/view/NoPhotoComponent';

const TAG = 'GridNoDataView';
const EMPTY_TIMELINE: EmptyPageProp = {
  illustration: $r('app.media.photo_empty'),
  title: $r('app.string.no_photo_head_title_timeline'),
  subTitle: $r('app.string.no_photo_sub_title_timeline'),
  extraInfo: 'Photos',
  hasBarSpace: true,
};

/**
 * 无数据视图构建参数
 */
export interface GridNoDataViewBuildParams {
  /**
   * 实例ID
   */
  persistentId: number;

  /**
   * 视图控制器
   */
  controller?: GridNoDataVc;

  /**
   * 相册信息（照片页为空）
   */
  albumInfo?: AlbumInfo,
}

/**
 * 宫格无数据视图构建器
 *
 * @param $$ 构建参数
 */
@Builder
export function gridNoDataViewBuilder($$: GridNoDataViewBuildParams): void {
  GridNoDataView({
    persistentId: $$.persistentId,
    controller: $$.controller,
  })
}

/**
 * 宫格无数据视图
 */
@Component
export struct GridNoDataView {
  public persistentId: number = 0;
  @State public controller: GridNoDataVc = new GridNoDataVc();
  @State subTitle: Resource | string = $r('app.string.no_photo_sub_title_timeline');
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = ScreenManager.getInstance()
    .getDiggingHoleCameraArea();
  private viewModel: DefaultVm = new DefaultVm('GridNoDataVm');
  private preScrollPosition: number[] = [0, 0];

  aboutToAppear(): void {
    LogUtils.info(TAG, 'aboutToAppear');
    this.viewModel.init(this.persistentId);
    this.controller.init(this.viewModel);
    LogUtils.info(TAG, 'controller isShow: ' + this.controller.isShow);
  }

  aboutToDisappear(): void {
    LogUtils.info(TAG, 'aboutToDisappear');
    this.controller.release();
    this.viewModel.release();
  }

  private isScrollDown(index: number, offset: number): boolean {
    if (index > this.preScrollPosition[0]) {
      return true;
    }
    if (index == this.preScrollPosition[0]) {
      return offset < this.preScrollPosition[1];
    }
    return false;
  }

  @Builder
  buildAlbumView() {
    NoPhotoComponent({
      title: this.controller.albumInfo?.isPhotoAlbum || this.controller.albumInfo?.isScreenShotAlbum ?
      $r('app.string.no_photos_head_title_photoAlbum') :
        this.controller.albumInfo?.isVideoAlbum ? $r('app.string.no_videos_head_title_videoAlbum') :
        $r('app.string.no_photos_videos_head_title_album'), isFromEmptyAlbum: true
    })
  }

  @Builder
  buildEmptyComponent() {
    if (this.controller.albumInfo) {
      this.buildAlbumView()
    } else if (this.controller.isVerdeFoldable) {
      Grid() {
        GridItem() {
        }.width('100%').height(Constants.SUB_TITLE_HEIGHT)
        .columnStart(0).columnEnd(2)

        GridItem() {
          NoPhotoIndexComponent({
            prop: EMPTY_TIMELINE,
            subTitle: this.subTitle,
            isVerdeFoldable: this.controller.isVerdeFoldable,
            noPhotoStyler: { width: undefined, height: undefined },
          })
            .padding({
              left: DeviceInfo.isFoldable() ? 0 : this.diggingHoleCameraArea.left,
              right: DeviceInfo.isFoldable() ? 0 : this.diggingHoleCameraArea.right,
            })
        }
        .width('100%')
        .columnStart(0).columnEnd(2)

        GridItem() {
        }
        .width('100%').height(Constants.ToolBarHeight)
        .columnStart(0).columnEnd(2)
      }
      .edgeEffect(EdgeEffect.Spring)
      .columnsTemplate('1fr')
      .scrollBar(BarState.Off)
      .layoutWeight(1)
      .onScrollBarUpdate((index: number, offset: number): ComputedBarAttribute => {
        if (offset > 0 || (index === this.preScrollPosition[0] &&
          Math.abs(offset - this.preScrollPosition[1]) < Constants.VERDE_SLIDING_THRESHOLD)) {
          return { totalOffset: 0, totalLength: 0 }
        }
        TabbarShowController.getInstance().setIsShowTabbar(!this.isScrollDown(index, offset))
        this.preScrollPosition = [index, offset];
        return { totalOffset: 0, totalLength: 0 };
      });
    } else {
      NoPhotoIndexComponent({ prop: EMPTY_TIMELINE, subTitle: this.subTitle })
    }
  }

  build() {
    if (this.controller.isCanShow && this.controller.isShow) {
      this.buildEmptyComponent();
    }
  }
}