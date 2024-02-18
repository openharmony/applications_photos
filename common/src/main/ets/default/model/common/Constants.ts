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

export class Constants {
  // illegal value
  static readonly INVALID: number = -1;

  // Index of and other operations, the index returned when it is not found
  static readonly NOT_FOUND: number = -1;

  // delay 1s
  static readonly DELAY_ONE_SECOND: number = 1000;

  // delay 500ms
  static readonly DELAY_HALF_SECOND: number = 500;

  // delay 250ms
  static readonly DELAY_QUARTER_SECOND: number = 250;

  // delay 100ms
  static readonly DELAY_TENTH_SECOND: number = 100;

  // delay 50ms
  static readonly DELAY_TWENTIETH_SECOND: number = 50;

  // Default sliding window size
  static readonly DEFAULT_SLIDING_WIN_SIZE: number = 500;
  static readonly DEFAULT_ROTATE_VALUE: number = 90;
  static readonly ROTATE_AROUND: number = 360;

  // MainAbility want parameters uri type
  static readonly WANT_PARAM_URI_DETAIL: string = 'photodetail';
  static readonly WANT_PARAM_URI_SELECT_SINGLE: string = 'singleselect';
  static readonly WANT_PARAM_URI_SELECT_MULTIPLE: string = 'multipleselect';
  static readonly WANT_PARAM_URI_FORM: string = 'formAbility';
  static readonly WANT_PARAM_URI_FORM_NONE: string = 'formAbilityNone';

  // Step size. When the last obtained data index deviates from the center of the current sliding window by more
  // than this step, adjust the start and end of the window and re initiate the data request
  static readonly STEP: number = 100;
  static readonly KEY_VIEW_TYPE: string = 'type';
  static readonly KEY_VIEW_DATA: string = 'data';
  static readonly ActionBarHeight: number = 56;
  static readonly APP_KEY_PHOTO_BROWSER: string = 'app_key_photo_browser';
  static readonly APP_KEY_ALL_PHOTO_DATASOURCE: string = 'app_key_all_photo_datasource';
  static readonly APP_KEY_MENU_OPERATION_FACTORY: string = 'app_key_menu_operation_factory';
  static readonly APP_KEY_MENU_MEDIA_OBSERVER: string = 'app_key_menu_media_observer';
  static readonly APP_KEY_MENU_USER_FILE_MANAGER_OBSERVER: string = 'app_key_menu_user_file_manager_observer';
  static readonly APP_KEY_WORKER_MANAGER: string = 'app_key_worker_manager';
  static readonly APP_KEY_SLIDE_SHOW: string = 'app_key_slide_show';
  static readonly APP_KEY_SCREEN_MANAGER: string = 'app_key_screen_manager';
  static readonly PHOTO_GRID_SELECT_MANAGER: string = 'photo_grid_select_manager';
  static readonly THIRD_SELECT_MANAGER: string = 'third_select_manager';
  static readonly APP_KEY_STATUS_BAR_COLOR_CONTROLLER: string = 'app_key_status_bar_color_controller';
  static readonly APP_KEY_NEW_ALBUM: string = 'app_key_new_album';
  static readonly APP_KEY_NEW_ALBUM_TARGET: string = 'app_key_new_album_target';
  static readonly APP_KEY_NEW_ALBUM_TARGET_URI: string = 'app_key_new_album_target_uri';
  static readonly APP_KEY_NEW_ALBUM_SOURCE: string = 'app_key_new_album_source';
  static readonly APP_KEY_NEW_ALBUM_SELECTED: string = 'app_key_new_album_selected';
  static readonly APP_KEY_INSTANCE_MEDIA_LIBRARY_ACCESS: string = 'app_key_instance_media_library_access';
  static readonly FROM_DATA_STORE_UTIL: string = 'form_data_store_util';
  static readonly IS_DATA_FREEZE: string = 'is_data_freeze';
  static readonly IS_SHOW_MOVE_COPY_DIALOG: string = 'is_show_move_copy_dialog';
  static readonly INSTANCE_MOVE_OR_COPY_BROADCAST_PROP: string = 'instance_move_or_copy_broadcast_prop';

  // used as album uri for creating album from picker page
  static readonly APP_NEW_ALBUM_SOURCE_PICKER: string = 'picker_page';

