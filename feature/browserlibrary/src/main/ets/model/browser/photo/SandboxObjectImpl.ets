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

import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';

export interface SandboxObjectImpl {

  fileAsset?: photoAccessHelper.PhotoAsset;
  photoData?: PhotoData;
  isMediaSource?: boolean;

}

export class PhotoData {
  public index?: number;
  /**
   * 文件类型,for example, IMAGE, VIDEO, AUDIO
   */
  public mediaType?: photoAccessHelper.PhotoType;
  /**
   * URI of the file.
   */
  public uri?: string;
  /**
   * thumbnail to show
   */
  public thumbnail?: string;
  /**
   * 在类型是Video或Audio时的播放时长
   */
  public duration?: number;
  /**
   * 文件大小字节数
   */
  public size?: number;
  /**
   * 图片分辨率的宽度
   */
  public width?: number;
  /**
   * 图片分辨率的高度
   */
  height?: number;
  /**
   * 在图库详情中的显示名称
   */
  displayName?: string;
  /**
   * fileAsset path data
   */
  path?: string;
  /**
   * Title of the file
   */
  title?: string;
  /**
   * 资源创建时间
   */
  dateTaken?: number;
  /**
   * 畅连资源是否在加载中（畅连点击预览时，视频资源可能正在下载中）
   */
  public isResourceLoading?: boolean;
  /**
   * 畅连资源唯一标识
   */
  public resourceId?: number;
}