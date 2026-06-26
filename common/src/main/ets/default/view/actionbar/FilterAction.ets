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
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { ActionViewModel, ParamsWrapper } from './Menu';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionButtonProp, DefaultActionButtonProp, SubMenuBuilderParam } from './ActionButton';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { Constants } from '../../model/common/Constants';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { AlbumDataSource } from '../../model/AlbumDataSource';
import lazy { PositionFilter } from '../../model/PositionFilter';
import lazy { PhotoDataImpl } from '../../model/browser/photo/PhotoDataImpl';
import lazy { DividerStyleType, SelectOptionType } from '../albumGridSort/type';
import lazy { toString } from '../../access/UserFileManagerAccess';


/* instrument ignore file */
const TAG = 'FilterAction';
const TV_ITEM_FONT_WEIGHT: number = 666;
const PC_ITEM_FONT_WEIGHT: string = 'medium';
const TV_ITEM_FONT_SIZE: string = '26vp';

export const COMPONENT_KEY_FILTER: string = 'Filter';

export const FILTER: Action = new Action({
  id: Action.uuid,
  textRes: $r("app.string.filter_file"),
  componentKey: COMPONENT_KEY_FILTER,
});

@Observed
export class FilterActionProp extends DefaultActionButtonProp {
  public action: Action | undefined = FILTER;
  public text: string | Resource = FILTER.textRes;
  public key: string = FILTER.componentKey;
  public filterOptions: SelectOptionType[] = [];
  public selected: string = '0';
  public onSelect: (option: SelectOptionType) => void = (option: SelectOptionType) => {
  };
  public hasSubMenu: boolean = true;
  public customSubMenuBuilder: WrappedBuilder<[SubMenuBuilderParam]> | undefined = wrapBuilder(buildSubMenu);
  public customSubMenuBuilderParam?: object | undefined = this;
}

/**
 * Action注册类
 */
export class FilterActionRegister extends ActionRegister {
  private readonly viewModel: ActionViewModel | undefined;

  public constructor(viewModel: ActionViewModel | undefined) {
    super();
    this.viewModel = viewModel;
  }

  public getActions(): Action[] {
    return [FILTER];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return this.viewModel;
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    let prop: FilterActionProp = new FilterActionProp();
    prop.onSelect = (option: SelectOptionType) => {
      (this.viewModel as FilterActionViewModel).onSelect(option);
    }
    return prop;
  }
}

/**
 * VM层
 */
export class FilterActionViewModel implements ActionViewModel {
  private readonly selectManager: SelectManager | undefined;
  private readonly dataSource: AlbumDataSource | undefined;

  public constructor(selectManager: SelectManager | undefined, dataSource: AlbumDataSource | undefined) {
    this.selectManager = selectManager;
    this.dataSource = dataSource;
  }

  public doAction(menuContext?: MenuContext): void {
    Log.info(TAG, 'doAction');
  }

  public onSelect(option: SelectOptionType): void {
    let filter: PositionFilter = parseInt(option.key);
    this.dataSource?.setPositionFilter(filter);
    let dataImpl: PhotoDataImpl | undefined = this.selectManager?.photoDataImpl as PhotoDataImpl;
    if (dataImpl) {
      dataImpl.positionFilter = filter;
    }
  }
}

@Builder
export function buildSubMenu(param: SubMenuBuilderParam) {
  FilterSubMenuPicker({ prop: param.param as FilterActionProp });
}

@Component
export default struct FilterSubMenuPicker {
  @State @Watch('onPropChanged') public prop: FilterActionProp = new FilterActionProp();
  @State private options: SelectOptionType[] = [];

  aboutToAppear(): void {
    this.onPropChanged();
  }

  private onPropChanged(): void {
    this.options = this.prop.filterOptions.slice();
    Log.info(TAG, `onPropChanged ${toString(this.prop.filterOptions)}, ${this.prop.selected}`);
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
      }
      .width(`calc(100% - 24vp)`)

      Column() {
        if (this.prop.selected === option.key) {
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
    ForEach(this.options, (option: SelectOptionType, index: number) => {
      MenuItem(this.renderItem(option))
        .contentFont({ weight: 'medium' })
        .width('100%')
        .margin(DeviceInfo.isPc() ? {
          bottom: index === this.options.length - 1 ? 0 : $r('sys.float.padding_level1')
        } : undefined)
        .hoverEffect(HoverEffect.Highlight)
        .onClick(() => {
          this.prop.selected = option.key;
          this.prop.onSelect(option);
        })
    }, (item: SelectOptionType, index: number) => `${item.key}`)
  }

  build() {
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
      startMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN),
      endMargin: LengthMetrics.vp(Constants.MENU_START_MARGIN),
    })
  }
}