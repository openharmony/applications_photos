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

import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import Want from '@ohos.app.ability.Want';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { AccountRepository } from '@ohos/privacy/src/main/ets/about/consent/AccountRepository';
import { assert } from '@ohos/tools/src/main/model/common/DataTypes';
import { Privacy, Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { PermissionPopup } from '@ohos/privacy/src/main/ets/about/consent/PermissionPopup';
import { SystemUtil } from '@ohos/common/src/main/ets/default/utils/SystemUtil';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';

/* instrument ignore file */
const TAG: string = '[AuthExtensionAbility]';
const WHITE_LIST: Set<string> =
  new Set(['com.ohos.sceneboard', 'com.ohos.camera', 'com.ohos.photos']);
const REQUEST_LOGIN_INFO: string = 'requestLoginInfo';
const REQUEST_ASSESS_TOKEN: string = 'requestAssessToken';

interface LoginInfo {
  uid: string;
  accessToken: string;
}

enum AuthErrorCode {
  SUCC = 0,
  NO_PERMISSION = 10001,
  INTERNAL_ERROR = 10002,
  REQUEST_TYPE_INVALID = 10003,
  USER_INFO_INVALID = 10004,
  REQUEST_LOGIN_TIMEOUT = 10005,
}

class AuthError extends Error {
  public readonly code?: number;
  public readonly data?: string;
  public readonly subCode?: number;

  constructor(code?: number, data?: string, subCode?: number) {
    super();
    this.code = code;
    this.data = data;
    this.subCode = subCode;
  }

  /**
   * 打印Json字串，用于返回错误
   * @returns
   */
  public toString(): string {
    return `{ "code": ${this.code ?? '\"\"'}, "data": "${this.data ?? '\"\"'}", "subCode": ${this.subCode ?? '\"\"'} }`;
  }
}

export default class AuthExtensionAbility extends UIExtensionAbility {
  private session?: UIExtensionContentSession;
  private currentLanguage: string = SystemUtil.getSystemLanguage();
  private storage: LocalStorage = new LocalStorage();
  private userInfo: PermissionPopup.UserInfo = {
    userId: '',
    accessToken: '',
  };
  private requestType: string = '';
  private contextInitialized: boolean = false;
  private timeFn: number | undefined = undefined;
  // 隐私弹窗是否要求登录
  private needLogin: boolean = true;
  // 是否已登录
  private isLogin: boolean = false;

  onCreate(): void {
    Log.info(TAG, 'onCreate');
  }

  onForeground(): void {
    Log.info(TAG, 'onForeground');
  }

  onBackground(): void {
    Log.info(TAG, 'onBackground');
  }

  onDestroy(): void {
    Log.info(TAG, 'onDestroy');
    AccountRepository.getInstance().releaseAccountContext();
  }

  // 配置更新
  onConfigurationUpdate() {
    const currentLanguage: string = SystemUtil.getSystemLanguage();
    if (currentLanguage !== this.currentLanguage) {
      this.storage?.setOrCreate('currentLanguage', currentLanguage);
      this.currentLanguage = currentLanguage;
    }
    Log.info(TAG, `onConfigurationUpdate language: ${currentLanguage}`);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    this.session = session;
    this.parseAndExecuteWant(want);
  }

  onSessionDestroy(session: UIExtensionContentSession): void {
    Log.info(TAG, 'onSessionDestroy');
  }

  private async parseAndExecuteWant(want: Want): Promise<void> {
    let wantParam: Record<string, Object> = want.parameters ?? {};
    let callerBundleName: string = assert.asString(wantParam?.['ohos.aafwk.param.callerBundleName'],
      'parse string fail') ?? '';
    if (!WHITE_LIST.has(callerBundleName)) {
      Log.error(TAG, `onSessionCreate ${callerBundleName} has no permission`);
      this.terminateError(new AuthError(AuthErrorCode.NO_PERMISSION, 'No Permission'));
      return;
    }
    let requestType: string = assert.asString(wantParam?.requestType, 'parse string fail') ?? '';
    let forceRefresh: boolean = assert.asBoolean(wantParam?.forceRefresh, 'parse boolean fail') ?? false;
    this.isLogin = assert.asBoolean(wantParam?.isLogin, 'parse boolean fail') ?? false;
    this.needLogin = assert.asBoolean(wantParam?.needLogin, 'parse boolean fail') ?? true;
    try {
      switch (requestType) {
        case REQUEST_LOGIN_INFO:
          this.handleReqLoginInfo();
          break;
        case REQUEST_ASSESS_TOKEN:
          this.handleReqAssessToken(forceRefresh);
          break;
        default:
          Log.error(TAG, `onSessionCreate failed: requestType(${requestType}) invalid`);
          this.terminateError(new AuthError(AuthErrorCode.REQUEST_TYPE_INVALID, 'RequestType Invalid'));
          break;
      }
    } catch (err) {
      Log.error(TAG, 'onSessionCreate internal error');
      this.terminateError(new AuthError(AuthErrorCode.INTERNAL_ERROR, 'Internal Error'));
    }
  }

  aiToggleStatusPublish(): void {
    let options: commonEventManager.CommonEventPublishData = {
      code: Constants.STATUS_BAR_OPEN_CODE,
      data: 'sign',
    };
    commonEventManager.publish(Constants.AI_TOGGLE_STATUS_EVENT_ID, options, (err: BusinessError) => {
      if (err) {
        Log.error(TAG, `aiToggleStatusPublish callBack err: ${JSON.stringify(err)}`);
      } else {
        Log.info(TAG, 'aiToggleStatusPublish success');
      }
    });
  }

  private handleReqLoginInfo() {
    Log.info(TAG, 'requestLoginInfo called');
    // this.requestType = REQUEST_LOGIN_INFO;
    // try {
    //   this.signInAndGetToken().then((tokenInfo: LoginInfo): void => {
    //     Log.info(TAG, 'requestLoginInfo success');
    //     this.terminateSuccess();
    //   }).catch((err: AuthError): void => {
    //     Log.error(TAG, `requestLoginInfo fail: ${err.toString()}`);
    //     this.terminateError(err);
    //   });
    // } catch (err) {
    //   Log.error(TAG, `handleReqLoginInfo fail: code: ${err?.code}, data: ${err?.data}, subCode: ${err?.subCode}`);
    //   this.terminateError(err);
    // }
  }

  private handleReqAssessToken(forceRefresh: boolean): void {
    Log.info(TAG, 'requestAssessToken called');
    this.requestType = REQUEST_ASSESS_TOKEN;
    try {
      this.getAccountInfo(forceRefresh).then((tokenInfo: LoginInfo): void => {
        Log.info(TAG, 'requestAssessToken success');
        this.terminateSuccess();
      }).catch((err: AuthError): void => {
        Log.error(TAG, `requestAssessToken fail: ${err.toString()}`);
        this.terminateError(err);
      });
    } catch (err) {
      Log.error(TAG, `handleReqAssessToken fail: code: ${err?.code}, data: ${err?.data}, subCode: ${err?.subCode}`);
      this.terminateError(err);
    }
  }

  private terminateSuccess(): void {
    Log.warn(TAG, 'terminateSuccess terminateSelfWithResult');
    this.context.terminateSelfWithResult({
      resultCode: 0,
      want: {
        parameters: {
          requestType: this.requestType,
          success: true,
        }
      }
    });
  }

  private terminateError(error: AuthError): void {
    Log.error(TAG, `terminateError terminateSelfWithResult code: ${error?.code}, data: ${error?.data}, subCode: ${
    error?.subCode}`);
    this.context.terminateSelfWithResult({
      resultCode: -1,
      want: {
        parameters: {
          errorCode: error?.code?.toString(),
          requestType: this.requestType,
          success: false,
          message: error.toString(),
        }
      }
    });
  }

  public async getLoginStatus(): Promise<boolean> {
    Log.info(TAG, 'Get login status silentSignInForProfile');
    this.loadEmptyUiContext();
    // 获取头像昵称需传如下scope
    // authRequest.scopes = ['profile'];
    // // 获取code与idToken需传如下permission
    // authRequest.permissions = ['serviceauthcode', 'idtoken'];
    // // forceAuthorization参数用来控制是否拉起授权页面
    // authRequest.forceAuthorization = false;
    // authRequest.state = 'photos_1111';

    return new Promise(async (resolve, reject) => {
      clearTimeout(this.timeFn);
      // 执行请求
      // const controller = new authentication.AuthenticationController();
      try {
        //   await controller.executeRequest(authRequest);
        //   Log.error(TAG,
        //   resolve(false);
        //   return;
        // }
        Log.info(TAG, 'Get login status return success!');
        resolve(true);
      } catch (err) {
        Log.error(TAG, 'Get login status failed to authFromApi. Cause: ' + err.message + `, code: ${err?.code}`);
        resolve(false);
      }
    });
  }

  private loadEmptyUiContext(): void {
    if (this.contextInitialized) {
      return;
    }
    this.contextInitialized = true;
    try {
      this.session?.loadContent('');
      this.session?.setWindowBackgroundColor(Constants.COLOR_TRANSPARENT);
    } catch (error) {
      Log.error(TAG, 'signInAndGetToken loadContent error');
      throw new AuthError(AuthErrorCode.INTERNAL_ERROR, 'Load Content Error');
    }
  }

  // private async signInAndGetToken(): Promise<LoginInfo> {
  //   Log.info(TAG, 'signInAndGetToken start');
  //   // 加载空的Content，否则没有UIContext，登录页面无法显示
  //   this.loadEmptyUiContext();
  //   AccountRepository.getInstance().setAccountContext(this.context);
  //   try {
  //     let token: string = (await AccountRepository.getInstance().signIn(false)).tokenString;
  //     Log.info(TAG, 'signInAndGetToken call signIn finish');
  //     let uid: string = AccountRepository.getInstance().getAccount().userId;
  //     if (uid.length > 0 && token.length > 0) {
  //       return {
  //         uid: uid, accessToken: token,
  //       };
  //     }
  //     throw new AuthError(AuthErrorCode.USER_INFO_INVALID, 'User Info Invalid');
  //   } catch (err) {
  //     Log.error(TAG, `signInAndGetToken code: ${err?.code}, data: ${err?.data}, subCode: ${err?.subCode}`);
  //     throw new AuthError(err?.code, err?.data, err?.subCode);
  //   }
  // }

  private async getAccountInfo(forceRefresh: boolean): Promise<LoginInfo> {
    Log.info(TAG, 'getAccountInfo called');
    try {
      this.session?.loadContent('');
      this.session?.setWindowBackgroundColor(Constants.COLOR_TRANSPARENT);
    } catch (error) {
      Log.error(TAG, 'getAccountInfo loadContent error');
      throw new AuthError(AuthErrorCode.INTERNAL_ERROR, 'Load Content Error');
    }
    AccountRepository.getInstance().setAccountContext(this.context);
    try {
      // await AccountRepository.getInstance().signIn(true);
      Log.info(TAG, 'getAccountInfo call signIn finish');
      let token: string = await AccountRepository.getInstance().getAccessToken(forceRefresh);
      Log.info(TAG, 'getAccountInfo call getAccessToken finish');
      let uid: string = AccountRepository.getInstance().getAccount().userId;
      if (uid.length > 0 && token.length > 0) {
        return {
          uid: uid, accessToken: token,
        };
      }
      throw new AuthError(AuthErrorCode.USER_INFO_INVALID, 'User Info Invalid');
    } catch (err) {
      Log.error(TAG, `getAccountInfo failed: code: ${err?.code}, data: ${err?.data}, subCode: ${err?.subCode}`);
      throw new AuthError(err?.code, err?.data, err?.subCode);
    }
  }

  private terminateSession(session: UIExtensionContentSession): void {
    session.terminateSelf();
    this.context.terminateSelf();
  }

  private privacyCallback: (agree: boolean, msg?: string) => void = (agree: boolean, msg?: string): void => {
    Log.info(TAG, `privacyCallback called agree: ${agree}`);
    this.context.terminateSelfWithResult({
      resultCode: 0,
      want: {
        parameters: {
          requestType: this.requestType,
          success: agree,
          message: msg ?? '',
        }
      }
    });

    if (!agree) {
      PermissionPopup.updateIsAgreeState(getContext(this), false);
    }
    // 获取AI编创隐私协议最新签署状态
    if (this.userInfo?.userId) {
      PermissionPopup.queryAgreementRecordCloud(getContext(this), this.userInfo, Privacy.AI_RETOUCH_PRIVACY_PROTOCOL);
    }
  }
  private signCallback: (agree: boolean) => Promise<boolean> = async (agree: boolean): Promise<boolean> => {
    Log.info(TAG, `privacyCallback called agree: ${agree}, needLogin: ${this.needLogin}`);
    // 1、已登录，2、不要求登录，已登录
    if (this.needLogin || (!this.needLogin && this.isLogin)) {
      Log.info(TAG, `sign agreement, is login`);
      let res: boolean = false;
      if (agree) {
        // 提前通知签署结果，查询登录信息合签署协议耗时较长，不阻塞用户使用，降低等待时延
        this.session?.sendData({ 'onAgreeResult': true });
        Protocol.set(Constants.AI_CREATION_TOGGLE_STATUS, true);
        this.aiToggleStatusPublish();
        let loginInfo: LoginInfo = await this.getAccountInfo(false);
        this.userInfo.userId = loginInfo.uid;
        this.userInfo.accessToken = loginInfo.accessToken;
        res = await this.sign(Privacy.AI_RETOUCH_PRIVACY_PROTOCOL);
        Log.info(TAG, `account sign result: ${res}`);
      }
      return res;
    } else { // 未登录，游客模式
      Log.info(TAG, `sign agreement, no need login`);
      let res: boolean = false;
      if (agree) {
        this.session?.sendData({ 'onAgreeResult': true });
        Protocol.set(Constants.AI_CREATION_TOGGLE_STATUS, true);
        this.aiToggleStatusPublish();
        res = await this.signVisitor(Privacy.AI_RETOUCH_PRIVACY_PROTOCOL);
        Log.info(TAG, `signVisitor result: ${res}`);
      }
      return res;
    }
  }

  private async queryVisitorAgreementRecord(protocol: number): Promise<boolean> {
    let res: boolean = await PermissionPopup.queryVisitorAgreementRecords(this.context, protocol);
    Log.info(TAG, `queryVisitorAgreementRecord res: ${res}`)
    return res;
  }

  private async signVisitor(protocol: number): Promise<boolean> {
    const res: boolean = await PermissionPopup.signVisitorAgreementRecord(this.context, protocol, true);
    return res;
  }

  private async queryAgreementRecord(protocol: number): Promise<boolean> {
    let res: boolean = await PermissionPopup.queryAgreementRecord(this.context, this.userInfo, protocol);
    Log.info(TAG, `queryAgreementRecord res: ${res}`)
    return res;
  }

  private async sign(protocol: number): Promise<boolean> {
    const res: boolean =
      await PermissionPopup.signAgreementRecord(this.context, this.userInfo, protocol);
    return res;
  }

  private async initPaf(protocol: number): Promise<void> {
    if (this.session === undefined) {
      Log.error(TAG, 'initPaf failed, session undefined');
      return;
    }
    const ns = await import('@ohos/privacy/src/main/ets/about/consent/PermissionPopup');
    await ns.PermissionPopup.initExt(this.session, this.context, protocol);
  }
}