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
#ifndef HMCDICTKEY_H
#define HMCDICTKEY_H

/* 缩略图获取的属性 */
#define DICT_KEY_THUMBNAIL_TIMESTAMP "timestamp" // 时间戳.
#define DICT_KEY_THUMBNAIL_LANE_ID "lane_uid"    // 轨道ID.
#define DICT_KEY_THUMBNAIL_ASSET_ID "asset_uid"  // 剪辑ID.
#define DICT_KEY_THUMBNAIL_THUMBNAIL "thumbnail" // 缩略图指针.

/* 滤镜缩略图属性 */
#define DICT_KEY_THUMBNAIL_FILTER_ID "filter_id"            // 滤镜ID.
#define DICT_KEY_THUMBNAIL_FILTER_RESULT "filter_thumbnail" // 滤镜缩略图.

/* LCD缩略图属性 */
#define DICT_KEY_THUMBNAIL_LCD_REMOTE "lcd_remote"                // LCD图 是否在云端. 1:本地  2：云端
#define DICT_KEY_THUMBNAIL_LCD_PIXELMAP "lcd_pix"                 //LCD图 pixelMap.

/* 工程文件中保存剪辑(asset)的属性 */
#define DICT_KEY_ASSET_PROPERTY_CLOUD_ID "cloud_id"               // 素材云端ID
#define DICT_KEY_ASSET_PROPERTY_UID "asset_uid"                   // 剪辑ID.
#define DICT_KEY_ASSET_PROPERTY_LANE "asset_lane"                 // 剪辑所在轨道的ID.
#define DICT_KEY_ASSET_PROPERTY_MATERIAL_UID "material_uid"       // 原始素材的UID.
#define DICT_KEY_ASSET_PROPERTY_NAME "asset_name"                 // 素材名.
#define DICT_KEY_ASSET_PROPERTY_PATH "asset_path"                 // 素材路径.
#define DICT_KEY_ASSET_PROPERTY_SIZE "file_size"                  // 素材大小.
#define DICT_KEY_ASSET_PROPERTY_PATH_TYPE "asset_path_type"       // 素材路径类型.
#define DICT_KEY_ASSET_PROPERTY_ENABLE "asset_enable"             // 剪辑是否处于有效状态.
#define DICT_KEY_ASSET_PROPERTY_START "start_time"                // 剪辑起始时间.
#define DICT_KEY_ASSET_PROPERTY_END "end_time"                    // 剪辑结束时间.
#define DICT_KEY_ASSET_PROPERTY_DURATION "duration"               // 剪辑时长.
#define DICT_KEY_ASSET_PROPERTY_PURE_DURATION "pure_duration"     // 剪辑纯时长（原视素材的时长）.
#define DICT_KEY_ASSET_PROPERTY_SPEED "speed"                     // 剪辑速率.
#define DICT_KEY_ASSET_PROPERTY_TRIM_IN "trim_in"                 // 剪辑的trim in.
#define DICT_KEY_ASSET_PROPERTY_TRIM_OUT "trim_out"               // 剪辑的trim out.
#define DICT_KEY_ASSET_PROPERTY_VISIBLE "is_visibility"           // 剪辑是否可见.
#define DICT_KEY_ASSET_PROPERTY_BACKWARD "is_backward"            // 剪辑是否倒放.
#define DICT_KEY_ASSET_PROPERTY_WIDTH "width"                     // 可视剪辑的宽度.
#define DICT_KEY_ASSET_PROPERTY_HEIGHT "height"                   // 可视剪辑的高度.
#define DICT_KEY_ASSET_PROPERTY_TRANS_OFFSET_X "trans_offsetX"    // 可视剪辑的坐标变换的X坐标的偏移.
#define DICT_KEY_ASSET_PROPERTY_TRANS_OFFSET_Y "trans_offsetY"    // 可视剪辑的坐标变换的Y坐标的偏移.
#define DICT_KEY_ASSET_PROPERTY_TRANS_ROTATIONX "trans_rotationX" // 可视剪辑的旋转角度.
#define DICT_KEY_ASSET_PROPERTY_TRANS_ROTATIONY "trans_rotationY" // 可视剪辑的旋转角度.
#define DICT_KEY_ASSET_PROPERTY_TRANS_ROTATIONZ "trans_rotationZ" // 可视剪辑的旋转角度.
#define DICT_KEY_ASSET_PROPERTY_TRANS_SCALE "trans_scale"         // 可视剪辑的缩放比例.
#define DICT_KEY_ASSET_PROPERTY_TRANS_SCALE_X "trans_scaleX"      // 可视剪辑的缩放比例, 由用户设置.
#define DICT_KEY_ASSET_PROPERTY_TRANS_SCALE_Y "trans_scaleY"      // 可视剪辑的缩放比例, 由用户设置.
#define DICT_KEY_ASSET_PROPERTY_TRANS_RATIO_X "trans_ratioX"      // 可视剪辑的缩放比例, 由画布调整得到.
#define DICT_KEY_ASSET_PROPERTY_TRANS_RATIO_Y "trans_ratioY"      // 可视剪辑的缩放比例, 由画布调整得到.
#define DICT_KEY_ASSET_PROPERTY_MIRROR_HORIZONTAL "mirror_horizontal" // 水平镜像.
#define DICT_KEY_ASSET_PROPERTY_MIRROR_VERTICAL "mirror_vertical"     // 垂直镜像.
#define DICT_KEY_ASSET_PROPERTY_TRANS_OPACITY "trans_opacity"         // 不透明度
#define DICT_KEY_ASSET_PROPERTY_BLEND_MODE "blend_mode"               // INT32: 混合模式.
#define DICT_KEY_ASSET_PROPERTY_EFFECT "effect"                       // 剪辑效果列表.
#define DICT_KEY_ASSET_PROPERTY_EDIT_DATA "edit_data"                       // 编辑数据.
#define DICT_KEY_ASSET_PROPERTY_IS_MEDIA_SOURCE "is_media_source"     // 是否媒体库效果图
#define DICT_KEY_ASSET_PROPERTY_IS_SUPPORT_WATERMARK "is_support_watermark"     // 是否支持水印编辑
#define DICT_KEY_ASSET_PROPERTY_IS_CAMERA_EDIT_DATA "is_camera_editdata"     // 是否相机编辑数据/未经过编辑
#define DICT_KEY_ASSET_PROPERTY_IS_FRONT_CAMERA "cameraPosition"     // 是否前置相机拍摄
#define DICT_KEY_ASSET_PROPERTY_SOURCE_XT_STYLE_INDEX "sourceXtStyleIndex"     // 原图的XXX滤镜index
#define DICT_KEY_ASSET_PROPERTY_SOURCE_XMAGE_COLOR_MODE "sourceXmageColorMode"     // 原图的xmageColorMode
#define PROJECT_KEY_WATERMARK_FILTER_NATIONAL_2025 "NationalDay2025"
#define PROJECT_KEY_WATERMARK_FILTER_SPRING_FESTIVAL "SpringFestival"

