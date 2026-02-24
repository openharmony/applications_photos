/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

import lazy { Log } from './Log';

const TAG: string = 'Throttle';

/**
 * 节流器，给定最小触发间隔，每次触发时使用#isPassable 判断是否可通过
 */
export class Throttle<T> {
  public readonly interval: number; // 最小触发间隔
  public lastPassTime: number = 0; // 上次通过时间
  private readonly tag: string;
  private timer: number = -1;

  public constructor(interval: number, tag?: string) {
    this.interval = Math.max(interval, 0);
    this.tag = tag ?? TAG;
    if (interval <= 0) {
      Log.warn(this.tag, 'Throttle interval <= 0');
    }
  }

  public isPassable(): boolean {
    let nowTime = new Date().getTime();
    let passTime = nowTime - this.lastPassTime;
    if (passTime < this.interval && passTime > 0) {
      return false;
    }

    this.lastPassTime = nowTime;
    return true;
  }

  /**
   * 每隔this.interval毫秒执行一遍func, 确保最后一次调用run时func能执行
   *
   * @param func 需要限流执行的方法
   */
  public run(func: (param: T) => void, param: T): void {
    if (this.interval <= 0) {
      Log.warn(this.tag, 'interval can not be less than or equal to 0');
      return;
    }
    if (this.isPassable()) {
      func(param);
    } else {
      clearTimeout(this.timer);
      this.timer = setTimeout((): void => {
        this.lastPassTime = new Date().getTime();
        func(param);
      }, this.interval);
    }
  }

  /**
   * 执行任务，如果可以通过，立即执行immediate
   * 如果不能立即执行，延迟interval后执行delayed
   * 如果已经有延迟任务，执行rejected
   * @param msg 日志tag
   * @param immediate 立即执行
   * @param delayed 延迟执行
   * @param rejected 已经有延迟任务，拒绝场景执行
   */
  public execute(immediate: Function, delayed?: Function, rejected?: Function): void {
    if (this.interval <= 0) {
      immediate();
      return;
    }

    if (this.timer > 0) {
      Log.info(this.tag, 'Throttle not passable has pending task');
      rejected?.();
      return;
    }

    if (this.isPassable()) {
      Log.info(this.tag, 'Throttle passable');
      immediate();
      this.lastPassTime = Date.now();
      return;
    }

    Log.info(this.tag, 'Throttle not passable set pending task');
    this.timer = setTimeout((): void => {
      if (delayed) {
        delayed();
      } else {
        immediate();
      }
      Log.info(this.tag, 'Throttle execute delayed');
      this.lastPassTime = Date.now();
      this.timer = 0;
    }, this.interval);
  }
}
