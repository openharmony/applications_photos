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

class EntryFromConstants {
  public static readonly NORMAL: number = 0;
  public static readonly CAMERA: number = 1;
  public static readonly SINGLE_SELECT: number = 2;
  public static readonly MULTIPLE_SELECT: number = 3;
  public static readonly RECYCLE: number = 4;
  public static readonly DISTRIBUTED: number = 5;
  public static readonly CARD: number = 6;
  public static readonly VIEW_DATA: number = 7;
  public static readonly PETALCLIP_VIDEO: number = 8;
  public static readonly HIDDEN: number = 9;
  public static readonly PUZZLE: number = 10;
  public static readonly GLOBAL_SEARCH: number = 11;
  public static readonly HIGHLIGHT: number = 12;
  public static readonly FILE_MANAGER: number = 13;
  public static readonly PHOTO_VIEW: number = 21;
  public static readonly ENTRY_FROM_MOVIE_PAGE: number = 24;
};

/**
 * 照片页预显示使用的常量声明类
 */
export class PreviewItemConstants {
  // 不同设备首屏照片页预览图片的个数
  public static readonly PHONE_LAUNCH_PHOTO_NUMBER: number = 32;
  public static readonly PHONE_UNFOLD: number = 36;
  public static readonly PC_LAUNCH_PHOTO_NUMBER: number = 70;
  public static readonly PAD_LAUNCH_PHOTO_NUMBER: number = 48;
  public static readonly FOLD_SCREEN_LAUNCH_PHOTO_NUMBER: number = 56;

  /**
   * 默认正式宫格创建间隔，从照片页创建到真实宫格的最晚创建时间，用于保护预览宫格有问题的情况
   */
  public static readonly DURATION_DEFAULT_SHOW_RAW: number = 150;

  public static readonly DURATION_DEFAULT_HIDE_PREVIEW: number = 3000;

  /**
   * 渲染间隔，给解码结果留出渲染帧发送给图形的时间
   */
  public static readonly ENCODE_FRAME_INTERVAL: number = 16.6;

  /**
   * 正式帧渲染间隔，正式帧渲染耗时需要留出时间，否则会有闪烁
   */
  public static readonly RENDER_FRAME_INTERVAL: number = 80;
}

/**
 * 视图枚举类型
 */
export enum ViewType {
  TAB_PAGE,
  PHOTO_GRID_PAGE,
  PHOTO_BROWSER
}

export enum SelectMediaType {
  INVALID = 0,
  IMAGE,
  VIDEO,
  IMAGE_VIDEO
}

/**
 * 任务类型
 */
export enum SubjectType {
  COURSES = 0,
  MEETING,
  TRAVELLING,
}

/**
 * 日历课程表拉起照片页参数
 */
export class CoursesParams {
  jumpSource: number;
  pageFrom: number;
  subjectType: SubjectType;
  subjectTitle: string;
  subjectStartTime: number;
  subjectStopTime: number;
};


export class Constants {
  // drag album number
  public static readonly DRAG_ALBUM_COUNT: number = 1;
  // drag album scale
  public static readonly DRAG_ALBUM_SCALE: number = 1.05;
  // enter album scale
  public static readonly ENTER_DRAG_ALBUM_SCALE: number = 0.95;
  // drag album scale recover
  public static readonly DRAG_ALBUM_SCALE_RECOVER: number = 1;
  // drag album scale animation mass
  public static readonly DRAG_ALBUM_SCALE_ANIMATION_MASS: number = 1;
  // drag album scale animation velocity
  public static readonly DRAG_ALBUM_SCALE_ANIMATION_VELOCITY: number = 14;
  // drag album scale animation stiffness
  public static readonly DRAG_ALBUM_SCALE_ANIMATION_STIFFNESS: number = 170;
  // enter album scale animation stiffness
  public static readonly ENTER_ALBUM_SCALE_ANIMATION_STIFFNESS: number = 400;
  // drag album scale animation damping
  public static readonly DRAG_ALBUM_SCALE_ANIMATION_DAMPING: number = 17;
  // enter album scale animation damping
  public static readonly ENTER_ALBUM_SCALE_ANIMATION_DAMPING: number = 38;
  // enter album scale animation velocity
  public static readonly ENTER_ALBUM_SCALE_ANIMATION_VELOCITY: number = 0;
  // drag grid item album info opacity appear
  public static readonly DRAG_ALBUM_INFO_OPACITY_APPEAR: number = 1;
  // drag grid item album info opacity disappear
  public static readonly DRAG_ALBUM_INFO_OPACITY_DISAPPEAR: number = 0;
  // drag grid item album info opacity appear or disappear time
  public static readonly DRAG_ALBUM_INFO_OPACITY_TIME: number = 150;
  // drag album start animation time
  public static readonly DRAG_ALBUM_START_ANIMATION_TIME: number = 300;
  // drag offset count
  public static readonly DRAG_OFFSET_COUNT: number = 2;
  // picker long log limit size
  public static readonly PICKER_LONG_LOG_LIMIT_SIZE: number = 10;
  public static readonly PICKER_FILTER_LIMIT_SIZE: number = 3;
  // illegal value
  public static readonly INVALID: number = -1;
  // not exist value
  public static readonly NOT_EXIST: number = -2;
  // 跳转玩机技巧
  public static readonly TIPS_APP_BUNDLE_NAME: string = 'com.ohos.tips';
  public static readonly TIPS_APP_ID: string = 'com.ohos.tips_BB4oLXt8JLOw5djd42S0oLOGzO6kOn' +
    'T8hZfFRAAel2gbcQBG5jIsO4genni5cn2SQpKpKvkwOA7Ajsc7qf+MZgM=';
  public static readonly TIPS_URI_FORMATTER: string = '';
  public static readonly TIPS_MODULE_NAME_APPGALLERY: string = 'com.xxx.hmsapp.appgallery';
  public static readonly TIPS_URI_APPGALLERY: string = '';
  public static readonly TIPS_HIGHLIGHT_URI: string = '';
  public static readonly TIPS_MOVING_PHOTO_URI: string = '';
  // illegal value
  public static readonly DEFAULT_MAX_COLLAGE_COUNT: number = 9;
  public static readonly DEFAULT_MIN_COLLAGE_COUNT: number = 2;
  public static readonly DEFAULT_IMAGE_RATIO: number = 8 / 3;
  public static readonly IMAGE_SPECIFICATIONS: string = 'The image specification is incorrect';
  public static readonly IMAGE_SCALE: string = 'The image scale is incorrect';
  public static readonly VIDEO_NOT_SUPPORTED: string = 'Video does not support jigsaw puzzles';
  public static readonly EXCEEDED_IN_QUANTITY: string = 'Please select 2 - 9 pictures for the puzzle';

  // open_ai_retouch_dialog_event_id
  public static readonly OPEN_AI_RETOUCH_DIALOG_EVENT_ID: string = 'open_ai_retouch_dialog_event_id';

  public static readonly CHANGE_AI_RETOUCH_PROTOCOL_EVENT_ID: string = 'change_ai_retouch_protocol_event_id';

  public static readonly STATUS_BAR_EVENT_ID: string = 'status_bar_event_id';

  public static readonly AI_TOGGLE_STATUS_EVENT_ID: string = 'ai_toggle_status_event_id';

  public static readonly AI_TOGGLE_CLOSE_EVENT_ID: string = 'ai_toggle_close_event_id';

  public static readonly STATUS_BAR_OPEN_CODE: number = 1;

  public static readonly STATUS_BAR_CLOSE_CODE: number = 0;

  // ai wallpaper event
  public static readonly AI_WALLPAPER_PROTOCOL_CHANGE_EVENT: string = 'ai_wallpaper_privacy_status_event';

  public static readonly OPEN_AI_WALLPAPER_DIALOG_EVENT_ID: string = 'open_ai_wallpaper_dialog_event_id';

  // Index of and other operations, the index returned when it is not found
  public static readonly NOT_FOUND: number = -1;

  // delay 1s
  public static readonly DELAY_ONE_SECOND: number = 1000;

  // delay 3s
  public static readonly DELAY_THREE_SECOND: number = 3000;

  // delay 500ms
  public static readonly DELAY_HALF_SECOND: number = 500;

  // delay 300ms
  public static readonly DELAY_THREE_HUNDRED_MILLISECOND: number = 300;

  // delay 250ms
  public static readonly DELAY_QUARTER_SECOND: number = 250;

  // delay 200ms
  public static readonly BROWSER_VIEW_ENTRY_ANIME_DELAY: number = 200;

  // delay 150ms
  public static readonly DRAG_DETECTING_STATUS_DELAY: number = 150;

  // delay 100ms
  public static readonly DELAY_TENTH_SECOND: number = 100;

  // delay 90ms
  public static readonly DELAY_NINETY_SECOND: number = 90;

  // delay 50ms
  public static readonly DELAY_TWENTIETH_SECOND: number = 50;

  // delay 400ms
  public static readonly DELAY_FOURTH_SECOND: number = 400;

  public static readonly DELAY_RETRY: number = 1000;

  public static readonly DELAY_RETRY_COUNT: number = 3;

  public static readonly SOURCE_ALBUM_MIN_COUNT: number = 5;

  // Default sliding window size
  public static readonly DEFAULT_SLIDING_WIN_SIZE: number = 500;
  public static readonly DEFAULT_CARD_SLIDING_WIN_SIZE: number = 200;
  public static readonly DEFAULT_PHONE_SLIDING_WIN_SIZE: number = 100;
  public static readonly BOTTOM_ACTION_BAR_HEIGHT: number = 100;
  public static readonly DEFAULT_YEAR_MONTH_SLIDING_WIN_SIZE: number = 4800;

  // ActionBarButtonHotZoneHeight + paddingTop:16vp +  paddingBtm: 44vp
  public static readonly SETTING_CLEARING_ACTION_BAR_HEIGHT: number = 100;

  //galleryCleanup
  public static readonly PHOTO_CLEANUP_DATA_SOURCE_MANAGER: string = 'photo_cleanup_data_source_manager';
  public static readonly GRID_CLEANUP_PAGE: string = 'GridCleanupPage';
  public static readonly VIDEO_CLEANUP_PAGE: string = 'VideoCleanupPage';
  public static readonly IMAGE_CLEANUP_PAGE: string = 'ImageCleanupPage';
  public static readonly IS_VIDEO_CLEANUP_PAGE: string = 'isVideoCleanupPage';
  public static readonly GALLERY_CLEANUP_PAGE: string = 'GalleryCleanupPage';
  public static readonly GALLERY_CLEANUP_ON_FOREGROUND: string = 'GalleryCleanupOnForeground';
  public static readonly IS_GALLERY_CLEANUP_PAGE: string = 'isGalleryCleanupPage';
  public static readonly IS_FROM_IMAGE_CLEANUP_ENTRY_PAGE: string = 'isFromImageCleanupEntryPage';
  public static readonly GALLERY_CLEANUP_PAGE_MAX_FONT_SCALE: number = 1.45;
  public static readonly DELETE_BUTTON_OPACITY_SHOW: number = 1;
  public static readonly DELETE_BUTTON_OPACITY_HIDE: number = 0.4;
  public static readonly DELETE_ALBUM_TYPE_PHOTO: string = 'photo';
  public static readonly THIRD_APP_LOCK_UPDATE: string = 'third_app_lock_update';
  public static readonly CLEANUP_PAGE_ALBUM_COUNT_INDEX: number = 0;
  public static readonly CLEANUP_PAGE_ALBUM_SIZE_INDEX: number = 1;
  public static readonly CLEANUP_PAGE_ALBUM_COVER_URI_INDEX: number = 2;
  public static readonly CLEANUP_PAGE_ALBUM_URI_INDEX: number = 3;

  public static readonly PER_YEAR_GROUP_COUNT: number = 432;
  public static readonly YEARSTEP: number = Constants.PER_YEAR_GROUP_COUNT * 4;
  public static readonly DEFAULT_SLIDING_WIN_SIZE_YEAR: number = Constants.PER_YEAR_GROUP_COUNT * 14;

  public static readonly PER_MONTH_GROUP_COUNT: number = 128;
  public static readonly MONTHSTEP: number = Constants.PER_MONTH_GROUP_COUNT * 8;
  public static readonly DEFAULT_SLIDING_WIN_SIZE_MONTH: number = Constants.PER_MONTH_GROUP_COUNT * 20;
  public static readonly DEFAULT_SLIDING_ALBUM_WIN_SIZE_PHONE: number = 100;
  public static readonly DEFAULT_SLIDING_ALBUM_WIN_SIZE_TABLET: number = 200;
  public static readonly DEFAULT_SLIDING_ALBUM_WIN_SIZE_PC: number = 500;
  public static readonly DEFAULT_ROTATE_VALUE: number = 90;
  public static readonly ROTATE_AROUND: number = 360;

  public static readonly OPEN_PHOTO_ALBUM_TIMES: string = 'open_photo_album_times';
  public static readonly OPEN_CLOUD_ENHANCE_ALBUM_TIMES: string = 'open_cloud_enhance_album_times';
  public static readonly OPEN_VIDEO_ALBUM_TIMES: string = 'open_video_album_times';
  public static readonly OPEN_FAVOR_ALBUM_TIMES: string = 'open_favor_album_times';
  public static readonly LAST_OPEN_SYSTEM_ALBUM_REPORT_TIME: string = 'last_open_system_album_report_time';
  public static readonly UPDATE_SHEETCONTAINER_SHOECLOSE: string = 'update_sheetcontainer_showclose';
  public static readonly UPDATE_SHEET_STATE: string = 'update_sheet_state';
  public static readonly UPDATE_PICKER_VISIBILITY: string = 'update_picker_visibility';
  public static readonly LAST_REPORT_DATE: string = 'last_report_date';

  //Instantiating the Face Image Interface
  public static readonly APP_KEY_USER_FILE_MANAGER_ACCESS: string = 'app_key_user_file_manager_access';

  //Instantiating the Face Image Interface Portrait
  public static readonly APP_KEY_PORTRAIT_FILE_MANAGER_ACCESS: string = 'app_key_portrait_file_manager_access';

  // MainAbility want parameters uri type
  public static readonly WANT_PARAM_URI_DETAIL: string = 'photodetail';
  public static readonly WANT_PARAM_URI_SELECT_SINGLE: string = 'singleselect';
  public static readonly WANT_PARAM_URI_SELECT_MULTIPLE: string = 'multipleselect';
  public static readonly WANT_PARAM_URI_FORM: string = 'formAbility';
  public static readonly WANT_PARAM_URI_MOMENT_FORM: string = 'MomentCardFormAbility';
  public static readonly WANT_PARAM_URI_FORM_NONE: string = 'formAbilityNone';
  public static readonly WANT_PARAM_URI_FORM_PROFILE: string = 'formAbilityProfile';
  public static readonly WANT_PARAM_URI_FORM_PORTRAIT: string = 'formAbilityPortrait';
  public static readonly WANT_PARAM_URI_PETALCLIP: string = 'petalclipvideodetail';
  public static readonly WANT_PARAM_URI_SHARE_BROWSER_ADD: string = 'shareBrowserAdd';
  public static readonly WANT_PARAM_URI_PORTRAIT_ALBUM: string = 'portraitAlbum';
  public static readonly WANT_PARAM_URI_GLOBAL_SEARCH: string = 'globalSearch';
  public static readonly WANT_PARAM_URI_FILE_MANAGER: string = 'fileManager';
  public static readonly WANT_PARAM_URI_CLOUD_ENHANCE_COMPARE: string = 'ImmersiveCompared';
  public static readonly WANT_PARAM_URI_SETTINGS: string = 'settings';
  public static readonly WANT_PARAM_URI_HW_SHARE: string = 'hwShare';
  public static readonly WANT_PARAM_URI_CAMERA: string = 'camera';

  // MainAbility want fromName uri type
  public static readonly WANT_PARAM_FROM_NAME_RETAILDEMO: string = 'com.ohos.retaildemo';
  public static readonly WANT_PARAM_FROM_NAME_BASEEXPERIENCE: string = 'com.xxx.baseexperience';
  public static readonly WANT_PARAM_URI_PHOTO_VIEW: string = 'photoView'; // 日历课程表拉起图库；

  // Application bundle name
  public static readonly SCENEBOARD_BUNDLE_NAME: string = 'com.ohos.sceneboard';

  // Step size. When the last obtained data index deviates from the center of the current sliding window by more
  // than this step, adjust the start and end of the window and re initiate the data request
  public static readonly SLIDING_STEP_LIBRARY: number = 25;
  public static readonly SLIDING_STEP_DEFAULT: number = 50;
  public static readonly STEP_DEFAULT: number = 100;
  public static readonly STEP_PAD_AND_PC: number = 200;
  public static readonly YEAR_MONTH_STEP: number = 1000;
  public static readonly ALBUM_STEP_PHONE: number = 20;
  public static readonly ALBUM_STEP_TABLET: number = 40;
  public static readonly ALBUM_STEP_PC: number = 100;
  public static readonly KEY_VIEW_TYPE: string = 'type';
  public static readonly KEY_VIEW_DATA: string = 'data';
  public static readonly ActionBarHeight: number = 56;
  public static readonly ActionBarPaddingHeight: number = 5;
  public static readonly StatusBarHeight: number = 36;
  public static readonly WindowDecorHeight: number = 72;
  public static readonly PcTitleTop: number = 2;
  public static readonly ToolBarHeight: number = 48;
  public static readonly TabCoverAIHeight: number = 80;
  public static readonly PreviewHeight: number = 52;
  public static readonly PreviewHeightHorizontal: number = 80;
  public static readonly WINDOW_HEIGHT: number = 32;
  public static readonly PROPERTIES_WIDTH: number = 332;
  public static readonly SPLIT_LIST_CARD_WIDTH: number = 332;
  public static readonly SPLIT_LIST_CARD_MARGIN_COUNT: number = 2;
  public static readonly FOLD_CREASE_REGION_DIFF_SIZE = 3;
  public static readonly PHOTO_LIST_CARD_PADDING: number = 16;
  public static readonly FORM_EDITOR_ITEM_MARGIN: number = 12;
  public static readonly FORM_EDITOR_TOGGLE_WIDTH: number = 36;
  public static readonly FORM_EDITOR_TOGGLE_HEIGHT: number = 20;
  public static readonly FORM_EDITOR_ITEM_HEIGHT: number = 48;
  public static readonly ToolBarHeight_Horizontal: number = 40;
  public static readonly ToolBarNavHeight_Horizontal: number = 68;
  public static readonly TABLET_ToolBarNavHeight_Horizontal: number = 72;
  public static readonly ToolBarAvoidHeight: number = 28;
  public static readonly ActionBarButtonHotZoneHeight: number = 40;
  public static readonly ActionBarButtonHeight: number = 24;
  public static readonly ActionBarButtonPadding: number = 8;
  public static readonly SearchViewWidth: number = 200;
  public static readonly SearchViewMinWidth: number = 159;
  public static readonly SearchViewHeight: number = 40;
  public static readonly SearchViewTop: number = 16;
  public static readonly APP_KEY_PHOTO_BROWSER: string = 'app_key_photo_browser';

  // storage KEY for GRL
  public static readonly APP_KEY_GRL_PORTRAIT_POSITION: string = 'grlPortraitPosition';

