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
import { TabName } from '../Enum';
import { HiLog } from '../../../common/util/HiLog';
import { BaseEditor } from '../../BaseEditor';
import { App, MenuChangeType } from '../../../service/App';
import { ADJUST_TAG } from '../../../common/const';
import { ButtonItem, TextItem } from '../../../feature/basic/common/view/SelectableProgressButton';
import { Asset } from '../../Asset';
import { MenuAttr } from './MenuAttr';
import sdk from '../../native';
import { NullUtil } from '../../../common/util/NullUtil';
import { ScreenManager } from '../../../common/util/ScreenManager';
import { DeviceUtil } from '../../../common/util/DeviceUtil';

export class AdjustItem {
  public name: string;
  public value: number;
  public enable: number;

  constructor(name: string, value: number, enable: number) {
    this.name = name;
    this.value = value;
    this.enable = enable;
  }
}


@Observed
export class AdjustValueItem {
  public value: number = 0;
  public disabled: boolean = false;
  public originalValue: number = 0;

  public constructor(value: number, disabled: boolean, originalValue: number) {
    this.value = value;
    this.disabled = disabled;
    this.originalValue = originalValue;
  }

  toString(): string {
    return '{value:' + this.value + ` enabled:${this.disabled}` + '}';
  }
}

let tipTimeFn: number | undefined = undefined;
let TAG: string = 'AdjustAttr';

