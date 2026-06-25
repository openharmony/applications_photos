/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
 */

import lazy { MediaItem } from '../model/browser/photo/MediaItem';

/**
 * 大图控制器基础接口能力定义
 */
export interface BrowserControlInterface {
  /**
   * 获取当前查看的图片
   *
   * @returns 当前图片数据对象
   */
  getCurrentPhoto(): MediaItem | undefined;
}
