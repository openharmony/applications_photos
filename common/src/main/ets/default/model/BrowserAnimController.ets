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

import lazy { Log } from './../utils/Log';
import lazy { componentUtils, display, Rect } from '@kit.ArkUI';
import lazy {
  getScreen
} from './../model/common/ScreenManager';
import lazy Curves from '@ohos.curves';
import lazy { Constants } from './../model/common/Constants';
import lazy { Constants as BrowserConstants } from './../model/browser/photo/Constants';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';

/* instrument ignore file */
const TAG = 'BrowserAnimController';

/**
 * 作为IGridController返回的参数
 */
export interface GridStartParams extends Rect {
  /**
   * 起点圆角
   */
  radius?: number,

  /**
   * 边框宽度
   */
  borderWidth?: number,

  /**
   * 侧边栏宽度
   */
  slideBarWidth: number,
  /**
   * 宫格缩略图宽高比
   */
  ratio: number

  /**
   * 横竖屏状态
   */
  mDirection?: WindowDirection,

  /**
   * 宫格缩略图宽度
   */
  thumbnailWidth?: number,

  /**
   * 宫格缩略图高度
   */
  thumbnailHeight?: number,
}

export enum WindowDirection {
  LEFT = 0,
  RIGHT = 1,
  TOP = 2,
  BOTTOM = 3,
}

/**
 * 作为最终动画的参数
 */
export interface BrowserAnimParams {
  /**
   * 目标宽度
   */
  targetWidth?: Length,
  /**
   * 目标高度
   */
  targetHeight?: Length,
  /**
   * 相对原点的偏移量
   */
  targetTranslate?: TranslateOptions,
  /**
   * 目标缩略图宽度
   */
  targetThumbnailWidth?: Length,
  /**
   * 目标缩略图高度
   */
  targetThumbnailHeight?: Length,
  /**
   * 相对原点的缩略图偏移量
   */
  targetThumbnailTranslate?: TranslateOptions,
  /**
   * 小图的最终透明度
   */
  targetThumbnailOpacity?: number,
  /**
   * 大图的最终透明度
   */
  targetPhotoOpacity?: number,
  /**
   * 目标宽高比
   */
  targetAspectRatio?: number,
  /**
   * 目标圆角
   */
  targetRadius?: number,
  /**
   * 大图到小图的动效曲线
   */
  targetBorderWidth?: number,
  curveStart?: Curves.ICurve,
  /**
   * 相对原点的偏移量
   */
  curveEnd?: Curves.ICurve,
  targetScale?: ScaleOptions,
  /**
   * 动画播放按钮透明度
   */
  targetPlayButtonOpacity?: number,
}

/**
 * 控制器类型
 */
export enum ControllerType {
  /**
   * 宫格
   */
  PHOTO_GRID,

  /**
   * 相机
   */
  CAMERA,
}

/**
 * IGridController作为动效基类，作为反向注入使用，进出大图需要使用动效，实现一个controller，BrowserAnimController的init传入
 * 需要实现getGridStartParams，返回动效参数
 */
export interface IGridController {
  /**
   * 获取控制器类型
   *
   * @returns 控制器类型
   */
  getControllerType(): ControllerType;

  /**
   * getGridStartParams, 返回动效参数
   *
   * uri?: 当前执行动效的大图uri
   */
  getGridStartParams(uri?: string, needSrolling?: boolean): GridStartParams | undefined;

  updatePlaceHolder(uniqueId: string, isTap: boolean): void;
}

export class CameraAnimController implements IGridController {
  public uiContext: UIContext | undefined = undefined;
  private getGridStartParamsFunc: () => GridStartParams = () => {
    return {
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      radius: 0,
      borderWidth: 0,
      slideBarWidth: 0,
      ratio: 1,
      mDirection: undefined
    };
  };

  constructor(uiContext: UIContext | undefined, getGridStartParams: () => GridStartParams) {
    this.uiContext = uiContext;
    this.getGridStartParamsFunc = getGridStartParams;
  }

  updatePlaceHolder(uniqueId: string, isTap: boolean): void {
  }

  public getControllerType(): ControllerType {
    return ControllerType.CAMERA;
  }

  public getGridStartParams(): GridStartParams {
    return this.getGridStartParamsFunc();
  }
}

export class BrowserAnimController {
  private gridController?: IGridController;
  public isTransitionEnable: boolean = true;
  public enterAnimId: number = 0;
  constructor() {}
  /**
   * 动画回调
   */
  public enterOnStart: () => void = () => {
  }
  public enterOnfinish: () => void = () => {
  }
  public exitOnStart: () => void = () => {
  };
  public exitOnfinish: () => void = () => {
  };