@Observed
export class AdjustAttr extends MenuAttr {
  public hue: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 色相(范围：0~100，默认值：0).
  public saturation: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 饱和度(范围：-100~100，默认值：0).
  public brightness: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 亮度(范围：-100~100，默认值：0).
  public contrast: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 对比度(范围：-100~100，默认值：0).
  public temperature: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 色温(范围：-100~100，默认值：0).
  public sharpness: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 锐度(范围：0~100，默认值：0).
  public fade: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 褪色(范围：0~100，默认值：0).
  public exposure: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 曝光(范围：0~100，默认值：0).
  public grain: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 颗粒(范围：0~100，默认值：0).
  public highlight: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 高光(范围：-100~100，默认值：0).
  public shadow: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 阴影(范围：0~100，默认值：0).
  public vignette: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 暗角(范围：0~100，默认值：0).
  public vibrance: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 自然饱和度(范围：0~100，默认值：0).
  public brightzone: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 亮部(范围：0~100，默认值：0).
  public darkzone: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 暗部(范围：0~100，默认值：0).
  public auto: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 曝光(范围：0~100，默认值：0).
  public tab =
    new ButtonItem($r('app.string.button_bubble_oneClick_adjust_imageEdit'),
      $r('sys.symbol.adjustment'), true, 'default', -1, -1, -1);
  public autoEnable: AdjustValueItem = new AdjustValueItem(0, true, 0); // int: 曝光(范围：0~100，默认值：0).
  public redoAdjustItem: string = '';
  public muteFlag: number = 0; // 是否静音
  public isRefreshValue: boolean = false;
  public isModified: boolean = false;
  public isChanged: boolean = false;
  public autoValHidden: boolean = false; //true表示一键调节的值隐藏
  public autoSelected: boolean = false; //true表示当前选中一键调节
  public barDisabled: boolean = false;
  public isAutoAdjustOn: boolean = false;
  public isXTStyleClear: boolean = false;
  public isResetSelected: boolean = false; // 是否恢复调节初始状态（AI修图/涂鸦-文本/马赛克编辑后需重置）
  public tabs: ButtonItem[] = [
    // new ButtonItem($r('app.string.button_bubble_oneClick_adjust_imageEdit'), $r('sys.symbol.adjustment'),
    //   true, 'auto', -100, 100, 1),
    // new ButtonItem($r('app.string.adjust_exposure_imageEdit'), $r('sys.symbol.exposure'), true,
    //   'exposure', -100, 100, 1),
    // new ButtonItem($r('app.string.adjust_highlights_imageEdit'), $r('sys.symbol.highlights'), true,
    //   'highlight', -100, 100, 1),
    // new ButtonItem($r('app.string.adjust_shadow_imageEdit'), $r('sys.symbol.shadow'), true, 'shadow', -100, 100, 1),
    new ButtonItem($r('app.string.adjust_luma_imageEdit'), $r('sys.symbol.toning'), true, 'brightness', -100, 100, 1),
    new ButtonItem($r('app.string.adjust_contrast_imageEdit'), $r('sys.symbol.contrast'), true,
      'contrast', -100, 100, 1),
    // new ButtonItem($r('app.string.adjust_bright_part_imageEdit'), $r('sys.symbol.bright'),
    //   true, 'brightzone', -100, 100, 1),
    // new ButtonItem($r('app.string.adjust_dark_part_imageEdit'), $r('sys.symbol.dark'), true, 'darkzone', -100, 100, 1),
    // new ButtonItem($r('app.string.adjust_saturation_imageEdit'),
    //   $r('sys.symbol.circle_righthalf_inset_filled'), true, 'saturation', -100, 100, 1),
    // new ButtonItem($r('app.string.adjust_nature_saturation_imageEdit'),
    //   $r('sys.symbol.drop_bottomrighthalf_inset_filled'), true, 'vibrance', -100, 100, 1),
    // new ButtonItem($r('app.string.adjust_temperature_imageEdit'),
    //   $r('sys.symbol.color_temperature_1'), true, 'temperature', -100, 100, 1),
    // new ButtonItem($r('app.string.adjust_hue_imageEdit'), $r('sys.symbol.paintpalette'), true, 'hue', -100, 100, 1),
    // new ButtonItem($r('app.string.adjust_sharpness_imageEdit'), $r('sys.symbol.triangleshape'),
    //   true, 'sharpness', 0, 100, 0.54),
    // new ButtonItem($r('app.string.adjust_vignette_imageEdit'), $r('sys.symbol.circle_square'),
    //   true, 'vignette', -100, 100, 1),
    // new ButtonItem($r('app.string.adjust_fade_imageEdit'), $r('sys.symbol.fade'), true, 'fade', 0, 100, 1),
    // new ButtonItem($r('app.string.adjust_granules_imageEdit'), $r('sys.symbol.particle'), true, 'grain', 0, 100, 1),
  ];
  public adjustTexts: TextItem[] = [
    new TextItem($r('app.string.adjust_auto_true'), 'auto'),
    new TextItem($r('app.string.adjust_exposure_true'), 'exposure'),
    new TextItem($r('app.string.adjust_highlight_true'), 'highlight'),
    new TextItem($r('app.string.adjust_shadow_true'), 'shadow'),
    new TextItem($r('app.string.adjust_brightness_true'), 'brightness'),
    new TextItem($r('app.string.adjust_contrast_true'), 'contrast'),
    new TextItem($r('app.string.adjust_brightzone_true'), 'brightzone'),
    new TextItem($r('app.string.adjust_darkzone_true'), 'darkzone'),
    new TextItem($r('app.string.adjust_saturation_true'), 'saturation'),
    new TextItem($r('app.string.adjust_vibrance_true'), 'vibrance'),
    new TextItem($r('app.string.adjust_temperature_true'), 'temperature'),
    new TextItem($r('app.string.adjust_hue_true'), 'hue'),
    new TextItem($r('app.string.adjust_sharpness_true'), 'sharpness'),
    new TextItem($r('app.string.adjust_vignette_true'), 'vignette'),
    new TextItem($r('app.string.adjust_fade_true'), 'fade'),
    new TextItem($r('app.string.adjust_grain_true'), 'grain'),
  ];
  public adjustScrollTexts: TextItem[] = [
    new TextItem((...params) => $r('app.string.voice_adjust_auto_scroll_100_100', ...params), 'auto'),
    new TextItem((...params) => $r('app.string.voice_adjust_exposure_scroll_100_100', ...params), 'exposure'),
    new TextItem((...params) => $r('app.string.voice_adjust_highlight_scroll_100_100', ...params), 'highlight'),
    new TextItem((...params) => $r('app.string.voice_adjust_shadow_scroll_100_100', ...params), 'shadow'),
    new TextItem((...params) => $r('app.string.voice_adjust_brightness_scroll_100_100', ...params), 'brightness'),
    new TextItem((...params) => $r('app.string.voice_adjust_contrast_scroll_100_100', ...params), 'contrast'),
    new TextItem((...params) => $r('app.string.voice_adjust_brightzone_scroll_100_100', ...params), 'brightzone'),
    new TextItem((...params) => $r('app.string.voice_adjust_darkzone_scroll_100_100', ...params), 'darkzone'),
    new TextItem((...params) => $r('app.string.voice_adjust_saturation_scroll_100_100', ...params), 'saturation'),
    new TextItem((...params) => $r('app.string.voice_adjust_vibrance_scroll_100_100', ...params), 'vibrance'),
    new TextItem((...params) => $r('app.string.voice_adjust_temperature_scroll_100_100', ...params), 'temperature'),
    new TextItem((...params) => $r('app.string.voice_adjust_hue_scroll_100_100', ...params), 'hue'),
    new TextItem((...params) => $r('app.string.voice_adjust_sharpness_scroll_0_100', ...params), 'sharpness'),
    new TextItem((...params) => $r('app.string.voice_adjust_vignette_scroll_100_100', ...params), 'vignette'),
    new TextItem((...params) => $r('app.string.voice_adjust_fade_scroll_0_100', ...params), 'fade'),
    new TextItem((...params) => $r('app.string.voice_adjust_grain_scroll_0_100', ...params), 'grain'),
  ];
  public adjustScrollAngleTexts: TextItem[] = [
    new TextItem((...params) => $r('app.string.voice_adjust_auto_scroll_adjust', ...params), 'auto'),
    new TextItem((...params) => $r('app.string.voice_adjust_exposure_scroll_adjust', ...params), 'exposure'),
    new TextItem((...params) => $r('app.string.voice_adjust_highlight_scroll_adjust', ...params), 'highlight'),
    new TextItem((...params) => $r('app.string.voice_adjust_shadow_scroll_adjust', ...params), 'shadow'),
    new TextItem((...params) => $r('app.string.voice_adjust_brightness_scroll_adjust', ...params), 'brightness'),
    new TextItem((...params) => $r('app.string.voice_adjust_contrast_scroll_adjust', ...params), 'contrast'),
    new TextItem((...params) => $r('app.string.voice_adjust_brightzone_scroll_adjust', ...params), 'brightzone'),
    new TextItem((...params) => $r('app.string.voice_adjust_darkzone_scroll_adjust', ...params), 'darkzone'),
    new TextItem((...params) => $r('app.string.voice_adjust_saturation_scroll_adjust', ...params), 'saturation'),
    new TextItem((...params) => $r('app.string.voice_adjust_vibrance_scroll_adjust', ...params), 'vibrance'),
    new TextItem((...params) => $r('app.string.voice_adjust_temperature_scroll_adjust', ...params), 'temperature'),
    new TextItem((...params) => $r('app.string.voice_adjust_hue_scroll_adjust', ...params), 'hue'),
    new TextItem((...params) => $r('app.string.voice_adjust_sharpness_scroll_adjust', ...params), 'sharpness'),
    new TextItem((...params) => $r('app.string.voice_adjust_vignette_scroll_adjust', ...params), 'vignette'),
    new TextItem((...params) => $r('app.string.voice_adjust_fade_scroll_adjust', ...params), 'fade'),
    new TextItem((...params) => $r('app.string.voice_adjust_grain_scroll_adjust', ...params), 'grain'),
  ];

