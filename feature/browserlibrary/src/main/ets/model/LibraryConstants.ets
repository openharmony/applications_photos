/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

/**
 * 大图组件化关键常数，封装了大图组件关键监听回调、各个功能子模块关键字信息
 */
export class LibraryConstants {
  // 监听回调关键字
  public static readonly LAST_CAPTURE_MEDIAURI_UPDATE: string = 'lastCaptureMediaUriUpdate';
  public static readonly LOAD_SWIPERVIEW: string = 'loadSwiperview';
  public static readonly EDITOR_INIT: string = 'editorInit';
  public static readonly ORIGIN_LOADING: string = 'originLoading';
  public static readonly MENU_KEY_UPDATE_CALLBACK: string = 'onMenuClickedForUpdate';
  public static readonly MENU_KEY_UPDATE_CALLBACK_PC: string = 'onMenuClickedForUpdatePC';
  public static readonly MENU_KEY_BACK_CALLBACK: string = 'onMenuClickedForBack';
  public static readonly MENU_KEY_INFO_CALLBACK: string = 'onMenuClickedForInfo';
  public static readonly KEY_UPDATE_ACTION_BAR_TITLE: string = 'onUpdateActionBarTitle';
  public static readonly JUMP_TO_SLIDE_SHOW: string = 'jumpToSlideShow';
  public static readonly UPDATE_CURRENT_INDEX: string = 'updateCurrentIndex';
  public static readonly UPDATE_PREPARED_INDEX: string = 'updatePreparedIndex';
  public static readonly UPDATE_HIDE_POPUP: string = 'updateHidePopup';
  public static readonly ON_TOGGLE_BARS_CALLBACK: string = 'onToggleBars';
  public static readonly SHOW_BARS_CALLBACK: string = 'showBars';
  public static readonly HIDE_BARS_CALLBACK: string = 'hideBars';
  public static readonly UPDATE_DELETING: string = 'updateDeleting';
  public static readonly UPDATE_HIDING: string = 'updateHiding';
  public static readonly GET_IS_PULLING_DOWN: string = 'getIsPullingDown';
  public static readonly CONTROLLER_BACK_EVENT: string = 'controllerBackEvent';
  public static readonly PHOTOSHM_CONTROLLER_BACK_EVENT: string = 'photoshmcontrollerBackEvent';
  public static readonly UPDATE_TRANS_ID: string = 'updateTransId';
  public static readonly JUMP_TO_EDIT_PAGE: string = 'jumpToEditPage';
  public static readonly JUMP_TO_WALLPAPER_EDITOR: string = 'jumpToWallpaperEditor';
  public static readonly JUMP_TO_MOVE_TO_ALBUM: string = 'jumpToMoveToAlbum';
  public static readonly EXPORT_TO_VIDEO: string = 'exportToVideo';
  public static readonly UPDATE_SYSTEM_UI: string = 'updateSystemUi';
  public static readonly PULL_DOWN_START: string = 'pullDownStart';
  public static readonly PULL_DOWN_END: string = 'pullDownEnd';
  public static readonly PULL_DOWN_CANCEL: string = 'pullDownCancel';
  public static readonly DELETE: string = 'single_photo_delete';
  public static readonly BROWSER_FULL_SHOW: string = 'browser_full_show';
  public static readonly JUMP_TYPE: string = 'jump_type';
  public static readonly PHOTO_SCALED: string = 'photo_scaled';
  public static readonly VIDEO_SCREENSHOT: string = 'videoScreenshot';
  //视频
  public static readonly VIDEO_IS_MUTE: string = 'videoIsMute';
  public static readonly VIDEO_SOUND_FILLED: string = 'soundFilled';
  public static readonly VIDEO_PLAYING_STATE: string = 'VideoPlayingState';
  public static readonly VIDEO_IS_PLAYING: string = 'isVideoPlaying';
  public static readonly UPDATE_VIDEO_STATE: string = 'updateVideoState';
  public static readonly VIDEO_PLAY: string = 'video_play';
  public static readonly VIDEO_PAUSE: string = 'video_pause';
  public static readonly GET_VIDEO_STATUS: string = 'get_video_status';
  // actionBarView default top padding
  public static readonly ACTION_BAR_VIEW_TOP_PADDING: number = 136;
  //placeHolder for photoItem
  public static readonly PLACEHOLDER_FOR_GEOMETRY_TRANSITION = 'placeholderForGeometryTransition';
  // 大图组件原图解码
  public static readonly EVENT_ON_CURRENT_INDEX_CHANGED: string = 'EVENT_ON_CURRENT_INDEX_CHANGED';
  public static readonly UPDATE_ACTIONBAR_POSITION: string = 'update_actionbar_position';
}

/**
 * 通知相机大图组件点击跳转类型
 * 0表示跳转至图库照片页;
 * 1表示跳转至新建相册页;
 * 2表示返回相机预览页;
 * 4表示跳转到图库设置页
 * 5表示跳转到图库一键对比页
 */
export enum JumpType {
  JUMP_TO_TIMELINE,
  JUMP_TO_SELECTALBUM,
  JUMP_TO_CAMERA,
  JUMP_TO_PORTRAIT_ALBUM,
  JUMP_TO_SETTINGS,
  JUMP_TO_COMPARE,
}