  public init(gridController?: IGridController): void {
    // 有controller才能执行动效
    if (gridController) {
      Log.info(TAG, `BrowserAnimController init success`)
      this.gridController = gridController;
      this.isTransitionEnable = false;
      // 动画ID增加，防止重复动画onfinish回调
      this.enterAnimId += 1;
    } else {
      Log.info(TAG, `BrowserAnimController init fail`)
      this.isTransitionEnable = true;
    }
  }

  public updatePlaceHolder(uniqueId: string, isTap: boolean): void {
    Log.info(TAG,'updatePlaceHolder');
    this.gridController?.updatePlaceHolder?.(uniqueId, isTap);
  }


  public initFun(enterOnStart: () => void, enterOnfinish: () => void, exitOnStart: () => void,
    exitOnfinish: () => void): void {
    Log.info(TAG, `initAnimateFun`)
    this.enterOnStart = enterOnStart;
    this.enterOnfinish = enterOnfinish;
    this.exitOnStart = exitOnStart;
    this.exitOnfinish = exitOnfinish;
  }


  public release(): void {
    this.enterAnimId = 0;
    Log.info(TAG, `BrowserAnimController uninit`)
  }

  /**
   * 计算相对大图的translate
   *
   * @param position
   * @param area
   * @returns
   */
  public calculateTranslate(position: [number, number], area: [number, number],
    slideBarWidth: number): [number, number] {
    let winLayoutWidth: number = getScreen().getWinWidth();
    let winLayoutHeight: number = getScreen().getWinHeight();
    // 维吾尔语言的X需要更换
    let centerX: number = 0;

    let translateX: number = position[0] + (area[0] - winLayoutWidth) / 2;
    let translateY: number = position[1] + (area[1] - winLayoutHeight) / 2;
    // TODO:PC独立窗口上了之后删除
    if (DeviceInfo.isPc()) {
      translateX -= slideBarWidth / 2;
    }
    if (i18n.isRTL(i18n.System.getSystemLanguage())) {
      translateX = centerX - translateX;
    }
    return [translateX, translateY];
  }

  // 进入大图前/退出大图后参数
  public getBrowserToGridAnimationParams(index: number, uri: string, needScrolling: boolean = true):
    BrowserAnimParams {
    Log.info(TAG, `getBrowserToGridAnimationParams`);
    // 获取坐标和大小信息
    let params: GridStartParams | undefined = this.gridController?.getGridStartParams(uri, needScrolling);
    if (!params) {
      Log.error(TAG, `getBrowserToGridAnimationParams params not enough ${params} ${this.gridController}`);
      return {
        targetWidth: Constants.PERCENT_100,
        targetThumbnailWidth: Constants.PERCENT_100,
        targetHeight: Constants.PERCENT_100,
        targetThumbnailHeight: Constants.PERCENT_100,
        targetPhotoOpacity: 1,
        targetThumbnailOpacity: 0,
        targetTranslate: { x: 0, y: 0 },
        targetThumbnailTranslate: { x: 0, y: 0 },
        targetRadius: 0,
        targetPlayButtonOpacity: 0,
      }
    }
    Log.info(TAG, `getBrowserToGridAnimationParams params ${params.left} ${params.right} ${
    params.top} ${params.bottom} ${params.mDirection} ${params.radius} ${params.borderWidth} ${params.ratio}
    ${params.slideBarWidth}`);
    let screenOffsetX: number = params.left;
    let screenOffsetY: number = params.top;
    let gridWidth: number = params.right - params.left;
    let gridHeight: number = params.bottom - params.top;
    params.ratio ??= 1;
    params.slideBarWidth ??= 0;
    if (DeviceInfo.isPc() && params.thumbnailWidth && params.thumbnailHeight && gridWidth > params.thumbnailWidth &&
      gridHeight > params.thumbnailHeight) {
      screenOffsetY += (gridHeight - params.thumbnailHeight) / 2;
      screenOffsetX += (gridWidth - params.thumbnailWidth) / 2;
      gridWidth = params.thumbnailWidth;
      gridHeight = params.thumbnailHeight;
    } else {
      if (params.ratio > 1) {
        gridHeight /= params.ratio;
        screenOffsetY += (gridWidth - gridHeight) / 2;
      } else {
        gridWidth *= params.ratio;
        screenOffsetX += (gridHeight - gridWidth) / 2;
      }
    }
    let translateRes: [number, number] = this.calculateTranslate([screenOffsetX, screenOffsetY],
      [gridWidth, gridHeight], params.slideBarWidth);
    Log.info(TAG, `getGridPosByIndex: ${index} ${screenOffsetX} ${screenOffsetY} ${gridWidth} ${gridHeight
    }  ${translateRes[0]} ${translateRes[1]}`);

    try {
      let displayInfo = display.getDefaultDisplaySync();
      Log.info(TAG, `getDefaultDisplaySync: ${displayInfo?.width} ${displayInfo?.height}
      ${displayInfo.scaledDensity} ${vp2px(1)}`);
    } catch (error) {
      Log.error(TAG, `Error getting display info: ${error?.code} ${error?.message}`);
    }

    let browserAnimParams: BrowserAnimParams = {
      targetWidth: gridWidth,
      targetThumbnailWidth: gridWidth,
      targetHeight: gridHeight,
      targetThumbnailHeight: gridHeight,
      targetTranslate: { x: translateRes[0], y: translateRes[1] },
      targetThumbnailTranslate: { x: translateRes[0], y: translateRes[1] },
      targetThumbnailOpacity: 1,
      targetPhotoOpacity: 1,
      targetAspectRatio: params.ratio,
      targetRadius: params.radius ?? 0,
      targetBorderWidth: params.borderWidth,
      targetPlayButtonOpacity: 0,
    };
    const controllerType = this.gridController?.getControllerType() ?? ControllerType.PHOTO_GRID;
    switch (controllerType) {
      case ControllerType.PHOTO_GRID:
        browserAnimParams.curveStart = BrowserConstants.OPEN_PHOTO_CURVE;
        browserAnimParams.curveEnd = BrowserConstants.CLOSE_PHOTO_CURVE;
        break;
      case ControllerType.CAMERA:
        browserAnimParams.curveStart = BrowserConstants.ANIM_PB_SHARE_OPEN_CURVE;
        browserAnimParams.curveEnd = BrowserConstants.ANIM_PB_SHARE_CLOSE_CURVE;
        break;
    }
    return browserAnimParams;
  }

