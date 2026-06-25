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

import type { MediaObserverCallback, MediaObserverNfyInfo } from './dataObserver/MediaObserverCallback';

interface MediaCallback {
  onMediaLibDataChange(mediaType: string): void;

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void;
}

export class CommonObserverCallback implements MediaObserverCallback {
  public source: MediaCallback;

  constructor(source: MediaCallback) {
    this.source = source;
  }

  public onChange(mediaType: string): void {
    this.source.onMediaLibDataChange(mediaType);
  }

  public onNotify(nfyInfo: MediaObserverNfyInfo): void {
    this.source.onMediaLibDataNfy(nfyInfo);
  }
}