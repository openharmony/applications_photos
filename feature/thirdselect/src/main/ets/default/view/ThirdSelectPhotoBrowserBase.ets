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

import router from '@ohos.router';
import Matrix4 from '@ohos.matrix4';
import {
  Action,
  BigDataConstants,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  BrowserConstants,
  Constants,
  Log,
  MediaDataSource,
  MediaItem,
  mMultimodalInputManager,
  PhotoDataSource,
  ReportToBigDataUtil,
  ScreenManager,
  SelectUtil,
  ThirdSelectManager,
  UiUtil,
  BrowserDataFactory,
  PhotoDataImpl,
  UserFileManagerAccess,
  MediaObserverNfyInfo
} from '@ohos/common';
import {
  BrowserController,
  PhotoBrowserBg,
  PhotoSwiper,
  ThirdSelectPhotoBrowserActionBar
} from '@ohos/common/CommonComponents';

import { FormConstants, IS_HORIZONTAL, LEFT_BLANK, SelectParams,
  THIRD_SELECT_IS_ORIGIN } from '../utils/ThirdSelectConstants';
import { ThirdSelectedPanel } from './ThirdSelectedPanel';
import { MouseTurnPageOperation } from '@ohos/browser/BrowserComponents';
import { Matrix4x4 } from '@ohos/common/src/main/ets/default/utils/Matrix4x4'
import ability from '@ohos.ability.ability';
import common from '@ohos.app.ability.common';
import { Results } from '@ohos/common/src/main/ets/default/view/PhotoSwiper';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import fileShare from '@ohos.fileshare';
import wantConstant from '@ohos.ability.wantConstant';
import { BusinessError } from '@ohos.base';
import userFileManager from '@ohos.filemanagement.userFileManager';

const TAG: string = 'thiSel_ThirdSelectPhotoBrowserBase';

interface Params {
  selectMode: boolean;
  position: number;
  transition: string;
  bundleName: string;
  title: string;
  maxSelectCount: number;
  isFromFa: boolean;
  isJustSelected: boolean
};

// third selection photoBrowser
@Component
export struct ThirdSelectPhotoBrowserBase {
  @Provide backgroundColorResource: Resource = $r('app.color.default_background_color');
  @State totalSelectedCount: number = 0;
  @Provide broadCast: BroadCast = new BroadCast();
  @Provide isSelected: boolean = true;
  @State isShowBar: boolean = true;
  @Provide isDefaultBackgroundColor: boolean = true;
  @State isPhotoScaled: boolean = false;
  @Provide pageFrom: number = Constants.ENTRY_FROM.NORMAL;
  selectManager: ThirdSelectManager | null = null;
  bundleName: string = '';
  isMultiPick = true;
  mTransition: string = '';
  controller?: SwiperController = new SwiperController();
  @Provide('transitionIndex') currentIndex: number = 0;
  @State currentUri: string = '';
  isFromFa: boolean = false;
  @Provide canSwipe: boolean = true;
  // position
  mPosition: number = 0;
  @State title: string = '';
  @Prop @Watch('onPageChanged') pageStatus: boolean = false;
  @StorageLink(LEFT_BLANK) leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  @StorageLink(IS_HORIZONTAL) isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  maxSelectCount: number = 0;
  @StorageLink('geometryOpacity') geometryOpacity: number = 1;
  @State @Watch('onGeometryChanged') geometryTransitionId: string = 'default_id';
  @Link isRunningAnimation: boolean;
  @ObjectLink browserController: BrowserController;
  @Provide isDeleting: boolean = false;
  // DataSource
  private dataSource: ThirdBrowserDataSource = new ThirdBrowserDataSource();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private geometryTransitionEnable: boolean = false;
  private isSelectMode: boolean = false;
  @State isJustSelected: boolean = true;
  private pullDownFunc: Function = (): Boolean => this.onBackPress();
  private dataSizeChangedFunc: Function = (size: number): void => this.onDataSizeChanged(size);
  private selectFunc: Function = (position: number, key: string, value: boolean): void =>
  this.selectCallback(position, key, value);
  private dataContentChangedFunc: Function = (index: number): void => this.onPhotoChanged(index);
  private jumpThirdPhotoBrowserFunc: Function = (name: string, item: MediaItem, isSelectMode = false): void =>
  this.jumpBrowserCallback(name, item, isSelectMode);
  private setDisableSwipeFunc: Function = (value: boolean): void => this.setDisableSwipe(value);
  newMediaItem: MediaItem | undefined = undefined;
  onEnterEdit: Function | undefined = undefined;
  canEditVideo: boolean = false;
  private editNewUri: string = '';
  private photoUnEdit: MediaItem | undefined = undefined;
  @Provide canEdit: boolean = false;
  private swiperDuration: number = 400;
  private panelId: string = 'ThirdSelectPhotoBrowserBase';
  private waitingUpdateIndex: number = -1;
  private waitingUpdateData: boolean = false;
  private isToEdit = false;
  albumUri = '';
  // 页面销毁时，ThirdSelectPhotoBrowserBase作为子组件可能仍未销毁，然后ThirdSelectPhotoBrowserBase在disappear时会调用
  // refreshData刷新panel，这时会导致Crash，该变量用于识别这种情况，并组织刷新panel
  private isPageDisappear: boolean = false;
  allPhotoDataSource: MediaDataSource | undefined = undefined;
  private funcOnDataReloadWithEdit: Function = async (): Promise<void> => await this.onDataReloadWithEdit();
  private funcPageDisappear: Function = (): void => this.pageDisappear();
  private funcUpdateEditItem: Function = (): void => this.updateEditItem();


