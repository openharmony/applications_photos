/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

/**
 * 此文件已管控,禁止任何合入
 * 责任田: 性能
 * 原因: 在此 export 引用对象, 将允许开发人员使用非精准导入, 影响冷启动
 *
 * 另外, 在视图文件中import大so文件的时候, 推荐使用懒加载而不是在开头import:
 * (): void {
 *   import('@ohos/common/src/main/ets/default/xxx').then((ns) => {
 *   ns.xxx(getContext(), records);
 * }
 *
 */

export { EditorController } from './src/main/ets/controller/EditorController';

export { EditorMain as ImageEditorMain,
  EditorMsg as ImageEditorMsg,
  EditorParams as ImageEditorParams,
  EditorSDK as ImageEditorSDK } from '@oh-image-editor/editor-pc';
