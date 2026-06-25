/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License"),
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

/**
 * @file
 * @kit CoreFileKit
 */

import type { AsyncCallback, Callback } from './@ohos.base';

/**
 * Provides the capabilities to control cloud file synchronization.
 *
 * @namespace cloudSync
 * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
 * @since 11
 */
declare namespace cloudSync {
  /**
   * Describes the Sync state type.
   *
   * @enum { number }
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @since 12
   */
  enum SyncState {
    /**
     * Indicates that the sync state is uploading.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    UPLOADING,
    /**
     * Indicates that the sync failed in upload processing.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    UPLOAD_FAILED,
    /**
     * Indicates that the sync state is downloading.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    DOWNLOADING,
    /**
     * Indicates that the sync failed in download processing.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    DOWNLOAD_FAILED,
    /**
     * Indicates that the sync finish.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    COMPLETED,
    /**
     * Indicates that the sync has been stopped.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    STOPPED
  }

  /**
   * Describes the Sync Error type.
   *
   * @enum { number }
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @since 12
   */
  enum ErrorType {
    /**
     * No error occurred.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    NO_ERROR,
    /**
     * Synchronization aborted due to network unavailable.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    NETWORK_UNAVAILABLE,
    /**
     * Synchronization aborted due to wifi unavailable.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    WIFI_UNAVAILABLE,
    /**
     * Synchronization aborted due to low capacity level.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    BATTERY_LEVEL_LOW,
    /**
     * Synchronization aborted due to warning low capacity level.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    BATTERY_LEVEL_WARNING,
    /**
     * Synchronization aborted due to cloud storage is full.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    CLOUD_STORAGE_FULL,
    /**
     * Synchronization aborted due to local storage is full.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    LOCAL_STORAGE_FULL,
    /**
     * Synchronization aborted due to device temperature is too high.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    DEVICE_TEMPERATURE_TOO_HIGH,
    
  }

  /**
   * The SyncProgress data structure.
   *
   * @interface SyncProgress
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @since 12
   */
  interface SyncProgress {
    /**
     * The current sync state.
     *
     * @type { SyncState }
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    state: SyncState;
    /**
     * The error type of sync.
     *
     * @type { ErrorType }
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    error: ErrorType;
  }

  /**
   * GallerySync object.
   *
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @systemapi
   * @since 10
   */
  class GallerySync {
    /**
     * A constructor used to create a GallerySync object.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    constructor();
    /**
     * Subscribes to sync progress change event. This method uses a callback to get sync progress changes.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { 'progress' } evt - event type.
     * @param { function } callback - callback function with a `SyncProgress` argument.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    on(evt: 'progress', callback: (pg: SyncProgress) => void): void;
    /**
     * Unsubscribes from sync progress event.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { 'progress' } evt - event type.
     * @param { function } callback - callback function with a `SyncProgress` argument.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    off(evt: 'progress', callback: (pg: SyncProgress) => void): void;
    /**
     * Unsubscribes all callbacks objects from sync progress event.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { 'progress' } evt - event type.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    off(evt: 'progress'): void;
    /**
     * Start the gallery sync task.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @returns { Promise<void> } - Return Promise.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:Incorrect parameter types.
     * @throws { BusinessError } 22400001 - Cloud status not ready.
     * @throws { BusinessError } 22400002 - Network unavailable.
     * @throws { BusinessError } 22400003 - Low battery level.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    start(): Promise<void>;
    /**
     * Start the gallery sync task with callback.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { AsyncCallback<void> } [callback] - Callback function.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 22400001 - Cloud status not ready.
     * @throws { BusinessError } 22400002 - Network unavailable.
     * @throws { BusinessError } 22400003 - Low battery level.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    start(callback: AsyncCallback<void>): void;
    /**
     * Stop the gallery sync task.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @returns { Promise<void> } - Return Promise.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:Incorrect parameter types.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    stop(): Promise<void>;
    /**
     * Stop the gallery sync task with callback.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { AsyncCallback<void> } [callback] - Callback function.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    stop(callback: AsyncCallback<void>): void;
  }

  /**
   * Describes the State type of download.
   *
   * @enum { number }
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @since 11
   */
  enum State {
    /**
     * Indicates that the download task in process now.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    RUNNING,
    /**
     * Indicates that the download task finished.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    COMPLETED,
    /**
     * Indicates that the download task failed.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    FAILED,
    /**
     * Indicates that the download task stopped.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    STOPPED
  }

  /**
   * Describes the download Error type.
   *
   * @enum { number }
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @since 11
   */
  enum DownloadErrorType {
    /**
     * No error occurred.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    NO_ERROR,
    /**
     * download aborted due to unknown error.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    UNKNOWN_ERROR,
    /**
     * download aborted due to network unavailable.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    NETWORK_UNAVAILABLE,
    /**
     * download aborted due to local storage is full.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    LOCAL_STORAGE_FULL,
    /**
     * download aborted due to content is not found in the cloud.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    CONTENT_NOT_FOUND,
    /**
     * download aborted due to frequent user requests.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    FREQUENT_USER_REQUESTS,
  }

  /**
   * The DownloadProgress data structure.
   *
   * @interface DownloadProgress
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @since 11
   */
  interface DownloadProgress {
    /**
     * The current download state.
     *
     * @type { State }
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    state: State;
    /**
     * The processed data size for current file.
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    processed: number;
    /**
     * The size of current file.
     *
     * @type { number }
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    size: number;
    /**
     * The uri of current file.
     *
     * @type { string }
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    uri: string;
    /**
     * The error type of download.
     *
     * @type { DownloadErrorType }
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    error: DownloadErrorType;
  }

  /**
   * Download object.
   *
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @systemapi
   * @since 10
   */
  class Download {
    /**
     * A constructor used to create a Download object.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    constructor();
    /**
     * Subscribes to download progress change event. This method uses a callback to get download progress changes.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { 'progress' } evt - event type.
     * @param { function } callback - callback function with a `DownloadProgress` argument.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    on(evt: 'progress', callback: (pg: DownloadProgress) => void): void;
    /**
     * Unsubscribes from download progress event.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { 'progress' } evt - event type.
     * @param { function } callback - callback function with a `DownloadProgress` argument.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    off(evt: 'progress', callback: (pg: DownloadProgress) => void): void;
    /**
     * Unsubscribes all callbacks objects from download progress event.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { 'progress' } evt - event type.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    off(evt: 'progress'): void;
    /**
     * Start the download task.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { string } uri - uri of file.
     * @returns { Promise<void> } - Return Promise.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13900002 - No such file or directory.
     * @throws { BusinessError } 13900025 - No space left on device.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    start(uri: string): Promise<void>;
    /**
     * Start the download task with callback.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { string } uri - uri of file.
     * @param { AsyncCallback<void> } [callback] - Callback function.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13900002 - No such file or directory.
     * @throws { BusinessError } 13900025 - No space left on device.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    start(uri: string, callback: AsyncCallback<void>): void;
    /**
     * Stop the download task.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { string } uri - uri of file.
     * @returns { Promise<void> } - Return Promise.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    stop(uri: string): Promise<void>;
    /**
     * Stop the download task with callback.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { string } uri - uri of file.
     * @param { AsyncCallback<void> } [callback] - Callback function.
     * @throws { BusinessError } 201 - Permission verification failed.
     * @throws { BusinessError } 202 - The caller is not a system application.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 10
     */
    stop(uri: string, callback: AsyncCallback<void>): void;
  }

