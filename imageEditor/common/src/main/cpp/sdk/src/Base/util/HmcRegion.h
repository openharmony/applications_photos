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
#ifndef OH_HMC_REGION_H
#define OH_HMC_REGION_H
#include <cstdint>

struct HmcRegion {
    /** X coordinate of the start point, in pixels. */
    uint32_t x;
    /** Y coordinate of the start point, in pixels. */
    uint32_t y;
    /** Width of the region, in pixels. */
    uint32_t width;
    /** Height of the region, in pixels. */
    uint32_t height;
};

#endif //OH_HMC_REGION_H
