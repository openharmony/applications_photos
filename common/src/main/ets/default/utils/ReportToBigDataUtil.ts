/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import hiSysEvent from '@ohos.hiSysEvent';
import { Log } from './Log';
import { MediaItem } from '../model/browser/photo/MediaItem';

const TAG: string = 'common_ReportToBigDataUtil';

export class ReportToBigDataUtil {
  /**
   * 前缀的字符个数是4（IMG_,VID_）
   */
  private static PREFIX_NUMBER: number = 4;
  static readonly PHOTOS_DFX_DOMAIN: string = 'PHOTOS';

  public static report(eventId: string, eventMsg?: object): void {
    hiSysEvent.write({
      domain: ReportToBigDataUtil.PHOTOS_DFX_DOMAIN,
      name: eventId,
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: eventMsg
    }, (err, val) => {
      Log.error(TAG, `report to bigData error because: ${err}`);
    })

    Log.info(TAG, `report, eventId: ${eventId} msg: ${JSON.stringify(eventMsg)}`);
  }

  public static statisticReport(eventId: string, eventMsg?: object): void {
    hiSysEvent.write({
      domain: ReportToBigDataUtil.PHOTOS_DFX_DOMAIN,
      name: eventId,
      eventType: hiSysEvent.EventType.STATISTIC,
      params: eventMsg
    }, (err, val) => {
      Log.error(TAG, `report to bigData error because: ${err}`);
    })

    Log.info(TAG, `report, eventId: ${eventId} msg: ${JSON.stringify(eventMsg)}`);
  }

  public static errEventReport(eventId: string, eventMsg?: object): void {
    hiSysEvent.write({
      domain: ReportToBigDataUtil.PHOTOS_DFX_DOMAIN,
      name: eventId,
      eventType: hiSysEvent.EventType.FAULT,
      params: eventMsg
    }, (err, val) => {
      Log.error(TAG, `report to bigData error because: ${err}`);
    })
    Log.info(TAG, 'errEventReport, eventId: ' + eventId + ' msg: ' + JSON.stringify(eventMsg));
  }

  // 获取相机拍摄照片视频的名称
  public static getFileNameOfPhotoTakenByCamera(mediaItem: MediaItem): string {
    if (mediaItem == null) {
      return '';
    }
    let name = mediaItem.getTitle();
    if (name == null) {
      return '';
    }
    // 匹配相机拍摄照片视频的命名格式
    let formatExp: RegExp = /^(IMG|VID)\_\d{8}\_\d{6}$/;
    if (name.match(formatExp) == null) {
      return '';
    }
    // 去除前缀
    return name.slice(ReportToBigDataUtil.PREFIX_NUMBER, name.length);
  }

  public static setFileNameProperty(eventMsg: object, name: string): void {
    if (eventMsg == null) {
      return;
    }
    if (name == null || name == '') {
      return;
    }
    Object.defineProperty(eventMsg, 'FileName', { value: name, enumerable: true });
  }
}

export class BigDataConstants {

  // 进入图库方式
  public static readonly ENTER_PHOTOS_ID: string = 'ENTER_PHOTO';
  // param
  public static readonly ENTER_BY_CAMERA: string = 'ENTER_BY_CAMERA';

  // Tab切换
  public static readonly TAB_SWITCH_ID: string = 'TAB_SWITCH';
  // param
  public static readonly CLICK_SWITCH: string = 'Click';

  // 查看大图
  public static readonly ENTER_PHOTO_BROWSER_ID: string = 'ENTER_PHOTO_BROWSER';
  // param
  public static readonly LOCAL_MEDIA: string = 'LOCAL_MEDIA';

  // 查看大图
  public static readonly PHOTO_BROWSER_SLIDE_ID: string = 'PHOTO_BROWSER_SLIDE';
  // param
  public static readonly NORMAL_PHOTO: string = 'PHOTO';
  public static readonly VIDEO: string = 'VIDEO';

  // 删除类型操作
  public static readonly DELETE_TYPE_ID: string = 'DELETE_TYPE';
  // param
  public static readonly DELETE_CLOUD_ONLY: string = 'DELETE_CLOUD_ONLY'
  public static readonly DELETE_LOCAL_ONLY: string = 'DELETE_LOCAL_ONLY'

  public static readonly REMOVE_TYPE_ID: string = 'REMOVE_TYPE';
  public static readonly REMOVE: string = 'REMOVE'


  // 删除类型操作
  public static readonly SPLIT_SCREEN_ID: string = 'SPLIT_SCREEN';

  // 相机进入大图操作
  public static readonly BROWSE_PHOTO_FROM_CAMERA_ID: string = 'BROWSE_PHOTO_FROM_CAMERA';

  // 照片按钮点击操作
  public static readonly CLICK_PHOTO_BUTTON_ID: string = 'CLICK_PHOTO_BUTTON';
  // param
  public static readonly PHOTO_BUTTON_VIDEO: string = 'VIDEO';

  // 下拉返回操作
  public static readonly PHOTO_PULL_DOWN_ID: string = 'PHOTO_PULL_DOWN';

  // 全选操作
  public static readonly SELECT_ALL_ID: string = 'SELECT_ALL';

  // 多选分享操作
  public static readonly MULTI_SHARE_ID: string = 'MULTI_SHARE';

  // 多选删除操作
  public static readonly MULTI_DELETE_ID: string = 'MULTI_DELETE';

