
/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { MenuContext } from '@ohos/base/src/main/ets/operation/MenuContext';
import { MenuOperation } from '@ohos/base/src/main/ets/operation/MenuOperation';
import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast'
import { ThirdDeleteOperation } from '@ohos/base/src/main/ets/operation/ThirdDeleteOperation';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { CustomDialogView } from '../common/view/dialog/CustomDialogView';
import dialogRequest from '@ohos.app.ability.dialogRequest';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import { getIdFromUri } from '@ohos/base/src/main/ets/utils/StringUtil';
import { MediaConstants } from '@ohos/base/src/main/ets/constants/MediaConstants';
import { GlobalContext } from '@ohos/base/src/main/ets/utils/GlobalContext';

const TAG: string = 'ResourceDeletePage';

@Entry
@Component
struct ResourceDeletePage {
  @Provide broadCast: Broadcast = new Broadcast();

  isShow: boolean = false;
  mediaDataItems: MediaDataItem[];

  onPageShow() {
    if (this.isShow) {
      return;
    }
    this.isShow = true;
    Log.info(TAG, 'onPageShow');
    let menuOperation: MenuOperation;
    let menuContext: MenuContext = new MenuContext();
    this.onOperationEnd = this.onOperationEnd.bind(this);
    this.onOperationCancel = this.onOperationCancel.bind(this);
    menuContext
      .withItems(this.mediaDataItems)
      .withOperationEndCallback(this.onOperationEnd)
      .withOperationCancelCallback(this.onOperationCancel)
      .withBroadCast(this.broadCast);
    menuOperation = new ThirdDeleteOperation(menuContext);
    menuOperation.doAction()
  }

  private getMediaItems(): MediaDataItem[] {
    let uris: [] = AppStorage.Get('uris');
    Log.error(TAG, `aboutToAppear uris : ${JSON.stringify(uris)}`);
    let mediaDataItems: MediaDataItem[] = [];
    if (uris != undefined && uris.length > 0) {
      uris.forEach((uri: string, index: number) => {

        let nullArray: string[] = [];
        let mediaDataItem: MediaDataItem = new MediaDataItem("",nullArray,"",1);
        mediaDataItem.id =  getIdFromUri(uri);
        mediaDataItem.status = MediaConstants.PART_LOADED;
        mediaDataItems.push(mediaDataItem);
      });
    }
    return mediaDataItems;
  }

  aboutToAppear() {
    this.mediaDataItems = this.getMediaItems();
  }

  aboutToDisappear() {
    Log.info(TAG, 'aboutToDisappear');
  }

  build() {
     Column() {

      CustomDialogView()
        .width('100%')
        .height('100%');
    }
    .backgroundColor("#00000000")
    .height('100%');
  }

  onOperationEnd () {
    this.setDeleteResult(dialogRequest.ResultCode.RESULT_OK);
  }

  onOperationCancel () {
    this.setDeleteResult(dialogRequest.ResultCode.RESULT_CANCEL);
  }

  private setDeleteResult(result: dialogRequest.ResultCode) {
    Log.info(TAG, `start to setDeleteResult : ${result}}`);
    try {
      var requestCallback = AppStorage.Get("requestCallback");
      let myResult = {
        result: result,
      }
      // @ts-ignore
      requestCallback.setRequestResult(myResult);
      GlobalContext.getContext().getObject("photoAbilityContext").terminateSelf();
    } catch(err) {
      Log.info(TAG, `getRequestInfo err : ${JSON.stringify(err)}`);
    }
  }
}