  // BroadCast
  static readonly APP_KEY_EVENT_BUS: string = 'app_key_event_bus';

  // Persistent storage of tabs index
  static readonly APP_KEY_TABS_INDEX: string = 'app_key_tabs_index';
  static readonly SCREEN_MANAGER: string = 'screen_manager';
  static readonly PIXEL_MAP_MANAGER: string = 'pixel_map_manager';

  // Load completion event
  static readonly ON_LOADING_FINISHED: string = 'on_loading_finished';

  // Large jump source: timeline
  static readonly PHOTO_TRANSITION_TIMELINE: string = 'TimelinePage';

  // Large jump source: album
  static readonly PHOTO_TRANSITION_ALBUM: string = 'PhotoGridPage';

  static readonly USER_FILE_MANAGER_PHOTO_TRANSITION_ALBUM: string = 'PhotoGridPage';

  // Large jump source: camera
  static readonly PHOTO_TRANSITION_CAMERA: string = 'Camera';

  // Large jump source: third app
  static readonly PHOTO_TRANSITION_THIRD_APP: string = 'ThirdApp';

  // camera bundleName
  static readonly CAMERA_BUNDLE_NAME: string = 'com.ohos.camera';

  // camera mainAbility
  static readonly CAMERA_MAIN_ABILITY: string = 'com.ohos.camera.MainAbility';

  // camera mainAbility
  static readonly CAMERA_TYPE_CAPTURE: string = 'capture';

  // camera mainAbility
  static readonly CAMERA_TYPE_VIDEO: string = 'video';
  static readonly PHOTO_TRANSITION_EDIT: string = 'EditPage';

  // Timeline page index
  static readonly TIMELINE_PAGE_INDEX: number = 0;

  // Album page index
  static readonly ALBUM_PAGE_INDEX: number = 1;
  static readonly IMAGE_GIF: string = 'gif';
  static readonly GRID_CACHE_ROW_COUNT: number = 4;
  static readonly DISTRIBUTED_ALBUM_PAGE_INDEX: number = 3;

  // Press animation duration
  static readonly PRESS_ANIM_DURATION: number = 100;

  // Press to scale the value at the end of the animation
  static readonly PRESS_ANIM_SCALE: number = 0.9;

  // Default maximum number of share count
  static readonly DEFAULT_MAX_SHARE_COUNT: number = 100;
  // Default maximum number of external selection pages
  static readonly DEFAULT_MAX_THIRD_SELECT_COUNT: number = 50;
  // maximum number limit of external selection pages
  static readonly LIMIT_MAX_THIRD_SELECT_COUNT: number = 500;

  // Horizontal and vertical screen flag
  static readonly SCREEN_ORIENTATION_HORIZONTAL: string = 'isHorizontal';
  // Screen rotate animation duration
  static readonly SCREEN_ROTATE_DURATION: number = 600;

  // Sidebar flag
  static readonly SCREEN_SIDEBAR: string = 'isSidebar';

  // Column flag
  static readonly SCREEN_COLUMNS: string = 'screen_colums';
  static readonly ADD_NOTES_MAX_LENGTH: number = 140;
  static readonly RENAME_MAX_LENGTH: number = 50;
  static readonly ENTRY_FROM_NONE: number = 0;
  static readonly ENTRY_FROM_CAMERA: number = 1;
  static readonly ENTRY_FROM_SINGLE_SELECT: number = 2;
  static readonly ENTRY_FROM_MULTIPLE_SELECT: number = 3;
  static readonly ENTRY_FROM_RECYCLE: number = 4;
  static readonly ENTRY_FROM_DISTRIBUTED: number = 5;
  static readonly ENTRY_FROM_NORMAL: number = 6;
  static readonly ENTRY_FROM_FORM_ABILITY: number = 7;
  static readonly ENTRY_FROM_FORM_FORM_EDITOR: number = 8;
  static readonly ENTRY_FROM_VIEW_DATA: number = 9;
  static readonly ENTRY_FROM_FORM_DEFAULT_ABILITY: number = 11;
  static readonly ENTRY_FROM = {
    NORMAL: 0,
    CAMERA: 1,
    SINGLE_SELECT: 2,
    MULTIPLE_SELECT: 3,
    RECYCLE: 4,
    DISTRIBUTED: 5,
    CARD: 6,
    VIEW_DATA: 7,
  };
  static readonly DIALOG_BOTTOM_OFFSET: number = 16;

