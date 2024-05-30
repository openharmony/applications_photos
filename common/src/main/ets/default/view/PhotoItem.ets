/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import resourceManager from '@ohos.resourceManager';
import Matrix4 from '@ohos.matrix4';
import router from '@ohos.router';
import { MediaItem } from '../model/browser/photo/MediaItem';
import { AnimationParam } from '../model/browser/photo/EventPipeline';
import { EventPipeline } from '../model/browser/photo/EventPipeline';
import { BroadCast } from '../utils/BroadCast';
import { Log } from '../utils/Log';
import { Constants as PhotoConstants } from '../model/browser/photo/Constants';
import { UserFileManagerAccess } from '../access/UserFileManagerAccess';
import { ColumnSize, ScreenManager } from '../model/common/ScreenManager';
import { Constants } from '../model/common/Constants';
import { LoadingPanel } from './LoadingPanel';
import { ImageUtil } from '../utils/ImageUtil';
import { BigDataConstants, ReportToBigDataUtil } from '../utils/ReportToBigDataUtil';
import { MultimodalInputManager } from '../model/common/MultimodalInputManager';
import { BroadCastConstants } from '../model/common/BroadCastConstants';
import { PhotoDataSource } from '../model/browser/photo/PhotoDataSource';
import { Matrix4x4 } from '../utils/Matrix4x4';

const TAG: string = 'common_PhotoItem';

@Component
export struct PhotoItem {
  @State @Watch('onViewDataChanged') item: MediaItem = new MediaItem();
  @State matrix: Matrix4.Matrix4Transit = Matrix4.identity().copy();
  @State mDirection: PanDirection = PanDirection.Vertical;
  //  @Consume broadCast: BroadCast;
  @Link broadCast: BroadCast;
  @State visible: Visibility = Visibility.Hidden;
  @State objectFit: ImageFit = ImageFit.Cover;
  @State thumbnail: string = '';
  @State ratio: number = 1.0;
  @State showError: boolean = false;
  @State lcdPixelMapUpdate: boolean = false;
  @Consume pageFrom: number;
  @Consume('transitionIndex') @Watch('onTransitionChange') updateTransition: number;
  mPosition: number = 0;
  transitionTag: string = '';
  @State isLoading: boolean = true;
  @State usePixmap: boolean = false;
  @Provide listCardWidth: number = 0;
  verifyPhotoScaled: (matrix: Matrix4.Matrix4Transit) => void = (matrix: Matrix4.Matrix4Transit): void => {
  };
  @Consume currentIndex: number;
  @StorageLink('geometryScale') geometryScale: number = 1;
  @StorageLink('geometryOffsetX') geometryOffsetX: number = 0;
  @StorageLink('geometryOffsetY') geometryOffsetY: number = 0;
  @State isPullDownAndDragPhoto: boolean = false;
  @Link isOnSwiperAnimation: boolean;
  @State imageTop: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean =
    ScreenManager.getInstance().isHorizontal();
  @State isPhotoScaled: boolean = false;
  @State justifyWidth: boolean = true;
  @State imageWidth?: string = Constants.PERCENT_100;
  @State imageHeight?: string = Constants.PERCENT_100;
  @State isEdgeTop: boolean = true;
  @Link isRunningAnimation: boolean;
  @State geometryTransitionId: string = 'default_id';
  @StorageLink('geometryTransitionBrowserId') @Watch('onGeometryIdChange') geometryTransitionBrowserId: string = '';
  private lastUpdateTransition: number = -1;
  private eventPipeline: EventPipeline | null = null;
  private animationOption?: AnimationParam;
  private animationEndMatrix?: Matrix4.Matrix4Transit;
  private isHandlingTap: boolean = false;
  private timerCounter: number = 0;
  private imgScale: number = 1;
  private firstLoad: boolean = true;
  private preItem: PreItem = { height: 0, width: 0 };
  private albumUri: string = '';
  private imagePropertyComponentHeight: number = 578;
  private propertyHeightHorizontal: number = 300;
  private lastTouchDownY: number = 0;
  private lastTouchDownX: number = 0;
  private isInSelectedMode: boolean = false;
  private geometryTransitionEnable: boolean = false;
  private windowLayoutWidth: number = ScreenManager.getInstance().getWinLayoutWidth();
  private windowLayoutHeight: number = ScreenManager.getInstance().getWinLayoutHeight();
  private windowColumns: number = ScreenManager.getInstance().getScreenColumns();
  private isFromFACard: boolean = false;
  private dataSource: PhotoDataSource | null = null;
  private isDefaultFA: boolean = false;
  private onWindowSizeChangeCallBack = () => this.onWindowSizeChanged();
  private onDataReloadFunc: Function = (addCount: KeyEvent): void => this.onDataReload(addCount);
  private resetDefaultScaleFunc: Function = (): void => this.resetDefaultScale();
  private saveScaleFunc: Function = (): void => this.saveScale();

