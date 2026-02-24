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

export interface DownloadListener {
  /**
   * Download finish notice
   *
   * @param uri uri
   */
  onDownloadFinished: (uri: string) => void;

  /**
   * Download stop notification
   *
   * @param uri uri
   */
  onDownloadStoped: (uri: string) => void;

  /**
   * Download failed notification
   *
   * @param uri uri
   * @param err error message
   */
  onDownloadFailed: (uri: string, err: string) => void;

  /**
   * Download progress change notification
   *
   * @param uri uri
   * @param progress progress
   */
  onDownloadProgressChanged: (uri: string, progress: number) => void;
}