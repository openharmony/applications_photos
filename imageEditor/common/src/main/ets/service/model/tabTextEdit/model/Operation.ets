/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
import { TextAreaInfo } from './TextAreaInfo';

export class Operation {
  /**
   * -1 涂鸦
   * 0 文本框删除
   * 1 文本框创建
   * 2 文本框移动
   * 3 文本框改变字体大小
   * 4 文本框改变字体颜色
   * 5 输入文字
   * 6 旋转
   * 7 复制
   */
  public operateType: number;
  public operateId: string;
  public previousTextArea: TextAreaInfo | undefined;
  public currentTextArea: TextAreaInfo | undefined;

  constructor(operateType: number, operateId: string,
    previousTextArea: TextAreaInfo | undefined, currentTextArea: TextAreaInfo | undefined) {
    this.operateType = operateType;
    this.operateId = operateId;
    this.previousTextArea = previousTextArea;
    this.currentTextArea = currentTextArea;
  }
}