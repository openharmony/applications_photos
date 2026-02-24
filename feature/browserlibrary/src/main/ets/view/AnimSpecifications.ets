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

import lazy curves from '@ohos.curves';

const TAG: string = 'AnimSpecifications';

/**
 * 参数定义
 */
export class AnimSpecifications {
  // <------------------    组件 透明度 alpha  ----------------------->

  // 完全透明
  public static readonly ALPHA_COMPLETELY_TRANSPARENT = 0.0;
  // 半透明 0.5
  public static readonly ALPHA_HALF = 0.5;
  // 不透明
  public static readonly ALPHA_OPAQUE = 1.0;
  // <------------------    组件 缩放 scale  ----------------------->

  // 原本大小 1.0
  public static readonly SCALE_ORIGINAL = 1.0;
  // 比例大小 0.8
  public static readonly SCALE_0_8 = 0.8;
  // 一半大小 0.5
  public static readonly SCALE_HALF = 0.5;
  // 隐藏状态 0.0
  public static readonly SCALE_ZERO = 0.0;
  // <------------------    组件 旋转 rotation  ----------------------->

  // 正向水平  0度
  public static readonly ROTATION_POSITIVE_HORIZONTAL = 0;
  // 垂直     90度
  public static readonly ROTATION_VERTICAL = 90;
  // 反向水平  180度
  public static readonly ROTATION_REVERSES_HORIZONTAL = 180;
  // 旋转轴位置  Y轴起始位置 ---- 0
  public static readonly ROTATION_Y_START = 0;
  // 旋转轴位置  Y轴中间位置 ---- 0.5
  public static readonly ROTATION_Y_HALF = 0.5;
  // <------------------    组件 模糊 blur  ----------------------->

  //模糊半径  100
  public static readonly BLUR_RADIUS_100 = 100;
  // <------------------    动效持续时长  duration  ----------------------->

  //duration  50
  public static readonly ANIM_DURATION_50 = 50;
  //duration  100
  public static readonly ANIM_DURATION_100 = 100;
  //duration  150
  public static readonly ANIM_DURATION_150 = 150;
  //duration  200
  public static readonly ANIM_DURATION_200 = 200;
  //duration  250
  public static readonly ANIM_DURATION_250 = 250;
  //duration  300
  public static readonly ANIM_DURATION_300 = 300;
  //duration  350
  public static readonly ANIM_DURATION_350 = 350;
  //duration  450
  public static readonly ANIM_DURATION_450 = 450;
  //duration  500
  public static readonly ANIM_DURATION_500 = 500;
  //duration  600
  public static readonly ANIM_DURATION_600 = 600;
  //duration  750
  public static readonly ANIM_DURATION_750 = 750;
  //duration  800
  public static readonly ANIM_DURATION_800 = 800;
  // <------------------    动效延迟  delay  ----------------------->

  //delay  50
  public static readonly ANIM_DELAY_50 = 50;
  //delay  100
  public static readonly ANIM_DELAY_100 = 100;
  //delay  150
  public static readonly ANIM_DELAY_150 = 150;
  //delay  200
  public static readonly ANIM_DELAY_200 = 200;
  //delay  250
  public static readonly ANIM_DELAY_250 = 250;
  //delay  400
  public static readonly ANIM_DELAY_400 = 400;
  //delay  500
  public static readonly ANIM_DELAY_500 = 500;
  //delay  550
  public static readonly ANIM_DELAY_550 = 550;
  //delay  700
  public static readonly ANIM_DELAY_700 = 700;
  //delay  950
  public static readonly ANIM_DELAY_950 = 950;
  //delay  1000
  public static readonly ANIM_DELAY_1000 = 1000;
  //delay  1500
  public static readonly ANIM_DELAY_1500 = 1500;
  // <------------------    旋转动画角度值  delay  ----------------------->

  //rotate 0
  public static readonly ANIM_ROTATE_0 = 0;
  //rotate 90
  public static readonly ANIM_ROTATE_90 = 90;
  //rotate 180
  public static readonly ANIM_ROTATE_180 = 180;
  //rotate 270
  public static readonly ANIM_ROTATE_270 = 270;
  //rotate 360
  public static readonly ANIM_ROTATE_360 = 360;
  // <------------------    预览翻转动效参数   ----------------------->

  // 取景框  缩放比例  0.8
  public static readonly CAMERA_FLIP_SCALE_END = 0.8;
  // 取景框1 终点旋转角度  80
  public static readonly CAMERA_FLIP_BLUR1_ROTATION_END = 80;
  // 取景框2 起点旋转角度  -80
  public static readonly CAMERA_FLIP_BLUR2_ROTATION_START = -80;
  // 摄像头按钮外圈 缩放比例90%
  public static readonly CAMERA_FLIP_SCALE_90 = 0.9;
  // 摄像头按钮外圈 缩放比例150%
  public static readonly CAMERA_FLIP_SCALE_150 = 1.5;
  // <------------------    拍照动效参数  ----------------------->

