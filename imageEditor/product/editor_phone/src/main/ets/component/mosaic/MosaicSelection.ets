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
  Asset,
  CustomScroll,
  Event,
  HiLog,
  BaseEditor,
  SCREEN_ORIENTATION_PORTRAIT,
  ScreenManager,
  UiUtil,
  MosaicAttr,
  ResourceButtonItem
} from '@oh-image-editor/editor-common';
import {
  FILTER_BUTTON_SIZE,
  WIN_WIDTH_KEY,
  WIN_HEIGHT_KEY,
  SCROLL_SHADOW_WIDTH
} from '@oh-image-editor/editor-common/src/main/ets/common/const';
import { ScrollerUtil } from '@oh-image-editor/editor-common/src/main/ets/common/util/ScrollerUtil';
import { i18n } from '@kit.LocalizationKit';

@Extend(Stack)
function imageItemStack() {
  .width(68)
  .height(68)
  .borderRadius(8)
  .alignContent(Alignment.Center)
  .backgroundImageSize({ width: '100%', height: '100%' })
  .backgroundColor('#171717')
}

@Extend(Column)
function insideBorder(isShowBorder: boolean) {
  .width(68)
  .height(68)
  .border({
    radius: 10,
    style: BorderStyle.Solid,
    color: Color.White,
    width: 2,
  })
  .visibility(isShowBorder ? Visibility.Visible : Visibility.None)
}

const TAG = 'MosaicSelection';

@Component
struct mosaicImageItem {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  @State mosaicAttr: MosaicAttr = App.getInstance().myEditor().asset.mosaic();
  @Prop itemIndex: number = 0;
  @Prop selectionIndex: number = 0;
  @Prop selectionKey: string = '';
  @Prop imageDataList: ResourceButtonItem[] = [];
  @State item: ResourceButtonItem = this.imageDataList[this.itemIndex];
  @State mosaicKey: string = '';
  @State mosaicUrl?: Resource = undefined;
  public onItemSelectChange: (val: number) => void = Event;
  @State isHover: boolean = false;

  aboutToAppear() {
    this.item = this.imageDataList[this.itemIndex];
    this.updateUrl(this.itemIndex);
  }

  updateUrl(itemIndex: number) {
    if (itemIndex === this.itemIndex) {
      this.mosaicKey = this.item.key;
      this.mosaicUrl = this.item.icon;
      return;
    }
    const tempIitem: ResourceButtonItem = this.imageDataList[itemIndex];
    this.mosaicKey = tempIitem.key;
    this.mosaicUrl = tempIitem.icon;
  }
  // instrument ignore next
  mosaicTextResource(currentIndex: number, index: number): string {
    if (this.mosaicAttr.mosaicTypeText[index] === null) {
      HiLog.e(TAG, 'imageSelectText is null');
      return '';
    }
    if (currentIndex === index) {
      return getContext().resourceManager.getStringSync($r('app.string.ai_is_selected'),
        UiUtil.getResourceString(this.mosaicAttr.mosaicTypeText[index]));
    }
    return UiUtil.getResourceString(this.mosaicAttr.mosaicTypeText[index]);
  }
  // instrument ignore next
  build() {
    Stack() {
      if (this.itemIndex === 0) {
        SymbolGlyph(this.mosaicUrl)
          .fontSize('24vp')
          .fontColor(['#FFFFFF'])
          .opacity(1)
          .id(`petalClip_mosaicSelection_item_image_${this.mosaicKey}`)
      } else {
        Image(this.mosaicUrl)
          .width('46.7%')
          .height('54.5%')
          .id(`petalClip_mosaicSelection_item_image_${this.mosaicKey}`)
      }
      Image($r('app.media.filter_inner_shadow_phone'))
        .visibility(this.selectionKey === this.mosaicKey ? Visibility.Visible : Visibility.None)
      Column().insideBorder(this.selectionKey === this.mosaicKey || this.isHover)
    }
    .id(`petalClip_mosaicSelection_item_${this.mosaicKey}`)
    .accessibilityText(this.mosaicTextResource(this.selectionIndex, this.itemIndex))
    .imageItemStack()
    .onClick((): void => {
      if (this.editor.asset.isGestureOperate || this.asset.isTouching) {
        HiLog.i(TAG, 'mosaicImageItem gesture operate cannot click adjust submenu');
        return;
      }
      if (this.selectionIndex === this.itemIndex) {
        HiLog.i('mosaicImageItem onClick', 'itemIndex: %{public}i', this.itemIndex);
        return;
      }
      HiLog.i('mosaicImageItem onClick', 'selectionKey: %{public}s, selectionIndex: %{public}i, itemIndex: %{public}i',
        this.selectionKey, this.selectionIndex, this.itemIndex);
      this.onItemSelectChange(this.itemIndex);
    })
    .onHover((isHover: boolean) => {
      this.isHover = isHover;
    })
  }
}

