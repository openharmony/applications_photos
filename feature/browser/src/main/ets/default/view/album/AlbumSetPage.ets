/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { MenuOperation, WindowUtil } from '@ohos/common';
import {
  Action,
  AlbumInfo,
  AlbumSetDataInfo,
  AlbumSetDataSource,
  AlbumSetSelectManager,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  CommonObserverCallback,
  Constants,
  Log,
  MediaObserver,
  MenuContext,
  MenuOperationFactory,
  ScreenManager,
  TraceControllerUtils,
  UiUtil
} from '@ohos/common';
import {
  AlbumSetNewMenuOperation,
  CustomDialogView,
  MoveOrCopyBroadCastProp,
  NoPhotoIndexComponent,
  TabItemWithText
} from '@ohos/common/CommonComponents';
import { TimelineDataSourceManager } from '../../../../../../../timeline';
import { AlbumSetPageActionBar } from './AlbumSetPageActionBar';
import { AlbumSetPageToolBar } from './AlbumSetPageToolBar';
import { AlbumGridItemNewStyle } from './AlbumGridItemNewStyle';
import { AlbumSetDeleteMenuOperation } from './AlbumSetDeleteMenuOperation';
import { AlbumSetRenameMenuOperation } from './AlbumSetRenameMenuOperation';

const TAG: string = 'AlbumSetPage';
const TRANSITION_EFFECT_ALPHA: number = 0.99;

// Album Set Page
@Component
export struct AlbumSetPage {
  @Consume @Watch('onModeChange') isAlbumSetSelectedMode: boolean;
  @Provide('selectedCount') @Watch('updateRightClickMenuList') selectedAlbumsCount: number = 0;
  @Provide @Watch('updateRightClickMenuList') isDisableDelete: boolean = false;
  @Provide @Watch('updateRightClickMenuList') isDisableRename: boolean = false;
  @State isEmpty: boolean = TimelineDataSourceManager.getInstance().getDataSource().isEmpty();
  @Provide gridColumnsCount: number = 0;
  @Provide broadCast: BroadCast = new BroadCast();
  @Consume @Watch('onIndexPageShow') isShow: boolean;
  albums: AlbumSetDataSource = new AlbumSetDataSource(this.broadCast);
  appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  isInCurrentTab = false;
  isActive = false; // Whether the page is in the foreground
  scroller: Scroller = new Scroller();
  @Consume('isShowSideBar') @Watch('initGridRowCount') isSidebar: boolean;
  mSelectManager = new AlbumSetSelectManager();
  isDataFreeze: boolean = false;
  // the switch of distributed page
  @Provide isTabBarShow: boolean = false;
  @Provide rightClickMenuList: Action[] = [];
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @StorageLink('deviceType') deviceType: string | undefined = AppStorage.get<string>('deviceType');
  @State pageStatus: boolean = false;
  @State bottomHeight: number = 0;
  @StorageLink('selectedAlbumUri') selectedAlbumUri: string = '';
  @StorageLink('albumActionBarOpacity') albumActionBarOpacity: number = 1;
  @StorageLink('albumOpacity') albumOpacity: number = 1;
  @StorageLink('albumOtherScale') albumOtherScale: number = 1;
  private tabs: TabItemWithText[] = [
    new TabItemWithText($r('app.string.local'), false),
    new TabItemWithText($r('app.string.other_equipment'), false)
  ];
  private dataObserver: CommonObserverCallback = new CommonObserverCallback(this);
  private tabsController: TabsController = new TabsController();
  private currentIndex: number = Constants.LOCAL_TAB_INDEX;
  private needNotify = false;
  private ignoreLocalNotify = false;
  private minGridColumnsCount: number = 2;
  private onWinSizeChangedFunc: Function = (): void => this.initGridRowCount();
  private onTabChangedFunc: Function = (index: number): void => this.onTabChanged(index);
  private onStateResetFunc: Function = (index: number): void => this.onStateReset(index);
  private onSendMoveCopyBroadCastFunc: Function = (index: number): void => this.onSendMoveCopyBroadCast(index);
  private onLoadingFinishedFunc: Function = (size: number): void => this.onLoadingFinished(size);
  private onResetZeroFunc: Function = (pageNumber: number): void => this.onResetZero(pageNumber);
  private onMenuClickedFunc = (action: Action, arg: Object[]): void => this.onMenuClicked(action, arg);
  private selectFunc = (
    key: string, value: boolean, isDisableRename: boolean, isDisableDelete: boolean, callback: Function): void =>
  this.select(key, value, isDisableRename, isDisableDelete, callback);