  // 拍照公用弹簧曲线
  public static readonly ANIM_CAPTURE_CURVE: curves.ICurve = curves.interpolatingSpring(1, 1, 410, 38);
  public static readonly ANIM_NIGHT_CURVE: curves.ICurve = curves.interpolatingSpring(1, 1, 410, 38);
  // 拍照按钮
  public static readonly ANIM_CAPTURE_BUTTON_DELAY = 0;
  public static readonly ANIM_CAPTURE_BUTTON_UP_DURATION = 200;
  public static readonly ANIM_CAPTURE_BUTTON_SCALE_DOWN: ScaleOptions = { x: 0.8, y: 0.8 };
  public static readonly ANIM_CAPTURE_BUTTON_SCALE_UP: ScaleOptions = { x: 1, y: 1 };
  public static readonly ANIM_NIGHT_BUTTON_SCALE_UP: ScaleOptions = { x: 1, y: 1 };
  public static readonly ANIM_AUDIO_CONTROL_CAPTURE_BUTTON_SCALE_DOWN: ScaleOptions = { x: 0.7, y: 0.7 };
  public static readonly ANIM_NIGHT_BUTTON_SCALE_DOWN: ScaleOptions = { x: 0.88, y: 0.88 };
  public static readonly ANIM_NIGHT_BUTTON_ONE_SCALE_DOWN: ScaleOptions = { x: 0.9, y: 0.9 };
  public static readonly ANIM_NIGHT_BUTTON_TWO_SCALE_DOWN: ScaleOptions = { x: 0, y: 0 };
  public static readonly ANIM_NIGHT_BUTTON_WIDTH_START: number = 18;
  public static readonly ANIM_NIGHT_BUTTON_WIDTH_MIDDLE: number = 42;
  public static readonly ANIM_NIGHT_BUTTON_WIDTH_END: number = 48;
  public static readonly ANIM_NIGHT_BUTTON_COLOR_MIDDLE: Color = Color.Gray;
  public static readonly ANIM_NIGHT_BUTTON_COLOR_END: Color = Color.White;
  public static readonly ANIM_NIGHT_BUTTON_RADIUS_START: number = 2;
  public static readonly ANIM_NIGHT_BUTTON_RADIUS_END: number = 24;
  // 取景框闪黑
  public static readonly ANIM_CAPTURE_FLASH_BLACK_DELAY = 50;
  public static readonly ANIM_CAPTURE_FLASH_BLACK_DURATION = 200;
  public static readonly ANIM_CAPTURE_FLASH_BLACK_OPACITY_FROM = 1;
  public static readonly ANIM_CAPTURE_FLASH_BLACK_OPACITY_TO = 0;
  // 缩略图
  public static readonly ANIM_CAPTURE_THUMBNAIL_OPACITY_FROM = 0;
  public static readonly ANIM_CAPTURE_THUMBNAIL_OPACITY_TO = 1;
  public static readonly ANIM_CAPTURE_THUMBNAIL_SCALE_FROM: ScaleOptions = { x: 1.5, y: 1.5 };
  public static readonly ANIM_CAPTURE_THUMBNAIL_SCALE_TO: ScaleOptions = { x: 1, y: 1 };
  // <------------------    录制动效参数  ----------------------->

  public static readonly ANIM_VIDEO_CURVE: curves.ICurve = curves.interpolatingSpring(1, 1, 410, 38);
  // 录制按钮
  public static readonly ANIM_VIDEO_BUTTON_DELAY = 0;
  public static readonly ANIM_VIDEO_START_DURATION = 50;
  public static readonly ANIM_VIDEO_BUTTON_SCALE_UP: ScaleOptions = { x: 1, y: 1 };
  public static readonly ANIM_VIDEO_BUTTON_1_SCALE_DOWN: ScaleOptions = { x: 0.9, y: 0.9 };
  public static readonly ANIM_VIDEO_BUTTON_2_SCALE_DOWN: ScaleOptions = { x: 0, y: 0 };
  public static readonly ANIM_VIDEO_BUTTON_WIDTH_START: number = 18;
  public static readonly ANIM_VIDEO_BUTTON_WIDTH_END: number = 48;
  public static readonly ANIM_VIDEO_BUTTON_RADIUS_START: number = 2;
  public static readonly ANIM_VIDEO_BUTTON_RADIUS_END: number = 24;
  public static readonly ANIM_VIDEO_BUTTON_COLOR_START: Color = Color.Red;
  public static readonly ANIM_VIDEO_BUTTON_COLOR_END: Color = Color.White;
  // <------------------    模式切换动效参数  ----------------------->

  public static readonly ANIM_MODE_SWITCH_CURVE = curves.interpolatingSpring(1, 1, 228, 30);
  public static readonly ANIM_MODE_SWITCH_BLUR = 80;
  // <------------------    预览区上下移动动效参数   ----------------------->

  public static readonly ANIM_PREVIEW_AREA_UP_OR_DOWN: curves.ICurve = curves.interpolatingSpring(0, 1, 228, 30);
  // <------------------    缩略图及大图组件动效参数  ----------------------->

  public static readonly ANIM_PB_SHARE_OPEN_CURVE: curves.ICurve = curves.interpolatingSpring(0, 1, 228, 25);
  public static readonly ANIM_PB_SHARE_CLOSE_CURVE: curves.ICurve = curves.interpolatingSpring(0, 1, 450, 42);
  public static readonly ANIM_PB_SHARE_DURATION = 300;
  public static readonly GEOMETRY_TRANSITION_ID_THUMBNAIL = 'Thumbnail_GeometryTransitionId';
  // <------------------    设置页入场动效参数  ----------------------->

  public static readonly NUM_4: number = 4;
}