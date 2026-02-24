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

import lazy { Log } from './Log';
import lazy i18n from '@ohos.i18n';
import lazy Intl from '@ohos.intl';
import lazy { UiUtil } from './UiUtil';

const TAG: string = 'common_DateUtil';

export class DateUtil {
  public static readonly MILLISECONDS_PER_SECOND: number = 1000;
  public static readonly MICROSECONDS_PER_SECOND: number = 1000 * 1000;
  public static readonly NANOSECONDS_PER_SECOND: number = 1000 * 1000 * 1000;
  public static readonly MILLISECONDS_OF_ONE_DAY: number = 24 * 60 * 60 * 1000;
  public static readonly SECONDS_PER_MINUTE: number = 60;
  public static readonly SECONDS_PER_HOUR: number = 3600;
  public static readonly DAYS_OF_THE_WEEK: number = 7;
  private static readonly NEW_NAME_IMG: string = 'IMG_';
  private static readonly SECONDS_OF_ONE_DAY: number = 24 * 60 * 60;
  private static preLocale: string = DateUtil.getLocales();
  private static dateTimeFormat: Intl.DateTimeFormat;
  private static monthAndDayFormat: Intl.DateTimeFormat;
  private static yearAndMonthFormat: Intl.DateTimeFormat;
  private static dayFormat: Intl.DateTimeFormat;
  private static monthFormat: Intl.DateTimeFormat;
  private static yearFormat: Intl.DateTimeFormat;
  private static is24HourTimeFormat: Intl.DateTimeFormat;
  private static isNot24HourTimeFormat: Intl.DateTimeFormat;

  private static setDateTimeFormat(dateTimeFormat: Intl.DateTimeFormat): void {
    this.dateTimeFormat = dateTimeFormat;
  }

  private static getCurDateTimeFormat(): Intl.DateTimeFormat {
    if (this.dateTimeFormat) {
      return this.dateTimeFormat;
    }
    this.dateTimeFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
    return this.dateTimeFormat;
  }

  private static setMonthAndDayFormat(monthAndDayFormat: Intl.DateTimeFormat): void {
    this.monthAndDayFormat = monthAndDayFormat;
  }

