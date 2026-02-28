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
import type Want from '@ohos.app.ability.Want';

export class TestConstants {
  // log tag
  public static readonly TAG = 'DT/';
  public static readonly TAG_SMART = 'SMART_Phone_DT/';
  // 包名
  public static readonly BUNDLE_NAME: string = 'bundleName';
  // 类名
  public static readonly ABILITY_NAME: string = 'abilityName';
  // 图库包名
  public static readonly PHOTO_BUNDLE_NAME: string = 'com.ohos.photos';
  // 图库首页
  public static readonly PHOTO_MAIN_ABILITY_NAME: string = 'com.ohos.photos.MainAbility';
  // 相机包名
  public static readonly CAMERA_BUNDLE_NAME: string = 'com.ohos.camera';
  // 相机首页
  public static readonly CAMERA_MAIN_ABILITY_NAME: string = 'com.ohos.camera.MainAbility';

  // pick单张
  public static readonly PICK_SINGLE_PHOTO: string = 'singleselect';
  // pick多张
  public static readonly PICK_MULTIPLE_PHOTO: string = 'multipleselect';
  // 选择条件All
  public static readonly FILTER_MEDIA_TYPE_ALL: string = 'FILTER_MEDIA_TYPE_ALL';
  // 单选图片
  public static readonly SINGLE_SELECT_COUNT: number = 1;
  // 多选图片最大数
  public static readonly MULTIPLE_SELECT_COUNT: number = 50;
  // 测试用例级别 0
  public static readonly TEST_LEVEL_ZERO: number = 0;
  // 测试用例级别 1
  public static readonly TEST_LEVEL_ONE: number = 1;
  // 测试用例级别 2
  public static readonly TEST_LEVEL_TWO: number = 2;
  // 测试用例级别 3
  public static readonly TEST_LEVEL_THREE: number = 3;
  // 延迟 1s
  public static readonly DELAY_ONE_SECOND: number = 1000;
  // 延迟 2s
  public static readonly DELAY_TWO_SECOND: number = 2000;
  // 延迟 3s
  public static readonly DELAY_THREE_SECOND: number = 3000;
  // 延迟 10s
  public static readonly DELAY_TEN_SECOND: number = 10000;
  // 多选是否显示序号
  public static readonly IS_SHOW_SERIAL_NUM: boolean = true;
  // 智能picker 二维码/条码场景
  public static readonly QR_OR_BAR_CODE_RECOMMENDATION_TYPE = 1;
  // 智能picker 二维码场景
  public static readonly QR_CODE_RECOMMENDATION_TYPE = 2;
  // 智能picker 条码场景
  public static readonly BAR_CODE_RECOMMENDATION_TYPE = 3;
  // 智能picker 身份证场景
  public static readonly ID_CARD_RECOMMENDATION_TYPE = 4;
  // 智能picker 头像场景
  public static readonly PROFILE_PICTURE_RECOMMENDATION_TYPE = 5;
  // 打开图库
  public static readonly START_PHOTO_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
  };

  // 打开相机
  public static readonly START_CAMERA_WANT: Want = {
    bundleName: TestConstants.CAMERA_BUNDLE_NAME,
    abilityName: TestConstants.CAMERA_MAIN_ABILITY_NAME,
  };

  // pick单张图片打开图库
  public static readonly SINGLE_PICK_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
    }
  };
  // pick多张图片打开图库
  public static readonly MULTIPLE_PICK_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_MULTIPLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.MULTIPLE_SELECT_COUNT,
    }
  };
  // pick多张图片显示序号并按照序号返回
  public static readonly MULTIPLE_PICK_SERIAL_NUM_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_MULTIPLE_PHOTO,
      maxSelectCount: TestConstants.MULTIPLE_SELECT_COUNT,
      isShowSerialNum: TestConstants.IS_SHOW_SERIAL_NUM,
    }
  };
  //smartPicker选择二维码/条码
  public static readonly SMART_PICKER_QR_OR_BAR_CODE_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.QR_OR_BAR_CODE_RECOMMENDATION_TYPE },
    }
  };
  //smartPicker选择二维码
  public static readonly SMART_PICKER_QR_CODE_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.QR_CODE_RECOMMENDATION_TYPE },
    }
  };
  //smartPicker选择条码
  public static readonly SMART_PICKER_BAR_CODE_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.BAR_CODE_RECOMMENDATION_TYPE },
    }
  };
  //smartPicker选择身份证
  public static readonly SMART_PICKER_ID_CARD_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.ID_CARD_RECOMMENDATION_TYPE },
    }
  };
  //smartPicker选择头像
  public static readonly SMART_PICKER_PROFILE_PICTURE_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.PROFILE_PICTURE_RECOMMENDATION_TYPE },
    }
  };
}