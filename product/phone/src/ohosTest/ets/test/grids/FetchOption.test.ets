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

import { describe, it, expect } from '@ohos/hypium';
import { FileFetchOptionBuilder } from '@ohos/common/src/main/ets/default/model/FetchOption';

export default function FetchOptionBuilderTest() {
  describe('FetchOptionBuilderTest', () => {

    it('should_add_GROUP_BY_KEY_to_fetchColumns_when_groupBy_is_called', 0, () => {
      let fileFetchOptionBuilder: FileFetchOptionBuilder = new FileFetchOptionBuilder();
      fileFetchOptionBuilder.groupBy();
      let fetchOption = fileFetchOptionBuilder.build();
      expect(fetchOption.fetchColumns.length >= 1).assertTrue();
    });

  });
}