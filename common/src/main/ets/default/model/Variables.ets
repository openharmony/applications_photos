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

/*
 * 获取全局的全局单例变量/常量，用于代替GlobalThis, 以业务分类, 保持代码高内聚
 *
 * 适合存一些比较大的全局对象或者使用方不感知变化的值
 * 使用方需要感知变化的值放在AppStorage或LocalStorage中
 * 比较大的全局对象放在 ./Context.ts
 *
 * @author
 * @since 2024/4/27
 */

/**
 * 业务: 系统变量
 */
export namespace SystemPrams {
  export const ON: string = 'on';
}

/**
 * 业务: ocr文字高亮
 */
export namespace OcrHighlight {
  // 非胶囊词
  export let curNewSearchWords: string = '';

  // 胶囊词中搜索域包含ocr的
  export let curOcrSearchWords: string = '';
}

/**
 * 业务：拼图
 */
export namespace Collage {
  export let isCollageViewCanSave: boolean = false;
}
