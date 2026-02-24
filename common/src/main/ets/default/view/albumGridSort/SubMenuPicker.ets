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
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { SelectOptionType, DividerStyleType, DialogItemOptionType, SortSelectMenuParamType } from './type'
import lazy { AlbumGridSortHelper, SortRuleString } from '../../model/AlbumGridSortHelper'
import lazy { emitSortChange, sortChangeParam, sortOptions } from './index'
import lazy { Constants } from '../../model/common/Constants';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';

const TV_ITEM_FONT_WEIGHT = 666;
const PC_ITEM_FONT_WEIGHT = 'medium';
const TV_ITEM_FONT_SIZE = '26vp';

@Component
export default struct SubMenuPicker {
  @Prop subMenuExpandingMode: SubMenuExpandingMode;
  private albumKey: string = '';
  private albumUri: string = '';
  private albumSubType: number = Number.NaN;
  onMenuClicked: Function = (): void => {
  };
  getAlbumInfoFunc: Function | undefined = undefined;
  private options: SelectOptionType[] =
    sortOptions.map(option => ({ value: option.dialogLabel, key: option.key } as SelectOptionType));
  @State selected: string = '';
  @State sortType: string = SortRuleString.defaultType;

  aboutToAppear(): void {
    this.updateAlbumUriAndAlbumKey();
    let sortRuleString = AlbumGridSortHelper.getInstance().getSortRule('SubMenuPicker', this.albumKey);
    this.selected = sortRuleString.rule;
    this.sortType = sortRuleString.type;
  }

  getSelectSortRule() {
    let defaultSortRule =
      AlbumGridSortHelper.transferOrderPropToRule(AlbumGridSortHelper.getDefaultOrderProp(this.albumUri));
    return this.selected || defaultSortRule;
  }

  isSelected(key: string) {
    return this.getSelectSortRule() === key;
  }

  @Builder
  renderDivider(style?: DividerStyleType) {
    Divider()
      .color($r('sys.color.ohos_id_color_list_separator'))
      .height(2)
      .width(style?.width ?? '100%')
      .margin({
        left: style?.marginLeft ?? Constants.MENU_START_MARGIN,
        right: style?.marginRight ?? Constants.MENU_START_MARGIN,
      })
  }

  private onSelect = (sortRule: string, sortType: string): void => {
    let onSelected: SortSelectMenuParamType = () => ({
      selected: sortRule,
      sortType: sortType,
    })
    this.onMenuClicked(onSelected);
  }

  private updateAlbumUriAndAlbumKey() {
    if (!this.getAlbumInfoFunc) {
      return;
    }
    let albumInfo: AlbumInfo | undefined = this.getAlbumInfoFunc();
    if (!albumInfo) {
      return;
    }
    this.albumUri = albumInfo.uri;
    this.albumKey = AlbumGridSortHelper.getAlbumKeyByAlbumInfo(albumInfo);
  }

  @Builder
  renderItem(option: SelectOptionType) {
    Row() {
      Row() {
        Column() {
          Text(option.value)
            .fontWeight(DeviceInfo.isTv() ? TV_ITEM_FONT_WEIGHT : PC_ITEM_FONT_WEIGHT)
            .fontSize(DeviceInfo.isTv() ? TV_ITEM_FONT_SIZE : undefined)
            .fontColor($r('sys.color.ohos_id_color_primary'))
        }
        .padding({ end: LengthMetrics.vp(8) })
        .constraintSize({
          maxWidth: 'calc(100% - 24vp)',
        })

        if (this.isSelected(option.key)) {
          SymbolGlyph($r(this.sortType === SortRuleString.DESC ? 'app.media.text_and_arrow_down' :
            'app.media.text_and_arrow_up'))
            .fontColor([$r('sys.color.font_primary')])
            .fontWeight(FontWeight.Regular)
            .fontSize($r('app.float.list_item_right_icon2_height'))
            .align(Alignment.Center)
        }
      }
      .width(`calc(100% - 24vp)`)

      Column() {
        if (this.isSelected(option.key)) {
          SymbolGlyph($r('sys.symbol.checkmark'))
            .fontColor([$r('sys.color.font_primary')])
            .fontWeight(FontWeight.Regular)
            .fontSize($r('app.float.list_item_right_icon2_height'))
            .align(Alignment.Center)
        }
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .constraintSize({
      minHeight: DeviceInfo.isPc() ? Constants.MENU_ITEM_HEIGHT_PC : Constants.MENU_ITEM_HEIGHT_PHONE,
    })
    .padding({
      left: Constants.SORT_MENU_ITEM_PADDING,
      right: Constants.SORT_MENU_ITEM_PADDING,
      top: Constants.SORT_MENU_ITEM_PADDING_Top_Bottom,
      bottom: Constants.SORT_MENU_ITEM_PADDING_Top_Bottom,
    })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  renderMenuItems() {
    if (this.subMenuExpandingMode === SubMenuExpandingMode.EMBEDDED_EXPAND) {
      this.renderDivider({
        marginLeft: -Constants.SORT_MENU_ITEM_PADDING,
        marginRight: 0,
        width: `calc(100% + ${Constants.SORT_MENU_ITEM_PADDING * 2}vp)`
      })
    }
    ForEach(this.options, (option: SelectOptionType, index: number) => {
      MenuItem(this.renderItem(option))
        .contentFont({ weight: 'medium' })
        .width('100%')
        .margin(DeviceInfo.isPc() ? {
          bottom: index === this.options.length - 1 ? 0 : $r('sys.float.padding_level1')
        } : undefined)
        .hoverEffect(HoverEffect.Highlight)
        .onClick(() => {
          const param: sortChangeParam = {
            albumUri: this.albumUri,
            albumKey: this.albumKey,
            selected: option.key,
            selectEmit: this.onSelect,
            albumSubType: this.albumSubType,
            clickSource: 'MoreSubMenu',
          };
          emitSortChange(param);
        })
      if (this.subMenuExpandingMode === SubMenuExpandingMode.STACK_EXPAND && index != this.options.length - 1) {
        this.renderDivider()
      }
    }, (item: DialogItemOptionType, index: number) => `${index}`)
  }

  build() {
    if (this.subMenuExpandingMode === SubMenuExpandingMode.STACK_EXPAND) {
      Column() {
        this.renderMenuItems()
      }
    } else {
      Menu() {
        this.renderMenuItems()
      }
      .width(DeviceInfo.isPc() ? $r('app.float.more_menu_width') : '100%')
      .padding({ right: 0 })
      .constraintSize({
        minHeight: DeviceInfo.isPc() ? Constants.MENU_ITEM_HEIGHT_PC * this.options.length +
          (new RscGetter(getContext().resourceManager).getNumber($r('sys.float.padding_level1')) *
            (this.options.length - 1)) : undefined
      })
      .menuItemDivider(DeviceInfo.isPc() ? undefined : {
        strokeWidth: LengthMetrics.px(Constants.MENU_STROKE_WIDTH),
        color: $r('sys.color.ohos_id_color_list_separator'),
        startMargin: LengthMetrics.vp(Constants.SUB_MENU_START_MARGIN),
        endMargin: LengthMetrics.vp(Constants.SUB_MENU_START_MARGIN),
      })
    }
  }
}