  updateEditItem(): void {
    let currentPhoto = this.getCurrentPhoto();
    this.photoUnEdit = currentPhoto;
  }

  onGeometryChanged() {
    AppStorage.setOrCreate<string>('geometryTransitionBrowserId', this.geometryTransitionId);
  }

  aboutToAppear(): void {
    AppStorage.setOrCreate('isReplace', true);
    this.allPhotoDataSource = AppStorage.get<MediaDataSource>(Constants.APP_KEY_ALL_PHOTO_DATASOURCE);
    Log.info(TAG, 'photoBrowser aboutToAppear');
    this.backgroundColorResource = $r('app.color.black');
    this.isDefaultBackgroundColor = false;
    this.geometryTransitionId = AppStorage.get<string>('geometryTransitionBrowserId') as string;
    this.browserController.browserBackFunc = (): boolean => this.onBackPress();
    mMultimodalInputManager.registerListener((control: number) => {
      Log.info(TAG, `key control : ${control} index ${this.currentIndex}`);
      if (control == 0) {
        if (this.currentIndex > 0) {
          this.onPhotoChanged(this.currentIndex - 1);
        }
      } else if (control == 1) {
        if (this.currentIndex < this.dataSource.totalCount() - 1) {
          this.onPhotoChanged(this.currentIndex + 1);
        }
      } else {
        this.onBackPress();
      }
    });
    this.selectManager = AppStorage.get<ThirdSelectManager>(Constants.THIRD_SELECT_MANAGER) as ThirdSelectManager;
    this.dataSource.setAlbumDataSource(
      AppStorage.get<MediaDataSource>(Constants.APP_KEY_PHOTO_BROWSER) as MediaDataSource);
    this.isMultiPick = this.selectManager.getIsMultiPick();
    if (this.isMultiPick) {
      this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    } else {
      this.totalSelectedCount = 1;
    }

    let param: Params = this.browserController.browserParam as Params;
    this.isFromFa = param.isFromFa;
    this.isSelectMode = param.selectMode;
    if (param.selectMode) {
      this.dataSource.setSelectMode(this.selectManager);
    }
    this.onPhotoChanged(param.position);
    this.photoUnEdit = this.getCurrentPhoto();
    this.canEdit = AppStorage.get<boolean>(Constants.KEY_OF_IS_THIRD_EDITABLE) as boolean
    this.mTransition = param.transition;
    this.bundleName = param.bundleName;
    this.title = param.title;
    this.maxSelectCount = param.maxSelectCount;

    this.dataSource.setBroadCast(this.broadCast);

    this.broadCast.on(BrowserConstants.PULL_DOWN_END, this.pullDownFunc);
    this.broadCast.on(BrowserConstants.DATA_SIZE_CHANGED, this.dataSizeChangedFunc);
    this.broadCast.on(BroadCastConstants.SELECT, this.selectFunc);
    this.broadCast.on(BrowserConstants.DATA_CONTENT_CHANGED, this.dataContentChangedFunc);
    this.broadCast.on(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.jumpThirdPhotoBrowserFunc);
    this.broadCast.on(BrowserConstants.SET_DISABLE_SWIPE, this.setDisableSwipeFunc);
    this.broadCast.on(BroadCastConstants.UPDATE_EDIT_ITEM, this.funcUpdateEditItem);
    this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, this.funcOnDataReloadWithEdit);
    this.broadCast.on(BroadCastConstants.PICKER_PAGE_DISAPPEAR, this.funcPageDisappear);

    this.dataSource.getAlbumDataSource()?.setPhotoBroadCast(this.broadCast);

