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

import { image } from '@kit.ImageKit';
import { HiLog } from '../../../common/util/HiLog';
import { mosaicResource, SCALE_RATIO } from './const';
import { taskpool } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'MosaicController';

interface ImagePromise {
  code: number,
  data: PixelMap | null,
}

const SUCCESS = 1;

export class MosaicController {
  private static instance?: MosaicController;
  private resources: Array<ImagePromise> = [];
  private resourcesPromise?: Promise<Array<ImagePromise>>;
  private context: Context = getContext(this);
  private mosaicImg?: PixelMap;

  constructor() {
  }

  async initPatterns() {
    this.resourcesPromise = Promise.all(mosaicResource.map(async (item: Resource) => {
      let ret: ImagePromise = { data: null, code: 0 };
      try {
        const buffer = (await this.context.resourceManager.getMediaContent(item)).buffer.slice(0);
        const imageSource = image.createImageSource(buffer);
        ret.data = await imageSource.createPixelMap();
        ret.code = SUCCESS;
        imageSource?.release();
      } catch (error) {
        HiLog.e(TAG, `init pattern failed: ${error.code}  ${error.message}`);
      }
      return ret;
    })) as Promise<Array<ImagePromise>>;
    this.resources = (await this.resourcesPromise || []);
  }

  public static getInstance(): MosaicController {
    if (!MosaicController.instance) {
      MosaicController.instance = new MosaicController();
    }
    return MosaicController.instance;
  }

  public getPathBg(index: number): ImagePromise {
    if (index < 2) {
      HiLog.e(TAG, `getPattern param index:${index} is error`);
      index = 2;
    }
    const res = this.resources[index - 2];
    return res;
  }

  public setMosaicImg(img: PixelMap, width: number, height: number) {
    this.applyMosaicEffectPx(img, width, height);
  }

  public getMosaicImg(): PixelMap | undefined {
    return this.mosaicImg;
  }


  public async applyMosaicEffectPx(pixelMap: PixelMap, width: number, height: number) {
    const start = Date.now();
    const ratio = SCALE_RATIO;
    width /= ratio;
    height /= ratio;
    const settings: RenderingContextSettings = new RenderingContextSettings(false);
    const offContext: OffscreenCanvasRenderingContext2D =
      new OffscreenCanvasRenderingContext2D(width, height, settings);
    HiLog.i(TAG, `applyMosaicEffectPx width: ${width} height: ${height}`);
    offContext.drawImage(pixelMap, 0, 0, width, height);
    const data = offContext.getImageData(0, 0, width, height);
    HiLog.i(TAG,
      'before trans to mosaic,' + ' it cost: ' + (Date.now() - start) + ' colorData len: ' + data.data.length);

    const colorData = applyMosaicEffect(data, 2);
    await taskpool.execute(generatePixelMap, colorData.data.buffer, data.width, data.height, ratio)
      .then((pm: object) => {
        this.mosaicImg = pm as PixelMap;
        HiLog.i(TAG, 'Succeeded in creating mosaic pixelmap.' + 'it cost: ' + (Date.now() - start));
      }).catch(() => {
        HiLog.i(TAG, 'Failed to create mosaic pixelmap.');
      });
  }

  clear() {
    this.mosaicImg?.release();
    this.resourcesPromise?.then(arr => {
      arr.forEach(i => {
        i.data?.release();
      });
    });
  }
}

function applyMosaicEffect(imageData: ImageData, blockSize = 20) {
  const width = imageData.width;
  const height = imageData.height;
  const data = imageData.data;
  const newData = new Uint8ClampedArray(data.length);

  // 确保块大小合理
  blockSize = Math.max(2, Math.min(blockSize, Math.min(width, height) / 2));

  // 遍历图像，按块处理
  for (let y = 0; y < height; y += blockSize) {
    for (let x = 0; x < width; x += blockSize) {
      // 计算当前块的边界
      blockProcess(blockSize, imageData, x, y, newData);
    }
  }

  return new ImageData(width, height, newData);
}

function blockProcess(blockSize: number, imageData: ImageData, x: number, y: number, newData: Uint8ClampedArray) {

  const width = imageData.width;
  const height = imageData.height;
  const data = imageData.data;

  // 计算当前块的边界
  const blockWidth = Math.min(blockSize, width - x);
  const blockHeight = Math.min(blockSize, height - y);

  // 计算块内所有像素的平均颜色
  let totalR = 0;
  let totalG = 0;
  let totalB = 0;
  let totalA = 0;
  let pixelCount = 0;

  for (let by = 0; by < blockHeight; by++) {
    for (let bx = 0; bx < blockWidth; bx++) {
      const px = x + bx;
      const py = y + by;
      const index = (py * width + px) * 4;

      totalR += data[index];
      totalG += data[index + 1];
      totalB += data[index + 2];
      totalA += data[index + 3];
      pixelCount++;
    }
  }

  const avgR = Math.round(totalR / pixelCount);
  const avgG = Math.round(totalG / pixelCount);
  const avgB = Math.round(totalB / pixelCount);
  const avgA = Math.round(totalA / pixelCount);

  // 将整个块设置为平均颜色
  for (let by = 0; by < blockHeight; by++) {
    for (let bx = 0; bx < blockWidth; bx++) {
      const px = x + bx;
      const py = y + by;
      const index = (py * width + px) * 4;

      newData[index] = avgR;
      newData[index + 1] = avgG;
      newData[index + 2] = avgB;
      newData[index + 3] = avgA;
    }
  }
}

/* instrument ignore next */
@Concurrent
function generatePixelMap(buffer: ArrayBuffer, width: number, height: number, ratio: number) {
  const color: ArrayBuffer = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions =
    {
      editable: true,
      pixelFormat: image.PixelMapFormat.RGBA_8888,
      size: { height, width },
    };
  const pm = image.createPixelMapSync(color, opts);
  pm.writeBufferToPixelsSync(buffer);
  return pm;
}
