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
import {
  getAllSortedAlbumsFetchOption,
  getCheckForUnsortedAlbumsFetchOption,
  getJudgeAlbumSortedByNameFetchOption,
  getListAreaAlbumCountFilterUnionAlbumsFetchOption,
  getListAreaAlbumsFetchOption,
  getMovePageAlbumsCountFilterUnionAlbumsFetchOption,
  getMovePageAlbumsFetchOption,
  getMyAlbumCountFilterUnionAlbumsFetchOption,
  getNormalAlbumsFetchOption,
  getSortedMyAlbumsFetchOption,
  getSortedSystemAlbumsFetchOption,
  getSystemAlbumCountFilterUnionAlbumsFetchOption,
  getUnionAlbumsCountFetchOption
} from '@ohos/common/src/main/ets/default/access/AlbumSortFetchOptions';
import { QueryAlbumParam } from '@ohos/common/src/main/ets/default/interface/BrowserDataInterface';

export default function AlbumSortFetchOptionsTest() {
  describe('AlbumSortFetchOptionsTest', () => {

    //测试getMovePageAlbumsCountFilterUnionAlbumsFetchOption
    it('getMovePageAlbumsCountFilterUnionAlbumsFetchOption_when_return_not_undefined', 0, () => {
      const res = getMovePageAlbumsCountFilterUnionAlbumsFetchOption();
      expect(res !== undefined).assertTrue();
    });

    //测试getMovePageAlbumsFetchOption
    it('getMovePageAlbumsFetchOption_when_return_not_undefined', 0, () => {
      const param: QueryAlbumParam = {
        filterMediaType: "test",
        uris: [],
        start: 1,
        count: 5,
        hasItemsOnly: true,
        blackUriList: [],
        nameOnly: true,
        orderSection: [],
        orderStyle: 5,
      }
      const res = getMovePageAlbumsFetchOption(param);
      expect(res !== undefined).assertTrue();
    });

    //getAllSortedAlbumsFetchOption
    it('getAllSortedAlbumsFetchOption_when_return_not_undefined', 0, () => {
      const param: QueryAlbumParam = {
        filterMediaType: "test",
        uris: [],
        start: 1,
        count: 5,
        hasItemsOnly: true,
        blackUriList: [],
        nameOnly: true,
        orderSection: [],
        orderStyle: 5,
      }
      const res = getAllSortedAlbumsFetchOption(param);
      expect(res !== undefined).assertTrue();
    });

    //测试getNormalAlbumsFetchOption
    it('getNormalAlbumsFetchOption_when_return_not_undefined', 0, () => {
      const param: QueryAlbumParam = {
        filterMediaType: "test",
        uris: [],
        start: 1,
        count: 5,
        hasItemsOnly: true,
        blackUriList: [],
        nameOnly: true,
        orderSection: [],
        orderStyle: 5,
      }
      const res = getNormalAlbumsFetchOption(param);
      expect(res !== undefined).assertTrue();
    });

    //测试getSortedSystemAlbumsFetchOption
    it('getSortedSystemAlbumsFetchOption_when_return_not_undefined', 0, () => {
      const param: QueryAlbumParam = {
        filterMediaType: "test",
        uris: [],
        start: 1,
        count: 5,
        hasItemsOnly: true,
        blackUriList: [],
        nameOnly: true,
        orderSection: [],
        orderStyle: 5,
      }
      const res = getSortedSystemAlbumsFetchOption(param);
      expect(res !== undefined).assertTrue();
    });

    //测试getSortedMyAlbumsFetchOption
    it('getSortedMyAlbumsFetchOption_when_return_not_undefined', 0, () => {
      const param: QueryAlbumParam = {
        filterMediaType: "test",
        uris: [],
        start: 1,
        count: 5,
        hasItemsOnly: true,
        blackUriList: [],
        nameOnly: true,
        orderSection: [],
        orderStyle: 5,
      }
      const res = getSortedMyAlbumsFetchOption(param);
      expect(res !== undefined).assertTrue();
    });

    //测试getSystemAlbumCountFilterUnionAlbumsFetchOption
    it('getSystemAlbumCountFilterUnionAlbumsFetchOption_when_return_not_undefined', 0, () => {
      const res = getSystemAlbumCountFilterUnionAlbumsFetchOption();
      expect(res !== undefined).assertTrue();
    });

    //测试getMyAlbumCountFilterUnionAlbumsFetchOption
    it('getMyAlbumCountFilterUnionAlbumsFetchOption_when_return_not_undefined', 0, () => {
      const res = getMyAlbumCountFilterUnionAlbumsFetchOption();
      expect(res !== undefined).assertTrue();
    });

    //测试getUnionAlbumsCountFetchOption
    it('getUnionAlbumsCountFetchOption_when_return_not_undefined', 0, () => {
      const param: QueryAlbumParam = {
        filterMediaType: "test",
        uris: [],
        start: 1,
        count: 5,
        hasItemsOnly: true,
        blackUriList: [],
        nameOnly: true,
        orderSection: [],
        orderStyle: 5,
      }
      let albumFlag: number = 1;
      const res = getUnionAlbumsCountFetchOption(param, albumFlag);
      expect(res !== undefined).assertTrue();
    });

    //测试getListAreaAlbumsFetchOption
    it('getListAreaAlbumsFetchOption_when_return_not_undefined', 0, () => {
      const param: QueryAlbumParam = {
        filterMediaType: "test",
        uris: [],
        start: 1,
        count: 5,
        hasItemsOnly: true,
        blackUriList: [],
        nameOnly: true,
        orderSection: [],
        orderStyle: 5,
      }
      const res = getListAreaAlbumsFetchOption(param);
      expect(res !== undefined).assertTrue();
    });


    //测试getListAreaAlbumCountFilterUnionAlbumsFetchOption
    it('getListAreaAlbumCountFilterUnionAlbumsFetchOption_when_return_not_undefined', 0, () => {
      const res = getListAreaAlbumCountFilterUnionAlbumsFetchOption();
      expect(res !== undefined).assertTrue();
    });

    //测试getCheckForUnsortedAlbumsFetchOption
    it('getCheckForUnsortedAlbumsFetchOption_when_return_not_undefined', 0, () => {
      const param: QueryAlbumParam = {
        filterMediaType: "test",
        uris: [],
        start: 1,
        count: 5,
        hasItemsOnly: true,
        blackUriList: [],
        nameOnly: true,
        orderSection: [],
        orderStyle: 5,
      }
      const res = getCheckForUnsortedAlbumsFetchOption(param);
      expect(res !== undefined).assertTrue();
    });

    //测试getJudgeAlbumSortedByNameFetchOption
    it('getJudgeAlbumSortedByNameFetchOption_when_return_not_undefined', 0, () => {
      const param: QueryAlbumParam = {
        filterMediaType: "test",
        uris: [],
        start: 1,
        count: 5,
        hasItemsOnly: true,
        blackUriList: [],
        nameOnly: true,
        orderSection: [],
        orderStyle: 5,
      }
      const res = getJudgeAlbumSortedByNameFetchOption(param);
      expect(res !== undefined).assertTrue();
    });
  });
}
