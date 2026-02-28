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

import lazy Curves from '@ohos.curves';
import lazy image from '@ohos.multimedia.image';

// 拍摄模式
export enum ShootingModeType {
  NONE = '0',
  PORTRAIT_ALBUM = '23', // 人像
  WIDE_APERTURE_ALBUM = '19', //大光圈
  NIGHT_SHOT_ALBUM = '42', // 夜景
  FRONT_NIGHT_SHOT_ALBUM = '7', // 前置夜景
  MOVING_PICTURE_ALBUM = '20', // 实况照片
  PRO_PHOTO_ALBUM = '2', // 专业模式
  SLOW_MOTION_ALBUM = '6', // 慢动作
  HIGH_PIXEL_ALBUM = '52', // 高像素
  SUPER_MACRO_ALBUM = '47', // 微距
  TAIL_LIGHT = '9', // 车水马龙
  LIGHT_GRAFFITI = '10', // 绚丽星轨
  SILKY_WATER = '11', // 丝绢流水
  STAR_TRACK = '12', // 光绘涂鸦
  PANORAMA = '8', // 全景
  DOCUMENT_CORRECTION = '15', // 文档校正
  SNAPSHOT = '63', // 快拍
  FLUORESCENCE_PHOTOGRAPHY = '67', // 荧光摄影
  FLASH_SHOOT = '62', // 闪拍
  PASSION_FRUIT = '77' // 百香果
}

// XXX模式
export enum DragonFruitTemplateNameType {
  N = '1',
  F = '2',
  C = '3',
  A = '4',
  V = '5',
  B = '6',
  H = '7'
}

// XMAGE风格
export enum XMageColorModeType {
  ORIGINAL = '0', // 原色
  VIVID = '1', // 鲜艳
  BRIGHT = '2', // 明快
  MONO = '3' // 黑白
}

// 焦距模式
export enum FocusModeType {
  AF = '2',
  MF = '3',
}

// 视频类型
export enum VideoType {
  SDR,
  HDR
}

// 文件后缀名
export enum SuffixType {
  HEIC = 'HEIC',
  HEIF = 'HEIF'
}

// 编辑的资源类型
export enum EditType {
  NONE = 'NONE',
  IMAGE = 'IMAGE',
  VIDEO = 'VIDEO',
  MOVING_PHOTO = 'MOVING_PHOTO',
}

// 初始大图旋转方向
export enum FirstRotationDirection {
  POSITIVE_ANGLE = -1,
  NEGATIVE_ANGLE = 1,
}

// 大图状态
export enum LargePictureBrowsingStatus {
  // 处于非大图模式
  ZERO = '0',

  // 处于大图模式
  ONE = '1'
}

// 设置-隔空分享能力开关
export enum ItemAirShareSwitchStatus {
  CLOSE = '0',
  OPEN = '1'
}

