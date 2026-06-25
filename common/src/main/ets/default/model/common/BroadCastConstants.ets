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

export class BroadCastConstants {
  public static readonly SHOW_RESTORE_DEFAULT_ALBUM_SORTING_DIALOG: string = 'showRestoreDefaultAlbumSortingDialog';
  public static readonly ON_DELETE_UI_FIRST: string = 'delete_ui_first';
  public static readonly RESET_TO_IMAGE_SLIDE_INIT_STATE: string = 'resetToImageSlideInitState';
  public static readonly RESET_IMAGE_SLIDE_INIT_STATE: string = 'resetImageSlideInitState';
  public static readonly SELECT: string = 'select';
  public static readonly CAMERA_SELECT: string = 'camera_select';
  public static readonly UPDATE_SELECT_ALBUMINFOS: string = 'updateSelectAlbuminfos';
  public static readonly JUMP_PHOTO_BROWSER: string = 'JumpPhotoPage';
  public static readonly SHOW_DELETE_DIALOG: string = 'showDeleteDialog';
  public static readonly SHOW_DELETE_POPOVER_DIALOG: string = 'showDeletePopoverDialog';
  public static readonly SHOW_HIDDEN_DIALOG: string = 'showHiddenDialog';
  public static readonly HIDE_DELETE_DIALOG: string = 'hideDeleteDialog';
  public static readonly HIDE_HIDDEN_DIALOG: string = 'hideHiddenDialog';
  public static readonly IS_MAP_PROTOCOL_AGREE: string = 'isMapProtocolAgree';
  public static readonly ADD_PEOPLE_TAG: string = 'add_people_tag';
  public static readonly LOAD_PORTRAIT_PAGE: string = 'loadPortraitPage';
  public static readonly FULL_SCREEN: string = 'fullScreen';
  public static readonly RIGHT_CLICK: string = 'rightClick';
  public static readonly CLEAR_RECYCLE: string = 'clearRecycle';
  public static readonly SHOW_REMOVE_DIALOG: string = 'showRemoveDialog';
  public static readonly HIDE_REMOVE_DIALOG: string = 'hideRemoveDialog';
  public static readonly SHOW_MOVE_DIALOG: string = 'showMoveDialog';
  public static readonly HIDE_MOVE_DIALOG: string = 'hideMoveDialog';
  public static readonly IS_CLICK_REMOVE_OR_HIDDEN_DIALOG: string = 'isClickRemoveOrHiddenDialog';
  public static readonly IS_ENTER_BIG_IMAGE: string = 'isEnterBigImage';
  public static readonly UPDATE_PROGRESS: string = 'updateProgress';
  public static readonly CANCEL_DELETE: string = 'cancelDelete';
  public static readonly JUMP_THIRD_PHOTO_BROWSER: string = 'jumpThirdPhotoPage';
  public static readonly PHOTO_BROWSER_ON_PAGE_SHOW: string = 'photoBrowserOnPageShow';
  public static readonly PHOTO_BROWSER_ON_PAGE_HIDE: string = 'photoBrowserOnPageHide';
  // picker宫格已选进大图
  public static readonly JUMP_THIRD_PHOTO_BROWSER_BY_SELECTED: string = 'jumpThirdPhotoPageBySelected';
  public static readonly BACK_PRESS_EVENT: string = 'back';
  public static readonly BACK_PRESS_CENTER: string = 'center';
  public static readonly IS_SHOW_OR_HIDE_BAR: string = 'isShowOrHideBar';
  public static readonly RESET_STATE_EVENT: string = 'resetState';
  public static readonly ON_PAGE_SHOW: string = 'onPageShow';
  public static readonly ON_PAGE_HIDE: string = 'onPageHide';
  public static readonly ON_TAB_CHANGED: string = 'onTabChanged';
  public static readonly CLOUD_CARD_CANCEL: string = 'cloudCardCancel';
  public static readonly CLOUD_CARD_CROSSES_CANCEL: string = 'cloudCardCrossesCancel';
  public static readonly PHOTO_BROWSER_ACTIVE: string = 'photoBrowserActive';
  public static readonly RESET_ZERO: string = 'resetZero';
  public static readonly UPDATE_IS_FAVOR: string = 'updateIsFavor';
  public static readonly UPDATE_ACTIONBAR_MENU: string = 'updateActionBarMenu';
  public static readonly TRIGGER_SEARCH: string = 'triggerSearch';
  public static readonly HIGHLIGHT_UPDATE_BACK: string = 'highlightUpdateBack';
  public static readonly HIGHLIGHT_UPDATE_CAROUSEL: string = 'highlight_update_carousel';
  public static readonly HIGHLIGHT_DELETE_CAROUSEL: string = 'highlight_delete_carousel';
  public static readonly SHOW_PROGRESS_DIALOG: string = 'showProgressDialog';
  public static readonly HIDE_PROGRESS_DIALOG: string = 'hideProgressDialog';
  public static readonly CANCEL_PROGRESS_DIALOG: string = 'cancelProgressDialog';
  public static readonly DELETE_PROGRESS_DIALOG: string = 'deleteProgressDialog';
  public static readonly HIDDEN_PROGRESS_DIALOG: string = 'hiddenProgressDialog';
  public static readonly REMOVE_PROGRESS_DIALOG: string = 'removeProgressDialog';
  public static readonly CANCEL_OPERATE: string = 'cancelOperate';
  public static readonly MEDIA_OPERATION: string = 'mediaOperation';
  public static readonly PC_MEDIA_OPERATION: string = 'pcmediaOperation';
  public static readonly PC_MEDIA_OPERATION_BROWSER: string = 'pcmediaOperationBrowser';
  public static readonly PC_SET_NEW_ALBUM_FOCUS_STATE_OPERATION: string = 'pcSetNewAlbumFocusState';
  public static readonly PICKER_OPERATION: string = 'pickerOperation';
  public static readonly FINISH_PICKER_OPERATION: string = 'finishPickerOperation';
  public static readonly CANCEL_PICKER_OPERATION: string = 'cancelPickerOperation';
  public static readonly OPERATE_CONTINUE: string = 'operateContinue';
  public static readonly OPERATE_PAUSE: string = 'operatePause';
  public static readonly SHOW_RENAME_PHOTO_DIALOG: string = 'showRenamePhotoDialog';
  public static readonly HIDE_RENAME_PHOTO_DIALOG: string = 'hideRenamePhotoDialog';
  public static readonly SHOW_SAVE_PHOTO_DIALOG: string = 'showSavePhotoDialog';
  public static readonly SHOW_CLOUD_FULL_NEG_DIALOG: string = 'showCloudFullNegDialog';
  public static readonly CLOSE_CLEANUP_NO_SPACE_RELEASE_DIALOG: string = 'closeCleanupNoSpaceReleaseDialogFunc';
  public static readonly CLOSE_CLOUD_FULL_NEG_DIALOG: string = 'closeCloudFullNegDialog';
  public static readonly SHOW_DOWNLOAD_PROGRESS_DIALOG: string = 'showDownloadProgressDialog';
  public static readonly SHOW_NETWORK_CONNECTION_SWITCH_DIALOG: string = 'showNetworkConnectionSwitchDialog';
  public static readonly CLOSE_NETWORK_CONNECTION_SWITCH_DIALOG: string = 'closeNetworkConnectionSwitchDialog';
  public static readonly UPDATE_SHOW_MOVING_PHOTO_STATUS: string = 'update_show_moving_photo_status';
  public static readonly SHOW_CLOUD_ENHANCE_PROTOCOL_DIALOG: string = 'showCloudEnhanceProtocolDialog';
  public static readonly HIDE_CLOUD_ENHANCE_PROTOCOL_DIALOG: string = 'closeCloudEnhanceProtocolDialog';
  public static readonly SHOW_CLOUD_ENHANCE_STOPPING_SERVICE_DIALOG: string = 'showCloudEnhanceStoppingServiceDialog';
  public static readonly HIDE_CLOUD_ENHANCE_STOPPING_SERVICE_DIALOG: string = 'closeCloudEnhanceStoppingServiceDialog';
  public static readonly SHOW_CLOUD_ENHANCE_NETWORK_SWITCH_DIALOG: string = 'showCloudEnhanceNetworkSwitchDialog';
  public static readonly CLOSE_CLOUD_ENHANCE_NETWORK_SWITCH_DIALOG: string = 'closeCloudEnhanceNetworkSwitchDialog';
  public static readonly DISABLE_CLOUD_ENHANCE_SERVICE_TOGGLE: string = 'disableCloudEnhanceServiceToggle';
  public static readonly UPDATE_CLOUD_ENHANCE_TRIGGER_STATUS: string = 'update_cloud_enhance_trigger_status';
  public static readonly UPDATE_CLOUD_ENHANCE_CLICKED_STATUS: string = 'update_cloud_enhance_clicked_status';
  public static readonly UPDATE_CLOUD_ENHANCE_PROTOCOL_STATUS: string = 'update_cloud_enhance_protocol_status';
  public static readonly CLOUD_ENHANCE_ACTIONS_ON_PHOTO_CHANGED: string = 'cloud_enhance_actions_on_photo_changed';
  public static readonly CLOUD_ENHANCE_COMPARE: string = 'cloud_enhance_compare';
  public static readonly CLOUD_ENHANCE_COMPARE_IN_SEARCH: string = 'cloud_enhance_compare_in_search';
  public static readonly SHOW_PHOTO_BY_INDEX: string = 'show_photo_by_index';
  public static readonly CLOSE_DOWNLOAD_PROGRESS_DIALOG: string = 'closeDownloadProgressDialog';
  public static readonly SHOW_BATCH_DOWNLOAD_PROGRESS_DIALOG: string = 'showBatchDownloadProgressDialog';
  public static readonly CLOSE_BATCH_DOWNLOAD_PROGRESS_DIALOG: string = 'closeBatchDownloadProgressDialog';
  public static readonly SHOW_EDIT_EXIT_PHOTO_DIALOG: string = 'showEditExitPhotoDialog';
  public static readonly SHOW_NEW_ALBUM_PHOTO_DIALOG: string = 'showNewAlbumPhotoDialog';
  public static readonly HIDE_NEW_ALBUM_PHOTO_DIALOG: string = 'hideNewAlbumPhotoDialog';
  public static readonly SHOW_COPY_OR_MOVE_DIALOG: string = 'showCopyOrMoveDialog';
  public static readonly EXIT_SAVE_PROGRESS_CLOSE: string = 'save_progress_close';
  public static readonly SHOW_EDIT_SAVE_PROGRESS_DIALOG: string = 'show_exit_save_progress_dialog';
  public static readonly SHOW_MEDIA_ANALYSIS_SERVICE_SWITCH_DIALOG: string = 'showMediaAanlysisServiceSwitchDialog';
  public static readonly CLOSE_MEDIA_ANALYSIS_SERVICE_SWITCH_DIALOG: string = 'closeMediaAanlysisServiceSwitchDialog';
  public static readonly ON_DATA_RELOADED: string = 'on_data_reloaded';
  public static readonly ON_DATA_RELOADED_WRAPPED: string = 'on_data_reloaded_wrapped';
  public static readonly SET_BLACK_URI_LIST: string = 'set_black_uri_list';
  public static readonly CLEAR_BLACK_URI_LIST: string = 'clear_black_uri_list';
  public static readonly SAVE_FORM_EDITOR_DATA: string = 'save_form_editor_data';
  public static readonly FA_INSERT_FIRST_ASSET: string = 'fa_insert_first_asset';
  public static readonly INIT_DATE_TEXT: string = 'init_date_text';
  public static readonly THIRD_ROUTE_PAGE: string = 'third_route_page';
  public static readonly ON_DATA_RELOADED_WITH_EDIT: string = 'on_data_reloaded_with_edit';
  public static readonly PHOTO_EDIT_SAVE_URI: string = 'photo_edit_save_uri';
  public static readonly PHOTO_EDIT_REVERT_TO_ORIGIN: string = 'photo_edit_revert_to_origin';
  public static readonly CHANGE_SWIPER_DURATION: string = 'change_swiper_duration';
  public static readonly SEND_COPY_OR_MOVE_BROADCAST: string = 'send_copy_or_move_broadcast';
  public static readonly SHOW_DATE_CHANGE_DIALOG: string = 'show_date_change_dialog';
  public static readonly SHOW_TIME_CHANGE_DIALOG: string = 'show_time_change_dialog';
  public static readonly DO_ANIMATION: string = 'do_animation';
  public static readonly PHOTO_BROWSER_BACK_PRESS_EVENT: string = 'photo_browser_back';
  public static readonly SELECT_PHOTO_BROWSER_BACK_PRESS_EVENT: string = 'select_photo_browser_back';
  public static readonly UPDATE_SELECT: string = 'updateSelect';
  public static readonly UPDATE_SELECT_FOCUS: string = 'updateSelectFocus';
  public static readonly REFRESH_SELECT_DATA: string = 'refreshSelectData';
  public static readonly REFRESH_SELECT_DATA_GROUP: string = 'refreshSelectDataGroup';
  public static readonly REFRESH_SELECT_DATA_TITLE: string = 'refreshSelectDataTitle';
  public static readonly UPDATE_PANEL_INDEX: string = 'updatePanelIndex';
  public static readonly UPDATE_EDIT_ITEM: string = 'updateEditItem';
  public static readonly SWITCH_THIRD_ALBUM: string = 'switch_third_album';
  public static readonly ANIMATE_TO_POSITION: string = 'animate_to_position';
  public static readonly RESET_POSITION: string = 'reset_position';
  public static readonly SET_EDIT_BUTTON_FALSE: string = 'set_edit_button_false';
  public static readonly CURRENT_PHOTO_LOAD_COMPLETED: string = 'current_photo_load_completed';
  public static readonly CURRENT_LCD_LOAD_COMPLETED: string = 'current_lcd_load_completed';
  public static readonly EDIT_PHOTO_LOAD_FAILED: string = 'edit_photo_load_failed';
  public static readonly EDIT_PHOTO_ENTER: string = 'edit_photo_enter';
  public static readonly UPDATE_SYSTEM_UI_ON_EDITOR_EXIT: string = 'update_system_ui_on_editor_exit';
  public static readonly CLOSE_PROGRESS_DIALOG: string = 'close_progress_dialog';
  public static readonly PROGRESS_DIALOG_COMPLETED: string = 'progress_dialog_completed';
  public static readonly PROMPT_NEW_ALBUMS_DIALOG: string = 'promptEmptyAlbumsDialog';
  public static readonly HIDE_PROMPT_DIALOG: string = 'hidePromptDialog';
  public static readonly ALBUM_SELECT: string = 'album_select';
  public static readonly ALBUM_RENAME: string = 'album_rename';
  public static readonly ALBUM_DELETE: string = 'album_delete';
  public static readonly ALBUM_RENAME_ALBUM_TAB: string = 'com.xxx.photos.AlbumSetPage.album_rename';
  public static readonly MOVE_OR_COPY_PHOTO_INTO_EXIST_ALBUM: string = 'move_or_copy_photo_into_exist_album';
  public static readonly PICKER_PAGE_DISAPPEAR: string = 'picker_page_disappear';
  public static readonly PLAY_VIDEO: string = 'play_video';
  public static readonly ON_VIDEO_DOWNLOAD_COMPLETED: string = 'on_video_download_completed';
  public static readonly PLAY_ICON_CLICK_FRAME_EXPAND: string = 'play_icon_click_frame_expand';
  public static readonly STATE_INVERSION: string = 'state_inversion';
  public static readonly UPDATE_SHOW_VIDEO: string = 'update_show_video';
  public static readonly SHOW_LOADING_PROGRESS: string = 'show_loading_progress';
  public static readonly SHOW_COVER_PICTURE: string = 'show_cover_picture';
  public static readonly CAST_MOVING_PHOTO_IS_PLAY: string = 'CAST_MOVING_PHOTO_IS_PLAY';
  public static readonly CAST_MOVING_PHOTO_IS_REPEAT_PLAY: string = 'CAST_MOVING_PHOTO_IS_REPEAT_PLAY';
  public static readonly CLOUD_SHOW_PLACEHOLDER: string = 'cloud_show_placeholder';
  public static readonly SWIPER_INDEX_CHANGED: string = 'swiper_index_changed';
  public static readonly REFRESH_ON_COVERED_BY_EDIT: string = 'refresh_on_covered_by_edit';
  public static readonly RESET_VIDEO_BEFORE_EDIT: string = 'reset_video_before_edit';
  public static readonly UPDATE_MENU_BEFORE_PLAY_VIDEO: string = 'update_menu_before_play_video';
  public static readonly INDEX_CHANGE_BY_DELETE_VIDEO: string = 'index_change_by_delete_video';
  public static readonly VIDEO_PLAY_COMPLETED: string = 'video_play_completed';
  public static readonly PHOTO_SWIPER_INDEX_CHANGED: string = 'photo_swiper_index_Changed';
  public static readonly PHOTO_SWIPER_PREVIEW_CHANGED: string = 'photo_swiper_preview_Changed';
  public static readonly PHOTO_SWIPER_SELECT_CHANGED: string = 'photo_swiper_select_Changed';
  public static readonly UPDATE_MENU_ON_AUDIO_INTERRUPT: string = 'update_menu_on_audio_interrupt';
  public static readonly CHANGE_PLAY_BUTTON_STATUS: string = 'change_play_button_status';
  public static readonly PHOTO_VIDEO_BACK_PRESS: string = 'video_back_press';
  public static readonly PHOTO_PHOTO_BACK_PRESS: string = 'photo_back_press';
  public static readonly PHOTO_VIDEO_BACK_PRESS_BY_MENU: string = 'video_back_press_by_menu';
  public static readonly AUDIO_INTERRUPT_PAUSE: string = 'audio_interrupt_pause';
  public static readonly INIT_VIDEO_PLAY_CONTROLLER: string = 'init_video_play_controller';
  public static readonly LARGE_PHOTO_COMPLETED: string = 'large_photo_completed';
  public static readonly SHOW_LOCK_DIALOG: string = 'showLockDialog';
  public static readonly HIDE_LOCK_DIALOG: string = 'hideLockDialog';
  public static readonly FOLD_PICKER_CONFIRM: string = 'folded_screen_picker_confirm';
  public static readonly REFRESH_VIDEO_STATUS_FOR_PROGRESS: string = 'refresh_video_status_for_progress';
  public static readonly SHORTCUT_KEY_COMPOSE: string = 'shortcut_key_compose';
  public static readonly SETTING_MULTIPLE_CLICKS: string = 'setting_multiple_clicks';
  public static readonly BACK_FROM_IMMERSIVE_COMPARED: string = 'back_from_immersive_compared';
  public static readonly ENTER_IMMERSIVE_COMPARED_PAGE: string = 'enter_immersive_compared_page';
  public static readonly UPDATE_IMMERSIVE_STATUS_BAR_COLOR: string = 'update_immersive_status_bar_color';
  public static readonly CHANGE_ALBUM_CARD_SIZE: string = 'change_album_card_size';
  public static readonly ALBUM_UPDATE_SCALE: string = 'album_update_scale';
  public static readonly PUZZLE_SAVE_DATA: string = 'puzzle_save_data';
  public static readonly PUZZLE_SAVE_PICTURE: string = 'puzzle_save_picture';
  public static readonly PUZZLE_SAVE_COMPLETE: string = 'puzzle_save_complete';
  public static readonly PUZZLE_REPLACE_PICTURE: string = 'puzzle_replace_picture';
  public static readonly PUZZLE_IMAGE_ON_LOAD: string = 'puzzle_image_on_load';
  public static readonly PUZZLE_IMAGE_ON_BACK: string = 'puzzle_image_on_back';
  public static readonly LOCATION_PHOTO_GRID_NUMBER_CHANGE: string = 'location_photo_grid_number_change';
  public static readonly ON_TIMELINE_BAR_COMPLETE: string = 'onTimelineBarComplete';
  public static readonly PHOTO_GRID_REFRESH: string = 'photo_grid_refresh';
  public static readonly HIDE_GRID_VIEW_ACTION_BAR: string = 'hideGridViewActionBar';
  public static readonly ON_SIDEBAR_CHANGED: string = 'on_sidebar_changed';
  public static readonly ON_SIDEBAR_WIDTH_CHANGED: string = 'on_sidebar_width_changed';
  public static readonly UPDATE_SYS_ALBUM_MAP: string = 'updateSysAlbumMap';
  public static readonly SIDEBAR_VIEW_SWITCH: string = 'sidebar_view_switch';
  public static readonly OPEN_SIDEBAR_VIEW: string = 'open_sidebar_view';
  public static readonly COMMON_ABILITY_DATA_INIT: string = 'common_ability_data_init';
  public static readonly COMMON_ABILITY_RESTORE_FA_CARD: string = 'common_ability_restore_fa_card';
  public static readonly IS_PULLING_UP: string = 'is_pulling_up';
  public static readonly BROWSER_DOWNLOAD_TO_GRID: string = 'browser_download_to_grid';
  public static readonly DOWNLOAD_ORIGIN_PHOTO_RESULT: string = 'downloadOriginPhotoResult';
  public static readonly SHOW_DOWNLOAD_PROGRESS: string = 'showDownloadProgress';
  public static readonly CHANGE_LOADING_STATUS: string = 'changeLoadingStatus';
  public static readonly CHANGE_IMAGE_LOADING: string = 'changeImageLoading';
  public static readonly SHOW_SAVE_FAILED_DIALOG: string = 'showSaveFailedDialog';
  public static readonly HIDE_SAVE_FAILED_DIALOG: string = 'hideSaveFailedDialog';
  public static readonly IS_HAVE_THUMBNAIL_CHECK: string = 'isHaveThumbnailCheck';
  public static readonly MAP_MOVING_CHANGE: string = 'map_moving_change';
  public static readonly IS_MOVING_PHOTO_LONG_PRESS_ON: string = 'isMovingPhotoLongPressOn';
  public static readonly IS_SHOW_PHOTO_GRID_BASE_PAGE_OFF: string = 'is_show_photo_gird_base_page_off';
  public static readonly IS_SHOW_PHOTO_BROWSER_SNAPSHOT_OFF: string = 'is_show_photo_browser_snapshot_off';
  public static readonly PHOTO_GRID_BASE_PAGE_BACKPRESS: string = 'photo_grid_base_page_backpress';
  public static readonly UPDATE_PHOTO_GRID_BASE_PAGE: string = 'update_photo_grid_base_page';
  public static readonly LAZY_LOAD_INDEX_PAGE: string = 'lazy_load_index_page';

