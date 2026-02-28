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
#ifndef HMC_PROJECT_SERIALIZE_DICT_H
#define HMC_PROJECT_SERIALIZE_DICT_H

#define PROJECT_KEY_EDITOR_SIGNATURE_KEY "_editor_signature_"
#define PROJECT_KEY_EDITOR_SIGNATURE_VALUE "_HW_OHOS_MEDIA_EDITOR_"

/* tab-project-lane */
#define PROJECT_KEY_LANE_MODULE_KEY "lane_module"
#define PROJECT_KEY_LANE_MUTE "lane_mute" // BOOL: 泳道是否静音

/* tab-project-asset */
#define PROJECT_KEY_ASSET_TYPE "asset_type"


/* tab-project-time-line */
#define PROJECT_KEY_TIME_LINE_KEY "time_line"

/* tab-project-render-manager */
#define PROJECT_KEY_AUDIO_BIT_RATE "audio_bit_rate"
#define PROJECT_KEY_AUDIO_SAMPLE_RATE "audio_sample_rate"
#define PROJECT_KEY_AUDIO_CHANNEL_NUM "audio_channel_num"
#define PROJECT_KEY_VIDEO_EXPORT_PATH "video_path"
#define PROJECT_KEY_IMAGE_EXPORT_PATH "image_path"
#define PROJECT_KEY_IMAGE_MIMETYPE "mime_type"
#define PROJECT_KEY_VIDEO_BIT_RATE "video_bit_rate"
#define PROJECT_KEY_VIDEO_WIDTH "video_width"
#define PROJECT_KEY_VIDEO_HEIGHT "video_height"
#define PROJECT_KEY_VIDEO_FPS "video_fps"
#define PROJECT_KEY_VIDEO_PIXEL "video_pixel"
#define PROJECT_KEY_VIDEO_EXPORT_ENCODER "video_export_encoder" // 0 h264, 1 h265
#define PROJECT_KEY_MEDIA_EXPORT_TYPE "media_export_type"       // HmcExportMediaType
#define PROJECT_KEY_EXPORT_STARTTIME "export_starttime"
#define PROJECT_KEY_EXPORT_ENDTIME "export_endtime"
#define PROJECT_KEY_ASSET_ID "asset_id"

#define PROJECT_KEY_PREVIEW_PERIOD_START "startTime"
#define PROJECT_KEY_PREVIEW_PERIOD_END "endTime"
#define PROJECT_KEY_PREVIEW_CANVAS_WIDTH "canvas_width"
#define PROJECT_KEY_PREVIEW_CANVAS_HEIGHT "canvas_height"

/* 工程文件中保存用户自定义数据的属性 */
#define PROJECT_KEY_USERDATA "userdata"           // 用户自定义数据
#define PROJECT_KEY_USERDATA_UID "userdata_uid"   // 用户自定义数据UID
#define PROJECT_KEY_USERDATA_DICT "userdata_dict" // 用户自定义数据dict

/* table-project-transform-property */
#define PROJECT_KEY_TRANSFORM_OFFSET_X "offsetX"
#define PROJECT_KEY_TRANSFORM_OFFSET_Y "offsetY"
#define PROJECT_KEY_TRANSFORM_OFFSET_Z "offsetZ"
#define PROJECT_KEY_TRANSFORM_ROTATION_X "rotationX"
#define PROJECT_KEY_TRANSFORM_ROTATION_Y "rotationY"
#define PROJECT_KEY_TRANSFORM_ROTATION_Z "rotationZ"
#define PROJECT_KEY_TRANSFORM_SCALE_X "scaleX"
#define PROJECT_KEY_TRANSFORM_SCALE_Y "scaleY"
#define PROJECT_KEY_TRANSFORM_RATIO_X "ratioX"
#define PROJECT_KEY_TRANSFORM_RATIO_Y "ratioY"
#define PROJECT_KEY_TRANSFORM_REF_X "refX"
#define PROJECT_KEY_TRANSFORM_REF_Y "refY"
#define PROJECT_KEY_TRANSFORM_MIRROR_H "mirrorH"
#define PROJECT_KEY_TRANSFORM_MIRROR_V "mirrorV"
#define PROJECT_KEY_TRANSFORM_OPACITY "opacity"
#define PROJECT_KEY_TRANSFORM_VIEWPORT_X "viewportX"
#define PROJECT_KEY_TRANSFORM_VIEWPORT_Y "viewportY"
#define PROJECT_KEY_TRANSFORM_CROP_LB_X "cropLBX"
#define PROJECT_KEY_TRANSFORM_CROP_LB_Y "cropLBY"
#define PROJECT_KEY_TRANSFORM_CROP_RT_X "cropRTX"
#define PROJECT_KEY_TRANSFORM_CROP_RT_Y "cropRTY"
#define PROJECT_KEY_TRANSFORM_CROP_OFFSET_X "cropOffsetX"
#define PROJECT_KEY_TRANSFORM_CROP_OFFSET_Y "cropOffsetY"
#define PROJECT_KEY_TRANSFORM_CROP_SCALE_X "cropScaleX"
#define PROJECT_KEY_TRANSFORM_CROP_SCALE_Y "cropScaleY"
#define PROJECT_KEY_TRANSFORM_CROP_ROTATION "cropRotate"
#define PROJECT_KEY_TRANSFORM_CROP_ENABLE "cropEnable"

