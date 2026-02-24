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

import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy {
  ActionBarColorMode,
  ActionBarMode
} from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarMode';
import lazy { ActionBarProp } from '@ohos/common/src/main/ets/default/view/browserOperation/ActionBarProp';
import lazy {
  DiggingHoleCameraArea,
  getScreen,
  isOrientationHorizontal
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { ThirdSelectActionBar } from '@ohos/common/src/main/ets/default/view/actionbar/ThirdSelectActionBar';
import lazy { IS_HORIZONTAL } from '../utils/ThirdSelectConstants';
import lazy { AlbumListInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumThirdSelectDataSource';
import lazy { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { PickerCloseButton } from './PickerCloseButton';
import lazy { ThirdSelectGridController } from './ThirdSelectPhotoGridBase';

/* instrument ignore file */
const THIRD_SELECT_PAGE_ACTION_BAR_PADDING = 4;

@Component
export struct ThirdSelectedPageActionBar {
  @StorageLink(IS_HORIZONTAL) @Watch('createActionBar') isHorizontal: boolean = isOrientationHorizontal();
  @State menuList: Action[] = [];
  public selectParams: SelectParams = SelectParams.defaultParam();
  @Provide selectedCount: number = 0;
  @Link @Watch('onSelectedCountChanged') totalSelectedCount: number;
  public isSelectPhotoGrid: boolean = false;
  private isFromPickerView: boolean = false;
  onMenuClicked: Function = (): void => {
  };
  public leftAction: Action = Action.BACK;
  public rightAction: Action = Action.PICKER_CLOSE;
  @Link @Watch('onSelectedCountChanged') title: string;
  @State actionBarProp: ActionBarProp = new ActionBarProp();
  public isFirstEnter: boolean = true;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  @Provide hidePopup: boolean = false;
  @StorageLink('digging_hole_camera_area') diggingHoleCameraArea: DiggingHoleCameraArea = getScreen()
    .getDiggingHoleCameraArea();
  @State isSearchEnabled: boolean = false;
  @State isNeedShowPrivacyMask: boolean = false;
  @Prop privacyOptionsText: Resource | undefined = undefined;
  private changePrivacyViewStatus: Function | undefined;
  public albumByTypeList: AlbumListInfo[] = [];
  public isNavTitle: boolean = false;
  private actionBarMarginTop: number =
    px2vp(UiUtil.getResourceNumber($r('sys.float.ohos_id_elements_margin_vertical_m')));
  @Prop private moreMenuList: Action[] = [];
  private pickerController: ThirdSelectGridController = new ThirdSelectGridController();

  aboutToAppear(): void {
    this.onSelectedCountChanged();
  }

  onSelectedCountChanged(): void {
    this.selectedCount = this.totalSelectedCount;
    this.menuList = [];
    this.createActionBar();
  }

  build() {
    Stack({alignContent: Alignment.End}){
      Column() {
        ThirdSelectActionBar({
          actionBarProp: $actionBarProp,
          onMenuClicked: this.onMenuClicked,
          isNeedPlaceholder: false,
          isFromPickerView: this.isFromPickerView,
          moreMenuList: this.moreMenuList,
          isNeedShowPrivacyMask: this.isNeedShowPrivacyMask,
          changePrivacyViewStatus: this.changePrivacyViewStatus,
          privacyOptionsText: this.privacyOptionsText,
        })
      }
      .margin({
        top: this.actionBarMarginTop,
        bottom: this.actionBarMarginTop,
      })
      if (DeviceInfo.isPhoneOrTablet() && !this.isFromPickerView) {
        PickerCloseButton({
          pickerController: this.pickerController,
          componentHeight: $r('app.float.title_default'),
        })
      }
    }
  }

  private createActionBar(): void {
    let actionBarProp: ActionBarProp = new ActionBarProp();
    actionBarProp
      .setLeftAction(!this.isNavTitle ? this.leftAction : Action.NONE)
      .setRightAction(!this.isNavTitle ? this.rightAction : Action.NONE)
      .setTitle(this.title)
      .setIsNavTitle(this.isNavTitle)
      .setMenuList(this.menuList)
      .setMode(ActionBarMode.STANDARD_MODE)
      .setColorMode(ActionBarColorMode.NORMAL)
      .setBackgroundColor($r('sys.color.background_secondary'))
      .setMaxSelectCount(this.selectParams.maxSelectCount);
    this.actionBarProp = actionBarProp;
  }
}