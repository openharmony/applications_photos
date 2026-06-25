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
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { SubMenuPicker as SortSelectMenu, SortSelectMenuParamType } from '../../view/albumGridSort'
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import lazy { AlbumGridSortHelper } from '../../model/AlbumGridSortHelper';

export enum ActionID {
  NONE,
  OK,
  OK_DISABLE,
  CANCEL,
  BACK,
  PICKER_CLOSE,
  INFO,
  INFO_SELECTED,
  BOUNCE_PLAY,
  BOUNCE_PLAY_INVALID,
  MICRO_MOTION,
  MICRO_MOTION_INVALID,
  INFO_INVALID,
  DELETE,
  DELETE_ALBUM,
  ALBUM_GRID_SORT,
  DELETE_ALBUM_WITHOUT_DIALOG,
  DELETE_ALBUM_INVALID,
  LONG_PRESS_DELETE,
  DELETE_RECYCLE,
  CLEAR_RECYCLE,
  DELETE_INVALID,
  RECOVER,
  RECOVER_INVALID,
  FULL_RATIO,
  FAVORITE,
  NOT_FAVORITE,
  FAVORITE_INVALID,
  UN_SELECTED,
  SELECTED,
  MULTISELECT,
  MULTISELECT_INVALID,
  SELECT_ALL,
  DESELECT_ALL,
  SETTING,
  MATERIAL_SELECT,
  GOTO_PHOTOS,
  SHARE,
  SHARE_INVALID,
  COLLAGE,
  COLLAGE_INVALID,
  EDIT,
  EDIT_INVALID,
  MORE,
  MORE_INVALID,
  NEW,
  NEW_WITHOUT_DIALOG,
  ADD_PHOTO,
  RENAME,
  RENAME_INVALID,
  RENAME_ALBUM,
  RENAME_ALBUM_INVALID,
  ADD,
  NEW_ALBUM,
  ADD_INVALID,
  MOVE,
  MOVE_INVALID,
  REMOVE_FROM,
  REMOVE_FROM_INVALID,
  NAVIGATION_ALBUMS,
  DOWNLOAD,
  DOWNLOAD_INVALID,
  CLEAR_RECYCLE_INVALID,
  GALLERY_SETTINGS,
  ABOUT_GALLERY,
  TIMELINE_ACTION_MORE,
  SEARCH,
  PHOTO_SEARCH,
  SOUND_FILLED,
  SOUND_OFF_FILLED,
  VIDEO_PAUSE,
  VIDEO_PLAY,
  PHONE_ROTATE,
  PHONE_ROTATE_INVALID,
  LOCK,
  LOCK_TIPS_LIST,
  TO_SET_UP,
  LOCK_TIPS_PASSWORD,
  NOT_PROMPT_AGAIN,
  PRINT,
  ALUBM_DISPLAY,
  GRID_DISPLAY,
  ACTION_REMOVE,
  MERGE_CHECK,
  MERGE,
  MERGE_INVALID,
  REMOVE_FROM_LARGE,
  COMPARE,
  COMPARE_INVALID,
  SAVE,
  COMPLETE,
  COMPLETE_DISABLED,
  PICKER_SELECT,
  PICKER_UNSELECT,
  EXTENDED_SERVICES,
  ALBUM_SET_NEW,
  BURST_PHOTOS,
  BURST_ABLE_SAVE,
  BURST_DISABLE_SAVE,
  SET_WALLPAPER,
  SET_WALLPAPER_INVALID,
  PASTE_FROM_PASTEBOARD,
  SLIDE_SHOW,
  CLOUD_ENHANCE_LOOP_PICTURE_INVALID,
  CLOUD_ENHANCE_COMPARE_INVALID,
  FAVORITE_INV,
  NOT_FAVORITE_INVALID,
  SELECTED_INVALID,
  MULTISELECT_INV,
  SELECT_ALL_INVALID,
  DESELECT_ALL_INVALID,
  MATERIAL_SELECT_INVALID,
  SOUND_FILLED_INVALID,
  SOUND_OFF_FILLED_INVALID,
  VIDEO_PAUSE_INVALID,
  VIDEO_PLAY_INVALID,
  BURST_PHOTOS_INVALID,
  ACTION_MORE_INVALID,
  PROTAGONIST_PLANET_DISPLAY,
  PLANET_SHOW_ALL,
  PROTAGONIST_RESTORE,
  SIDEBAR_DRAWER,
  EDIT_GROUP,
  DELETE_GROUP,
  DELETE_GROUP_FROM_MENU,
  REMOVE_FROM_GROUP,
  REMOVE_INVALID,
  // XXXstart
  FLASH_CAPTURE,
  CLOSE_FLASH_CAPTURE,
  VIRTUAL_APERTURE,
  CLOSE_VIRTUAL_APERTURE,
  DYNAMIC_PANNING,
  OVERLAY_EFFECT,
  CLOSE_EFFECT
  // XXXend
}

