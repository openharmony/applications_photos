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

import type image from '@ohos.multimedia.image';
import type { MediaItem } from '../MediaItem';

/**
 * 图片请求创建者
 *
 * @since 2023-10-17
 */
export class Builder {
  /**
   *
   */
  public albumUri: string | undefined = undefined;
  /**
   * 媒体数据
   */
  public item: MediaItem | undefined = undefined;
  /**
   * 缩略图uri
   */
  public uri: string = '';
  /**
   * 是否走新接口获取数据
   */
  public isNewApi: boolean = false;
  /**
   * 解码选项
   */
  public options: image.DecodingOptions | undefined = undefined;
  /**
   * 是否作为缩略图解码，解码时使用getThumbnail接口，使用已生成的缩略图缓存加速解码，但是可能效果较差
   */
  public isThumbnail: boolean = false;

  /**
   * 设置相册uri
   *
   * @param albumUri 相册uri
   * @returns Builder
   */
  public setAlbum(albumUri: string): Builder {
    this.albumUri = albumUri;
    return this;
  }

  /**
   * 设置元数据
   *
   * @param item 元数据
   * @returns Builder
   */
  public setItem(item: MediaItem): Builder {
    this.item = item;
    return this;
  }

  /**
   * 设置uri
   *
   * @param uri uri
   * @returns Builder
   */
  public setUri(uri: string): Builder {
    this.uri = uri;
    return this;
  }

  /**
   * 设置解码参数
   *
   * @param options 参数
   * @returns Builder
   */
  public setOptions(options: image.DecodingOptions): Builder {
    this.options = options;
    return this;
  }

  /**
   * 设置是否以缩略图方式解码
   *
   * @param isThumbnail 是否缩略图
   * @returns Builder
   */
  public setIsThumbnail(isThumbnail: boolean): Builder {
    this.isThumbnail = isThumbnail;
    return this;
  }

  /**
   * 设置是否是隐藏相册的大图
   *
   * @param isNewApi 是否需要新接口获取数据
   * @returns Builder
   */
  public setIsNewApi(isNewApi: boolean): Builder {
    this.isNewApi = isNewApi;
    return this;
  }

  /**
   * 创建ImageRequest
   *
   * @returns ImageRequest
   */
  public build(): ImageRequest {
    return new ImageRequest(this);
  }
}

/**
 * 图片请求
 *
 * @since 2023-10-17
 */
export class ImageRequest {
  /**
   *
   */
  readonly albumUri: string | undefined = '';
  /**
   * 媒体数据
   */
  readonly item: MediaItem | undefined = undefined;
  /**
   * 解码uri
   */
  readonly uri: string = '';
  /**
   * 解码选项
   */
  readonly options: image.DecodingOptions | undefined = undefined;
  /**
   * 是否作为缩略图解码，解码时使用getThumbnail接口，使用已生成的缩略图缓存加速解码，但是可能效果较差
   */
  readonly isThumbnail: boolean = false;
  /**
   * 是否需要使用新接口获取数据
   */
  readonly isNewApi: boolean = false;

  /**
   * 构造函数
   *
   * @param builder 创建者
   */
  constructor(reqBuilder: Builder) {
    let builder: Builder = reqBuilder ? reqBuilder : new Builder();
    if (!builder.item) {
      throw new Error(`invalid builder: ${JSON.stringify(builder)}`);
    }
    if (builder.albumUri) {
      this.albumUri = builder.albumUri;
    }
    this.item = builder.item;
    this.uri = builder.uri;
    this.options = builder.options;
    this.isThumbnail = builder.isThumbnail;
    this.isNewApi = builder.isNewApi;
  }
}