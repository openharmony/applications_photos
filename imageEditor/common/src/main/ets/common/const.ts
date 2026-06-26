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
import { bundleManager } from '@kit.AbilityKit';

export const AMT_MATH_PARA: number = 255;

export const COLOR_OFFSET_A: number = 24;

export const COLOR_OFFSET_R: number = 16;

export const COLOR_OFFSET_G: number = 8;

const darkTheme = true;
const colorBlack = 0x000000;
const colorWhite = 0xFFFFFF;
const COLOR_RED = 0xFF;
const COLOR_GREEN = 0x00FF;
const COLOR_OF_PRIMARY = 0xC459E0;
const COLOR_OF_DANGER = 0xF96058;
const COLOR_OF_SUCCESS = 0x39ae77;
const COLOR_OF_WARNING = 0xF6CA73;
const COLOR_OF_SECONDARY = 0xF0F0F0;
const BACKGROUND_COLOR_BLACK_LIGHT: number = 1.1;
const BACKGROUND_COLOR_WHITE_LIGHT: number = 0.9;
const FOREGROUND_COLOR_BLACK_LIGHT: number = 1.35;
const FOREGROUND_COLOR_WHITE_LIGHT: number = 0.65;
const GRAY_LIGHTNESS_FACTOR = 1.5;
const DISABLED_LIGHTNESS_FACTOR = 1.45;

function toAlpha(color: number, alpha: number): number {
  return alpha === 1 ? color : ((Math.floor(alpha * AMT_MATH_PARA) + 1) * (1 << COLOR_OFFSET_A)) + color;
}

function wrapToAlpha(color: number) {
  return function (alpha: number = 1, light: number = 1): number {
    return toAlpha(brightness(color, light), alpha);
  };
}

function addColor(color, amt): number {
  let r = color + amt;
  return r > AMT_MATH_PARA ? AMT_MATH_PARA : (r < 0 ? 0 : r);
}

function brightness(color: number, light: number = 1): number {
  if (light === 1) {
    return color;
  }
  let amt = Math.round((light - 1) * AMT_MATH_PARA);
  let a = color >> COLOR_OFFSET_A;
  let r = addColor(color >> COLOR_OFFSET_R, amt);
  let g = addColor(color >> COLOR_OFFSET_G & COLOR_GREEN, amt);
  let b = addColor(color & COLOR_RED, amt);
  return (a << COLOR_OFFSET_A) + (r << COLOR_OFFSET_R) + (g << COLOR_OFFSET_G) + b;
}

export let AppColor = {
  brightness: brightness,
  toAlpha: toAlpha,
  white: wrapToAlpha(colorWhite),
  black: wrapToAlpha(colorBlack),
  backgroundStrong: wrapToAlpha(darkTheme ? colorBlack : colorWhite),
  foregroundStrong: wrapToAlpha(darkTheme ? colorWhite : colorBlack),
  background: wrapToAlpha(darkTheme ? brightness(colorBlack, BACKGROUND_COLOR_BLACK_LIGHT) :
    brightness(colorWhite, BACKGROUND_COLOR_WHITE_LIGHT)),
  foreground: wrapToAlpha(darkTheme ? brightness(colorWhite, FOREGROUND_COLOR_WHITE_LIGHT) :
    brightness(colorBlack, FOREGROUND_COLOR_BLACK_LIGHT)),
  gray: wrapToAlpha(brightness(colorBlack, GRAY_LIGHTNESS_FACTOR)),
  disabled: wrapToAlpha(brightness(colorBlack, DISABLED_LIGHTNESS_FACTOR)),
  primary: wrapToAlpha(COLOR_OF_PRIMARY),
  danger: wrapToAlpha(COLOR_OF_DANGER),
  success: wrapToAlpha(COLOR_OF_SUCCESS),
  warning: wrapToAlpha(COLOR_OF_WARNING),
  secondary: wrapToAlpha(COLOR_OF_SECONDARY),
};

export type PositionType = {
  x: number,
  y: number,
};

export type PreviewWideApertureParam = {
  position: PositionType,
  fNum: number,
  timelineId: number,
  assertUid: string,
};

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
}

export const PHOTO_BUNDLE_NAME: string = 'com.ohos.photos';

export const SCREEN_ORIENTATION_PORTRAIT: string = 'editor_isPortrait';

export const SCREEN_FOLD_ORIENTATION_PORTRAIT: string = 'editor_fold_isPortrait';

export const EDITOR_STATUS_BAR_HEIGHT_KEY: string = 'editor_statusBarHeight';

export const WINDOW_STATUS_KEY: string = 'window_status';

