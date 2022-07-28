/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

export enum CropRatioType {
    RATIO_TYPE_FREE,
    RATIO_TYPE_HORIZONTAL,
    RATIO_TYPE_VERTICAL,
    RATIO_TYPE_1_1,
    RATIO_TYPE_16_9,
    RATIO_TYPE_9_16,
    RATIO_TYPE_4_3,
    RATIO_TYPE_3_4,
    RATIO_TYPE_3_2,
    RATIO_TYPE_2_3
}

export enum CropTouchState {
    NONE,
    CROP_MOVE,
    IMAGE_DRAG,
    IMAGE_SCALE
}

export enum CropAngle {
    ONE_QUARTER_CIRCLE_ANGLE = 90,
    HALF_CIRCLE_ANGLE = 180,
    THREE_QUARTER_CIRCLE_ANGLE = 270,
    CIRCLE_ANGLE = 360
}