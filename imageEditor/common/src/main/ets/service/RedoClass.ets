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
import LightWeightMap from '@ohos.util.LightWeightMap';
import { Rectangle } from '../common/util/types';
import { App, BaseEditor } from './App';
import { HiLog } from '../common/util/HiLog';
import { CropScaleClass } from './model/CropModel';
import { ADJUST_TAG, CropIndex } from '../common/const';
import { NullUtil } from '../common/util/NullUtil';
import { AdjustItem } from './model/menu/AdjustAttr';
import { AdjustAttr, CropAttr} from './BaseEditor';
import { DeviceUtil } from '../common/util/DeviceUtil';

/* instrument ignore file */
const TAG = 'RedoClass';

export class RedoClass {
  public editor: BaseEditor = App.getInstance().myEditor();
  public cropAttr: CropAttr = App.getInstance().myEditor().asset.crops();

  cascadeOperation(redoValue: string, isUndo: boolean): void {
  }

  changeCropRect(redoValue: string): void {
    let cropVal: CropVal = JSON.parse(redoValue);
    let crop = this.cropAttr.cropRect;
    if (NullUtil.isObjNull(cropVal) || NullUtil.isObjNull(crop)) {
      HiLog.e(TAG, 'cropVal or crop is empty!');
      return;
    }
    let last = new Rectangle(
      px2vp(cropVal.left as number),
      px2vp(cropVal.top as number),
      px2vp(cropVal.right as number),
      px2vp(cropVal.bottom as number)
    );
    crop.left = last.left;
    crop.top = last.top;
    crop.right = last.right;
    crop.bottom = last.bottom;
  }
}

class CropVal {
  public left: number = 0;
  public top: number = 0;
  public right: number = 0;
  public bottom: number = 0;
}

export class AdjustRedoClass extends RedoClass {
  public adjustAttr: AdjustAttr = App.getInstance().myEditor().asset.adjusts();

  cascadeOperation(redoValue: string): void {
    let adjustVal: AdjustVal = JSON.parse(redoValue);
    if (NullUtil.isObjNull(adjustVal)) {
      HiLog.e(TAG, 'adjustVal is empty!');
      return;
    }
    this.adjustAttr.redoAdjustItem = adjustVal.id;
    let index = this.adjustAttr.tabs.findIndex(tab => {
      return tab.key === adjustVal.id;
    })
    if (adjustVal.autoValue != undefined) {
      this.adjustAttr.autoValHidden = adjustVal.autoEnable === 0;
      this.adjustAttr.tabs[0].value = adjustVal.autoValue;
      this.adjustAttr.isAutoAdjustOn = adjustVal.autoEnable === 1;
      this.adjustAttr.tabs[0].state = this.adjustAttr.autoSelected && !this.adjustAttr.autoValHidden ? 1 : 0;
    }
    this.adjustAttr.barDisabled = this.adjustAttr.tab.state === 2;
    this.adjustAttr.tabs[index].value = adjustVal.itemValue;
    this.adjustAttr.tabs[index].isCheck = Boolean(adjustVal.itemEnable);
    this.adjustAttr.getValueByKey(this.adjustAttr.redoAdjustItem).value = adjustVal.itemValue;
    this.adjustAttr.getValueByKey(this.adjustAttr.redoAdjustItem).disabled = Boolean(adjustVal.itemEnable);
    this.adjustAttr.isRefreshValue = true;
  }
}

class AdjustVal {
  public id: string = '';
  public itemEnable: number = 0;
  public itemValue: number = 0;
  public autoValue: number = 0;
  public autoEnable: number = 0;
}

export class AutoAdjustClass extends RedoClass {
  public adjustAttr: AdjustAttr = App.getInstance().myEditor().asset.adjusts();

  cascadeOperation(redoValue: string): void {
    let adjustVal: AutoAdjustVal = JSON.parse(redoValue);
    if (NullUtil.isObjNull(adjustVal)) {
      HiLog.e(TAG, 'autoAdjustVal is empty!');
      return;
    }
    let adjustValId = adjustVal.id;
    if (this.adjustAttr.redoAdjustItem.match('_')) {
      adjustValId = this.adjustAttr.redoAdjustItem.split('_')[0];
    }
    this.adjustAttr.redoAdjustItem = adjustValId;
    let items: AutoAdjustItem[] = JSON.parse(adjustVal.value);
    if (NullUtil.isObjNull(items) || !(items instanceof Array)) {
      HiLog.e(TAG, 'autoAdjustItems is not array!');
      return;
    }

    items.forEach((item: AdjustItem) => {
      let index = this.adjustAttr.tabs.findIndex(tab => {
        return tab.key === item.name;
      })
      if (item.name == ADJUST_TAG) {
        this.adjustAttr.autoValHidden = item.enable === 0;
        this.adjustAttr.isAutoAdjustOn = item.enable === 1;
      }
      this.adjustAttr.tabs[index].isCheck = item.value != 0;
      this.adjustAttr.tabs[index].value = item.value;
      this.adjustAttr.getValueByKey(item.name).value = item.value;
      this.adjustAttr.getValueByKey(item.name).disabled = Boolean(item.enable);
      if (this.adjustAttr.autoSelected) {
        if (this.adjustAttr.tabs[index].key == ADJUST_TAG) {
          this.adjustAttr.tabs[index].state = item.enable;
          this.adjustAttr.autoValHidden = item.enable === 0;
        } else {
          this.adjustAttr.tabs[index].state = item.enable === 1 ? 0 : 2;
        }
      }
    })
    this.adjustAttr.isRefreshValue = true;
  }
}

