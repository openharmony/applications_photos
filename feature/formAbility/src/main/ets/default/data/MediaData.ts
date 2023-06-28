/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
  formId: string = '0';
  albumName: string = '';
  albumUri: string = '';
  displayName: string = '';
  currentUri: string = '';
  currentIndex: number = 0;
  intervalTime: number = 0;
  //数据持久化保存布尔型目前存在问题，使用数字类型保存。
  //isShowAlbum: true or 1 is displaying Album; false or 0 is displaying a Picture
  isShowAlbum: number = 0;
  arkUri: number = 0;
  orientation: number = 0;

  constructor(formId: string, displayName: string, albumName: string,
              albumUri: string, currentUri: string, currentIndex: number,
              intervalTime: number, isShowAlbum: number, arkUri: number) {
    this.formId = formId;
    this.albumUri = albumUri;
    this.displayName = displayName;
    this.albumName = albumName;
    this.currentUri = currentUri;
    this.currentIndex = currentIndex;
    this.intervalTime = intervalTime;
    this.isShowAlbum = isShowAlbum;
    this.arkUri = arkUri;
  }
}