export const DEVICE_FOLD_STATUS: string = 'device_isFold';

export const CURRENT_LANGUAGE: string = 'currentLanguage';

export const DEVICE_SCALE_STATUS: string = 'device_isScale';

export const DEVICE_FLOAT_STATUS: string = 'isFloatMode';

export const CONTAINER_WIDTH: string = 'container_width';

export const FIRST_FRAME_STATUS: string = 'first_frame';

export const DOWNLOAD_STATUS: string = 'download_status';

export const CANVAS_RECT: string = 'canvas_rect';

export const ADJUST_TAG: string = 'auto';

export const DIRECTION_LTR: string = 'ltr';

export const DIRECTION_RTL: string = 'rtl';

export const PAVE_SCREEN_ITEM: number = -2;

export const AUTO_INDEX: number = 0;

export const SHARPNESS_INDEX: number = 12;

export const VIGNETTE_INDEX: number = 13;

export const FADE_INDEX: number = 14;

export const GRAIN_INDEX: number = 15;

export const PHONE_MIN_CROP: number = 43;

export const PC_MIN_CROP: number = 60;

export const WGR_TRIM_HEIGHT: number = 120;

export const WGR_TRIM_LENGTH = 813;

export const PAD_CANVAS_BOTTOM: number = 128;

export const PHONE_RULER_START_OPT: number = 32;

export const PHONE_RULER_END_OPT: number = 40;

export const PAD_RULER_START_OPT: number = 105;

export const PAD_RULER_END_OPT: number = 120;

export const ALT_RULER_START_OPT: number = 85;

export const ALT_RULER_END_OPT: number = 95;

export const DEFAULT_STRENGTH_BAR_WIDTH: number = 240;

export const FOLDANDPAD_LR_STRENGTH_BAR_WIDTH: number = 272;

export const PHONE_TB_STRENGTH_BAR_WIDTH: number = 256;

export const PHONE_LR_STRENGTH_BAR_WIDTH: number = 186;

export const COMPARE_BTN_RIGHT_MARGIN: number = 24;

export const SCROLL_SHADOW_WIDTH: number = 24;

export const BOTTOM_HEIGHT: number = 236;

export const TOP_BAR_HEIGHT: number = 56;

export const PC_TOP_BAR_HEIGHT: number = 72;

/**
 * PC：预览/裁剪与 native timeline 的 operTop 统一下移（vp），与白框、底图共用同一套增量，避免仅改 getOperationArea 导致框图错位。
 * 与 PreviewStarter.calOperationArea、SwitchAnimator.getEditorPreviewRect 保持一致。
 */
export const PC_PREVIEW_VERTICAL_OFFSET_VP: number = 40;

export const STATUS_BAR_HEIGHT: number = 48;

export const RIGHT_BAR_HEIGHT: number = 320;

export const RIGHT_BAR_WIDTH: number = 74;

export const HOT_SPOT_WIDTH: number = 24;

export const HOT_SPOT_HEIGHT: number = 24;

export const PREVIEW_HEIGHT_OFFSET: number = 24;

export const ADJUST_AND_FILTER_SCROLL_DELAY: number = 300;

export const ADJUST_AND_XT_STYLE_SCROLL_DELAY: number = 300;

export const ADJUST_BUTTON_SIZE: number = 68;

export const FILTER_BUTTON_SIZE: number = 72;

export const XT_STYLE_BUTTON_SIZE: number = 72;

export const CROP_ROT_MIR_SIZE: number = 148;

export const TRIM_LENGTH_RATIO: number = 0.6;

export const STRENGTH_BAR_RATIO: number = 0.65;

export const OPER_WIDTH_PORTRAIT: number = 72;

export const OPER_WIDTH_LANDSCAPE: number = 152;

export const WIN_WIDTH_KEY: string = 'winWidth';

export const WIN_HEIGHT_KEY: string = 'winHeight';

export const APP_STORAGE_KEY_DOWNLOAD_PROGRESS: string = 'editorDownloadProgress';

export const USER_LOGIN_STATUS: string = 'editorGetLoginStatus';

export const PC_WINDOW_PADDING = 10;

export const PC_PADDING_VAL = 20;

export const BOTTOM_HEIGHT_NO_BAR: number = 224;

export const BOTTOM_HEIGHT_SPLIT: number = 208;

export const FOLD_PHONE_RULER_START_OPT: number = 28;

export const FOLD_PHONE_RULER_END_OPT: number = 34;

export const OVER_SEAL_SIZE: number = 400;

export const ANIMATION_DURATION: number = 250;