  public static readonly GRL_UPDATE_SLIDING_WINDOW_NUM: number = 112;
  public static readonly GRL_SCROLL_DELAY_NUM: number = 200;
  public static readonly GRL_SCROLL_DELAY_TIME: number = 500;
  public static readonly GRL_RECOVER_NUM: number = 72;
  public static readonly APP_KEY_GRL_NUM_CHANGE: number = 1000;
  public static readonly APP_KEY_GRL_FIRST_INDEX: string = 'grlFirstIndex';
  public static readonly APP_KEY_GRL_GROUP_FIRST_INDEX: string = 'grlGroupFirstIndex';
  public static readonly APP_KEY_GRL_CURRENT_VIEW: string = 'grlCurrentViewType';
  public static readonly APP_KEY_GRL_GROUP_VIEW_ZINDEX: string = 'groupViewZIndex';
  public static readonly APP_KEY_GRL_DAY_VIEW_ZINDEX: string = 'dayViewZIndex';
  public static readonly APP_KEY_GRL_MONTH_VIEW_ZINDEX: string = 'monthViewZIndex';
  public static readonly APP_KEY_GRL_YEAR_VIEW_ZINDEX: string = 'yearViewZIndex';
  public static readonly APP_KEY_GRL_PORTRAIT_ENTRY: string = 'gtlPortraitEntry';
  public static readonly APP_KEY_GRL_GRID_SCROLL_INDEX: string = 'grlScrollIndex';
  public static readonly APP_KEY_GRL_GRID_SCROLL_INDEX_TMP: string = 'grlScrollIndexTmp';
  public static readonly APP_KEY_GRL_RECOVER_GRID_VIEW: string = 'isRecoverGridView';
  public static readonly APP_KEY_GRL_RECOVER_SIDEBAR_INDEX: string = 'glrSidebarIndex';
  public static readonly APP_KEY_GRL_RECOVER_HIGHLIGHT: string = 'glrHighLight';
  public static readonly APP_KEY_GRL_CATEGORY_GRID_INDEX: string = 'categoryGridIndex';
  public static readonly APP_KEY_GRL_SHOOTING_MODE_GRID_INDEX: string = 'shootingModeGridIndex';
  public static readonly APP_KEY_GRL_TIMELINE_SELECT_MODE: string = 'timelineSelectMode';
  public static readonly APP_KEY_GRL_TIMELINE_SELECT_FRAME: string = 'timelineSelectFrame';
  public static readonly APP_KEY_GRL_TIMELINE_IS_SELECT_ALL: string = 'timelineIsSelectALL';
  public static readonly APP_KEY_GRL_KEEP_SEARCH: string = 'isKeepSearch';
  public static readonly APP_KEY_GRL_IS_KEEP_CLASSIFIED: string = 'isKeepClassified';
  public static readonly APP_KEY_GRL_IS_KEEP_SHOOTING: string = 'isKeepShootingMode';
  public static readonly APP_KEY_GRL_PHOTO_GRID_SELECT_MODE: string = 'isPhotoGridSelectMode';
  public static readonly APP_KEY_GRL_PHOTO_GRID_SELECT_FRAME: string = 'isPhotoGridSelectFrame';
  public static readonly APP_KEY_GRL_RECOVER_TIME: number = 2500;
  public static readonly APP_KEY_GRL_HIDDEN_ENTRY: string = 'grlHiddenEntry';
  public static readonly APP_KEY_GRL_HIDDEN_GRID_ENTRY: string = 'grlHiddenGridEntry';
  public static readonly APP_KEY_GRL_IS_SHOW_SIDEBAR: string = 'isShowSideBar';
  public static readonly APP_KEY_GRL_MOVING_TO_PAGE: string = 'isMovingToPage';
  public static readonly APP_KEY_GRL_HIDDEN_GRID_SELECT_MODE: string = 'isHiddenGridSelectMode';
  public static readonly APP_KEY_GRL_HIDDEN_GRID_SELECT_FRAME: string = 'isHiddenGridSelectFrame';
  public static readonly APP_KEY_GRL_PHOTO_GRID_VIEW_MODE: string = 'grlPhotoGridViewMode';
  public static readonly APP_KEY_GRL_HIDDEN_UNLOCK: string = 'isHiddenUnlock';
  public static readonly APP_KEY_GRL_GRID_PORTRAIT_SELECT_MANAGER: string = 'grlGridPortraitSelectManager';
  public static readonly APP_KEY_GRL_ALBUM_SELECT_MODE: string = 'isAlbumSelectMode';
  public static readonly APP_KEY_GRL_PORTRAIT_MORE_ENTRY: string = 'grlMorePortraitEntry';
  public static readonly APP_KEY_GRL_MORE_PORTRAIT_SELECT_MANAGER: string = 'grlMorePortraitSelectManager';

  public static readonly APP_KEY_REPLACE_URI_MANAGER: string = 'app_key_replace_uri_manager';
  public static readonly APP_KEY_ALL_PHOTO_DATASOURCE: string = 'app_key_all_photo_datasource';
  public static readonly APP_KEY_SLIDE_SHOW: string = 'app_key_slide_show';
  public static readonly APP_KEY_SCREEN_MANAGER: string = 'app_key_screen_manager';
  public static readonly PHOTO_GRID_SELECT_MANAGER: string = 'photo_grid_select_manager';
  public static readonly THIRD_SELECT_MANAGER: string = 'third_select_manager';
  public static readonly APP_KEY_NEW_ALBUM: string = 'app_key_new_album';
  public static readonly APP_KEY_NEW_ALBUM_TARGET: string = 'app_key_new_album_target';
  public static readonly APP_KEY_NEW_ALBUM_TARGET_URI: string = 'app_key_new_album_target_uri';
  public static readonly APP_KEY_NEW_ALBUM_SOURCE: string = 'app_key_new_album_source';
  public static readonly APP_KEY_NEW_ALBUM_SELECTED: string = 'app_key_new_album_selected';
  public static readonly IS_DATA_FREEZE: string = 'is_data_freeze';
  public static readonly IS_SHOW_MOVE_COPY_DIALOG: string = 'is_show_move_copy_dialog';
  public static readonly IS_SHOW_SETTINGS_PAGE: string = 'is_show_settings_page';
  public static readonly TEMPLATE_NAME: string = 'templateName';
  public static readonly APP_KEY_SESSION = 'app_key_session';
  public static readonly APP_KEY_WANT_PARAM = 'app_key_want_param';
  public static readonly APP_KEY_DELETE_UI_EXT_URIS = 'app_key_delete_ui_ext_uris';
  public static readonly APP_KEY_DELETE_UI_EXT_NAME = 'app_key_delete_ui_ext_name';
  public static readonly CLASSIFIED_ALBUMS: string = 'classified_albums';
  public static readonly ALBUM_SET_CACHED: number = 5;
  // 日视图持久化键值
  public static readonly DAY_PERSISTENT_KEY: string = 'dayViewType';
  // pc正方形网格持久化键值
  public static readonly GRID_IS_FULLRATIO_KEY: string = 'IsFullRatio';
  //是否割接
  public static readonly HAS_CUT_OVER_KEY: string = 'hasCutOver';
  public static readonly RECORD_TIME_PERSISTENT_KEY: string = 'recordDaySubTypeTime';
  public static readonly DAY_GROUP_GUIDE_HAS_DISPLAY: string = 'dayGroupGuideHasDisplayed';
  // 照片页ready标志位持久化
  public static readonly THUMBNAIL_READY_FLAG: string = 'thumbnailReadyFlag';

  public static readonly STORAGE_TIME: string = 'storage_time';

  // photo bundle name
  public static readonly PHOTO_BUNDLE_NAME: string = 'com.ohos.photos';

  // used as album uri for creating album from picker page
  public static readonly APP_NEW_ALBUM_SOURCE_PICKER: string = 'picker_page';

  // Persistent storage of tabs index
  public static readonly APP_KEY_TABS_INDEX: string = 'app_key_tabs_index';
  public static readonly SCREEN_MANAGER: string = 'screen_manager';

  // Load completion event
  public static readonly ON_LOADING_FINISHED: string = 'on_loading_finished';

  // 分组更新老方案照片页专用，后续废弃
  public static readonly ON_GROUP_FINISHED: string = 'on_group_finished';

  public static readonly PHOTO_SOURCE: string = 'PhotoSource';
  public static readonly CLASS_ALBUMS_SOURCE: string = 'classAlbums_source';
  // Large jump source: timeline
  public static readonly PHOTO_TRANSITION_TIMELINE: string = 'TimelineView';
  public static readonly PHOTO_TRANSITION_TIMELINE_GROUP: string = 'TimelinePageGroup';
  // 极简页面
  public static readonly PHOTO_TRANSITION_TIMELINE_MINIMAL: string = 'MinimalTimelinePage';

  // Large jump source: RealTimeGridView
  public static readonly PHOTO_TRANSITION_REAL_VIEW: string = 'RealTimeGridView';

  // Large jump source: RealTimeGridViewPC
  public static readonly PHOTO_TRANSITION_REAL_VIEW_PC: string = 'RealTimeGridViewPC';

  // Large jump source: GroupPhotoGridPage
  public static readonly GROUP_PHOTO_GRID_PAGE = 'GroupPhotoGridPage';

  // Large jump source: album
  public static readonly PHOTO_TRANSITION_ALBUM: string = 'PhotoGridPage';

  public static readonly PHOTO_GRID_VIEW_PC: string = 'PhotoGridView';

  public static readonly PHOTO_TRANSITION_HIDDEN_VIEW_PC: string = 'PhotoHiddenPCView';

  // Large jump source: album
  public static readonly PHOTO_TRANSITION_HIDDEN: string = 'hiddenGridPage';

  public static readonly USER_FILE_MANAGER_PHOTO_TRANSITION_ALBUM: string = 'PhotoGridPage';

  public static readonly PHOTO_TRANSITION_MEDIA_OPERATION: string = 'MediaOperationPage';

  // Large jump source: camera
  public static readonly PHOTO_TRANSITION_CAMERA: string = 'Camera';

  // Large jump source: third app
  public static readonly PHOTO_TRANSITION_THIRD_APP: string = 'ThirdApp';

  // Large jump source: petalClip
  public static readonly PHOTO_TRANSITION_PETALCLIP: string = 'PetalClip';

  // Large jump source: PortraitPhotoGridPage
  public static readonly PORTRAIT_PHOTO_GRID_PAGE = 'PortraitPhotoGridPage';

  // Large jump source: LocationPhotoGridPage
  public static readonly LOCATION_PHOTO_GRID_PAGE = 'LocationPhotoGridPage';

  // Large jump source: PortraitCoverSetPhotoGridPage
  public static readonly PORTRAIT_COVER_SET_PHOTO_GRID_PAGE = 'PortraitCoverSetPhotoGridPage';

  // camera abilityName
  public static readonly CAMERA_ABILITY_NAME: string = 'PickerAbility';

  public static readonly CAMERA_MAIN_ABILITY_NAME: string = '';
  public static readonly CAMERA_BUNDLE_NAME: string = '';

  // camera moduleName
  public static readonly CAMERA_MODULE_NAME: string = 'picker';

  // camera mainAbility
  public static readonly CAMERA_MAIN_ABILITY: string = 'com.ohos.camera.MainAbility';

  // camera mainAbility
  public static readonly CAMERA_TYPE_CAPTURE: string = 'capture';

  // camera mainAbility
  public static readonly CAMERA_TYPE_VIDEO: string = 'video';
  public static readonly PHOTO_TRANSITION_EDIT: string = 'EditPage';

  // Timeline page index
  public static readonly TIMELINE_PAGE_INDEX: number = 0;

  // Album page index
  public static readonly ALBUM_PAGE_INDEX: number = 1;
  public static readonly IMAGE_GIF: string = 'gif';
  public static readonly GRID_CACHE_ROW_COUNT: number = 4;
  public static readonly GRID_CACHE_COL_COUNT: number = 7;
  public static readonly GROUP_DAY_GRID_CACHE_ROW_COUNT: number = 3;
  public static readonly GRID_CACHE_ROW_COUNT_NONE: number = 0;
  public static readonly MONTH_GRID_CACHE_ROW_COUNT: number = 1;
  public static readonly YEAR_GRID_CACHE_ROW_COUNT: number = 1;
  public static readonly DISTRIBUTED_ALBUM_PAGE_INDEX: number = 3;

  // Press animation duration
  public static readonly PRESS_ANIM_DURATION: number = 150;
  public static readonly IMAGE_ITEM_PRESS_CURVE_STIFFNESS: number = 228;
  public static readonly GROUP_ITEM_PRESS_CURVE_STIFFNESS: number = 230;
  public static readonly IMAGE_ITEM_PRESS_CURVE_DAMPING: number = 30;
  public static readonly GROUP_ITEM_PRESS_CURVE_DAMPING: number = 27;
  public static readonly IMAGE_GRID_ITEM_PRESS_CURVE_STIFFNESS: number = 410;
  public static readonly IMAGE_GRID_ITEM_PRESS_CURVE_DAMPING: number = 38;
  public static readonly SHOW_MORE_MENU_DURATION: number = 200;

  // Navigation imitate animation duration
  public static readonly NAVIGATION_IMITATE_ANIMATION_DURATION = 250;

  // Press to scale the value at the end of the animation
  public static readonly PRESS_ANIM_SCALE: number = 0.9;

  // Default minimum number of compare count
  public static readonly DEFAULT_MIN_COMPARE_COUNT: number = 2;
  // Default maximum number of compare count
  public static readonly DEFAULT_MAX_COMPARE_COUNT: number = 20;
  // Default ratio of compare
  public static readonly DEFAULT_COMPARE_IMAGE_RATIO: number = 8 / 3;
  // Enter to compare page time
  public static readonly ENTER_TO_COMPARE_PAGE_TIME: number = 100;
  // 纹理上传时延
  public static readonly RENDER_PASS_DELAY_TIME: number = 400;
  // compared page jump to picker interval time
  public static readonly PICKER_PAGE_DELAY_TIME: number = 500;
  // Enter to compare page time
  public static readonly IMMERSIVE_COMPARE_LOTTIE_TIME: number = 1000;
  //immersive bar content color
  public static readonly IMMERSIVE_BAR_CONTENT_COLOR: string = '#F1F3F5';
  //immersive bar background color, Black 30% opacity
  public static readonly IMMERSIVE_BAR_BACKGROUND_COLOR_30: string = '#4D000000';
  //immersive bar background color, transparent background
  public static readonly IMMERSIVE_BAR_BACKGROUND_COLOR_TRANSPARENT: string = '#00FFFFFF';
  //enter to collage page time
  public static readonly ENTER_TO_COLLAGE_PAGE_TIME: number = 100;
  //collage page jump to photo browser time
  public static readonly EXIT_COLLAGE_JUMP_BROWSER_TIME: number = 500;
  //movie page jump to photo browser time
  public static readonly EXIT_MOVIE_JUMP_BROWSER_TIME: number = 500;
  // First compare tip
  public static readonly IS_CLOSE_COMPARE_TIP: string = 'isCloseCompareTip';
  // First connection tip
  public static readonly IS_CLOSE_CONNECTION_TIP: string = 'isCloseConnectionTip';
  // PAGE_ON_BACK_PRESS
  public static readonly PAGE_ON_BACK_PRESS: string = 'PAGE_ON_BACK_PRESS';
  //Immersive compared maxScale
  public static readonly IMMERSIVE_COMPARED_MAX_SCALE: string = 'immersiveComparedMaxScale';
  // Saved to puzzle album show toast time
  public static readonly SAVED_TO_PUZZLE_ALBUM_TOAST_TIME: number = 1000;

  // Default maximum number of share count
  public static readonly DEFAULT_MAX_SHARE_COUNT: number = 25000;
  // Default maximum number of external selection pages
  public static readonly DEFAULT_MAX_THIRD_SELECT_COUNT: number = 50;
  // maximum number limit of external selection pages
  public static readonly LIMIT_MAX_THIRD_SELECT_COUNT: number = 500;
  public static readonly LIMIT_MAX_ADD_HIGHLIGHT_PICKER_COUNT: number = 200;
  // maximum photo number limit of external selection pages
  public static readonly LIMIT_MAX_THIRD_SELECT_PHOTO_COUNT: number = 500;
  // maximum video number limit of external selection pages
  public static readonly LIMIT_MAX_THIRD_SELECT_VIDEO_COUNT: number = 500;
  // maxSelectedReminderMode: NONE = 0, TOAST = 1, MASK = 2
  public static readonly NONE_REMIND_MODE: number = 0;
  public static readonly TOAST_REMIND_MODE: number = 1;
  public static readonly MASK_REMIND_MODE: number = 2;
  // item opacity
  public static readonly DEFAULT_ITEM_OPACITY: number = 1;
  public static readonly OBSCURATION_ITEM_OPACITY: number = 0.6;
  public static readonly PULLDOWN_OPACITY_THRESHOLD: number = 100;
  public static readonly PULLDOWN_OPACITY_ANIMATE_TIME: number = 150;
  public static readonly BAR_GEOMETRY_OPACITY = 'barGeometryOpacity';

  public static readonly CAMERA_RELATIVE_POSITION_CHANGED = 'digging_hole_camera_area';

  // Sidebar flag
  public static readonly SCREEN_SIDEBAR: string = 'isSidebar';
  // ScreeReader open flag
  public static readonly OPEN_TOUCH_GUIDE: string = 'isOpenTouchGuide';

  //scale flag
  public static readonly albumScreenScale: string = '0';

  // Column flag
  public static readonly SCREEN_COLUMNS: string = 'screen_colums';
  public static readonly ADD_NOTES_MAX_LENGTH: number = 140;
  public static readonly ADD_NOTES_MAX_LINE: number = 1;
  public static readonly FILE_SIZE_MAX_LINE: number = 2;
  public static readonly ADD_NOTES_SHOW_COUNTER_SCALE: number = 0.9;
  public static readonly EQUIVALENT_LENS_FOCAL_LENGTH: number = 35;
  public static readonly RENAME_MAX_LENGTH: number = 82;
  public static readonly ENTRY_FROM_NONE: number = 0;
  public static readonly ENTRY_FROM_CAMERA: number = 1;
  public static readonly ENTRY_FROM_SINGLE_SELECT: number = 2;
  public static readonly ENTRY_FROM_MULTIPLE_SELECT: number = 3;
  public static readonly ENTRY_FROM_RECYCLE: number = 4;
  public static readonly ENTRY_FROM_DISTRIBUTED: number = 5;
  public static readonly ENTRY_FROM_NORMAL: number = 6;
  public static readonly ENTRY_FROM_FORM_ABILITY: number = 7;
  public static readonly ENTRY_FROM_FORM_FORM_EDITOR: number = 8;
  public static readonly ENTRY_FROM_VIEW_DATA: number = 9;
  public static readonly ENTRY_FROM_PETALCLIP: number = 10;
  public static readonly ENTRY_FROM_FORM_DEFAULT_ABILITY: number = 11;
  public static readonly ENTRY_FROM_THIRD_CAMERA_ADD: number = 12;
  public static readonly ENTRY_FROM_HIDDEN: number = 16;
  public static readonly ENTRY_FROM_GLOBAL_SEARCH: number = 14;
  public static readonly ENTRY_FROM_FILE_MANAGER: number = 15;
  public static readonly ENTRY_FROM_THIRD_CAMERA_TO_PORTRAIT_ALBUM: number = 16;
  public static readonly ENTRY_FROM_THIRD_CAMERA_TO_LOCATION_ALBUM: number = 20;
  public static readonly ENTRY_FROM_THIRD_CAMERA_TO_COMPARE: number = 18;
  public static readonly ENTRY_FROM_THIRD_CAMERA_TO_SETTING: number = 17;
  public static readonly ENTRY_FROM_PROTOTYPE_EXPERIENCE_APP: number = 19;
  public static readonly ENTRY_FROM_HIGHLIGHT_CARD: number = 22;
  public static readonly PHOTO_DETAIL_NOTE_SPACE_INNER: number = 4;
  public static readonly PHOTO_DETAIL_SYMBOL_SPACE: number = 6;
  public static readonly PHOTO_DETAIL_NOTE_SPACE_OUTER: number = 12;
  public static readonly ENTRY_FROM = EntryFromConstants;
  public static readonly DIALOG_BOTTOM_OFFSET: number = 16;
  public static readonly ENTRY_FROM_FORM_PROFILE_TO_PORTRAIT_ALBUM: number = 24;
  public static readonly ENTRY_FROM_FORM_ABILITY_PORTRAIT = 25;

