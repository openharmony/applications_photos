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
import lazy { Constants } from '../model/common/Constants';

export class AnimationUtil {
  public static albumAnimation(isOpenTransitionAni: boolean): TransitionEffect {
    return isOpenTransitionAni ?
    TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({
        curve: Curve.Sharp,
        duration: Constants.GRID_ADD_OPACITY_DURATION,
      }).combine(
        TransitionEffect.scale({ x: Constants.GRID_SCALE_VALUE, y: Constants.GRID_SCALE_VALUE }).animation({
          curve: Curve.Friction,
          duration: Constants.GRID_ADD_SCALE_DURATION,
        })
      ),
      TransitionEffect.OPACITY.animation({
        curve: Curve.Sharp,
        duration: Constants.GRID_DEL_OPACITY_DURATION,
      }).combine(
        TransitionEffect.scale({ x: Constants.GRID_SCALE_VALUE, y: Constants.GRID_SCALE_VALUE }).animation({
          curve: Curve.Friction,
          duration: Constants.GRID_DEL_SCALE_DURATION,
        })
      )
    ) :
    TransitionEffect.OPACITY
  }

  public static blurImageAnimation(): TransitionEffect {
    return TransitionEffect.OPACITY.animation({
      curve: Curve.Sharp,
      duration: Constants.BLUR_IMAGE_ANIMATION_SCALE_DURATION,
    }).combine(
      TransitionEffect.scale({ x: Constants.BLUR_IMAGE_SCALE_VALUE, y: Constants.BLUR_IMAGE_SCALE_VALUE }).animation({
        curve: Curve.Friction,
        duration: Constants.BLUR_IMAGE_ANIMATION_SCALE_DURATION,
      })
    )
  }
}