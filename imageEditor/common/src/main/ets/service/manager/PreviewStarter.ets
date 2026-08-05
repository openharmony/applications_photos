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
// instrument ignore file
import { DeviceUtil } from '../../common/util/DeviceUtil';
import { GlobalThisUtil } from '../../common/util/GlobalThisUtil';
import { HiLog } from '../../common/util/HiLog';
import { ScreenUtil } from '../../common/util/ScreenUtil';
import { App, TabName, MenuChangeType } from '../App';
import sdk from '../native';
import { Rectangle } from '../../common/util/types';
import { Asset, Timeline, OperationArea } from '../BaseEditor';
import {
  HOT_SPOT_HEIGHT,
  HOT_SPOT_WIDTH,
  PC_MIN_CROP,
  PC_PREVIEW_VERTICAL_OFFSET_VP,
  PC_TOP_BAR_HEIGHT,
  PHONE_MIN_CROP,
  TOP_BAR_HEIGHT
} from '../../common/const';
import { ScreenManager } from '../../common/util/ScreenManager';
import { RectValue, SwitchAnimator } from '../EditorSDK';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { UiUtil } from '../../common/util/UiUtil';
import { Trace } from '../../common/util/Trace';

const TAG = 'PreviewStarter';

interface myArea {
  left: number,
  top: number,
  width: number,
  height: number
}

let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

export class PreviewStarter {
  public timeline: Timeline = new Timeline();
  private asset: Asset | null = null;
  private xComponentId: string | undefined = '';
  private hasBindXComponent: boolean = false;
  private hasPreviewStarted: boolean = false;
  public previewTrimStartedCallbacks: Function[] = [];
  private previewOperationArea: Area | null = null;
  private screenManager: ScreenManager = ScreenManager.getInstance();

  constructor() {
  }

  public onTimelineInitialized(timeline: Timeline): void {
    HiLog.i(TAG, `onTimelineInitialized ${JSON.stringify(timeline)}`);
    this.timeline = timeline;
    this.bindXComponentIfNeeded();
  }

  public onAssetInitialized(asset: Asset, reEdit: boolean): void {
    HiLog.i(TAG, 'onAssetInitialized ' + asset + `reEdit ${reEdit}`);
    this.asset = asset;
    this.startPreviewIfNeeded(reEdit, reEdit);
  }

  public onOperationAreaChanged(area: Area): void {
    if ((DeviceUtil.isPhone() || DeviceUtil.isPad()) && !ScreenManager.getInstance()
      .isScreenPortrait() && area.height <= 60) {
      area.height = ScreenManager.getInstance().height - TOP_BAR_HEIGHT;
    }
    HiLog.i(TAG, `onOperationAreaChanged ${JSON.stringify(area)}`);
    this.previewOperationArea = area;
    // 横屏底部热区避让aiBar
    if (this.previewOperationArea && !ScreenManager.getInstance().isScreenPortrait() &&
      !ScreenManager.getInstance().isDeviceFold()) {
      this.previewOperationArea.height = this.previewOperationArea.height as number -
        (DeviceUtil.isPhone() ? HOT_SPOT_WIDTH / 2 : HOT_SPOT_WIDTH);
    }
    if (App.getInstance().myEditor().asset.isBindXComponentFailed) {
      App.getInstance().myEditor().previewStarter.onXComponentLoad(App.getInstance().instanceData().previewComponentId);
      App.getInstance().myEditor().asset.isBindXComponentFailed = false;
    }
    GlobalThisUtil.setProperty('previewer_area_width', area.width as number);
    this.startPreviewIfNeeded(true);
  }

  public onXComponentLoad(id: string): void {
    HiLog.i(TAG, `onXComponentLoad ${id}`);
    this.xComponentId = id;
    this.bindXComponentIfNeeded();
  }

  public onXComponentDestroy(): void {
    HiLog.i(TAG, 'onXComponentDestroy');
    this.xComponentId = undefined;
  }

