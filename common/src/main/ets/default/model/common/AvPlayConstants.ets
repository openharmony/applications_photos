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

interface PlayPage {
  VOLUME: number;
  PLAY_PROGRESS_HEIGHT: string;
  COLUMN_HEIGHT_ONE: string;
  DEFAULT_HEIGHT: number;
}

interface PlayPlayer {
  ID: string;
  LIBRARY_NAME: string;
  SURFACE_WIDTH: number;
  SURFACE_HEIGHT: number;
  VIDEO_INDEX_THREE: number;
  VIDEO_INDEX_TWO: number;
  VIDEO_INDEX_ONE: number;
  VIDEO_INDEX_ZERO: number;
}

interface PlayProgress {
  CURRENT_TIME: string;
  TOTAL_TIME: string;
  PROGRESS_VAL: number;
  RAW_TIME: number,
  INTERVAL: number;
  STEP: number;
  TRACK_THICKNESS: number;
  SLIDER_WIDTH: string;
  MARGIN_LEFT: string;
  SEEK_TIME: number;
  ROW_WIDTH: string;
}

interface PlaySpeed {
  SPEED_0_125_X: number,
  SPEED_0_25_X: number,
  SPEED_0_5_X: number,
  SPEED_0_75_X: number,
  SPEED_1_0_X: number,
  SPEED_1_25_X: number,
  SPEED_1_5_X: number,
  SPEED_1_75_X: number,
  SPEED_2_0_X: number,
  SPEED_4_0_X: number,
  ANCHOR_START: number,
  ANCHOR_END: number,
}

// avplayer状态机回调接口
export interface AVPlayerCallBack {
  idleCallBack: () => void;
  initializedCallBack: () => void;
  preparedCallBack: () => void;
  playingCallBack: () => void;
  pauseCallBack: () => void;
  completedCallBack: () => void;
  stopCallBack: () => void;
  releasedCallBack: () => void;
  errorCallBack: () => void;
}


export enum XComponentStatus {
  LOAD = 'load',
  DESTROY = 'destroy',
}

export enum PageStatus {
  HIDE = 'hide',
  SHOW = 'show',
}

export class VideoReportParams {
  public url: string = '';
  public start: number = -1;
  public end: number = -1;
  public duration: number = -1;
  public playDuration: number = -1;
  public bufferTimes: number = -1;
  public netType: number = -1;
  public netDownWidthAvg: number = -1;
  public netDownRateAvg: number = -1;
  public netRttMsAvg: number = -1;
  public position: MediaPosition = MediaPosition.LOCAL;
  public bitrate: number = -1;
  public timeCost: number = -1;
  public code: number = -1;
  public space: number = -1;
  public totalTime: number = -1;
  public playTime: number = -1;
  public catonTime: number = -1;
  public pauseReason: number = 1;
  public rate: number = -1;
  public fastPlayTime: number = -1;
  public subtype: number = -1;
  public quality: number = -1;
}

export enum PauseReason {
  MANUALLY = 1,
  SEEK = 2,
  BUFFERING = 3,
  PAGE_HIDE = 4,
  CAST = 5,
  AUDIO = 6,
  PICKER = 7,
  OTHERS = 8,
  DOUBLE_CLICK = 9,
  SELECTED_MODE = 10
}

/**
 * 视频播放相关常量
 */
