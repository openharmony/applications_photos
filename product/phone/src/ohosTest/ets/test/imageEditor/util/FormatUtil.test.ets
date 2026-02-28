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
import { describe, expect, it } from '@ohos/hypium';
import { Log } from '@ohos/tools/src/main/utils/Log';
import { FormatUtil } from '../../../../../../../../imageEditor/common/src/main/ets/common/util/FormatUtil';

const TAG = 'FOR';

export default function FormatUtilTest() {
  describe('FormatUtilTest', () => {
    it('FormatUtilTest_nameByDate_trueParam', 0, () => {
      let nameByDate = FormatUtil.nameByDate(true);
      expect(nameByDate).assertContain('VID_');
    })
    it('FormatUtilTest_nameByDate_falseParam', 0, () => {
      let nameByDate = FormatUtil.nameByDate(false);
      expect(nameByDate).assertContain('IMG_');
    })
    it('FormatUtilTest_formatDate_0', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('000_000');
      expect(stringDate).assertEqual('000_000_000')
    })

    it('FormatUtilTest_formatDate_1', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffffffff');
      expect(stringDate).assertEqual('255_255_255')
    })

    it('FormatUtilTest_formatDate_2', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00000000');
      expect(stringDate).assertEqual('000_000_000')
    })

    it('FormatUtilTest_formatDate_3', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffb28133');
      expect(stringDate).assertEqual('178_129_051')
    })

    it('FormatUtilTest_formatDate_4', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#fff0d5e4');
      expect(stringDate).assertEqual('240_213_228')
    })

    it('FormatUtilTest_formatDate_5', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffb8fa15');
      expect(stringDate).assertEqual('184_250_021')
    })

    it('FormatUtilTest_formatDate_6', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff35f715');
      expect(stringDate).assertEqual('053_247_021')
    })

    it('FormatUtilTest_formatDate_7', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffebcb71');
      expect(stringDate).assertEqual('235_203_113')
    })

    it('FormatUtilTest_formatDate_8', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff7cd260');
      expect(stringDate).assertEqual('124_210_096')
    })

    it('FormatUtilTest_formatDate_9', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffcaaf9d');
      expect(stringDate).assertEqual('202_175_157')
    })

    it('FormatUtilTest_formatDate_10', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff94f0e4');
      expect(stringDate).assertEqual('148_240_228')
    })

    it('FormatUtilTest_formatDate_11', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff19c59f');
      expect(stringDate).assertEqual('025_197_159')
    })

    it('FormatUtilTest_formatDate_12', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffe7ee20');
      expect(stringDate).assertEqual('231_238_032')
    })

    it('FormatUtilTest_formatDate_13', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#fff4a221');
      expect(stringDate).assertEqual('244_162_033')
    })

    it('FormatUtilTest_formatDate_14', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffa813f7');
      expect(stringDate).assertEqual('168_019_247')
    })

    it('FormatUtilTest_formatDate_15', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff8dcb72');
      expect(stringDate).assertEqual('141_203_114')
    })

    it('FormatUtilTest_formatDate_16', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff22816a');
      expect(stringDate).assertEqual('034_129_106')
    })

    it('FormatUtilTest_formatDate_17', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff37ec36');
      expect(stringDate).assertEqual('055_236_054')
    })

    it('FormatUtilTest_formatDate_18', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff286988');
      expect(stringDate).assertEqual('040_105_136')
    })

    it('FormatUtilTest_formatDate_19', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff883538');
      expect(stringDate).assertEqual('136_053_056')
    })

    it('FormatUtilTest_formatDate_20', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffa549a8');
      expect(stringDate).assertEqual('165_073_168')
    })

    it('FormatUtilTest_formatDate_21', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff0b636e');
      expect(stringDate).assertEqual('011_099_110')
    })

    it('FormatUtilTest_formatDate_22', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffaacadd');
      expect(stringDate).assertEqual('170_202_221')
    })

    it('FormatUtilTest_formatDate_23', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffcabf00');
      expect(stringDate).assertEqual('202_191_000')
    })

    it('FormatUtilTest_formatDate_24', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffebe713');
      expect(stringDate).assertEqual('235_231_019')
    })

    it('FormatUtilTest_formatDate_25', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff63f4df');
      expect(stringDate).assertEqual('099_244_223')
    })

    it('FormatUtilTest_formatDate_26', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffd597e0');
      expect(stringDate).assertEqual('213_151_224')
    })

    it('FormatUtilTest_formatDate_27', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffbfcecd');
      expect(stringDate).assertEqual('191_206_205')
    })

    it('FormatUtilTest_formatDate_28', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff767737');
      expect(stringDate).assertEqual('118_119_055')
    })

    it('FormatUtilTest_formatDate_29', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#fffe7feb');
      expect(stringDate).assertEqual('254_127_235')
    })

    it('FormatUtilTest_formatDate_30', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffb72636');
      expect(stringDate).assertEqual('183_038_054')
    })

    it('FormatUtilTest_formatDate_31', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff603119');
      expect(stringDate).assertEqual('096_049_025')
    })

    it('FormatUtilTest_formatDate_32', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffcf5be3');
      expect(stringDate).assertEqual('207_091_227')
    })

    it('FormatUtilTest_formatDate_33', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffada523');
      expect(stringDate).assertEqual('173_165_035')
    })

    it('FormatUtilTest_formatDate_34', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffad110c');
      expect(stringDate).assertEqual('173_017_012')
    })

    it('FormatUtilTest_formatDate_35', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffc07501');
      expect(stringDate).assertEqual('192_117_001')
    })

    it('FormatUtilTest_formatDate_36', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff20ca98');
      expect(stringDate).assertEqual('032_202_152')
    })

    it('FormatUtilTest_formatDate_37', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff808be7');
      expect(stringDate).assertEqual('128_139_231')
    })

    it('FormatUtilTest_formatDate_38', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff4e81de');
      expect(stringDate).assertEqual('078_129_222')
    })

    it('FormatUtilTest_formatDate_39', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff86005e');
      expect(stringDate).assertEqual('134_000_094')
    })

    it('FormatUtilTest_formatDate_40', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff72b784');
      expect(stringDate).assertEqual('114_183_132')
    })

    it('FormatUtilTest_formatDate_41', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff281935');
      expect(stringDate).assertEqual('040_025_053')
    })

    it('FormatUtilTest_formatDate_42', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff416890');
      expect(stringDate).assertEqual('065_104_144')
    })

    it('FormatUtilTest_formatDate_43', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff2595b5');
      expect(stringDate).assertEqual('037_149_181')
    })

    it('FormatUtilTest_formatDate_44', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffc8c2c7');
      expect(stringDate).assertEqual('200_194_199')
    })

    it('FormatUtilTest_formatDate_45', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffd4833d');
      expect(stringDate).assertEqual('212_131_061')
    })

    it('FormatUtilTest_formatDate_46', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff552487');
      expect(stringDate).assertEqual('085_036_135')
    })

    it('FormatUtilTest_formatDate_47', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff6ea492');
      expect(stringDate).assertEqual('110_164_146')
    })

    it('FormatUtilTest_formatDate_48', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffd57314');
      expect(stringDate).assertEqual('213_115_020')
    })

    it('FormatUtilTest_formatDate_49', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffb4f915');
      expect(stringDate).assertEqual('180_249_021')
    })

    it('FormatUtilTest_formatDate_50', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff13eb4c');
      expect(stringDate).assertEqual('019_235_076')
    })

    it('FormatUtilTest_formatDate_51', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff189465');
      expect(stringDate).assertEqual('024_148_101')
    })

    it('FormatUtilTest_formatDate_52', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff4dd54d');
      expect(stringDate).assertEqual('077_213_077')
    })

    it('FormatUtilTest_formatDate_53', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff5e7be2');
      expect(stringDate).assertEqual('094_123_226')
    })

    it('FormatUtilTest_formatDate_54', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff1444a5');
      expect(stringDate).assertEqual('020_068_165')
    })

    it('FormatUtilTest_formatDate_55', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffdb98a9');
      expect(stringDate).assertEqual('219_152_169')
    })

    it('FormatUtilTest_formatDate_56', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff98ed4d');
      expect(stringDate).assertEqual('152_237_077')
    })

    it('FormatUtilTest_formatDate_57', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff21db71');
      expect(stringDate).assertEqual('033_219_113')
    })

    it('FormatUtilTest_formatDate_58', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffb3b1e4');
      expect(stringDate).assertEqual('179_177_228')
    })

    it('FormatUtilTest_formatDate_59', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff48e55e');
      expect(stringDate).assertEqual('072_229_094')
    })

    it('FormatUtilTest_formatDate_60', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff5df9ca');
      expect(stringDate).assertEqual('093_249_202')
    })

    it('FormatUtilTest_formatDate_61', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffa9915f');
      expect(stringDate).assertEqual('169_145_095')
    })

    it('FormatUtilTest_formatDate_62', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff8fdeb4');
      expect(stringDate).assertEqual('143_222_180')
    })

    it('FormatUtilTest_formatDate_63', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff5cbc30');
      expect(stringDate).assertEqual('092_188_048')
    })

    it('FormatUtilTest_formatDate_64', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff4051f3');
      expect(stringDate).assertEqual('064_081_243')
    })

    it('FormatUtilTest_formatDate_65', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff652d8c');
      expect(stringDate).assertEqual('101_045_140')
    })

    it('FormatUtilTest_formatDate_66', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff8e46fa');
      expect(stringDate).assertEqual('142_070_250')
    })

    it('FormatUtilTest_formatDate_67', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffdb67d6');
      expect(stringDate).assertEqual('219_103_214')
    })

    it('FormatUtilTest_formatDate_68', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffcd9a09');
      expect(stringDate).assertEqual('205_154_009')
    })

    it('FormatUtilTest_formatDate_69', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffb2e2ee');
      expect(stringDate).assertEqual('178_226_238')
    })

    it('FormatUtilTest_formatDate_70', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff12bf68');
      expect(stringDate).assertEqual('018_191_104')
    })

    it('FormatUtilTest_formatDate_71', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff5ce9f9');
      expect(stringDate).assertEqual('092_233_249')
    })

    it('FormatUtilTest_formatDate_72', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffbbf859');
      expect(stringDate).assertEqual('187_248_089')
    })

    it('FormatUtilTest_formatDate_73', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff705516');
      expect(stringDate).assertEqual('112_085_022')
    })

    it('FormatUtilTest_formatDate_74', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff211567');
      expect(stringDate).assertEqual('033_021_103')
    })

    it('FormatUtilTest_formatDate_75', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff157b15');
      expect(stringDate).assertEqual('021_123_021')
    })

    it('FormatUtilTest_formatDate_76', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffa2895b');
      expect(stringDate).assertEqual('162_137_091')
    })

    it('FormatUtilTest_formatDate_77', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff9de542');
      expect(stringDate).assertEqual('157_229_066')
    })

    it('FormatUtilTest_formatDate_78', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#fff3b35c');
      expect(stringDate).assertEqual('243_179_092')
    })

    it('FormatUtilTest_formatDate_79', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#fffc6640');
      expect(stringDate).assertEqual('252_102_064')
    })

    it('FormatUtilTest_formatDate_80', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffecf77f');
      expect(stringDate).assertEqual('236_247_127')
    })

    it('FormatUtilTest_formatDate_81', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffd45469');
      expect(stringDate).assertEqual('212_084_105')
    })

    it('FormatUtilTest_formatDate_82', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffcf8fe1');
      expect(stringDate).assertEqual('207_143_225')
    })

    it('FormatUtilTest_formatDate_83', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffa88038');
      expect(stringDate).assertEqual('168_128_056')
    })

    it('FormatUtilTest_formatDate_84', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffbea1cc');
      expect(stringDate).assertEqual('190_161_204')
    })

    it('FormatUtilTest_formatDate_85', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffa636c7');
      expect(stringDate).assertEqual('166_054_199')
    })

    it('FormatUtilTest_formatDate_86', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff3b5852');
      expect(stringDate).assertEqual('059_088_082')
    })

    it('FormatUtilTest_formatDate_87', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff967538');
      expect(stringDate).assertEqual('150_117_056')
    })

    it('FormatUtilTest_formatDate_88', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff586aeb');
      expect(stringDate).assertEqual('088_106_235')
    })

    it('FormatUtilTest_formatDate_89', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffb467d1');
      expect(stringDate).assertEqual('180_103_209')
    })

    it('FormatUtilTest_formatDate_90', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff74d34a');
      expect(stringDate).assertEqual('116_211_074')
    })

    it('FormatUtilTest_formatDate_91', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#fff4a91e');
      expect(stringDate).assertEqual('244_169_030')
    })

    it('FormatUtilTest_formatDate_92', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffddf8ae');
      expect(stringDate).assertEqual('221_248_174')
    })

    it('FormatUtilTest_formatDate_93', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffc0a1ae');
      expect(stringDate).assertEqual('192_161_174')
    })

    it('FormatUtilTest_formatDate_94', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff78df50');
      expect(stringDate).assertEqual('120_223_080')
    })

    it('FormatUtilTest_formatDate_95', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff450606');
      expect(stringDate).assertEqual('069_006_006')
    })

    it('FormatUtilTest_formatDate_96', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff8d415f');
      expect(stringDate).assertEqual('141_065_095')
    })

    it('FormatUtilTest_formatDate_97', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffdf57d4');
      expect(stringDate).assertEqual('223_087_212')
    })

    it('FormatUtilTest_formatDate_98', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff18af3f');
      expect(stringDate).assertEqual('024_175_063')
    })

    it('FormatUtilTest_formatDate_99', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff83e427');
      expect(stringDate).assertEqual('131_228_039')
    })

    it('FormatUtilTest_formatDate_100', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ffd4d87a');
      expect(stringDate).assertEqual('212_216_122')
    })

    it('FormatUtilTest_formatDate_101', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff1f4da3');
      expect(stringDate).assertEqual('031_077_163')
    })

    it('FormatUtilTest_formatDate_102', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#ff29800d');
      expect(stringDate).assertEqual('041_128_013')
    })

    it('FormatUtilTest_formatDate_103', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00a397a2');
      expect(stringDate).assertEqual('163_151_162')
    })

    it('FormatUtilTest_formatDate_104', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#005553be');
      expect(stringDate).assertEqual('085_083_190')
    })

    it('FormatUtilTest_formatDate_105', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00f1fcf9');
      expect(stringDate).assertEqual('241_252_249')
    })

    it('FormatUtilTest_formatDate_106', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00796b52');
      expect(stringDate).assertEqual('121_107_082')
    })

    it('FormatUtilTest_formatDate_107', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#001413e9');
      expect(stringDate).assertEqual('020_019_233')
    })

    it('FormatUtilTest_formatDate_108', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00e22d51');
      expect(stringDate).assertEqual('226_045_081')
    })

    it('FormatUtilTest_formatDate_109', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#008e1f56');
      expect(stringDate).assertEqual('142_031_086')
    })

    it('FormatUtilTest_formatDate_110', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00085727');
      expect(stringDate).assertEqual('008_087_039')
    })

    it('FormatUtilTest_formatDate_111', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00a705d4');
      expect(stringDate).assertEqual('167_005_212')
    })

    it('FormatUtilTest_formatDate_112', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00d05282');
      expect(stringDate).assertEqual('208_082_130')
    })

    it('FormatUtilTest_formatDate_113', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#0077751b');
      expect(stringDate).assertEqual('119_117_027')
    })

    it('FormatUtilTest_formatDate_114', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00994aed');
      expect(stringDate).assertEqual('153_074_237')
    })

    it('FormatUtilTest_formatDate_115', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00583d6a');
      expect(stringDate).assertEqual('088_061_106')
    })

    it('FormatUtilTest_formatDate_116', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#005236d5');
      expect(stringDate).assertEqual('082_054_213')
    })

    it('FormatUtilTest_formatDate_117', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00244a68');
      expect(stringDate).assertEqual('036_074_104')
    })

    it('FormatUtilTest_formatDate_118', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#008ead95');
      expect(stringDate).assertEqual('142_173_149')
    })

    it('FormatUtilTest_formatDate_119', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#005f3c35');
      expect(stringDate).assertEqual('095_060_053')
    })

    it('FormatUtilTest_formatDate_120', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00b5c48c');
      expect(stringDate).assertEqual('181_196_140')
    })

    it('FormatUtilTest_formatDate_121', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00dd6c11');
      expect(stringDate).assertEqual('221_108_017')
    })

    it('FormatUtilTest_formatDate_122', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00323de2');
      expect(stringDate).assertEqual('050_061_226')
    })

    it('FormatUtilTest_formatDate_123', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00b4b459');
      expect(stringDate).assertEqual('180_180_089')
    })

    it('FormatUtilTest_formatDate_124', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00cfce23');
      expect(stringDate).assertEqual('207_206_035')
    })

    it('FormatUtilTest_formatDate_125', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#003d27df');
      expect(stringDate).assertEqual('061_039_223')
    })

    it('FormatUtilTest_formatDate_126', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00a7f996');
      expect(stringDate).assertEqual('167_249_150')
    })

    it('FormatUtilTest_formatDate_127', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00fc1ee0');
      expect(stringDate).assertEqual('252_030_224')
    })

    it('FormatUtilTest_formatDate_128', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00662c0e');
      expect(stringDate).assertEqual('102_044_014')
    })

    it('FormatUtilTest_formatDate_129', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#007b8cca');
      expect(stringDate).assertEqual('123_140_202')
    })

    it('FormatUtilTest_formatDate_130', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#0030428f');
      expect(stringDate).assertEqual('048_066_143')
    })

    it('FormatUtilTest_formatDate_131', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00bc9f7b');
      expect(stringDate).assertEqual('188_159_123')
    })

    it('FormatUtilTest_formatDate_132', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00ced1b8');
      expect(stringDate).assertEqual('206_209_184')
    })

    it('FormatUtilTest_formatDate_133', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00b187ec');
      expect(stringDate).assertEqual('177_135_236')
    })

    it('FormatUtilTest_formatDate_134', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#008ad6bb');
      expect(stringDate).assertEqual('138_214_187')
    })

    it('FormatUtilTest_formatDate_135', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#002e1563');
      expect(stringDate).assertEqual('046_021_099')
    })

    it('FormatUtilTest_formatDate_136', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#000e3cdc');
      expect(stringDate).assertEqual('014_060_220')
    })

    it('FormatUtilTest_formatDate_137', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00a43a7a');
      expect(stringDate).assertEqual('164_058_122')
    })

    it('FormatUtilTest_formatDate_138', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#000620a7');
      expect(stringDate).assertEqual('006_032_167')
    })

    it('FormatUtilTest_formatDate_139', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00931b34');
      expect(stringDate).assertEqual('147_027_052')
    })

    it('FormatUtilTest_formatDate_140', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00dd4cf5');
      expect(stringDate).assertEqual('221_076_245')
    })

    it('FormatUtilTest_formatDate_141', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00ec8896');
      expect(stringDate).assertEqual('236_136_150')
    })

    it('FormatUtilTest_formatDate_142', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#0068d668');
      expect(stringDate).assertEqual('104_214_104')
    })

    it('FormatUtilTest_formatDate_143', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00a0096f');
      expect(stringDate).assertEqual('160_009_111')
    })

    it('FormatUtilTest_formatDate_144', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#008e9347');
      expect(stringDate).assertEqual('142_147_071')
    })

    it('FormatUtilTest_formatDate_145', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00c941db');
      expect(stringDate).assertEqual('201_065_219')
    })

    it('FormatUtilTest_formatDate_146', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00accf97');
      expect(stringDate).assertEqual('172_207_151')
    })

    it('FormatUtilTest_formatDate_147', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#0089f351');
      expect(stringDate).assertEqual('137_243_081')
    })

    it('FormatUtilTest_formatDate_148', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00057971');
      expect(stringDate).assertEqual('005_121_113')
    })

    it('FormatUtilTest_formatDate_149', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#002c0e0d');
      expect(stringDate).assertEqual('044_014_013')
    })

    it('FormatUtilTest_formatDate_150', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00606b59');
      expect(stringDate).assertEqual('096_107_089')
    })

    it('FormatUtilTest_formatDate_151', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00d559e1');
      expect(stringDate).assertEqual('213_089_225')
    })

    it('FormatUtilTest_formatDate_152', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#006cc1b9');
      expect(stringDate).assertEqual('108_193_185')
    })

    it('FormatUtilTest_formatDate_153', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00556342');
      expect(stringDate).assertEqual('085_099_066')
    })

    it('FormatUtilTest_formatDate_154', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00447155');
      expect(stringDate).assertEqual('068_113_085')
    })

    it('FormatUtilTest_formatDate_155', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#000bba97');
      expect(stringDate).assertEqual('011_186_151')
    })

    it('FormatUtilTest_formatDate_156', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00e66867');
      expect(stringDate).assertEqual('230_104_103')
    })

    it('FormatUtilTest_formatDate_157', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00fe715b');
      expect(stringDate).assertEqual('254_113_091')
    })

    it('FormatUtilTest_formatDate_158', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00507655');
      expect(stringDate).assertEqual('080_118_085')
    })

    it('FormatUtilTest_formatDate_159', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00c22263');
      expect(stringDate).assertEqual('194_034_099')
    })

    it('FormatUtilTest_formatDate_160', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#004f02ce');
      expect(stringDate).assertEqual('079_002_206')
    })

    it('FormatUtilTest_formatDate_161', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00a8d8a7');
      expect(stringDate).assertEqual('168_216_167')
    })

    it('FormatUtilTest_formatDate_162', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#000a456a');
      expect(stringDate).assertEqual('010_069_106')
    })

    it('FormatUtilTest_formatDate_163', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00431a4d');
      expect(stringDate).assertEqual('067_026_077')
    })

    it('FormatUtilTest_formatDate_164', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00855f3e');
      expect(stringDate).assertEqual('133_095_062')
    })

    it('FormatUtilTest_formatDate_165', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00db6af8');
      expect(stringDate).assertEqual('219_106_248')
    })

    it('FormatUtilTest_formatDate_166', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#0073d161');
      expect(stringDate).assertEqual('115_209_097')
    })

    it('FormatUtilTest_formatDate_167', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#005ad053');
      expect(stringDate).assertEqual('090_208_083')
    })

    it('FormatUtilTest_formatDate_168', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#003521c9');
      expect(stringDate).assertEqual('053_033_201')
    })

    it('FormatUtilTest_formatDate_169', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#008a63ec');
      expect(stringDate).assertEqual('138_099_236')
    })

    it('FormatUtilTest_formatDate_170', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#006db2ee');
      expect(stringDate).assertEqual('109_178_238')
    })

    it('FormatUtilTest_formatDate_171', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00bcda47');
      expect(stringDate).assertEqual('188_218_071')
    })

    it('FormatUtilTest_formatDate_172', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#0064e50d');
      expect(stringDate).assertEqual('100_229_013')
    })

    it('FormatUtilTest_formatDate_173', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#004ea827');
      expect(stringDate).assertEqual('078_168_039')
    })

    it('FormatUtilTest_formatDate_174', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#001b2f06');
      expect(stringDate).assertEqual('027_047_006')
    })

    it('FormatUtilTest_formatDate_175', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00598af0');
      expect(stringDate).assertEqual('089_138_240')
    })

    it('FormatUtilTest_formatDate_176', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00537dc2');
      expect(stringDate).assertEqual('083_125_194')
    })

    it('FormatUtilTest_formatDate_177', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#0034d713');
      expect(stringDate).assertEqual('052_215_019')
    })

    it('FormatUtilTest_formatDate_178', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00878cb3');
      expect(stringDate).assertEqual('135_140_179')
    })

    it('FormatUtilTest_formatDate_179', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00d19718');
      expect(stringDate).assertEqual('209_151_024')
    })

    it('FormatUtilTest_formatDate_180', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#003e844a');
      expect(stringDate).assertEqual('062_132_074')
    })

    it('FormatUtilTest_formatDate_181', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00acc0a5');
      expect(stringDate).assertEqual('172_192_165')
    })

    it('FormatUtilTest_formatDate_182', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00f4260b');
      expect(stringDate).assertEqual('244_038_011')
    })

    it('FormatUtilTest_formatDate_183', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#0002f3b3');
      expect(stringDate).assertEqual('002_243_179')
    })

    it('FormatUtilTest_formatDate_184', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00a81062');
      expect(stringDate).assertEqual('168_016_098')
    })

    it('FormatUtilTest_formatDate_185', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00afe8ec');
      expect(stringDate).assertEqual('175_232_236')
    })

    it('FormatUtilTest_formatDate_186', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00a03c6a');
      expect(stringDate).assertEqual('160_060_106')
    })

    it('FormatUtilTest_formatDate_187', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00e2f0c1');
      expect(stringDate).assertEqual('226_240_193')
    })

    it('FormatUtilTest_formatDate_188', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00f578ce');
      expect(stringDate).assertEqual('245_120_206')
    })

    it('FormatUtilTest_formatDate_189', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00a9c966');
      expect(stringDate).assertEqual('169_201_102')
    })

    it('FormatUtilTest_formatDate_190', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#0041086a');
      expect(stringDate).assertEqual('065_008_106')
    })

    it('FormatUtilTest_formatDate_191', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#000c352c');
      expect(stringDate).assertEqual('012_053_044')
    })

    it('FormatUtilTest_formatDate_192', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00b12ad1');
      expect(stringDate).assertEqual('177_042_209')
    })

    it('FormatUtilTest_formatDate_193', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#003cabc5');
      expect(stringDate).assertEqual('060_171_197')
    })

    it('FormatUtilTest_formatDate_194', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00ef5455');
      expect(stringDate).assertEqual('239_084_085')
    })

    it('FormatUtilTest_formatDate_195', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#0053833f');
      expect(stringDate).assertEqual('083_131_063')
    })

    it('FormatUtilTest_formatDate_196', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#00bf24fa');
      expect(stringDate).assertEqual('191_036_250')
    })

    it('FormatUtilTest_formatDate_197', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#002b86eb');
      expect(stringDate).assertEqual('043_134_235')
    })

    it('FormatUtilTest_formatDate_198', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#006c7c65');
      expect(stringDate).assertEqual('108_124_101')
    })

    it('FormatUtilTest_formatDate_199', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#003ba6ae');
      expect(stringDate).assertEqual('059_166_174')
    })

    it('FormatUtilTest_formatDate_200', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#002167b7');
      expect(stringDate).assertEqual('033_103_183')
    })

    it('FormatUtilTest_formatDate_201', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#008c73ec');
      expect(stringDate).assertEqual('140_115_236')
    })

    it('FormatUtilTest_formatDate_202', 0, () => {
      let stringDate = FormatUtil.RGBAHexToR_G_B('#0038a496');
      expect(stringDate).assertEqual('056_164_150')
    })

    it('should_return_empty_string_when_date_is_null', 0, () => {
      let result: string = FormatUtil.formatDate(null, 'yyyyMMdd_HHmmss');
      expect(result).assertUndefined();
    });

  });
}