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
import lazy { PhotoAsset, UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { BaseItemInfo } from '@ohos.file.PhotoPickerComponent';

const TAG: string = 'third_select_SelectionChecker';

/**
 * 在数据发生变更的场景下，校验选中的图片是否被删除
 */
export class SelectionChecker {
  private readonly manager: ThirdSelectManager | undefined;
  private readonly broadcast: BroadCast | undefined;
  private session: UIExtensionContentSession | undefined;
  private isChecking: boolean = false;
  private hasPending: boolean = false;

  public constructor(manager: ThirdSelectManager | undefined, broadcast: BroadCast | undefined,
    session: UIExtensionContentSession | undefined) {
    this.manager = manager;
    this.broadcast = broadcast;
    this.session = session;
  }

  public async check(): Promise<void> {
    if (this.isChecking) {
      this.hasPending = true;
      return;
    }
    try {
      this.isChecking = true;
      let uris: string[] = await this.manager?.getSelectedUri() ?? [];
      if (uris.length < 1) {
        return;
      }
      let assets: PhotoAsset[] = await UserFileManagerAccess.getInstance().getPhotoAssetByUriArray(uris);

      // photoAssets仅包含未删除图片uri
      Log.info(TAG, `selected uris size:${uris.length}, assets size:${assets.length}`);

      // 原已选中uris中，已被删除的进行反选操作，并发送图片选择状态更新信息
      let invalidUris: string[] = uris.filter(
        uri =>!assets.find(item => item.uri === uri) && this.manager?.isSelected(uri) &&
        this.manager?.toggle(uri, false));
      let itemInfos: BaseItemInfo[] = [];
      invalidUris.forEach(uri => {
        this.manager?.updateTotalSelectUris(uri, false);
        this.broadcast?.emit(Constants.UPDATE_SELECTED, [false, uri]);
        itemInfos.push({ uri: uri, });
      });
      this.manager?.updateMediaItemFullState();
      if (itemInfos.length > 0) {
        this.session?.sendData({ 'dataType': 'selectedItemsDeleted', 'selectedItemInfos': itemInfos, });
      }
    } finally {
      this.isChecking = false;
      if (this.hasPending) {
        this.hasPending = false;
        this.check();
      }
    }
  }
}
