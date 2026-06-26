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

/* instrument ignore file */

import lazy { FetchOptions, UserFileManagerAccess } from './UserFileManagerAccess';
import lazy { AlbumDefine } from '../model/browser/AlbumDefine';
import lazy { Log } from '../utils/Log';

const TAG = 'ScenarioDefaultDataFactory';

/**
 * 图库场景化兜底数据工厂
 */
export class ScenarioDefaultDataFactory {
  /**
   * 卡片出现频率默认值
   */
  public static readonly DEFAULT_INTERVAL_TIME: number[] = [1, 3, 7];
  /**
   * 已满卡片阈值 单位MB
   */
  public static readonly FULL_LIMIT: number = 10;
  /**
   * 将满卡片阈值 单位MB
   */
  public static readonly NEAR_FULL_LIMIT: number = 500;
  /**
   * Mb字节数
   */
  public static readonly MB_BYTE_UNIT: number = 1024 ** 2;
  /**
   * 2Tb字节数
   */
  public static readonly TWO_TB_BYTE_UNIT: number = 2 * 1024 ** 4;
  /**
   * 4Tb字节数
   */
  public static readonly FOUR_TB_BYTE_UNIT: number = 4 * 1024 ** 4;
  /**
   * 1天毫秒数
   */
  public static readonly ONE_DAY_MS: number = 24 * 60 * 60 * 1000;
  /**
   * ipc获取文案超时 打点key
   */
  public static readonly IPC_TIMEOUT: string = 'IPC_TIMEOUT';
  /**
   * 云同步卡片上次操作时间 sp键名后缀
   */
  public static readonly CARD_LAST_OPT_TIME: string = 'lastOptTime';
  /**
   * 云同步卡片展示次数 sp键名后缀
   */
  public static readonly CARD_SHOW_COUNT: string = 'showCount';
  /**
   * 云同步已满卡片点击取消次数 sp键名
   */
  public static readonly FULL_CARD_CLOSE_COUNT: string = 'fullCardCloseCount';
  /**
   * IDL接口interfaceToken
   */
  public static readonly GALLERY_INTERFACE_TOKEN: string = 'OHOS.Photo.CommonServiceAbility';
  /**
   * 已满卡片类型-普通卡片
   */
  public static readonly NORMAL_CARD_TYPE: number = 0;
  /**
   * 已满卡片类型-负反馈卡片
   */
  public static readonly NEG_CARD_TYPE: number = 2;
  /**
   * 曝光打点类型
   */
  public static readonly REPORT_SHOW: string = 'show';
  /**
   * 点击打点类型
   */
  public static readonly REPORT_CLICK: string = 'click';
  /**
   * 取消打点类型
   */
  public static readonly REPORT_CANCEL: string = 'cancel';

  /**
   * 相机地理权限弹窗
   */
  public static readonly CAMERA_LOCATION_STATUS: string = 'cameraLocationStatus';
}