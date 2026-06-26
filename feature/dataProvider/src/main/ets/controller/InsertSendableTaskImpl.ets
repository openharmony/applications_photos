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
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { AssetHelper } from '@ohos/common/src/main/ets/default/utils/AssetHelper';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { taskpool } from '@kit.ArkTS';
import lazy { sendableContextManager } from '@kit.AbilityKit';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy ImageProxyDataService from '../database/service/ImageProxyDataService';
import lazy ReminderService, { BatchInsertReminderInfo } from '../database/service/ReminderService';
import lazy DatabaseUtils from '../database/DatabaseUtils';

const TAG: string = 'InsertSendableTask';

const BATCH_SIZE: number = 10;

export interface photoAssetInfoI {
  dateTaken: number,
  dateAdded: number,
}

export class InsertSendableTaskImpl {
  private imageProxyDataService: ImageProxyDataService;
  private reminderService: ReminderService;
  private formId: string;
  private albumUri: string;
  private reminders: BatchInsertReminderInfo[] = [];

  constructor(formId: string, albumUri: string, sendableContext: sendableContextManager.SendableContext) {
    Log.info(TAG, `InsertSendableTaskImpl construct, formId = ${formId}, albumUri = ${albumUri}`);
    this.formId = formId;
    this.albumUri = albumUri;

    const context: Context = sendableContextManager.convertToContext(sendableContext);
    this.reminderService = new ReminderService(context);
    this.imageProxyDataService = new ImageProxyDataService(context);
  }

  async process(result: photoAccessHelper.PhotoAsset[], uriExistFlag: boolean[]): Promise<void> {
    for (let i = 0; i < result.length; i++) {
      if (taskpool.Task.isCanceled()) {
        Log.info(TAG, `formId: ${this.formId}, sendable task has been canceled`);
        return;
      }
      Log.info(TAG, `insert index: ${i} uriExistFlag = ${uriExistFlag[i]} formId = ${this.formId}`);
      const photoAssetInfo: photoAssetInfoI = this.getAssetDates(result[i]);
      let reminder: BatchInsertReminderInfo | undefined = undefined;
      if (!uriExistFlag[i]) {
        reminder = await this.processAssetThumbnail(result[i], photoAssetInfo);
      } else {
        reminder =
          { imageUri: result[i].uri, dateTaken: photoAssetInfo.dateTaken, dateAdded: photoAssetInfo.dateAdded };
      }
      Log.info(TAG, `get reminder index: ${i}, reminder = ${JSON.stringify(reminder)} formId = ${this.formId}`);
      if (!reminder) {
        Log.info(TAG, `get reminder is undefined, continue. index: ${i}, formId = ${this.formId}`);
        continue;
      }
      this.reminders.push(reminder);

      if (i % BATCH_SIZE === 0) {
        await this.insertReminders();
      }
    }
    if (taskpool.Task.isCanceled()) {
      Log.info(TAG, `formId: ${this.formId}, sendable task has been canceled`);
      return;
    }
    await this.insertReminders();
  }

  private getAssetDates(asset: photoAccessHelper.PhotoAsset): photoAssetInfoI {
    const dateTaken: number = Number(AssetHelper.get(asset, UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS, 0));
    const dateAdded: number = Number(AssetHelper.get(asset, UserFileManagerAccess.FILE_KEY_DATE_ADDED_MS, 0));
    return { dateTaken, dateAdded };
  }

  private async processAssetThumbnail(asset: photoAccessHelper.PhotoAsset,
    photoAssetInfo: photoAssetInfoI): Promise<BatchInsertReminderInfo | undefined> {
    try {
      Log.info(TAG, `getThumbnailData uri = ${asset.uri} formId = ${this.formId}`);
      const pixelMapData = await asset.getThumbnailData(photoAccessHelper.ThumbnailType.LCD);
      Log.info(TAG, `pixelMapData = ${pixelMapData.byteLength} formId = ${this.formId}`);

      if (taskpool.Task.isCanceled()) {
        Log.info(TAG, `formId: ${this.formId}, sendable task has been canceled`);
        return undefined;
      }

      const pixelBase64 = await DatabaseUtils.bufferToBase64(pixelMapData);
      Log.info(TAG, `pixelBase64 = ${pixelBase64.length} formId = ${this.formId}`);
      const insertNum = await this.imageProxyDataService.insert(asset, pixelBase64, true);
      Log.info(TAG,
        `imageProxyDataService insert insertNum = ${insertNum} uri = ${asset.uri} formId = ${this.formId}`);
      if (insertNum !== undefined) {
        return { imageUri: asset.uri, dateTaken: photoAssetInfo.dateTaken, dateAdded: photoAssetInfo.dateAdded };
      }
    } catch (error) {
      Log.error(TAG,
        `insert error = ${error?.code}, message = ${error?.msg} uri = ${asset.uri} formId = ${this.formId}`);
      return undefined;
    }
    return undefined;
  }

  private async insertReminders(): Promise<void> {
    if (this.reminders.length > 0) {
      Log.info(TAG, `reminders batchinsert begin formId = ${this.formId}`);
      const insertNO = await this.reminderService.batchInsert(this.formId, this.albumUri, this.reminders);
      this.reminders = [];
      Log.info(TAG, `reminders batchinsert end insertNO = ${insertNO} formId = ${this.formId}`);
    }
  }
}