  // Local tab index
  static readonly LOCAL_TAB_INDEX: number = 0;

  // Other equipment tab index
  static readonly OTHER_EQUIPMENT_TAB_INDEX: number = 1;

  //the constant for action of the want
  static readonly ACTION_DELETE_DATA: string = 'ohos.want.action.deleteDialog';

  // editor used
  static readonly UPDATE_MENU: string = 'updateMenu';
  static readonly UPDATE_DOODLE_STYLE: string = 'update_doodle_style';
  static readonly ADJUST_PARAMS_VALUE_CHANGED: string = 'adjust_params_value_changed';
  static readonly ADJUST_PARAMS_ID_CHANGED: string = 'adjust_params_id_changed';
  static readonly IS_IMMERSIVE: string = 'is_immersive';
  static readonly UPDATE_DOODLE_STROKE_STYLE: string = 'update_doodle_stroke_style';
  static readonly PHOTO_EDITOR_MANAGER: string = 'photo_editor_manager';
  static readonly PHOTO_EDITOR_EVENT_MANAGER: string = 'photo_editor_event_manager';
  static readonly INTI_RULER: string = 'inti_ruler';
  static readonly RULER_CHANGED: string = 'inti_ruler';
  static readonly LABEL_STYLE_CHANGED: string = 'label_style_changed';
  static readonly LABEL_TEXT_STYLE_CHANGED: string = 'label_text_style_changed';
  static readonly LABEL_TEXT_COLOR_CHANGED: string = 'label_text_color_changed';
  static readonly LABEL_GET_CLIP_RECT: string = 'label_get_clip_rect';
  static readonly CROP_RESET_CLICKED: string = 'crop_reset_clicked';
  static readonly IS_BIG_TEXT_SHOW: string = 'is_big_text_show';
  static readonly RULER_BAR_INTI: string = 'ruler_bar_inti';
  static readonly COLOR_SLIDER_CHANGED: string = 'color_slider_changed';
  static readonly MOSAIC_STYLE_CHANGED: string = 'mosaic_style_changed';
  static readonly LABEL_DELETE: string = 'label_delete';
  static readonly UPDATE_LABEL_STYLE: string = 'update_label_style';
  static readonly IS_LABEL_ACTIVE: string = 'is_label_active';
  static readonly NOT_MAX_INDEX_CLICK_OF_LABEL: string = 'not_max_index_click_of_label';
  static readonly IS_LABEL_MODE: string = 'is_label_mode';
  static readonly RESET_LABEL_STYLE_INFO: string = 'reset_label_style_info';
  static readonly UPDATE_TOUCH_EVENT: string = 'update_touch_event';
  static readonly PHOTO_COLLAGE_MANAGER: string = 'photo_collage_manager';
  static readonly RETURN_TO_MAIN: string = 'return_to_main';
  static readonly FORM_ITEM_NAME: string = 'form_itemName';
  static readonly FORM_ITEM_ALBUM_ID: string = 'form_itemAlbumId';
  static readonly FORM_ITEM_DISPLAY_NAME: string = 'form_itemDisplayName';
  static readonly MAIN_WINDOW: string = 'mainWindow';
  static readonly ACTION_URI_FORM_ABILITY: string = 'formAbility';
  static readonly ACTION_URI_FORM_ABILITY_NONE: string = 'formAbilityNone';
  static readonly PROGRESS_LENGTH_DIFF: number = 88;
  static readonly ALBUM_NAME_MAX_LENGTH: number = 80;
  static readonly BACK_FROM_FORM_DETAIL: string = 'back_from_form_detail';
  static readonly NEGATIVE_FORTY: string = '-40';
  static readonly NEGATIVE_THIRTY: string = '-30';
  static readonly NEGATIVE_TWENTY: string = '-20';
  static readonly NEGATIVE_TEN: string = '-10';
  static readonly ZERO_STR: string = '0';
  static readonly POSITIVE_TEN: string = '10';
  static readonly POSITIVE_TWENTY: string = '20';
  static readonly POSITIVE_THIRTY: string = '30';
  static readonly POSITIVE_FORTY: string = '40';
  static readonly RULER_CONTEXT_FONT_10PX: string = '10px SimSun, Songti SC';
  static readonly RULER_CONTEXT_FONT_20PX: string = '20px SimSun, Songti SC';
  static readonly RULER_CONTEXT_FONT_25PX: string = '25px SimSun, Songti SC';
  static readonly RULER_CONTEXT_FONT_30PX: string = '30px SimSun, Songti SC';
  static readonly RULER_CONTEXT_FONT_35PX: string = '35px SimSun, Songti SC';
  static readonly RULER_FILL_STYLE_100: string = '#FFFFFF';
  static readonly RULER_FILL_STYLE_90: string = '#E5FFFFFF';
  static readonly RULER_FILL_STYLE_40: string = '#66FFFFFF';
  static readonly RULER_FILL_STYLE_30: string = '#4dffffff';
  static readonly RULER_FILL_STYLE_20: string = '#33ffffff';
  static readonly RULER_FILL_STYLE_10: string = '#1affffff';
  static readonly RULER_TEXT_ALIGN: string = 'center';
  static readonly STATUS_BAR_BACKGROUND_COLOR: string = '#F1F3F5';
  static readonly STATUS_BAR_CONTENT_COLOR: string = '#000000';
  static readonly TOP_BAR_SIZE: number = 56;
  static readonly TOOL_BAR_SIZE: number = 72;
  static readonly BOTTOM_TOOL_BAR_SIZE: number = 196;
  static readonly FILTER_BOTTOM_TOOL_BAR_SIZE: number = 232;
  static readonly DEFAULT_WIDTH: number = 360;
  static readonly RESET_SIZE: number = 20;
  static readonly RESET_SIZE_HORIZONTAL: number = 48;
  static readonly TIMEOUT: number = 50;
  static readonly PADDING_VERTICAL: number = 140;
  static readonly PADDING_HORIZONTAL: number = 160;
  static readonly MID_LINE_WIDTH: number = 1.5;
  static readonly MID_LINE_HEIGHT: number = 18;
  static readonly RULER_LINE_WIDTH: number = 1;
  static readonly NEGATIVE_1: number = -1;
  static readonly NEGATIVE_2: number = -2;
  static readonly NUMBER_1: number = 1;
  static readonly NUMBER_2: number = 2;
  static readonly NUMBER_3: number = 3;
  static readonly NUMBER_4: number = 4;
  static readonly NUMBER_5: number = 5;
  static readonly NUMBER_5_5: number = 5.5;
  static readonly NUMBER_6: number = 6;
  static readonly NUMBER_6_5: number = 6.5;
  static readonly NUMBER_7: number = 7;
  static readonly NUMBER_7_5: number = 7.5;
  static readonly NUMBER_8: number = 8;
  static readonly NUMBER_8_5: number = 8.5;
  static readonly NUMBER_9: number = 9;
  static readonly NUMBER_9_5: number = 9.5;
  static readonly NUMBER_10: number = 10;
  static readonly NUMBER_10_5: number = 10.5;
  static readonly NUMBER_11_5: number = 11.5;
  static readonly NUMBER_15: number = 15;
  static readonly EDGE_ANGLE: number = 45;
  static readonly LITTLE_CANVAS_SIZE: number = 60;
  static readonly NUMBER_40: number = 40;
  static readonly NUMBER_30: number = 30;
  static readonly NUMBER_20: number = 20;
  static readonly NUMBER_0: number = 0;
  static readonly NUMBER_0_5: number = 0.5;
  static readonly NUMBER_16: number = 16;
  static readonly NUMBER_96: number = 96;
  static readonly NUMBER_48: number = 48;
  static readonly NUMBER_32: number = 32;