  onGeometryIdChange() {
    this.geometryTransitionId = (this.mPosition === this.currentIndex) ? this.geometryTransitionBrowserId : 'default_id';
    Log.debug(TAG, 'geometryTransitionId = ' + this.geometryTransitionId + ', this.mPosition = ' + this.mPosition +
    ', this.currentIndex = ' + this.currentIndex);
  }

  private onDataReload(addCount: KeyEvent): void {
    Log.info(TAG, `onDataReload ${this.item.uri}`);
    let item: MediaItem | null = this.dataSource?.getItemByUri(this.item.uri) as MediaItem ?? null;
    if (item) {
      this.item = item;
      Log.debug(TAG, `Item[${this.item.uri}] is changed`);
    }
  }

  private resetDefaultScale(): void {
    this.resetScaleAnimation(Matrix4.identity().copy());
  }

  private saveScale(): void {
    if (this.currentIndex == this.mPosition) {
      AppStorage.setOrCreate(PhotoConstants.MATRIX, this.matrix);
    }
  }

  aboutToAppear(): void {
    Log.info(TAG, `aboutToAppear ${this.item.uri}`);
    this.eventPipeline = new EventPipeline(this.broadCast, this.item, this);
    this.matrix = Matrix4.identity().copy();
    this.isPhotoScaled = false;
    this.firstLoad = true;
    if (this.dataSource) {
      this.broadCast.on(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFunc);
    }
    ScreenManager.getInstance().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    this.broadCast.on(PhotoConstants.RESET_DEFAULT_SCALE + this.item.uri, this.resetDefaultScaleFunc);
    this.broadCast.on(PhotoConstants.SAVE_SCALE, this.saveScaleFunc);
    this.onTransitionChange();
    this.onViewDataChanged();
    this.updateListCardWidth();
    this.calculateImagePos();
    this.onGeometryIdChange();

    let matrix: Matrix4.Matrix4Transit =
      AppStorage.get<Matrix4.Matrix4Transit>(PhotoConstants.MATRIX) as Matrix4.Matrix4Transit;
    if (this.currentIndex == this.mPosition && matrix) {
      this.matrix = matrix;
      this.updatePhotoScaledStatus();
    }
    Log.info(TAG, `aboutToAppear ${this.item.uri} end`);
  }

  onWindowSizeChanged(): void {
    let winLayoutW = ScreenManager.getInstance().getWinLayoutWidth();
    let winLayoutH = ScreenManager.getInstance().getWinLayoutHeight();
    if (this.windowLayoutWidth !== winLayoutW || this.windowLayoutHeight !== winLayoutH) {
      Log.debug(TAG, `size change. oldWH: [${this.windowLayoutWidth}, ${this.windowLayoutHeight}]` +
        `, newWH: [${winLayoutW}, ${winLayoutH}]`);
      this.windowLayoutWidth = winLayoutW;
      this.windowLayoutHeight = winLayoutH;
      this.windowColumns = ScreenManager.getInstance().getScreenColumns();
      // 跟随屏幕旋转动效同时对Image的宽高重新赋值
      animateTo({
        duration: Constants.SCREEN_ROTATE_DURATION,
        curve: PhotoConstants.PHOTO_TRANSITION_CURVE,
        onFinish: () => {
          this.eventPipeline?.onAnimationEnd(this.animationEndMatrix);
          this.animationOption = undefined;
          this.animationEndMatrix = undefined;
        }
      }, () => {
        this.eventPipelineSizeChange();
        this.matrix = this.animationEndMatrix as Matrix4.Matrix4Transit;
        this.calculateImagePos();
        this.updateListCardWidth();
      });
    }
  }

