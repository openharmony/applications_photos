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
import lazy videoProcessingEngine from '@ohos.multimedia.videoProcessingEngine';
import lazy image from '@ohos.multimedia.image';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { Thumbnail } from '@ohos/common/src/main/ets/default/model/browser/photo/Thumbnail';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy Matrix4 from '@ohos.matrix4';
import lazy { Matrix4x4 } from '@ohos/common/src/main/ets/default/utils/Matrix4x4';
import lazy { systemParameterEnhance } from '@kit.BasicServicesKit';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy Global from '@ohos/common/src/main/ets/default/utils/GlobalContext';
/* instrument ignore file  */
/* instrument ignore file */
const TAG: string = 'ImageAdapterHelper';
interface photoItemCacheType {
  mIsCurrent?: boolean,
  matrix?: Matrix4.Matrix4Transit,
  firstLookWidth?: number,
  firstLookHeight?: number,
  firstLookRatio?: number,
  width?: number,
  height?: number,
  mPosition?: number,
  isGestureMove?: boolean,
  duration?: number,
  maxScale?: number,
  pixelmap?: image.PixelMap,
  isRunningAnimation?: boolean,
  reset?: boolean,
  angle?: number
}

export class ImageAdapterHelper {
  public enable: boolean = false;
  public enablePixelmapReadapt: boolean = false;
  public static instance: ImageAdapterHelper | undefined = undefined;
  private contrastEnhancer: videoProcessingEngine.ImageProcessor | undefined = undefined;

  constructor() {
    if (ImageAdapterHelper.instance instanceof ImageAdapterHelper) {
      return ImageAdapterHelper.instance;
    }
    ImageAdapterHelper.instance = this;
    this.setPixelmapReAdaptEnable();
    if (!this.enable) {
      return;
    }
  }

  public setPixelmapReAdaptEnable(): void {
    try {
      systemParameterEnhance.get('const.photos.enable_pixelmap_readapt', 'false').then((value: string): void => {
        Log.info(TAG, `setPixelmapReAdaptEnable const.photos.enable_pixelmap_readapt = ${value}`);
        AppStorage.setOrCreate('pixelmapReAdapt', value === 'true');
        let pixelmapReAdapt: boolean = AppStorage.get('pixelmapReAdapt') ?? false;
        Log.info(TAG, `setPixelmapReAdaptEnable ${pixelmapReAdapt} , ${AppStorage.get('pixelmapReAdapt')}`);
        this.enable = pixelmapReAdapt;
        this.enablePixelmapReadapt = pixelmapReAdapt;
      });
    } catch (error) {
      Log.error(TAG, `setPixelmapReAdaptEnable system.photos.yuvDecode.enable fail: ${error}`);
    }
  }

  public setProgDispEnable(): void {
    let dispSwitch = AppStorage.get<boolean>('prog_disp_switch') ?? false;
    this.enable = dispSwitch && this.enablePixelmapReadapt;
    Log.info(TAG, `setProgDispEnable, ${this.enable} ,${this.enablePixelmapReadapt} , ${dispSwitch}`);
  }

  public getContrastEnhancer(): videoProcessingEngine.ImageProcessor {
    if (this.contrastEnhancer === undefined) {
      this.contrastEnhancer =
        videoProcessingEngine.create() as videoProcessingEngine.ImageProcessor;
    }
    return this.contrastEnhancer;
  }

  canPixelmapReadapt(photoItemCacheType: photoItemCacheType) {
    if (!this.enable) {
      return true;
    }
    if (!photoItemCacheType.mIsCurrent) {
      return true;
    }
    if (!photoItemCacheType.matrix) {
      return true;
    }
    if (photoItemCacheType.angle === undefined) {
      return true;
    }
    if (photoItemCacheType.angle % 90 !== 0) {
      return true;
    }
    return false;
  }

