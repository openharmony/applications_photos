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

import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { isFilterListEmpty } from '@ohos/common/src/main/ets/default/utils/ArrayUtil';
import lazy Matrix4 from '@ohos.matrix4';
import lazy {
  AnalyzerUtil,
  ComponentSizeInfo,
  AIButtonStatus,
} from '@ohos/common/src/main/ets/default/utils/AnalyzerUtils';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Constants as BrowserConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import lazy { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import lazy { Matrix4x4 } from '@ohos/common/src/main/ets/default/utils/Matrix4x4';
import lazy { getScreen, isOrientationHorizontal } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import { PhotoDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoDataSource';


const HALF_DIVIDER: number = 2;
const AI_BUTTON_DEFAULT_OFFSET: number = 16;
const AI_BUTTON_DEFAULT_OFFSET_MIDDLE: number = 24;
const AI_BUTTON_DEFAULT_OFFSET_LARGE: number = 32;
const AI_BUTTON_VIDEO_RIGHT_OFFSET: number = 52;
/* instrument ignore file */
const TAG: string = 'common_VideoAnalyzerAdaptor';

export class VideoAnalyzerAdaptor {
  private xComponentController: XComponentController | undefined;
  private isVideoAnalyzer: boolean = false;
  private xComAnalyzerController: Promise<void> | undefined;
  // private controller: visionImageAnalyzer.VisionImageAnalyzerController | undefined;
  private startAnalyzer: () => void = (): void => this.startVideoAnalyzer();
  private stopAnalyzer: () => void = (): void => this.stopVideoAnalyzer();
  public static readonly NO_SKIN_SMOOTHING: string = 'no_skin_smoothing';
  public static readonly ALREADY_SKIN_SMOOTHED: string = 'already_skin_smoothed';
  public static readonly PENDDING_DOWNLOAD_TASK_MAX_CNT: number = 1;
  public static readonly DOWNLOAD_TIMEOUT: number = 600000;
  private onVisibilityChangeCallback: Function = (): void => {
  };
  private handleAiOverlayChangedFunc: Function = (): void => {
  };
  private calcBarBottomHeightFunc: () => number = (): number => {
    return 0;
  };
  private item: MediaItem = new MediaItem();
  private dataSource: PhotoDataSource | undefined = undefined;
  // private selectedStatus: visionImageAnalyzer.SelectedStatus = visionImageAnalyzer.SelectedStatus.UNSELECTED;
  // private selectedStatusOnGestureJudge: visionImageAnalyzer.SelectedStatus =
  //   visionImageAnalyzer.SelectedStatus.UNSELECTED;
  private selectedChangeStatus: boolean = false;
  private enableAnalyzer: boolean = true;
  private isCurrent: boolean = false;
  // 大图显示控件宽度
  private componentWidth: number = vp2px(getScreen().getWinLayoutWidth());
  // 大图显示控件高度
  private componentHeight: number = vp2px(getScreen().getWinLayoutHeight());
  private videoComponentSizeInfo: ComponentSizeInfo = {
    componentWidth: 0,
    componentHeight: 0,
    componentPositionX: 0,
    componentPositionY: 0,
  }
  private overlayWidth: number = 0;
  private overlayHeight: number = 0;
  private overlayVisible: boolean = true;
  private canShowAIButton: boolean = true;
  private isShowBar: boolean = true;
  private matrix: Matrix4.Matrix4Transit = Matrix4.identity().copy();
  private isHorizontal: boolean = isOrientationHorizontal();
  private isAbuttonSelected: boolean = false;
  // 主体分割相关
  // private subjectObject: visionImageAnalyzer.Subject[] = [];
  private isSelectedSubjectChange: boolean = false;
  // 文字识别相关
  private selectText: string = '';
  private isSelectedTextChange: boolean = false;
  private aiButtonPositionX: number = AI_BUTTON_DEFAULT_OFFSET;
  private aiButtonPositionY: number = AI_BUTTON_DEFAULT_OFFSET;
  private preGestureType: GestureControl.GestureType = GestureControl.GestureType.TAP_GESTURE;
  private broadCast: BroadCast | undefined;

  // constructor(xComponentController: XComponentController | undefined, handleAiOverlayChangedFunc: Function,
  //   calcBarBottomHeightFunc: () => number, controller?: visionImageAnalyzer.VisionImageAnalyzerController) {
  //   this.xComponentController = xComponentController;
  //   this.handleAiOverlayChangedFunc = handleAiOverlayChangedFunc;
  //   this.calcBarBottomHeightFunc = calcBarBottomHeightFunc;
  //   this.controller = controller;
  // }

  public init(item: MediaItem, dataSource: PhotoDataSource | undefined, isShowBar: boolean,
    broadCast: BroadCast): void {
    if (!this.enableAnalyzer) {
      return;
    }
    if (this.isCurrent && this.item.uri === item.uri) {
      this.updateItem(item.uri);
      this.onVisibilityChangeCallback();
      return;
    }
    this.componentWidth = vp2px(getScreen().getWinLayoutWidth());
    this.componentHeight = vp2px(getScreen().getWinLayoutHeight());
    this.item = item;
    this.dataSource = dataSource;
    this.isCurrent = true;
    this.isShowBar = isShowBar;
    this.canShowAIButton = isShowBar;
    this.broadCast = broadCast;
    Log.info(TAG, `ImageAnalyzerAdaptor init, uri = ${item.uri}, this.item.uri = ${
    this.item.uri}, isCurrent = ${this.isCurrent}, isShowBar = ${this.isShowBar}, canShowAIButton = ${
    this.canShowAIButton}`);
    this.addListener();
  }

  public deinit(): void {
    if (!this.isCurrent || !this.enableAnalyzer) {
      return;
    }
    this.initParams();
    this.stopVideoAnalyzer();
    this.removeListener();
  }

  private addListener(): void {
    this.broadCast?.on(BroadCastConstants.VIDEO_START_AI_ANALYZER, this.startAnalyzer);
    this.broadCast?.on(BroadCastConstants.VIDEO_STOP_AI_ANALYZER, this.stopAnalyzer);
    // this.controller?.on('selectedStatusChange', (status: visionImageAnalyzer.SelectedStatus) => {
    //   this.onSelectedStatusChanged(status);
    // })
    // this.controller?.on('aiButtonStatusChange', (status: visionImageAnalyzer.AIButtonStatus) => {
    //   this.onAIButtonStatusChanged(status);
    // })
    // this.controller?.on('selectedTextChange', (text: string) => {
    //   this.onTextSelected(text);
    // });
    // this.controller?.on('selectedSubjectsChange', (data: visionImageAnalyzer.Subject[]): void => {
    //   this.onSelectedSubjectsChanged(data);
    // });
  }

  private removeListener(): void {
    this.broadCast?.off(BroadCastConstants.VIDEO_START_AI_ANALYZER, this.startAnalyzer);
    this.broadCast?.off(BroadCastConstants.VIDEO_STOP_AI_ANALYZER, this.stopAnalyzer);
    // this.controller?.off('aiButtonStatusChange');
    // // this.controller?.off('selectedStatusChange');
    // this.controller?.off('selectedTextChange');
    // this.controller?.off('selectedSubjectsChange');
  }

  private initParams(): void {
    // this.selectedStatus = visionImageAnalyzer.SelectedStatus.UNSELECTED;
    // this.selectedStatusOnGestureJudge = visionImageAnalyzer.SelectedStatus.UNSELECTED;
    this.selectedChangeStatus = false;
    this.isCurrent = false;

    this.overlayWidth = 0;
    this.overlayHeight = 0;
    this.overlayVisible = true;
    this.canShowAIButton = true;
    this.isShowBar = true;
    this.matrix = Matrix4.identity().copy();
    this.isHorizontal = isOrientationHorizontal();
    this.isAbuttonSelected = false;

    // 主体分割相关
    // this.subjectObject = [];
    this.isSelectedSubjectChange = false;

    // 文字识别相关
    this.selectText = '';
    this.isSelectedTextChange = false;
    this.aiButtonPositionX = AI_BUTTON_DEFAULT_OFFSET;
    this.aiButtonPositionY = AI_BUTTON_DEFAULT_OFFSET;
  }

  public updateItem(uri: string): void {
    if (!this.enableAnalyzer) {
      return;
    }
    let item: MediaItem | undefined = this.dataSource?.getItemByUri(uri);
    if (!item) {
      return;
    }
    if (this.isCurrent && this.item.uri === item.uri && this.item.dateModified === item.dateModified) {
      this.item = item;
      return;
    }
    Log.info(TAG, `ImageAnalyzerAdaptor updateItem, uri = ${this.item.uri}, isCurrent = ${
    this.isCurrent}, new DateModified = ${item.getDateModified()}, old DateModified = ${this.item.dateModified}`);
    this.item = item;
  }

  public setEnableAnalyzer(enableAnalyzer: boolean): void {
    this.enableAnalyzer = enableAnalyzer;
  }

  public startVideoAnalyzer(): void {
    if (!this.enableAnalyzer) {
      return;
    }
    this.onVisibilityChangeCallback();
    this.calculateOverlaySize();
    this.calcAIButtonOffset();
    try {
      if (!this.isVideoAnalyzer) {
        let imageAnalyzerConfig: ImageAnalyzerConfig = {
          types: [AnalyzerUtil.SUBJECT_TYPE, AnalyzerUtil.TEXT_TYPE, AnalyzerUtil.SEARCH_TYPE],
        };
        let startAnalyzer: Promise<void> | undefined =
          this.xComponentController?.startImageAnalyzer(imageAnalyzerConfig);
        this.xComAnalyzerController = startAnalyzer?.then(() => {
          Log.info(TAG, 'pause and start analyzer');
          this.isVideoAnalyzer = true;
          // this.controller?.setAIButtonVisibility(true);
          // this.controller?.setImageAnalyzerVisibility(visionImageAnalyzer.ImageAnalyzerVisibility.SHOWN);
          // this.controller?.setAIButtonPosition(this.getAIButtonOffset());
        })
      }
    } catch (error) {
      Log.error(TAG, 'analyzer start error');
    }
  }

  public stopVideoAnalyzer(): void {
    if (!this.enableAnalyzer) {
      return;
    }
    if (this.isVideoAnalyzer) {
      this.xComAnalyzerController?.then(() => {
        try {
          Log.info(TAG, `play and stop analyzer${this.isVideoAnalyzer}`);
          this.xComponentController?.stopImageAnalyzer();
          this.isVideoAnalyzer = false;
        } catch (error) {
          Log.error(TAG, 'analyzer stop error');
        }
      })
    }
  }

  public setComponentSize(componentWidth: number, componentHeight: number): void {
    if (!this.enableAnalyzer) {
      return;
    }
    this.componentWidth = componentWidth;
    this.componentHeight = componentHeight;
    Log.info(TAG, `setComponentSize: ${this.componentWidth}, ${this.componentHeight}`);
    if (!this.isCurrent) {
      return;
    }
    this.calculateOverlaySize();
    this.setAiButtonOffset();
  }

  private getRatio(): number {
    if (this.item.width * this.item.height * this.componentWidth * this.componentHeight === 0) {
      return 1;
    }
    return this.item.width / this.item.height / (this.componentWidth / this.componentHeight);
  };

  private isResourceSmaller(): boolean {
    return (DeviceInfo.isPc() && this.item.width < this.componentWidth && this.item.height < this.componentHeight);
  }

  private calculateOverlaySize(): void {
    if (!this.item) {
      return;
    }
    if (this.item.width && this.item.height) {
      // 缩略图的宽高未重新计算，这里计算一下
      if (this.isResourceSmaller()) {
        this.overlayWidth = this.item.width;
        this.overlayHeight = this.item.height;
        return;
      }
      if (this.getRatio() > 1) {
        this.overlayWidth = this.componentWidth;
        this.overlayHeight = this.item.height * (this.overlayWidth / this.item.width);
        return;
      }
      this.overlayHeight = this.componentHeight;
      this.overlayWidth = this.item.width * (this.overlayHeight / this.item.height);
      return;
    }
    this.overlayWidth = BrowserConstants.DEFAULT_SIZE;
    this.overlayHeight = BrowserConstants.DEFAULT_SIZE;
  }

  private calcAIButtonOffset(): void {
    let xPosition: number = AI_BUTTON_DEFAULT_OFFSET;
    let yPosition: number = AI_BUTTON_DEFAULT_OFFSET;
    let mat: number[] | undefined = (this.matrix.copy() as Matrix4x4).matrix4x4;
    if (!this.isCurrent) {
      return;
    }
    if (!mat) {
      Log.error(TAG, `mat is ${String(mat)}`);
      this.aiButtonPositionX = xPosition;
      this.aiButtonPositionY = yPosition;
      return;
    }
    let scale: number = mat[0];
    let horizontalOffset: number = mat[12];
    let verticalOffset: number = mat[13];

    let overlayDisplayWidth: number = this.overlayWidth * scale;
    let overlayDisplayHeight: number = this.overlayHeight * scale;

    let bottomHeight: number = this.isShowBar ? this.calcBarBottomHeightFunc() : 0;
    if (overlayDisplayWidth > this.componentWidth) {
      overlayDisplayWidth = this.componentWidth;
    }
    if (overlayDisplayHeight > this.componentHeight) {
      overlayDisplayHeight = this.componentHeight;
    }
    let yDelta = px2vp((this.componentHeight - overlayDisplayHeight) / HALF_DIVIDER);
    if (yDelta > bottomHeight || DeviceInfo.isPc()) {
      yPosition = this.getAButtonDefaultPosition();
    } else {
      yPosition = this.getAButtonDefaultPosition() + bottomHeight - yDelta;
    }
    yPosition -= px2vp((overlayDisplayHeight - this.overlayHeight) / HALF_DIVIDER);
    xPosition = this.getAButtonDefaultPosition() - px2vp((overlayDisplayWidth - this.overlayWidth) / HALF_DIVIDER);
    Log.info(TAG, `calcAIButtonOffset, uri = ${this.item.uri}, this.overlayWidth = ${
    this.overlayWidth}, this.overlayHeight = ${this.overlayHeight}, scale = ${scale}, overlayDisplayWidth = ${
    overlayDisplayWidth}, overlayDisplayHeight = ${overlayDisplayHeight}, this.componentWidth = ${
    this.componentWidth}, this.componentHeight = ${this.componentHeight}, bottomHeight = ${
    bottomHeight}, yDelta = ${yDelta}, xPosition = ${xPosition}, yPosition = ${yPosition}`);
    this.aiButtonPositionX = xPosition;
    this.aiButtonPositionY = yPosition;
  }

  public setAiButtonOffset(): void {
    this.calcAIButtonOffset();
    // this.controller?.setAIButtonPosition(this.getAIButtonOffset());
  }

  private getAButtonDefaultPosition(): number {
    /* instrument ignore next */
    if (DeviceInfo.isPc()) {
      return AI_BUTTON_DEFAULT_OFFSET_MIDDLE;
    }
    return AI_BUTTON_DEFAULT_OFFSET;
  }

  // private getAIButtonOffset(): visionImageAnalyzer.Rect {
  //   return {
  //     left: this.aiButtonPositionX,
  //     right: DeviceInfo.isPhoneOrTablet() ?
  //       this.aiButtonPositionX + AI_BUTTON_VIDEO_RIGHT_OFFSET : this.aiButtonPositionX,
  //     bottom: this.aiButtonPositionY,
  //   };
  // }

  public setXComponentController(mXComponentController: XComponentController): void {
    this.xComponentController = mXComponentController;
  }

  public isSelectedStatusOnGestureJudge(): boolean {
    if (!this.enableAnalyzer) {
      return false;
    }
    return false;
    // return this.selectedStatusOnGestureJudge === visionImageAnalyzer.SelectedStatus.SELECTED;
  }

  public unselectedStatus(): void {
    if (!this.enableAnalyzer) {
      return;
    }
    // Log.info(TAG,
    //   `unselectedStatusInner this.selectedStatus = ${
    //   this.selectedStatus}, selectedStatusOnGestureJudge = ${this.selectedStatusOnGestureJudge}`);
    // this.selectedStatus = visionImageAnalyzer.SelectedStatus.UNSELECTED;
    this.selectedChangeStatus = false;
  }

  public isSelectedStatus(): boolean {
    if (!this.enableAnalyzer) {
      return false;
    }
    return false;
    // return this.selectedStatus === visionImageAnalyzer.SelectedStatus.SELECTED;
  }

  public onGestureJudgeBegin(gestureInfo: GestureInfo, event: BaseGestureEvent): GestureJudgeResult {
    if (!this.enableAnalyzer) {
      return GestureJudgeResult.CONTINUE;
    }
    let ret: GestureJudgeResult = GestureJudgeResult.CONTINUE;
    // this.selectedStatusOnGestureJudge = this.selectedStatus;
    // let isTextDrug: boolean = this.selectedStatus === visionImageAnalyzer.SelectedStatus.SELECTED &&
    // this.isSelectedTextChange && this.preGestureType === GestureControl.GestureType.PAN_GESTURE &&
    //   gestureInfo.type === GestureControl.GestureType.TAP_GESTURE;
    // this.preGestureType = gestureInfo.type;
    // if (!this.checkEventInVideoAnalyzer(event) && !isTextDrug) {
    //   Log.info(TAG, 'onGestureJudgeBegin, gesture is not in videoAnalyzer, return GestureJudgeResult.CONTINUE');
    //   return ret;
    // }
    Log.info(TAG, 'onGestureJudgeBegin, gesture is in videoAnalyzer');
    if (this.selectedChangeStatus) {
      this.selectedChangeStatus = false;
      if (gestureInfo.type === GestureControl.GestureType.TAP_GESTURE) {
        ret = GestureJudgeResult.REJECT;
      }
    }
    if (this.isSelectedSubjectChange) {
      this.isSelectedSubjectChange = false;
      if (gestureInfo.type === GestureControl.GestureType.TAP_GESTURE) {
        ret = GestureJudgeResult.REJECT;
      }
    }
    // else if (this.subjectObject.length > 0) {
    //   if (gestureInfo.type === GestureControl.GestureType.TAP_GESTURE) {
    //     ret = GestureJudgeResult.REJECT;
    //   }
    // }
    if (this.selectText.length > 0) {
      if (gestureInfo.type !== GestureControl.GestureType.PINCH_GESTURE) {
        ret = GestureJudgeResult.REJECT;
      }
    }
    // if (this.selectedStatus === visionImageAnalyzer.SelectedStatus.SELECTED) {
    //   if (gestureInfo.type === GestureControl.GestureType.PAN_GESTURE) {
    //     ret = GestureJudgeResult.REJECT;
    //   }
    // }
    Log.info(TAG, `onGestureJudgeBegin ret = ${ret}`);
    return ret;
  }

  public setVideoComponentArea(value: Area): void {
    let videoWidth: Length = value.width;
    let videoHeight: Length = value.height;
    let globalPositionX: Length | undefined = value.globalPosition.x;
    let globalPositionY: Length | undefined = value.globalPosition.y;
    if (typeof videoWidth === 'number' && typeof videoHeight === 'number') {
      this.videoComponentSizeInfo.componentWidth = videoWidth;
      this.videoComponentSizeInfo.componentHeight = videoHeight;
    }
    if (typeof globalPositionX === 'number' && typeof globalPositionY === 'number') {
      this.videoComponentSizeInfo.componentPositionX = globalPositionX;
      this.videoComponentSizeInfo.componentPositionY = globalPositionY;
    }
  }

  public setMatrix(matrix: Matrix4.Matrix4Transit): void {
    if (!this.enableAnalyzer) {
      return;
    }
    this.matrix = matrix;
    Log.info(TAG, `video matrix: ${this.matrix}`);
    if (this.overlayVisible === false) {
      return;
    }
    // this.controller?.setAIButtonPosition(this.getAIButtonOffset());
  }

  public setOverlayVisible(overlayVisible: boolean): void {
    if (this.enableAnalyzer === false) {
      return;
    }
    if (this.overlayVisible === overlayVisible) {
      return;
    }
    this.overlayVisible = overlayVisible;
    Log.info(TAG, `video setOverlayVisible: ${this.overlayVisible}, ${this.item.uri}`);
    // this.controller?.setImageAnalyzerVisibility(this.overlayVisible ?
    // visionImageAnalyzer.ImageAnalyzerVisibility.SHOWN : visionImageAnalyzer.ImageAnalyzerVisibility.HIDDEN);
  }

  public setHorizontal(isHorizontal: boolean): void {
    if (!this.enableAnalyzer) {
      return;
    }
    if (this.isHorizontal === isHorizontal) {
      return;
    }
    this.isHorizontal = isHorizontal;
    Log.info(TAG, `setHorizontal: ${this.isHorizontal}`);
    if (!this.isCurrent) {
      return;
    }
    this.setAiButtonOffset();
  }

  public setShowBar(flag: boolean): void {
    if (!this.enableAnalyzer) {
      return;
    }
    this.isShowBar = flag;
    if (!this.isAbuttonSelected) {
      this.canShowAIButton = flag;
      // this.controller?.setAIButtonVisibility(false);
    }
    if (flag) {
      // this.controller?.setAIButtonVisibility(true);
    }
    Log.info(TAG, `setShowBar: ${this.isShowBar}, canShowAIButton = ${
    this.canShowAIButton}, isAbuttonSelected: ${this.isAbuttonSelected}`);
    this.setAiButtonOffset();
    // this.controller?.setAIButtonVisibility(this.canShowAIButton);
  }

  private checkEventInVideoAnalyzer(event: BaseGestureEvent): boolean {
    let fingerList: FingerInfo[] = isFilterListEmpty(event.fingerList);
    if (AnalyzerUtil.isFingerListEmpty(fingerList)) {
      return false;
    }
    let scale: number = AnalyzerUtil.getScale(this.matrix);
    return AnalyzerUtil.isFingerInComponent(this.videoComponentSizeInfo, scale, fingerList);
  }

  // 文字是否选中的监听
  private onTextSelected(data: string): void {
    Log.info(TAG, `onTextSelected data = ${data.length}`);
    if (this.selectText.length > 0 && data.length > 0) {
      this.isSelectedTextChange = true;
    }
    this.selectText = data ? data : '';
  }

  // 主体是否选中的监听
  // private onSelectedSubjectsChanged(data: visionImageAnalyzer.Subject[]): void {
  //   // this.subjectObject = data;
  //   this.isSelectedSubjectChange = true;
  //   Log.info(TAG, `onSelectedSubjectsChanged, isSelectedSubjectChange: ${this.isSelectedSubjectChange}`);
  //   return;
  // }

  // private onSelectedStatusChanged(status: visionImageAnalyzer.SelectedStatus): void {
  //   if (!this.enableAnalyzer) {
  //     return;
  //   }
    // let preSelectStatus: visionImageAnalyzer.SelectedStatus = this.selectedStatus;
    // this.selectedStatus = status;
    // this.selectedChangeStatus = this.checkSelectStatusChanged(preSelectStatus);
    // if (this.selectedChangeStatus) {
    //   this.handleAiOverlayChangedFunc();
    // }
  // }

  // private onAIButtonStatusChanged(aiButtonStatus: visionImageAnalyzer.AIButtonStatus): void {
  //   Log.info(TAG, `onAIButtonStatusChanged , status = ${aiButtonStatus}`);
  //   this.isAbuttonSelected = aiButtonStatus === AIButtonStatus.SELECTED;
  // }

  // private checkSelectStatusChanged(preSelectStatus: visionImageAnalyzer.SelectedStatus): boolean {
  //   if (preSelectStatus === visionImageAnalyzer.SelectedStatus.SELECTED) {
  //     if (this.selectedStatus !== visionImageAnalyzer.SelectedStatus.SELECTED) {
  //       return true;
  //     }
  //   }
  //   if (preSelectStatus !== visionImageAnalyzer.SelectedStatus.SELECTED) {
  //     if (this.selectedStatus === visionImageAnalyzer.SelectedStatus.SELECTED) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  public getCanShowAIButton(): boolean {
    return this.canShowAIButton;
  }
}