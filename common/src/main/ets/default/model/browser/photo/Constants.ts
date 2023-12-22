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

import Curves from '@ohos.curves';

export class Constants {
  // Immersive animation duration
  static readonly IMMERSE_ANIM_DURATION = 200;
  static readonly IMMERSE_ANIM_DELAY = 50;

  // click event
  static readonly TOGGLE_BAR: string = 'single_photo_toggle_bar';

  // hide bars
  static readonly HIDE_BARS: string = 'single_photo_hide_bars';

  // show bars
  static readonly SHOW_BARS: string = 'single_photo_show_bars';

  // pull down to return start
  static readonly PULL_DOWN_START: string = 'single_photo_pull_down_start';

  // pull down to return end
  static readonly PULL_DOWN_END: string = 'single_photo_pull_down_end';

  // pull down to return cancel
  static readonly PULL_DOWN_CANCEL: string = 'single_photo_pull_down_cancel';

  // pull down to return threshold
  static readonly PULL_DOWN_THRESHOLD: number = 200;

  // data quantity change
  static readonly DATA_SIZE_CHANGED: string = 'photo_data_size_changed';

  // current data change
  static readonly DATA_CONTENT_CHANGED: string = 'photo_data_content_changed';

  // video play
  static readonly VIDEO_PLAY: string = 'single_photo_video_play';

  // video pause
  static readonly VIDEO_PAUSE: string = 'single_photo_video_pause';

  // popup show
  static readonly POP_APPEAR: string = 'single_photo_popup_appear';

  // popup disappear
  static readonly POP_DISAPPEAR: string = 'single_photo_popup_disappear';

  // set favor photo
  static readonly SET_FAVOR: string = 'single_photo_set_favor';

  // rename photo
  static readonly RENAME: string = 'single_photo_rename';

  // rotate photo
  static readonly ROTATE: string = 'single_photo_rotate';

  // delete photo
  static readonly DELETE: string = 'single_photo_delete';

  // remove photo
  static readonly Remove: string = 'single_photo_remove';

  // photo show state
  static readonly PHOTO_SHOW_STATE: string = 'single_photo_show_state';

  // set swiper can swipe
  static readonly SET_DISABLE_SWIPE: string = 'set_disable_swipe';

  // update photo name
  static readonly UPDATE_PHOTO_NAME: string = 'update_photo_name';

  // reset default scale
  static readonly RESET_DEFAULT_SCALE: string = 'reset_default_scale';

  // save scale
  static readonly SAVE_SCALE: string = 'save_scale';

  // matrix
  static readonly MATRIX: string = 'matrix';

  // photo browser delete confirm
  static readonly PHOTO_BROWSER_DELETE_CONFIRM: string = 'photo_browser_delete_confirm';

  // photo browser remove confirm
  static readonly PHOTO_BROWSER_REMOVE_CONFIRM: string = 'photo_browser_remove_confirm';

  // Scale lower limit
  static readonly COMPONENT_SCALE_FLOOR: number = 0.5;

  // scale upper limit
  static readonly COMPONENT_SCALE_CEIL: number = 2.0;

  // when the double-click scale is larger than maxScale, the maxScale is adjusted to 1.2 times the double-click scale
  static readonly MAX_SCALE_EXTRA_FACTOR: number = 1.2;

  // After reaching max scale, you can also scale an additional 0.2x max scale, and rebound after letting go
  static readonly OVER_SCALE_EXTRA_FACTOR: number = 1.5;

  // If the aspect ratio of the picture is the same as the display area,
  // double-click to adjust the zoom factor to 4 / 3
  static readonly RATIO_SCALE_WIDTH: number = 4;
  static readonly RATIO_SCALE_HEIGHT: number = 3;
  static readonly SAME_RATIO_SCALE_FACTOR: number = Constants.RATIO_SCALE_WIDTH / Constants.RATIO_SCALE_HEIGHT;

  static readonly CURVE_X1: number = 0.2;
  static readonly CURVE_Y1: number = 0.2;
  static readonly CURVE_X2: number = 0.1;
  static readonly CURVE_Y2: number = 1.0;
  static readonly PHOTO_TRANSITION_CURVE: string =
    Curves.cubicBezier(Constants.CURVE_X1, Constants.CURVE_Y1, Constants.CURVE_X2, Constants.CURVE_Y2);

  // GeometryTransition constants
  static readonly CAN_PULL_DOWN_DRAG_THRESHOLD: number = 10;
  static readonly SPRING_MOTION_RESPONSE: number = 0.347;
  static readonly SPRING_MOTION_DAMPING_FRACTION: number = 0.99;
  static readonly SPRING_MOTION_CURVE: Curves.ICurve =
    Curves.springMotion(Constants.SPRING_MOTION_RESPONSE, Constants.SPRING_MOTION_DAMPING_FRACTION);

  // Drag image curve constants
  static readonly DRAG_SCALE: number = 0.0013;
  static readonly MIN_DRAG_SCALE: number = 0.5;
  static readonly DRAG_OPACITY: number = 0.0026;

