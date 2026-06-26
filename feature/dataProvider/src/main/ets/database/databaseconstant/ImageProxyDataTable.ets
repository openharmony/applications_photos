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
export enum ImageProxyDataTable {
  TABLE_NAME = 'image_proxy_data',

  ID = 'id',

  // 图片uri 如果是时刻封面还需在后面拼接时刻相册uri 例: xxx.jpg?album_uri:xxx
  URI = 'uri',

  BLOB = 'photo_blob',

  BOUND = 'photo_bound',
}