export const BOTTOM_NAVIGATION_HEIGHT: number = 28;

export const OVER_SCALE_ANIME_DURATION: number = 500;

export const PAGE_SWITCH_ANIME_DURATION: number = 400;

export const CANVAS_SHOW_DELAY_DURATION: number = 200;

export const TABS_DEFINE_ANIME_DURATION: number = 150;

export const TABS_DEFINE_FADE_ANIME_DURATION: number = 100;

export const EACH_BUTTON_ANIME_DELAY: number = 50;

export const TABS_CONTENT_HEIGHT: number = 160;

export const NETWORK_TOAST_PORTRAIT_BOTTOM: number = 158;

export const TAB_SIZE: number = 52;

export const TOOL_CONTAINER_HEIGHT: number = 96;

export const LEFT_PORTRAIT_OFFSET_PHONE: number = 0;

export const LEFT_LANDSCAPE_OFFSET_PHONE: number = 0;

export const LEFT_LANDSCAPE_NOFOLD_OFFSET_PHONE: number = 24;

export const LEFT_MIRRORMODE_LANDSCAPE_OFFSET_PHONE: number = 206;

export const RIGHT_PORTRAIT_OFFSET_PHONE: number = 0;

export const RIGHT_LANDSCAPE_OFFSET_PHONE: number = 226;

export const RIGHT_MIRRORMODE_LANDSCAPE_OFFSET_PHONE: number = 24;

export const RIGHT_SPLIT_OFFSET_PHONE: number = 218;

export const RIGHT_LANDSCAPE_NOFOLD_OFFSET_PHONE: number = 226;

export const RIGHT_NOLANDSCAPE_NOFOLD_OFFSET_PHONE: number = 261;

export const RIGHT_NOLANDSCAPE_TRI_FLOD_OFFSET_PHONE: number = 31;

export const RIGHT_LANDSCAPE_TRI_FLOD_FULL_OFFSET_PHONE: number = 23;

export const THIRD_TOOL_BAR_HEIGHT: number = 56;

export const TOP_OFFSET_PHONE: number = 56;

export const BOTTOM_LANDSCAPE_OFFSET_PHONE_FOR_IMAGE: number = 48;

export const BOTTOM_LANDSCAPE_NOFOLD_OFFSET_PHONE_FOR_IMAGE: number = 56;

export const BOTTOM_PORTRAIT_OFFSET_PHONE: number = 208;

export const BOTTOM_PORTRAIT_OFFSET_PHONE_FOR_IMAGE: number = 212;

export const BOTTOM_LANDSCAPE_OFFSET_PHONE: number = 0;

export const BOTTOM_LANDSCAPE_NOFOLD_OFFSET_PHONE: number = 4;

export const LEFT_PORTRAIT_OFFSET_PAD: number = 0;

export const LEFT_LANDSCAPE_OFFSET_PAD: number = 45;

export const RIGHT_PORTRAIT_OFFSET_PAD: number = 0;

export const RIGHT_LANDSCAPE_OFFSET_PAD: number = 238;

export const TOP_OFFSET_PAD: number = 56;

export const BOTTOM_PORTRAIT_OFFSET_PAD: number = 208;

export const BOTTOM_LANDSCAPE_OFFSET_PAD: number = 8;

export const BOTTOM_LANDSCAPE_OFFSET_PAD_FOR_IMAGE: number = 64;

export const BOTTOM_AVOID_HEIGHT: number = 28;

export const CANVAS_BOTTOM_EXPAND_HEIGHT: number = 32;

export const PORTRAIT_TABS_SPACE: number = 12;

export const LANDSCAPE_TABS_SPACE: number = 10;

export const PORTRAIT_MARGIN: number = 10;

export const LANDSCAPE_LENGTH_RATIO: number = 0.6;

export const LANDSCAPE_TOP_MARGIN: number = 8;

export const AI_REMOVE_BUTTON_SHOW_ANIMATION_DURATION: number = 200;

export const AI_REMOVE_BUTTON_CHANGE_ANIMATION_DURATION: number = 500;

export const AI_REMOVE_BUTTON_OPACITY_CHANGE_ANIMATION_DELAY: number = 100;

export const AI_REMOVE_BUTTON_OPACITY_CHANGE_ANIMATION_DURATION: number = 100;

//新增移动按钮间距，延时的常量
export const AI_MOVE_BUTTON_SHOW_ANIMATION_DURATION: number = 200;

export const AI_MOVE_BUTTON_CHANGE_ANIMATION_DURATION: number = 500;

export const AI_MOVE_BUTTON_OPACITY_CHANGE_ANIMATION_DELAY: number = 100;

