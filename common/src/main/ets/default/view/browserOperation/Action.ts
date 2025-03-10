/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

enum ActionID {
  NONE,
  OK,
  OK_DISABLE,
  CANCEL,
  BACK,
  INFO,
  INFO_INVALID,
  DELETE,
  DELETE_RECYCLE,
  CLEAR_RECYCLE,
  DELETE_INVALID,
  RECOVER,
  RECOVER_INVALID,
  FAVORITE,
  NOT_FAVORITE,
  UN_SELECTED,
  SELECTED,
  MULTISELECT,
  MULTISELECT_INVALID,
  SELECT_ALL,
  DESELECT_ALL,
  SETTING,
  NAVIGATION,
  MATERIAL_SELECT,
  GOTO_PHOTOS,
  SHARE,
  SHARE_INVALID,
  EDIT,
  EDIT_INVALID,
  MORE,
  NEW,
  RENAME,
  RENAME_INVALID,
  ADD_NOTES,
  ROTATE,
  MOVE,
  MOVE_INVALID,
  ADD,
  ADD_INVALID,
  COPY,
  COPY_INVALID,
  REMOVE_FROM,
  REMOVE_FROM_INVALID,
  NAVIGATION_ALBUMS,
  DOWNLOAD,
  DOWNLOAD_INVALID,
  CLEAR_RECYCLE_INVALID
}

const COMPONENT_KEY_OK: string = 'OK';
const COMPONENT_KEY_OK_DISABLE: string = 'OK';
const COMPONENT_KEY_CANCEL: string = 'Cancel';
const COMPONENT_KEY_BACK: string = 'Back';
const COMPONENT_KEY_INFO: string = 'Info';
const COMPONENT_KEY_INFO_INVALID: string = 'Info';
const COMPONENT_KEY_DELETE: string = 'Delete';
const COMPONENT_KEY_DELETE_RECYCLE: string = 'DeleteRecycle';
const COMPONENT_KEY_CLEAR_RECYCLE: string = 'ClearRecycle';
const COMPONENT_KEY_DELETE_INVALID: string = 'Delete';
const COMPONENT_KEY_RECOVER: string = 'Recover';
const COMPONENT_KEY_RECOVER_INVALID: string = 'Recover';
const COMPONENT_KEY_FAVORITE: string = 'Favor';
const COMPONENT_KEY_NOT_FAVORITE: string = 'Favor';
const COMPONENT_KEY_UN_SELECTED: string = 'Selected';
const COMPONENT_KEY_SELECTED: string = 'Selected';
const COMPONENT_KEY_MULTISELECT: string = 'MultiSelected';
const COMPONENT_KEY_MULTISELECT_INVALID: string = 'MultiSelected';
const COMPONENT_KEY_SELECT_ALL: string = 'SelectAll';
const COMPONENT_KEY_DESELECT_ALL: string = 'SelectAll';
const COMPONENT_KEY_NAVIGATION: string = 'Navigation';
const COMPONENT_KEY_SETTING: string = 'Setting';
const COMPONENT_KEY_MATERIAL_SELECT: string = 'MaterialSelect';
const COMPONENT_KEY_GOTO_PHOTOS: string = 'GotoPhotos';
const COMPONENT_KEY_SHARE: string = 'Share';
const COMPONENT_KEY_SHARE_INVALID: string = 'Share';
const COMPONENT_KEY_EDIT: string = 'Edit';
const COMPONENT_KEY_EDIT_INVALID: string = 'Edit';
const COMPONENT_KEY_MORE: string = 'More';
const COMPONENT_KEY_NEW: string = 'New';
const COMPONENT_KEY_RENAME: string = 'Rename';
const COMPONENT_KEY_RENAME_INVALID: string = 'Rename';
const COMPONENT_KEY_ADD_NOTES: string = 'AddNotes';
const COMPONENT_KEY_ROTATE: string = 'Rotate';
const COMPONENT_KEY_MOVE: string = 'Move';
const COMPONENT_KEY_MOVE_INVALID: string = 'Move';
const COMPONENT_KEY_COPY: string = 'Copy';
const COMPONENT_KEY_COPY_INVALID: string = 'Copy';
const COMPONENT_KEY_ADD: string = 'Add';
const COMPONENT_KEY_ADD_INVALID: string = 'Add';
const COMPONENT_KEY_REMOVE_FROM: string = 'RemoveFrom';
const COMPONENT_KEY_REMOVE_FROM_INVALID: string = 'RemoveFrom';
const COMPONENT_KEY_NAVIGATION_ALBUMS: string = 'NavigationAlbums';
const COMPONENT_KEY_DOWNLOAD: string = 'Download';
const COMPONENT_KEY_DOWNLOAD_INVALID: string = 'Download';
const COMPONENT_KEY_CLEAR_RECYCLE_INVALID: string = 'ClearRecycle';