  /**
   * FileSync object.
   *
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @since 12
   */
  class FileSync {
    /**
     * A constructor used to create a FileSync object.
     *
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:Incorrect parameter types.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    constructor();
    /**
     * A constructor used to create a FileSync object.
     *
     * @param { string } bundleName - Name of the bundle that need to synchronize and subscribe the sync progress event.
     * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 12
     */
    constructor(bundleName: string);
    /**
     * Subscribes to sync progress change event. This method uses a callback to get sync progress changes.
     *
     * @param { 'progress' } event - event type.
     * @param { Callback<SyncProgress> } callback - callback function with a `SyncProgress` argument.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    on(event: 'progress', callback: Callback<SyncProgress>): void;
    /**
     * Unsubscribes from sync progress event.
     *
     * @param { 'progress' } event - event type.
     * @param { Callback<SyncProgress> } [callback] - callback function with a `SyncProgress` argument.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    off(event: 'progress', callback?: Callback<SyncProgress>): void;
    /**
     * Start the file sync task.
     *
     * @returns { Promise<void> } - Return Promise.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error.
     * @throws { BusinessError } 22400001 - Cloud status not ready.
     * @throws { BusinessError } 22400002 - Network unavailable.
     * @throws { BusinessError } 22400003 - Low battery level.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    start(): Promise<void>;
    /**
     * Start the file sync task with callback.
     *
     * @param { AsyncCallback<void> } callback - Callback function.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error.
     * @throws { BusinessError } 22400001 - Cloud status not ready.
     * @throws { BusinessError } 22400002 - Network unavailable.
     * @throws { BusinessError } 22400003 - Low battery level.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    start(callback: AsyncCallback<void>): void;
    /**
     * Stop the file sync task.
     *
     * @returns { Promise<void> } - Return Promise.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    stop(): Promise<void>;
    /**
     * Stop the file sync task with callback.
     *
     * @param { AsyncCallback<void> } callback - Callback function.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    stop(callback: AsyncCallback<void>): void;
    /**
     * Get the last synchronization time.
     *
     * @returns { Promise<number> } - Return the date of last synchronization.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    getLastSyncTime(): Promise<number>;
    /**
     * Get the last synchronization time.
     *
     * @param { AsyncCallback<number> } callback - Callback function.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    getLastSyncTime(callback: AsyncCallback<number>): void;
  }
  /**
   * CloudFileCache object.
   *
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @since 11
   */
  class CloudFileCache {
    /**
     * A constructor used to create a CloudFileCache object.
     *
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:Incorrect parameter types.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    constructor();
    /**
     * Subscribes to cloud file cache download progress change event. This method uses a callback to get download progress changes.
     *
     * @param { 'progress' } event - event type.
     * @param { Callback<DownloadProgress> } callback - callback function with a `DownloadProgress` argument.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    on(event: 'progress', callback: Callback<DownloadProgress>): void;
    /**
     * Unsubscribes from cloud file cache download progress event.
     *
     * @param { 'progress' } event - event type.
     * @param { Callback<DownloadProgress> } [callback] - callback function with a `DownloadProgress` argument.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    off(event: 'progress', callback?: Callback<DownloadProgress>): void;

    /**
     * Start the cloud file cache download task.
     *
     * @param { string } uri - uri of file.
     * @returns { Promise<void> } - Return Promise.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error.
     * @throws { BusinessError } 13900002 - No such file or directory.
     * @throws { BusinessError } 13900025 - No space left on device.
     * @throws { BusinessError } 14000002 - Invalid URI.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    start(uri: string): Promise<void>;
    /**
     * Start the cloud file cache download task with callback.
     *
     * @param { string } uri - uri of file.
     * @param { AsyncCallback<void> } callback - Callback function.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error.
     * @throws { BusinessError } 13900002 - No such file or directory.
     * @throws { BusinessError } 13900025 - No space left on device.
     * @throws { BusinessError } 14000002 - Invalid URI.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    start(uri: string, callback: AsyncCallback<void>): void;
    /**
     * Stop the cloud file cache download task.
     *
     * @param { string } uri - uri of file.
     * @returns { Promise<void> } - Return Promise.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error.
     * @throws { BusinessError } 13900002 - No such file or directory.
     * @throws { BusinessError } 14000002 - Invalid URI.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    /**
     * Stop the cloud file cache download task.
     *
     * @param { string } uri - uri of file.
     * @param { boolean } [needClean] - whether to delete the file that already downloaded.
     * @returns { Promise<void> } - Return Promise.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error.
     * @throws { BusinessError } 13900002 - No such file or directory.
     * @throws { BusinessError } 14000002 - Invalid URI.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    stop(uri: string, needClean?: boolean): Promise<void>;
    /**
     * Stop the cloud file cache download task with callback.
     *
     * @param { string } uri - uri of file.
     * @param { AsyncCallback<void> } callback - Callback function.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error.
     * @throws { BusinessError } 13900002 - No such file or directory.
     * @throws { BusinessError } 14000002 - Invalid URI.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 11
     */
    stop(uri: string, callback: AsyncCallback<void>): void;
    /**
     * Clean the local file cache.
     *
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @param { string } uri - uri of file.
     * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
     * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
     * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
     * <br>2.Incorrect parameter types.
     * @throws { BusinessError } 13600001 - IPC error.
     * @throws { BusinessError } 13900002 - No such file or directory.
     * @throws { BusinessError } 14000002 - Invalid URI.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 11
     */
    cleanCache(uri: string): void;
  }