  public bindXComponentIfNeeded(): void {
    if (this.xComponentId && this.timeline) {
      HiLog.i(TAG, 'bindXComponent begin');
      Trace.begin('bindXComponent');
      this.bindXComponent(this.xComponentId, (canvasWidth: number, canvasHeight: number) => {
        Trace.end('bindXComponent');
        HiLog.i(TAG, 'bindXComponent end, width=' + canvasWidth + ` height=${canvasHeight}`);
        this.hasBindXComponent = true;
        App.getInstance().myEditor().afterLoad(App.getInstance().myEditor().afterLoadCb);
        this.startPreviewIfNeeded(false);
      });
    } else {
      HiLog.e(TAG, 'bindXComponent failed, xComponentId=' + this.xComponentId + ` timeline=${this.timeline}`);
    }
  }

  public startPreviewIfNeeded(isOperationChanged: boolean, reEdit?: boolean): void {
    HiLog.i(TAG, `startPreviewIfNeeded，hasBindXComponent ${this.hasBindXComponent} asset ${this.asset} previewOperationArea ${this.previewOperationArea} timeline ${JSON.stringify(this.timeline)}`);
    if (this.hasBindXComponent && this.asset && this.previewOperationArea && this.timeline) {
      HiLog.i(TAG, `startPreview begin，timeline ${JSON.stringify(this.timeline)}`);
      Trace.begin('startPreviewIfNeeded');
      if (isOperationChanged) {
        this.updatePreview(reEdit);
      } else {
        this.startPreview();
      }

      this.hasPreviewStarted = true;
      for (let callback of this.previewTrimStartedCallbacks) {
        callback();
      }
      this.previewTrimStartedCallbacks.splice(0, this.previewTrimStartedCallbacks.length);
      Trace.end('startPreviewIfNeeded');
      HiLog.i(TAG, 'startPreview end');
    }
  }


  private bindXComponent(xid: string, cb: (width: number, height: number) => void): void {
    // instrument ignore if
    if (!this.timeline) {
      return;
    }
    // instrument ignore if
    if (!this.previewOperationArea) {
      HiLog.e(TAG, 'bindXComponent failed! previewOperationArea is null!');
      App.getInstance().myEditor().asset.isBindXComponentFailed = true;
      return;
    }

    let previewOperationAreaWidth = this.previewOperationArea.width as number;
    let previewOperationAreaHeight = this.previewOperationArea.height as number;
    if (DeviceUtil.isPhone() || DeviceUtil.isPad()) {
      previewOperationAreaWidth = this.screenManager.width;
      previewOperationAreaHeight = this.screenManager.height;
    }
    HiLog.i(TAG, 'EditorContext_bindTimelineWithXComponent canvasWidth:' + previewOperationAreaWidth +
      ',canvasHeight:' + previewOperationAreaHeight);

    // 当前从草稿恢复，视频不显示问题是因为初始化大小不正确，先用这个顶替一下，crop模块正确计算后，这块代码恢复成注释代码
    sdk.EditorContext_bindTimelineWithXComponent(this.timeline.id, xid, vp2px(previewOperationAreaWidth),
      vp2px(previewOperationAreaHeight), (width: number, height: number) => {
        // code linter无法识别到上面的判断，所有此处需要再次判断
        if (this.timeline) {
          // 返回的px单位（width，height）
          this.timeline.canvasWidth = width;
          this.timeline.canvasHeight = height;
          this.timeline.canvasToDesignRatio = this.timeline.canvasWidth / ScreenUtil.getPreviewerWidthLpx();
          cb(width, height);
        }
      })
  }

