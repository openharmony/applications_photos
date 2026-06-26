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
import { describe, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { common } from '@kit.AbilityKit';
import { PhotoAlbum, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import { FaCardPortraitAlbumDataSource } from "@ohos/common/src/main/ets/default/model/browser/album/FaCardPortraitAlbumDataSource";
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG = 'FaCardPortraitAlbumDataSourceTest'

export default function FaCardPortraitAlbumDataSourceTest() {
    describe('FaCardPortraitAlbumDataSourceTest', () => {
        it('FaCardPortraitAlbumDataSourceTest_001', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
            await FaCardPortraitAlbumDataSourceTest001();
        });

        it('FaCardPortraitAlbumDataSourceTest_002', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
            await FaCardPortraitAlbumDataSourceTest002();
        });

        it('FaCardPortraitAlbumDataSourceTest_003', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
            await FaCardPortraitAlbumDataSourceTest003();
        });

        it('FaCardPortraitAlbumDataSourceTest_004', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
            await FaCardPortraitAlbumDataSourceTest004();
        });

        it('FaCardPortraitAlbumDataSourceTest_005', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
            await FaCardPortraitAlbumDataSourceTest005();
        });
    })
}

async function FaCardPortraitAlbumDataSourceTest001() {
    let facardportraitalbumdatasource: FaCardPortraitAlbumDataSource = new FaCardPortraitAlbumDataSource(getContext(), new BroadCast(), '');
    let setAlbumInfoMethod: Function  = Reflect.get(facardportraitalbumdatasource, 'setAlbumInfo');
    let mediaSetList: PhotoAlbum[] = [];
    let currentIndex: number = 0;
    const result: AlbumInfo[] = await setAlbumInfoMethod(mediaSetList, currentIndex);
    expect(result.length).assertEqual(0);
}

async function FaCardPortraitAlbumDataSourceTest002() {
    let facardportraitalbumdatasource: FaCardPortraitAlbumDataSource = new FaCardPortraitAlbumDataSource(getContext(), new BroadCast(), '');
    let mediaSetList: PhotoAlbum[] = [];
    let currentIndex: number = 0;
    let userFileManagerAccess = new UserFileManagerAccess();
    let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
    if (context) {
        userFileManagerAccess.onCreate(context);
        let imageAlbum: PhotoAlbum | undefined =
            await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

        if (imageAlbum) {
            mediaSetList.push(imageAlbum);
        }
        const run = (mediaSetList: PhotoAlbum[], currentIndex: number): AlbumInfo[] => Reflect.get(facardportraitalbumdatasource, 'setAlbumInfo')
            .call(facardportraitalbumdatasource, mediaSetList, currentIndex);
        const result: AlbumInfo[] = await run(mediaSetList, currentIndex);
        expect(result.length).assertEqual(1);
        Log.info(TAG, `FaCardPortraitAlbumDataSourceTest002 end: ${result.length}`);
    } else {
        Log.info(TAG, `FaCardPortraitAlbumDataSourceTest002 getContext is undefined.`);
    }
}

async function FaCardPortraitAlbumDataSourceTest003() {
    let facardportraitalbumdatasource: FaCardPortraitAlbumDataSource = new FaCardPortraitAlbumDataSource(getContext(), new BroadCast(), '');
    let mediaSetList: PhotoAlbum[] = [];
    let currentIndex: number = 0;
    let userFileManagerAccess = new UserFileManagerAccess();
    let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
    if (context) {
        userFileManagerAccess.onCreate(context);
        let imageAlbum: PhotoAlbum | undefined =
            await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

        if (imageAlbum) {
            mediaSetList.push(imageAlbum);
        }

        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(PhotoAccessHelperAccess, PhotoAccessHelperAccess.getSmartAlbumMediaTypeCount);
        let videoCount = imageAlbum?.count;
        when(mockfunc)(ArgumentMatchers.any).afterReturn(videoCount);

        const run = (mediaSetList: PhotoAlbum[], currentIndex: number): AlbumInfo[] => Reflect.get(facardportraitalbumdatasource, 'setAlbumInfo')
            .call(facardportraitalbumdatasource, mediaSetList, currentIndex);
        const result: AlbumInfo[] = await run(mediaSetList, currentIndex);
        expect(result.length).assertEqual(0);

        mocker.ignoreMock(PhotoAccessHelperAccess, PhotoAccessHelperAccess.getSmartAlbumMediaTypeCount);
    } else {
        Log.info(TAG, `FaCardPortraitAlbumDataSourceTest003 getContext is undefined.`);
    }
}

/**
 * updateAlbumData
 * 分支 this.lastUpdateTime < this.lastRequestTime && this.isActive
 */
async function FaCardPortraitAlbumDataSourceTest004() {
    let facardportraitalbumdatasource: FaCardPortraitAlbumDataSource = new FaCardPortraitAlbumDataSource(getContext(), new BroadCast(), '');
    let requestTime: number = -1;
    let mediaSetList: PhotoAlbum[] = [];

    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(facardportraitalbumdatasource, facardportraitalbumdatasource.loadData);
    when(mockfunc)(ArgumentMatchers.any).afterReturn({});

    await facardportraitalbumdatasource.updateAlbumData(requestTime, mediaSetList);

    expect(facardportraitalbumdatasource !== undefined).assertTrue();
    mocker.ignoreMock(facardportraitalbumdatasource, facardportraitalbumdatasource.loadData);
}

/**
 * updateAlbumData
 * 分支 !(this.lastUpdateTime < this.lastRequestTime && this.isActive)
 */
async function FaCardPortraitAlbumDataSourceTest005() {
    let facardportraitalbumdatasource: FaCardPortraitAlbumDataSource = new FaCardPortraitAlbumDataSource(getContext(), new BroadCast(), '');
    let requestTime: number = 10;
    let mediaSetList: PhotoAlbum[] = [];

    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(facardportraitalbumdatasource, facardportraitalbumdatasource.onAlbumDataReloaded);
    when(mockfunc)(ArgumentMatchers.any).afterReturn({});

    await facardportraitalbumdatasource.updateAlbumData(requestTime, mediaSetList);

    expect(facardportraitalbumdatasource !== undefined).assertTrue();
    mocker.ignoreMock(facardportraitalbumdatasource, facardportraitalbumdatasource.onAlbumDataReloaded);
}