/* table-effect-property: 通用效果属性 */
#define DICT_KEY_EFFECT_NAME \
    "name" // STRING: 效果的名字;只用于HmcEffectAdd创建效果dict，效果创建好之后如需改名则调用HmcEffectRename接口.
#define DICT_KEY_EFFECT_MATERIAL_UID \
    "material_id" // HmcUid:
                  // 效果的原始素材id.只用于HmcEffectAdd；创建非内建效果时需要将这个ID值放在dict里，创建好之后不允许修改；内建效果不用填.
#define DICT_KEY_EFFECT_MATERIAL_CLOUD_ID \
    "material_cloud_id" // cloudid:
                        // 效果的原始素材id.只用于HmcEffectAdd；创建非内建效果时需要将这个ID值放在dict里，创建好之后不允许修改；内建效果不用填.
#define DICT_KEY_EFFECT_TYPE \
    "type" // HmcEffectType: 效果的类型.只用于HmcEffectAdd；创建效果需要放在dict里；创建好之后不允许修改.
#define DICT_KEY_EFFECT_ENABLE "enable" // BOOL: 效果是否启用，该KEY只作用于HmcEffectGetProperty接口和序列化反序列化.
#define DICT_KEY_EFFECT_INDEX \
    "index" // INT32:
            // 效果在当前asset中的序号；只作用于创建效果时，创建效果dict中如果不带这个index，或者dict中index小于0或者大于effect数，则默认添加在effect列表的最后，否则添加在index.
#define DICT_KEY_EFFECT_START_TIME \
    "start_time" // INT64: 效果的起始时间，使用asset的相对时间；创建特效带这个值，则用这个值，如果不带则使用默认值0
#define DICT_KEY_EFFECT_DURATION "duration" // INT64: 效果的持续时长（end_time = start_time + duration +
                                            // 1）；创建特效带这个值，则用这个值，如果不带则使用该类效果的默认时长
