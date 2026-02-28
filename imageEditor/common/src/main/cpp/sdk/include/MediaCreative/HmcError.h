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

#ifndef HMCERROR_H
#define HMCERROR_H

#define HMC_OK (0) // 成功

// 通用错误
#define HMC_ERR (-100000)                // 错误
#define HMC_ERR_PARAM (HMC_ERR - 1)      // 参数错误
#define HMC_ERR_OOM (HMC_ERR - 2)        // 内存不足
#define HMC_ERR_DICT_KEY (HMC_ERR - 3)   // 无对应的KEY
#define HMC_ERR_DICT_VALUE (HMC_ERR - 4) // VALUE的类型不正确
#define HMC_ERR_EAGAIN (HMC_ERR - 5)     // 同步非阻塞接口临时错误
#define HMC_ERR_EINTR (HMC_ERR - 6)      // 被中断
#define HMC_ERR_ECONNRESET (HMC_ERR - 7) // 连接被复位
#define HMC_ERR_EOS (HMC_ERR - 8)        // 文件/流结束
// ...
#define HMC_ERR_FILE (-100100)                    // 文件错误
#define HMC_ERR_FILE_NOT_EXIST (HMC_ERR_FILE - 1) // 文件不存在
// 网络错误码
#define HMC_ERR_NETWORK (-100200)                                // 网络错误
#define HMC_ERR_NETWORK_TIMEOUT (HMC_ERR_NETWORK - 1)            // 网络超时
#define HMC_ERR_NETWORK_REQUEST_BAD (HMC_ERR_NETWORK - 2)        // 错误请求
#define HMC_ERR_NETWORK_REQUEST_NOT_FOUND (HMC_ERR_NETWORK - 3)  // 页面找不到
#define HMC_ERR_NETWORK_SERVER_INNER_ERROR (HMC_ERR_NETWORK - 4) // 服务器内部错误
#define HMC_ERR_HTTP_FAILURE (HMC_ERR_NETWORK - 11)              // http请求失败
#define HMC_ERR_HTTP_INIT_ERROR (HMC_ERR_NETWORK - 12)           // http初始化失败
#define HMC_ERR_HTTP_PERFORM_ERROR (HMC_ERR_NETWORK - 13)        // http参数失败
#define HMC_ERR_MUSIC_SERVER_AUTH_FAILED (HMC_ERR_NETWORK - 14)  // 服务器认证失败
#define HMC_ERR_RESPONSE_PARSE_ERR (HMC_ERR_NETWORK - 30)        // 响应数据解析数据异常
#define HMC_ERR_REQUEST_CREATE_FAILED (HMC_ERR_NETWORK - 40)     // httprequest创建失败
#define HMC_ERR_LOWER_LIMIT (HMC_ERR_NETWORK - 99)               // 网络错误下限，用于判断错误类型范围
#define HMC_HTTP_SUCCESS (HMC_OK)                                // http请求成功
// ...

// 业务错误码
#define HMC_ERR_SERVICE (-200000)                            // 业务层错误
#define HMC_ERR_SERVICE_INVALID_EDITOR (HMC_ERR_SERVICE - 1) // 无效editor
// ...
#define HMC_ERR_SERVICE_ASSET (-200100)                                    // 剪辑错误
#define HMC_ERR_SERVICE_ASSET_INVALID (HMC_ERR_SERVICE_ASSET - 1)          // 无效剪辑
#define HMC_ERR_SERVICE_ASSET_TYPE_ERR (HMC_ERR_SERVICE_ASSET - 2)         // 剪辑类型错误
#define HMC_ERR_SERVICE_ASSET_MATERIAL_INVALID (HMC_ERR_SERVICE_ASSET - 3) // 无效素材
// ...
#define HMC_ERR_SERVICE_LANE (-200200)                           // 轨道错误
#define HMC_ERR_SERVICE_LANE_INVALID (HMC_ERR_SERVICE_LANE - 1)  // 无效轨道
#define HMC_ERR_SERVICE_LANE_TYPE_ERR (HMC_ERR_SERVICE_LANE - 2) // 轨道类型错误
// ...
#define HMC_ERR_SERVICE_EFFECT (-200300)                              // 效果错误
#define HMC_ERR_SERVICE_EFFECT_INVALID (HMC_ERR_SERVICE_EFFECT - 1)   // 无效效果
#define HMC_ERR_SERVICE_EFFECT_TYPE_ERR (HMC_ERR_SERVICE_EFFECT - 2)  // 效果类型错误
#define HMC_ERR_SERVICE_EFFECT_UN_ENABLE (HMC_ERR_SERVICE_EFFECT - 3) // 效果未使能
// ...