  public startPreview(): void {
    // instrument ignore if
    if (this.hasPreviewStarted || !this.timeline || !this.asset) {
      return;
    }

    let canvasLeft = (this.timeline.operLeft) - HOT_SPOT_WIDTH;
    let canvasTop = this.timeline.operTop - HOT_SPOT_HEIGHT;
    let canvasRight = this.timeline.operLeft + this.timeline.operWidth +
      HOT_SPOT_WIDTH;
    let canvasBottom = this.timeline.operHeight + this.timeline.operTop - (DeviceUtil.isPc() &&
      App.getInstance().myEditor().tabIndex === TabName.TabAdjust ? App.getInstance().myEditor().bottomHeight : 0) +
      HOT_SPOT_HEIGHT;
    let canvasRect: RectValue = new RectValue(canvasLeft, canvasTop, canvasRight - canvasLeft, canvasBottom -
      canvasTop);
    ScreenManager.getInstance().setCanvasRect(canvasRect);

    let paddingLR = vp2px(HOT_SPOT_WIDTH);
    let paddingTB = vp2px(HOT_SPOT_HEIGHT);
    let isScreenPortrait = ScreenManager.getInstance().isScreenPortrait();
    this.calOperationArea(isScreenPortrait);
    sdk.Asset_initCropOperationArea(this.timeline.id, this.asset.uid,
      [vp2px(this.timeline.operLeft), vp2px(this.timeline.operTop),
        vp2px(this.timeline.operLeft + this.timeline.operWidth),
        vp2px(this.timeline.operHeight + this.timeline.operTop)],
      [paddingLR, paddingTB, vp2px(DeviceUtil.isPhone() ? PHONE_MIN_CROP : PC_MIN_CROP)],
      (jsonPos: string) => {
        let crop: Rectangle = JSON.parse(jsonPos);
        // instrument ignore if
        if (!this.asset || !crop) {
          HiLog.e(TAG, 'initCropOperationArea failed. asset or crop is empty');
          return;
        }
        // code linter无法识别到上面的判断，所有此处需要再次判断

        this.asset.crops().cropRect.left = px2vp(crop.left);
        this.asset.crops().cropRect.right = px2vp(crop.right);
        this.asset.crops().cropRect.top = px2vp(crop.top);
        this.asset.crops().cropRect.bottom = px2vp(crop.bottom);
        this.asset.crops().maxRect = this.asset.crops().cropRect.clone();
        this.asset.isShowCropRect = true;
        // 未被编辑过的图片进入编辑时不走UpdateCropOperationArea, 在这里触发一下切换到个性风格, 防止出现调色盘无法关闭的问题
        if (AppStorage.get('is_entry_XTStyle')) {
          appBroadCast.emit('changeTabToXTStyle');
        }
        HiLog.i(TAG, 'init cropRect: left: ' + px2vp(crop.left) + `,top: ${px2vp(crop.top)}` + ',bottom: ' +
        px2vp(crop.bottom) + ',right: ' + px2vp(crop.right))
      })

    if (ScreenManager.getInstance().isMultiWindowNotFullScreen()) {
      this.updatePreview();
    }
  }

  public updateCropArea(jsonPos: string) {
    // instrument ignore if
    if (!this.timeline || !this.asset) {
      return;
    }
    let crop: Rectangle = JSON.parse(jsonPos);
    let cropRect = this.asset.crops().cropRect;
    cropRect.left = px2vp(crop.left);
    cropRect.right = px2vp(crop.right);
    cropRect.top = px2vp(crop.top);
    cropRect.bottom = px2vp(crop.bottom);
  }