  constructor(editor: BaseEditor, asset: Asset) {
    super(editor, asset);
    this.getAdjustProperty();
  }

  enterMenu() {
    super.enterMenu();
    this.asset.adjusts().getAdjustProperty();
    if ((TabName.TabAdjust === this.changeTabIndex || this.editor.tabIndex === this.changeTabIndex) &&
      (this.editor.tabIndex != TabName.TabCrop) && !ScreenManager.getInstance().isScreenPortrait()) {
      App.getInstance().screenClass.screenChangeType = MenuChangeType.NO_CROP_TO_NO_CROP;
      HiLog.i(TAG, `change screen type:${App.getInstance().screenClass.screenChangeType}`)
    }
    this.isRefreshValue = false;
    this.syncAutoVal();
    // instrument ignore if
    if (DeviceUtil.isPc()) {
      this.editor.refreshThumbnail.ifRefreshThumbnail = true;
    }
    if (this.tab.state === 1) {
      this.editor.operationTip.setName(this.tab.text);
      this.editor.operationTip.setValue(this.getValueByKey(this.tab.key).value);
      this.editor.operationTip.setDisabled(this.getValueByKey(this.tab.key).disabled);
      HiLog.i('VideoAdjustTool', 'aboutToAppear disabled' + this.getValueByKey(this.tab.key)
        .disabled);
      this.editor.operationTip.tips = true;

      tipTimeFn && clearTimeout(tipTimeFn);
      tipTimeFn = setTimeout((): void => {
        this.editor.operationTip.tips = false;
      }, 1000)
    } else {
      this.editor.operationTip.setName('');
    }
  }

