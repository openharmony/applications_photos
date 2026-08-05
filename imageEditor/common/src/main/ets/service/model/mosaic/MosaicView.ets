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
import { HiLog } from '../../../common/util/HiLog';
import { App, BaseEditor, ScreenClass } from '../../App';
import { Asset } from '../../Asset';
import { TabName } from '../../BaseEditor';
import { EditorStatus, RectValue, SwitchAnimator } from '../../EditorSDK';
import { MosaicController } from './MosaicController';
import { MosaicAttr } from '../menu/MosaicAttr';
import {
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY,
  CANVAS_SHOW_DELAY_DURATION,
  DEVICE_FOLD_STATUS,
  SCREEN_ORIENTATION_PORTRAIT,
  CURRENT_LANGUAGE,
  HOT_SPOT_HEIGHT,
  HOT_SPOT_WIDTH,
  FONT_SIZE_SCALE_KEY
} from '../../../common/const';
import { ScreenManager } from '../../../common/util/ScreenManager';
import { PaintController, PaintType } from './PaintController';
import Matrix4 from '@ohos.matrix4';
import { calculateObjectFit, GestureController } from './GestureController';
import { ANIMATION_COST, LEAVE_ANIMATION_COST, REFRESH_WIN_SIZE_INTERVAL } from './const';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager'
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { AccessibilityManager } from '../../../common/util/AccessibilityManager';
import { UiUtil } from '../../../common/util/UiUtil';
import { ComposeUtil } from '../../../common/util/ComposeUtil';
import { PixelMapUtil } from '../../../common/util/PixelMapUtil';

const TAG = 'MosaicView';

@Component
export struct MosaicView {
  //用来配置CanvasRenderingContext2D对象的参数，包括是否开启抗锯齿，true表明开启抗锯齿。
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  //用来创建CanvasRenderingContext2D对象，通过在canvas中调用CanvasRenderingContext2D对象来绘制。
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private controller: MosaicController = MosaicController.getInstance();
  private paintController: PaintController = new PaintController(this.context, this.controller);
  private gestureController: GestureController = new GestureController();
  private timer: number = -1;
  // state
  @Link status: EditorStatus;
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State @Watch('onAssetChange') asset: Asset = App.getInstance().myEditor().asset;
  @State mosaicAttr: MosaicAttr = App.getInstance().myEditor().asset.mosaic();
  @State mosaicVisible: boolean = true;
  @State rotateScale: number = 1;
  @State imageReady: boolean = false;
  @State mosaicReady: boolean = false;
  @State transitionPixelMap: PixelMap | undefined = undefined;
  @StorageLink('isAccessibilityMode') isAccessibilityMode: boolean = AccessibilityManager.getInstance()
    .getIsAccessibilityMode();
  @StorageLink(CURRENT_LANGUAGE) @Watch('refreshWinSize') currentLanguage: string | undefined = undefined;
  @State @Watch('refreshWinSize') screenClass: ScreenClass = App.getInstance().screenClass;
  @StorageProp(SCREEN_ORIENTATION_PORTRAIT) @Watch('refreshWinSize') isScreenPortrait: boolean =
    ScreenManager.getInstance().isScreenPortrait();
  @StorageProp(DEVICE_FOLD_STATUS) @Watch('refreshWinSize') isFold: boolean =
    ScreenManager.getInstance().isDeviceFold();
  @StorageProp(WIN_WIDTH_KEY) @Watch('refreshWinSize') winWidth: number =
    ScreenManager.getInstance().width;
  @StorageProp(WIN_HEIGHT_KEY) @Watch('refreshWinSize') winHeight: number =
    ScreenManager.getInstance().height;
  @StorageProp(FONT_SIZE_SCALE_KEY) @Watch('refreshWinSize') fontSizeScale: number = 0;
  // style
  @State operationRect: RectValue = new RectValue(0, 0, 0, 0); // vp 实际可操作区域
  @State imagePositionX: number = 0;
  @State imagePositionY: number = 0;
  @State imageViewWidth: number = 0;
  @State imageViewHeight: number = 0;
  // gesture
  @State matrix: Matrix4.Matrix4Transit = Matrix4.identity().copy();
  private scaleMax: number = 1;
  private drawId: number = -1;
  private hideXcTimer: number = -1;
  private canvasSize: Size = { width: 0, height: 0, };
  private refreshSizeTimer: number = -1;
  private touchTimer: number = -1;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private operationRectInited: boolean = false;

