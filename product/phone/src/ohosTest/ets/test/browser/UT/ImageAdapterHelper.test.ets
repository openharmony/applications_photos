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
import { afterEach, ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { ImageAdapterHelper } from '@ohos/browsercommon/src/main/ets/default/utils/ImageAdapterHelper';
import videoProcessingEngine from '@ohos.multimedia.videoProcessingEngine';
import Matrix4 from '@ohos.matrix4';

let imageAdapterHelper: ImageAdapterHelper | undefined = undefined;

export default function ImageAdapterHelperTest() {
  describe('ImageAdapterHelperTest', () => {

    beforeEach(() => {
      imageAdapterHelper = new ImageAdapterHelper();
    });

    afterEach(() => {
      if (!imageAdapterHelper) {
        return;
      }
      (imageAdapterHelper as ESObject).instance = undefined
      imageAdapterHelper = undefined;
    });

    it('getContrastEnhancer', 0, () => {
      getContrastEnhancer();
    });
    it('onPixelmapReAdapt', 0, () => {
      onPixelmapReAdapt();
    });
    it('onLCDReAdapt', 0, () => {
      onLCDReAdapt();
    });
    it('calculateRatio', 0, () => {
      calculateRatio();
    });
    it('calculateImagePosAndScale', 0, () => {
      calculateImagePosAndScale();
    });
  })
}

function getContrastEnhancer() {
  if (!imageAdapterHelper) {
    return;
  }
  let result1: videoProcessingEngine.ImageProcessor = imageAdapterHelper.getContrastEnhancer();
  let result2: videoProcessingEngine.ImageProcessor = imageAdapterHelper.getContrastEnhancer();
  expect(result1).assertDeepEquals(result2);
}

function onPixelmapReAdapt() {
  if (!imageAdapterHelper) {
    return;
  }
  let photoItemCacheType: ESObject = new Object() as ESObject;

  imageAdapterHelper.enable = false;
  imageAdapterHelper.onPixelmapReAdapt(photoItemCacheType);

  imageAdapterHelper.enable = true;
  photoItemCacheType.mIsCurrent = true;
  photoItemCacheType.matrix = new Matrix4Test();
  let mocker: MockKit = new MockKit();
  let mockCopy: Function = mocker.mockFunc(photoItemCacheType.matrix, photoItemCacheType.matrix.copy);
  let mockCalculateImagePosAndScale: Function =
    mocker.mockFunc(imageAdapterHelper, imageAdapterHelper.calculateImagePosAndScale)
  when(mockCopy)().afterReturn({ matrix4x4: undefined });
  when(mockCalculateImagePosAndScale)(ArgumentMatchers.any).afterReturn(undefined);
  imageAdapterHelper.onPixelmapReAdapt(photoItemCacheType);

  photoItemCacheType.maxScale = 1;
  photoItemCacheType.pixelmap = new Object() as ESObject;
  when(mockCopy)().afterReturn({ matrix4x4: [1] });
  when(mockCalculateImagePosAndScale)(ArgumentMatchers.any).afterReturn([1]);
  imageAdapterHelper.onPixelmapReAdapt(photoItemCacheType);

  mocker.ignoreMock(photoItemCacheType.matrix, photoItemCacheType.matrix.copy);
  mocker.ignoreMock(imageAdapterHelper, imageAdapterHelper.calculateImagePosAndScale);
}

function onLCDReAdapt() {
  if (!imageAdapterHelper) {
    return;
  }
  let photoItemCacheType: ESObject = new Object() as ESObject;
  let mocker: MockKit = new MockKit();
  let mockGetContrastEnhancer: Function = mocker.mockFunc(imageAdapterHelper, imageAdapterHelper.getContrastEnhancer);
  imageAdapterHelper.enable = false;
  imageAdapterHelper.onLCDReAdapt(photoItemCacheType);

  imageAdapterHelper.enable = true;
  photoItemCacheType.mIsCurrent = true;
  photoItemCacheType.pixelmap = new Object() as ESObject;
  let contrastEnhancer: ESObject = new ContrastEnhancerTest();
  let mockSetLcdImage: Function = mocker.mockFunc(contrastEnhancer, contrastEnhancer.setLcdImage);
  when(mockGetContrastEnhancer)(ArgumentMatchers.any).afterReturn(contrastEnhancer);
  imageAdapterHelper.onLCDReAdapt(photoItemCacheType);
  mocker.ignoreMock(imageAdapterHelper, imageAdapterHelper.getContrastEnhancer);
  mocker.ignoreMock(contrastEnhancer, contrastEnhancer.setLcdImage);
}

function calculateRatio() {
  if (!imageAdapterHelper) {
    return;
  }
  imageAdapterHelper.calculateRatio(1, 1, 0);
  let result: number = imageAdapterHelper.calculateRatio(0, 0, 0);
  expect(result).assertEqual(1);
}

function calculateImagePosAndScale() {
  if (!imageAdapterHelper) {
    return;
  }
  let photoItemCacheType: ESObject = new Object() as ESObject;
  photoItemCacheType.enable = true;
  photoItemCacheType.width = 0;
  photoItemCacheType.height = 0;
  photoItemCacheType.firstLookRatio = 0;
  photoItemCacheType.matrix = new Matrix4Test();
  let mocker: MockKit = new MockKit();
  let mockCopy: Function = mocker.mockFunc(photoItemCacheType.matrix, photoItemCacheType.matrix.copy);
  when(mockCopy)().afterReturn({ matrix4x4: [1] });
  imageAdapterHelper.calculateImagePosAndScale(photoItemCacheType);
  photoItemCacheType.reset = true;
  imageAdapterHelper.calculateImagePosAndScale(photoItemCacheType);
  when(mockCopy)().afterReturn({ matrix4x4: undefined });
  let result: number[] = imageAdapterHelper.calculateImagePosAndScale(photoItemCacheType);
}

class ContrastEnhancerTest {
  setLcdImage() {
  }
}


class Matrix4Test implements Matrix4.Matrix4Transit {
  copy(): Matrix4.Matrix4Transit {
    throw new Error('Method not implemented.');
  }

  invert(): Matrix4.Matrix4Transit {
    throw new Error('Method not implemented.');
  }

  combine(options: Matrix4.Matrix4Transit): Matrix4.Matrix4Transit {
    throw new Error('Method not implemented.');
  }

  translate(options: Matrix4.TranslateOption): Matrix4.Matrix4Transit {
    throw new Error('Method not implemented.');
  }

  scale(options: Matrix4.ScaleOption): Matrix4.Matrix4Transit {
    throw new Error('Method not implemented.');
  }

  skew(x: number, y: number): Matrix4.Matrix4Transit {
    throw new Error('Method not implemented.');
  }

  rotate(options: Matrix4.RotateOption): Matrix4.Matrix4Transit {
    throw new Error('Method not implemented.');
  }

  transformPoint(options: [number, number]): [number, number] {
    throw new Error('Method not implemented.');
  }

  setPolyToPoly(options: Matrix4.PolyToPolyOptions): Matrix4.Matrix4Transit {
    throw new Error('Method not implemented.');
  }
}