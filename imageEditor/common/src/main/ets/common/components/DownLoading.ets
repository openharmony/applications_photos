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
import {
  App,
  TabName
} from '../../service/App'
import {
  APP_STORAGE_KEY_DOWNLOAD_PROGRESS,
  CANVAS_RECT,
  DOWNLOAD_STATUS,
  FIRST_FRAME_STATUS,
  SCREEN_ORIENTATION_PORTRAIT,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY
} from '../const'
import { Constants } from '../util/Constants'
import {
  EditorParams,
  RectValue
} from '../../service/EditorSDK'
import { HiLog } from '../util/HiLog'
import { CropAttr } from '../../service/BaseEditor'
import { ScreenManager } from '../util/ScreenManager'
import { EditorPixelMapManager } from '../EditorPixelMapManager'
import { image } from '@kit.ImageKit'
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager'
import { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo'
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast'
import { Trace } from '../util/Trace'

const TAG = 'EditorPage';

let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

@Component
export struct DownLoading {
  @State params: EditorParams | undefined = undefined // 工程初始化参数
  @State lcdPixelMap: image.PixelMap | undefined = undefined;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('getLoadingPosition') isPortrait: boolean =
    ScreenManager.getInstance()
      .isScreenPortrait();
  @StorageProp(DOWNLOAD_STATUS) isDownloadStatue: boolean = ScreenManager.getInstance().getDownLoadFail();
  @StorageProp(FIRST_FRAME_STATUS) isFirstFrameStatue: boolean = ScreenManager.getInstance().getIsFirstFrame();
  @StorageProp(CANVAS_RECT) canvasRect: RectValue = ScreenManager.getInstance().getCanvasRect();
  @StorageProp(WIN_WIDTH_KEY) @Watch('getLoadingPosition') winWidth: number = ScreenManager.getInstance().width;
  @StorageProp(WIN_HEIGHT_KEY) @Watch('getLoadingPosition') winHeight: number = ScreenManager.getInstance().height;
  @StorageLink(APP_STORAGE_KEY_DOWNLOAD_PROGRESS) @Watch('refreshDownloadStatus') downloadProgress: number = 0;
  @State crop: CropAttr = App.getInstance().myEditor().asset.crops();
  @Prop previewRect: RectValue = new RectValue(0, 0, 0, 0);
  @Prop @Watch('getLoadingPosition') tab: TabName; //监听tabindex
  @State isShowDownLoad: boolean = false;
  @State isSpecialSize: boolean = false;
  @State realProgress: number = 0;
  @State isFirstFrameLoaded: boolean = false;
  private loadingSize: number = 32;
  private progressShadowSize: number = 48;

  aboutToDisappear(): void {
    HiLog.i(TAG, 'DownLoading aboutToDisappear');
    this.downloadProgress = 0;
    this.realProgress = 0;
    this.lcdPixelMap?.release();
    if (!DeviceInfo.isPc()) {
      appBroadCast.off('CustomFilterStackCardViewInitiated');
    }
  }

  refreshDownloadStatus() {
    /* instrument ignore if */
    if (this.realProgress <= this.downloadProgress) {
      this.realProgress = this.downloadProgress;
    }
  }

  public async aboutToAppear(): Promise<void> {
    HiLog.i(TAG, 'DownLoading aboutToAppear');
    Trace.begin('getThumbnailByAsset');
    this.lcdPixelMap = await EditorPixelMapManager.getThumbnailByAsset(this.params?.asset);
    Trace.end('getThumbnailByAsset');
    App.getInstance().myEditor().releaseDownLoadingLcd = () => {
      HiLog.i(TAG, 'DownLoading release lcd');
      this.lcdPixelMap?.release();
      this.lcdPixelMap = undefined;
    }
    this.getLoadingPosition();
    if (DeviceInfo.isPc()) {
      setTimeout((): void => {
        this.isShowDownLoad = true;
      }, 100)
    } else {
      setTimeout((): void => {
        this.isShowDownLoad = true;
      }, 100)
    }
  }

  getLoadingPosition() {
    let width = this.params?.rectInfo?.width as number;
    let height = this.params?.rectInfo?.height as number;
    let ratio = width / height;
    this.previewRect = ScreenManager.getInstance()
      .getPreviewRect(ratio, ScreenManager.getInstance().isScreenPortrait());
    HiLog.i('LoadingProgress', 'previewRect is ' + JSON.stringify(this.previewRect) + ', ratio ' + ratio);
    this.isSpecialSize = px2vp(this.previewRect.width) > this.progressShadowSize && px2vp(this.previewRect.height) >
    this.progressShadowSize;
  }

  /* instrument ignore next */
  build() {
    if (this.params?.position === Constants.FILE_LOCATION_CLOUD && this.isFirstFrameStatue === false &&
    this.isShowDownLoad && this.isSpecialSize) {
      Column() {
        Stack() {
          if (DeviceInfo.isPc()) {
            Image(this.lcdPixelMap)
              .width(px2vp(Number(this.params?.rectInfo?.width)))
              .height(px2vp(Number(this.params?.rectInfo?.height)))
              .opacity(this.isFirstFrameStatue ? 1 : 0.8)
              .onComplete((result: ImageLoadResult) => {
                if (result.loadingStatus) {
                  HiLog.i(TAG, `loadingComplete,imageHeight: ${result.contentHeight} ,imageWidth:${result.contentWidth}`)
                  this.isFirstFrameLoaded = true;
                }
              })
            Progress({ value: this.realProgress, total: 100, type: ProgressType.Ring })
              .color($r('sys.color.white'))
              .backgroundColor('rgba(255, 255, 255, 0.2)')
              .width(this.loadingSize)
              .height(this.loadingSize)
              .style({ strokeWidth: 4, enableScanEffect: true })
              .shadow({
                radius: 100,
                color: 'rgba(0,0,0,0.2)',
                fill: true,
                type: ShadowType.BLUR,
              })
              .foregroundColor(ColoringStrategy.INVERT)
              .visibility(this.isDownloadStatue === false && this.isFirstFrameLoaded
                ? Visibility.Visible : Visibility.Hidden)

            Image($r('app.media.shadow'))
              .width(this.progressShadowSize)
              .height(this.progressShadowSize)
              .visibility(this.isDownloadStatue === false && this.isFirstFrameLoaded
                ? Visibility.Visible : Visibility.Hidden)
          } else {
            Image(this.lcdPixelMap)
              .width(px2vp(Number(this.previewRect?.width)))
              .height(px2vp(Number(this.previewRect?.height)))
              .opacity(this.isFirstFrameStatue ? 1 : 0.8)
              .onComplete((result: ImageLoadResult) => {
                if (result.loadingStatus) {
                  HiLog.i(TAG, `loadingComplete,imageHeight: ${result.contentHeight} ,imageWidth:${result.contentWidth}`)
                  this.isFirstFrameLoaded = true;
                }
              })
            Progress({ value: this.realProgress, total: 100, type: ProgressType.Ring })
              .color($r('sys.color.white'))
              .backgroundColor('rgba(225, 225 , 225, 0.2)')
              .width(this.loadingSize)
              .height(this.loadingSize)
              .style({ strokeWidth: 4, enableScanEffect: true })
              .shadow({
                radius: 100,
                color: 'rgba(0,0,0,0.2)',
                fill: true,
                type: ShadowType.BLUR,
              })
              .foregroundColor(ColoringStrategy.INVERT)
              .visibility(this.isDownloadStatue === false && this.isFirstFrameLoaded
                ? Visibility.Visible : Visibility.Hidden)

            Image($r('app.media.shadow'))
              .width(this.progressShadowSize)
              .height(this.progressShadowSize)
              .visibility(this.isDownloadStatue === false && this.isFirstFrameLoaded
                ? Visibility.Visible : Visibility.Hidden)
          }

          Image($r('sys.media.ohos_ic_public_fail'))
            .fillColor($r('sys.color.white'))
            .width(this.loadingSize)
            .height(this.loadingSize)
            .visibility(this.isDownloadStatue === true ? Visibility.Visible : Visibility.Hidden)
        }
      }
      .key('ProgressOfLoadingPanel')
      .position({
        x: px2vp(this.previewRect?.x), y: px2vp(this.previewRect?.y),
      })
    }
  }
}
