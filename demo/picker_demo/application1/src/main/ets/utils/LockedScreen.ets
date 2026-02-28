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
import lazy { tryFunc } from './ErrUtil';
import lazy CommonEventManager from '../utils/CommonEventManager';
import lazy { Log } from './Log';
import lazy Global from './GlobalContext';
import lazy Bundles from '@ohos/tools/src/main/utils/Bundle';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { Timer } from '@ohos/tools/src/main/utils/Timer';
import lazy { Constants } from '../model/common/Constants';

/* instrument ignore file */
const TAG: string = 'LockedScreen';

export class LockedScreen {
  public static instance: LockedScreen = new LockedScreen();
  public isFromLockedScreen: boolean = false;

  public wakenByLockScreen(wantParam: Record<string, Object>): number {
    Global.setBoolean('isShowTabMenu', assert.asDefault(wantParam.isShowTabMenu, true, 'isShowTabMenu'));
    AppStorage.setOrCreate<string>('cameraShotKey', assert.asDefault(wantParam.cameraShotKey, ''));
    const entryFromHap = AppStorage.get<number>('entryFromHap');
    this.isFromLockedScreen = !Global.getBoolean('isShowTabMenu') && Bundles.isFromCamera(wantParam);
    this.setShowOnLockScreen(this.isFromLockedScreen);
    Log.info(TAG, 'is wakenByLockScreen' + `{isShowTabMenu: ${Global.getBoolean(
      'isShowTabMenu')},isFromLockedScreen: ${this.isFromLockedScreen}, entryFromHap: ${entryFromHap},`);
    if (!this.isFromLockedScreen) {
      return Constants.ENTRY_FROM_NONE;
    }
    Log.info(TAG, 'entering LockScreen, parameters:' + JSON.stringify(wantParam));
    CommonEventManager.getInstance().init();
    return Constants.ENTRY_FROM_CAMERA;
  }

  public onExit(isEmitBack: boolean, isTerminate: boolean, tag: string, msg?: string): void {
    Log.info(TAG, `LockScreen isFromLockedScreen: ${this.isFromLockedScreen} from ${tag}, msg: ${msg ?? ''}`);
    if (!this.isFromLockedScreen) {
      return;
    }
    if (!isTerminate) {
      return;
    }
    this.isFromLockedScreen = false;
    this.setShowOnLockScreen(false);
    Global.setBoolean('isShowTabMenu', true);
    global.terminateSelf(TAG, msg);
  }

  //图库处于锁屏之上
  private async setShowOnLockScreen(showOnLockScreen: boolean): Promise<void> {
    Timer.sleep(100);
    Log.warn(TAG, 'setting setShowOnLockScreen' + showOnLockScreen);
    tryFunc((): void => global.uiAbilityContext().windowStage.setShowOnLockScreen(showOnLockScreen));
  }
}

export default function lockedScreenMgr(): LockedScreen {
  if (!Boolean(LockedScreen.instance)) {
    LockedScreen.instance = new LockedScreen();
  }
  return LockedScreen.instance;
}
