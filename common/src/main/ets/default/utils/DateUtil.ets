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

const TAG: string = 'common_DateUtil';
const YEAR_INDEX: number = 4;
const MONTH_INDEX: number = 6;
const MAX_INDEX: number = 8;

export class DateUtil {
  public static readonly MILLISECONDS_PER_SECOND: number = 1000;
  public static readonly MICROSECONDS_PER_SECOND: number = 1000 * 1000;
  public static readonly NANOSECONDS_PER_SECOND: number = 1000 * 1000 * 1000;
  public static readonly MILLISECONDS_OF_ONE_DAY: number = 24 * 60 * 60 * 1000;
  public static readonly SECONDS_PER_MINUTE: number = 60;
  public static readonly SECONDS_PER_HOUR: number = 3600;
  public static readonly DAYS_OF_THE_WEEK: number = 7;
  public static readonly SECONDS_OF_ONE_DAY: number = 24 * 60 * 60;
  private static preLocale: string = DateUtil.getLocales();
  private static dateTimeFormat: Intl.DateTimeFormat;
  private static monthAndDayFormat: Intl.DateTimeFormat;
  private static yearAndMonthFormat: Intl.DateTimeFormat;
  private static fullTimeFormat: Intl.DateTimeFormat;
  private static dayFormat: Intl.DateTimeFormat;
  private static monthFormat: Intl.DateTimeFormat;
  private static yearFormat: Intl.DateTimeFormat;
  private static is24HourTimeFormat: Intl.DateTimeFormat;
  private static isNot24HourTimeFormat: Intl.DateTimeFormat;

  /* instrument ignore next */
  private static setDateTimeFormat(dateTimeFormat: Intl.DateTimeFormat): void {
    DateUtil.dateTimeFormat = dateTimeFormat;
  }

  /* instrument ignore next */
  private static getCurDateTimeFormat(): Intl.DateTimeFormat {
    if (DateUtil.dateTimeFormat) {
      return DateUtil.dateTimeFormat;
    }
    DateUtil.dateTimeFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
    return DateUtil.dateTimeFormat;
  }

  /* instrument ignore next */
  private static setMonthAndDayFormat(monthAndDayFormat: Intl.DateTimeFormat): void {
    DateUtil.monthAndDayFormat = monthAndDayFormat;
  }