  // Grid Constants
  static readonly TAB_BAR_WIDTH: number = 200;
  static readonly PAD_TAB_BAR_WIDTH: number = 96;
  static readonly GRID_GUTTER: number = 2;
  static readonly GRID_IMAGE_SIZE: number = 256;
  static readonly GRID_MAX_SIZE_RATIO: number = 1.2;
  static readonly GRID_MIN_COUNT: number = 2;
  static readonly SCROLL_BAR_SIDE_MIN_GAP: number = 12;
  static readonly SCROLL_MARGIN: number = 24;

  // Column Constants
  static readonly COLUMN_MARGIN: number = 12;
  static readonly COLUMN_GUTTER: number = 12;

  // Album Card Constants
  static readonly CARD_ASPECT_RATIO: number = 1;
  static readonly ALBUM_SET_NEW_ICON_SIZE: number = 22;
  static readonly ALBUM_SET_NEW_ICON_MARGIN: number = 8;
  static readonly ALBUM_SET_MARGIN: number = 12;
  static readonly ALBUM_SET_GUTTER: number = 12;
  static readonly ALBUM_SET_COVER_SIZE: number = 150;
  static readonly RECYCLE_ALBUM_OF_PHONE_HEIGHT: number = 88;

  // System Resource Constants
  static readonly TEXT_SIZE_SUB_TITLE1: number = 18; // ohos_id_text_size_sub_title1
  static readonly TEXT_SIZE_BODY2: number = 14; // ohos_id_text_size_body2
  static readonly TEXT_SIZE_SUB_TITLE2: number = 16; // ohos_id_text_size_sub_title2

