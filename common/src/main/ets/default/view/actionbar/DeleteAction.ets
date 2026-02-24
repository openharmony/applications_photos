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

import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import lazy { ActionRegister } from './ActionRegister';
import lazy { BrowserControlInterface } from '../../interface/BrowserControlInterface';
import lazy { ActionModel, ActionViewModel, MenuConstants, OperationListener, ParamsWrapper } from './Menu';
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import type { BroadCast } from '../../utils/BroadCast';
import lazy { DeleteMenuOperation } from '../browserOperation/DeleteMenuOperation';
import lazy { Log } from '../../utils/Log';
import lazy { Constants } from '../../model/common/Constants';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy  { AlbumDataSource } from '../../model/AlbumDataSource';

const TAG: string = 'DeleteAction';

/**
 * 删除按钮属性
 */
@Observed
export class DeleteActionProp extends DefaultActionButtonProp {
  public action = Action.DELETE;
  public icon = Action.DELETE.iconRes;
  public text = Action.DELETE.textRes;
  public key = 'ActionButton_' + Action.DELETE.componentKey;
}

/**
 * 删除按钮属性，PC场景使用
 */
@Observed
export class DeleteActionPropHugeScreen extends DeleteActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 删除Action注册类
 */
export class DeleteActionRegister extends ActionRegister {
  public static readonly DELETE_LISTENER: string = 'com.ohos.photos.delete_listener';

  public getActions(): Action[] {
    return [Action.DELETE];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new DeleteActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    let listener: OperationListener | undefined = params.get<OperationListener>(DeleteActionRegister.DELETE_LISTENER);
    // 大图场景
    let currentPhotoParam: BrowserControlInterface | undefined =
      params.get<BrowserControlInterface>(MenuConstants.KEY_BROWSER_CONTROLLER);
    return {
      produce: () => {
        let menuContext: MenuContext = new MenuContext().set(MenuConstants.KEY_RIGHT_CLICK_MENU,
          params.get<boolean>(MenuConstants.KEY_RIGHT_CLICK_MENU));
        return menuContext
          .set(MenuConstants.KEY_CURRENT_PHOTO, currentPhotoParam?.getCurrentPhoto())
          .withSelectManager(params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .withFromPage(currentPhotoParam ? Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER :
          MenuConstants.KEY_PAGE_FROM_HIGHLIGHT)
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .withAlbumInfo(params.get<AlbumInfo>(MenuConstants.KEY_ALBUM_INFO))
          .withDataSource(params.get<AlbumDataSource>(MenuConstants.KEY_DATASOURCE));
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    let actionButtonProp: ActionButtonProp;
    if (DeviceInfo.isPc()) {
      let isThirdScene: boolean = params.get<boolean>(MenuConstants.KEY_IS_THIRD_SCENE);
      Log.info(TAG, `buildViewProp, pc, isThirdScene: ${isThirdScene}`);
      actionButtonProp = new DeleteActionPropHugeScreen();
      if (isThirdScene) {
        actionButtonProp.setLabelInfo('');
      }
    } else {
      actionButtonProp = new DeleteActionProp();
    }
    return actionButtonProp;
  }
}

/**
 * 删除操作VM层
 */
export class DeleteActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    let albumInfo: AlbumInfo | undefined = menuContext.get<AlbumInfo>(MenuConstants.KEY_ALBUM_INFO);
    if (albumInfo) {
      menuContext.withAlbumInfo(albumInfo);
    }
    let item: MediaItem | undefined = menuContext.get<MediaItem>(MenuConstants.KEY_CURRENT_PHOTO);
    if (item) {
      Log.info(TAG, 'doAction single hide');
      menuContext.withMediaItem(item);
      menuContext.withHiddenState(true);
    }
    new DeleteMenuOperation(menuContext).doAction();
  }
}