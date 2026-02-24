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
import lazy {
  PhotoBrowserStateMachine
} from '@ohos/browsercommon/src/main/ets/default/viewModel/statemachine/PhotoBrowserStateMachine';
import lazy { ThumbnailVM } from './ThumbnailVM';
import lazy { CameraThumbnailVM } from './CameraThumbnailVM';
import lazy { BrowserCaller } from './ShowBrowserParam';
import { PhotosThumbnailVM } from './PhotosThumbnailVM';

export class ThumbnailVMFactory {
  public static getThumbnailVM(stateMachine: PhotoBrowserStateMachine, pageFrom: string): ThumbnailVM {
    /* instrument ignore next */
    if (pageFrom === BrowserCaller.CAMERA_PAGE) {
      return new CameraThumbnailVM(stateMachine);
    } else {
      return new PhotosThumbnailVM(stateMachine);
    }
  }
}