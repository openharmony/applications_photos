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
import lazy { AlbumGridSortHelper, SortRuleString } from '../../model/AlbumGridSortHelper';
import lazy { emitSortChange, RESUME_DEFAULT, sortChangeParam, sortOptions, } from './index';
import lazy { MenuItemContentModifierParamType, selectEmitType, SelectOptionType } from './type';
import lazy { Constants } from '../../model/common/Constants';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { BroadCastManager } from '../../model/common/BroadCastManager';
import lazy { getScreen, isOrientationHorizontal, ScreenManager } from '../../model/common/ScreenManager';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { TextModifier, SymbolGlyphModifier } from '@kit.ArkUI';

let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
let isOnClick: boolean = false;

const ALBUM_MENU_HOVER_INDEX = 'ALBUM_MENU_HOVER_INDEX';
/**
 * 文字缩进4
 */
const TEXT_INDENT_FOUR = 4;
let getTouchIndex = (event: TouchEvent, touchStartIndex: number) => {
  let itemHeight = event.target?.area?.height as number ?? 1;
  let diffY = event.touches?.[0]?.y ?? 0;
  return touchStartIndex + Math.floor(diffY / itemHeight);
}

@Component
export struct RenderDevider {
  @State hoverIndex: number = -1;
  @Prop index: number;

  aboutToAppear(): void {
    appBroadCast.on(ALBUM_MENU_HOVER_INDEX, this.onHoverIndexChange);
  }

  aboutToDisappear(): void {
    appBroadCast.off(ALBUM_MENU_HOVER_INDEX, this.onHoverIndexChange);
  }

  onHoverIndexChange = (index: number) => {
    this.hoverIndex = index;
  }

  build() {
    Divider()
      .color($r('sys.color.ohos_id_color_list_separator'))
      .height(2)
      .width('100%')
      .position({ left: 0, right: 0, bottom: 0 })
      .opacity((this.hoverIndex != -1 && [this.hoverIndex, this.hoverIndex - 1].includes(this.index)) ? 0 : 1)
  }
}

@Builder
function renderItem(configuration: MenuItemConfiguration, param: MenuItemContentModifierParamType) {
  Row() {
    Row() {
      Column() {
        Text(configuration.value)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.ohos_id_color_primary'))
      }
      .padding({ right: 8 })
      .constraintSize({
        maxWidth: 'calc(100% - 24vp)',
      })

      if (param.isSelected(configuration.index)) {
        SymbolGlyph($r(param.sortType === SortRuleString.DESC ? 'app.media.text_and_arrow_down' :
          'app.media.text_and_arrow_up'))
          .fontColor([$r('sys.color.font_primary')])
          .fontWeight(FontWeight.Medium)
          .fontSize($r('app.float.list_item_right_icon2_height'))
          .align(Alignment.Center)
      }
    }
    .width(`calc(100% - 24vp)`)

    Column() {
      if (param.isSelected(configuration.index)) {
        SymbolGlyph($r('sys.symbol.checkmark'))
          .fontColor([$r('sys.color.font_primary')])
          .fontWeight(FontWeight.Medium)
          .fontSize($r('app.float.list_item_right_icon2_height'))
          .align(Alignment.Center)
      }
    }

    if (configuration.index != param.optionLength - 1 && !DeviceInfo.isPc()) {
      RenderDevider({
        index: configuration.index,
      })
    }
  }
  .width('100%')
  .alignItems(VerticalAlign.Center)
  .constraintSize({
    minHeight: DeviceInfo.isPc() ? Constants.MENU_ITEM_HEIGHT_PC : Constants.MENU_ITEM_HEIGHT_PHONE,
  })
  .padding({
    left: Constants.MENU_ITEM_START_PADDING,
    right: Constants.MENU_ITEM_START_PADDING,
  })
  .justifyContent(FlexAlign.SpaceBetween)
  .onTouch(event => {
    if (event.type === TouchType.Down || event.type === TouchType.Move) {
      appBroadCast.emit(ALBUM_MENU_HOVER_INDEX, [getTouchIndex(event, configuration.index)])
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      appBroadCast.emit(ALBUM_MENU_HOVER_INDEX, [-1])
    }
  })
}

@Builder
function menuItemBuilder(configuration: MenuItemConfiguration) {
  MenuItem(renderItem(configuration,
    (configuration.contentModifier as MenuItemContentModifier).param as MenuItemContentModifierParamType
  ))
    .hoverEffect(HoverEffect.Highlight)
    .width(224 - Constants.MENU_ITEM_START_MARGIN * 2)
    .margin(DeviceInfo.isPc() ? {
      bottom: $r('sys.float.padding_level1'),
    } : undefined)
    .onClick(() => {
      isOnClick = true;
      configuration.triggerSelect(configuration.index, configuration.value.valueOf().toString());
    })
}

class MenuItemContentModifier implements ContentModifier<MenuItemConfiguration> {
  public param: MenuItemContentModifierParamType | null = null;

  constructor(param: MenuItemContentModifierParamType) {
    this.param = param;
  }

  applyContent(): WrappedBuilder<[MenuItemConfiguration]> {
    return wrapBuilder(menuItemBuilder)
  }
}