  onMenuClicked(action: Action, arg: Object[]) {
    Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
    let menuContext: MenuContext;
    let menuOperation: MenuOperation;
    if (action.actionID === Action.NEW.actionID) {
      menuContext = new MenuContext();
      menuContext
        .withOperationStartCallback((): void => this.onOperationStart())
        .withOperationEndCallback((): void => this.onOperationEnd())
        .withAlbumSetDataSource(this.albums)
        .withBroadCast(this.broadCast);
      menuOperation =
        MenuOperationFactory.getInstance().createMenuOperation(AlbumSetNewMenuOperation, menuContext);
      menuOperation.doAction();
    } else if (action.actionID === Action.CANCEL.actionID) {
      this.isAlbumSetSelectedMode = false;
    } else if (action.actionID === Action.MULTISELECT.actionID) {
      this.isAlbumSetSelectedMode = true;
    } else if (action.actionID === Action.RENAME.actionID) {
      menuContext = new MenuContext();
      menuContext
        .withFromSelectMode(true)
        .withSelectManager(this.mSelectManager)
        .withOperationStartCallback((): void => this.onOperationStart())
        .withOperationEndCallback((): void => this.onOperationEnd())
        .withBroadCast(this.broadCast);
      menuOperation =
        MenuOperationFactory.getInstance().createMenuOperation(AlbumSetRenameMenuOperation, menuContext);
      menuOperation.doAction();
    } else if (action.actionID === Action.DELETE.actionID) {
      menuContext = new MenuContext();
      menuContext
        .withFromSelectMode(true)
        .withSelectManager(this.mSelectManager)
        .withOperationStartCallback((): void => this.onOperationStart())
        .withOperationEndCallback((): void => this.onOperationEnd())
        .withBroadCast(this.broadCast);
      menuOperation =
        MenuOperationFactory.getInstance().createMenuOperation(AlbumSetDeleteMenuOperation, menuContext);
      menuOperation.doAction();
    }
  }

  onOperationStart(): void {
    this.isDataFreeze = true;
    this.ignoreLocalNotify = true;
    this.albums.freeze();
  }

  onOperationEnd(): void {
    Log.debug(TAG, `onOperationEnd`);
    this.isDataFreeze = false;
    this.isAlbumSetSelectedMode = false
    this.ignoreLocalNotify = false;
    this.albums.onChange('image');
    this.albums.unfreeze();
  }

  aboutToAppear(): void {
    TraceControllerUtils.startTrace('AlbumSetPageAboutToAppear');
    Log.info(TAG, `AlbumSetPageAboutToAppear`);
    this.appBroadCast.on(BroadCastConstants.ON_TAB_CHANGED, this.onTabChangedFunc);
    this.appBroadCast.on(BroadCastConstants.RESET_STATE_EVENT, this.onStateResetFunc);
    this.appBroadCast.on(BroadCastConstants.SEND_COPY_OR_MOVE_BROADCAST, this.onSendMoveCopyBroadCastFunc);
    AppStorage.setOrCreate('setSelectManagerToAnother', this.mSelectManager);
    this.broadCast.on(Constants.ON_LOADING_FINISHED, this.onLoadingFinishedFunc);
    this.appBroadCast.on(BroadCastConstants.RESET_ZERO, this.onResetZeroFunc);

    MediaObserver.getInstance().registerObserver(this.dataObserver);

    this.onActive();

    this.updateRightClickMenuList();
    this.initGridRowCount();
    // 后续phone缩略图支持横竖屏后再放开
    if (AppStorage.get('deviceType') as string !== Constants.DEFAULT_DEVICE_TYPE) {
      ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedFunc);
    }

