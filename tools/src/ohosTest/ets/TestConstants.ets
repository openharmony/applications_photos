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

export namespace TestConstants {
  /** 公共id配置 **/
  // 使用系统公共弹窗组件: 取消和确认按钮
  export const DIALOG_BUTTON_FIRST: string = 'advanced_dialog_button_0';

  export const DIALOG_BUTTON_SECOND: string = 'advanced_dialog_button_1';

  export const PICKER_GRID_ITEM_PREFIX: string = 'ThirdSelectAlbumGridBase_GridItem';

  // log tag
  export const TAG = 'DT/';

  export const TAG_SMART = 'SMART_Phone_DT/';

  // 包名
  export const BUNDLE_NAME: string = 'bundleName';

  // 类名
  export const ABILITY_NAME: string = 'abilityName';

  // 文件管理
  export const FILES_BUNDLE_NAME: string = 'com.ohos.files';

  // 文件管理首页
  export const FILES_ABILITY_NAME: string = 'EntryAbility';

  // 图库包名
  export const PHOTO_BUNDLE_NAME: string = 'com.ohos.photos';

  // 图库首页
  export const PHOTO_MAIN_ABILITY_NAME: string = 'com.ohos.photos.MainAbility';

  // 相机包名
  export const CAMERA_BUNDLE_NAME: string = 'com.ohos.camera';

  // 设置包名
  export const SETTING_BUNDLE_NAME: string = 'com.ohos.settings';

  // 相机首页
  export const CAMERA_MAIN_ABILITY_NAME: string = 'com.ohos.camera.MainAbility';

  // 设置首页
  export const SETTING_MAIN_ABILITY_NAME: string = 'com.ohos.settings.MainAbility';

  // smartPicker text input
  export const SMART_PICKER_TEXT_INPUT: string = '大熊猫';

  // pick单张
  export const PICK_SINGLE_PHOTO: string = 'singleselect';

  // pick多张
  export const PICK_MULTIPLE_PHOTO: string = 'multipleselect';

  // 选择条件All
  export const FILTER_MEDIA_TYPE_ALL: string = 'FILTER_MEDIA_TYPE_ALL';

  // 选择条件video
  export const FILTER_MEDIA_TYPE_VIDEO: string = 'FILTER_MEDIA_TYPE_VIDEO';

  /**
   * 【照片页】ActionBar 名称-key映射关系
   */
  // 照片页放大镜
  export const TIMELINE_ACTION_BUTTON_SEARCH = 'ActionButton_Search';

  // 相册页放大镜
  export const ALBUM_ACTION_BUTTON_SEARCH = 'More_Image_Search';

  // 返回
  export const TIMELINE_ACTION_BUTTON_BACK = 'ActionButton_Back';

  // 取消
  export const TIMELINE_ACTION_BUTTON_CANCEL = 'ActionButton_Cancel';

  // 分享   照片页-相册页 下方toolbar按钮公用key   统一取最外层button上key
  export const TIMELINE_ACTION_BUTTON_SHARE = 'ToolBarButton_ActionButton_Share';

  // 对比   照片页-相册页 下方toolbar按钮公用key   统一取最外层button上key
  export const TIMELINE_ACTION_BUTTON_COMPARE = 'ToolBarButton_ActionButton_compare';

  // 拼图   照片页-相册页 下方toolbar按钮公用key   统一取最外层button上key
  export const TIMELINE_ACTION_BUTTON_COLLAGE = 'ToolBarButton_ActionButton_Collage';

  // 删除   照片页-相册页 下方toolbar按钮公用key   统一取最外层button上key
  export const TIMELINE_ACTION_BUTTON_DELETE = 'ToolBarButton_ActionButton_Delete';

  // 更多- 取SymbolGlyph组件上的key   与   相册内右上角更多公用
  export const TIMELINE_ACTION_BUTTON_MORE = 'ActionButton_More';

  // 更多 - 移动到
  export const TIMELINE_ACTION_BUTTON_MORE_MOVE = 'ActionBarButton_Text_ActionButton_Move';

  // 更多 - 收藏或取消收藏
  export const TIMELINE_ACTION_BUTTON_MORE_FAVOR = 'ActionBarButton_Text_ActionButton_Favor';