  // Empty Page
  static readonly EMPTY_PAGE_OFFSET_RADIO: number = 0.4;
  static readonly EMPTY_PAGE_DEFAULT_OFFSET: number = 300;
  static readonly EMPTY_PAGE_MARGIN: number = 12;
  static readonly DETAILS_DIALOG_PATH_MAX_LINE: number = 7;
  static readonly DETAILS_DIALOG_NAME_MAX_LINE: number = 5;
  static readonly BIG_SCREEN_WIDTH: number = 600;
  static readonly BIG_EMPTY_ICON_SIZE: number = 160;
  static readonly SMALL_EMPTY_ICON_SIZE: number = 120;

  // Menu
  static readonly MENU_DIVIDER_STROKE_WIDTH: number = 0.5;

  // Double click time delay
  static readonly DOUBLE_CLICK_GAP: number = 300;

  // Empty page picture size
  static readonly EMPTY_PAGE_PIC_SIZE: number = 120;

  // Button status
  static readonly BUTTON_STATUS_NORMAL: string = 'NORMAL';
  static readonly BUTTON_STATUS_HOVER: string = 'HOVER';
  static readonly BUTTON_STATUS_PRESS: string = 'PRESS';
  static readonly BUTTON_STATUS_DISABLE: string = 'DISABLE';
  static readonly BUTTON_STATUS_FOCUS: string = 'FOCUS';

  // Video status
  static readonly VIDEO_STATUS_INITIAL: string = 'initial';
  static readonly VIDEO_STATUS_PLAYING: string = 'playing';
  static readonly VIDEO_STATUS_PAUSE: string = 'pause';
  static readonly VIDEO_STATUS_FINISH: string = 'finish';
  static readonly VIDEO_STATUS_ERROR: string = 'error';

  // Edit rulerBar line length
  static readonly EDITOR_MIDDLE_TICK_LINE_HEIGHT: number = 8;
  static readonly EDITOR_SMALL_TICK_LINE_HEIGHT: number = 4;
  static readonly EDITOR_LARGE_TICK_LINE_HEIGHT: number = 18;

  // Angle
  static readonly ANGLE_360: number = 360;
  static readonly ANGLE_270: number = 270;
  static readonly ANGLE_180: number = 180;
  static readonly ANGLE_90: number = 90;

  // Button set-gray transparency
  static readonly BUTTON_INVALID_OPACITY: number = 0.4;

  // Device types
  static readonly DEFAULT_DEVICE_TYPE: string = 'phone';
  static readonly PAD_DEVICE_TYPE: string = 'pad';
  static readonly PC_DEVICE_TYPE: string = 'pc';

  // Device album page minimal column count
  static readonly PAD_ALBUM_GRID_COLUMN_MIN_COUNT: number = 1;
  static readonly DEFAULT_ALBUM_GRID_COLUMN_MIN_COUNT: number = 2;

  // Maximum recycle days
  static readonly RECYCLE_DAYS_MAX: number = 30;
  static readonly RECYCLE_DAYS_WARN: number = 3;

  // Get want info with key
  static readonly KEY_WANT_PARAMETERS_CALLER_BUNDLE_NAME: string = 'ohos.aafwk.param.callerBundleName';