  // Local tab index
  public static readonly LOCAL_TAB_INDEX: number = 0;

  // Other equipment tab index
  public static readonly OTHER_EQUIPMENT_TAB_INDEX: number = 1;

  // editor used
  public static readonly UPDATE_MENU: string = 'updateMenu';
  public static readonly UPDATE_DOODLE_STYLE: string = 'update_doodle_style';
  public static readonly ADJUST_PARAMS_VALUE_CHANGED: string = 'adjust_params_value_changed';
  public static readonly ADJUST_PARAMS_ID_CHANGED: string = 'adjust_params_id_changed';
  public static readonly IS_IMMERSIVE: string = 'is_immersive';
  public static readonly UPDATE_DOODLE_STROKE_STYLE: string = 'update_doodle_stroke_style';
  public static readonly PHOTO_EDITOR_MANAGER: string = 'photo_editor_manager';
  public static readonly PHOTO_EDITOR_EVENT_MANAGER: string = 'photo_editor_event_manager';
  public static readonly INTI_RULER: string = 'inti_ruler';
  public static readonly RULER_CHANGED: string = 'inti_ruler';
  public static readonly LABEL_STYLE_CHANGED: string = 'label_style_changed';
  public static readonly LABEL_TEXT_STYLE_CHANGED: string = 'label_text_style_changed';
  public static readonly LABEL_TEXT_COLOR_CHANGED: string = 'label_text_color_changed';
  public static readonly LABEL_GET_CLIP_RECT: string = 'label_get_clip_rect';
  public static readonly CROP_RESET_CLICKED: string = 'crop_reset_clicked';
  public static readonly IS_BIG_TEXT_SHOW: string = 'is_big_text_show';
  public static readonly RULER_BAR_INTI: string = 'ruler_bar_inti';
  public static readonly COLOR_SLIDER_CHANGED: string = 'color_slider_changed';
  public static readonly MOSAIC_STYLE_CHANGED: string = 'mosaic_style_changed';
  public static readonly LABEL_DELETE: string = 'label_delete';
  public static readonly UPDATE_LABEL_STYLE: string = 'update_label_style';
  public static readonly IS_LABEL_ACTIVE: string = 'is_label_active';
  public static readonly NOT_MAX_INDEX_CLICK_OF_LABEL: string = 'not_max_index_click_of_label';
  public static readonly IS_LABEL_MODE: string = 'is_label_mode';
  public static readonly RESET_LABEL_STYLE_INFO: string = 'reset_label_style_info';
  public static readonly UPDATE_TOUCH_EVENT: string = 'update_touch_event';
  public static readonly PHOTO_COLLAGE_MANAGER: string = 'photo_collage_manager';
  public static readonly RETURN_TO_MAIN: string = 'return_to_main';
  public static readonly FORM_ITEM_NAME: string = 'form_itemName';
  public static readonly FORM_ITEM_ALBUM_ID: string = 'form_itemAlbumId';
  public static readonly FORM_ITEM_DISPLAY_NAME: string = 'form_itemDisplayName';
  public static readonly MAIN_WINDOW: string = 'mainWindow';
  public static readonly ACTION_URI_FORM_ABILITY: string = 'formAbility';
  public static readonly ACTION_URI_FORM_ABILITY_NONE: string = 'formAbilityNone';
  public static readonly ACTION_URI_FORM_ABILITY_PROFILE: string = 'formAbilityProfile';
  public static readonly ACTION_URI_FORM_ABILITY_PORTRAIT: string = 'formAbilityPortrait';
  public static readonly PROGRESS_LENGTH_DIFF: number = 88;
  public static readonly ALBUM_NAME_MAX_LENGTH: number = 80;
  public static readonly BACK_FROM_FORM_DETAIL: string = 'back_from_form_detail';
  public static readonly RULER_CONTEXT_FONT_10PX: string = '10px SimSun, Songti SC';
  public static readonly RULER_CONTEXT_FONT_20PX: string = '20px SimSun, Songti SC';
  public static readonly RULER_CONTEXT_FONT_25PX: string = '25px SimSun, Songti SC';
  public static readonly RULER_CONTEXT_FONT_30PX: string = '30px SimSun, Songti SC';
  public static readonly RULER_CONTEXT_FONT_35PX: string = '35px SimSun, Songti SC';
  public static readonly RULER_FILL_STYLE_100: string = '#FFFFFF';
  public static readonly RULER_FILL_STYLE_90: string = '#E5FFFFFF';
  public static readonly RULER_FILL_STYLE_40: string = '#66FFFFFF';
  public static readonly RULER_FILL_STYLE_30: string = '#4dffffff';
  public static readonly RULER_FILL_STYLE_20: string = '#33ffffff';
  public static readonly RULER_FILL_STYLE_10: string = '#1affffff';
  public static readonly COLOR_TRANSPARENT: string = '#00000000';
  public static readonly RULER_TEXT_ALIGN: string = 'center';
  public static readonly STATUS_BAR_BACKGROUND_COLOR: string = '#F1F3F5';
  public static readonly STATUS_BAR_CONTENT_COLOR: string = '#000000';
  public static readonly TOP_BAR_SIZE: number = 56;
  public static readonly TOOL_BAR_SIZE: number = 72;
  public static readonly BOTTOM_TOOL_BAR_SIZE: number = 196;
  public static readonly FILTER_BOTTOM_TOOL_BAR_SIZE: number = 232;
  public static readonly DEFAULT_WIDTH: number = 360;
  public static readonly VERDE_SWIPER_PADDING_BOTTOM: number = 52;
  public static readonly RESET_SIZE: number = 20;
  public static readonly RESET_SIZE_HORIZONTAL: number = 48;
  public static readonly TIMEOUT: number = 50;
  public static readonly PADDING_VERTICAL: number = 140;
  public static readonly PADDING_HORIZONTAL: number = 160;
  public static readonly MID_LINE_WIDTH: number = 1.5;
  public static readonly MID_LINE_HEIGHT: number = 18;
  public static readonly RULER_LINE_WIDTH: number = 1;
  public static readonly EDGE_ANGLE: number = 45;
  public static readonly LITTLE_CANVAS_SIZE: number = 60;
  public static readonly SHARE_BROWSER_ADD_MEDIA_URI: string = 'share_browser_add_media_uri';
  // Large directly enter AI editing
  public static readonly PHOTO_DIRECTLY_ENTER_AI_EDITING: string = 'is_entry_ai_edit';
  //Large directly enter XTStyle
  public static readonly PHOTO_DIRECTLY_ENTER_XTSTYLE: string = 'is_entry_XTStyle';
  public static readonly IS_SHOW_LOCATION_GRID: string = 'isShowLocationGrid';

  // Grid Constants
  public static readonly TAB_BAR_WIDTH: number = 240;
  public static readonly PAD_TAB_BAR_WIDTH: number = 96;
  public static readonly GRID_GUTTER: number = 2;
  public static readonly PC_GRID_GUTTER: number = 16;
  public static readonly PC_CARD_GRID_GUTTER: number = 132;
  public static readonly PC_GRID_SMALL_WIDTH: number = 340;
  public static readonly PC_GRID_MEDIUN_WIDTH: number = 80;
  public static readonly PC_GRID_LARGE_WIDTH: number = 500;
  public static readonly PC_GRID_DIVISOR_WIDTH: number = 420;
  public static readonly PC_GRID_MARGIN_TOP: number = 8;
  public static readonly TV_GRID_GUTTER: number = 32;
  public static readonly TV_FIRST_ROW_HEIGHT: number = 133;
  public static readonly TV_GRID_ITEM_OVERLAY_WIDTH: number = 142;
  public static readonly TV_GRID_ITEM_OVERLAY_HEIGHT: number = 53;
  public static readonly TV_SWIPER_PADDING_BOTTOM: number = 32;
  public static readonly TV_TOTAL_WINDOW_HEIGHT: number = 720;
  public static readonly TV_TOTAL_WINDOW_WIDTH: number = 1280;
  public static readonly TV_DETAIL_WIDTH: number = 416;
  public static readonly TV_PHOTO_PROPERTIES_GAP = 32;
  public static readonly TV_PHOTO_PROPERTIES_TEXT_INPUT_HEIGHT: number = 64;
  public static readonly TV_PHOTO_PROPERTIES_BORDER_WIDTH: number = 0.7;
  public static readonly TV_PHOTO_DETAIL_IMAGE_INFO_PADDING: number = 1.3;
  public static readonly TV_PHOTO_TITLE_EDIT_HEIGHT: number = 36;
  public static readonly TV_PHOTO_DETAIL_TEXT_INFO_SIZE: number = 13;
  public static readonly TV_HISTOGRAM_HEIGHT: number = 130;
  public static readonly TV_HISTOGRAM_WIDTH: number = 320;
  public static readonly TV_PHOTO_DETAIL_TEXT_LINE_HEIGHT: number = 21;
  public static readonly TV_PLAY_BUTTON_WIDTH_HEIGHT: number = 64;
  public static readonly GRID_IMAGE_SIZE: number = 256;
  public static readonly GRID_MAX_SIZE_RATIO: number = 1.2;
  public static readonly GRID_MIN_COUNT: number = 4;
  public static readonly SCROLL_BAR_SIDE_MIN_GAP: number = 12;
  public static readonly SCROLL_MARGIN: number = 24;
  public static readonly SCROLL_BAR_CLICKING: string = 'SCROLL_BAR_CLICKING';
  public static readonly gridLargeNum: number = 2;
  public static readonly gridSmallNum: number = 3;
  public static readonly gridSmallScale: number = 0.5;
  public static readonly gridDefaultScale: number = 1;
  public static readonly gridLargeScale: number = 2;
  public static readonly defaultScale: number = 1;
  public static readonly albumStyleSwitchDuration: number = 350;
  public static readonly albumStyleSmoothDuration: number = 300;
  public static readonly albumItemSmoothDuration: number = 500;
  public static readonly responsiveResponse: number = 0.15;
  public static readonly responsiveDamping: number = 0.86;
  public static readonly responsiveDuration: number = 0.25;
  public static readonly albumDefaultScale: number = 0;
  public static readonly albumLargeScale: number = 1;
  public static readonly animationLargeScale: number = 1.04;
  public static readonly animationSmallScale: number = 0.95;
  public static readonly gridLargeAnimation: number = 1.01;
  public static readonly gridSmallAnimation: number = 0.99;
  public static readonly albumSmallThreshold: number = 0.67;
  public static readonly albumLargeThreshold: number = 1.33;
  public static readonly CONTAINER_BORDER_WIDTH: number = 1;
  public static readonly CONTENT_PADDING: number = 4;
  public static readonly GRID_ZOOMIN_MAGNITUDE: number = 1.25;
  public static readonly GRID_ZOOMOUT_MAGNITUDE: number = 0.8;
  public static readonly GRID_DAY_FLING_SPEED: number = 8000;
  public static readonly GRID_MONTH_FLING_SPEED: number = 10000;
  public static readonly GRID_YEAR_FLING_SPEED: number = 5000;
  public static readonly GRID_PICKER_FLING_SPEED: number = 5000;
  public static readonly GRID_YEAR_FLING_SPEED_HORIZONTAL: number = 2000;
  public static readonly TOOLBAR_ANIMATE_DURATION: number = 350;

  // Column Constants
  public static readonly COLUMN_MARGIN: number = 16;
  public static readonly COLUMN_GUTTER: number = 16;
  public static readonly COLUMN_MARGIN_FOUR = 16;
  public static readonly COLUMN_GUTTER_FOUR = 8;
  public static readonly COLUMN_MARGIN_SIX = 24;
  public static readonly COLUMN_GUTTER_SIX = 12;
  public static readonly COLUMN_MARGIN_EIGHT = 32;
  public static readonly COLUMN_GUTTER_EIGHT = 16;
  public static readonly COLUMN_MARGIN_TWELVE = 40;
  public static readonly COLUMN_GUTTER_TWELVE = 20;

  // Album Card Constants
  public static readonly CARD_ASPECT_RATIO: number = 1;
  public static readonly ALBUM_SET_NEW_ICON_SIZE: number = 22;
  public static readonly ALBUM_SET_NEW_ICON_MARGIN: number = 8;
  public static readonly ALBUM_SET_MARGIN: number = 12;
  public static readonly ALBUM_SET_GUTTER: number = 12;
  public static readonly ALBUM_SET_COVER_SIZE: number = 150;
  public static readonly ALBUM_NAME_HEIGHT: number = 40;
  public static readonly ALBUM_DIVIDER_HEIGHT: number = 20;
  public static readonly ALBUM_EXPAND_HEIGHT: number = 58;
  public static readonly MORE_ALBUM_HEIGHT: number = 44; // 4 + 4 + 24 + 12
  public static readonly RECYCLE_ALBUM_OF_PHONE_HEIGHT: number = 88;

  // System Resource Constants
  public static readonly TEXT_SIZE_SUB_TITLE1: number = 18; // ohos_id_text_size_sub_title1
  public static readonly TEXT_SIZE_BODY2: number = 14; // ohos_id_text_size_body2
  public static readonly TEXT_SIZE_SUB_TITLE2: number = 16; // ohos_id_text_size_sub_title2

  // Empty Page
  public static readonly EMPTY_PAGE_OFFSET_RADIO: number = 0.4;
  public static readonly EMPTY_PAGE_OFFSET_BIG_RADIO: number = 0.5;
  public static readonly EMPTY_PAGE_DEFAULT_OFFSET: number = 300;
  public static readonly EMPTY_PAGE_MARGIN: number = 12;
  public static readonly DETAILS_DIALOG_PATH_MAX_LINE: number = 7;
  public static readonly DETAILS_DIALOG_NAME_MAX_LINE: number = 5;
  public static readonly BIG_SCREEN_WIDTH: number = 600;
  public static readonly BIG_EMPTY_ICON_SIZE: number = 160;
  public static readonly SMALL_EMPTY_ICON_SIZE: number = 120;
  public static readonly EMPTY_ICON_SIZE: number = 120;
  public static readonly LOCK_PAGE_OFFSET_RADIO: number = 0.4;
  public static readonly LOCK_IMAGE_HEIGHT: number = 72;
  public static readonly LOCK_DISTANCE_SCREEN_RATIO: number = 0.5;
  public static readonly HIDE_DIALOG_BOTTOM: number = 32;
  public static readonly PHOTO_GRID_PADDING_TOP: number = 8;

  // Menu
  public static readonly MENU_DIVIDER_STROKE_WIDTH: string = '1px';
  public static readonly MENU_ITEM_WIDTH_PC: number = 216;
  public static readonly FORTH_MENU_ITEM_WIDTH_PC: number = 192;
  public static readonly MENU_ITEM_WIDTH_PHONE: number = 216;
  public static readonly MENU_ITEM_HEIGHT_PC: number = 40;
  public static readonly MENU_ITEM_HEIGHT_PHONE: number = 48;

  // Double click time delay
  public static readonly DOUBLE_CLICK_GAP: number = 300;

  // Empty page picture size
  public static readonly EMPTY_PAGE_PIC_SIZE: number = 120;

  // Button status
  public static readonly BUTTON_STATUS_NORMAL: string = 'NORMAL';
  public static readonly BUTTON_STATUS_HOVER: string = 'HOVER';
  public static readonly BUTTON_STATUS_PRESS: string = 'PRESS';
  public static readonly BUTTON_STATUS_DISABLE: string = 'DISABLE';
  public static readonly BUTTON_STATUS_FOCUS: string = 'FOCUS';

  // Video status
  public static readonly VIDEO_STATUS_INITIAL: string = 'initial';
  public static readonly VIDEO_STATUS_PLAYING: string = 'playing';
  public static readonly VIDEO_STATUS_PAUSE: string = 'pause';
  public static readonly VIDEO_STATUS_FINISH: string = 'finish';
  public static readonly VIDEO_STATUS_ERROR: string = 'error';

  // Edit rulerBar line length
  public static readonly EDITOR_MIDDLE_TICK_LINE_HEIGHT: number = 8;
  public static readonly EDITOR_SMALL_TICK_LINE_HEIGHT: number = 4;
  public static readonly EDITOR_LARGE_TICK_LINE_HEIGHT: number = 18;

  // Angle
  public static readonly ANGLE_360: number = 360;
  public static readonly ANGLE_270: number = 270;
  public static readonly ANGLE_180: number = 180;
  public static readonly ANGLE_90: number = 90;

  // Button set-gray transparency
  public static readonly BUTTON_INVALID_OPACITY: number = 0.4;

  // Device album page minimal column count
  public static readonly PAD_ALBUM_GRID_COLUMN_MIN_COUNT: number = 1;
  public static readonly DEFAULT_ALBUM_GRID_COLUMN_MIN_COUNT: number = 2;

  // Maximum recycle days
  public static readonly RECYCLE_DAYS_MAX: number = 30;
  public static readonly RECYCLE_DAYS_WARN: number = 3;

  // Keys of photo detail text
  public static readonly KEY_FOR_AUTO_TEST_TITLE: string = 'DetailTitle';
  public static readonly KEY_FOR_AUTO_TEST_TIME: string = 'DetailTime';
  public static readonly KEY_FOR_AUTO_TEST_SIZE: string = 'DetailSize';
  public static readonly KEY_FOR_AUTO_TEST_RESOLUTION: string = 'DetailResolution';
  public static readonly KEY_FOR_AUTO_TEST_DURATION: string = 'DetailDuration';
  public static readonly KEY_FOR_AUTO_TEST_PATH: string = 'DetailPath';

