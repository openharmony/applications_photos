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
import { AlbumPhotoGridVm } from '@ohos/timeline/src/main/ets/albumgrid/viewmodel/AlbumPhotoGridVm';

export default function AlbumPhotoGridVmTest(): void {

  describe('AlbumPhotoGridVmTest', (): void => {

    // 测试setNavPathStack函数
    it('should_set_navPathStack_when_navPathStack_is_not_null', 0, () => {
      let vm: AlbumPhotoGridVm = new AlbumPhotoGridVm();
      let newNavPathStack: NavPathStack = new NavPathStack();
      vm.setNavPathStack(newNavPathStack);
      let updatedPathStack: NavPathStack = Reflect.get(vm, 'navPathStack');
      expect(updatedPathStack).assertEqual(newNavPathStack);
    });

  });
}