  // Keys of photo detail text
  static readonly KEY_FOR_AUTO_TEST_TITLE: string = 'DetailTitle';
  static readonly KEY_FOR_AUTO_TEST_TIME: string = 'DetailTime';
  static readonly KEY_FOR_AUTO_TEST_SIZE: string = 'DetailSize';
  static readonly KEY_FOR_AUTO_TEST_RESOLUTION: string = 'DetailResolution';
  static readonly KEY_FOR_AUTO_TEST_DURATION: string = 'DetailDuration';
  static readonly KEY_FOR_AUTO_TEST_PATH: string = 'DetailPath';

  // Properties of edit page
  static readonly PUNCH_HOLE_HEIGHT: number = 30;
  static readonly ACTION_BUTTON_WIDTH: number = 60;
  static readonly ACTION_BUTTON_HEIGHT: number = 79.5;
  static readonly CROP_RULER_WIDTH: number = 78;
  static readonly CROP_STYLE_BAR: number = 40;
  // 横屏状态下编辑页各组件的属性
  static readonly HORIZONTAL_RESET_BUTTON_WIDTH: number = 35;
  static readonly HORIZONTAL_RESET_BUTTON_HEIGHT: number = 24;
  static readonly HORIZONTAL_RESET_BUTTON_MARGIN: number = 5;
  static readonly HORIZONTAL_CROP_STYLE_BAR_HEIGHT: number = 70;
  static readonly HORIZONTAL_CROP_RULER_WIDTH: number = 70;
  static readonly HORIZONTAL_RESET_BUTTON_TEXT_SIZE: number = 17.5;
  static readonly HORIZONTAL_TOOL_BAR_WIDTH: number = 70;
  static readonly HORIZONTAL_TOOL_BAR_HEIGHT: number = 97.5;
  static readonly HORIZONTAL_MAIN_MENU_WIDTH: number = 277.5;
  static readonly HORIZONTAL_CROP_STYLE_BAR_TOP_PADDING: number = 15;
  static readonly HORIZONTAL_CROP_STYLE_BAR_BOTTOM_PADDING: number = 15;
  static readonly HORIZONTAL_CROP_STYLE_BAR_LEFT_PADDING: number = 20;
  static readonly HORIZONTAL_CROP_STYLE_BAR_RIGHT_PADDING: number = 20;
  static readonly HORIZONTAL_ACTION_BUTTON_WIDTH: number = 30;
  static readonly HORIZONTAL_ACTION_BUTTON_HEIGHT: number = 50;
  static readonly HORIZONTAL_ACTION_BUTTON_LEFT_MARGIN: number = 27.5;
  static readonly HORIZONTAL_ACTION_BUTTON_LEFT_PADDING: number = 25.5;
  static readonly HORIZONTAL_RULER_COMPONENT_WIDTH: number = 97.5;
  static readonly HORIZONTAL_CROP_RULER_MARGIN: number = 27;
  static readonly HORIZONTAL_OUTSIDE_ACTION_BUTTON_CONTAINER_HEIGHT: number = 90;
  static readonly HORIZONTAL_OUTSIDE_ACTION_BUTTON_CONTAINER_WIDTH: number = 81;
  // 竖屏状态下编辑页各组件的属性
  static readonly VERTICAL_RESET_BUTTON_HEIGHT: number = 19;
  static readonly VERTICAL_RESET_BUTTON_TEXT_SIZE: number = 14;
  static readonly VERTICAL_RESET_BUTTON_MARGIN: number = 6;
  static readonly VERTICAL_CROP_STYLE_BAR_HEIGHT: number = 56;
  static readonly VERTICAL_RULER_COMPONENT_HEIGHT: number = 60;
  static readonly VERTICAL_TOOL_BAR_WIDTH: number = 104;
  static readonly VERTICAL_TOOL_BAR_HEIGHT: number = 72;
  static readonly VERTICAL_MAIN_MENU_BAR_HEIGHT: number = 219;
  static readonly VERTICAL_CROP_STYLE_BAR_TOP_PADDING: number = 16;
  static readonly VERTICAL_CROP_STYLE_BAR_BOTTOM_PADDING: number = 16;
  static readonly VERTICAL_CROP_STYLE_BAR_LEFT_PADDING: number = 24;
  static readonly VERTICAL_CROP_STYLE_BAR_RIGHT_PADDING: number = 24;
  static readonly VERTICAL_OUTSIDE_ACTION_BUTTON_CONTAINER_HEIGHT: number = 60;
  static readonly VERTICAL_OUTSIDE_ACTION_BUTTON_CONTAINER_WIDTH: number = 79.5;