  public static readonly SHOW_DETAIL_DIALOG: string = 'showDetailDialog';
  public static readonly SHOW_MULTI_SELECT_DIALOG: string = 'showMultiSelectDialog';

  //AI
  public static readonly PORTRAIT_COVER_SET_COMPLETE: string = 'portrait_cover_set_complete';
  public static readonly PORTRAIT_ITEM_CHANGED_COMPLETE: string = 'portrait_item_changed_complete';
  public static readonly PORTRAIT_DATA_RELOAD_COMPLETE: string = 'portrait_data_reload_complete';
  public static readonly PORTRAIT_CARD_RELOAD: string = 'portrait_card_reload';
  public static readonly TO_IMMERSIVE_COMPARED_PAGE: string = 'to_immersive_compared_page';
  public static readonly VIDEO_START_AI_ANALYZER: string = 'video_start_ai_analyzer';
  public static readonly VIDEO_STOP_AI_ANALYZER: string = 'video_stop_ai_analyzer';
  public static readonly UPDATE_SIDEBAR_PORTARIT_DATA: string = 'udpate_sidebar_portrait_data';

  public static readonly UPDATE_REPEAT_PICK_TIMES: string = 'update_repeat_pick_times';
  public static readonly AI_OCR_CACHE_DATA_IS_READY: string = 'ai_ocr_cache_data_is_ready';
  public static readonly GET_VIDEO_FRAME_FOR_PREVIEW: string = 'get_video_frame_for_preview';
  public static readonly FIRST_CLICK_TO_PLAY_VIDEO: string = 'first_click_to_play_video';
  public static readonly CLOSE_TAB_SELECTED_INDEXES_CHANGING: string = 'close_tab_selected_indexes_changing';
  public static readonly GROUP_DATA_RELOAD_COMPLETE: string = 'group_data_reload_complete';
  public static readonly THIRD_PICKER_ALBUM_GIRD_CLOSE: string = 'third_picker_album_gird_close';
  //是否点击相册页删除按钮
  public static readonly HAS_CLICKED_ALBUM_DELETE_BUTTON: string = 'has_clicked_album_delete_button';
  public static readonly OPEN_OR_CLOSE_PHOTO_BROWSER: string = 'open_or_close_photo_browser';
  public static readonly OPEN_OR_CLOSE_PHOTO_BROWSER_ANIM: string = 'open_or_close_photo_browser_anim';
  public static readonly UPDATE_TITLE: string = 'update_title';
  public static readonly UPDATE_BACK: string = 'update_back';
  public static readonly PERCEPTION_ALBUM: string = 'perception_album';
  public static readonly UPDATE_TRIGGER_VALUE: string = 'update_trigger_value';
  public static readonly UPDATE_TRIGGER_VALUE_ACTION_BAR: string = 'UPDATE_TRIGGER_VALUE_ACTION_BAR';
  //cast
  public static readonly CAST_UPDATE_SURFACE: string = 'cast_update_surface';
  public static readonly CAST_UPDATE_SURFACE_BY_CAST: string = 'cast_update_surface_by_cast';
  public static readonly CAST_START_ABILITY: string = 'cast_start_ability';
  public static readonly CAST_STOP_ABILITY: string = 'cast_stop_ability';
  public static readonly CAST_MANAGER_STOP_ABILITY: string = 'cast_manager_stop_ability';
  public static readonly CAST_UPDATE_GESTURE: string = 'cast_update_gesture';
  public static readonly CAST_INDEX_CHANGED: string = 'cast_index_changed';
  public static readonly CAST_POSITION_CHANGED: string = 'cast_position_changed';
  public static readonly CAST_IMAGE_SCALE: string = 'cast_image_scale';
  public static readonly CAST_SHOW_COVER: string = 'cast_show_cover';
  public static readonly CAST_SET_SHOW_COVER = 'cast_set_show_cover';
  public static readonly CAST_IMAGE_SCALE_READY: string = 'cast_image_scale_ready';
  public static readonly CAST_IMAGE_PIXELMAP_READY: string = 'cast_image_pixelmap_ready';
  public static readonly IS_PULLING_DOWN: string = 'is_pulling_down';
  public static readonly CURRENT_DELETE_UNIQUEID: string = 'currentDeleteUniqueId';
  public static readonly IMMERSIVE_COMPARED_ORIGIN_DOWNLOAD_DONE: string = 'immersive_compared_origin_download_done';
  public static readonly COLLAGE_ORIGIN_DOWNLOAD_DONE: string = 'collage_origin_download_done';
  public static readonly JUMP_TO_CAMARA: string = 'jump_to_camera';
  public static readonly CAST_UPDATE_POSITION: string = 'cast_update_position';
  public static readonly QUIT_SEARCH_MAIN_PAGE: string = 'QuitSearchMainPage';
  public static readonly CAST_REFRESH_SIZE_BY_EDIT: string = 'cast_refresh_size_by_edit';
  // subScreen
  public static readonly PAUSE_FROM_SUB_SCREEN: string = 'pause_from_sub_screen';
  public static readonly PLAY_FROM_SUB_SCREEN: string = 'play_from_sub_screen';
  public static readonly CHANGE_IS_PAUSE: string = 'change_is_pause';
  public static readonly SHOW_SUB_SCREEN_DELETE_DIALOG: string = 'show_sub_screen_delete_dialog';
  public static readonly HIDE_SUB_SCREEN_DELETE_DIALOG: string = 'hide_sub_screen_delete_dialog';
  public static readonly CLICK_BACK_PRESS: string = 'click_back_press';
  // shortcut
  public static readonly DELETE_MEDIA: string = 'delete_media';
  public static readonly SAVE_IMAGE: string = 'save_image';
  public static readonly SAVE_AS_IMAGE: string = 'save_as_image';
  public static readonly EDIT_VALUE_ADD: string = 'edit_value_add';
  public static readonly EDIT_VALUE_SUB: string = 'edit_value_sub';
  public static readonly EDIT_VALUE_CHANGE_END: string = 'edit_value_change_end';
  public static readonly CROP_HEIGHT_ADD: string = 'crop_height_add';
  public static readonly CROP_HEIGHT_SUB: string = 'crop_height_sub';
  public static readonly CROP_WIDTH_ADD: string = 'crop_width_add';
  public static readonly CROP_WIDTH_SUB: string = 'crop_width_sub';
  public static readonly MEDIA_LARGER: string = 'media_larger';
  public static readonly MEDIA_SMALLER: string = 'media_smaller';
  // 请求ActionBar区域获取焦点
  public static readonly REQUEST_ACTIONBAR_FOCUS: string = 'request_actionbar_focus';
  public static readonly SHORTCUT_DELETE: string = 'shortcut_delete';
  public static readonly DELETE_ALBUM_INSIDE: string = 'delete_album_inside';
  public static readonly DELETE_ALBUM_OUTSIDE: string = 'delete_album_outside';
  public static readonly SELECT_ALL: string = 'select_all';
  public static readonly COPY_MEDIA: string = 'copy_media';
  public static readonly COPY_BROWSER_MEDIA: string = 'copy_browser_media';
  public static readonly EDIT_REDO: string = 'edit_redo';
  public static readonly SELECT_TEXT_STATUS: string = 'select_text_status';
  public static readonly EDIT_UNDO: string = 'edit_undo';
  public static readonly CHANGE_ALBUM_COVER: string = 'change_album_cover';
  public static readonly RESTORE_ALBUM_COVER: string = 'restore_album_cover';
  public static readonly CLEAR_SELECT: string = 'clear_select';
  public static readonly MENU_ACTION_FROM_PHOTO_ITEM: string = 'menu_action_from_photoItem';
  public static readonly MENU_ACTION_FROM_PHOTO_CAMERA: string = 'menu_action_from_photo_camera';
  public static readonly PASTE_MEDIA: string = 'paste_media';
  public static readonly PASTE_END_RELOAD: string = 'paste_end_reload';
  public static readonly SHORTCUT_SEARCH: string = 'shortcut_search';
  public static readonly SINGLE_PHOTO_DELETE: string = 'single_photo_delete';
  public static readonly HIDDEN_ALBUM_GRID_PRESS: string = 'hidden_album_grid_back_to_alum';
  public static readonly SELECT_CONFIRM: string = 'select_confirm';
  public static readonly UPDATE_PHOTO_BROWSER_SELECT_STATUS: string = 'update_photo_browser_select_status';
  public static readonly CLICK_SIDE_BAR_CONTAINER: string = 'click_side_bar_container';
  public static readonly CLICK_SIDE_BAR_ITEM: string = 'click_side_bar_item';
  public static readonly UPDATE_SWIPER_ANIMATION_STATE: string = 'update_swiper_animation_state';
  public static readonly UPDATE_SWIPER_ANIMATION: string = 'update_swiper_animation';
  public static readonly UPDATE_ACTION_BAR_COLOR: string = 'update_action_bar_color';
  public static readonly CLOSE_CLICK_DETAIL_BY_BACK_PRESS: string = 'close_click_detail_by_back_press';
  public static readonly UPDATE_TIME_LINE_SELECTED: string = 'update_time_line_select';
  public static readonly BROWSER_ON_BACK_PRESS: string = 'browser_on_back_press';
  public static readonly REPLACE_PHOTO_PICKER_PREVIEW: string = 'replace_uri';
  public static readonly SAVE_CALLBACK: string = 'save_callback';
  public static readonly UPDATE_LAYOUT_OPTIONS: string = 'updateLayoutOptions';
  public static readonly UPDATE_RECOVER_INFO_AFTER_GET_ANCHOR: string = 'updateRecoverInfoAfterGetAnchor';
  public static readonly RE_SCROLL_AFTER_DATA_LOADED: string = 'reScrollAfterDataLoaded';
  public static readonly UPDATE_PAGE_INDEX: string = 'update_page_index';
  public static readonly UPDATE_PICKER_IMAGE_DISPLAY_HEIGHT: string = 'update_picker_image_display_height';
  public static readonly UPDATE_IS_PICKER_SPLIT_SCREEN: string = 'update_is_picker_split_screen';
  public static readonly UPDATE_IS_HALF_SCREEN: string = 'update_is_half_screen';
  public static readonly UPDATE_IMAGE_HEIGHT: string = 'update_image_height';
  public static readonly UPDATE_STACK_HEIGHT: string = 'update_stack_height';
  public static readonly UPDATE_PICKER_DISPLAY_HEIGHT: string = 'update_picker_display_height';
  public static readonly JUMP_TO_BURST: string = 'jump_to_burst';
  public static readonly JUMP_TO_FIRST_BROWSER: string = 'jump_to_first_browser';
  public static readonly UPDATE_TOP_MODE_BUILDER_OPACITY: string = 'update_top_mode_builder_opacity';
  public static readonly UPDATE_BURST_TOP_MODE_BUILDER_OPACITY: string = 'update_burst_top_mode_builder_opacity';
  // 逐帧播放: 进度条时间点更新
  public static readonly UPDATE_PROGRESS_RAW_TIME: string = 'update_progress_raw_time';
  public static readonly UPDATE_VIDEO_WIDTH: string = 'update_video_width';
  public static readonly ON_SWIPER_ANIMATION_CHANGE: string = 'on_swiper_animation_change';
  public static readonly SET_SLIDE_BAR_TIMER: string = 'set_slide_bar_timer';
  public static readonly SET_IS_SLIDE_BAR_HOVER: string = 'set_is_slide_bar_hover';
  public static readonly SET_PHOTO_BROWSER_ITEM: string = 'setPhotoBrowserItem';
  public static readonly PREVIEW_NOTIFY_PHOTO: string = 'previewNotifyPhoto';
  public static readonly PREVIEW_ENTER_PHOTO_BROWSER: string = 'previewEnterPhotoBrowser';
  public static readonly PREVIEW_EXIT_PHOTO_BROWSER: string = 'previewExitPhotoBrowser';
  /**
   * 文件管理跳转到相册首页
   */
  public static readonly JUMP_TO_ALBUM_FOR_FILE_MANAGER: string = 'jump_to_album_for_file_manager';
  // 动态照片
  public static readonly SET_IS_SWITCHING: string = 'set_is_switching';
  public static readonly EFFECT_MODE_SWITCH_CLICKED: string = 'effect_mode_switch_clicked';
  public static readonly SET_IS_DOWNLOADING: string = 'set_is_downloading';
  public static readonly REFRESH_MOVING_PHOTO_AFTER_REQ: string = 'refresh_moving_photo_after_req';
  public static readonly MOVING_PHOTO_LOADING_PROGRESS: string = 'moving_photo_loading_progress';
  public static readonly ON_LEAVE_CURRENT_WINDOW: string = 'on_leave_current_window';
  public static readonly OPEN_MOVING_PHOTO_FROM_LIBRARY: string = 'open_moving_photo_from_library';
  public static readonly SET_WAITING_DONE_CALLBACK: string = 'set_waiting_done_callback';
  public static readonly MOVING_PHOTO_DOWNLOAD_CALLBACK: string = 'moving_photo_download_callback';
  public static readonly MOVING_PHOTO_STOP_DOWNLOAD: string = 'moving_photo_stop_download';
  public static readonly MOVING_PHOTO_START_DOWNLOAD: string = 'moving_photo_start_download';
  public static readonly MOVING_PHOTO_RESTART: string = 'moving_photo_restart';
  public static readonly QUALITY_CHANGE_REFRESH: string = 'quality_change_refresh';
  public static readonly SLIDESHOW_CHANGE_INDEX: string = 'slideShowChangeIndex';
  // swiper主动切换
  public static readonly SWIPER_CHANGE_AFTER_CONVERT: string = 'swiperChangeAfterConvert';
  public static readonly SHOW_CONVERT_LOADING_PANEL: string = 'showConvertLoadingPanel';
  /**
   * 模块全限定名，防止广播等发生冲突
   */
  public static readonly PHOTO_SEARCH: string = 'com.ohos.photos.search_';
  public static readonly PROTAGONIST_PLANET_PAGE: string = 'com.ohos.protagonist_planet_';
  /**
   * 搜索page进入前台
   */
  public static readonly ON_PHOTO_SEARCH_PAGE_SHOW: string =
    `${BroadCastConstants.PHOTO_SEARCH}ON_PHOTO_SEARCH_PAGE_SHOW`;
  /**
   * 搜索page进入后台
   */
  public static readonly ON_PHOTO_SEARCH_PAGE_HIDE: string =
    `${BroadCastConstants.PHOTO_SEARCH}ON_PHOTO_SEARCH_PAGE_HIDE`;
  public static readonly ON_PHOTO_SEARCH_BACK_PRESS: string =
    BroadCastConstants.PHOTO_SEARCH + 'on_photo_search_back_press';
  public static readonly ON_PROTAGONIST_PLANET_BACK_PRESS: string =
    BroadCastConstants.PROTAGONIST_PLANET_PAGE + 'on_photo_protagonist_planet_press';
  public static readonly ON_STORY_COLLECTION_BACK_PRESS: string =
    BroadCastConstants.PROTAGONIST_PLANET_PAGE + 'on_photo_story_collection_press';
  public static readonly UPDATE_PHOTO_BROWSER_UI_ELEMENT_VISIBILITY: string = 'updatePhotoBrowserUIElementVisibility';
  /**
   * 大图上划详情区域点击事件
   */
  public static readonly ON_PROPERTIES_ITEM_CLICKED: string = 'onPropertiesItemClicked';
  /**
   * 使用真正业务帧替换临时宫格帧
   */
  public static readonly SWITCH_GRID_HIDE_PREVIEW: string = 'switch_grid_view_preview';
  /**
   * 展示真正组件
   */
  public static readonly SWITCH_GRID_VIEW_RAW: string = 'switch_grid_view_raw';
  public static readonly PICKER_SINGLE_LINE_MODE_PREVIEW_IMG_CREATED: string =
    'picker_single_line_mode_preview_img_created';
  public static readonly ROUTE_TO_PORTRAIT_PAGE: string = 'routeToPortraitPage';
  /**
   * 跳转到设置页面
   */
  public static readonly ROUTE_TO_SETTINGS_PAGE: string = 'routeToSettingsPage';