  aboutToAppear() {
    this.controller.initPatterns();
    this.gestureInit();
    this.clearTransitionPixelMap();
    this.mosaicAttr.gestureController = this.gestureController;
    this.mosaicAttr.paintController = this.paintController;
    HiLog.i(TAG, 'MosaicView aboutToAppear');
    this.eventRegister();
    clearTimeout(this.timer);
    this.editor.getExportRect(this.operationRectInit);
    this.timer = setTimeout(() => {
      if (!this.mosaicAttr.baseImagePromise) {
        return;
      }
      this.mosaicAttr.baseImagePromise.then((pm): Promise<void> => {
        if (!pm) {
          return Promise.reject('get export image failed');
        }
        const size = pm.getImageInfoSync().size;
        this.operationRectInit(size.width, size.height);
        this.asset.exportPixelMap = pm;
        return this.controller.applyMosaicEffectPx(pm, this.imageViewWidth, this.imageViewHeight);
      })
        .then(() => {
          if (this.editor.tabIndex === TabName.TabMosaic) {
            this.status.isPreviewHidden = true;
            this.mosaicReady = true;
          }
        }).catch(() => {
          HiLog.e(TAG, 'get export base img error');
        });
    }, ANIMATION_COST);
  }

  operationRectInit = (width: number, height: number) => {
    if (width === 0 || height === 0 || this.operationRectInited) {
      return;
    }
    this.operationRectInited = true;
    this.getPreviewOperationRect();
    const output = calculateObjectFit({
      imgWidth: width,
      imgHeight: height,
      containerWidth: this.operationRect.width,
      containerHeight: this.operationRect.height,
    });
    this.mosaicAttr.watermarkParamInit(width, height, output.scale);
    const imageRect = new RectValue(output.x, output.y, output.width, output.height);
    this.gestureController.updateOperationRect(this.operationRect);
    this.gestureController.updatePreviewSize(imageRect);
    this.imageViewWidth = imageRect.width;
    this.imageViewHeight = imageRect.height;
    this.imagePositionX = imageRect.x;
    this.imagePositionY = imageRect.y;
    this.gestureController.init();
    HiLog.i(TAG,
      `start set mosaic img: width:${this.imageViewWidth} height: ${this.imageViewHeight}`);
    this.mosaicAttr.setPreviewRect(new RectValue(
      this.operationRect.x + imageRect.x,
      this.operationRect.y + imageRect.y,
      imageRect.width,
      imageRect.height
    ));
    this.canvasSize = {
      width: imageRect.width,
      height: imageRect.height,
    };
  };

  aboutToDisappear() {
    clearTimeout(this.timer);
    clearTimeout(this.touchTimer);
    this.eventCancel();
    this.mosaicAttr.paintController = undefined;
    this.mosaicAttr.gestureController = undefined;
    this.status.isPreviewHidden = false;
    this.clearTransitionPixelMap();
    this.controller.clear();
    HiLog.i(TAG, 'aboutToDisappear isPreviewHidden = false');
  }

