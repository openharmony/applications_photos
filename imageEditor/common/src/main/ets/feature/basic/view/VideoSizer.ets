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
import { copyAttrTo } from '../../../common/util/misc';
import { ScreenSizer } from '../../../common/components/FrostedGlass';
import { App, BaseEditor, TabName } from '../../../service/App';
import { CropAttr } from '../../../service/BaseEditor';
import { CropType } from '../../../service/model/CropModel';
import { SCREEN_ORIENTATION_PORTRAIT, ANIMATION_DURATION } from '../../../common/const';
import { ScreenManager } from '../../../common/util/ScreenManager';
import { TextAreaManager } from '../../../service/model/tabTextEdit/viewModel/TabTextAreaManager';
import { TextEditAttr } from '../../../service/model/menu/TextEditAttr';
import { HiLog } from '../../../common/util/HiLog';
import {
  ApsUtil,
  APS_SCENE_STATE_ON,
  APS_SCENE_STATE_OFF,
  PHOTO_BUNDLE_NAME,
  PHOTO_IN_EDIT_CROP
} from '../../../common/util/ApsUtil';

const  TAG: string = 'VideoSizer';
const GESTURE_FLUSH_INTERVAL_MS: number = 16;

@Component
export struct VideoSizer {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State crop: CropAttr = App.getInstance().myEditor().asset.crops();
  @State hasSplitLine: boolean = App.getInstance()
    .myEditor()
    .asset
    .crops()
    .hasSplitLine;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) isScreenPortrait: boolean = ScreenManager.getInstance().isScreenPortrait();
  // 是否需要直接显示个性风格调色盘, 由演示APP拉起图库跳转编辑的场景会被置成true, 正常从大图进编辑时值为false
  @StorageLink('is_entry_XTStyle') showXTStyleDirectly: boolean = false;
  private gestureFlushTimer: number = -1;
  private pendingPanX: number = 0;
  private pendingPanY: number = 0;
  private pendingScaleRatio: number = 1;
  private pendingScaleCenterX: number = 0;
  private pendingScaleCenterY: number = 0;
  private isDragImageEnabled: boolean = false;

  aboutToDisappear(): void {
    this.resetGestureBuffer();
    this.setDragImageState(false);
    HiLog.i(TAG, 'aboutToDisappear, close setApsSceneState begin.');
    ApsUtil.setApsSceneState(PHOTO_BUNDLE_NAME, PHOTO_IN_EDIT_CROP, APS_SCENE_STATE_OFF);
    HiLog.i(TAG, 'aboutToDisappear, close setApsSceneState end.');
  }

  /* instrument ignore file */
  build() {
    Column() {
      if (!this.crop.isRotateAndMirrorStatus && !this.editor.isInTextArea) {
        ScreenSizer({
          maxWidth: this.editor.timeline.operWidth,
          maxHeight: this.editor.timeline.operHeight,
          clipSize: this.editor.asset.crops().cropRect,
          onSizing: this.sizing,
          onSizeEnd: this.sizeEnd,
          onPanGestureMove: this.panGestureMove,
          onPinchGestureScale: this.pinchGestureScale,
          onGestureEnd: this.gestureEnd,
          clipVisible: this.editor.tabIndex == TabName.TabCrop,
          isRotateAndMirrorStatus: this.crop.isRotateAndMirrorStatus,
          hasSplitLine: this.crop.hasSplitLine,
          isStopOperating: this.crop.isScrolling,
          isRecordOperating: this.editor.tabIndex === TabName.TabCrop,
        })
      }
    }
    .visibility(this.showXTStyleDirectly ? Visibility.Hidden : Visibility.Visible)
    .id('video_sizer_area')
    .position({ x: 0, y: 0 })
    .width('100%')
    .enabled(!this.editor.isInTextArea && !this.editor.apertureMode)
  }

  private enterRealtimeOperationState(showSplitLine: boolean = true): void {
    this.clearTimeout();
    this.setDragImageState(true);
    const crops = this.editor.asset.crops();
    if (crops.isEnableBlur) {
      crops.isEnableBlur = false;
    }
    if (showSplitLine && this.editor.tabIndex === TabName.TabCrop) {
      crops.animateShowSplitLine(true);
    }
    if (!this.editor.timeline.timeProgressImmersiveMode) {
      this.editor.timeline.timeProgressImmersiveMode = true;
    }
    if (!this.editor.operationTip.immersiveMode) {
      this.editor.operationTip.immersiveMode = true;
    }
  }

  private setDragImageState(enabled: boolean): void {
    if (this.isDragImageEnabled === enabled) {
      return;
    }
    this.isDragImageEnabled = enabled;
    this.editor.asset.setIsDragImage(enabled);
  }

  private hasPendingGestureOperation(): boolean {
    return this.pendingPanX !== 0 || this.pendingPanY !== 0 || this.pendingScaleRatio !== 1;
  }

  private scheduleGestureFlush(): void {
    if (this.gestureFlushTimer !== -1) {
      return;
    }
    this.gestureFlushTimer = setTimeout((): void => {
      this.gestureFlushTimer = -1;
      this.flushGestureOperations();
      if (this.hasPendingGestureOperation()) {
        this.scheduleGestureFlush();
      }
    }, GESTURE_FLUSH_INTERVAL_MS);
  }

  private flushGestureOperations(): void {
    if (this.pendingPanX !== 0 || this.pendingPanY !== 0) {
      this.editor.asset.translate(vp2px(this.pendingPanX), vp2px(this.pendingPanY));
      this.pendingPanX = 0;
      this.pendingPanY = 0;
    }
    if (this.pendingScaleRatio !== 1) {
      this.editor.asset.scale(this.pendingScaleRatio, vp2px(this.pendingScaleCenterX), vp2px(this.pendingScaleCenterY));
      this.pendingScaleRatio = 1;
    }
  }

  private resetGestureBuffer(): void {
    if (this.gestureFlushTimer !== -1) {
      clearTimeout(this.gestureFlushTimer);
      this.gestureFlushTimer = -1;
    }
    this.pendingPanX = 0;
    this.pendingPanY = 0;
    this.pendingScaleRatio = 1;
    this.pendingScaleCenterX = 0;
    this.pendingScaleCenterY = 0;
  }

  panGestureMove = (movex: number, movey: number): void => {
    this.enterRealtimeOperationState();
    this.pendingPanX += movex;
    this.pendingPanY += movey;
    this.scheduleGestureFlush();
    this.editor.isImageMove = true;
  }
  pinchGestureScale = (ratio: number, centerx: number, centery: number): void => {
    this.enterRealtimeOperationState();
    if (ratio !== 1) {
      this.pendingScaleRatio *= ratio;
      this.pendingScaleCenterX = centerx;
      this.pendingScaleCenterY = centery;
      this.scheduleGestureFlush();
    }
    this.editor.isImageMove = true;
  }
  gestureEnd = (): void => {
    this.flushGestureOperations();
    this.resetGestureBuffer();
    this.setDragImageState(false);
    this.clearTimeout();
    this.editor.interrupt = true;
    this.editor.tabIndex == TabName.TabCrop && this.editor.stopEditorOperate();
    this.editor.imageMove = setTimeout((): void => {
      this.editor.isImageMove = false;
    }, ANIMATION_DURATION)
    if (this.editor.timeline.timeProgressImmersiveMode) {
      this.editor.timeline.timeProgressImmersiveMode = false;
    }
    if (this.editor.operationTip.immersiveMode) {
      this.editor.operationTip.immersiveMode = false;
    }
    this.editor.timeBlur = setTimeout((): void => {
      this.editor.tabIndex == TabName.TabCrop &&
      !this.editor.asset.crops().isEnableBlur &&
      (this.editor.asset.crops().isEnableBlur = true);
      this.editor.interrupt = false;
      if (this.editor.timeline.timeProgressImmersiveMode) {
        this.editor.timeline.timeProgressImmersiveMode = false;
      }
      if (this.editor.operationTip.immersiveMode) {
        this.editor.operationTip.immersiveMode = false;
      }
      this.editor.asset.crops().animateShowSplitLine(false);
    }, 1300);

    this.editor.timeStartZoom = setTimeout((): void => {
      this.crop.isDragCrop && this.sizeAnimate(ANIMATION_DURATION);
      this.crop.isDragCrop = false;
    }, 500)
  }

  private clearTimeout(): void {
    clearTimeout(this.editor.timeStartZoom);
    clearTimeout(this.editor.timeBlur);
    clearTimeout(this.editor.imageMove);
  }

  sizing = (l: number, t: number, r: number, b: number,
    directionLeft: number, directionTop: number, directionRight: number, directionBottom: number,
    pressure: number): boolean => {
    this.flushGestureOperations();
    this.resetGestureBuffer();
    this.crop.isDragCrop = true;
    this.enterRealtimeOperationState();
    // 裁剪单边拖动可移动边设置
    if (this.editor.asset.crops()
      .clipRatio > 0 && (directionLeft + directionTop + directionRight + directionBottom) === 1) {
      if (directionLeft || directionRight) {
        directionTop = 1;
        directionBottom = 1;
      } else if (directionTop || directionBottom) {
        directionLeft = 1;
        directionRight = 1;
      }
    }
    let newCrop = this.editor.asset.getReachableCropRect(l, t, r, b, this.editor.asset.crops().clipRatio,
      directionLeft, directionTop, directionRight, directionBottom, pressure);
    if (newCrop !== undefined) {
      copyAttrTo(newCrop, this.editor.asset.crops().cropRect);
      return true;
    }
    return false;
  }
  sizeEnd = (l: number, t: number, r: number, b: number): void => {
    this.flushGestureOperations();
    this.resetGestureBuffer();
    this.setDragImageState(false);
    clearTimeout(this.editor.timeBlur);
    clearTimeout(this.editor.timeStartZoom);
    this.editor.interrupt = true;
    this.editor.timeBlur = setTimeout((): void => {
      this.editor.tabIndex == TabName.TabCrop &&
      !this.editor.asset.crops().isEnableBlur &&
      (this.editor.asset.crops().isEnableBlur = true);
      if (this.editor.timeline.timeProgressImmersiveMode) {
        this.editor.timeline.timeProgressImmersiveMode = false;
      }
      if (this.editor.operationTip.immersiveMode) {
        this.editor.operationTip.immersiveMode = false;
      }
    }, 1300); // 裁剪恢复后再开高斯模糊，时间轴等显示 == 恢复速度很快，暂定300ms
    //  裁剪结束后等待恢复时长 500ms
    this.editor.timeStartZoom = setTimeout((): void => {
      this.editor.interrupt = false;
      this.editor.asset.crops().animateShowSplitLine(false);
      this.sizeAnimate(ANIMATION_DURATION);
      this.crop.isDragCrop = false;
    }, 500)
  }

  sizeAnimate(aniDuration: number): void {
    HiLog.i(TAG, 'sizeAnimate open setApsSceneState begin');
    ApsUtil.setApsSceneState(PHOTO_BUNDLE_NAME, PHOTO_IN_EDIT_CROP, APS_SCENE_STATE_ON)
    HiLog.i(TAG, 'sizeAnimate open setApsSceneState end');
    this.editor.asset.setClipCropRect(aniDuration, CropType.FRAME_CROP, this.isScreenPortrait);
    this.editor.asset.overSizePrompt();
  }
}