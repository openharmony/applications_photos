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
import { App, BaseEditor, FIRST_FRAME_STATUS, HiLog, ScreenManager, TabName } from '@oh-image-editor/editor-common'
import { AdjustTab } from '../adjust/AdjustTab'
import { FilterTab } from '../filter/FilterTab'
import { Service } from '@oh-image-editor/editor-common/src/main/ets/common/util/Service'
import pointer from '@ohos.multimodalInput.pointer';
import { SegmentButton, SegmentButtonItemTuple, SegmentButtonOptions } from '@ohos.arkui.advanced.SegmentButton'
import { MenuAttr } from '@oh-image-editor/editor-common/src/main/ets/service/model/menu/MenuAttr'

const TAG = 'RightMenuTool';

@Extend(Row)
function menuStyle(isFirstFrameStatue: boolean) {
  .backgroundColor('#252525')
  .justifyContent(FlexAlign.Center)
  .height(64)
  .width($r('app.float.right_bar_width'))
  .enabled(isFirstFrameStatue)
  .opacity(isFirstFrameStatue ? 1 : 0.4)
  .padding({
    top: 12,
    left: 16,
    right: 16,
    bottom: 12,
  })
}

@Component
export struct RightMenuTool {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State @Watch('changeMenu') singleSelectCapsuleSelectedIndexes: number[] = [0];
  @StorageProp(FIRST_FRAME_STATUS) isFirstFrameStatue: boolean = ScreenManager.getInstance().getIsFirstFrame();
  @State menuTabs: SegmentButtonOptions = SegmentButtonOptions.capsule({
    buttons: [{ text: $r('app.string.tabs_adjust_imageEdit') }, {
      text: $r('app.string.tabs_filter_imageEdit'),
    }] as SegmentButtonItemTuple,
    multiply: false,
    selectedBackgroundColor: $r('sys.color.ohos_id_color_foreground_contrary'),
    fontColor: '#99FFFFFF',
    fontSize: $r('sys.float.ohos_id_text_size_body2'),
    fontWeight: FontWeight.Regular,
    backgroundColor: 'rgba(0,0,0,0)',
    selectedFontWeight: FontWeight.Medium,
    selectedFontColor: '#E5000000',
    selectedFontSize: $r('sys.float.ohos_id_text_size_body2'),
    buttonPadding: {
      left: 16,
      right: 16,
      top: 8,
      bottom: 8,
    },
  })
  private tabs: TabName[] = [TabName.TabAdjust, TabName.TabFilter];

  changeMenu() {
    if (this.singleSelectCapsuleSelectedIndexes.length < 1) {
      HiLog.e(TAG, 'menu tab selected index illegal');
      return;
    }
    let index = this.singleSelectCapsuleSelectedIndexes[0];
    if (this.tabs[index] === this.editor.tabIndex || index < 0) {
      HiLog.i(TAG, 'click same tab');
      return;
    }
    let leaveMenu: MenuAttr = this.editor.asset.getMenuAttr(this.editor.tabIndex);
    leaveMenu.leaveMenu(this.tabs[index]);
    let enterMenu: MenuAttr = this.editor.asset.getMenuAttr(this.tabs[index]);
    enterMenu.enterMenu();
    enterMenu.changeMenuAnimate(this.tabs[index]);
    this.bottomHeightChange(this.tabs[index] == TabName.TabAdjust);
    AppStorage.setOrCreate<boolean>('isDefaultTab', this.tabs[index] === TabName.TabAdjust);
    this.editor.previewStarter.startPreviewIfNeeded(true, false);
    this.editor.refreshCompareEffectList();
  }

  // 底部街区轨道组件渐隐渐显动画
  bottomHeightChange(flag: boolean): void {
    animateTo({
      duration: 400, // 动画时长
      delay: 100,
      curve: Curve.Friction, // 动画曲线
    }, () => {
      this.editor.bottomHeight = flag ? 100 : 0
    })
  }

  build() {
    Column() {
      Row() {
        this.NavigationToolbar();
      }
      .menuStyle(this.isFirstFrameStatue)

      AdjustTab().visibility(this.editor.tabIndex == TabName.TabAdjust ? Visibility.Visible : Visibility.None)
      FilterTab().visibility(this.editor.tabIndex == TabName.TabFilter ? Visibility.Visible : Visibility.None)
    }
    .visibility(this.editor.stylusMode ? Visibility.None : Visibility.Visible)
    .onHover((isHover: boolean, event: HoverEvent): void => {
      event.stopPropagation();
      isHover && Service.changeMouseShape(pointer.PointerStyle.DEFAULT);
    })
  }

  @Builder
  NavigationToolbar() {
    Column() {
      SegmentButton({ options: this.menuTabs, selectedIndexes: $singleSelectCapsuleSelectedIndexes, maxFontScale: 2 })
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .borderRadius(20)
    .size({ width: 288, height: 40 })
    .backgroundColor($r('sys.color.ohos_id_color_button_normal_dark'))
    .enabled(this.isFirstFrameStatue)
    .opacity(this.isFirstFrameStatue ? 1 : 0.4)
  }
}