  gestureInit = () => {
    this.gestureController.setOnViewChange(this.onMatrixChange);
    this.gestureController.updateMaxScale(this.scaleMax);
    this.gestureController.setOnDisplayRectChange(this.onDisplayRectChange);
  };
  onMatrixChange = (matrix: Matrix4.Matrix4Transit) => {
    this.matrix = matrix;
  };
  onDisplayRectChange = (rect: RectValue) => {
    this.mosaicAttr.setPreviewRect(rect);
  };
  eventRegister = () => {
    this.appBroadCast.on('LeaveMosaicView', this.onLeaveView);
    this.appBroadCast.on('EnterAiEditor', this.onEnterAiEditor);
    this.appBroadCast.on('LeaveAiEditor', this.onLeaveAiEditor);
    this.mosaicAttr.listener.on('onMosaicViewChange', this.onMosaicViewTabChange);
    this.mosaicAttr.listener.on('beforeLeaveMosaicView', this.beforeLeave);
    this.mosaicAttr.listener.on('beforeEnterStylus', this.beforeEnterStylus);
    this.mosaicAttr.listener.on('beforeEnterAi', this.beforeEnterStylus);
    this.mosaicAttr.listener.on('hideImage', this.onEnterStylus);
    this.mosaicAttr.listener.on('showImage', this.onLeaveStylus);
    this.mosaicAttr.listener.on('updateBaseImage', this.updateBaseImage);
  };
  eventCancel = () => {
    this.appBroadCast.off('EnterAiEditor', this.onEnterAiEditor);
    this.appBroadCast.off('LeaveAiEditor', this.onLeaveAiEditor);
    this.appBroadCast.off('LeaveMosaicView', this.onLeaveView);
    this.mosaicAttr.listener.off('onMosaicViewChange', this.onMosaicViewTabChange);
    this.mosaicAttr.listener.off('hideImage', this.onEnterStylus);
    this.mosaicAttr.listener.off('showImage', this.onLeaveStylus);
    this.mosaicAttr.listener.off('beforeEnterStylus', this.beforeEnterStylus);
    this.mosaicAttr.listener.off('beforeEnterAi', this.beforeEnterStylus);
    this.mosaicAttr.listener.off('updateBaseImage', this.updateBaseImage);
    this.mosaicAttr.listener.off('beforeLeaveMosaicView', this.beforeLeave);
  };


  onMosaicViewTabChange = (display: boolean) => {
    if (!display) {
      return;
    }
    this.status.isPreviewHidden = true;
    this.gestureController.init();
    this.gestureController.resetParam();
  };
  onEnterAiEditor = () => {
    this.onEnterStylus();
  };
  onLeaveAiEditor = (pm?: PixelMap) => {
    this.onLeaveStylus();
    // 拿到ai编辑后的pixelmap
    if (pm) {
      this.updateBaseImage(pm);
    }
  };
  updateBaseImage = (pm: PixelMap) => {
    HiLog.i(TAG, 'updateBaseImage: ' + (pm !== this.asset.exportPixelMap));
    this.asset.exportPixelMap = pm;
    this.paintController.clear();
    this.paintController.clearCache();
    this.controller.applyMosaicEffectPx(pm, this.imageViewWidth, this.imageViewHeight);
  };
  beforeEnterStylus = () => {
    // 获取最新的rect 用于切页面动效
    this.gestureController.updateImageDisplayRect();
  };
  onEnterStylus = () => {
    this.mosaicVisible = false;
    this.gestureController.resetParam();
    this.gestureController.updateImageDisplayRect();
  };
  onLeaveStylus = () => {
    this.mosaicVisible = true;
  };

  onAssetChange() {
    HiLog.i(TAG, 'asset change');
  };

  refreshWinSize() {
    clearTimeout(this.refreshSizeTimer);
    this.refreshSizeTimer = setTimeout(() => {
      animateTo({
        duration: CANVAS_SHOW_DELAY_DURATION,
        curve: Curve.Friction,
        onFinish: (): void => {
          HiLog.i(TAG, 'refreshWinSize finish');
        },
      }, () => {
        HiLog.i(TAG, 'refreshWinSize');
        this.updatePageSize();
      });
    }, REFRESH_WIN_SIZE_INTERVAL);
  }

