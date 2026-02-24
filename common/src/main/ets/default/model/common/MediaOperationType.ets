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

export class MediaOperationType {
  public static readonly ADD = 'Media_add';
  public static readonly MOVE = 'Media_move';
  public static readonly COPY = 'Media_copy';
  public static readonly REMOVE = 'Media_remove';
  public static readonly DELETE = 'Media_delete';
  public static readonly DOWNLOAD = 'Media_download';
  public static readonly RECOVER = 'Media_recover';
  public static readonly NEW = 'Media_new';
}