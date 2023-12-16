/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import SmartPickerConstants from './SmartPickerConstants';

export default class SmartPickerRecommendInfo {
  private recommendType: number = SmartPickerConstants.INVALID;
  private labelId: string = '';
  private recommendContent: string = '';
  private albumUri: string = '';
  private totalCount: number = SmartPickerConstants.INVALID;

  constructor() {
  }

  public getRecommendType(): number {
    return this.recommendType;
  }

  public setRecommendType(recommendType: number): void {
    this.recommendType = recommendType;
  }

  public getLabelId(): string {
    return this.labelId;
  }

  public setLabelId(labelId: string): void {
    this.labelId = labelId;
  }

  public getRecommendContent(): string {
    return this.recommendContent;
  }

  public setRecommendContent(recommendContent: string): void {
    this.recommendContent = recommendContent;
  }

  public getAlbumUri(): string {
    return this.albumUri;
  }

  public setAlbumUri(albumUri: string): void {
    this.albumUri = albumUri;
  }

  public getTotalCount(): number {
    return this.totalCount;
  }

  public setTotalCount(totalCount: number): void {
    this.totalCount = totalCount;
  }
}