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

import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy {
  getScreen,
  isOrientationHorizontal,
  ScreenManager
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { PageStatus } from '@ohos/common/src/main/ets/default/model/common/AvPlayConstants';
import lazy { PickerSheetContent } from './PickerSheetContent';
import lazy { SelectConstants, SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy ability from '@ohos.ability.ability';
import lazy screenLock from '@ohos.screenLock';
import lazy { THIRD_SELECT_IS_ORIGIN } from '@ohos/thirdselect/src/main/ets/default/utils/ThirdSelectConstants';
import lazy {
  ThirdSelectGridController,
  ThirdSelectGridListener
} from '@ohos/thirdselect/src/main/ets/default/view/ThirdSelectPhotoGridBase';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { BurstPhotoUtils } from '@ohos/common/src/main/ets/default/utils/BurstPhotoUtils';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy wantConstant from '@ohos.app.ability.wantConstant';
import lazy { PickerSelectTipToast } from '@ohos/thirdselect/src/main/ets/default/view/PickerSelectTipToast';
import lazy { PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy { PhotoDataImpl } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataImpl';
import lazy { PickerMediaDataSource } from '@ohos/thirdselect/src/main/ets/default/common/PickerMediaDataSource';
import lazy { PickerDataSourceManager } from '@ohos/thirdselect/src/main/ets/default/common/PickerDataSourceManager';
import lazy { SaveRecoverInfo } from '@ohos/thirdselect/src/main/ets/default/utils/recoverScene/SaveRecoverInfo';
import lazy { display } from '@kit.ArkUI';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { image } from '@kit.ImageKit';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';

// instrument ignore file
const TAG: string = 'PickerSheetPage';

let storage: LocalStorage = LocalStorage.getShared();

@Entry(storage)
@Component
export struct PickerSheetPage {
  @State private pageStatus: boolean = false;
  @State private showClose: boolean = true;
  @State private isSheetShow: boolean = true;
  @State private browserController: BrowserController = new BrowserController(true);
  // 广播
  @State private broadCast: BroadCast = new BroadCast();
  @State private isShowContent: boolean = false;
  // 横竖屏
  @StorageLink('isHorizontal') private isHorizontal: boolean = isOrientationHorizontal();
  @State private thirdSelectGridController: ThirdSelectGridController = new ThirdSelectGridController();
  private param: SelectParams = new SelectParams();
  @State private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  @State private isShowPickerSelectTip: boolean = false;
  private updateShoeCloseFun: Function = (showClose: boolean): void => this.updateShoeCloseStatue(showClose);
  // 合一编辑器场景默认避让的摄像头高度
  private defaultCameraHeight: number = 38;
  // bindSheet默认的避让高度，参考半模态转场说明
  private defaultAvoidHeight: number = 8;
  private onBackFunc: Function = (): void => {
  };
  private onWindowSizeChangedFunc: Function = (): void => this.onWindowSizeChanged();
  @State private bindSheetHeight: Length | SheetSize = 0;
  private readonly thirdSelectGridListener: ThirdSelectGridListener = {
    onCompleted: (items: MediaItem[]) => this.onThirdSelectComplete(items),
    onCompletedWithUris: (uris: string[]) => this.onThirdSelectCompleteWithUris(uris),
    onCancelled: (): void => this.onThirdSelectCancel(),
  } as ThirdSelectGridListener;
  @State private searchKeyword: string = '';
  private onPickerHiddeFunc: Function = (isPickerHidden: boolean): void => this.onPickerHidden(isPickerHidden);
  @State private isPickerHidden: boolean = false;
  @StorageLink('unDataGridCount') private unDataGridCount: number = 0;
  @StorageLink('loadedSize') loadedSize: number = 0;
  @StorageLink('chosenItemIndex') chosenItemIndex: number = 0;
  private photoDataImpl: PhotoDataImpl | undefined;
  private dataSource: PickerMediaDataSource | undefined;
  private pickerPanelHeight: number = 52;
  private footerNavigationHeight: number = 28;
  private pickerActionBarHeight: number = 72;

  aboutToAppear(): void {
    Log.info(TAG, 'pickerSheetPage aboutToAppear in.');
    let pickerDataSourceManager: PickerDataSourceManager | undefined =
      storage?.get<PickerDataSourceManager>(Constants.PHOTO_PICKER_PICKER_DATA_SOURCE_MANAGER);
    this.photoDataImpl = pickerDataSourceManager?.getDataImpl();
    this.dataSource = pickerDataSourceManager?.getDataSource();
    this.param = storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY) as SelectParams;
    this.broadCast.on(Constants.UPDATE_SHEETCONTAINER_SHOECLOSE, this.updateShoeCloseFun);
    this.refreshFoldStatus();
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFunc);
    this.bindSheetHeight = this.bindSheetStatusBarHeight();
    this.thirdSelectGridController.hasDelegate = true;
    if (this.isVerdeFoldable) {
      this.isShowPickerSelectTip = true;
      setTimeout((): void => {
        this.isShowPickerSelectTip = false;
      }, Constants.DELAY_THREE_SECOND);
    }
    this.thirdSelectGridController.register(this.thirdSelectGridListener);
    if (screenLock.isLocked()) { // 锁屏场景不处理 UPDATE_PICKER_VISIBILITY
      Log.info(TAG, 'screenLock');
    } else {
      this.broadCast.on(Constants.UPDATE_PICKER_VISIBILITY, this.onPickerHiddeFunc);
    }
  }

  aboutToDisappear(): void {
    this.broadCast.off(Constants.UPDATE_SHEETCONTAINER_SHOECLOSE, this.updateShoeCloseFun);
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFunc);
    this.broadCast.off(Constants.UPDATE_PICKER_VISIBILITY, this.onPickerHiddeFunc);
    storage.delete(BroadCastConstants.UPDATE_IS_PICKER_SPLIT_SCREEN);
    storage.delete(BroadCastConstants.UPDATE_PICKER_IMAGE_DISPLAY_HEIGHT);
    storage.delete(BroadCastConstants.UPDATE_IMAGE_HEIGHT);
    storage.delete(BroadCastConstants.UPDATE_STACK_HEIGHT);
  }

  private refreshFoldStatus(): void {
    try {
      AppStorage.setOrCreate(Constants.FOLD_DISPLAY_MODE, display.getFoldDisplayMode());
    } catch (err) {
      Log.warn(TAG, `refreshFoldStatus err code:${err?.code}, err msg:${err?.msg} `);
    }
  }

  private async onThirdSelectComplete(items: MediaItem[]): Promise<void> {
    Log.info(TAG, 'onThirdSelectComplete');
    this.isSheetShow = false;
    if (items && items.length === 0) {
      setTimeout((): void => {
        this.reportStylePhotoEvent(false);
        let session: UIExtensionContentSession | undefined =
          storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
        session?.terminateSelf();
      }, 100);
    } else {
      let uris = await BurstPhotoUtils.getBurstUris(items);
      this.onThirdSelectCompleteWithUris(uris);
    }
  }

  private async onThirdSelectCompleteWithUris(uris: string[]): Promise<void> {
    this.isSheetShow = false;
    Log.info(TAG, 'onThirdSelectCompleteWithUris start to execute');
    let session: UIExtensionContentSession | undefined =
      storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
    let hideSensitiveType = PhotoAccessHelperAccess.getPrivacyStatusByTokenId(this.param.tokenId);
    let result: number | undefined =
      await PhotoAccessHelperAccess.grantPermissionForUris(getContext(), this.param?.tokenId, uris, hideSensitiveType);
    Log.info(TAG, `grantPermissionForUris end, uris size:${uris?.length}, result is: ${result}`);
    let abilityResult = await this.getAbilityResult(uris);
    setTimeout((): void => {
      this.reportStylePhotoEvent(true)
      session?.terminateSelfWithResult(abilityResult).then((result: void) => {
        Log.info(TAG, `terminateSelfWithResult result: ${result}, self result ${JSON.stringify(abilityResult)}`);
      });
    }, 100);
  }

  public async getAbilityResult(uris: string[]): Promise<ability.AbilityResult> {
    let isOrigin: boolean = LocalStorage.getShared()?.get<boolean>(THIRD_SELECT_IS_ORIGIN) ?? false;
    let isSceneBoard: boolean = this.param?.bundleName === Constants.SCENEBOARD_BUNDLE_NAME;
    let saveRecoverInfo: SaveRecoverInfo =
      new SaveRecoverInfo(this.dataSource, this.unDataGridCount, this.loadedSize, this.chosenItemIndex, isSceneBoard);
    let albumUri: string = saveRecoverInfo.getAlbumUri();
    let time: number = await saveRecoverInfo.getTime(albumUri);
    let displayName: string = saveRecoverInfo.getDisplayName();
    let recommendationType: number = saveRecoverInfo.getRecommendationType(this.param);
    let selectedRecommendationType: number = saveRecoverInfo.getSelectedRecommendationType();
    return {
      resultCode: uris ? 0 : -1,
      want: {
        parameters: {
          'select-item-list': uris as Object,
          isOriginal: isOrigin,
          'albumUri': albumUri,
          'time': time.toString(),
          'displayName': displayName,
          'recommendationType': recommendationType,
          'selectedRecommendationType': selectedRecommendationType,
        }
      }
    }
  }

  private onThirdSelectCancel() {
    Log.info(TAG, 'onThirdSelectCancel');
    this.isSheetShow = false;
    setTimeout((): void => {
      this.reportStylePhotoEvent(false);
      let session: UIExtensionContentSession | undefined =
        storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
      session?.terminateSelf();
    }, 100);
  }

  private updateShoeCloseStatue(showClose: boolean) {
    this.showClose = showClose;
  }

  private onWindowSizeChanged(): void {
    AppStorage.setOrCreate('getFoldStatus', DeviceInfo.isFoldable());
    AppStorage.setOrCreate(Constants.FOLD_DISPLAY_MODE, display.getFoldDisplayMode());
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
    this.bindSheetHeight = this.bindSheetStatusBarHeight();
  }

  private onPickerHidden(isPickerHidden: boolean): void {
    Log.info(TAG, `onPickerHidden: ${isPickerHidden}`);
    this.isPickerHidden = isPickerHidden;
  }

  onPageShow() {
    this.pageStatus = true;
    LocalStorage.getShared()?.setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.SHOW);
  }

  onPageHide() {
    this.pageStatus = false;
    LocalStorage.getShared()?.setOrCreate<PageStatus>(Constants.VIDEO_PAGE_STATUS, PageStatus.HIDE);


  }

  onBackPress() {
    if (this.browserController.isBrowserShow) {
      this.browserController.browserBackFunc?.();
      return true;
    }
    if (this.onBackFunc && !this.param?.isFromPickerView) {
      this.onBackFunc();
      return true;
    }
    return false;
  }

  private bindSheetStatusBarHeight(): Length | SheetSize {
    if (!this.isHorizontal && DeviceInfo.isPhoneUx() && !DeviceInfo.isFoldable() && !getScreen().isSplitMode()) {
      // 适配合一编辑器场景，避让摄像头
      if (this.param.bundleName === Constants.SCENEBOARD_BUNDLE_NAME) {
        // 底部弹窗距离信号栏为8vp
        let statusBarHeight: number =
          this.param.statusBarHeight === 0 ? this.defaultCameraHeight : this.param.statusBarHeight;
        Log.info(TAG, `statusBarHeight is ${statusBarHeight}`)
        return getScreen().getWinHeight() - statusBarHeight - this.defaultAvoidHeight;
      }
      // 适配其他场景，避让摄像头
      const relativePos = getScreen().calcActualArea();
      Log.info(TAG, 'bindSheetStatusBarHeight' + getScreen().getWinHeight());
      return getScreen().getWinHeight() - relativePos.top - this.defaultAvoidHeight;
    }
    return SheetSize.LARGE;
  }

  private bindBackFunc(backFunc: Function): void {
    this.onBackFunc = backFunc;
  }

  private bindSheetOnWillDismiss(dismissSheetAction: DismissSheetAction): boolean {
    if (this.browserController.isBrowserShow &&
      dismissSheetAction.reason == DismissReason.PRESS_BACK) {
      this.broadCast.emit(BroadCastConstants.BROWSER_ON_BACK_PRESS, []);
      return true;
    }
    return false;
  }

  private reportStylePhotoEvent(isSelectData: boolean): void {
    if (this.param.recommendationType !== SelectConstants.RECOMMEND_TYPE_COLOR_STYPE) {
      return;
    }
    const msg: Record<string, boolean> = { 'carryOrNotData': isSelectData };
    ReportToBigDataUtil.report(BigDataConstants.SELECT_PICKER_FOR_STYLE_PHOTO, msg);
  }

  @Builder
  PickerContents() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.isShowContent) {
        PickerSheetContent({
          pageStatus: this.pageStatus,
          broadCast: this.broadCast,
          storage: storage,
          param: this.param,
          browserController: this.browserController,
          backFuncBinder: (backFunc: Function): void => this.bindBackFunc(backFunc),
          thirdSelectGridController: this.thirdSelectGridController,
          searchKeyword: this.searchKeyword,
          photoDataImpl: this.photoDataImpl,
          dataSource: this.dataSource,
        })
      }
      if (this.isVerdeFoldable && this.isShowPickerSelectTip) {
        Column() {
          PickerSelectTipToast()
        }
        .margin({
          bottom: this.getToastMarginBottom(),
        });
      }
    }
    .onAreaChange((oldValue: Area, newValue: Area): void => {
      /**
       * 单选模式下:获取半模态的高度减去buildActionBar:72vp,ThirdSelectedPanel内buildOriginButton容器高52,
       * 以及PickerSelectTip的高28vp和距离底部的28vp
       */
      let totalBarHeight: number = this.pickerActionBarHeight + this.pickerPanelHeight +
        this.footerNavigationHeight * 2;
      let imageDisplayHeight: number = Number(newValue.height) - totalBarHeight;
      let areaRatio: number = ImageUtil.calcRatio({
        width: newValue.width,
        height: imageDisplayHeight,
      } as image.Size);
      let maxImageHeight = Number(newValue.height) - this.pickerActionBarHeight - this.footerNavigationHeight * 2;
      storage.setOrCreate(BroadCastConstants.UPDATE_PICKER_IMAGE_DISPLAY_HEIGHT, areaRatio);
      storage.setOrCreate(BroadCastConstants.UPDATE_IMAGE_HEIGHT, maxImageHeight);
      storage.setOrCreate(BroadCastConstants.UPDATE_STACK_HEIGHT, Number(newValue.height));
      Log.info(TAG, `onRootAreaChange: ${newValue.width}, ${newValue.height}, ${imageDisplayHeight}, ${areaRatio}`);
    })
    .width('100%')
    .height('100%')
    .onAppear(() => {
      this.isShowContent = true;
    })
    .visibility(this.isPickerHidden ? Visibility.Hidden : Visibility.Visible)
  }

  private getToastMarginBottom(): number {
    if (this.param.isFromPickerView) {
      return Constants.PICKER_SELECT_TIP_BOTTOM_COMPONENT;
    }
    if (this.param.maxSelectCount === 1) {
      return Constants.PICKER_SELECT_TIP_BOTTOM_ABILITY;
    }
    return Constants.PICKER_SELECT_TIP_BOTTOM;
  }

  @Builder
  SheetContainer() {
    Stack() {
    }
    .width('100%')
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area): void => {
      //判断当前是否是三分之一分屏模式,px2vp(display.getDefaultDisplaySync().height):转化为vp的屏幕高度,为false代表当前是三分之一屏
      let splitScreenRatio = Number(newValue.height) / px2vp(display.getDefaultDisplaySync().height);
      let isPickerSplitScreen = splitScreenRatio > 0.4;
      let landScapeSplitScreenRatio = Number(newValue.width) / px2vp(display.getDefaultDisplaySync().width);
      let isHalfScreen = splitScreenRatio > 0.4 && splitScreenRatio <= 0.5 ||
        landScapeSplitScreenRatio > 0.4 && landScapeSplitScreenRatio <= 0.5;
      storage.setOrCreate(BroadCastConstants.UPDATE_IS_PICKER_SPLIT_SCREEN, isPickerSplitScreen);
      storage.setOrCreate(BroadCastConstants.UPDATE_IS_HALF_SCREEN, isHalfScreen);
      Log.info(TAG, `isPickerSplitScreen: ${isPickerSplitScreen},${isHalfScreen},${landScapeSplitScreenRatio}`);
    })
    .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    .bindSheet($$this.isSheetShow, this.PickerContents(), {
      showClose: (this.showClose && !this.isPickerHidden && !(DeviceInfo.isPhoneUx() || DeviceInfo.isTablet())),
      preferType: SheetType.CENTER,
      backgroundColor: this.isPickerHidden ? '#00000000' : $r('sys.color.ohos_id_color_panel_bg'),
      height: this.isVerdeFoldable ? SheetSize.LARGE : this.bindSheetHeight,
      onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
        Log.info(TAG, 'bind sheet onWillDismiss');
        if (this.bindSheetOnWillDismiss(dismissSheetAction)) {
          return;
        }
        dismissSheetAction.dismiss();
        setTimeout((): void => {
          this.reportStylePhotoEvent(false)
          let session: UIExtensionContentSession | undefined =
            storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
          session?.terminateSelf();
        }, 100);
      }),
    })
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      if (this.param.isFromPickerView) {
        this.PickerContents();
      } else {
        this.SheetContainer();
      }
    }
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .id('modalRoot')
    .width('100%')
    .height('100%')
  }
}