export const AI_MOVE_BUTTON_OPACITY_CHANGE_ANIMATION_DURATION: number = 100;

export const AI_EXPAND_LANDSCAPE_BUTTON_AREA: number = 48;

export const AI_EXPAND_RECT_DISTANCE_SCREEN: number = 48;

export const AI_TOAST_PORTRAIT_BOTTOM: number = 80;

export const EXPAND_RECT_BORDER_WIDTH: number = 1;

export const WINDOW_MODE_DECOR_BAR: number = 37;

export const AI_EDITOR_IMAGE_ID: string = 'aiEditorImageID';

export const FOCUS_SCROLL: string = 'focusScroll';

// 非文字轮播区域宽度
export const BTN_BORDER_RADIUS_DOUBLE: number = 45;

// 扩图按钮文字字体大小
export const EXPAND_BUTTON_FONT_SIZE: number = 14;

export const FONT_SIZE_SCALE_KEY: string = 'fontSizeScale';

export const DIALOG_ICON_KEY: string = 'DIALOG_ICON';

export const DIALOG_NAME_KEY: string = 'DIALOG_NAME';

/**
 * Enum for state.
 * 同 ArkUI @ohos.promptAction CommonState 枚举，但ArkUi存在BUG无法正常使用，此处自定义，如需修改请与官方文档一致
 *
 * @enum { number }
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @crossplatform
 * @atomicservice
 * @since 20
 */
export enum PromptState {
  /**
   * Indicates it is uninitialized.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 20
   */
  UNINITIALIZED = 0,

  /**
   * Indicates it is initialized.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 20
   */
  INITIALIZED = 1,

  /**
   * Indicates it is appearig.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 20
   */
  APPEARING = 2,

  /**
   * Indicates it is appeared.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 20
   */
  APPEARED = 3,

  /**
   * Indicates it is disappearing.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 20
   */
  DISAPPEARING = 4,

  /**
   * Indicates it is disappeared.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 20
   */
  DISAPPEARED = 5,
}

export const FONT_SIZE_SCALE_M: number = 2;

export const FONT_SIZE_SCALE_S: number = 1.75;

// 首次进入涂鸦
export const IS_FIRST_PEN_KIT: string = 'isFirstPenKit';
// AI修图默认页签下标
export const DEFAULT_AI_TAB_INDEX: number = 1;

export const SPORT_PAN_MAX = 100;

export const SPORT_PAN_MIN = 0;

export const SPORT_PAN_GAP = 5;

export const SPORT_PAN_DIVISION = 25;

export enum AIErrorCode {
  SUCCESS = 'SUCCESS', // 成功
  UNKNOWN_ERROR = 'UNKNOWN_ERROR', // 服务器故障
  ERR_NOT_SUPPORT_BUSINESS = 'ERR_NOT_SUPPORT_BUSINESS', // 不支持的业务类型
  ERR_INPUT_TYPE_MISMATCH = 'ERR_INPUT_TYPE_MISMATCH', // 模型输入与业务类型不匹配
  ERR_RISK_MANAGER = 'ERR_RISK_MANAGER', // 风控拒绝
  ERR_RUN_TIMEOUT = 'ERR_RUN_TIMEOUT', // 超时
  ERR_NETWORK_DISCONNECT = 'ERR_NETWORK_DISCONNECT', // 网络错误
  ERR_NATIVE_INNER_ERROR = 'ERR_NATIVE_INNER_ERROR', // 内部错误
  ERR_OH_INNER_ERROR = 'ERR_OH_INNER_ERROR', // 内部错误
  ERR_COMPOSE_DISCONNECT_ERROR = 'ERR_COMPOSE_DISCONNECT_ERROR',
  ERR_COMPOSE_RISK_ERROR = 'ERR_COMPOSE_RISK_ERROR',
  ERR_COMPOSE_SERVER_ERROR = 'ERR_COMPOSE_SERVER_ERROR',
  ERR_COMPOSE_TIMEOUT_ERROR = 'ERR_COMPOSE_TIMEOUT_ERROR',
  ERR_SIZE_LARGE_ERROR = 'ERR_SIZE_LARGE_ERROR',
  ERR_SIZE_LOW_ERROR = 'ERR_SIZE_LOW_ERROR',
  ERR_NO_FACE_DETECTION = 'ERR_NO_FACE_DETECTION',
  ERR_CANNOT_DO_REFINE_AGAIN = 'ERR_CAN_NOT_DO_REFINE_AGAIN',
  ERR_PARAM_MISMATCH = 'ERR_PARAM_MISMATCH', // 入参不合规
  ERR_ALG_MANAGER = 'ERR_ALG_MANAGER', // 算法拦截
  ERR_REQUEST_TIMEOUT = 'ERR_REQUEST_TIMEOUT' // 服务器算法运行时间+风控时间长，14s未获取到风控结果
}

