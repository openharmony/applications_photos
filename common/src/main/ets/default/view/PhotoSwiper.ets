/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import Matrix4 from '@ohos.matrix4';
import { PhotoItem } from './PhotoItem';
import { BroadCastConstants } from '../model/common/BroadCastConstants';
import { Log } from '../utils/Log';
import { BroadCast } from '../utils/BroadCast';
import Curves from '@ohos.curves';
import { Constants } from '../model/common/Constants';
import { Constants as BrowserConstants } from '../model/browser/photo/Constants';

const TAG: string = 'common_PhotoSwiper';

@Component
export struct PhotoSwiper {
  mTransition: string;
  @Consume currentIndex: number;
  @Link broadCast: BroadCast;
  @State mDuration: number = 300;
  onPhotoChanged: Function;
  swiperController: SwiperController;
  isInSelectedMode: boolean;
  @Consume canSwipe: boolean;
  swiperItemSpace: number = Constants.NUMBER_8;
  verifyPhotoScaledFunc: (matrix: Matrix4.Matrix4Transit) => void
  @Link isRunningAnimation: boolean;
  isLeftSwiper: boolean = false;
  @Consume isDeleting: boolean;
  @State isOnSwiperAnimation: boolean = false;
  private dataSource;
  private geometryTransitionEnable: boolean = false;
  private isFromFACard: boolean = false;
  private SWIPE_CACHE_COUNT: number = 2;

  aboutToAppear() {
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, (addCount) => {
      let totalCount = this.dataSource.totalCount();
      if (addCount > Constants.NUMBER_0) {
        this.dataSource.onDataReloaded();
        if (this.currentIndex + addCount < totalCount) {
          this.currentIndex += addCount;
        }
        Log.info(TAG, `ON_DATA_RELOADED: ${this.currentIndex}, ${addCount}`);
        return;
      }
      Log.debug(TAG, 'animate to data reloaded start');
      animateTo({
        duration: 300, // 删除动画时长
        curve: Curves.cubicBezier(0.0, 0.0, 0.2, 1.0), // 减速曲线参数
        onFinish: () => {
          let totalCount = this.dataSource.totalCount();
          this.dataSource.onDataChanged(this.currentIndex);
          // UPDATE NEXT TWO DATA FOR AVOID NOT LOADING DATA
          if (this.currentIndex + 1 < totalCount) {
            this.dataSource.onDataChanged(this.currentIndex + 1);
          }
          if (this.currentIndex + 2 < totalCount) {
            this.dataSource.onDataChanged(this.currentIndex + 2);
          }
          this.dataSource.onDataReloaded();
        } }, () => {
        if (this.isDeleting) {
          this.dataSource.deleteData(this.currentIndex);
        }
        if (this.currentIndex === this.dataSource.totalCount() || (this.isDeleting && this.isLeftSwiper && this.currentIndex > 0)) {
          this.currentIndex--;
        }
        this.isDeleting = false;
      })
    });

    this.broadCast.on(BroadCastConstants.CHANGE_SWIPER_DURATION, (value) => {
      Log.debug(TAG, `change duration start ${value}`);
      this.mDuration = value;
    });
  }

  aboutToDisappear(): void {
    this.swiperController = undefined;
  }

  build() {
    Swiper(this.swiperController) {
      LazyForEach(this.dataSource, (item, index?: number) => {
        if (!!item) {
          Column() {
            PhotoItem({
              item: item.data,
              mPosition: item.pos,
              thumbnail: item.thumbnail,
              transitionTag: this.mTransition ? this.mTransition : 'default_id',
              verifyPhotoScaled: this.verifyPhotoScaledFunc,
              albumUri: this.dataSource.getAlbumUri(),
              geometryTransitionEnable: this.geometryTransitionEnable,
              broadCast: $broadCast,
              isRunningAnimation: $isRunningAnimation,
              isFromFACard: this.isFromFACard,
              isInSelectedMode: this.isInSelectedMode,
              isOnSwiperAnimation: $isOnSwiperAnimation,
              dataSource: this.dataSource
            })
          }.zIndex(item.pos == this.currentIndex ? 2 : 1)
        }
      }, (item, index) => {
        if (item == null || item == undefined) {
          return JSON.stringify(item) + index;
        }
        return `${item.data.uri}_${item.data.size}_${item.data.orientation}_${index}`;
      })
    }
    .cachedCount(this.SWIPE_CACHE_COUNT)
    .duration(BrowserConstants.PHOTO_SWIPE_DURATION)
    .itemSpace(this.swiperItemSpace)
    .parallelGesture(PanGesture({
      direction: PanDirection.Horizontal
    })
      .onActionStart((event: GestureEvent) => {
        if (!this.canSwipe) {
          this.isOnSwiperAnimation = true;
        }
      })
    )
    .index(this.currentIndex)
    .indicator(false)
    .loop(false)
    .onChange((index: number) => {
      if (this.currentIndex - index == 1) {
        this.isLeftSwiper = true;
      } else if (this.currentIndex - index == -1) {
        this.isLeftSwiper = false;
      }
      if (this.mDuration != 0) {
        this.onPhotoChanged(index);

        if (!!this.verifyPhotoScaledFunc) {
          this.verifyPhotoScaledFunc(undefined)
        }
      }
    })
    .disableSwipe(this.canSwipe)
    .onAnimationStart((index: number) => {
      this.isOnSwiperAnimation = true;
    })
    .onAnimationEnd(() => {
      this.isOnSwiperAnimation = false;
    })
  }
}