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

import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { DataListener, LoadingResult } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { ActionViewModel, MenuConstants, ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { GridAppBarManager } from '@ohos/timeline/src/main/ets/photogrid/view/GridAppBar';
import lazy { doubleTitleBuilder, DoubleTitleProp } from '@ohos/common/src/main/ets/default/view/actionbar/DoubleTitle';
import lazy { GridStateProxy } from '@ohos/timeline/src/main/ets/photogrid/statemanager/GridStateProxy';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy { AppBarElementBuilder } from '@ohos/common/src/main/ets/default/view/actionbar/AppBar';
import lazy {
  MULTISELECT,
  MultiSelectActionRegister,
  selectionBuilder
} from '@ohos/common/src/main/ets/default/view/actionbar/SelectionAction';
import lazy { BigDataConstants } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { AboutActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/AboutAction';
import lazy { ActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/ActionRegister';
import lazy { GallerySettingActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/GallerySettingAction';
import lazy { GridMultiSelectViewModel } from '@ohos/timeline/src/main/ets/photogrid/viewmodel/GridMultiSelectViewModel';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { FirstLevelTitleProp } from '@ohos/common/src/main/ets/default/view/actionbar/FirstLevelTitle';
import lazy { ImmersiveController } from '@ohos/common/src/main/ets/default/utils/ImmersiveController';
import lazy { FormStateType, FormStateTypeUtils } from '@ohos/timeline/src/main/ets/photogrid/statemanager/GridFormFsm';
import lazy { AppBarStyles } from '@ohos/common/src/main/ets/default/view/actionbar/AppBarStyles';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { MovingPhotoChecker } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { ActionUtils } from '@ohos/common/src/main/ets/default/utils/ActionUtils';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { ActionButtonProp } from '@ohos/common/src/main/ets/default/view/actionbar/ActionButton';
import lazy { BrowserJumper } from '@ohos/timeline/src/main/ets/photogrid/viewmodel/BrowserJumper';
import lazy { PhotosHmBrowserController } from '@ohos/browserlibrary';
import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { AppStorageKeys } from '@ohos/common/src/main/ets/default/utils/AppStorageKeys';
import { MoreActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/MoreAction';


const TAG: string = 'TimelineAppBarManager';
/**
 * 菜单栏元素个数阈值
 */
const TOOL_MENU_LIST_LENGTH_THRESHOLD: number = 4;

export class TimelineAppBarManager extends GridAppBarManager {
  public static readonly BUILDER_KEY_DOUBLE_TITLE: string = 'Timeline_Double_Title';
  private hasUnMovingPhotoStatus: boolean = false;
  private readonly dataListener: DataListener<MediaItem> = {
    onLoadingFinished: (result: LoadingResult<MediaItem>) => this.updateLayout(),
  }
  private readonly movingPhotoChecker: MovingPhotoChecker = new MovingPhotoChecker();
  private readonly spliceBrowserJumper: BrowserJumper = new BrowserJumper();

  public extraInit(): void {
    GridStateProxy.getInstance(this.instanceId).dataSourceManager.dayDataSource.addListener(this.dataListener);
    GridStateProxy.getInstance(this.instanceId).titleBarStateManager.setTitleBarAppBarController(
      this.actionBarController);

    // 主副标题，有数据场景使用
    let doubleTitleProp: DoubleTitleProp = new DoubleTitleProp();
    doubleTitleProp.mainTitle.content = $r('app.string.tab_timeline');
    doubleTitleProp.mainTitle.fontSize = AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE;
    doubleTitleProp.mainTitle.transitionEffect = TransitionEffect.OPACITY.animation({duration: AppBarStyles.MULTISELECT_ANIMATION_DURATION, curve: Curve.Sharp})
    doubleTitleProp.subTitle.content = '';
    doubleTitleProp.subTitle.fontSize = ActionBarProp.SUB_TITLE_TEXT_SIZE;
    doubleTitleProp.subTitle.transitionEffect = TransitionEffect.OPACITY.animation({duration: AppBarStyles.MULTISELECT_ANIMATION_DURATION, curve: Curve.Sharp})
    let doubleBuilder: AppBarElementBuilder = {
      builder: doubleTitleBuilder,
      builderParams: doubleTitleProp,
      key: TimelineAppBarManager.BUILDER_KEY_DOUBLE_TITLE,
    };
    this.elements.set(TimelineAppBarManager.BUILDER_KEY_DOUBLE_TITLE, doubleBuilder);
    this.registerTitleBarContentChange();
    this.selectedItemsParser?.addChecker(this.movingPhotoChecker);
    this.initSpliceBrowserJumper();
    super.extraInit();
  }

  private initSpliceBrowserJumper(): void {
    this.spliceBrowserJumper.init(this.instanceId,
      GridStateProxy.getInstance(this.instanceId).dataSourceManager.dayDataSource,
      this.initParams?.get<PhotosHmBrowserController>(GridAppBarManager.KEY_BROWSER_CONTROLLER));
  }

  protected setEmptyDataTitle(): void {
    // 照片页为空时显示 “照片”
    Log.info(TAG, 'setEmptyDataTitle');
    let titleBuilder: AppBarElementBuilder | undefined = this.elements.get(GridAppBarManager.BUILDER_KEY_TITLE);
    let titleProp: FirstLevelTitleProp | undefined = titleBuilder?.builderParams as FirstLevelTitleProp;
    if (!titleProp) {
      return;
    }

    let currentFontSize: number | string | Resource = titleProp.fontSize;
    if (currentFontSize !== $r('app.float.first_level_title_font_size')) {
      titleProp.fontSize = $r('app.float.first_level_title_font_size');
    }

    let currentText: string | Resource | undefined = titleProp.content;
    let targetText: string | Resource | undefined = $r('app.string.tab_timeline');
    if (currentText !== targetText) {
      titleProp.content = targetText;
    }

    let targetFontColor: ResourceColor = ActionBarProp.NORMAL_TEXT_COLOR;
    if (titleProp.fontColor !== targetFontColor) {
      titleProp.fontColor = targetFontColor;
    }
  }

  protected registerNonSelectionActions(): void {
    // 标题
    if (GridStateProxy.getInstance(this.instanceId).dataSourceManager.isEmpty() &&
      !GridStateProxy.getInstance(this.instanceId).dataSourceManager.dayDataSource.isInInitData) {
      this.actionBarController.put(this.elements.get(GridAppBarManager.BUILDER_KEY_TITLE));
      this.setEmptyDataTitle();
    } else {
      this.actionBarController.put(this.elements.get(TimelineAppBarManager.BUILDER_KEY_DOUBLE_TITLE));
      this.updateNonSelectionTitle();
    }

    let params: ParamsWrapper =
      this.buildCommonParams().set(MenuConstants.KEY_APP_BAR_CONTROLLER, this.actionBarController);

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

    // 更多菜单，设置、关于
    let moreRegisters: ActionRegister[] = [];
    moreRegisters.push(new GallerySettingActionRegister());
    new MoreActionRegister(moreRegisters).register(params);
    this.setActionEnabled(Action.MORE, true);
  }

  protected updateNonSelectionTitle(): void {
    let isImmersive: boolean = this.gridStateManager !== undefined && this.gridStateManager.immersiveAsm.currentState;
    let titleBuilder: AppBarElementBuilder | undefined =
      this.elements.get(TimelineAppBarManager.BUILDER_KEY_DOUBLE_TITLE);
    let titleProp: DoubleTitleProp | undefined = titleBuilder?.builderParams as DoubleTitleProp;
    if (!titleProp) {
      return;
    }
    let currentFontColor: ResourceColor = titleProp.mainTitle.fontColor;
    let targetColor: ResourceColor =
      isImmersive ? ImmersiveController.FONT_COLOR_LIGHT : ActionBarProp.NORMAL_TEXT_COLOR;
    if (currentFontColor !== targetColor) {
      titleProp.mainTitle.fontColor = targetColor;
      titleProp.subTitle.fontColor = targetColor;
    }
  }

  protected registerTitleBarContentChange() {
    this.gridObserverProxy.titleBarObserverProxy.getMainContent((_oldState, newState) => {
      let titleBuilder: AppBarElementBuilder | undefined =
        this.elements.get(TimelineAppBarManager.BUILDER_KEY_DOUBLE_TITLE);
      let titleProp: DoubleTitleProp | undefined = titleBuilder?.builderParams as DoubleTitleProp;
      if (!titleProp) {
        return;
      }

      if ((newState as Resource)?.id === $r('app.string.tab_timeline').id) {
        // 显示 “照片” 场景，需要调整样式为单行样式，隐藏副标题
        titleProp.mainTitle.fontSize = $r('app.float.first_level_title_font_size');
        titleProp.subTitle.visibility = Visibility.None;
      } else if (DeviceInfo.isTablet()) {
        titleProp.mainTitle.fontSize = $r('app.float.first_level_title_font_size');
        titleProp.subTitle.visibility = Visibility.Visible;
      } else {
        titleProp.mainTitle.fontSize = AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE;
        titleProp.subTitle.visibility = Visibility.Visible;
      }
      titleProp.subTitle.visibility = titleProp.subTitle.content ? Visibility.Visible : Visibility.None;
      titleProp.mainTitle.content = newState;
    })

    this.gridObserverProxy.titleBarObserverProxy.getSubContent((_oldState, newState) => {
      let titleBuilder: AppBarElementBuilder | undefined =
        this.elements.get(TimelineAppBarManager.BUILDER_KEY_DOUBLE_TITLE);
      let titleProp: DoubleTitleProp | undefined = titleBuilder?.builderParams as DoubleTitleProp;
      if (!titleProp) {
        return;
      }
      titleProp.subTitle.content = newState;
      titleProp.subTitle.visibility = newState ? Visibility.Visible : Visibility.None;
    })
  }

  protected buildCommonParams(): ParamsWrapper {
    return super.buildCommonParams()
      .set(MenuConstants.KEY_CURRENT_TAB_PAGE, BigDataConstants.CLICK_SEARCH_ICON_FROM_PHOTO)
  }

  protected registerMoreSelectActions(params: ParamsWrapper): ActionRegister[] {
    let registers: ActionRegister[] = super.registerMoreSelectActions(params);
    return registers;
  }

  protected onSelectModeChanged(): void {
    this.hasUnMovingPhotoStatus = false;
    super.onSelectModeChanged();
  }

  protected updateCheckerResult(result: LoadingResult<ParamsWrapper>): void {
    let checkResult: ParamsWrapper | undefined = result.newPageData.data[0];
    if (!checkResult || !this.selectManager?.isSelectedMode()) {
      return;
    }

    // 如果没有key，默认存在非动态图片
    this.hasUnMovingPhotoStatus = checkResult.get<boolean>(MovingPhotoChecker.KEY_IS_NOT_MOVING_PHOTO);
    Log.info(TAG, `updateCheckerResult hasUnmoving: ${this.hasUnMovingPhotoStatus}`);
    super.updateCheckerResult(result);
  }

  public registerAppBar(): void {
    super.registerAppBar();
    let isImmersive: boolean = this.gridStateManager !== undefined && this.gridStateManager.immersiveAsm.currentState;
    ActionUtils.setImmersiveStyle(this.actionBarController, isImmersive);
  }

  protected updateToolBar(): void {
    super.updateToolBar();
    ActionUtils.setImmersiveStyle(this.toolbarController, false);
    super.multiSelectToolBarParameter(this.toolbarController);
  }

  public updateAppBar(): void {
    super.updateAppBar();
  }

  public release(): void {
    GridStateProxy.getInstance(this.instanceId).dataSourceManager.dayDataSource.removeListener(this.dataListener);
    this.spliceBrowserJumper.release();
    super.release();
  }
}