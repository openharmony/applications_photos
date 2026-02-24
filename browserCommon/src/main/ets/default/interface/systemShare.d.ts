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

import type Want from '@ohos.app.ability.Want';
import type common from '@ohos.app.ability.common';

/**
 * Provide methods make the host (data owner) application can conveniently wrap shared data,
 * make show the system share panel.
 *
 * @namespace systemShare
 * @syscap SystemCapability.Collaboration.SystemShare
 * @since 4.1.0(11)
 */
declare namespace systemShare {
  export class SharedData {
    constructor(record: SharedRecord);

    addRecord(record: SharedRecord): void;

    getRecords(): Array<SharedRecord>;
  }

  export interface SharedRecord {
    utd: string;
    content?: string;
    uri?: string;
    title?: string;
    label?: string;
    description?: string;
    thumbnail?: Uint8Array;
    extraData?: Record<string, Object>;
    thumbnailUri?: string;
  }

  export interface AlbumInfo {
    uri: string;
    unionAlbumUris?: string[];
    order: 'asc' | 'desc';
    orderBy: string;
    initialIndex?: number;
    albumType?: number;
    albumSubtype?: number;
    cameraShotKey?: string;
  }

  export interface Offset {
    x: number;
    y: number;
  }

  export interface Size {
    width: number;
    height: number;
  }

  export interface ShareControllerAnchor {
    windowOffset: Offset;
    size?: Size;
  }

  export enum SharePreviewMode {
    DEFAULT = 0,
    DETAIL
  }

  export enum SelectionMode {
    SINGLE = 0,

    BATCH = 1,

    MULTIPLE = 2,

    ALBUM = 3
  }

  enum ShareAbilityResultCode {
    ERROR = -1,
    BACK = 0,
    CLOSE = 1,
    UPDATE = 2,
  }

  enum ShareAbilityType {
    COPY_TO_PASTEBOARD = 0,
    SAVE_TO_MEDIA_ASSET = 1,
    SAVE_AS_FILE = 2,
    PRINT = 3,
    SAVE_TO_SUPERHUB = 4
  }

  interface SharedDataSummary {
    summary: Record<string, number>;
    fileExtensionSummary: Record<string, number>;
    totalCount: number;
    totalSize: string | number;
  }

  export interface AlbumDataShareSource {
    shareId?: string;
    shareTime: number;
    assetsUri: string;
    initialIndex: number;
    selectedAssetsUri: string;
    selectedSummary: SharedDataSummary;
    tableName?: string;
    assetsTotalCount: number;
  }

  export interface ShareControllerOptions {
    selectionMode?: SelectionMode;
    anchor?: ShareControllerAnchor | string;
    previewMode?: SharePreviewMode;
    albumInfo?: AlbumInfo;
    excludedAbilities?: Array<ShareAbilityType>;
    hasSandboxFile?: boolean;
    albumDataShareSource?: AlbumDataShareSource;
  }

  export class ShareController {
    constructor(data: SharedData);

    show(context: common.UIAbilityContext, options: ShareControllerOptions): Promise<void>;

    on(event: 'canceled', callback: () => void): void;

    off(event: 'canceled', callback: () => void): void;
  }

  export interface ContactInfo {
    contactType: string;
    contactId: string;
  }

  export function getSharedData(want: Want): Promise<SharedData>;

  export function getWant(data: SharedData, options?: ShareControllerOptions): Promise<Want>;

  export function getContactInfo(want: Want): Promise<ContactInfo>;
}

export default systemShare;