export const AI_IMAGE_LARGE_SIDE: number = 960;

export const AI_BUTTON_HEIGHT: number = 36;

export const PORTRAIT_AI_TOOL_CONTAINER_HEIGHT: number = 80;

export const LAND_AI_TOOL_CONTAINER_HEIGHT: number = 68;

export const TEXT_MOVE_SIZE: number = 20;

export const AI_TEXT_CONTAINER_WIDTH: number = 250;

// AI动效文字与提示信息框容器高度
export const AI_TEXT_CONTAINER_HEIGHT: number = 24;

// AI动效文字与提示信息框TOP偏移量
export const AI_TEXT_CONTAINER_TOP_OFFSET: number = 28;

// 直板机状态下，图片预览区域BOTTOM偏移量
export const AI_IMAGE_CONTAINER_BOTTOM_FOLD_OFFSET: number = 68;

// 文字提示框高度
export const AI_TEXT_HEIGHT: number = 19;

// AI出字高度-竖屏
export const AI_TEXT_NO_PORTRAIT_HEIGHT: number = 21;

// 直板机分屏场景图片预览区BOTTOM偏移量
export const AI_BOTTOM_SPLIT_MODE_OFFSET_PHONE: number = 81;

// 直板机分屏场景文字预览区BOTTOM偏移量
export const AI_TIP_BOTTOM_SPLIT_MODE_OFFSET_PHONE: number = 20;

// 直板机分屏场景动效文字预览区BOTTOM偏移量
export const AI_TEXT_BOTTOM_SPLIT_MODE_OFFSET_PHONE: number = 5;

// AI动效文字与提示信息框容器高度-直板机分屏状态下
export const AI_TEXT_FOLD_CONTAINER_HEIGHT: number = 14;

// 展开状态下，图片预览区域BOTTOM偏移量
export const AI_IMAGE_CONTAINER_BOTTOM_NO_FOLD_OFFSET: number = 76;

// 展开状态下，AI动效文字与提示信息框TOP偏移量
export const AI_TEXT_CONTAINER_TOP_NO_FOLD_OFFSET: number = 20;

// 展开状态下，AI动效文字与提示信息框容器高度
export const AI_TEXT_CONTAINER_NO_FOLD_HEIGHT: number = 32;

// 上下布局，文字动效框高度
export const AI_TEXT_CONTAINER_PORTRAIT_HEIGHT: number = 56;

// 拍摄模式
export enum ImageConfig {
  NONE = '0',
  PORTRAIT_ALBUM = '23', // 人像
  WIDE_APERTURE_ALBUM = '19', //大光圈
  CLOUD_ENHANCE = '120' // 云增强
}

export enum CropIndex {
  INTELLIGENT = 0, // 智能校正
  ROTATE = 1, // 旋转
  HORIZONTAL = 2, // 水平校正
  VERTICAL = 3, // 垂直校正
  RATIO = 4 // 比例
}

export const EPSILON: number = 1e-6;

export const ONE_DAY_MS: number = 24 * 60 * 60 * 1000;
// 是否点击涂鸦按钮
export const IS_PEN_KIT_CLICKED: string = 'isPenKitClicked';
// 涂鸦提示弹框展示时间
export const PEN_KIT_POP_TIME: string = 'penKitPopTime';
// 涂鸦提示弹框展示次数
export const PEN_KIT_POP_COUNT: string = 'penKitPopCount';

// 二级菜单，转场动效偏移量
export const AI_MENU_TRANSITION_OFFSET: number = 300;

export const AVOID_LEFT_OFFSET: string = 'avoid_left';

export const SINGLE_WIDTH_FLEX_BASIS: number = 328;

// 是否点击过涂鸦引导页我知道按钮
export const IS_PEN_KIT_GUIDE_CLICKED: string = 'isPenKitGuideClicked';

// 长截图裁剪热区异常激活数
export const LONG_SCREENSHOT_CROP_HOT_AREA: number = 2;

// 字体放大倍数：大2挡，1.3倍
export const FONT_SCALE_LEVEL2_SIZE: number = 1.3;

// 字体放大倍数：大3挡，1.45倍
export const FONT_SCALE_LEVEL3_SIZE: number = 1.45;

/** 关闭XtStyle */
export const XT_STYLE_OFF: number = 10000;