export class AvPlayConstants {
  // 全屏
  public static readonly FULL_PERCENT: string = '100%';
  // 宽高占比
  public static readonly ASPECT_RATIO: number = 1;
  // 10
  public static readonly TEN: number = 10;
  // 100
  public static readonly ONE_HUNDRED: number = 100;
  // 1000
  public static readonly A_THOUSAND: number = 1000;
  // 静音
  public static readonly AV_PLAY_MUTE: number = 0.0;
  // 声音
  public static readonly AV_PLAY_VOLUME: number = 1.0;
  // 精准seek
  public static readonly SEEK_MODE_PERFECT: number = 3;
  // 屏幕旋转延时
  public static readonly AV_PLAY_DELAY_TIME: number = 5000;
  // 点击播放按钮trace打点id
  public static readonly TRACE_ID_OF_PLAY_BUTTON: number = 6104;
  // loading progress默认间距
  public static readonly LOADING_PROGRESS_DEFAULT_PADDING: number = 16;
  // fps 60
  public static readonly VIDEO_FPS_60: number = 60;
  // fps 120
  public static readonly VIDEO_FPS_120: number = 120;
  // fps 240
  public static readonly VIDEO_FPS_240: number = 240;
  // 动态帧率误差下边界
  public static readonly VIDEO_FPS_DEVIATION_MIN: number = 0.95;
  // 动态帧率误差上边界
  public static readonly VIDEO_FPS_DEVIATION_MAX: number = 1.05;
  // 播放速度
  public static readonly PLAY_SPEED: PlaySpeed = {
    SPEED_0_125_X: 9,
    SPEED_0_25_X: 8,
    SPEED_0_5_X: 5,
    SPEED_0_75_X: 0,
    SPEED_1_0_X: 1,
    SPEED_1_25_X: 2,
    SPEED_1_5_X: 6,
    SPEED_1_75_X: 3,
    SPEED_2_0_X: 4,
    SPEED_4_0_X: 10,
    ANCHOR_START: 0.2,
    ANCHOR_END: 0.8,
  }
  // 播放页常量
  public static readonly PLAY_PAGE: PlayPage = {
    VOLUME: 0.5,
    PLAY_PROGRESS_HEIGHT: '7.1%',
    COLUMN_HEIGHT_ONE: '85.7%',
    DEFAULT_HEIGHT: 20,
  }
  // XComponent相关常量
  public static readonly PLAY_PLAYER: PlayPlayer = {
    ID: '',
    LIBRARY_NAME: '',
    SURFACE_WIDTH: 1920,
    SURFACE_HEIGHT: 1080,
    VIDEO_INDEX_THREE: 3,
    VIDEO_INDEX_TWO: 2,
    VIDEO_INDEX_ONE: 1,
    VIDEO_INDEX_ZERO: 0,
  }
  // 进度条相关常量
  public static readonly PLAY_PROGRESS: PlayProgress = {
    CURRENT_TIME: '00:00',
    TOTAL_TIME: '00:00',
    PROGRESS_VAL: 0,
    RAW_TIME: 0,
    INTERVAL: -1,
    STEP: 1,
    TRACK_THICKNESS: 4,
    SLIDER_WIDTH: '68.9%',
    MARGIN_LEFT: '2.2%',
    SEEK_TIME: 0,
    ROW_WIDTH: '93.4%',
  }
  // 逐帧播放取帧公式系数
  public static readonly CON1: number = 2.8958;
  public static readonly CON2: number = 0.5016;
  // 逐帧播放动效时长
  public static readonly ANI_DURATION: number = 350;
  // 逐帧播放缩略图入场出场动效时长
  public static readonly thumbInOutDuration: number = 350;
  // 时间胶囊3s后消失
  public static readonly TIME_CAPSULE_DURATION: number = 3000;
  // 时间胶囊透明度动效时长
  public static readonly TIME_CAPSULE_OPACITY_DURATION: number = 150;
  // 时间胶囊位移/缩放动效时长
  public static readonly TIME_CAPSULE_SCALE_DURATION: number = 150;
  // 时间胶囊缩小最小值
  public static readonly TIME_CAPSULE_SCALE_MIN: number = 0.5;
  // 时间胶囊缩小中心 - X轴
  public static readonly TIME_CAPSULE_SCALE_CENTER_X: string = '50%';
  // 时间胶囊缩小中心 - Y轴
  public static readonly TIME_CAPSULE_SCALE_CENTER_Y: string = '100%';
  // 时间胶囊字体大小
  public static readonly TIME_CAPSULE_FONT_SIZE: number = 12;
  // 时间胶囊margin
  public static readonly TIME_CAPSULE_MARGIN_BOTTOM: number = 2;
  // 逐帧播放xxx最小抽帧个数
  public static readonly MIN_FRAME_NUM: number = 3;
  // 逐帧播放封面帧个数
  public static readonly COVER_FRAME_NUM: number = 2;
  // 视频时长的一半
  public static readonly DURATION_HALF: number = 2;
  // 非xxx，播放完成后重置定位条延时
  public static readonly RESET_PREVIEW_BAR_DELAY: number = 150;
  // 视频播放时，概率出现闪一下；将封面延迟20ms撤掉
  public static readonly REMOVE_COVER_DELAY: number = 20;
  // 视频文件名前缀
  public static readonly VIDEO_PREFIX_STR: string = 'SL_MO_VID';
}

export enum AvplayerErrorCode {
  // Could not read from resource
  IO_ERROR = 5400103,
  // media_service died code
  SERVICE_DIED = 5400105,
  // unsupported media type
  UNSUPPORTED_MEDIA_TYPE = 5400106,
  // Operation not allowed
  OPERATION_NOT_ALLOWED = 5400102,
}

export enum MediaPosition {
  LOCAL = 'LOCAL',
  CLOUD = 'CLOUD',
  BOTH = 'BOTH',
}

/**
 * avplayer状态枚举
 */
export enum AvplayerStatus {
  // 闲置状态，属性都为默认值。
  IDLE = 'idle',
  // 资源初始化，AVPlayer会进入initialized状态，此时可以配置窗口、音频等静态属性。
  INITIALIZED = 'initialized',
  // 已准备状态，在initialized状态调用prepare()方法，AVPlayer会进入prepared状态
  PREPARED = 'prepared',
  // 正在播放状态
  PLAYING = 'playing',
  // 暂停状态
  PAUSED = 'paused',
  // 播放至结尾状态，当媒体资源播放至结尾时
  COMPLETED = 'completed',
  // 停止状态
  STOPPED = 'stopped',
  // 销毁状态，销毁与当前AVPlayer关联的播放引擎
  RELEASED = 'released',
  // 错误状态
  ERROR = 'error',
}

/**
 * avplayer监听事件类型枚举
 */
export enum Events {
  // 状态改变
  STATE_CHANGE = 'stateChange',
  // 视频进度
  TIME_UPDATE = 'timeUpdate',
  // 音频焦点变化
  AUDIO_INTERRUPT = 'audioInterrupt',
  // 播放结束
  END_OF_STREAM = 'endOfStream',
  // 首帧上报
  START_RENDER_FRAME = 'startRenderFrame',
  // 视频宽高上报
  VIDEO_SIZE_CHANGE = 'videoSizeChange',
  // reset事件
  RESET = 'reset',
  // error事件
  ERROR = 'error',
  // 进度设置
  SEEK_DONE = 'seekDone',
  // 倍速设置成功监听
  SPEED_DONE = 'speedDone',
  // 音频流输出设备变化
  AUDIO_OUTPUT_DEVICE_CHANGE_WITH_INFO = 'audioOutputDeviceChangeWithInfo',
}

/**
 * 进度条类型枚举
 */
export enum LoadProgressType {
  // 条式进度条
  SLIDER = 'slider',
  // list预览进度条
  PREVIEW = 'preview',
}

/**
 * 播放类型枚举
 */
export enum PlayType {
  // 非自动 - 点击按钮播放
  CLICK_TO_PLAY = 'clickToPlay',
  // 自动播放
  AUTOPLAY = 'autoplay',
}