  /**
   * Describes the sync state of file.
   *
   * @enum { number }
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @systemapi
   * @since 11
   */
  enum FileSyncState {
    /**
     * Indicates that the file cache is uploading now.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 11
     */
    UPLOADING,
    /**
     * Indicates that the file cache is downloading now.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 11
     */
    DOWNLOADING,
    /**
     * Indicates that the file cache sync task finished.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 11
     */
    COMPLETED,
    /**
     * Indicates that the file cache sync task stopped.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 11
     */
    STOPPED,
    /**
     * Indicates that the file is waiting for upload.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 12
     */
    TO_BE_UPLOADED,
    /**
     * Indicates that the file has been already uploaded successfully.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 12
     */
    UPLOAD_SUCCESS,
    /**
     * Indicates that the file upload failure.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 12
     */
    UPLOAD_FAILURE,
  }

  /**
   * Get the sync state of file.
   *
   * @permission ohos.permission.CLOUDFILE_SYNC
   * @param { Array<string> } uri - uri of files.
   * @returns { Promise<Array<FileSyncState>> } - Return the sync state of given files.
   * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
   * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
   * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
   * <br>2.Incorrect parameter types.
   * @throws { BusinessError } 13600001 - IPC error.
   * @throws { BusinessError } 13900002 - No such file or directory.
   * @throws { BusinessError } 14000002 - Invalid URI.
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @systemapi
   * @since 11
   */
  function getFileSyncState(uri: Array<string>): Promise<Array<FileSyncState>>;
  /**
   * Get the sync state of file.
   *
   * @permission ohos.permission.CLOUDFILE_SYNC
   * @param { Array<string> } uri - uri of file.
   * @param { AsyncCallback<Array<FileSyncState>> } callback - The callback is used to return the sync state of given files.
   * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
   * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
   * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
   * <br>2.Incorrect parameter types.
   * @throws { BusinessError } 13600001 - IPC error.
   * @throws { BusinessError } 13900002 - No such file or directory.
   * @throws { BusinessError } 14000002 - Invalid URI.
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @systemapi
   * @since 11
   */
  function getFileSyncState(uri: Array<string>, callback: AsyncCallback<Array<FileSyncState>>): void;
  /**
   * Get the sync state of file.
   *
   * @param { string } uri - uri of file.
   * @returns { FileSyncState } - return the sync state of given files.
   * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
   * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
   * <br>2.Incorrect parameter types.
   * @throws { BusinessError } 13900002 - No such file or directory.
   * @throws { BusinessError } 13900004 - Interrupted system call
   * @throws { BusinessError } 13900010 - Try again
   * @throws { BusinessError } 13900012 - Permission denied by the file system
   * @throws { BusinessError } 13900031 - Function not implemented
   * @throws { BusinessError } 13900042 - Unknown error 
   * @throws { BusinessError } 14000002 - Invalid URI.
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @systemapi
   * @since 12
   */
  function getFileSyncState(uri: string): FileSyncState;
  /**
   * Register change notify for the specified uri.
   *
   * @param { string } uri - uri of file.
   * @param { boolean } recursion - Whether to monitor the child files.
   * @param { Callback<ChangeData> } callback - Returns the changed data.
   * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
   * <br>2.Incorrect parameter types.
   * @throws { BusinessError } 13900001 - Operation not permitted
   * @throws { BusinessError } 13900002 - No such file or directory.
   * @throws { BusinessError } 13900012 - Permission denied
   * @throws { BusinessError } 14000002 - Invalid URI.
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @since 12
   */
  function registerChange(uri: string, recursion: boolean, callback: Callback<ChangeData>): void;
  /**
   * Unregister change notify fir the specified uri.
   *
   * @param { string } uri - uri of file.
   * @throws { BusinessError } 401 - The input parameter is invalid.Possible causes:1.Mandatory parameters are left unspecified;
   * <br>2.Incorrect parameter types.
   * @throws { BusinessError } 13900001 - Operation not permitted
   * @throws { BusinessError } 13900002 - No such file or directory.
   * @throws { BusinessError } 13900012 - Permission denied
   * @throws { BusinessError } 14000002 - Invalid URI.
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @since 12
   */
  function unregisterChange(uri: string): void;