  leaveMenu(index: TabName) {
  }

  SyncDataFromSdk(properties: Object) {
    if (!properties || !(properties instanceof Array) ||
      (properties instanceof Array && properties.length < 12)) {
      HiLog.e('AdjustAttr', 'initialize failed, properties=' + JSON.stringify(properties));
      return;
    }
    if (properties instanceof Array) {
      properties.forEach((prop: AdjustItem) => {
        let key = prop.name;
        let adjustItem = this.getValueByKey(key);
        if (adjustItem != undefined) {
          adjustItem.value =
            prop.enable === 1 || (this.editor.isEdit && this.editor.isSystemEditData) ? prop.value : 0;
          adjustItem.disabled = prop.enable === 1;
          adjustItem.originalValue = prop.value;
        }
      })

      this.tabs.forEach((item: ButtonItem) => {
        let adjustItem = this.getValueByKey(item.key);
        item.value = adjustItem.originalValue;
        // instrument ignore if
        if (DeviceUtil.isPc()) {
          item.state = adjustItem.disabled ? (item.key == ADJUST_TAG ? 1 : 0) : (item.key == ADJUST_TAG ? 0 : 2);
        }
        item.isCheck = adjustItem.disabled && item.value !== 0 ? true : false;
      })
    }
  }

  // 调用SDK接口预置一键调节算法结果，降低响应时延
  syncAutoVal() {
    sdk.Asset_PreloadAdjustResource(this.editor.timeline.id, this.asset.uid);
  }

  /**
   * 获取调节属性效果
   * return 所有调节属性效果json
   */
  getAdjustProperty(): void {
    HiLog.i(TAG, 'Asset: getAdjustProperty');
    let ret: string = sdk.Asset_GetAdjustProperty(this.editor.timeline.id, this.asset.uid);
    HiLog.i(TAG, `Asset: GetAdjustProperty ret=${ret}`);
    let properties: Object = JSON.parse(ret);
    this.SyncDataFromSdk(properties);
  }

  /**
   * 校验是否设置了调节属性
   * @returns true 有非0调节项且未置灰, false 调节项都为0或者都置灰
   */
  public isAdjustModified(): boolean {
    this.isModified = (this.hue.value !== 0 && this.hue.disabled) ||
      (this.saturation.value !== 0 && this.saturation.disabled) ||
      (this.brightness.value !== 0 && this.brightness.disabled) ||
      (this.contrast.value !== 0 && this.contrast.disabled) ||
      (this.temperature.value !== 0 && this.temperature.disabled) ||
      (this.sharpness.value !== 0 && this.sharpness.disabled) ||
      (this.fade.value !== 0 && this.fade.disabled) ||
      (this.exposure.value !== 0 && this.exposure.disabled) ||
      (this.grain.value !== 0 && this.grain.disabled) ||
      (this.highlight.value !== 0 && this.highlight.disabled) ||
      (this.shadow.value !== 0 && this.shadow.disabled) ||
      (this.vignette.value !== 0 && this.vignette.disabled) ||
      (this.vibrance.value !== 0 && this.vibrance.disabled) ||
      (this.brightzone.value !== 0 && this.brightzone.disabled) ||
      (this.auto.value !== 0 && !this.autoValHidden) ||
      (this.darkzone.value !== 0 && this.darkzone.disabled);
    return this.isModified;
  }

