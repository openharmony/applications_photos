/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { Constants } from '../../model/common/Constants';
import { Log } from '../../utils/Log';
import type { MenuOperation } from './MenuOperation';
import { MenuContext } from './MenuContext';
import type { AsyncCallback } from '../../model/common/AsyncCallback';
import { SelectManager } from '../../model/browser/SelectManager';
import { MediaItem } from '../../model/browser/photo/MediaItem';
import { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import { UiUtil } from '../../utils/UiUtil';
import { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import common from '@ohos.app.ability.common';

const TAG: string = 'common_ShareMenuOperation';

export class ShareMenuOperation implements MenuOperation, AsyncCallback<MediaItem[]> {
  private static readonly ACTION_PHOTOS_SHARE_DATA: string = 'ability.ACTION_PHOTOS_SHARE_DATA';
  private static readonly SHARE_TYPE_IMAGE: string = 'image/*';
  private static readonly SHARE_TYPE_VIDEO: string = 'video/*';
  private static readonly SHARE_TYPE_MULTIPLE: string = 'application/*';
  private pickerWant: any = {
    deviceId: '',
    bundleName: '',
    abilityName: '',
    uri: '',
    type: '',
    action: 'ohos.want.action.select',
    parameters: {
      'ability.picker.type': '',
      'ability.picker.text': '',
      'ability.picker.uri': '',
      'ability.picker.fileNames': [],
      'ability.picker.fileSizes': [],
      'ability.want.params': {
        'action': ShareMenuOperation.ACTION_PHOTOS_SHARE_DATA,
        'parameters': {
          'ability.params.streams': []
        }
      }
    }
  };
  private menuContext: MenuContext;
  private hasImage: boolean = false;
  private hasVideo: boolean = false;
  private fileNames: string[] = [];
  private fileSizes: number[] = [];
  private uris: string[] = [];

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  doAction(): void {
    if (this.menuContext == null || this.menuContext.fromSelectMode == null) {
      Log.error(TAG, 'cannot get fromSelectMode, return');
      return;
    }
    if (this.menuContext.fromSelectMode) {
      let selectManager: SelectManager = this.menuContext.selectManager;
      if (selectManager != null) {
        let count = selectManager.getSelectedCount();
        if (count <= 0) {
          Log.error(TAG, 'count <= 0, return');
          return;
        }
        selectManager.getSelectedItems(this.callback.bind(this));
      } else {
        Log.error(TAG, 'select mode not have manager.');
      }
    } else {
      let mediaItem: MediaItem = this.menuContext.mediaItem;
      if (mediaItem != null) {
        this.callback([mediaItem]);
      } else {
        Log.error(TAG, 'single mode not have item.');
      }
    }
  }

  callback(items: MediaItem[]): void {
    Log.info(TAG, `share file length is ${items.length}`);
    if (items.length > Constants.DEFAULT_MAX_SHARE_COUNT) {
      UiUtil.showToast($r('app.string.number_of_shared_exceeds_the_limit_tips'))
      return;
    }
    let imageCount: number = 0;
    let videoCount: number = 0;
    for (let i = 0; i < items.length; i++) {
      let item = items[i];
      Log.debug(TAG, `share item${i}: ${JSON.stringify(item)}`);
      if (item.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        videoCount++;
        this.hasVideo = true;
      } else if (item.mediaType == UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
        imageCount++;
        this.hasImage = true;
      }
      this.fileNames[i] = this.getTitle(item);
      this.fileSizes[i] = item.size;
      this.uris[i] = item.uri;
    }
    let want = this.getParameters();
    this.reportToBigData(want.parameters['ability.picker.type'], imageCount, videoCount);
    let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext');
    context.startAbility(want);
  }

  private reportToBigData(shareType: string, imageCount: number, videoCount: number): void {
    let count: number = 1;
    if (AppStorage.get('click_share_count') != null) {
      let oldCount: number = AppStorage.get('click_share_count');
      count = oldCount + 1;
    }
    AppStorage.setOrCreate('click_share_count', count);
    let msg = {
      'count': count,
      'shareType': shareType,
      'imageCount': imageCount,
      'videoCount': videoCount,
    }
    ReportToBigDataUtil.report(BigDataConstants.MULTI_SHARE_ID, msg);
  }

  private getParameters(): any {
    let newWant = this.pickerWant;
    newWant.parameters['ability.picker.type'] = this.getShareType();
    newWant.parameters['ability.picker.fileNames'] = this.fileNames;
    newWant.parameters['ability.picker.fileSizes'] = this.fileSizes;
    newWant.parameters['ability.want.params'].parameters['ability.params.streams'] = this.uris;
    Log.debug(TAG, `newWant: ${JSON.stringify(newWant)}`);
    return newWant;
  }

  private getTitle(item: MediaItem): string {
    let title = item.getTitle();
    if (!!title) {
      return title;
    }
    if (!!item.displayName) {
      return item.displayName.substr(0, item.displayName.lastIndexOf('.'));
    }
    return '';
  }

  private getShareType(): string {
    let shareType = ShareMenuOperation.SHARE_TYPE_MULTIPLE;
    if (this.hasVideo && this.hasImage) {
      shareType = ShareMenuOperation.SHARE_TYPE_MULTIPLE;
    } else if (this.hasVideo || this.hasImage) {
      if (this.hasVideo) {
        shareType = ShareMenuOperation.SHARE_TYPE_VIDEO;
      } else {
        shareType = ShareMenuOperation.SHARE_TYPE_IMAGE;
      }
    } else {
      shareType = ShareMenuOperation.SHARE_TYPE_MULTIPLE;
    }
    Log.info(TAG, `shareType: ${shareType}, hasVideo: ${this.hasVideo}, hasImage: ${this.hasImage}`);
    return shareType;
  }
}