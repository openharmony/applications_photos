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
export enum RemindersTable {
  TABLE_NAME = 'Reminders',

  ID = '_id',

  FORM_ID = 'form_id',

  IMAGE_URI = 'image_uri',

  SHOW_TIME = 'show_time',

  ALBUM_URI = 'album_uri',

  IS_HIDDEN = 'is_hidden',

  DATE_TAKEN = 'date_taken',

  DATE_ADDED = 'date_added',

  /**
   * 只保留image_uri到id的部分
   * image_uri: file://media/Photo/4436/IMG_1745737925_4426/IMG_20250426_120837.jpg
   * image_uri_id: file://media/Photo/4436
   */
  IMAGE_URI_ID = 'image_uri_id',
}

export const REMINDER_DEFAULT_VALUE: Record<string, number | string> = {
  '_id': 1,
  'form_id': 10000,
  'minutes': 100000
}

export class ReminderTableConstants {
  public static readonly IS_HIDDEN: string = '1';
  public static readonly NOT_HIDDEN: string = '0';
}