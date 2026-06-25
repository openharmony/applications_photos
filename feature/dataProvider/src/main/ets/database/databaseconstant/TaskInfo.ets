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
import lazy { ValuesBucket } from '@kit.ArkData';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { AlbumType } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { FaCardInfo } from '../service/FaCardService';
import lazy { AlbumType as FATableAlbumType } from './FaCardTable'

const QUERY_START = '?';

export enum TaskUri {
  TASK_CREATE_FACARD_URI = 'datashare:///hmos_photodata/task_create_facard', // 创建卡片

  TASK_ADD_FACARD_URI = 'datashare:///hmos_photodata/task_add_facard', // 添加卡片

  TASK_DELETE_FACARD_URI = 'datashare:///hmos_photodata/task_delete_facard', // 删除卡片

  TASK_UPDATE_FACARD_URI = 'datashare:///hmos_photodata/task_update_facard', // 卡片数据刷新（30分钟）

  TASK_RESTORE_FACARD_URI = 'local:///hmos_photodata/task_restore_facard', // 恢复卡片

  TASK_SELECT_ALBUM_URI = 'local:///hmos_photodata/task_select_album', // 选择相册

  TASK_SELECT_PHOTO_URI = 'local:///hmos_photodata/task_select_photo', // 选择单张图片

  TASK_MEDIA_UPDATE_ALBUM_URI = 'local:///hmos_photodata/task_media_update_album', // 媒体库触发相册刷新

  TASK_SWITCH_CLOUD = 'local:///hmos_photodata/task_switch_cloud', // 媒体库触发云同步开关

  TASK_REFRESH_FACARD = 'local:///hmos_photodata/task_refresh_facard', // 异常通知刷新
}

const taskUriSet = new Set(Object.values(TaskUri));

export function isTaskUri(uri: string): boolean {
  return taskUriSet.has(uri as TaskUri);
}

export function buildUri(uri: string, query: string = ''): string {
  return uri + `${QUERY_START}${query}`;
}

export function getFormId(uri: string): string {
  return uri?.split(QUERY_START)[1] ?? '';
}

// 以taskUri标识task，定义task的优先级值，越大优先级越高，同级则后进的优先级更高
export const taskPriority: Map<string, number> = new Map([
  [TaskUri.TASK_CREATE_FACARD_URI, 0],
  [TaskUri.TASK_ADD_FACARD_URI, 0],
  [TaskUri.TASK_RESTORE_FACARD_URI, 5],
  [TaskUri.TASK_REFRESH_FACARD, 5],
  [TaskUri.TASK_UPDATE_FACARD_URI, 10],
  [TaskUri.TASK_MEDIA_UPDATE_ALBUM_URI, 10],
  [TaskUri.TASK_SWITCH_CLOUD, 10],
  [TaskUri.TASK_SELECT_ALBUM_URI, 20],
  [TaskUri.TASK_SELECT_PHOTO_URI, 20],
  [TaskUri.TASK_DELETE_FACARD_URI, 50],
]);

// task所需要的参数
export interface Task {
  formId: string;
  taskUri: TaskUri;
  values?: ValuesBucket;
  album?: AlbumInfo;
  albumUri?: string;
  albumType?: AlbumType;
  interval?: number;
  faCardInfo?: FaCardInfo;
  formDimension?: string;
  recordStartTime?: number;
  faTableAlbumType?: FATableAlbumType;
  playbackInterval?: number;
  photoUris?: string[];
}