const COMPONENT_KEY_OK: string = 'OK';
const COMPONENT_KEY_OK_DISABLE: string = 'OK';
const COMPONENT_KEY_CANCEL: string = 'Cancel';
const COMPONENT_KEY_BACK: string = 'Back';
const COMPONENT_KEY_PICKER_CLOSE: string = 'PickerClose';
const COMPONENT_KEY_INFO: string = 'Info';
const COMPONENT_KEY_INFO_SELECTED: string = 'Info';
const COMPONENT_KEY_INFO_INVALID: string = 'Info';
const COMPONENT_KEY_BOUNCE_PLAY: string = 'BouncePlay';
const COMPONENT_KEY_BOUNCE_PLAY_INVALID: string = 'BouncePlayInvalid';
const COMPONENT_KEY_MICRO_MOTION: string = 'MicroMotion';
const COMPONENT_KEY_MICRO_MOTION_INVALID: string = 'MicroMotionInvalid';
const COMPONENT_KEY_CLOUD_ENHANCE_LOOP_PICTURE: string = 'CloudEnhanceLoopPicture';
const COMPONENT_KEY_CLOUD_ENHANCE_COMPARE_PICTURE: string = 'CloudEnhanceComparePicture';
const COMPONENT_KEY_DELETE: string = 'Delete';
const COMPONENT_KEY_RECENTLY_DELETE: string = 'RECENTLY_DELETE';
const COMPONENT_KEY_DELETE_LONG_PRESS: string = 'HoldPositionDelete';
const COMPONENT_KEY_DELETE_RECYCLE: string = 'DeleteRecycle';
const COMPONENT_KEY_CLEAR_RECYCLE: string = 'ClearRecycle';
const COMPONENT_KEY_DELETE_INVALID: string = 'Delete';
const COMPONENT_KEY_DELETE_ALBUM: string = 'DeleteAlbum';
const COMPONENT_KEY_RECOVER: string = 'Recover';
const COMPONENT_KEY_RECOVER_INVALID: string = 'Recover';
const COMPONENT_KEY_DELETE_ALBUM_GRID_SORT: string = 'AlbumGridSort';
const COMPONENT_KEY_DELETE_ALBUM_INVALID: string = 'DeleteAlbum';
const COMPONENT_KEY_SIDEBAR_DRAWER: string = 'SidebarDrawer';
const COMPONENT_KEY_FULL_RATIO: string = 'FullRatio';
const COMPONENT_KEY_FAVORITE: string = 'Favor';
const COMPONENT_KEY_NOT_FAVORITE: string = 'Favor';
const COMPONENT_KEY_FAVORITE_INVALID: string = 'Favor';
const COMPONENT_KEY_UN_SELECTED: string = 'Selected';
const COMPONENT_KEY_SELECTED: string = 'Selected';
const COMPONENT_KEY_MULTISELECT: string = 'MultiSelected';
const COMPONENT_KEY_MULTISELECT_INVALID: string = 'MultiSelected';
const COMPONENT_KEY_SELECT_ALL: string = 'SelectAll';
const COMPONENT_KEY_DESELECT_ALL: string = 'DeSelectAll';
const COMPONENT_KEY_SETTING: string = 'Setting';
const COMPONENT_KEY_MATERIAL_SELECT: string = 'MaterialSelect';
const COMPONENT_KEY_GOTO_PHOTOS: string = 'GotoPhotos';
const COMPONENT_KEY_EDIT: string = 'Edit';
const COMPONENT_KEY_EDIT_INVALID: string = 'Edit';
const COMPONENT_KEY_MORE: string = 'More';
const COMPONENT_KEY_MORE_INVALID: string = 'More';
const COMPONENT_KEY_TIMELINE_ACTION_MORE: string = 'TimelineActionMore';
const COMPONENT_KEY_NEW: string = 'New';
const COMPONENT_KEY_ADD_PHOTO: string = 'AddPhoto';
const COMPONENT_KEY_MOVE_PHOTO: string = 'MovePhoto';
const COMPONENT_KEY_RENAME: string = 'Rename';
const COMPONENT_KEY_RENAME_ALBUM: string = 'RenameAlbum';
const COMPONENT_KEY_RENAME_ALBUM_INVALID: string = 'RenameAlbum';
const COMPONENT_KEY_COVER: string = 'Cover';
const COMPONENT_KEY_COMPLETE: string = 'Complete';
const COMPONENT_KEY_COMPLETE_DISABLED: string = 'CompleteDisabled';
const COMPONENT_KEY_ADD: string = 'Add';
const COMPONENT_KEY_NEW_ALBUM: string = 'NewAlbum';
const COMPONENT_KEY_ADD_INVALID: string = 'Add';
const COMPONENT_KEY_MOVE: string = 'Move';
const COMPONENT_KEY_MOVE_INVALID: string = 'Move';
const COMPONENT_KEY_PRINT: string = 'Print';
const COMPONENT_KEY_PHOTO_SEARCH: string = 'Search';
const COMPONENT_KEY_REMOVE_FROM: string = 'RemoveFrom';
const COMPONENT_KEY_REMOVE_FROM_INVALID: string = 'RemoveFrom';
const COMPONENT_KEY_NAVIGATION_ALBUMS: string = 'NavigationAlbums';
const COMPONENT_KEY_DOWNLOAD: string = 'Download';
const COMPONENT_KEY_DOWNLOAD_INVALID: string = 'Download';
const COMPONENT_KEY_CLEAR_RECYCLE_INVALID: string = 'ClearRecycle';
const COMPONENT_KEY_GALLERY_SETTINGS: string = 'GallerySettings';
const COMPONENT_KEY_ABOUT_GALLERY: string = 'AboutGallery';
const COMPONENT_KEY_SEARCH: string = 'Search';
const COMPONENT_KEY_PICKER_SELECT: string = 'PickerSelect';
const COMPONENT_KEY_PICKER_UNSELECT: string = 'PickerUnSelect';
const SOUND_FILLED: string = 'soundFilled';
const SOUND_OFF_FILLED: string = 'sound_off_filled';
const VIDEO_PAUSE: string = 'videoPause';
const VIDEO_PLAY: string = 'videoPlay';
const PHONE_ROTATE: string = 'phoneRotate';
const PHONE_ROTATE_INVALID: string = 'phoneRotateInvalid';
const DISPLAY_BY_ALBUM: string = 'albumDisplay';
const DISPLAY_BY_PHOTO_AND_VIDEO: string = 'gridDisplay';
const COMPONENT_KEY_MERGE_CHECK: string = 'MergeCheck';
const COMPONENT_KEY_ACTION_REMOVE: string = 'Action_Remove';
const COMPONENT_KEY_MERGE: string = 'merge';
const COMPONENT_KEY_MERGE_INVALID: string = 'mergeInvalid';
const COMPONENT_KEY_REMOVE_FROM_LARGE: string = 'RemoveFrom';
const COMPONENT_KEY_EDIT_GROUP: string = 'editGroup';
const COMPONENT_KEY_DELETE_GROUP: string = 'deleteGroup';
const COMPONENT_KEY_DELETE_GROUP_FROM_MENU: string = 'deleteGroup';
const COMPONENT_KEY_REMOVE_FROM_GROUP: string = 'removeFromGroup';
const COMPONENT_KEY_ACTION_REMOVE_INVALID: string = 'Action_Remove';

const COMPONENT_KEY_COMPARE: string = 'compare';
const COMPONENT_KEY_COMPARE_INVALID: string = 'compare';
const COMPONENT_KEY_SAVE: string = 'Save';
const COMPONENT_KEY_ALBUM_SET_NEW: string = 'createAlbumSet';

const COMPONENT_KEY_BURST_PHOTOS: string = 'burst_photos';
const COMPONENT_KEY_BURST_ABLE_SAVE: string = 'burst_able_save';
const COMPONENT_KEY_BURST_DISABLE_SAVE: string = 'burst_disable_save';
const COMPONENT_KEY_SET_WALLPAPER: string = 'setWallpaper';
const COMPONENT_KEY_SET_WALLPAPER_INVALID: string = 'setWallpaperInvalid';
const COMPONENT_KEY_SLIDE_SHOW: string = 'Slideshow';

// XXXstart
const COMPONENT_KEY_FLASH_CAPTURE: string = 'SNAPSHOT';
const COMPONENT_KEY_CLOSE_FLASH_CAPTURE: string = 'CLOSE_SNAPSHOT';
const COMPONENT_KEY_VIRTUAL_APERTURE: string = 'VIRTUAL_APERTURE';
const COMPONENT_KEY_CLOSE_VIRTUAL_APERTURE: string = 'CLOSE_VIRTUAL_APERTURE';
const COMPONENT_KEY_DYNAMIC_PANNING: string = 'DYNAMIC_PANNING';
const COMPONENT_KEY_OVERLAY_EFFECT: string = 'OVERLAY_EFFECT';
const COMPONENT_KEY_CLOSE_EFFECT: string = 'CLOSE_EFFECT';
// XXXend

interface ActionOptions {
  id: number;
  textRes?: Resource|string;
  iconRes?: Resource;
  isAutoTint?: boolean;
  fillColor?: Resource;
  actionType?: Resource;
  componentKey?: string;
  isInvalid?: boolean;
  shortKey?: string;
  hasSubMenu?: boolean;
  subMenuKey?: string;
}

