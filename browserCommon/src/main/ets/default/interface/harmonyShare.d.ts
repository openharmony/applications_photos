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

import lazy { Callback } from '@kit.BasicServicesKit';
import lazy { systemShare } from './index';

/**
 * Provide methods make the host (data owner) application can conveniently wrap shared data,
 * make show the system share panel.
 *
 * @namespace systemShare
 * @syscap SystemCapability.Collaboration.SystemShare
 * @since 4.1.0(11)
 */
declare namespace harmonyShare {
  export enum SharableErrorCode {
    NO_CONTENT_ERROR = 1,
    NO_INTERNET_ERROR = 2,
    DOWNLOAD_ERROR = 3,
    EMPTY_SHARE_CONTENT_ERROR = 4,
    FORMAT_UNSUPPORT_ERROR = 5,
  }

  export enum ReceivableErrorCode {
    NO_RECEIVABLE_ERROR = 1,
  }

  export interface SharableTarget {
    share(data: systemShare.SharedData): Promise<void>;
    reject(error: number): Promise<void>;
  }

  export interface ReceivableTarget {
    receive(path: ReceivePath, callback: ReceiveCallback): Promise<void>;
    reject(error: ReceivableErrorCode): Promise<void>;
  }

  export interface RecvCapabilityRegistry {
    windowId?: number;
  }

  export interface ReceivePath {
    receiveFolderUri: string;
  }

  export interface TransmitProgressInfo {
    completedSize: number;
    totalSize: number;
  }

  interface FailedReason {
    message: string;
  }

  export interface TransferResults {
    onFinished?: Callback<void>;
    onFailed?: Callback<FailedReason>;
  }

  export interface ReceiveCallback extends TransferResults {
    onDataReceived: Callback<systemShare.SharedData>;
  }

  export interface SendCapabilityRegistry {
    windowId?: number;
  }

  export function on(event: 'knockShare', callback: Callback<SharableTarget>): void;

  export function off(event: 'knockShare', callback?: Callback<SharableTarget>): void;

  export function on(event: 'knockShare', sendOption: SendCapabilityRegistry, callback: Callback<SharableTarget>): void;

  export function off(event: 'knockShare', sendOption: SendCapabilityRegistry, callback?: Callback<SharableTarget>): void;

  export function on(event: 'receive', regCap: RecvCapabilityRegistry, callback: Callback<ReceivableTarget>): void;

  export function off(event: 'receive', regCap: RecvCapabilityRegistry, callback?: Callback<ReceivableTarget>): void;
}

export default harmonyShare;