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
import lazy { Action } from './Action';
import lazy { ActionBarColorMode, ActionBarMode, ActionBarSelectionMode } from './ActionBarMode';
import type { DisplayName } from '../../model/common/DataTypes';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';

// ActionBarProp
export class ActionBarProp {
  public static readonly NORMAL_BACKGROUND_COLOR: Resource = $r('sys.color.comp_background_gray');
  public static readonly PHOTO_BROWSER_ACTIONBAR_BACKGROUND_COLOR: Resource =
    $r('sys.color.ohos_id_color_bottom_tab_sub_bg_blur');
  public static readonly TRANSPARENT_BACKGROUND_COLOR: Resource = $r('app.color.transparent');
  public static readonly NORMAL_TEXT_COLOR: Resource = $r('sys.color.ohos_id_color_text_primary');
  public static readonly NORMAL_SUBTITLE_TEXT_COLOR: Resource = $r('sys.color.icon_secondary');
  public static readonly ICON_COLOR: Resource = $r('sys.color.icon_primary');
  public static readonly TRANSPARENT_TEXT_COLOR: Resource = $r('sys.color.ohos_id_color_text_primary_dark');
  public static readonly TRANSPARENT_SUBTITLE_TEXT_COLOR: Resource =
    $r('app.color.subtitle_text_color_on_transparent_bg');
  public static readonly HEAD_TITLE_TEXT_SIZE: Resource = $r('sys.float.Title_L');
  public static readonly HEAD_TITLE_ONE_LINE_TEXT_SIZE: Resource = $r('sys.float.titlebar_title_secondary_size');
  public static readonly TITLE_TEXT_SIZE: Resource = $r('sys.float.Title_S');
  public static readonly TITLE_TEXT_MIN_SIZE: Resource = $r('sys.float.Subtitle_M');
  public static readonly SUB_TITLE_TEXT_SIZE: Resource = $r('sys.float.Subtitle_S');
  public static readonly SUB_TITLE_TEXT_SIZE_PC: Resource = $r('sys.float.Caption_L');
  public static readonly TITLE_FONT_WEIGHT = 500;
  public static readonly SUBTITLE_TEXT_SIZE: Resource = $r('sys.float.Body_M');
  public static readonly MEDIUM_FONT: Resource = $r('app.string.id_text_font_family_medium');
  public static readonly REGULAR_FONT: Resource = $r('app.string.id_text_font_family_regular');
  public static readonly SINGLE_UNSELECT_TITLE: Resource = $r('app.string.title_select_photos');
  public static readonly SINGLE_SELECT_ALBUM_TITLE: Resource = $r('app.string.title_select_album');
  public static readonly SINGLE_TAB_ALBUM_TITLE: Resource = $r('app.string.tab_albums');
  public static readonly MULTI_UNSELECT_TITLE: Resource = $r('app.string.title_none_selected');
  public static readonly PHOTO_BROWSER_ACTIONBAR_ALPHA = 0.95;
  public static readonly LEVELONE_PAGE_ACIONTBAR_TITLE_MAX_FONT = 30;
  public static readonly LEVELONE_PAGE_ACTIONBAR_TITLE_MIN_FONT = 14;
  private hasTabBar = false;
  private hasSearchBar = false;
  private leftAction = Action.NONE;
  private rightAction = Action.NONE;
  private isHeadTitle = false;
  private title: DisplayName = '';
  private subTitle: DisplayName = '';
  private menuList: Action[] = [];
  private backgroundColorResource: Resource = ActionBarProp.NORMAL_BACKGROUND_COLOR;
  private alpha = 1;
  private selectionMode: ActionBarSelectionMode = ActionBarSelectionMode.MULTI;
  private colorMode: ActionBarColorMode = ActionBarColorMode.NORMAL;
  private mode: ActionBarMode = ActionBarMode.STANDARD_MODE;
  private maxSelectCount = 0;
  private isNeedTitle: boolean = true;
  private isNavTitle: boolean = false;
  private titleFontSize: Resource | number = ActionBarProp.TITLE_TEXT_SIZE;
  private subTitleFontSize: Resource | number = ActionBarProp.SUB_TITLE_TEXT_SIZE;
  private isLevelOneHeadTitle: boolean = false;
  private isShowPhotoDate: boolean = true;
  private isImmersive: boolean = false;
  private flexibleMenuList: Action[] = [];
  private menuListMinWidth: number = 0;
  private originalMenuListLength: number = 0;
  private isUpdateOriginalLength: boolean = true;
  private detailMenuPanelWidth: number = 0;
  public albumInfo: AlbumInfo | undefined = undefined;

  constructor() {
  }

  public static getCountDetailSelectedTitle(count: number): Resource {
    return $r('app.plural.count_details_selected', count, count);
  }

  /**
   * External selection quantity display
   * @param count The selected quantity, same as the current count above
   * @param maxSelectCount Maximum number of options
   */
  public static getCountDetailExternalSelectedTitle(count: number, maxSelectCount: number): Resource {
    return $r('app.plural.count_details_external_selected', count, count, maxSelectCount, maxSelectCount);
  }

  public setHasTabBar(hasTabBar: boolean): ActionBarProp {
    this.hasTabBar = hasTabBar;
    return this;
  }

  public getHasTabBar(): boolean {
    return this.hasTabBar;
  }

  public setHasSearchBar(hasSearchBar: boolean): ActionBarProp {
    this.hasSearchBar = hasSearchBar;
    return this;
  }

  public getHasSearchBar(): boolean {
    return this.hasSearchBar;
  }

  public setLeftAction(leftAction: Action): ActionBarProp {
    this.leftAction = leftAction;
    return this;
  }

  public getLeftAction(): Action {
    return this.leftAction;
  }

