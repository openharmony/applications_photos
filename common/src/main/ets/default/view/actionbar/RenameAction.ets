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
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import type { BroadCast } from '../../utils/BroadCast';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { RenameMenuOperation } from '../browserOperation/RenameMenuOperation';
import lazy { ActionRegister } from './ActionRegister';
import lazy { BrowserControlInterface } from '../../interface/BrowserControlInterface';
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import lazy { ActionModel, ActionViewModel, MenuConstants, ParamsWrapper, OperationListener } from './Menu';

const TAG: string = 'RenameAction';

/**
 * 重命名Action 属性
 */
@Observed
export class RenameActionProp extends DefaultActionButtonProp {
  public action = Action.RENAME;
  public icon = Action.RENAME.iconRes;
  public text = Action.RENAME.textRes;
  public key = 'ActionButton_' + Action.RENAME.componentKey;
}

/**
 * 重命名Action 属性 PC场景使用
 */
@Observed
export class RenameActionPropHugeScreen extends RenameActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 重命名Action 注册类
 */
export class RenameActionRegister extends ActionRegister {
  public static readonly LISTENER: string = 'com.ohos.photos.rename.listener';

  public getActions(): Action[] {
    return [Action.RENAME];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new RenameActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    // 大图场景
    let currentPhoto: BrowserControlInterface =
      params.get<BrowserControlInterface>(MenuConstants.KEY_BROWSER_CONTROLLER);
    return {
      produce: () => {
        let listener: OperationListener | undefined = params.get<OperationListener>(RenameActionRegister.LISTENER);
        let menuContext: MenuContext = new MenuContext();
        menuContext.withSelectManager(params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
          .withMediaItem(currentPhoto?.getCurrentPhoto())
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.());
        return menuContext;
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new RenameActionPropHugeScreen() : new RenameActionProp();
  }
}

/**
 * 重命名Action VM层
 */
export class RenameActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    let longPressMediaItem: MediaItem | undefined = menuContext?.get<MediaItem>(MenuConstants.KEY_LONG_PRESS_MEDIA);
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    // 长按图片弹出菜单场景，入参为MediaItem
    if (menuContext.mediaItem || longPressMediaItem) {
      const mediaItem = menuContext.mediaItem || longPressMediaItem;
      if (mediaItem) {
        Log.info(TAG, `doAction longPress reNameMediaItem: ${mediaItem.uri}`);
        menuContext.withMediaItem(mediaItem)
        new RenameMenuOperation(menuContext).doAction();
        return;
      }
    }
    let selectManager: SelectManager | undefined = menuContext?.selectManager;
    if (!selectManager) {
      Log.error(TAG, 'doAction. selectManager is null');
      return;
    }
    const selectedCount: number = selectManager.getSelectedCount();
    if (selectedCount !== 1) {
      Log.error(TAG, `doAction selectedCount is invalid. selectedCount:${selectedCount}`);
      return;
    }
    selectManager.getSelectedItems(async (selectedItems: MediaItem[]) => {
      if (selectedItems.length !== 1) {
        Log.error(TAG, `doAction selectedItems.length is invalid. selectedItems.length:${selectedItems.length}`);
        return;
      }
      const currentPhoto: MediaItem = selectedItems[0];
      menuContext.withMediaItem(currentPhoto)
      new RenameMenuOperation(menuContext).doAction();
    })
  }
}