@Component
export default struct SelectPicker {
  @StorageLink('getFoldStatus') @Watch('updateWrapPadding') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageLink('isHorizontal') @Watch('updateWrapPadding') isHorizontal: boolean = isOrientationHorizontal();
  @State @Watch('updateWrapPadding') isShowSidebar: boolean = false;
  @StorageProp('titlePaddingLeft') @Watch('updateWrapPadding') titlePaddingLeft: number = 0;
  @Prop @Watch('updateTmpSelected') selected: string = '';
  @Prop @Watch('updateTmpSelected') sortType: string = SortRuleString.defaultType;
  @Prop disabled: boolean = false;
  @State wrapPadding: Padding | undefined = undefined;
  @State tmpSelected: string = '';
  @Prop albumKey: string;
  @Prop albumUri: string;
  private albumSubType: number = Number.NaN;
  onSelect: selectEmitType = null;
  private options: SelectOptionType[] =
    sortOptions.map(option => ({ value: option.dialogLabel, key: option.key } as SelectOptionType));

  textModifier: TextModifier = new TextModifier();
  symbolGlyphModifier: SymbolGlyphModifier = new SymbolGlyphModifier();

  aboutToAppear(): void {
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChange);
    this.updateWrapPadding();
    this.textModifier
      .maxFontScale(Constants.FONT_SCALE_LEVEL3_SIZE)
      .textIndent(TEXT_INDENT_FOUR)
    this.symbolGlyphModifier
      .maxFontScale(Constants.defaultScale)
  }

  aboutToDisappear(): void {
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWinSizeChange);
  }

  updateTmpSelected() {
    this.tmpSelected = '';
  }

  onWinSizeChange = () => {
    this.updateWrapPadding();
  }

  getSelectedIndex() {
    return this.options.findIndex(option => option.key === this.selected)
  }

  getSelectedValue() {
    return this.options.find(option => option.key === this.selected)?.value
  }

  getShowSelected() {
    return this.tmpSelected || this.selected;
  }

  private getSelectShowValue(): Resource | string {
    let selected = sortOptions.find(option => option.key === this.getShowSelected());
    if (!selected) {
      return '';
    }
    return selected.titleLabel;
  }

  getSelectSortRule() {
    let defaultSortRule =
      AlbumGridSortHelper.transferOrderPropToRule(AlbumGridSortHelper.getDefaultOrderProp(this.albumUri));
    return this.selected || defaultSortRule;
  }

  isSelected = (index: number) => {
    let key: string = this.options[index]?.key;
    return this.getSelectSortRule() === key;
  }

  build() {
    Row() {
      Row() {
        SymbolGlyph($r(this.sortType === SortRuleString.DESC ? 'app.media.text_and_arrow_down' :
          'app.media.text_and_arrow_up'))
          .fontColor([$r('sys.color.font_primary')])
          .fontWeight(FontWeight.Medium)
          .fontSize($r('app.float.list_title_font_size'))
          .align(Alignment.Center)
          .position(UiUtil.isMirrorMode() ?
            {
              right: 10,
              top: 11,
            }
            : {
              left: 10,
              top: 11,
            })
        Select(this.options)
          .selected(this.getSelectedIndex())
          .value(this.getSelectShowValue())
          .backgroundColor(Color.Transparent)
          .padding(UiUtil.isMirrorMode() ? { right: 24 } : { left: 24 })
          .onSelect((index: number) => {
            const param: sortChangeParam = {
              albumUri: this.albumUri,
              albumKey: this.albumKey,
              selected: this.options[index].key,
              selectEmit: this.onSelect,
              albumSubType: this.albumSubType,
              clickSource: 'GirdMenu',
            };
            this.tmpSelected = param.selected;
            if (isOnClick) {
              emitSortChange(param);
              isOnClick = false;
            } else {
              // 拦截语言切换时自动触发的onSelect事件
              this.updateTmpSelected();
            }
          })
          .menuItemContentModifier(new MenuItemContentModifier({
            isSelected: this.isSelected,
            sortType: this.sortType,
            optionLength: this.options.length,
          }))
          .arrowModifier(this.symbolGlyphModifier)
          .textModifier(this.textModifier)
      }
      .width('70%')

      Text($r('app.string.album_photo_sort_dialog_item_back_to_default'))
        .fontColor($r('sys.color.font_emphasize'))
        .fontWeight(FontWeight.Medium)
        .fontSize(16)
        .onClick(() => {
          const param: sortChangeParam = {
            albumUri: this.albumUri,
            albumKey: this.albumKey,
            selected: RESUME_DEFAULT,
            selectEmit: this.onSelect,
            albumSubType: this.albumSubType,
            clickSource: 'GridMenu',
          };
          emitSortChange(param);
        })
        .maxFontScale(Constants.FONT_SCALE_LEVEL3_SIZE)
        .constraintSize({
          maxWidth: '30%',
        })
    }
    .width('100%')
    .padding(this.wrapPadding)
    .justifyContent(FlexAlign.SpaceBetween)
    .enabled(!this.disabled)
    .opacity(this.disabled ? 0.4 : 1)
  }

  updateWrapPadding() {
    this.wrapPadding = this.getWrapPadding();
  }

  getWrapPadding(): Padding | undefined {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return;
    }
    let padding = 16;
    /* instrument ignore next */
    if (DeviceInfo.isFoldable() && this.isFoldExpanded && getScreen().isFullMode()) {
      padding = 24;
    }
    /* instrument ignore next */
    if (DeviceInfo.isTablet() && this.isHorizontal) {
      padding = 32;
    }
    /* instrument ignore next */
    if (DeviceInfo.isTablet() && !this.isHorizontal && !this.isShowSidebar) {
      padding = 24;
    }
    /* instrument ignore next */
    if (DeviceInfo.isTablet() && getScreen().isSplitMode()) {
      padding = this.titlePaddingLeft;
    }
    return { left: padding, right: padding };
  }
}