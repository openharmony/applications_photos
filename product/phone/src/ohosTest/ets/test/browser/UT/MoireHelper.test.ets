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
import { MoireHelper } from '@ohos/browsercommon/src/main/ets/default/utils/MoireHelper';
import { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import TaskManage, {
  cacheItemType,
  updateOptionsType
} from '@ohos/browsercommon/src/main/ets/default/utils/MoireTaskManage'
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { Thumbnail } from '@ohos/common/src/main/ets/default/model/browser/photo/Thumbnail';
import Matrix4 from '@ohos.matrix4';

let moireHelper: MoireHelper | undefined = undefined;

export default function MoireHelperTest() {
  describe('MoireHelperTest', () => {

    beforeEach(() => {
      moireHelper = new MoireHelper();
    });

    afterEach(() => {
      if (!moireHelper) {
        return;
      }
      (moireHelper as ESObject).instance = undefined
      moireHelper = undefined;
    });
    it('init', 0, () => {
      init();
    });
    it('updatePCImageWindowScale', 0, () => {
      updatePCImageWindowScale();
    });
    it('updateImageWindowScale', 0, () => {
      updateImageWindowScale();
    });
    it('updatePhotoCache', 0, () => {
      updatePhotoCache();
    });
    it('resetCache', 0, () => {
      resetCache();
    });
    it('changeMIsCurrent', 0, () => {
      changeMIsCurrent();
    });
    it('clearDebounceTime', 0, () => {
      clearDebounceTime();
    });
    it('update', 0, () => {
      update();
    });
    it('on', 0, () => {
      on();
    });
    it('off', 0, () => {
      off();
    });
    it('notify', 0, () => {
      notify();
    });
    it('showLargeImage', 0, () => {
      showLargeImage();
    });
    it('showLargeImageAsync', 0, () => {
      showLargeImageAsync();
    });
    it('hideLargeImage', 0, () => {
      hideLargeImage();
    });
    it('setIsOnSwiperAnimation', 0, () => {
      setIsOnSwiperAnimation();
    });
  })
}

function init() {
  if (!moireHelper) {
    return;
  }
  moireHelper.enable = false;
  let mocker: MockKit = new MockKit();
  new MoireHelper();
}

function updatePCImageWindowScale() {
  if (!moireHelper) {
    return;
  }
  let mocker: MockKit = new MockKit();
  let mockUpdate: Function = mocker.mockFunc(moireHelper, moireHelper.update);
  let mockIsPc: Function = mocker.mockFunc(DeviceInfo, DeviceInfo.isPc);
  moireHelper.updatePCImageWindowScale('test');

  (moireHelper as ESObject).currentId = 'test';
  when(mockIsPc)().afterReturn(true);
  moireHelper.updatePCImageWindowScale('test');

  mocker.verify('update', ['test', undefined, true]).once();
  mocker.ignoreMock(moireHelper, moireHelper.update);
}

function updateImageWindowScale() {
  if (!moireHelper) {
    return;
  }
  moireHelper.updateImageWindowScale('test', false, 1, 1);
  let mocker: MockKit = new MockKit();
  let mockUpdateImageWindowScale: Function = mocker.mockFunc(TaskManage, TaskManage.updateImageWindowScale);
  (moireHelper as ESObject).currentId = 'test';
  moireHelper.updateImageWindowScale('test', true, 1, 1);
  mocker.verify('updateImageWindowScale', [true, 1, 1]).once();
  mocker.ignoreMock(TaskManage, TaskManage.updateImageWindowScale);
}

function updatePhotoCache() {
  if (!moireHelper) {
    return;
  }
  let mocker: MockKit = new MockKit();
  let mockUpdate: Function = mocker.mockFunc(moireHelper, moireHelper.update);

  let thumbnail: Thumbnail = new Thumbnail();
  thumbnail.pixelMap = new Object() as ESObject;
  let photoItemCacheOptions: ESObject = { item: new MediaItem(), thumbnail: thumbnail };
  let photoItemCacheOptions1: ESObject = {};
  moireHelper.enable = false;
  moireHelper.updatePhotoCache('test', photoItemCacheOptions);

  moireHelper.enable = true;
  moireHelper.updatePhotoCache('test', photoItemCacheOptions1);
  moireHelper.updatePhotoCache('test', photoItemCacheOptions);


  moireHelper.updatePhotoCache('test', photoItemCacheOptions, true);

  moireHelper.updatePhotoCache('test', photoItemCacheOptions, true, undefined, true);

  moireHelper.updatePhotoCache('test', photoItemCacheOptions, true, 1, true);

  mocker.ignoreMock(moireHelper, moireHelper.update);
}

function resetCache() {
  if (!moireHelper) {
    return;
  }
  let mocker: MockKit = new MockKit();
  let mockResetCache: Function = mocker.mockFunc(TaskManage, TaskManage.resetCache);

  moireHelper.enable = false;
  moireHelper.resetCache();

  moireHelper.enable = true;
  moireHelper.resetCache();

  mocker.ignoreMock(TaskManage, TaskManage.resetCache);
}

function changeMIsCurrent() {
  if (!moireHelper) {
    return;
  }
  let mocker: MockKit = new MockKit();
  let mockUpdate: Function = mocker.mockFunc(moireHelper, moireHelper.update);
  moireHelper.enable = false;
  moireHelper.changeMIsCurrent(true, 'test');

  moireHelper.enable = true;
  (moireHelper as ESObject).currentId = '123';
  moireHelper.changeMIsCurrent(false, 'test');
  moireHelper.changeMIsCurrent(true, 'test');

  (moireHelper as ESObject).currentId = 'test';
  moireHelper.changeMIsCurrent(true, 'test');

  (moireHelper as ESObject).photoItemCache.set('test', {})
  moireHelper.changeMIsCurrent(true, 'test');
  mocker.ignoreMock(moireHelper, moireHelper.update);
}

function clearDebounceTime() {
  if (!moireHelper) {
    return;
  }
  (moireHelper as ESObject).clearDebounceTime();
  (moireHelper as ESObject).debounceTime = 1;
  (moireHelper as ESObject).clearDebounceTime();
}

function update() {
  if (!moireHelper) {
    return;
  }
  moireHelper.enable = false;
  moireHelper.update('test');

  let mocker: MockKit = new MockKit();
  let mockUpdate: Function = mocker.mockFunc(TaskManage, TaskManage.update);
  let mockCalculateRatio: Function = mocker.mockFunc(TaskManage, TaskManage.calculateRatio);
  let mockGetFormatUpdateOptions: Function = mocker.mockFunc(moireHelper, moireHelper.getFormatUpdateOptions);
  let mockDebounce: Function = mocker.mockFunc(moireHelper, (moireHelper as ESObject).debounce);
  let mockGetTaskItemCacheKey: Function = mocker.mockFunc(TaskManage, TaskManage.getTaskItemCacheKey);
  moireHelper.enable = true;
  moireHelper.update('test');

  TaskManage.cache.set('test', {} as cacheItemType);
  let updateOptionsType = {
    scale: 1,
  } as updateOptionsType;
  moireHelper.update('test');

  when(mockCalculateRatio)(ArgumentMatchers.any).afterReturn(2);
  updateOptionsType = {
    scale: 1,
    isImmediately: false,
  } as updateOptionsType
  moireHelper.update('test', updateOptionsType);

  updateOptionsType = {
    scale: 1,
  } as updateOptionsType
  when(mockGetTaskItemCacheKey)(ArgumentMatchers.any).afterReturn('');
  moireHelper.update('test', updateOptionsType);

  moireHelper.update('test', updateOptionsType, false);

  when(mockCalculateRatio)(ArgumentMatchers.any).afterReturn(0);
  moireHelper.update('test', updateOptionsType, false);
  mocker.ignoreMock(TaskManage, TaskManage.update);
  mocker.ignoreMock(TaskManage, TaskManage.calculateRatio);
  mocker.ignoreMock(moireHelper, moireHelper.getFormatUpdateOptions);
  mocker.ignoreMock(TaskManage, TaskManage.getTaskItemCacheKey);
}

function on() {
  if (!moireHelper) {
    return;
  }
  moireHelper.enable = false;
  moireHelper.on('test', () => {
  });

  moireHelper.enable = true;
  moireHelper.on('test', () => {
  });
}

function off() {
  if (!moireHelper) {
    return;
  }
  moireHelper.enable = false;
  moireHelper.off('test', () => {});

  moireHelper.enable = true;
  moireHelper.off('test', () => {});
}

function notify() {
  if (!moireHelper) {
    return;
  }
  moireHelper.enable = false;
  moireHelper.notify('test', 1);

  moireHelper.enable = true;
  let listener: ESObject = {
    id: 'testId',
    listenerCallback: (object: ESObject) => {
    },
  };
  moireHelper.notify('testId', new Object() as ESObject);
  moireHelper.notify('test', new Object() as ESObject);
}

function showLargeImage() {
  if (!moireHelper) {
    return;
  }
  moireHelper.enable = false;
  moireHelper.showLargeImage();

  moireHelper.enable = true;
  moireHelper.showLargeImage();
}

async function showLargeImageAsync() {
  if (!moireHelper) {
    return;
  }
  moireHelper.enable = false;
  await moireHelper.showLargeImageAsync();

  moireHelper.enable = true;
  await moireHelper.showLargeImageAsync();
}

function hideLargeImage() {
  if (!moireHelper) {
    return;
  }
  let mocker: MockKit = new MockKit();
  let mockResetCache: Function = mocker.mockFunc(TaskManage, TaskManage.resetCache);
  moireHelper.enable = false;
  moireHelper.hideLargeImage();

  moireHelper.enable = true;
  moireHelper.hideLargeImage();
  mocker.ignoreMock(TaskManage, TaskManage.resetCache);
}

function setIsOnSwiperAnimation() {
  if (!moireHelper) {
    return;
  }
  moireHelper.enable = false;
  moireHelper.setIsOnSwiperAnimation(true, new Object() as ESObject);

  moireHelper.enable = true;
  let matrix: Matrix4.Matrix4Transit = new Matrix4Test();
  let mocker: MockKit = new MockKit();
  let mockCopy: Function = mocker.mockFunc(matrix, matrix.copy);

  when(mockCopy)().afterReturn({ matrix4x4: undefined });
  moireHelper.setIsOnSwiperAnimation(true, matrix);
  let mockUpdate: Function = mocker.mockFunc(moireHelper, moireHelper.update);
  when(mockCopy)().afterReturn({ matrix4x4: [1] });
  moireHelper.setIsOnSwiperAnimation(false, matrix);
  mocker.ignoreMock(moireHelper, moireHelper.update);
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