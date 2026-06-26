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

import lazy { PickerMediaDataSource } from '@ohos/thirdselect/src/main/ets/default/common/PickerMediaDataSource';
import lazy { GrantPhotoUrisDataImpl } from '@ohos/thirdselect/src/main/ets/default/common/GrantPhotoUrisDataImpl';
import lazy { ThirdSelectManager } from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy {
  ThirdSelectGridController,
  ThirdSelectGridListener,
  ThirdSelectPhotoGridBase
} from '@ohos/thirdselect/src/main/ets/default/view/ThirdSelectPhotoGridBase';
import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { ThirdSelectBrowserParams } from './ThirdSelectBrowserParams';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { BurstPhotoUtils } from '@ohos/common/src/main/ets/default/utils/BurstPhotoUtils';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import lazy ability from '@ohos.ability.ability';
import lazy wantConstant from '@ohos.app.ability.wantConstant';
import lazy { UIExtensionContentSession } from '@kit.AbilityKit';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { PickerCloseButton } from '@ohos/thirdselect/src/main/ets/default/view/PickerCloseButton';

/* instrument ignore file */
const TAG: string = 'GrantPhotoUrisPage';
let storage: LocalStorage = LocalStorage.getShared();

@Entry(storage)
@Component
export struct GrantPhotoUrisPage {
  @State private isShowContent: boolean = false;
  private dataSource: PickerMediaDataSource | undefined = undefined;
  private selectManager: ThirdSelectManager | undefined = undefined;
  @State @Watch('updateAnimationStatus') private browserController: BrowserController = new BrowserController(true);
  @Provide private broadCast: BroadCast = new BroadCast();
  @Provide private isShow: boolean = true;
  @State private pageStatus: boolean = false;
  @State private actionBarController: ActionBarController = new ActionBarController();
  private param: SelectParams = new SelectParams();
  @State private searchKeyword: string = '';
  @BuilderParam private selectBrowserLoader: ($$: ThirdSelectBrowserParams) => void;
  @State private isBrowserShow: boolean = false;
  @Provide private isSelectedMode: boolean = true;
  @Provide private displaySearchWords: string = '';
  private photoDataImpl: GrantPhotoUrisDataImpl | undefined = undefined;
  @State private thirdSelectGridController: ThirdSelectGridController = new ThirdSelectGridController();
  private readonly thirdSelectGridListener: ThirdSelectGridListener = {
    onCompleted: (items: MediaItem[]) => this.onThirdSelectComplete(items),
    onCancelled: (): void => this.onThirdSelectCancel(),
  } as ThirdSelectGridListener;
  @State private isSheetShow: boolean = true;
  private onBackFunc: Function = (): void => {
  };

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.param = storage?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY) as SelectParams;
    let uris = storage?.get<string[]>(Constants.PHOTO_PICKER_GRANT_PHOTO_URIS) as string[];
    this.selectManager = new ThirdSelectManager();
    this.photoDataImpl = new GrantPhotoUrisDataImpl(getContext(this), uris);
    this.dataSource = new PickerMediaDataSource(100, this.photoDataImpl);
    this.thirdSelectGridController.hasDelegate = true;
    this.thirdSelectGridController.register(this.thirdSelectGridListener);
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
  }

  onPageShow(): void {
    Log.info(TAG, 'onPageShow');
    this.pageStatus = true;
  }

  onPageHide(): void {
    Log.info(TAG, 'onPageHide');
    this.pageStatus = false;
  }

  onBackPress(): boolean | void {
    if (this.browserController.isBrowserShow) {
      this.browserController.browserBackFunc?.();
      Log.info(TAG, 'browserBackFunc');
      return true;
    }
    if (this.onBackFunc) {
      this.onBackFunc();
      Log.info(TAG, 'onBackFunc');
      return true;
    }
    Log.info(TAG, 'onBackPress');
    return false;
  }

  private bindSheetOnWillDismiss(dismissSheetAction: DismissSheetAction): boolean {
    if (this.browserController.isBrowserShow &&
      dismissSheetAction.reason == DismissReason.PRESS_BACK) {
      this.broadCast.emit(BroadCastConstants.BROWSER_ON_BACK_PRESS, []);
      Log.info(TAG, 'bindSheetOnWillDismiss: browser back');
      return true;
    }
    return false;
  }

  private async onThirdSelectComplete(items: MediaItem[]): Promise<void> {
    Log.info(TAG, `onThirdSelectComplete${this.param?.appId}`);
    this.isSheetShow = false;
    let selectedUris = await BurstPhotoUtils.getBurstUris(items);
    let abilityResult: ability.AbilityResult = {
      resultCode: selectedUris ? 0 : -1,
      want: {
        flags: wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
        parameters: {
          'desFileUris': selectedUris as Object,
        }
      }
    } as ability.AbilityResult
    await PhotoAccessHelperAccess.grantPermissionForUris(getContext(), this.param?.tokenId, selectedUris);
    setTimeout((): void => {
      Log.info(TAG, 'session terminateSelfWithResult');
      let session: UIExtensionContentSession | undefined =
        storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
      session?.terminateSelfWithResult(abilityResult).then((result: void) => {
        Log.info(TAG, `terminateSelfWithResult result: ${result}, self result ${JSON.stringify(abilityResult)}`);
      });
    }, 100);
  }

  private onThirdSelectCancel() {
    Log.info(TAG, 'onThirdSelectCancel');
    this.isSheetShow = false;
    let abilityResult: ability.AbilityResult = {
      resultCode: 0,
      want: {
        flags: wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
        parameters: {
          'desFileUris': '',
        }
      }
    } as ability.AbilityResult;
    setTimeout((): void => {
      let session: UIExtensionContentSession | undefined =
        storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
      session?.terminateSelfWithResult(abilityResult).then((result: void) => {
        Log.info(TAG,
          `onWillDismiss terminateSelfWithResult result: ${result}, self result ${JSON.stringify(abilityResult)}`);
      });
    }, 100);
  }

  /**
   * @Watch browserController
   */
  private updateAnimationStatus(): void {
    this.loadBrowserComponent();
  }

  private async loadBrowserComponent(): Promise<void> {
    try {
      let loader = await import('./ThirdSelectBrowserViewLoader');
      this.selectBrowserLoader = loader.ThirdSelectBrowserViewLoader;
      this.isBrowserShow = this.browserController.isBrowserShow;
    } catch (error) {
      Log.error(TAG, `loadBrowserComponent error: ${error}`);
    }
  }

  build() {
    Stack() {
    }
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    .bindSheet(this.isSheetShow, this.PickerContents(), {
      showClose: false,
      preferType: SheetType.CENTER,
      backgroundColor: $r('sys.color.ohos_id_color_panel_bg'),
      onWillDismiss: ((dismissSheetAction: DismissSheetAction) => {
        Log.info(TAG, 'bind sheet onWillDismiss');
        if (this.bindSheetOnWillDismiss(dismissSheetAction)) {
          return;
        }
        dismissSheetAction.dismiss();
        let abilityResult: ability.AbilityResult = {
          resultCode: 0,
          want: {
            flags: wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION,
            parameters: {
              'desFileUris': '',
            }
          }
        } as ability.AbilityResult;
        setTimeout((): void => {
          let session: UIExtensionContentSession | undefined =
            storage?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
          session?.terminateSelfWithResult(abilityResult).then((result: void) => {
            Log.info(TAG,
              `onWillDismiss terminateSelfWithResult result: ${result}, self result ${JSON.stringify(abilityResult)}`);
          });
        }, 100);
      }),
      onDisappear: () => {
      }
    })
  }

  @Builder
  PickerContents() {
    Stack({ alignContent: Alignment.Center }) {
      if (this.isShowContent) {
        Flex({
          direction: FlexDirection.Column,
          justifyContent: FlexAlign.Start,
          alignItems: ItemAlign.Start,
        }) {
          this.buildTitle();
          ThirdSelectPhotoGridBase({
            pageStatus: this.pageStatus,
            backFuncBinder: (backFunc: Function): void => this.bindBackFunc(backFunc),
            browserController: this.browserController,
            param: this.param,
            actionBarController: this.actionBarController,
            searchKeyword: this.searchKeyword,
            dataSource: this.dataSource,
            photoDataImpl: this.photoDataImpl,
            controller: this.thirdSelectGridController,
          })
            .transition({ type: TransitionType.All, opacity: 0 })
            .onAppear((): void => {
              Log.info(TAG, 'ThirdSelectPhotoGridBase onAppear');
            })
        }

        if (this.isBrowserShow) {
          this.selectBrowserLoader({
            replaceUriManager: undefined,
            broadCast: this.broadCast,
            pageStatus: this.pageStatus,
            browserController: this.browserController,
            thirdSelectController: this.thirdSelectGridController,
          });
        }
      }
    }
    .width('100%')
    .height('100%')
    .onAppear(() => {
      this.isShowContent = true;
    })
  }

  @Builder
  buildTitle() {
    Row() {
      Text($r('app.string.data_inherit_photos_and_dideos'))
        .height(61)
        .margin({ start: LengthMetrics.vp(16), top: LengthMetrics.vp(8), end: LengthMetrics.vp(64) })
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Bold)
        .fontSize(20)
        .fontColor('#FF000000')
        .lineHeight(27)
        .textAlign(TextAlign.Start)
      PickerCloseButton({
        pickerController: this.thirdSelectGridController,
        componentHeight: $r('app.float.title_default'),
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  private bindBackFunc(backFunc: Function): void {
    this.onBackFunc = backFunc;
  }
}