class AutoAdjustVal {
  public id: string = '';
  public value: string = '';
}

class AutoAdjustItem {
  public name: string = '';
  public enable: number = 0;
  public value: number = 0;
}

export class AdjustRedoEnableClass extends RedoClass {
  public adjustAttr: AdjustAttr = App.getInstance().myEditor().asset.adjusts();

  cascadeOperation(redoValue: string): void {
    let adjustEnable: AdjustEnable = JSON.parse(redoValue);
    if (NullUtil.isObjNull(adjustEnable)) {
      HiLog.e(TAG, 'adjustEnable is empty!');
      return;
    }
    let adjustEnableId: string = adjustEnable.id.substring(0, adjustEnable.id.indexOf('_'));
    this.adjustAttr.redoAdjustItem = adjustEnable.id;
    let index = this.adjustAttr.tabs.findIndex(tab => {
      return tab.key === adjustEnableId;
    })
    if (adjustEnableId == this.adjustAttr.tab.key) {
      this.adjustAttr.tabs[index].state = adjustEnable.itemEnable === 1 ? 1 : 2;
    } else {
      this.adjustAttr.tabs[index].state = adjustEnable.itemEnable === 1 ? 0 : 2;
    }
    if (adjustEnable.autoValue != undefined) {
      this.adjustAttr.autoValHidden = adjustEnable.autoEnable === 0;
      this.adjustAttr.tabs[0].value = adjustEnable.autoValue;
      this.adjustAttr.tabs[0].state = this.adjustAttr.autoSelected && !this.adjustAttr.autoValHidden ? 1 : 0;
      this.adjustAttr.isAutoAdjustOn = adjustEnable.autoEnable === 1;
    }
    this.adjustAttr.barDisabled = this.adjustAttr.tab.state === 2;
    this.adjustAttr.tabs[index].isCheck = Boolean(adjustEnable.itemEnable);
    this.adjustAttr.getValueByKey(adjustEnableId).disabled = Boolean(adjustEnable.itemEnable);
    this.adjustAttr.isRefreshValue = true;
  }
}

class AdjustEnable {
  public id: string = '';
  public itemEnable: number = 0;
  public autoValue: number = 0;
  public autoEnable: number = 0;
}

export class FilterRedoClass extends RedoClass {

  cascadeOperation(redoValue: string): void {
    let filterVal: FilterVal = JSON.parse(redoValue);
    if (NullUtil.isObjNull(filterVal)) {
      HiLog.e(TAG, 'filterVal is empty!');
      return;
    }
    if (filterVal.currentUid != undefined && filterVal.currentStrength != undefined) {
    }
  }
}

class FilterVal {
  public currentUid: string = '';
  public currentStrength: number = 0;
}

export class XTStyleRedoClass extends RedoClass {

  cascadeOperation(redoValue: string): void {
    let xtStyleVal: XTStyleVal = JSON.parse(redoValue);
    if (NullUtil.isObjNull(xtStyleVal)) {
      HiLog.e(TAG, 'xtStyleVal is empty!');
      return;
    }
    if (xtStyleVal.type != undefined && xtStyleVal.colorTemperature != undefined &&
      xtStyleVal.saturation != undefined && xtStyleVal.lightShadow != undefined) {
      this.xtStyleTypesThumbnailParamUpdate(xtStyleVal.type, xtStyleVal.colorTemperature,
        xtStyleVal.saturation, xtStyleVal.lightShadow);
    }
  }