#define DICT_KEY_EFFECT_UID "effect_uid" // HmcUid: 效果的id

/* table-effect-adjust-property: 颜色调节的参数 */
#define DICT_KEY_ADJUST_AUTO "auto"               // int: 一键调节(范围：-100~100，默认值：ai生成).
#define DICT_KEY_ADJUST_AUTO_ENABLE "auto_enable" // int:  0为关，1为开.
#define DICT_KEY_ADJUST_HUE "hue"                 // int: 色相(范围：-100~100，默认值：0).
#define DICT_KEY_ADJUST_HUE_ENABLE "hue_enable"   // int： 0为关，1为开.
#define DICT_KEY_ADJUST_SATURATION "saturation"   // int: 饱和度(范围：-100~100，默认值：0).
#define DICT_KEY_ADJUST_SATURATION_ENABLE "saturation_enable"   // int： 0为关，1为开.
#define DICT_KEY_ADJUST_BRIGHTNESS "brightness"                 // int: 亮度(范围：-100~100，默认值：0).
#define DICT_KEY_ADJUST_BRIGHTNESS_ENABLE "brightness_enable"   // int： 0为关，1为开.
#define DICT_KEY_ADJUST_CONTRAST "contrast"                     // int: 对比对(范围：-100~100，默认值：0).
#define DICT_KEY_ADJUST_CONTRAST_ENABLE "contrast_enable"       // int： 0为关，1为开.
#define DICT_KEY_ADJUST_TEMPERATURE "temperature"               // int: 色温(范围：-100~100，默认值：0).
#define DICT_KEY_ADJUST_TEMPERATURE_ENABLE "temperature_enable" // int： 0为关，1为开.
#define DICT_KEY_ADJUST_SHARPNESS "sharpness"                   // int: 锐度(范围：0~100，默认值：0).
#define DICT_KEY_ADJUST_SHARPNESS_ENABLE "sharpness_enable"     // int： 0为关，1为开.
#define DICT_KEY_ADJUST_FADE "fade"                             // int: 褪色(范围：0~100，默认值：0).
#define DICT_KEY_ADJUST_FADE_ENABLE "fade_enable"               // int： 0为关，1为开.
#define DICT_KEY_ADJUST_EXPOSURE "exposure"                     // int: 曝光(范围：-100~100，默认值：0).
#define DICT_KEY_ADJUST_EXPOSURE_ENABLE "exposure_enable"       // int： 0为关，1为开.
#define DICT_KEY_ADJUST_GRAIN "grain"                           // int: 颗粒(范围：0~100，默认值：0).
#define DICT_KEY_ADJUST_GRAIN_ENABLE "grain_enable"             // int： 0为关，1为开.
#define DICT_KEY_ADJUST_HIGHLIGHT "highlight"                   // int: 高光(范围：-100~100，默认值：0).
#define DICT_KEY_ADJUST_HIGHLIGHT_ENABLE "highlight_enable"     // int： 0为关，1为开.
#define DICT_KEY_ADJUST_SHADOW "shadow"                         // int: 阴影(范围：-100~100，默认值：0).
#define DICT_KEY_ADJUST_SHADOW_ENABLE "shadow_enable"           // int：0为关，1为开.
#define DICT_KEY_ADJUST_VIGNETTE "vignette"                     // int: 暗角(范围：-100~100，默认值：0).
#define DICT_KEY_ADJUST_VIGNETTE_ENABLE "vignette_enable"       // int： 0为关，1为开.
#define DICT_KEY_ADJUST_VIBRANCE "vibrance"                   // int: 自然饱和度(范围：-100~100，默认值：0)
#define DICT_KEY_ADJUST_VIBRANCE_ENABLE "vibrance_enable"     // int: 0为关，1为开.
#define DICT_KEY_ADJUST_BRIGHTZONE "brightzone"               // int: 亮部(范围：-100~100，默认值：0)
#define DICT_KEY_ADJUST_BRIGHTZONE_ENABLE "brightzone_enable" // int: 0为关，1为开.
#define DICT_KEY_ADJUST_DARKZONE "darkzone"                   // int: 暗部(范围：-100~100，默认值：0)
#define DICT_KEY_ADJUST_DARKZONE_ENABLE "darkzone_enable"     // int: 0为关，1为开.

/* table-effect-filter-property: 滤镜的参数 */