  /* instrument ignore next */
  private static getMonthAndDayFormat(): Intl.DateTimeFormat {
    if (DateUtil.monthAndDayFormat) {
      return DateUtil.monthAndDayFormat;
    }
    DateUtil.monthAndDayFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      month: 'long',
      day: 'numeric',
    });
    return DateUtil.monthAndDayFormat;
  }

  /* instrument ignore next */
  private static setDayFormat(dayFormat: Intl.DateTimeFormat): void {
    DateUtil.dayFormat = dayFormat;
  }

  /* instrument ignore next */
  private static getDayFormat(): Intl.DateTimeFormat {
    if (DateUtil.dayFormat) {
      return DateUtil.dayFormat;
    }
    DateUtil.dayFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      day: 'numeric',
    });
    return DateUtil.dayFormat;
  }

  /* instrument ignore next */
  private static setYearAndMonthFormat(yearAndMonthFormat: Intl.DateTimeFormat): void {
    DateUtil.yearAndMonthFormat = yearAndMonthFormat;
  }

  /* instrument ignore next */
  private static getYearAndMonthFormat(): Intl.DateTimeFormat {
    if (DateUtil.yearAndMonthFormat) {
      return DateUtil.yearAndMonthFormat;
    }
    DateUtil.yearAndMonthFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: 'numeric',
      month: 'long',
    });
    return DateUtil.yearAndMonthFormat;
  }

  /* instrument ignore next */
  private static getDateTimeFormat(): Intl.DateTimeFormat {
    if (DateUtil.fullTimeFormat) {
      return DateUtil.fullTimeFormat;
    }
    DateUtil.fullTimeFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: '2-digit',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
    });
    return DateUtil.fullTimeFormat;
  }

  public static getFullTime(): string {
    return DateUtil.getDateTimeFormat().format(new Date(Date.now()));
  }

  private static get2DigitStr(num: number): string {
    let numStr = num.toString();
    const numStrLen = numStr.length;
    if (numStrLen === 1) {
      numStr = `0${numStr}`;
    } else {
      numStr = numStr.substring(numStrLen - 2, numStrLen);
    }
    return numStr;
  }

  public static getTimeStringInYYMMDD_HHMMSS(): string {
      const curDate = new Date();
      let year = DateUtil.get2DigitStr(curDate.getFullYear());
      let month = DateUtil.get2DigitStr(curDate.getMonth() + 1);
      let date = DateUtil.get2DigitStr(curDate.getDate());
      let hours = DateUtil.get2DigitStr(curDate.getHours());
      let minutes = DateUtil.get2DigitStr(curDate.getMinutes());
      let seconds = DateUtil.get2DigitStr(curDate.getSeconds());
      return `${year}${month}${date}_${hours}${minutes}${seconds}`;
  }

  /* instrument ignore next */
  private static setMonthFormat(monthFormat: Intl.DateTimeFormat): void {
    DateUtil.monthFormat = monthFormat;
  }

  /* instrument ignore next */
  private static getMonthFormat(): Intl.DateTimeFormat {
    if (DateUtil.monthFormat) {
      return DateUtil.monthFormat;
    }
    DateUtil.monthFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      month: 'numeric',
    });
    return DateUtil.monthFormat;
  }

  /* instrument ignore next */
  private static setYearFormat(yearFormat: Intl.DateTimeFormat): void {
    DateUtil.yearFormat = yearFormat;
  }

  /* instrument ignore next */
  private static getYearFormat(): Intl.DateTimeFormat {
    if (DateUtil.yearFormat) {
      return DateUtil.yearFormat;
    }
    DateUtil.yearFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: 'numeric',
    });
    return DateUtil.yearFormat;
  }

  /* instrument ignore next */
  private static setIs24HourTimeFormat(is24HourTimeFormat: Intl.DateTimeFormat): void {
    DateUtil.is24HourTimeFormat = is24HourTimeFormat;
  }

  /* instrument ignore next */
  private static getIs24HourTimeFormat(): Intl.DateTimeFormat {
    if (DateUtil.is24HourTimeFormat) {
      return DateUtil.is24HourTimeFormat;
    }
    DateUtil.is24HourTimeFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      hour12: false,
      hour: 'numeric',
      minute: '2-digit',
    });
    return DateUtil.is24HourTimeFormat;
  }

  /* instrument ignore next */
  private static setIsNot24HourTimeFormat(isNot24HourTimeFormat: Intl.DateTimeFormat): void {
    DateUtil.isNot24HourTimeFormat = isNot24HourTimeFormat;
  }

  /* instrument ignore next */
  private static getIsNot24HourTimeFormat(): Intl.DateTimeFormat {
    if (DateUtil.isNot24HourTimeFormat) {
      return DateUtil.isNot24HourTimeFormat;
    }
    DateUtil.isNot24HourTimeFormat = new Intl.DateTimeFormat(DateUtil.preLocale, {
      hour12: true,
      hour: '2-digit',
      minute: '2-digit',
    });
    return DateUtil.isNot24HourTimeFormat;
  }

  // Get the date after localization (year-month-day)
  public static getLocalizedDate(milliseconds: number | undefined, containYear: boolean = true): string {
    /* instrument ignore if */
    if (milliseconds === undefined) {
      return DateUtil.getCurDateTimeFormat().format(new Date());
    }
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

    const opts: Readonly<Map<string, number>> = new Map([
      ['MM', time.getMonth() + 1],
      ['dd', time.getDate()],
      ['HH', time.getHours()],
      ['mm', time.getMinutes()],
      ['ss', time.getSeconds()],
    ]);

    if (/(y+)/.test(formatStr)) {
      formatStr = formatStr.replace('yyyy', time.getFullYear().toString().substr(0));
    }
    for (const f of opts.keys()) { // <-- iterate DateUtil way
      if (new RegExp(`(${f}` + ')').test(formatStr)) {
        const v = opts.get(f) ?? '';
        formatStr = formatStr.replace(f, (f.length === 1) ? v.toString() : ((`00${v}`).substr(
          v.toString().length)));
      }
    }
    return formatStr;
  }

  // Gets the localization date of the photo page grouping data
  // instrument ignore next
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
    return $r('app.string.common_place_holder', DateUtil.getLocalizedDate(milliseconds));
  }

  /* instrument ignore next */
  public static getLocalizedYearResource(milliseconds: number): Resource {
    let locales: string = DateUtil.getLocales();
    let yearText = new Intl.DateTimeFormat(locales, {
      year: 'numeric',
    }).format(new Date(milliseconds));
    return $r('app.string.common_place_holder', yearText.toString());
  }

  public static getLocalizedYearString(milliseconds: number): string {
    let locales: string = DateUtil.getLocales();
    let yearText = new Intl.DateTimeFormat(locales, {
      year: 'numeric',
    }).format(new Date(milliseconds));
    Log.info(TAG, `getLocalizedYearString:${milliseconds} ${yearText.toString()}`);
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
    let date: string = DateUtil.getLocalizedDate(milliseconds, DateUtil.getLocalizedYear(milliseconds) !==
    DateUtil.getLocalizedYear(Date.now()));
    let time: string = DateUtil.getLocalizedTime(milliseconds);
    /* instrument ignore if */
    if (!date || !time) {
      return '';
    }
    return `${date} ${time}`;
  }

  //同步时间
  public static getLocalSyncTime(milliseconds: number): string {
    DateUtil.checkLocaleAndUpdateFormatInstance();
    let time: string = DateUtil.getLocalizedTime(milliseconds);
    /* instrument ignore if */
    if (!time) {
      return '';
    }
    return `${time}`;
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

  public static getLocalizedTime(milliseconds: number | undefined): string {
    if (milliseconds === undefined) {
      return DateUtil.getIs24HourTimeFormat().format(new Date());
    }
    DateUtil.checkLocaleAndUpdateFormatInstance();
    let is24HourClock = i18n.is24HourClock();
    Log.debug(TAG, `get is24HourClock ${is24HourClock}`);
    if (is24HourClock) {
      return DateUtil.getIs24HourTimeFormat().format(new Date(milliseconds));
    } else {
      return DateUtil.getIsNot24HourTimeFormat().format(new Date(milliseconds));
    }
  }

  // Format duration
  public static getFormattedDuration(milliSecond: number): string {
    if (Number.isNaN(milliSecond) || milliSecond <= 0) {
      Log.error(TAG, `getFormattedDuration, input is invalid: ${milliSecond}`);
      return '00:00';
    }
    if (milliSecond < DateUtil.MILLISECONDS_PER_SECOND) {
      return '00:01';
    }
    let seconds = Math.floor(milliSecond / DateUtil.MILLISECONDS_PER_SECOND);
    let hourTime: number = Math.floor(seconds / DateUtil.SECONDS_PER_HOUR);
    let minuteTime: number =
      Math.floor(Math.floor(seconds / DateUtil.SECONDS_PER_MINUTE) % DateUtil.SECONDS_PER_MINUTE);
    let secondTime: number = Math.floor(seconds % DateUtil.SECONDS_PER_MINUTE);
    if (hourTime > 0) {
      return `${hourTime}:${DateUtil.checkTime(minuteTime)}:${DateUtil.checkTime(secondTime)}`;
    } else {
      return `${DateUtil.checkTime(minuteTime)}:${DateUtil.checkTime(secondTime)}`;
    }
  }

  // Format duration for ScreenReader
  public static getFormattedDurationForScreenReader(milliSecond: number): string {
    /* instrument ignore if */
    if (milliSecond === null) {
      Log.error(TAG, 'getFormattedDuration, input is null!');
      return '00:00:00';
    }
    if (milliSecond <= 0) {
      Log.error(TAG, 'getFormattedDuration, input is negative number!');
      return '00:00:00';
    }
    if (milliSecond < DateUtil.MILLISECONDS_PER_SECOND) {
      return '00:00:01';
    }
    let seconds = Math.floor(milliSecond / DateUtil.MILLISECONDS_PER_SECOND);
    let hourTime: number = Math.floor(seconds / DateUtil.SECONDS_PER_HOUR);
    let minuteTime: number = Math.floor(Math.floor(seconds /
    DateUtil.SECONDS_PER_MINUTE) % DateUtil.SECONDS_PER_MINUTE);
    let secondTime: number = Math.floor(seconds % DateUtil.SECONDS_PER_MINUTE);
    if (hourTime > 0) {
      return `${hourTime}:${DateUtil.checkTime(minuteTime)}:${DateUtil.checkTime(secondTime)}`;
    } else {
      return `00:${DateUtil.checkTime(minuteTime)}:${DateUtil.checkTime(secondTime)}`;
    }
  }

  public static isTheSameDay(startTime: number, endTime: number): boolean {
    /* instrument ignore if */
    if (!Number.isFinite(startTime) || !Number.isFinite(endTime)) {
      return false;
    }
    const startTimeMs = new Date(startTime).setHours(0, 0, 0, 0);
    const endTimeMs = new Date(endTime).setHours(0, 0, 0, 0);
    return startTimeMs === endTimeMs;
  }

  /**
   * 判断时间戳和日期是同一天
   * @param startTime 时间戳
   * @param endTime ‘yyyyMMdd’格式字符串
   * @returns
   */
  public static isTheSameDayInGroup(startTime: number, endTime: string): boolean {
    /* instrument ignore if */
    if (!Number.isFinite(startTime) || endTime.length !== 8) {
      return false;
    }
    const startDate: Date = new Date(startTime);
    const year = String(startDate.getFullYear()); // 获取年份
    const month = String(startDate.getMonth() + 1).padStart(2, '0'); // 获取月份，并补零
    const day = String(startDate.getDate()).padStart(2, '0');
    return `${year}${month}${day}` === endTime;
  }

  public static isTheSameMonth(startTime: number, endTime: number): boolean {
    /* instrument ignore if */
    if (!Number.isFinite(startTime) || !Number.isFinite(endTime)) {
      return false;
    }
    const startMonth = new Date(startTime).getMonth();
    const endMonth = new Date(endTime).getMonth();
    return startMonth === endMonth;
  }

  public static isTheSameYear(startTime: number, endTime: number): boolean {
    /* instrument ignore if */
    if (!Number.isFinite(startTime) || !Number.isFinite(endTime)) {
      return false;
    }
    const startYear = new Date(startTime).getFullYear();
    const endYear = new Date(endTime).getFullYear();
    return startYear === endYear;
  }

  // Seconds converted to days (Less than 1 day is counted as 1 day)
  public static convertSecondsToDays(seconds: number): number {
    if (seconds % (DateUtil.SECONDS_OF_ONE_DAY * 1000) === 0) {
      return seconds / (DateUtil.SECONDS_OF_ONE_DAY * 1000);
    } else {
      return parseInt(seconds / (DateUtil.SECONDS_OF_ONE_DAY * 1000) + '') + 1;
    }
  }

  private static getLocales(): string {
    return i18n.System.getSystemLanguage();
  }

  private static checkTime(time: number): string {
    /* instrument ignore if */
    if (time < 0) {
      Log.error(TAG, 'checkTime, input is negative number!');
      return '00';
    }
    let formatTime: string = time.toString();
    /* instrument ignore if */
    if (time < 10) {
      let zeroString = '0';
      formatTime = zeroString.concat(formatTime);
    }
    return formatTime;
  }

  /* instrument ignore next */
  private static checkLocaleAndUpdateFormatInstance(): void {
    if (DateUtil.preLocale === DateUtil.getLocales()) {
      return;
    }
    DateUtil.preLocale = DateUtil.getLocales();
    DateUtil.setDateTimeFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    }));

    DateUtil.setMonthAndDayFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      month: 'long',
      day: 'numeric',
    }));

    DateUtil.setYearAndMonthFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: 'numeric',
      month: 'long',
    }));

    DateUtil.setDayFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      day: 'numeric',
    }));

    DateUtil.setMonthFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      month: 'numeric',
    }));

    DateUtil.setYearFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      year: 'numeric',
    }));

    DateUtil.setIs24HourTimeFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      hour12: false,
      hour: 'numeric',
      minute: '2-digit',
    }));

    DateUtil.setIsNot24HourTimeFormat(new Intl.DateTimeFormat(DateUtil.preLocale, {
      hour12: true,
      hour: '2-digit',
      minute: '2-digit',
    }));
    Log.info(TAG, 'checkLocaleAndUpdateFormatInstance done');
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

  // 从20250123格式化时间中按长度截取年月日时间
  public static parseDateDayString(dateString: string): number {
    if (dateString?.length === MAX_INDEX) {
      let year: number = parseInt(dateString?.substring(0, YEAR_INDEX));
      let month: number = parseInt(dateString?.substring(YEAR_INDEX, MONTH_INDEX));
      let day: number = parseInt(dateString?.substring(MONTH_INDEX));
      let timestamp: number = new Date(year, month - 1, day).getTime();
      Log.info(TAG, `parseDateDayString dateDay:${dateString} timestamp:${timestamp} ` +
        `year:${year} month:${month} day:${day}`);
      return timestamp;
    }
    return -1;
  }

  /**
   * DetailTime转换时间戳
   * @param time 时间
   * @returns 时间戳
   */
  public static convertDateToTimestamp(time: string): number {
    if (!time || time === '0' || time === '') {
      return 0;
    }
    let timeSplitArr = time.split(' ');
    if (timeSplitArr.length < 2) {
      return 0;
    }
    let photoDate = timeSplitArr[0];
    let photoTime = timeSplitArr[1];
    photoDate = photoDate.replace(/:/g, '-');
    let timestamp = photoDate + ' ' + photoTime;
    Log.debug(TAG, `new time is ${timestamp}`);
    return Date.parse(timestamp);
  }

}