  /**
   * 更新缩略图数组
   * 数组形式为 [鲜艳type,X,X,X,明快type,X,X,X,黑白type,X,X,X,自然type,X,X,X,胶片type,X,X,X,电影type,X,X,X,动漫type,X,X,X]
   * 鲜艳、明快、黑白type分别为5、6、7
   * 自然、胶片、电影、动漫type分别为1、2、3、4
   *
   * @param styleIndex
   * @param hue
   * @param saturation
   * @param tone
   */
  public xtStyleTypesThumbnailParamUpdate(styleIndex: number, hue: number, saturation: number, tone: number) {
    if (styleIndex < 1) {
      return;
    }
  }
}

interface XTStyleVal {
  id: string;
  type: number;
  colorTemperature: number;
  lightShadow: number;
  saturation: number;
  templateIndex: number;
}

export class CropRectRedoClass extends RedoClass {
  cascadeOperation(redoValue: string): void {
    super.changeCropRect(redoValue);
  }
}

export class NinetyRotateRedoClass extends RedoClass {
  public cropAttr: CropAttr = App.getInstance().myEditor().asset.crops();

  cascadeOperation(redoValue: string): void {
    super.changeCropRect(redoValue);
    if (this.cropAttr.scale != 0) {
      this.cropAttr.scale = 1 / this.cropAttr.scale;
      this.cropAttr.clipRatio = 1 / this.cropAttr.clipRatio;
    }
  }
}

export class WideApertureRedoClass extends RedoClass {
  cascadeOperation(redoValue: string, isUndo: boolean): void {
  }
}

export class RulerRedoClass extends RedoClass {
  public cropAttr: CropAttr = App.getInstance().myEditor().asset.crops();

  cascadeOperation(redoValue: string): void {
    let rulerVal: RulerVal = JSON.parse(redoValue);
    if (NullUtil.isObjNull(rulerVal)) {
      HiLog.e(TAG, 'rulerVal is empty!');
      return;
    }
    // 移除了自由旋转功能，跳过相关操作
    if (rulerVal.intelligentCorrection !== undefined) {
      // 智能校正现在直接作用于智能校正按钮
      this.cropAttr.redoCropItem = 'intelligentCorrection';
    }
    if (rulerVal.rotation !== undefined) {
      // 跳过自由旋转操作
    }
    if (rulerVal.horizontalCorrection !== undefined) {
      this.cropAttr.horizontalCorrection.originalValue = this.cropAttr.cropTabs[CropIndex.HORIZONTAL].value;
      this.cropAttr.redoCropItem = 'horizontalCorrection';
      this.cropAttr.cropTabs[CropIndex.HORIZONTAL].value = rulerVal.horizontalCorrection;
    }
    if (rulerVal.verticalCorrection !== undefined) {
      this.cropAttr.verticalCorrection.originalValue = this.cropAttr.cropTabs[CropIndex.VERTICAL].value;
      this.cropAttr.redoCropItem = 'verticalCorrection';
      this.cropAttr.cropTabs[CropIndex.VERTICAL].value = rulerVal.verticalCorrection;
    }
    this.cropAttr.isClickUndoRedo = true;
  }
}

class RulerVal {
  public intelligentCorrection: number = 0;
  public rotation: number = 0;
  public horizontalCorrection: number = 0;
  public verticalCorrection: number = 0;
}

export class CropRatioRedoClass extends RedoClass {
  public cropAttr: CropAttr = App.getInstance().myEditor().asset.crops();

  cascadeOperation(redoValue: string): void {
    let cropVal: CropVal2 = JSON.parse(redoValue);
    if (NullUtil.isObjNull(cropVal)) {
      HiLog.e(TAG, 'cropVal is empty!');
      return;
    }
    if (cropVal.ratio != undefined && cropVal.clipRatio != undefined) {
      this.cropAttr.ratio = cropVal.ratio as string;
      this.cropAttr.clipRatio = cropVal.clipRatio as number;
      let item = this.cropAttr.videoScaleList.find((item: CropScaleClass) => {
        return item.ratio === cropVal.ratio;
      })
      item && (this.cropAttr.scale = item.value);
      item && (item.value === 0) && (this.cropAttr.clipRatio = 0);
      super.changeCropRect(redoValue);
    }
  }
}

class CropVal2 {
  public ratio: string = '';
  public clipRatio: number = 0;
}

export class MirrorRedoClass extends RedoClass {
  public cropsAttr: CropAttr = App.getInstance().myEditor().asset.crops();

  cascadeOperation(redoValue: string): void {
    this.cropsAttr.mirrorFlag = this.cropsAttr.mirrorFlag ? 0 : 1
  }
}

export class SealRedoClass extends RedoClass {
  cascadeOperation(redoValue: string): void {
  }
}

export class RedoModel {
  public redoTips: Resource;
  public undoTips: Resource;
  public redoClass: RedoClass;

  constructor(redoTips: Resource, undoTips: Resource, redoClass: RedoClass = new RedoClass()) {
    this.redoTips = redoTips;
    this.undoTips = undoTips;
    this.redoClass = redoClass;
  }
}

