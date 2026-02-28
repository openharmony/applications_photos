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

import { describe } from '@ohos/hypium';
import Aa from "./imageEditor/util/Aa.test";
import Ba from "./imageEditor/util/Ba.test";
import AccessibilityManagerTest from "./imageEditor/util/AccessibilityManager.test";
import LivePhoto from './browser/interact/LivePhoto.test';
import LivePhoto2 from './browser/interact/LivePhoto2.test';
import TCGraffiti from './browser/interact/GalleryGraffiti.test';
import TCCropPicture from './browser/interact/GalleryCropPicture.test';
import TCAIRetouching from './browser/interact/GalleryAIRetouching.test';
import abilityTest from './basephotos/Ability.test';
import abilityRotateTest from './basephotos/AbilityRotate.test';
import abilityFloatTest from './basephotos/AbilityFloat.test';
import PickerPhotoGridControllerUT from './browser/util/PickerPhotoGridController.test';
import MaskLayerUtilsUT from './browser/util/MaskLayerUtils.test';
import GridAutoScrollerUtilUT from './browser/util/GridAutoScrollerUtil.test';
import LineCrops01Test from './browser/UT/LineCrops01.test';
import ratioAtLineTest from './browser/UT/LineCrop.test';
import LineCropsTest from './browser/UT/LineCrops.test';
import ActionBarButtonTest from './browser/ActionBarButton.test';
import LineCrops02Test from './browser/UT/LineCrops02.test';
import LineCrops03Test from './browser/UT/LineCrops03.test';
import LineCrops04Test from './browser/UT/LineCrops04.test';
import LineCrops05Test from './browser/UT/LineCrops05.test';
import BrowserFaCardService from './browser/picker/FaCardService.test';
import BrowserFaCardWidget from './browser/picker/FaCardWidget.test';
import BrowserPicker from './browser/picker/Picker.test';
import unitTest from './basephotos/Unit.test';
import backupExtensionTest from './BackupExtension/BackupExtension.test';
import PhotoPropertiesTest from './browser/PhotoProperties';
import browserEntranceTest from './browser/BrowserEntrance.test';
import PictureDetailTest from './browser/PictureDetail.test';
import getDurationTest from './browser/UT/Timer.test';
import PerformanceToolTest from './browser/UT/PerformanceTool.test';
import OperateDeleteTest from './browser/operations/Delete.test';
import setAgreedTest from '@ohos/privacy/src/test/override/AgreementConfig.test';
import VideoPlayControllerTest from './browser/controller/VideoPlayController.test';
import ShortcutControllerTest from './browser/controller/ShortcutController.test';
import NetQualityUtilTest from './browser/NetQualityUtil.test';
import BurstPhotosUtilsTest from './browser/BurstPhotosUtils.test';
import AudioSessionControllerTest from './browser/controller/AudioSessionController.test';
import SpliceUtilsTest from './browser/SpliceUtils.test';
import SideBarControllerTest from './browser/controller/SideBarController.test';
import SpliceMenuOperationTest from './browser/SpliceMenuOperation.test';
import FocusCtrlTest from './browser/FocusCtrl.test';
import BrowserDataFactoryTest from './browser/BrowserDataFactory.test';
import ActionBarVarTest from './browser/ActionBarVar.test';
import BrowserCostReportManagerTest from './browser/BrowserCostReportManager.test';
import MoireHelperTest from './browser/UT/MoireHelper.test';
import ImageAdapterHelperTest from './browser/UT/ImageAdapterHelper.test';
import FastScrollCheckerTest from './browser/UT/FastScrollChecker.test';
import MoireTaskManageTest from './browser/UT/MoireTaskManage.test';
import FormControllerUT from './browser/util/FormController.test';
import FaCardAlbumServiceUT from './browser/util/FaCardAlbumService.test';
import DatabaseOperationHelperUT from './browser/util/DatabaseOperationHelper.test';
import DatabaseUpdateHelperUT from './browser/util/DatabaseUpdateHelperUtils.test';
import DatabaseProxyUT from './browser/util/DatabaseProxyUtils.test';
import FaCardAlbumUtilsUT from './browser/util/FaCardAlbumUtils.test';
import FaCardServiceUT from './browser/util/FaCardServiceUtils.test';
import ReminderServiceUT from './browser/util/ReminderService.test';
import ReminderServiceUtilsUT from './browser/util/ReminderServiceUtils.test';
import SavePhotosManagerUT from './browser/util/SavePhotosManager.test';
import SelectionCheckerUT from './browser/util/SelectionChecker.test';
import UserUtilsUT from './browser/util/UserUtils.test';
import MediaItemUtilTest from './grids/MediaItemUtil.test';
import BrowserUiTest from './browser/uiComponentCheck/browserUi.test';
import VideoBrowserUiTest from './browser/uiComponentCheck/VideoBrowserUi.test';
import LivePhotoUITest from './browser/uiComponentCheck/LivePhotoUI.test';
import BrowserUiUtilTest from './browser/UT/BrowserUiUtil.test';
import BrowserEventPipelineTest from './browser/UT/BrowserEventPipeline.test';
import BrowserArrayUtilTest from './browser/UT/BrowserArrayUtil.test';
import BrowserAnalyzerUtilTest from './browser/UT/BrowserAnalyzerUtil.test';
import BrowserDateUtilTest from './browser/UT/BrowserDataUtil.test';
import BrowserImageUtilTest from './browser/UT/BrowserImageUtil.test';
import BrowserStringUtilTest from './browser/UT/BrowserStringUtil.test';
import GallerySettingsMovingPhotoAutoPlay from './browser/interact/GallerySettingsMovingPhotoAutoPlay.test';
import PanoramaPhotoInnerPic from './browser/interact/PanoramaPhotoInnerPic.test';
import LivePhotoForMoreMenu from './browser/interact/LivePhotoForMoreMenu.test';
import SystemAndTimeUtilsTest from './grids/SystemUtil.test';
import MathUtilsTest from './grids/MathUtil.test';
import imageStylusTest from "./imageEditor/base/ImageStylus.test";
import imageStylusGuideTest from "./imageEditor/base/ImageStylusGuide.test";
import mosaicTest from "./imageEditor/base/Mosaic.test";
import PhotoApertureImageTest from "./imageEditor/base/PhotoApertureImage.test";
import photoEditorTest from "./imageEditor/base/PhotoEditor.test";
import photoXTStyleEditorTest from "./imageEditor/base/PhotoXTStyleEditor.test";
import FormatUtilTest from "./imageEditor/util/FormatUtil.test";
import PhotoAssetUtilTest from "./imageEditor/util/PhotoAssetUtilTest.test";
import PositionUtilTest from "./imageEditor/util/PositionUtil.test";
import ScreenUtilTest from "./imageEditor/util/ScreenUtil.test";
import UtilTest from "./imageEditor/util/Util.test";
import RectangleTest from './imageEditor/util/types.test';
import PathUtilsTest from './imageEditor/util/PathUtils.test';
// import YearMonthMediaQueryWorkerTest from './grids/YearMonthMediaQueryWorker.test'

