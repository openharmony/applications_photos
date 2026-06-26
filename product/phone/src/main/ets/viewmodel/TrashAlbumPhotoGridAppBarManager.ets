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

import lazy { AppBarElementBuilder } from '@ohos/common/src/main/ets/default/view/actionbar/AppBar';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { AlbumPhotoGridAppBarManager } from './AlbumPhotoGridAppBarManager';
import lazy { GridAppBarManager } from '@ohos/timeline/src/main/ets/photogrid/view/GridAppBar';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { SecondLevelTitleProp } from '@ohos/common/src/main/ets/default/view/actionbar/SecondLevelTitle';
import lazy { BindSheetController } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';
import lazy { GridCancelViewModel } from '@ohos/timeline/src/main/ets/photogrid/viewmodel/GridCancelViewModel';
import lazy {
  ActionViewModel,
  MenuConstants,
  OperationListener,
  ParamsWrapper
} from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { AlbumInfo, photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { LeftBackActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/LeftBackAction';
import lazy {
  MULTISELECT,
  MultiSelectActionRegister,
  selectionBuilder
} from '@ohos/common/src/main/ets/default/view/actionbar/SelectionAction';
import lazy {
  FormEventTypeUtils,
  FormStateType,
  FormStateTypeUtils
} from '@ohos/timeline/src/main/ets/photogrid/statemanager/GridFormFsm';
import lazy { GridStateProxy } from '@ohos/timeline/src/main/ets/photogrid/statemanager/GridStateProxy';
import lazy {
  GridMultiSelectViewModel
} from '@ohos/timeline/src/main/ets/photogrid/viewmodel/GridMultiSelectViewModel';
import lazy { RecoverActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/RecoverAction';
import lazy { DeleteActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/DeleteAction';
import lazy { Action, ActionID } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import type { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { IrregularType } from '@ohos/timeline/src/main/ets/photogrid/statemanager/constants/GridDefine';
import lazy { AppBarController } from '@ohos/common/src/main/ets/default/view/actionbar/AppBar';
import lazy { getScreen, ColumnSize } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { AppBarStyles } from '@ohos/common/src/main/ets/default/view/actionbar/AppBarStyles';
import lazy { ActionUtils } from '@ohos/common/src/main/ets/default/utils/ActionUtils';

/* instrument ignore file */
const TAG: string = 'TrashAlbumPhotoGridAppBarManager';
/**
 * 菜单栏元素个数阈值
 */
const TOOL_MENU_LIST_LENGTH_THRESHOLD: number = 4;

export class TrashAlbumPhotoGridAppBarManager extends AlbumPhotoGridAppBarManager {
  public navigationPageInfos: NavPathStack | undefined = new NavPathStack();
  private targetDataSource: AlbumDataSource | undefined = undefined;

  constructor(dataSource: AlbumDataSource | undefined, navPathStack?: NavPathStack,
    bindSheetController?: BindSheetController) {
    super(dataSource);
    this.targetDataSource = dataSource;
    this.navigationPageInfos = navPathStack;
    this.bindSheetController = bindSheetController;
  }

  public extraInit() {
    super.extraInit();
    this.gridObserverProxy.gridObserverProxy.getIrregularTypeHeight(
      IrregularType.FIXED_IRREGULAR,
      (oldHeight, newHeight)=>{
        GridStateProxy.getInstance(this.instanceId)
          .titleBarStateManager
          .immersiveThresholdAsm
          .updateState(newHeight);
      })
  }

  protected onSelectModeChanged(): void {
    Log.info(TAG, `quitSelectMode hasUnmoving: ${this.selectManager?.isSelectedMode()}`);
    super.onSelectModeChanged();
    if (!this.selectManager?.isSelectedMode()) {
      this.updateNonSelectionTitle();
    }
  }

  protected onActionBarAreaChanged(oldValue: Area, newValue: Area): void {
    this.updateTitleBarHeight(newValue.height as number);
  }

  public clearAllDoAction() {
    let params: ParamsWrapper = this.buildCommonParams();
    let menuContext = new MenuContext();
    menuContext
      .withSelectManager(this.selectManager)
      .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
      .withAlbumInfo(this.albumInfo)
      .withAlbumUri(UserFileManagerAccess.getRecycleBinUri())
      .operate(Action.CLEAR_RECYCLE.actionID);
  }

  protected override registerNonSelectionActions() {
    let params: ParamsWrapper =
      this.buildCommonParams().set(MenuConstants.KEY_APP_BAR_CONTROLLER, this.actionBarController);

    // 返回
    if (this.albumInfo?.subType === photoAccessHelper.AlbumSubtype.GEOGRAPHY_LOCATION) {
      new LeftBackActionRegister(() => this.backFunc()).register(params);
    } else if (!(DeviceInfo.isTablet() &&
      // Pad 上，仅对“非最近删除”的系统 / 来源相册保留原来的无返回行为；
      // 最近删除(TRASH) 页面本身需要返回按钮。
      ((this.albumInfo?.isSystemAlbum && this.albumInfo?.subType !== photoAccessHelper.AlbumSubtype.TRASH) ||
        this.albumInfo?.isSourceAlbum))) {
      new LeftBackActionRegister(() => this.backFunc()).register(params);
    }
    this.actionBarController.put(this.elements.get(GridAppBarManager.BUILDER_KEY_TITLE));
    this.updateNonSelectionTitle();

    // 多选/全选/取消全选按钮
    if (this.usePhoneUx() || DeviceInfo.isTablet()) {
      params.set(MultiSelectActionRegister.KEY_CUSTOM_MULTISELECT_BUILDER, selectionBuilder);
    }
    let selectViewModel: ActionViewModel | undefined = this.actions.get(MULTISELECT.componentKey)?.viewModel;
    let currentState: FormStateType = GridStateProxy.getInstance(this.instanceId).formFsm.currentState;
    let shouldShowMultiSelect: boolean =
      FormStateTypeUtils.isInDayState(currentState) || FormStateTypeUtils.isInGroupDayState(currentState);
    if (!GridStateProxy.getInstance(this.instanceId).dataSourceManager.isEmpty() && shouldShowMultiSelect) {
      // 有数据时才显示多选按钮
      new MultiSelectActionRegister(selectViewModel ?? new GridMultiSelectViewModel(this.instanceId)).register(params);
    }
  }

  protected override registerCommonSelectActions(params: ParamsWrapper): void {
    new RecoverActionRegister().register(params);
    new DeleteActionRegister().register(params);
  }

  protected updateNonSelectionTitle(): void {
    super.updateNonSelectionTitle();
    let titleBuilder: AppBarElementBuilder | undefined = this.elements.get(GridAppBarManager.BUILDER_KEY_TITLE);
    let titleProp: SecondLevelTitleProp | undefined = titleBuilder?.builderParams as SecondLevelTitleProp;
    if (!titleProp) {
      return;
    }
    try {
      titleProp.content = this.targetDataSource?.albumInfo?.albumName ?? '';
    } catch (error) {
      Log.error(TAG, `getStringSync failed, error code: ${error?.code}, message: ${error?.message}.`);
    }
  }

  public override updateAppBar(): void {
    super.updateAppBar();
    let selectedCount: number = this.selectManager?.getSelectedCount() ?? 0;
    this.setActionEnabled(Action.RECOVER, selectedCount > 0);
  }

  protected override updateToolBar(): void {
    super.updateToolBar();
    ActionUtils.setImmersiveStyle(this.toolbarController, false);
    // 最近删除页面特殊处理：向上移动并增加底部背景高度
    this.multiSelectToolBarParameterForTrash(this.toolbarController);
  }

  /**
   * 最近删除页面多选工具栏参数设置
   * @param toolbarController 工具栏控制器
   */
  private multiSelectToolBarParameterForTrash(toolbarController: AppBarController): void {
    let horizontalPadding: number = getScreen().getScreenColumns() === ColumnSize.COLUMN_FOUR &&
      toolbarController.builders.length >= TOOL_MENU_LIST_LENGTH_THRESHOLD ? 0 :
      getScreen().getScreenColumns() === ColumnSize.COLUMN_EIGHT &&
        toolbarController.builders.length < TOOL_MENU_LIST_LENGTH_THRESHOLD ?
        AppBarStyles.TOOLBAR_LESS_THAN_THRESHOLD_PADDING*2 + (getScreen().getWinWidth() -
          AppBarStyles.TOOLBAR_LESS_THAN_THRESHOLD_PADDING*9)/ColumnSize.COLUMN_EIGHT:
        AppBarStyles.TOOLBAR_LESS_THAN_THRESHOLD_PADDING;
    let bottomOffset: number = 0;
    // 增加底部背景高度
    let bottomPadding: number = bottomOffset + 30;
    toolbarController.padding = {
      left: horizontalPadding,
      right: horizontalPadding,
      bottom: bottomPadding,
    };
    toolbarController.margin = {
      top: 0,
      left: 0,
      right: 0,
      bottom: bottomOffset,
    };
    // 重新设置对齐规则，确保 margin 生效
    toolbarController.alignRules = {
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      left: { anchor: '__container__', align: HorizontalAlign.Start },
    };
  }

  protected backFunc(): void {
    Log.info(TAG, 'Return to the previous page doAnimation');
    // 退出选择模式
    if (this.selectManager?.isSelectedMode()) {
      new GridCancelViewModel(this.instanceId).doAction();
      return;
    }
    this.navigationPageInfos?.pop();
  }
}