// 引擎错误码
#define HMC_ERR_ENGINE (-300000) // 引擎错误
// ...

// 编解码错误码
#define HMC_ERR_ENGINE_VIDEO (-300100)
#define HMC_ERR_ENGINE_VIDEO_BUFFER_INDEX_INVALID (HMC_ERR_ENGINE_VIDEO - 1) // buffer无效

// 工程管理错误码
#define HMC_ERR_PROJECT (-400000) // 工程错误
// ...

// 素材区错误码
#define HMC_ERR_MATERIAL_BASE (-500000)
#define HMC_ERR_MATERIAL_PARAM (HMC_ERR_MATERIAL_BASE - 1)                // 参数错误
#define HMC_ERR_MATERIAL_MEMORY (HMC_ERR_MATERIAL_BASE - 2)               // 内存错误
#define HMC_ERR_MATERIAL_DOWNLOAD (HMC_ERR_MATERIAL_BASE - 3)             // 下载错误
#define HMC_ERR_MATERIAL_DOWNLOADING (HMC_ERR_MATERIAL_BASE - 4)          // 正在下载
#define HMC_ERR_MATERIAL_UPDATE_CONTENT (HMC_ERR_MATERIAL_BASE - 5)       // 更新内容错误
#define HMC_ERR_MATERIAL_UPDATE_COLUMN (HMC_ERR_MATERIAL_BASE - 6)        // 更新列失败
#define HMC_ERR_MATERIAL_UNAVAILABLE (HMC_ERR_MATERIAL_BASE - 7)          // 不可获得
#define HMC_ERR_MATERIAL_CREATING_UPDATING (HMC_ERR_MATERIAL_BASE - 8)    // 正在创建或更新
#define HMC_ERR_MATERIAL_FILE_NOT_EXIST (HMC_ERR_MATERIAL_BASE - 9)       // 文件不存在
#define HMC_ERR_MATERIAL_INNER (HMC_ERR_MATERIAL_BASE - 10)               // 错误输入
#define HMC_ERR_MATERIAL_PARSE (HMC_ERR_MATERIAL_BASE - 11)               // 解码失败
#define HMC_ERR_MATERIAL_FORMATR_NOT_SUPPORT (HMC_ERR_MATERIAL_BASE - 12) // 格式不支持
#define HMC_ERR_MATERIAL_TYPE_NOT_SUPPORT (HMC_ERR_MATERIAL_BASE - 13)    // 类型不支持
// ...

// 编辑数据错误码
#define HMC_ERR_EDITDATA_BASE (-600000)
#define HMC_ERR_EDITDATA_NOT_SYSTEM (HMC_ERR_EDITDATA_BASE - 1)    // 不是system的edita
#define HMC_ERR_EDITDATA_NO_EXTRA_INFO (HMC_ERR_EDITDATA_BASE - 2) // 没有extra_info
#define HMC_ERR_EDITDATA_NO_SIGNATURE (HMC_ERR_EDITDATA_BASE - 3)  // 没有组件的定制数据

// 消除错误码
#define HMC_ERR_AI_REMOVE (-700000)                                             // AI消除错误
#define HMC_ERR_AI_REMOVE_CANCEL (HMC_ERR_AI_REMOVE - 1)                        // 取消AI消除
#define HMC_ERR_AI_REMOVE_NETWORK (HMC_ERR_AI_REMOVE - 2)                       // 因为网络原因，AI消除失败
#define HMC_ERR_AI_REMOVE_SERVER (HMC_ERR_AI_REMOVE - 3)                        // 因为服务器原因，AI消除失败
#define HMC_ERR_AI_REMOVE_TIMEOUT (HMC_ERR_AI_REMOVE - 4)                       // 因为超时原因，AI消除失败
#define HMC_ERR_AI_REMOVE_RISK_MANAGER (HMC_ERR_AI_REMOVE - 5)                  // 因为风控原因，AI消除失败
#define HMC_ERR_AI_REMOVE_RESOLUTION_TOO_LARGE (HMC_ERR_AI_REMOVE - 6)          // 因为分辨率过大，AI消除失败
#define HMC_ERR_AI_REMOVE_RATIO (HMC_ERR_AI_REMOVE - 7)                         // 因为尺寸异常，AI消除失败
#define HMC_ERR_AI_REMOVE_FORMAT (HMC_ERR_AI_REMOVE - 8)                        // 因为格式问题，AI消除失败
#define HMC_ERR_AI_REMOVE_INPUT_INVALID (HMC_ERR_AI_REMOVE - 9)                 // 因为入参不合法，AI消除失败
#define HMC_ERR_AI_REMOVE_RISK_TIMEOUT (HMC_ERR_AI_REMOVE - 10)                 // 因为风控超时，AI消除失败
#define HMC_ERR_AI_REMOVE_NOT_ALLOW (HMC_ERR_AI_REMOVE - 11)                    // 因为算法不允许，AI消除失败
#define HMC_ERR_AI_REMOVE_RUN_FAILED (HMC_ERR_AI_REMOVE - 12)                   // 因为算法运行失败，AI消除失败
#define HMC_ERR_AI_REMOVE_ONDEVICE_REASONING_FAIL (HMC_ERR_AI_REMOVE - 13)      // 因为端侧大模型推理失败，AI消除失败
#define HMC_ERR_AI_REMOVE_ONDEVICE_LOAD_FAIL (HMC_ERR_AI_REMOVE - 14)           // 因为端侧大模型加载失败，AI消除失败
#define HMC_ERR_AI_REMOVE_INVALID_PARAMETER (HMC_ERR_AI_REMOVE - 15)            // 因为非法参数，AI消除失败