  // Properties of edit page
  public static readonly PUNCH_HOLE_HEIGHT: number = 30;
  public static readonly ACTION_BUTTON_WIDTH: number = 60;
  public static readonly ACTION_BUTTON_HEIGHT: number = 79.5;
  public static readonly CROP_RULER_WIDTH: number = 78;
  public static readonly CROP_STYLE_BAR: number = 40;
  // 横屏状态下编辑页各组件的属性
  public static readonly HORIZONTAL_RESET_BUTTON_WIDTH: number = 35;
  public static readonly HORIZONTAL_RESET_BUTTON_HEIGHT: number = 24;
  public static readonly HORIZONTAL_RESET_BUTTON_MARGIN: number = 5;
  public static readonly HORIZONTAL_CROP_STYLE_BAR_HEIGHT: number = 70;
  public static readonly HORIZONTAL_CROP_RULER_WIDTH: number = 70;
  public static readonly HORIZONTAL_RESET_BUTTON_TEXT_SIZE: number = 17.5;
  public static readonly HORIZONTAL_TOOL_BAR_WIDTH: number = 70;
  public static readonly HORIZONTAL_TOOL_BAR_HEIGHT: number = 97.5;
  public static readonly HORIZONTAL_MAIN_MENU_WIDTH: number = 277.5;
  public static readonly HORIZONTAL_CROP_STYLE_BAR_TOP_PADDING: number = 15;
  public static readonly HORIZONTAL_CROP_STYLE_BAR_BOTTOM_PADDING: number = 15;
  public static readonly HORIZONTAL_CROP_STYLE_BAR_LEFT_PADDING: number = 20;
  public static readonly HORIZONTAL_CROP_STYLE_BAR_RIGHT_PADDING: number = 20;
  public static readonly HORIZONTAL_ACTION_BUTTON_WIDTH: number = 30;
  public static readonly HORIZONTAL_ACTION_BUTTON_HEIGHT: number = 50;
  public static readonly HORIZONTAL_ACTION_BUTTON_LEFT_MARGIN: number = 27.5;
  public static readonly HORIZONTAL_ACTION_BUTTON_LEFT_PADDING: number = 25.5;
  public static readonly HORIZONTAL_RULER_COMPONENT_WIDTH: number = 97.5;
  public static readonly HORIZONTAL_CROP_RULER_MARGIN: number = 27;
  public static readonly HORIZONTAL_OUTSIDE_ACTION_BUTTON_CONTAINER_HEIGHT: number = 90;
  public static readonly HORIZONTAL_OUTSIDE_ACTION_BUTTON_CONTAINER_WIDTH: number = 81;
  // 竖屏状态下编辑页各组件的属性
  public static readonly VERTICAL_RESET_BUTTON_HEIGHT: number = 19;
  public static readonly VERTICAL_RESET_BUTTON_TEXT_SIZE: number = 14;
  public static readonly VERTICAL_RESET_BUTTON_MARGIN: number = 6;
  public static readonly VERTICAL_CROP_STYLE_BAR_HEIGHT: number = 56;
  public static readonly VERTICAL_RULER_COMPONENT_HEIGHT: number = 60;
  public static readonly VERTICAL_TOOL_BAR_WIDTH: number = 104;
  public static readonly VERTICAL_TOOL_BAR_HEIGHT: number = 72;
  public static readonly VERTICAL_MAIN_MENU_BAR_HEIGHT: number = 219;
  public static readonly VERTICAL_CROP_STYLE_BAR_TOP_PADDING: number = 16;
  public static readonly VERTICAL_CROP_STYLE_BAR_BOTTOM_PADDING: number = 16;
  public static readonly VERTICAL_CROP_STYLE_BAR_LEFT_PADDING: number = 24;
  public static readonly VERTICAL_CROP_STYLE_BAR_RIGHT_PADDING: number = 24;
  public static readonly VERTICAL_OUTSIDE_ACTION_BUTTON_CONTAINER_HEIGHT: number = 60;
  public static readonly TV_VERTICAL_OUTSIDE_ACTION_BUTTON_CONTAINER_HEIGHT: number = 80;
  public static readonly VERTICAL_OUTSIDE_ACTION_BUTTON_CONTAINER_WIDTH: number = 79.5;

  // Types and minimal screen size of breakpoints
  public static readonly BREAKPOINT_XS: string = 'xs'; // The screen size ranges from 0 to 320.excluding 320.
  public static readonly BREAKPOINT_XS_MIN_SIZE: number = 0;
  public static readonly BREAKPOINT_SM: string = 'sm'; // The screen size ranges from 320 to 520.excluding 520.
  public static readonly BREAKPOINT_SM_MIN_SIZE: number = 320;
  public static readonly BREAKPOINT_MD: string = 'md'; // The screen size ranges from 520 to 840.excluding 840.
  public static readonly BREAKPOINT_MD_MIN_SIZE: number = 520;
  public static readonly BREAKPOINT_LG: string = 'lg'; // The screen size is greater than or equal to 840.
  public static readonly BREAKPOINT_LG_MIN_SIZE: number = 840;
  public static readonly WINDOW_TO_DISPLAY_RATIO: number = 0.67;
  public static readonly PERCENT_100: string = '100%';
  public static readonly PERCENT_50: string = '50%';
  public static readonly PERCENT_55: string = '55%';
  public static readonly PERCENT_0: string = '0%';
  public static readonly SINGLE_TITLE_WIDTH: number = 0;
  public static readonly SINGLE_TITLE_FLEX_BASIS: number = 328;
  public static readonly DEFAULT_DIVIDER_COLOR: string = 'rgb(207, 195, 195)';
  public static readonly DEFAULT_DIVIDER_HEIGHT: string = '24vp';
  public static readonly PHOTOS_STORE_KEY: string = 'PhotosStore';
  public static readonly LOCAL_KEY_PREFERENCES: string = 'com.ohos.photos.common.preferences';
  public static readonly PREFERENCES_KEY_LAST_PAGE: string = 'lastPage';
  public static readonly PHOTOS_PERMISSION_FLAG: string = 'PhotosPermissionFlag';
  public static readonly PHOTOS_CNT_FOR_HIDE_SCROLL_BAR: number = 100;
  public static readonly GROUP_PHOTOS_CNT_FOR_HIDE_SCROLL_BAR: number = 200;
  public static readonly PC_PHOTOS_CNT_FOR_HIDE_SCROLL_BAR: number = 0;
  public static readonly PHOTO_PROPERTIES_TRANSLATE_Y: string = '107vp';
  public static readonly PERCENT_NEGATIVE_50 = '-50%';
  public static readonly PERCENT_NEGATIVE_25 = '-25%';

  public static readonly FOCAL_LENGTH_35: number = 35;

  // First delete flag
  public static readonly IS_FIRST_TIME_DELETE: string = 'isFirstTimeDelete';

  // First hide flag
  public static readonly IS_CLOSE_TIP: string = 'isCloseTip';

  // Media operation from page
  public static readonly MEDIA_OPERATION_FROM_TIMELINE: string = 'FromTimelinePage';
  public static readonly MEDIA_OPERATION_FROM_PHOTO_GRID: string = 'FromPhotoGridPage';
  public static readonly MEDIA_OPERATION_FROM_HIDDEN_PHOTO_GRID: string = 'FromHiddenGridPage';
  public static readonly MEDIA_OPERATION_FROM_THIRD_CAMERA_ADD: string = 'FromThirdCameraAdd';
  public static readonly MEDIA_OPERATION_FROM_PHOTO_BROWSER: string = 'FromPhotoBrowser';
  public static readonly MOUSE_TURN_PAGE_BUTTON_DISAPPEAR_TIMEOUT: number = 2000;

  // AppStorage Key
  public static readonly KEY_OF_PHOTO_HIDDEN_GRID_VIEW_OPACITY: string = 'hiddenGridViewOpacity';
  public static readonly KEY_OF_SELECTED_HIDDEN_ALBUM_INDEX: string = 'selectHiddenAlbumIndex';
  public static readonly KEY_OF_SELECTED_HIDDEN_ALBUM_URI: string = 'selectHiddenAlbumUri';
  public static readonly CONFIRM_TEXT_KEY: string = 'confirmText';
  public static readonly KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM: string = 'photoGridViewAlbumItem';
  public static readonly KEY_OF_IS_FROM_FA_CARD: string = 'isFromFACard';
  public static readonly KEY_OF_PHOTO_HIDDEN_GRID_VIEW_ALBUM_ITEM: string = 'photoHiddenGridViewAlbumItem';
  public static readonly KEY_OF_ALBUM_ID: string = 'albumId'; // Waiting: API10整改完成后删除
  public static readonly KEY_OF_ALBUM_URI: string = 'albumUri';
  public static readonly KEY_OF_GEOMETRY_TRANSITION_ID_HEIGHT: string = 'geometryTransitionId';
  public static readonly KEY_OF_PLACE_HOLDER_INDEX: string = 'placeHolderIndex';
  public static readonly KEY_OF_SELECTED_ALBUM_INDEX: string = 'selectedAlbumIndex';
  public static readonly KEY_OF_IS_SHOW_PHOTO_GRID_VIEW: string = 'isShowPhotoGridView';
  public static readonly KEY_OF_IS_PHOTO_CITY_GRID: string = 'isPhotoCityGrid';
  public static readonly KEY_OF_IS_SHOW_CITY_GRID_VIEW: string = 'isShowCityGridView';
  public static readonly KEY_OF_PHOTO_COUNT_IN_ALBUM: string = 'photoCount';
  public static readonly KEY_OF_ALBUM_ACTIONBAR_OPACITY: string = 'albumActionBarOpacity';
  public static readonly KEY_OF_PHOTO_GRID_ACTIONBAR_OPACITY: string = 'photoGridActionBarOpacity';
  public static readonly KEY_OF_SIDE_BAR_OPACITY: string = 'sideBarOpacity';
  public static readonly KEY_OF_IS_FIRST_PHOTO_ITEM: string = 'isFirstPhotoItem';
  public static readonly KEY_OF_IS_FROM_CATEGORY: string = 'isFromCategory';
  public static readonly KEY_OF_IS_FROM_SHOOT_VIEW: string = 'isFromShootView';
  public static readonly KEY_OF_IS_FROM_CITY_ALBUM: string = 'isFromCityAlbum';
  public static readonly KEY_OF_SELECTED_ALBUM_ID: string = 'selectedAlbumId'; // Waiting: API10整改完成后删除
  public static readonly KEY_OF_SELECTED_ALBUM_URI: string = 'selectedAlbumUri';
  public static readonly KEY_OF_PHOTO_GRID_VIEW_OPACITY: string = 'photoGridViewOpacity';
  public static readonly KEY_OF_ALBUM_OPACITY: string = 'albumOpacity';
  public static readonly KEY_OF_ALBUM_OTHER_SCALE: string = 'albumOtherScale';
  public static readonly KEY_OF_PHOTO_GRID_VIEW_SCALE: string = 'photoGridViewScale';
  public static readonly KEY_OF_IS_SHOW_VIDEO_MASK: string = 'isShowVideoMask';
  public static readonly KEY_OF_SIDE_BAR_BOUNDARY_LINE_OPACITY: string = 'sideBarBoundaryLineOpacity';
  public static readonly KEY_OF_IS_DOING_GEOMETRY_TRANSITION_ANIMATION: string = 'isDoingGeometryTransitionAnimation';
  public static readonly KEY_OF_IS_THIRD_EDITABLE: string = 'isThirdEditAble';
  public static readonly KEY_OF_HIDDEN_POSITION: string = 'hiddenPosition';
  public static readonly KEY_OF_UNHIDDEN_POSITION: string = 'unHiddenPosition';
  public static readonly KEY_OF_MAP_DIAMETER: string = 'locationDiameter';
  public static readonly KEY_OF_MARKER_REFRESH: string = 'markerRefresh';
  public static readonly KEY_OF_BURST_PHOTOS_URI: string = 'saveBurstPhotosUri';
  public static readonly KEY_OF_IS_DELETED_BURST_PHOTOS: string = 'isDeletedBurstPhotos';
  public static readonly KEY_OF_GRID_HIGHT0_SIZE_RECODE: string = 'gridHight0SizeRecode';
  public static readonly KEY_OF_IS_BLACK_BG: string = 'isBlackBg';
  public static readonly KEY_OF_GRID_SCROLL_ENABLED: string = 'isPageScrollEnabled';

  // album hidden properties
  public static readonly KEY_OF_IS_SHOW_PHOTO_HIDDEN_VIEW: string = 'isShowPhotoHiddenView';
  public static readonly KEY_OF_IS_SHOW_HIDDEN_GRID_VIEW: string = 'isShowHiddenGridView';
  public static readonly KEY_OF_ALBUM_SWITCH_STYLE: string = 'hiddenAlbumSwitchStyle';
  public static readonly kEY_OF_HIDDEN_GRID_DATA_CHANGE: string = 'hiddenGridDataChange';

  //album hidden animate
  public static readonly HIDDEN_OPACITY_DURATION = 300;
  public static readonly HIDDEN_OPACITY_DELAY_DURATION = 50;
  public static readonly HIDDEN_ICON_SCALE_DURATION = 250;
  public static readonly HIDDEN_ICON_SCALE = 1.5;

  // album Classifieds properties
  public static readonly KEY_OF_IS_SHOW_PHOTO_CLASSIFIEDS: string = 'isShowPhotoClassifieds';
  public static readonly KEY_OF_IS_SHOW_CATEGORY_ALBUM_VIEW_GRID: string = 'isShowCategoryAlbumViewGrid';
  public static readonly KEY_OF_CATEGORY_ACTION_BAR_OPACITY: string = 'categoryActionBarOpacity';
  public static readonly KEY_OF_CATEGORY_VIEW_GRID_OPACITY: string = 'categoryViewGridOpacity';

  // album Shooting properties
  public static readonly KEY_OF_SHOOT_ACTION_BAR_OPACITY: string = 'ShootActionBarOpacity';
  public static readonly KEY_OF_SHOOT_VIEW_GRID_OPACITY: string = 'ShootViewGridOpacity';

  // faCard key
  public static readonly KEY_OF_VIDEO_PLAY_CTRL_RESET_ONCE: string = 'videoPlayControllerResetOnce';
  public static readonly KEY_OF_MARK_NEW_WANT_IS_NOT_FROM_FA_CARD: string = 'markNewWantIsNotFromFaCard';
  public static readonly KEY_OF_MARK_NEW_WANT_IS_NOT_FROM_MOMENT_CARD: string = 'markNewWantIsNotFromMomentCard';
  public static readonly KEY_OF_MARK_JUMP_TO_HIGHLIGHT_DIRECTLY: string = 'markJumpToHighlightPageDirectly';
  public static readonly KEY_OF_HIGHLIGHT_ALBUM_FROM_FA_CARD: string = 'highlightAlbumItemFromFaCard';
  public static readonly DELETED_FORM_IDS: string = 'deleted_form_ids';
  public static readonly IS_FROM_FORM_ABILITY_PROFILE: string = 'isFromFormAbilityProfile';
  public static readonly IS_FROM_FORM_ABILITY_PORTRAIT: string = 'isFromFormAbilityPortrait';
  public static readonly PHOTO_GRID_BASE_PAGE_APPEAR: string = 'photoGridBasePageAppear';
  public static readonly PHOTO_BROWSER_COMPONENT_APPEAR: string = 'photoBrowserComponentAppear';
  public static readonly FORM_PRE_CONFIGURATION: string = 'formPreConfiguration';
  public static readonly FROM_FACARD_POPUP_OFF: string = 'fromFacardPopupOff';

  public static readonly KEY_OF_REFRESH_FA_CARD_ID: string = 'formRefreshCurrentId';

  public static readonly KEY_OF_SNAPSHOT_ACTUAL_URI: string = 'snapshotActualUri';
  public static readonly KEY_OF_SNAPSHOT_ACTUAL_ALT: string = 'snapshotActualAlt';


  // picker restore scene
  public static readonly KEY_OF_RECOVER_FIRST_GRID_INDEX: string = 'recoverFirstGridIndex';
  public static readonly KEY_OF_RECOVER_GRID_ROW_COUNT: string = 'recoverGridRowCount';
  public static readonly KEY_OF_RECOVER_LAST_GRID_INDEX: string = 'recoverLastGridIndex';
  public static readonly KEY_OF_RECOVER_ALBUM_URI: string = 'albumUriForRecover';
  public static readonly KEY_OF_RECOVER_SELECTED_RECOMMEND_TYPE: string = 'recoverSelectedRecommendType';
  public static readonly IS_RECOVER_IN_ALBUM_PAGE: string = 'isRecoverInAlbumPage';
  public static readonly PICKER_ALL_PHOTOS_SHEET: string = 'allPhotos';
  public static readonly DISABLE_SCROLL_TO_ANCHOR: string = 'disableScrollToAnchor';
  public static readonly DELAY_TO_ENTER_ALBUM_ON_RECOVER: number = 250;