  private updatePageSize() {
    // 刷新马赛克笔触
    if (this.mosaicAttr.canUndo) {
      this.mosaicAttr.undo();
      this.mosaicAttr.redo();
    }
    if (!this.imageViewWidth) {
      return;
    }
    this.getPreviewOperationRect();
    const output = calculateObjectFit({
      imgWidth: this.imageViewWidth,
      imgHeight: this.imageViewHeight,
      containerWidth: this.operationRect.width,
      containerHeight: this.operationRect.height,
    });
    const imageRect = new RectValue(output.x, output.y, output.width, output.height);
    this.gestureController.updateOperationRect(this.operationRect);
    this.gestureController.updatePreviewSize(imageRect);
    this.rotateScale = this.canvasSize.width === 0 ? 1 : imageRect.width / this.canvasSize.width;
    HiLog.i(TAG, `updatePageSize rotateScale = ${this.rotateScale}`);
    this.imagePositionX = imageRect.x;
    this.imagePositionY = imageRect.y;
    this.gestureController.updateImageDisplayRect();
    this.gestureController.updateMatrix();
  }

  onLeaveView = () => {
    HiLog.i(TAG, 'onLeaveMosaicView');
    this.mosaicAttr.changeView(false);
    this.status.isPreviewHidden = false;
    this.clearTransitionPixelMap();
    HiLog.i(TAG, 'isPreviewHidden = false');
    clearTimeout(this.hideXcTimer);
  };
  beforeLeave = (index: TabName) => {
    this.cacheTransitionPixelMap();
    this.gestureController.close();
    this.mosaicAttr.leaveAnimPromise = new Promise<void>((resolve) => {
      animateTo({
        duration: LEAVE_ANIMATION_COST,
        curve: Curve.Friction,
        onFinish: (): void => {
          resolve();
          HiLog.i(TAG, 'refreshWinSize finish');
        },
      }, () => {
        HiLog.i(TAG, 'leave animation');
        if (index === TabName.TabCrop) {
          // 进入裁剪页
          const cropRect = // px
            SwitchAnimator.getPreviewPosition({
              width: ScreenManager.getInstance().width,
              height: ScreenManager.getInstance().height,
            }, this.isScreenPortrait);
          const mirrorOffsetx = vp2px(UiUtil.getPreviewRectOffset());
          cropRect.x += mirrorOffsetx;
          const output = calculateObjectFit({
            imgWidth: this.imageViewWidth,
            imgHeight: this.imageViewHeight,
            containerWidth: px2vp(cropRect.width),
            containerHeight: px2vp(cropRect.height),
          });
          HiLog.i(TAG,
            'cropRect = ' + JSON.stringify(cropRect) + ' rect = ' +
            JSON.stringify(this.asset.mosaic().getPreviewRect()));
          const scale = output.scale / this.rotateScale;
          this.matrix = Matrix4.identity().copy()
            .scale({ x: scale, y: scale });
        } else if (this.editor.isShowWatermarkTab(index)) {
          this.status.isPreviewHidden = false;
          // 离开马赛克 至 有画框水印的tab时
          const output = calculateObjectFit({
            imgWidth: this.imageViewWidth + this.mosaicAttr.watermarkFrameSize.left +
            this.mosaicAttr.watermarkFrameSize.right,
            imgHeight: this.imageViewHeight + this.mosaicAttr.watermarkFrameSize.top +
            this.mosaicAttr.watermarkFrameSize.bottom,
            containerWidth: this.operationRect.width,
            containerHeight: this.operationRect.height,
          });
          HiLog.i(TAG, 'leave to watermark output = ' + JSON.stringify(output));
          this.matrix =
            this.gestureController
              .calcMatrix(new RectValue(
                vp2px(this.operationRect.x + output.x + this.mosaicAttr.watermarkFrameSize.left * output.scale),
                vp2px(this.operationRect.y + output.y + this.mosaicAttr.watermarkFrameSize.top * output.scale),
                vp2px(this.imageViewWidth * output.scale),
                vp2px(this.imageViewHeight * output.scale)
              ));
        } else {
          this.gestureController.resetParam();
          this.gestureController.updateImageDisplayRect();
        }
        this.refreshSizeTimer = -1;
      });
    });
  };

  build() {
    this.buildMosicPage();
  }

