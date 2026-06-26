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

import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { ActionRegister } from './ActionRegister';
import lazy { BrowserControlInterface } from '../../interface/BrowserControlInterface';
import lazy { ActionModel, ActionViewModel, MenuConstants, ParamsWrapper } from './Menu';
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import lazy { WallpaperUtils } from '../../utils/WallpaperUtils';

const TAG: string = 'SetWallpaperAction';

/**
 * 设置为壁纸Action 属性
 */
@Observed
export class SetWallpaperActionProp extends DefaultActionButtonProp {
  public action = Action.SET_WALLPAPER;
  public icon = Action.SET_WALLPAPER.iconRes;
  public text = Action.SET_WALLPAPER.textRes;
  public key = 'ActionButton_' + Action.SET_WALLPAPER.componentKey;
}

/**
 * 设置为壁纸Action 属性，PC场景使用
 */
@Observed
export class SetWallpaperActionPropHugeScreen extends SetWallpaperActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 设置为壁纸Action 注册类
 */
export class SetWallpaperActionRegister extends ActionRegister {
  public getActions(): Action[] {
    return [Action.SET_WALLPAPER];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new SetWallpaperActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    let currentPhoto: BrowserControlInterface | undefined =
      params.get<BrowserControlInterface>(MenuConstants.KEY_BROWSER_CONTROLLER);
    return {
      produce: () => {
        return new MenuContext()
          .withSelectManager(params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
          .withMediaItem(currentPhoto?.getCurrentPhoto());
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new SetWallpaperActionPropHugeScreen() : new SetWallpaperActionProp();
  }
}

/**
 * 设置为壁纸Action VM层
 */
export class SetWallpaperActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    let longPressMediaItem: MediaItem | undefined = menuContext?.get<MediaItem>(MenuConstants.KEY_LONG_PRESS_MEDIA);
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    // 长按图片场景处理
    if (menuContext.mediaItem || longPressMediaItem) {
      const mediaItem = menuContext.mediaItem || longPressMediaItem;
      if (mediaItem) {
        Log.info(TAG, `doAction longPress setWallpaper mediaItem: ${mediaItem.uri}`);
        this.currentPhotoSetWallPaper(mediaItem);
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
      this.currentPhotoSetWallPaper(currentPhoto);
    });
  }

  private currentPhotoSetWallPaper(item: MediaItem): void {
    if (item?.getPosition?.() === photoAccessHelper.PositionType.CLOUD) {
      UiUtil.showToast($r('app.string.current_picture_not_download_please_download_and_try_again'));
    } else {
      Log.info(TAG, 'doAction. BroadCast.emit BroadCastConstants.SET_WALLPAPER');
      WallpaperUtils.setWallpaper(item.uri);
    }
  }
}