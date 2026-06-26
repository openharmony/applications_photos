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
import { App, TabName, BaseEditor, ScreenClass } from '../../service/App'
import { OperationTip, Asset, AdjustAttr } from '../../service/BaseEditor'
import {
  AppColor,
  EDITOR_STATUS_BAR_HEIGHT_KEY,
  SCREEN_ORIENTATION_PORTRAIT,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY
} from '../const';
import { NullUtil } from '../util/NullUtil'
import { ScreenManager } from '../util/ScreenManager'
import { CompareTool } from './CompareTool'
import { DeviceUtil } from '../util/DeviceUtil'
import { Constants } from '../util/Constants'
import { AiTabName } from '../../service/model/Enum';
import { LengthMetrics } from '@kit.ArkUI';
import { DEVICE_FOLD_STATUS } from '../const';
import { HiLog } from '../util/HiLog';
import { UiUtil } from '@ohos/common/src/main/ets/default/utils/UiUtil';

@Extend(Text)
function showInfo() {
  .fontSize(48)
  .lineHeight(75)
  .fontColor(AppColor.white())
  .fontWeight(300)
  .textShadow({
    radius: 5,
    color: '#000000',
    offsetX: 0,
    offsetY: 0,
  })
  .opacity(30)
}

@Component
export struct VideoTool {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  @State adjustAttr: AdjustAttr = App.getInstance().myEditor().asset.adjusts();
  @State @Watch('changeHeight') screenClass: ScreenClass = App.getInstance().screenClass;
  @State positionY: number = 0;
  @StorageProp(EDITOR_STATUS_BAR_HEIGHT_KEY) statusBarHeight: number = 0
  @State operationTip: OperationTip = App.getInstance().myEditor().operationTip;
  @Link originalColorMode: number;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('changeHeight') isScreenPortrait: boolean =
    ScreenManager.getInstance().isScreenPortrait();
  @StorageProp(WIN_HEIGHT_KEY) @Watch('changeHeight') winHeight: number = ScreenManager.getInstance().height;
  @State textPaddingLeftAndRight: number =
    ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight();
  @StorageLink('isSplitMode') isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
  @StorageProp(DEVICE_FOLD_STATUS) isFold: boolean = ScreenManager.getInstance().isDeviceFold()

  aboutToAppear() {
    this.changeHeight();
  }

  changeHeight() {
    let statusHeight = DeviceUtil.isPhone() ? px2vp(this.statusBarHeight) : 0
    this.positionY = (ScreenManager.getInstance().height - Constants.STATUS_HEIGHT -
      (this.isScreenPortrait ? Constants.BOTTOM_HEIGHT + statusHeight :
        this.asset.isUnfoldPortrait && !ScreenManager.getInstance().isSplitMode() ? this.screenClass.avoidBottom :
          statusHeight + this.screenClass.avoidBottom) - Constants.TEXT_HEIGHT) / 2;
    this.textPaddingLeftAndRight = ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight();
  }

  @Builder
  ToolTips() {
    Column() {
      if ((this.editor.immersiveMode || this.operationTip.isShowNum) && !NullUtil.isStrNull(this.operationTip.value) &&
        !this.editor.rotateMode) {
        Text(this.operationTip.value)
          .showInfo()
          .maxFontScale(this.isFold && ScreenManager.getInstance().isSplitMode() ? 0.9 : 1.45)
          .direction(Direction.Ltr)
      } else {
        if (this.operationTip.tips && !NullUtil.isObjNull(this.operationTip.name) &&
          (this.editor.tabIndex === TabName.TabAdjust || this.editor.tabIndex === TabName.TabFilter ||
            this.editor.tabIndex === TabName.TabXTStyle) && !this.editor.rotateMode) {
          Text(this.operationTip.name)
            .showInfo()
            .maxLines(2)
            .lineHeight(0)
            .textOverflow({
              overflow: TextOverflow.Ellipsis,
            })
            .maxFontScale(this.isFold && ScreenManager.getInstance().isSplitMode() ? 0.9 : 1.45)
            .transition(TransitionEffect.asymmetric(TransitionEffect.scale({ x: 0, y: 0 }).animation({
              duration: 100,
            }), TransitionEffect.OPACITY.animation({ duration: 100 })))
            .markAnchor(this.isGLBXTStyle() ? { x: '50%', y: '50%' } : null)
            .position(this.isGLBXTStyle() ?
                this.isPhoneLandscapeRTL() ?
                {
                  x: this.editor.operationArea.operLeft,
                  y: this.editor.operationArea.operTop
                } :
                {
                  x: this.editor.operationArea.operLeft + this.editor.operationArea.operWidth / 2,
                  y: this.editor.operationArea.operHeight / 2
                } :
              null
            )
        }
      }
    }
    .alignItems(this.isGLBXTStyle() ? HorizontalAlign.Start : HorizontalAlign.Center)
    .padding(this.isGLBXTStyle() ? null : {
      start: LengthMetrics.vp((this.isScreenPortrait ? this.textPaddingLeftAndRight : this.textPaddingLeftAndRight)),
      end: LengthMetrics.vp(this.textPaddingLeftAndRight),
    })
    .position(this.isGLBXTStyle() ? null : { x: this.screenClass.avoidLeft / 2, y: this.positionY })
    .hitTestBehavior(HitTestMode.Transparent)
    .width('100%')
    .id('petalClip_VideoTool_ToolTips')
  }

  isPhoneLandscapeRTL(): boolean {
    return UiUtil.isMirrorMode() && '' === DeviceUtil.currDevicePosture() &&
      !ScreenManager.getInstance().isScreenPortrait();
  }

  isGLBXTStyle(): boolean {
    return this.editor.tabIndex === TabName.TabXTStyle &&
      !((this.editor.immersiveMode || this.operationTip.isShowNum) && !NullUtil.isStrNull(this.operationTip.value) &&
        !this.editor.rotateMode);
  }

  isShowCompareButton() {
    return this.editor.tabIndex != TabName.TabCrop && this.editor.tabIndex != TabName.TabAdjust;
  }

  build() {
    Column() {
      Column() {
        CompareTool({
          originalColorMode: this.originalColorMode
        })
      }
      .width('100%').alignItems(this.isScreenPortrait ? HorizontalAlign.End : HorizontalAlign.Start)
      .visibility(this.isShowCompareButton() ? Visibility.Visible : Visibility.None)

      this.ToolTips();
    }
    .position({ x: 0, y: 0 })
  }
}