@Component
export struct MosaicSelection {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State asset: Asset = App.getInstance().myEditor().asset;
  @State mosaicAttr: MosaicAttr = App.getInstance().myEditor().asset.mosaic();
  public scroller: Scroller = new Scroller();
  public imageDataList: ResourceButtonItem[] = [];
  public onSelectChange: (val: number) => void = Event;
  @Prop selectionKey: string = '';
  @Prop @Watch('scrollToSelected') isScrollToIndex: number = -1;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('watchScrollDirection') isScreenPortrait: boolean =
    ScreenManager.getInstance().isScreenPortrait()
  @State scrollDirection: ScrollDirection = this.isScreenPortrait ? ScrollDirection.Horizontal :
  ScrollDirection.Vertical
  @StorageProp(WIN_WIDTH_KEY) @Watch('refreshHeight') winWidth: number = ScreenManager.getInstance().width;
  @StorageProp(WIN_HEIGHT_KEY) @Watch('refreshHeight') winHeight: number = ScreenManager.getInstance().height;
  @State isShowShadowStart: boolean = false;
  @State isShowShadowEnd: boolean = true;
  @State scrollDistance: number = 0;
  @State shadowRate: number = 0;
  @StorageLink('currentLanguage') @Watch('onLanguageChange') currentLanguage: string | undefined = undefined;
  @State isRTL: boolean = false;

  aboutToAppear() {
    this.onLanguageChange();
  }

  scrollToSelected() {
    this.scrollAppear();
  }

  private onLanguageChange(): void {
    if (this.currentLanguage) {
      this.isRTL = i18n.isRTL(this.currentLanguage);
      HiLog.i(TAG, `LanguageChange : ${this.currentLanguage} , change isRTL : ${this.isRTL}`);
    }
  }

  private marginValue(index: number | undefined): Length | Padding | LocalizedPadding {
    if (this.isScreenPortrait) {
      if (this.isRTL) {
        return { top: 0, right: index ? 4 : 0 };
      } else {
        return { top: 0, left: index ? 4 : 0 }
      }
    } else {
      if (this.isRTL) {
        return { top: index ? 4 : 0, right: 0 }
      } else {
        return { top: index ? 4 : 0, left: 0 }
      }
    }
  }

  watchScrollDirection() {
    this.scrollDirection = this.isScreenPortrait ? ScrollDirection.Horizontal : ScrollDirection.Vertical;
    this.scrollDistance = 0;
    this.handleScroll();
  }

  refreshHeight() {
    this.scrollDistance = 0;
    this.handleScroll();
  }