#define PROJECT_KEY_WATERMARK_TYPE "watermarkType"
#define PROJECT_KEY_WATERMARK_OPACITY "opacity"
#define PROJECT_KEY_WATERMARK_EXPORTW "exportW"
#define PROJECT_KEY_WATERMARK_EXPORTH "exportH"

#define PROJECT_KEY_WATERMARK_DIRECTORY "RESOURCE_DIRECTORY"
#define PROJECT_KEY_WATERMARK_IS_CONTAIN_PARAM "isContainParam"
#define PROJECT_KEY_WATERMARK_IS_CONTAIN_DATE "isContainDate"
#define PROJECT_KEY_WATERMARK_IS_CONTAIN_LOCATION "isContainLocation"
#define PROJECT_KEY_WATERMARK_IS_CONTAIN_XT_STYLE "isContainXtStyle"
#define PROJECT_KEY_WATERMARK_CAMERA_POSITION "cameraPosition"
#define PROJECT_KEY_WATERMARK_FILTER_SHOT_PARAM "FILTER_SHOT_PARAM"
#define PROJECT_KEY_WATERMARK_FILTER_SHOT_DATE "FILTER_SHOT_DATE"
#define PROJECT_KEY_WATERMARK_FILTER_STICKER_LOCATION "FILTER_STICKER_LOCATION"
#define PROJECT_KEY_WATERMARK_FILTER_STICKER_DEFINITION "FILTER_STICKER_DEFINITION"
#define PROJECT_KEY_WATERMARK_FILTER_XT_DEFINITION "FILTER_XT_DEFINITION"
#define PROJECT_KEY_WATERMARK_FILTER_XT_PARAM "FILTER_XT_PARAM"
#define PROJECT_KEY_WATERMARK_FILTER_XT_COLOR "FILTER_XT_COLOR"
#define PROJECT_KEY_WATERMARK_FILTER_XT_ENABLE "FILTER_XT_ENABLE"
#define PROJECT_KEY_WATERMARK_FILTER_SHOT_SIGN "FILTER_SHOT_ARTISTIC_TEXT"
#define PROJECT_KEY_WATERMARK_FILTER_SHOT_SIGN_FONT "FILTER_SHOT_ARTISTIC_FONT"
#define PROJECT_KEY_WATERMARK_FILTER_BACKGROUND_COLOR "FILTER_BACKGROUND_COLOR"
#define PROJECT_KEY_WATERMARK_FILTER_BACKGROUND_TYPE "FILTER_BACKGROUND_TYPE"
#define PROJECT_KEY_WATERMARK_FILTER_STICKER_CUSTOMTEXT "FILTER_STICKER_CUSTOMTEXT"
#define PROJECT_KEY_WATERMARK_FILTER_FESTIVAL_TYPE "FILTER_FESTIVAL_TYPE"
#define PROJECT_KEY_WATERMARK_FILTER_TEMPLATE "FILTER_TEMPLATE"
#define SHOT_SIGN_FONT "art"

#define PROJECT_KEY_WATERMARK_IS_ALWAYS_SHOW        "isAlwaysShow"
#define PROJECT_KEY_WATERMARK_ORI_WATERMARK_TYPE    "oriWatermarkType"
#define PROJECT_KEY_WATERMARK_ORI_IS_CONTAIN_PARAM  "oriIsContainParam"
#define PROJECT_KEY_WATERMARK_ORI_IS_CONTAIN_DATE   "oriIsContainDate"
#define PROJECT_KEY_WATERMARK_ORI_IS_CONTAIN_LOCATION "oriIsContainLocation"
#define PROJECT_KEY_WATERMARK_ORI_SHOT_SIGN   "oriShotSign"
#define PROJECT_KEY_WATERMARK_ORI_USER_INPUT  "originUserInput"
#define PROJECT_KEY_WATERMARK_ORI_IS_CONTAIN_XT_STYLE   "oriIsContainXtStyle"
#define PROJECT_KEY_WATERMARK_ORI_FILTER_TEMPLATE "oriFilterTemplate"
#define PROJECT_KEY_WATERMARK_ORI_BACKGROUND_TYPE "oriBackgroundType"
#define PROJECT_KEY_WATERMARK_ORI_BACKGROUND_COLOR "oriBackgroundColor"
#define PROJECT_KEY_MATERMARK_ORI_CUSTOMTEXT "oriCustomText"