  public updatePreview(reEdit?: boolean): void {
    // instrument ignore if
    if (!this.timeline || !this.asset) {
      return;
    }
    // instrument ignore if
    if (!this.previewOperationArea) {
      return;
    }
    let previewOperationAreaWidth = DeviceUtil.isPhone() || DeviceUtil
      .isPad() ? this.screenManager.getWinLayoutWidth() : this.previewOperationArea.width as number;
    let previewOperationAreaHeight = DeviceUtil.isPhone() || DeviceUtil
      .isPad() ? this.screenManager.getWinLayoutHeight() : this.previewOperationArea.height as number;
    let layoutSwitchFlag = ScreenManager.getInstance().getLayoutSwitching();

    let isScreenPortrait = ScreenManager.getInstance().isScreenPortrait();
    this.calOperationArea(isScreenPortrait);
    if (AppStorage.get<boolean>('isCustomFilterCardShow')) {
      HiLog.i(TAG,'UpdateCropArea refresh openOrCloseCustomFilterCard');
      BroadCastManager.getInstance().getBroadCast().emit('updatePreviewArea');
      return;
    }
    sdk.Asset_UpdateCropOperationArea(this.timeline.id, this.asset.uid,
      vp2px(this.timeline.operLeft), vp2px(this.timeline.operTop),
      vp2px(this.timeline.operLeft + this.timeline.operWidth),
      vp2px(this.timeline.operHeight + this.timeline.operTop),
      vp2px(previewOperationAreaWidth), vp2px(previewOperationAreaHeight),
      isScreenPortrait, App.getInstance().screenClass.screenChangeType,
      (jsonPos: string) => {
        let oper = App.getInstance().myEditor().operationArea;
        oper.operLeft = this.timeline.operLeft
        oper.operTop = this.timeline.operTop
        oper.operHeight = this.timeline.operHeight
        oper.operWidth = this.timeline.operWidth
        let crop: Rectangle = JSON.parse(jsonPos);
        if (!this.asset || !crop) {
          HiLog.e(TAG, 'UpdateCropOperationArea failed. asset or crop is empty');
          return;
        }
        // code linter无法识别到上面的判断，所有此处需要再次判断
        App.getInstance().screenClass.screenChangeType = MenuChangeType.NO_CHANGE;
        let cropRect = this.asset.crops().cropRect;
        // 裁剪后恢复动画
        animateTo({
          duration: reEdit || layoutSwitchFlag ? 0 : 400, // 动画时长
          curve: Curve.Friction, // 动画曲线
          delay: 0,
          iterations: 1, // 播放次数 -1无限次
          playMode: PlayMode.Alternate, // 动画模式
          onFinish: () => {
          },
        }, () => {
          cropRect.left = px2vp(crop.left);
          cropRect.right = px2vp(crop.right);
          cropRect.top = px2vp(crop.top);
          cropRect.bottom = px2vp(crop.bottom);
        })
        this.asset.isShowCropRect = true;
        HiLog.i(TAG, `cropRect: left: ${px2vp(crop.left)}, top: ${px2vp(crop.top)}, bottom: ${px2vp(crop.bottom)}, right: ${px2vp(crop.right)}`);

        if (App.getInstance().myEditor().tabIndex === TabName.TabAperture) {
        }
        // 编辑保存后的图片进入编辑不走initCropOperationArea, 在这里触发一下切换到个性风格, 防止出现调色盘无法关闭的问题
        if (AppStorage.get('is_entry_XTStyle')) {
          appBroadCast.emit('changeTabToXTStyle');
        }
      })
  }

  calOperationArea(isScreenPortrait: boolean): Timeline {
    let realScreenPortrait = DeviceUtil.isPc() ? false : isScreenPortrait;
    let previewRect: RectValue = SwitchAnimator.getPreviewPosition({
      width: ScreenManager.getInstance().getWinLayoutWidth(),
      height: ScreenManager.getInstance().getWinLayoutHeight(),
    }, realScreenPortrait);

    this.timeline.operTop =
      px2vp(previewRect.y) - (DeviceUtil.isPc() ? PC_TOP_BAR_HEIGHT : 0) + // pc的xcomponent是不带topbar的
      (DeviceUtil.isPc() ? PC_PREVIEW_VERTICAL_OFFSET_VP : 0)
    this.timeline.operLeft = px2vp(previewRect.x);
    this.timeline.operLeft += UiUtil.getPreviewRectOffset();
    this.timeline.operWidth = px2vp(previewRect.width);
    this.timeline.operHeight = px2vp(previewRect.height);
    HiLog.i(TAG, 'timelinepx: left: ' + (this.timeline.operLeft) + ',top: ' + (this.timeline.operTop) + ',bottom: ' +
      (this.timeline.operHeight + this.timeline.operTop) + ', right: ' + (this.timeline.operLeft +
    this.timeline.operWidth) + ',screenChangeType: ' + App.getInstance().screenClass.screenChangeType);
    return this.timeline;
  }