  static readonly RESPONSIVE_SPRING_MOTION_RESPONSE: number = 0.15;
  static readonly RESPONSIVE_SPRING_MOTION_DAMPING_FRACTION: number = 0.86;
  static readonly RESPONSIVE_SPRING_MOTION_OVERLAP_DURATION: number = 0.25;
  static readonly RESPONSIVE_SPRING_MOTION_CURVE: Curves.ICurve =
  Curves.responsiveSpringMotion(Constants.RESPONSIVE_SPRING_MOTION_RESPONSE,
    Constants.RESPONSIVE_SPRING_MOTION_DAMPING_FRACTION, Constants.RESPONSIVE_SPRING_MOTION_OVERLAP_DURATION);

  // overScale animation duration
  static readonly OVER_SCALE_ANIME_DURATION: number = 500;
  static readonly ROTATE_ONCE: number = 90;
  static readonly ROTATE_TWICE: number = 180;
  static readonly ROTATE_THRICE: number = 270;
  static readonly ROTATE_QUARTIC: number = 360;
  static readonly DEFAULT_SIZE: number = 256;
  static readonly OPERATION_EXIT_ANIMATION_DURATION: number = 100;
  static readonly SHARE_TRANSITION_DURATION: number = 200;
  static readonly PAGE_SHOW_ANIMATION_DURATION: number = 200;
  static readonly PHOTO_GRID_ANIMATION_DURATION: number = 300;
  static readonly PHOTO_SWIPE_DURATION: number = 300;
  static readonly RESERVED_DIGITS: number = 6;
  static readonly CENTER_DEFAULT: number = 0.5;
  static readonly NUMBER_2: number = 2;
  static readonly NUMBER_3: number = 3;
  static readonly NUMBER_12: number = 12;
  static readonly NUMBER_13: number = 13;

  static readonly PHOTO_GRID_Scale: number = 0.8
  static readonly Album_Scale: number = 1.2
  static readonly LINK_IN_PHOTO_GRID_DELAY: number = 100;
  static readonly PC_LINK_IN_PHOTO_GRID_ACTIONBAR_DURATION: number = 150;
  static readonly PC_LINK_OUT_PHOTO_GRID_ACTIONBAR_DURATION: number = 200;
  static readonly PC_LINK_ALBUM_DURATION: number = 200;
  static readonly PC_LINK_OUT_PHOTO_GRID_DURATION: number = 150;
  static readonly PC_LINK_IN_PHOTO_GRID_DURATION: number = 200;
  static readonly PC_LINK_IN_ALBUM_ACTIONBAR_DURATION: number = 150;
  static readonly PC_LINK_OUT_ALBUM_ACTIONBAR_DURATION: number = 200;
  static readonly PC_LINK_IN_SIDEBAR_DURATION: number = 150;
  static readonly PC_LINK_OUT_SIDEBAR_DURATION: number = 200;
  static readonly PC_LINK_OUT_SIDEBAR_DELAY: number = 0;
  static readonly PC_LINK_IN_ALBUM_DURATION: number = 200;
  static readonly PC_LINK_IN_ALBUM_DELAY: number = 50;
  static readonly PC_LINK_OUT_SIDEBAR_BOUNDARY_LINE_DURATION: number = 150;
  static readonly PC_LINK_OUT_SIDEBAR_BOUNDARY_LINE_DELAY: number = 250;
  static readonly PC_LINK_ALBUM_TO_PHOTO_GRID_DURATION: number = 400;
  static readonly PC_LINK_ALBUM_TO_PHOTO_GRID_SCALE_DURATION: number = 400;
  static readonly PC_LINK_PHOTO_GRID_TO_ALBUM_DURATION: number = 400;
  static readonly PC_LINK_PHOTO_GRID_TO_ALBUM_SCALE_DURATION: number = 400;
  static readonly PC_LINK_OUT_ALBUM_ACTIONBAR_DELAY: number = 50;
  static readonly PC_LINK_PHOTO_GRID_ACTIONBAR_DELAY: number = 100;

  static readonly PHONE_LINK_IN_PHOTO_GRID_ACTIONBAR_DURATION: number = 250;
  static readonly PHONE_LINK_OUT_PHOTO_GRID_ACTIONBAR_DURATION: number = 175;
  static readonly PHONE_LINK_PHOTO_GRID_ACTIONBAR_DELAY: number = 250;
  static readonly PHONE_LINK_ALBUM_ACTIONBAR_DURATION: number = 250;
  static readonly PHONE_LINK_ALBUM_ACTIONBAR_DELAY: number = 100;
  static readonly PHONE_LINK_IN_TAB_BAR_DURATION: number = 250;
  static readonly PHONE_LINK_OUT_TAB_BAR_DURATION: number = 175;
  static readonly PHONE_LINK_ALBUM_TO_PHOTO_GRID_DURATION: number = 500;
  static readonly PHONE_LINK_ALBUM_TO_PHOTO_GRID_SCALE_DURATION: number = 500;
  static readonly PHONE_LINK_PHOTO_GRID_TO_ALBUM_DURATION: number = 350;
  static readonly PHONE_LINK_PHOTO_GRID_TO_ALBUM_SCALE_DURATION: number = 350;
}