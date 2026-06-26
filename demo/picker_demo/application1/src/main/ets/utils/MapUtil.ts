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
import type { ValueType } from '@ohos.data.ValuesBucket';
import lazy { mapCommon } from '@kit.MapKit';


export interface StaticMapOptions {
  location: {
    latitude: number,
    longitude: number
  },
  zoom: number,
  imageWidth: number,
  imageHeight: number,
  scale?: number,
  dayNightMode?: mapCommon.DayNightMode
}

export interface LatLongRange {
  startLatitude: string,
  startLongitude: string,
  endLatitude: string,
  endLongitude: string
}

export interface MapDataStore {
  key: string,
  value: ValueType
}


export class MapUtil {
}