  /**
   * 为云增强添加临时currentindex变化广播，不允许其余地方监听该广播，云增强后续重构后，需删除该广播
   */
  public static readonly TMP_CURRENT_INDEX_CHANGE: string = 'current_index_change';
  /**
   * 一碰传视频按钮显隐
   */
  public static readonly SHARE_IS_SHOW_PLAY_BUTTON: string = 'share_is_show_play_button';
  // 是否链接wifi
  public static readonly WIFI_CONN_STATE: string = 'wifi_conn_state';
  public static readonly CLOSE_MEDIA_ANALYSIS_SERVICE: string = 'CLOSE_MEDIA_ANALYSIS_SERVICE';
  /**
   * 编辑保存返回
   */
  public static readonly EDITOR_SAVE_BACK_PHOTOITEM: string = 'editor_save_back_photoItem';
  public static readonly HIDE_ALBUM: string = 'hide_albums';
  public static readonly ACCESS_HIDE_ALBUM_PAD: string = 'access_hide_albums_pad';
  /**
   * 返回左侧边栏第一个相册页面，可以用于隐藏相册一级宫格返回
   */
  public static readonly BACK_TO_FIRST_ALBUM_PAD_AND_PC: string = 'back_to_first_album_pad_and_pc';
  /**
   * 隐藏相册二级宫格返回
   */
  public static readonly HIDDEN_GRID_VIEW_BACK_PAD_AND_PC: string = 'hidden_grid_view_back_pad_and_pc';

