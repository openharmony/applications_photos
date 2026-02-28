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

import { FormConstants } from '@ohos/common/src/main/ets/default/model/common/FormConstants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { WidgetCardViewModel, widgetCardType } from './WidgetCardViewModel';

/* instrument ignore file */

@Component
export struct WidgetCardView {
  private cardType: string = '';
  @State widgetCardViewModel: WidgetCardViewModel = new WidgetCardViewModel(this, this.cardType);

  @Builder
  buildImage() {
    Stack() {
      FormLink(this.widgetCardViewModel.getFormLinkParams(true)) {
        Image(this.widgetCardViewModel.pixel)
          .imageStyle(this.cardType)
      }
    }
    .transition(
      TransitionEffect.asymmetric(TransitionEffect.move(TransitionEdge.END),
        TransitionEffect.move(TransitionEdge.START)))
  }

  @Builder
  buildOtherImage() {
    Stack() {
      FormLink(this.widgetCardViewModel.getFormLinkParams(false)) {
        Image(this.widgetCardViewModel.otherPixel)
          .imageStyle(this.cardType)
      }
    }
    .transition(
      TransitionEffect.asymmetric(TransitionEffect.move(TransitionEdge.END),
        TransitionEffect.move(TransitionEdge.START)))
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      if (this.widgetCardViewModel.pixel || this.widgetCardViewModel.otherPixel) {
        if (this.widgetCardViewModel.showOtherImage) {
          this.buildOtherImage();
        } else {
          this.buildImage();
        }
      }
      if ((this.widgetCardViewModel.currentUri || this.widgetCardViewModel.otherUri) &&
      this.widgetCardViewModel.isShowAlbumName) {
        if (this.cardType === widgetCardType.WIDGET_CARD_2x2 || this.cardType === widgetCardType.WIDGET_CARD_2x4) {
          Stack({ alignContent: Alignment.BottomStart }) {
            Text(this.widgetCardViewModel.albumNameTmp)
              .height('14fp')
              .fontSize('14fp')
              .textStyle(this.cardType)
          }
          .padding(16)
          .width('100%')
          .height('100%')
        } else if (this.cardType === widgetCardType.WIDGET_CARD_4x4) {
          Stack({ alignContent: Alignment.BottomStart }) {
            Text(this.widgetCardViewModel.albumNameTmp)
              .height('34fp')
              .fontSize('34fp')
              .textStyle(this.cardType)
          }
          .padding(24)
          .width('100%')
          .height('100%')
        }
      }
    }
  }
}

@Extend(Image)
function imageStyle(tag: string) {
  .width('100%')
  .height('100%')
  .onError((error: ImageError) => {
    Log.error(tag, 'image error ' + error?.message);
  })
  .onAppear(() => {
    Log.info(tag, 'image onAppear ');
  })
  .onComplete((status) => {
    Log.info(tag, 'image onComplete ' + status?.loadingStatus);
  })
  .alt($r('app.media.form_default_bg'))
  .syncLoad(true)
}

@Extend(Text)
function textStyle(tag: string) {
  .fontWeight(FontWeight.Bold)
  .fontFamily(FormConstants.HIGHLIGHT_DEFAULT_FONT)
  .fontColor(Color.White)
  .maxLines(1)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
  .direction(Direction.Auto)
  .textShadow({
    radius: 4,
    color: '#805F5F5F',
    offsetX: 0,
    offsetY: 2,
  })
  .onAppear(() => {
    Log.info(tag, 'text onAppear ');
  })
}