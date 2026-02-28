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
import {
  App,
  EditorStatus,
  BaseEditor,
  UndoRedoInfo,
  VideoSizer,
  HiLog,
  TabName,
  ScreenManager,
  SCREEN_ORIENTATION_PORTRAIT
} from '@oh-image-editor/editor-common';
import { VideoTool } from '@oh-image-editor/editor-common/src/main/ets/common/components/VideoTool';
import { ScreenClass } from '@oh-image-editor/editor-common/src/main/ets/service/App';
import { AiTabName } from '@oh-image-editor/editor-common/src/main/ets/service/model/Enum';
import { HashSet } from '@kit.ArkTS';

const TAG = 'ScreenTool';

@Extend(Text)
function showDoInfo() {
  .fontSize(12)
  .fontWeight('textFontFamilyRegular')
  .lineHeight(16)
  .fontColor('#DBFFFFFF')
  .backgroundColor('#4D4D4D')
  .border({
    radius: 4,
  })
  .padding({
    left: 8,
    right: 8,
    top: 3,
    bottom: 3,
  })
  .maxFontScale(1.45)
}

@Extend(Column)
function operateInfo() {
  .height(60)
  .width('100%')
  .alignItems(HorizontalAlign.Center)
  .justifyContent(FlexAlign.Center)
  .position({ x: 0, y: 0 })
}

@Component
export struct ScreenTool {
  @Prop isLoading: boolean = false;
  @State undoRedoInfo: UndoRedoInfo = App.getInstance().undoRedoInfo;
  @State editor: BaseEditor = App.getInstance().myEditor();
  @Link originalColorMode: number;
  @Consume isInMosaicView: boolean;
  private notSupportEditorTipSet: HashSet<AiTabName> = new HashSet();
  @State @Watch('screenToolAreaChange') screenClass: ScreenClass = App.getInstance().screenClass;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) isScreenPortrait: boolean = ScreenManager.getInstance().isScreenPortrait();

  screenToolAreaChange() {
    let isSplitMode: boolean = ScreenManager.getInstance().isSplitMode();
    let isScreenPortrait = ScreenManager.getInstance().isScreenPortrait();
    let isFold = ScreenManager.getInstance().isDeviceFold();
    let needRefreshPreviewArea = !ScreenManager.getInstance().isWindowMode() && !isScreenPortrait && isSplitMode &&
      ScreenManager.getInstance().getWidthScale() === 1 && ScreenManager.getInstance().getHeightScale() < 1 && isFold;
    if (needRefreshPreviewArea && this.editor.screenToolArea) {
      HiLog.i(TAG, 'screenToolAreaChange');
      App.getInstance().myEditor().previewStarter.onOperationAreaChanged(this.editor.screenToolArea);
    }
  }

  private isNeedShowTip(tabIndex: AiTabName): boolean {
    return true;
  }

  build() {
    Stack() {
      if (this.editor.asset.isShowCropRect && !this.isInMosaicView) {
        VideoSizer({
        })
      }
      if (this.editor.isInitComp) {
        Flex({
          direction: this.isScreenPortrait ? FlexDirection.Column : FlexDirection.Row
        }) {
          Column()
            .width(this.screenClass.avoidLeft);

        }.width('100%').height('100%').hitTestBehavior(HitTestMode.Transparent);
      }
      if (this.editor.isInitComp) {
        VideoTool({
          originalColorMode: this.originalColorMode
        })
      }
      if (this.editor.changeLoading) {
        Stack() {
          LoadingProgress()
            .color($r('sys.color.white'))
            .width(32)
            .height(32)
        }
        .width('100%')
        .height('100%')
      }
    }
  }

  @Builder
  doTips() {
    Column() {
      Text(this.undoRedoInfo.redoInfo).showDoInfo()
    }.operateInfo()
    .hitTestBehavior(HitTestMode.Transparent)
  }
}