  public setRightAction(rightAction: Action): ActionBarProp {
    this.rightAction = rightAction;
    return this;
  }

  public getRightAction(): Action {
    return this.rightAction;
  }

  public setIsHeadTitle(isHeadTitle: boolean): ActionBarProp {
    this.isHeadTitle = isHeadTitle;
    return this;
  }

  public getIsHeadTitle(): boolean {
    return this.isHeadTitle;
  }

  public setIsLevelOneHeadTitle(isLevelOneHeadTitle: boolean): ActionBarProp {
    this.isLevelOneHeadTitle = isLevelOneHeadTitle;
    return this;
  }

  public getIsLevelOneHeadTitle(): boolean {
    return this.isLevelOneHeadTitle;
  }

  public setTitleFontSize(fontSize: Resource | number): ActionBarProp {
    this.titleFontSize = fontSize;
    return this;
  }

  public getTitleFontSize(): Resource | number {
    return this.titleFontSize;
  }

  public setSubTitleFontSize(fontSize: Resource | number): ActionBarProp {
    this.subTitleFontSize = fontSize;
    return this;
  }

  public getSubTitleFontSize(): Resource | number {
    return this.subTitleFontSize;
  }

  public setIsNavTitle(isNavTitle: boolean): ActionBarProp {
    this.isNavTitle = isNavTitle;
    return this;
  }

  public getIsNavTitle(): boolean {
    return this.isNavTitle;
  }

  public setTitle(title: DisplayName): ActionBarProp {
    this.title = title;
    return this;
  }

  public getTitle(): DisplayName {
    return this.title as DisplayName;
  }

  public setSubTitle(subTitle: DisplayName): ActionBarProp {
    this.subTitle = subTitle;
    return this;
  }

  public getSubTitle(): DisplayName {
    return this.subTitle as DisplayName;
  }

  public setMenuList(menuList: Action[]): ActionBarProp {
    this.menuList = menuList;
    return this;
  }

  public getMenuList(): Action[] {
    return this.menuList;
  }

  public setBackgroundColor(backgroundColorResource: Resource): ActionBarProp {
    this.backgroundColorResource = backgroundColorResource;
    return this;
  }

  public getBackgroundColor(): Resource {
    return this.colorMode ===
    ActionBarColorMode.TRANSPARENT ? ActionBarProp.TRANSPARENT_BACKGROUND_COLOR : this.backgroundColorResource;
  }

  public setAlpha(alpha: number): ActionBarProp {
    this.alpha = alpha;
    return this;
  }

  public getAlpha(): number {
    return this.alpha;
  }

  public setMode(mode: ActionBarMode): ActionBarProp {
    this.mode = mode;
    return this;
  }

  public getMode(): ActionBarMode {
    return this.mode;
  }

  public setColorMode(colorMode: ActionBarColorMode): ActionBarProp {
    this.colorMode = colorMode;
    return this;
  }

  public getColorMode(): ActionBarColorMode {
    return this.colorMode;
  }

  public setSelectionMode(selectionMode: ActionBarSelectionMode): ActionBarProp {
    this.selectionMode = selectionMode;
    return this;
  }

  public getSelectionMode(): ActionBarSelectionMode {
    return this.selectionMode;
  }

  public setMaxSelectCount(maxSelectCount: number): ActionBarProp {
    this.maxSelectCount = maxSelectCount;
    return this;
  }

  public getMaxSelectCount(): number {
    return this.maxSelectCount;
  }

  public setIsNeedTitle(isNeedTitle: boolean): ActionBarProp {
    this.isNeedTitle = isNeedTitle;
    return this;
  }

  public getIsNeedTitle(): boolean {
    return this.isNeedTitle;
  }

  public getIsShowPhotoDate(): boolean {
    return this.isShowPhotoDate;
  }

  public setIsShowPhotoDate(isShowPhotoDate: boolean): ActionBarProp {
    this.isShowPhotoDate = isShowPhotoDate;
    return this;
  }

  public setIsImmersive(isImmersive: boolean): ActionBarProp {
    this.isImmersive = isImmersive;
    return this;
  }

  public getIsImmersive(): boolean {
    return this.isImmersive;
  }

  public setFlexibleMenuList(flexibleMenuList: Action[]): ActionBarProp {
    this.flexibleMenuList = flexibleMenuList;
    return this;
  }

  public getFlexibleMenuList(): Action[] {
    return this.flexibleMenuList;
  }

  public setMenuListMinWidth(menuListMinWidth: number): ActionBarProp {
    this.menuListMinWidth = menuListMinWidth;
    return this;
  }

  public getMenuListMinWidth(): number {
    return this.menuListMinWidth;
  }

  public setOriginalMenuListLength(originalMenuListLength: number): ActionBarProp {
    this.originalMenuListLength = originalMenuListLength;
    return this;
  }

  public getOriginalMenuListLength(): number {
    return this.originalMenuListLength;
  }

  public setIsUpdateOriginalLength(isUpdateOriginalLength: boolean): ActionBarProp {
    this.isUpdateOriginalLength = isUpdateOriginalLength;
    return this;
  }

  public getIsUpdateOriginalLength(): boolean {
    return this.isUpdateOriginalLength;
  }

  public setDetailMenuPanelWidth(detailMenuPanelWidth: number): ActionBarProp {
    this.detailMenuPanelWidth = detailMenuPanelWidth;
    return this;
  }

  public getDetailMenuPanelWidth(): number {
    return this.detailMenuPanelWidth;
  }

  public setAlbumInfo(albumInfo: AlbumInfo | undefined): ActionBarProp {
    this.albumInfo = albumInfo;
    return this;
  }

  public getAlbumInfo(): AlbumInfo | undefined {
    return this.albumInfo;
  }
}