  /**
   * Enumeration types of data change.
   *
   * @enum { number } NotifyType
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @since 12
   */
  enum NotifyType {
    /**
     * File has been newly created
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    NOTIFY_ADDED,
    /**
     * File has been modified.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    NOTIFY_MODIFIED,
    /**
     * File has been deleted.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    NOTIFY_DELETED,
    /**
     * File has been renamed or moved.
     *
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    NOTIFY_RENAMED
  }

  /** 
   * Defines the change data
   * 
   * @interface ChangeData
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @since 12
   */
  interface ChangeData {
    /**
     * The notify type of the change.
     * 
     * @type {NotifyType}
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    type: NotifyType;
    /**
     * Indicates whether the changed uri is directory.
     * 
     * @type {Array<boolean>}
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    isDirectory: Array<boolean>;
    /**
     * The changed uris.
     * 
     * @type {Array<string>}
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @since 12
     */
    uris: Array<string>;
  }

  /**
   * Optimize storage space
   *
   * @permission ohos.permission.CLOUDFILE_SYNC
   * @returns { Promise<void> } - Return Promise.
   * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
   * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
   * <br>2.Incorrect parameter types.
   * @throws { BusinessError } 13600001 - IPC error.
   * @throws { BusinessError } 13900042 - Unknown error.
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @systemapi
   * @since 16
   */
  function optimizeStorage(): Promise<void>;

