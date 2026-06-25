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
  Event,
  HiLog,
  BaseEditor,
  ScreenManager,
  StrengthBar,
  UiUtil
} from '@oh-image-editor/editor-common';
import resourceManager from '@ohos.resourceManager';
import { systemParameter } from '@kit.BasicServicesKit';
import { Algorithms } from '@oh-image-editor/editor-common/src/main/ets/service/model/Enum'

const TAG: string = 'FilterTab';

@Extend(Column)
function menuStyle() {
  .backgroundColor('#262626')
  .justifyContent(FlexAlign.Start)
  .width($r('app.float.right_bar_width'))
  .height('100%')
}

@Component
export struct FilterTab {
  @State touchState: TouchType = TouchType.Up;
  @State editor: BaseEditor = App.getInstance().myEditor();
  // 因为图片本身通过state-prop传递存在问题，所以使用标志位标识缩略图发生变化
  @State filterImageChangedArray: number[] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  @State isSlide: boolean = false;
  private hazeRemovalStatus: boolean = UiUtil.checkAlgorithms(Algorithms.Haze_Removal);

  changeProgress(): void {
  }

  aboutToAppear() {
  }

  getFilterName(): string {
    return ""
  }

  build() {
    Column() {
      Column() {
        Grid() {
        }
        .scrollBar(BarState.Off)
        .columnsGap(6)
        .maxCount(4)
        .rowsGap(24)
        .padding({
          left: $r('app.float.right_bar_left_right_padding'),
          right: $r('app.float.right_bar_left_right_padding'),
          bottom: 12,
          top: 12,
        })
      }
    }
    .id('petalClip_videoFilterTool_videoFilterTool')
    .menuStyle()
  }
}

@Component
struct imageItem {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @Prop itemIndex: number = 0;
  @State isHover: boolean = false;
  @Prop selectionUid: string = '';
  @Prop filterImageChanged: number = 0;
  public onItemSelectChange: (val: string) => void = Event;
  @State url: PixelMap | Resource | string = '';

  aboutToAppear() {
  }

  // 监听缩略图回调结果
  updateFilterThumbnailFn() {
  }

  build() {
    Column() {
      Stack() {
        Image(this.url)
          .borderRadius(10)
        Image($r('app.media.filter_inner_shadow_pc'))
          .visibility( Visibility.Visible)
      }
      .imageItemStack()

      Text()
        .imageName()
        .margin({ top: 4 })
    }
    .onClick((): void => {
      if (this.editor.isEdit) {
        this.editor.isShowRevert = !this.editor.isEdited();
      }
    })
    .onHover((isHover: boolean, event: HoverEvent): void => {
      if (!event || isHover === undefined || event.stopPropagation === null || event.stopPropagation === undefined) {
        return;
      }
      event.stopPropagation();
      this.isHover = isHover;
    })
  }
}

@Extend(Text)
function imageName() {
  .fontColor(Color.White)
  .fontWeight(FontWeight.Regular)
  .fontSize(12)
  .maxFontSize(3.2)
}

@Extend(Stack)
function imageItemStack() {
  .width(59)
  .height(59)
  .backgroundImageSize({ width: '100%', height: '100%' })
}

@Extend(Column)
function insideBorder(selectionUid: string, materialUid: string, isHover: boolean) {
  .width(59)
  .height(59)
  .border({
    radius: 10,
    style: BorderStyle.Solid,
    color: (selectionUid != materialUid && isHover) ? 'rgba(255, 255, 255, 0.80)' : Color.White,
    width: 2,
  })
  .visibility(selectionUid === materialUid ? Visibility.Visible : (isHover ? Visibility.Visible : Visibility.None))
}