// MovingPhoto
export const SCREEN_ORIENTATION_BLOCK_FLAG: string = 'editor_screen_block_flag';

export const DEVICE_SCREEN_ORIENTATION_PORTRAIT: string = 'editor_device_isPortrait';

export const SAVE_PROGRESS_KEY :string = 'editor_progress';

export const STATUS_BAR_COLOR_WHITE: string = '#ffffff';

export const STATUS_BAR_COLOR_BLACK: string = '#000000';

export const PLAY_BTN_SIZE: number = 24;

export const PLAY_BTN_RIGHT_MARGIN = 16;

export const TIME_BAR_LEFT_PADDING: number = 24;

export const MAX_THUMBNAIL_NUM:number = 100;

export const MIN_THUMBNAIL_INTERVAL: number = 200;

// 最大缩略图请求基数
export const MAX_BASE_THUMBNAIL_INTERVAL: number = 1000;

export const MOVING_PHOTO_PHONE_MIN_CROP: number = 40;

export const PAD_TRIM_HEIGHT: number = 92;

export const MOVING_PHOTO_STATUS_BAR_HEIGHT: number = 29;

export const AVOID_BOTTOM_HEIGHT: number = 28;

export const PHONE_TRIM_HEIGHT: number = 100;

export const LIMIT_TRIM_LENGTH: number = 100;

export const TIME_CAPSULE_LENGTH: number = 100;

export const TIME_CAPSULE_RIGHT_OFFSET: number = 120;

export const SEEK_LINE_EDGE_HOT_ZONE: number = 20;

export const SEEK_LINE_BODY_HOT_ZONE: number = 10;

export const TRIM_POINTER_WIDTH: number = 3;

export const TOP_TIPS_OFFSET: number = 30;

export const PAD_TRIM_LENGTH = 813;

export const AI_BAR_HOT_HEIGHT:number = 10;

export const BOTTOM_SPLIT_MODE_CUSTOM_HEIGHT:number = 3;

export const MOVING_PHOTO_ALT_RULER_START_OPT: number = 60;

export const MOVING_PHOTO_ALT_RULER_END_OPT: number = 70;

export const PAD_LANDSCAPE_IMAGE_HEIGHT: number = 52;

export const PHONE_LANDSCAPE_IMAGE_HEIGHT: number = 32;

export const IMAGE_HEIGHT = 52;

export const FOLD_BTN_WIDTH: number = 58;

export const PAD_BTN_WIDTH: number = 68;

export const PAD_ICON_MARGIN: number = 36;

export const COMPARE_BTN_RIGHT_MARGIN_PHONE: number = 16;

export const HOT_SPOT_SINGLE_WIDTH: number = 24; // 裁剪热区20+裁剪边框宽度4

export const HOT_SPOT_SINGLE_HEIGHT: number = 24;

export const HOT_HEIGHT_OFFSET: number = 48;

export const CROP_BORDER_WIDTH: number = 4;

export const PC_HOT_SPOT_WIDTH: number = 48; // PC热区44+裁剪边框4

export const PC_HOT_HEIGHT_OFFSET: number = 96;

export const TOOL_BAR_ITEM_HEIGHT: number = 52;

export const TOOL_BAR_ITEM_WIDTH: number = 52;

export const ADJUST_BUTTON_HEIGHT: number = 88;

export const RULER_WIDTH_SIZE: number = 148;

export const RULER_HEIGHT_SIZE: number = 184;

export const SMALL_SCREEN_SIZE: number = 200;

export const BIG_SCREEN_SIZE: number = 300;

export const WIN_BEZEL_WIDTH: number = 4.8;

export const IS_FOLD_STATUS_KEY: string = 'isFolded';

export const IS_REFRESH_SPLIT_KEY: string = 'isRefreshSplit';

export const CONTENT_CHANGE_KEY: string = 'contentChanged';

export const RATIO_CHANGE_KEY: string = 'ratioChanged';

export const WIN_STATUS_KEY: string = 'windowStatus';

export const GRID_PADDING_KEY: string = 'GridPadding';

export const FIRST_TRIM_KEY: string = 'isVideoFirstTrim';

export const LIVE_PHOTO_FIRST_TRIM_KEY: string = 'isLivePhotoFirstTrim';

export const FIRST_ADD_MUSIC_KEY: string = 'isFirstAddMusic';

export const MIN_WIN_HEIGHT: number = 220;

export const TRIM_LENGTH_KEY: string = 'trimLength';

export const CRITICAL_PRESSURE: number = 0.5;