  private static getMonthAndDayFormat(): Intl.DateTimeFormat {
    if (this.monthAndDayFormat) {
      return this.monthAndDayFormat;
    }
    this.monthAndDayFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      month: 'long',
      day: 'numeric'
    });
    return this.monthAndDayFormat;
  }

  private static setDayFormat(dayFormat: Intl.DateTimeFormat): void {
    this.dayFormat = dayFormat;
  }

  private static getDayFormat(): Intl.DateTimeFormat {
    if (this.dayFormat) {
      return this.dayFormat;
    }
    this.dayFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      day: 'numeric'
    });
    return this.dayFormat;
  }

  private static setYearAndMonthFormat(yearAndMonthFormat: Intl.DateTimeFormat): void {
    this.yearAndMonthFormat = yearAndMonthFormat;
  }

  private static getYearAndMonthFormat(): Intl.DateTimeFormat {
    if (this.yearAndMonthFormat) {
      return this.yearAndMonthFormat;
    }
    this.yearAndMonthFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: 'numeric',
      month: 'long'
    });
    return this.yearAndMonthFormat;
  }

  private static setMonthFormat(monthFormat: Intl.DateTimeFormat): void {
    this.monthFormat = monthFormat;
  }

  private static getMonthFormat(): Intl.DateTimeFormat {
    if (this.monthFormat) {
      return this.monthFormat;
    }
    this.monthFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      month: 'numeric'
    });
    return this.monthFormat;
  }

  private static setYearFormat(yearFormat: Intl.DateTimeFormat): void {
    this.yearFormat = yearFormat;
  }

  private static getYearFormat(): Intl.DateTimeFormat {
    if (this.yearFormat) {
      return this.yearFormat;
    }
    this.yearFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: 'numeric'
    });
    return this.yearFormat;
  }

  private static setIs24HourTimeFormat(is24HourTimeFormat: Intl.DateTimeFormat): void {
    this.is24HourTimeFormat = is24HourTimeFormat;
  }

  private static getIs24HourTimeFormat(): Intl.DateTimeFormat {
    if (this.is24HourTimeFormat) {
      return this.is24HourTimeFormat;
    }
    this.is24HourTimeFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      hour12: false,
      hour: 'numeric',
      minute: '2-digit'
    });
    return this.is24HourTimeFormat;
  }

  private static setIsNot24HourTimeFormat(isNot24HourTimeFormat: Intl.DateTimeFormat): void {
    this.isNot24HourTimeFormat = isNot24HourTimeFormat;
  }

  private static getIsNot24HourTimeFormat(): Intl.DateTimeFormat {
    if (this.isNot24HourTimeFormat) {
      return this.isNot24HourTimeFormat;
    }
    this.isNot24HourTimeFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      hour12: true,
      hour: '2-digit',
      minute: '2-digit'
    });
    return this.isNot24HourTimeFormat;
  }

  // Get the date after localization (year-month-day)
  public static getLocalizedDate(milliseconds: number, containYear: boolean = true): string {
    DateUtil.checkLocaleAndUpdateFormatInstance();
    if (containYear) {
      return DateUtil.getCurDateTimeFormat().format(new Date(milliseconds));
    } else {
      return DateUtil.getMonthAndDayFormat().format(new Date(milliseconds));
    }
  }

  public static format(time: Date, formatStr?: string): string {
    if (!formatStr) {
      return time.valueOf().toString();
    }
    let opts = {
      MM: time.getMonth() + 1,
      dd: time.getDate(),
      HH: time.getHours(),
      mm: time.getMinutes(),
      ss: time.getSeconds()
    };

    if (/(y+)/.test(formatStr)) {
      formatStr = formatStr.replace('yyyy', time.getFullYear().toString().substr(0));
    }
    for (let f in opts) {
      if (new RegExp('(' + f + ')').test(formatStr)) {
        const tmp = f as keyof (typeof opts);
        formatStr = formatStr.replace(tmp, (tmp.length === 1) ? opts[tmp].toString() : (('00' + opts[tmp]).substr(
          opts[tmp].toString().length)));
      }
    }
    return formatStr;
  }

  public static getDateTimeFormat(milliseconds: number): string {
    return DateUtil.format(new Date(milliseconds), 'yyyy/MM/dd HH:mm:ss');
  }

  // Gets the localization date of the photo page grouping data
  public static getGroupDataLocalizedDate(milliseconds: number): Resource {
    let date = new Date(milliseconds);
    let today = new Date();
    // instrument ignore if
    if (date.getFullYear() === today.getFullYear() && date.getMonth() === today.getMonth()) {
      if (date.getDate() === today.getDate()) {
        return $r('app.string.date_today');
      }
      if (today.getDate() - date.getDate() === 1) {
        return $r('app.string.date_yesterday');
      }
    }
    DateUtil.checkLocaleAndUpdateFormatInstance();
    return $r('app.string.common_place_holder', this.getLocalizedDate(milliseconds));
  }

  public static getLocalizedYearResource(milliseconds: number): Resource {
    let locales: string = this.getLocales();
    let yearText = new Intl.DateTimeFormat(locales, {
      year: 'numeric'
    }).format(new Date(milliseconds));
    return $r('app.string.common_place_holder', yearText.toString());
  }

  public static getLocalizedYearString(milliseconds: number): string {
    let locales: string = this.getLocales();
    let yearText = new Intl.DateTimeFormat(locales, {
      year: 'numeric'
    }).format(new Date(milliseconds));
    Log.info(TAG, `getLocalizedYearString${yearText.toString()}`);
    return yearText.toString();
  }

  public static getLocalizedYear(milliseconds: number): string {
    DateUtil.checkLocaleAndUpdateFormatInstance();
    return DateUtil.getYearFormat().format(new Date(milliseconds));
  }

  /**
   * 获取上次同步时间
   * @param milliseconds 当前时间的timestamp
   * @returns 用于显示在照片页顶部的上次同步时间字串，如果当前时间和上次同步时间在同一年，不显示年份
   */
  public static getLocalizedSyncTime(milliseconds: number): string {
    DateUtil.checkLocaleAndUpdateFormatInstance();
    let date: string = DateUtil.getLocalizedDate(milliseconds, DateUtil.getLocalizedYear(milliseconds) !== DateUtil.getLocalizedYear(Date.now()));
    let time: string = DateUtil.getLocalizedTime(milliseconds);
    if (!date || !time) {
      return undefined;
    }
    return `${date} ${time}`;
  }

  public static isTimeIntervalOver24Hours(startTimestamp: number, endTimestamp: number): boolean {
    return endTimestamp - startTimestamp >= DateUtil.SECONDS_OF_ONE_DAY * DateUtil.MILLISECONDS_PER_SECOND;
  }

  public static getLocalizedYearAndMonth(milliseconds: number): string {
    DateUtil.checkLocaleAndUpdateFormatInstance();
    return DateUtil.getYearAndMonthFormat().format(new Date(milliseconds));
  }

  public static getLocalizedMonthAndDay(milliseconds: number): string {
    DateUtil.checkLocaleAndUpdateFormatInstance();
    return DateUtil.getMonthAndDayFormat().format(new Date(milliseconds));
  }

  public static getLocalizedDay(milliseconds: number): string {
    DateUtil.checkLocaleAndUpdateFormatInstance();
    return DateUtil.getDayFormat().format(new Date(milliseconds));
  }

  public static getLocalizedMonth(milliseconds: number): string {
    DateUtil.checkLocaleAndUpdateFormatInstance();
    return DateUtil.getMonthFormat().format(new Date(milliseconds));
  }

  public static getLocalizedTime(milliseconds: number): string {
    DateUtil.checkLocaleAndUpdateFormatInstance();
    let is24HourClock = i18n.is24HourClock();
    Log.info(TAG, `get is24HourClock ${is24HourClock}`);
    if (is24HourClock) {
      return DateUtil.getIs24HourTimeFormat().format(new Date(milliseconds));
    } else {
      return DateUtil.getIsNot24HourTimeFormat().format(new Date(milliseconds));
    }
  }

  // Format duration
  public static getFormattedDuration(milliSecond: number): string {
    if (milliSecond == null) {
      Log.error(TAG, 'getFormattedDuration, input is null!');
      return '00:00';
    }
    if (milliSecond <= 0) {
      Log.error(TAG, 'getFormattedDuration, input is negative number!');
      return '00:00';
    }
    if (milliSecond < this.MILLISECONDS_PER_SECOND) {
      return '00:01';
    }
    let seconds = Math.floor(milliSecond / this.MILLISECONDS_PER_SECOND);
    let hourTime: number = Math.floor(seconds / this.SECONDS_PER_HOUR);
    let minuteTime: number = Math.floor(Math.floor(seconds / this.SECONDS_PER_MINUTE) % this.SECONDS_PER_MINUTE);
    let secondTime: number = Math.floor(seconds % this.SECONDS_PER_MINUTE);
    if (hourTime > 0) {
      return `${hourTime}:${this.checkTime(minuteTime)}:${this.checkTime(secondTime)}`;
    } else {
      return `${this.checkTime(minuteTime)}:${this.checkTime(secondTime)}`;
    }
  }

  // Format duration for ScreenReader
  public static getFormattedDurationForScreenReader(milliSecond: number): string {
    if (milliSecond === null) {
      Log.error(TAG, 'getFormattedDuration, input is null!');
      return '00:00:00';
    }
    if (milliSecond <= 0) {
      Log.error(TAG, 'getFormattedDuration, input is negative number!');
      return '00:00:00';
    }
    if (milliSecond < this.MILLISECONDS_PER_SECOND) {
      return '00:00:01';
    }
    let seconds = Math.floor(milliSecond / this.MILLISECONDS_PER_SECOND);
    let hourTime: number = Math.floor(seconds / this.SECONDS_PER_HOUR);
    let minuteTime: number = Math.floor(Math.floor(seconds / this.SECONDS_PER_MINUTE) % this.SECONDS_PER_MINUTE);
    let secondTime: number = Math.floor(seconds % this.SECONDS_PER_MINUTE);
    if (hourTime > 0) {
      return `${hourTime}:${this.checkTime(minuteTime)}:${this.checkTime(secondTime)}`;
    } else {
      return `00:${this.checkTime(minuteTime)}:${this.checkTime(secondTime)}`;
    }
  }

  public static isTheSameDay(startTime: number, endTime: number): boolean {
    if (!Number.isFinite(startTime) || !Number.isFinite(endTime)) {
      return false;
    }
    const startTimeMs = new Date(startTime).setHours(0, 0, 0, 0);
    const endTimeMs = new Date(endTime).setHours(0, 0, 0, 0);
    return startTimeMs === endTimeMs;
  }

  public static isTheSameMonth(startTime: number, endTime: number): boolean {
    if (!Number.isFinite(startTime) || !Number.isFinite(endTime)) {
      return false;
    }
    const startMonth = new Date(startTime).getMonth();
    const endMonth = new Date(endTime).getMonth();
    return startMonth === endMonth;
  }

  public static isTheSameYear(startTime: number, endTime: number): boolean {
    if (!Number.isFinite(startTime) || !Number.isFinite(endTime)) {
      return false;
    }
    const startYear = new Date(startTime).getFullYear();
    const endYear = new Date(endTime).getFullYear();
    return startYear === endYear;
  }

  // Seconds converted to days (Less than 1 day is counted as 1 day)
  public static convertSecondsToDays(seconds: number): number {
    if (seconds % (this.SECONDS_OF_ONE_DAY * 1000) === 0) {
      return seconds / (this.SECONDS_OF_ONE_DAY * 1000);
    } else {
      return parseInt(seconds / (this.SECONDS_OF_ONE_DAY * 1000) + '') + 1;
    }
  }

  public static isEmpty(obj: unknown): boolean {
    return obj === undefined || obj === null;
  }

  private static getLocales(): string {
    return i18n.getSystemLanguage();
  }

  private static checkTime(time: number): string {
    if (time < 0) {
      Log.error(TAG, 'checkTime, input is negative number!');
      return '00';
    }
    let formatTime: string = time.toString();
    if (time < 10) {
      let zeroString = '0';
      formatTime = zeroString.concat(formatTime);
    }
    return formatTime;
  }

  private static checkLocaleAndUpdateFormatInstance(): void {
    if (DateUtil.preLocale === DateUtil.getLocales()) {
      return;
    }
    DateUtil.preLocale = DateUtil.getLocales();
    DateUtil.setDateTimeFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    }));

    DateUtil.setMonthAndDayFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      month: 'long',
      day: 'numeric'
    }));

    DateUtil.setYearAndMonthFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: 'numeric',
      month: 'long'
    }));

    DateUtil.setDayFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      day: 'numeric'
    }));

    DateUtil.setMonthFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      month: 'numeric'
    }));

    DateUtil.setYearFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: 'numeric'
    }));

    DateUtil.setIs24HourTimeFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      hour12: false,
      hour: 'numeric',
      minute: '2-digit'
    }));

    DateUtil.setIsNot24HourTimeFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      hour12: true,
      hour: '2-digit',
      minute: '2-digit'
    }));
    Log.info(TAG, 'checkLocaleAndUpdateFormatInstance done');
  }

  public static formatTimeStampToLocalizedDate(milliseconds: number): string {
    if (DateUtil.isSameDay(milliseconds)) {
      return UiUtil.getResourceStringSync($r('app.string.date_today'));
    }
    if (DateUtil.isSameDay(milliseconds + DateUtil.MILLISECONDS_OF_ONE_DAY)) {
      return UiUtil.getResourceStringSync($r('app.string.date_yesterday'));
    }
    DateUtil.checkLocaleAndUpdateFormatInstance();
    return this.getLocalizedDate(milliseconds);
  }

  public static isSameDay(milliseconds: number): boolean {
    let today = new Date();
    let date = new Date(milliseconds);
    if (date.getFullYear() === today.getFullYear() && date.getMonth() === today.getMonth() &&
      date.getDate() === today.getDate()) {
      return true;
    }
    return false;
  }
}