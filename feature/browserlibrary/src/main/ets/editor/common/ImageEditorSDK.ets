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

import lazy {
  EditorMsg,
  EditorParams,
  EditorSDK,
  EditorStatus,
  RectValue,
  SwitchAnimator,
  WinSize
} from '@oh-image-editor/editor-common/src/main/ets/service/EditorSDK';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy window from '@ohos.window';

const TAG: string = 'ImageEditorSDK';

/**
 * ImageEditorMain组件的消息回调
 */
export class ImageEditorMsg extends EditorMsg {
  public readonly MSG_ID_ON_EXIT: string = 'exit';
  public readonly MSG_ID_ON_EXIT_DISCARD_MODIFICATION: string = 'exit_discard_modification';
  public readonly MSG_ID_ON_FIRST_FRAME: string = 'first_frame';
  public id: string = '';
  public extra?: Object | undefined = undefined;

  constructor(id: string, extra?: Object) {
    super(id, extra);
    this.id = id;
    this.extra = extra;
  }
}

/**
 * ImageEditorMain组件的状态控制
 */
@Observed
export class ImageEditorStatus extends EditorStatus {
  public isPreviewHidden: boolean = false; // 入场动画过程中需要预览隐藏，切换完成后再显示
  public startFadeoutAnim: boolean = false; // 控制开始进行出场动画
}

/**
 * ImageEditorMain组件的初始化参数
 */
export class ImageEditorParams extends EditorParams {
  public static readonly MEDIA_TYPE_IMAGE: string = 'IMAGE';
  public static readonly MEDIA_TYPE_VIDEO: string = 'VIDEO';
  public uri: string = '';
  public mediaType: string = '';
  public thumbnail: string = '';
  public albumUri: string = '';
}

/**
 * 编辑功能的全局SDK接口
 */
export class ImageEditorSDK extends EditorSDK {
  public static sHasInitialized: boolean = false;

  /**
   * 初始化全局变量及加载native so
   *
   * @param abilityStageContext abilityStage的context
   * @param abilityContext ability的context
   * @param windowStage windowStage实例
   * @param moduleContext 被hsp集成时需要额外传入hsp对应的module context，以访问hsp中的rawfile资源
   */
  public static initialize(abilityStageContext: Context, abilityContext: Context,
    windowStage: window.WindowStage, moduleContext?: Context) {
    Log.info(TAG, 'ImageEditorSDK initialize from browserlibrary');
    EditorSDK.initialize(abilityStageContext, abilityContext, windowStage, moduleContext);
  }

  /**
   * 通知用户进行back动作
   *
   * @returns true表示back事件被编辑业务消费，调用方不继续传递back事件
   */
  public static onBackPress(): boolean {
    return EditorSDK.onBackPress();
  }

  public static handleTermination(): boolean {
    return EditorSDK.handleTermination();
  }
}

export class ImageRectValue extends RectValue {
  public x: number;
  public y: number;
  public width: number;
  public height: number;

  constructor(x: number, y: number, width: number, height: number) {
    super(x, y, width, height);
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }
}

/**
 * 提供编辑组件入场&出场的一镜到底动效能力接口
 */
export class ImageSwitchAnimator extends SwitchAnimator {
  /**
   * 获取编辑页预览区域的rect位置
   *
   * @param winSize 应用当前窗口宽高，单位vp
   * @param ratio 素材的宽高比（宽/高）
   * @param mediaType 素材的类型（IMAGE:图片，VIDEO:视频）
   * @returns rect in px
   */
  public static getEditorPreviewRect(imageWinSize: WinSize, ratio: number, mediaType: string): ImageRectValue {
    return SwitchAnimator.getEditorPreviewRect({
      width: imageWinSize.width,
      height: imageWinSize.height,
    }, ratio, mediaType);
  }
}