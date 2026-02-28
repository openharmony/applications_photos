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

/* instrument ignore file */

import lazy { DateUtil } from '../../utils/DateUtil';
import lazy { Log } from '../../utils/Log';

const TAG: string = 'DurationFormatter';
const SEPARATOR: string = ':';
/**
 * String zero padding.
 */
const PADDING_STR: string = '0';
/**
 * Zero padding, 2 bits.
 */
const PADDING_NULL: string = PADDING_STR + PADDING_STR;

/**
 * Seconds converted to HH:mm:ss.
 *
 * @param seconds Maximum video duration (seconds).
 * @return Time after conversion.
 */
export function formatDuration(seconds: number): string {
  if (seconds === null || seconds === undefined || !Number.isFinite(seconds) || isNaN(seconds)) {
    Log.error(TAG, 'seconds is ', seconds.toString());
    return PADDING_NULL + SEPARATOR + PADDING_NULL;
  }
  /**
   * sexagesimal time system, Hour-minute-second conversion.
   */
  const SECONDS_PER_MINUTE = DateUtil.SECONDS_PER_MINUTE;
  const SECONDS_PER_HOUR = DateUtil.SECONDS_PER_HOUR;
  const hour = Math.floor(seconds / SECONDS_PER_HOUR);
  const minute = Math.floor((seconds - hour * SECONDS_PER_HOUR) / SECONDS_PER_MINUTE);
  const second = seconds - hour * SECONDS_PER_HOUR - minute * SECONDS_PER_MINUTE;
  return [hour, minute, second]
    .map(v => v.toString().length === 1 ? PADDING_STR + v : v)//长度=1时补位
    .filter((v, i) => v !== PADDING_NULL || i)//小时=0时筛掉
    .join(SEPARATOR);
}