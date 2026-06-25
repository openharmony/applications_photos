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
import { describe, expect, it, beforeEach, afterEach, MockKit, when } from "@ohos/hypium";
import { Position } from '../../../../../../../../imageEditor/common/src/main/ets/common/util/PositionUtil';
import { Rectangle } from '../../../../../../../../imageEditor/common/src/main/ets/common/util/types';
import { Log } from '@ohos/tools/src/main/utils/Log';

const TAG: string = `PositionUtilTest`;

export default function PositionUtilTest() {
  describe('PositionUtilTest', () => {
    let mocker: MockKit

    beforeEach(() => {
      Log.info(TAG,'begin');
      // 创建一个mock能力的对象MockKit
      mocker = new MockKit()
    })

    afterEach(() => {
      Log.info(TAG,'end');
      mocker.ignoreMock(Position, Position.getRectangleById);
      mocker.clearAll();
    });

    it('PositionUtilTest_isNumberInInterval', 0, () => {
      expect(Position.isNumberInInterval(100, [50,200])).assertTrue();
      expect(Position.isNumberInInterval(100, [150,200])).assertFalse();
    });

    it('PositionUtilTest_isRectangleSizeEqual', 0, () => {
      let aRectangle = new Rectangle(100, 400, 300, 200);
      let bRectangle = new Rectangle(100, 200, 300, 200);
      expect(Position.isRectangleSizeEqual(aRectangle, aRectangle)).assertTrue();
      expect(Position.isRectangleSizeEqual(aRectangle, bRectangle)).assertFalse();
    });

    it('PositionUtilTest_isSameRectInPixel', 0, () => {
      let aRectangle = new Rectangle(100, 400, 300, 200);
      let bRectangle = new Rectangle(100, 200, 300, 100);
      expect(Position.isSameRectInPixel(aRectangle, aRectangle)).assertTrue();
      expect(Position.isSameRectInPixel(aRectangle, bRectangle)).assertFalse();
    });

    it('PositionUtilTest_1', 0, () => {
      // 进行mock操作,比如需要对Position类的method_1函数进行getRectangleById
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      // 期望Position.getRectangleById函数被mock后, 以'0'为入参时调用函数返回结果rect
      let rect = new Rectangle(102, 402, 300, 200);
      when(mockFunc)('0').afterReturn(rect);

      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      // 对mock后的结果进行断言，看是否符合预期
      expect(rectangle[0]).assertEqual(201);
      expect(rectangle[1]).assertEqual(301);
    });

    it('PositionUtilTest_2', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1383, 886, 777, 915);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1080);
      expect(rectangle[1]).assertEqual(900.5);
    });

    it('PositionUtilTest_3', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1793, 335, 1386, 492);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1589.5);
      expect(rectangle[1]).assertEqual(413.5);
    });

    it('PositionUtilTest_4', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(649, 1421, 362, 27);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(505.5);
      expect(rectangle[1]).assertEqual(724);
    });

    it('PositionUtilTest_5', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(690, 59, 1763, 1926);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1226.5);
      expect(rectangle[1]).assertEqual(992.5);
    });

    it('PositionUtilTest_6', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(540, 1426, 1172, 1736);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(856);
      expect(rectangle[1]).assertEqual(1581);
    });

    it('PositionUtilTest_7', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1211, 1368, 567, 429);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(889);
      expect(rectangle[1]).assertEqual(898.5);
    });

    it('PositionUtilTest_8', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1782, 1530, 862, 1123);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1322);
      expect(rectangle[1]).assertEqual(1326.5);
    });

    it('PositionUtilTest_9', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(67, 1135, 1929, 1802);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(998);
      expect(rectangle[1]).assertEqual(1468.5);
    });

    it('PositionUtilTest_10', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(22, 1058, 1069, 167);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(545.5);
      expect(rectangle[1]).assertEqual(612.5);
    });

    it('PositionUtilTest_11', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1393, 456, 1011, 42);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1202);
      expect(rectangle[1]).assertEqual(249);
    });

    it('PositionUtilTest_12', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(229, 1373, 421, 919);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(325);
      expect(rectangle[1]).assertEqual(1146);
    });

    it('PositionUtilTest_13', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1784, 537, 1198, 324);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1491);
      expect(rectangle[1]).assertEqual(430.5);
    });

    it('PositionUtilTest_14', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(315, 370, 413, 1526);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(364);
      expect(rectangle[1]).assertEqual(948);
    });

    it('PositionUtilTest_15', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(91, 980, 1956, 1873);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1023.5);
      expect(rectangle[1]).assertEqual(1426.5);
    });

    it('PositionUtilTest_16', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(862, 1170, 996, 1281);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(929);
      expect(rectangle[1]).assertEqual(1225.5);
    });

    it('PositionUtilTest_17', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(305, 925, 1084, 327);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(694.5);
      expect(rectangle[1]).assertEqual(626);
    });

    it('PositionUtilTest_18', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(336, 505, 846, 1729);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(591);
      expect(rectangle[1]).assertEqual(1117);
    });

    it('PositionUtilTest_19', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1313, 1857, 124, 1895);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(718.5);
      expect(rectangle[1]).assertEqual(1876);
    });

    it('PositionUtilTest_20', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1582, 545, 814, 1367);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1198);
      expect(rectangle[1]).assertEqual(956);
    });

    it('PositionUtilTest_21', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1434, 364, 43, 1750);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(738.5);
      expect(rectangle[1]).assertEqual(1057);
    });

    it('PositionUtilTest_22', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1087, 808, 1276, 1178);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1181.5);
      expect(rectangle[1]).assertEqual(993);
    });

    it('PositionUtilTest_23', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1788, 1584, 1403, 651);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1595.5);
      expect(rectangle[1]).assertEqual(1117.5);
    });

    it('PositionUtilTest_24', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(754, 399, 1932, 1060);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1343);
      expect(rectangle[1]).assertEqual(729.5);
    });

    it('PositionUtilTest_25', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1676, 1368, 1739, 12);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1707.5);
      expect(rectangle[1]).assertEqual(690);
    });

    it('PositionUtilTest_26', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(226, 586, 94, 1539);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(160);
      expect(rectangle[1]).assertEqual(1062.5);
    });

    it('PositionUtilTest_27', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(795, 570, 1434, 378);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1114.5);
      expect(rectangle[1]).assertEqual(474);
    });

    it('PositionUtilTest_28', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1467, 601, 97, 902);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(782);
      expect(rectangle[1]).assertEqual(751.5);
    });

    it('PositionUtilTest_29', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1317, 492, 652, 756);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(984.5);
      expect(rectangle[1]).assertEqual(624);
    });

    it('PositionUtilTest_30', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1301, 280, 286, 1441);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(793.5);
      expect(rectangle[1]).assertEqual(860.5);
    });

    it('PositionUtilTest_31', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1865, 1689, 444, 619);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1154.5);
      expect(rectangle[1]).assertEqual(1154);
    });

    it('PositionUtilTest_32', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(440, 729, 31, 117);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(235.5);
      expect(rectangle[1]).assertEqual(423);
    });

    it('PositionUtilTest_33', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(97, 1771, 481, 675);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(289);
      expect(rectangle[1]).assertEqual(1223);
    });

    it('PositionUtilTest_34', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(709, 927, 567, 1856);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(638);
      expect(rectangle[1]).assertEqual(1391.5);
    });

    it('PositionUtilTest_35', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1497, 353, 586, 965);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1041.5);
      expect(rectangle[1]).assertEqual(659);
    });

    it('PositionUtilTest_36', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1306, 683, 219, 624);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(762.5);
      expect(rectangle[1]).assertEqual(653.5);
    });

    it('PositionUtilTest_37', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1528, 871, 1732, 829);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1630);
      expect(rectangle[1]).assertEqual(850);
    });

    it('PositionUtilTest_38', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1503, 19, 270, 1368);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(886.5);
      expect(rectangle[1]).assertEqual(693.5);
    });

    it('PositionUtilTest_39', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1708, 715, 340, 149);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1024);
      expect(rectangle[1]).assertEqual(432);
    });

    it('PositionUtilTest_40', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1796, 723, 618, 245);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1207);
      expect(rectangle[1]).assertEqual(484);
    });

    it('PositionUtilTest_41', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(846, 1451, 921, 1555);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(883.5);
      expect(rectangle[1]).assertEqual(1503);
    });

    it('PositionUtilTest_42', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(379, 1488, 1764, 228);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1071.5);
      expect(rectangle[1]).assertEqual(858);
    });

    it('PositionUtilTest_43', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1841, 350, 1193, 1500);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1517);
      expect(rectangle[1]).assertEqual(925);
    });

    it('PositionUtilTest_44', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1034, 1764, 124, 914);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(579);
      expect(rectangle[1]).assertEqual(1339);
    });

    it('PositionUtilTest_45', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(987, 1856, 1743, 491);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1365);
      expect(rectangle[1]).assertEqual(1173.5);
    });

    it('PositionUtilTest_46', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(227, 365, 1859, 1936);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1043);
      expect(rectangle[1]).assertEqual(1150.5);
    });

    it('PositionUtilTest_47', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1432, 551, 437, 1228);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(934.5);
      expect(rectangle[1]).assertEqual(889.5);
    });

    it('PositionUtilTest_48', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1275, 1407, 1474, 121);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1374.5);
      expect(rectangle[1]).assertEqual(764);
    });

    it('PositionUtilTest_49', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(858, 395, 29, 1237);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(443.5);
      expect(rectangle[1]).assertEqual(816);
    });

    it('PositionUtilTest_50', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(235, 1793, 1818, 428);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1026.5);
      expect(rectangle[1]).assertEqual(1110.5);
    });

    it('PositionUtilTest_51', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(143, 1011, 1928, 1529);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1035.5);
      expect(rectangle[1]).assertEqual(1270);
    });

    it('PositionUtilTest_52', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(776, 404, 443, 1763);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(609.5);
      expect(rectangle[1]).assertEqual(1083.5);
    });

    it('PositionUtilTest_53', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(613, 538, 606, 840);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(609.5);
      expect(rectangle[1]).assertEqual(689);
    });

    it('PositionUtilTest_54', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(904, 818, 1128, 688);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1016);
      expect(rectangle[1]).assertEqual(753);
    });

    it('PositionUtilTest_55', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1369, 1917, 1917, 996);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1643);
      expect(rectangle[1]).assertEqual(1456.5);
    });

    it('PositionUtilTest_56', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1324, 1743, 1470, 183);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1397);
      expect(rectangle[1]).assertEqual(963);
    });

    it('PositionUtilTest_57', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(490, 1499, 1772, 725);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1131);
      expect(rectangle[1]).assertEqual(1112);
    });

    it('PositionUtilTest_58', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1644, 1590, 1505, 139);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1574.5);
      expect(rectangle[1]).assertEqual(864.5);
    });

    it('PositionUtilTest_59', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(954, 1786, 1669, 82);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1311.5);
      expect(rectangle[1]).assertEqual(934);
    });

    it('PositionUtilTest_60', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(542, 464, 197, 1507);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(369.5);
      expect(rectangle[1]).assertEqual(985.5);
    });

    it('PositionUtilTest_61', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1355, 804, 348, 611);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(851.5);
      expect(rectangle[1]).assertEqual(707.5);
    });

    it('PositionUtilTest_62', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1622, 1828, 1299, 1343);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1460.5);
      expect(rectangle[1]).assertEqual(1585.5);
    });

    it('PositionUtilTest_63', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1746, 1568, 340, 1422);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1043);
      expect(rectangle[1]).assertEqual(1495);
    });

    it('PositionUtilTest_64', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1311, 1810, 1605, 1801);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1458);
      expect(rectangle[1]).assertEqual(1805.5);
    });

    it('PositionUtilTest_65', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1661, 1730, 878, 1305);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1269.5);
      expect(rectangle[1]).assertEqual(1517.5);
    });

    it('PositionUtilTest_66', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1320, 736, 1444, 626);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1382);
      expect(rectangle[1]).assertEqual(681);
    });

    it('PositionUtilTest_67', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(522, 1465, 708, 1416);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(615);
      expect(rectangle[1]).assertEqual(1440.5);
    });

    it('PositionUtilTest_68', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(282, 1258, 924, 1637);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(603);
      expect(rectangle[1]).assertEqual(1447.5);
    });

    it('PositionUtilTest_69', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(62, 1624, 600, 36);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(331);
      expect(rectangle[1]).assertEqual(830);
    });

    it('PositionUtilTest_70', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1452, 1899, 1379, 1550);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1415.5);
      expect(rectangle[1]).assertEqual(1724.5);
    });

    it('PositionUtilTest_71', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1468, 71, 973, 1131);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1220.5);
      expect(rectangle[1]).assertEqual(601);
    });

    it('PositionUtilTest_72', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1881, 930, 933, 1894);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1407);
      expect(rectangle[1]).assertEqual(1412);
    });

    it('PositionUtilTest_73', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(660, 163, 1199, 1981);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(929.5);
      expect(rectangle[1]).assertEqual(1072);
    });

    it('PositionUtilTest_74', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(899, 996, 959, 1773);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(929);
      expect(rectangle[1]).assertEqual(1384.5);
    });

    it('PositionUtilTest_75', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(813, 1668, 1190, 1095);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1001.5);
      expect(rectangle[1]).assertEqual(1381.5);
    });

    it('PositionUtilTest_76', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(926, 466, 1084, 1340);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1005);
      expect(rectangle[1]).assertEqual(903);
    });

    it('PositionUtilTest_77', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(90, 1684, 1376, 1542);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(733);
      expect(rectangle[1]).assertEqual(1613);
    });

    it('PositionUtilTest_78', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1936, 1107, 1445, 1756);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1690.5);
      expect(rectangle[1]).assertEqual(1431.5);
    });

    it('PositionUtilTest_79', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1179, 418, 887, 1412);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1033);
      expect(rectangle[1]).assertEqual(915);
    });

    it('PositionUtilTest_80', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1348, 172, 1659, 9);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1503.5);
      expect(rectangle[1]).assertEqual(90.5);
    });

    it('PositionUtilTest_81', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(336, 1210, 342, 1587);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(339);
      expect(rectangle[1]).assertEqual(1398.5);
    });

    it('PositionUtilTest_82', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(206, 1301, 1713, 1372);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(959.5);
      expect(rectangle[1]).assertEqual(1336.5);
    });

    it('PositionUtilTest_83', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1321, 1255, 819, 599);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1070);
      expect(rectangle[1]).assertEqual(927);
    });

    it('PositionUtilTest_84', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1721, 1904, 1939, 1811);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1830);
      expect(rectangle[1]).assertEqual(1857.5);
    });

    it('PositionUtilTest_85', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1940, 1667, 1705, 228);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1822.5);
      expect(rectangle[1]).assertEqual(947.5);
    });

    it('PositionUtilTest_86', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1127, 1150, 1984, 658);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1555.5);
      expect(rectangle[1]).assertEqual(904);
    });

    it('PositionUtilTest_87', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1920, 1224, 422, 1269);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1171);
      expect(rectangle[1]).assertEqual(1246.5);
    });

    it('PositionUtilTest_88', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1396, 81, 1630, 84);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1513);
      expect(rectangle[1]).assertEqual(82.5);
    });

    it('PositionUtilTest_89', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1292, 1972, 1672, 1850);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1482);
      expect(rectangle[1]).assertEqual(1911);
    });

    it('PositionUtilTest_90', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1625, 1385, 1222, 1299);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1423.5);
      expect(rectangle[1]).assertEqual(1342);
    });

    it('PositionUtilTest_91', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(640, 42, 1898, 713);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1269);
      expect(rectangle[1]).assertEqual(377.5);
    });

    it('PositionUtilTest_92', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(298, 190, 524, 590);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(411);
      expect(rectangle[1]).assertEqual(390);
    });

    it('PositionUtilTest_93', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(209, 581, 819, 1336);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(514);
      expect(rectangle[1]).assertEqual(958.5);
    });

    it('PositionUtilTest_94', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1732, 1155, 1994, 4);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1863);
      expect(rectangle[1]).assertEqual(579.5);
    });

    it('PositionUtilTest_95', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(379, 769, 1273, 1776);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(826);
      expect(rectangle[1]).assertEqual(1272.5);
    });

    it('PositionUtilTest_96', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(850, 1255, 1860, 142);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1355);
      expect(rectangle[1]).assertEqual(698.5);
    });

    it('PositionUtilTest_97', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1579, 1884, 1993, 1205);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1786);
      expect(rectangle[1]).assertEqual(1544.5);
    });

    it('PositionUtilTest_98', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1621, 1567, 504, 613);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1062.5);
      expect(rectangle[1]).assertEqual(1090);
    });

    it('PositionUtilTest_99', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1961, 754, 1326, 259);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1643.5);
      expect(rectangle[1]).assertEqual(506.5);
    });

    it('PositionUtilTest_100', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(944, 202, 1202, 1506);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1073);
      expect(rectangle[1]).assertEqual(854);
    });

    it('PositionUtilTest_101', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(784, 21, 842, 868);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(813);
      expect(rectangle[1]).assertEqual(444.5);
    });

    it('PositionUtilTest_102', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1528, 1189, 872, 1908);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1200);
      expect(rectangle[1]).assertEqual(1548.5);
    });

    it('PositionUtilTest_103', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1958, 498, 36, 808);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(997);
      expect(rectangle[1]).assertEqual(653);
    });

    it('PositionUtilTest_104', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1753, 248, 1303, 1333);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1528);
      expect(rectangle[1]).assertEqual(790.5);
    });

    it('PositionUtilTest_105', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(133, 1648, 890, 1754);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(511.5);
      expect(rectangle[1]).assertEqual(1701);
    });

    it('PositionUtilTest_106', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1567, 1746, 368, 1529);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(967.5);
      expect(rectangle[1]).assertEqual(1637.5);
    });

    it('PositionUtilTest_107', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(500, 46, 1788, 1797);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1144);
      expect(rectangle[1]).assertEqual(921.5);
    });

    it('PositionUtilTest_108', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(249, 990, 1303, 1033);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(776);
      expect(rectangle[1]).assertEqual(1011.5);
    });

    it('PositionUtilTest_109', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1363, 497, 253, 892);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(808);
      expect(rectangle[1]).assertEqual(694.5);
    });

    it('PositionUtilTest_110', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1686, 1125, 1152, 1996);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1419);
      expect(rectangle[1]).assertEqual(1560.5);
    });

    it('PositionUtilTest_111', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1975, 1188, 1157, 1729);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1566);
      expect(rectangle[1]).assertEqual(1458.5);
    });

    it('PositionUtilTest_112', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1436, 460, 1414, 1921);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1425);
      expect(rectangle[1]).assertEqual(1190.5);
    });

    it('PositionUtilTest_113', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(460, 304, 28, 27);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(244);
      expect(rectangle[1]).assertEqual(165.5);
    });

    it('PositionUtilTest_114', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(50, 748, 1556, 902);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(803);
      expect(rectangle[1]).assertEqual(825);
    });

    it('PositionUtilTest_115', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(794, 1697, 699, 1043);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(746.5);
      expect(rectangle[1]).assertEqual(1370);
    });

    it('PositionUtilTest_116', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1039, 2, 428, 403);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(733.5);
      expect(rectangle[1]).assertEqual(202.5);
    });

    it('PositionUtilTest_117', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(500, 681, 1647, 538);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1073.5);
      expect(rectangle[1]).assertEqual(609.5);
    });

    it('PositionUtilTest_118', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(159, 1151, 535, 134);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(347);
      expect(rectangle[1]).assertEqual(642.5);
    });

    it('PositionUtilTest_119', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(339, 1692, 215, 127);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(277);
      expect(rectangle[1]).assertEqual(909.5);
    });

    it('PositionUtilTest_120', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(504, 1629, 49, 964);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(276.5);
      expect(rectangle[1]).assertEqual(1296.5);
    });

    it('PositionUtilTest_121', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(285, 429, 1343, 335);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(814);
      expect(rectangle[1]).assertEqual(382);
    });

    it('PositionUtilTest_122', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1177, 900, 1238, 1971);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1207.5);
      expect(rectangle[1]).assertEqual(1435.5);
    });

    it('PositionUtilTest_123', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(949, 289, 1367, 1988);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1158);
      expect(rectangle[1]).assertEqual(1138.5);
    });

    it('PositionUtilTest_124', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(292, 1795, 743, 1144);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(517.5);
      expect(rectangle[1]).assertEqual(1469.5);
    });

    it('PositionUtilTest_125', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(829, 390, 1682, 1340);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1255.5);
      expect(rectangle[1]).assertEqual(865);
    });

    it('PositionUtilTest_126', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1541, 569, 1826, 232);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1683.5);
      expect(rectangle[1]).assertEqual(400.5);
    });

    it('PositionUtilTest_127', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(261, 42, 360, 1117);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(310.5);
      expect(rectangle[1]).assertEqual(579.5);
    });

    it('PositionUtilTest_128', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(23, 761, 81, 309);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(52);
      expect(rectangle[1]).assertEqual(535);
    });

    it('PositionUtilTest_129', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1190, 1425, 996, 367);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1093);
      expect(rectangle[1]).assertEqual(896);
    });

    it('PositionUtilTest_130', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(677, 234, 690, 1626);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(683.5);
      expect(rectangle[1]).assertEqual(930);
    });

    it('PositionUtilTest_131', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(524, 57, 1614, 1168);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1069);
      expect(rectangle[1]).assertEqual(612.5);
    });

    it('PositionUtilTest_132', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(205, 358, 312, 1386);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(258.5);
      expect(rectangle[1]).assertEqual(872);
    });

    it('PositionUtilTest_133', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1100, 346, 726, 994);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(913);
      expect(rectangle[1]).assertEqual(670);
    });

    it('PositionUtilTest_134', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(916, 552, 1578, 1529);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1247);
      expect(rectangle[1]).assertEqual(1040.5);
    });

    it('PositionUtilTest_135', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(946, 290, 647, 970);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(796.5);
      expect(rectangle[1]).assertEqual(630);
    });

    it('PositionUtilTest_136', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1051, 1080, 1631, 593);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1341);
      expect(rectangle[1]).assertEqual(836.5);
    });

    it('PositionUtilTest_137', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(857, 627, 1312, 1886);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1084.5);
      expect(rectangle[1]).assertEqual(1256.5);
    });

    it('PositionUtilTest_138', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1214, 355, 1512, 90);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1363);
      expect(rectangle[1]).assertEqual(222.5);
    });

    it('PositionUtilTest_139', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(412, 1479, 1610, 969);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1011);
      expect(rectangle[1]).assertEqual(1224);
    });

    it('PositionUtilTest_140', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(189, 274, 355, 1641);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(272);
      expect(rectangle[1]).assertEqual(957.5);
    });

    it('PositionUtilTest_141', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(620, 1433, 987, 1888);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(803.5);
      expect(rectangle[1]).assertEqual(1660.5);
    });

    it('PositionUtilTest_142', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(338, 566, 1770, 1284);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1054);
      expect(rectangle[1]).assertEqual(925);
    });

    it('PositionUtilTest_143', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(856, 417, 606, 260);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(731);
      expect(rectangle[1]).assertEqual(338.5);
    });

    it('PositionUtilTest_144', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1849, 237, 1205, 1059);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1527);
      expect(rectangle[1]).assertEqual(648);
    });

    it('PositionUtilTest_145', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1217, 518, 945, 783);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1081);
      expect(rectangle[1]).assertEqual(650.5);
    });

    it('PositionUtilTest_146', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(873, 458, 873, 1637);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(873);
      expect(rectangle[1]).assertEqual(1047.5);
    });

    it('PositionUtilTest_147', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(289, 483, 607, 478);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(448);
      expect(rectangle[1]).assertEqual(480.5);
    });

    it('PositionUtilTest_148', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(757, 1314, 471, 1729);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(614);
      expect(rectangle[1]).assertEqual(1521.5);
    });

    it('PositionUtilTest_149', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1100, 1459, 1618, 1438);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1359);
      expect(rectangle[1]).assertEqual(1448.5);
    });

    it('PositionUtilTest_150', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(25, 1388, 1074, 1233);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(549.5);
      expect(rectangle[1]).assertEqual(1310.5);
    });

    it('PositionUtilTest_151', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(157, 1681, 1493, 358);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(825);
      expect(rectangle[1]).assertEqual(1019.5);
    });

    it('PositionUtilTest_152', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(270, 699, 1417, 1839);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(843.5);
      expect(rectangle[1]).assertEqual(1269);
    });

    it('PositionUtilTest_153', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1569, 363, 622, 794);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1095.5);
      expect(rectangle[1]).assertEqual(578.5);
    });

    it('PositionUtilTest_154', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1173, 1847, 431, 1462);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(802);
      expect(rectangle[1]).assertEqual(1654.5);
    });

    it('PositionUtilTest_155', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(682, 1390, 292, 1791);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(487);
      expect(rectangle[1]).assertEqual(1590.5);
    });

    it('PositionUtilTest_156', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1057, 1115, 1521, 157);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1289);
      expect(rectangle[1]).assertEqual(636);
    });

    it('PositionUtilTest_157', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(574, 1491, 1947, 951);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1260.5);
      expect(rectangle[1]).assertEqual(1221);
    });

    it('PositionUtilTest_158', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1231, 1021, 537, 1740);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(884);
      expect(rectangle[1]).assertEqual(1380.5);
    });

    it('PositionUtilTest_159', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1054, 30, 98, 1325);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(576);
      expect(rectangle[1]).assertEqual(677.5);
    });

    it('PositionUtilTest_160', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1081, 1516, 1516, 1002);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1298.5);
      expect(rectangle[1]).assertEqual(1259);
    });

    it('PositionUtilTest_161', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(231, 139, 1796, 1404);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1013.5);
      expect(rectangle[1]).assertEqual(771.5);
    });

    it('PositionUtilTest_162', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(338, 580, 1218, 1021);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(778);
      expect(rectangle[1]).assertEqual(800.5);
    });

    it('PositionUtilTest_163', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1970, 1862, 812, 1379);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1391);
      expect(rectangle[1]).assertEqual(1620.5);
    });

    it('PositionUtilTest_164', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(977, 685, 1536, 1904);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1256.5);
      expect(rectangle[1]).assertEqual(1294.5);
    });

    it('PositionUtilTest_165', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(176, 1483, 1207, 1759);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(691.5);
      expect(rectangle[1]).assertEqual(1621);
    });

    it('PositionUtilTest_166', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(857, 1744, 1499, 1911);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1178);
      expect(rectangle[1]).assertEqual(1827.5);
    });

    it('PositionUtilTest_167', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(127, 1950, 1236, 1560);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(681.5);
      expect(rectangle[1]).assertEqual(1755);
    });

    it('PositionUtilTest_168', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1818, 1105, 563, 49);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1190.5);
      expect(rectangle[1]).assertEqual(577);
    });

    it('PositionUtilTest_169', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1244, 711, 1805, 1934);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1524.5);
      expect(rectangle[1]).assertEqual(1322.5);
    });

    it('PositionUtilTest_170', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1291, 1375, 955, 1614);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1123);
      expect(rectangle[1]).assertEqual(1494.5);
    });

    it('PositionUtilTest_171', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1589, 1768, 993, 918);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1291);
      expect(rectangle[1]).assertEqual(1343);
    });

    it('PositionUtilTest_172', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(805, 882, 822, 982);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(813.5);
      expect(rectangle[1]).assertEqual(932);
    });

    it('PositionUtilTest_173', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(717, 30, 1093, 1574);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(905);
      expect(rectangle[1]).assertEqual(802);
    });

    it('PositionUtilTest_174', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(126, 593, 1486, 253);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(806);
      expect(rectangle[1]).assertEqual(423);
    });

    it('PositionUtilTest_175', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(543, 1074, 1814, 713);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1178.5);
      expect(rectangle[1]).assertEqual(893.5);
    });

    it('PositionUtilTest_176', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(179, 377, 762, 1775);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(470.5);
      expect(rectangle[1]).assertEqual(1076);
    });

    it('PositionUtilTest_177', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1088, 919, 1710, 732);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1399);
      expect(rectangle[1]).assertEqual(825.5);
    });

    it('PositionUtilTest_178', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(294, 1017, 346, 235);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(320);
      expect(rectangle[1]).assertEqual(626);
    });

    it('PositionUtilTest_179', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1137, 1691, 1153, 1943);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1145);
      expect(rectangle[1]).assertEqual(1817);
    });

    it('PositionUtilTest_180', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(573, 328, 925, 1291);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(749);
      expect(rectangle[1]).assertEqual(809.5);
    });

    it('PositionUtilTest_181', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(710, 18, 1217, 836);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(963.5);
      expect(rectangle[1]).assertEqual(427);
    });

    it('PositionUtilTest_182', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(963, 1055, 1090, 1858);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1026.5);
      expect(rectangle[1]).assertEqual(1456.5);
    });

    it('PositionUtilTest_183', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(130, 904, 571, 661);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(350.5);
      expect(rectangle[1]).assertEqual(782.5);
    });

    it('PositionUtilTest_184', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1633, 1685, 789, 1073);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1211);
      expect(rectangle[1]).assertEqual(1379);
    });

    it('PositionUtilTest_185', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(604, 851, 1805, 1250);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1204.5);
      expect(rectangle[1]).assertEqual(1050.5);
    });

    it('PositionUtilTest_186', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1868, 503, 1485, 1006);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1676.5);
      expect(rectangle[1]).assertEqual(754.5);
    });

    it('PositionUtilTest_187', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(195, 639, 949, 1120);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(572);
      expect(rectangle[1]).assertEqual(879.5);
    });

    it('PositionUtilTest_188', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(967, 226, 763, 1677);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(865);
      expect(rectangle[1]).assertEqual(951.5);
    });

    it('PositionUtilTest_189', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(596, 1981, 865, 1560);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(730.5);
      expect(rectangle[1]).assertEqual(1770.5);
    });

    it('PositionUtilTest_190', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1036, 1955, 1770, 1518);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1403);
      expect(rectangle[1]).assertEqual(1736.5);
    });

    it('PositionUtilTest_191', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1211, 342, 532, 1196);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(871.5);
      expect(rectangle[1]).assertEqual(769);
    });

    it('PositionUtilTest_192', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(379, 1321, 270, 984);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(324.5);
      expect(rectangle[1]).assertEqual(1152.5);
    });

    it('PositionUtilTest_193', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(172, 427, 234, 40);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(203);
      expect(rectangle[1]).assertEqual(233.5);
    });

    it('PositionUtilTest_194', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1283, 72, 1398, 1830);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1340.5);
      expect(rectangle[1]).assertEqual(951);
    });

    it('PositionUtilTest_195', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1063, 347, 950, 30);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1006.5);
      expect(rectangle[1]).assertEqual(188.5);
    });

    it('PositionUtilTest_196', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(573, 1714, 59, 1522);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(316);
      expect(rectangle[1]).assertEqual(1618);
    });

    it('PositionUtilTest_197', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(47, 924, 1082, 1435);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(564.5);
      expect(rectangle[1]).assertEqual(1179.5);
    });

    it('PositionUtilTest_198', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1232, 1204, 954, 443);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1093);
      expect(rectangle[1]).assertEqual(823.5);
    });

    it('PositionUtilTest_199', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1898, 1486, 1640, 278);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1769);
      expect(rectangle[1]).assertEqual(882);
    });

    it('PositionUtilTest_200', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1159, 262, 1262, 1683);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1210.5);
      expect(rectangle[1]).assertEqual(972.5);
    });

    it('PositionUtilTest_201', 0, () => {
      let mockFunc: Function = mocker.mockFunc(Position, Position.getRectangleById);
      let rect = new Rectangle(1041, 1848, 1723, 324);
      when(mockFunc)('0').afterReturn(rect);
      let rectangle = Position.getCenterById('0');
      Log.info(TAG,`getCenterById ${rectangle.toString()}`);
      expect(rectangle[0]).assertEqual(1382);
      expect(rectangle[1]).assertEqual(1086);
    });




  })
}