  // 搜索二级界面侧滑返回
  public static readonly SEARCH_GRID_VIEW_PC_BACK_PRESS: string = 'search_grid_view_pc_back_press';

  /**
   * 相册排序
   */
  public static readonly SORT_ALBUMS: string = 'sort_albums';

  // 进入大图恢复url
  public static readonly RECOVER_SHOW_RESOURCE: string = 'recoverShowResource';
  public static readonly EXTERNAL_STORAGE_SHOW: string = 'external_storage_show';
  public static readonly EXTERNAL_STORAGE_NOT_SHOW: string = 'external_storage_not_show';
  // 退出后台停止ready机制
  public static readonly STOP_TIMELINE_READY_PROGRESS: string = 'stopTimeLineReadyProgress';
  // 取消多选时更新标题属性
  public static readonly ON_CANCEL_MULTISELECT: string = 'on_cancel_multiselect';
  // 打开、关闭图片编辑的广播
  public static readonly OPEN_PIC_CLICK_EDIT: string = 'open_pic_click_edit';
  // picker宫格进入大图
  public static readonly OPEN_BROWSER_IN_SELECT_VIEW: string = 'open_browser_in_select_view';
  // picker大图模式中点击下面缩略图通知宫格到对应的index
  public static readonly PICKER_NOTIFY_SCROLL_INDEX: string = 'picker_notify_scroll_index';
  // 大图退回picker宫格
  public static readonly CLOSE_BROWSER_AND_RETURN_TO_SELECT_VIEW: string = 'close_browser_and_return_to_select_view';
  // PhotoPickerComponent 切换相册
  public static readonly PHOTO_PICKER_COMPONENT_SWITCH_ALBUM: string = 'photo_picker_component_switch_album';
  // PhotoPickerComponent 应用锁状态更新
  public static readonly PHOTO_PICKER_APP_LOCK_STATUS_UPDATED: string = 'photo_picker_app_lock_status_updated';
  // PhotoPickerComponent  CAMERA拍照返回触发
  public static readonly PHOTO_PICKER_ONSHOW_CAMERA: string = 'PHOTO_PICKER_ONSHOW_CAMERA';
  // picker恢复现场刷新非视频资源的宫格数量
  public static readonly UPDATE_UN_DATA_GRID_COUNT: string = 'update_un_data_grid_count';
  // 进入相册封面选择页面
  public static readonly SHOW_ALBUM_COVER_CHANGE_SHEET: string = 'show_album_cover_change_bind_sheet';
  public static readonly CLOSE_ALBUM_COVER_CHANGE_SHEET: string = 'close_album_cover_change_bind_sheet';
  // 在平板模式, 通过侧边栏的系统相册进入搜索页面
  public static readonly SHOW_SEARCH_PAGE_BY_SIDE_BAR_ALBUM: string = `${BroadCastConstants.PHOTO_SEARCH}show_search_by_side_bar`;