export const LIGHT_PRESSURE_CROP_PERCENTAGE: number = 0.2;

export const HEAVY_PRESSURE_CROP_PERCENTAGE: number = 0.4;

export const HEAVY_PRESSURE_PERCENTAGE_LENGTH: number = 320;

export const MENU_WIDTH: number = 52;

export const CROP_SCROLL_MIN_LENGTH: number = 80;

export const APP_CHANGE_BACKGROUND: string = 'change_background';

export const APP_CHANGE_FOREGROUND: string = 'change_foreground';

export const FILE_PRE: string = 'file:///';

export const FD_PRE: string = 'fd://';

export const SUCCESS_RES: number = 0;

export const HMC_ERR_SPLIT_LIMIT: number = -100009;

export const FILE_SUF_VIDEO: string = '.mp4';

export const FILE_SUF_IMAGE: string = '.jpg';

export const IS_PORTRAIT: string = 'isPortrait';

export const FONT_SIZE_SCALE_L: number = 3.2;

export const MS_TO_HOUR: number = 3600000;

export const MS_TO_S: number = 1000;

export const MS_TO_SEC: number = 60000;

export const TIME_MAX_LENGTH: number = 2;

export const SEC_MAX_LENGTH: number = 4;

export const S_TO_SEC: number = 60;

export const S_TO_HOUR: number = 3600;

export const CACHE_VIEW_POS_PARA: number = 2;

export const MIN_PAD_START: number = 2;

export const SEC_PAD_START_CUT: number = 4;

export const SEC_PAD_START_NO_CUT: number = 2;

export const MILLI_SECS_PAD_START: number = 3;

export const FORMAT_DATE_OFFSET: number = 100;

export const FORMAT_DATE_MONTH_OFFSET: number = 101;

export const FORMAT_FILE_SIZE_DP: number = 10;

export const LOG_MAX_FILE_SIZE_OFFSET: number = 22;

export const LOG_FORCE_REFRESH_CACHE_BYTE_OFFSET: number = 20;

export const LOG_FORCE_REFRESH_DURATION_MS_OFFSET: number = 500;

export const DOWNLOAD_FINISH_PERCENTAGE: number = 100;

export const TRIM_BAR_WIDTH: number = 16;

export const TRIM_BAR_HOT_ZOOM: number = 24;

export const TRIMER_BAR_OFFSET: number = 6.5;

// Canvas组件超过5000px会闪黑，定义最大尺寸为4900
export const CANVAS_MAX_WIDTH: number = 4900;

export const LIVE_PHOTO_POSITION_X_OFFSET_PHONE: number = 20;

export const LIVE_PHOTO_POSITION_X_OFFSET_PAD: number = 30;

export const LIVE_PHOTO_POSITION_Y_OFFSET: number = 12;

export const TRIM_BAR_HEIGHT_PORTRAIT: number = 60;

export const TRIM_BAR_HEIGHT_LANDSCAPE: number = 40;
// seek指针的宽度
export const SEEK_POINTER_WIDTH: number = 4;
//各设备的偏移量
export const VERTICAL_SCREEN_OFFSET: number = 40;
export const PHONE_HORIZONTAL_SCREEN_OFFSET: number = 140;
export const PAD_HORIZONTAL_SCREEN_OFFSET: number = 320;
export const FOLD_VERTICAL_SCREEN_OFFSET: number = 230;
export const FOLD_HORIZONTAL_SCREEN_OFFSET: number = 100;

// 编辑页面上下标题栏距离屏幕左右边距
export const EDITOR_GRID_SMALL_PADDING_LEFT_AND_RIGHT: number = 16;

export const EDITOR_GRID_MEDIUM_PADDING_LEFT_AND_RIGHT: number = 24;

export const EDITOR_GRID_LARGE_PADDING_LEFT_AND_RIGHT: number = 32;

// 过期滤镜状态码
export const OLD_FILTER_DATA_CODE: number = -200304;

// 截取页面 操作按钮高度
export const SLOW_MOTION_BAR_HEIGHT = 24;
// 截取页面 Pad设备下播放条高度
export const PAD_THUMBNAIL_HEIGHT = 60;
// 截取页面 Phone设备下播放条高度
export const PHONE_THUMBNAIL_HEIGHT = 40;
// 截取页面 播放条与操作按钮默认间距
export const DEFAULT_THUMBNAIL_MARGIN_TOP = 18;
// 截取页面 播放条与操作按钮小间距
export const MIN_THUMBNAIL_MARGIN_TOP = 8;
// 截取页面 竖屏状态下截取工具底部间距
export const PORTRAIT_TRIM_TOOL_BOTTOM = 18;
// 截取页面 分割线点击有效宽度（单位vp）
export const SPLIT_LINE_CLICK_WIDTH = 24;
// 截取页面 转场效果最小时长（单位ms）
export const TRANSITION_MIN_DURATION = 100;
// 截取页面 转场效果默认时长（单位ms）
export const TRANSITION_DEFAULT_DURATION = 500;
// 截取页面 转场预览区文字显示时间（单位ms）
export const TRANSITION_TEXT_SHOW_TIME = 500;