  // Properties of image Properties component
  public static readonly PHOTO_DETAIL_MODEL_AND_SUFFIX_MARGIN: number = 4;
  public static readonly TV_PHOTO_DETAIL_MODEL_AND_SUFFIX_MARGIN: number = 5;
  public static readonly PHOTO_PROPERTIES_LEFT: number = 16;
  public static readonly PHOTO_PROPERTIES_RIGHT: number = 16;
  public static readonly PHOTO_DETAIL_INPUT_RADIUS: number = 0;
  public static readonly PHOTO_DETAIL_NOTE_MARGIN_UP: number = 4;
  public static readonly PHOTO_DETAIL_NOTE_MARGIN_DOWN: number = 4;
  public static readonly PHOTO_DETAIL_NOTE_PADDING_TOP_PC: number = 74;
  public static readonly PHOTO_DETAIL_NOTE_PADDING_UP: number = 12;
  public static readonly PHOTO_DETAIL_NOTE_PADDING_DOWN: number = 12;
  public static readonly PHOTO_DETAIL_NOTE_PC_PADDING: number = 0;
  public static readonly PHOTO_DETAIL_NOTE_PC_BORDER_WIDTH: number = 2;
  public static readonly PHOTO_DETAIL_SUFFIX_LEFT_MARGIN: number = 6;
  public static readonly TV_PHOTO_DETAIL_SUFFIX_LEFT_MARGIN: number = 8;
  public static readonly PHOTO_DETAIL_NOTE_HEIGHT: number = 56;
  public static readonly PHOTO_DETAIL_IMAGE_INFO_HEIGHT: number = 16;
  public static readonly TV_PHOTO_DETAIL_IMAGE_INFO_HEIGHT: number = 21;
  public static readonly PHOTO_DETAIL_IMAGE_INFO_WIDTH: number = 16;
  public static readonly TV_PHOTO_DETAIL_IMAGE_INFO_WIDTH: number = 21;
  public static readonly PHOTO_DETAIL_PADDING_FOUR: number = 4;
  public static readonly PHOTO_DETAIL_X_MAGE_SVG_WIDTH: string = '10vp';
  public static readonly PHOTO_DETAIL_IMAGE_SVG_WIDTH: string = '12vp';
  public static readonly TV_PHOTO_DETAIL_IMAGE_SVG_WIDTH: string = '16vp';
  public static readonly PHOTO_DETAIL_IMAGE_INFO_MARGIN_LEFT: number = 8;
  public static readonly PHOTO_DETAIL_IMAGE_INFO_MARGIN_TOP: number = 8;
  public static readonly PHOTO_DETAIL_TEXT_INFO_SIZE: number = 7.5;
  public static readonly PHOTO_DETAIL_SYMBOL_TEXT_INFO_SIZE: number = 8;
  public static readonly TV_PHOTO_DETAIL_SYMBOL_TEXT_INFO_SIZE: number = 11;
  public static readonly PHOTO_DETAIL_TEXT_INFO_HEIGHT: number = 14;
  public static readonly TV_PHOTO_DETAIL_TEXT_INFO_HEIGHT: number = 19;
  public static readonly PHOTO_DETAIL_TEXT_SVG_INFO_HEIGHT: number = 10;
  public static readonly TV_PHOTO_DETAIL_TEXT_SVG_INFO_HEIGHT: number = 13;
  public static readonly PHOTO_DETAIL_TEXT_SVG_SAFE_PADDING: number = 1;
  public static readonly PHOTO_DETAIL_TEXT_INFO_COLUMN_HEIGHT: number = 24;
  public static readonly TV_PHOTO_DETAIL_TEXT_INFO_COLUMN_HEIGHT: number = 32;
  public static readonly PHOTO_DETAIL_TEXT_INFO_Divider_HEIGHT: number = 14;
  public static readonly TV_PHOTO_DETAIL_TEXT_INFO_Divider_HEIGHT: number = 19;
  public static readonly PHOTO_DETAIL_TEXT_F_SIZE: number = 8;
  public static readonly TV_PHOTO_DETAIL_TEXT_F_SIZE: number = 11;
  public static readonly PHOTO_DETAIL_IMAGE_INFO_PADDING: number = 2;
  public static readonly PHOTO_DETAIL_PIC_INFO_WIDTH: number = 76;
  public static readonly PHOTO_DETAIL_NOTE_INPUT_MIN_HEIGHT: number = 56;
  public static readonly PHOTO_DETAIL_NOTE_INPUT_MIN_WEIGHT: number = 0;
  public static readonly PHOTO_DETAIL_NOTE_INPUT_MAX_HEIGHT: number = 112;
  public static readonly PHOTO_TITLE_LINE_HEIGHT: number = 19;
  public static readonly PHOTO_TITLE_EDIT_HEIGHT: number = 28;
  public static readonly PHOTO_TITLE_EDIT_LINE_HEIGHT: number = 24;
  public static readonly PHOTO_TITLE_MAX_WIDTH: number = 296;
  public static readonly EDIT_FONT_WIDTH: number = 24;
  public static readonly EDIT_FONT_HEIGHT: number = 16;
  public static readonly EDIT_FONT_SIZE: number = 12;
  public static readonly PHOTO_DATE_FONT_HEIGHT: number = 14;
  public static readonly PHOTO_DATE_TOP_MARGIN: number = 2;
  public static readonly COLUMN_RADIUS: number = 16;
  public static readonly COLUMN_PADDING: number = 12;
  public static readonly COLUMN_PADDING_TOP: number = 8;
  public static readonly COLUMN_PADDING_LEFT: number = 12;
  public static readonly COLUMN_PADDING_RIGHT: number = 12;
  public static readonly COLUMN_PADDING_BOTTOM: number = 12;
  public static readonly COLUMN_MARGIN_BOTTOM: number = 16;
  public static readonly COLUMN_ITEM_SPACING_SMALL: number = 4;
  public static readonly COLUMN_ITEM_PADDING_Y_SMALL: number = 6;
  public static readonly HISTOGRAM_HEIGHT: number = 96;
  public static readonly PHOTO_PROPERTIES_ROW_GAP: number = 16;

  // Properties of PhotoInfo edit page
  public static readonly PHOTO_EDIT_PAGE_TEXT_INPUT_HEIGHT: number = 48;
  public static readonly PHOTO_EDIT_PAGE_TEXT_INPUT_PADDING: number = 0;
  public static readonly PHOTO_EDIT_PAGE_TEXT_INPUT_RADIUS: number = 0;
  public static readonly PHOTO_EDIT_PAGE_CARD_HEIGHT: number = 56;
  public static readonly PHOTO_EDIT_PAGE_CARD_RADIUS: number = 16;
  public static readonly PHOTO_EDIT_PAGE_CARD_PADDING: number = 12;
  public static readonly PHOTO_EDIT_PAGE_CARD_TOP_MARGIN: number = 8;
  public static readonly PHOTO_EDIT_PAGE_COLUMN_GAP: number = 12;

  public static readonly PHOTO_ARTGRIDPAGE: string = 'ArtGridPage';

  public static readonly PHOTO_BAR_MULTIPLIER: number = 1.5;

  // Animation: Show image detail by click icon
  public static readonly DURATION_PHOTO_DETAIL_OPEN: number = 700;
  public static readonly DURATION_PHOTO_DETAIL_CLOSE: number = 700;


  // Histogram
  public static readonly HISTOGRAM_READY_STATUS_KEY: string = 'HistogramReadyStatus';
  public static readonly HISTOGRAM_ARRAY_BUFFER_KEY: string = 'HistogramArrayBuffer';
  public static readonly PIXEL_NUMBER: number = 256;
  public static readonly HISTOGRAM_CONSTANT_256: number = 256;
  public static readonly HISTOGRAM_CONSTANT_512: number = 512;
  public static readonly RGB_CHANNELS: number = 3;
  public static readonly RGBA_CHANNELS: number = 4;
  public static readonly HISTOGRAM_DIVIDE_LINE_NUM: number = 2;
  public static readonly HISTOGRAM_DIVIDER_REGION_NUM: number = 3;
  public static readonly HISTOGRAM_WIDTH: number = 312;
  public static readonly HISTOGRAM_RED_FILL_COLOR: string = '#FF0000';
  public static readonly HISTOGRAM_GREEN_FILL_COLOR: string = '#00FF00';
  public static readonly HISTOGRAM_BLUE_FILL_COLOR: string = '#0000FF';
  public static readonly HISTOGRAM_STROKE_WIDTH: number = 0.8;
  public static readonly HISTOGRAM_INTERNAL_STROKE_COLOR: string = '#1A000000';
  public static readonly HISTOGRAM_REGION_STROKE_COLOR: string = '#ffffff';
  public static readonly HISTOGRAM_LINE_WIDTH: number = 0.5;

