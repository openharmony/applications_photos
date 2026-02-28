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
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import lazy { ActionRegister } from './ActionRegister';
import lazy { BrowserControlInterface } from '../../interface/BrowserControlInterface';
import lazy { ActionModel, ActionViewModel, MenuConstants, OperationListener, ParamsWrapper } from './Menu';
import lazy { AppBarController } from './AppBar';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { Action } from '../browserOperation/Action';
import lazy { ActionUtils } from '../../utils/ActionUtils';
import lazy { FavoriteMenuOperation } from '../browserOperation/FavoriteMenuOperation';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';

const TAG: string = 'FavorAction';

/**
 * 收藏按钮属性，手机平板等场景使用
 */
@Observed
export class FavorActionProp extends DefaultActionButtonProp {
  public action = Action.FAVORITE;
  public icon = Action.FAVORITE.iconRes;
  public text = Action.FAVORITE.textRes;
  public key = 'ActionButton_' + Action.FAVORITE.componentKey;
  public fillColor = Action.FAVORITE.fillColor;
}

/**
 * 收藏按钮属性，PC场景使用
 */
@Observed
export class FavorActionPropHugeScreen extends FavorActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 分享Action注册类
 */
export class FavorActionRegister extends ActionRegister {
  public static readonly LISTENER: string = 'com.ohos.photos.favor_listener';

  public getActions(): Action[] {
    return [Action.FAVORITE];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new FavorActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    // 大图场景
    let currentPhotoParam: BrowserControlInterface | undefined =
      params.get<BrowserControlInterface>(MenuConstants.KEY_BROWSER_CONTROLLER);
    return {
      produce: () => {
        let listener: OperationListener | undefined =
          params.get<OperationListener>(FavorActionRegister.LISTENER);
        let menuContext: MenuContext = new MenuContext();
        menuContext
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .withSelectManager(params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .withMediaItem(currentPhotoParam?.getCurrentPhoto())
          .set(ActionRegister.ACTION_BAR_CONTROLLER, params.get(ActionRegister.ACTION_BAR_CONTROLLER))
          .set(ActionRegister.TOOL_BAR_CONTROLLER, params.get(ActionRegister.TOOL_BAR_CONTROLLER))
          .set(MenuConstants.KEY_GET_IS_DOING_ACTION,params.get(MenuConstants.KEY_GET_IS_DOING_ACTION))
          .set(MenuConstants.KEY_SET_IS_DOING_ACTION,params.get(MenuConstants.KEY_SET_IS_DOING_ACTION));
        return menuContext;
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new FavorActionPropHugeScreen() : new FavorActionProp();
  }
}

/**
 * 点击分享VM层
 */
export class FavorActionViewModel implements ActionViewModel {
  public static readonly KEY_FAVOR: string = 'com.ohos.photos.favor_is_favor';
  public static readonly FAVOR: string = 'favor';
  public static readonly NOT_FAVOR: string = 'not_favor';

  public doAction(menuContext?: MenuContext): void {
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    let isDoingAction: boolean = false;
    isDoingAction = menuContext.get<Function>(MenuConstants.KEY_GET_IS_DOING_ACTION)?.();
    if (isDoingAction) {
      Log.error(TAG, 'already doing FavorAction');
      return;
    }
    menuContext.get<Function>(MenuConstants.KEY_SET_IS_DOING_ACTION)?.(true);
    let mediaItem: MediaItem | undefined = menuContext.get<MediaItem>(MenuConstants.KEY_CURRENT_PHOTO);
    if (menuContext.mediaItem || mediaItem) {
      Log.info(TAG, 'favor click single mediaItem');
      if (!menuContext.mediaItem) {
        menuContext.withMediaItem(mediaItem);
      }
      let favorStatus: boolean = !menuContext.mediaItem?.isFavor;
      if (menuContext.mediaItem) {
        menuContext.mediaItem.isFavor = favorStatus;
      }
      menuContext.withTargetFavorStatus(favorStatus);
      new FavoriteMenuOperation(menuContext).doAction();
      let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
      appBroadCast.emit(BroadCastConstants.UPDATE_IS_FAVOR, [menuContext.mediaItem]);
      return;
    }

    let actionBarController: AppBarController | undefined =
      menuContext.get<AppBarController>(ActionRegister.ACTION_BAR_CONTROLLER);
    let toolBarController: AppBarController | undefined =
      menuContext.get<AppBarController>(ActionRegister.TOOL_BAR_CONTROLLER);
    let props: (ActionButtonProp | undefined)[] =
      actionBarController ? ActionUtils.getProps(actionBarController) : [];
    props.push(...(toolBarController ? ActionUtils.getProps(toolBarController) : []));

    let favorProp: ActionButtonProp | undefined;
    for (let prop of props) {
      if (prop?.action === Action.FAVORITE) {
        favorProp = prop;
      }
    }
    if (!favorProp && !menuContext.get<string>(FavorActionViewModel.KEY_FAVOR)) {
      Log.error(TAG, 'favor action not found and not favor key');
      return;
    }

    let shouldDoFavor: boolean = false;
    if (favorProp) {
      shouldDoFavor = (favorProp.text as Resource).id === $r('app.string.action_not_favorite').id;
    } else {
      shouldDoFavor = menuContext.get<string>(FavorActionViewModel.KEY_FAVOR) === FavorActionViewModel.NOT_FAVOR;
    }
    Log.info(TAG, `doAction favor: ${shouldDoFavor}`);
    let selectMgr: SelectManager | undefined = menuContext.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER);
    selectMgr?.resetUnFavorItemCount(shouldDoFavor);
    menuContext.withTargetFavorStatus(shouldDoFavor);
    new FavoriteMenuOperation(menuContext).doAction();
  }
}