#define DICT_KEY_FILTER_NONE "000000000000000000"       // 原图
#define DICT_KEY_FILTER_CLASSIC "Classic"               // 经典
#define DICT_KEY_FILTER_MOODY "Moody"                   // 灰调
#define DICT_KEY_FILTER_NATURAL "Natural"               // 自然
#define DICT_KEY_FILTER_BLOSSOM "Blossom"               // 森系
#define DICT_KEY_FILTER_FAIR "Fair"                     // 白皙
#define DICT_KEY_FILTER_PINK "Pink"                     // 粉调
#define DICT_KEY_FILTER_HAZE_REMOVAL "Haze_Removal"     // 除雾
#define DICT_KEY_FILTER_FACE_BEAUTY "Beauty"            // 美肤

/* table-effect-transform-property: 形变效果的参数 */
#define DICT_KEY_TRANSFORM_NAME "transform"         // string: 形变效果的默认名称.
#define DICT_KEY_CROP_LEFTBOTTOM_X "leftbottom_x"   // FLOAT: 裁剪框的左下顶点位置的横坐标（X）.
#define DICT_KEY_CROP_LEFTBOTTOM_Y "leftbottom_y"   // FLOAT: 裁剪框的左下顶点位置的纵坐标（Y）.
#define DICT_KEY_CROP_RIGHTBOTTOM_X "rightbottom_x" // FLOAT: 裁剪框的右下顶点位置的横坐标（X）.
#define DICT_KEY_CROP_RIGHTBOTTOM_Y "rightbottom_y" // FLOAT: 裁剪框的右下顶点位置的纵坐标（Y）.
#define DICT_KEY_CROP_LEFTTOP_X "lefttop_x"         // FLOAT: 裁剪框的左上顶点位置的横坐标（X）.
#define DICT_KEY_CROP_LEFTTOP_Y "lefttop_y"         // FLOAT: 裁剪框的左上顶点位置的纵坐标（Y）.
#define DICT_KEY_CROP_RIGHTTOP_X "righttop_x"       // FLOAT: 裁剪框的右上顶点位置的横坐标（X）.
#define DICT_KEY_CROP_RIGHTTOP_Y "righttop_y"       // FLOAT: 裁剪框的右上顶点位置的纵坐标（Y）.
#define DICT_KEY_CROP_BLUR_OPACITY "blur_opacity"   // FLOAT: 裁剪框区域外不透明度

/* table-effect-filter-property: 滤镜的参数 */
#define DICT_KEY_FILTER_STRENGTH "strength" // float: 滤镜的强度（0-1）


/* 工程文件中保存轨道(lane)的属性 */
#define DICT_KEY_LANE "lane"                   // 轨道
#define DICT_KEY_LANE_SIZE "lane_size"         // 轨道大小
#define DICT_KEY_LANE_TYPE "lane_type"         // 轨道类型
#define DICT_KEY_LANE_DURATION "lane_duration" // 轨道时间线起始时间
#define DICT_KEY_LANE_ASSET_SIZE "asset_size"  // 轨道上剪辑个数
#define DICT_KEY_LANE_ASSET "asset"            // 轨道上剪辑列表
#define DICT_KEY_LANE_UID "lane_uid"           // 轨道的id

/* 设置画布的参数 */
#define DICT_KEY_CANVAS_PROPERTY_COLOR "canvas_color"       // int: 颜色的RGB值(0X000000-0XFFFFFF).
#define DICT_KEY_CANVAS_PROPERTY_COLOR_ALPHA "canvas_alpha" // float: 颜色的透明度（0% - 100%）.
#define DICT_KEY_CANVAS_PROPERTY_MATERIAL_UID \
    "canvas_material_uid" // HmcUid: 选中样式/图片的素材id,当前对HmcEditorSetCanvas无效.
#define DICT_KEY_CANVAS_PROPERTY_MATERIAL_PATH \
    "canvas_material_path" // string: 选中图片的绝对路径,当前对HmcEditorSetCanvas无效.
#define DICT_KEY_CANVAS_PROPERTY_WIDTH \
    "canvas_width" // int: 画布的宽度,只对HmcEditorSetCanvas有效,必须和高度同时设置，否则无效.
#define DICT_KEY_CANVAS_PROPERTY_HEIGHT \
    "canvas_height" // int: 画布的高度,只对HmcEditorSetCanvas有效,必须和宽度同时设置，否则无效.

#endif // HMCDICTKEY_H