export class Constants {
  // fileAsset path data
  public static readonly KEY_FILE_DATA: string = 'data';
  // Immersive animation duration
  public static readonly IMMERSE_ANIM_DURATION = 200;
  public static readonly IMMERSE_ANIM_DELAY = 50;
  // click event
  public static readonly TOGGLE_BAR: string = 'single_photo_toggle_bar';
  // click event folding screen show toggle bar
  public static readonly SHOW_TOGGLE_BAR: string = 'folding_screen_show_toggle_bar';
  // hide bars
  public static readonly HIDE_BARS: string = 'single_photo_hide_bars';
  // show bars
  public static readonly SHOW_BARS: string = 'single_photo_show_bars';
  // pull down to return start
  public static readonly PULL_DOWN_START: string = 'single_photo_pull_down_start';
  // pull down to return end
  public static readonly PULL_DOWN_END: string = 'single_photo_pull_down_end';
  // pull down to return cancel
  public static readonly PULL_DOWN_CANCEL: string = 'single_photo_pull_down_cancel';
  // notify browser full show status when pull down
  public static readonly BROWSER_FULL_SHOW: string = 'browser_full_show';
  // pull down to return threshold
  public static readonly PULL_DOWN_THRESHOLD: number = 200;
  // data quantity change
  public static readonly DATA_SIZE_CHANGED: string = 'photo_data_size_changed';
  // set menu group photoItem
  public static readonly SET_MENU_GROUP_PHOTO_ITEM: string = 'set_menu_group_photo_item';
  // current data change
  public static readonly DATA_CONTENT_CHANGED: string = 'photo_data_content_changed';
  // video play
  public static readonly VIDEO_PLAY: string = 'single_photo_video_play';
  // video pause
  public static readonly VIDEO_PAUSE: string = 'single_photo_video_pause';
  // popup show
  public static readonly POP_APPEAR: string = 'single_photo_popup_appear';
  // popup disappear
  public static readonly POP_DISAPPEAR: string = 'single_photo_popup_disappear';
  // set favor photo
  public static readonly SET_FAVOR: string = 'single_photo_set_favor';
  // rename photo
  public static readonly RENAME: string = 'single_photo_rename';
  // rotate photo
  public static readonly ROTATE: string = 'single_photo_rotate';
  // delete photo
  public static readonly DELETE: string = 'single_photo_delete';
  // remove photo
  public static readonly REMOVE: string = 'single_photo_remove';
  // delete photo single
  public static readonly SINGLE_DELETE: string = 'photo_delete_single';
  // photo show state
  public static readonly PHOTO_SHOW_STATE: string = 'single_photo_show_state';
  // set swiper can swipe
  public static readonly SET_DISABLE_SWIPE: string = 'set_disable_swipe';
  // update photo name
  public static readonly UPDATE_PHOTO_NAME: string = 'update_photo_name';
  // reset default scale
  public static readonly RESET_DEFAULT_SCALE: string = 'reset_default_scale';
  public static readonly FILLET_SERRATION_COLOR: string = '#FF6A6A6A';
  public static readonly EDITOR_SWITCH_TOTAL_DURATION: number = 300;
  public static readonly EDITOR_SWITCH_PC_TOTAL_DURATION: number = 200;
  public static readonly EDITOR_SWITCH_IN_DURATION: number = 200;
  public static readonly EDITOR_SWITCH_OUT_DURATION: number = 200;
  public static readonly EDITOR_SWITCH_ANIMATION_TIMEOUT_MS: number = 6000;
  public static readonly EDITOR_HIDE_TIMEOUT: number = 20;
  // save scale
  public static readonly SAVE_SCALE: string = 'save_scale';
  // matrix
  public static readonly MATRIX: string = 'matrix';
  // photo browser delete confirm
  public static readonly PHOTO_BROWSER_DELETE_CONFIRM: string = 'photo_browser_delete_confirm';
  // photo browser remove confirm
  public static readonly PHOTO_BROWSER_REMOVE_CONFIRM: string = 'photo_browser_remove_confirm';
  public static readonly DOWNLOAD_ORIGIN_PHOTO: string = 'download_origin_photo';
  // Image pull up by clicking action bar icon
  public static readonly OPEN_CLICK_DETAIL_PULLING_UP: string = 'open_Click_Detail_Pulling_Up';
  public static readonly CLOSE_CLICK_DETAIL_PULLING_UP: string = 'close_Click_Detail_Pulling_Up';
  public static readonly CLOSE_CLICK_DETAIL_BY_BACK_PRESS: string = 'close_click_detail_by_back_press';
  // 拖动和滑动参数
  public static readonly THRESHOLD: number = 100;
  public static readonly GESTURE_INTERVAL: number = 10;
  public static readonly MOVE_INTERVAL: number = 5;
  // GeometryTransition constants
  public static readonly COMPONENT_EMPTY_EFFECT_OPACITY: number = 0.99;
  public static readonly GRID_MIN_SCALE: number = 0.001;
  public static readonly CAN_PULL_DOWN_DRAG_THRESHOLD: number = 10;
  public static readonly OPEN_CURVE_DURATION: number = 200;
  public static readonly PC_OPEN_CURVE_DURATION: number = 50;
  public static readonly OPEN_BACKGROUND_CURVE_DURATION: number = 300;
  public static readonly OPEN_CURVE_DELAY_ACTIONBAR: number = -100;
  public static readonly CLOSE_CURVE_DURATION: number = 100;
  public static readonly PICKER_BROWSER_OPEN_DELAY: number = 100;
  public static readonly CURVE_X1: number = 0.2;
  public static readonly CURVE_Y1: number = 0.0;
  public static readonly CURVE_X2: number = 0.2;
  public static readonly CURVE_Y2: number = 1.0;
  public static readonly PHOTO_TRANSITION_CURVE: string =
    Curves.cubicBezier(Constants.CURVE_X1, Constants.CURVE_Y1, Constants.CURVE_X2, Constants.CURVE_Y2);
  // GeometryTransition constants for closing browsers
  public static readonly CLOSE_SPRING_CURVE_VELOCITY: number = 0;
  public static readonly CLOSE_SPRING_CURVE_MASS: number = 1;
  public static readonly CLOSE_SPRING_CURVE_STIFFNESS: number = 327;
  public static readonly CLOSE_SPRING_CURVE_DAMPING: number = 36;
  public static readonly CLOSE_SPRING_CURVE: Curves.ICurve =
    Curves.interpolatingSpring(Constants.CLOSE_SPRING_CURVE_VELOCITY, Constants.CLOSE_SPRING_CURVE_MASS,
      Constants.CLOSE_SPRING_CURVE_STIFFNESS, Constants.CLOSE_SPRING_CURVE_DAMPING);
  // GeometryTransition constants for opening browsers
  public static readonly OPEN_PHOTO_CURVE: Curves.ICurve = Curves.interpolatingSpring(0, 1, 600, 50);
  public static readonly OPEN_PHOTO_DURATION: number = 500;
  // 非大图内容的显示曲线，包括：actionbar、toolbar、预览条
  public static readonly OPEN_OTHER_CONTENT: Curves.ICurve = Curves.cubicBezierCurve(0.33, 0, 0.67, 1);
  public static readonly OPEN_OTHER_CONTENT_DURATION: number = 100;
  // GeometryTransition constants for closing browsers(Curve.FastOutSlowIn)
  public static readonly CLOSE_PHOTO_CURVE: Curves.ICurve = Curves.interpolatingSpring(0, 1, 550, 45);
  public static readonly CLOSE_PHOTO_DURATION: number = 200;
  // GeometryTransition constants for closing browsers from camera (Curve.FastOutSlowIn)
  public static readonly ANIM_PB_SHARE_OPEN_CURVE: Curves.ICurve = Curves.interpolatingSpring(0, 1, 228, 25);
  public static readonly ANIM_PB_SHARE_CLOSE_CURVE: Curves.ICurve = Curves.interpolatingSpring(0, 1, 450, 42);
  // 宫格进入大图Trace名
  public static readonly OPEN_BROWSER: string = 'OPEN_BROWSER';
  // 大图退出宫格Trace名
  public static readonly CLOSE_BROWSER: string = 'CLOSE_BROWSER';
  // 相机进入大图Trace名
  public static readonly CAMERA_UE_GO_GALLERY: string = 'CAMERA_UE_GO_GALLERY';
  // 大图进入宫格Trace名
  public static readonly CAMERA_UE_EXIT_GALLERY: string = 'CAMERA_UE_EXIT_GALLERY';
  // GeometryTransition constants for picker's privacy options
  public static readonly PICKER_PRIVACY_OPTIONS_CURVE: Curves.ICurve = Curves.interpolatingSpring(0, 1, 342, 37);
  // Geometry transition effect
  public static readonly OPEN_EFFECT: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Constants.PHOTO_TRANSITION_CURVE,
    duration: Constants.OPEN_CURVE_DURATION,
  });
  public static readonly PC_PHOTO_BROWSER_OPEN_EFFECT: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Constants.PHOTO_TRANSITION_CURVE,
    duration: Constants.PC_OPEN_CURVE_DURATION,
  });
  public static readonly OPEN_EFFECT_ACTIONBAR: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Constants.PHOTO_TRANSITION_CURVE,
    duration: Constants.OPEN_CURVE_DURATION,
    delay: Constants.OPEN_CURVE_DELAY_ACTIONBAR,
  });
  public static readonly CLOSE_EFFECT: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Constants.PHOTO_TRANSITION_CURVE,
    duration: Constants.CLOSE_CURVE_DURATION,
  });
  public static readonly VIDEO_CLEANUP_MASK_EFFECT: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Curve.Sharp,
    duration: 200,
  });
  public static readonly VIDEO_CLEANUP_OPEN_EFFECT: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Curve.Sharp,
    delay: 50,
    duration: 200,
  });
  public static readonly VIDEO_CLEANUP_CLOSE_EFFECT: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Curve.Sharp,
    duration: 200,
  });
  public static readonly VIDEO_CLEANUP_LIST_EFFECT: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Curve.Sharp,
    duration: 300,
  });
  public static readonly PICKER_BROWSER_OPEN_EFFECT: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Curve.Sharp,
    duration: Constants.OPEN_CURVE_DURATION,
    delay: Constants.PICKER_BROWSER_OPEN_DELAY,
  });
  public static readonly PICKER_BROWSER_CLOSE_EFFECT: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Curve.Sharp,
    duration: Constants.OPEN_CURVE_DURATION,
  });
  public static readonly PICKER_BROWSER_BACKGROUND_OPEN_EFFECT: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Curve.Sharp,
    duration: Constants.OPEN_BACKGROUND_CURVE_DURATION,
  });
  public static readonly PICKER_BROWSER_BACKGROUND_CLOSE_EFFECT: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Curve.Sharp,
    duration: Constants.OPEN_BACKGROUND_CURVE_DURATION,
  });
  // 云同步卡片缩放动效时长
  public static readonly CLOUD_SYNC_CARD_SCALE_DURATION: number = 350;
  // 云同步卡片缩放动效比例
  public static readonly CLOUD_SYNC_CARD_SCALE: number = 0.85;
  // 云同步卡片透明动效时长
  public static readonly CLOUD_SYNC_CARD_OPACITY_DURATION: number = 150;
  // 云同步卡片透明动效
  public static readonly CLOUD_SYNC_CARD_OPACITY_EFFECT: TransitionEffect = TransitionEffect.OPACITY.animation({
    curve: Curve.Sharp,
    duration: Constants.CLOUD_SYNC_CARD_OPACITY_DURATION,
  });
  // 云同步卡片动效
  public static readonly CLOUD_SYNC_CARD_EFFECT: TransitionEffect = Constants.CLOUD_SYNC_CARD_OPACITY_EFFECT
    .combine(TransitionEffect.scale({ x: Constants.CLOUD_SYNC_CARD_SCALE, y: Constants.CLOUD_SYNC_CARD_SCALE })
      .animation({
        curve: Curve.Friction,
        duration: Constants.CLOUD_SYNC_CARD_SCALE_DURATION,
      }));
  // Swiper depth animation
  public static readonly SWIPER_DEPTH_CURVE_RESPONSE = 0.416114;
  public static readonly SWIPER_DEPTH_CURVE_DAMPING = 0.993399;
  public static readonly SWIPER_DEPTH_CURVE_OVERLAP = 0;
  public static readonly SWIPER_SPRING_CURVE: Curves.ICurve = Curves.springMotion(Constants.SWIPER_DEPTH_CURVE_RESPONSE,
    Constants.SWIPER_DEPTH_CURVE_DAMPING, Constants.SWIPER_DEPTH_CURVE_OVERLAP);
  // Delay of backPress when rotate screen
  public static readonly DELAY_FOR_ROTATE_SCREEN: number = 650;
  // rotation start wait time
  public static readonly DELAY_FOR_ROTATE_START: number = 200;
  // Drag image curve constants
  public static readonly DRAG_SCALE: number = 0.0013;
  public static readonly MIN_DRAG_SCALE: number = 0.5;
  public static readonly DRAG_OPACITY: number = 0.0026;
  public static readonly DRAG_ANIMATION_DURATION: number = 100;
  // overScale animation duration
  public static readonly OVER_SCALE_ANIME_DURATION: number = 500;
  public static readonly DEFAULT_SIZE: number = 256;
  public static readonly OPERATION_EXIT_ANIMATION_DURATION: number = 100;
  public static readonly PAGE_SHOW_ANIMATION_DURATION: number = 200;
  public static readonly PHOTO_GRID_ANIMATION_DURATION: number = 300;
  public static readonly PHOTO_GRID_SCALE: number = 0.8;
  public static readonly ALBUM_SCALE: number = 1.2;
  /**
   * 大图当前查看图片index变化，比如左右滑动，或者数据刷新时当前元素位置变更
   */
  public static readonly EVENT_ON_CURRENT_INDEX_CHANGED: string = 'EVENT_ON_CURRENT_INDEX_CHANGED';
  // Delay of set auto rotate screen when video rotate click
  public static readonly DELAY_FOR_SET_AUTO_ROTATE_SCREEN: number = 500;
  public static readonly ROTATE_DEVICE_30_DEG_X: number = 30;
  public static readonly ROTATE_DEVICE_150_DEG_X: number = 150;
  public static readonly ROTATE_DEVICE_30_DEG_Y: number = 30;
  public static readonly ROTATE_DEVICE_60_DEG_Y: number = 60;
  // 执行横竖屏旋转动画等待时间
  public static readonly DELAY_FOR_WINDOW_ROTATE_ANIMATION: number = 1000;
  public static readonly ROTATION_STATUS_ON: string = '1';
  public static readonly ROTATION_STATUS_OFF: string = '0';
  public static readonly ROTATION_STATUS_DEFAULT: string = '-1';
  //video player
  public static readonly SET_VIDEO_RATIO: string = 'set_video_ratio';
  public static readonly SET_IS_SUPPORTED_VIDEO_TYPE: string = 'set_is_supported_video_type';
  public static readonly SET_IMAGE_SIZE_WHEN_ZERO: string = 'set_image_size_when_zero';
  public static readonly SET_VIDEO_COMPONENT_SIZE: string = 'set_video_component_size';
  public static readonly SET_VIDEO_REAL_SIZE: string = 'set_video_real_size';
  public static readonly UPDATE_CARD_WIDTH: string = 'update_photo_detail_card_width';
  public static readonly REQUEST_QUALITY_IMAGE: string = 'requestQualityImage';
  public static readonly CATEGORY_ALBUM_MIN_COUNT: number = 1;
  // 大图页删除动效
  public static readonly ITEM_BLUR_CHANGE: string = 'itemBlurChange';
  public static readonly BLUR_DURATION: number = 650;
  public static readonly INIT_BLUR_VALUE: number = 0;
  public static readonly MAX_BLUR_VALUE: number = 100;
  public static readonly BLUR_DELAY: number = 100;
  public static readonly DELETE_MOVE_DELAY: number = 250;
  public static readonly DELETE_SCALE: number = 0.5;
  public static readonly DELETE_DURATION: number = 650;
  public static readonly DELETE_OPACITY: number = 650;
  public static readonly DELETE_LOW_INDEX: number = 3;
  public static readonly DELETE_HIGH_INDEX: number = 4;
  public static readonly DELETE_ANIM_DELAY: number = 250;
  //大图浏览ocr高亮
  public static readonly DOT_THRESHOLD: number = 12;
  public static readonly RECT_THRESHOLD: number = 24;
  public static readonly RECT_RADIUS: number = 4;
  public static readonly OVERLAY_PULLING_ANIM_DURATION: number = 150;
  public static readonly OVERLAY_APPEAR_ANIM_DURATION: number = 250;
  public static readonly OVERLAY_DISAPPEAR_ANIM_DURATION: number = 150;
  public static readonly DOT_ANIM_DURATION: number = 1500;
  public static readonly DOT_ANIM_ITERATION: number = 3;
  public static readonly DOT_ORIGINAL_SCALE: number = 0.216;
  //一碰分享on注册监听延时
  public static readonly SHARE_ON_DURATION: number = 10;
  public static readonly ITEM_AIR_SHARE_SWITCH: string = 'item_air_share_switch';
  public static readonly SWING_SHARE: string = 'swingShare';
  public static readonly LARGE_PICTURE_BROWSING_STATUS: string = 'large_picture_browsing_status';
  public static readonly EXIF_ARRAY: image.PropertyKey[] = [
    image.PropertyKey.MODEL,
    image.PropertyKey.ISO_SPEED_RATINGS,
    image.PropertyKey.RECOMMENDED_EXPOSURE_INDEX,
    image.PropertyKey.EXPOSURE_TIME,
    image.PropertyKey.EXPOSURE_BIAS_VALUE,
    image.PropertyKey.WHITE_BALANCE,
    image.PropertyKey.FLASH,
    image.PropertyKey.METERING_MODE,
    image.PropertyKey.F_NUMBER,
    image.PropertyKey.FOCAL_LENGTH_IN_35_MM_FILM,
    image.PropertyKey.FOCUS_MODE,
    image.PropertyKey.LIGHT_SOURCE
  ];
  public static readonly X_MAGE_DRAGON_FRUIT: string = 'XXX';
  public static readonly X_MAGE_STYLE: string = 'XMAGE';
  public static readonly XT_STYLE_MIN_HUE_VALUE: number = 0;
  public static readonly XT_STYLE_MAX_HUE_VALUE: number = 20;
  public static readonly XT_STYLE_MIN_SATURATION: number = 0;
  public static readonly XT_STYLE_MAX_SATURATION: number = 10;
  public static readonly XT_STYLE_MIN_LIGHT_AND_SHADOW: number = 0;
  public static readonly XT_STYLE_MAX_LIGHT_AND_SHADOW: number = 10;
  public static readonly XT_STYLE_TEMPLATE_NAME: string = 'HwMnoteXtStyleTemplateName';
  public static readonly XT_STYLE_CUSTOM_HUE: string = 'HwMnoteXtStyleCustomHue';
  public static readonly XT_STYLE_CUSTOM_SATURATION: string = 'HwMnoteXtStyleCustomSaturation';
  public static readonly XT_STYLE_CUSTOM_LIGHT_AND_SHADOW: string = 'HwMnoteXtStyleCustomLightAndShadow';
  public static readonly X_MAGE_COLOR_MODE: string = 'HwMnoteXmageColorMode';
  // 内外屏适配接续
  public static readonly CONTINUE_PLAY_FROM_SUB_SCREEN: string = 'continue_play_from_sub_screen';
  public static readonly CLICK_BACK_PRESS: string = 'click_back_press';
  // 动态照片
  public static readonly MOVING_PHOTO_ON_COMPLETE: string = 'moving_photo_on_complete';
  // 连拍
  public static readonly BURST_SHORT_DURATION: number = 100;
  public static readonly BURST_MEDIUM_DURATION: number = 150;
  public static readonly BURST_LONG_DURATION: number = 200;
  public static readonly BURST_FAVOR_INTERVAL: number = 200;
  public static readonly BURST_PHOTOS_SELECTED_NO_CHANGED = 'burst_photos_selected_no_changed';
  public static readonly BURST_PHOTOS_SAVE_DIALOG_OPEN = 'burst_photos_save_dialog_open';
  public static readonly BURST_PHOTOS_SAVE_DIALOG_CLOSE = 'burst_photos_save_dialog_close';
  public static readonly BURST_PHOTOS_SAVE_PROGRESS = 'burst_photos_save_progress';
  public static readonly BURST_PHOTOS_SAVE_FINISH = 'burst_photos_save_finish';
  public static readonly BURST_PHOTOS_CANCEL_SAVE = 'burst_photos_cancel_save';
  public static readonly BURST_PHOTOS_CANCEL_PROGRESS = 'burst_photos_cancel_progress';
  public static readonly BURST_PHOTOS_COMMON_TRANSFORM = 'burst_photos_common_transform';
  public static readonly BACK_FROM_BURST: string = 'back_from_burst';
  public static readonly BURST_THUMBNAIL_WIDTH_ANIMATION: string = 'burst_thumbnail_width_animation';
  // 逐帧播放
  public static readonly TAG_VIDEO_PLAY_BY_FRAME: string = '[VIDEO_PLAY_BY_FRAME]';
  public static readonly RESET_VIDEO_FRAME_BEFORE_EDIT: string = 'RESET_VIDEO_FRAME_BEFORE_EDIT';
  public static readonly RESET_VIDEO_FRAME: string = 'RESET_VIDEO_FRAME';
  // 返回处理
  public static readonly PHOTO_PHOTO_BACK_PRESS: string = 'photo_back_press';
  public static readonly VIDEO_SCROLL_TO_START: string = 'video_scroll_to_start';
  public static readonly LOAD_YUV_PIXEL_MAP: string = 'loadYuvPixelMap';
  // 全搜引起页面刷新
  public static readonly DATA_LOAD_FINISH_PREVIEWER_REFRESH: string = 'data_load_finish_previewer_refresh';
  // 全搜预览条出现广播延时
  public static readonly DATA_LOAD_FINISH_BROADCAST_DELAY: number = 100;
  // 点击播放按钮 list滑动曲线
  public static readonly CLICK_PLAY_FRAME_EXPAND_LIST_CURVE: Curves.ICurve = Curves.interpolatingSpring(0, 1, 328, 36);
  public static readonly DELAY_FOR_MENU_AUTO_HIDDEN: number = 5000;
  // 离手旋转动效
  public static readonly PHOTO_ROTATION_DURATION: number = 500;
  // 大图旋转复原
  public static readonly PHOTO_RESET_ROTATION: string = 'photo_reset_rotation';
  // 大图旋转角度-0
  public static readonly ROTATION_ZERO: number = 0;
  // 大图旋转角度-90
  public static readonly ROTATION_NINETY: number = 90;
  // 大图旋转角度-180
  public static readonly ROTATION_ONE_EIGHT_ZERO: number = 180;
  // 大图旋转角度-360
  public static readonly ROTATION_THREE_SIX_ZERO: number = 360;
  // 大图旋转
  public static readonly ROTATION_HAIF: number = 2;
  // 大图旋转 触发旋转手势最小改变度数
  public static readonly ROTATION_TRIGGER_ANGLE: number = 35;
  // 隔空分享,延时启动监听隔空分享事件的时间
  public static readonly DELAY_MONITORING_TIME_FOR_REMOTE_SHARING: number = 200;
  // 隔空分享,延时展示视频按钮的时间
  public static readonly DELAY_MONITORING_TIME_FOR_SHOW_PLAY_BUTTON: number = 500;
  // 隔空分享,云资源下载超时时间
  public static readonly CLOUD_RESOURCE_DOWNLOAD_TIMEOUT: number = 10000;
  // pc大图进沉浸式缩放动效
  public static readonly PC_BROWSER_IMMERSE_ANIM_DURATION = 300;
  // 不合法序号
  public static readonly INVALID: number = -1;
  // 点击删除触发时间间隔
  public static readonly CLICK_DELETE_INTERVAL = 300;
  // 进退大图动画默认结束宽度
  public static readonly targetWidth: Length = '100%';
  // 进退大图动画默认结束宽度
  public static readonly targetHeight: Length = '100%';
  // 进退大图动画默认结束位置偏移量
  public static readonly targetTranslate: TranslateOptions = { x: 0, y: 0 };
  // 进退大图动画默认结束缩略图透明度
  public static readonly targetThumbnailOpacity: number = 0;
  // 进退大图动画默认结束原图透明度
  public static readonly targetPhotoOpacity: number = 1;
  // 进退大图动画默认结束宽高比
  public static readonly targetAspectRatio: number = 1;
  // 进退大图动画默认结束圆角宽度
  public static readonly targetRadius: number = 0;
  // 进退大图动画默认结束边框宽度
  public static readonly targetBorderWidth: number = 0;
  // 进大图默认动画
  public static readonly curveStart: Curves.ICurve = Constants.OPEN_PHOTO_CURVE;
  // 退大图默认动画
  public static readonly curveEnd: Curves.ICurve = Constants.CLOSE_PHOTO_CURVE;
  // 进退大图动画默认开始边框宽度
  public static readonly borderWidth: number = 0;
  // 进退大图动画默认结束缩放比
  public static readonly targetScale: ScaleOptions = { x: 1, y: 1 };
  // 分割线线宽度1vp
  public static readonly DIVIDER_WIDTH: number = 1;
  // 详情横向宽度
  public static readonly PROPERTIES_DEFAULT_WIDTH: number = 332;
  // swiper布局变化视频进度延迟校准
  public static readonly PROGRESS_CALIBRATION_DELAY: number = 50;
  // 拍摄模式相册名称-人像
  public static readonly SHOOT_PORTRAIT: string = '1';
  // 拍摄模式相册名称-自拍
  public static readonly SHOOT_SELFIE: string = '12';
  // 拍摄模式相册名称-动态照片
  public static readonly SHOOT_MOVING_PICTURE: string = '4';
  // 拍摄模式相册名称-夜景
  public static readonly SHOOT_NIGHT_VIEW: string = '3';
  // 拍摄模式相册名称-高像素
  public static readonly SHOOT_HIGH_PIXEL: string = '8';
  // 拍摄模式相册名称-大光圈
  public static readonly SHOOT_LARGE_APERTURE: string = '2';
  // 拍摄模式相册名称-全景模式
  public static readonly SHOOT_PANORAMA_MODE: string = '10';
  // 拍摄模式相册名称-连拍
  public static readonly SHOOT_BURST_PHOTOS: string = '11';
  // 拍摄模式相册名称-RAW
  public static readonly SHOOT_RAW: string = '13';
  // 一镜到底宫格设置为白块时延
  public static readonly SET_WHITE_THUMBNAIL_PLACEHOLDER_DELAY: number = 30;

  public static readonly SHOOT_ALBUM_ORDER_MAP = new Map<string, number>([
    [Constants.SHOOT_PORTRAIT, 0],
    [Constants.SHOOT_MOVING_PICTURE, 1],
    [Constants.SHOOT_NIGHT_VIEW, 2],
    [Constants.SHOOT_HIGH_PIXEL, 3],
    [Constants.SHOOT_LARGE_APERTURE, 4],
    [Constants.SHOOT_PANORAMA_MODE, 5],
    [Constants.SHOOT_BURST_PHOTOS, 6],
    [Constants.SHOOT_RAW, 7],
  ]);
}