  /**
   * Start optimize storage space task.
   *
   * @permission ohos.permission.CLOUDFILE_SYNC
   * @param { OptimizeSpaceParam } optimizePara - Setting parameters with a `OptimizeSpaceParam` argument.
   * @param { Callback<OptimizeSpaceProgress> } callback - callback function with a `OptimizeSpaceProgress` argument.
   * @returns { Promise<void> } - Return Promise.
   * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
   * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
   * @throws { BusinessError } 401 - Parameter error. Possible causes: 1.Mandatory parameters are left unspecified; 2.Incorrect parameter types.
   * @throws { BusinessError } 13600001 - IPC error.
   * @throws { BusinessError } 22400005 - Inner error.
   * @throws { BusinessError } 22400006 - Other optimize task is running.
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @systemapi
   * @since 16
   */
  function startOptimizeSpace(optimizePara: OptimizeSpaceParam, callback?: Callback<OptimizeSpaceProgress>): Promise<void>;

  /**
   * Stop optimize storage space task.
   *
   * @permission ohos.permission.CLOUDFILE_SYNC
   * @throws { BusinessError } 201 - Permission verification failed, usually the result returned by VerifyAccessToken.
   * @throws { BusinessError } 202 - Permission verification failed, application which is not a system application uses system API.
   * @throws { BusinessError } 13600001 - IPC error.
   * @throws { BusinessError } 22400005 - Inner error.
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @systemapi
   * @since 16
   */
  function stopOptimizeSpace(): void;

  /**
   * Describes the state type of optimize space task.
   * @enum { number } OptimizeState
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @systemapi
   * @since 16
   */
  export enum OptimizeState {

    /**
     * Indicates that the optimize space task in process now.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 16
     */
    RUNNING = 0,

    /**
     * Indicates that the optimize space task finished successfully.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 16
     */
    COMPLETED = 1,

    /**
     * Indicates that the optimize space task failed.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 16
     */
    FAILED = 2,

    /**
     * Indicates that the optimize space task stopped.
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 16
     */
    STOPPED = 3
  }

  /**
   * Defines the OptimizeSpaceProgress data structure.
   * @typedef OptimizeSpaceProgress
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @systemapi
   * @since 16
   */
  declare interface OptimizeSpaceProgress {

    /**
     * The current optimize space task state.
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @type { OptimizeState }
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 16
     */
    state: OptimizeState;

    /**
     * The percentage of clearing files.
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @type { number }
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 16
     */
    progress: number;
  }

  /**
   * Defines the OptimizeSpaceParam data structure.
   * @typedef OptimizeSpaceParam
   * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
   * @systemapi
   * @since 16
   */
  declare interface OptimizeSpaceParam {

    /**
     * The total size(Unit:byte) of clean space.
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @type { number }
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 16
     */
    totalSize: number;

    /**
     * Clean files that are not accessed agingDays(unit:day) ago.
     * @permission ohos.permission.CLOUDFILE_SYNC
     * @type { number }
     * @syscap SystemCapability.FileManagement.DistributedFileService.CloudSync.Core
     * @systemapi
     * @since 16
     */
    agingDays: number;
  }
}

export default cloudSync;