  // Types and minimal screen size of breakpoints
  static readonly BREAKPOINT_XS: string = 'xs'; // The screen size ranges from 0 to 320.excluding 320.
  static readonly BREAKPOINT_XS_MIN_SIZE: number = 0;
  static readonly BREAKPOINT_SM: string = 'sm'; // The screen size ranges from 320 to 520.excluding 520.
  static readonly BREAKPOINT_SM_MIN_SIZE: number = 320;
  static readonly BREAKPOINT_MD: string = 'md'; // The screen size ranges from 520 to 840.excluding 840.
  static readonly BREAKPOINT_MD_MIN_SIZE: number = 520;
  static readonly BREAKPOINT_LG: string = 'lg'; // The screen size is greater than or equal to 840.
  static readonly BREAKPOINT_LG_MIN_SIZE: number = 840;
  static readonly PERCENT_100: string = '100%';
  static readonly PERCENT_0: string = '0%';
  static readonly DEFAULT_DIVIDER_COLOR: string = 'rgb(207, 195, 195)';
  static readonly DEFAULT_DIVIDER_HEIGHT: string = '24vp';
  static readonly PHOTOS_STORE_KEY: string = 'PhotosStore';
  static readonly PHOTOS_PERMISSION_FLAG: string = 'PhotosPermissionFlag';
  static readonly PHOTOS_CNT_FOR_HIDE_SCROLL_BAR: number = 100;

  // First delete flag
  static readonly IS_FIRST_TIME_DELETE: string = 'isFirstTimeDelete';

  // Media operation from page
  static readonly MEDIA_OPERATION_FROM_TIMELINE: string = 'FromTimelinePage';
  static readonly MEDIA_OPERATION_FROM_PHOTO_GRID: string = 'FromPhotoGridPage';
  static readonly MEDIA_OPERATION_FROM_PHOTO_BROWSER: string = 'FromPhotoBrowser';
  static readonly MOUSE_TURN_PAGE_BUTTON_DISAPPEAR_TIMEOUT: number = 2000;

  // AppStorage Key
  static readonly CONFIRM_TEXT_KEY: string = 'confirmText';
  static readonly KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM: string = 'photoGridViewAlbumItem';
  static readonly KEY_OF_ALBUM_ID: string = 'albumId'; //TODO API10整改完成后删除
  static readonly KEY_OF_ALBUM_URI: string = 'albumUri';
  static readonly KEY_OF_ALBUM_HEIGHT: string = 'albumHeight';
  static readonly KEY_OF_ALBUM_WIDTH: string = 'albumWidth';
  static readonly KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT: string = 'geometryTransitionId';
  static readonly KEY_OF_PLACE_HOLDER_INDEX: string = 'placeHolderIndex';
  static readonly KEY_OF_SELECTED_ALBUM_INDEX: string = 'selectedAlbumIndex';
  static readonly KEY_OF_IS_SHOW_PHOTO_GRID_VIEW: string = 'isShowPhotoGridView';
  static readonly KEY_OF_PHOTO_COUNT_IN_ALBUM: string = 'photoCount';
  static readonly KEY_OF_ALBUM_ACTIONBAR_OPACITY: string = 'albumActionBarOpacity';
  static readonly KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY: string = 'photoGridActionBarOpacity';
  static readonly KEY_OF_SIDE_BAR_OPACITY: string = 'sideBarOpacity';
  static readonly KEY_OF_IS_FIRST_PHOTO_ITEM: string = 'isFirstPhotoItem';
  static readonly KEY_OF_SELECTED_ALBUM_ID: string = 'selectedAlbumId'; //TODO API10整改完成后删除
  static readonly KEY_OF_SELECTED_ALBUM_URI: string = 'selectedAlbumUri';
  static readonly KEY_OF_PHOTO_GRID_VIEW_OPACITY: string = 'photoGridViewOpacity';
  static readonly KEY_OF_ALBUM_OPACITY: string = 'albumOpacity';
  static readonly KEY_OF_ALBUM_OTHER_SCALE: string = 'albumOtherScale';
  static readonly KEY_OF_PHOTO_GRID_VIEW_SCALE: string = 'photoGridViewScale';
  static readonly KEY_OF_IS_SHOW_VIDEO_MASK: string = 'isShowVideoMask';
  static readonly KEY_OF_SIDE_BAR_BOUNDARY_LINE_OPACITY: string = 'sideBarBoundaryLineOpacity';
  static readonly KEY_OF_IS_THIRD_EDITABLE: string = 'isThirdEditAble';

