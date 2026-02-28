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
import { LoadingListener } from '@ohos/common/src/main/ets/default/model/browser/LoadingListener';
import {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';

export default function AbsDataSourceTest() {

  describe('AbsDataSourceTest', () => {
    const TAG: string = 'common_AbsDataSource';
    //测试addLoadingListener_when_LoadingListener_is_valid
    it('addLoadingListener_when_LoadingListener_is_valid', 0, () => {
      let windowSize = 10;
      let isDataSourceMode = true;
      let mediaDataSource: MediaDataSource = new MediaDataSource(windowSize, undefined, isDataSourceMode, undefined);
      let listener: LoadingListener = new PhotoDataSource(new PhotoBrowserStateMachine(), 'albumUri', undefined);
      mediaDataSource.addLoadingListener(listener);
      const loadingListeners: LoadingListener[] = Reflect.get(mediaDataSource, 'loadingListeners');
      expect(loadingListeners.length !== 0).assertTrue();
    });

    //测试removeLoadingListener_when_listener_is_not_null
    it('removeLoadingListener_when_listener_is_not_null', 0, () => {
      let windowSize = 10;
      let isDataSourceMode = true;
      let mediaDataSource: MediaDataSource = new MediaDataSource(windowSize, undefined, isDataSourceMode, undefined);
      let listener: LoadingListener = new PhotoDataSource(new PhotoBrowserStateMachine(), 'albumUri', undefined);
      mediaDataSource.addLoadingListener(listener);
      mediaDataSource.removeLoadingListener(listener);
      const loadingListeners: LoadingListener[] = Reflect.get(mediaDataSource, 'loadingListeners');
      expect(loadingListeners.length === 0).assertTrue();
    });

  });
}