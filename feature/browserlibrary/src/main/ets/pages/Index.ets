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
 * 此文件已管控,禁止任何合入
 * 责任田: 性能
 * 原因: 在此export 引用对象, 将允许开发人员使用非精准导入, 影响冷启动
 *
 * 另外, 在视图文件中import大so文件的时候, 推荐使用懒加载而不是在开头import:
 * (): void {
 *   import('@ohos/common/src/main/ets/default/xxx').then((ns) => {
 *   ns.xxx(getContext(), records);
 * }
 *
 * 已有代码将被陆续删除, 所有非管控合入将被回退并追溯
 */