  public static readonly IS_ON_SWIPER_ANIMATION: string = 'isOnSwiperAnimation';
  public static readonly NAME_PATTERN: RegExp = /[\\.\\\\/:*?"'`<>|\[\]{}]/;

  public static readonly THIRD_SELECT_ALBUM_PHOTOS_UPDATE: string = 'third_select_album_photos_update';

  // Network
  public static readonly APP_STORAGE_KEY_OF_NETWORK_AVAILABLE: string = 'networkAvailable';

  // cloud sync
  public static readonly APP_STORAGE_KEY_SYNC_STATUS: string = 'syncStatus';
  public static readonly APP_STORAGE_KEY_LAST_SYNC_TIME: string = 'latestSyncTime';
  public static readonly APP_STORAGE_KEY_IS_SYNCING: string = 'isSyncing';
  public static readonly APP_STORAGE_KEY_DOWNLOAD_PROGRESS: string = 'downloadProgress';
  public static readonly APP_STORAGE_KEY_EDITOR_DOWNLOAD_PROGRESS: string = 'editorDownloadProgress'; // 进入编辑页下载进度
  public static readonly APP_STORAGE_KEY_DOWNLOAD_FINISH: string = 'cloudDownloadFinish';
  public static readonly APP_STORAGE_KEY_CLOUD_DOWNLOAD_FINISH_STATUS: string = 'cloudDownloadFinishStatus';
  public static readonly APP_STORAGE_KEY_CLOUD_DOWNLOAD_FINISH_LIST: string = 'cloudDownloadFinishList';
  public static readonly LAST_MEDIA_COUNT_REPORT_TIME: string = 'lastMediaCountReportTime';
  public static readonly APP_IS_PHOTO_CLONE: string = 'isPhotoClone';
  public static readonly DOWNLOAD_FINISH_PERCENTAGE: number = 100;
  public static readonly DEFAULT_TIMESTAMP: number = -1;

  // 大图左右快速滑动
  public static readonly APP_STORAGE_KEY_IS_IN_FAST_MODE = 'isInFastScrollMode';

  // map album
  public static readonly OPEN_MAP_ALBUM_DIALOG_EVENT_ID: string = 'open_map_album_dialog_event_id';
  public static readonly MAP_ALBUM_NEARBY_BTN_HEIGHT: number = 40;

  // cloud enhance and moving photo's notice popup
  public static readonly APP_STORAGE_KEY_CLOUD_ENHANCE_POPUP: string = 'cloudEnhancePopup';
  public static readonly APP_STORAGE_KEY_MOVING_PHOTO_POPUP: string = 'movingPhotoPopup';
  public static readonly APP_STORAGE_KEY_POPUP_LIMITED_COUNT: number = 2;

  // 幻灯片播放标志，notice popup可以依据此判断是否展示
  public static readonly APP_STORAGE_KEY_JUMP_TO_SLIDE_SHOW_PAGE: string = 'jumpToSlideShowPage';

  /*
   * 首次引导弹框，点击“知道了”后，记录当前时间currentTime，下次询问时间为 >= currentTime + 7 * 24 * 3600s
   * 第二次弹出引导弹框，再次点击“知道了”后，更新当前时间currentTime，第三次引导弹框时间为 >= currenTime + 2 * 7 * 24 * 3600s。
   */
  public static readonly CLOUD_ENHANCE_POPUP_INTERVAL_MS: number = 7 * 24 * 3600 * 1000;

  // 当前的云增强隐私协议版本，如果变更隐私协议，可以修改这个值，则会重新弹出隐私协议同意对话框
  public static readonly CLOUD_ENHANCE_PROTOCOL_VERSION: string = '1';

  // cloud enhance
  public static readonly APP_STORAGE_KEY_CURRENT_NAV_STACK: string = 'currentNavStack';
  public static readonly APP_STORAGE_KEY_IS_PAF_INITTED: string = 'isPafInitted';
  public static readonly SYSTEM_PARM_CLOUD_ENHANCE: string = 'systemParmCloudEnhance';
  public static readonly OPEN_CE_PROTOCOL_DIALOG_EVENT_ID: string = 'open_CE_protocol_dialog_event_id';
  public static readonly CHANGE_CE_PROTOCOL_EVENT_ID: string = 'change_CE_protocol_event_id';

  // 云增强特性总配置开关
  public static readonly IS_SUPPORT_CLOUD_ENHANCE_PARAM: string = 'hw_mc.camera.enable_cloud_enhance_capture';
  public static readonly IS_SUPPORT_AUTO_CLOUD_ENHANCE_PARAM: string = 'hw_mc.camera.enable_auto_cloud_enhance_capture';
  public static readonly IS_SUPPORT_CLOUD_ENHANCE: string = 'isSupportCloudEnhance';
  public static readonly IS_SUPPORT_AUTO_CLOUD_ENHANCE: string = 'isSupportAutoCloudEnhance';
  public static readonly CLOUD_ENHANCE_EXT_URI: string =
    'datashare:///com.ohos.photos.provider.DataShare.ai_cloud_enhance';

  // heic 转 jpg 开关
  public static readonly HEIC_2_JPG_SWITCH: string = 'hw_mc.photo.heic_2_jpg';

  // 取消云增强隐私同意后，需要联动关闭云增强的开关状态
  public static readonly IS_CLOUD_ENHANCE_ENABLE: string = 'isCloudEnhanceEnable';
  public static readonly AUTO_CLOUD_ENHANCE_TYPE: string = 'autoCloudEnhanceType';

  // 分享弹窗锚点
  public static readonly SHARE_ANCHOR_POINT: string = 'shareAnchorPoint';
  // 分享弹窗锚点记录
  public static readonly SHARE_ANCHOR_POINT_RECORD: string = 'shareAnchorPointRecord';
  // 分享按钮组件锚点的值
  public static readonly ACTION_BUTTON_SHARE: string = 'ActionButton_Share';
  //动态照片popup弹窗配置开关
  public static readonly MOVING_PHOTO_POPUP_EXT_URI: string =
    'datashare:///com.ohos.photos.provider.DataShare.moving_photo_popup';

  // 云增强气泡弹窗 datashare 保存的key
  public static readonly KEY_CLOUD_ENHANCE_POPUP_ENABLE: string = 'cloudEnhancePopupEnable';
  public static readonly KEY_CLOUD_ENHANCE_POPUP_COUNT: string = 'cloudEnhancePopupCount';
  public static readonly KEY_CLOUD_ENHANCE_POPUP_CLICK_TIME: string = 'cloudEnhancePopupClickTime';
  public static readonly KEY_AUTO_CLOUD_ENHANCE_POPUP_ENABLE: string = 'autoCloudEnhancePopupEnable';
  public static readonly KEY_AUTO_CLOUD_ENHANCE_POPUP_COUNT: string = 'autoCloudEnhancePopupCount';
  public static readonly KEY_AUTO_CLOUD_ENHANCE_POPUP_CLICK_TIME: string = 'autoCloudEnhancePopupClickTime';
  public static readonly KEY_CLOUD_ENHANCE_COMPARE_POPUP_COUNT: string = 'cloudEnhanceComparePopupShowCount';
  // 用户在自动云增强弹窗3次toast后，首次点击魔法棒进行云增强的时间
  public static readonly KEY_CLOUD_ENHANCE_CLICK_TIME: string = 'cloudEnhanceFirstClickTime';

  public static readonly UI_COMP_KEY_AUTO_ENHANCE_ID: string = 'AutoCloudEnhanceListCard';

  public static readonly DATA_SHARE_KEY: string = 'keyName';
  public static readonly DATA_SHARE_VALUE: string = 'value';

  // account
  public static readonly APP_STORAGE_KEY_IS_LOGIN: string = 'isLogIn';
  // 是否首次使用AI编创隐私协议
  public static readonly APP_STORAGE_KEY_IS_FIRST_USE_AI_CREATION: string = 'ai_creation_flag';
  public static readonly APP_STORAGE_KEY_IS_AGREE: string = 'isAgree'; // AI编创隐私协议签署状态
  public static readonly APP_STORAGE_KEY_LOCAL_AVATAR_URI: string = 'localAvatarUri';
  public static readonly APP_STORAGE_KEY_USER_NAME: string = 'userName';
  public static readonly IS_LOG_IN: string = 'isLogIn';
  public static readonly APP_STORAGE_KEY_PORTRAIT_CACHE_INFO: string = 'portraitCacheInfo';

  public static readonly GRID_TRANSITION_DURATION: number = 400;
  public static readonly GRID_ADD_OPACITY_DURATION: number = 150;
  public static readonly GRID_ADD_SCALE_DURATION: number = 350;
  public static readonly GRID_DEL_OPACITY_DURATION: number = 300;
  public static readonly GRID_DEL_SCALE_DURATION: number = 300;
  public static readonly GRID_OPACITY_DURATION: number = 200;
  public static readonly GRID_SCALE_VALUE: number = 0.75;
  public static readonly GRID_THIRD_VALUE: number = 0.33;
  public static readonly GRID_LOCK_DURATION: number = 800;
  public static readonly GRID_COLD_LONG_DURATION: number = 2500;
  public static readonly GRID_ADD_TRANSITION_DURATION: number = 100;
  public static readonly GRID_SCROLL_TO_TOP_DURATION: number = 500;
  public static readonly SHOW_DATE_ON_TOP_DURATION: number = 100;
  public static readonly SHOW_DATE_ON_TOP_ANIMATION_GAP: number = 50;
  public static readonly SCALE_VALUE: number = 2160;
  public static readonly SWITCH_LAYOUT_DURATION: number = 1;
  public static readonly HIGHLIGHT_ALPHA_DURATION: number = 500;
  public static readonly HIGHLIGHT_ALPHA_DELAY: number = 2100;
  public static readonly HIGHLIGHT_COVER_ALPHA_DELAY: number = 1500;
  public static readonly HIGHLIGHT_EMPTY_IMAGE_HEIGHT: number = 251;
  public static readonly PC_GRID_VIEW_TIME_TITLE_HEIGHT: number = 40;
  public static readonly UPDATE_MORE_MENU_DELAY: number = 350;

  public static readonly OLD_PHOTO_ALBUM_SHOW: string = 'old_photo_album_show';
  public static readonly OLD_CLOUD_ENHANCE_ALBUM_SHOW: string = 'old_cloud_enhance_album_show';
  public static readonly OLD_VIDEO_ALBUM_SHOW: string = 'old_video_album_show';
  public static readonly OLD_FAVOR_ALBUM_SHOW: string = 'old_favor_album_show';

  public static readonly PROGRESS_SHOW_TIME_THRESHOLD: number = 1000;

  // currentTime
  public static readonly CURRENT_TIME: string = 'current_time';
  public static readonly TIME_CHANGED_KEY: string = 'usual.event.TIME_CHANGED';
  public static readonly TIME_TICK_KEY: string = 'usual.event.TIME_TICK';
  public static readonly TIMEZONE_CHANGED_KEY: string = 'usual.event.TIMEZONE_CHANGED';

  // fileAsset path data
  public static readonly KEY_FILE_DATA: string = 'data';

  public static readonly UPDATE_SELECTED: string = 'update_selected';
  public static readonly UPDATE_NAVIGATION_HEIGHT: string = 'update_navigation_height';
  public static readonly UPDATE_DOWNLOAD_STATE: string = 'update_download_state';

  // navigator list
  public static readonly LIST_ITEM_SPACE: number = 1;
  public static readonly LIST_MID_ITEM_MARGIN: number = 7;
  public static readonly WAVE_MID_ITEM_MARGIN: number = 4;
  public static readonly FULL_PERCENT: string = '100%';
  public static readonly SELECTED_INDEX_KEY: string = 'selectedIndex';
  public static readonly DOUBLE_NUMBER: number = 2;
  public static readonly SHOW_COUNT: number = 17;
  public static readonly HALF_SHOW_COUNT: number = 8;
  public static readonly PARAM_PHOTO_ARR_KEY: string = 'photoArr';
  public static readonly SLIDER_BAR_DIVIDER_WIDTH: number = 0.5;
  public static readonly SMALL_IMAGE_MARGIN_TOP: number = 2;
  public static readonly PRIVACY_VIEW_FULLSCREEN_TOP: number = 34;
  public static readonly PRIVACY_VIEW_NOT_FULLSCREEN_TOP: number = 0;
  public static readonly PRIVACY_VIEW_FULLSCREEN_BOTTOM: number = 10;
  public static readonly PRIVACY_VIEW_FULLSCREEN_TOP_PC: number = -8;

  // preview
  public static readonly SWIPER_PREVIEW_PROGRESS_MARGIN: number = -4;
  public static readonly PREVIEW_PROGRESS_TOP_MARGIN: number = 5;

  // 逐帧播放定位条
  public static readonly PREVIEW_PROGRESS_WIDTH: number = 4;
  public static readonly TV_PREVIEW_PROGRESS_WIDTH: number = 10;
  public static readonly PREVIEW_PROGRESS_BORDER_WIDTH: number = 1;
  public static readonly TV_PREVIEW_PROGRESS_BORDER_WIDTH: number = 2;
  public static readonly PREVIEW_PROGRESS_HEIGHT: number = 40;
  public static readonly PAD_PREVIEW_PROGRESS_HEIGHT: number = 44;
  public static readonly WAVE_PREVIEW_PROGRESS_HEIGHT: number = 50;
  public static readonly TV_WAVE_PREVIEW_PROGRESS_HEIGHT: number = 133;
  public static readonly WAVE_PAD_PREVIEW_PROGRESS_HEIGHT: number = 55;
  public static readonly PREVIEW_PROGRESS_BORDER_RADIUS: number = 2;
  public static readonly TV_PREVIEW_PROGRESS_BORDER_RADIUS: number = 16;
  public static readonly PREVIEW_PROGRESS_MARGIN: number = 2;
  public static readonly PREVIEW_PROGRESS_BORDER_COLOR: string = 'rgba(0, 0, 0, 0.4)';
  public static readonly TV_PREVIEW_PROGRESS_BORDER_COLOR: string = '#66000000';

  // time capsule：逐帧播放时间胶囊
  public static readonly TIME_CAPSULE_HALF: number = 2;
  public static readonly TIME_CAPSULE_WIDTH: number = 98;
  public static readonly TIME_CAPSULE_HEIGHT: number = 24;
  public static readonly TIME_CAPSULE_TEXT_WIDTH: number = 82;
  public static readonly TIME_CAPSULE_RADIUS: number = 25;
  public static readonly TIME_CAPSULE_LINE_HEIGHT: number = 16;

  // 波浪预览条 scale档位 1.25 -> 1.125 -> 1
  public static readonly WAVE_PREVIEW_ANIM_DURATION: number = 200;
  public static readonly WAVE_PREVIEW_SCALE_GEAR: number = 0.125;
  public static readonly WAVE_PREVIEW_SCALE_MAX: number = 1.25;
  public static readonly TOUCH_FALL_BACK_DELAY: number = 3000;
  public static readonly SCROLL_FALL_BACK_DELAY: number = 1000;
  public static readonly WAVE_SECOND_MARGIN_GEAR: number = 2.25;
  public static readonly WAVE_SECOND_MARGIN_FACTOR: number = 4;
  public static readonly WAVE_TARGET_WIDTH_FACTOR: number = 1.5;

  // 屏幕宽度的一半
  public static readonly DEVICE_WIDTH_HALF: number = 2;
  // not Prompt Again
  public static readonly PROMPT_AGAIN: string = 'prompt_again';

  //hiddenDialog height
  public static readonly HIDDEN_DIALOG_HEIGHT: number = 189;
  public static readonly LOCK_DIALOG_HEIGHT: number = 162;
  public static readonly REPLACEME_DIALOG_HEIGHT: number = 311;
  public static readonly SETFORME_DIALOG_HEIGHT: number = 219;
  public static readonly REMOVEME_DIALOG_HEIGHT: number = 141;
  public static readonly PROBABLYISME_DIALOG_HEIGHT: number = 213;
  public static readonly MERGE_DIALOG_HEIGHT: number = 248;

  // photopicker
  public static readonly PHOTO_PICKER_SESSION_KEY: string =
    'com.ohos.photopicker_PickerUIExtensionAbility_session';
  public static readonly PHOTO_PICKER_PARAMS_KEY: string =
    'com.ohos.photopicker_PickerUIExtensionAbility_params';
  public static readonly PHOTO_PICKER_EXTENSION_WINDOW: string = 'photosUiExtensionStage';
  public static readonly PHOTO_PICKER_FROM_PHOTOS: string = 'photo_picker_from_photos';
  public static readonly PHOTO_PICKER_DATA_SOURCE_MANAGER: string = 'photo_picker_data_source_manager';
  public static readonly PHOTO_PICKER_UUID: string = 'photo_picker_uuid';
  public static readonly PHOTO_PICKER_ON_FOREGROUND: string = 'com.ohos.photopicker_onForeground';
  public static readonly PHOTO_USER_FILE_MANAGER_ACCESS: string = 'photo_user_file_manager_access';
  public static readonly PHOTO_ALBUMSET_DATASOURCE_MANAGER: string = 'photo_albumset_datasource_manager';
  public static readonly BROADCAST_MANAGER: string = 'broadcast_manager';
  public static readonly MEDIA_OBSERVER_MANAGER: string = 'media_observer_manager';
  public static readonly OCRHIGHLIGHT_MANAGER: string = 'ocrhighlight_manager';
  public static readonly PHOTO_CLOUD_ENHANCE_MANAGER: string = 'photo_cloud_enhance_manager';
  public static readonly GALLERY_CLOUD_SYNC_ACCESS_MANAGER: string = 'gallery_cloud_sync_access_manager'
  public static readonly PHOTO_MEDIA_OBSERVER: string = 'photo_media_observer';
  public static readonly IS_FROM_PICKER_VIEW: string = 'isFromPickerView';
  public static readonly IS_THIRD_PICKER_SUBWINDOW: string = 'isThirdPickerSubwindow';
  public static readonly IS_PICKER_USED_SUBWINDOW: string = 'isPickerUsedSubwindow';
  public static readonly PHOTO_PICKER_GRANT_PHOTO_URIS: string = 'com.ohos.photopicker_grantPhotoUris';
  public static readonly PHOTO_PICKER_PC_SUBWINDOW: string = 'photo_picker_pc_subWindow';
  public static readonly PHOTO_HARMONY_SHARE_MANAGER: string = 'photo_harmony_share_manager';
  public static readonly PHOTO_PICKER_COMBINED_MEDIA_TYPE_FILTER: string = 'photo_picker_combined_media_type_filter';
  public static readonly IS_PHOTO_PICKER_COMBINED_FILTER_ERROR: string = 'is_photo_picker_combined_filter';
  public static readonly PHOTO_PICKER_BROWSER_DATASOURCE: string = 'photo_picker_browser_datasource';

  public static readonly PHOTO_CAST_MANAGER: string = 'photo_cast_manager';

  public static readonly PHOTO_PICKER_GRANT_PHOTO_APP_NAME: string =
    'com.ohos.photopicker_grantPhotoUris_appName';
  public static readonly PHOTO_PICKER_PICKER_DATA_SOURCE_MANAGER: string =
    'com.ohos.photopicker_pickerDataSourceManager';

  // recentPhoto
  public static readonly RECENT_PHOTO_SESSION_KEY: string =
    'com.ohos.recent_photo_RecentUIExtensionAbility_session';
  public static readonly RECENT_PHOTO_MEDIA_ITEM_KEY: string =
    'com.ohos.recent_photo_RecentUIExtensionAbility_media_item';
  public static readonly RECENT_PHOTO_MEDIA_WANT_KEY: string =
    'com.ohos.recent_photo_RecentUIExtensionAbility_want';
  public static readonly RECENT_PHOTO_APP_BUNDLE_NAME_KEY: string = 'com.ohos.recent_photo_app_bundle_name';
  public static readonly PHOTO_PICKER_APP_ID_KEY: string = 'com.ohos.photo_picker_app_id';
  public static readonly PHOTO_PICKER_TOKEN_ID_KEY: string = 'com.ohos.photo_picker_token_id';
  public static readonly PICKER_SELECT_TIP_HEIGHT: number = 20;
  public static readonly PICKER_SELECT_TIP_WIDTH: number = 162;
  public static readonly PICKER_SELECT_TIP_RADIUS: number = 4;
  public static readonly PICKER_SELECT_TIP_BOTTOM: number = 64;
  public static readonly PICKER_SELECT_TIP_BOTTOM_ABILITY: number = 24;
  public static readonly PICKER_SELECT_TIP_BOTTOM_COMPONENT: number = 8;
  public static readonly PICKER_PREVIEW_AREA_HEIGHT: number = 84;
  public static readonly TV_PICKER_PREVIEW_AREA_HEIGHT: number = 123;
  public static readonly PICKER_PHOTO_BROWSER_AREA: number = 122;
  public static readonly PICKER_SELECT_BAR: number = 178;
  public static readonly PICKER_SEGMENT_BAR_PADDING_TOP: number = 11;
  public static readonly PICKER_SEGMENT_BAR_PADDING_BOTTOM: number = 5;
  public static readonly PICKER_TIPS_DURATION: number = 100;
  public static readonly PICKER_TIPS_DIRECTION_Y: number = 5;
  public static readonly RECENT_PHOTO_PERIOD_MAX_VALUE: number = 86400;
  public static readonly PICKER_SELECTED_BUTTON_SPACE: number = 16;
  public static PICKER_PC_DEFAULT_WIDTH_VP: number = 1158; // pc picker默认宽度(vp),用的时候需要转px
  public static PICKER_PC_DEFAULT_HEIGHT_VP: number = 772; // pc picker默认宽度(vp),用的时候需要转px
  public static PICKER_SIZE_RATIO: number = 0.75; // pc picker拉起时占屏幕宽高比例
  public static DEFAULT_MARGIN_VP: number = 48; // picker左上角和父窗口左上角的默认距离(vp),用的时候需要转px
  public static CLOSE_BUTTON_RIGHT_MARGIN: number = 16;
  public static PICKER_DEFAULT_GRID_ROW_COUNT: number = 4;

  //AI
  public static readonly AI_PREPARE_DELAY_TIME: number = 10;

  //video
  public static readonly VIDEO_PAGE_STATUS: string = 'video_page_status';

  public static readonly GRID: string = 'GRID';
  public static readonly BROWSER: string = 'BROWSER';

  // translate
  public static readonly TWENTY_TRANSLATE: number = 20;
  public static readonly FU_TWENTY_TRANSLATE: number = -20;

  // expandMore amount
  public static readonly EXPAND_MORE_AMOUNT: number = 5;
  public static readonly SHOW_SYSTEM_ALBUM_MAX_COUNT: number = 500;

  // card container
  public static readonly CARD_CONTAINER: number = 25;

  //piano feature
  public static readonly ENABLE_PIANO: string = 'enable_piano';
  public static readonly IS_SUPPORT_BEAUTY: string = 'is_support_beauty';
  public static readonly FACE_BEAUTY_NAME: string = 'Beauty';
  // XXX参数
  public static readonly SPORT: string = 'Sport';
  public static readonly WIDE_APERTURE: string = 'Wide_Aperture';
  public static readonly MULTIPLE_GAINS_BUTTON_Y_POSITION: number = 72;
  public static readonly MULTIPLE_GAINS_BUTTON_HORIZONTAL_Y_POSITION: number = 72;
  public static readonly MULTIPLE_GAINS_CLOSE_ALL_EFFECT: number = 0;
  public static readonly MULTIPLE_GAINS_VIRTUAL_APERTURE: number = 1;
  public static readonly MULTIPLE_GAINS_FLASH_CAPTURE: number = 2;
  public static readonly MULTIPLE_GAINS_FLASH_CAPTURE_AND_VIRTUAL_APERTURE: number = 3;
  public static readonly MULTIPLE_GAINS_PAN: number = 4;
  public static readonly MULTIPLE_GAINS_PAN_VIRTUAL_APERTURE: number = 5;
  public static readonly MULTIPLE_GAINS_PAN_AND_FLASH_CAPTURE: number = 6;
  public static readonly MULTIPLE_GAINS_OPEN_ALL_EFFECT: number = 7;
  public static readonly MULTIPLE_GAINS_MOVING_PHOTO_EFFECT_ENABLE: number = 16384;

  // SidebarContainer
  public static readonly COMPONENT_KEY_PHOTOS: string = 'Photos';
  public static readonly COMPONENT_KEY_ALBUMS: string = 'Albums';
  public static readonly COMPONENT_KEY_HIGHLIGHTS: string = 'Highlights';
  public static readonly COMPONENT_KEY_SEARCH: string = 'Search';
  public static readonly ACTIONBAR_LEFTMARGIN: number =
    14; //Originlaly16, excluding 2vp width of sideBarContainer divider
  public static readonly ACTIONBAR_RIGHTMARGIN: number = 16;
  public static readonly PC_ACIONBAR_MARGIN_TOP: number = 8;
  public static readonly PC_SEARCH_ACTION_BAR_WIDTH: number = 200;
  public static readonly SIDE_BAR_ITEM_HEIGHT_PC: number = 40;
  public static readonly SIDE_BAR_ITEM_HEIGHT_TABLET: number = 48;
  public static readonly SIDE_BAR_ITEM_HEIGHT_TV: number = 64;
  //portrait
  public static readonly STORAGE_MONTH_TIME: string = 'storage_month_time';
  public static readonly PORTRAIT_MERGE_DIALOG_POSITION_X: number = 0;
  public static readonly PORTRAIT_MERGE_DIALOG_POSITION: number = 12;

  //keyBoard
  public static readonly KEY_OF_IS_CTRL_PRESS: string = 'isCtrlPress';
  public static readonly KEY_OF_IS_SHIFT_PRESS: string = 'isShiftPress';

  public static readonly PORTRAIT_QUERY_TYPE: number = 4096;
  public static readonly LOCATION_QUERY_SUB_TYPE: number = 4099;
  public static readonly CITY_QUERY_SUB_TYPE: number = 4100;
  public static readonly PORTRAIT_QUERY_SUB_TYPE: number = 4102;
  public static readonly GROUP_QUERY_SUB_TYPE: number = 4103;
  public static readonly HIGHLIGHT_QUERY_SUB_TYPE: number = 4104;
  public static readonly HIGHLIGHT_QUERY_SUB_TYPE_RECENT: number = 4105;
  public static readonly TRASH_QUERY_SUB_TYPE: number = 1028;
  public static readonly SOURCE_QUERY_TYPE: number = 2048;
  public static readonly SOURCE_QUERY_SUB_TYPE: number = 2049;

  public static readonly MAP_DIALOG_HEIGHT: number = 341;
  public static readonly MAP_DIALOG_BOTTOM: number = 28;
  public static readonly PORTRAIT_INDEX: number = 1;

  public static readonly PORTRAIT_CANCEL_SELECT_ME: string = 'portrait_cancel_select_me';
  public static readonly PORTRAIT_ENTER_INFO_BEHAVIOR_ZERO: number = 0;
  public static readonly PORTRAIT_ENTER_INFO_BEHAVIOR_ONE: number = 1;
  public static readonly PORTRAIT_ENTER_INFO_BEHAVIOR_TWO: number = 2;
  public static readonly PORTRAIT_ENTER_INFO_BEHAVIOR_THREE: number = 3;
  public static readonly PORTRAIT_ENTER_INFO_BEHAVIOR_FOUR: number = 4;
  public static readonly PORTRAIT_ENTER_INFO_BEHAVIOR_FIVE: number = 5;
  public static readonly PORTRAIT_ENTER_INFO_BEHAVIOR_SIX: number = 6;
  public static readonly PORTRAIT_ENTER_INFO_COUNT: number = 1;
  public static readonly PORTRAIT_ENTER_INFO_FROM_PORTRAIT_GRID: number = 0;
  public static readonly PORTRAIT_ENTER_INFO_FROM_PHOTO_PROPERTIES: number = 1;
  public static readonly PORTRAIT_SORT_PRE: number = 1;
  public static readonly PORTRAIT_SORT_NEXT: number = 2;
  public static readonly PORTRAIT_INVALID_VALUE: number = -1;
  public static readonly PORTRAIT_OPTIONS_COUNT: number = 3;
  public static readonly PORTRAIT_MAX_WIDTH: number = 90;
  public static readonly PORTRAIT_MARGIN: number = 4;
  public static readonly PORTRAIT_OUTLINE_WIDTH: number = 8;

  public static readonly PORTRAIT_MERGE_COUNT: number = 12;
  // 当前浏览图片窗口index
  public static readonly CURRENT_SHOW_IMAGE_INDEX: string = 'currentShowImageIndex';
  //最近刪除和隱藏相冊數量
  public static readonly HIDDEN_ALBUM_AND_TRASH_ALBUM_COUNT: string = 'hidden_album_and_trash_album_count';

  public static readonly ACCESSING_PICKER_APP_LIST: string = 'accessing_picker_app_list';

  public static readonly ACCESSING_PICKER_VIEW_APP_LIST: string = 'accessing_picker_view_app_list';

  public static readonly HAS_PICKER_VIEW_WARNING_SHOW: string = 'has_picker_view_warning_show';

  public static readonly IS_VIEW_SHARE_GRID: string = '1';

  //小缩略图描边边框粗细
  public static readonly SMALL_ALBUM_COVER_BORDER_THICKNESS: number = 0.5;
  public static readonly SMALL_DELETE_ANIM_DELAY: number = 100;
  public static readonly SMALL_SCALE_ANIM_DURATION: number = 150;
  public static readonly SMALL_SCALE: number = 0.8;

  // 启用高频调试日志
  public static readonly IS_DEBUG_ON = false;

  public static readonly ON_PAGE_SHOW: string = 'on_page_show';

  public static readonly MULTISELECT_SYSTEM_ALBUM_INFO_OPACITY: number = 0.4;
  public static readonly SYSTEM_ALBUM_INFO_OPACITY: number = 1;

  public static readonly PORTRAIT_DISPLAY_MIN_COUNT: number = 10;

  public static readonly MULTISELECT_PORTRAIT_ITEM_OPACITY: number = 0.4;
  public static readonly PORTRAIT_ITEM_OPACITY: number = 0.8;

  //相册页距离屏幕左右边距中等
  public static readonly ALBUM_GRID_SMALL_PADDING_LEFT_AND_RIGHT: number = 16;
  public static readonly ALBUM_GRID_MEDIUM_PADDING_LEFT_AND_RIGHT: number = 24;
  public static readonly ALBUM_GRID_LARGE_PADDING_LEFT_AND_RIGHT: number = 32;

  // AI控件
  public static readonly IMAGE_ANALYZER_CACHE_MANAGER: string = 'image_analyzer_cache_manager';

  // 时刻点击控件显隐时长
  public static readonly HIGHLIGHT_OPACITY_ANIMATION_DURATION: number = 300;

  // tabBar和年月日SegmentButton显隐时长
  public static readonly TABBAR_SEGMENT_BUTTON_ANIMATION_DURATION: number = 350;

  // 相册URI前缀
  public static readonly ALBUM_URI_PREF: string = 'file://media/PhotoAlbum/';

  public static readonly MIME_TYPE_GIF: string = 'image/gif';
  public static readonly MIME_TYPE_PNG: string = 'image/png';
  public static readonly MIME_TYPE_HEIC: string = 'image/heic';
  public static readonly MIME_TYPE_HEIF: string = 'image/heif';
  public static readonly MIME_TYPE_JPEG: string = 'image/jpeg';
  public static readonly MIME_TYPE_WEBP: string = 'image/webp';
  public static readonly MEDIA_TYPE_IMAGE: string = 'image';
  public static readonly MEDIA_TYPE_IMAGE_EXCLUDE: string = '(image)';
  public static readonly MEDIA_TYPE_VIDEO: string = 'video';
  public static readonly MEDIA_TYPE_VIDEO_EXCLUDE: string = '(video)';
  public static readonly MOVING_PHOTO: string = 'movingPhoto';
  public static readonly MOVING_PHOTO_EXCLUDE: string = '(movingPhoto)';

  public static readonly HIGH_LIGHT_ROWS_GAP_HEIGHT: number = 16;

  public static readonly MENU_START_MARGIN: number = 16;
  public static readonly MENU_DIVIDER_END_MARGIN: number = 16;
  public static readonly MENU_DIVIDER_START_MARGIN: number = 16;
  public static readonly MENU_RIGHT_MARGIN: number = -7.5;
  public static readonly TV_MENU_START_MARGIN: number = 21;
  public static readonly MENU_STROKE_WIDTH: number = 1;
  public static readonly MENU_TOP_PADDING: number = 4;
  public static readonly TV_MENU_TOP_PADDING: number = 5;
  public static readonly MENU_LEFT_PADDING: number = 0;
  public static readonly MENU_ITEM_START_MARGIN: number = 4;
  public static readonly MENU_ITEM_START_PADDING: number = 12;
  public static readonly TV_MENU_ITEM_START_MARGIN: number = 5;
  public static readonly TV_MENU_ITEM_START_PADDING: number = 16;
  public static readonly SUB_MENU_START_MARGIN: number = 8;

  // 父子转场标题延迟动画参数
  public static readonly SHOW_TITLE_ANIMATE_STIFFNESS: number = 342;
  public static readonly SHOW_TITLE_ANIMATE_DAMPING: number = 37;

  // 分段按钮最大宽度
  public static readonly SEGMENT_BUTTON_MAX_WIDTH: number = 448;

  // 地图相册页标题左右边距
  public static readonly MAP_ALBUM_TITLE_PADDING_PHONE: number = 16;
  public static readonly MAP_ALBUM_TITLE_PADDING_FOLDABLE: number = 24;
  public static readonly MAP_ALBUM_TITLE_PADDING_TABLET: number = 32;

  // 图片加载框架图片缓存最大值(字节)
  public static readonly IMAGE_LOADER_MAX_CACHE_SIZE: number = 125 * 1024 * 1024;

  public static readonly EXTENSION_PNG: string = '.png';
  public static readonly EXTENSION_HEIC: string = '.heic';
  public static readonly EXTENSION_GIF: string = '.gif';
  public static readonly EXTENSION_WBMP: string = '.wbmp';

  // 大图组件维测日志错误码
  public static readonly API_RESPONSE_DELAY_TIMEOUT: number = 95271001; //medialibrary query time out
  public static readonly API_RESPONSE_NO_DATA: number = 95271002; //medialibrary query no data
  public static readonly API_RESPONSE_INDEX_NOT_FOUND: number = 95271003; //medialibrary query index not found

  public static readonly CROP_HALF: number = 0.5;

  //预览图最大高度相关参数
  public static readonly PREVIEW_HEIGHT_HALF: number = 2;
  public static readonly PREVIEW_PAD_HORIZONTAL: number = 3 / 5;
  public static readonly PREVIEW_PHONE_HORIZONTAL_MAX: number = 16;
  public static readonly PREVIEW_PHONE_HORIZONTAL_MIN: number = 4;
  public static readonly PREVIEW_RATIO: number = 3;
  public static readonly PREVIEW_DEFAULT_RATIO: number = 1;
  public static readonly TV_PREVIEW_DEFAULT_RATIO: number = 4 / 3;

  // 来源相册首批查询个数
  public static readonly SOURCE_ALBUM_FIRST_BATCH_QUERY_COUNT: number = 25;

  /**
   * 显示loading的超时时间
   */
  public static readonly SHOW_LOADING_TIMEOUT: number = 5000;

  // 相册页相册默认scale
  public static readonly ALBUM_DEFAULT_SCALE: number = 1;

  public static readonly ANIMATE_TIME: number = 150;

  public static readonly PHONE_LIST_MARGIN_BOTTOM: number = 0;
  public static readonly PC_LIST_MARGIN_BOTTOM: number = 2;

  public static readonly WAVE_LIST_MARGIN_TOP: number = 12;

  // checkbox勾选热区范围设置
  public static readonly GRID_ITEM_WIDTH_HALF: number = 2.0;
  public static readonly GRID_ITEM_CHECKBOX_ANCHOR = 28;
  public static readonly GRID_ITEM_CHECKBOX_MIRROR_ANCHOR_X = -8;

  // 开屏引导页面
  public static readonly USER_GUIDE: string = 'USER_GUIDE';

  // 全屏引导页面
  public static readonly FULL_SCREEN_GUIDE: string = 'FULL_SCREEN_GUIDE';

  // 大图上滑详情
  public static readonly PHOTO_ADDRESS_LATITUDE: string = 'Photos.latitude';
  public static readonly PHOTO_ADDRESS_LONGITUDE: string = 'Photos.longitude';
  public static readonly PHOTO_ADDRESS_DESCRIPTION: string = 'address_description';
  public static readonly LOCALITY: string = 'locality';
  public static readonly SUB_LOCALITY: string = 'sub_locality';
  public static readonly ADMIN_AREA: string = 'admin_area';
  public static readonly SUB_ADMIN_AREA: string = 'sub_admin_area';
  public static readonly THOROUGHFARE: string = 'thoroughfare';
  public static readonly SUB_THOROUGHFARE: string = 'sub_thoroughfare';
  public static readonly COUNTRY: string = 'country';

  // 宫格与标题之间的padding
  public static readonly BAR_GRID_BOTTOM_PADDING: number = 6;

  public static readonly TV_BAR_GRID_BOTTOM_PADDING: number = 4;
  public static readonly TV_BAR_GRID_ROW_COUNT: number = 4;

  //seek结束，容许偏移的时间
  public static readonly SEEK_ALLOWABLE_OFFSET_TIME: number = 10;

  // 畅联包名
  public static readonly MEETIME_SERVICE: string = 'com.ohos.meetimeservice';
  // 透明
  public static readonly TRANSPARENT: number = 0;
  // 不透明
  public static readonly OPAQUE: number = 1;

  // 文件管理跳转进入图库
  public static readonly ENTER_VIDEO_PAGE_FROM_FILE_MANAGER: string = 'video_page';
  public static readonly ENTER_CAMERA_PAGE_FROM_FILE_MANAGER: string = 'camera_page';
  public static readonly ENTER_HW_SHARE_PAGE_FROM_FILE_MANAGER: string = 'hw_share_page';
  public static readonly ENTER_ALBUM_PAGE_FROM_FILE_MANAGER: string = 'album_page';
  public static readonly ENTER_USER_ALBUM_PAGE: string = 'user_album_page';
  public static readonly ENTER_TIMELINE_PAGE: string = 'timeline_page';
  public static readonly ENTER_HIGHLIGHT_PAGE: string = 'highlight_page';

  // 分享跳转进入分享相册宫格页
  public static readonly ENTER_HW_SHARE_PAGE_FROM_SHARE: string = 'hw_share_page';

  // 人像卡片跳转进入宫格页
 public static readonly ENTER_PORTRAIT_ALBUM_GRID_PAGE: string = 'portrait_album_grid_page';


  // 所有图片及视频相册uri
  public static readonly ALBUM_URI_ALL_MEDIA: string = 'file://media/PhotoAlbum/pictures_and_videos';

  // 聚合相册uri头部
  public static readonly UNION_ALBUM_URI_HEAD: string = 'unionAlbum:';

  // 浅层窗口
  public static readonly SHEET_CONFIG_TOP_PADDING: number = 8;
  // 栅格适配：在sheetShow为false时，自动按照5.0规范栅格适配，为true时固定按照4栅格适配
  public static readonly SHEET_CONFIG_LEFT_RIGHT_MARGIN: number = 16;
  public static readonly SHEET_CONFIG_LEFT_RIGHT_MARGIN_PC: number = 24;
  public static readonly SHEET_SHOW_BACK_COLOR_LIGHT: string = '#F1F3F5';
  public static readonly SHEET_SHOW_BACK_COLOR_DARK: string = '#1A1A1A';
  public static readonly MAIN_LIST_HEIGHT: number = 64;
  public static readonly MAIN_LIST_HEIGHT_PC: number = 56;
  public static readonly LIST_HEIGHT: number = 48;
  public static readonly LIST_HEIGHT_PC: number = 40;
  public static readonly LIST_ICON_WIDTH: number = 40;
  // 上下padding之和
  public static readonly LIST_PADDING_TOP_BOTTOM: number = 8;
  public static readonly SUB_TITLE_HEIGHT_PC: number = 40;
  public static readonly SUB_TITLE_HEIGHT: number = 56;
  // 图库网络连接有一个4vp的提示语，所以24-4
  public static readonly LEARN_HOW_TO_USE_DATA_BOTTOM_PADDING: number = 8;
  public static readonly STATEMENT_CARDS_BOTTOM_PADDING: number = 12;
  public static readonly SETTING_TEXT_TOP_BOTTOM_PADDING: number = 3;
  public static readonly ACCOUNT_TEXT_TOP_BOTTOM_MARGIN_PC: number = 8;
  public static readonly DIVIDER_MARGIN: number = 8;
  public static readonly ACCOUNT_TEXT_TOP_BOTTOM_MARGIN: number = 8;
  public static readonly ACCOUNT_LIST_OUTER_HEIGHT_PC: number = 64;
  public static readonly ACCOUNT_LIST_OUTER_HEIGHT: number = 72;
  public static readonly GALLERY_SETTING_TOP_MARGIN_TO_BUTTON: number = 8;
  public static readonly GALLERY_SETTING_BOTTOM_MARGIN_TO_BUTTON: number = 24;
  public static readonly GALLERY_SETTING_BOTTOM_MARGIN_TO_TEXT: number = 4;
  public static readonly GALLERY_SETTING_BOTTOM_MARGIN_TO_TEXT_PC: number = 12;

  // 云空间开屏引导页面
  public static readonly ENABLE_SYNC_SPLASH: string = 'ENABLE_SYNC_SPLASH';

  // 一碰分享云图提示语
  public static readonly SEND_API_NOTIFY_INFO_DATA_PREPARING_TO_SHARE: number = 1201;
  public static readonly SEND_API_NOTIFY_INFO_OPEN_HOTPOINT_TO_SHARE: number = 1205;
  public static readonly SEND_API_NOTIFY_INFO_INTERNET_IMAGE_FAILED: number = 1208;
  public static readonly SEND_API_NOTIFY_INFO_INTERNET_VIDEO_FAILED: number = 1209;
  public static readonly SEND_API_NOTIFY_INFO_NO_INTERNET_FILE_FAILED = 1210;
  public static readonly SEND_API_NOTIFY_INFO_DOWNLOADING_VIDEO: number = 1211;
  public static readonly SEND_API_NOTIFY_INFO_PHOTOS_EXCEEDED_MAX_LIMIT: number = 1215;
  public static readonly SEND_API_NOTIFY_INFO_DOWNLOAD_SUCCESS: number = 1219;
  public static readonly SEND_API_NOTIFY_INFO_DOWNLOAD_FAIL: number = 1220;

  //一碰表盘相关
  public static readonly DIAL_SERVICE_NAME: string = 'GalleryTouchDial';
  public static readonly DIAL_INIT_AND_CANCEL_SERVICE_CODE: number = 11;
  public static readonly DIAL_SEND_EVEN_CODE: number = 0;
  public static readonly DIAL_CALLBACK_SUCCESS_CODE: number = 3;
  public static readonly DIAL_INIT_AND_CANCEL_PARAMETER: Record<string, Object> = {
    'serviceCode': Constants.DIAL_INIT_AND_CANCEL_SERVICE_CODE,
    'serviceName': Constants.DIAL_SERVICE_NAME,
  };
  public static readonly MAX_TRANSMISSIONS_DIAL_NUM: number = 500;

  // 长按倍速相关ui参数
  public static readonly FAST_FORWARD_ICON_SIZE: number = 16;
  public static readonly FAST_PLAY_LABEL_TEXT_FONT_SIZE: number = 14;
  public static readonly FAST_PLAY_LABEL_BACKGROUND_COLOR: string = '#94808080';
  public static readonly FAST_PLAY_LABEL_BACKGROUND_BLUR_SCALE: number = 0.28;
  public static readonly FAST_PLAY_LABEL_POSITION_Y_VERTICAL: number = 110;
  public static readonly FAST_PLAY_LABEL_POSITION_Y_HORIZONTAL: number = 74;
  public static readonly LIBRARY_ACTION_BAR_PADDING_TOP_PX_TABLET: number = 136;

  // 视频旋转相关ui参数
  public static readonly ROTATE_BUTTON_ICON_SIZE: number = 24;
  public static readonly ROTATE_BUTTON_BACKGROUND_HEIGHT: number = 40;
  public static readonly ROTATE_BUTTON_SHADOW_RADIUS: number = 16;
  public static readonly ROTATE_BUTTON_SHADOW_OFFSET: number = 6;
  public static readonly ROTATE_BUTTON_POSITION: number = 16;

  //连接网络时的code值
  public static readonly WIFI_CONNECT: number = 4;

  /**
   * 图库多选一碰分享最大文件数量
   */
  public static readonly MAX_TRANSMISSIONS_NUM: number = 400;

  /**
   * 宫格文字放大倍数上限
   */
  public static readonly GRID_TEXT_MAX_SCALE: number = 1.75;
  public static readonly PORTRAIT_GRID_TEXT_MAX_SCALE: number = 1;

  // 拖拽图片或视频到图库，弹窗打开相册
  public static readonly OPEN_ALBUM_AFTER_DRAG: string = 'open_album';

  /**
   * 字体放大倍数：正常，1倍
   */
  public static readonly FONT_SCALE_NORMAL_SIZE: number = 1;
  /**
   * 字体放大倍数：大1挡，1.15倍
   */
  public static readonly FONT_SCALE_LEVEL1_SIZE: number = 1.15;
  /**
   * 字体放大倍数：大2挡，1.3倍
   */
  public static readonly FONT_SCALE_LEVEL2_SIZE: number = 1.3;

  /**
   * 字体放大倍数：大3挡，1.45倍
   */
  public static readonly FONT_SCALE_LEVEL3_SIZE: number = 1.45;

  /**
   * 字体放大倍数：大4挡，1.75倍
   */
  public static readonly FONT_SCALE_LARGE_SIZE: number = 1.75;

  /**
   * 字体放大倍数：大5挡，2倍
   */
  public static readonly FONT_SCALE_STRONG_SIZE: number = 2;

  /**
   * 字体放大倍数：大6挡，3.2倍
   */
  public static readonly FONT_SCALE_HEAVY_SIZE: number = 3.2;

  public static readonly AI_BAR_HEIGHT: string = 'AI_BAR_HEIGHT';

  public static readonly TIMELINE_PERSIST_ID: string = 'TIMELINE_PERSIST_ID';

  /**
   * 长按新建相册弹窗分屏场景适配
   */
  public static readonly CARD_LARGE_SPLIT_SCREEN_HEIGHT: number = 42;
  public static readonly CARD_LARGE_FLOATING_SCREEN_HEIGHT: number = 18;
  public static readonly CARD_OTHER_SCREEN_HEIGHT: number = 6;
  public static readonly CARD_MIDDLE_SPLIT_SCREEN_HEIGHT: number = 30;
  public static readonly CARD_MIDDLE_FLOATING_SCREEN_HEIGHT: number = 9;

  /**
   * 各个页面组件的组件key值，用于屏幕朗读手动聚焦
   */
  public static readonly COMPONENT_KEY_TEXT_INPUT: string = 'TextInput';
  public static readonly COMPONENT_KEY_BUTTON_FAVOR: string = 'ToolBarButtonFavor';
  public static readonly COMPONENT_KEY_BUTTON_BACK: string = 'AccessibilityComponentBack';
  public static readonly COMPONENT_KEY_BUTTON_BrowserBack: string = 'AccessibilityComponent_BrowserBack';
  public static readonly COMPONENT_KEY_BUTTON_BurstBrowserBack: string = 'AccessibilityComponent_BurstBrowserBack';
  public static readonly COMPONENT_KEY_BUTTON_BACK_THIRD: string = 'Back';
  public static readonly COMPONENT_KEY_SEARCH_VIEW: string = 'SearchView';
  public static readonly COMPONENT_KEY_BUTTON_CANCEL: string = 'AccessibilityComponentCancel';
  public static readonly COMPONENT_KEY_BUTTON_MULTI_SELECT: string = 'AccessibilityComponentMultiSelected';
  public static readonly COMPONENT_KEY_BUTTON_SELECT_ALL: string = 'AccessibilityComponentSelectAll';
  public static readonly COMPONENT_KEY_BUTTON_DESELECT_ALL: string = 'AccessibilityComponentDeSelectAll';
  public static readonly COMPONENT_KEY_LIST_MONTH: string = 'TimelinePage_list_month';
  public static readonly COMPONENT_KEY_GRID_DAY: string = 'TimelinePage_grid_day';
  public static readonly COMPONENT_KEY_ADD_PORTRAIT: string = 'gridItem_add_portrait';
  public static readonly COMPONENT_KEY_TOGGLE_CLOUD_SYNC: string = 'CloudSyncToggle';
  public static readonly COMPONENT_KEY_TOGGLE_NETWORK_CONN: string = 'NetworkConnectionToggle';
  public static readonly COMPONENT_KEY_BUTTON_HIDDEN_SECONDARY_BACK: string =
    'AccessibilityComponent_HiddenSecondaryBack';
  public static readonly COMPONENT_KEY_BUTTON_HIDDEN_SECONDARY_CANCEL: string =
    'AccessibilityComponent_HiddenSecondaryCancel';
  public static readonly COMPONENT_KEY_BUTTON_BROWSER_BACK: string = 'AccessibilityComponent_BrowserBack';
  public static readonly COMPONENT_KEY_SIDE_BUTTON = 'sideButton';
  public static readonly COMPONENT_KEY_CHEVRON_ARROW = 'ChevronArrow';
  public static readonly COMPONENT_KEY_EXPAND_MORE: string = 'expandMore_click';


  // 多选按钮屏幕截断宽度
  public static readonly MULTISELECT_ACTION_WIN_SIZEO_TRUNCATION_WIDTH: number = 360;

  /**
   * 触发启动重复照片处理功能，需要连续点击的次数：10
   */
  public static readonly CLICK_TIMES_THRESHOLD_FOR_DUPLICATE: number = 10;

  /**
   * getMapImage查询地图静态图，每次请求的最小间隔毫秒数
   */
  public static readonly MILLI_SECOND_GAP_MAP_STATIC: number = 500;

  /**
   * betaClub应用包名
   */
  public static readonly ABILITY_BETA_CLUB: string = 'com.ohos.betaclub';

  /**
   * UIAbilityContext调用返回的错误编码，表示：The specified ability does not exist.
   */
  public static readonly ERROR_CODE_ABILITY_NOT_EXIST: number = 16000001;

  /**
   * 查询重复照片的albumUri
   */
  public static readonly ALL_DUPLICATE_ASSETS: string = '/all_duplicate_assets';

  /**
   * 查询待删除重复照片的albumUri
   */
  public static readonly CAN_DEL_DUPLICATE_ASSETS: string = '/can_del_duplicate_assets';

  /**
   * 相机相册的lpath
   */
  public static readonly LPATH_CAMERA: string = '/DCIM/Camera';

  /**
   * 截图相册的lpath
   */
  public static readonly LPATH_SCREEN_SHOT: string = '/Pictures/Screenshots';

  /**
   * 录屏相册的lpath
   */
  public static readonly LPATH_SCREEN_RECORDING: string = '/Pictures/Screenrecords';

  public static readonly FULL_GUIDE_DELAY_GET_DATA: number = 1000;

  public static readonly TIMELINE_GRID: string = 'timeline_grid';

  public static readonly PC_DAY_GRID: string = 'PcDayGrid';

  public static readonly PC_GROUP_DAY_GRID: string = 'PcGroupDayGrid';

  public static readonly PHOTO_GRID: string = 'photo_grid';

  public static readonly PHOTO_HIDDEN_GRID: string = 'photo_hidden_grid';

  public static readonly PHOTO_HIDDEN_ALBUM_GRID: string = 'photo_hidden_album_grid';

  public static readonly PHOTO_HIDDEN_VIEW_GRID: string = 'photo_hidden_view_grid';

  public static readonly PHOTO_COLLAGE_PAGE_GRID: string = 'photo_collage_page_grid';

  public static readonly PHOTO_COLLAGE_MENU: string = 'photo_collage_menu';

  public static readonly PHOTO_PORTRAIT_ALBUM_GRID: string = 'photo_portrait_album_grid';

  public static readonly PHOTO_CATEGORY_ALBUM_GRID: string = 'photo_category_album_grid';

  public static readonly PHOTO_SHOOT_ALBUM_GRID: string = 'photo_shoot_album_grid';

  public static readonly PHOTO_SEARCH_RESULT_GRID: string = 'photo_search_result_grid';

  public static readonly PHOTO_SEARCH_GROUP_DATA: string = 'photo_search_group_data';
  /**
   * 冷启动换帧PC适配时顶部GridItem高度设置
   */
  public static readonly PC_BLANK_GRID_ITEM_HEIGHT: number = 48;

  /**
   * 图库下载UI显示的初始进度
   */
  public static readonly PICKER_PHOTO_DOWNLOAD_START_PROGRESS: number = 5;

  /**
   * 图库下载UI显示的完整进度
   */
  public static readonly PICKER_PHOTO_DOWNLOAD_COMPLETE_PROGRESS: number = 100;

  /**
   * 外屏滑动，进入沉浸态的最小感知长度
   */
  public static readonly VERDE_SLIDING_THRESHOLD: number = 10;

  public static readonly PC_SUN_HEADER_HORIZONTAL_PADDING = '-16vp';

  /**
   * 时刻后台分析进度显示阈值
   */
  public static readonly HIGHLIGHT_ANALYSIS_PROCESS_SHOW_THRESHOLD: number = 95;

  /**
   * 大图切侧边栏，动画完成切标记时间
   */
  public static readonly PC_PICTURE_TO_SIDEBAR_ANIMATION_COUNT: number = 500;

  /**
   * 大图切侧边栏，大图消失动画时间
   */
  public static readonly PC_PICTURE_TO_SIDEBAR_ANIMATION_DURATION: number = 450;

  /**
   * 大图进出编辑，侧边栏动画时间
   */
  public static readonly SIDEBAR_ANIM_DURATION: number = 200;

  public static readonly UPDATE_PC_SEARCH_ICON: string = 'update_pc_search_icon';

  /**
   * 大图进出详情，详情框动画时间
   */
  public static readonly PHONE_PROPERTY_ANIM_DURATION: number = 150;

  /**
   * 资源大小换算,千字节的转换单位
   */
  public static readonly CONVERSION_UNIT: number = 1000;

  /**
   * 年视图标识
   */
  public static readonly YEAR = 'Year';

  /**
   * 月视图标识
   */
  public static readonly MONTH = 'Month';

  /**
   * 年月视图默认uri前缀
   */
  public static readonly YEAR_MONTH_DEFAULT_URI_PREFIX = 'file://media/Photo/1/1/1.jpg?timestampApp=';

  /**
   * 年视图默认uri后缀
   */
  public static readonly YEAR_DEFAULT_URI_SUFFIX = '&oper=astc&width=64&height=64&time_id=';

  /**
   * 月视图默认uri后缀
   */
  public static readonly MONTH_DEFAULT_URI_SUFFIX = '&oper=astc&width=128&height=128&time_id=';

  /**
   * 年视图单组元数据个数
   */
  public static readonly YEAR_ITEM_COUNT_PER_GROUP = 160;

  /**
   * 年视图单批次元数据组数
   */
  public static readonly YEAR_ITEM_GROUP_COUNT = 5;

  /**
   * 年月视图元数据批次个数: (单组元数据个数 * 单批次元数据组数) 的倍数
   */
  public static readonly YEAR_MONTH_MEDIA_DATA_BATCH_NUM = 4000;

  //搜索框左右边距
  public static readonly SEARCH_VIEW_MARGIN: number = 16;

  public static readonly ACTION_BUTTON_WIDTH_PC: number = 48;

  public static readonly ALBUM_NAME_PREDICATE: string = 'album_name';

  /**
   * 模块全限定名，防止广播等发生冲突
   */
  public static readonly FQDN_PREFIX: string = 'com.ohos.photos_';

  /**
   * xxx展FoldDisplayMode状态
   */
  public static readonly FOLD_DISPLAY_MODE = `${Constants.FQDN_PREFIX}fold_display_mode`;

  /**
   * 降采样图片最大长度或者宽度
   */
  public static readonly IMAGE_SOURCE_THUMBNAIL_MAX_LENGTH: number = 4096;

  /**
   * B->MB 内存转换
   */
  public static readonly MB_UNIT: number = 1000 * 1000;

  public static readonly MOVING_PHOTO_REPEAT_PLAY_DELAY: number = 100;

  /**
   * 设置卡片内存上限
   */
  public static readonly NEED_SHOW_MEDIA_MEMORY_LIMIT: number = 500;

  /**
   * 空闲内存上限
   */
  public static readonly NEED_SHOW_FREE_MEMORY_LIMIT: number = 0.1;

  /**
   * 空闲内存下限
   */
  public static readonly NEED_SHOW_FREE_MEMORY_LOWER_LIMIT: number = 2 * 1000;

  /**
   * 照片tab卡片延时展示时间
   */
  public static readonly SYNC_CARD_DISPLAY_DELAY: number = 500;

  /**
   * 演示版本预制关键词key
   */
  public static readonly DEFAULT_SEARCH_KEYWORD: string = 'const.photo.search.default_search_keyword';

  /**
   * 是否首次预制
   */
  public static readonly IS_FIRST_REGISTER_DEFAULT_SEARCH_KEYWORD: string = 'is_first_register_default_search_keyword';

  public static readonly DRAWER_BUTTON_WIDTH_PC: number = 48;

  public static readonly ENABLE_HEIF_PHOTO_DISPLAY: string = 'enable_heif_photo_display';

  public static readonly ENHANCED_TAG = '_enhanced';
  public static readonly ENABLE_SLIDESHOW = 'enable_slideshow';

  /**
   * 中文简体
   */
  public static readonly CHINESE_LANGUAGE: string = 'zh-Hans';
  /**
   * 英文
   */
  public static readonly ENGLISH_LANGUAGE: string = 'en-Latn-US';
  /**
   * 中文繁体
   */
  public static readonly TRADITIONAL_CHINESE_LANGUAGE: string = 'zh-Hant';

  /**
   * xxx 连拍
   */
  public static readonly VDE_FOLD_BURST_PADDING_BOTTOM: number = 8;
  public static readonly VDE_BURST_ZERO: number = 0;
  public static readonly PAD_SLIDER_BAR_HORIZON_HEIGHT: number = 72;
  public static readonly SLIDER_BAR_HORIZON_HEIGHT: number = 68;
  public static readonly PC_SLIDER_BAR_HEIGHT: number = 44;
  public static readonly SLIDER_BAR_HEIGHT: number = 40;

  public static readonly PC_SIDEBAR_STATUS = 'pc_sideBar_status';

  /**
   * 屏蔽时刻分析进度提示语
   */
  public static readonly IS_SHOW_HIGHLIGHT_ANALYSIS_PROGRESS: boolean = false;

  /**
   * 大图双指旋转 开关
   */
  public static readonly ENABLE_ROTATE: string = 'enable_rotate';
  /**
   * 大图浏览支持画中画 开关
   */
  public static readonly ENABLE_INNERPIC: string = 'enable_innerPic';

  /**
   * 拍摄模式
   */
  public static readonly SHOOTING_MODE_TAG: string = 'shooting_mode_tag';

  public static readonly ALBUM_GRID_SORT_SELECT_HEIGHT: number = 50;
  public static readonly ALBUM_GRID_SORT_SELECT_DURATION: number = 150;
  public static readonly ALBUM_GRID_SORT_SELECT_HIDE_DURATION: number = 100;
  public static readonly ALBUM_GRID_SORT_HIDE_DELAY: number = 100;
  public static readonly SORT_MENU_ITEM_PADDING: number = 8;
  public static readonly SORT_MENU_ITEM_PADDING_Top_Bottom: number = 13.5;

  /**
   * 防窥保护模糊参数
   */
  public static readonly BLUR_IMAGE_SCALE_VALUE: number = 0.85;
  public static readonly BLUR_IMAGE_ANIMATION_OPACITY_DURATION: number = 150;
  public static readonly BLUR_IMAGE_ANIMATION_SCALE_DURATION: number = 350;
  /**
   * 宫格排序动效参数
   */
  public static readonly ALBUM_GRID_SORT_CURVE_STIFFNESS: number = 228;
  public static readonly ALBUM_GRID_SORT_CURVE_DAMPING: number = 30;

  /**
   * 主角星球和人像相册切换
   */
  public static readonly PORTRAIT_PROTAGONIST_PLANET_SWITCH: string = 'portrait_protagonist_planet_switch';

  /**
   * 主角星球item默认高度宽度
   */
  public static readonly DEFAULT_ITEM_WIDTH = 102;
  public static readonly DEFAULT_ITEM_HEIGHT = 102;

  public static readonly NULL_STRING: string = '';

  public static readonly LAST_AUTO_CLOUD_ENHANCE_SWITCH_LOG: string = 'last_auto_cloud_enhance_switch_log';

  public static readonly TOAST_DURATION_SHORTER = 2000;
  public static readonly TOAST_BOTTOM = 80;
  public static readonly DOUBLE_TEXT_MID_PADDING = '2vp';
  public static readonly DOUBLE_TEXT_CHECK_BOX_HEIGHT = '24vp';
  public static readonly OPTIMIZE_SPACE_BOTTOM_MARGIN_TO_NETWORK = '12vp';
  public static readonly IMMEDIATELY_BUTTON_HEIGHT_FOR_PHONE = '48vp';
  public static readonly IMMEDIATELY_BUTTON_HEIGHT_FOR_PC = '40vp';
  public static readonly GALLERY_SETTING_BOTTOM_MARGIN_TO_BUTTON_FIX: number = 16;
  public static readonly LIST_BUTTON_TEXT_MARGIN_TO_BOTTOM_PHONE = '11vp';
  public static readonly LIST_BUTTON_TEXT_MARGIN_TO_BOTTOM_PC = '9vp';
  public static readonly ONE: number = 1;
  public static readonly ZERO: number = 0;
  public static readonly TWO: number = 2;

  /**
   * PC设置壁纸
   */
  public static readonly SET_WALLPAPER_ABILITY = 'WallpaperComponentExtAbility';

  /**
   * LDU演示样机
   */
  public static readonly DEVICE_ENABLE_RETAIL: string = 'device_enable_retail';

  /**
   * 封面编辑
   */
  public static readonly COVER_SELECT_SHEET: string = 'CoverSelectSheet';
  public static readonly COVER_PREVIEW_SHEET: string = 'CoverPreviewSheet';

  public static readonly TV_MENU_SYMBOL_UNICODE: string = '\u{F0679}';
  /**
   * LocalStorage中，主界面返回事件处理器的KEY值
   */
  public static readonly LOCAL_KEY_INDEX_BACK_PRESS_EVENT_HELPER: string =
    'com.ohos.photos.index_back_press_event_helper';
  /**
   * 撤销数据量上限
   */
  public static readonly UNDO_LIMIT: number = 30000;
  public static readonly SETTINGS_DATA_VIRTUAL_KB_KEY_URI: string =
    'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=virtualKeyBoardType';
  public static readonly SETTINGS_DATA_VIRTUAL_KB_KEY: string = 'virtualKeyBoardType';
  public static readonly PC_VIRTUAL_KB_HIDDEN: string = '0';
  public static readonly PC_VIRTUAL_KB_SHOWN: string = '1';
  public static readonly PC_VIRTUAL_KB__FLOAT_SHOWN: string = '3';
  public static readonly CONVERT_IMMERSIVE_STATUS_ANIMATION = 300;
  // PC大图预览条初始区域高度
  public static readonly PC_PREVIEW_STACK_HEIGHT: number = 57;
  // 安全组件动画播放标识
  public static readonly PICKER_SHIELD_ANIMATE_PLAYED_FLAG: string = 'pickerShieldAnimatePlayed';

  // 设置---显示大小变化的数据库字段
  public static readonly USER_SET_DPI_VALUE: string = 'user_set_dpi_value';

  public static readonly suffixList: string[] = ['jpg', '.jpeg', '.png', '.bmp', '.webp', '.raw', '.heic'];

  public static readonly formatList: string[] = ['jpg', 'jpeg', 'png', 'bmp', 'webp', 'raw', 'heic'];

  public static readonly OPEN_MEDIA_TYPE: string = 'openMediaType';
  public static readonly SCENARIO_INDEX: string = 'scenarioIndex';

  // 从相机进入人像卡片，返回退出应用
  public static readonly DESTROY_FROM_CAMERA: string = 'destroy_from_camera';
  // 组件化宫格广播标识
  public static readonly PC_NEW_PHOTO_GRID: string = 'NewPhotoGridView';

  public static readonly IS_APPEAR_MORE: string = 'isAppearMore';
  // 相册封面预览图宽度
  public static readonly ALBUM_COVER_PREVIEW_ITEM_HEIGHT: number = 328;
  // 相册封面预览半模态高度 vp
  public static readonly ALBUM_COVER_BIND_SHEET_HEIGHT: number = 560;
  public static readonly DEFAULT_ALBUM_COVER: string = '0';
  public static readonly CUSTOM_ALBUM_COVER: string = '1';

  /**
   * 气泡最大显示次数
   */
  public static readonly MAX_DISPLAY_GUIDE: number = 4;

  /**
   * 1天毫秒数
   */
  public static readonly ONE_DAY_MS: number = 24 * 60 * 60 * 1000;

  /**
   * 卡片出现频率默认值
   */
  public static readonly DEFAULT_INTERVAL_TIME: number[] = [1, 3, 7];

  /**
   * 云同步卡片上次操作时间 sp键名后缀
   */
  public static readonly GUIDE_LAST_OPT_TIME: string = 'GuideLastOptTime';

  /**
   * 云同步卡片展示次数 sp键名后缀
   */
  public static readonly GUIDE_SHOW_COUNT: string = 'GuideShowCount';

  /**
   * 视图是否在四宫格和三宫格之间切换过
   */
  public static readonly DAY_GROUP_HAS_CHANGED: string = 'dayGroupHasChanged';

  /**
   *  PC最近删除相册字体默认间距
   */
  public static readonly DEFAULT_FONT_SPACING: number = 8;

  /**
   *  PC最近删除相册字体大小放大比例
   */
  public static readonly FONT_SIZE_SCALE: number = 16;

  /**
   * 提醒向导是否已经手动关闭
   */
  public static readonly GUIDE_HAS_CLOSED: string = 'GuideHasClosed';

  /**
   * 是否已经上报过切换向导显示次数
   */
  public static readonly HAS_REPORT_GUIDE_COUNT: string = 'HAS_REPORT_GUIDE_COUNT';

  /**
   * 三宫格切换到四宫格
   */
  public static readonly GROUP_DAY_TO_DAY: string = 'GROUP_DAY_TO_DAY';

  /**
   * 四宫格切换到三宫格
   */
  public static readonly DAY_TO_GROUP_DAY: string = 'DAY_TO_GROUP_DAY';

  /**
   * 移动到页面/相册排序页面 第一批相册加载数量
   */
  public static readonly INIT_ALBUMS_FIRST_BATCH: number = 16;

  /**
   * 移动到页面/相册排序页面 第二批相册加载数量
   */
  public static readonly INIT_ALBUMS_SECOND_BATCH: number = 60;
  /**
   * 存储通过image.createImagePacker().supportedFormats获取的数据
   */
  public static readonly IMAGE_PACKER_SUPPORTED_FORMATS: string = 'ImagePacker_supportedFormats';

  /**
   * 是否需要还原切换向导备份
   */
  public static readonly IS_NEED_RESTORE_GUIDE: string = 'isNeedRestoreGuide';

  /**
   * 相机进大图更多菜单参数
   */
  public static readonly KEY_UPDATE_MENU_PARAM_CAMERA: string = 'KEY_UPDATE_MENU_PARAM_CAMERA';

  /**
   * 图库进大图更多菜单参数
   */
  public static readonly KEY_UPDATE_MENU_PARAM_BROWSER: string = 'KEY_UPDATE_MENU_PARAM_BROWSER';

  /**
   * 缓存隐私协议是否是从setting的协议列表页面打开
   */
  public static readonly IS_SHOW_FROM_SETTING_PRIVACY_LIST: string = 'isShowFromSettingPrivacyList'

  /**
   * 标记已经加载过地图So
   */
  public static readonly ALREADY_LOAD_MAP_SO: string = 'alreadyLoadMapSo';

  /**
   * 拉起方
   */
  public static readonly ALBUM_GRID_VIEW_PAGE_FROM: string = 'ALBUM_GRID_VIEW_PAGE_FROM';

  /**
   * AI编创入口开关状态
   */
  public static readonly AI_CREATION_TOGGLE_STATUS: string = 'AI_CREATION_TOGGLE_STATUS';
  /**
   * 智慧相册刷新宫格长按菜单
   */
  public static readonly SMART_ALBUM_LONG_PRESS_MENU: string = 'SMART_ALBUM_LONG_PRESS_MENU';
  // commonAbility 三方跳转replaceUri 时间
  public static readonly Jump_TO_BROWSER_TIME: string = 'JUMP_TO_BROWSER_TIME';
  // 不响应大图backPress时间差
  public static readonly POP_UP_TIME_VARIANCE: number = 300;

  //pc宫格是否正方形网格
  public static readonly IS_FULL_RATIO: string = 'IS_FULL_RATIO';
  /**
   * 分类相册需要充电熄屏
   */
  public static readonly CATEGORY_CV_DONE: string = '0';
  /**
   * 源手机有 > 2W 的数据
   */
  public static readonly CATEGORY_OLD_DONE: string = '1';
  /**
   * 目的手机无4097相册的数据
   */
  public static readonly CATEGORY_NEW_EMPTY: string = '1';

  /**
   * 分类相册智慧分析提示框标志位
   */
  public static readonly CATEGORY_NOTE_CANCELED: string = 'persist.photos.category.noteCanceled';
  /**
   * 分类相册智慧分析媒体库KEY
   */
  public static readonly MEDIA_CATEGORY_FRESH: string = 'persist.multimedia.media_analysis_service.categoryfresh.enable';

  public static readonly PORTRAIT_LOAD_FINISH : string = 'PORTRAIT_LOAD_FINISH';
  // 全部同步开关标志位
  public static readonly PHOTO_ALL_ALBUMS_UPLOAD_STATUS: string = 'photos_all_album_upload';
  // 云同步开关批量MAX
  public static readonly UPLOAD_ALBUM_BATCH_SIZE: number = 500;
}