interface ActionOptions {
  id: number;
  textRes: Resource;
  iconRes?: Resource;
  isAutoTint?: boolean;
  fillColor?: Resource;
  actionType?: Resource;
  componentKey?: string;
}

export class Action {
  public static NONE = new Action({
    id: ActionID.NONE,
    iconRes: null,
    textRes: null
  });
  public static OK = new Action({
    id: ActionID.OK,
    iconRes: $r('app.media.ic_gallery_public_ok'),
    textRes: $r('app.string.action_ok'),
    componentKey: COMPONENT_KEY_OK
  });
  public static OK_DISABLE = new Action({
    id: ActionID.OK_DISABLE,
    iconRes: $r('app.media.ic_gallery_public_ok'),
    textRes: $r('app.string.action_ok'),
    fillColor: $r('app.color.icon_disabled_color'),
    componentKey: COMPONENT_KEY_OK_DISABLE
  });
  public static CANCEL = new Action({
    id: ActionID.CANCEL,
    iconRes: $r('app.media.ic_gallery_public_cancel'),
    textRes: $r('app.string.action_cancel'),
    fillColor: $r('sys.color.ohos_id_color_primary'),
    componentKey: COMPONENT_KEY_CANCEL
  });
  public static BACK = new Action({
    id: ActionID.BACK,
    iconRes: $r('app.media.ic_gallery_public_back'),
    textRes: $r('app.string.action_back'),
    fillColor: $r('sys.color.ohos_id_color_primary'),
    componentKey: COMPONENT_KEY_BACK
  });
  public static INFO = new Action({
    id: ActionID.INFO,
    iconRes: $r('app.media.ic_gallery_public_details'),
    textRes: $r('app.string.action_info'),
    componentKey: COMPONENT_KEY_INFO
  });
  public static INFO_INVALID = new Action({
    id: ActionID.INFO_INVALID,
    iconRes: $r('app.media.ic_gallery_public_details'),
    textRes: $r('app.string.action_info'),
    fillColor: $r('app.color.icon_disabled_color'),
    componentKey: COMPONENT_KEY_INFO_INVALID
  });
  public static DELETE = new Action({
    id: ActionID.DELETE,
    iconRes: $r('app.media.ic_gallery_public_delete_line'),
    textRes: $r('app.string.action_delete'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_DELETE
  });
  public static DELETE_RECYCLE = new Action({
    id: ActionID.DELETE_RECYCLE,
    iconRes: $r('app.media.ic_gallery_public_delete_line'),
    textRes: $r('app.string.action_delete'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_DELETE_RECYCLE
  });
  public static CLEAR_RECYCLE = new Action({
    id: ActionID.CLEAR_RECYCLE,
    iconRes: $r('app.media.ic_gallery_public_delete_line'),
    textRes: $r('app.string.action_clear_recycle'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_CLEAR_RECYCLE
  });
  public static CLEAR_RECYCLE_INVALID = new Action({
    id: ActionID.CLEAR_RECYCLE_INVALID,
    iconRes: $r('app.media.ic_gallery_public_delete_line'),
    textRes: $r('app.string.action_clear_recycle'),
    fillColor: $r('app.color.icon_disabled_color'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_CLEAR_RECYCLE_INVALID
  });
  public static DELETE_INVALID = new Action({
    id: ActionID.DELETE_INVALID,
    iconRes: $r('app.media.ic_gallery_public_delete_line'),
    textRes: $r('app.string.action_delete'),
    fillColor: $r('app.color.icon_disabled_color'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_DELETE_INVALID
  });
  public static RECOVER = new Action({
    id: ActionID.RECOVER,
    iconRes: $r('app.media.ic_gallery_public_undo'),
    textRes: $r('app.string.action_recover'),
    actionType: $r('app.string.action_recover'),
    componentKey: COMPONENT_KEY_RECOVER
  });
  public static RECOVER_INVALID = new Action({
    id: ActionID.RECOVER_INVALID,
    iconRes: $r('app.media.ic_gallery_public_undo'),
    textRes: $r('app.string.action_recover'),
    fillColor: $r('app.color.icon_disabled_color'),
    actionType: $r('app.string.action_recover'),
    componentKey: COMPONENT_KEY_RECOVER_INVALID
  });
  public static FAVORITE = new Action({
    id: ActionID.FAVORITE,
    iconRes: $r('app.media.ic_gallery_public_Favorite_filled'),
    textRes: $r('app.string.action_favorite'),
    fillColor: $r('sys.color.ohos_fa_activated'),
    actionType: $r('app.string.action_favorite'),
    componentKey: COMPONENT_KEY_FAVORITE
  });
  public static NOT_FAVORITE = new Action({
    id: ActionID.NOT_FAVORITE,
    iconRes: $r('app.media.ic_gallery_public_favorite_line'),
    textRes: $r('app.string.action_not_favorite'),
    actionType: $r('app.string.action_favorite'),
    componentKey: COMPONENT_KEY_NOT_FAVORITE
  });
  public static UN_SELECTED = new Action({
    id: ActionID.UN_SELECTED,
    iconRes: $r('app.media.ic_checkbox_off'),
    textRes: $r('app.string.action_unselected'),
    actionType: $r('app.string.action_selected'),
    componentKey: COMPONENT_KEY_UN_SELECTED
  });
  public static MULTISELECT = new Action({
    id: ActionID.MULTISELECT,
    iconRes: $r('app.media.ic_gallery_material_select_checkbox'),
    textRes: $r('app.string.multiselect'),
    actionType: $r('app.string.action_select_all'),
    componentKey: COMPONENT_KEY_MULTISELECT
  });
  public static MULTISELECT_INVALID = new Action({
    id: ActionID.MULTISELECT_INVALID,
    iconRes: $r('app.media.ic_gallery_material_select_checkbox'),
    textRes: $r('app.string.multiselect'),
    fillColor: $r('app.color.icon_disabled_color'),
    actionType: $r('app.string.action_select_all'),
    componentKey: COMPONENT_KEY_MULTISELECT_INVALID
  });
  public static SELECTED = new Action({
    id: ActionID.SELECTED,
    iconRes: $r('app.media.ic_gallery_public_checkbox_filled'),
    textRes: $r('app.string.action_selected'),
    isAutoTint: false,
    actionType: $r('app.string.action_selected'),
    componentKey: COMPONENT_KEY_SELECTED
  });
  public static SELECT_ALL = new Action({
    id: ActionID.SELECT_ALL,
    iconRes: $r('app.media.ic_gallery_public_select_all'),
    textRes: $r('app.string.action_select_all'),
    actionType: $r('app.string.action_select_all'),
    componentKey: COMPONENT_KEY_SELECT_ALL
  });
  public static DESELECT_ALL = new Action({
    id: ActionID.DESELECT_ALL,
    iconRes: $r('app.media.ic_gallery_public_select_all_action'),
    textRes: $r('app.string.action_deselect_all'),
    actionType: $r('app.string.action_select_all'),
    componentKey: COMPONENT_KEY_DESELECT_ALL
  });
  public static SETTING = new Action({
    id: ActionID.SETTING,
    textRes: $r('app.string.action_setting'),
    componentKey: COMPONENT_KEY_SETTING
  });
  public static NAVIGATION = new Action({
    id: ActionID.NAVIGATION,
    textRes: $r('app.string.action_navigation'),
    componentKey: COMPONENT_KEY_NAVIGATION
  });
  public static MATERIAL_SELECT = new Action({
    id: ActionID.MATERIAL_SELECT,
    iconRes: $r('app.media.ic_checkbox_off_black_bg'),
    textRes: $r('app.string.action_material_select'),
    isAutoTint: false,
    actionType: $r('app.string.action_selected'),
    componentKey: COMPONENT_KEY_MATERIAL_SELECT
  });
  public static GOTO_PHOTOS = new Action({
    id: ActionID.GOTO_PHOTOS,
    iconRes: $r('app.media.ic_goto_photos'),
    textRes: $r('app.string.action_goto_photos'),
    componentKey: COMPONENT_KEY_GOTO_PHOTOS
  });
  public static SHARE = new Action({
    id: ActionID.SHARE,
    iconRes: $r('app.media.ic_gallery_public_share'),
    textRes: $r('app.string.action_share'),
    actionType: $r('app.string.action_share'),
    componentKey: COMPONENT_KEY_SHARE
  });
  public static SHARE_INVALID = new Action({
    id: ActionID.SHARE_INVALID,
    iconRes: $r('app.media.ic_gallery_public_share'),
    fillColor: $r('app.color.icon_disabled_color'),
    textRes: $r('app.string.action_share'),
    actionType: $r('app.string.action_share'),
    componentKey: COMPONENT_KEY_SHARE_INVALID
  });
  public static EDIT = new Action({
    id: ActionID.EDIT,
    iconRes: $r('app.media.ic_gallery_public_edit'),
    textRes: $r('app.string.action_edit'),
    componentKey: COMPONENT_KEY_EDIT
  });
  public static EDIT_INVALID = new Action({
    id: ActionID.EDIT_INVALID,
    iconRes: $r('app.media.ic_gallery_public_edit'),
    textRes: $r('app.string.action_edit'),
    fillColor: $r('app.color.icon_disabled_color'),
    componentKey: COMPONENT_KEY_EDIT_INVALID
  });
  public static MORE = new Action({
    id: ActionID.MORE,
    iconRes: $r('app.media.ic_gallery_public_more'),
    textRes: $r('app.string.more_text'),
    componentKey: COMPONENT_KEY_MORE
  });
  public static NEW = new Action({
    id: ActionID.NEW,
    iconRes: $r('app.media.ic_gallery_public_new'),
    textRes: $r('app.string.action_new'),
    componentKey: COMPONENT_KEY_NEW
  });
  public static RENAME = new Action({
    id: ActionID.RENAME,
    iconRes: $r('app.media.ic_gallery_public_rename'),
    textRes: $r('app.string.action_rename'),
    actionType: $r('app.string.action_rename'),
    componentKey: COMPONENT_KEY_RENAME
  });
  public static RENAME_INVALID = new Action({
    id: ActionID.RENAME_INVALID,
    iconRes: $r('app.media.ic_gallery_public_rename'),
    textRes: $r('app.string.action_rename'),
    fillColor: $r('app.color.icon_disabled_color'),
    actionType: $r('app.string.action_rename'),
    componentKey: COMPONENT_KEY_RENAME
  });
  public static ROTATE = new Action({
    id: ActionID.ROTATE,
    iconRes: $r('app.media.ic_edit_photo_crop_rotate'),
    textRes: $r('app.string.rotate_text'),
    actionType: $r('app.string.rotate_text'),
    componentKey: COMPONENT_KEY_ROTATE
  });
  public static ADD_NOTES = new Action({
    id: ActionID.ADD_NOTES,
    iconRes: null,
    textRes: $r('app.string.add_notes'),
    componentKey: COMPONENT_KEY_ADD_NOTES
  });
  public static MOVE = new Action({
    id: ActionID.MOVE,
    textRes: $r('app.string.move_to_album'),
    componentKey: COMPONENT_KEY_MOVE
  });
  public static MOVE_INVALID = new Action({
    id: ActionID.MOVE_INVALID,
    textRes: $r('app.string.move_to_album'),
    fillColor: $r('app.color.icon_disabled_color'),
    componentKey: COMPONENT_KEY_MOVE_INVALID
  });
  public static ADD = new Action({
    id: ActionID.ADD,
    textRes: $r('app.string.add_to_album'),
    componentKey: COMPONENT_KEY_ADD
  });
  public static ADD_INVALID = new Action({
    id: ActionID.ADD_INVALID,
    textRes: $r('app.string.add_to_album'),
    fillColor: $r('app.color.icon_disabled_color'),
    componentKey: COMPONENT_KEY_ADD_INVALID
  });
  public static COPY = new Action({
    id: ActionID.COPY,
    textRes: $r('app.string.copy_to_album'),
    componentKey: COMPONENT_KEY_COPY
  });
  public static COPY_INVALID = new Action({
    id: ActionID.COPY_INVALID,
    textRes: $r('app.string.copy_to_album'),
    fillColor: $r('app.color.icon_disabled_color'),
    componentKey: COMPONENT_KEY_COPY_INVALID
  });
  public static REMOVE_FROM = new Action({
    id: ActionID.REMOVE_FROM,
    textRes: $r('app.string.remove_from'),
    componentKey: COMPONENT_KEY_REMOVE_FROM
  });
  public static REMOVE_FROM_INVALID = new Action({
    id: ActionID.REMOVE_FROM_INVALID,
    textRes: $r('app.string.remove_from'),
    fillColor: $r('app.color.icon_disabled_color'),
    componentKey: COMPONENT_KEY_REMOVE_FROM_INVALID
  });
  public static NAVIGATION_ALBUMS = new Action({
    id: ActionID.NAVIGATION_ALBUMS,
    iconRes: $r('app.media.ic_navigation_albums_line'),
    textRes: $r('app.string.rotate_text'),
    fillColor: $r('sys.color.ohos_id_color_primary'),
    componentKey: COMPONENT_KEY_NAVIGATION_ALBUMS
  });
  public static DOWNLOAD = new Action({
    id: ActionID.DOWNLOAD,
    iconRes: $r('app.media.download'),
    textRes: $r('app.string.save_to_local'),
    componentKey: COMPONENT_KEY_DOWNLOAD
  });
  public static DOWNLOAD_INVALID = new Action({
    id: ActionID.DOWNLOAD_INVALID,
    iconRes: $r('app.media.download'),
    textRes: $r('app.string.save_to_local'),
    fillColor: $r('app.color.icon_disabled_color'),
    componentKey: COMPONENT_KEY_DOWNLOAD_INVALID
  });
  public static ICON_DEFAULT_COLOR: Resource = $r('app.color.icon_default_color');
  public static ICON_DEFAULT_COLOR_CONTRARY: Resource = $r('app.color.icon_default_color_contrary');
  readonly actionID: number;
  readonly textRes: Resource;
  readonly iconRes: Resource = $r('app.media.ic_gallery_public_more');
  readonly isAutoTint: boolean = true;
  readonly fillColor: Resource = $r('app.color.icon_default_color');
  readonly actionType: Resource; // It is used to distinguish whether it is the same type of action
  readonly componentKey: string;

  constructor(options: ActionOptions) {
    this.actionID = options.id;
    this.textRes = options.textRes;
    this.componentKey = options.componentKey;
    if (options.iconRes != undefined) {
      this.iconRes = options.iconRes;
    }
    if (options.isAutoTint != undefined) {
      this.isAutoTint = options.isAutoTint;
    }
    if (options.fillColor != undefined) {
      this.fillColor = options.fillColor;
    }
    if (options.actionType != undefined) {
      this.actionType = options.actionType;
    }
  }

  public equals(action: Action): boolean {
    return (action) ? (action.actionID === this.actionID) : false;
  }
}