  // 更多 - 隐藏
  export const TIMELINE_ACTION_BUTTON_MORE_HIDE = 'ActionBarButton_Text_ActionButton_Hide';

  // 更多 - 打印或生成pdf
  export const TIMELINE_ACTION_BUTTON_MORE_DELETE = 'ActionBarButton_Text_ActionButton_Delete';

  // 更多 - 移动到  -  新建相册
  export const TIMELINE_ACTION_BUTTON_MORE_NEW_ALBUM = 'More_Image_NewAlbum';

  // 相册页右上角四个点按钮
  export const ALBUMS_ACTION_BUTTON_MORE = 'ActionBarButtonTimelineActionMore';

  // 多选
  export const ALBUMS_ACTION_BUTTON_MORE_MULTI_SELECTED = 'ActionBarButton_Text_MultiSelected';

  // 删除相册
  export const ALBUMS_ACTION_BUTTON_MORE_DELETE_ALBUM = 'ActionBarButton_Text_ActionButton_DeleteAlbum';

  //照片-搜索-返回
  export const SEARCH_BACK_BUTTON = 'searchBackButton'

  // 相册页-图片相册
  export const ALBUM_NAME_TU_PIAN = 'Album_0'

  // 相册页-图片名称
  export const ALBUM_NAME_TU_PIAN_NAME = '图片'

  // 单选图片
  export const SINGLE_SELECT_COUNT: number = 1;

  // 多选图片最大数
  export const MULTIPLE_SELECT_COUNT: number = 50;

  // 测试用例级别 0
  export const TEST_LEVEL_ZERO: number = 0;

  // 测试用例级别 1
  export const TEST_LEVEL_ONE: number = 1;

  // 测试用例级别 2
  export const TEST_LEVEL_TWO: number = 2;

  // 测试用例级别 3
  export const TEST_LEVEL_THREE: number = 3;

  // 延迟 0.5s
  export const DELAY_HALF_SECOND: number = 500;

  // 延迟 1s
  export const DELAY_ONE_SECOND: number = 1000;

  // 延迟 2s
  export const DELAY_TWO_SECOND: number = 2000;

  // 延迟 3s
  export const DELAY_THREE_SECOND: number = 3000;

  // 延迟 4s
  export const DELAY_FOUR_SECOND: number = 4000;

  // 延迟 5s
  export const DELAY_FIVE_SECOND: number = 5000;

  // 延迟 10s
  export const DELAY_TEN_SECOND: number = 10000;

  // 延迟 20s
  export const DELAY_TWENTY_SECOND: number = 20000;

  // 多选是否显示序号
  export const IS_SHOW_SERIAL_NUM: boolean = true;

  // 智能picker 二维码/条码场景
  export const QR_OR_BAR_CODE_RECOMMENDATION_TYPE = 1;

  // 智能picker 二维码场景
  export const QR_CODE_RECOMMENDATION_TYPE = 2;

  // 智能picker 条码场景
  export const BAR_CODE_RECOMMENDATION_TYPE = 3;

  // 智能picker 身份证场景
  export const ID_CARD_RECOMMENDATION_TYPE = 4;

  // 智能picker 头像场景
  export const PROFILE_PICTURE_RECOMMENDATION_TYPE = 5;

  // 智能picker 护照场景
  export const PASSPORT_RECOMMENDATION_TYPE = 6;

  // 智能picker 银行卡场景
  export const BANK_CARD_RECOMMENDATION_TYPE = 7;

  // 智能picker 驾驶证场景
  export const DRIVER_LICENSE_RECOMMENDATION_TYPE = 8;

  // 智能picker 行驶证场景
  export const DRIVING_LICENSE_RECOMMENDATION_TYPE = 9;

  // 智能picker 精选单人像场景
  export const FEATURED_SINGLE_PORTRAIT_RECOMMENDATION_TYPE = 10;

  // 智能picker 无效类型场景
  export const INVALID_RECOMMENDATION_TYPE = -1;

  // 默认XXX效果
  export const DEFAULT_COLOR_STYLE: string = "default";

  //体验APP
  export const EXPERIENCE_HAP: string = "com.xxx.baseexperience";

  //大图页面ID
  export const PHOTO_BROWSER_PAGE_ID: number = 2;

  //大图页面ID
  export const EMPTY_IMAGE_URI: string = "";

