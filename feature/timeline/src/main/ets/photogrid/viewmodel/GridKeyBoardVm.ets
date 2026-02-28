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
import lazy { KeyCode } from '@ohos.multimodalInput.keyCode';
import lazy common from '@ohos.app.ability.common'
import lazy { AbstractVm } from './AbstractVm';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { MenuConstants,
  OperationListener, ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { SelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { GridStateProxy } from '../statemanager/GridStateProxy';
import lazy { Action, ActionID, SubMenuParamType } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { PhotoAsset } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { BigDataConstants } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { Constants as PhotoConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy {
  AlbumSetDataSourceManager
} from '@ohos/common/src/main/ets/default/model/browser/album/AlbumSetDataSourceManager';

const TAG: string = 'KeyBoardViewModel';

/**
 * 宫格键盘事件视图模型: 收束宫格的通用键盘事件
 *
 */
export class GridKeyBoardVm extends AbstractVm {
  private isCtrlPress: boolean = false;
  private isShiftPress: boolean = false;
  private mSelectManager: SelectManager = new SelectManager();
  private eventHubs?: common.EventHub;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private albumBroadCast: BroadCast = AlbumSetDataSourceManager.getInstance().getBroadCast();

  private keyBoardFunc: Function = (event: KeyEvent): void => this.handleKeyBoard(event);
  private handleDeleteFunc: Function = (isShowPhotoBrowser: boolean): void => this.handleDelete(isShowPhotoBrowser);
  private handleLargerFunc: Function = (): void => this.handleLarger();
  private handleSmallerFunc: Function = (): void => this.handleSmaller();
  private handleBackEventFunc: Function = (isRunningAnimation: boolean): void => this.handleBackEvent(isRunningAnimation);

  constructor() {
    super('GridKeyBoardVm');
  }

  public init(param?: number, eventHub?: common.EventHub): void {
    super.init(param);
    this.eventHubs = eventHub;
    this.mSelectManager = GridStateProxy.getInstance(this.persistentId).selectManager;
    if (this.eventHubs) {
      this.eventHubs.on(Constants.PC_NEW_PHOTO_GRID, this.keyBoardFunc);
      this.eventHubs.on(BroadCastConstants.DELETE_MEDIA, this.handleDeleteFunc);
      this.eventHubs.on(BroadCastConstants.MEDIA_LARGER, this.handleLargerFunc);
      this.eventHubs.on(BroadCastConstants.MEDIA_SMALLER, this.handleSmallerFunc);
      this.eventHubs.on(BroadCastConstants.BACK_EVENTS, this.handleBackEventFunc);
    }
  }

  public release(): void {
    super.release();
    if (this.eventHubs) {
      this.eventHubs.off(Constants.PC_NEW_PHOTO_GRID, this.keyBoardFunc);
      this.eventHubs.off(BroadCastConstants.DELETE_MEDIA, this.handleDeleteFunc);
      this.eventHubs.off(BroadCastConstants.MEDIA_LARGER, this.handleLargerFunc);
      this.eventHubs.off(BroadCastConstants.MEDIA_SMALLER, this.handleSmallerFunc);
      this.eventHubs.off(BroadCastConstants.BACK_EVENTS, this.handleBackEventFunc);
    }
  }

  /**
   * 键盘事件
   *
   * @param event 键盘事件入口
   */
  public handleKeyBoard(event: KeyEvent): void {
    this.isCtrlPress = AppStorage.get<boolean>(Constants.KEY_OF_IS_CTRL_PRESS) || false;
    this.isShiftPress = AppStorage.get<boolean>(Constants.KEY_OF_IS_SHIFT_PRESS) || false;
    Log.info(TAG, `handleKeyBoard isCtrl: ${this.isCtrlPress}, isShift: ${this.isShiftPress}`);
    if (this.isCtrlPress) {
      this.handleKeyBoardWithCtrl(event);
      return;
    }
  }

  /**
   * 处理组合快捷键
   * @param event
   */
  public handleKeyBoardWithCtrl(event: KeyEvent): void {
    Log.info(TAG, `keyBoard event: ${event.keyCode}`);
    switch (event.keyCode) {
      case KeyCode.KEYCODE_A:
        this.handleSelectAll();
        break;
      default:
        break;
    }
  }

  /*
    Esc键返回上一层界面
   */
  private handleBackEvent(isRunningAnimation: boolean): void {
    let isCollageOrComparedPage: boolean | undefined = AppStorage.get<boolean>('isCollageOrComparedPage');
    Log.info(TAG, `Esc backEvent received, isPhotoBrowser: ${isRunningAnimation} and ${isCollageOrComparedPage}`);
    if (isCollageOrComparedPage || isRunningAnimation) {
      return;
    }
    let params: ParamsWrapper = new ParamsWrapper().set(MenuConstants.KEY_ACTION, Action.BACK)
      .set(MenuConstants.KEY_SELECTION_MANAGER, this.mSelectManager)
    this.gridStateManager.rightClickMenuAsm.updateState(params, 'right click menu state update');
  }
  /*
    全选功能
   */
  private handleSelectAll(): void {
    // 搜索界面屏蔽全选键盘操作
    let isShowSearchPage: boolean | undefined = AppStorage.get<boolean>('isShowSearchPage');
    if (isShowSearchPage) {
      Log.info(TAG, 'inSearchPage reject photoGridView KeyBoardEvent');
      return;
    }
    Log.info(TAG, 'ctrl + a: handleSelectAll received');
    let params: ParamsWrapper = new ParamsWrapper().set(MenuConstants.KEY_ACTION, Action.SELECT_ALL)
      .set(MenuConstants.KEY_SELECTION_MANAGER, this.mSelectManager)
    this.gridStateManager.rightClickMenuAsm.updateState(params, 'right click menu state update');
  }

  /*
    删除功能
   */
  private handleDelete(isShowPhotoBrowser: boolean): void {
    Log.info(TAG, `ctrl + d: handleDelete received, handleDelete isShowPhotoBrowser: ${isShowPhotoBrowser}`);
    if (isShowPhotoBrowser && !this.isInSelectMode()) {
      // 大图场景的快捷键删除
      Log.info(TAG, 'photoBrowser handleDelete');
      this.appBroadCast.emit(PhotoConstants.SINGLE_DELETE, []);
      return;
    }

    if (this.mSelectManager.clickedSet.size !== 0 || this.mSelectManager.inverseSelection) {
      // 宫格场景的快捷键删除
      let params: ParamsWrapper = new ParamsWrapper().set(MenuConstants.KEY_ACTION, Action.DELETE)
        .set(MenuConstants.KEY_SELECTION_MANAGER, this.mSelectManager);
      this.gridStateManager.rightClickMenuAsm.updateState(params, 'right click menu state update');
    } else {
      let isShowSearchPage: boolean | undefined = AppStorage.get<boolean>('isShowSearchPage');
      if (this.albumObserverProxy.getAlbumInfo()?.isUserCreatedAlbum && !isShowSearchPage) {
        // 删除自建相册
        Log.info(TAG, 'handleDelete Album');
        this.albumBroadCast.emit(BroadCastConstants.ALBUM_DELETE + this.albumObserverProxy.getAlbumInfo()?.uri);
      }
    }
  }

  /*
    宫格放大
   */
  private handleLarger(): void {
    Log.info(TAG, 'ctrl + +: handleLarger received');
    this.gridStateManager.gridLevelAsm.updateState(
      Math.min(this.gridStateManager.gridLevelAsm.currentState + 1, this.gridStateManager.config.maxGridLevel));
  }

  /*
    宫格缩小
   */
  private handleSmaller(): void {
    Log.info(TAG, 'ctrl + -: handleSmaller received');
    this.gridStateManager.gridLevelAsm.updateState(
      Math.max(this.gridStateManager.gridLevelAsm.currentState - 1, this.gridStateManager.config.minGridLevel));
  }
}