// 1 second = 1000 ms
export const secondToMillisecond = 1000;

// 1 minute = 60000 ms
export const minuteToMillisecond = 60000;

export const MUSIC_CONTROLLER_HEIGHT = 28;

export const MUSIC_VOLUME_UNFOLD_HEIGHT = 60;

export const MUSIC_VOLUME_FOLD_HEIGHT = 40;

export const MUSIC_COMP_MARGIN = 10;

export const MUSIC_UNPORTRAIT_COMP_MARGIN = 40;

// 横屏状态，预览区距离屏幕左右边距: Pad = 86, xxx | Phone = 78,
export const PAD_HALF_RIGHT_BAR_WIDTH = 86;
export const PHONE_HALF_RIGHT_BAR_WIDTH = 78;
// PC设备底部截取组件高度
export const PC_PREVIEW_BOTTOM_HEIGHT: number = 116;
// PC设备播放轨道距离屏幕底部的距离
export const PC_PORTRAIT_TRIM_TOOL_BOTTOM: number = 8;

// 音乐二次编辑相关的常量
export const MAX_AUDIO_TEXT_FONT_SCALE: number = 1.45;// 截取时间文本的最大倍率
export const AUDIO_TEXT_BUTTON_COMPONENT_HEIGHT: number = 28;// 音频时间胶囊组件的高度
export const SPACE_BETWEEN_AUDIO_TEXT_AND_HANDLE: number = 8;// 音频时间胶囊组件与把手之间的高度差
export const HANDLE_WIDTH: number = 16;// 把手宽度
export const CENTER_AREA_BORDER_WIDTH: number = 4;// 左/右把手内的中心区域边框宽度
export const AUDIO_TEXT_HEIGHT: number = 14;// 截取时间文本高度
export const RADIUS_IN_HANDLE: number = 8;// 中心区域圆角
export const MINIMUM_AUDIO_TIME: number = 100;// 最低截取时间0.1s
export const HANDLE_COLOR: string = '#FFFFFF'; // 激活态的把手颜色
export const HANDLE_COLOR_NOT_ACTIVE_COLOR: string = '#46484D'; // 非激活态的把手颜色

// 波形图相关常量
export const MAX_AUDIO_WAVE_DATA: number = 50; // 最多缓存的波形图个数
export const AUDIO_WAVE_POINTS_IN_PHONE: number = 180; // Phone设备音频波形图默认点数
export const AUDIO_WAVE_POINTS_IN_FOLDABLE: number = 230; // 可xxx音频波形图默认点数
export const AUDIO_WAVE_POINTS_IN_PAD: number = 400; // 平板设备音频波形图默认点数
export const AUDIO_WAVE_POINTS_IN_PC: number = 130; // PC设备音频波形图默认点数
export const PLAY_COMPLETE_TIME_PRECISION: number = 100; // 右把手与指针间隔100ms内认为是播放完毕
export const DIVIDER_WIDTH: number = 2; // 把手中指针的宽度

export const HW_MUSIC_BUNDLE_NAME: string = 'com.xxx.hmsapp.music';

export const BUNDLE_FLAGS	= bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_EXTENSION_ABILITY |
bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA;

export const META_DATA_NAME: string = 'feature-musiclibrary.online.videoedit';

export const META_DATA_VALUE: string = '1';

export const HW_MUSIC_ACTION: string = 'ohos.want.action.appdetail';

export const MUSIC_BIND_SHEET_MASK_COLOR: string = 'sys.color.mask_tertiary';

export enum SealType{
  NO_STICKER = 'NoSticker',
  IN_PLACE_STICKER = 'InplaceSticker',
  FRAME_STICKER = 'FrameSticker',
  XT_STYLE_STICKER = 'XtStyleSticker',
}

// 一键美肤
export const BEAUTY: string = 'Beauty';

// 运动
export const SPORT: string = 'Sport';

// 大光圈
export const WIDE_APERTURE: string = 'Wide_Aperture';

// 抓拍
export const SNAP: string = '1';

// 遥拍
export const PAN: string = '2';
