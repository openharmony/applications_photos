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
import { describe, expect, it } from '@ohos/hypium'
import { UiUtil } from '../../../../../../../../imageEditor/common/src/main/ets/common/util/UiUtil';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';

export default function MovingUiUtilTest() {
  describe('MovingUiUtilTest_1', () => {
    it('showToast_null', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.showToast('', 0, '0');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('showToast_0', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.showToast('', 100, '0');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('showToast_15', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.showToast('', 0, '15%');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('showToast', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.showToast('Uitest', 0, '0');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('showToast_Uitest_1000', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.showToast('Uitest', 1000, '0');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('showToast_Uitest_15', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.showToast('Uitest', 1000, '15%');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('showToast_photo', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.showToast('Uitest', 1000, '15%');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('showToast_photo_1000', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.showToast('', 1000, '');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('showToast_photo_15', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.showToast('', 0, '15%');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('showToast_photo_0', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.showToast('', 0, '0');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('getString_1', TestConstants.TEST_LEVEL_ZERO, async () => {
      let context: Context = getContext();
      let source: Resource = $r('app.string.tabs_cut');
      UiUtil.getString(source, context);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('getString_null', TestConstants.TEST_LEVEL_ZERO, async () => {
      let context: Context = getContext();
      let source: Resource = $r('app.string.tabs_cut');
      source = {} as Resource;
      UiUtil.getString(source, context);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });
  });

  describe('MovingUiUtilTest_2', () => {
    it('getStringLength_null', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('');
      expect(UiUtil.getStringLength('')).assertEqual(0);
    });

    it('getStringLength_11', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('11');
      expect(UiUtil.getStringLength('11')).assertEqual(2);
    });

    it('getStringLength_photo', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('photo');
      expect(UiUtil.getStringLength('photo')).assertEqual(5);
    });

    it('getStringLength_media', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('media');
      expect(UiUtil.getStringLength('media')).assertEqual(5);
    });

    it('getStringLength_move', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('move');
      expect(UiUtil.getStringLength('move')).assertEqual(4);
    });

    it('getStringLength_moves', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('moves');
      expect(UiUtil.getStringLength('moves')).assertEqual(5);
    });

    it('getStringLength_moving', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('moving');
      expect(UiUtil.getStringLength('moving')).assertEqual(6);
    });

    it('getStringLength_1', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('1');
      expect(UiUtil.getStringLength('1')).assertEqual(1);
    });

    it('getStringLength_petalClip_topToolBar_back', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('petalClip_topToolBar_back');
      expect(UiUtil.getStringLength('petalClip_topToolBar_back')).assertEqual(25);
    });

    it('getStringLength_petalClip', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('petalClip');
      expect(UiUtil.getStringLength('petalClip')).assertEqual(9);
    });

    it('getStringLength_topToolBar', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('topToolBar');
      expect(UiUtil.getStringLength('topToolBar')).assertEqual(10);
    });

    it('getStringLength_back', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('back');
      expect(UiUtil.getStringLength('back')).assertEqual(4);
    });

    it('getStringLength_edit', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('edit');
      expect(UiUtil.getStringLength('edit')).assertEqual(4);
    });

    it('getStringLength_save', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('save');
      expect(UiUtil.getStringLength('save')).assertEqual(4);
    });

    it('getStringLength_cropTool', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('cropTool');
      expect(UiUtil.getStringLength('cropTool')).assertEqual(8);
    });

    it('getStringLength_rotateBtn', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('rotateBtn');
      expect(UiUtil.getStringLength('rotateBtn')).assertEqual(9);
    });

    it('getStringLength_mirrorBtn', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('mirrorBtn');
      expect(UiUtil.getStringLength('mirrorBtn')).assertEqual(9);
    });

    it('getStringLength_rulerScroller', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('rulerScroller');
      expect(UiUtil.getStringLength('rulerScroller')).assertEqual(13);
    });

    it('getStringLength_RulerBar', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('RulerBar');
      expect(UiUtil.getStringLength('RulerBar')).assertEqual(8);
    });

    it('getStringLength_cropTab', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('cropTab');
      expect(UiUtil.getStringLength('cropTab')).assertEqual(7);
    });

    it('getStringLength_intelligentCorrection', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('intelligentCorrection');
      expect(UiUtil.getStringLength('intelligentCorrection')).assertEqual(21);
    });

    it('getStringLength_off', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('off');
      expect(UiUtil.getStringLength('off')).assertEqual(3);
    });

    it('getStringLength_on', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('on');
      expect(UiUtil.getStringLength('on')).assertEqual(2);
    });

    it('getStringLength_rotation', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('rotation');
      expect(UiUtil.getStringLength('rotation')).assertEqual(8);
    });

    it('getStringLength_horizontalCorrection', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('horizontalCorrection');
      expect(UiUtil.getStringLength('horizontalCorrection')).assertEqual(20);
    });

    it('getStringLength_verticalCorrection', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('verticalCorrection');
      expect(UiUtil.getStringLength('verticalCorrection')).assertEqual(18);
    });

    it('getStringLength_ratio', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('ratio');
      expect(UiUtil.getStringLength('ratio')).assertEqual(5);
    });

    it('getStringLength_AiRetouch', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('AiRetouch');
      expect(UiUtil.getStringLength('AiRetouch')).assertEqual(9);
    });

    it('getStringLength_bottomToolBar', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('bottomToolBar');
      expect(UiUtil.getStringLength('bottomToolBar')).assertEqual(13);
    });

    it('getStringLength_image', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('image');
      expect(UiUtil.getStringLength('image')).assertEqual(5);
    });

    it('getStringLength_image_1', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('image_1');
      expect(UiUtil.getStringLength('image_1')).assertEqual(7);
    });

    it('getStringLength_text_1', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('text_1');
      expect(UiUtil.getStringLength('text_1')).assertEqual(6);
    });

    it('getStringLength_text', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('text');
      expect(UiUtil.getStringLength('text')).assertEqual(4);
    });

    it('getStringLength_image_2', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('image_2');
      expect(UiUtil.getStringLength('image_2')).assertEqual(7);
    });

    it('getStringLength_text_2', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('text_2');
      expect(UiUtil.getStringLength('text_2')).assertEqual(6);
    });

    it('getStringLength_image_4', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('image_4');
      expect(UiUtil.getStringLength('image_4')).assertEqual(7);
    });

    it('getStringLength_text_4', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('text_4');
      expect(UiUtil.getStringLength('text_4')).assertEqual(6);
    });

    it('getStringLength_bottomToolBar_7', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('bottomToolBar_7');
      expect(UiUtil.getStringLength('bottomToolBar_7')).assertEqual(15);
    });

    it('getStringLength_image_7', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('image_7');
      expect(UiUtil.getStringLength('image_7')).assertEqual(7);
    });

    it('getStringLength_text_7', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('text_7');
      expect(UiUtil.getStringLength('text_7')).assertEqual(6);
    });

    it('getStringLength_image_8', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('image_8');
      expect(UiUtil.getStringLength('image_8')).assertEqual(7);
    });

    it('getStringLength_text_8', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('text_8');
      expect(UiUtil.getStringLength('text_8')).assertEqual(6);
    });

    it('getStringLength_image_9', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('image_9');
      expect(UiUtil.getStringLength('image_9')).assertEqual(7);
    });

    it('getStringLength_text_9', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStringLength('text_9');
      expect(UiUtil.getStringLength('text_9')).assertEqual(6);
    });

  });

  describe('MovingUiUtilTest_3', () => {
    it('vibrateById_1', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('1');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_2', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('2');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_3', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('3');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_4', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('4');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_5', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('5');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_6', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('6');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_7', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('7');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_8', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('8');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_9', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('9');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_10', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('10');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_11', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('11');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });
    it('vibrateById_12', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('12');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_13', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('13');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_14', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('14');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_15', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('15');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_16', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('16');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_17', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('17');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_18', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('18');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_19', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('19');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrateById_20', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrateById('20');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });
  });

  describe('MovingUiUtilTest_4', () => {
    it('vibrate_1', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('1');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_2', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('2');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_3', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('3');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_4', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('4');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_5', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('5');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_6', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('6');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_7', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('7');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_8', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('8');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_9', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('9');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_10', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('10');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_11', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('11');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });
    it('vibrate_12', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('12');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_13', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('13');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_14', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('14');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_15', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('15');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_16', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('16');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_17', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('17');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_18', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('18');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_19', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('19');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('vibrate_20', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.vibrate('20');
      expect(UiUtil.isPrivacyPage).assertFalse();
    });
  });

  describe('MovingUiUtilTest_5', () => {
    it('getStatusBarHeight', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStatusBarHeight();
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_1', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(1);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_2', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(2);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_3', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(3);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_4', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(4);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_5', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(5);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_6', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(6);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_7', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(7);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_8', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(8);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_9', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(9);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_10', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(10);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_11', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(11);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_12', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(12);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_13', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(13);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_14', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(14);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_15', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(15);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_16', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(16);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_17', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(17);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_18', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(18);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_19', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(19);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('sleep_20', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.sleep(20);
      expect(UiUtil.isPrivacyPage).assertFalse();
    });

    it('convertResource2Num', TestConstants.TEST_LEVEL_ZERO, async () => {
      UiUtil.getStatusBarHeight();
      expect(UiUtil.isPrivacyPage).assertFalse();
    });
  });
}