    if (this.pageStatus) {
      this.onPageShow();
    }
  }

  private pageDisappear(): void {
    this.isPageDisappear = true;
    this.onBackPress();
  }

  async onDataReloadWithEdit(): Promise<void> {
    Log.info(TAG, 'BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT animate to data reloaded start with edit');
    ReportToBigDataUtil.report(BigDataConstants.CREATE_THIRD_EDIT_SAVE, undefined);
    try {
      this.broadCast.emit(BroadCastConstants.CHANGE_SWIPER_DURATION, [0]);
      let uri: string = AppStorage.get<string>(BroadCastConstants.PHOTO_EDIT_SAVE_URI) ?? '';

      if (uri) {
        // is in current album
        let newIndex = this.dataSource.getDataIndexByUri(uri);

        if (newIndex != Constants.NOT_FOUND) {
          // Search for the position of new image/video after edit in current 500 items succeed
          AppStorage.setOrCreate<number>('placeholderIndex', newIndex);
          if (!this.isMultiPick) {
            this.currentIndex = newIndex;
            this.photoUnEdit = this.getCurrentPhoto();
          } else {
            let currentSelectIndex: number =
              (this.photoUnEdit ? this.selectManager?.checkItemInSelectMap(this.photoUnEdit) : -1) ??
              Constants.INVALID;
            this.currentIndex = newIndex;
            if (currentSelectIndex !== -1) {
              this.broadCast.emit(Constants.UPDATE_SELECTED, [false, this.photoUnEdit?.uri ?? '']);
              this.unSelectEditPhoto();
            }

            if (this.totalSelectedCount < this.maxSelectCount) {
              this.selectStateChangeEdit();
            }

            if (this.dataSource.getSelectMode() && this.selectManager) {
              this.dataSource.setSelectMode(this.selectManager);
            }
            this.photoUnEdit = this.getCurrentPhotoInTimeLine();
          }
          this.photoChangedByMediaItem(this.getCurrentPhotoInTimeLine());
        } else { // is not in current album or over 500
          // Search for the position of new image/video after edit in current 500 items failed
          this.canEdit = false;

          this.editNewUri = uri;
          this.dataSource.enableGetData(false);
          this.currentIndex = 0;
          this.dataSource.getItemIndexByUri(
            this.editNewUri,
            (index: number): void => this.onGetItemIndexByNewEditUri(index));
        }
      }
    } catch (e) {
      Log.error(TAG, `ON_DATA_RELOADED_WITH_EDIT error ${e}`);
    } finally {
      this.appBroadCast.emit(BroadCastConstants.PHOTO_EDIT_SAVE_COMPLETE, []);
    }

    this.dataSource.onDataReloaded();
  }

  photoChangedByMediaItem(mediaItem: MediaItem): void {
    if (this.dataSource.getSelectMode()) {
      this.currentIndex = this.dataSource.getDataIndex(mediaItem);
    } else {
      this.currentIndex = this.dataSource.getDataIndexByUri(this.photoUnEdit?.uri ?? '');
      // 先暂时不更新编辑图片 this.photoUnEdit = mediaItem;
    }

    let currentPhoto = mediaItem;
    this.canEdit = AppStorage.get<boolean>(Constants.KEY_OF_IS_THIRD_EDITABLE) as boolean &&
    UiUtil.isEditedEnable(currentPhoto);

    if (currentPhoto === undefined) {
      Log.error(TAG, 'onPhotoChanged, item is undefined');
    } else {
      this.isSelected = this.selectManager?.isItemSelected(currentPhoto.uri) ?? false;
      this.currentUri = currentPhoto.uri;

      let dataSourceIndex = this.isSelectMode ?
        (this.selectManager?.getSelectItemDataSourceIndex(currentPhoto) ?? Constants.INVALID) :
      this.currentIndex;
      let timelineIndex = this.dataSource.getPositionByIndex(dataSourceIndex);

      if (this.geometryTransitionId !== undefined && this.geometryTransitionId !== '') {
        AppStorage.setOrCreate<number>('placeholderIndex', timelineIndex as number);
        this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode() + this.isSelected;
        Log.info(TAG, `onPhotoChanged, index: ${this.currentIndex}, currentPhoto: ${currentPhoto.uri}, \
        geometryTransitionId = ${this.geometryTransitionId}, placeholderIndex = ${timelineIndex}`);
      }

      if (this.totalSelectedCount < this.maxSelectCount) {
        // 根据滑动方向 以及当前的位置 处理
        this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_PANEL_INDEX, [this.currentUri]);

        this.broadCast.emit(Constants.UPDATE_SELECTED, [true, this.currentUri]);
      }
    }
  }

  getCurrentPhotoInTimeLine(): MediaItem {
    return this.dataSource.getDataInTimeLine(this.currentIndex)?.data;
  }

  selectStateChangeEdit(): void {
    Log.info(TAG, 'change selected.');
    let currentPhoto = this.getCurrentPhotoInTimeLine();
    if (currentPhoto == undefined) {
      return;
    }
    this.isSelected = true;
    this.selectManager?.toggleEdit(currentPhoto.uri, true);
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;

    this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT, [currentPhoto.uri, this.isSelected]);
  }

  onGetItemIndexByNewEditUri(index: number): void {
    Log.info(TAG, `onGetItemIndexByNewEditUri: index=${index}`);
    if (this.editNewUri.length > 0) {
      if (index != Constants.NOT_FOUND) { // over 500
        Log.info(TAG, `data reloaded move to ${index}`);

        AppStorage.setOrCreate<number>('placeholderIndex', index);

        this.dataSource.enableGetData(true);
        this.dataSource.onDataReloaded();
        let result: Results = this.dataSource.getDataInTimeLine(this.currentIndex);
        if (result !== undefined) {
          let mediaItem: MediaItem = result.data;
          let pos: number = result.pos;
          let thumbnail: string = result.thumbnail;
          this.currentIndex = pos;
          this.newMediaItem = mediaItem;
          this.newMediaItem.setThumbnail(thumbnail);

          this.currentUri = this.editNewUri;
          this.editNewUri = '';

          this.updateSelectItemByNewEditIndexFromDataSource(this.currentIndex);

          if (this.dataSource.getSelectMode()) {
            AppStorage.setOrCreate<number>('placeholderIndex', Constants.INVALID);
          }
        } else {
          this.waitingUpdateIndex = index;
          this.waitingUpdateData = true;
        }
      } else { // other album and can not save new in this album
        Log.error(TAG, `edit new uri ${this.editNewUri} is invalid`);
        this.dataSource.enableGetData(true);
        this.dataSource.onDataReloaded();


        // 此时数据应当使用选中列表的数据
        let dataImpl: PhotoDataImpl | undefined =
          BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO) as PhotoDataImpl | undefined;
        dataImpl?.getDataByUri(this.editNewUri).then((fileAsset: userFileManager.FileAsset | undefined): void => {
          this.newMediaItem = new MediaItem(fileAsset);
          this.newMediaItem.setThumbnail(dataImpl?.getThumbnailSafe(this.newMediaItem.uri, this.newMediaItem.path));

          this.editNewUri = '';
          this.updateSelectItemByNewEditItem(this.newMediaItem, this.currentIndex);

          AppStorage.setOrCreate<number>('placeholderIndex', Constants.INVALID);
          this.geometryTransitionId = '';
        });
      }
    }
  }

  updateSelectItemByNewEditItem(mediaItem: MediaItem, index?: number): void {
    Log.info(TAG, `updateSelectItemByNewEditItem: index=${index}`);
    AppStorage.setOrCreate<number>('placeholderIndex', index as number); // timeLineIndex
    if (!this.isMultiPick) {
      this.currentIndex = index as number;
      this.photoUnEdit = this.getCurrentPhoto();
    } else {
      let currentSelectIndex =
        (this.photoUnEdit ? this.selectManager?.checkItemInSelectMap(this.photoUnEdit) : -1) ??
        Constants.INVALID;
      this.currentIndex = index as number;
      if (currentSelectIndex !== -1) {
        this.broadCast.emit(Constants.UPDATE_SELECTED, [false, this.photoUnEdit?.uri ?? '']);
        this.unSelectEditPhoto();
      }

      if (this.totalSelectedCount < this.maxSelectCount) {
        this.isSelected = true;
        this.selectManager?.toggleEditThree(mediaItem.uri, true, mediaItem);
        this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
        this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT, [mediaItem.uri, this.isSelected]);
      }

      if (this.dataSource.getSelectMode() && this.selectManager) {
        this.dataSource.setSelectMode(this.selectManager);
        this.photoUnEdit = mediaItem;
      }
    }
    this.photoChangedByMediaItem(mediaItem);
    this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT, [this.photoUnEdit?.uri ?? '', this.isSelected]);
  }

  updateSelectItemByNewEditIndexFromDataSource(index: number): void {
    Log.info(TAG, `updateSelectItemByNewEditIndexFromDataSource: index=${index}`);
    AppStorage.setOrCreate<number>('placeholderIndex', index); // timeLineIndex
    if (!this.isMultiPick) {
      this.currentIndex = index;
      this.photoUnEdit = this.getCurrentPhoto();
    } else {
      let currentSelectIndex =
        (this.photoUnEdit ? this.selectManager?.checkItemInSelectMap(this.photoUnEdit) : -1) ??
        Constants.INVALID;
      this.currentIndex = index;
      if (currentSelectIndex !== -1) {
        this.broadCast.emit(Constants.UPDATE_SELECTED, [false, this.photoUnEdit?.uri ?? '']);
        this.unSelectEditPhoto();
      }

      if (this.totalSelectedCount < this.maxSelectCount) {
        this.selectStateChangeEdit();
      }

      if (this.dataSource.getSelectMode() && this.selectManager) {
        this.dataSource.setSelectMode(this.selectManager);
      }
      this.photoUnEdit = this.getCurrentPhotoInTimeLine();
    }
    this.photoChangedByMediaItem(this.getCurrentPhotoInTimeLine());
    this.broadCast.emit(this.panelId + BroadCastConstants.UPDATE_SELECT, [this.photoUnEdit.uri, this.isSelected]);
  }

  unSelectEditPhoto(): void {
    Log.info(TAG, 'unSelectEditPhoto.');
    this.selectManager?.toggleEdit(this.photoUnEdit?.uri ?? '', false);
    this.isSelected = false;
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    Log.info(TAG, `totalSelectedCount: ${this.totalSelectedCount} after state change`);
  }

  onMediaLibDataNfy(nfyInfo: MediaObserverNfyInfo): void {
    Log.info(TAG, `onMediaLibDataNfy nfyInfo: ${JSON.stringify(nfyInfo)}`);
    this.dataSource.onDataReloaded();

    if (this.allPhotoDataSource !== undefined && this.allPhotoDataSource !== null) {
      this.allPhotoDataSource.onDataReloaded();
    }
  }

  onMediaLibDataChange(changeType: string): void {
    Log.info(TAG, `onMediaLibDataChange type: ${changeType}`);
    this.dataSource.onDataReloaded();

    if (this.allPhotoDataSource !== undefined && this.allPhotoDataSource !== null) {
      this.allPhotoDataSource.onDataReloaded();
    }
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'call aboutToDisappear');
    // 数据清理以及重置
    if (this.selectManager !== null) {
      if (this.selectManager?.isPreview) {
        this.selectManager.isPreview = false;
        this.selectManager.clickedSet.clear();

        this.selectManager.previewSet.forEach(
          (value: string) => {
            this.selectManager?.clickedSet.add(value);
          });
      }

      this.selectManager?.selectedMap.forEach(
        (value: MediaItem, key: string) => {
          if (this.selectManager != null && !(this.selectManager.clickedSet.has(key))) {
            if (value !== undefined) {
              this.selectManager.indexMap.delete(value);
            }
            this.selectManager.selectedMap.delete(key);
          }
        });

      // selectManager 多余数据处理
      this.selectManager?.previewSet.clear();
    }
    this.selectManager?.refreshData();

    this.broadCast.release();
    if (this.broadCast) {
      this.broadCast.off(BrowserConstants.PULL_DOWN_END, this.pullDownFunc);
      this.broadCast.off(BrowserConstants.DATA_SIZE_CHANGED, this.dataSizeChangedFunc);
      this.broadCast.off(BroadCastConstants.SELECT, this.selectFunc);
      this.broadCast.off(BrowserConstants.DATA_CONTENT_CHANGED, this.dataContentChangedFunc);
      this.broadCast.off(BroadCastConstants.JUMP_THIRD_PHOTO_BROWSER, this.jumpThirdPhotoBrowserFunc);
      this.broadCast.off(BrowserConstants.SET_DISABLE_SWIPE, this.setDisableSwipeFunc);
      this.broadCast.off(BroadCastConstants.UPDATE_EDIT_ITEM, this.funcUpdateEditItem);
      this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED_WITH_EDIT, this.funcOnDataReloadWithEdit);
      this.broadCast.off(BroadCastConstants.PICKER_PAGE_DISAPPEAR, this.funcPageDisappear);
    }
    this.dataSource.release();
    mMultimodalInputManager.unregisterListener();
    this.controller = undefined;
  }

  onDataSizeChanged(size: number): void {
    Log.info(TAG, `onDataSizeChanged, size is ${size}`);
    if (size == 0) {
      this.onBackPress();
    }
  }

  setDisableSwipe(value: boolean): void {
    Log.info(TAG, `set swiper swipe ${value}`);
    this.canSwipe = value;
  }

  onPhotoChanged(index: number): void {
    this.currentIndex = index;
    let currentPhoto = this.getCurrentPhoto();
    this.canEdit = (currentPhoto?.mediaType !== UserFileManagerAccess.MEDIA_TYPE_VIDEO);
    if (currentPhoto === undefined) {
      Log.error(TAG, 'onPhotoChanged, item is undefined');
    } else {
      this.isSelected = this.selectManager?.isItemSelected(currentPhoto.uri) ?? false;
      this.currentUri = currentPhoto.uri;

      let dataSourceIndex = this.isSelectMode ?
        (this.selectManager?.getSelectItemDataSourceIndex(currentPhoto) ?? Constants.INVALID) : index;
      let timelineIndex = this.dataSource.getPositionByIndex(dataSourceIndex);
      AppStorage.setOrCreate<number>('placeholderIndex', timelineIndex);
      this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode() + this.isSelected;
      Log.info(TAG, `onPhotoChanged, index: ${index}, currentPhoto: ${currentPhoto.uri}, \
        geometryTransitionId = ${this.geometryTransitionId}, placeholderIndex = ${timelineIndex}`);
    }
  }

  selectStateChange() {
    Log.info(TAG, 'change selected.');
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      return;
    }
    this.isSelected = !this.isSelected;
    if (this.isSelected) {
      this.selectManager?.toggle(currentPhoto.uri, true);
    } else {
      this.selectManager?.toggle(currentPhoto.uri, false);
    }
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    this.geometryTransitionId = this.browserController.pageFrom + currentPhoto.getHashCode() + this.isSelected;
    this.broadCast.emit(BroadCastConstants.UPDATE_SELECT, [currentPhoto.uri, this.isSelected]);
    Log.info(TAG, `totalSelectedCount: ${this.totalSelectedCount} after state change geometryTransitionId ${this.geometryTransitionId}`);
  }

  selectEditPhoto(newIdIndex: number) {
    this.currentIndex = newIdIndex;
    this.dataSource.resetSelectMode();
    let currentPhoto = this.getCurrentPhoto();
    if (currentPhoto == undefined) {
      return;
    }

    this.isSelected = false;

    this.selectManager?.toggle(this.photoUnEdit?.uri ?? '', false);

    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    Log.info(TAG, `totalSelectedCount: ${this.totalSelectedCount} after state change`);
  }

  selectCallback(position: number, key: string, value: boolean) {
    if (key === this.currentUri) {
      this.isSelected = value;
    }
    if (this.selectManager) {
      this.selectManager.toggle(key, value);
    }
    this.totalSelectedCount = this.selectManager?.getSelectedCount() ?? 0;
    Log.info(TAG, `totalSelectedCount: ${this.totalSelectedCount} after select callback`);
  }

  onPageChanged() {
    if (this.pageStatus) {
      this.onPageShow();
    } else {
      this.onPageHide();
    }
  }

  onPageShow() {
    Log.debug(TAG, 'onPageShow');
    this.appBroadCast.emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [true, this.mTransition]);
  }

  onPageHide() {
    Log.debug(TAG, 'onPageHide');
    this.appBroadCast.emit(BroadCastConstants.PHOTO_BROWSER_ACTIVE, [false, this.mTransition]);
    // 数据清理以及重置

    if (this.selectManager !== null) {
      if (this.selectManager?.isPreview === true) {
        this.selectManager.isPreview = false;
        this.selectManager.clickedSet.clear();
        for (let item of this.selectManager.previewSet) {
          this.selectManager?.clickedSet.add(item);
        }
      }

      this.selectManager?.selectedMap.forEach(
        (value: MediaItem, key: string) => {
          if (this.selectManager != null && !(this.selectManager.clickedSet.has(key))) {
            if (value !== undefined) {
              this.selectManager.indexMap.delete(value);
            }
            this.selectManager.selectedMap.delete(key);
          }
        });
      // selectManager 多余数据处理
      this.selectManager?.previewSet.clear();
      this.selectManager?.refreshData();
    }
  }

  onMenuClicked(action: Action) {
    Log.info(TAG, `onMenuClicked, action: ${action.actionID}`);
    if (action.actionID === Action.BACK.actionID) {
      interface Msg {
        from: string;
      }
      let msg: Msg = {
        from: BigDataConstants.BY_CLICK,
      }
      ReportToBigDataUtil.report(BigDataConstants.ESC_PHOTO_BROWSER_WAY, msg);
      this.onBackPress();
    } else if (action.actionID === Action.MATERIAL_SELECT.actionID) {
      Log.info(TAG, 'click UN_SELECTED');
      this.selectStateChange();
    } else if (action.actionID === Action.SELECTED.actionID) {
      Log.info(TAG, 'click SELECTED');
      this.selectStateChange();
    } else if (action.actionID === Action.OK.actionID) {
      Log.info(TAG, 'click OK');
      this.setPickResult();
    } else if (action.actionID === Action.EDIT.actionID) {
      Log.info(TAG, 'click EDIT');
      let currentPhoto = this.getCurrentPhoto();
      if (currentPhoto == undefined || currentPhoto.size == 0) {
        Log.warn(TAG, 'currentPhoto is undefined or size is 0.');
        return;
      }
      AppStorage.setOrCreate<MediaItem | undefined>('EditorMediaItem', currentPhoto);
      AppStorage.setOrCreate<string>('EditorAlbumUri', this.dataSource.getAlbumDataSource()?.albumUri);
      router.pushUrl({
        url: 'pages/EditMain'
      })
      this.isToEdit = true;
    }
  }

  getCurrentPhoto(): MediaItem {
    Log.debug(TAG, 'getCurrentPhoto  ' + this.currentIndex);
    return this.dataSource.getData(this.currentIndex)?.data;
  }

  onBackPress() {
    if (!this.isPageDisappear) {
      this.selectManager?.refreshData();
    }
    if (this.geometryTransitionEnable) {
      this.controller?.finishAnimation((): void => this.onBackPressInner());
    } else {
      router.back({
        url: '',
        params: { index: this.currentIndex }
      });
    }
    return true;
  }

  @Builder
  buildCheckBox() {
    if (this.isMultiPick) {
      Row() {
        Image(this.isSelected ? $r('app.media.picker_checkbox_selected_dark') : $r('app.media.picker_checkbox_unselected_dark'))
          .width($r('app.float.icon_size'))
          .aspectRatio(1)
          .key('Checkbox_' + this.currentIndex)
          .margin({
            right: $r('sys.float.ohos_id_max_padding_end'),
            bottom: $r('app.float.picker_browser_checkbox_margin_bottom')
          })
          .onClick(() => {
            this.selectStateChange();
          })
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .visibility(this.isShowBar ? Visibility.Visible : Visibility.Hidden)
      .opacity(this.geometryOpacity)
      .transition(TransitionEffect.opacity(0))
      .hitTestBehavior(HitTestMode.Transparent)
    }
  }

  @Builder
  buildPanel() {
    ThirdSelectedPanel({
      maxSelectCount: this.maxSelectCount,
      onMenuClicked: (action: Action): void => this.onMenuClicked(action),
      isBrowserMode: true,
      isMultiPick: this.isMultiPick,
      mTransition: TAG,
      isFromFa: this.isFromFa,
      currentUri: this.currentUri,
      isShowBar: $isShowBar,
      totalSelectedCount: $totalSelectedCount
    })
      .opacity(this.geometryOpacity)
      .transition(TransitionEffect.opacity(0))
      .hitTestBehavior(HitTestMode.Transparent)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Stack({ alignContent: Alignment.TopStart }) {
        PhotoBrowserBg({ isShowBar: $isShowBar })
          .opacity(this.geometryOpacity)
          .transition(TransitionEffect.opacity(0))

        PhotoSwiper({
          dataSource: this.dataSource,
          mTransition: this.mTransition,
          onPhotoChanged: (index: number) => this.onPhotoChanged(index),
          swiperController: this.controller,
          verifyPhotoScaledFunc:  (matrix?: Matrix4.Matrix4Transit) => this.verifyPhotoScaled(matrix),
          geometryTransitionEnable: true,
          broadCast: $broadCast,
          isRunningAnimation: $isRunningAnimation,
          isInSelectedMode: true
        })

        if (this.isHorizontal) {
          MouseTurnPageOperation({
            dataSource: this.dataSource,
            controller: this.controller,
            isPhotoScaled: this.isPhotoScaled,
            isShowBar: this.isShowBar
          })
            .opacity(this.geometryOpacity)
            .transition(TransitionEffect.opacity(0))
            .hitTestBehavior(HitTestMode.Transparent)

        }
        ThirdSelectPhotoBrowserActionBar({
          isMultiPick: this.isMultiPick,
          onMenuClicked: (action: Action): void => this.onMenuClicked(action),
          title: this.title,
          isThird: true,
          isShowBar: $isShowBar,
          totalSelectedCount: $totalSelectedCount
        })
          .opacity(this.geometryOpacity)
          .transition(TransitionEffect.opacity(0))
          .hitTestBehavior(HitTestMode.Transparent)
      }

      this.buildCheckBox()
      this.buildPanel()
    }
    .padding({ bottom: this.leftBlank[3] })
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: BrowserConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
    PageTransitionExit({ duration: BrowserConstants.PAGE_SHOW_ANIMATION_DURATION })
      .opacity(0)
  }

  verifyPhotoScaled(matrix?: Matrix4.Matrix4Transit): void {
    if (matrix) {
      let mat: number[] | undefined = (matrix.copy() as Matrix4x4).matrix4x4;
      if (mat) {
        let xScale: number = mat[0];
        let yScale: number = mat[5];
        Log.info(TAG, `photo in PhotoItem has Scaled x scale: ${xScale}, y scale: ${yScale}, mat: ${mat}`);
        this.isPhotoScaled = xScale != 1 || yScale != 1
      }
    } else {
      this.isPhotoScaled = false
      Log.info(TAG, `photo in PhotoItem has not Scaled isPhotoScaled: ${this.isPhotoScaled}`);
    }
  }

  private onBackPressInner(): void {
    this.browserController.hideBrowser();
  }

  private jumpBrowserCallback(name: string, item: MediaItem, isSelectMode = false): void {
    if (this.dataSource.getSelectMode() === false) {
      if (this.selectManager) {
        this.dataSource.setSelectMode(this.selectManager);
      }
      this.currentIndex = this.dataSource.getDataIndex(item);
      this.onPhotoChanged(this.currentIndex);
      this.dataSource.onDataReloaded();
    } else {
      if (this.dataSource && item && this.currentUri != item.uri) {
        Log.debug(TAG, `jumpBrowserCallback jump to item.uri ${item.uri}, currentUri ${this.currentUri}`)
        let tgtIndex = this.dataSource.getDataIndex(item);
        Log.debug(TAG, `jump to index ${tgtIndex}`);
        this.onPhotoChanged(tgtIndex);
        this.dataSource.onDataReloaded();
      }
    }
    this.photoUnEdit = item;
  }

  private setPickResult(): void {
    if (this.isFromFa) {
      let currentPhoto = this.getCurrentPhoto();
      if (currentPhoto) {
        Log.debug(TAG, `setPickResult. updateFormData obj: ${currentPhoto.uri}  currentIndex: ${this.currentIndex}`);
        this.appBroadCast.emit(BroadCastConstants.SAVE_FORM_EDITOR_DATA,
          ['', AppStorage.get<string>(FormConstants.FORM_ITEM_ALBUM_URI), AppStorage.get<Resource>(FormConstants.FORM_ITEM_DISPLAY_NAME),
          currentPhoto.uri, false]);
      } else {
        Log.error(TAG, 'Fa setPickResult is null');
      }
      return;
    }
    let uriArray: string[] = [];
    let mediaType: number;
    if (this.isMultiPick) {
      if (this.selectManager === null) {
        Log.error(TAG, 'Select Manager empty');
        return;
      }
      if (this.selectManager.isPreview) {
        uriArray = SelectUtil.getUriArray(this.selectManager?.previewSet ?? new Set());
      } else {
        uriArray = SelectUtil.getUriArray(this.selectManager?.clickedSet ?? new Set());
      }
      Log.info(TAG, `uri size: ${uriArray}`);
    } else {
      if (!AppStorage.get('isReplace')) {
        this.currentIndex = 0;
      }
      let currentPhoto = this.getCurrentPhoto();
      if (currentPhoto == undefined) {
        return;
      }
      uriArray = [currentPhoto.uri];
    }
    let promise: Promise<void> = SelectUtil.grantPermissionForUris(uriArray, this.bundleName);
    let abilityResult: ability.AbilityResult = {
      resultCode: 0,
      want: {
        parameters: {
          'select-item-list': uriArray,
        }
      }
    };
    let localStorage = LocalStorage.getShared();
    if (localStorage?.has(Constants.PHOTO_PICKER_SESSION_KEY)) {
      let session = localStorage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
      let param = localStorage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY);
      if (uriArray === null || uriArray === undefined || uriArray?.length === 0) {
        session?.terminateSelfWithResult(abilityResult).then((result: void) => {
          Log.info(TAG, `session terminateSelfWithResult abilityResult: ${JSON.stringify(abilityResult)} result: ${result}`);
        });
      } else {
        try {
          if (param?.bundleName) {
            Log.debug(TAG, `grantUriPermission to ${param?.bundleName}`);
            uriArray.forEach(uri => {
              fileShare.grantUriPermission(uri, param?.bundleName,
                wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION | wantConstant.Flags.FLAG_AUTH_WRITE_URI_PERMISSION,
                (err: BusinessError): void => {
                  Log.error(TAG, `failed to grantUriPermission to ${param?.bundleName}`);
                  session?.terminateSelfWithResult(abilityResult).then((result: void) => {
                    Log.info(TAG, `session terminateSelfWithResult abilityResult: ${JSON.stringify(abilityResult)} result: ${result}`);
                  });
                });
            })
          }
        } catch (err) {
          Log.error(TAG, `err: ${JSON.stringify(err)}`);
          session?.terminateSelfWithResult(abilityResult).then((result: void) => {
            Log.info(TAG, `session terminateSelfWithResult abilityResult: ${JSON.stringify(abilityResult)} result: ${result}`);
          });
        }
      }
    } else {
      let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
      context.terminateSelfWithResult(abilityResult).then((result: void) => {
        Log.info(TAG, `terminateSelf result: ${result}, self result ${JSON.stringify(abilityResult)}`);
      });
    }
    let selectedMap: Map<string, MediaItem> = this.selectManager?.selectedMap ?? new Map();
    SelectUtil.getCountOfMedia(uriArray, selectedMap).then((result: number[]) => {
      let isOrigin: boolean = AppStorage.get<boolean>(THIRD_SELECT_IS_ORIGIN) ?? false;
      if (isOrigin == undefined) {
        isOrigin = false;
      }

      interface Msg {
        isOriginalChecked: boolean;
        selectItemSize: number;
        selectImageSize: number;
        selectVideoSize: number;
      }

      let msg: Msg = {
        isOriginalChecked: isOrigin,
        selectItemSize: (uriArray === null || uriArray === undefined || uriArray.length <= 0) ? 0 : uriArray.length,
        selectImageSize: this.isMultiPick ? result[0] : (mediaType === UserFileManagerAccess.MEDIA_TYPE_IMAGE ? 1 : 0),
        selectVideoSize: this.isMultiPick ? result[1] : (mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO ? 1 : 0)
      }
      ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_RESULT, msg);
    });
  }
}

