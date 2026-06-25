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

import lazy { PhotoGridVm } from '../../photogrid/viewmodel/PhotoGridVm';
import lazy { NavigationBroadCastManager } from '@ohos/common/src/main/ets/default/model/common/NavigationBroadCastManager';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { OperateStateTypeUtils } from '../../photogrid/statemanager/GridOperateFsm';
import lazy { GridToolBarPosition } from '../../photogrid/statemanager/constants/ToolBarDefine';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';

export const IS_KEEP_ALBUM_SELECT_PAGE: string = 'isKeepAlbumSelectPage';
export const MIN_BOTTOM_AVOID_HEIGHT: number = 28; // 底部最小避让高度,默认值为AI bar的高度
export const BOTTOM_AVOID_AI_BAR_HEIGHT: number = 16;

/**
 * 相册宫格整体视图模型
 */
export class AlbumPhotoGridVm extends PhotoGridVm {
  private navigationBroadCast: BroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
  private onPickerOperationBackToExistAlbumFunc: Function = (): void => this.onPickerOperationBackToExistAlbum();
  private navPathStack: NavPathStack = new NavPathStack();

  public constructor() {
    super('AlbumPhotoGridVm');
  }

  /**
   * 初始化navigation路由栈
   * @param navPathStack navigation路由栈
   */
  public setNavPathStack(navPathStack: NavPathStack): void {
    /* instrument ignore if */
    if (!navPathStack) {
      return;
    }
    this.navPathStack = navPathStack;
  }

  /* instrument ignore next */
  protected override doInit(persistentId: number): void {
    super.doInit(persistentId);
    LogUtils.info(this.tag, `doInit`);
    this.navigationBroadCast.on(NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK_TO_EXIST_ALBUM,
      this.onPickerOperationBackToExistAlbumFunc);
    this.observerAndUpdateBottomAvoidHeight();
  }

  /* instrument ignore next */
  protected override doRelease(): void {
    super.doRelease();
    this.navigationBroadCast.off(NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION_BACK_TO_EXIST_ALBUM,
      this.onPickerOperationBackToExistAlbumFunc);
  }

  /**
   * picker页面返回相册宫格回调
   */
  /* instrument ignore next */
  private onPickerOperationBackToExistAlbum(): void {
    LogUtils.info(this.tag, 'onPickerOperationBackToExistAlbum');
    this.navPathStack?.pop();
    if (DeviceInfo.isGRLFoldScreen()) {
      AppStorage.delete(IS_KEEP_ALBUM_SELECT_PAGE);
    }
  }

  /* instrument ignore next */
  protected observerAndUpdateBottomAvoidHeight(): void {
    this.toolbarObserverProxy.getToolbarPosition(() => this.updateBottomAvoidHeight());
    this.getOperateState(() => this.updateBottomAvoidHeight());
  }

  /* instrument ignore next */
  protected updateBottomAvoidHeight() {
    let avoidHeight: number = this.displayStateManager.config?.bottomAvoidHeight ?? 0;
    if (this.toolbarObserverProxy.getToolbarPosition() === GridToolBarPosition.BOTTOM &&
    OperateStateTypeUtils.isInSelectState(this.getOperateState())) {
      avoidHeight += Constants.ToolBarHeight + MIN_BOTTOM_AVOID_HEIGHT;
    } else {
      avoidHeight = MIN_BOTTOM_AVOID_HEIGHT + BOTTOM_AVOID_AI_BAR_HEIGHT;
    }
    this.stateProxy.displayStateManager.bottomAvoidHeightAsm.updateState(avoidHeight, this.tag);
  }
}