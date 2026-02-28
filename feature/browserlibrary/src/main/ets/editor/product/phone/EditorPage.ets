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

import lazy { EditorMain } from '@oh-image-editor/editor-phone/src/main/ets/component/enter/EditorPage'
import lazy { ImageEditorMsg, ImageEditorParams, ImageEditorStatus } from '../../common/ImageEditorSDK'


@Component
export struct EditorMainPhone {
  // 外部传入参数
  params: ImageEditorParams | undefined = undefined // 工程初始化参数
  @ObjectLink status: ImageEditorStatus // 编辑组件界面状态控制
  onMessageCallback = (msg: ImageEditorMsg): boolean => { // 消息回调函数
    return false;
  }

  build() {
    // 图片编辑组件
    EditorMain({
      params: this.params,
      status: this.status,
      onMessageCallback: this.onMessageCallback,
    })
  }
}