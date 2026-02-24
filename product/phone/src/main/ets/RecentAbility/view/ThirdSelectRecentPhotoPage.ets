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

import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { AvPlayConstants } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { formatDuration } from '@ohos/common/src/main/ets/default/model/common/DurationFormatter';
import lazy { StringUtil } from '@ohos/common/src/main/ets/default/utils/StringUtil';
import lazy { BundleInfoUtils } from '@ohos/common/src/main/ets/default/utils/BundleInfoUtils';
import lazy { CommonRecentPhotoInfoUtil } from '@ohos/extensions/src/main/ets/default/CommonRecentPhotoInfoStub';
import lazy { PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { PickerColorMode } from '@kit.MediaLibraryKit';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';

let storage = LocalStorage.getShared();

/* instrument ignore file */
const TAG: string = 'ThirdSelectRecentPhotoPage';

// Third Select Recent Photo page
@Entry(storage)
@Component
export struct ThirdSelectRecentPhotoPage {
  @Prop private mediaItem: MediaItem = new MediaItem();
  @Prop private thumbnailUri: string = '';
  @Prop private maxTime: string;
  @State isAutoRefreshSupported: boolean = false;
  private colorMode: PickerColorMode = PickerColorMode.AUTO;
  private dataObserver: CommonObserverCallback | undefined = new CommonObserverCallback(this);
  private isActive: boolean = true;

  onPageShow(): void {
    if (this.isAutoRefreshSupported) {
      this.updatePhoto();
    }
    this.isActive = true;
  }

  aboutToAppear() {
    Log.info(TAG, 'aboutToAppear');
    let media = storage?.get<MediaItem>(Constants.RECENT_PHOTO_MEDIA_ITEM_KEY);
    if (media && media instanceof MediaItem) {
      this.mediaItem = media;
      Log.info(TAG, `mediaItem: ${JSON.stringify(this.mediaItem)}`);
      this.maxTime = formatDuration(Math.floor(this.mediaItem.duration / AvPlayConstants.A_THOUSAND));
      if (this.mediaItem.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
        this.thumbnailUri = `${
        this.mediaItem.uri}?timestampApp=${
        this.mediaItem.getDateModified()}&oper=thumbnail&path=${this.mediaItem.path}`;
        Log.info(TAG, `thumbnailUri:${this.thumbnailUri}`);
      }
    }
    let wantParam: Record<string, Object> =
      storage?.get<Record<string, Object>>(Constants.RECENT_PHOTO_MEDIA_WANT_KEY) as Record<string, Object>;
    this.isAutoRefreshSupported = wantParam?.isAutoRefreshSupported as boolean;
    this.colorMode = wantParam?.colorMode as PickerColorMode;
    Log.info(TAG, `colorMode: ${this.colorMode} isAutoRefreshSupported: ${this.isAutoRefreshSupported}`);
    const msg: Record<string, number | string | boolean> = {
      'AUTO_REFRESH': this.isAutoRefreshSupported,
      'COLOR_MODE': this.colorMode
    }
    ReportToBigDataUtil.report(BigDataConstants.SEND_RECENT_PHOTO, msg);

    if (this.isAutoRefreshSupported) {
      MediaObserver.getInstance().registerObserver(this.dataObserver);
    }
  }

  aboutToDisappear() {
    Log.info(TAG, 'aboutToDisappear');
    if (this.isAutoRefreshSupported) {
      MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    }
  }

  private updatePhoto(): void {
    Log.info(TAG, 'updatePhoto');
    let wantParam: Record<string, Object> =
      storage?.get<Record<string, Object>>(Constants.RECENT_PHOTO_MEDIA_WANT_KEY) as Record<string, Object>;
    let session: UIExtensionContentSession =
      storage?.get<UIExtensionContentSession>(Constants.RECENT_PHOTO_SESSION_KEY) as UIExtensionContentSession;
    let isRecentPhotoCheckResultSet: boolean = wantParam['isRecentPhotoCheckResultSet'] as boolean ?? false;
    let queryUtil: CommonRecentPhotoInfoUtil = new CommonRecentPhotoInfoUtil();
    queryUtil.queryRecentPhoto(wantParam).then((result: MediaItem | undefined) => {
      if (isRecentPhotoCheckResultSet) {
        session.sendData({
          'dataType': 'checkResult', 'isExist': result ? true : false
        });
        session.sendData({
          'dataType': 'checkInfo',
          'isExist': result ? true : false,
          'identifier': result ? PickerUtil.getHash(result.getTitle()) : '',
          'dateTaken': result ? result.getDateTaken() : 0
        });
        Log.info(TAG, `sendData title=: ${result?.getTitle()}, datetaken= ${result?.getDateTaken()}`);
      }
      if (result) {
        Log.info(TAG, `queryRecentPhoto result: ${result.uri}`);
        storage?.setOrCreate(Constants.RECENT_PHOTO_SESSION_KEY, session);
        storage?.setOrCreate(Constants.RECENT_PHOTO_MEDIA_ITEM_KEY, result);
        if (result && result instanceof MediaItem) {
          this.mediaItem = result;
          Log.info(TAG, `mediaItem: ${JSON.stringify(this.mediaItem)}`);
          this.maxTime = formatDuration(Math.floor(this.mediaItem.duration / AvPlayConstants.A_THOUSAND));
          if (this.mediaItem.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
            this.thumbnailUri = `${
            this.mediaItem.uri}?timestampApp=${
            this.mediaItem.getDateModified()}&oper=thumbnail&path=${this.mediaItem.path}`;
            Log.info(TAG, `thumbnailUri:${this.thumbnailUri}`);
          }
        }
      } else {
        this.mediaItem.uri = '';
        Log.info(TAG, 'queryRecentPhoto finished, result is empty.');
      }
    });
  }

  private getColor(): ResourceColor {
    if (this.colorMode === PickerColorMode.LIGHT) {
      return $r('app.color.black');
    } else if (this.colorMode === PickerColorMode.DARK) {
      return $r('app.color.ohos_id_color_white_icon');
    } else {
      return $r('sys.color.icon_primary');
    }
  }

  onPageHide(): void {
    if (this.isAutoRefreshSupported) {
      this.isActive = false;
    }
  }

  private async grantUriPermissionAndSendData(): Promise<void> {
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper =
      photoAccessHelper.getPhotoAccessHelper(getContext(this));
    try {
      let appId: string = storage?.get<string>(Constants.PHOTO_PICKER_APP_ID_KEY) as string ?? '';
      if (StringUtil.isEmpty(appId)) {
        let bundleName: string = storage?.get<string>(Constants.RECENT_PHOTO_APP_BUNDLE_NAME_KEY) as string ?? '';
        appId = await BundleInfoUtils.getAppIdByBundleName(bundleName);
        storage?.setOrCreate(Constants.PHOTO_PICKER_APP_ID_KEY, appId);
      }
      const tokenId = storage?.get<number>(Constants.PHOTO_PICKER_TOKEN_ID_KEY) ?? 0;
      let permissionState: number = await phAccessHelper.grantPhotoUriPermission(
        tokenId,
        this.mediaItem.uri,
        photoAccessHelper.PhotoPermissionType.PERSISTENT_READ_IMAGEVIDEO,
        photoAccessHelper.HideSensitiveType.NO_HIDE_SENSITIVE_TYPE);
      Log.info(TAG, `grantPhotoUriPermission result is ${permissionState}, uri:${this.mediaItem.uri}, appId:${appId}`);
    } catch (error) {
      Log.error(TAG, `grantPhotoUriPermission failed. uri:${this.mediaItem.uri}, ${error}`);
    } finally {
      phAccessHelper?.release();
    }
    this.sendData();
  }

  private sendData(): void {
    let session: UIExtensionContentSession | undefined =
      storage?.get<UIExtensionContentSession>(Constants.RECENT_PHOTO_SESSION_KEY);
    session?.sendData({
      'dataType': 'select',
      'uri': this.mediaItem.uri,
      'mimeType': this.mediaItem.mimeType,
      'width': this.mediaItem.width,
      'height': this.mediaItem.height,
      'size': this.mediaItem.size,
      'duration': this.mediaItem.duration ?? -1
    });
    session?.terminateSelf(() => {
      Log.info(TAG, 'sendData done, session to terminateSelf');
    });
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
    if (this.isActive) {
      this.updatePhoto();
    }
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
  }

  @Builder
  ImageContent() {
    Image(this.mediaItem.uri + '?timestampApp=' + this.mediaItem.getDateModified())
      .accessibilityRole(AccessibilityRoleType.BUTTON)
      .onClick((): void => {
        this.grantUriPermissionAndSendData();
      })
  }

  @Builder
  VideoContent() {
    // 视频
    Stack() {
      // 预览图
      Image(this.thumbnailUri)

      // 蒙层
      Row() {
        Column() {
          Text(this.maxTime)
            .fontSize($r('sys.float.Body_S'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.font_on_primary'))
            .textShadow({ radius: 4, color: 'rgba(0,0,0,0.2)' })
            .margin({ left: 5.5, bottom: 3 })
        }
        .height('33%')
        .width(Constants.FULL_PERCENT)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.End)
        .linearGradient({
          direction: GradientDirection.Bottom,
          colors: [['rgba(0,0,0,0)', 0], ['rgba(0,0,0,0.2)', 1]],
        })
      }.alignItems(VerticalAlign.Bottom).height(Constants.FULL_PERCENT).width(Constants.FULL_PERCENT)
    }
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .onClick((): void => {
      this.grantUriPermissionAndSendData();
    })
  }

  build() {
    Stack() {
      if (this.mediaItem.uri === '' && this.isAutoRefreshSupported) {
        Image($r('app.media.ic_picture_new'))
          .fillColor(this.getColor())
      } else {
        if (this.mediaItem.mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE) {
          this.ImageContent();
        } else {
          this.VideoContent();
        }
      }
    }
  }
}
