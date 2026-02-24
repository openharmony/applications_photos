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

import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { promptAction } from '@kit.ArkUI';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import type { BroadCast } from '../../utils/BroadCast';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { ActionRegister } from './ActionRegister';
import lazy { BrowserControlInterface } from '../../interface/BrowserControlInterface';
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import lazy { ActionModel, ActionViewModel, MenuConstants, ParamsWrapper, OperationListener } from './Menu';
import lazy { PrintUtil } from '../../utils/PrintUtil';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';

const TAG: string = 'PrintAction';

@Observed
export class PrintActionProp extends DefaultActionButtonProp {
  public action = Action.PRINT;
  public icon = Action.PRINT.iconRes;
  public text = Action.PRINT.textRes;
  public labelInfo = Action.PRINT.shortKey;
  public key = 'ActionButton_' + Action.PRINT.componentKey;
}

export class PrintActionRegister extends ActionRegister {

  public getActions(): Action[] {
    return [Action.PRINT];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new PrintActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    let currentPhoto: BrowserControlInterface =
      params.get<BrowserControlInterface>(MenuConstants.KEY_BROWSER_CONTROLLER);
    return {
      produce: () => {
        let menuContext: MenuContext = new MenuContext();
        menuContext
          .withSelectManager(params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
          .withMediaItem(currentPhoto?.getCurrentPhoto())
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
        return menuContext;
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new PrintActionProp();
  }
}

export class PrintActionViewModel implements ActionViewModel {
  private static readonly DOWNLOAD_INFO: string = 'com.ohos.photos.print.download_info';

  public doAction(menuContext?: MenuContext): void {
    Log.info(TAG, 'Print doAction');
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    if (menuContext.mediaItem) {
      PrintUtil.singlePrint(menuContext.mediaItem, {
        printTriggerPlace: BigDataConstants.PHOTO_PRINT_BIG_PICTURE_POSITION,
        printTriggerType: 0,
      })
      return;
    }
    let selectManager: SelectManager | undefined = menuContext.selectManager;
    if (!selectManager) {
      Log.error(TAG, 'invalid selectManager');
      return;
    }
    let count: number = selectManager.getSelectedCount();
    if (count > PrintUtil.PRINT_MAX_NUMBER) {
      Log.warn(TAG, 'exceed max print count');
      promptAction.showToast({
        message: $r('app.string.number_of_print_exceeds_the_limit_tips'),
        duration: UiUtil.TOAST_DURATION,
      })
      return;
    }

    selectManager.getSelectedItems(async (items: MediaItem[]) => {
      PrintUtil.multiplePrint(items, {
        printTriggerPlace: BigDataConstants.PHOTO_PRINT_GRID_POSITION,
        printTriggerType: 0,
      })
    })
  }
}