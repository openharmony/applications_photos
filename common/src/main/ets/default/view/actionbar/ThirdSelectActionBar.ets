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

import lazy { ActionBarProp } from '../browserOperation/ActionBarProp';
import lazy { Action } from '../browserOperation/Action';
import lazy { Constants } from '../../model/common/Constants';
import lazy { isOrientationHorizontal } from '../../model/common/ScreenManager';
import lazy { ThirdSelectSingleTitle } from './ThirdSelectSingleTitle';
import lazy { ThirdSelectActionBarButton } from './ThirdSelectActionBarButton';

/* instrument ignore file */
const TAG: string = 'common_ActionBar';
const BLACK_WIDTH: number = 16;

// ActionBar，It consists of action on the left, title in the middle and menupanel on the right
@Component
export struct ThirdSelectActionBar {
  @Link @Watch('onActionBarPropChanged') actionBarProp: ActionBarProp;
  onMenuClicked: Function = (): void => {
  };
  public isFromPhotoBrowser: boolean = false;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @Prop isNeedPlaceholder: boolean = false;
  private isFromPickerView: boolean = false;
  @Provide isThirdSelect: boolean = true;
  @Provide albumName: string = '';
  @Prop private moreMenuList: Action[] = [];
  @State menuList: Action[] = [];
  @State isNeedShowPrivacyMask: boolean = false;
  @Prop privacyOptionsText: Resource | undefined = undefined;
  private changePrivacyViewStatus: Function | undefined;

  createArray(): ActionBarProp[] {
    let actionBarProps: ActionBarProp[] = [];
    actionBarProps.push(this.actionBarProp);

    return actionBarProps;
  }

  private onActionBarPropChanged(): void {
    this.menuList = this.actionBarProp.getMenuList();
  }

  private isNoneAction(isLeft: boolean): boolean {
    let isNoneAction: boolean = isLeft ? this.actionBarProp.getLeftAction().equals(Action.NONE) :
    this.actionBarProp.getRightAction().equals(Action.NONE);
    return isNoneAction;
  }

  @Builder
  private thirdSelectActionBarBuilder(isLeft: boolean): void {
    if (!this.isNoneAction(isLeft)) {
      ForEach(this.createArray(), (item: ActionBarProp) => {
        ThirdSelectActionBarButton({
          res: isLeft ? item.getLeftAction().iconRes : item.getRightAction().iconRes,
          action: isLeft ? item.getLeftAction() : item.getRightAction(),
          onMenuClicked: this.onMenuClicked,
          isAutoTint: isLeft ? item.getLeftAction().isAutoTint : item.getRightAction().isAutoTint,
          colorMode: item.getColorMode(),
          isFromPickerView: this.isFromPickerView,
          moreMenuList: this.moreMenuList,
        })
      }, (item: ActionBarProp) => {
        return isLeft ? item.getLeftAction().actionID.toString() : item.getRightAction().actionID.toString();
      })
    } else {
      Blank().width(BLACK_WIDTH)
    }
  }

  @Builder
  private buildThirdSelectTitle() {
    // 组件形态下，大图不显示title
    if (!this.isFromPickerView) {
      Stack({ alignContent: Alignment.Start }) {
        ThirdSelectSingleTitle({
          actionBarProp: $actionBarProp,
          isNeedShowPrivacyMask: this.isNeedShowPrivacyMask,
          changePrivacyViewStatus: this.changePrivacyViewStatus,
          privacyOptionsText: this.privacyOptionsText,
        })
      }
      .flexGrow(1)
      .key('ThirdSelectSingleTitle')
    }
  }

  aboutToAppear(): void {
    this.onActionBarPropChanged();
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: this.isFromPickerView ? FlexAlign.Start : FlexAlign.Center,
      alignItems: ItemAlign.Center,
    }) {
      this.thirdSelectActionBarBuilder(true);
      this.buildThirdSelectTitle();
      // 右侧构造一个虚拟的关闭按钮，位置与半模态自带的关闭按钮重叠。flex布局时以此虚拟按钮进行关闭按钮的占位，避免相册页标题超长时覆盖在关闭按钮上。
      // 出现时机目前与返回按钮保持一致，后续如果需要替换掉半模态自带的关闭按钮，以此为基础修改即可。
      this.thirdSelectActionBarBuilder(false);
    }
    .height(Constants.ActionBarHeight)
    .zIndex(3)
    .width(Constants.PERCENT_100)
    .backgroundColor($r('app.color.transparent'))
    .opacity(this.actionBarProp.getAlpha())
    .padding({ left: 0 })
  }
}