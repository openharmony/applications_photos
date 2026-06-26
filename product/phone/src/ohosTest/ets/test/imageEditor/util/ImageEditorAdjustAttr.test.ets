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
import { describe, expect, it, beforeEach, beforeAll} from '@ohos/hypium';
import { Log } from '@ohos/tools/src/main/utils/Log';
import { AdjustAttr  } from '../../../../../../../../imageEditor/common/src/main/ets/service/model/menu/AdjustAttr';
import { BaseEditor } from '../../../../../../../../imageEditor/common/src/main/ets/service/BaseEditor';
import { Asset } from '../../../../../../../../imageEditor/common/src/main/ets/service/Asset';

const TAG: string = `AdjustAttrTest`;

export default function ImageEditorAdjustAttrTest() {
  describe('ImageEditorAdjustAttrTest',() => {
    let editor: BaseEditor;
    let adjustAttr: AdjustAttr;
    let asset: Asset;
    let instance: AdjustAttr;

    beforeAll(() => {
      Log.info(TAG, `ImageEditorAdjustAttrTest start`);
      editor = new BaseEditor();
      asset = new Asset(editor);
      adjustAttr = new AdjustAttr(editor, asset);
      instance = new AdjustAttr(editor, asset);
    });

    beforeEach(() => {
      // 初始化所有属性为默认值（value = 0，disabled = false）
      instance.hue.value = 0;
      instance.hue.disabled = false;
      instance.saturation.value = 0;
      instance.saturation.disabled = false;
      instance.brightness.value = 0;
      instance.brightness.disabled = false;
      instance.contrast.value = 0;
      instance.contrast.disabled = false;
      instance.temperature.value = 0;
      instance.temperature.disabled = false;
      instance.sharpness.value = 0;
      instance.sharpness.disabled = false;
      instance.fade.value = 0;
      instance.fade.disabled = false;
      instance.exposure.value = 0;
      instance.exposure.disabled = false;
      instance.grain.value = 0;
      instance.grain.disabled = false;
      instance.highlight.value = 0;
      instance.highlight.disabled = false;
      instance.shadow.value = 0;
      instance.shadow.disabled = false;
      instance.vignette.value = 0;
      instance.vignette.disabled = false;
      instance.vibrance.value = 0;
      instance.vibrance.disabled = false;
      instance.brightzone.value = 0;
      instance.brightzone.disabled = false;
      instance.auto.value = 0;
      instance.autoValHidden = true; // 默认为 true
      instance.darkzone.value = 0;
      instance.darkzone.disabled = false;
    });

    it('AdjustAttrTest_isAdjustModified_01', 0,() => {
      // 设置有色相调节能力
      instance.hue.value = 1;
      instance.hue.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_02', 0, () => {
      // 确保所有属性的value为0或disabled为false
      expect(instance.isAdjustModified()).assertFalse();
    });

    it('AdjustAttrTest_isAdjustModified_03', 0, () => {
      // 设置不具备色相调节能力
      instance.hue.value = 1;
      instance.hue.disabled = false;
      expect(instance.isAdjustModified()).assertFalse();
    });

    it('AdjustAttrTest_isAdjustModified_04', 0, () => {
      // 设置具备饱和度调节能力
      instance.saturation.value = 1;
      instance.saturation.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_05', 0, () => {
      // 设置具备亮度调节能力
      instance.brightness.value = 1;
      instance.brightness.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_06', 0, () => {
      // 设置具备对比度调节能力
      instance.contrast.value = 1;
      instance.contrast.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_07', 0, () => {
      // 设置具备色温调节能力
      instance.temperature.value = 1;
      instance.temperature.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_08', 0, () => {
      // 设置具备锐度调节能力
      instance.sharpness.value = 1;
      instance.sharpness.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_09', 0, () => {
      // 设置具备褪色调节能力
      instance.fade.value = 1;
      instance.fade.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_10', 0, () => {
      // 设置具备曝光调节能力
      instance.exposure.value = 1;
      instance.exposure.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_11', 0, () => {
      // 设置具备颗粒度调节能力
      instance.grain.value = 1;
      instance.grain.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_12', 0, () => {
      // 设置具备高光调节能力
      instance.highlight.value = 1;
      instance.highlight.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_13', 0, () => {
      // 设置具备阴影调节能力
      instance.shadow.value = 1;
      instance.shadow.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_14', 0, () => {
      // 设置具备暗角调节能力
      instance.vignette.value = 1;
      instance.vignette.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_15', 0, () => {
      // 设置具备自然饱和度调节能力
      instance.vibrance.value = 1;
      instance.vibrance.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_16', 0, () => {
      // 设置具备亮部调节能力
      instance.brightzone.value = 1;
      instance.brightzone.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_17', 0, () => {
      // 设置具备曝光调节能力
      instance.auto.value = 1;
      instance.autoValHidden = false;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_18', 0, () => {
      // 设置具备暗部调节能力
      instance.darkzone.value = 1;
      instance.darkzone.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_19', 0, () => {
      // 不具备调节能力
      expect(instance.isAdjustModified()).assertFalse();
    });

    it('AdjustAttrTest_isAdjustModified_20', 0, () => {
      instance.hue.value = 1;
      instance.hue.disabled = true;
      instance.saturation.value = 1;
      instance.saturation.disabled = true;
      expect(instance.isAdjustModified()).assertTrue();
    });

    it('AdjustAttrTest_isAdjustModified_21', 0, () => {
      instance.hue.value = 1;
      instance.hue.disabled = false;
      expect(instance.isAdjustModified()).assertFalse();
    });

    it('AdjustAttrTest_isAdjustModified_22', 0, () => {
      instance.auto.value = 1;
      instance.autoValHidden = true;
      expect(instance.isAdjustModified()).assertFalse();
    });

    it('AdjustAttrTest_getValueByKey_contrast', 0, () => {
      const result = adjustAttr.getValueByKey('contrast');
      expect(result).assertEqual(adjustAttr.contrast);
    });

    it('AdjustAttrTest_getValueByKey_saturation', 0, () => {
      const result = adjustAttr.getValueByKey('saturation');
      expect(result).assertEqual(adjustAttr.saturation);
    });

    it('AdjustAttrTest_getValueByKey_hue', 0, () => {
      const result = adjustAttr.getValueByKey('hue');
      expect(result).assertEqual(adjustAttr.hue);
    });

    it('AdjustAttrTest_getValueByKey_temperature', 0, () => {
      const result = adjustAttr.getValueByKey('temperature');
      expect(result).assertEqual(adjustAttr.temperature);
    });

    it('AdjustAttrTest_getValueByKey_sharpness', 0, () => {
      const result = adjustAttr.getValueByKey('sharpness');
      expect(result).assertEqual(adjustAttr.sharpness);
    });

    it('AdjustAttrTest_getValueByKey_highlight', 0, () => {
      const result = adjustAttr.getValueByKey('highlight');
      expect(result).assertEqual(adjustAttr.highlight);
    });

    it('AdjustAttrTest_getValueByKey_shadow', 0, () => {
      const result = adjustAttr.getValueByKey('shadow');
      expect(result).assertEqual(adjustAttr.shadow);
    });

    it('AdjustAttrTest_getValueByKey_fade', 0, () => {
      const result = adjustAttr.getValueByKey('fade');
      expect(result).assertEqual(adjustAttr.fade);
    });

    it('AdjustAttrTest_getValueByKey_brightness', 0, () => {
      const result = adjustAttr.getValueByKey('brightness');
      expect(result).assertEqual(adjustAttr.brightness);
    });

    it('AdjustAttrTest_getValueByKey_grain', 0, () => {
      const result = adjustAttr.getValueByKey('grain');
      expect(result).assertEqual(adjustAttr.grain);
    });

    it('AdjustAttrTest_getValueByKey_vibrance', 0, () => {
      const result = adjustAttr.getValueByKey('vibrance');
      expect(result).assertEqual(adjustAttr.vibrance);
    });

    it('AdjustAttrTest_getValueByKey_brightzone', 0, () => {
      const result = adjustAttr.getValueByKey('brightzone');
      expect(result).assertEqual(adjustAttr.brightzone);
    });

    it('AdjustAttrTest_getValueByKey_darkzone', 0, () => {
      const result = adjustAttr.getValueByKey('darkzone');
      expect(result).assertEqual(adjustAttr.darkzone);
    });

    it('AdjustAttrTest_getValueByKey_exposure', 0, () => {
      const result = adjustAttr.getValueByKey('exposure');
      expect(result).assertEqual(adjustAttr.exposure);
    });

    // 测试 default 分支
    it('AdjustAttrTest_getValueByKey_auto', 0, () => {
      const result = adjustAttr.getValueByKey('unknown_key');
      expect(result).assertEqual(adjustAttr.auto);
    });
  });
}