  eventPipelineSizeChange(): void {
    this.eventPipeline?.onComponentSizeChanged(vp2px(this.windowLayoutWidth), vp2px(this.windowLayoutHeight));
  }

  aboutToDisappear(): void {
    Log.info(TAG, `aboutToDisappear ${this.item.uri}`);
    if (this.currentIndex == this.mPosition) {
      AppStorage.delete(PhotoConstants.MATRIX);
    }
    if (this.dataSource) {
      this.broadCast.off(BroadCastConstants.ON_DATA_RELOADED, this.onDataReloadFunc);
    }
    ScreenManager.getInstance().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangeCallBack);
    this.broadCast.off(PhotoConstants.RESET_DEFAULT_SCALE + this.item.uri, this.resetDefaultScaleFunc);
    this.broadCast.off(PhotoConstants.SAVE_SCALE, this.saveScaleFunc);
    this.lcdPixelMapUpdate = false;
    Log.info(TAG, `aboutToDisappear ${this.item.uri} end`);
  }

  onViewDataChanged(): void {
    if (this.eventPipeline == null || this.item == null) {
      return;
    }
    if (!this.usePixmap && !this.isDefaultFA) {
      this.ratio = ImageUtil.calcRatio(this.item);
    }

    if ((this.preItem.height == this.item.imgHeight &&
    this.preItem.width == this.item.imgWidth) && !this.firstLoad) {
      this.preItem.width = this.item.imgWidth;
      this.preItem.height = this.item.imgHeight;
      this.eventPipeline && this.eventPipeline.onDataChanged(this.item)
      return;
    }

    this.matrix = Matrix4.identity().copy();
    this.updatePhotoScaledStatus();
    this.eventPipeline && this.eventPipeline.setDefaultScale(1);

    this.eventPipeline && this.eventPipeline.onDataChanged(this.item);
    this.firstLoad = false;
    this.preItem.width = this.item.imgWidth;
    this.preItem.height = this.item.imgHeight;
    Log.info(TAG, 'onViewDataChanged, index: ' + this.mPosition + ', usePixmap: ' + this.usePixmap +
      ', ratio: ' + this.ratio + ', thumbnail: ' + JSON.stringify(this.thumbnail));
  }

  onTouchEventRespond(matrix: Matrix4.Matrix4Transit): void {
    Log.info(TAG, `on touch event respond ${this.item.uri}`);
    this.matrix = matrix;
    this.updatePhotoScaledStatus();
  }

  onDirectionChangeRespond(direction: PanDirection): void {
    Log.info(TAG, `item: ${this.item.uri}, direction: ${direction}`);
    if (this.mDirection === direction) {
      return;
    }
    this.mDirection = direction;
  }

  resetScaleAnimation(matrix: Matrix4.Matrix4Transit): void {
    if (this.eventPipeline?.isDefaultScale()) {
      return;
    }
    this.eventPipeline?.startAnimation(matrix);
    animateTo({
      duration: (this.animationOption as AnimationParam).duration,
      curve: (this.animationOption as AnimationParam).curve as Curve,
      onFinish: (): void => {
        this.eventPipeline?.onAnimationEnd(this.animationEndMatrix as Matrix4.Matrix4Transit);
        this.animationOption = undefined;
        this.animationEndMatrix = undefined;
      }
    }, () => {
      this.matrix = this.animationEndMatrix as Matrix4.Matrix4Transit;
      this.updatePhotoScaledStatus();
    })
  }

  onAnimationEventRespond(animationOption: AnimationParam, animationEndMatrix: Matrix4.Matrix4Transit): void {
    Log.info(TAG, `item: ${this.item.uri}, animationOption: ${JSON.stringify(animationOption)}`);
    this.animationOption = animationOption;
    this.animationEndMatrix = animationEndMatrix;
  }

  updatePhotoScaledStatus() {
    let matrix: Matrix4.Matrix4Transit = this.matrix;
    if (!!matrix) {
      let mat: number[] | undefined = (matrix.copy() as Matrix4x4).matrix4x4;
      if (mat) {
        let xScale: number = mat[Constants.NUMBER_0];
        let yScale: number = mat[Constants.NUMBER_5];
        Log.debug(TAG, `photo in PhotoItem has Scaled x scale: ${xScale}, y scale: ${yScale}, mat: ${mat}`);
        this.isPhotoScaled = (xScale != 1 || yScale != 1);
      }
    } else {
      this.isPhotoScaled = false;
    }
  }

  @Builder
  buildImage() {
    Image(this.thumbnail)
      .key('browserFocus_' + this.thumbnail)
      .aspectRatio(this.ratio)
      .focusable(true)
      .transform(this.matrix)
      .objectFit(ImageFit.Cover)
      .autoResize(false)
      .onComplete(() => {
        Log.info(TAG, `onComplete finish index: ${this.mPosition}, uri: ${this.item.uri}`);
        this.showError = false;
        this.isLoading = false;
        if (this.updateTransition == this.mPosition) {
          this.broadCast.emit(PhotoConstants.PHOTO_SHOW_STATE, [true]);
        }
      })
      .onError(() => {
        Log.info(TAG, `image show error`);
        this.showError = true;
        this.isLoading = false;
        if (this.updateTransition == this.mPosition) {
          this.broadCast.emit(PhotoConstants.PHOTO_SHOW_STATE, [false]);
        }
      })
      .onKeyEvent((event?: KeyEvent) => {
        this.handleKeyEvent(event as KeyEvent);
      })
      .width(this.imageWidth as string)
      .height(this.imageHeight as string)
      .scale({
        x: this.geometryScale,
        y: this.geometryScale
      })
      .offset({
        x: this.geometryOffsetX,
        y: this.geometryOffsetY
      })
      .geometryTransition(this.geometryTransitionId)
      .transition(TransitionEffect.asymmetric(TransitionEffect.opacity(0.99),
        TransitionEffect.scale({
          x: 1 / this.geometryScale,
          y: 1 / this.geometryScale,
          centerX: '50%',
          centerY: '50%' })
          .combine(TransitionEffect.opacity(0.99))
      ))
      .onAppear(() => {
        if (this.currentIndex == this.mPosition) {
          let ret: Boolean = focusControl.requestFocus('browserFocus_' + this.thumbnail);
          if (ret !== true) {
            Log.error(TAG, `requestFocus faild, ret:${ret}`);
          }
        }
      })
  }

  build() {
    Stack() {
      // 加载图标文字组件
      if (this.isLoading && !this.isRunningAnimation) {
        Column() {
          LoadingPanel()
        }
        .width(Constants.PERCENT_100)
        .height(Constants.PERCENT_100)
      }

      Column() {
        Stack({ alignContent: Alignment.TopStart }) {
          Column() {
            // 图片主体组件
            if (this.item.width != 0 && this.item.height != 0) {
              this.buildImage()
            } else {
              Image(this.thumbnail)
                .key('browserFocus_' + this.thumbnail)
                .focusable(true)
                .transform(this.matrix)
                .objectFit(ImageFit.Cover)
                .autoResize(false)
                .onComplete(() => {
                  Log.info(TAG, `onComplete finish index: ${this.mPosition}, uri: ${this.item.uri}`);
                  this.showError = false;
                  this.isLoading = false;
                  if (this.updateTransition == this.mPosition) {
                    this.broadCast.emit(PhotoConstants.PHOTO_SHOW_STATE, [true]);
                  }
                })
                .onError(() => {
                  Log.info(TAG, `image show error`);
                  this.showError = true;
                  this.isLoading = false;
                  if (this.updateTransition == this.mPosition) {
                    this.broadCast.emit(PhotoConstants.PHOTO_SHOW_STATE, [false]);
                  }
                })
                .onKeyEvent((event?: KeyEvent) => {
                  this.handleKeyEvent(event as KeyEvent);
                })
                .onAppear(() => {
                  if (this.currentIndex == this.mPosition) {
                    let ret: Boolean = focusControl.requestFocus('browserFocus_' + this.thumbnail);
                    if (ret !== true) {
                      Log.error(TAG, `requestFocus faild, ret:${ret}`);
                    }
                  }
                })
            }
          }
          .width(Constants.PERCENT_100)
          .height(Constants.PERCENT_100)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
      }
      .hitTestBehavior(HitTestMode.Default)
      .width(Constants.PERCENT_100)
      .height(Constants.PERCENT_100)
      // 绑定手势
      .parallelGesture(
        GestureGroup(GestureMode.Parallel,
          // 捏合手势
          PinchGesture({
            fingers: 2,
            distance: 1
          })
            .onActionStart((event?: GestureEvent) => {
              Log.info(TAG, 'PinchGesture onActionStart');
              Log.info(TAG, `PinchGesture onActionStart scale:\
                          ${(event as GestureEvent).scale}, cx: ${(event as GestureEvent).pinchCenterX},
                          cy: ${(event as GestureEvent).pinchCenterY}`);
              if (this.item.mediaType == UserFileManagerAccess.MEDIA_TYPE_IMAGE ||
                this.item.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
                this.eventPipeline?.onScaleStart((event as GestureEvent).scale,
                  (event as GestureEvent).pinchCenterX, (event as GestureEvent).pinchCenterY);
              }
            })
            .onActionUpdate((event?: GestureEvent) => {
              Log.debug(TAG, `PinchGesture onActionUpdate scale: ${(event as GestureEvent).scale}`);
              if (this.item.mediaType == UserFileManagerAccess.MEDIA_TYPE_IMAGE ||
                this.item.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
                this.eventPipeline?.onScale((event as GestureEvent).scale);
              }
            })
            .onActionEnd(() => {
              Log.info(TAG, 'PinchGesture onActionEnd');
              if (this.item.mediaType == UserFileManagerAccess.MEDIA_TYPE_IMAGE ||
                this.item.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
                this.eventPipeline?.onScaleEnd();
                if (this.animationOption != null) {
                  animateTo({
                    duration: this.animationOption.duration,
                    curve: this.animationOption.curve,
                    onFinish: () => {
                      this.eventPipeline?.onAnimationEnd(this.animationEndMatrix);
                      this.animationOption = undefined;
                      this.animationEndMatrix = undefined;
                    }
                  }, () => {
                    this.matrix = this.animationEndMatrix as Matrix4.Matrix4Transit;
                  })
                  if (!!this.verifyPhotoScaled) {
                    this.verifyPhotoScaled(this.matrix)
                  }
                  this.updatePhotoScaledStatus();
                }
              }
            }),
          // 平移手势
          PanGesture({
            direction: this.mDirection
          })
            .onActionStart((event?: GestureEvent) => {
              Log.info(TAG, `PanGesture start offsetX:\
                                  ${vp2px((event as GestureEvent).offsetX)},
                                  offsetY: ${vp2px((event as GestureEvent).offsetY)}`);
              this.eventPipeline?.onMoveStart(vp2px((event as GestureEvent).offsetX),
                vp2px((event as GestureEvent).offsetY));
            })
            .onActionUpdate((event?: GestureEvent) => {
              Log.info(TAG, `PanGesture update offsetX:\
                                  ${vp2px((event as GestureEvent).offsetX)},
                                  offsetY: ${vp2px((event as GestureEvent).offsetY)}`);
              this.eventPipeline?.onMove(vp2px((event as GestureEvent).offsetX),
                vp2px((event as GestureEvent).offsetY));
              this.isPullDownAndDragPhoto = this.eventPipeline?.canPullDownAndDragPhoto() ?? false;
              if (this.isPullDownAndDragPhoto && this.geometryTransitionEnable &&
              !this.isOnSwiperAnimation && !this.isFromFACard) {
                this.doDragPhoto((event as GestureEvent).offsetX, (event as GestureEvent).offsetY);
              }
            })
            .onActionEnd((event?: GestureEvent) => {
              Log.info(TAG, `PanGesture end offsetX:\
                                  ${vp2px((event as GestureEvent).offsetX)}, offsetY: ${vp2px((event as GestureEvent).offsetY)} \
                                  this.isOnSwiperAnimation ${this.isOnSwiperAnimation}`);
              if (this.isOnSwiperAnimation) {
                return;
              }
              this.eventPipeline?.onMoveEnd(vp2px((event as GestureEvent).offsetX),
                vp2px((event as GestureEvent).offsetY));
              this.isPullDownAndDragPhoto = this.eventPipeline?.canPullDownAndDragPhoto() ?? false;
              if (this.animationOption != null) {
                animateTo({
                  duration: this.animationOption.duration,
                  curve: this.animationOption.curve,
                  onFinish: () => {
                    this.eventPipeline?.onAnimationEnd(this.animationEndMatrix);
                    this.animationOption = undefined;
                    this.animationEndMatrix = undefined;
                  }
                }, () => {
                  this.matrix = this.animationEndMatrix as Matrix4.Matrix4Transit;
                })
                if (!!this.verifyPhotoScaled) {
                  this.verifyPhotoScaled(this.matrix)
                }
                this.updatePhotoScaledStatus();
              }
            }),
          // 点击手势
          TapGesture({
            count: 1
          })
            .onAction((event?: GestureEvent) => {
              if (this.isHandlingTap) {
                if (this.timerCounter != null) {
                  clearTimeout(this.timerCounter)
                  this.timerCounter = 0;
                  this.isHandlingTap = false;
                }
              } else {
                this.isHandlingTap = true;
                this.timerCounter = setTimeout(() => {
                  this.broadCast.emit(PhotoConstants.TOGGLE_BAR, [null]);
                  this.isHandlingTap = false;
                }, Constants.DOUBLE_CLICK_GAP)
                return;
              }
              Log.info(TAG, `onDoubleTap event: ${JSON.stringify(event)}`);
              this.eventPipeline?.onDoubleTap((event as GestureEvent).fingerList[0].localX,
                (event as GestureEvent).fingerList[0].localY);
              if (this.animationOption != null) {
                Log.info(TAG, 'TapGesture animateTo start');
                animateTo({
                  duration: this.animationOption.duration,
                  curve: this.animationOption.curve,
                  onFinish: () => {
                    this.eventPipeline?.onAnimationEnd(this.animationEndMatrix);
                    this.animationOption = undefined;
                    this.animationEndMatrix = undefined;
                  }
                }, () => {
                  this.matrix = this.animationEndMatrix as Matrix4.Matrix4Transit;
                })
                if (!!this.verifyPhotoScaled) {
                  this.verifyPhotoScaled(this.matrix)
                }
                this.updatePhotoScaledStatus();
              }
            }),
        )
      )
      .clip(true)
      .onTouch((event?: TouchEvent) => {
        this.dealTouchEvent(event as TouchEvent);
        this.eventPipeline?.onTouch(event as TouchEvent);
      })
      // TODO Remind users when pictures of other devices cannot be show
      if ((this.showError || this.item.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO) &&
      this.pageFrom == Constants.ENTRY_FROM.DISTRIBUTED) {
        Row() {
          Text((this.item.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO) ?
          $r('app.string.no_distributed_photo_show_video') :
          $r('app.string.no_distributed_photo_show_image'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
        }
        .margin({
          top: (this.item.mediaType ==
          UserFileManagerAccess.MEDIA_TYPE_VIDEO) ? $r('app.float.input_text_notify_margin') : 0
        })
      }
      // 播放视频按键
      if (this.isVideoPlayBtnShow() && !this.isPullDownAndDragPhoto && !this.isRunningAnimation) {
        Row() {
          Image($r('app.media.ic_video_play_btn_png'))
            .key('VideoPlayButton')
            .objectFit(ImageFit.Contain)
            .width($r('app.float.icon_video_size'))
            .height($r('app.float.icon_video_size'))
            .onClick(() => {
              Log.info(TAG, 'video item: ' + JSON.stringify(this.item))
              Log.info(TAG, 'video thumbail: ' + JSON.stringify(this.thumbnail))
              if (this.item != undefined) {
                router.pushUrl({
                  url: 'pages/VideoBrowser',
                  params: {
                    uri: this.item.uri,
                    dateTaken: this.item.getDataTaken(),
                    previewUri: this.thumbnail
                  }
                })
                interface Msg {
                  photoButton: string;
                  from: string;
                }
                let msg: Msg = {
                  photoButton: BigDataConstants.PHOTO_BUTTON_VIDEO,
                  from: BigDataConstants.LOCAL_MEDIA,
                }
                ReportToBigDataUtil.report(BigDataConstants.CLICK_PHOTO_BUTTON_ID, msg);
              }
            })
        }
      }
    }
    .width(Constants.PERCENT_100)
    .height(Constants.PERCENT_100)
  }

  isVideoPlayBtnShow(): boolean {
    return (this.item != undefined) && (this.item.mediaType == UserFileManagerAccess.MEDIA_TYPE_VIDEO);
  }

  doDragPhoto(offsetX: number, offsetY: number) {
    animateTo({
      curve: PhotoConstants.RESPONSIVE_SPRING_MOTION_CURVE
    }, () => {
      let distanceY = Math.abs(offsetY);
      this.geometryOffsetX = offsetX;
      this.geometryOffsetY = offsetY;

      // Calculate image size by distance Y, min size is 50%
      let calcGeometryScale = Constants.NUMBER_1 - distanceY * PhotoConstants.DRAG_SCALE;
      this.geometryScale = calcGeometryScale > PhotoConstants.MIN_DRAG_SCALE ?
        calcGeometryScale : PhotoConstants.MIN_DRAG_SCALE;

      // Calculate image opacity by distance Y, min opacity is 0
      let calcTouchOpacity = Constants.NUMBER_1 - distanceY * PhotoConstants.DRAG_OPACITY;
      let touchOpacity = calcTouchOpacity > Constants.NUMBER_0 ? calcTouchOpacity : Constants.NUMBER_0;
      AppStorage.setOrCreate<number>('geometryOpacity', touchOpacity);
    })
  }

  private calculateImagePos(): void {
    let screenWidth = vp2px(this.windowLayoutWidth);
    let screenHeight = vp2px(this.windowLayoutHeight);
    this.justifyWidth = this.needJustifyWidth();
    this.imageWidth = this.justifyWidth ? Constants.PERCENT_100 : undefined;
    this.imageHeight = !this.justifyWidth ? Constants.PERCENT_100 : undefined;
    if (!this.justifyWidth) {
      this.imageTop = 0;
    } else {
      let imgHeight = screenWidth / this.ratio;
      this.imageTop = screenHeight / 2 - imgHeight / 2;
      Log.debug(TAG, `calculate image size: height ${imgHeight}, screen height ${screenHeight}, ratio ${this.ratio}`);
    }
    Log.debug(TAG, `calculate image size: top ${this.imageTop}`);
  }

  private updateListCardWidth(): void {
    if (this.windowColumns == ColumnSize.COLUMN_FOUR) {
      this.listCardWidth = ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_FOUR);
    } else if (this.windowColumns == ColumnSize.COLUMN_EIGHT) {
      this.listCardWidth = ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_SIX);
    } else if (this.windowColumns == ColumnSize.COLUMN_TWELVE) {
      this.listCardWidth = ScreenManager.getInstance().getColumnsWidth(ColumnSize.COLUMN_EIGHT);
    } else {
      Log.error(TAG, `screenColumns is: ${this.windowColumns}`);
    }
  }

  private onTransitionChange() {
    Log.info(TAG, `onTransitionChange , ${this.updateTransition} ${this.position}`);
    if (this.lastUpdateTransition != this.updateTransition) {
      this.lastUpdateTransition = this.updateTransition;
      if (this.updateTransition == this.mPosition) {
        this.broadCast.emit(PhotoConstants.PHOTO_SHOW_STATE, [!this.showError]);
      } else {

      }
      // reset matrix
      if (this.imgScale != 1) {
        this.matrix = Matrix4.identity().scale({
          x: this.imgScale,
          y: this.imgScale
        }).copy();
        this.eventPipeline && this.eventPipeline.setDefaultScale(this.imgScale);
      } else {
        this.matrix = Matrix4.identity().copy();
        // 重置大小
        this.eventPipeline && this.eventPipeline.reset();
      }
      this.updatePhotoScaledStatus();
      Log.info(TAG, `onTransitionChange end`);
    }
  }

  private needJustifyWidth(): boolean {
    let maxWidth = vp2px(this.windowLayoutWidth);
    let maxHeight = vp2px(this.windowLayoutHeight);
    let justifyWidth: boolean = this.ratio >= (maxWidth / maxHeight);
    Log.info(TAG, `maxWidth:${maxWidth}, maxHeight:${maxHeight}, ratio:${this.ratio}, justifyWidth:${justifyWidth}`);
    return justifyWidth;
  }

  private dealTouchEvent(event: TouchEvent): void {
    if (this.eventPipeline === null) {
        return;
    };
    if (!this.eventPipeline.canTouch() || this.isOnSwiperAnimation || event.touches.length > 1 ||
    this.isPhotoScaled || this.isInSelectedMode || this.isDefaultFA) {
      return;
    }
    if (event.type == TouchType.Move) {
      let yOffset = event.touches[0].screenY - this.lastTouchDownY;
      let xOffset = event.touches[0].screenX - this.lastTouchDownX;
      this.lastTouchDownY = event.touches[0].screenY;
      this.lastTouchDownX = event.touches[0].screenX;
      if (yOffset == undefined || xOffset == undefined) {
        Log.info(TAG, 'dealTouchEvent screenY or screenX undefined');
        return;
      }
    } else if (event.type == TouchType.Down) {
      this.lastTouchDownY = event.touches[0].screenY;
      this.lastTouchDownX = event.touches[0].screenX;
    } else if (event.type == TouchType.Up) {
    }
  }

  private handleKeyEvent(event: KeyEvent): void {
    Log.info(TAG, `type=${event.type}, keyCode=${event.keyCode}`);
    interface Msg {
      from: string;
    }
    if (KeyType.Up == event.type) {
      switch (event.keyCode) {
        case MultimodalInputManager.KEY_CODE_KEYBOARD_ESC:
          let msg: Msg = {
            from: BigDataConstants.BY_KEYBOARD,
          }
          ReportToBigDataUtil.report(BigDataConstants.ESC_PHOTO_BROWSER_WAY, msg);
          this.broadCast.emit(PhotoConstants.PULL_DOWN_END, []);
          break;
        case MultimodalInputManager.KEY_CODE_KEYBOARD_ENTER:
          if (this.item != undefined && this.item.mediaType === UserFileManagerAccess.MEDIA_TYPE_VIDEO) {
            router.pushUrl({
              url: 'pages/VideoBrowser',
              params: {
                uri: this.item.uri,
                dateTaken: this.item.getDataTaken(),
                previewUri: this.thumbnail
              }
            })
          }
          break;
        default:
          Log.info(TAG, `on key event Up, default`);
          break;
      }
    }
  }

  private isNeedShieldPullUpEvent(event: GestureEvent): boolean {
    return event.offsetY < 0 &&
    !this.isPhotoScaled;
  }
}

interface PreItem {
  height: number;
  width: number;
}
