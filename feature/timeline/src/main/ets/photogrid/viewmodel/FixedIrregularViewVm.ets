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

/* instrument ignore file */

import lazy { AbstractVm } from './AbstractVm';
import lazy { IrregularType } from '../statemanager/constants/GridDefine';
import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { common } from '@kit.AbilityKit';

const TAG: string = 'FixedIrregularViewVm';

/**
 * 固定不规则区域视图模型
 */
export class FixedIrregularViewVm extends AbstractVm {
  private isBetaClubNotExist: boolean | undefined;
  private isShowDuplicateAlbum: boolean = AppStorage.get<boolean>('isShowDuplicateAlbum') ?? false;
  private clickTimesForDuplicateAlbum: number = 0;

  constructor() {
    super('FixedIrregularViewVm');
  }

  protected override doInit(persistentId: number): void {
    super.doInit(persistentId);
  }

  /**
   * 更新不滚动消息的headHeight数据
   */
  public updateMsgHeight(newHeight: number = 0) {
    this.gridStateManager.updateIrregularTypeHeight(IrregularType.FIXED_IRREGULAR,
      newHeight, this.tag);
  }

  /**
   * 删除提示语点击触发重复照片处理功能
   */
  public onTrashMessageClick() {
    // 如果已经启动了重复照片处理功能（或者终端没有安装betaClub应用），直接返回，不用再处理
    if (this.isShowDuplicateAlbum || this.isBetaClubNotExist) {
      return;
    }

    // 记录最近10次连续点击版本链接的时间
    this.clickTimesForDuplicateAlbum++;
    LogUtils.info(TAG, `countClickForDuplicateAlbum count=${this.clickTimesForDuplicateAlbum}`);

    // 10秒内连续点击了10次，触发启动重复照片处理功能（需要先判断安装了betaClub后）
    if (this.clickTimesForDuplicateAlbum >= Constants.CLICK_TIMES_THRESHOLD_FOR_DUPLICATE) {
      this.markDuplicateByConnectBetaClub();
    }
  }

  private markDuplicateByConnectBetaClub(): void {
    try {
      let context = LocalStorage.getShared().get<Context>('photosAbilityContext') as common.UIAbilityContext;
      let want: Want = {
        bundleName: Constants.ABILITY_BETA_CLUB,
        abilityName: 'MainAbility',
      };
      let markDuplicateCallback = (isBetaClubNotExist: boolean) => {
        if (isBetaClubNotExist) {
          // 如果BetaClub应用没有安装，则标记后面不需要再去判断是否安装（重新进入界面变量重置后会再次判断）
          this.isBetaClubNotExist = true;
        } else {
          // 如果BetaClub应用安装了，则启动重复照片功能
          this.isShowDuplicateAlbum = true;
          AppStorage.setOrCreate<boolean>('isShowDuplicateAlbum', true);
        }
      }
      let options: common.ConnectOptions = {
        onConnect(_elementName, _remote) {
          // 启动重复照片功能
          markDuplicateCallback(false);
          LogUtils.info(TAG, 'connectServiceExtensionAbility onConnect...');
        },
        onDisconnect(_elementName) {
        },
        onFailed(code) {
          markDuplicateCallback(code === Constants.ERROR_CODE_ABILITY_NOT_EXIST);
          LogUtils.info(TAG, `connectServiceExtensionAbility onFailed... ${code}`);
        }
      };
      let connection: number = context.connectServiceExtensionAbility(want, options);
      context.disconnectServiceExtensionAbility(connection);
    } catch (error) {
      LogUtils.error(TAG, `markDuplicateByConnectBetaClub error: ${error}, code: ${error?.code}`);
    }
  }
}