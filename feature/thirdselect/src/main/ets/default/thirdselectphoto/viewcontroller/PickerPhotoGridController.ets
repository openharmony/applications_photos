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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { PickerMediaDataSource } from '../../common/PickerMediaDataSource';
import lazy { PickerDataSourceManager } from '../../common/PickerDataSourceManager';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { UIExtensionContentSession, uriPermissionManager } from '@kit.AbilityKit';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { BusinessError } from '@ohos.base';
import lazy HashMap from '@ohos.util.HashMap';
import lazy { SelectInfo } from '../../view/ThirdSelectPhotoGridBase';
import lazy {
  MediaObserverNfyInfo
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { SelectionChecker } from '../../../default/model/SelectionChecker';
import lazy { AlbumChecker } from '../../../default/model/AlbumChecker';
import lazy { HeadTailPosition, PositionInfo } from '@ohos/common/src/main/ets/default/model/common/DataTypes';
import { HashSet } from '@kit.ArkTS';

const TAG = 'PickerPhotoGridController';


export class PickerPhotoGridController {

  public selectionChecker: SelectionChecker | undefined = undefined;
  public albumChecker: AlbumChecker | undefined = undefined;
  public isShowPickerWarnDialog: Boolean = false;
  public headTailPosition: HeadTailPosition = {
    headPosition: undefined,
    tailPosition: undefined,
  };

  public dataSource: PickerMediaDataSource = new PickerDataSourceManager().getDataSource();
  public isOnItemClickedSet: boolean = false;
  public param?: SelectParams;
  public photoPermissionMap: HashMap<string, number> = new HashMap<string, number>();
  public selectInfoList: SelectInfo[] = [];
  public preData: HashSet<string> = new HashSet();
  private context: Context;
  private storage: LocalStorage;

  constructor(context: Context, storage: LocalStorage) {
    this.context = context;
    this.storage = storage;
  }

  public hidePickerWarningDialog: Function = () => {
    this.isShowPickerWarnDialog = false;
  }

  public getTokenId(): number {
    let tokenId: number = this.param?.tokenId ?? 0;
    return tokenId;
  }

  public setSelectInfoList(list: SelectInfo[]): void {
    this.selectInfoList = list;
  }

  public async grantUriPermissionAndSendData(key: string, value: boolean): Promise<void> {
    let storage = this.storage;
    let session: UIExtensionContentSession | undefined =
      storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
    let params = storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY);
    if (session) {
      Log.info(TAG, 'grantUriPermissionAndSendData start to execute');
      if (value) {
        // 0表示授权成功，1表示已有权限，-1表示授权失败
        const tokenId: number = this.getTokenId();
        Log.info(TAG, `grantPermissionForUris start, tokenId:${tokenId}`);
        let permissionState: number | undefined =
          await PhotoAccessHelperAccess.grantPermissionForUri(this.context, tokenId, key);
        Log.info(TAG, `grantPermissionForUris end, uri:${key}, result:${permissionState}`);
        // 记录图片授权结果
        this.photoPermissionMap.set(key, permissionState ?? -1);
      } else {
        this.revokePermissionByUri(key, params?.bundleName);
      }
      this.handleSendSelectData(key, session, value);
    }
  }

  public getPhotoAccessHelper(): photoAccessHelper.PhotoAccessHelper {
    return photoAccessHelper.getPhotoAccessHelper(this.context);
  }

  public async revokePermissionByUri(uri: string, bundleName?: string): Promise<void> {
    Log.info(TAG, `revokePermissionByUri, uri:${uri}, permission state:${this.photoPermissionMap.get(uri)}`);
    // instrument ignore if
    if (this.photoPermissionMap.get(uri) == 1 || this.preData.has(uri)) {
      // 仅对首次授权的图片需要取消授权，历史已授权图片无需取消授权
      return;
    }
    const tokenId: number = this.getTokenId();
    Log.info(TAG, `revokePermissionByUri, tokenId:${tokenId}`);
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper = this.getPhotoAccessHelper();
    phAccessHelper.cancelPhotoUriPermission(
      tokenId, uri, photoAccessHelper.PhotoPermissionType.PERSISTENT_READ_IMAGEVIDEO)
      .then((result) => {
        Log.info(TAG, `revokePermissionByUri, uri:${uri}, result:${result}`);
        // 0表示取消授权成功，-1表示取消授权失败
        // instrument ignore next
        if (result === 0) {
          // 取消授权，删除权限记录
          this.photoPermissionMap.remove(uri);
        }
      }).catch((error: BusinessError) => {
        Log.error(TAG, `revokePermissionByUri has error: ${error}, code: ${error?.code}`);
      }).finally(() => {
        phAccessHelper?.release();
      });
    uriPermissionManager.revokeUriPermission(uri, bundleName).then(() => {
      Log.info(TAG, `ReceiveDataCallback: revokeUriPermission ${bundleName}`);
    }).catch(() => {
      Log.info(TAG, 'ReceiveDataCallback: revokeUriPermission: Verification failed.');
    })
  }

  public handleSendSelectData(key: string, session: UIExtensionContentSession | undefined, isSelect: boolean): void {
    if (!isSelect) {
      this.sendSelectData(key, session, false);
      return;
    }
    Log.info(TAG, `handleSendSelectData: lenght:${this.selectInfoList?.length}`);
    // 因为授权是异步的，谁先完成授权不可知，这段处理逻辑是为了按选择顺序发送数据
    for (let item of this.selectInfoList) {
      if (item.uri === key) {
        Log.info(TAG, 'handleSendSelectData item.state === 1');
        item.state = 1; // 代表已授权
        break;
      }
    }
    for (let item of this.selectInfoList) {
      if (item.state === 0) { // 代表未授权
        Log.info(TAG, 'handleSendSelectData item.state === 0');
        continue;
      }
      if (item.state === 2) { // 代表已发送
        Log.info(TAG, 'handleSendSelectData item.state === 2');
        continue;
      }
      item.state = 2;
      this.sendSelectData(item.uri, session, true);

      // 注册了isOnItemClickedSet回调的，在调用方给我们返回选择结果的回调里去更新this.selectInfoList，否则在此处更新
      if (!this.isOnItemClickedSet) {
        this.selectInfoList = this.selectInfoList.filter((item: SelectInfo) => {
          return item?.uri !== key;
        })
      }
    }
  }


  public sendSelectData(key: string, session: UIExtensionContentSession | undefined, isSelect: boolean): void {
    if (this.isOnItemClickedSet) {
      Log.info(TAG, `sendSelectData, uri:${key}`);
      let mediaItem: MediaItem | undefined = this.dataSource.getMediaItemByUri(key);
      for (let info of this.selectInfoList) {
        if (info.uri === key && info.item ) {
          Log.info(TAG, `sendSelectData, get item form selectInfoList`);
          mediaItem = info.item;
          break;
        }
      }
      session?.sendData({
        'dataType': 'itemClick',
        'itemType': 'thumbnail',
        'clickType': isSelect ? 'select' : 'deselect',
        'uri': key,
        'mimeType': mediaItem?.mimeType,
        'width': mediaItem?.width,
        'height': mediaItem?.height,
        'size': mediaItem?.size,
        'duration': mediaItem?.duration ?? -1
      });
      if (!isSelect) {
        Log.info(TAG, `selectOrDeselect, uri:${key}`);
        session?.sendData({ 'dataType': 'selectOrDeselect', 'select-item-list': key, 'isSelect': isSelect });
      }
    } else {
      Log.info(TAG, `selectOrDeselect, uri:${key} isSelect:${isSelect}`);
      session?.sendData({ 'dataType': 'selectOrDeselect', 'select-item-list': key, 'isSelect': isSelect });
    }
  }

}