  public onPixelmapReAdapt(photoItemCacheType: photoItemCacheType): void {
    if (this.canPixelmapReadapt(photoItemCacheType)) {
      Log.info(TAG, `onPixelmapReAdapt not enable ${this.enable} ${photoItemCacheType.mIsCurrent}
      ${photoItemCacheType.matrix} ${photoItemCacheType?.angle}`);
      return;
    }

    // 调用对比度算法
    let mat: number[] | undefined = (photoItemCacheType.matrix?.copy() as Matrix4x4).matrix4x4;
    if (mat && photoItemCacheType.reset) {
      mat[0] = 1;
    }
    let detailImageParams: number[] | undefined = this.calculateImagePosAndScale(photoItemCacheType);
    if (!detailImageParams || !mat || !photoItemCacheType.maxScale || !photoItemCacheType.pixelmap) {
      Log.info(TAG, `onPixelmapReAdapt info not enough ${detailImageParams} ${mat}
      ${photoItemCacheType.maxScale} ${photoItemCacheType.pixelmap}`);
      return;
    }

    let pixelmapArea: image.Region = {
      size: { width: photoItemCacheType.width ?? 1, height: photoItemCacheType.height ?? 1 },
      x: 0, y: 0,
    };

    let displayArea: image.Region = {
      size: { width: detailImageParams[2], height: detailImageParams[3] },
      x: detailImageParams[0], y: detailImageParams[1],
    };

    let contrastEnhancer = this.getContrastEnhancer();
    Log.info(TAG, `onPixelmapReAdapt isGestureMove ${photoItemCacheType.isGestureMove} ${photoItemCacheType.maxScale *
      (photoItemCacheType?.firstLookRatio ?? 1)} ${photoItemCacheType?.duration ?? 0} ${(mat[0] ?? 1) *
      (photoItemCacheType?.firstLookRatio ?? 1)}`);

    Log.info(TAG, `onPixelmapReAdapt contrastEnhancer.setDetailImage pixelmapArea:${JSON.stringify(pixelmapArea)
    } displayArea:${JSON.stringify(displayArea)} position: ${photoItemCacheType.mPosition}`);

  }

  public onLCDReAdapt(photoItemCacheType: photoItemCacheType): void {
    this.setProgDispEnable();
    if (!this.enable || !photoItemCacheType.mIsCurrent || !photoItemCacheType.pixelmap) {
      Log.info(TAG, `onLCDReAdapt not enable ${this.enable} ${photoItemCacheType.mIsCurrent}
      ${photoItemCacheType.pixelmap}`);
      return;
    }
    Log.info(TAG, `onLCDReAdapt: start`);
    let contrastEnhancer = this.getContrastEnhancer();
  }


  /**
   * 打点参数
   * @params sizeInfo[0]: 原始图片宽
   * @params sizeInfo[1]: 原始图片高
   * @params sizeInfo[2]: 屏幕高
   * @params sizeInfo[3]: 屏幕宽
   */
  public calculateRatio(imageWidth: number, imageHeight: number, angle: number,
    imageComponentWidth?: number, imageComponentHeight?: number): number {
    let lastFirstLookRatio: number = 1;
    if (imageWidth === 0 || imageHeight === 0) {
      Log.info(TAG, `can not read sizeInfo sizeInfo: ${imageWidth} ${imageHeight}`);
      return lastFirstLookRatio;
    }
    let photoitemView = getScreen().getPhotoitemView(imageComponentWidth, imageComponentHeight);
    let screenWidth = photoitemView[0];
    let screenHeight = photoitemView[1];
    Log.info(TAG, `calculateRatio screenWidth: ${screenWidth} screenHeight: ${screenHeight} angle: ${angle}`)
    if (angle % 180 !== 0) {
      screenWidth = photoitemView[1];
      screenHeight = photoitemView[0];
    }
    lastFirstLookRatio = Math.min(screenWidth / imageWidth, screenHeight / imageHeight);
    return lastFirstLookRatio;
  }

