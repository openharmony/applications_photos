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
 * Copyright (c) Huawei Technologies Co., Ltd. 2021-2022. All rights reserved.
 * Description: 自动生成的ts常量文件
 * update: 2022/9/9 14:18:21
 **/

export enum ASSET {
  CLOUD_ID = 'cloud_id', // 素材云端ID
  LANE = 'asset_lane', // 剪辑所在轨道的ID.
  MATERIAL_CLOUD_ID = 'material_cloud_id', // 原始素材的云端ID.
  PATH = 'asset_path', // 素材路径.
  PATH_TYPE = 'asset_path_type', // 素材路径类型.
  ENABLE = 'asset_enable', // 剪辑是否处于有效状态.
  END = 'end_time', // 剪辑结束时间.
  PURE_DURATION = 'pure_duration', // 剪辑纯时长（原视素材的时长）.
  TRIM_IN = 'trim_in', // 剪辑的trim in.
  VISIBLE = 'is_visibility', // 剪辑是否可见.
  WIDTH = 'width', // 可视剪辑的宽度.
  TRANS_OFFSET_X = 'trans_offsetX', // 可视剪辑的坐标变换的X坐标的偏移.
  TRANS_ROTATIONX = 'trans_rotationX', // 可视剪辑的旋转角度.
  TRANS_ROTATIONZ = 'trans_rotationZ', // 可视剪辑的旋转角度.
  STICKER_INDEX = 'sticker_index', // 贴纸序号.
  TRANS_SCALE_X = 'trans_scaleX', // 可视剪辑的缩放比例, 由用户设置.
  TRANS_RATIO_X = 'trans_ratioX', // 可视剪辑的缩放比例, 由画布调整得到.
  MIRROR_HORIZONTAL = 'mirror_horizontal', // 水平镜像.
  TRANS_OPACITY = 'trans_opacity', // 不透明度
  EFFECT = 'effect', // 剪辑效果列表.
  TEXTBOX = 'text_box', // 文本框.
}

export enum PROJECT_COVER {
  TYPE = 'cover_type', // 封面类型.
}

export enum ADJUST {
  HUE = 'hue', // int: 色相(范围：0~100，默认值：0).
  SATURATION = 'saturation', // int: 饱和度(范围：-100~100，默认值：0).
  BRIGHTNESS = 'brightness', // int: 亮度(范围：-100~100，默认值：0).
  CONTRAST = 'contrast', // int: 对比对(范围：-100~100，默认值：0).
  TEMPERATURE = 'temperature', // int: 色温(范围：-100~100，默认值：0).
  SHARPNESS = 'sharpness', // int: 锐度(范围：0~100，默认值：0).
  FADE = 'fade', // int: 褪色(范围：0~100，默认值：0).
  EXPOSURE = 'exposure', // int: 曝光(范围：0~100，默认值：0).
  GRAIN = 'grain', // int: 颗粒(范围：-100~100，默认值：0).
  HIGHLIGHT = 'highlight', // int: 高光(范围：-100~100，默认值：0).
  SHADOW = 'shadow', // int: 阴影(范围：0~100，默认值：0).
  VIGNETTE = 'vignette', // int: 暗角(范围：0~100，默认值：0).
}

export enum CROP {
  DEFAULT_NAME = '剪辑裁剪', // string: 裁剪效果的默认名称.
  LEFTBOTTOM_Y = 'leftbottom_y', // FLOAT: 裁剪框的左下顶点位置的纵坐标（Y）.
  RIGHTBOTTOM_Y = 'rightbottom_y', // FLOAT: 裁剪框的右下顶点位置的纵坐标（Y）.
  LEFTTOP_Y = 'lefttop_y', // FLOAT: 裁剪框的左上顶点位置的纵坐标（Y）.
  RIGHTTOP_Y = 'righttop_y', // FLOAT: 裁剪框的右上顶点位置的纵坐标（Y）.
}