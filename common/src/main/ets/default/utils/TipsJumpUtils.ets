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
import lazy common from '@ohos.app.ability.common';
import lazy bundleManager from '@ohos.bundle.bundleManager';
import lazy hilog from '@ohos.hilog';
import lazy Want from '@ohos.app.ability.Want';
import lazy { BusinessError } from '@ohos.base';
import lazy util from '@ohos.util';
import lazy { Constants } from '../model/common/Constants';

/* instrument ignore file */
const DOMAIN_ID: number = 0x3F3F;
const TAG: string = 'common_NewPhotosJumpTips';
const MODULE_NAME_PHONE: string = 'phone_widget';
const MODULE_NAME_PC: string = 'pc_widget';
const CODE_BUNDLE_NAME_NOT_FOUND: number = 17700001;
const CODE_SUCCESS_ERROR: number = 0;
const FUN_NUM_HOME: string = 'SF-10044789_f6501';

type startAbleContext = common.UIAbilityContext | common.ServiceExtensionContext;

export class TipsJumpUtils {
  /**
   * 跳转到玩机技巧首页
   *
   * @param startAbleContext 上下文,类型要求：common.UIAbilityContext |
   common.ServiceExtensionContext
   * @param type 入口类型ID，用于打点
   * @param moduleName phone_widget:跳转手机，pc_widget：跳转PC
   */
  public static jumpHome(context: startAbleContext, type: string, moduleName: string = MODULE_NAME_PHONE) {
    TipsJumpUtils.jumpTips(context, FUN_NUM_HOME, type, moduleName ?? MODULE_NAME_PHONE);
  }

  /**
   * 跳转到玩机技巧指定页面
   *
   * @param startAbleContext 上下文,类型要求：common.UIAbilityContext |
   common.ServiceExtensionContext
   * @param funNum:页面FunNum
   * @param type 入口类型ID，用于打点
   * @param moduleName phone_widget:跳转手机，pc_widget：跳转PC
   */
  public static jumpTips(context: startAbleContext, funNum: string, type: string,
    moduleName: string = MODULE_NAME_PHONE) {
    let uri = util.format(Constants.TIPS_URI_FORMATTER, funNum, type);
    TipsJumpUtils.jumpTipsByUri(context, uri, moduleName ?? MODULE_NAME_PHONE);
  }

  public static jumpTipsHighlight(context: startAbleContext) {
    TipsJumpUtils.jumpTipsByUri(context, Constants.TIPS_HIGHLIGHT_URI);
  }

  public static jumpTipsMovingPhoto(context: startAbleContext) {
    TipsJumpUtils.jumpTipsByUri(context, Constants.TIPS_MOVING_PHOTO_URI);
  }

  /**
   * 跳转到玩机技巧指定页面，使用uri方式
   *
   * @param startAbleContext 上下文,类型要求：common.UIAbilityContext |
   common.ServiceExtensionContext
   * @param uri uri格式：hwtips://com.ohos.tips.app?funNum=xxx&type=xxx
   * @param moduleName phone_widget:跳转手机，pc_widget：跳转PC
   */
  public static jumpTipsByUri(context: startAbleContext, uri: string, moduleName: string = MODULE_NAME_PHONE) {
    if (moduleName !== MODULE_NAME_PHONE && moduleName !== MODULE_NAME_PC) {
      hilog.error(DOMAIN_ID, TAG, `unknown moduleName, supported value:"${MODULE_NAME_PHONE}" or "${MODULE_NAME_PC}"`);
      return;
    }
    TipsJumpUtils.isAppInstalled().then((isAppInstalled: boolean) => {
      if (isAppInstalled) {
        TipsJumpUtils.jumpAppByUri(context, uri);
      } else {
        TipsJumpUtils.jumpAppGallery(context);
      }
    })
  }

  /**
   * 跳转到应用的指定页面，使用uri方式
   */
  private static jumpAppByUri(context: startAbleContext, uri: string) {
    hilog.info(DOMAIN_ID, TAG, 'try jump to app');
    let want: Want = {
      bundleName: Constants.TIPS_APP_BUNDLE_NAME,
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri
    };
    context.startAbility(want, (err: BusinessError) => {
      if (err.code !== CODE_SUCCESS_ERROR) {
        hilog.warn(DOMAIN_ID, TAG, 'jump to [tips app] failed, error : %{private}s', JSON.stringify(err));
      } else {
        hilog.info(DOMAIN_ID, TAG, 'jump to [tips app] success');
      }
    });
  }

  /**
   * 跳转到应用市场页面，使用uri方式
   */
  private static jumpAppGallery(context: startAbleContext) {
    hilog.info(DOMAIN_ID, TAG, 'try jump to AppGallery');
    const want: Want = {
      bundleName: Constants.TIPS_MODULE_NAME_APPGALLERY,
      uri: Constants.TIPS_URI_APPGALLERY,
    };
    context.startAbility(want).then(() => {
      hilog.info(DOMAIN_ID, TAG, 'jump appgallery success');
    }).catch(() => {
      hilog.warn(DOMAIN_ID, TAG, 'jump appgallery error');
    })
  }

  private static isAppInstalled(): Promise<boolean> {
    return bundleManager.getBundleInfo(Constants.TIPS_APP_BUNDLE_NAME,
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO).then((info) => {
      if (Constants.TIPS_APP_ID === info.signatureInfo.appId) {
        hilog.info(DOMAIN_ID, TAG, 'tips app is installed');
        return true;
      } else {
        hilog.warn(DOMAIN_ID, TAG, 'tips app is forged');
        return false;
      }
    }).catch((err: BusinessError) => {
      if (err.code === CODE_BUNDLE_NAME_NOT_FOUND) {
        hilog.info(DOMAIN_ID, TAG, 'tips app is not installed');
      } else {
        hilog.info(DOMAIN_ID, TAG, 'failed to check if tips app is installed, err: %{private}s', JSON.stringify(err));
      }
      return false;
    })
  }
}