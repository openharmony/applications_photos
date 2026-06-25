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

const DEFAULT_MAX_THIRD_SELECT_COUNT: number = 50;
const FILTER_MEDIA_TYPE_ALL: string = 'FILTER_MEDIA_TYPE_ALL';

export class FormConstants {
  public static readonly FORM_ITEM_ALBUM_URI: string = 'form_itemAlbumUri';
  public static readonly FORM_ITEM_DISPLAY_NAME: string = 'form_itemDisplayName';
}

/* storage key begin */
export const THIRD_SELECT_IS_ORIGIN: string = 'third_select_is_origin';

export const IS_SPLIT_MODE: string = 'isSplitMode';

export const LEFT_BLANK: string = 'leftBlank';

export const IS_SIDE_BAR: string = 'isSidebar';

export const IS_HORIZONTAL: string = 'isHorizontal';

/* storage key end */

export const THUMBNAIL_WIDTH: number = 256;

export class ThirdSelectConstants {
  // picker完成按钮支持定制
  public static readonly COMPLETE_BUTTON_TEXT_DONE: number = 0;
  public static readonly COMPLETE_BUTTON_TEXT_SEND: number = 1;
  public static readonly COMPLETE_BUTTON_TEXT_ADD: number = 2;
  public static readonly COMPLETE_BUTTON_TEXT_GRANT: number = 100;

  // 打开大图浏览模式后，左右滑动切换浏览图片的范围
  public static readonly PHOTO_BROWSER_RANGE_ALL: number = 0;
  public static readonly PHOTO_BROWSER_RANGE_SELECTED_ONLY: number = 1;

  /**
   * 模块全限定名，防止广播等发生冲突
   */
  public static readonly FQDN_PREFIX: string = 'com.ohos.photos.thirdselect_';

  public static readonly ABILITY_RESULT: string = `${ThirdSelectConstants.FQDN_PREFIX}abilityResult`;

  // 大图页面支持的UI元素类型
  public static readonly PHOTO_BROWSER_UI_ELEMENT_CHECKBOX: number = 0;
  public static readonly PHOTO_BROWSER_UI_ELEMENT_BACK_BUTTON: number = 1;
}