  public setEnable(adjustEnableName: string, enable: boolean, cb?: (strength: number) => void): void {
    console.log('Asset: setAdjustEnable adjustType: ' + adjustEnableName + ` enable: ${enable}`);
    let adjustItem: AdjustValueItem = this.getValueByKey(adjustEnableName);
    adjustItem.disabled = enable;
    this.isAdjustModified();
    sdk.Asset_SetAdjustEnable(this.editor.timeline.id, this.asset.uid, adjustEnableName, enable,
      (ret: string) => {
        if (adjustEnableName !== ADJUST_TAG) {
          return;
        }
        let adjustVal: Object = JSON.parse(ret);
        animateTo({
          duration: 100, // 动画时长
          playMode: PlayMode.Alternate, // 动画模式
        }, () => {
          if (NullUtil.isObjNull(adjustVal) || !(adjustVal instanceof Array)) {
            return;
          }
          adjustVal.forEach((item: AdjustItem) => {
            let index = this.tabs.findIndex(tab => {
              return tab.key === item.name;
            })
            this.tabs[index].value = item.value;
            this.tabs[index].isCheck = item.value !== 0;
            if (item.name !== ADJUST_TAG) {
              this.tabs[index].state = 0;
            }
            this.getValueByKey(item.name).value = item.value;
            this.getValueByKey(item.name).originalValue = item.value;
            this.getValueByKey(item.name).disabled = item.enable === 1;
            if (item.name == ADJUST_TAG && cb !== null && cb !== undefined) {
              cb(item.value);
            }
          })
          this.isChanged = true;
          if (this.editor.isEdit) {
            this.editor.isShowRevert = !this.editor.isEdited();
          }
        })
      });
  }

  refreshAdjustValue(adjustName: string, value: number) {
    let adjustItem: AdjustValueItem = this.getValueByKey(adjustName);
    if (adjustItem.value === value) {
      return;
    }
    adjustItem.value = value;
  }

  /**
   * 设置Asset的调节属性，包括亮度、对比度、饱和度等。
   *
   * @param adjustName 效果类型 @ref AdjustKey
   * @param value 调节属性值
   * @param isEnableChecked pc的checkbox是否被动打开
   */
  setValue(adjustName: string, value: number, isEnableChecked?: boolean): void {
    this.refreshAdjustValue(adjustName, value);
    const callback = (ret: string): void => {
      let adjustVal: Object = JSON.parse(ret);
      if (!adjustVal || !(adjustVal instanceof Array)) {
        return;
      }

      adjustVal.forEach((item: AdjustItem) => {
        let index = this.tabs.findIndex(tab => {
          return tab.key === item.name;
        })
        this.tabs[index].value = item.value;
        this.tabs[index].isCheck = item.value !== 0;
        this.getValueByKey(item.name).value = item.value;
        this.getValueByKey(item.name).disabled = Boolean(item.enable);
      })
    }
    if (adjustName == ADJUST_TAG) {
      sdk.Asset_SetAdjustValue(this.editor.timeline.id, this.asset.uid, adjustName, value, callback);
    } else if (isEnableChecked) {
      sdk.Asset_SetAdjustValueAndEnable(this.editor.timeline.id, this.asset.uid, adjustName, value);
    } else {
      sdk.Asset_SetAdjustValue(this.editor.timeline.id, this.asset.uid, adjustName, value);
    }

  }

  /**
   * 根据key获取对应属性
   *
   * @param key ButtonItem.key
   * @returns AdjustValueItem
   */
  getValueByKey(key: string): AdjustValueItem {
    switch (key) {
      case 'vignette':
        return this.vignette;
      case 'contrast':
        return this.contrast;
      case 'saturation':
        return this.saturation;
      case 'hue':
        return this.hue;
      case 'temperature':
        return this.temperature;
      case 'sharpness':
        return this.sharpness;
      case 'highlight':
        return this.highlight;
      case 'shadow':
        return this.shadow;
      case 'fade':
        return this.fade;
      case 'brightness':
        return this.brightness;
      case 'grain':
        return this.grain;
      case 'vibrance':
        return this.vibrance;
      case 'brightzone':
        return this.brightzone;
      case 'darkzone':
        return this.darkzone;
      case 'exposure':
        return this.exposure;
      default:
        return this.auto;
    }
  }
}