  // 长按倍速
  public static readonly SHOW_FAST_PLAY_LABEL: string = 'show_fast_play_label';

  /**
   * 大图上向左、右点击事件
   */
  public static readonly TURN_LEFT_OR_RIGHT_ITEM_CLICKED: string = 'turnLeftOrRightItemClicked';
  // 卡片进大图懒加载组件，大图加载完成通知
  public static readonly COMP_LOAD_COMPLETED: string = 'photo_browser_comp_load_completed';
  //更新搜索按钮
  public static readonly UPDATE_PC_SEARCH_ICON: string = 'update_pc_search_icon';
  public static readonly HIGHLIGHT_PROGRESS_REFRESH: string = 'highlight_progress_refresh';
  public static readonly CHANGE_SEARCH_RESULT_PAGE_VISIBILITY: string = 'change_search_result_page_visibility';
  public static readonly CHANGE_CATEGORY_ALBUM_VIEW_VISIBILITY: string = 'change_category_album_view_visibility';
  public static readonly CHANGE_PORTRAIT_ALBUM_PAGE_VISIBILITY: string = 'change_portrait_album_page_visibility';
  /**
   * 最近删除清理页退出
   */
  public static readonly PROCESS_RECENTLY_DELETED_PAGE_BACK: string = 'onHandBackFunc';
  public static readonly PROCESS_VIDEO_PAGE_BACK: string = 'onBackPressFunc';
  public static readonly IS_PULLING_UP_CHANGE: string = 'IS_PULLING_UP_CHANGE';
  public static readonly IS_IMMERSIVE_MODE_CHANGE: string = 'isImmersiveModeChange';
  public static readonly SIDEBAR_CHANGE_BREAKPOINT: string = 'sidebar_change_breakpoint';