#define PROJECT_KEY_WIDE_APERTURE_POSITION_X "positionX"
#define PROJECT_KEY_WIDE_APERTURE_POSITION_Y "positionY"
#define PROJECT_KEY_WIDE_APERTURE_F_NUM "fNum"

/* tab-project-image-asset */
#define PROJECT_KEY_ASSET_IMAGE_CONTENT "image_content" // 图片剪辑的内容.

/* tab-project-Video-asset */
#define PROJECT_KEY_ASSET_VIDEO_AUDIO "audio" //

#define PROJECT_KEY_ASSET_CROP_OFFSET_X "crop_offset_x" // 因裁剪而造成的离中心点的偏移量横坐标（0~1）
#define PROJECT_KEY_ASSET_CROP_OFFSET_Y "crop_offset_y" // 因裁剪而造成的离中心点的偏移量纵坐标（0~1）

/* tab-project-Audio-asset */
#define PROJECT_KEY_ASSET_AUDIO_MUTE "mute"                                     //
#define PROJECT_KEY_ASSET_AUDIO_FADE_IN_TIME "fade_in_time"                     // UINT32: 渐入时间
#define PROJECT_KEY_ASSET_AUDIO_FADE_OUT_TIME "fade_out_time"                   // UINT32: 渐出时间
#define PROJECT_KEY_ASSET_AUDIO_FADE_IN_DURATION_TIME "fade_in_duration_time"   // UINT32: 渐入持续时间
#define PROJECT_KEY_ASSET_AUDIO_FADE_OUT_DURATION_TIME "fade_out_duration_time" // UINT32: 渐出持续时间
#define PROJECT_KEY_ASSET_AUDIO_VOLUME_LEFT_DB "volume_left_db"                 // double: 音量左声道db值
#define PROJECT_KEY_ASSET_AUDIO_VOLUME_RIGHT_DB "volume_right_db"               // double: 音量右声道db值
#define PROJECT_KEY_ASSET_AUDIO_IS_PCM_ENCRYPT "is_pcm_encrypt"                 // BOOL: 是否加密
#define PROJECT_KEY_ASSET_AUDIO_IS_PCM_FILE "is_pcm_file"                       // BOOL: 是否是pcm文件
#define PROJECT_KEY_VERSION_NUM "version"                                       // string: 草稿版本号

#define PROJECT_KEY_PROPERTY_VALUE "value"   // 属性值
#define PROJECT_KEY_PROPERTY_ENABLE "enable" // 属性是否生效

/* 设置XTStyle滤镜的参数 */
#define PROJECT_KEY_XTSTYLE_TYPE "FILTER_XTSTYLE_TEMPLATE"                            // 个性风格的种类
#define PROJECT_KEY_XTSTYLE_COLOR_TEMPERATURE "FILTER_XTSTYLE_TEMPERATURE"            // 色温
#define PROJECT_KEY_XTSTYLE_SATURATION "FILTER_XTSTYLE_SATURATION"                    // 饱和度
#define PROJECT_KEY_XTSTYLE_LIGHT_AND_SHADOW "FILTER_XTSTYLE_LIGHTSHADOW"             // 光影
#define PROJECT_KEY_XTSTYLE_TEMPLATE_INDEX "FILTER_XTSTYLE_TEMPLATE_INDEX"            // 模板index
#define PROJECT_KEY_XTSTYLE_CREATE_MODE "FILTER_XTSTYLE_MODE"                         // 创建模式，表示是否复用创建的资源
#define PROJECT_KEY_XTSTYLE_FACT_RECTS "FILTER_XTSTYLE_FACE_DATA"                    // 人脸数据
#define PROJECT_KEY_XTSTYLE_FORCE_ON "FILTER_XTSTYLE_FORCE_ON"                       // 是否强制开启XXX（忽略一切其他条件）
#define PROJECT_KEY_XTSTYLE_PROCESS_MODE "FILTER_XTSTYLE_PROCESS_MODE"                // 表示预览还是导出

/* 设置Sport滤镜参数 */
#define PROJECT_KEY_SPORT_TYPE ""
#define PROJECT_KEY_SPORT_VALUE ""

#endif // HMC_PROJECT_SERIALIZE_DICT_H