export class RedoMap {
  public adjustRedoClass = new AdjustRedoClass();
  public autoAdjustRedoClass = new AutoAdjustClass();
  public adjustRedoEnableClass = new AdjustRedoEnableClass();
  public wideApertureRedoClass = new WideApertureRedoClass();
  public sealRedoClass = new SealRedoClass();
  public filterRedoClass = new FilterRedoClass();
  public xtStyleRedoClass = new XTStyleRedoClass();
  public cropRectRedoClass = new CropRectRedoClass();
  public rulerRedoClass = new RulerRedoClass();
  public cropRatioRedoClass = new CropRatioRedoClass();
  public ninetyRotateRedoClass = new NinetyRotateRedoClass();
  public mirrorRedoClass = new MirrorRedoClass();
  public aiMoveRedoClass = new RedoClass();
  public redoMap: LightWeightMap<string, RedoModel> = new LightWeightMap();

  public getRedoMap(): LightWeightMap<string, RedoModel> {
    this.redoUndoAdjust();
    this.redoMapUndoAiMove();
    this.redoUndoCameraFilter();
    this.redoUndoXTStyle();
    this.redoMap.set('aperture_adjust',
      new RedoModel($r('app.string.redo_aperture_adjust'),
        $r('app.string.undo_aperture_adjust'), this.wideApertureRedoClass));

    this.redoMap.set('brightness_on',
      new RedoModel($r('app.string.redo_adjust_brightness_on_imageEdit'),
        $r('app.string.undo_adjust_brightness_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('brightness_off',
      new RedoModel($r('app.string.redo_adjust_brightness_off_imageEdit'),
        $r('app.string.undo_adjust_brightness_off_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('exposure_on',
      new RedoModel($r('app.string.redo_adjust_exposure_on_imageEdit'),
        $r('app.string.undo_adjust_exposure_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('exposure_off',
      new RedoModel($r('app.string.redo_adjust_exposure_off_imageEdit'),
        $r('app.string.undo_adjust_exposure_off_imageEdit'), this.adjustRedoEnableClass));

    this.redoMap.set('auto_on',
      new RedoModel($r('app.string.redo_button_bubble_oneClick_adjust_on_imageEdit'),
        $r('app.string.undo_button_bubble_oneClick_adjust_on_imageEdit'), this.autoAdjustRedoClass));
    this.redoMap.set('auto_off',
      new RedoModel($r('app.string.redo_button_bubble_oneClick_adjust_off_imageEdit'),
        $r('app.string.undo_button_bubble_oneClick_adjust_off_imageEdit'), this.autoAdjustRedoClass));

    this.redoMap.set('brightzone_on',
      new RedoModel($r('app.string.redo_adjust_brightzone_on_imageEdit'),
        $r('app.string.undo_adjust_brightzone_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('brightzone_off',
      new RedoModel($r('app.string.redo_adjust_brightzone_off_imageEdit'),
        $r('app.string.undo_adjust_brightzone_off_imageEdit'), this.adjustRedoEnableClass));

    this.redoMap.set('darkzone_on',
      new RedoModel($r('app.string.redo_adjust_darkzone_on_imageEdit'),
        $r('app.string.undo_adjust_darkzone_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('darkzone_off',
      new RedoModel($r('app.string.redo_adjust_darkzone_off_imageEdit'),
        $r('app.string.undo_adjust_darkzone_off_imageEdit'), this.adjustRedoEnableClass));

    this.redoMap.set('vibrance_on',
      new RedoModel($r('app.string.redo_adjust_vibrance_on_imageEdit'),
        $r('app.string.undo_adjust_vibrance_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('vibrance_off',
      new RedoModel($r('app.string.redo_adjust_vibrance_off_imageEdit'),
        $r('app.string.undo_adjust_vibrance_off_imageEdit'), this.adjustRedoEnableClass));

    this.redoMap.set('fade_on',
      new RedoModel($r('app.string.redo_adjust_fade_on_imageEdit'), $r('app.string.undo_adjust_fade_on_imageEdit'),
        this.adjustRedoEnableClass));
    this.redoMap.set('fade_off', new RedoModel($r('app.string.redo_adjust_fade_off_imageEdit'),
      $r('app.string.undo_adjust_fade_off_imageEdit'), this.adjustRedoEnableClass));

    this.redoMap.set('grain_on', new RedoModel($r('app.string.redo_adjust_grain_on_imageEdit'),
      $r('app.string.undo_adjust_grain_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('grain_off',
      new RedoModel($r('app.string.redo_adjust_grain_off_imageEdit'),
        $r('app.string.undo_adjust_grain_off_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('contrast_on',
      new RedoModel($r('app.string.redo_adjust_contrast_on_imageEdit'),
        $r('app.string.undo_adjust_contrast_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('contrast_off',
      new RedoModel($r('app.string.redo_adjust_contrast_off_imageEdit'),
        $r('app.string.undo_adjust_contrast_off_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('saturation_on',
      new RedoModel($r('app.string.redo_adjust_saturation_on_imageEdit'),
        $r('app.string.undo_adjust_saturation_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('saturation_off',
      new RedoModel($r('app.string.redo_adjust_saturation_off_imageEdit'),
        $r('app.string.undo_adjust_saturation_off_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('hue_on', new RedoModel($r('app.string.redo_adjust_hue_on_imageEdit'),
      $r('app.string.undo_adjust_hue_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('hue_off',
      new RedoModel($r('app.string.redo_adjust_hue_off_imageEdit'), $r('app.string.undo_adjust_hue_off_imageEdit'),
        this.adjustRedoEnableClass));
    this.redoMap.set('temperature_on',
      new RedoModel($r('app.string.redo_adjust_temperature_on_imageEdit'),
        $r('app.string.undo_adjust_temperature_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('temperature_off',
      new RedoModel($r('app.string.redo_adjust_temperature_off_imageEdit'),
        $r('app.string.undo_adjust_temperature_off_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('sharpness_on',
      new RedoModel($r('app.string.redo_adjust_sharpness_on_imageEdit'),
        $r('app.string.undo_adjust_sharpness_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('sharpness_off',
      new RedoModel($r('app.string.redo_adjust_sharpness_off_imageEdit'),
        $r('app.string.undo_adjust_sharpness_off_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('highlight_on',
      new RedoModel($r('app.string.redo_adjust_highlight_on_imageEdit'),
        $r('app.string.undo_adjust_highlight_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('highlight_off',
      new RedoModel($r('app.string.redo_adjust_highlight_off_imageEdit'),
        $r('app.string.undo_adjust_highlight_off_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('shadow_on',
      new RedoModel($r('app.string.redo_adjust_shadow_on_imageEdit'),
        $r('app.string.undo_adjust_shadow_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('shadow_off', new RedoModel($r('app.string.redo_adjust_shadow_off_imageEdit'),
      $r('app.string.undo_adjust_shadow_off_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('vignette_on',
      new RedoModel($r('app.string.redo_adjust_vignette_on_imageEdit'),
        $r('app.string.undo_adjust_vignette_on_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('vignette_off',
      new RedoModel($r('app.string.redo_adjust_vignette_off_imageEdit'),
        $r('app.string.undo_adjust_vignette_off_imageEdit'), this.adjustRedoEnableClass));
    this.redoMap.set('switch_sticker',
      new RedoModel($r('app.string.redo_switch_watermark_imageEdit'),
        $r('app.string.undo_switch_watermark_imageEdit'), this.sealRedoClass));
    this.redoMap.set('selected_sticker',
      new RedoModel($r('app.string.redo_selected_watermark_imageEdit'),
        $r('app.string.undo_selected_watermark_imageEdit'), this.sealRedoClass));
    this.redoMap.set('edit_sticker',
      new RedoModel($r('app.string.redo_edit_watermark_imageEdit'),
        $r('app.string.undo_edit_watermark_imageEdit'), this.sealRedoClass));
    this.redoMap.set('no_sticker',
      new RedoModel($r('app.string.redo_close_watermark_imageEdit'),
        $r('app.string.undo_close_watermark_imageEdit'), this.sealRedoClass));
    return this.redoMap;
  }

  private redoUndoAdjust() {
    this.redoMap.set('brightness',
      new RedoModel($r('app.string.redo_adjust_luma_imageEdit'),
        $r('app.string.undo_adjust_luma_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('contrast', new RedoModel($r('app.string.redo_adjust_contrast_imageEdit'),
      $r('app.string.undo_adjust_contrast_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('saturation', new RedoModel($r('app.string.redo_adjust_saturation_imageEdit'),
      $r('app.string.undo_adjust_saturation_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('hue',
      new RedoModel($r('app.string.redo_adjust_hue_imageEdit'),
        $r('app.string.undo_adjust_hue_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('temperature',
      new RedoModel($r('app.string.redo_adjust_temperature_imageEdit'),
        $r('app.string.undo_adjust_temperature_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('sharpness',
      new RedoModel($r('app.string.redo_adjust_sharpness_imageEdit'),
        $r('app.string.undo_adjust_sharpness_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('highlight', new RedoModel($r('app.string.redo_adjust_highlights_imageEdit'),
      $r('app.string.undo_adjust_highlights_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('shadow', new RedoModel($r('app.string.redo_adjust_shadow_imageEdit'),
      $r('app.string.undo_adjust_shadow_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('vignette', new RedoModel($r('app.string.redo_adjust_vignette_imageEdit'),
      $r('app.string.undo_adjust_vignette_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('brightzone',
      new RedoModel($r('app.string.redo_adjust_bright_part_imageEdit'),
        $r('app.string.undo_adjust_bright_part_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('exposure', new RedoModel($r('app.string.redo_adjust_exposure_imageEdit'),
      $r('app.string.undo_adjust_exposure_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('auto', new RedoModel($r('app.string.redo_button_bubble_oneClick_adjust_imageEdit'),
      $r('app.string.undo_button_bubble_oneClick_adjust_imageEdit'), this.autoAdjustRedoClass));
    this.redoMap.set('darkzone', new RedoModel($r('app.string.redo_adjust_dark_part_imageEdit'),
      $r('app.string.undo_adjust_dark_part_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('fade', new RedoModel($r('app.string.redo_adjust_fade_imageEdit'),
      $r('app.string.undo_adjust_fade_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('intelligentCorrection', new RedoModel($r('app.string.redo_correct_intelligent_imageEdit'),
      $r('app.string.undo_correct_intelligent_imageEdit'), this.rulerRedoClass));
    this.redoMap.set('grain',
      new RedoModel($r('app.string.redo_adjust_granules_imageEdit'), $r('app.string.undo_adjust_granules_imageEdit'),
        this.adjustRedoClass));
    this.redoMap.set('vibrance', new RedoModel($r('app.string.redo_adjust_nature_saturation_imageEdit'),
      $r('app.string.undo_adjust_nature_saturation_imageEdit'), this.adjustRedoClass));
    this.redoMap.set('rotation', new RedoModel($r('app.string.redo_rotate_imageEdit'),
      $r('app.string.undo_rotate_imageEdit'), this.rulerRedoClass));
    this.redoMap.set('horizontalCorrection',
      new RedoModel($r('app.string.redo_correct_horizontal_imageEdit'),
        $r('app.string.undo_correct_horizontal_imageEdit'),
        this.rulerRedoClass));
    this.redoMap.set('verticalCorrection',
      new RedoModel($r('app.string.redo_correct_vertical_imageEdit'), $r('app.string.undo_correct_vertical_imageEdit'),
        this.rulerRedoClass));
    this.redoMap.set('clipRatio',
      new RedoModel($r('app.string.redo_proportional_imageEdit'), $r('app.string.undo_proportional_imageEdit'),
        this.cropRatioRedoClass));
    this.redoMap.set('ninetyRotate',
      new RedoModel($r('app.string.redo_ninety_angle_rotate_imageEdit','90'),
        $r('app.string.undo_ninety_angle_rotate_imageEdit','90'), this.ninetyRotateRedoClass));
    this.redoMap.set('mirror',
      new RedoModel($r('app.string.redo_mirror_imageEdit'),
        $r('app.string.undo_mirror_imageEdit'), this.mirrorRedoClass));
    this.redoMap.set('crop',
      new RedoModel($r('app.string.redo_crop_imageEdit'),
        $r('app.string.undo_crop_imageEdit'), this.cropRectRedoClass));
    this.redoMap.set('none', new RedoModel($r('app.string.redo_filter_none_imageEdit'),
      $r('app.string.undo_filter_none_imageEdit'), this.filterRedoClass));
    this.redoMap.set('000000000000000000', new RedoModel($r('app.string.redo_filter_none_imageEdit'),
      $r('app.string.undo_filter_none_imageEdit'), this.filterRedoClass));
  }

  private redoMapUndoAiMove() {
    this.redoMap.set('AISegMove',
      new RedoModel($r('app.string.redo_selection_imageEdit'), $r('app.string.undo_selection_imageEdit'),
        this.aiMoveRedoClass));
    this.redoMap.set('AIMoveObjectCutout', new RedoModel($r('app.string.redo_confirm_selection_imageEdit'),
      $r('app.string.undo_confirm_selection_imageEdit'), this.aiMoveRedoClass));
    this.redoMap.set('AIMoveSegOneStep', new RedoModel($r('app.string.redo_confirm_selection_imageEdit'),
      $r('app.string.undo_confirm_selection_imageEdit'), this.aiMoveRedoClass));
    this.redoMap.set('AIMoveObjectFusion',
      new RedoModel($r('app.string.redo_compose_imageEdit'), $r('app.string.undo_compose_imageEdit'),
        this.aiMoveRedoClass));
    this.redoMap.set('AIMoveObject',
      new RedoModel($r('app.string.redo_move_object_imageEdit'), $r('app.string.undo_move_object_imageEdit'),
        this.aiMoveRedoClass));
    this.redoMap.set('AIMoveObjectCopy',
      new RedoModel($r('app.string.redo_copy_object_imageEdit'), $r('app.string.undo_copy_object_imageEdit'),
        this.aiMoveRedoClass));
    this.redoMap.set('AIMoveObjectDelete',
      new RedoModel($r('app.string.redo_delete_object_imageEdit'), $r('app.string.undo_delete_object_imageEdit'),
        this.aiMoveRedoClass));
    this.redoMap.set('AIMoveObjectAdjustment',
      new RedoModel($r('app.string.redo_adjust_object_imageEdit'), $r('app.string.undo_adjust_object_imageEdit'),
        this.aiMoveRedoClass));
    this.redoMap.set('AIMoveObjectLevel', new RedoModel($r('app.string.redo_adjust_tier_object_imageEdit'),
      $r('app.string.undo_adjust_tier_object_imageEdit'), this.aiMoveRedoClass));
    this.redoMap.set('AIMoveObjectReSegment', new RedoModel($r('app.string.redo_selection_imageEdit'),
      $r('app.string.undo_selection_imageEdit'), this.aiMoveRedoClass));
    this.redoMap.set('AIPasteObjectCutout', new RedoModel($r('app.string.redo_add_patches_imageEdit'),
      $r('app.string.undo_add_patches_imageEdit'), this.aiMoveRedoClass))
  }

  private redoUndoCameraFilter() {
    this.redoMap.set('Classic',
      new RedoModel($r('app.string.redo_filter_classics_imageEdit'),
        $r('app.string.undo_filter_classics_imageEdit'), this.filterRedoClass));
    this.redoMap.set('Moody', new RedoModel($r('app.string.redo_filter_moody_imageEdit'),
      $r('app.string.undo_filter_moody_imageEdit'), this.filterRedoClass));
    this.redoMap.set('Natural', new RedoModel($r('app.string.redo_filter_natural_imageEdit'),
      $r('app.string.undo_filter_natural_imageEdit'), this.filterRedoClass));
    this.redoMap.set('Blossom', new RedoModel($r('app.string.redo_filter_blossom_imageEdit'),
      $r('app.string.undo_filter_blossom_imageEdit'), this.filterRedoClass));
    this.redoMap.set('Fair', new RedoModel($r('app.string.redo_filter_fair_imageEdit'),
      $r('app.string.undo_filter_fair_imageEdit'), this.filterRedoClass));
    this.redoMap.set('Pink',
      new RedoModel($r('app.string.redo_filter_pink_imageEdit'),
        $r('app.string.undo_filter_pink_imageEdit'), this.filterRedoClass));
    this.redoMap.set('Haze_Removal',
      new RedoModel($r('app.string.redo_filter_haze_removal_imageEdit'),
        $r('app.string.undo_filter_haze_removal_imageEdit'), this.filterRedoClass));
  }

  private redoUndoXTStyle() {
    this.redoMap.set('close_xtStyle',
      new RedoModel($r('app.string.redo_xt_style_close_imageEdit'),
        $r('app.string.undo_xt_style_close_imageEdit'), this.xtStyleRedoClass));
    this.redoMap.set('standard_xtStyle', new RedoModel($r('app.string.redo_natural_style'),
      $r('app.string.undo_natural_style'), this.xtStyleRedoClass));
    this.redoMap.set('films_xtStyle', new RedoModel($r('app.string.redo_xt_style_films_imageEdit'),
      $r('app.string.undo_xt_style_films_imageEdit'), this.xtStyleRedoClass));
    this.redoMap.set('romance_xtStyle', new RedoModel($r('app.string.redo_xt_style_romance_imageEdit'),
      $r('app.string.undo_xt_style_romance_imageEdit'), this.xtStyleRedoClass));
    this.redoMap.set('anime_xtStyle', new RedoModel($r('app.string.redo_xt_style_anime_imageEdit'),
      $r('app.string.undo_xt_style_anime_imageEdit'), this.xtStyleRedoClass));
    this.redoMap.set('vivid_xtStyle', new RedoModel($r('app.string.redo_xt_style_bright_imageEdit'),
      $r('app.string.undo_xt_style_bright_imageEdit'), this.xtStyleRedoClass));
    this.redoMap.set('bright_xtStyle', new RedoModel($r('app.string.redo_xt_style_soft_imageEdit'),
      $r('app.string.undo_xt_style_soft_imageEdit'), this.xtStyleRedoClass));
    this.redoMap.set('mono_xtStyle', new RedoModel($r('app.string.redo_xt_style_black_imageEdit'),
      $r('app.string.undo_xt_style_black_imageEdit'), this.xtStyleRedoClass));
  }

  private redoUndoFilter() {
    this.redoMap.set('green_orange',
      new RedoModel($r('app.string.redo_filter_green_orange_imageEdit'),
        $r('app.string.undo_filter_green_orange_imageEdit'), this.filterRedoClass));
    this.redoMap.set('green_orange_strength',
      new RedoModel($r('app.string.redo_filter_green_orange_strength_imageEdit'),
        $r('app.string.undo_filter_green_orange_strength_imageEdit'), this.filterRedoClass));
    this.redoMap.set('sunset', new RedoModel($r('app.string.redo_filter_sunset_imageEdit'),
      $r('app.string.undo_filter_sunset_imageEdit'), this.filterRedoClass));
    this.redoMap.set('sunset_strength',
      new RedoModel($r('app.string.redo_filter_sunset_strength_imageEdit'),
        $r('app.string.undo_filter_sunset_strength_imageEdit'), this.filterRedoClass));
    this.redoMap.set('original', new RedoModel($r('app.string.redo_filter_original_imageEdit'),
      $r('app.string.undo_filter_original_imageEdit'), this.filterRedoClass));
    this.redoMap.set('original_strength',
      new RedoModel($r('app.string.redo_filter_original_strength_imageEdit'),
        $r('app.string.undo_filter_original_strength_imageEdit'), this.filterRedoClass));
    this.redoMap.set('crystal_clear',
      new RedoModel($r('app.string.redo_filter_crystal_clear_imageEdit'),
        $r('app.string.undo_filter_crystal_clear_imageEdit'), this.filterRedoClass));
    this.redoMap.set('crystal_clear_strength',
      new RedoModel($r('app.string.redo_filter_crystal_clear_strength_imageEdit'),
        $r('app.string.undo_filter_crystal_clear_strength_imageEdit'), this.filterRedoClass));
    this.redoMap.set('old_tree', new RedoModel($r('app.string.redo_filter_old_tree_imageEdit'),
      $r('app.string.undo_filter_old_tree_imageEdit'), this.filterRedoClass));
    this.redoMap.set('old_tree_strength',
      new RedoModel($r('app.string.redo_filter_old_tree_strength_imageEdit'),
        $r('app.string.undo_filter_old_tree_strength_imageEdit'), this.filterRedoClass));
    this.redoMap.set('little_luck',
      new RedoModel($r('app.string.redo_filter_little_luck_imageEdit'),
        $r('app.string.undo_filter_little_luck_imageEdit'), this.filterRedoClass));
    this.redoMap.set('little_luck_strength',
      new RedoModel($r('app.string.redo_filter_little_luck_strength_imageEdit'),
        $r('app.string.undo_filter_little_luck_strength_imageEdit'), this.filterRedoClass));
    this.redoMap.set('sweet',
      new RedoModel($r('app.string.redo_filter_sweet_imageEdit'),
        $r('app.string.undo_filter_sweet_imageEdit'), this.filterRedoClass));
    this.redoMap.set('sweet_strength',
      new RedoModel($r('app.string.redo_filter_sweet_strength_imageEdit'),
        $r('app.string.undo_filter_sweet_strength_imageEdit'), this.filterRedoClass));
    this.redoMap.set('middle_tone',
      new RedoModel($r('app.string.redo_filter_middle_tone_imageEdit'),
        $r('app.string.undo_filter_middle_tone_imageEdit'), this.filterRedoClass));
    this.redoMap.set('middle_tone_strength',
      new RedoModel($r('app.string.redo_filter_middle_tone_strength_imageEdit'),
        $r('app.string.undo_filter_middle_tone_strength_imageEdit'), this.filterRedoClass));
    this.redoMap.set('milk_tea', new RedoModel($r('app.string.redo_filter_milk_tea_imageEdit'),
      $r('app.string.undo_filter_milk_tea_imageEdit'), this.filterRedoClass));
    this.redoMap.set('milk_tea_strength',
      new RedoModel($r('app.string.redo_filter_milk_tea_strength_imageEdit'),
        $r('app.string.undo_filter_milk_tea_strength_imageEdit'), this.filterRedoClass));
    this.redoMap.set('black_and_white',
      new RedoModel($r('app.string.redo_filter_black_and_white_imageEdit'),
        $r('app.string.undo_filter_black_and_white_imageEdit'), this.filterRedoClass));
    this.redoMap.set('black_and_white_strength',
      new RedoModel($r('app.string.redo_filter_black_and_white_strength_imageEdit'),
        $r('app.string.undo_filter_black_and_white_strength_imageEdit'), this.filterRedoClass));
  }
}