  /**
   * GRL产品定制xxx通知
   */
  public static readonly SHOW_RENAME_BIND_SHEET: string = 'showRenameBindSheet';
  public static readonly HIGHLIGHT_CHANGE_TITLE: string = 'changeTitle';

  // 框架上报的视频状态
  public static readonly VIDEO_STATUS_REPORTED: string = 'video_status_reported';

  // 个性风格undo、redo
  public static readonly XT_STYLE_UNDO_REDO: string = 'XTStyle_undo_redo';

  // 个性风格读取数据库更新默认值
  public static readonly XT_STYLE_LIST_UPDATE: string = 'XTStyle_list_update';

  /**
   * 图库卡片
   */
  public static readonly UPDATE_FA_CARD_URI: string = 'update_fa_card_uri';

  public static readonly SET_CURRENT_IMAGE_URI: string = 'set_current_image_uri';

  // 更新snapshot的image，避免两个PhotoBrowserComponent存在
  public static readonly UPDATE_SNAPSHOT_IMAGE_URI: string = 'update_snapshot_image_uri';

  // 从卡片跳转大图时，变更index page的退场动效
  public static readonly CHANGE_PAGE_EXIT_TRANSITION: string = 'change_page_exit_transition';

  // 独占事件
  public static readonly OCCUPY_EVENTS: string = 'occupyEvents';

