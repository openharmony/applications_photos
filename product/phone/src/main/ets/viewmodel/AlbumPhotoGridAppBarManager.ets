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

import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { DataListener, LoadingResult } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy {
  ActionViewModel,
  MenuConstants,
  OperationListener,
  ParamsWrapper
} from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { GridAppBarManager } from '@ohos/timeline/src/main/ets/photogrid/view/GridAppBar';
import lazy { GridStateProxy } from '@ohos/timeline/src/main/ets/photogrid/statemanager/GridStateProxy';
import lazy { AppBarElementBuilder } from '@ohos/common/src/main/ets/default/view/actionbar/AppBar';
import lazy {
  MULTISELECT,
  MultiSelectActionRegister,
  selectionBuilder
} from '@ohos/common/src/main/ets/default/view/actionbar/SelectionAction';
import lazy { BigDataConstants } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { ActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/ActionRegister';
import lazy { GridMultiSelectViewModel } from '@ohos/timeline/src/main/ets/photogrid/viewmodel/GridMultiSelectViewModel';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy {
  FormEventTypeUtils,
  FormStateType, FormStateTypeUtils } from '@ohos/timeline/src/main/ets/photogrid/statemanager/GridFormFsm';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { MovingPhotoChecker } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy {
  secondLevelTitleBuilder,
  SecondLevelTitleProp
} from '@ohos/common/src/main/ets/default/view/actionbar/SecondLevelTitle';
import lazy { LeftBackActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/LeftBackAction';
import lazy { SortActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/SortAction';
import lazy { DeleteAlbumActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/DeleteAlbumAction';
import lazy { RenameAlbumActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/RenameAlbumAction';
import lazy {
  FilterActionRegister,
  FilterActionViewModel,
  FilterActionProp,
  FILTER
} from '@ohos/common/src/main/ets/default/view/actionbar/FilterAction';
import lazy { SelectOptionType } from '@ohos/common/src/main/ets/default/view/albumGridSort/type';
import lazy {
  GridViewMode,
  PhotoGridViewConstants,
  PhotoGridViewController
} from '@ohos/common/src/main/ets/default/view/grid/GridView';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy {
  getDelayConst,
  getDurationConst,
  GridLink,
} from '@ohos/common/src/main/ets/default/model/browser/photo/const/GridLinkDelay';
import lazy { performanceMonitor } from '@kit.ArkUI';
import lazy { AddActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/AddAction';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { SortSelectMenuParamType } from '@ohos/common/src/main/ets/default/view/albumGridSort';
import lazy { AlbumGridSortHelper, SortRuleString } from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy { AppBarStyles } from '@ohos/common/src/main/ets/default/view/actionbar/AppBarStyles';
import lazy { AlbumInfoType } from '@ohos/timeline/src/main/ets/photogrid/statemanager/AlbumStateManager';
import lazy { ActionUtils } from '@ohos/common/src/main/ets/default/utils/ActionUtils';
import lazy { GridCancelViewModel } from '@ohos/timeline/src/main/ets/photogrid/viewmodel/GridCancelViewModel';
import lazy { DeleteActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/DeleteAction';
import lazy { FormIndex } from '@ohos/timeline/src/main/ets/photogrid/statemanager/constants/GridDefine';
import lazy { BindSheetController } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';
import lazy { ActionButtonProp } from '@ohos/common/src/main/ets/default/view/actionbar/ActionButton';
import lazy { AccessibilityUtil } from '@ohos/common/src/main/ets/default/utils/AccessibilityUtil';
import lazy { CreationActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/CreationAction';
import lazy { MovieActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/MovieAction';
import lazy { VideoSplicingActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/VideoSplicingAction';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { AlbumUtils } from '@ohos/common/src/main/ets/default/utils/AlbumUtils';
import lazy { PositionFilter } from '@ohos/common/src/main/ets/default/model/PositionFilter';
import { PhotosHmBrowserController } from '@ohos/browserlibrary';
import { MoreActionRegister } from '@ohos/common/src/main/ets/default/view/actionbar/MoreAction';

/* instrument ignore file */
const TAG: string = 'AlbumPhotoGridAppBarManager';
/**
 * 菜单栏元素个数阈值
 */
const TOOL_MENU_LIST_LENGTH_THRESHOLD: number = 4;
const FILTER_CLOUD: SelectOptionType[] = [
  {
    value: $r("app.string.all"),
    key: PositionFilter.NONE.toString(),
  },
  {
    value: $r("app.string.local_image"),
    key: PositionFilter.LOCAL_OR_BOTH.toString(),
  },
  {
    value: $r("app.string.cloud_image"),
    key: PositionFilter.CLOUD_OR_BOTH.toString(),
  }
];
const FILTER_HOME: SelectOptionType[] = [
  {
    value: $r("app.string.all"),
    key: PositionFilter.NONE.toString(),
  },
  {
    value: $r("app.string.local_image"),
    key: PositionFilter.LOCAL_OR_BOTH.toString(),
  },
  {
    value: $r("app.string.switch_gallery_and_nas_sync"),
    key: PositionFilter.CLOUD_OR_BOTH.toString(),
  }
];



export enum FeatureType {
  FEATURE_PHOTO_CREATE, // 图库创作特性
  FEATURE_PHOTO_AUTO_CLIP //流光易剪
}

export class AlbumPhotoGridAppBarManager extends GridAppBarManager {
  private hasUnMovingPhotoStatus: boolean = false;
  private isMoreMenuHiding: boolean = false;
  private readonly dataListener: DataListener<MediaItem> = {
    onLoadingFinished: (result: LoadingResult<MediaItem>) => this.updateLayout(),
  }
  private readonly movingPhotoChecker: MovingPhotoChecker = new MovingPhotoChecker();
  protected appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private readonly onBackPressEventFunc: Function = (): void => this.backFunc();
  protected dataSource: AlbumDataSource | undefined;
  protected bindSheetController: BindSheetController | undefined;
  protected browserController: PhotosHmBrowserController | undefined;
  private sortSubMenuClickedFunc: Function = (param: SortSelectMenuParamType): void => this.sortSubMenuClicked(param);
  private updateTitleFunc: Function =
    (newAlbumName: string, oldAlbumUri: string): void => this.updateTitle(newAlbumName, oldAlbumUri);
  private dateShowFunc: Function = (isShowDate: boolean): void => this.showDate(isShowDate);
  protected readonly deleteAlbumOperationListener: OperationListener = {
    onOperationStart: () => {
    },
    onOperationEnd: () => {
      this.resetViewModeAndSort();
      this.backFunc();
    }
  };
  public albumInfo: AlbumInfoType;
  private readonly getAlbumInfoFunc: Function = (): AlbumInfoType => this.getAlbumInfo();
  private newAlbumName: string | undefined = undefined;

  constructor(dataSource: AlbumDataSource | undefined, bindSheetController?: BindSheetController,
    browserController?: PhotosHmBrowserController) {
    super();
    this.dataSource = dataSource;
    this.bindSheetController = bindSheetController;
    this.browserController = browserController;
  }

  public extraInit(): void {
    this.gridObserverProxy.albumObserverProxy.getAlbumInfo((_oldValue, newValue) => {
      this.albumInfo = newValue;
      this.newAlbumName = undefined;
      this.selectManager?.setAlbumUri(this.albumInfo?.uri ?? '');
    });
    GridStateProxy.getInstance(this.instanceId).dataSourceManager.dayDataSource.addListener(this.dataListener);
    this.selectedItemsParser?.addChecker(this.movingPhotoChecker);
    this.appBroadCast.on(BroadCastConstants.BACK_PRESS_EVENT, this.onBackPressEventFunc);
    this.appBroadCast.on(BroadCastConstants.UPDATE_TITLE, this.updateTitleFunc);
    this.broadCast?.on(BroadCastConstants.ALBUM_GRID_DATE_SHOW, this.dateShowFunc);
    this.initGridSortAsm();
    // 相册名标题
    let titleProp: SecondLevelTitleProp = new SecondLevelTitleProp();
    titleProp.content = this.albumInfo?.albumName ?? '';
    let titleBuilder: AppBarElementBuilder = {
      builder: secondLevelTitleBuilder,
      builderParams: titleProp,
      key: GridAppBarManager.BUILDER_KEY_TITLE,
    };
    this.elements.set(GridAppBarManager.BUILDER_KEY_TITLE, titleBuilder);
    super.extraInit();
  }

  private shouldShowFilter(): boolean {
    if (this.albumInfo === undefined) {
      return false;
    }
    let subType: number = this.albumInfo.subType;
    switch (subType) {
      case Number(photoAccessHelper.AlbumSubtype.USER_GENERIC): // 用户相册
      case Number(photoAccessHelper.AlbumSubtype.FAVORITE): // 收藏
      case Number(photoAccessHelper.AlbumSubtype.VIDEO): // 视频
      case Number(photoAccessHelper.AlbumSubtype.HIDDEN): // 隐藏相册
      case Number(photoAccessHelper.AlbumSubtype.TRASH): // 最近删除
      case Number(photoAccessHelper.AlbumSubtype.SCREENSHOT): // 截屏
      case Number(photoAccessHelper.AlbumSubtype.CAMERA): // 相机
      case Number(photoAccessHelper.AlbumSubtype.IMAGE): // 图片
      case Number(photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT): // 云增强
      case Number(photoAccessHelper.AlbumSubtype.SOURCE_GENERIC): // 来源
        return true;
      default:
        return false;
    }
  }

  protected registerNonSelectionActions(): void {
    let params: ParamsWrapper =
      this.buildCommonParams().set(MenuConstants.KEY_APP_BAR_CONTROLLER, this.actionBarController);

    // 返回
    if (this.albumInfo?.subType === photoAccessHelper.AlbumSubtype.GEOGRAPHY_LOCATION) {
      new LeftBackActionRegister(() => this.backFunc()).register(params);
    } else if (!((this.albumInfo?.isUserCreatedAlbum || this.albumInfo?.isSourceAlbum ||
      this.albumInfo?.isSystemAlbum) && DeviceInfo.isTablet())) {
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

    // 用户相册，添加按钮
    if (this.albumInfo?.isUserCreatedAlbum) {
      new AddActionRegister().register(params);
    }

    // 更多菜单
    this.registerMoreAction(params);
  }

  protected registerMoreAction(params: ParamsWrapper): void {
    // 更多菜单，设置、关于
    let moreRegisters: ActionRegister[] = [];
    // 重命名、删除
    if (this.albumInfo?.isUserCreatedAlbum) {
      moreRegisters.push(new RenameAlbumActionRegister());
    }
    // 删除
    if (this.albumInfo?.isUserCreatedAlbum) {
      moreRegisters.push(new DeleteAlbumActionRegister());
    }
    // 过滤
    // if (this.shouldShowFilter()) {
    //   let viewModel: ActionViewModel | undefined = this.actions.get(FILTER.componentKey)?.viewModel;
    //   moreRegisters.push(new FilterActionRegister(viewModel ??
    //     new FilterActionViewModel(this.selectManager, this.dataSource)));
    // }
    // 排序方式
    if (this.albumInfo?.viewMode === GridViewMode.GRID) {
      moreRegisters.push(new SortActionRegister());
    }
    this.setActionEnabled(Action.MORE, true);
    this.updateFilterOptions();
    new MoreActionRegister(moreRegisters).register(params);
  }

  private updateFilterOptions(): void {
    // 更新options内容
    let prop: FilterActionProp | undefined = this.getProp(FILTER) as FilterActionProp;
    if (!prop) {
      return;
    }
    prop.filterOptions = FILTER_HOME;
  }

  protected updateNonSelectionTitle(): void {
    let isImmersive: boolean = this.gridStateManager !== undefined && this.gridStateManager.immersiveAsm.currentState;
    let titleBuilder: AppBarElementBuilder | undefined = this.elements.get(GridAppBarManager.BUILDER_KEY_TITLE);
    let titleProp: SecondLevelTitleProp | undefined = titleBuilder?.builderParams as SecondLevelTitleProp;
    if (!titleProp) {
      Log.error(TAG, `updateNonSelectionTitle titleProp is null`);
      return;
    }
    titleProp.fontSize = this.getNonSysAlbumTitleFontSize();
    titleProp.minFontSize = $r('sys.float.Body_M');
    titleProp.maxFontSize = this.getNonSysAlbumTitleFontSize();
    titleProp.fontColor = isImmersive ? '#FFFFFF' : AppBarStyles.BUTTON_FILL_COLOR;
    let isSelectedMode: boolean | undefined = this.selectManager?.isSelectedMode();
    // 非选择模式时显示相册名称
    if (!isSelectedMode) {
      titleProp.content = this.newAlbumName ?? (this.albumInfo?.albumName ?? '');
    }
    Log.info(TAG, `updateNonSelectionTitle ${isSelectedMode} ${titleProp.fontColor}`);
  }

  /**
   * 重命名后，更新宫格顶部标题
   * @param name 新的相册名称
   */
  private updateTitle(newAlbumName: string, oldAlbumUri: string): void {
    Log.info(TAG, `updateTitle ${newAlbumName}, oldAlbumUri=${oldAlbumUri}, currAlbumUri=${this.albumInfo?.uri}`);
    if (!newAlbumName) {
      return;
    }
    if (oldAlbumUri !== this.albumInfo?.uri) {
      Log.info(TAG, `updateTitle called by different album`);
      return;
    }
    Log.info(TAG, `updateTitle ${newAlbumName}, ${AlbumDefine.getAnonymizeAlbumName(this.albumInfo?.albumName)}`);
    this.newAlbumName = newAlbumName;
    Log.info(TAG, `updateTitle ${newAlbumName}, ${AlbumDefine.getAnonymizeAlbumName(this.newAlbumName)}`);

    this.updateNonSelectionTitle();
  }

  /**
   * 通过状态机控制宫格日期切换的目标形态
   * @param formIndex 目标形态
   */
  private showDate(isShowDate: boolean): void {
    Log.info(TAG, `isShowDate: ${isShowDate}`);
    if (isShowDate && this.albumInfo) {
      this.albumInfo.viewMode = 2;
    } else if (!isShowDate && this.albumInfo) {
      this.albumInfo.viewMode = 1;
    }
    this.gridStateManager?.updateGirdAnimState(false);
    let intervalId = setInterval((): void => {
      this.gridStateManager?.updateGirdAnimState(true);
      clearInterval(intervalId);
    }, Constants.GRID_LOCK_DURATION);
    this.isMoreMenuHiding = true;
    setTimeout((): void => {
      this.isMoreMenuHiding = false;
      this.updateLayout();
    }, Constants.UPDATE_MORE_MENU_DELAY);
    // 宫格和分组的排序可能不一致，切换形态前清理数据，防止布局和图片内容闪烁
    this.dataSource?.resetActiveWindow();
    this.dataSource?.onDataReloaded();

    const gridProxy = GridStateProxy.getInstance(this.instanceId);
    gridProxy.formFsm.changeIsLastFormIsDayGroup(isShowDate);
    if (!this.gridObserverProxy.gridObserverProxy.config.isSupportStaggerLoading) {
      this.gridStateManager?.delayLoadAsm.updateState(false, TAG);
    }
    gridProxy.gridStateManager.getFirstIndexManager().updateState(0);
    gridProxy.gridStateManager.getScrollOffsetManager().updateState(0);
    gridProxy.formFsm
      .submitEvent(FormEventTypeUtils.getSwitchEventTypeFromForm(isShowDate ? FormIndex.GROUP_DAY : FormIndex.DAY));
  }

  public updateAppBar(): void {
    super.updateAppBar()
    let isImmersive: boolean = this.gridStateManager !== undefined && this.gridStateManager.immersiveAsm.currentState;
    ActionUtils.setImmersiveStyle(this.actionBarController, isImmersive);
  }

  protected updateToolBar(): void {
    super.updateToolBar();
    ActionUtils.setImmersiveStyle(this.toolbarController, false);
    super.multiSelectToolBarParameter(this.toolbarController);
  }

  public getFeatureType(type: FeatureType): boolean {
    return false;
  }
  protected override registerCommonSelectActions(params: ParamsWrapper): void {
    if (!this.isAllVideoAlbum() && !DeviceInfo.isVerdeFoldable()) {
      // 对比
      if ((this.getFeatureType(FeatureType.FEATURE_PHOTO_CREATE) ||
      this.getFeatureType(FeatureType.FEATURE_PHOTO_AUTO_CLIP)) && DeviceInfo.isSupportMovie()) {
        // 创作
        new CreationActionRegister(this.registerCreationSelectActions(params)).register(params);
      }
    }

    if (this.isAllVideoAlbum() && !DeviceInfo.isVerdeFoldable()) {
      if (DeviceInfo.isSupportMovie()) {
        if (this.getFeatureType(FeatureType.FEATURE_PHOTO_CREATE)) {
          new VideoSplicingActionRegister().register(params);
        }
        if (this.getFeatureType(FeatureType.FEATURE_PHOTO_AUTO_CLIP)) {
          new MovieActionRegister().register(params);
        }
      }
    }

    // 删除
    new DeleteActionRegister().register(params);

  }

  /**
   * 用户相册，分类相册，搜索界面使用的单行标题字体大小
   */
  private getNonSysAlbumTitleFontSize(): Resource {
    if (DeviceInfo.isPc() || DeviceInfo.isFoldablePhone() || (DeviceInfo.isPhoneUx() && !AppStorage.get<boolean>('isHorizontal'))) {
      return AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE;
    } else if (DeviceInfo.isTablet()) {
      return $r('app.float.first_level_title_font_size');
    }
    return AppBarStyles.FIRST_LEVEL_TITLE_FONT_SIZE
  }

  private getAlbumInfo(): AlbumInfoType {
    return this.albumInfo;
  };

  protected buildCommonParams(): ParamsWrapper {
    return super.buildCommonParams()
      .set(MenuConstants.KEY_CURRENT_TAB_PAGE, BigDataConstants.CLICK_SEARCH_ICON_FROM_PHOTO)
      .set(MenuConstants.SUB_MENU_CLICKED, this.sortSubMenuClickedFunc)
      .set(MenuConstants.KEY_IS_MORE_MENU_HIDING, this.isMoreMenuHiding)
      .set(MenuConstants.KEY_ALBUM_INFO, this.albumInfo)
      .set(MenuConstants.KEY_CONTEXT, this.context)
      .set(DeleteAlbumActionRegister.DELETE_ALBUM_LISTENER, this.deleteAlbumOperationListener)
      .set(BindSheetController.KEY_ALBUM_COVER_CONTROLLER, this.bindSheetController)
      .set(MenuConstants.KEY_GET_ALBUM_INFO_FUNC, this.getAlbumInfoFunc);
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

  public release(): void {
    GridStateProxy.getInstance(this.instanceId).dataSourceManager.dayDataSource.removeListener(this.dataListener);
    this.appBroadCast.off(BroadCastConstants.BACK_PRESS_EVENT, this.onBackPressEventFunc);
    this.appBroadCast.off(BroadCastConstants.UPDATE_TITLE, this.updateTitleFunc);
    this.broadCast?.off(BroadCastConstants.ALBUM_GRID_DATE_SHOW, this.dateShowFunc);
    super.release();
  }

  private resetViewModeAndSort(): void {
    // 重置显示日期 排序
    Log.info(TAG, `resetViewModeAndSort`);
    AlbumUtils.saveViewMode(getContext(), this.albumInfo?.subType, this.albumInfo?.lpath, GridViewMode.GRID);
    AlbumGridSortHelper.getInstance().setSortRule(
      AlbumGridSortHelper.getAlbumKeyByAlbumInfo(this.albumInfo), '', SortRuleString.defaultType);
  }

  protected backFunc(): void {
    Log.info(TAG, 'Return to the previous page doAnimation');
    // 退出选择模式
    if (this.selectManager?.isSelectedMode()) {
      new GridCancelViewModel(this.instanceId).doAction();
      return;
    }
    //大图连续返回到相册页面打断大图返回动效
    this.browserController?.cancelBrowserToGridAnim();
    // 返回相册页
    Log.info(TAG, `Exit album, albumname ${AlbumDefine.getAnonymizeAlbumName(this.albumInfo?.albumName)}, subType ${this.albumInfo?.subType}`);
    if (!(DeviceInfo.isTablet() &&
      (this.albumInfo?.isSystemAlbum || this.albumInfo?.isUserCreatedAlbum || this.albumInfo?.isSourceAlbum))) {
      AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_DOING_GEOMETRY_TRANSITION_ANIMATION, true);
      animateTo({
        duration: getDurationConst(GridLink.ALBUM_ACTIONBAR),
        delay: getDelayConst(GridLink.ALBUM_ACTIONBAR),
        curve: Curve.Sharp,
      }, (): void => {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_ACTIONBAR_OPACITY, 1);
      })
      animateTo({
        duration: getDurationConst(GridLink.OUT_PHOTO_GRID_ACTIONBAR),
        curve: Curve.Sharp,
      }, (): void => {
        AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY, 0);
        AppStorage.setOrCreate<number>(Constants.KEY_OF_PHOTO_GRID_VIEW_OPACITY, 0);
        AppStorage.setOrCreate<number>(Constants.KEY_OF_ALBUM_OPACITY, 1);
      })
      animateTo({
        duration: getDurationConst(GridLink.PHOTO_GRID_TO_ALBUM),
        curve: Curve.Friction,
        onFinish: (): void => {
          performanceMonitor.end('CLOSE_ALBUM');
          AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_DOING_GEOMETRY_TRANSITION_ANIMATION, false);
        }
      }, (): void => {
        this.updateFocusWhenBackToAlbum();
        AppStorage.setOrCreate<number>(Constants.KEY_OF_SELECTED_ALBUM_INDEX, -1);
        AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_PHOTO_GRID_VIEW, false);
        AppStorage.setOrCreate<boolean>(Constants.KEY_OF_IS_SHOW_CITY_GRID_VIEW, false);
        AppStorage.setOrCreate<string>(Constants.KEY_OF_SELECTED_ALBUM_URI, '');
        let controller: PhotoGridViewController = new PhotoGridViewController();
        controller.setIsShow(TAG, 'backFunc', controller.isShow, false);
        controller.dataSource = this.dataSource;
        getContext().eventHub.emit(PhotoGridViewConstants.EVENT_KEY_SHOW_GRID_VIEW, controller);
      });
    }
  }

  private updateFocusWhenBackToAlbum(): void {
    if (AccessibilityUtil.isOpenTouchGuideSync()) {
      let currentFocusedAlbumIndex: number = AppStorage.get(Constants.KEY_OF_SELECTED_ALBUM_INDEX) ?? 0;
      let targetFocusedElementId: string = `AccessibilityAlbumStack_${currentFocusedAlbumIndex.toString()}`;
      AccessibilityUtil.sendFocusAccessibilityEvent(targetFocusedElementId);
    }
  }

  // 宫格排序子菜单
  private sortSubMenuClicked(param: SortSelectMenuParamType): void {
    this.onSelectSortRuleChange(param().selected, param().sortType);
  }

  private onSelectSortRuleChange(selected: string, sortType: string) {
    this.gridStateManager?.updateGirdSort(new SortRuleString(selected, sortType));
  }

  /**
   * 初始化排序菜单状态机
   */
  private initGridSortAsm(): void {
    let sortRuleString = AlbumGridSortHelper.getInstance()
      .getSortRule('initAlbumGridSortSelect', AlbumGridSortHelper.getAlbumKeyByAlbumInfo(this.albumInfo));
    this.gridStateManager?.updateGirdSort(sortRuleString);
  }

  public updateBindSheetStatus(isShow: boolean) {
    if (this.bindSheetController === undefined) {
      return;
    }
    this.bindSheetController.isShow = isShow;
  }

  /**
   * 是否支持显示搜索按钮相册
   * @returns
   */
  private isSupportSearchAlbum(): boolean {
    if (this.albumInfo?.subType === photoAccessHelper.AlbumSubtype.PORTRAIT ||
      this.albumInfo?.subType === photoAccessHelper.AlbumSubtype.GEOGRAPHY_CITY ||
      this.albumInfo?.subType === photoAccessHelper.AlbumSubtype.CLASSIFY ||
      this.albumInfo?.subType === photoAccessHelper.AlbumSubtype.TRASH ||
      this.albumInfo?.subType === photoAccessHelper.AlbumSubtype.HIDDEN ||
      this.albumInfo?.subType === photoAccessHelper.AlbumSubtype.GEOGRAPHY_LOCATION) {
      return false;
    }
    return true;
  }

  /**
   * 相册是否仅包含视频
   * @returns
   */
  private isAllVideoAlbum(): boolean {
    // 屏幕录制相册
    if (this.albumInfo?.lpath === Constants.LPATH_SCREEN_RECORDING) {
      return true;
    }
    // 视频相册
    if (this.albumInfo?.isVideoAlbum) {
      return true;
    }
    return false;
  }
}