    let self = this;
    this.broadCast.on(BroadCastConstants.SELECT, this.selectFunc);
    this.mSelectManager.registerCallback('updateCount', (newState: number) => {
      Log.info(TAG, `updateSelectedCount ${newState}`);
      if (this.isDataFreeze) {
        return;
      }
      if (this.selectedAlbumsCount === 0 && newState === 0) {
        this.selectedAlbumsCount--;
      } else {
        this.selectedAlbumsCount = newState;
      }
    });
    this.mSelectManager.registerCallback('updateToolBarState',
      (isDisableRename: boolean, isDisableDelete: boolean) => {
        if (this.isDataFreeze) {
          return;
        }
        Log.info(TAG, `updateToolBarState:\
                    isDisableRename: ${isDisableRename}, isDisableDelete: ${isDisableDelete}`);
        this.isDisableRename = isDisableRename
        this.isDisableDelete = isDisableDelete
      }
    );

    if (Constants.LOCAL_TAB_INDEX == this.currentIndex) {
      this.tabs[Constants.LOCAL_TAB_INDEX].isSelected = true;
      this.tabs[Constants.OTHER_EQUIPMENT_TAB_INDEX].isSelected = false;
    } else {
      this.tabs[Constants.LOCAL_TAB_INDEX].isSelected = false;
      this.tabs[Constants.OTHER_EQUIPMENT_TAB_INDEX].isSelected = true;
    }
    TraceControllerUtils.finishTrace('AlbumSetPageAboutToAppear');
  }

  aboutToDisappear(): void {
    this.onInActive();
    this.broadCast.off(Constants.ON_LOADING_FINISHED, this.onLoadingFinishedFunc);
    this.broadCast.off(BroadCastConstants.SELECT, this.selectFunc);
    this.appBroadCast.off(BroadCastConstants.ON_TAB_CHANGED, this.onTabChangedFunc);
    this.appBroadCast.off(BroadCastConstants.RESET_STATE_EVENT, this.onStateResetFunc);
    this.appBroadCast.off(BroadCastConstants.SEND_COPY_OR_MOVE_BROADCAST, this.onSendMoveCopyBroadCastFunc);
    this.appBroadCast.off(BroadCastConstants.RESET_ZERO, this.onResetZeroFunc);
    MediaObserver.getInstance().unregisterObserver(this.dataObserver);
    this.dataObserver.clearSource();
    // 后续phone缩略图支持横竖屏后再放开
    if (AppStorage.get('deviceType') as string !== Constants.DEFAULT_DEVICE_TYPE) {
      ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChangedFunc);
    }
  }

  // Callback when the page is show.
  onIndexPageShow() {
    Log.info(TAG, `[onIndexPageShow] isShow=${this.isShow}, isInCurrentTab=${this.isInCurrentTab}`);
    if (this.isShow && this.isInCurrentTab) {
      this.onActive();
    } else if (!this.isShow && this.isInCurrentTab) {
      this.onInActive();
    } else {
    }
  }

  onModeChange() {
    Log.info(TAG, `onModeChange ${this.isAlbumSetSelectedMode}`);
    this.updateRightClickMenuList();
    if (!this.isAlbumSetSelectedMode) {
      this.mSelectManager.emitCallback('updateCount', [0]);
      this.mSelectManager.onModeChange(false);
    }
  }

  updateRightClickMenuList() {
    if (this.isAlbumSetSelectedMode) {
      this.rightClickMenuList = [];
      if (!this.isDisableRename && this.selectedAlbumsCount == 1) {
        this.rightClickMenuList.push(Action.RENAME);
      }
      if (!this.isDisableDelete && this.selectedAlbumsCount > 0) {
        this.rightClickMenuList.push(Action.DELETE);
      }
    }
  }

  onStateReset(index: number): void {
    if (index == Constants.ALBUM_PAGE_INDEX) {
      this.isAlbumSetSelectedMode = false;
    }
  }

  onTabChanged(index: number): void {
    if (index == Constants.ALBUM_PAGE_INDEX) {
      this.isInCurrentTab = true;
      this.onActive();
    } else {
      this.isInCurrentTab = false;
      this.isAlbumSetSelectedMode = false;
      this.onInActive();
    }
  }

  onLoadingFinished(size: number): void {
    this.isEmpty = (size == 0);
  }

  select(key: string, value: boolean, isDisableRename: boolean, isDisableDelete: boolean, callback: Function): void {
    this.mSelectManager.toolBarStateToggle(key, value, isDisableRename, isDisableDelete);
    if (this.mSelectManager.toggle(key, value)) {
      Log.info(TAG, 'enter event process');
      callback();
    }
  }

  onSendMoveCopyBroadCast(index: number): void {
    if (index == Constants.ALBUM_PAGE_INDEX) {
      MoveOrCopyBroadCastProp.getInstance().sendMoveOrAddBroadCast(this.broadCast);
    }
  }

  // Callback when the page is in the foreground
  onActive() {
    if (!this.isActive) {
      Log.info(TAG, 'onActive');
      this.isActive = true;
      if (this.currentIndex == Constants.LOCAL_TAB_INDEX) {
        this.onLocalAlbumSetActive();
      } else {
        this.onLocalAlbumSetInActive();
      }

      this.showNotify();
    }
  }

  // Callback when the page is in the background
  onInActive() {
    if (this.isActive) {
      Log.info(TAG, 'onInActive');
      this.isActive = false;
      this.albums && this.albums.onInActive();
    }
  }

  // Callback when the local albums' page is in the foreground
  onLocalAlbumSetActive() {
    if (this.currentIndex == Constants.LOCAL_TAB_INDEX) {
      Log.info(TAG, 'Local album set is on active');
      this.albums && this.albums.onActive();
    }
  }

  // Callback when the local albums' page is in the background
  onLocalAlbumSetInActive() {
    if (this.currentIndex == Constants.OTHER_EQUIPMENT_TAB_INDEX) {
      Log.info(TAG, 'Local album set is on inactive');
      this.albums && this.albums.onInActive();
    }
  }

  onResetZero(pageNumber: number) {
    if (pageNumber == Constants.ALBUM_PAGE_INDEX) {
      this.scroller.scrollEdge(Edge.Top);
    }
  }

  initGridRowCount(): void {
    Log.info(TAG, `get screen width is : ${ScreenManager.getInstance().getWinWidth()}`);
    Log.info(TAG, `get screen height is : ${ScreenManager.getInstance().getWinHeight()}`);
    let currentBreakpoint = AppStorage.get<string>('currentBreakpoint');
    if (currentBreakpoint === Constants.BREAKPOINT_LG && this.deviceType == Constants.PAD_DEVICE_TYPE) {
      this.gridColumnsCount = UiUtil.getAlbumGridCount(true);
    } else {
      this.gridColumnsCount = UiUtil.getAlbumGridCount(this.isSidebar);
    }
    Log.info(TAG, `the grid count in a line is: ${this.gridColumnsCount}`);
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    if (!this.ignoreLocalNotify) {
      this.albums.onChange(changeType);
    }
  }

  isRecycleAlbumOfPhoneLikeDevice(item: AlbumInfo): boolean {
    return this.deviceType != Constants.PC_DEVICE_TYPE && item.isTrashAlbum;
  }

  @Builder
  LocalAlbumSet() {
    Stack() {
      if (!this.isEmpty) {
        Grid(this.scroller) {
          LazyForEach(this.albums, (item: AlbumSetDataInfo, index?: number) => {
            GridItem() {
              if (this.selectedAlbumUri === item.data.uri) {
                Column() {
                }
                .width('100%')
                .height(AppStorage.get<string>(Constants.KEY_OF_ALBUM_WIDTH) as string)
                .key('' + index)
              } else {
                AlbumGridItemNewStyle({
                  item: item.data,
                  isSelected: this.isAlbumSetSelectedMode ?
                  this.mSelectManager.isItemSelected(item.data.uri) : false,
                  onMenuClicked: this.onMenuClickedFunc,
                  onMenuClickedForSingleItem: (action: Action, currentAlbum: AlbumInfo): void =>
                  this.onMenuClickedForSingleItem(action, currentAlbum),
                  keyIndex: index,
                  bottomHeight: $bottomHeight
                })
                  .transition(TransitionEffect.opacity(TRANSITION_EFFECT_ALPHA))
              }
            }
            .margin({
              bottom: this.bottomHeight
            })
            .clip(false)
            .key('Album_' + index)
          }, (item: AlbumSetDataInfo) => {
            if (item.data.mediaItem) {
              return item.data.getHashCode() + item.data.mediaItem.getHashCode();
            }
            return item.data.getHashCode();
          })
        }
        .edgeEffect(EdgeEffect.Spring)
        .clip(false)
        .columnsTemplate('1fr '.repeat(this.gridColumnsCount))
        .padding({
          top: $r('app.float.album_set_page_padding_top'),
          bottom: this.isHorizontal ? 0 : $r('app.float.tab_bar_vertical_height'),
          left: $r('sys.float.ohos_id_card_margin_start'),
          right: $r('sys.float.ohos_id_card_margin_end')
        })
        .columnsGap($r('sys.float.ohos_id_card_margin_middle'))
        .rowsGap($r('sys.float.ohos_id_elements_margin_vertical_l'))
        .scrollBar(BarState.Auto)
      }
    }
  }

  build() {
    Stack() {
      Flex({
        direction: FlexDirection.Column,
        justifyContent: FlexAlign.Start,
        alignItems: ItemAlign.Start
      }) {
        if (!this.isEmpty || this.isTabBarShow) {
          Column() {
            AlbumSetPageActionBar({ onMenuClicked: this.onMenuClickedFunc })
              .opacity(this.albumActionBarOpacity)
          }
          .backgroundColor($r('app.color.default_background_color'))
          Column() {
            this.LocalAlbumSet()
          }
          .zIndex(Constants.NEGATIVE_1)
          .opacity(this.albumOpacity)
          .scale({ x: this.albumOtherScale, y: this.albumOtherScale })
          .layoutWeight(Constants.NUMBER_1)
        }
        if (this.isAlbumSetSelectedMode) {
          AlbumSetPageToolBar({ onMenuClicked: this.onMenuClickedFunc })
        }

        if (this.isEmpty && !this.isTabBarShow) {
          NoPhotoIndexComponent({ index: Constants.ALBUM_PAGE_INDEX, hasBarSpace: true })
        }
      }

      CustomDialogView({ broadCast: $broadCast })
    }
  }

  private onMenuClickedForSingleItem(action: Action, currentAlbum: AlbumInfo) {
    Log.info(TAG, `single menu click, action: ${action?.actionID}, currentUri: ${currentAlbum?.albumName}`);
    if (currentAlbum == undefined) {
      return;
    }
    let menuContext: MenuContext;
    let menuOperation: MenuOperation;
    if (action.actionID === Action.RENAME.actionID) {
      menuContext = new MenuContext();
      menuContext
        .withFromSelectMode(false)
        .withAlbumInfo(currentAlbum)
        .withOperationStartCallback((): void => this.onOperationStart())
        .withOperationEndCallback((): void => this.onOperationEnd())
        .withBroadCast(this.broadCast);
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(AlbumSetRenameMenuOperation, menuContext);
      menuOperation.doAction();
    } else if (action.actionID === Action.DELETE.actionID) {
      menuContext = new MenuContext();
      menuContext
        .withFromSelectMode(false)
        .withAlbumInfo(currentAlbum)
        .withOperationStartCallback((): void => this.onOperationStart())
        .withOperationEndCallback((): void => this.onOperationEnd())
        .withBroadCast(this.broadCast);
      menuOperation = MenuOperationFactory.getInstance()
        .createMenuOperation(AlbumSetDeleteMenuOperation, menuContext);
      menuOperation.doAction();
    }
  }

  private showNotify() {
    if (this.needNotify) {
      UiUtil.showToast($r('app.string.distributed_album_disconnected'));
      this.needNotify = false;
    }
  }

  private onDistributedTabChanged(index: number) {
    this.currentIndex = index;
    if (index == Constants.LOCAL_TAB_INDEX) {
      this.onLocalAlbumSetActive();
    } else {
      this.onLocalAlbumSetInActive();
    }
  }

  private onUpdateRemoteDevice(res: string, deviceId: string, size: number): void {
    Log.info(TAG, `onUpdateRemoteDevice size: ${size} deviceId: ${deviceId} type: ${res}`);

    if (res == 'offline') {
      this.needNotify = true;
    }

    if (size <= 0) {
      this.currentIndex = Constants.LOCAL_TAB_INDEX
      try {
        this.tabsController.changeIndex(this.currentIndex);
      } catch (error) {
        Log.debug(TAG, `change tab index failed: ${error}`);
      }
      this.tabs[Constants.LOCAL_TAB_INDEX].isSelected = true;
      this.tabs[Constants.OTHER_EQUIPMENT_TAB_INDEX].isSelected = false;

      if (this.isActive) {
        this.showNotify();
      }
    }

    this.isTabBarShow = (size > 0);
  }
}