  /**
   * Popup显隐事件
   */
  public static readonly ACTION_POPUP_SHOW_EVENT: string = 'com.ohos.photos.action_popup.onPopupShow';

  //返回按钮事件
  public static readonly BACK_EVENTS: string = 'back_events';

  /**
   * PC设置壁纸
   */
  public static readonly SET_WALLPAPER: string = 'set_wallpaper';

  //右键菜单撤销事件
  public static readonly RIGHT_CLICK_UNDO: string = 'right_click_undo';

  //右键菜单恢复事件
  public static readonly RIGHT_CLICK_REDO: string = 'right_click_redo';

  // 是否显示分段按钮
  public static readonly IS_SHOW_SEGMENT: string = 'isShowSegment';

  /**
   * 年日期更新 后续需要从广播中整改走：多相册支持年视图的需求场景下涉及全局变量污染
   */
  public static readonly YEAR_UPDATE: string = 'yearDateUpdate';

  /**
   * 更新云同步卡片显示状态
   */
  public static readonly UPDATE_CLOUD_CARD_STATE: string = 'UpdateCloudCardState';

  /**
   * 月日期更新 同上需要整改
   */
  public static readonly MONTH_UPDATE: string = 'monthDateUpdate';

  /**
   * HDR错峰
   */
  public static readonly ENABLE_HDR: string = 'enable_hdr';
  /**
   * 时刻标题更新
   */
  public static readonly UPDATE_HIGHLIGHT_TITLE: string = 'updateHighlightTitle';

