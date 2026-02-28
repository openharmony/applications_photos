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

import lazy { LogUtils } from '@ohos/common/src/main/ets/default/utils/LogUtils';
import lazy { DayGridVc } from '../viewcontroller/DayGridVc';
import lazy { DayGridVm } from '../viewmodel/DayGridVm';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy  { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { UserFileManagerAccess, } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { ImageGridItemComponent } from '@ohos/common/src/main/ets/default/view/ImageGridItemComponent';
import lazy { MinimalImageGridItemComponent } from '@ohos/common/src/main/ets/default/view/MinimalImageGridItemComponent';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { DataListener, LoadingResult } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { GridStateObserverProxy } from '../statemanager/GridStateObserverProxy';
import lazy { FormIndex } from '../statemanager/constants/GridDefine';
import lazy { OperateStateTypeUtils } from '../statemanager/GridOperateFsm';
import lazy { Router } from '@kit.ArkUI';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { ScenarioDefaultDataFactory } from '@ohos/common/src/main/ets/default/access/ScenarioDefaultDataFactory';
import lazy { isFilterListEmpty } from '@ohos/common/src/main/ets/default/utils/ArrayUtil';
import lazy { MenuConstants, MenuHelper, ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { MenuOptionOtherParams } from '@ohos/common/src/main/ets/default/view/browserOperation/interfaces';
import lazy { menuOption } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuOption';
import lazy { MenuContext } from '@ohos/common/src/main/ets/default/view/browserOperation/MenuContext';
import lazy { PhotosHmBrowserController } from '@ohos/browserlibrary';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { GridController } from '../viewmodel/GridController';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { MediaObserver } from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserver';
import lazy { CommonObserverCallback } from '@ohos/common/src/main/ets/default/model/browser/CommonObserverCallback';
import lazy {
  MediaObserverNfyInfo,
  MediaObserverNfyType
} from '@ohos/common/src/main/ets/default/model/browser/dataObserver/MediaObserverCallback';
import lazy { AlbumGridSortHelper } from '@ohos/common/src/main/ets/default/model/AlbumGridSortHelper';
import lazy { MediaTypeChecker, SelectedItemsParser } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import { TimelineDataSourceManager } from '../../model/TimelineDataSourceManager';
import { CameraAuthLocationCardView,
  CameraAuthorizeDialog } from '@ohos/common/src/main/ets/default/view/CameraAuthLocationCardView';
import { CameraAuthLocationFromEnum, CameraAuthLocationManager } from '@ohos/common/src/main/ets/default/viewmodel/CameraAuthLocationManager';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { AlbumConstants } from '../statemanager/constants/AlbumConstants';
import lazy { IrregularElement, IrregularElementBuilder } from '../../albumgrid/view/IrregularElement';
import lazy { BaseBuildParams, emptyBuildBuilder } from './ViewLoader';
import text from '@ohos.graphics.text';
import { Stack } from '@kit.ArkTS';
import { LazyLoadImg } from './LazyLoadImg';

const TAG: string = 'DayGridView';
AppStorage.setOrCreate<number>('TimelinePageIndex', Constants.INVALID);

class RightClickMenuGroup {
  menuList: Action[] = [];
}

/**
 * 日宫格
 */
@Component
export struct DayGridView {
  // 外部导入
  public persistentId: number = 0;
  @State public controller: DayGridVc = new DayGridVc();
  @Provide broadCast: BroadCast = new BroadCast();
  public viewModel: DayGridVm = new DayGridVm();
  public albumInfo: AlbumInfo = new AlbumInfo();

  // 内部自定义
  private readonly observerProxy: GridStateObserverProxy = new GridStateObserverProxy();
  private isHorizontal: boolean = false;
  @State @Watch('onSelectModeChange') isSelectedModePreFrame: boolean = false;
  @Provide isAllSelected: boolean = false;
  @State private timelinePageAllSelectClicker: boolean = false;
  @State totalSelectedCount: number = 0;
  isActive = false; // Is the page active
  @State @Watch('touchScrollEndChange') private isGridTouching: boolean = false;
  @State @Watch('touchScrollEndChange') private isGridScrolling: boolean = false;
  @State touchScrollEnd :boolean = true;
  @Provide rightClickMenuList: RightClickMenuGroup[] = [];
  @Provide longPressMenuList: Action[] = [];

  // ImageGridItemComponent依赖状态开始
  @State imageGridItemHeight: number = 0;
  @State gridItemWidth: number = 0;
  @State gridRowCount: number = 0;
  // ImageGridItemComponent依赖状态结束

  private timePagePhotoAccessCallBackFunc: Function = (): void => this.timePagePhotoAccessCallBack();
  private onMenuListAppearFunc: Function = (mediaItem?: MediaItem) => this.onMenuListAppear(mediaItem);
  // actionBar占位组件高度
  @State actionBarHeight: number = 56;
  // 分段式按钮
  @State isNeedTransition: boolean = false;
  @Prop currentIndex: number = Constants.TIMELINE_PAGE_INDEX;
  @State isSupportPrint: boolean = false;
  @State private isRefreshSelectState: boolean = false;
  // 宫格进大图
  private onJumpPhotoBrowserFunc: Function = (name: string, item: MediaItem, geometryTapIndex: number,
    geometryTransitionString: string, mPosition: number): void =>
  this.onJumpPhotoBrowser(name, item, geometryTapIndex, geometryTransitionString, mPosition);
  private onJumpThirdPhotoBrowserFunc: Function = (name: string, item: MediaItem, geometryTapIndex: number,
    geometryTransitionString: string): void =>
  this.onJumpThirdPhotoBrowser(name, item, geometryTapIndex, geometryTransitionString);
  private spliceItem?: MediaItem | undefined = new MediaItem();
  @Consume @Watch('onBrowserControllerChanged') browserController: PhotosHmBrowserController;
  @StorageLink('leftBlank') leftBlank: number[] = getScreen().getLeftBlank();
  // 选择模式
  private onSelectFunc: Function = (index: number, id: string, isSelected: boolean, callback?: Function,
    isRefreshSelectState?: boolean): void => this.onSelect(index, id, isSelected, callback, isRefreshSelectState);
  private convertPosX: number = 0;
  private convertPosY: number = 0;
  @StorageLink('statusBarHeight') @Watch('onStatusBarHeightChange') statusBarHeight: number = 0;
  // 用于刷新左上角"已选择n项"，需要及时刷新
  @State totalSelectedCountRealTime: number = 0;
  // 用户是否登录
  @StorageProp('isLogIn') isLogIn: boolean = true;
  // 相机权限卡片透明度
  @State private cameraCardOpacity: number = 1;
  // 是否展示顶部信息
  @State isShowMessage: boolean = false;
  // 外部导入
  public isShowSdCardTip: boolean = false;
  private onMenuClickedForSingleItemFunc: Function = (action: Action, currentPhoto: MediaItem):
    void => this.onMenuClickedForSingleItem(action, currentPhoto);
  private readonly menuHelper: MenuHelper = new MenuHelper();
  private updateLongPressMenuListFunc: Function = (isFavor: boolean): void => this.updateLongPressMenuList(isFavor);
  private onPageShowFunc: Function = (msg: string): void => this.onPageShowInner();
  private onPageHideFunc: Function = (msg: string): void => this.onPageHideInner();
  private readonly gridForm: FormIndex = FormIndex.DAY;
  private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  private coverPhotoUri: string = '';
  // 最近删除相册字体与图片间距
  @State private recycleBottomHeight: number = 0;
  private pageName: string = Constants.PHOTO_TRANSITION_TIMELINE;
  private isRegisterHarmonyShare: boolean = false;
  @State @Watch('onCameraAuthCardShowChanged') cameraAuthCardShow: boolean = false;
  @State cameraAuthorizeDialogShow: boolean = false;
  @State isCancelCameraCard: boolean = false;
  private onUpdateCloudCardStateFunc: Function = (isShowCloudCard: boolean): void => this.onUpdateCloudCardState(isShowCloudCard);
  @StorageLink('isAnalysisBackPage') isAnalysisBackPage: boolean = false;
  @BuilderParam irregularHeadBuilder: (param: BaseBuildParams) => void = emptyBuildBuilder;
  @LocalStorageLink('placeholderIndex') @Watch('onPlaceholderChanged') placeholderIndex: number = -1;
  private irregularElementBuilder: IrregularElementBuilder | undefined = undefined;

  aboutToAppear(): void {
    LogUtils.info(TAG, 'aboutToAppear');
    this.observerProxy.init(this.persistentId);
    this.viewModel.setBroadCast(this.broadCast);
    this.viewModel.init(this.persistentId);
    this.controller.init(this.viewModel);
    this.viewModel.registerDataSourceChangedListener({
      onDataSourceChanged: (isNeedTransition: boolean) => {
        Log.info(TAG, `${TAG}` + 'onDataSourceChanged  ' + `${isNeedTransition}`)
        this.isNeedTransition = isNeedTransition
      },
    })
    this.initObservers();
    this.onActive();
    UserFileManagerAccess.getInstance().registerPhotoAccess(this.timePagePhotoAccessCallBackFunc);
    this.registerSelectListener();
    // 注册右键菜单项更新监听器
    this.viewModel.getRightClickMenuList((oldState: RightClickMenuGroup[], newState: RightClickMenuGroup[]):
      void => this.updateRightClickMenuList(newState));
    this.broadCast.on(BroadCastConstants.JUMP_PHOTO_BROWSER, this.onJumpPhotoBrowserFunc);
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.onJumpThirdPhotoBrowserFunc);
    // 选择模式
    this.broadCast.on(BroadCastConstants.SELECT, this.onSelectFunc);
    TimelineDataSourceManager.getInstance().getBroadCast().on(BroadCastConstants.UPDATE_CLOUD_CARD_STATE,
      this.onUpdateCloudCardStateFunc);
    this.controller.isShowSdCardTip = this.isShowSdCardTip;

    this.updateLongPressMenuList();
    this.getUIContext().getHostContext()?.eventHub.on(BroadCastConstants.ON_PAGE_SHOW, this.onPageShowFunc);
    this.getUIContext().getHostContext()?.eventHub.on(BroadCastConstants.ON_PAGE_HIDE, this.onPageHideFunc);
    MediaObserver.getInstance().registerObserver(this.dataObserver);
    this.initPageFrom();
    this.isAnalysisBackPage = this.albumInfo.albumType === photoAccessHelper.AlbumType.SMART;
    this.irregularHeadBuilder =
      this.controller.albumObserverProxy.config.dayViewIrregularBuilder;
    this.irregularElementBuilder =
      this.controller.albumObserverProxy.config.extraParams
        .get<IrregularElementBuilder>(AlbumConstants.PARAMS_KEY_IRREGULAR_ELEMENT_VIEW);
    Log.info(TAG, `this.controller.isMinimalism: ${this.controller.isMinimalism}!this.controller.recycleGridItemSate：${!this.controller.recycleGridItemSate} `);
    Log.info(TAG, `this.controller.isRefreshGrid: ${this.controller.isRefreshGrid}`);
    Log.info(TAG, `this.controller.isCanShow : ${this.controller.isCanShow}&& this.controller.isShow ${this.controller.isShow}`);
    //Log.info(TAG, ` this.viewModel: ${JSON.stringify(this.viewModel.dataSource)}`);
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
    if (!nfyInfo) {
      return;
    }
    if (nfyInfo.type === MediaObserverNfyType.ALBUM_UPDATE && nfyInfo.sharedPhotoAssets) {
      let assets = nfyInfo.sharedAlbumAssets;
      if (!assets || assets.length < Constants.ONE) {
        return;
      }
      this.coverPhotoUri = assets[0]?.coverUri ?? '';
    }
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
  }

  private async getCameraAuthCardShowState(): Promise<void> {
    if (!this.observerProxy.gridObserverProxy.config.isShowCameraCard) {
      Log.info(TAG, `getCameraAuthCardShowState no need show CameraCard`);
      return;
    }
    let isShowCameraAuthCard: boolean = await CameraAuthLocationManager.getIsShowCameraAuthLocationCard(getContext(this),
      CameraAuthLocationFromEnum.TimeLine);
    let totalCount: number = this.viewModel.dayDataSource.totalCount();
    if (totalCount <= 10) {
      this.cameraAuthCardShow = false;
    } else {
      this.cameraAuthCardShow = isShowCameraAuthCard;
    }
    this.controller.isCameraAuthCardShow = this.cameraAuthCardShow;
    this.viewModel.isShowCameraCard = this.cameraAuthCardShow;
    if (this.cameraAuthCardShow) {
      this.controller.isShowCloudCard = false;
      this.viewModel.isShowCloudCard = false;
    }
    this.viewModel.updateCameraCardShowState(this.cameraAuthCardShow);
    this.controller.updateLayoutOptions();
    LogUtils.info(TAG, `getCameraAuthCardShowState:${this.cameraAuthCardShow} canShowCameraCard:` +
      ` totalCount:${totalCount}`);
  }

  private onCameraAuthCardShowChanged(): void {
    this.controller.isCameraAuthCardShow = this.cameraAuthCardShow;
    this.viewModel.isShowCameraCard = this.cameraAuthCardShow;
    if (this.cameraAuthCardShow) {
      this.controller.isShowCloudCard = false;
      this.viewModel.updateCloudCardShowStatus(false);
    } else {
      // 更新高度
      this.viewModel.updateCameraAuthLocationCardHeight(0, 'onCameraAuthCardShowChanged');
    }
    this.controller.updateLayoutOptions();
    this.viewModel.updateCameraCardShowState(this.cameraAuthCardShow);
    this.viewModel.updateIrregularCount(this.cameraAuthCardShow, 'DayCameraAuthCard');
  }

  private onUpdateCloudCardState(isShowCloudCard: boolean): void {
    this.controller.isShowCloudCard = isShowCloudCard;
    this.viewModel.updateCloudCardShowStatus(isShowCloudCard);
  }

  private onPageShowInner(): void {
    this.viewModel.resume();
  }

  private onPageHideInner(): void {
    this.viewModel.pause();
  }

  private initObservers(): void {
    //加监听 从vc更新上面的state变量
    this.observerProxy.gridObserverProxy.getGridColumn(this.gridForm, (oldState, newState) => {
      LogUtils.info(TAG, `update row count from ${oldState} to ${newState}`);
      this.gridRowCount = newState;
    });
    this.observerProxy.gridObserverProxy.getGridImageHeight(this.gridForm, (oldState, newState) => {
      LogUtils.info(TAG, `update GridItemHeight from ${oldState} to ${newState}`);
      this.imageGridItemHeight = newState;
      if (!this.observerProxy.gridObserverProxy.config.isAutoAdjustColumns) {
          // 此处更新会导致旋转性能优化，需要尽快改造
        this.gridItemWidth = newState;
      }
    });

    // 监听多选模式
    this.observerProxy.getOperateState((_oldState, newState) => {
      let isSelectMode: boolean = OperateStateTypeUtils.isInSelectState(newState);
      LogUtils.info(TAG, `isSelectMode change to ${isSelectMode}`);
      this.isSelectedModePreFrame = isSelectMode;
    });
    // 监听屏幕方向变化
    this.observerProxy.displayObserverProxy.getIsHorizontal((_oldState, isHorizontal) => {
      this.isHorizontal = isHorizontal;
    });

    // 更新相机地理权限提醒卡片显示状态
    this.observerProxy.gridObserverProxy.getCameraCardShowState((_oldState, isCameraCardShow) => {
      LogUtils.info(TAG, `getCameraCardShowState:${this.cameraAuthCardShow} ${isCameraCardShow}`);
      this.cameraAuthCardShow = isCameraCardShow;
    });
    // 更新相机权限卡片显示状态
    this.observerProxy.gridObserverProxy.getUpdateCameraAuthorizeState((_oldState, isUpdateCameraAuthorize) => {
      LogUtils.info(TAG, `getUpdateCameraAuthorizeState:${this.cameraAuthCardShow} ${isUpdateCameraAuthorize}`);
      if (isUpdateCameraAuthorize) {
        this.getCameraAuthCardShowState();
      }
    });

    this.observerProxy.gridObserverProxy.getUpdateCameraCardOpacity((_oldState, newState) => {
      let isInCurrentForm: boolean = this.viewModel.isInCurrentForm();
      LogUtils.info(TAG, `getUpdateCameraCardOpacity:${newState} ${isInCurrentForm} ${this.cameraAuthCardShow}`);
      // 只更新当前视图卡片透明度
      if (isInCurrentForm && this.cameraAuthCardShow) {
        this.cameraCardOpacity = newState;
      }
    });
  }

  private registerSelectListener(): void {
    this.observerProxy.selectObserverProxy.registerEventListener({
      updateCount: (newState: number) => {
        LogUtils.info(TAG, `updateSelectCount ${newState}`);
        if (!this.viewModel.isInCurrentForm()) {
          return;
        }
        if (this.viewModel.needUpdateTotalSelectedCount(newState)) {
          this.totalSelectedCount = newState;
        }
      },
      allSelect: (newState: boolean, isDoSelectAll?: boolean) => {
        LogUtils.info(TAG, `isAllSelected ${newState} isDoSelectAll ${isDoSelectAll}`);
        if (!this.viewModel.isInCurrentForm()) {
          return;
        }
        if (this.isAllSelected !== newState) {
          this.isAllSelected = newState;
          if (!AppStorage.get(Constants.PHOTO_GRID_SELECT_MANAGER)) {
            AppStorage.setOrCreate(Constants.PHOTO_GRID_SELECT_MANAGER, this.viewModel.selectManager);
          }
          LogUtils.info(TAG, `change allSelect to: ${newState}`);
          this.timelinePageAllSelectClicker = !this.timelinePageAllSelectClicker;
        }
      },
      clearSelect: (isDoSelectAll: boolean) => this.clearSelect(isDoSelectAll),
      onRefreshSelectState: () => this.isRefreshSelectState = !this.isRefreshSelectState
    });
  }

  private initPageFrom(): void {
    this.pageName = this.observerProxy.albumObserverProxy.config.extraParams
      .get<string>(Constants.ALBUM_GRID_VIEW_PAGE_FROM) ?? this.pageName;
    if (this.viewModel.dayDataSource.albumInfo) {
      this.albumInfo = this.viewModel.dayDataSource.albumInfo;
      // Log.info(TAG, `this.albumInfo: ${JSON.stringify(this.albumInfo)}`);
    }
    Log.info(TAG, `pageName: ${this.pageName}`);
  }

  aboutToDisappear(): void {
    LogUtils.info(TAG, 'aboutToDisappear');
    this.saveReadyStatus();
    UserFileManagerAccess.getInstance().unregisterPhotoAccess(this.timePagePhotoAccessCallBackFunc);
    this.controller.release();
    this.viewModel.release();
    this.viewModel.onDisAppear();
    this.observerProxy.release();

    this.broadCast.off(BroadCastConstants.JUMP_PHOTO_BROWSER, this.onJumpPhotoBrowserFunc);
    this.broadCast.off(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.onJumpThirdPhotoBrowserFunc);
    // 选择模式
    this.broadCast.off(BroadCastConstants.SELECT, this.onSelectFunc);
    TimelineDataSourceManager.getInstance().getBroadCast().off(BroadCastConstants.UPDATE_CLOUD_CARD_STATE,
      this.onUpdateCloudCardStateFunc);
    this.controller.registerSpliceDataSourceListener();
    this.getUIContext().getHostContext()?.eventHub.off(BroadCastConstants.ON_PAGE_SHOW, this.onPageShowFunc);
    this.getUIContext().getHostContext()?.eventHub.off(BroadCastConstants.ON_PAGE_HIDE, this.onPageHideFunc);
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.isAnalysisBackPage = false;
  }

  onSelectModeChange() {
    if (this.isSelectedModePreFrame !== this.controller.isSelectMode) {
      this.viewModel.changeSelectMode(this.isSelectedModePreFrame);
    }
  }

  /**
   * browserController 的watch函数
   */
  onBrowserControllerChanged(): void {

  }

  @Builder
  buildHead() {
    GridItem() {
      if (this.irregularElementBuilder) {
        IrregularElement({
          builder: this.irregularElementBuilder.builder,
          params: this.irregularElementBuilder.builderParams,
          viewModel: this.viewModel,
        })
      }

      if (this.irregularHeadBuilder) {
        this.irregularHeadBuilder({
          persistentId: this.persistentId
        });
      }
    }
    .id('buildHeadGridItem')
    .height(this.controller.headHeight)
  }

  @Builder
  buildFpItems() {
    ForEach(this.controller.fillPositionArr, () => {
      GridItem() {
      }
      .width(this.controller.imageGridItemHeight)
      .height(this.controller.imageGridItemHeight)
      .visibility(Visibility.Hidden)
    }, (item: number) => {
      return `FillPosition${item}`;
    })
  }

  private touchScrollEndChange() {
    this.touchScrollEnd = (!this.isGridTouching && !this.isGridScrolling);
  }

  @Builder
  buildMediaItems() {
    LazyForEach(this.viewModel.dataSource, (item: ViewData, index?: number) => {
      if (this.controller.isMinimalism) {
        MinimalImageGridItemComponent({
          item: item,
          simpleMediaItem: item?.simpleMediaItem,
          mPosition: index,
          pageName: Constants.PHOTO_TRANSITION_TIMELINE_MINIMAL,
          geometryTransitionString: this.viewModel.getGeometryTransitionId(item, index as number),
          gridItemWidth: this.imageGridItemHeight,
          isRecycle: this.albumInfo.isTrashAlbum,
        }).onAppear(()=>{
          Log.info(TAG,'MinimalImageGridItemComponent');
        })
          .reuseId(UiUtil.generateReuseId(Constants.PHOTO_TRANSITION_TIMELINE_MINIMAL,
          item, this.viewModel.getGeometryTransitionId(item, index as number)))
      } else {
        if (!this.controller.recycleGridItemSate) {
          LazyLoadImg({
            item: item,
            touchScrollEnd: this.touchScrollEnd,
          }) {
            ImageGridItemComponent({
              item: item,
              dataSource: this.viewModel.dataSource,
              simpleMediaItem: item?.simpleMediaItem,
              gridScrollMsg: this.controller.gridScrollMsg,
              mPosition: index,
              isSelected: (this.controller.isSelectMode || DeviceInfo.isPc()) ?
                this.viewModel.selectManager.isItemSelected((item?.mediaItem)?.uri as string, index) : false,
              timelinePageAllSelectClicker: this.timelinePageAllSelectClicker,
              onRightMenuClicked: (action: Action, mediaItem?: MediaItem):
                void => this.viewModel.onRightMenuClicked(action, mediaItem),
              pageName: this.pageName,
              onMenuClicked: (action: Action): void => this.viewModel.onMenuClicked(action),
              onMenuClickedForSingleItem: this.onMenuClickedForSingleItemFunc,
              onMenuListAppear: this.onMenuListAppearFunc,
              updateLongPressMenuList: (isFavor: boolean) => {
                if (this.observerProxy.albumObserverProxy.config.extraParams
                  .get<Action[]>(Constants.SMART_ALBUM_LONG_PRESS_MENU)) {
                  this.updateOhterLongPressMenuList(isFavor);
                } else {
                  this.updateLongPressMenuList(isFavor);
                }
              },
              geometryTransitionString: this.viewModel.getGeometryTransitionId(item, index as number),
              selectedCount: $totalSelectedCount,
              isSupportPrint: $isSupportPrint,
              gridItemWidth: this.imageGridItemHeight,
              isNeedTransition: this.isNeedTransition,
              drawnThumbnailCount: this.controller.drawnThumbnailCount,
              gridRowCount: $gridRowCount,
              scroller: this.viewModel.getScroller(),
              positionDeviation: 1,
              selectManager: this.viewModel.selectManager,
              isRefreshSelectState: $isRefreshSelectState,
              isSelectedMode: $isSelectedModePreFrame,
              imageGridItemHeight: this.imageGridItemHeight,
              isShowFileSize: this.controller.isShowFileSize,
              persistentId: this.persistentId,
              useNewPhotoGrid: true,
              rightClickMenuController: undefined,
              isRecycle: this.albumInfo.isTrashAlbum,
              pcRecycleBottomHeight: this.recycleBottomHeight,
              selectMediaType: this.controller.selectMediaType,
            })
              .onAppear(() => {
                Log.info(TAG, 'ImageGridItemComponent');
              })
              .reuseId(this.controller.isBlockReuse ? undefined :
                UiUtil.generateReuseId(Constants.PHOTO_TRANSITION_TIMELINE, item,
                  this.viewModel.getGeometryTransitionId(item, index as number)));
          }
        }
      }
    }, (item: ViewData, index?: number) => {
      if (item == null || item == undefined) {
        return (`undefined${index}`) as string;
      }
      return this.viewModel.getGeometryTransitionId(item, index as number) as string;
    })
  }

  @Builder
  buildTail() {
    // 行尾补位
    ForEach(this.controller.tailFillPosition, (): void => {
      GridItem() {
      }
      .width(this.controller.imageGridItemHeight)
      .height(this.controller.imageGridItemHeight)
      .visibility(Visibility.Hidden)
    }, (item: number): string => {
      return `TailFillPosition${item}`;
    })

    // 底部占位
    GridItem() {
    }
    .id('buildTailItem')
    .height(this.controller.tailHeight)
  }

  @Builder
  buildCameraAuthorizeView() {
    if (this.cameraAuthCardShow && this.observerProxy.gridObserverProxy.config.isShowCameraCard) {
      CameraAuthLocationCardView({
        from: CameraAuthLocationFromEnum.TimeLine,
        cameraAuthCardShow: $cameraAuthCardShow,
        cameraAuthorizeDialogShow: $cameraAuthorizeDialogShow,
        hideCameraAuthCard: () => {

        },
      })
        .id('buildCameraAuthorizeItem')
        .onAreaChange((oldValue: Area, newValue: Area) => {
          const oldHeight: number = assert.asNumber(oldValue.height) ?? 0;
          const newHeight: number = assert.asNumber(newValue.height) ?? 0;
          let msg: string[] = [`dayView CameraAuthLocationCard onAreaChange`];
          msg.push(`newHeight: ${newHeight}`, `oldHeight: ${oldHeight}`);
          msg.push(`isShowMessage: ${this.isShowMessage}`, `cameraAuthCardShow: ${this.cameraAuthCardShow}`);
          Log.info(TAG, msg.join(', '));
          if (oldHeight != newHeight) {
            this.viewModel.updateCameraAuthLocationCardHeight(newHeight, 'CameraAuthLocationHeightChange');
          }
        })
        .visibility(this.cameraCardOpacity < 1 ? Visibility.Hidden : Visibility.Visible)
        .opacity(this.cameraCardOpacity)
        .onAppear(() => {
          LogUtils.info(TAG, `onAppear CameraAuthLocationCardView:${this.cameraAuthCardShow}`);
        })
        .onDisAppear(() => {
          LogUtils.info(TAG, `onDisAppear CameraAuthLocationCardView:${this.cameraAuthCardShow}`);
          this.cameraAuthCardShow = false;
        })
    }
  }

  @Builder
  buildDayGridView() {
    Grid(this.viewModel.getScroller(), this.controller.gridLayoutOptions) {
      // 信息头
      this.buildHead();

      // 云卡片
      this.buildCameraAuthorizeView();

      // 补位区域
      this.buildFpItems();

      // 媒体数据项
      if (this.controller.isRefreshGrid) {
        this.buildMediaItems();
      } else {
        this.buildMediaItems();
      }

      // 尾部
      this.buildTail();
    }
    .cachedCount(5)
    .attributeModifier(this.controller.attributeUpdater)
    .onAreaChange((_oldValue: Area, newValue: Area) => {
      let newValueHeight: number = assert.asNumber(newValue.height) ?? 0;
      this.convertPosX = newValue.globalPosition.x as number;
      this.convertPosY = newValue.globalPosition.y as number;
      this.viewModel.gridAutoScrollerUtil.setScrollerHeight(newValueHeight);
      this.viewModel.gridAutoScrollerUtil.setExtraAreaHeightByIsHorizontal(this.getIsHorizontal4Vxx(),
        this.actionBarHeight,
        px2vp(this.statusBarHeight), false, false);
    })
    .onAppear(() => this.viewModel.onAppear())
    .onDisAppear(() => this.viewModel.onDisAppear())
    .onScrollIndex((firstIndex: number, lastIndex: number) => this.viewModel.onScrollIndex(firstIndex, lastIndex))
    .onScrollBarUpdate((index: number, offset: number) => this.viewModel.onScrollBarUpdate(index, offset))
    .onDidScroll((scrollOffset: number, scrollState: number) => this.viewModel.onDidScroll(scrollOffset, scrollState))
    .onReachStart((): void => this.viewModel.onReachStart())
    .onReachEnd((): void => this.viewModel.onReachEnd())
    .onScrollStart((): void => {
      this.isGridScrolling = true;
      this.viewModel.onScrollStart();
    })
    // todo 先注释注释后日试图滚动正常
    // .onScrollFrameBegin((offset: number, state: number) => this.viewModel.onScrollFrameBegin(offset, state))
    .onWillScroll((offset: number, state: number, source: number) => this.viewModel.onWillScroll(offset, state, source))
    .onScrollStop(() => {
      this.isGridScrolling = false;
      this.isGridTouching = false;
      this.viewModel.onScrollStop();
    })
    .onTouch((event: TouchEvent): void => {
      if (event.type === TouchType.Down || event.type === TouchType.Move) {
        this.isGridTouching = true;
      } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
        this.isGridTouching = false;
      }
      this.viewModel.onTouch(event);
    })
    .onFocus(() => this.viewModel.onFocused())
    .onMouse((event?: MouseEvent) => this.viewModel.onMouse(event))
    .backToTop(false)
    .gesture(
      PanGesture({
        direction: PanDirection.Horizontal,
        distance: this.controller.isSelectMode ? 1 : Number.MAX_SAFE_INTEGER,
      })
        .onActionStart((event: GestureEvent): void => {
          LogUtils.info(TAG, 'DayView PanGesture onActionStart');
          event.fingerList = isFilterListEmpty(event.fingerList);
          if (event.fingerList.length === 0) {
            return;
          }
          this.viewModel.onPanActionStart(event.fingerList[0].globalX - event.offsetX - this.convertPosX,
            event.fingerList[0].globalY - this.convertPosY);
        })
        .onActionUpdate((event: GestureEvent): void => {
          event.fingerList = isFilterListEmpty(event.fingerList);
          if (event.fingerList.length > 0) {
            this.viewModel.onPanActionUpdate(event.fingerList[0].globalX - this.convertPosX,
              event.fingerList[0].globalY - this.convertPosY);
          }
        })
        .onActionEnd((event: GestureEvent): void => {
          LogUtils.info(TAG, 'DayView PanGesture onActionEnd');
          this.viewModel.onPanActionEnd();
        })
    )
  }

  private onSelect(index: number, id: string, isSelected: boolean, callback?: Function,
    isRefreshSelectState?: boolean): void {
    if (!this.viewModel.isInCurrentForm()) {
      return;
    }
    if (DeviceInfo.isPc() && isRefreshSelectState) {
      LogUtils.info(TAG, 'onSelect setImageHeadTail');
      this.viewModel.selectManager.setImageHeadTailPosition(this.controller.isSelectMode, isSelected, id, index,
        (isNowSelected: boolean) => {
          this.isRefreshSelectState = !this.isRefreshSelectState;
          callback?.(isNowSelected);
          return;
        });
      return;
    }
    if (index === undefined) {
      return;
    }
    if (this.viewModel.selectManager.toggle(id, isSelected, index) && !this.controller.isSelectMode) {
      if (!DeviceInfo.isPc()) {
        this.updateSelectedMode(true);
      }
    }
    if (typeof callback === 'function') {
      callback?.();
    }
  }

  onStatusBarHeightChange(changedPropertyName: string): void {
  }

  private updateSelectedMode(newState: boolean): void {
    this.controller.isSelectMode = newState;
    this.isSelectedModePreFrame = newState;
  }

  private clearSelect(isDoSelectAll: boolean): void {
    this.viewModel.selectManager.deSelectHeadTailPosition(isDoSelectAll);
    if (this.controller.isSelectMode) {
      this.updateSelectedMode(false);
    }
    let gridController: GridController = new GridController();
    if (this.persistentId !== 0) {
      gridController.init(this.persistentId);
    }
    gridController.refreshSelectState();
  }

  private async saveReadyStatus(): Promise<void> {
    LogUtils.info(TAG, `saveReadyStatus ${ImageUtil.isThumbnailReady()}`);
    await DataStoreUtil.getInstance().putData<boolean>(Constants.THUMBNAIL_READY_FLAG, ImageUtil.isThumbnailReady());
  }

  private getIsHorizontal4Vxx(): boolean {
    return !DeviceInfo.isVerdeFoldable() && this.isHorizontal;
  }

  private timePagePhotoAccessCallBack(): void {
    if (this.currentIndex === Constants.TIMELINE_PAGE_INDEX) {
      this.viewModel.dataSource?.notifyDirty();
      LogUtils.info(TAG, 'User TimePagePhotoAccessCallBack');
    }
  }

  onMenuListAppear(mediaItem?: MediaItem): void {
    this.viewModel.updateRightClickMenuList(mediaItem);
  }

  private updateOhterLongPressMenuList(isFavor?: boolean): void {
    const tempMenuList: Action[] = [];
    for (let action of this.observerProxy.albumObserverProxy.config.extraParams
      .get<Action[]>(Constants.SMART_ALBUM_LONG_PRESS_MENU)) {
      if (action.actionID === Action.MULTISELECT.actionID && this.controller.isSelectMode) {
        continue;
      }
      tempMenuList.push(action);
    }

    if (!UiUtil.isActionArrayEqual(this.longPressMenuList, tempMenuList)) {
      this.longPressMenuList = tempMenuList;
    }
    LogUtils.info(TAG, `updateLongPressMenuList end ${this.longPressMenuList.length}`);
  }

  private updateLongPressMenuList(isFavor?: boolean, isHiddenAlbum?: boolean): void {
    let tempMenuList: Action[] = [];
    if (!this.controller.isSelectMode) {
      tempMenuList.push(Action.MULTISELECT);
    }
    if (this.albumInfo.uri != "" && !this.albumInfo.isTrashAlbum && isFavor !== undefined) {
      tempMenuList.push(isFavor ? Action.FAVORITE : Action.NOT_FAVORITE);
    }
    if (this.albumInfo.isTrashAlbum) {
      tempMenuList.push(Action.RECOVER);
      tempMenuList.push(Action.DELETE);
    } else {
      tempMenuList.push(Action.LONG_PRESS_DELETE);
    }
    let msg: string = tempMenuList.map((action: Action) => action.componentKey).join(',');
    LogUtils.info(TAG, `longPressMenuList: ${msg}`);
    if (!UiUtil.isActionArrayEqual(this.longPressMenuList, tempMenuList)) {
      this.longPressMenuList = tempMenuList;
    }
    LogUtils.info(TAG, `updateLongPressMenuList end ${this.longPressMenuList.length}`);
  }

  // The callback when current page is in the foreground
  onActive(): void {
    if (!this.isActive) {
      ReportToBigDataUtil.report(BigDataConstants.ENTER_TIMELINE_PAGE);
      this.isActive = true;
      this.viewModel.dataSource.onActive();
    }
  }

  // The callback when current page is in the background
  onInActive(): void {
    LogUtils.info(TAG, 'call onInActive');
    if (this.isActive) {
      this.isActive = false;
      this.stopReadyProcess();
    }
  }

  private onMenuClickedForSingleItem(action: Action, currentPhoto: MediaItem): void {
    LogUtils.info(TAG, `single menu click, action: ${action?.actionID}, currentUri: ${currentPhoto?.uri},
      mpositon: ${currentPhoto?.mPosition}`);
    if (currentPhoto == undefined) {
      return;
    }

    // 弹窗删除对话框时不显示切换向导
    if (Action.LONG_PRESS_DELETE.actionID === action?.actionID) {
      this.viewModel.updateDayGuideState(false);
    }

    // 连拍照片的删除/隐藏等单独处理
    const burstHandleActions = [Action.LONG_PRESS_DELETE];
    if (currentPhoto?.getIsBurstPhotos() && burstHandleActions.includes(action)) {
      // let burstPhotosUtils: BurstPhotosUtils = new BurstPhotosUtils();
      // if (!this.viewModel.dayDataSource) {
      //   LogUtils.debug(TAG, 'handleBurstPhotos without dataSource');
      //   return;
      // }
      // burstPhotosUtils.longPressHandleBurstPhotos(action.actionID, currentPhoto,
      //   this.viewModel.dayDataSource, this.broadCast);
    } else {
      let otherParams: MenuOptionOtherParams = {
        currentIndex: this.viewModel.dayDataSource?.getDataIndex(currentPhoto),
        mediaCount: this.viewModel.dayDataSource?.getMediaCount(),
      };
      const albumInfo: AlbumInfo | undefined = this.viewModel.dayDataSource?.albumUri ? this.viewModel.dayDataSource?.albumInfo : undefined;
      menuOption(action.actionID, currentPhoto, this.broadCast, albumInfo, BigDataConstants.OPERATION_IN_TIMELINE_PAGE,
        undefined, otherParams);
    }
    let params: ParamsWrapper = new ParamsWrapper().set(MenuConstants.KEY_CONTEXT, getContext())
      .set(MenuConstants.KEY_IS_FROM_SINGLE_CLICK, true)
      .set(MenuConstants.KEY_CURRENT_PHOTO, currentPhoto);
    this.menuHelper.onMenuClicked(action, params);
  }

  private stopReadyProcess(): void {
    LogUtils.debug(TAG, 'stopReadyProcess');
    UserFileManagerAccess.getInstance().stopCreateThumbnailTask();
  }

  private onJumpPhotoBrowser(name: string, item: MediaItem, geometryTapIndex: number,
    geometryTransitionString: string, mPosition: number): void {
    if (!this.viewModel.isInCurrentForm()) {
      return;
    }
    let targetIndex = Constants.NOT_FOUND;
    if (!item?.uniqueId) {
      // 当uniqueId为空时，说明数据未刷新完成，使用mPosition来获取dataIndex
      targetIndex = this.viewModel.dataSource.layoutToData(mPosition);
    } else {
      targetIndex = this.viewModel.dayDataSource?.getDataIndex(item) ?? Constants.NOT_FOUND;
    }
    LogUtils.info(TAG, `targetIndex=${targetIndex}, mPosition=${mPosition}, uniqueId=${item?.uniqueId}`);
    targetIndex = targetIndex === Constants.NOT_FOUND ? mPosition : targetIndex;
    if (targetIndex === Constants.NOT_FOUND) {
      LogUtils.error(TAG, 'targetIndex is not found');
      return;
    }
    AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.viewModel.dayDataSource);
    if (geometryTapIndex !== undefined && geometryTransitionString !== undefined) {
      this.jumpToPhotoBrowserGeometryTransition(targetIndex, name, item, geometryTapIndex, geometryTransitionString);
      return;
    }
    this.jumpToPhotoBrowserNormal(targetIndex, name, item);
  }

  jumpToPhotoBrowserNormal(targetIndex: number, name: string, item: MediaItem): void {
    AppStorage.get<Router>('router')?.pushUrl({
      url: 'MainAbility/view/PhotoBrowser',
      params: {
        position: targetIndex,
        transition: name,
        leftBlank: this.leftBlank,
        pageFrom: this.getPageEntryFrom(),
      }
    });
  }

  private onJumpThirdPhotoBrowser(name: string, item: MediaItem, geometryTapIndex: number,
    geometryTransitionString: string): void {
    if (!this.viewModel.isInCurrentForm()) {
      return;
    }
    let targetIndex = this.viewModel.dayDataSource?.getDataIndex(item) ?? Constants.NOT_FOUND;
    if (targetIndex === Constants.NOT_FOUND) {
      LogUtils.error(TAG, 'targetIndex is not found');
      return;
    }
    LogUtils.info(TAG, `JUMP_THIRD_PHOTO_BROWSER.index: ${targetIndex} transition: ${name}`);
    AppStorage.setOrCreate(Constants.PHOTO_GRID_SELECT_MANAGER, this.viewModel.selectManager);
    AppStorage.setOrCreate(Constants.APP_KEY_PHOTO_BROWSER, this.viewModel.dataSource);
    if (geometryTapIndex !== undefined && geometryTransitionString !== undefined) {
      if (this.albumInfo.isTrashAlbum) {
        this.jumpToPhotoBrowserGeometryTransition(targetIndex, name, item, geometryTapIndex,
          geometryTransitionString);
      } else {
        this.jumpToSelectPhotoBrowserGeometryTransition(targetIndex, name, item, geometryTapIndex,
          geometryTransitionString);
      }
      return;
    }
    LogUtils.error(TAG, 'jump to selectPhotoBrowser error');
  }

  private onPlaceholderChanged(): void {
    this.controller.onPlaceholderChanged(this.placeholderIndex);
  }

  private onSpliceDataLoadingFinished(result: LoadingResult<MediaItem>): void {
    let oldVersion: number = result.oldPageData.version;
    let newVersion: number = result.newPageData.version;
    if (newVersion > oldVersion) {
      if (this.spliceItem !== undefined) {
        let currentGridScene: string = Constants.PHOTO_TRANSITION_TIMELINE;
        this.viewModel.dayDataSource?.getItemIndexByUri(this.spliceItem.uri, (index: number) => {
          LogUtils.info(TAG, `SpliceMenuOperation onJumpPhotoBrowser, currentIndex: index: ${index}`);
          if (this.spliceItem !== undefined) {
            this.jumpToPhotoBrowserGeometryTransition(index, currentGridScene, this.spliceItem,
              index, currentGridScene + this.viewModel.dayDataSource?.getMediaItemByPosition(index)?.hashCode);
            this.spliceItem = undefined;
          }
        });
      }
    }
  }

  private jumpToPhotoBrowserGeometryTransition(targetIndex: number, name: string, item: MediaItem, geometryTapIndex:
    number, geometryTransitionString: string): void {
    interface Msg {
      position: number;
      transition: string;
      leftBlank: number[];
      coverPhotoUri?: string;
      pageFrom: number;
      albumInfo: AlbumInfo;
      sortHelper: AlbumGridSortHelper;
    }

    const params: Msg = {
      position: targetIndex,
      transition: name,
      leftBlank: this.leftBlank,
      coverPhotoUri: this.coverPhotoUri,
      pageFrom: this.getPageEntryFrom(),
      albumInfo: this.albumInfo,
      sortHelper: AlbumGridSortHelper.getInstance(),
    };
    let gridController: GridController = new GridController();
    if (this.persistentId !== 0) {
      gridController.init(this.persistentId);
    }
    LogUtils.info(TAG, `jumpToPhotoBrowserGeometryTransition persistentId: ${this.persistentId}`);
    this.browserController.showBrowser(geometryTapIndex, geometryTransitionString, name, params, {
      caller: name,
      targetIndex: targetIndex,
      geometryTransitionString: geometryTransitionString,
      leftBlank: this.leftBlank,
      gridController: this.persistentId !== 0 ? gridController : undefined,
      isFromPortrait: this.pageName === Constants.PORTRAIT_PHOTO_GRID_PAGE,
      isFromGroup: this.pageName === Constants.GROUP_PHOTO_GRID_PAGE,
    });
  }

  private jumpToSelectPhotoBrowserGeometryTransition(targetIndex: number, name: string, item: MediaItem,
    geometryTapIndex: number, geometryTransitionString: string): void {
    interface Params {
      position: number;
      transition: string;
      leftBlank: number[];
      pageFrom: number;
    }
    let gridController: GridController = new GridController();
    if (this.persistentId !== 0) {
      gridController.init(this.persistentId);
    }
    LogUtils.info(TAG, `jumpToPhotoBrowserGeometryTransition persistentId: ${this.persistentId} ${targetIndex}`);
    const params: Params = {
      position: targetIndex,
      transition: name,
      leftBlank: this.leftBlank,
      pageFrom: this.getPageEntryFrom(),
    };

    this.browserController.showSelectBrowser(geometryTapIndex, geometryTransitionString, name, params, {
      caller: name,
      targetIndex: targetIndex,
      geometryTransitionString: geometryTransitionString,
      leftBlank: this.leftBlank,
      gridController: this.persistentId !== 0 ? gridController : undefined
    });
  }

  private getPageEntryFrom(): number {
    if (this.albumInfo.isTrashAlbum) {
      return Constants.ENTRY_FROM.RECYCLE
    }
    return Constants.ENTRY_FROM.NORMAL;
  }

  /**
   * 更新日期分组视图IrregularIndex
   */
  private updateLayoutOptions(): void {
    // 兼顾云同步卡片
    const isShowCard: boolean = this.isShowSdCardTip;
    this.controller.gridLayoutOptions = {
      regularSize: [1, 1],
      irregularIndexes: isShowCard ? [0, 1] : [0],
    };
  }

  build() {
    if (this.controller.isCanShow && this.controller.isShow) {
      this.buildDayGridView();
      // 相机权限对话框
      if (this.cameraAuthorizeDialogShow) {
        CameraAuthorizeDialog({
          cameraAuthCardShow: $cameraAuthCardShow,
          cameraAuthorizeDialogShow: $cameraAuthorizeDialogShow,
          from: CameraAuthLocationFromEnum.TimeLine,
        })
      }
    }
  }

  private updateRightClickMenuList(rightClickMenuList: RightClickMenuGroup[]): void {
    this.rightClickMenuList = rightClickMenuList;
  };
}