  // 打开图库
  export const START_PHOTO_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
  };

  // 打开相机
  export const START_CAMERA_WANT: Want = {
    bundleName: TestConstants.CAMERA_BUNDLE_NAME,
    abilityName: TestConstants.CAMERA_MAIN_ABILITY_NAME,
  };

  // 打开设置
  export const START_SETTINGS_WANT: Want = {
    bundleName: TestConstants.SETTING_BUNDLE_NAME,
    abilityName: TestConstants.SETTING_MAIN_ABILITY_NAME,
  };

  // pick单张图片打开图库
  export const SINGLE_PICK_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
    }
  };

  // pick多张图片打开图库
  export const MULTIPLE_PICK_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_MULTIPLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.MULTIPLE_SELECT_COUNT,
    }
  };

  // pick多张图片显示序号并按照序号返回
  export const MULTIPLE_PICK_SERIAL_NUM_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_MULTIPLE_PHOTO,
      maxSelectCount: TestConstants.MULTIPLE_SELECT_COUNT,
      isShowSerialNum: TestConstants.IS_SHOW_SERIAL_NUM,
    }
  };

  //smartPicker选择二维码/条码
  export const SMART_PICKER_QR_OR_BAR_CODE_WANT: Want = {
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
  export const SMART_PICKER_QR_CODE_WANT: Want = {
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
  export const SMART_PICKER_BAR_CODE_WANT: Want = {
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
  export const SMART_PICKER_ID_CARD_WANT: Want = {
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
  export const SMART_PICKER_PROFILE_PICTURE_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.PROFILE_PICTURE_RECOMMENDATION_TYPE },
    }
  };

  //smartPicker文本类输入为你推荐
  export const SMART_PICKER_TEXT_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { textContextInfo: { text: TestConstants.SMART_PICKER_TEXT_INPUT } }
    }
  };

  //smartPicker选择护照
  export const SMART_PICKER_PASSPORT_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.PASSPORT_RECOMMENDATION_TYPE },
    }
  };

  //smartPicker选择银行卡
  export const SMART_PICKER_BANK_CARD_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.BANK_CARD_RECOMMENDATION_TYPE },
    }
  };

  //smartPicker选择驾驶证
  export const SMART_PICKER_DRIVER_LICENSE_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.DRIVER_LICENSE_RECOMMENDATION_TYPE },
    }
  };

  //smartPicker选择行驶证
  export const SMART_PICKER_DRIVING_LICENSE_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.DRIVING_LICENSE_RECOMMENDATION_TYPE },
    }
  };

  //smartPicker选择精选单人像
  export const SMART_PICKER_FEATURED_SINGLE_PORTRAIT_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.FEATURED_SINGLE_PORTRAIT_RECOMMENDATION_TYPE },
    }
  };

  //smartPicker
  export const SMART_PICKER_NO_RECOMMEND_OPTIONS_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
    }
  };

  //smartPicker
  export const SMART_PICKER_INVALID_RECOMMEND_OPTIONS_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendType: TestConstants.ID_CARD_RECOMMENDATION_TYPE },
    }
  };

  //smartPicker
  export const SMART_PICKER_VIDEO_RECOMMEND_OPTIONS_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_VIDEO,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.ID_CARD_RECOMMENDATION_TYPE },
    }
  };

  //smartPicker
  export const SMART_PICKER_INVALID_RECOMMEND_TYPE_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      uri: TestConstants.PICK_SINGLE_PHOTO,
      filterMediaType: TestConstants.FILTER_MEDIA_TYPE_ALL,
      maxSelectCount: TestConstants.SINGLE_SELECT_COUNT,
      recommendationOptions: { recommendationType: TestConstants.INVALID_RECOMMENDATION_TYPE },
    }
  };

  // 门店app打开图库
  export const EXPERIENCE_WANT: Want = {
    bundleName: TestConstants.PHOTO_BUNDLE_NAME,
    abilityName: TestConstants.PHOTO_MAIN_ABILITY_NAME,
    parameters: {
      colorStyle: TestConstants.DEFAULT_COLOR_STYLE,
      fromName: TestConstants.EXPERIENCE_HAP,
      uri: TestConstants.EMPTY_IMAGE_URI,
      targetPageId: TestConstants.PHOTO_BROWSER_PAGE_ID,
    }
  };
}