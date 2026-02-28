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

import lazy { MediaOperationType } from '../../model/common/MediaOperationType';
import lazy { ColumnSize, getScreen, ScreenManager } from '../../model/common/ScreenManager';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { CustomContentDialog } from '@ohos.arkui.advanced.Dialog';
import lazy { Log } from '../../utils/Log';
import lazy { LengthMetrics } from '@kit.ArkUI';
import lazy { Constants } from '../../model/common/Constants';
import lazy { UiUtil } from '../../utils/UiUtil';

/**
 * 154 = Progress宽度（getScreen().getColumnsWidth(ColumnSize.COLUMN_FOUR) -  88） - deleteProgress宽度(34)
 */
export const PROGRESS_MESSAGE_WIDTH: number = 154;

/**
 * 88 = 左右padding（24 * 2） + 关闭图片宽度（24） + 图片与Progress间距(16)
 */
export const PROGRESS_WIDTH: number = 88;

/* instrument ignore file */
const TAG: string = 'common_ProgressDialog';
const PROCESS_DIALOG_SPACE: number = 4;
const PROCESS_DIALOG_CANCEL_REGION: string = '166%';
const PROCESS_DIALOG_FLEX_WIDTH: string = '100%';

/**
 * 定制弹框样式
 */
export class ProgressParamWrapper {
  /**
   * 自定义builder，第一个入参是 ProgressDialog 通用的 ProgressParam，第二个是自定义样式所需的定制参数
   */
  public progressParam: ProgressParam = new ProgressParam();
  /**
   * 自定义builder的定制参数，如果需要动态刷新定制内容，可以声明该参数类型为@Observed修饰的，dialog弹出者持有自行刷新
   */
  public customParam: Object = new Object();
}

/**
 * 定制弹框样式
 */
export interface CustomBuilderParam {
  /**
   * 自定义builder，第一个入参是 ProgressDialog 通用的 ProgressParam，第二个是自定义样式所需的定制参数
   */
  builder: WrappedBuilder<[ProgressParamWrapper]>;

  /**
   * 自定义builder的定制参数，如果需要动态刷新定制内容，可以声明该参数类型为@Observed修饰的，dialog弹出者持有自行刷新
   */
  param: Object;
}

@Observed
export class ProgressParam {
  /**
   * 进度
   */
  public progress: number = 0;
  /**
   * 提示信息
   */
  public message?: string | Resource;
  /**
   * msgWidth 参数
   */
  public msgWidth?: number;
  /**
   * 取消回调
   */
  public cancelFunc: Function = (): void => {
  };
  /**
   * 自定义参数
   */
  public custom?: CustomBuilderParam;
}

@CustomDialog
export struct ProgressDialog {
  controller?: CustomDialogController
  /**
   * 进度状态
   */
  @State public progressParam: ProgressParam = new ProgressParam();
  @State popWidth: number = 0;
  @State textWidth: number = 0;
  @State progressWidth: number = 0;
  @State public isHighlightShare: boolean = false;
  private onWindowSizeChangedFun: Function = (): void => this.onWindowSizeChanged();
  @StorageProp('currentFontSizeScale') private currentFontSizeScale: number = 1;