  @Builder
  prevent() {
    this.preventTopEvent();
    this.preventBottomEvent();
    this.preventLeftEvent();
    this.preventRightEvent();
  }

  private isInMosaicTab(): boolean {
    return this.editor.tabIndex === TabName.TabMosaic;
  }

  private shouldShowOverlay(): boolean {
    // 马赛克 tab 内，或“只有马赛克修改、还没有文字修改”时展示画布
    // 裁剪页（含比例子页）应始终使用裁剪链路显示，避免马赛克画布残留
    return this.isInMosaicTab() || (this.editor.tabIndex !== TabName.TabCrop &&
      this.editor.mosaicModified && !this.editor.textEditModified);
  }

  private shouldShowBaseImage(): boolean {
    return this.isInMosaicTab() || this.editor.isSaveVideoDialog ||
      (this.editor.tabIndex !== TabName.TabCrop &&
        this.status.isPreviewHidden && this.transitionPixelMap !== undefined);
  }

  private getBaseImageSource(): PixelMap | undefined {
    if (this.isInMosaicTab() || this.editor.isSaveVideoDialog) {
      return this.asset.exportPixelMap;
    }
    return this.transitionPixelMap;
  }

  private cacheTransitionPixelMap(): void {
    if (this.transitionPixelMap || !this.asset.exportPixelMap) {
      return;
    }
    try {
      const clonedPm = ComposeUtil.clonePixelMap(this.asset.exportPixelMap);
      PixelMapUtil.setMemoryNameSync(clonedPm, 'MosaicTransitionPixelMap');
      this.transitionPixelMap = clonedPm;
    } catch (e) {
      HiLog.e(TAG, `cacheTransitionPixelMap failed: ${e?.code} ${e?.message}`);
    }
  }

  private clearTransitionPixelMap(): void {
    this.transitionPixelMap?.release();
    this.transitionPixelMap = undefined;
  }

  @Builder
  buildMosicPage() {
    Column() {
      if (this.isInMosaicTab()) {
        this.prevent();
      }
      Stack() {
        Image(this.getBaseImageSource())
          .objectFit(ImageFit.Contain)
          .syncLoad(true)
          .draggable(false)
          .visibility((this.shouldShowBaseImage() &&
            this.mosaicVisible && this.imageViewWidth) ? Visibility.Visible :
            Visibility.Hidden);

        Canvas(this.context)
          .id('mosaic_canvas')
          .scale({ x: this.rotateScale, y: this.rotateScale })
          .width(this.imageViewWidth)
          .height(this.imageViewHeight)
          .backgroundColor('#00000000')
          .visibility(this.mosaicAttr.isComparing ? Visibility.Hidden : Visibility.Visible)
          .hitTestBehavior(this.isInMosaicTab() ? HitTestMode.Default : HitTestMode.None)
          .onTouch(this.isInMosaicTab() ? this.handleTouchEvent : undefined);
      }
      .transform(this.matrix)
      .width(this.imageViewWidth * this.rotateScale)
      .height(this.imageViewHeight * this.rotateScale)
      .position({
        x: this.imagePositionX,
        y: this.imagePositionY,
      });
    }
    .width(this.operationRect.width)
    .height(this.operationRect.height)
    .id('mosaicView')
    .position({
      x: this.operationRect.x,
      y: this.operationRect.y,
    })
    .visibility((this.shouldShowOverlay() && this.mosaicVisible) ? Visibility.Visible : Visibility.None)
    .hitTestBehavior(this.isInMosaicTab() ? HitTestMode.Default : HitTestMode.None)
    .gesture(GestureGroup(GestureMode.Parallel,
      PinchGesture({ fingers: 2, distance: 0.01 })
        .onActionStart(this.gestureController.pinchStartHandle)
        .onActionUpdate(this.gestureController.pinchUpdateHandle)
        .onActionEnd(this.gestureController.pinchEndHandle)
        .onActionCancel(this.gestureController.pinchEndHandle),
      PanGesture({ fingers: 2, distance: 0.01 })
        .onActionStart(this.gestureController.panStartHandle)
        .onActionUpdate(this.gestureController.panUpdateHandle)
        .onActionEnd(this.gestureController.panEndHandle)
        .onActionCancel(this.gestureController.pinchEndHandle),
    ));
  };