  calOperationArea1(isScreenPortrait: boolean): Rectangle {
    let realScreenPortrait = DeviceUtil.isPc() ? false : isScreenPortrait;
    let previewRect: RectValue = SwitchAnimator.getPreviewPosition({
      width: ScreenManager.getInstance().getWinLayoutWidth(),
      height: ScreenManager.getInstance().getWinLayoutHeight(),
    }, realScreenPortrait);

    let operTop: number =
      px2vp(previewRect.y) - (DeviceUtil.isPc() ? PC_TOP_BAR_HEIGHT : 0) + // pc的xcomponent是不带topbar的
      (DeviceUtil.isPc() ? PC_PREVIEW_VERTICAL_OFFSET_VP : 0)
    let operLeft: number = px2vp(previewRect.x);
    operLeft += UiUtil.getPreviewRectOffset();
    let operWidth: number = px2vp(previewRect.width);
    let operHeight: number = px2vp(previewRect.height);
    HiLog.i(TAG, 'CS_timelinepx: left: ' + (operLeft) + ',top: ' + (operTop) + ',bottom: ' +
      (operHeight + operTop) + ', right: ' + (operLeft +
      operWidth) + ',screenChangeType: ' + App.getInstance().screenClass.screenChangeType);
    return Rectangle.createRectangleByLTWH(operLeft, operTop, operWidth, operHeight);
  }


  preCalOperationArea(): OperationArea {
    let result  = new OperationArea();
    if (!this.previewOperationArea) {
      result.status = -1;
      return result;
    }
    let isScreenPortrait = ScreenManager.getInstance().isScreenPortrait();
    let realScreenPortrait = DeviceUtil.isPc() ? false : isScreenPortrait;
    let previewRect: RectValue = SwitchAnimator.getPreviewPosition({
      width: ScreenManager.getInstance().getWinLayoutWidth(),
      height: ScreenManager.getInstance().getWinLayoutHeight(),
    }, realScreenPortrait);
    let previewOperationAreaWidth = DeviceUtil.isPhone() || DeviceUtil
      .isPad() ? this.screenManager.getWinLayoutWidth() : this.previewOperationArea.width as number;
    let previewOperationAreaHeight = DeviceUtil.isPhone() || DeviceUtil
      .isPad() ? this.screenManager.getWinLayoutHeight() : this.previewOperationArea.height as number;
    result.operTop = previewRect.y - (DeviceUtil.isPc() ? vp2px(PC_TOP_BAR_HEIGHT) : 0) + // pc的xcomponent是不带topbar的
      (DeviceUtil.isPc() ? vp2px(PC_PREVIEW_VERTICAL_OFFSET_VP) : 0)
    result.operLeft = previewRect.x;
    result.operLeft += vp2px(UiUtil.getPreviewRectOffset());
    result.operWidth = previewRect.width;
    result.operHeight = previewRect.height;
    result.previewOperationAreaWidth = vp2px(previewOperationAreaWidth);
    result.previewOperationAreaHeight = vp2px(previewOperationAreaHeight);
    HiLog.i(TAG, 'preCalOperationArea: left: ' + (result.operLeft) + ',top: ' + (result.operTop) + ',bottom: ' +
      (result.operHeight + result.operTop) + ', right: ' + (result.operLeft + result.operWidth));
    return result;
  }

  public getTimelineOperationCenterPointPosition(): Position {
    let x: number = this.timeline.operLeft + this.timeline.operWidth / 2;
    let y: number = this.timeline.operTop + this.timeline.operHeight / 2;
    HiLog.w(TAG, `CS_center position x: ${x}, y: ${y}, ${this.timeline.operWidth}, ${this.timeline.operHeight}`);
    return {
      x: this.timeline.operLeft + this.timeline.operWidth / 2,
      y: this.timeline.operTop + this.timeline.operHeight / 2
    }
  }
}