  /**
   * 时刻艺术字更新
   */
  public static readonly UPDATE_HIGHLIGHT_WORD_ART: string = 'updateHighLightWordArt';

  /**
   * 快速进出同一张大图执行一镜到底动画
   */
  public static readonly BROWSER_ANIM_SHOW: string = 'browserAnimShow';

  /**
   * 宫格显示日期
   */
  public static readonly ALBUM_GRID_DATE_SHOW: string = 'albumGridDateShow';
  public static readonly UPDATE_PLACEHOLER_INDEX: string = 'updatePlaceHolder';
  public static readonly HIDE_BROWSER_BARS: string = 'hideBrowserBars';

  /**
   * pc宫格正方形展示
   */
  public static readonly UPDATE_ALBUM_GRID_FULL_RATIO: string = 'updateAlbumGridFullRatio';

  /**
   * 侧边栏按钮点击事件
   */
  public static readonly SIDEBAR_DRAWER_CONVERT: string = 'sidebarDrawerConvert';

  /**
   * 从宫格进大图时隐藏滚动条日期胶囊
   */
  public static readonly JUMP_TO_PHOTO_BROWSER: string = 'jump_to_photo_browser';
  public static readonly EXTRA_WIDTH_CHANGE: string = 'extraWidthChange';
  public static readonly SIDEBAR_CHANGE: string = 'sideBarChange';
  public static readonly ROUTE_TO_PORTRAIT_PAGE_FROM_SEARCH: string = 'routeToPortraitPageFromSearch';

  // phone的编辑页按键广播
  public static readonly PHONE_EDIT_PAGE_PRESS_ESC: string = 'phoneEditPagePressEsc';
  public static readonly PHONE_EDIT_PAGE_PRESS_SAVE_OVERRIDE: string = 'phoneEditPagePressSaveOverride';
  public static readonly PHONE_EDIT_PAGE_PRESS_SAVE_AS: string = 'phoneEditPagePressSaveAs';
  public static readonly PHONE_EDIT_PAGE_PRESS_UNDO: string = 'phoneEditPagePressUndo';
  public static readonly PHONE_EDIT_PAGE_PRESS_REDO: string = 'phoneEditPagePressRedo';

  // 大图扫描二维码
  public static readonly QRCODE_UPDATE: string = 'QRcode_update';
  public static readonly QRCODE_GET_ITEM: string = 'QRCODE_GET_ITEM';
  public static readonly TAB_CURRENT_INDEX_CHANGE: string = 'TabCurrentIndexChange';

  // 时刻卡片进入时刻时，设置当前轮播时刻albumUri
  public static readonly SET_CURRENT_HIGHLIGHT_ALBUM_URI: string = 'set_current_highlight_album_uri';
  public static readonly PHOTO_PREVIEW_CHANGED_CLOSED_INFO: string = 'photoPreviewChangedClosedInfo';

  /**
   * 合影相册
   */
  public static readonly SHOW_REMOVE_FROM_GROUP_COMPLETE_DIALOG: string = 'showRemoveFromGroupCompleteDialog';
  public static readonly HIDE_REMOVE_FROM_GROUP_DIALOG: string = 'hideRemoveFromGroupDialog';
  public static readonly REMOVE_FROM_GROUP_COMPLETE_DIALOG: string = 'removeFromGroupCompleteDialog';
  public static readonly GROUP_ADD_PHOTO: string = 'groupAddPhoto';
  public static readonly LOAD_REPLACE_COVER: string = 'loadReplaceCover';
  public static readonly GROUP_RENAME: string = 'groupRename';

  //地点相册，地图和城市切换时，selectedItem要恢复为空
  public static readonly CLEAR_SELECTED_ITEM: string = 'clearSelectedItem';

  /**
   * 大图显示壁纸设置页
   */
  public static readonly SHOW_WALLPAPER: string = 'showWallpaper';

  //enter键广播，当前用于搜索界面添加搜索历史;
  public static readonly ENTER_HISTORY_INFO: string = 'EnterHistoryInfo';
  public static readonly REMOVE_PORTRAIT_CARD_BY_URI: string = 'removePortraitCardByUri';

  /**
   * 云相册同步数据接收广播
   */
  public static readonly BOARDCAST_CLOUD_ALBUM_LOAD_FINISH: string = 'boardCastCloudAlbumLoadFinish';
}

export enum Condition {
  START,
  END
}