  // Properties of image Properties component
  static readonly PHOTO_TITLE_LINE_HEIGHT: number = 19;
  static readonly PHOTO_TITLE_MAX_WIDTH: number = 296;
  static readonly EDIT_FONT_WIDTH: number = 24;
  static readonly EDIT_FONT_HEIGHT: number = 16;
  static readonly EDIT_FONT_SIZE: number = 12;
  static readonly PHOTO_DATE_FONT_HEIGHT: number = 16;
  static readonly PHOTO_DATE_TOP_MARGIN: number = 2;
  static readonly COLUMN_RADIUS: number = 16;
  static readonly COLUMN_PADDING: number = 12;
  static readonly HISTOGRAM_HEIGHT: number = 96;
  static readonly PHOTO_PROPERTIES_ROW_GAP: number = 16;

  static readonly PHOTO_BAR_MULTIPLES_1_5: number = 1.5;

  // Histogram
  static readonly HISTOGRAM_INSTANCE_KEY: string = 'HistogramInstance';
  static readonly HISTOGRAM_READY_STATUS_KEY: string = 'HistogramReadyStatus';
  static readonly HISTOGRAM_ARRAY_BUFFER_KEY: string = 'HistogramArrayBuffer';
  static readonly WORKER_INSTANCE_NAME_RED: string = 'WorkerInstanceRed';
  static readonly WORKER_INSTANCE_NAME_GREEN: string = 'WorkerInstanceGreen';
  static readonly WORKER_INSTANCE_NAME_BLUE: string = 'WorkerInstanceBlue';
  static readonly PIXEL_NUMBER: number = 256;
  static readonly HISTOGRAM_CONSTANT_256: number = 256;
  static readonly HISTOGRAM_CONSTANT_512: number = 512;
  static readonly HISTOGRAM_WORKER_NUMBER: number = 3;
  static readonly RGB_CHANNELS: number = 3;
  static readonly RGBA_CHANNELS: number = 4;
  static readonly HISTOGRAM_DIVIDE_LINE_NUM: number = 2;
  static readonly HISTOGRAM_DIVIDER_REGION_NUM: number = 3;
  static readonly HISTOGRAM_WIDTH: number = 312;
  static readonly HISTOGRAM_RED_FILL_COLOR: string = '#FF0000';
  static readonly HISTOGRAM_GREEN_FILL_COLOR: string = '#00FF00';
  static readonly HISTOGRAM_BLUE_FILL_COLOR: string = '#0000FF';
  static readonly HISTOGRAM_STROKE_WIDTH: number = 0.8;
  static readonly HISTOGRAM_INTERNAL_STROKE_COLOR: string = '#1A000000';
  static readonly HISTOGRAM_REGION_STROKE_COLOR: string = '#ffffff';
  static readonly HISTOGRAM_LINE_WIDTH: number = 0.5;
  static readonly WORKER_SMOOTH_PARAM: number = 4;

  static readonly IS_ON_SWIPER_ANIMATION: string = 'isOnSwiperAnimation';
  static readonly NAME_PATTERN: RegExp = /[\\.\\\\/:*?"'`<>|\[\]{}]/;

  // fileAsset path data
  static readonly KEY_FILE_DATA: string = 'data';
  static readonly PHOTO_PICKER_SESSION_KEY: string = 'photopicker_PickerUIExtensionAbility_session';
  static readonly PHOTO_PICKER_PARAMS_KEY: string = 'photopicker_PickerUIExtensionAbility_params';
  static readonly PHOTO_PICKER_EXTENSION_WINDOW: string = 'photopicker_PickerUIExtensionAbility_extension_window';
  static readonly UPDATE_SELECTED: string = 'update_selected';
}