  /**
   * 打点参数
   * @params posAndScale[0]: 图片显示范围x轴起点
   * @params posAndScale[1]: 图片显示范围y轴起点
   * @params posAndScale[2]: 图片x轴显示范围
   * @params posAndScale[3]: 图片y轴显示范围
   */
  public calculateImagePosAndScale(photoItemCacheType: photoItemCacheType): number[] {
    let posAndScale: number[] = [0, 0, 0, 0];
    let imageWidth: number = photoItemCacheType.firstLookWidth ?? 1;
    let imageHeight: number = photoItemCacheType.firstLookHeight ?? 1;
    let firstLookRatio: number = photoItemCacheType.firstLookRatio ?? 1;
    let oriWidth: number = photoItemCacheType.width ?? 1;
    let oriHeight: number = photoItemCacheType.height ?? 1;
    let angle: number = photoItemCacheType.angle ?? 0;
    let matrix4x4: number[] | undefined = (photoItemCacheType.matrix?.copy() as Matrix4x4)?.matrix4x4;
    if (!matrix4x4 || imageWidth === 0 || imageHeight === 0 || firstLookRatio === 0 ||
      oriWidth === 0 || oriHeight === 0) {
      Log.info(TAG, `calculateImagePosAndScale error matrix4x4 is ${matrix4x4}, imageWidth = ${imageWidth
      } imageHeight = ${imageHeight} firstLookRatio = ${firstLookRatio} oriWidth = ${oriWidth
      } oriHeight = ${oriHeight}`);
      return posAndScale;
    }
    if (photoItemCacheType.reset) {
      matrix4x4[0] = 1;
      matrix4x4[12] = 0;
      matrix4x4[13] = 0;
    }
    let photoitemView = getScreen().getPhotoitemView();
    let screenWidth = photoitemView[0];
    let screenHeight = photoitemView[1];
    let scale = matrix4x4[0] ?? 1;
    let offsetX = matrix4x4[12] ?? 0;
    let offsetY = matrix4x4[13] ?? 0;
    if (angle % 180 !== 0) {
      let swapWH: number = imageWidth;
      imageWidth = imageHeight;
      imageHeight = swapWH;
    }
    posAndScale[0] = Math.max(0, Math.floor(((imageWidth * scale - screenWidth) / 2 - offsetX) / scale)) /
      firstLookRatio;
    posAndScale[1] = Math.max(0, Math.floor(((imageHeight * scale - screenHeight) / 2 - offsetY) / scale)) /
      firstLookRatio;
    posAndScale[2] = Math.min(screenWidth / scale, imageWidth) / firstLookRatio;
    posAndScale[3] = Math.min(screenHeight / scale, imageHeight) / firstLookRatio;

    let displayX: number = posAndScale[0];
    let displayY: number = posAndScale[1];
    switch (angle) {
      case 90:
        posAndScale[0] = displayY;
        posAndScale[1] = oriHeight - displayX - posAndScale[2];
        break;
      case 270:
        posAndScale[0] = oriWidth - displayY - posAndScale[3];
        posAndScale[1] = displayX;
        break;
      case 180:
        posAndScale[0] = oriWidth - displayX - posAndScale[2];
        posAndScale[1] = oriHeight - displayY - posAndScale[3];
        break;
    }

    if (angle % 180 !== 0) {
      let swapWH: number = posAndScale[2];
      posAndScale[2] = posAndScale[3];
      posAndScale[3] = swapWH;
    }

    Log.info(TAG, `calculateImagePosAndScale imageWidth = ${imageWidth} imageHeight = ${imageHeight
    } screenWidth = ${screenWidth} screenHeight = ${screenHeight} scale = ${scale} offsetX = ${offsetX
    } offsetY = ${offsetY} firstLookRatio ${firstLookRatio} oriWidth = ${oriWidth} oriHeight = ${oriHeight
    } angle: ${angle} displayX: ${displayX} displayY: ${displayY}`);
    Log.info(TAG, `posAndScale ${posAndScale.toString()}`);
    return posAndScale;
  }
}

export default new ImageAdapterHelper();

