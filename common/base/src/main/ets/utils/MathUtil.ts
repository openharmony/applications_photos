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

export function distance(x1: number, y1: number, x2: number, y2: number): number {
    let dstX = x1 - x2;
    let dstY = y1 - y2;
    return Math.sqrt(dstX * dstX + dstY * dstY);
}

export function clamp(num: number, min: number, max: number): number {
    return Math.min(Math.max(num, min), max);
}