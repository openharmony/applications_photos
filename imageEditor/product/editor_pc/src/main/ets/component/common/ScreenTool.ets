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
import { AdjustAttr, EditorStatus, ScreenManager, SCREEN_ORIENTATION_PORTRAIT } from '@oh-image-editor/editor-common'
import { App, Asset, BaseEditor, UndoRedoInfo, VideoPlay, } from '@oh-image-editor/editor-common'
import { CropFrame } from '../crop/screen/CropFrame'
import { CompareTool } from '@oh-image-editor/editor-common/src/main/ets/common/components/CompareTool'

@Extend(Text)
function showDoInfo() {
  .fontSize(12)
  .fontWeight('textFontFamilyRegular')
  .lineHeight(16)
  .fontColor('rgba(255,255,255,0.85)')
  .maxFontScale(3.2)
}

@Extend(Column)
function operateInfo(isShowInfo: boolean) {
  .height(60)
  .width('100%')
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.Center)
  .position({ x: 0, y: 0 })
  .visibility(isShowInfo ? Visibility.Visible : Visibility.None)
}

@Extend(Row)
function redoFrame() {
  .backgroundColor('#4D4D4D')
  .opacity(0.9)
  .border({
    radius: 4,
  })
  .padding({
    left: 8,
    right: 8,
    top: 2,
    bottom: 4,
  })
}

@Component
export struct ScreenTool {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  @State adjustAttr: AdjustAttr = App.getInstance().myEditor().asset.adjusts();
  @Prop isLoading: boolean = false;
  @State undoRedoInfo: UndoRedoInfo = App.getInstance().undoRedoInfo;
  @Prop status: EditorStatus = new EditorStatus();
  @Link originalColorMode: number;
  @State compareBtnXPosition: number = 0;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) isScreenPortrait: boolean = ScreenManager.getInstance().isScreenPortrait();

  @Builder
  aiImageView() {
  }

  build() {
    Stack() {
      VideoPlay({
        status: this.status,
        aiView: (() => {
          this.aiImageView();
        })
      })
      if (!this.isLoading && !this.status.isPreviewHidden) {
        CropFrame().transition(TransitionEffect.asymmetric(
          TransitionEffect.OPACITY.animation({ duration: 100 }), TransitionEffect.IDENTITY))
      }
      CompareTool({
        originalColorMode: this.originalColorMode
      })
    }.height('100%').width('100%')
  }

  @Builder
  doTips() {
    Column() {
      Row() {
        Text(this.undoRedoInfo.redoInfo).showDoInfo()
      }.redoFrame()
    }.operateInfo(this.undoRedoInfo.isShowRedoInfo)
    .hitTestBehavior(HitTestMode.Transparent)
  }
}