import ExifUtilTest from './imageEditor/util/ExifUtil.test';
import ImageEditorUiBaseTest from './imageEditor/uiComponentCheck/imageEditorUiBase.test';
import ImageEditorUiCheckTest from './imageEditor/uiComponentCheck/imageEditorUiCheck.test';
import ImageEditorUiNoteToolColorButtonTest from './imageEditor/uiComponentCheck/imageEditorUiNoteToolColor.test';
import MovingUiUtilTest from './imageEditor/util/MovingUiUtil.test';
import ImageEditorAdjustAttrTest from './imageEditor/util/ImageEditorAdjustAttr.test';
import MovingPhotoLiveNullUtilTest from './imageEditor/util/MovingPhotoLiveNullUtil.test';
import photoEditorKeyBoardTest from './imageEditor/base/PhotoEditorKeyBoard.test';
import JsonUtilTest from './imageEditor/util/JsonUtil.test';

/**
 * suite定义是否执行
 */
export default function PipelineDemoSuite() {

  describe('imageEditor_test', () => {
    // UT
    AccessibilityManagerTest();
    FormatUtilTest();
    UtilTest();
    ScreenUtilTest();
    PhotoAssetUtilTest();
    PositionUtilTest();
    ExifUtilTest();
    MovingUiUtilTest();
    ImageEditorAdjustAttrTest();
    MovingPhotoLiveNullUtilTest();
    RectangleTest();
    PathUtilsTest();
    JsonUtilTest();
  })

  describe('imageEditor_dynamic', () => {
    Aa();
    ImageEditorUiBaseTest();
    ImageEditorUiCheckTest();
    imageStylusGuideTest();
    photoXTStyleEditorTest();
    PhotoApertureImageTest();
  })

  describe('imageEditor_static', () => {
    Ba();
    ImageEditorUiNoteToolColorButtonTest();
    photoEditorTest();
    photoEditorKeyBoardTest();
    imageStylusTest();
    mosaicTest();
  })

  // 智慧图库
  describe('photos_intelligence', () => {
  });

  // 时刻&搜索
  describe('HighlightSearch', () => {
  });

  // picker
  describe('picker', () => {
  });

  // 图库大图
  describe('photos_browser5', () => {
    PanoramaPhotoInnerPic();
  })

  describe('photos_browser4', () => {
    LivePhoto();
    LivePhoto2();
    BrowserFaCardService();
    BrowserFaCardWidget();
    BrowserPicker();
    browserEntranceTest();
  })

  describe('photos_browser3', () => {
    TCAIRetouching();
    TCGraffiti();
    TCCropPicture();
  })

  describe('photos_browser2', () => {
    // UT 白盒 不依赖UI
    backupExtensionTest();
    MathUtilsTest();
    SystemAndTimeUtilsTest();
    BrowserDateUtilTest();
    BrowserArrayUtilTest();
    BrowserImageUtilTest();
    BrowserUiUtilTest();
    BrowserAnalyzerUtilTest();
    FocusCtrlTest();
    BrowserDataFactoryTest();
    ActionBarVarTest();
    setAgreedTest();
    MoireTaskManageTest();
    BrowserEventPipelineTest();
    BrowserStringUtilTest();
    // Util
    LineCrops02Test();
    LineCrops03Test();
    LineCrops04Test();
    LineCrops05Test();
    GridAutoScrollerUtilUT();
    // LightGlimpseHelperUT();
    // LightGlimpseUtilUT();
    MaskLayerUtilsUT();
    PickerPhotoGridControllerUT();
    getDurationTest();
    PerformanceToolTest();
    LineCrops01Test();
    ratioAtLineTest();
    LineCropsTest();
    NetQualityUtilTest();
    BurstPhotosUtilsTest();
    SpliceUtilsTest();
    SideBarControllerTest();
    SpliceMenuOperationTest();
    AudioSessionControllerTest();
    BrowserCostReportManagerTest();
    VideoPlayControllerTest();
    ShortcutControllerTest();
    ImageAdapterHelperTest();
    FastScrollCheckerTest();
    MoireHelperTest();
    MediaItemUtilTest();
    DatabaseProxyUT();
    DatabaseUpdateHelperUT();
    DatabaseOperationHelperUT();
    FaCardAlbumServiceUT();
    FaCardAlbumUtilsUT();
    FaCardServiceUT();
    FormControllerUT();
    ReminderServiceUT();
    ReminderServiceUtilsUT();
    SavePhotosManagerUT();
    SelectionCheckerUT();
    // SkimmingRuleMgrUT();
    UserUtilsUT();
    //UI不放这里了, 容易出现mockFunc没有ignoreMock导致的crash
  });

  describe('photos_browser', () => {
    // 基础功能
    ActionBarButtonTest();
    unitTest();
    BrowserUiTest();
    VideoBrowserUiTest();
    LivePhotoUITest();
    OperateDeleteTest();
    PictureDetailTest();
    PhotoPropertiesTest();
    abilityTest();
    abilityRotateTest();
    abilityFloatTest();
    GallerySettingsMovingPhotoAutoPlay();
  });

  //图库宫格
  describe('photos_grid', () => {

  });
  describe('photos_override', () => {
  });
}