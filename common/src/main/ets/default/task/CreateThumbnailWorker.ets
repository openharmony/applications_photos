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

import lazy { CommonContext } from '../model/browser/photo/TimelineDataManager';
import lazy { dataSharePredicates } from '@kit.ArkData';
import lazy { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import lazy { Log } from '../utils/Log';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy {
  START_CREATE_THUMBNAIL_TASK,
  STOP_CREATE_THUMBNAIL_TASK,
  UserFileManagerAccess
} from '../access/UserFileManagerAccess';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

const TAG: string = 'CreateThumbnailWorker';

// 缩略图全部生成
const ALL_THUMBNAIL_READY = -2307;

const START_CREATE_THUMBNAIL_TASK_DURATION: number = 1000;

let readyRequestId: number = 0;

let readyTimerId: number = 0;

let isProcessingReady: boolean = false;

/**
 * 主线程发送消息后，worker线程的处理函数
 *
 * @param messageEvents 主线程发送的消息内容
 */
/* instrument ignore file */
workerPort.onmessage = (messageEvents: MessageEvents) => {
  if (!messageEvents || !messageEvents.data || !messageEvents.data.message || !messageEvents.data.context) {
    Log.error(TAG, 'onmessage, invalid message!');
    return;
  }

  Log.info(TAG, `onmessage, message is ${messageEvents.data.message}`);
  if (messageEvents.data.message === START_CREATE_THUMBNAIL_TASK) {
    startCreateThumbnailTaskAsync(messageEvents.data.context, messageEvents.data.orderDesc);
  } else if (messageEvents.data.message === STOP_CREATE_THUMBNAIL_TASK) {
    stopCreateThumbnailTaskAsync(messageEvents.data.context);
  }
}

/**
 * 当收到无法反序列化的消息时的回调函数
 *
 * @param e message data
 */
workerPort.onmessageerror = (e: MessageEvents) => {
  Log.error(TAG, 'onmessageerror');
}

/**
 * 当worker线程产生运行错误时的回调函数
 *
 * @param e error message
 */
workerPort.onerror = (e: ErrorEvent) => {
  Log.error(TAG, `onerror: ${e.message}`);
}

async function startCreateThumbnailTaskAsync(
  context: CommonContext,
  orderDesc: photoAccessHelper.PhotoKeys = UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS
): Promise<void> {
  if (readyTimerId !== 0) {
    Log.info(TAG, 'startCreateThumbnailTaskAsync readyTimerId != 0');
    return;
  }
  if (!context) {
    Log.error(TAG, 'startCreateThumbnailTaskAsync context undefined');
    return;
  }

  let photoHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
  if (!photoHelper) {
    Log.error(TAG, 'startCreateThumbnailTaskAsync photoAccessHelper undefined');
    return;
  }

  readyTimerId = setInterval(() => {
    if (readyRequestId === ALL_THUMBNAIL_READY) {
      Log.info(TAG, 'all thumbnail are ready');
      clearInterval(readyTimerId);
      readyTimerId = 0;

      photoHelper.stopCreateThumbnailTask(readyRequestId);
      readyRequestId = 0;
      isProcessingReady = false;
      clearInterval(readyTimerId);
      readyTimerId = 0;
      workerPort.postMessage({ isProcessingReady: isProcessingReady });
      return;
    }
    if (readyRequestId !== 0) {
      Log.debug(TAG, 'readyRequestId != 0, no need to startCreateThumbnailTaskAsync again.');
      return;
    }

    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    Log.debug(TAG, `startCreateThumbnailTask order by ${orderDesc}`)
    predicates.orderByDesc(orderDesc);
    readyRequestId = photoHelper.startCreateThumbnailTask(predicates, () => {
      Log.info(TAG, 'startCreateThumbnailTask callback');
      resetReadyRequestId();
    });
    Log.info(TAG, `startCreateThumbnailTaskAsync requestId: ${readyRequestId}`);
  }, START_CREATE_THUMBNAIL_TASK_DURATION);
  isProcessingReady = true;
  workerPort.postMessage({ isProcessingReady: isProcessingReady });
}

function stopCreateThumbnailTaskAsync(context: CommonContext): void {
  if (!context) {
    Log.error(TAG, 'stopCreateThumbnailTaskAsync context undefined');
    return;
  }

  let photoHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
  if (!photoHelper) {
    Log.error(TAG, 'stopCreateThumbnailTaskAsync photoAccessHelper undefined');
    return;
  }
  if (readyTimerId === 0) {
    Log.info(TAG, 'stopCreateThumbnailTaskAsync no need to clear thumbnail task interval');
    return;
  }

  clearInterval(readyTimerId);
  readyTimerId = 0;
  Log.info(TAG, `stopCreateThumbnailTaskAsync requestId: ${readyRequestId}`);
  photoHelper.stopCreateThumbnailTask(readyRequestId);
  readyRequestId = 0;
  isProcessingReady = false;
  workerPort.postMessage({ isProcessingReady: isProcessingReady });
}

function resetReadyRequestId(): void {
  readyRequestId = 0;
}