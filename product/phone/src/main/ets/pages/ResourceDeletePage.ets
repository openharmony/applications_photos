
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
import {
  MenuContext ,
  ThirdDeleteOperation ,
  MenuOperationFactory,
  Log ,
  BroadCast,
  SelectManager ,
  MediaObserver
} from '@ohos/common';
import { CustomDialogView } from '@ohos/common/CommonComponents';
import { MenuOperation } from '@ohos/common';
import dialogRequest from '@ohos.app.ability.dialogRequest';
import uri from '@ohos.uri';
import common from '@ohos.app.ability.common';

const TAG: string = 'ResourceDeletePage';

@Entry
@Component
struct ResourceDeletePage {
  @Provide broadCast: BroadCast = new BroadCast();

  isShow: boolean = false;
  selectManager: SelectManager = new SelectManager();

  onPageShow() {
    if (this.isShow) {
      return;
    }
    this.isShow = true;
    Log.info(TAG, 'onPageShow');
    let menuOperation: MenuOperation;
    let menuContext: MenuContext;
    menuContext = new MenuContext();
    menuContext
      .withSelectManager(this.selectManager)
      .withOperationEndCallback((): void => this.onOperationEnd())
      .withOperationCancelCallback((): void => this.onOperationCancel())
      .withBroadCast(this.broadCast);
    menuOperation = MenuOperationFactory.getInstance()
      .createMenuOperation(ThirdDeleteOperation, menuContext);
    menuOperation.doAction();
  }

  aboutToAppear() {
    this.selectManager = new SelectManager();
    let uris: string[] | undefined = AppStorage.get<string[]>('uris');
    Log.info(TAG, 'aboutToAppear uris : ' + JSON.stringify(uris));
    if (!uris?.length) {
      return;
    }
    uris.forEach((uri: string): void => {
      if (this.selectManager !== null && !this.selectManager.clickedSet.has(uri)) {
        this.selectManager.clickedSet.add(uri);
      }
    })
  }

  aboutToDisappear() {
    Log.info(TAG, 'aboutToDisappear');
    MediaObserver.getInstance().unregisterForAllPhotos();
    MediaObserver.getInstance().unregisterForAllAlbums();
  }

  build() {
     Column() {

      CustomDialogView({ broadCast: $broadCast})
        .width('100%')
        .height('100%');
    }
    .backgroundColor('#00000000')
    .height('100%');
  }

  onOperationEnd () {
    this.setDeleteResult(dialogRequest.ResultCode.RESULT_OK);
  }

  onOperationCancel () {
    this.setDeleteResult(dialogRequest.ResultCode.RESULT_CANCEL);
  }

  private setDeleteResult(result: dialogRequest.ResultCode): void {
    Log.info(TAG, 'start to setDeleteResult : ' + result);
    try {
      (AppStorage.get<dialogRequest.RequestCallback>('requestCallback') as dialogRequest.RequestCallback).setRequestResult({ result });
      (AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext).terminateSelf();
    } catch (err) {
      Log.info(TAG, `getRequestInfo err= ${JSON.stringify(err)}`);
    }
  }
}