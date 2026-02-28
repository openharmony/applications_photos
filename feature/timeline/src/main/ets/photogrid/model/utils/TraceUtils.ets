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

import lazy hiTraceMeter from '@ohos.hiTraceMeter';
import lazy { FormIndex } from '../../statemanager/constants/GridDefine';

// 宫格形态ID头
const GRID_FORM_TASK_ID_HEAD: number = 100000;

/**
 * Trace任务名
 */
export enum TraceTaskType {
  /**
   * 开始标记（放在第一个，误删）
   */
  START,

  /**
   * 宫格滚动
   */
  GRID_SCROLL,

  /**
   * 每帧开始滚动
   */
  SCROLL_FRAME_BEGIN,

  /**
   * 即将滑动
   */
  WILL_SCROLL,

  /**
   * 滚动条更新
   */
  SCROLL_BAR_UPDATE,

  /**
   * 滑动索引变更
   */
  SCROLL_INDEX,

  /**
   * 宫格切换
   */
  GRID_SWITCH,

  /**
   * 数据更新
   */
  DATA_UPDATE,

  /**
   * 数据加载完成
   */
  DATA_LOAD_FINISH,

  /**
   * 分组数据刷新
   */
  GROUP_INFO_UPDATE,

  /**
   * 主页面初始化
   */
  PHOTO_GRID_INIT,

  /**
   * 预览视图加载结束
   */
  PREVIEW_GRID_LOAD_FINISH,

  /**
   * 预览视图存活
   */
  PREVIEW_GRID_LIVE,

  /**
   * 视图初始化
   */
  GRID_INIT,

  /**
   * 宫格延时加载
   */
  GRID_DELAY_LOAD,

  /**
   * 结束标记（放在最后一个，误删）
   */
  END,
}

/**
 * Trace任务
 */
class TaskTask {
  /**
   * 任务名称
   */
  public readonly name: string;

  /**
   * 任务ID
   */
  public readonly id: number;

  public constructor(name: string, id: number) {
    this.name = name;
    this.id = id;
  }

  /**
   * 获取任务名
   *
   * @param formIndex 宫格形态
   * @returns 组装后的任务名
   */
  public getTaskName(formIndex?: FormIndex): string {
    if (formIndex === undefined || FormIndex[formIndex] === undefined) {
      return this.name;
    }
    return `${FormIndex[formIndex]}_${this.name}`;
  }

  /**
   * 获取任务名
   *
   * @param formIndex 宫格形态
   * @returns 组装后的任务名
   */
  public getTaskId(formIndex?: FormIndex): number {
    if (formIndex === undefined || FormIndex[formIndex] === undefined) {
      return this.id;
    }
    return (formIndex + 1) * GRID_FORM_TASK_ID_HEAD + this.id;
  }
}

/**
 * Trace任务表
 */
const TRACE_TASK_MAP: Map<TraceTaskType, TaskTask> = new Map(new Array(TraceTaskType.END - 1).fill(0).map(
  (_: number, index: number) => [index + 1, new TaskTask(TraceTaskType[index + 1], index + 1)]));

/**
 * 性能打点工具
 */
export class TraceUtils {
  /**
   * 标记任务开始
   *
   * @param taskType 任务类型
   * @param formIndex 宫格形态
   */
  public static startTrace(taskType: TraceTaskType, formIndex?: FormIndex): void {
    const trackTask = TRACE_TASK_MAP.get(taskType);
    if (!trackTask) {
      return;
    }
    hiTraceMeter.startTrace(trackTask.getTaskName(formIndex), trackTask.getTaskId(formIndex));
  }

  /**
   * 标记任务结束
   *
   * @param taskType 任务类型
   * @param formIndex 宫格形态
   */
  public static finishTrace(taskType: TraceTaskType, formIndex?: FormIndex): void {
    const trackTask = TRACE_TASK_MAP.get(taskType);
    if (!trackTask) {
      return;
    }
    hiTraceMeter.finishTrace(trackTask.getTaskName(formIndex), trackTask.getTaskId(formIndex));
  }
}