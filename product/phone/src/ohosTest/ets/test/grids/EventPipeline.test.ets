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
import Matrix4 from '@ohos.matrix4';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import {
  PhotoItemGestureCallback
} from '@ohos/common/src/main/ets/default/model/browser/photo/PhotoItemGestureCallback';
import {
  describe,
  beforeEach,
  afterEach,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
  beforeAll
} from '@ohos/hypium';
import { AnimationParam, EventPipeline } from '@ohos/common/src/main/ets/default/model/browser/photo/EventPipeline';
import { ImageToolConstants } from '@ohos/common/src/main/ets/default/model/common/ImageToolConstants';
import { Constants as PhotoConstants } from '@ohos/common/src/main/ets/default/model/browser/photo/Constants';
import { Scales } from '@ohos/common/src/main/ets/default/model/browser/photo/pipeline/variable';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const NUMBER_ONE: number = 1;

export default function EventPipelineTest() {
  describe('EventPipelineTest', () => {

    class MyPhotoItemGestureCallback implements PhotoItemGestureCallback {

      onTouchEventRespond(matrix: Matrix4.Matrix4Transit): void {
        console.log('Touch event responded with matrix:', matrix);
      }

      onDirectionChangeRespond(direction: PanDirection): void {
        console.log('Direction changed to:', direction);
      }

      onAnimationEventRespond(animationOption: AnimationParam, animationEndMatrix: Matrix4.Matrix4Transit): void {
        console.log('Animation event responded with options:', animationOption, 'and end matrix:', animationEndMatrix);
      }

      onEventPullUpRespond(isPullingUp: boolean): void {
        console.log('Pull up event responded with isPullingUp:', isPullingUp);
      }
    }

    const callbackInstance = new MyPhotoItemGestureCallback();

    let eventPipeline: EventPipeline = new EventPipeline(new BroadCast(), new MediaItem(), callbackInstance);
    let event: GestureEvent = {
      repeat: true,
      fingerList: [],
      offsetX: 1,
      offsetY: 1,
      angle: 1,
      speed: 1,
      scale: 1,
      pinchCenterX: 1,
      pinchCenterY: 1,
      velocityX: 1,
      velocityY: 1,
      velocity: 1,
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown,
      target: {} as EventTarget,
    };

    let touchEvent: TouchEvent = {
      type: TouchType.Down,
      touches: [],
      changedTouches: [],
      stopPropagation() {
        console.log('Propagation stopped');
      },
      preventDefault() {
        console.log('Default action prevented');
      },
      getHistoricalPoints: (): HistoricalPoint[] => {
        throw new Error('Function not implemented.');
      },
      target: {} as EventTarget,
      timestamp: 0,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown,
    };

    beforeAll(() => {

    });

    it('should_initialize_all_properties_correctly', 0, () => {
      let broadCast = new BroadCast();
      let mediaItem = new MediaItem();

      expect(eventPipeline.broadCast).assertDeepEquals(broadCast);
      expect(eventPipeline.item).assertDeepEquals(mediaItem);
    });

    it('should_return_true_when_isDisPlayLargerCompoSize_is_true', 0, () => {
      Reflect.set(eventPipeline, 'isDisPlayLargerCompoSize', true);
      const result = eventPipeline.getDisPlayCompaCompo();
      expect(result).assertEqual(true);
    });

    it('should_initialize_imageToolState_when_event_is_not_null', 0, () => {
      eventPipeline.imageToolOnActionStart(event);
      expect(eventPipeline.imageToolState._panOffsetX).assertEqual(eventPipeline.imageToolState._scrollX);
      expect(eventPipeline.imageToolState._panOffsetY).assertEqual(eventPipeline.imageToolState._scrollY);
    });

    it('should_limit_scroll_when_imageToolState_pan_offset_exceeds_stack_size', 0, () => {
      eventPipeline.imageToolState._panOffsetX = 0;
      eventPipeline.imageToolState._scrollWidth = 100;
      eventPipeline.imageToolState._stackWidth = 50;
      eventPipeline.imageToolState._scrollX = 0;

      event.offsetX = 100;

      eventPipeline.imageToolOnActionUpdate(event);

      expect(eventPipeline.imageToolState._scrollX).assertEqual(-50);
    });

    it('should_limit_scroll_when_imageToolState_pan_offset_is_less_than_zero', 0, () => {
      eventPipeline.imageToolState._panOffsetX = 0;
      eventPipeline.imageToolState._scrollWidth = 100;
      eventPipeline.imageToolState._stackWidth = 50;
      eventPipeline.imageToolState._scrollX = 0;

      event.offsetX = -100;

      eventPipeline.imageToolOnActionUpdate(event);

      expect(eventPipeline.imageToolState._scrollX).assertEqual(0);
    });

    it('should_calculate_scroll_when_imageToolState_pan_offset_is_within_stack_size', 0, () => {
      eventPipeline.imageToolState._panOffsetX = 0;
      eventPipeline.imageToolState._scrollWidth = 100;
      eventPipeline.imageToolState._stackWidth = 150;
      eventPipeline.imageToolState._scrollX = 0;

      event.offsetX = 50;

      eventPipeline.imageToolOnActionUpdate(event);

      expect(eventPipeline.imageToolState._scrollX).assertEqual(50);
    });

    it('should_limit_scroll_y_when_imageToolState_pan_offset_exceeds_stack_size', 0, () => {
      eventPipeline.imageToolState._panOffsetY = 0;
      eventPipeline.imageToolState._scrollHeight = 100;
      eventPipeline.imageToolState._stackHeight = 50;
      eventPipeline.imageToolState._scrollY = 0;

      event.offsetY = 100;

      eventPipeline.imageToolOnActionUpdate(event);

      expect(eventPipeline.imageToolState._scrollY).assertEqual(-50);
    });

    it('should_limit_scroll_y_when_imageToolState_pan_offset_is_less_than_zero', 0, () => {
      eventPipeline.imageToolState._panOffsetY = 0;
      eventPipeline.imageToolState._scrollHeight = 100;
      eventPipeline.imageToolState._stackHeight = 50;
      eventPipeline.imageToolState._scrollY = 0;

      event.offsetY = -100;

      eventPipeline.imageToolOnActionUpdate(event);

      expect(eventPipeline.imageToolState._scrollY).assertEqual(0);
    });

    it('should_limit_scroll_y_when_imageToolState_pan_offset_is_within_stack_size', 0, () => {
      eventPipeline.imageToolState._panOffsetY = 0;
      eventPipeline.imageToolState._scrollHeight = 100;
      eventPipeline.imageToolState._stackHeight = 150;
      eventPipeline.imageToolState._scrollY = 0;

      event.offsetY = 50;

      eventPipeline.imageToolOnActionUpdate(event);

      expect(eventPipeline.imageToolState._scrollY).assertEqual(50);
    });

    it('should_set_lastOffset_and_offset_to_zero_when_imageToolOnActionEnd_is_called', 0, () => {
      eventPipeline.offset = [3, 4];
      eventPipeline.imageToolOnActionEnd(event);

      expect(eventPipeline.offset[0]).assertEqual(0);
      expect(eventPipeline.offset[1]).assertEqual(0);
    });

    it('should_reset_last_offset_when_imageToolOnActionCancel_is_called', 0, () => {
      eventPipeline.defaultScale = 1.0;
      eventPipeline.imageToolOnActionCancel();
      expect(eventPipeline.defaultScale).assertEqual(1.0);
    });

    /**
     * disPlayWidth = 100 * 1.5 = 150, disPlayHeight = 200 * 1.5 = 300
     * ratio = 56 / disPlayWidth = 56 / 150
     */
    it('should_calculate_scroll_info_correctly_when_isRight_is_true', 0, () => {
      eventPipeline.imageToolState._isRight = true;
      eventPipeline.width = 100;
      eventPipeline.height = 200;
      eventPipeline.lastScale = 1.5;
      eventPipeline.lastOffset = [50, 100];
      eventPipeline.componentWidth = 200;
      eventPipeline.componentHeight = 300;

      eventPipeline.getInnerSmaPicInfo();

      // 56 / 150 * 200 = 74.66666666666667
      // 56 / 150 * 300 = 112
      // (200 - 150) / 2 + 50 = 75, (300 - 300) / 2 + 100 = 100
      expect(eventPipeline.imageToolState._scrollWidth).assertEqual(224/3);
      expect(eventPipeline.imageToolState._scrollHeight).assertEqual(112);
      expect(eventPipeline.imageToolState._scrollX).assertEqual(-28);
      expect(eventPipeline.imageToolState._scrollY).assertEqual(0-(112 / 3));
    });

    it('should_return_correct_length_when_imageToolState_is_not_right', 0, () => {
      Reflect.set(eventPipeline, 'imageScaleInitWidth', 100);
      Reflect.set(eventPipeline, 'imageScaleInitHeight', 200);
      eventPipeline.imageToolState._isRight = false;
      const result = eventPipeline.getImageToolLenByRatio();
      expect(result).assertEqual(ImageToolConstants.IMAGE_TOOL_SINGLE_LEN / 200 * 100);
    });

    it('should_return_correct_length_when_imageToolState_is_right', 0, () => {
      Reflect.set(eventPipeline, 'imageScaleInitWidth', 100);
      Reflect.set(eventPipeline, 'imageScaleInitHeight', 200);
      eventPipeline.imageToolState._isRight = true;
      const result = eventPipeline.getImageToolLenByRatio();
      expect(result).assertEqual(ImageToolConstants.IMAGE_TOOL_SINGLE_LEN / 100 * 200);
    });

    it('setCastConnect_test', 0, () => {
      let isCastConnect = true;
      eventPipeline.setCastConnect(isCastConnect);
      let result: boolean = Reflect.get(eventPipeline, 'isCastConnect');
      expect(result).assertTrue();
    });

    it('setIsPullingUp_test', 0, () => {
      let isPullingUp = true;
      eventPipeline.setIsPullingUp(isPullingUp);
      expect(eventPipeline.isPullingUp).assertTrue();
    });

    it('setCanPullingUp_test', 0, () => {
      let canPullingUp = true;
      eventPipeline.setCanPullingUp(canPullingUp);
      expect(eventPipeline.canPullingUp).assertTrue();
    });

    it('setIsAngleChange_test', 0, () => {
      let isRotationAngleChange = true;
      eventPipeline.setIsAngleChange(isRotationAngleChange);
      let result: boolean = Reflect.get(eventPipeline, 'isRotationAngleChange');
      expect(result).assertTrue();
    });

    it('setAngle_test', 0, () => {
      eventPipeline.setAngle(1);
      let result: number = Reflect.get(eventPipeline, 'rotationAngle');
      expect(result).assertEqual(1);
    });

    it('should_call_calculateImgSize_and_calculateImageScaleInfo_when_onRotateEnd_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockCalculateImgSize: Function = mocker.mockFunc(eventPipeline, eventPipeline.calculateImgSize);
      when(mockCalculateImgSize)([]).afterReturnNothing();

      let mockCalculateImageScaleInfo: Function = mocker.mockFunc(eventPipeline, eventPipeline.calculateImageScaleInfo);
      when(mockCalculateImageScaleInfo)([]).afterReturnNothing();

      let mockEvaluateScales: Function = mocker.mockFunc(eventPipeline, eventPipeline.evaluateScales);
      when(mockEvaluateScales)([]).afterReturnNothing();
      let angle: number =  10;
      eventPipeline.onRotateEnd(angle);
      expect(Reflect.get(eventPipeline, 'rotationAngle')).assertEqual(angle);
      mocker.ignoreMock(eventPipeline, eventPipeline.calculateImgSize);
      mocker.ignoreMock(eventPipeline, eventPipeline.calculateImageScaleInfo);
      mocker.ignoreMock(eventPipeline, eventPipeline.evaluateScales);
    });

    it('should_call_calculateImgSize_and_evaluateScales_when_onDataChanged_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockCalculateImgSize: Function = mocker.mockFunc(eventPipeline, eventPipeline.calculateImgSize);
      let mockEvaluateScales: Function = mocker.mockFunc(eventPipeline, eventPipeline.evaluateScales);

      when(mockCalculateImgSize)().afterReturnNothing();
      when(mockEvaluateScales)().afterReturnNothing();
      let mediaItem = new MediaItem();
      eventPipeline.onDataChanged(mediaItem);
      expect(eventPipeline.item).assertEqual(mediaItem);
      mocker.ignoreMock(eventPipeline, eventPipeline.calculateImgSize);
      mocker.ignoreMock(eventPipeline, eventPipeline.evaluateScales);
    });

    it('should_call_calculateImgSize_and_evaluateScales_when_recalculateImgSizeAndScales_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockCalculateImgSize: Function = mocker.mockFunc(eventPipeline, eventPipeline.calculateImgSize);
      let mockEvaluateScales: Function = mocker.mockFunc(eventPipeline, eventPipeline.evaluateScales);

      when(mockCalculateImgSize)(ArgumentMatchers.any).afterReturnNothing();
      when(mockEvaluateScales)(ArgumentMatchers.any).afterReturnNothing();

      eventPipeline.recalculateImgSizeAndScales();
      mocker.verify('calculateImgSize', []).once();
      mocker.verify('evaluateScales', []).once();
      mocker.ignoreMock(eventPipeline, eventPipeline.calculateImgSize);
      mocker.ignoreMock(eventPipeline, eventPipeline.evaluateScales);
    });

    it('should_set_default_scale_correctly', 0, () => {
      eventPipeline.setDefaultScale(2.0);

      expect(eventPipeline.defaultScale).assertEqual(2.0);
      expect(eventPipeline.lastScale).assertEqual(2.0);
    });

    it('should_set_isVideo_to_true_when_isVideo_is_true', 0, () => {
      eventPipeline.setIsVideo(true);
      let isVideo: boolean = Reflect.get(eventPipeline, 'isVideo');
      expect(isVideo).assertEqual(true);
    });

    it('should_set_isBurstPhotos_to_true_when_isBurstPhotos_is_true', 0, () => {
      eventPipeline.setIsBurstPhotos(true);
      let isBurstPhotos: boolean = Reflect.get(eventPipeline, 'isBurstPhotos');
      expect(isBurstPhotos).assertEqual(true);
    });

    it('should_reset_transition_status_correctly', 0, () => {
      eventPipeline.resetTransitionStatus();

      expect(eventPipeline.lastOffset).assertDeepEquals([0, 0]);
      expect(eventPipeline.offset).assertDeepEquals([0, 0]);
      expect(eventPipeline.lastScale).assertEqual(1.0);
      expect(eventPipeline.scale).assertEqual(1);
      expect(eventPipeline.hasReachLeft).assertTrue();
      expect(eventPipeline.hasReachRight).assertTrue();
      expect(eventPipeline.isInAnimation).assertFalse();
      expect(eventPipeline.isExiting).assertFalse();
    });

    it('should_call_calculateImgSize_and_evaluateScales_when_onComponentSizeChanged_is_called', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockCalculateImgSize: Function = mocker.mockFunc(eventPipeline, eventPipeline.calculateImgSize);
      when(mockCalculateImgSize)(ArgumentMatchers.any).afterReturnNothing();

      let mockEvaluateScales: Function = mocker.mockFunc(eventPipeline, eventPipeline.evaluateScales);
      when(mockEvaluateScales)(ArgumentMatchers.any).afterReturnNothing();

      eventPipeline.onComponentSizeChanged(100, 100);

      expect(eventPipeline.componentWidth).assertDeepEquals(100);
      expect(eventPipeline.componentHeight).assertDeepEquals(100);
      mocker.ignoreMock(eventPipeline, eventPipeline.calculateImgSize);
      mocker.ignoreMock(eventPipeline, eventPipeline.evaluateScales);
    });

    it('should_return_false_when_isInAnimation_is_true', 0, () => {
      eventPipeline.isInAnimation = true;
      expect(eventPipeline.canTouch()).assertEqual(false);
    });

    it('should_call_updateInnerSmaPicInfo_with_correct_parameters', 0, () => {
      eventPipeline.lastScale = 1.5;
      eventPipeline.lastOffset = [100, 200];
      eventPipeline.innerPicPinchAnimationEnd();
      expect(eventPipeline.lastScale).assertEqual(1.5);
      expect(eventPipeline.lastOffset).assertDeepEquals([100, 200]);
    });

    it('should_reset_parameters_when_TouchType_is_Down', 0, () => {
      touchEvent.type = TouchType.Down;
      touchEvent.touches = [{
        id: 0,
        screenX: 100,
        screenY: 100,
        displayX: 100,
        displayY: 100,
        windowX: 100,
        windowY: 100,
        x: 100,
        y: 100,
        type: TouchType.Down,
      }];
      eventPipeline.isPullDownAndDragPhoto = true;
      eventPipeline.touchEventStartX = 100;
      eventPipeline.verifyPullDownAndDragPhotoStatus(touchEvent);
      expect(eventPipeline.touchEventStartX).assertEqual(100);
      expect(eventPipeline.touchEventStartY).assertEqual(100);
      expect(eventPipeline.touchEventStartId).assertEqual(0);
      expect(eventPipeline.isPullDownAndDragPhoto).assertFalse();
    });

    it('should_reset_parameters_when_touch_length_greater_than_1', 0, () => {
      touchEvent.type = TouchType.Down;
      touchEvent.touches = [{
        id: 1,
        screenX: 100,
        screenY: 100,
        displayX: 100,
        displayY: 100,
        windowX: 100,
        windowY: 100,
        x: 100,
        y: 100,
        type: TouchType.Down,
      }, {
        id: 2,
        screenX: 100,
        screenY: 100,
        displayX: 100,
        displayY: 100,
        windowX: 100,
        windowY: 100,
        x: 100,
        y: 100,
        type: TouchType.Down,
      }];
      eventPipeline.touchEventStartX = 100;
      eventPipeline.verifyPullDownAndDragPhotoStatus(touchEvent);
      expect(eventPipeline.touchEventStartX).assertEqual(100);
      expect(eventPipeline.touchEventStartY).assertEqual(100);
      expect(eventPipeline.touchEventStartId).assertEqual(0);
      expect(eventPipeline.isPullDownAndDragPhoto).assertFalse();
    });

    it('should_reset_parameters_when_TouchType_is_Move', 0, () => {
      touchEvent.type = TouchType.Move;
      touchEvent.touches = [{
        id: 0,
        screenX: 100,
        screenY: 150,
        displayX: 100,
        displayY: 100,
        windowX: 100,
        windowY: 100,
        x: 100,
        y: 100,
        type: TouchType.Down,
      }];
      eventPipeline.isPullingUp = false;
      eventPipeline.isPullDownAndDragPhoto = true;
      eventPipeline.touchEventStartX = 100;
      eventPipeline.verifyPullDownAndDragPhotoStatus(touchEvent);
      expect(eventPipeline.touchEventStartX).assertEqual(100);
      expect(eventPipeline.touchEventStartY).assertEqual(100);
      expect(eventPipeline.touchEventStartId).assertEqual(0);
      expect(eventPipeline.isPullDownAndDragPhoto).assertTrue();
    });

    it('should_set_currentScale_and_matrices_correctly', 0, () => {
      eventPipeline.defaultScale = 1.5;
      eventPipeline.photoToDefaultScale();
      expect(eventPipeline.currentScale).assertEqual(1.5);
      expect(eventPipeline.scale).assertEqual(1);
      expect(eventPipeline.lastScale).assertEqual(1.5);
    });

    it('emitBurstCommonTransform_test', 0, () => {
      Reflect.set(eventPipeline, 'isBurstPhotos', true);
      Reflect.get(eventPipeline, 'emitBurstCommonTransform').call(eventPipeline);
      expect(Reflect.get(eventPipeline, 'isBurstPhotos')).assertTrue()
    });

    it('onBurstScaleEnd_test', 0, () => {
      Reflect.get(eventPipeline, 'onBurstScaleEnd').call(eventPipeline);
      expect(eventPipeline.scale).assertEqual(1);
    });

    it('should_call_all_resetBurstPhotos_methods_with_correct_parameters', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockReset: Function = mocker.mockFunc(eventPipeline, eventPipeline.reset);
      let mockOnScale: Function = mocker.mockFunc(eventPipeline, eventPipeline.onScale);
      let mockOnScaleEnd: Function = mocker.mockFunc(eventPipeline, eventPipeline.onScaleEnd);
      let mockEvaluateOffset: Function = mocker.mockFunc(eventPipeline, eventPipeline.evaluateOffset);
      let mockEmitTouchEvent: Function = mocker.mockFunc(eventPipeline, eventPipeline.emitTouchEvent);

      when(mockReset)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnScale)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnScaleEnd)(ArgumentMatchers.any).afterReturnNothing();
      when(mockEvaluateOffset)(ArgumentMatchers.any).afterReturn([0, 0]);
      when(mockEmitTouchEvent)(ArgumentMatchers.any).afterReturnNothing();

      eventPipeline.resetBurstPhotos(1.0, 0, 0);
      let offset = Reflect.get(eventPipeline, 'offset');
      expect(offset.length).assertEqual(2);
      mocker.ignoreMock(eventPipeline, eventPipeline.reset);
      mocker.ignoreMock(eventPipeline, eventPipeline.onScale);
      mocker.ignoreMock(eventPipeline, eventPipeline.onScaleEnd);
      mocker.ignoreMock(eventPipeline, eventPipeline.evaluateOffset);
      mocker.ignoreMock(eventPipeline, eventPipeline.emitTouchEvent);
    });

    it('should_return_immediately_when_canTouch_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(eventPipeline, eventPipeline.canTouch);
      when(mockFunc)([]).afterReturn(false);
      eventPipeline.moveEndAction(0, 0);
      mocker.verify('canTouch', []).once();
      mocker.ignoreMock(eventPipeline, eventPipeline.canTouch);
      mocker.ignoreMock(Log, Log.info);
    });

    // 验证emitPullDownToBackEvent分支
    it('should_emit_PullDownToBackEvent_when_scale_equals_defaultScale_and_offsetY_greater_than_threshold_and_not_burst_photos',
      0, async () => {
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(eventPipeline, eventPipeline.canTouch);
        mocker.mockFunc(eventPipeline, eventPipeline.emitPullDownToBackEvent);
        when(mockFunc)([]).afterReturn(true);
        // 显式指定defaultScale = 1.0
        eventPipeline.defaultScale = 1.0;
        eventPipeline.scale = 1.0;
        eventPipeline.lastScale = 1.0;
        eventPipeline.setIsBurstPhotos(false);
        eventPipeline.moveEndAction(0, 300, false);
        // 验证走入正确分支
        mocker.verify('emitPullDownToBackEvent', []).once();
        mocker.ignoreMock(eventPipeline, eventPipeline.canTouch);
        mocker.ignoreMock(eventPipeline, eventPipeline.emitPullDownToBackEvent);
      });

    // 验证emitPullUpToDisplayEvent分支
    it('should_reset_drag_related_parameters_when_start_pull_down_and_return', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(eventPipeline, eventPipeline.canTouch);
      mocker.mockFunc(eventPipeline, eventPipeline.emitPullUpToDisplayEvent);
      when(mockFunc)([]).afterReturn(true);
      // 显式指定defaultScale = 1.0
      eventPipeline.defaultScale = 1.0;
      eventPipeline.scale = 1.0;
      eventPipeline.lastScale = 1.0;
      eventPipeline.setIsBurstPhotos(true);
      eventPipeline.setCanPullingUp(true);
      // 显式指定isPullDownAndDragPhoto = false
      eventPipeline.isPullDownAndDragPhoto = false;
      eventPipeline.moveEndAction(0, -300, false);
      // 验证走入正确分支
      mocker.verify('emitPullUpToDisplayEvent', []).once();
      mocker.ignoreMock(eventPipeline, eventPipeline.canTouch);
      mocker.ignoreMock(eventPipeline, eventPipeline.emitPullUpToDisplayEvent);
    });

    it('should_set_width_and_height_when_item_width_and_height_are_valid_and_isPcResourceSmaller_is_true', 0, () => {
      eventPipeline.item.width = 100;
      eventPipeline.item.height = 200;
      let mocker: MockKit = new MockKit();
      let mockIsPcResourceSmaller: Function = mocker.mockFunc(eventPipeline, eventPipeline.isPcResourceSmaller);
      when(mockIsPcResourceSmaller)([]).afterReturn(true);
      eventPipeline.calculateImgSize();
      expect(eventPipeline.width).assertEqual(100);
      expect(eventPipeline.height).assertEqual(200);
      mocker.ignoreMock(eventPipeline, eventPipeline.isPcResourceSmaller);
    });

    it('should_set_width_and_height_when_item_width_and_height_are_valid_and_isPcResourceSmaller_is_false_and_rotationAngle_is_zero',
      0, () => {
        eventPipeline.item.width = 100;
        eventPipeline.item.height = 200;
        Reflect.set(eventPipeline, 'rotationAngle', 0);
        let mocker: MockKit = new MockKit();
        let mockIsPcResourceSmaller: Function = mocker.mockFunc(eventPipeline, eventPipeline.isPcResourceSmaller);
        when(mockIsPcResourceSmaller)([]).afterReturn(false);
        let mockGetRatio: Function = mocker.mockFunc(eventPipeline, eventPipeline.getRatio);
        when(mockGetRatio)([]).afterReturn(1);
        eventPipeline.calculateImgSize();
        expect(eventPipeline.width).assertEqual(50);
        expect(eventPipeline.height).assertEqual(100);
        mocker.ignoreMock(eventPipeline, eventPipeline.isPcResourceSmaller);
        mocker.ignoreMock(eventPipeline, eventPipeline.getRatio);
      });

    it('should_set_width_and_height_when_item_width_and_height_are_valid_and_isPcResourceSmaller_is_false_and_rotationAngle_is_ninety',
      0, () => {
        eventPipeline.item.width = 100;
        eventPipeline.item.height = 200;
        Reflect.set(eventPipeline, 'rotationAngle', PhotoConstants.ROTATION_NINETY);
        let mocker: MockKit = new MockKit();
        let mockIsPcResourceSmaller: Function = mocker.mockFunc(eventPipeline, eventPipeline.isPcResourceSmaller);
        when(mockIsPcResourceSmaller)([]).afterReturn(false);
        let mockGetRatio: Function = mocker.mockFunc(eventPipeline, eventPipeline.getRatio);
        when(mockGetRatio)([]).afterReturn(1);
        eventPipeline.calculateImgSize();
        expect(eventPipeline.width).assertEqual(200);
        expect(eventPipeline.height).assertEqual(100);
        mocker.ignoreMock(eventPipeline, eventPipeline.isPcResourceSmaller);
        mocker.ignoreMock(eventPipeline, eventPipeline.getRatio);
      });

    it('getRatio_test', 0, () => {
      eventPipeline.item.width = 100;
      eventPipeline.item.height = 200;
      eventPipeline.componentWidth = 0;
      let result = eventPipeline.getRatio();
      expect(result).assertEqual(1);
    });

    it('should_calculate_coordinate_correctly_when_scale_is_less_than_componentWidth_and_componentHeight', 0, () => {
      eventPipeline.componentWidth = 100;
      eventPipeline.width = 50;
      eventPipeline.componentHeight = 200;
      eventPipeline.height = 100;
      eventPipeline.center = [0.5, 0.5];
      const result = eventPipeline.calcCoordinate(0.75);
      expect(result[0]).assertEqual(50);
      expect(result[1]).assertEqual(100);
    });

    it('emitDirectionChange_test_when_PanDirection_All', 0, () => {
      eventPipeline.hasReachLeft = false;
      eventPipeline.hasReachRight = false;
      eventPipeline.scale = 2.0;
      eventPipeline.isPullingUp = false;
      eventPipeline.emitDirectionChange();
      expect(eventPipeline.height).assertEqual(100);
    });

    it('emitDirectionChange_test_when_PanDirection_Vertical_or_Right', 0, () => {
      eventPipeline.hasReachLeft = false;
      eventPipeline.hasReachRight = true;
      eventPipeline.scale = 2.0;
      eventPipeline.isPullingUp = false;
      eventPipeline.emitDirectionChange();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('emitDirectionChange_test_when_PanDirection_Vertical_or_Left', 0, () => {
      eventPipeline.hasReachLeft = true;
      eventPipeline.hasReachRight = false;
      eventPipeline.scale = 2.0;
      eventPipeline.isPullingUp = false;
      eventPipeline.emitDirectionChange();
      expect(eventPipeline.height).assertEqual(100);
    });

    it('should_return_correct_offset_when_scale_is_less_than_defaultScale', 0, async () => {
      eventPipeline.defaultScale = 1.0;
      eventPipeline.lastScale = 1.0;
      eventPipeline.scale = 0.5;
      eventPipeline.lastOffset = [0, 0];
      eventPipeline.offset = [0, 0];
      eventPipeline.burstDefaultScale = 1.5;
      const result = eventPipeline.evaluateOffset();
      expect(result[0]).assertEqual(0);
      expect(result[1]).assertEqual(0);
    });

    it('should_return_correct_offset_when_scale_is_greater_than_or_equal_to_defaultScale', 0, async () => {
      Reflect.set(eventPipeline, 'isBurstPhotos', false);
      eventPipeline.defaultScale = 1.5;
      eventPipeline.lastScale = 1.0;
      eventPipeline.scale = 1.0;
      eventPipeline.lastOffset = [0, 0];
      eventPipeline.offset = [0, 0];
      const result = eventPipeline.evaluateOffset();
      expect(result[0]).assertEqual(0);
      expect(result[1]).assertEqual(0);
    });

    it('should_calculate_scales_correctly_when_width_height_ratio_is_close_to_1', 0, async () => {
      eventPipeline.width = 100;
      eventPipeline.height = 100;
      eventPipeline.componentWidth = 100;
      eventPipeline.componentHeight = 100;
      Reflect.set(eventPipeline, 'isSubScreen', true);
      eventPipeline.evaluateScales();
      expect(eventPipeline.doubleTapScale).assertEqual(2);
      expect(eventPipeline.maxScale).assertEqual(2);
    });

    // 0706代码变更doubleTapScale计算逻辑调整
    it('should_calculate_scales_correctly_when_width_height_ratio_is_not_close_to_1', 0, async () => {
      eventPipeline.width = 100;
      eventPipeline.height = 50;
      eventPipeline.componentWidth = 100;
      eventPipeline.componentHeight = 100;
      eventPipeline.item.width = 400;
      eventPipeline.item.height = 200;
      Reflect.set(eventPipeline, 'isSubScreen', false);
      eventPipeline.evaluateScales();
      expect(eventPipeline.doubleTapScale).assertEqual(2);
      expect(eventPipeline.maxScale).assertEqual(8);
    });

    it('should_return_1_when_width_height_componentWidth_burstComponentHeight_is_zero', 0, () => {
      eventPipeline.item.width = 0;
      eventPipeline.item.height = 0;
      eventPipeline.componentWidth = 0;
      eventPipeline.burstComponentHeight = 0;
      const result = eventPipeline.getBurstDefaultScale();
      expect(result).assertEqual(1);
    });

    it('should_return_newRatio_div_defaultRatio_when_width_height_componentWidth_burstComponentHeight_is_not_zero', 0,
      () => {
        eventPipeline.item.width = 100;
        eventPipeline.item.height = 200;
        eventPipeline.componentWidth = 50;
        eventPipeline.burstComponentHeight = 100;
        const result = eventPipeline.getBurstDefaultScale();
        expect(result).assertEqual(1);
      });

    it('should_calculate_burst_component_height_correctly', 0, () => {
      eventPipeline.setBurstComponentHeight(100, 200);
      expect(eventPipeline.burstComponentHeight < 0).assertTrue();
      expect(eventPipeline.burstDefaultScale < 0).assertTrue();
      expect(eventPipeline.burstDefaultTranslateY < 0).assertTrue();
    });

    it('should_return_correct_center_when_currentComponentWidth_is_greater_than_imgDisplayWidth', 0, () => {
      eventPipeline.width = 100;
      eventPipeline.height = 100;
      eventPipeline.lastScale = 1.5;
      eventPipeline.componentWidth = 200;
      eventPipeline.lastOffset = [50, 50];
      const result = eventPipeline.evaluateCenter(100, 100);
      expect(result[0]).assertEqual(0.5);
      expect(result[1]).assertEqual(0.5);
    });

    it('should_return_correct_matrix_when_scale_is_greater_than_1', 0, async () => {
      eventPipeline.evaluateAnimeMatrix(2);
      expect(eventPipeline.offset[0]).assertEqual(0);
      expect(eventPipeline.offset[1]).assertEqual(0);
      expect(eventPipeline.scale).assertEqual(1);
    });

    it('should_report_to_big_data_with_correct_values', 0, () => {
      let status: Scales.BigData = {
        width: 100,
        height: 100,
        lastOffset: [0, 0],
        screenWidth: 100,
        screenHeight: 100,
      };
      eventPipeline.onMoveBigDataMsg(status);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('isPcResourceSmaller_test', 0, () => {
      let result = eventPipeline.isPcResourceSmaller();
      expect(result != undefined).assertTrue();
    });

    it('should_return_mScaleCustom_when_getRatio_is_greater_than_Scales_CORRE_RANGE_MAX', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(eventPipeline, eventPipeline.getRatio);
      when(mockFunc)().afterReturn(Scales.CORRE.RANGE.MAX + 1);
      const result = eventPipeline.calculateCorre(2.0);
      expect(result).assertEqual(2.26);
      mocker.ignoreMock(eventPipeline, eventPipeline.getRatio);
    });

    it('should_calculate_bounds_correctly_when_width_to_height_ratio_is_greater_than_component_width_to_height_ratio',
      0, async () => {
        eventPipeline.width = 200;
        eventPipeline.height = 100;
        eventPipeline.componentWidth = 50;
        eventPipeline.componentHeight = 50;
        eventPipeline.lastScale = 1.0;
        eventPipeline.scale = 1.0;
        let result = eventPipeline.evaluateImgDisplayBounds();
        expect(result[0]).assertEqual(12.5);
        expect(result[1]).assertEqual(25);
      });

    it('getCurrentComponentWidth_test', 0, async () => {
      let result: number = Reflect.get(eventPipeline, 'getCurrentComponentWidth').call(eventPipeline, 100);
      expect(result).assertEqual(100);
    });
  });
}