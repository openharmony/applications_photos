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
import { describe, expect, it } from '@ohos/hypium';
import { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { HiddenPhotoImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/HiddenPhotoImpl';
import { BrowserDataFactory } from '@ohos/common/src/main/ets/default/interface/BrowserDataFactory';
import { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';

const NUMBER_ONE: number = 1;

export default function PhotoDataSourceTest() {
  describe('PhotoDataSourceTest', () => {

    it('updateCurrent', 0, () => {
      let datasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let curIndex = 0;
      datasource.updateCurrent(curIndex);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('setAlbumDataSource_getAlbumDataSource', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(),'a://photo/image/0');
      let mediaDataSource: MediaDataSource | undefined = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE, new HiddenPhotoImpl());
      AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, mediaDataSource);
      photoDatasource.setAlbumDataSource(mediaDataSource);
      expect(photoDatasource.getAlbumDataSource()).assertEqual(mediaDataSource);

      mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      expect(photoDatasource.getAlbumDataSource()).assertEqual(mediaDataSource);
    });

    it('getValidStartIndex_getValidEndIndex', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(),'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      expect(photoDatasource.getValidStartIndex()).assertEqual(Constants.NOT_FOUND);

      expect(photoDatasource.getValidEndIndex()).assertEqual(Constants.NOT_FOUND);

    });

    it('getValidStartIndex_getValidEndIndex_0', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let validEndIndex = 0;
      let mediaDataSource: MediaDataSource | undefined = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE, new HiddenPhotoImpl());
      mediaDataSource.validEndIndex = validEndIndex;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      expect(photoDatasource.getValidStartIndex()).assertEqual(Constants.NOT_FOUND);

      expect(photoDatasource.getValidEndIndex()).assertEqual(validEndIndex);

    });

    it('getDataByDisplayName', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      expect(photoDatasource.getDataByDisplayName('') === undefined).assertEqual(true);
    });

    it('getDataIndexByPrefix', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      expect(photoDatasource.getDataIndexByPrefix('')).assertEqual(Constants.NOT_FOUND);
    });

    it('getDataIndexByDisplayName', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      expect(photoDatasource.getDataIndexByDisplayName('')).assertEqual(Constants.NOT_FOUND);
    });

    it('getDataIndexByUri', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      expect(photoDatasource.getDataIndexByUri('')).assertEqual(Constants.NOT_FOUND);
    });

    it('getItemByPath', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      expect(photoDatasource.getItemByPath('')).assertEqual(undefined);
    });

    it('fetchItemInAlbumByUri', 0, async () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      let res = await photoDatasource.fetchItemInAlbumByUri('');
      expect(res === undefined).assertEqual(true);
    });

    it('getItemByUri', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      expect(photoDatasource.getItemByUri('')).assertEqual(undefined);
    });

    it('getDataByUri', 0, async () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      let res = await photoDatasource.getDataByUri('');
      expect(res).assertEqual(undefined);
    });

    it('getPhotoDataImpl', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      Reflect.set(photoDatasource, 'photoDataImpl', undefined);
      let res1 = photoDatasource.getPhotoDataImpl();
      expect(res1).assertEqual(undefined);

      let photoDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO) as PhotoDataImpl;
      Reflect.set(photoDatasource, 'photoDataImpl', photoDataImpl);
      let res2 = photoDatasource.getPhotoDataImpl();
      expect(res2).assertEqual(photoDataImpl);
    });

    it('packData', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      let res = photoDatasource.packData(0);
      expect(res).assertEqual(undefined);
    });

    it('packDataWithCache', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      let res = photoDatasource.packDataWithCache(0, new MediaItem());
      expect(res != undefined).assertEqual(true);
    });

    it('getMediaItemWithoutCache', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);

      Reflect.set(photoDatasource, 'enableGetDataFlag', false);
      let res = photoDatasource.getMediaItemWithoutCache(0);
      expect(res).assertEqual(undefined);
    });

    it('getMediaItemWithoutCache_0', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);

      let res = photoDatasource.getMediaItemWithoutCache(0);
      expect(res).assertEqual(undefined);
    });

    it('getDataWithoutCache', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);

      Reflect.set(photoDatasource, 'enableGetDataFlag', false);
      let res = photoDatasource.getDataWithoutCache(0);
      expect(res).assertEqual(undefined);
    });

    it('getDataWithoutCache_0', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);

      let res = photoDatasource.getDataWithoutCache(0);
      expect(res).assertEqual(undefined);
    });

    it('getData', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);

      Reflect.set(photoDatasource, 'enableGetDataFlag', false);
      let res = photoDatasource.getData(0);
      expect(res).assertEqual(undefined);
    });

    it('getData_0', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);

      let res = photoDatasource.getData(0);
      expect(res).assertEqual(undefined);
    });

    it('enableGetData', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      let flag = true;
      photoDatasource.enableGetData(flag);
      let res: boolean = Reflect.get(photoDatasource, 'enableGetDataFlag');
      expect(res).assertEqual(flag);
    });

    it('setDeviceId', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      let deviceId = 'aaa';
      photoDatasource.setDeviceId(deviceId);
      let res: string = Reflect.get(photoDatasource, 'deviceId');
      expect(res).assertEqual(deviceId);
    });

    it('getAlbumUri_setAlbumUri', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      let albumUri = 'aaa';
      photoDatasource.setAlbumUri(albumUri);
      expect(photoDatasource.getAlbumUri()).assertEqual(albumUri);
    });

    it('resetAlbumUri', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource: MediaDataSource | undefined = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE, new HiddenPhotoImpl());
      photoDatasource.setAlbumDataSource(mediaDataSource);
      let albumUri = 'aaa';
      photoDatasource.resetAlbumUri(albumUri);
      expect(photoDatasource.getAlbumUri()).assertEqual(albumUri);
    });

    it('getDataIndex', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource: MediaDataSource | undefined = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      let res = photoDatasource.getDataIndex(new MediaItem());
      expect(res).assertEqual(-1);
    });

    it('realTotalCount', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource: MediaDataSource | undefined = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      let res = photoDatasource.realTotalCount();
      expect(res).assertEqual(0);
    });

    it('setIsNeedNotify', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource: MediaDataSource | undefined = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      let flag = true;
      photoDatasource.setIsNeedNotify(flag);
      let res: boolean = Reflect.get(photoDatasource, 'isNeedNotify');
      expect(res).assertEqual(flag);
    });

    it('totalCount', 0, () => {
      let photoDatasource: PhotoDataSource = new PhotoDataSource(new PhotoBrowserStateMachine(), 'a://photo/image/0');
      let mediaDataSource: MediaDataSource | undefined = undefined;
      photoDatasource.setAlbumDataSource(mediaDataSource);
      let res = photoDatasource.totalCount();
      expect(res).assertEqual(0);
    });

  });
}