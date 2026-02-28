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

/* [此文件已管控, 任何合入将被要求整改]
 * 获取全局的全局单例变量/常量，用于代替GlobalThis,
 * 请将变量放进../variables 文件夹下, 以业务分类, 保持代码高内聚
 * 请勿滥用全局变量
 * 声明变量的优先级顺序: 函数内 => 文件内(类外 => 类内成员) => 模块内 => 跨模块
 *
 * 适合存一些比较大的全局对象或者使用方不感知变化的值
 * 使用方需要感知变化的值放在AppStorage或LocalStorage中
 * 比较大的全局对象放在 ./Context.ts
 *
 */

/**
 * 业务: 隐私合规
 */
export enum Privacy {
  CLOUD_ENHANCE_PRIVACY_PROTOCOL = 10742,
}

export namespace CloudEnhance {
  export let isPropSupport: boolean | undefined = undefined; // system param 特性是否体现

  export let isSupportAutoCloudEnhance: boolean | undefined = undefined; // 设备是否支持自动云增强
}