// 移物错误码
#define HMC_ERR_AI_MOVE (-700100)                                             // 当前重叠区域过大
#define HMC_ERR_AI_MOVE_NOT_SUPPORT (HMC_ERR_AI_MOVE - 1)                   // 当前能力不支持
#define HMC_ERR_AI_MOVE_CANCEL (HMC_ERR_AI_MOVE - 2)                        // 取消AI抠贴
#define HMC_ERR_AI_MOVE_RISK_MANAGER (HMC_ERR_AI_MOVE - 3)                  // 因为风控原因，AI抠贴失败
#define HMC_ERR_AI_MOVE_TIMEOUT (HMC_ERR_AI_MOVE - 4)                       // 因为超时原因，AI抠贴失败
#define HMC_ERR_AI_MOVE_NETWORK (HMC_ERR_AI_MOVE - 5)                       // 因为网络原因，AI抠贴失败
#define HMC_ERR_AI_MOVE_SERVER (HMC_ERR_AI_MOVE - 6)                        // 因为服务器原因，AI抠贴失败
#define HMC_ERR_AI_MOVE_API_MAX (HMC_ERR_AI_MOVE - 7)                        // 当日操作次数已达上限
#define HMC_ERR_AI_MOVE_MASK_MIN (HMC_ERR_AI_MOVE - 8)                       // 图片扣取区域太小
#define HMC_ERR_AI_MOVE_MASK_MAX (HMC_ERR_AI_MOVE - 9)                       // 主体放大过大

// 背景编辑错误吗
#define HMC_ERR_AI_BACKGROUND (-800000)                                          // AI背景编辑错误
#define HMC_ERR_AI_BACKGROUND_INVALID_OPT (HMC_ERR_AI_BACKGROUND - 1)            // AI背景编辑-无效操作

// 扩图错误码
#define HMC_ERR_AI_EXPAND (-900000)                                             // AI扩图错误
#define HMC_ERR_AI_EXPAND_CANCEL (HMC_ERR_AI_EXPAND - 1)                        // 取消AI扩区

// 修图大师错误码
#define HMC_ERR_AI_REFINE_MASTER (-1000000)                                       // AI修图大师错误
#define HMC_ERR_AI_REFINE_NATIVE_ERROR (HMC_ERR_AI_REFINE_MASTER - 1)             // Native侧错误
#define HMC_AI_UPLOAD_ERROR (HMC_ERR_AI_REFINE_MASTER - 2)
#define HMC_AI_REFINE_CANCEL (HMC_ERR_AI_REFINE_MASTER - 3)
#define HMC_ERR_AI_REMOVE_REFLECT (-1000100)
#define HMC_ERR_AI_REMOVE_REFLECT_CANCEL (HMC_ERR_AI_REMOVE_REFLECT - 1)

// 换脸错误码
#define HMC_ERR_AI_REPLACE (-900100)       // 通用错误
#define HMC_ERR_AI_REPLACE_TIMEOUT (HMC_ERR_AI_REPLACE - 1)   // 执行超时
#define HMC_ERR_AI_REPLACE_NO_EMO (HMC_ERR_AI_REPLACE - 2)       // 未检测到人脸
#define HMC_ERR_AI_REPLACE_COMPLETED (HMC_ERR_AI_REPLACE - 3)       // 涂鸦未保存返回状态

// 智能校正
#define HMC_ERR_INTELLIGENT_CORRECTION (720)       // 智能校正失败

// 保留
// ...

#endif // HMCERROR_H
