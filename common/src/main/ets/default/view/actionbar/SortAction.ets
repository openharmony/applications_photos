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
import lazy { ActionViewModel, MenuConstants, ParamsWrapper } from './Menu';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionButtonProp, DefaultActionButtonProp, SubMenuBuilderParam } from './ActionButton';
import lazy { SortSelectMenuParamType } from '../../view/albumGridSort';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { SubMenuPicker } from '../../view/albumGridSort';
import lazy { AlbumGridSortHelper } from '../../model/AlbumGridSortHelper';
import lazy { SymbolGlyphModifier } from '@kit.ArkUI';

export type SubMenuParamType = number | string | SortSelectMenuParamType;

/* instrument ignore file */
const TAG = 'SortAction';

export interface SortSubMenuBuilderParam {
  albumInfo: AlbumInfo;
  onMenuClicked: Function;
  getAlbumInfoFunc?: Function;
};

@Observed
export class SortActionProp extends DefaultActionButtonProp {
  public action = Action.ALBUM_GRID_SORT;
  public text = $r('app.string.album_photo_sort');
  public key = 'ActionButton_Sort';
  public hasSubMenu: boolean = true;
  public customSubMenuBuilder: WrappedBuilder<[SubMenuBuilderParam]> | undefined = wrapBuilder(buildSubMenu);
  /**
   * 相册信息
   */
  public albumInfo: AlbumInfo | undefined = undefined;

  public constructor(albumInfo: AlbumInfo | undefined, menuFunc: Function, getAlbumInfoFunc: Function | undefined) {
    super();
    Log.info(TAG, `new SortActionProp, albumInfo: ${albumInfo}`);
    this.customSubMenuBuilderParam = {
      albumInfo: albumInfo,
      onMenuClicked: menuFunc,
      getAlbumInfoFunc: getAlbumInfoFunc,
    } as SortSubMenuBuilderParam;
    this.albumInfo = albumInfo;
    this.subMenuClick = menuFunc;
    this.customSubMenuBuilder = wrapBuilder(buildSubMenu);
    this.getAlbumInfoFunc = getAlbumInfoFunc;

    //PC 子菜单
    this.symbolEndIcon = new SymbolGlyphModifier($r('sys.symbol.chevron_right')).fontSize($r('sys.float.Title_M'));
    this.customMenuItemBuilder = wrapBuilder(buildMenuItems);
  }
}

@Builder
export function buildSubMenu(param: SubMenuBuilderParam) {
  CustomRenderSubMenu({
    albumInfo: (param.param as SortSubMenuBuilderParam).albumInfo,
    onMenuClicked: (subMenu: SubMenuParamType): void => (param.param as SortSubMenuBuilderParam).onMenuClicked(subMenu),
    getAlbumInfoFunc: (param.param as SortSubMenuBuilderParam)?.getAlbumInfoFunc
  });
}

@Builder
export function buildMenuItems(prop: ActionButtonProp) {
  CustomRenderSubMenu({
    albumInfo: (prop as SortActionProp).albumInfo,
    onMenuClicked: prop.subMenuClick,
  });
}

@Component
export struct CustomRenderSubMenu {
  onMenuClicked: Function = (): void => {
  };
  @State albumInfo: AlbumInfo | undefined = undefined;
  @Prop subMenuExpandingMode: SubMenuExpandingMode;
  getAlbumInfoFunc: Function = (): void => {
  };

  build() {
    SubMenuPicker({
      onMenuClicked: this.onMenuClicked,
      subMenuExpandingMode: this.subMenuExpandingMode,
      albumKey: AlbumGridSortHelper.getAlbumKeyByAlbumInfo(this.albumInfo),
      albumUri: this.albumInfo?.uri,
      albumSubType: this.albumInfo?.subType,
      getAlbumInfoFunc: this.getAlbumInfoFunc
    })
  }
}

/**
 * Action注册类
 */
export class SortActionRegister extends ActionRegister {
  public getActions(): Action[] {
    return [Action.ALBUM_GRID_SORT];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new SortActionViewModel(params?.get<NavPathStack>(MenuConstants.KEY_NAV_PATH_STACK) as NavPathStack);
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new SortActionProp(params?.get<AlbumInfo>(MenuConstants.KEY_ALBUM_INFO) as AlbumInfo,
      params.get<Function>(MenuConstants.SUB_MENU_CLICKED),
      params.get<Function>(MenuConstants.KEY_GET_ALBUM_INFO_FUNC)
    );
  }
}

/**
 * VM层
 */
export class SortActionViewModel implements ActionViewModel {
  private readonly navigationPageInfos: NavPathStack;

  /**
   * 构造函数
   * @param navigationPageInfos 导航栈
   */
  public constructor(navigationPageInfos: NavPathStack) {
    this.navigationPageInfos = navigationPageInfos;
  }

  public doAction(menuContext?: MenuContext): void {
    // todo 下拉菜单
  }
}