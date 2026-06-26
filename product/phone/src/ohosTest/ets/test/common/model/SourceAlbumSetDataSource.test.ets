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

import { describe, expect, it, ArgumentMatchers, MockKit, when } from "@ohos/hypium";
import { abilityDelegator } from "@ohos/tools/src/ohosTest/ets/Factory.test";
import { TestConstants } from "@ohos/tools/src/ohosTest/ets/TestConstants";
import { common } from "@kit.AbilityKit";
import { AlbumSetCacheManager, CacheType } from "@ohos/common/src/main/ets/default/model/AlbumSetCacheManager";
import { SourceAlbumSetDataSource } from "@ohos/common/src/main/ets/default/model/SourceAlbumSetDataSource";

const TAG: string = 'SourceAlbumSetDataSourceTest';

export default function SourceAlbumSetDataSourceTest(): void {
  describe('SourceAlbumSetDataSourceTest', (): void => {
    it('SourceAlbumSetDataSourceTest_001', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await SourceAlbumSetDataSourceTest01();
    });

    it('SourceAlbumSetDataSourceTest_002', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await SourceAlbumSetDataSourceTest02();
    });

    it('SourceAlbumSetDataSourceTest_003', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await SourceAlbumSetDataSourceTest03();
    });

    it('SourceAlbumSetDataSourceTest_004', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await SourceAlbumSetDataSourceTest04();
    });

    it('SourceAlbumSetDataSourceTest_005', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await SourceAlbumSetDataSourceTest05();
    });

    it('AlbumSetCacheManagerTest_001', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetCacheManagerTest01();
    });

    it('AlbumSetCacheManagerTest_002', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetCacheManagerTest02();
    });

    it('AlbumSetCacheManagerTest_003', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetCacheManagerTest03();
    });

    it('AlbumSetCacheManagerTest_004', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetCacheManagerTest04();
    });

    it('AlbumSetCacheManagerTest_005', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetCacheManagerTest05();
    });

    it('AlbumSetCacheManagerTest_006', TestConstants.TEST_LEVEL_ZERO, async (): Promise<void> => {
      await AlbumSetCacheManagerTest06();
    });
  })
}

/**
 * 打开图库
 */
async function SourceAlbumSetDataSourceTest01() {
  try {
    let result =
      await abilityDelegator.executeShellCommand('aa start -a com.ohos.photos.MainAbility -b com.ohos.photos')
        .then((): void => {
        });
    expect(result !== null).assertTrue();
  } catch (exception) {
  } finally {
  }
}

async function SourceAlbumSetDataSourceTest02() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (context) {
    let cache = new AlbumSetCacheManager(context);
    let dataSource = new SourceAlbumSetDataSource(context, cache, 1);
    dataSource.totalCount();
    dataSource.dataCount();
    dataSource.setShowCount(2);
    dataSource.getData(1);
  }
  expect(context !== undefined).assertTrue();
}

async function SourceAlbumSetDataSourceTest03() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (context) {
    let cache = new AlbumSetCacheManager(context);
    let dataSource = new SourceAlbumSetDataSource(context, cache, 1);
    dataSource.dataCount();
    dataSource.setShowCount(0);
    dataSource.getShowCount();
    dataSource.getData(1);
    dataSource.notifyDirty()
  }
  expect(context !== undefined).assertTrue();
}

async function SourceAlbumSetDataSourceTest04() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (context) {
    let cache = new AlbumSetCacheManager(context);
    let dataSource = new SourceAlbumSetDataSource(context, cache, 1);

    let mocker: MockKit = new MockKit();
    let totalCount: Function = mocker.mockFunc(dataSource, dataSource.totalCount);
    when(totalCount)(ArgumentMatchers.any).afterReturn(0);

    let res = dataSource.hasSourceAlbum();

    expect(!res).assertTrue();
    mocker.ignoreMock(dataSource, dataSource.totalCount);
  }

}

async function SourceAlbumSetDataSourceTest05() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (context) {
    let cache = new AlbumSetCacheManager(context);
    let dataSource = new SourceAlbumSetDataSource(context, cache, 1);

    let mocker: MockKit = new MockKit();
    let totalCount: Function = mocker.mockFunc(dataSource, dataSource.totalCount);
    when(totalCount)(ArgumentMatchers.any).afterReturn(1);

    let res = dataSource.hasSourceAlbum();

    expect(res).assertTrue();
    mocker.ignoreMock(dataSource, dataSource.totalCount);
  }

}


/**
 * AlbumSetCacheManager.setCacheData
 * 分支 !filePath
 */
async function AlbumSetCacheManagerTest01() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (context) {
    let cache = new AlbumSetCacheManager(context);
    await cache.setCacheData(CacheType.PORTRAIT_HOMEPAGE_ALBUMS);
  }
  expect(context !== undefined).assertTrue();
}

/**
 * AlbumSetCacheManager.getCache
 * 分支  if (!cacheType)
 */
async function AlbumSetCacheManagerTest02() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (context) {
    let cache = new AlbumSetCacheManager(context);
    cache.getCache(undefined);
  }
  expect(context !== undefined).assertTrue();
}

/**
 * AlbumSetCacheManager.getCacheAsync
 * 分支  if (!cacheType)
 */
async function AlbumSetCacheManagerTest03() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (context) {
    let cache = new AlbumSetCacheManager(context);
    await cache.getCacheAsync(undefined);
  }
  expect(context !== undefined).assertTrue();
}

/**
 * AlbumSetCacheManager.getCacheAsync
 * 分支  if (!this.caches.get(cacheType))
 */
async function AlbumSetCacheManagerTest04() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (context) {
    let cache = new AlbumSetCacheManager(context);
    await cache.getCacheAsync(CacheType.PORTRAIT_HOMEPAGE_ALBUMS);
  }
  expect(context !== undefined).assertTrue();
}

/**
 * AlbumSetCacheManager.getCacheAsync
 * 分支  if (this.caches.get(cacheType))
 */
async function AlbumSetCacheManagerTest05() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (context) {
    let cache = new AlbumSetCacheManager(context);
    await cache.getCacheAsync(CacheType.MAP);
  }
  expect(context !== undefined).assertTrue();
}

/**
 * AlbumSetCacheManager.writeCache
 * 分支  !filePath
 */
async function AlbumSetCacheManagerTest06() {
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  if (context) {
    let cache = new AlbumSetCacheManager(context);
    await cache.writeCache(CacheType.PORTRAIT_HOMEPAGE_ALBUMS, undefined);
  }
  expect(context !== undefined).assertTrue();
}