  // 发送至U盘操作
  public static readonly EXPORT_ID: string = 'EXPORT';

  // 发送至U盘结果
  public static readonly EXPORT_RESULT_ID: string = 'EXPORT_RESULT';
  public static readonly CREATE_FA_CARD_ID: string = 'CREATE_FA_CARD';
  public static readonly DELETE_FA_CARD_ID: string = 'DELETE_FA_CARD';
  public static readonly CREATE_THIRD_EDIT_SAVE: string = 'CREATE_THIRD_EDIT_SAVE';
  public static readonly CHANGE_FA_CARD_IMAGE_ID: string = 'CHANGE_FA_CARD_IMAGE';
  public static readonly SET_FA_CARD_CAROUSEL_ID: string = 'SET_FA_CARD_CAROUSEL';
  public static readonly SET_FA_CARD_IS_NAME_ID: string = 'SET_FA_CARD_IS_NAME';

  // 选择Picker操作
  public static readonly SELECT_PICKER_ID: string = 'SELECT_PICKER';
  public static readonly SELECT_PICKER_RESULT: string = 'SELECT_PICKER_RESULT';
  public static readonly SELECT_PICKER_CLICK_CAMERA_ID: string = 'SELECT_PICKER_CLICK_CAMERA';
  public static readonly SELECT_PICKER_CLICK_PREVIEW: string = 'SELECT_PICKER_CLICK_PREVIEW';
  public static readonly SELECT_PICKER_SWITCH_ALBUM: string = 'SELECT_PICKER_SWITCH_ALBUM';

  // ERROR
  public static readonly FA_CARD_ERROR: string = 'FA_CARD_ERROR';
  public static readonly CREATE_FA_CARD_ERROR: string = 'CREATE_FA_CARD_ERROR';
  public static readonly DELETE_FA_CARD_ERROR: string = 'DELETE_FA_CARD_ERROR';
  public static readonly CHANGE_FA_CARD_IMAGE_ERROR: string = 'CHANGE_FA_CARD_IMAGE_ERROR';
  public static readonly SET_FA_CARD_CAROUSEL_ERROR: string = 'SET_FA_CARD_CAROUSEL_ERROR';
  public static readonly SET_FA_CARD_IS_NAME_ERROR: string = 'SET_FA_CARD_IS_NAME_ERROR';

  // Tab
  public static readonly PHOTO_TAB: string = 'TIME';
  public static readonly ALBUM_TAB: string = 'LIST';

  // 进入大图编辑
  public static readonly ENTER_PHOTO_EDIT_ID: string = 'ENTER_PHOTO_EDIT';

  // 大图编辑操作
  public static readonly PHOTO_EDIT_TYPE_ID: string = 'PHOTO_EDIT_OPERATION';
  // param
  public static readonly PHOTO_EDIT_ROTATE: string = 'ROTATE'
  public static readonly PHOTO_EDIT_MIRROR: string = 'MIRROR'
  public static readonly PHOTO_EDIT_RESET: string = 'RESET'

  // 编辑保存
  public static readonly PHOTO_EDIT_SAVE_ID: string = 'PHOTO_EDIT_SAVE'
  //param
  public static readonly SAVE_AS_NEW: string = 'SAVE_AS_NEW'
  public static readonly SAVE_REPLACE: string = 'SAVE_REPLACE'


  // 编辑保存失败
  public static readonly PHOTO_EDIT_SAVE_ERROR_ID: string = 'GALLERY_FILE_EDIT_SAVE_FAIL'

  // 进入大图方式
  public static readonly ENTER_PHOTO_BROWSER_WAY: string = 'ENTER_PHOTO_BROWSER_WAY';
  // 退出大图方式
  public static readonly ESC_PHOTO_BROWSER_WAY: string = 'ESC_PHOTO_BROWSER_WAY';
  // 方式
  public static readonly BY_KEYBOARD: string = 'BY_KEYBOARD';
  public static readonly BY_CLICK: string = 'BY_CLICK';

  // 相册操作
  public static readonly ALBUM_OPERATION_ID: string = 'ALBUM_OPERATION';
  public static readonly ALBUM_CREATE: string = 'ALBUM_CREATE';
  public static readonly ALBUM_RENAME: string = 'ALBUM_RENAME';
  public static readonly MEDIA_MOVE: string = 'MEDIA_MOVE';
  public static readonly MEDIA_COPY: string = 'MEDIA_COPY';
  // error
  public static readonly ALBUM_OPERATION_ERROR_ID: string = 'ALBUM_OPERATION_ERROR';
  public static readonly ALBUM_CREATE_ERROR: string = 'ALBUM_CREATE_ERROR';
  public static readonly ALBUM_RENAME_ERROR: string = 'ALBUM_RENAME_ERROR';
  public static readonly MEDIA_MOVE_ERROR: string = 'MEDIA_MOVE_ERROR';
  public static readonly MEDIA_COPY_ERROR: string = 'MEDIA_COPY_ERROR';

  //是否显示菜单栏
  public static readonly IS_SHOW_MENU_ID: string = 'IS_SHOW_MENU_FROM_THIRDVIEW';
  public static readonly UNDEFINED_IS_SHOW_MENU: string = 'UNDEFINED_IS_SHOW_MENU';
  public static readonly SHOW_MENU: string = 'SHOW_MENU';
  public static readonly HIDE_MENU: string = 'HIDE_MENU';
}