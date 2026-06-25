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

/**
 * 手机图库大图浏览大图图片质量分数打点相关常量
 */
export class PictureQualityConstants {
  // PhotoPicker 打开大图
  public static IS_THIRD_PICKER: string = 'isThirdPicker';
  // 图片编辑保存后返回大图浏览
  public static IS_EDIT_SAVE: string = 'isEditSave';
  // 手机图库大图浏览大图图片质量分数打点点位事件名
  public static PICTURE_QUALITY: string = 'PICTURE_QUALITY';
  // 打点上报图片质量分数：100分（0）
  public static PICTURE_QUALITY_HUNDRED_SCORE: number = 0;
  // 打点上报图片质量分数：80分（1）
  public static PICTURE_QUALITY_EIGHTY_SCORE: number = 1;
}