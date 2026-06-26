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

import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { dataSharePredicates, DataShareResultSet, ValuesBucket } from '@kit.ArkData';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy storageStatistics from '@ohos.file.storageStatistics';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { RecommendClearingCard } from './RecomendClearingCard';
import lazy SettingCardDataShareAbility from './SettingCardDataShareAbility';
import lazy { ImageUtil } from '@ohos/common/src/main/ets/default/utils/ImageUtil';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy { Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';

/**
 * 日志TAG
 */
/* instrument ignore file */
const TAG = 'SettingCardAccess';

/**
 * 图库空间优化卡片Access
 */
export class SettingCardAccess {
  /**
   * 单例
   */
  private static instance: SettingCardAccess;
  private static readonly COUNT_ONE: number = 1;
  private static readonly COUNT_ZERO: number = 0;
  private albumTotalSize: number = 0;

  private constructor() {
  }

  /**
   * 获取单例
   */
  public static getInstance(): SettingCardAccess {
    if (!SettingCardAccess.instance) {
      SettingCardAccess.instance = new SettingCardAccess();
    }
    return SettingCardAccess.instance;
  }

  /**
   * 查询"推荐清理卡片"是否展示
   *
   */
  private async checkIsNeedShow(context: Context): Promise<boolean> {
    const isSettingAgreed = await Protocol.getIsAgreedPref(context);
    Log.info(TAG, `checkIsNeedShow:getIsAgreedPref, isAgreed=${isSettingAgreed}`);
    if (!isSettingAgreed) {
      Log.info(TAG, `checkIsNeedShow:isAgreed=${isSettingAgreed}`);
      return false;
    }
    try {
      // 获取总空间
      let totalSize = await storageStatistics.getTotalSize();
      //获取设备剩余空间
      let freeSize = await storageStatistics.getFreeSize();
      let freeRate = freeSize / totalSize;
      Log.info(TAG, `check size info ,total : ${totalSize} free：${freeSize} rate：${freeRate}`);
      // 查询媒体库
      UserFileManagerAccess.getInstance().onCreate(context);
      let localMediaSize: number = await UserFileManagerAccess.getInstance().getLocalMediaAndRecentDeletedSize();
      this.albumTotalSize = localMediaSize;
      if ((freeRate < Constants.NEED_SHOW_FREE_MEMORY_LIMIT) &&
        (localMediaSize / Constants.MB_UNIT > Constants.NEED_SHOW_MEDIA_MEMORY_LIMIT)) {
        Log.info(TAG, 'less 10% and return true');
        return true;
      } else if ((freeRate >= Constants.NEED_SHOW_FREE_MEMORY_LIMIT) &&
        (localMediaSize / Constants.MB_UNIT > Constants.NEED_SHOW_FREE_MEMORY_LOWER_LIMIT)) {
        Log.info(TAG, 'beyond 10% and return true');
        return true;
      } else {
        Log.info(TAG, 'check size finish and return false');
        return false;
      }
    } catch (err) {
      Log.info(TAG, `check size with err : ${JSON.stringify(err)}`);
      return false;
    }
  }

  /**
   * 获取卡片信息
   *
   * @param uriString uri
   * @param callback 回调
   */
  public async fetchSettingCardInfo(predicates: dataSharePredicates.DataSharePredicates, callback: Function,
    context: Context): Promise<void> {
    try {
      // 空间优化卡片信息
      this.albumTotalSize = 0;
      let needShow = await this.checkIsNeedShow(context);
      if (needShow) {
        const msg: Record<string, number | string | boolean> = {
          'cleanupFileSize': ImageUtil.formatMBSize(this.albumTotalSize)
        };
        Log.info(TAG, `fetchSettingCardInfo: this.albumTotalSize=${ImageUtil.formatMBSize(this.albumTotalSize)}`);
        ReportToBigDataUtil.report(BigDataConstants.GET_GALLERY_CLEANUP_SIZE, msg);
      }
      let isRtl: boolean = i18n.isRTL(i18n.System.getSystemLanguage());
      let summaryParam: string = isRtl ? ImageUtil.formatFileSize(this.albumTotalSize).replace(' ', '') :
        ImageUtil.formatFileSize(this.albumTotalSize);
      let cardInfo: RecommendClearingCard =
        RecommendClearingCard.createCardInfo(needShow, summaryParam);
      // 插入数据库
      await this.saveCardInfoToDb(needShow, JSON.stringify(cardInfo.getCradInfo()), predicates, callback);
    } catch (err) {
      Log.error(TAG, `fetchCardInfo err, code ${err?.code} message ${err?.message}`);
    } finally {
      // 查询数据库拿到返回值
      Log.info(TAG, 'fetch ok ');
    }
  }

  /**
   * 获取资产信息
   *
   * @param requestType 请求类型
   * @param predicates predicates
   * @param callback 回调
   * @param context 上下文信息
   */
  public async fetchAssetsInfo(requestType: string, predicates: dataSharePredicates.DataSharePredicates,
    callback: Function, context: Context): Promise<void> {
    try {
      UserFileManagerAccess.getInstance().onCreate(context);
      const isSettingAgreed = await Protocol.getIsAgreedPref(context);
      Log.info(TAG, `fetchAssetsInfo:getIsAgreedPref,requestType=${requestType} isAgreed=${isSettingAgreed}`);
      if (!isSettingAgreed) {
        await this.procNotAgreedFetchAssetsInfo(isSettingAgreed, requestType, predicates, callback);
        return;
      }
      if (requestType === 'queryVideoSize') {
        // 获取视频大小
        let videoSize: number = await UserFileManagerAccess.getInstance().getAllLocalVideoSize();
        // 插入数据库
        await this.saveVideoSizeToAssetsInfoDb(videoSize, predicates, callback);
      } else if (requestType === 'queryImageSize') {
        // 获取图片大小
        let imageSize: number = await UserFileManagerAccess.getInstance().getAllLocalImageSize();
        // 插入数据库
        await this.saveImageSizeToAssetsInfoDb(imageSize, predicates, callback);
      }
    } catch (err) {
      Log.error(TAG, `fetchAssetsInfo err, code ${err?.code} message ${err?.message}`);
    } finally {
      Log.info(TAG, 'fetchAssetsInfo ok ');
    }
  }

  private async procNotAgreedFetchAssetsInfo(isAgreed: boolean, requestType: string,
    predicates: dataSharePredicates.DataSharePredicates, callback: Function) {
    // 在图库隐私同意前，通过storageStatistics.getUserStorageStats查询图片和视频的大小，图库隐私同意后，保持现在的查询方式。
    let storageStats = await storageStatistics?.getUserStorageStats();
    if (!storageStats) {
      Log.error(TAG, `procNotAgreedFetchAssetsInfo: storageStats is invalid!`);
      return;
    }
    let storageVideoSize: number = storageStats?.video ?? 0;
    let storageImageSize: number = storageStats?.image ?? 0;
    Log.info(TAG, `storageVideoSize=${storageVideoSize}, storageImageSize=${storageImageSize}`);
    if (requestType === 'queryVideoSize') {
      await this.saveVideoSizeToAssetsInfoDb(storageVideoSize, predicates, callback);
    } else if (requestType === 'queryImageSize') {
      await this.saveImageSizeToAssetsInfoDb(storageImageSize, predicates, callback);
    }
  }

  /**
   * 保存卡片信息
   *
   * @param needShow 卡片是否展示
   * @param cardInfo 卡片信息
   * @param uriString uri信息
   * @param callback callback回调
   */
  private async saveCardInfoToDb(needShow: boolean, cardInfo: string,
    predicates: dataSharePredicates.DataSharePredicates, callback: Function): Promise<void> {
    if (!callback) {
      return;
    }
    let bucket: ValuesBucket = {
      needShow: needShow ? 'true' : 'false',
      cardName: `SettingClearingCardInfo`, cardInfo: cardInfo
    };
    try {
      Log.info(TAG, `start saveCardInfoToDb needShow ${needShow}`);
      const cardEntity = new SettingCardDataShareAbility();
      let updatePredicates = new dataSharePredicates.DataSharePredicates();
      // 查询库中空间优化卡片信息
      let queryCallBack: Function = this.queryCallBackFunc(cardEntity, updatePredicates, bucket, predicates, callback);
      await cardEntity.query('.queryCardInfo', updatePredicates, [], queryCallBack);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Log.error(TAG, `saveCardInfoToDb error, code ${err.code}, message ${err.message}`);
    }
  }

  private queryCallBackFunc(cardEntity: SettingCardDataShareAbility,
    updatePredicates: dataSharePredicates.DataSharePredicates,
    bucket: ValuesBucket, predicates: dataSharePredicates.DataSharePredicates, callback: Function): Function {
    return (error: BusinessError, resultSet: DataShareResultSet): void => {
      Log.info(TAG, `start queryResult ${resultSet.rowCount}`);
      if (resultSet.rowCount == SettingCardAccess.COUNT_ONE) {
        // 已存在cardInfo 信息，只需要更新
        cardEntity.update(`.updateCardInfo`, updatePredicates, bucket, () => {
          Log.info(TAG, `update ok`);
          cardEntity.queryTableContent('RecommendClearingCard', predicates, callback);
        });
      } else if (resultSet.rowCount == SettingCardAccess.COUNT_ZERO) {
        // 不存在cardInfo信息,需要插入
        cardEntity.insert(`.insertCardInfo`, bucket, () => {
          Log.info(TAG, `insert ok`);
          cardEntity.queryTableContent('RecommendClearingCard', predicates, callback);
        });
      } else {
        Log.error(TAG, `saveCardInfoToDb failed ${resultSet.rowCount}`);
      }
    };
  }

  /**
   * 保存视频大小到数据库
   *
   * @param videoLocalSize 本地总视频大小
   * @param predicates predicates
   * @param callback callback
   */
  private async saveVideoSizeToAssetsInfoDb(videoLocalSizeByte: number,
    predicates: dataSharePredicates.DataSharePredicates, callback: Function): Promise<void> {
    if (!callback) {
      return;
    }
    try {
      let localVideoSize: string = ImageUtil.formatFileSize(videoLocalSizeByte);
      localVideoSize = this.formatVideoSizeText(localVideoSize);
      Log.info(TAG, `saveVideoSizeToAssetsInfoDb start: localVideoSize=${localVideoSize}`);
      const cardEntity = new SettingCardDataShareAbility();
      let updatePredicates = new dataSharePredicates.DataSharePredicates();
      let queryCallBack: Function =
        this.queryVideoSizeCallBackFunc(localVideoSize, cardEntity, updatePredicates, predicates, callback);
      await cardEntity.query('.queryLocalVideoSize', updatePredicates, [], queryCallBack);
      const msg: Record<string, number | string | boolean> = {
        'cleanupVideosSize': ImageUtil.formatMBSize(videoLocalSizeByte)
      };
      ReportToBigDataUtil.report(BigDataConstants.GET_VIDEO_CLEANUP_SIZE, msg);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Log.error(TAG, `saveVideoSizeToAssetsInfoDb error, code ${err.code}, message ${err.message}`);
    }
  }

  private queryVideoSizeCallBackFunc(localVideoSize: string, cardEntity: SettingCardDataShareAbility,
    updatePredicates: dataSharePredicates.DataSharePredicates, predicates: dataSharePredicates.DataSharePredicates,
    callback: Function): Function {
    return (error: BusinessError, resultSet: DataShareResultSet): void => {
      Log.info(TAG, `start queryResult ${resultSet.rowCount}, localVideoSize=${localVideoSize}`);
      if (resultSet.rowCount == SettingCardAccess.COUNT_ONE) {
        // 已存在AssetsInfo信息，只需要更新
        let updateBucket: ValuesBucket = { localVideoSize: `${localVideoSize}` };
        cardEntity.update(`.updateAssetsInfo`, updatePredicates, updateBucket, () => {
          Log.info(TAG, `updateAssetsInfo finished!`);
          cardEntity.queryTableContent('AssetsInfo', predicates, callback);
        });
      } else if (resultSet.rowCount == SettingCardAccess.COUNT_ZERO) {
        // 不存在cardInfo信息,需要插入
        let insertBucket: ValuesBucket = {
          localVideoSize: `${localVideoSize}`,
          localImageSize: '0 KB',
        };
        cardEntity.insert(`.insertAssetsInfo`, insertBucket, () => {
          Log.info(TAG, 'insertAssetsInfo finished!');
          cardEntity.queryTableContent('AssetsInfo', predicates, callback);
        });
      } else {
        Log.error(TAG, `saveVideoSizeToAssetsInfoDb failed ${resultSet.rowCount}`);
      }
    };
  }

  /**
   * 保存图片大小到数据库
   *
   * @param imageLocalSize 本地总图片大小
   * @param predicates predicates
   * @param callback callback
   */
  private async saveImageSizeToAssetsInfoDb(imageLocalSizeByte: number,
    predicates: dataSharePredicates.DataSharePredicates, callback: Function): Promise<void> {
    if (!callback) {
      return;
    }
    try {
      let localImageSize: string = ImageUtil.formatFileSize(imageLocalSizeByte);
      localImageSize = this.formatVideoSizeText(localImageSize);
      Log.info(TAG, `saveImageSizeToAssetsInfoDb start: localImageSize=${localImageSize}`);
      const cardEntity = new SettingCardDataShareAbility();
      let updatePredicates = new dataSharePredicates.DataSharePredicates();
      let queryCallBack: Function = (error: BusinessError, resultSet: DataShareResultSet): void => {
        Log.info(TAG, `start queryResult ${resultSet.rowCount}, localImageSize=${localImageSize}`);
        if (resultSet.rowCount == SettingCardAccess.COUNT_ONE) {
          // 已存在AssetsInfo信息，只需要更新
          let updateBucket: ValuesBucket = { localImageSize: `${localImageSize}` };
          cardEntity.update(`.updateAssetsInfo`, updatePredicates, updateBucket, () => {
            Log.info(TAG, `updateAssetsInfo finished!`);
            cardEntity.queryTableContent('AssetsInfo', predicates, callback);
            const msg: Record<string, number | string | boolean> = {
              'cleanupImagesSize': ImageUtil.formatMBSize(imageLocalSizeByte)
            };
            ReportToBigDataUtil.report(BigDataConstants.GET_IMAGE_CLEANUP_SIZE, msg);
            Log.info(TAG, `saveImageSizeToAssetsInfoDb: msg=${JSON.stringify(msg)}`);
          });
        } else if (resultSet.rowCount == SettingCardAccess.COUNT_ZERO) {
          // 不存在cardInfo信息,需要插入
          let insertBucket: ValuesBucket = {
            localVideoSize: '0 KB',
            localImageSize: `${localImageSize}`,
          };
          cardEntity.insert(`.insertAssetsInfo`, insertBucket, () => {
            Log.info(TAG, 'insertAssetsInfo finished!');
            cardEntity.queryTableContent('AssetsInfo', predicates, callback);
          });
        } else {
          Log.error(TAG, `saveImageSizeToAssetsInfoDb failed ${resultSet.rowCount}`);
        }
      }
      await cardEntity.query('.queryLocalImageSize', updatePredicates, [], queryCallBack);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      Log.error(TAG, `saveImageSizeToAssetsInfoDb error, code ${err.code}, message ${err.message}`);
    }
  }

  /**
   * 大于100 则不保留小数（四舍五入）
   *
   * @param localVideoSize
   * @returns
   */
  private formatVideoSizeText(localVideoSize: string) {
    let arr = localVideoSize.split(' ');
    let num = parseFloat(arr[0]);
    if (num > 100) {
      num = Math.round(num);
    }
    return num + ' ' + arr[1];
  }
}