/**
 * 用于预览已选中的图片的dataSource
 * 数据源取自selectManager的当前已选中图片
 */
class ThirdBrowserDataSource extends PhotoDataSource {
  private isSelectMode = false;
  private selectedItems: MediaItem[] = [];

  totalCount() {
    if (this.isSelectMode) {
      return this.selectedItems.length;
    }
    return super.totalCount();
  }

  getData(index: number): Results {
    if (this.isSelectMode) {
      return this.packData(index, this.selectedItems[index]) as Results;
    }
    return super.getData(index) as Results;
  }

  setSelectMode(manager: ThirdSelectManager) {
    this.isSelectMode = true;
    this.selectedItems = manager.getSelectItems();
  }

  getDataIndex(item: MediaItem): number {
    if (this.isSelectMode) {
      for (let i = 0; i < this.selectedItems.length; i++) {
        let clicked: MediaItem = this.selectedItems[i];
        if (clicked.uri === item.uri) {
          return i;
        }
      }
      return Constants.NOT_FOUND;
    }
    return super.getDataIndex(item);
  }

  getDataInTimeLine(index: number): Results {
    return super.getData(index) as Results;
  }

  getSelectMode(): boolean {
    return this.isSelectMode;
  }

  resetSelectMode() {
    this.isSelectMode = false;
  }
}