export class Action {
  public static readonly SEARCH_ICON = $r('sys.symbol.magnifyingglass');
  public static readonly MORE_ICON = $r('sys.symbol.dot_grid_2x2');
  public static readonly BACK_ICON = $r('sys.symbol.chevron_backward');
  public static readonly OK_ICON = $r('sys.symbol.checkmark');
  public static readonly SHARE_ICON = $r('sys.symbol.share');
  public static readonly CANCEL_ICON = $r('sys.symbol.xmark');
  public static readonly RESTORE_ICON = $r('sys.symbol.arrow_counterclockwise_clock');
  public static readonly MUTE_ICON = $r('sys.symbol.speaker_slash');
  public static readonly UNMUTE_ICON = $r('sys.symbol.speaker_wave_3');
  public static readonly REMOVE_ICON = $r('sys.symbol.trash')
  public static readonly NONE = new Action({
    id: ActionID.NONE,
    iconRes: undefined,
    textRes: undefined,
  });
  public static readonly OK = new Action({
    id: ActionID.OK,
    iconRes: $r('sys.symbol.checkmark'),
    textRes: $r('app.string.action_ok'),
    componentKey: COMPONENT_KEY_OK,
  });
  public static readonly OK_DISABLE = new Action({
    id: ActionID.OK_DISABLE,
    iconRes: $r('app.media.ic_gallery_public_ok'),
    textRes: $r('app.string.action_ok'),
    fillColor: $r('app.color.icon_disabled_color'),
    componentKey: COMPONENT_KEY_OK_DISABLE,
    isInvalid: true,
  });
  public static readonly CANCEL = new Action({
    id: ActionID.CANCEL,
    iconRes: $r('sys.symbol.xmark'),
    textRes: $r('app.string.action_cancel'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_CANCEL,
  });
  public static readonly BACK = new Action({
    id: ActionID.BACK,
    iconRes: Action.BACK_ICON,
    textRes: $r('app.string.action_back'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_BACK,
  });
  public static readonly PICKER_CLOSE = new Action({
    id: ActionID.PICKER_CLOSE,
    iconRes: Action.CANCEL_ICON,
    textRes: undefined,
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_PICKER_CLOSE,
  });
  public static readonly INFO = new Action({
    id: ActionID.INFO,
    iconRes: $r('sys.symbol.info_circle'),
    textRes: $r('app.string.details'),
    componentKey: COMPONENT_KEY_INFO,
  });
  public static readonly INFO_SELECTED = new Action({
    id: ActionID.INFO_SELECTED,
    iconRes: $r('sys.symbol.info_circle'),
    textRes: $r('app.string.details'),
    fillColor: $r('sys.color.icon_emphasize'),
    componentKey: COMPONENT_KEY_INFO_SELECTED,
  });
  // 来回播放
  public static readonly BOUNCE_PLAY = new Action({
    id: ActionID.BOUNCE_PLAY,
    iconRes: $r('sys.symbol.playing_back_and_forth'),
    textRes: $r('app.string.moving_photo_bounce_play'),
    componentKey: COMPONENT_KEY_BOUNCE_PLAY,
  });
  public static readonly BOUNCE_PLAY_INVALID = new Action({
    id: ActionID.BOUNCE_PLAY_INVALID,
    iconRes: $r('sys.symbol.playing_back_and_forth'),
    textRes: $r('app.string.moving_photo_bounce_play'),
    componentKey: COMPONENT_KEY_BOUNCE_PLAY_INVALID,
    isInvalid: true,
  });
  // 微动瞬间
  public static readonly MICRO_MOTION = new Action({
    id: ActionID.MICRO_MOTION,
    iconRes: $r('sys.symbol.cinemagraph'),
    textRes: $r('app.string.moving_photo_micro_motion'),
    componentKey: COMPONENT_KEY_MICRO_MOTION,
  });
  public static readonly MICRO_MOTION_INVALID = new Action({
    id: ActionID.MICRO_MOTION_INVALID,
    iconRes: $r('sys.symbol.cinemagraph'),
    textRes: $r('app.string.moving_photo_micro_motion'),
    componentKey: COMPONENT_KEY_MICRO_MOTION_INVALID,
    isInvalid: true,
  });
  // XXXstart
  // 动感摇拍效果
  public static readonly DYNAMIC_PANNING = new Action({
    id: ActionID.DYNAMIC_PANNING,
    iconRes: $r('app.media.dynamic_panning'),
    textRes: $r('app.string.dynamic_panning'),
    componentKey: COMPONENT_KEY_DYNAMIC_PANNING,
  });
  // 闪拍效果
  public static readonly FLASH_CAPTURE = new Action({
    id: ActionID.FLASH_CAPTURE,
    iconRes: $r('sys.symbol.snapshot'),
    textRes: $r('app.string.flash_capture'),
    componentKey: COMPONENT_KEY_FLASH_CAPTURE,
  });
  // 关闭闪拍效果
  public static readonly CLOSE_FLASH_CAPTURE = new Action({
    id: ActionID.CLOSE_FLASH_CAPTURE,
    iconRes: $r('app.media.close_flash_capture'),
    textRes: $r('app.string.close_flash_capture'),
    componentKey: COMPONENT_KEY_CLOSE_FLASH_CAPTURE,
    isInvalid: true,
  });
  // 虚拟光圈
  public static VIRTUAL_APERTURE = new Action({
    id: ActionID.VIRTUAL_APERTURE,
    iconRes: $r('sys.symbol.virtual_background'),
    textRes: $r('app.string.virtual_aperture'),
    componentKey: COMPONENT_KEY_VIRTUAL_APERTURE,
  });
  // 关闭虚拟光圈
  public static CLOSE_VIRTUAL_APERTURE = new Action({
    id: ActionID.CLOSE_VIRTUAL_APERTURE,
    iconRes: $r('app.media.close_virtual_aperture'),
    textRes: $r('app.string.close_virtual_aperture'),
    componentKey: COMPONENT_KEY_CLOSE_VIRTUAL_APERTURE,
    isInvalid: true,
  });
  public static OVERLAY_EFFECT = new Action({
    id: ActionID.OVERLAY_EFFECT,
    iconRes: $r('sys.symbol.satellite_map'),
    textRes: $r('app.string.overlay_effect'),
    componentKey: COMPONENT_KEY_OVERLAY_EFFECT,
  });
  public static CLOSE_EFFECT = new Action({
    id: ActionID.CLOSE_EFFECT,
    iconRes: $r('app.media.close_effect'),
    textRes: $r('app.string.close_effect'),
    componentKey: COMPONENT_KEY_CLOSE_EFFECT,
    isInvalid: true,
  });
  // XXXend
  //人像合并，移除
  public static readonly MERGE = new Action({
    id: ActionID.MERGE,
    iconRes: $r('sys.symbol.person_2'),
    textRes: $r('app.string.merge'),
    componentKey: COMPONENT_KEY_MERGE,
  });
  public static readonly MERGE_INVALID = new Action({
    id: ActionID.MERGE_INVALID,
    iconRes: $r('sys.symbol.person_2'),
    textRes: $r('app.string.merge'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_MERGE_INVALID,
    isInvalid: true,
  });
  public static readonly INFO_INVALID = new Action({
    id: ActionID.INFO_INVALID,
    iconRes: $r('sys.symbol.info_circle'),
    textRes: $r('app.string.details'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_INFO_INVALID,
    isInvalid: true,
  });
  public static readonly DELETE = new Action({
    id: ActionID.DELETE,
    iconRes: DeviceInfo.isTv() ? $r('sys.symbol.trash_fill') : $r('sys.symbol.trash'),
    textRes: $r('app.string.action_delete'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_DELETE,
    shortKey: 'Ctrl+D',
  });
  // 大图播放幻灯片
  public static readonly SLIDE_SHOW = new Action({
    id: ActionID.SLIDE_SHOW,
    textRes: $r('app.string.action_slide_show'),
    actionType: $r('app.string.action_slide_show'),
    componentKey: COMPONENT_KEY_SLIDE_SHOW,
  });
  public static readonly RECENTLY_DELETE = new Action({
    id: ActionID.DELETE,
    iconRes: $r('sys.symbol.trash'),
    textRes: $r('app.string.action_delete'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_RECENTLY_DELETE,
    shortKey: 'Ctrl+D',
  });
  public static readonly DELETE_ALBUM = new Action({
    id: ActionID.DELETE_ALBUM,
    iconRes: $r('sys.symbol.trash'),
    textRes: $r('app.string.action_delete_album'),
    actionType: $r('app.string.action_delete_album'),
    componentKey: COMPONENT_KEY_DELETE_ALBUM,
    shortKey: 'Ctrl+D',
  });
  public static readonly ALBUM_GRID_SORT = new Action({
    id: ActionID.ALBUM_GRID_SORT,
    textRes: $r('app.string.album_photo_sort'),
    actionType: $r('app.string.album_photo_sort'),
    componentKey: COMPONENT_KEY_DELETE_ALBUM_GRID_SORT,
    hasSubMenu: true,
    subMenuKey: 'SortSelectMenu',
  });
  public static DELETE_ALBUM_WITHOUT_DIALOG = new Action({
    id: ActionID.DELETE_ALBUM_WITHOUT_DIALOG,
    iconRes: $r('app.media.ic_gallery_public_delete_line'),
    textRes: $r('app.string.action_delete_album'),
    actionType: $r('app.string.action_delete_album'),
    componentKey: COMPONENT_KEY_DELETE_ALBUM,
  });
  public static readonly DELETE_ALBUM_INVALID = new Action({
    id: ActionID.DELETE_ALBUM_INVALID,
    iconRes: $r('sys.symbol.trash'),
    textRes: $r('app.string.action_delete_album'),
    actionType: $r('app.string.action_delete_album'),
    componentKey: COMPONENT_KEY_DELETE_ALBUM_INVALID,
    isInvalid: true,
  });
  public static readonly LONG_PRESS_DELETE = new Action({
    id: ActionID.LONG_PRESS_DELETE,
    iconRes: $r('sys.symbol.trash'),
    textRes: $r('app.string.action_delete'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_DELETE_LONG_PRESS,
  });
  public static readonly RECENTLY_LONG_PRESS_DELETE = new Action({
    id: ActionID.LONG_PRESS_DELETE,
    iconRes: $r('sys.symbol.trash'),
    textRes: $r('app.string.action_delete'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_RECENTLY_DELETE,
  });
  public static readonly DELETE_RECYCLE = new Action({
    id: ActionID.DELETE_RECYCLE,
    iconRes: $r('sys.symbol.trash'),
    textRes: $r('app.string.action_delete'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_DELETE_RECYCLE,
  });
  public static readonly CLEAR_RECYCLE = new Action({
    id: ActionID.CLEAR_RECYCLE,
    iconRes: DeviceInfo.isTv() ? $r('sys.symbol.trash_fill') : $r('sys.symbol.trash'),
    textRes: $r('app.string.action_clear_recycle'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_CLEAR_RECYCLE,
  });
  public static readonly CLEAR_RECYCLE_INVALID = new Action({
    id: ActionID.CLEAR_RECYCLE_INVALID,
    iconRes: $r('sys.symbol.trash'),
    textRes: $r('app.string.action_clear_recycle'),
    fillColor: $r('sys.color.icon_primary'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_CLEAR_RECYCLE_INVALID,
    isInvalid: true,
  });
  public static readonly SEARCH_INVALID = new Action({
    id: ActionID.SEARCH,
    iconRes: Action.SEARCH_ICON,
    textRes: $r('app.string.action_search'),
    fillColor: $r('app.color.icon_disabled_color'),
    actionType: $r('app.string.action_search'),
    componentKey: COMPONENT_KEY_SEARCH,
    isInvalid: true,
  });
  public static readonly SEARCH_VALID = new Action({
    id: ActionID.PHOTO_SEARCH,
    iconRes: Action.SEARCH_ICON,
    textRes: $r('app.string.action_search'),
    actionType: $r('app.string.action_search'),
    componentKey: COMPONENT_KEY_PHOTO_SEARCH,
  });
  public static readonly PHOTO_SEARCH = DeviceInfo.isEmulator() ? Action.SEARCH_INVALID : Action.SEARCH_VALID;
  public static readonly DELETE_INVALID = new Action({
    id: ActionID.DELETE_INVALID,
    iconRes: DeviceInfo.isTv() ? $r('sys.symbol.trash_fill') : $r('sys.symbol.trash'),
    textRes: $r('app.string.action_delete'),
    fillColor: $r('sys.color.icon_primary'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_DELETE_INVALID,
    isInvalid: true,
  });
  public static readonly RECOVER = new Action({
    id: ActionID.RECOVER,
    iconRes: $r('sys.symbol.arrow_counterclockwise'),
    textRes: $r('app.string.action_recover'),
    actionType: $r('app.string.action_recover'),
    componentKey: COMPONENT_KEY_RECOVER,
  });
  public static readonly SIDEBAR_DRAWER = new Action({
    id: ActionID.SIDEBAR_DRAWER,
    iconRes: $r('sys.symbol.open_sidebar'),
    textRes: $r('app.string.expand'),
    componentKey: COMPONENT_KEY_SIDEBAR_DRAWER,
  });
  public static readonly FULL_RATIO = new Action({
    id: ActionID.FULL_RATIO,
    componentKey: COMPONENT_KEY_FULL_RATIO,
  });
  public static readonly FAVORITE = new Action({
    id: ActionID.FAVORITE,
    iconRes: $r('sys.symbol.heart_fill'),
    textRes: $r('app.string.action_favorite'),
    fillColor: $r('sys.color.icon_emphasize'),
    actionType: $r('app.string.action_favorite'),
    componentKey: COMPONENT_KEY_FAVORITE,
  });
  public static readonly NOT_FAVORITE = new Action({
    id: ActionID.NOT_FAVORITE,
    iconRes: $r('sys.symbol.heart'),
    textRes: $r('app.string.action_not_favorite'),
    actionType: $r('app.string.action_favorite'),
    componentKey: COMPONENT_KEY_NOT_FAVORITE,
  });
  public static readonly FAVORITE_INVALID = new Action({
    id: ActionID.FAVORITE_INVALID,
    iconRes: $r('sys.symbol.heart'),
    textRes: $r('app.string.action_not_favorite'),
    fillColor: $r('sys.color.icon_primary'),
    actionType: $r('app.string.action_favorite'),
    componentKey: COMPONENT_KEY_FAVORITE_INVALID,
    isInvalid: true,
  });
  public static readonly FAVORITE_INV = new Action({
    id: ActionID.FAVORITE_INV,
    iconRes: $r('sys.symbol.heart_fill'),
    textRes: $r('app.string.action_favorite'),
    fillColor: $r('sys.color.icon_emphasize'),
    actionType: $r('app.string.action_favorite'),
    componentKey: COMPONENT_KEY_FAVORITE,
    isInvalid: true,
  });
  public static readonly NOT_FAVORITE_INVALID = new Action({
    id: ActionID.NOT_FAVORITE_INVALID,
    iconRes: $r('sys.symbol.heart'),
    textRes: $r('app.string.action_not_favorite'),
    actionType: $r('app.string.action_favorite'),
    componentKey: COMPONENT_KEY_FAVORITE_INVALID,
    isInvalid: true,
  });
  public static readonly UN_SELECTED = new Action({
    id: ActionID.UN_SELECTED,
    iconRes: $r('app.media.ic_checkbox_off'),
    textRes: $r('app.string.action_unselected'),
    actionType: $r('app.string.action_selected'),
    componentKey: COMPONENT_KEY_UN_SELECTED,
  });
  public static readonly MULTISELECT = new Action({
    id: ActionID.MULTISELECT,
    iconRes: DeviceInfo.isTv() ? $r('sys.symbol.checkmark_square_fill') : $r('sys.symbol.checkmark_square'),
    textRes: $r('app.string.multiselect'),
    actionType: $r('app.string.action_select_all'),
    componentKey: COMPONENT_KEY_MULTISELECT,
  });
  public static readonly MULTISELECT_INV = new Action({
    id: ActionID.MULTISELECT_INV,
    textRes: $r('app.string.multiselect'),
    fillColor: $r('sys.color.icon_primary'),
    actionType: $r('app.string.action_select_all'),
    componentKey: COMPONENT_KEY_MULTISELECT,
    isInvalid: true,
  });
  public static readonly MULTISELECT_INVALID = new Action({
    id: ActionID.MULTISELECT_INVALID,
    iconRes: DeviceInfo.isTv() ? $r('sys.symbol.checkmark_square_fill') : $r('sys.symbol.checkmark_square'),
    textRes: $r('app.string.multiselect'),
    fillColor: $r('sys.color.icon_primary'),
    actionType: $r('app.string.action_select_all'),
    componentKey: COMPONENT_KEY_MULTISELECT_INVALID,
    isInvalid: true,
  });
  public static readonly SELECTED = new Action({
    id: ActionID.SELECTED,
    iconRes: $r('sys.symbol.checkmark_square'),
    textRes: $r('app.string.action_selected'),
    isAutoTint: false,
    actionType: $r('app.string.action_selected'),
    componentKey: COMPONENT_KEY_SELECTED,
  });
  public static readonly SELECTED_INVALID = new Action({
    id: ActionID.SELECTED_INVALID,
    iconRes: $r('sys.symbol.checkmark_square'),
    textRes: $r('app.string.action_selected'),
    isAutoTint: false,
    fillColor: $r('sys.color.icon_primary'),
    actionType: $r('app.string.action_selected'),
    componentKey: COMPONENT_KEY_SELECTED,
    isInvalid: true,
  });
  public static readonly SELECT_ALL = new Action({
    id: ActionID.SELECT_ALL,
    iconRes: DeviceInfo.isTv() ? $r('sys.symbol.checkmark_square_on_square_fill') :
    $r('sys.symbol.checkmark_square_on_square'),
    textRes: $r('app.string.action_select_all'),
    actionType: $r('app.string.action_select_all'),
    componentKey: COMPONENT_KEY_SELECT_ALL,
    shortKey: 'Ctrl+A',
  });
  public static readonly SELECT_ALL_INVALID = new Action({
    id: ActionID.SELECT_ALL_INVALID,
    iconRes: DeviceInfo.isTv() ? $r('sys.symbol.checkmark_square_on_square_fill') :
    $r('sys.symbol.checkmark_square_on_square'),
    textRes: $r('app.string.action_select_all'),
    fillColor: $r('sys.color.icon_primary'),
    actionType: $r('app.string.action_select_all'),
    componentKey: COMPONENT_KEY_SELECT_ALL,
    isInvalid: true,
  });
  public static readonly DESELECT_ALL = new Action({
    id: ActionID.DESELECT_ALL,
    iconRes: $r('sys.symbol.checkmark_square_on_square_fill'),
    textRes: $r('app.string.action_deselect_all'),
    actionType: $r('app.string.action_select_all'),
    componentKey: COMPONENT_KEY_DESELECT_ALL,
  });
  public static readonly DESELECT_ALL_INVALID = new Action({
    id: ActionID.DESELECT_ALL_INVALID,
    iconRes: $r('sys.symbol.checkmark_square_on_square_fill'),
    textRes: $r('app.string.action_deselect_all'),
    fillColor: $r('sys.color.icon_primary'),
    actionType: $r('app.string.action_select_all'),
    componentKey: COMPONENT_KEY_DESELECT_ALL,
    isInvalid: true,
  });
  public static readonly SETTING = new Action({
    id: ActionID.SETTING,
    textRes: $r('app.string.action_setting'),
    componentKey: COMPONENT_KEY_SETTING,
  });
  public static readonly MATERIAL_SELECT = new Action({
    id: ActionID.MATERIAL_SELECT,
    iconRes: $r('app.media.ic_checkbox_off_black_bg'),
    textRes: $r('app.string.action_material_select'),
    isAutoTint: false,
    actionType: $r('app.string.action_selected'),
    componentKey: COMPONENT_KEY_MATERIAL_SELECT,
  });
  public static readonly MATERIAL_SELECT_INVALID = new Action({
    id: ActionID.MATERIAL_SELECT_INVALID,
    iconRes: $r('app.media.ic_checkbox_off_black_bg'),
    textRes: $r('app.string.action_material_select'),
    fillColor: $r('sys.color.icon_primary'),
    isAutoTint: false,
    actionType: $r('app.string.action_selected'),
    componentKey: COMPONENT_KEY_MATERIAL_SELECT,
    isInvalid: true,
  });
  public static readonly GOTO_PHOTOS = new Action({
    id: ActionID.GOTO_PHOTOS,
    iconRes: $r('sys.symbol.picture'),
    textRes: $r('app.string.action_goto_photos'),
    componentKey: COMPONENT_KEY_GOTO_PHOTOS,
  });
  public static readonly EDIT = !DeviceInfo.isEmulator() ?
    new Action({
      id: ActionID.EDIT,
      iconRes: $r('sys.symbol.square_and_pencil'),
      textRes: $r('app.string.action_edit'),
      componentKey: COMPONENT_KEY_EDIT,
    }) : new Action({
      id: ActionID.EDIT_INVALID,
      iconRes: $r('sys.symbol.square_and_pencil'),
      textRes: $r('app.string.action_edit'),
      fillColor: $r('sys.color.icon_primary'),
      componentKey: COMPONENT_KEY_EDIT_INVALID,
      isInvalid: true,
    });
  public static readonly EDIT_INVALID = new Action({
    id: ActionID.EDIT_INVALID,
    iconRes: $r('sys.symbol.square_and_pencil'),
    textRes: $r('app.string.action_edit'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_EDIT_INVALID,
    isInvalid: true,
  });
  public static readonly MORE = new Action({
    id: ActionID.MORE,
    iconRes: Action.MORE_ICON,
    textRes: $r('app.string.more_text'),
    componentKey: COMPONENT_KEY_MORE,
  });
  public static readonly MORE_INVALID = new Action({
    id: ActionID.MORE_INVALID,
    iconRes: Action.MORE_ICON,
    textRes: $r('app.string.more_text'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_MORE_INVALID,
    isInvalid: true,
  });
  public static readonly ACTION_MORE = new Action({
    id: ActionID.TIMELINE_ACTION_MORE,
    iconRes: DeviceInfo.isTv() ? $r('sys.symbol.gearshape_fill') : Action.MORE_ICON,
    textRes: $r('app.string.more_text'),
    componentKey: COMPONENT_KEY_TIMELINE_ACTION_MORE,
  });
  public static readonly ACTION_MORE_INVALID = new Action({
    id: ActionID.ACTION_MORE_INVALID,
    iconRes: DeviceInfo.isTv() ? $r('sys.symbol.gearshape_fill') : Action.MORE_ICON,
    textRes: $r('app.string.more_text'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_TIMELINE_ACTION_MORE,
    isInvalid: true,
  });
  public static readonly NEW = new Action({
    id: ActionID.NEW,
    iconRes: $r('sys.symbol.plus'),
    textRes: $r('app.string.add'),
    componentKey: COMPONENT_KEY_NEW,
  });
  public static readonly NEW_ALBUM = new Action({
    id: ActionID.NEW_ALBUM,
    iconRes: $r('sys.symbol.plus'),
    textRes: $r('app.string.album_new_album'),
    componentKey: COMPONENT_KEY_NEW_ALBUM,
  });
  public static readonly NEW_WITHOUT_DIALOG = new Action({
    id: ActionID.NEW_WITHOUT_DIALOG,
    iconRes: $r('app.media.ic_gallery_public_new'),
    textRes: $r('app.string.action_new'),
    componentKey: COMPONENT_KEY_NEW,
  });
  public static readonly ADD_PHOTO = new Action({
    id: ActionID.NEW,
    iconRes: $r('sys.symbol.plus'),
    textRes: $r('app.string.action_add_photo'),
    componentKey: COMPONENT_KEY_ADD_PHOTO,
  });
  public static readonly MOVE_PHOTO = new Action({
    id: ActionID.MOVE,
    iconRes: $r('sys.symbol.plus'),
    textRes: $r('app.string.action_add_photo'),
    componentKey: COMPONENT_KEY_MOVE_PHOTO,
  });
  public static readonly RENAME = new Action({
    id: ActionID.RENAME,
    iconRes: $r('sys.symbol.square_and_pencil'),
    textRes: $r('app.string.action_rename'),
    actionType: $r('app.string.action_rename'),
    componentKey: COMPONENT_KEY_RENAME,
  });
  public static readonly RENAME_INVALID = new Action({
    id: ActionID.RENAME_INVALID,
    iconRes: $r('sys.symbol.square_and_pencil'),
    textRes: $r('app.string.action_rename'),
    fillColor: $r('sys.color.icon_primary'),
    actionType: $r('app.string.action_rename'),
    componentKey: COMPONENT_KEY_RENAME,
    isInvalid: true,
  });
  public static readonly RENAME_ALBUM = new Action({
    id: ActionID.RENAME_ALBUM,
    iconRes: $r('sys.symbol.square_and_pencil'),
    textRes: $r('app.string.action_rename_album'),
    actionType: $r('app.string.action_rename_album'),
    componentKey: COMPONENT_KEY_RENAME_ALBUM,
  });
  public static readonly RENAME_ALBUM_INVALID = new Action({
    id: ActionID.RENAME_ALBUM_INVALID,
    iconRes: $r('sys.symbol.square_and_pencil'),
    textRes: $r('app.string.action_rename_album'),
    actionType: $r('app.string.action_rename_album'),
    componentKey: COMPONENT_KEY_RENAME_ALBUM_INVALID,
    isInvalid: true,
  });
  public static readonly ADD = new Action({
    id: ActionID.ADD,
    textRes: $r('app.string.add_to'),
    componentKey: COMPONENT_KEY_ADD,
  });
  public static readonly ADD_INVALID = new Action({
    id: ActionID.ADD_INVALID,
    textRes: $r('app.string.add_to'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_ADD_INVALID,
    isInvalid: true,
  });
  public static readonly MOVE = new Action({
    id: ActionID.MOVE,
    iconRes: $r('sys.symbol.arrow_down_and_rectangle_on_rectangle'),
    textRes: $r('app.string.move_file_to'),
    componentKey: COMPONENT_KEY_MOVE,
  });
  public static readonly MOVE_INVALID = new Action({
    id: ActionID.MOVE_INVALID,
    textRes: $r('app.string.move_file_to'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_MOVE_INVALID,
    isInvalid: true,
  });
  public static readonly PRINT = new Action({
    id: ActionID.PRINT,
    textRes: $r('app.string.print'),
    componentKey: COMPONENT_KEY_PRINT,
    shortKey: 'Ctrl+P',
  });
  public static readonly PASTE_FROM_PASTEBOARD = new Action({
    id: ActionID.PASTE_FROM_PASTEBOARD,
    textRes: $r('app.string.paste_from_pasteboard'),
    shortKey: 'Ctrl+V',
  });
  public static readonly REMOVE_FROM = new Action({
    id: ActionID.REMOVE_FROM,
    textRes: $r('app.string.remove_from'),
    componentKey: COMPONENT_KEY_REMOVE_FROM,
  });
  public static readonly REMOVE_FROM_LARGE = new Action({
    id: ActionID.REMOVE_FROM_LARGE,
    textRes: $r('app.string.remove_from'),
    componentKey: COMPONENT_KEY_REMOVE_FROM_LARGE,
  });
  public static readonly REMOVE_FROM_INVALID = new Action({
    id: ActionID.REMOVE_FROM_INVALID,
    textRes: $r('app.string.remove_from'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_REMOVE_FROM_INVALID,
    isInvalid: true,
  });
  public static readonly NAVIGATION_ALBUMS = new Action({
    id: ActionID.NAVIGATION_ALBUMS,
    iconRes: $r('app.media.ic_navigation_albums_line'),
    textRes: $r('app.string.rotate_text'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_NAVIGATION_ALBUMS,
  });
  public static readonly DOWNLOAD = new Action({
    id: ActionID.DOWNLOAD,
    iconRes: $r('app.media.download'),
    textRes: $r('app.string.save_to_local'),
    componentKey: COMPONENT_KEY_DOWNLOAD,
  });
  public static readonly DOWNLOAD_INVALID = new Action({
    id: ActionID.DOWNLOAD_INVALID,
    iconRes: $r('app.media.download'),
    textRes: $r('app.string.save_to_local'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_DOWNLOAD_INVALID,
    isInvalid: true,
  });
  public static readonly GALLERY_SETTINGS = new Action({
    id: ActionID.GALLERY_SETTINGS,
    iconRes: undefined,
    textRes: $r('app.string.gallery_settings'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_GALLERY_SETTINGS,
  });
  //关于页
  public static readonly ABOUT_GALLERY = new Action({
    id: ActionID.ABOUT_GALLERY,
    iconRes: undefined,
    textRes: $r('app.string.about'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_ABOUT_GALLERY,
  });
  // 声音
  public static readonly SOUND_FILLED = new Action({
    id: ActionID.SOUND_FILLED,
    iconRes: $r('sys.symbol.speaker_wave_3'),
    textRes: $r('app.string.sound_off_filled'),
    componentKey: SOUND_FILLED,
  });
  public static readonly SOUND_FILLED_INVALID = new Action({
    id: ActionID.SOUND_FILLED_INVALID,
    iconRes: $r('sys.symbol.speaker_wave_3'),
    textRes: $r('app.string.sound_off_filled'),
    componentKey: SOUND_FILLED,
    isInvalid: true,
  });
  // 禁音
  public static readonly SOUND_OFF_FILLED = new Action({
    id: ActionID.SOUND_OFF_FILLED,
    iconRes: $r('sys.symbol.speaker_slash'),
    textRes: $r('app.string.sound_filled'),
    componentKey: SOUND_OFF_FILLED,
  });
  public static readonly SOUND_OFF_FILLED_INVALID = new Action({
    id: ActionID.SOUND_OFF_FILLED_INVALID,
    iconRes: $r('sys.symbol.speaker_slash'),
    textRes: $r('app.string.sound_filled'),
    componentKey: SOUND_OFF_FILLED,
    isInvalid: true,
  });
  // 暂停
  public static readonly VIDEO_PAUSE = new Action({
    id: ActionID.VIDEO_PAUSE,
    iconRes: $r('sys.symbol.play_fill'),
    textRes: $r('app.string.play'),
    componentKey: VIDEO_PAUSE,
  });
  public static readonly VIDEO_PAUSE_INVALID = new Action({
    id: ActionID.VIDEO_PAUSE_INVALID,
    iconRes: $r('sys.symbol.play_fill'),
    textRes: $r('app.string.play'),
    componentKey: VIDEO_PAUSE,
    isInvalid: true,
  });
  // 播放
  public static readonly VIDEO_PLAY = new Action({
    id: ActionID.VIDEO_PLAY,
    iconRes: $r('sys.symbol.pause'),
    textRes: $r('app.string.pause'),
    componentKey: VIDEO_PLAY,
  });
  public static readonly VIDEO_PLAY_INVALID = new Action({
    id: ActionID.VIDEO_PLAY_INVALID,
    iconRes: $r('sys.symbol.pause'),
    textRes: $r('app.string.pause'),
    componentKey: VIDEO_PLAY,
    isInvalid: true,
  });
  // 旋转
  public static readonly PHONE_ROTATE = new Action({
    id: ActionID.PHONE_ROTATE,
    iconRes: $r('sys.symbol.rectangle_portrait_rotate'),
    textRes: $r('app.string.phone_rotate'),
    componentKey: PHONE_ROTATE,
  });
  // 旋转置灰
  public static readonly PHONE_ROTATE_INVALID = new Action({
    id: ActionID.PHONE_ROTATE_INVALID,
    iconRes: $r('sys.symbol.rectangle_portrait_rotate'),
    textRes: $r('app.string.phone_rotate'),
    componentKey: PHONE_ROTATE_INVALID,
    isInvalid: true,
  });
  // 按相册展示
  public static readonly ALUBM_DISPLAY = new Action({
    id: ActionID.ALUBM_DISPLAY,
    textRes: $r('app.string.album_display'),
    componentKey: DISPLAY_BY_ALBUM,
  });
  //按宫格展示
  public static readonly GRID_DISPLAY = new Action({
    id: ActionID.GRID_DISPLAY,
    textRes: $r('app.string.grid_display'),
    componentKey: DISPLAY_BY_PHOTO_AND_VIDEO,
  });
  //对比
  public static readonly COMPARE_VALID = new Action({
    id: ActionID.COMPARE,
    iconRes: $r('sys.symbol.square_and_square'),
    textRes: $r('app.string.action_compare'),
    actionType: $r('app.string.action_compare'),
    componentKey: COMPONENT_KEY_COMPARE,
  });
  public static readonly COMPARE_INVALID = new Action({
    id: ActionID.COMPARE_INVALID,
    iconRes: $r('sys.symbol.square_and_square'),
    fillColor: $r('sys.color.icon_primary'),
    textRes: $r('app.string.action_compare'),
    actionType: $r('app.string.action_compare'),
    componentKey: COMPONENT_KEY_COMPARE_INVALID,
    isInvalid: true,
  });
  public static readonly COMPARE = DeviceInfo.isEmulator() ? Action.COMPARE_INVALID : Action.COMPARE_VALID;
  public static readonly SAVE = new Action({
    id: ActionID.OK,
    iconRes: $r('sys.symbol.save'),
    textRes: $r('app.string.save_to_local'),
    componentKey: COMPONENT_KEY_SAVE,
  });
  // 新增合并检查，更换封面，设置为‘我’和从人像相册移除
  public static readonly MERGE_CHECK = new Action({
    id: ActionID.MERGE_CHECK,
    textRes: $r('app.string.merge_check'),
    componentKey: COMPONENT_KEY_MERGE_CHECK,
  });
  public static readonly ACTION_REMOVE = new Action({
    id: ActionID.ACTION_REMOVE,
    textRes: $r('app.string.action_remove'),
    componentKey: COMPONENT_KEY_ACTION_REMOVE,
  });
  public static readonly PICKER_SELECT = new Action({
    id: ActionID.PICKER_SELECT,
    textRes: $r('app.string.Picker_Select'),
    componentKey: COMPONENT_KEY_PICKER_SELECT,
  });
  public static readonly PICKER_UNSELECT = new Action({
    id: ActionID.PICKER_UNSELECT,
    textRes: $r('app.string.Picker_Unselect'),
    componentKey: COMPONENT_KEY_PICKER_UNSELECT,
  });
  public static readonly ALBUM_SET_NEW = new Action({
    id: ActionID.ALBUM_SET_NEW,
    componentKey: COMPONENT_KEY_ALBUM_SET_NEW,
  });
  // 完成
  public static readonly COMPLETE = new Action({
    id: ActionID.COMPLETE,
    iconRes: $r('sys.symbol.checkmark'),
    textRes: $r('app.string.complete'),
    componentKey: COMPONENT_KEY_COMPLETE,
  });
  public static readonly COMPLETE_DISABLED = new Action({
    id: ActionID.COMPLETE_DISABLED,
    iconRes: $r('sys.symbol.checkmark'),
    textRes: $r('app.string.complete'),
    componentKey: COMPONENT_KEY_COMPLETE_DISABLED,
    isInvalid: true,
  });
  // 连拍
  public static readonly BURST_PHOTOS = new Action({
    id: ActionID.BURST_PHOTOS,
    iconRes: $r('sys.symbol.square_stack_3d'),
    textRes: $r('app.string.burst_photos'),
    componentKey: COMPONENT_KEY_BURST_PHOTOS,
  });
  public static readonly BURST_PHOTOS_INVALID = new Action({
    id: ActionID.BURST_PHOTOS_INVALID,
    iconRes: $r('sys.symbol.square_stack_3d'),
    textRes: $r('app.string.burst_photos'),
    componentKey: COMPONENT_KEY_BURST_PHOTOS,
    isInvalid: true,
  });
  // 连拍保存（按钮可点击）
  public static readonly BURST_ABLE_SAVE = new Action({
    id: ActionID.BURST_ABLE_SAVE,
    iconRes: $r('sys.symbol.save'),
    textRes: $r('app.string.save_to_local'),
    isInvalid: false,
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_BURST_ABLE_SAVE,
  });
  // 连拍保存（按钮不可点击）
  public static readonly BURST_DISABLE_SAVE = new Action({
    id: ActionID.BURST_DISABLE_SAVE,
    iconRes: $r('sys.symbol.save'),
    isInvalid: true,
    fillColor: $r('sys.color.ohos_id_color_tertiary'),
    textRes: $r('app.string.save_to_local'),
    componentKey: COMPONENT_KEY_BURST_DISABLE_SAVE,
  });
  public static readonly SET_WALLPAPER = new Action({
    id: ActionID.SET_WALLPAPER,
    textRes: $r('app.string.set_wallpaper'),
    componentKey: COMPONENT_KEY_SET_WALLPAPER,
  });
  public static readonly SET_WALLPAPER_INVALID = new Action({
    id: ActionID.SET_WALLPAPER_INVALID,
    textRes: $r('app.string.set_wallpaper'),
    fillColor: $r('sys.color.icon_primary'),
    componentKey: COMPONENT_KEY_SET_WALLPAPER_INVALID,
    isInvalid: true,
  });
  // 编辑合影
  public static readonly EDIT_GROUP = new Action({
    id: ActionID.EDIT_GROUP,
    textRes: $r('app.string.edit_group_album'),
    componentKey: COMPONENT_KEY_EDIT_GROUP,
  });
  // 删除合影
  public static readonly DELETE_GROUP = new Action({
    id: ActionID.DELETE_GROUP,
    iconRes: $r('sys.symbol.trash'),
    textRes: $r('app.string.delete_group_album'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_DELETE_GROUP,
  });
  // 删除合影
  public static readonly DELETE_GROUP_FROM_MENU = new Action({
    id: ActionID.DELETE_GROUP_FROM_MENU,
    textRes: $r('app.string.delete_group_album'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_DELETE_GROUP_FROM_MENU,
  });
  public static readonly REMOVE_FROM_GROUP = new Action({
    id: ActionID.REMOVE_FROM_GROUP,
    textRes: $r('app.string.remove_from_group'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_REMOVE_FROM_GROUP,
    iconRes: $r('sys.symbol.arrow_down_and_rectangle_on_rectangle')
  });
  public static readonly REMOVE_FROM_GROUP_INVALID = new Action({
    id: ActionID.REMOVE_FROM_GROUP,
    textRes: $r('app.string.remove_portrait'),
    actionType: $r('app.string.action_delete'),
    componentKey: COMPONENT_KEY_REMOVE_FROM_GROUP,
    iconRes: $r('sys.symbol.arrow_down_and_rectangle_on_rectangle')
  });
  // public static readonly REMOVE_FROM_GROUP_TOOL_BAR = new Action({
  //   id: ActionID.REMOVE_FROM_GROUP,
  //   textRes: $r('app.string.delete'),
  //   actionType: $r('app.string.action_delete'),
  //   componentKey: COMPONENT_KEY_REMOVE_FROM_GROUP,
  //   iconRes: $r('sys.symbol.trash')
  // });
  // public static readonly REMOVE_INVALID = new Action({
  //   id: ActionID.REMOVE_INVALID,
  //   iconRes: Action.REMOVE_ICON,
  //   fillColor: $r('sys.color.icon_primary'),
  //   textRes: $r('app.string.delete'),
  //   actionType: $r('app.string.action_remove'),
  //   componentKey: COMPONENT_KEY_ACTION_REMOVE_INVALID,
  //   isInvalid: true,
  // });
  public static readonly ICON_DEFAULT_COLOR: Resource = $r('sys.color.icon_primary');
  public static readonly ICON_DEFAULT_COLOR_CONTRARY: Resource = $r('app.color.icon_default_color_contrary');
  private static uuidInner = 1000; // 起始1000，防止与现有的冲突
  public actionID: number;
  public textRes: Resource;
  public iconRes: Resource = Action.MORE_ICON;
  public isAutoTint: boolean = true;
  public fillColor: Resource = $r('sys.color.icon_primary');
  public actionType: Resource | undefined =
    undefined; // It is used to distinguish whether it is the same type of action
  public componentKey: string;
  public isInvalid: boolean | undefined = undefined;
  public shortKey: string = '';
  public hasSubMenu: boolean = false;
  public subMenuKey: string = '';

  constructor(options: ActionOptions) {
    this.actionID = options.id;
    this.textRes = options.textRes as Resource;
    this.componentKey = options.componentKey as string;
    this.shortKey = options.shortKey || '';
    if (options.iconRes !== undefined && options.iconRes !== null) {
      this.iconRes = options.iconRes;
    }
    if (options.isAutoTint !== undefined && options.isAutoTint !== null) {
      this.isAutoTint = options.isAutoTint;
    }
    if (options.fillColor !== undefined && options.fillColor !== null) {
      this.fillColor = options.fillColor;
    }
    if (options.actionType !== undefined && options.actionType !== null) {
      this.actionType = options.actionType;
    }
    if (options.isInvalid !== undefined && options.isInvalid !== null) {
      this.isInvalid = options.isInvalid;
    }
    if (options.hasSubMenu != null) {
      this.hasSubMenu = options.hasSubMenu;
    }
    if (options.subMenuKey != null) {
      this.subMenuKey = options.subMenuKey;
    }
  }

  /**
   * 生成唯一id
   * @returns 唯一id
   */
  public static get uuid(): number {
    Action.uuidInner++; // 每次调用自增，防止冲突
    return Action.uuidInner;
  }

  public equals(action: Action): boolean {
    return this.actionID === action?.actionID;
  }
}

export type SubMenuParamType = number | string | SortSelectMenuParamType;

@Component
export struct CustomRenderSubMenu {
  onMenuClicked: Function = (): void => {
  };
  private subMenuKey: string = '';
  @Prop albumInfo: AlbumInfo | undefined;
  @Prop subMenuExpandingMode: SubMenuExpandingMode;

  build() {
    if (this.subMenuKey == 'SortSelectMenu') {
      SortSelectMenu({
        onMenuClicked: this.onMenuClicked,
        subMenuExpandingMode: this.subMenuExpandingMode,
        albumKey: AlbumGridSortHelper.getAlbumKeyByAlbumInfo(this.albumInfo),
        albumUri: this.albumInfo?.uri,
        albumSubType: this.albumInfo?.subType,
      })
    }
  }
}