  handleScroll(state?: ScrollState) {
    if (!this.scroller.currentOffset()) {
      return;
    }
    const scrollDistance = (
      this.isScreenPortrait ? this.scroller.currentOffset().xOffset : this.scroller.currentOffset().yOffset
    ) ?? 0;
    this.isShowShadowStart = scrollDistance > 0 ? true : false;
    if (!this.isShowShadowEnd && state !== undefined && state === ScrollState.Fling) {
      return;
    }
    this.isShowShadowEnd = this.scrollDistance === 0 || scrollDistance < this.scrollDistance ? true : false;
  }
  // instrument ignore next
  build() {
    Row() {
      CustomScroll({
        tabLength: this.imageDataList.length,
        marginScreen: 32,
        scroller: this.scroller,
        needMask: true,
        itemWidth: 72,
        scrollDirection: this.scrollDirection,
        scroll: ((state: ScrollState) => {
          this.handleScroll(state);
        }),
        scrollItem: (() => {
          this.scrollerItem();
        }),
        scrollEdge: ((side) => {
          console.error('scrollEdge', side);
          if (side === Edge.Start || side === Edge.Top) {
            this.isShowShadowStart = false;
          } else {
            this.isShowShadowStart = true;
          }
          if (side === 3 || side === Edge.Bottom) { // 3: Edge.End
            this.scrollDistance = (
              this.isScreenPortrait ? this.scroller.currentOffset().xOffset : this.scroller.currentOffset().yOffset
            ) ?? 0;
            this.isShowShadowEnd = false;
          } else {
            this.isShowShadowEnd = true;
          }
        })
      })
        // .blendMode(BlendMode.SRC_IN, BlendApplyType.OFFSCREEN)
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.shadowRate = SCROLL_SHADOW_WIDTH / Number(this.isScreenPortrait ? newValue.width : newValue.height);
        })
    }
    .id('petalclip_videoMosaicTool_mosaicType_customScroll')
    .width('100%')
    .height('100%')
    .linearGradient({
      angle: this.isScreenPortrait ? 90 : 180,
      colors: [
        ['rgba(0, 0, 0, 0)', 0],
        ['rgba(0, 0, 0, 1)', this.isShowShadowStart ? this.shadowRate : 0],
        ['rgba(0, 0, 0, 1)', this.isShowShadowEnd ? 1 - this.shadowRate : 1],
        ['rgba(0, 0, 0, 0)', 1]]
    })
  }

  @Builder
  scrollerItem() {
    Flex({
      direction: this.isScreenPortrait ? FlexDirection.Row : FlexDirection.Column,
      alignItems: ItemAlign.Start,
    }) {
      ForEach(this.imageDataList, (item: ResourceButtonItem, index: number | undefined) => {
        mosaicImageItem({
          imageDataList: this.imageDataList,
          itemIndex: index,
          selectionIndex: this.mosaicAttr.selectMosaicIndex,
          selectionKey: this.mosaicAttr.selectMosaicKey,
          onItemSelectChange: this.onItemSelectChange
        }).id('mosaicTab_' + item.key + (this.mosaicAttr.selectMosaicIndex == index ? '_on' : '_off'))
          .margin(this.marginValue(index))
      }, (item: ResourceButtonItem) => item.key)
    }
    .padding(this.isScreenPortrait ? {
      left: ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight(),
      right: ScreenManager.getInstance().updateEditorPageGridPaddingLeftAndRight(),
    } : {})
  }

  private onItemSelectChange = (val: number) => {
    if (val < this.imageDataList.length) {
      HiLog.i('MosaicSelection onItemSelectChange Index:', String(val));
      const tempItem: ResourceButtonItem = this.imageDataList[val];
      this.mosaicAttr.selectMosaicIndex = val;
      this.mosaicAttr.selectMosaicKey = tempItem.key;
      this.onSelectChange(val);
    }
  }

  scrollAppear(): void {
    let index = this.imageDataList.findIndex((item: ResourceButtonItem) => item.key === this.selectionKey);
    HiLog.i(TAG, `scroll index:${index}`);
    ScrollerUtil.scrollerTo(index, this.scroller, this.isScreenPortrait,
      FILTER_BUTTON_SIZE, FILTER_BUTTON_SIZE);
  }
}