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
export class MediaData {
  public formId: string = '0';
  public albumName: string = '';
  public albumUri: string = '';
  public currentUri: string = '';
  public currentIndex: number = 0;
  public isShowAlbum: number = 0;

  /* instrument ignore file */
  constructor(formId: string, albumName: string, albumUri: string,
              currentUri: string, currentIndex: number, isShowAlbum: number) {
    this.formId = formId;
    this.albumName = albumName;
    this.albumUri = albumUri;
    this.currentUri = currentUri;
    this.currentIndex = currentIndex;
    this.isShowAlbum = isShowAlbum;
  }
}