  @Builder
  preventTopEvent() {
    Column() {

    }
    .position({
      top: -this.operationRect.y,
    })
    .id('mosaic_prevent_click_top')
    .zIndex(1)
    .height(this.operationRect.y)
    .width('200%');
  }

  @Builder
  preventBottomEvent() {
    Column() {

    }
    .position({
      top: this.operationRect.height,
    })
    .zIndex(1)
    .id('mosaic_prevent_click_bottom')
    .height(this.operationRect.height)
    .width('100%');
  }

  @Builder
  preventLeftEvent() {
    Column() {

    }
    .position({
      left: -this.operationRect.x,
    })
    .zIndex(1)
    .id('mosaic_prevent_click_left')
    .height(this.operationRect.height)
    .width(this.operationRect.x);
  }

  @Builder
  preventRightEvent() {
    Column() {

    }
    .position({
      left: this.operationRect.width,
    })
    .zIndex(1)
    .id('mosaic_prevent_click_right')
    .height(this.operationRect.height)
    .width('100%');
  }

  handleTouchDown = (event: TouchEvent) => {
    if (event.touches.length > 1) {
      this.drawId = -1;
      return;
    }

    const x = event.touches[0].x;
    const y = event.touches[0].y;
    this.drawId = event.changedTouches[0].id;
    this.paintController.setPaintSize(this.handlePaintSize() / this.gestureController.imgScale / this.rotateScale);
    this.paintController.setType(this.mosaicAttr.selectMosaicIndex);
    // 等待一段时间确认是否有双指操作。
    clearTimeout(this.touchTimer);
    this.touchTimer = setTimeout(() => {
      if (!this.gestureController.isScaling) {
        this.paintController.drawStart(x, y);
      }
    }, 70);
  };
  handleTouchUp = (event: TouchEvent) => {
    this.drawId = -1;
    this.paintController.drawEnd();
  };
  handleTouchMove = (event: TouchEvent) => {
    if (this.drawId !== event.touches[0].id) {
      return;
    }
    const x = event.touches[0].x;
    const y = event.touches[0].y;
    this.paintController.draw(x, y);
    this.mosaicAttr.updateUndoRedo();
  };
  handleTouchEvent = (event: TouchEvent) => {
    if (this.mosaicAttr.isLeaving) {
      return;
    }
    if (!this.mosaicReady && this.mosaicAttr.selectMosaicIndex === PaintType.Mosaic) {
      return;
    }
    if (this.gestureController.isScaling) {
      return;
    }
    if (this.mosaicAttr.isComparing) {
      return;
    }
    switch (event.type) {
      case TouchType.Down:
        this.handleTouchDown(event);
        break;
      case TouchType.Up:
      case TouchType.Cancel:
        this.handleTouchUp(event);
        break;
      case TouchType.Move:
        this.handleTouchMove(event);
        break;
    }
  };
  private getPreviewOperationRect = () => {
    const cropRect =
      SwitchAnimator.getPreviewPosition({
        width: ScreenManager.getInstance().width,
        height: ScreenManager.getInstance().height,
      }, this.isScreenPortrait);
    const mirrorOffsetx = vp2px(UiUtil.getPreviewRectOffset());
    cropRect.x += mirrorOffsetx;
    this.operationRect =
      new RectValue(
        px2vp(cropRect.x),
        px2vp(cropRect.y),
        px2vp(cropRect.width),
        px2vp(cropRect.height)
      );
    return cropRect;
  };
  handlePaintSize = (): number => {
    if (this.mosaicAttr.selectMosaicSize >= 0 && this.mosaicAttr.selectMosaicSize <= 4) {
      const lineWidthArr: number[] = [4, 6, 9, 12, 16];
      return lineWidthArr[this.mosaicAttr.selectMosaicSize];
    } else {
      return 9;
    }
  };
}