  private onWindowSizeChanged(): void {
    let column: number = this.isHighlightShare ? ColumnSize.COLUMN_FOUR : ColumnSize.COLUMN_THREE;
    this.popWidth = getScreen().getColumnsWidth(column);
    this.textWidth = getScreen().getColumnsWidth(column) -
      (this.progressParam.msgWidth ? this.progressParam.msgWidth : PROGRESS_MESSAGE_WIDTH);
    this.progressWidth = getScreen().getColumnsWidth(column) - PROGRESS_WIDTH;
  }

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    this.onWindowSizeChanged();
    getScreen().on(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFun);
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'aboutToDisappear');
    getScreen().off(ScreenManager.ON_WIN_SIZE_CHANGED, this.onWindowSizeChangedFun);
  }

  private getNeedWrap(): boolean {
    // UX检视：2倍字体下全部换行显示
    return this.currentFontSizeScale >= Constants.FONT_SCALE_STRONG_SIZE;
  }

  @Builder
  customDialogComponent() {
    if (this.progressParam.custom) {
      this.progressParam.custom.builder.builder({
        progressParam: this.progressParam,
        customParam: this.progressParam.custom.param,
      });
    }
  }

  build() {
    CustomContentDialog({
      contentBuilder: (): void => {
        if (this.progressParam.custom) {
          this.customDialogComponent();
        } else {
          this.buildProgress();
        }
      }
    })
  }

  @Builder
  buildProgress() {
    Column() {
      Flex({
        direction: this.getNeedWrap() ? FlexDirection.Column : FlexDirection.Row,
        justifyContent: this.getNeedWrap() ? FlexAlign.Start : FlexAlign.SpaceBetween,
        alignItems: this.getNeedWrap() ? ItemAlign.Start : ItemAlign.Center,
        wrap: this.getNeedWrap() ? FlexWrap.NoWrap : FlexWrap.Wrap,
        space: {
          main: this.getNeedWrap() ? LengthMetrics.vp(PROCESS_DIALOG_SPACE) : LengthMetrics.vp(0),
          cross: this.getNeedWrap() ? LengthMetrics.vp(0) : LengthMetrics.vp(PROCESS_DIALOG_SPACE),
        }
      }) {
        Text(this.progressParam.message)
          .fontSize($r('sys.float.Body_M'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.font_primary'))
          .maxFontScale(Constants.FONT_SCALE_STRONG_SIZE)
          .fontWeight(FontWeight.Medium)
        Text(`${Math.floor(this.progressParam.progress)}%`)
          .fontSize($r('sys.float.Body_M'))
          .fontFamily($r('app.string.id_text_font_family_regular'))
          .fontColor($r('sys.color.font_secondary'))
          .maxFontScale(Constants.FONT_SCALE_STRONG_SIZE)
          .margin({
            right: UiUtil.isMirrorMode() ? 0 : $r('sys.float.padding_level8'),
            left: UiUtil.isMirrorMode() ? $r('sys.float.padding_level8') : 0,
          })
      }
      .width(PROCESS_DIALOG_FLEX_WIDTH)
      .padding({
        right: UiUtil.isMirrorMode() ? 0 : $r('sys.float.padding_level12'),
        left: UiUtil.isMirrorMode() ? $r('sys.float.padding_level12') : 0,
      })
      .height('auto')

      Row() {
        Progress({ value: 0, total: 100, style: ProgressStyle.Linear })
          .value(this.progressParam.progress)
          .color($r('sys.color.comp_background_emphasize'))
          .layoutWeight(1)
          .width(this.progressWidth)
          .margin({
            right: UiUtil.isMirrorMode() ? 0 : $r('sys.float.padding_level8'),
            left: UiUtil.isMirrorMode() ? $r('sys.float.padding_level8') : 0,
          })
        SymbolGlyph($r('sys.symbol.xmark_circle_fill'))
          .draggable(false)
          .width($r('app.float.icon_size'))
          .height($r('app.float.icon_size'))
          .fontSize($r('app.float.icon_size'))
          .fontColor([$r('sys.color.ohos_id_color_tertiary')])
          .onClick((): void => {
            Log.info(TAG, 'cancel button onclick');
            if (this.progressParam.cancelFunc && typeof this.progressParam.cancelFunc === 'function') {
              this.progressParam.cancelFunc();
            }
          })
          .accessibilityText($r('app.string.dialog_cancel'))
          .accessibilityRole(AccessibilityRoleType.BUTTON)
          .responseRegion({
            width: PROCESS_DIALOG_CANCEL_REGION,
            height: PROCESS_DIALOG_CANCEL_REGION,
          })
      }
    }
    .constraintSize({ minHeight: $r('app.float.progress_dialog_height') })
    .justifyContent(FlexAlign.End)
    .height('auto')
    .width('auto')
  }
}