  // 大图返回前/进入大图后参数
  public getGridToBrowserAnimationParams(): BrowserAnimParams {
    let browserAnimParams: BrowserAnimParams = {
      targetWidth: Constants.PERCENT_100,
      targetThumbnailWidth: Constants.PERCENT_100,
      targetHeight: Constants.PERCENT_100,
      targetThumbnailHeight: DeviceInfo.isHalfFoldState() ? Constants.PERCENT_50 : Constants.PERCENT_100,
      targetPhotoOpacity: 1,
      targetThumbnailOpacity: 1,
      targetTranslate: { x: 0, y: 0 },
      targetThumbnailTranslate: { x: 0, y: DeviceInfo.isHalfFoldState() ? Constants.PERCENT_NEGATIVE_50 : 0},
      targetRadius: 0,
      targetBorderWidth: 0,
      targetPlayButtonOpacity: 1,
    };
    const controllerType = this.gridController?.getControllerType() ?? ControllerType.PHOTO_GRID;
    switch (controllerType) {
      case ControllerType.PHOTO_GRID:
        browserAnimParams.curveStart = BrowserConstants.OPEN_PHOTO_CURVE;
        browserAnimParams.curveEnd = BrowserConstants.CLOSE_PHOTO_CURVE;
        break;
      case ControllerType.CAMERA:
        browserAnimParams.curveStart = BrowserConstants.ANIM_PB_SHARE_OPEN_CURVE;
        browserAnimParams.curveEnd = BrowserConstants.ANIM_PB_SHARE_CLOSE_CURVE;
        break;
    }
    return browserAnimParams;
  }

  public getEnterAnimTraceName(): string {
    const controllerType = this.gridController?.getControllerType() ?? ControllerType.PHOTO_GRID;
    switch (controllerType) {
      case ControllerType.PHOTO_GRID:
        return BrowserConstants.OPEN_BROWSER;
      case ControllerType.CAMERA:
        return BrowserConstants.CAMERA_UE_GO_GALLERY;
    }
  }

  public getExitAnimTraceName(): string {
    const controllerType = this.gridController?.getControllerType() ?? ControllerType.PHOTO_GRID;
    switch (controllerType) {
      case ControllerType.PHOTO_GRID:
        return BrowserConstants.CLOSE_BROWSER;
      case ControllerType.CAMERA:
        return BrowserConstants.CAMERA_UE_EXIT_GALLERY;
    }
  }

  // TODO 临时使用，后续解下拉返回问题后删除
  public getControllerTypeCamera(): boolean {
    return (this.gridController?.getControllerType() ?? ControllerType.PHOTO_GRID) === ControllerType.CAMERA;
  }
}