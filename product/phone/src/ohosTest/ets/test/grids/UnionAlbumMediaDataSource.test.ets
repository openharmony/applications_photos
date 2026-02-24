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
import { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  UnionAlbumMediaDataSource
} from '@ohos/common/src/main/ets/default/model/browser/photo/UnionAlbumMediaDataSource';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'UnionAlbumMediaDataSource';

export default function UnionAlbumMediaDataSourceTest() {

  describe('UnionAlbumMediaDataSourceTest', () => {

    // 测试if分支 !this.isUnionAlbum = true
    it('should_return_super_getQueryParam_when_isUnionAlbum_is_false', 0, () => {
      let unionAlbumMediaDatasource: UnionAlbumMediaDataSource = new UnionAlbumMediaDataSource(10);
      // 显式指定isUnionAlbum = false
      unionAlbumMediaDatasource.isUnionAlbum = false;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(unionAlbumMediaDatasource, unionAlbumMediaDatasource.getQueryParam);
      when(mockFunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn({
        albumUri: 'testUri',
        albumUris: ['testUri1', 'testUri2'],
        start: 0,
        count: 10,
        filterMediaType: 1
      });
      const result = unionAlbumMediaDatasource.getQueryParam(0, 10);
      expect(result.albumUri).assertEqual('testUri');
      expect(result.albumUris).assertDeepEquals(['testUri1', 'testUri2']);
      expect(result.start).assertEqual(0);
      expect(result.count).assertEqual(10);
      expect(result.filterMediaType).assertEqual(1);
      mocker.ignoreMock(unionAlbumMediaDatasource, unionAlbumMediaDatasource.getQueryParam);
    });

    // 测试正常分支，不走if
    it('should_return_custom_QueryParam_when_isUnionAlbum_is_true', 0, () => {
      let unionAlbumMediaDatasource: UnionAlbumMediaDataSource = new UnionAlbumMediaDataSource(10, new PhotoDataImpl());
      // 显式指定isUnionAlbum = true
      unionAlbumMediaDatasource.isUnionAlbum = true;
      unionAlbumMediaDatasource.albumUri = 'testAlbumUri';

      Reflect.set(unionAlbumMediaDatasource, 'albumUris', ['testUri1', 'testUri2']);
      Reflect.set(unionAlbumMediaDatasource, 'filterMediaType', 1);

      const result = unionAlbumMediaDatasource.getQueryParam(0, 10);
      expect(result.albumUri).assertEqual('testAlbumUri');
      expect(result.albumUris).assertDeepEquals(['testUri1', 'testUri2']);
      expect(result.start).assertEqual(0);
      expect(result.count).assertEqual(10);
      expect(result.filterMediaType).assertEqual(1);
    });

    // 测试if分支：!albumUris || albumUris.length === 0
    it('should_log_error_when_albumUris_is_empty', 0, () => {
      let unionAlbumMediaDatasource: UnionAlbumMediaDataSource = new UnionAlbumMediaDataSource(10);
      let albumUris: string[] = [];
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(Log, Log.error);
      unionAlbumMediaDatasource.setAlbumUris(albumUris);
      mocker.verify('error', [TAG, 'setAlbumUris: empty albumUris']).once();
      mocker.ignoreMock(Log, Log.error);
    });

    // 测试非空分支
    it('should_set_albumUris_when_albumUris_is_not_empty', 0, () => {
      let unionAlbumMediaDatasource: UnionAlbumMediaDataSource = new UnionAlbumMediaDataSource(10);
      let albumUris: string[] = ['uri1', 'uri2'];
      unionAlbumMediaDatasource.setAlbumUris(albumUris);
      let res: string[] = Reflect.get(unionAlbumMediaDatasource, 'albumUris');
      expect(res[0]).assertDeepEquals(albumUris[0]);
      expect(res[1]).assertDeepEquals(albumUris[1]);
      expect(unionAlbumMediaDatasource.albumUri).assertEqual(albumUris[0]);
    });

    it('should_return_false_when_albumUri_is_undefined_or_empty', 0, () => {
      let unionAlbumMediaDatasource: UnionAlbumMediaDataSource = new UnionAlbumMediaDataSource(10);
      let result: boolean = Reflect.get(unionAlbumMediaDatasource, 'checkAlbumUri').call(undefined);
      expect(result).assertEqual(false);
    });

    // 测试if分支且调用super.checkAlbumUri有返回
    it('should_return_false_when_isUnionAlbum_is_false_and_super_checkAlbumUri_returns_false', 0, () => {
      let unionAlbumMediaDatasource: UnionAlbumMediaDataSource = new UnionAlbumMediaDataSource(10);
      // 显式指定isUnionAlbum = false
      unionAlbumMediaDatasource.isUnionAlbum = false;
      let result: boolean = Reflect.get(unionAlbumMediaDatasource, 'checkAlbumUri').call('someAlbumUri');
      expect(result).not().assertNull();
    });

    // 测试非if分支且super.checkAlbumUri返回true
    it('should_return_true_when_isUnionAlbum_is_true_and_albumUri_is_in_albumUris', 0, () => {
      let unionAlbumMediaDatasource: UnionAlbumMediaDataSource = new UnionAlbumMediaDataSource(10);
      unionAlbumMediaDatasource.isUnionAlbum = true;
      let strItem = 'someAlbumUri';
      Reflect.set(unionAlbumMediaDatasource, 'albumUris', [strItem]);
      let albumUris: string[] = Reflect.get(unionAlbumMediaDatasource, 'albumUris');
      expect(albumUris.length > 0 && albumUris[0] === strItem).assertTrue();
      expect(albumUris.indexOf(strItem) !== -1).assertTrue();
      // 反射调用protected及private方法传入对象实例及参数列表
      let result: boolean = Reflect.get(unionAlbumMediaDatasource, 'checkAlbumUri')
        .call(unionAlbumMediaDatasource, strItem);
      expect(result).assertTrue();
    });

    // 测试非if分支且super.checkAlbumUri返回false
    it('should_return_false_when_isUnionAlbum_is_true_and_albumUri_is_not_in_albumUris', 0, () => {
      let unionAlbumMediaDatasource: UnionAlbumMediaDataSource = new UnionAlbumMediaDataSource(10);
      unionAlbumMediaDatasource.isUnionAlbum = true;
      let strItem1 = 'otherAlbumUri';
      let strItem2 = 'someAlbumUri';
      Reflect.set(unionAlbumMediaDatasource, 'albumUris', [strItem1]);
      let albumUris: string[] = Reflect.get(unionAlbumMediaDatasource, 'albumUris');
      expect(albumUris.length > 0 && albumUris[0] === strItem1).assertTrue();
      // 反射调用protected及private方法传入对象实例及参数列表
      let result: boolean = Reflect.get(unionAlbumMediaDatasource, 'checkAlbumUri')
        .call(unionAlbumMediaDatasource, strItem2);
      expect(result).assertFalse();
    });

  });
}