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

import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy window from '@ohos.window';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { common, UIExtensionContentSession } from '@kit.AbilityKit';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { uiExtensionHost } from '@kit.ArkUI';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy Bundles from '@ohos/tools/src/main/utils/Bundle';
import lazy { Privacy, Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import lazy { AccountRepository } from './AccountRepository';
import settings from '@ohos.settings';

/* instrument ignore file */
const TAG: string = 'PermissionPopup';
const CLIENT_NAME: string = 'photos';

/**
 * 欢迎页总体逻辑：
 *
 * 1） 首次必弹（先判断本地缓存的变量，不满足条件直接谈欢迎页）
 *
 * 2） 访客：继承前一个账号的同意记录。
 *
 * 3） 登录账号后，非首次：先同步检查本地签署记录，本地记录未签署，则弹欢迎页；
 * 若本地记录已签署的话会进入图库，然后异步查云端*，若云端记录不满足条件，则弹欢迎页
 * ** paf 6 版本之后, 弹欢迎页不再查云端记录 **
 */
export namespace PermissionPopup {
  export interface AgreeRecord {
    time: Date,
    agreed: boolean,
    privacyStatementVer: string,
    appVer: string,
  }

  // const queryRecordsCallBack = new AgreementConfig.QueryCallback();
  // let client: Agreement | undefined;

  //14.16.10-305升级到14.17.4-300 新版继承上一个版本的记录  需应用自己做割接
  export async function cutOverRecords(ctx: common.UIAbilityContext = global.uiAbilityContext()) {
    // let agreed = Protocol.get<boolean>('PERMISSION_AGREED', false);
    // let hasNotCutOver = await DataStoreUtil.getInstance().getData(Constants.HAS_CUT_OVER_KEY, false);
    // Log.info(TAG, `agreed: ${agreed}, hasNotCutOver: ${hasNotCutOver}`);
    // if (!agreed || hasNotCutOver) {
    //   return;
    // }
    // // 无论是否成功割接，就认为已割接，并保存到本地
    // DataStoreUtil.getInstance().putData(Constants.HAS_CUT_OVER_KEY, true);
    // // 写入客户端信息
    // let deviceType: ClientDeviceType = ClientDeviceType._2in1_;
    // if (DeviceInfo.isPhoneUx()) {
    //   deviceType = ClientDeviceType.PHONE;
    // } else if (DeviceInfo.isPcOrTablet()) {
    //   deviceType = ClientDeviceType.PAD;
    // }
    // let clientInfo = new consent.ClientInfo();
    // clientInfo.name = CLIENT_NAME;
    // clientInfo.version = Bundles.getInfo().versionName;
    // clientInfo.aaid = AAID.getAAID;
    // clientInfo.deviceId = DeviceInfo.getODID;
    // clientInfo.deviceIdType = 1;
    // clientInfo.deviceType = deviceType;
    // let grsClient = new consentGrsSys.ConsentGrsSysClient(ctx);
    // let extendOption = new consent.ExtendOption();
    // extendOption.grsClient = grsClient;
    // // 生成客户端实例
    // let client: Agreement = new consent.Agreement(ctx, clientInfo, extendOption);
    // // 调用游客签署记录
    // // 此处为业务逻辑流程ID, 建议传入业务调用接口的transId，便于后续问题定位和分析
    // let transId =
    //   (DeviceInfo.isPc() ? Privacy.PRIVACY_PROTOCOL_PC : Privacy.PRIVACY_PROTOCOL).toString() + new Date().getTime();
    // let request: consent.SignVstRequest = new consent.SignVstRequest(transId);
    // request.country = 'CN';
    // // 割接场景，如果业务之前自实现游客模式，现升级consentSDK版本，需要将游客本地同意记录割接给ConsentSDK，
    // // 必须采用：只保存不联网方式, 使签署记录快速保存到本地，否则会阻塞用户使用。
    // request.accessNetwork = false;
    // let s1 = new consent.SignVstSingleRequest();
    // s1.agrType = (DeviceInfo.isPc() ? Privacy.PRIVACY_PROTOCOL_PC : Privacy.PRIVACY_PROTOCOL);
    // let s2 = new consent.SignVstSingleRequest();
    // let s3 = new consent.SignVstSingleRequest();
    // s3.agrType = Privacy.CLOUD_ENHANCE_PRIVACY_PROTOCOL;
    // request.requests.push(s1, s2, s3);
    // try {
    //   // 此处仅保存同意记录且不联网查询协议版本号（request.accessNetwork=false）时，可以采用同步等待方式保存游客同意本地记录
    //   let response: consent.SignVstResponse = await client.signVst(request);
    // } catch (e) {
    //   // 发生异常打印错误信息即可，此处万不能直接退出APP，不管是否保存成功，都放用户往下走，最差情况也就是重新弹框。
    //   // 但如退出就可能算做现网故障
    //   Log.info(TAG, `respone error:${JSON.stringify(e)}`)
    // }
  }

  /**
   * 业务自己适配的接口初始化paf
   * @param windowStage
   * @param ctx
   * @param win
   * @returns
   */
  export async function init(windowStage: window.WindowStage = global.windowStage(), ctx:
    common.UIAbilityContext = global.uiAbilityContext()): Promise<void> {
    // Paf UiWidget 初始化
    Log.info(TAG, 'begin to init paf......');
    TraceControllerUtils.startTrace('PermissionPopup_start');
        // ns.PafEngine.init(windowStage, ctx, {
    //   config: {
    //     region: Region.CN
    //   }
    // });
    if (!ctx) {
      Log.fatal(TAG, 'get photosAbilityContext failed');
      TraceControllerUtils.finishTrace('PermissionPopup_start');
      return;
    }
    TraceControllerUtils.finishTrace('PermissionPopup_start');
    await cutOverRecords(ctx);
    await initPafAsync(ctx);
  }

  /**
   * ExtensionAbility适配的接口初始化paf
   * @param session
   * @param ctx
   * @returns
   */
  export async function initExt(
    session: UIExtensionContentSession,
    ctx: common.UIExtensionContext,
    protocol: number,
  ): Promise<void> {
    // Paf UiWidget 初始化
    Log.warn(TAG, 'initExt start');
        // let windowProxy: uiExtensionHost.UIExtensionHostWindowProxy = session.getUIExtensionHostWindowProxy();
    // ns.PafEngine.initForUIExtension(session, ctx, {
    //   config: {
    //     region: Region.CN
    //   }
    // });

    // Grs初始化
    await initPafCustomAsync(ctx, protocol);
  }

  /**
   * 开关，控制协议签署方式
   * @param ctx
   * @param win
   * @returns
   */
  export async function initPafCustomAsync(ctx: Context, protocol: number): Promise<void> {
    Log.warn(TAG, 'initPafCustomAsync start');
    // const clientInfoIn: PafClientInfo = await AgreementConfig.clientInfo();
    // clientInfoIn.extendOption.grsClient = getGrsClient(ctx);
    // let userAccount: PafUserAccount = {
    //   userAccountParam: {
    //     country: 'CN',
    //     region: 'CN',
    //     userId: '',
    //   }
    // }
    // await PafAgreement.initAndQuery(ctx, clientInfoIn, userAccount,
    //   AgreementConfig.getCustomAgreementTypes(protocol), getAgreementCallback());
    Log.warn(TAG, 'PermissionPopup_initAsync');
  }

  export interface UserInfo {
    userId: string,
    accessToken: string,
  }

  // export async function getClient(ctx: Context): Promise<Agreement> {
  //   if (!client) {
  //     // Grs初始化
  //     await GrsFileUtil.copyGrsConfigFile(ctx, false);
  //     const clientInfoIn: consent.ClientInfo = await AgreementConfig.getClientInfo();
  //     let extendOption: ExtendOption = new consent.ExtendOption();
  //     let grsClient: consentGrsSys.ConsentGrsSysClient = new consentGrsSys.ConsentGrsSysClient(ctx);
  //     let sdkConfig: consent.SDKConfig = new consent.SDKConfig();
  //     let httpClientOption: consent.HttpClientOption = new consent.HttpClientOption();
  //     sdkConfig.httpClientOption = httpClientOption;
  //     sdkConfig.httpClientOption.setConnectTimeout(5000);
  //     sdkConfig.httpClientOption.setReadTimeout(5000);
  //     sdkConfig.httpClientOption.setCallTimeout(5000);
  //     extendOption.grsClient = grsClient;
  //     extendOption.sdkConfig = sdkConfig;
  //     client = new consent.Agreement(ctx, clientInfoIn, extendOption);
  //   }
  //   return client;
  // }

  /**
   * 获取游客模式客户端实例
   */
  // export async function getVisitorClient(context: common.Context = global.uiAbilityContext()): Promise<Agreement> {
    // 写入客户端信息
    // let deviceType: ClientDeviceType = ClientDeviceType._2in1_;
    // if (DeviceInfo.isPhone()) {
    //   deviceType = ClientDeviceType.PHONE;
    // } else if (DeviceInfo.isPcOrTablet()) {
    //   deviceType = ClientDeviceType.PAD;
    // }
    // let clientInfo = new consent.ClientInfo();
    // clientInfo.name = CLIENT_NAME;
    // clientInfo.version = Bundles.getInfo().versionName;
    // clientInfo.aaid = AAID.getAAID;
    // clientInfo.deviceId = DeviceInfo.getODID;
    // clientInfo.deviceIdType = 1;
    // clientInfo.deviceType = deviceType;
    // let grsClient = new consentGrsSys.ConsentGrsSysClient(context);
    // let extendOption = new consent.ExtendOption();
    // extendOption.grsClient = grsClient;
    // // 生成客户端实例
    // let client = new consent.Agreement(context, clientInfo, extendOption);
    // return client;
  // }

  /**
   * GRS国家码获取接口
   * 查询优先级：1 > 2 > 3 > 4 > 5 > 6
   * 1.查询设备发货地码（只有CN使用，其它地区码舍弃）
   * 2.查询sim卡1
   * 3.查询sim卡2
   * 4.查询系统语言地区码1
   * 5.查询系统语言地区码2
   * 6.指定CN
   */
  export async function queryGuestCountryByGrs(): Promise<string> {
    let countryCode: string = '';
    // try {
    //   countryCode = await grs.getIssueCountryCode();
    //   Log.debug(TAG, `queryGuestCountryByGrs success, issueCountryCode = ${countryCode}`);
    // } catch (err) {
    //   Log.error(TAG, 'queryGuestCountryByGrs failed. Cause: ' + err.message + `, code: ${err?.code}`);
    // }
    return countryCode;
  }

  /**
   * 查询游客模式隐私协议签署结果
   */
  export async function queryVisitorAgreementRecords(context: Context, protocol: number,
    needReshow: boolean = false): Promise<boolean> {
    // Log.info(TAG, 'queryVisitorAgreementRecords start');
    // let result: boolean = false;
    // const isFirstUseAICreation = getIsFirstUseAICreation(context);
    // if (isFirstUseAICreation === 'true') {
    //   return false;
    // }
    // try {
    //   let transId: string = protocol.toString() + new Date().getTime();
    //   let request: consent.QueryVstRecordsRequest = new consent.QueryVstRecordsRequest(transId);
    //   let country: string = await queryGuestCountryByGrs();
    //   request.country = country;
    //   request.accessNetwork = true; // 将根据协议ID获取协议版本号
    //   let reqLocal: consent.QueryRecordsSingleRequest = new consent.QueryRecordsSingleRequest(protocol);
    //   request.requests.push(reqLocal);
    //
    //   // 定义重签回调
    //   let resignNotice: consent.ResignNotice = async (needResign, notFounds) => {
    //     // 协议/隐私声明发生了重大更新，需重弹隐私协议弹窗
    //     if (needResign.size() !== 0) {
    //       Log.warn(TAG, 'queryVisitorAgreementRecords needResign size > 0 , need resign.');
    //     }
    //     // 隐私协议签署无效, 需重弹隐私协议弹窗
    //     if (notFounds.size() !== 0) {
    //       Log.warn(TAG, 'queryVisitorAgreementRecords notFounds size > 0 , need resign.');
    //     }
    //   };
    //   request.resignNotice = resignNotice;
    //
    //   let client: Agreement = await getVisitorClient(context);
    //   let response: consent.QueryVstRecordsResponse = await client.queryVstRecords(request);
    //   if (response.isSuccess() && response.agreed.size() !== 0) {
    //     Log.info(TAG, 'queryVisitorAgreementRecords success. agreement has signed.');
    //     result = true;
    //   }
    // } catch (exception) {
    //   Log.info(TAG, `queryVisitorAgreementRecords err: ${JSON.stringify(exception)}`);
    // }
    // // 已同意后有隐私协议变更，更新isAgree标志位
    // if (needReshow) {
    //   if (!result) {
    //     updateIsAgreeState(context, false);
    //   }
    //   return result;
    // }
    // // 未签署隐私协议
    // if (!result) {
    //   updateIsAgreeState(context, false);
    //   return result;
    // }
    // // 隐私协议已签署，以AI编创开关状态为准(游客模式consentSDK无撤销接口，已签署状态不能作为依据)
    // let isToggleOpen: boolean = await Protocol.getIsAgreedState(context);
    // result = isToggleOpen;
    // updateIsAgreeState(context, result);
    // return result;
    return false
  }

  /**
   * 签署游客模式隐私协议
   * @param ctx 应用上下文
   * @param protocol 协议号
   * @param needUpdateResult 是否需要更新标志位
   */
  export async function signVisitorAgreementRecord(ctx: Context, protocol: number,
    needUpdateResult: boolean): Promise<boolean> {
    // Log.info(TAG, `signVisitorAgreementRecord start, protocol: ${protocol}`);
    // handleIsFirstUseAICreation(ctx);
    // let res: boolean = false;
    // try {
    //   let client: Agreement = await getVisitorClient(ctx);
    //   let transId: string = protocol.toString() + new Date().getTime();
    //   let request: consent.SignVstRequest = new consent.SignVstRequest(transId);
    //   let country: string = await queryGuestCountryByGrs();
    //   request.country = country;
    //   request.accessNetwork = true; // 将根据协议ID获取协议版本号
    //   let consentRequest: consent.SignVstSingleRequest = new consent.SignVstSingleRequest();
    //   consentRequest.agrType = protocol;
    //   request.requests.push(consentRequest);
    //   let response: consent.SignResponse = await client.signVst(request);
    //   Log.info(TAG, `signVisitorAgreementRecord response isSuccess: ${response.isSuccess()}`);
    //   if (response.isSuccess()) {
    //     res = true;
    //     if (needUpdateResult) {
    //       updateIsAgreeState(ctx, true);
    //     }
    //   }
    // } catch (e) {
    //   Log.info(TAG, `signVisitorAgreementRecord err: ${JSON.stringify(e)}`);
    // }
    // Log.info(TAG, 'signVisitorAgreementRecord end');
    // return res;
    return false
  }

  /**
   * 撤销游客模式对某协议的签署，SDK暂无此接口
   */
  export async function revokeVisitorAgreementRecord(ctx: Context, protocol: number): Promise<boolean> {
    Log.info(TAG, 'revokeVisitorAgreementRecord start');
    let res: boolean = false;
    // try {
    //   let transId: string = protocol.toString();
    //   let request: consent.RevokeRequest = new consent.RevokeRequest(transId);
    //   let country: string = await queryGuestCountryByGrs();
    //   request.country = country;
    //   let req: consent.RevokeSingleRequest = new consent.RevokeSingleRequest();
    //   req.agrType = protocol;
    //   request.requests.push(req);
    //   let client: Agreement = await getVisitorClient(ctx);
    //   let response: RevokeResponse = await client.revoke(request);
    //   if (response.isSuccess()) {
    //     res = true;
    //   }
    //   Log.info(TAG, `revokeVisitorAgreementRecord response, isSuccess: ${response.isSuccess()}`);
    // } catch (e) {
    //   Log.info(TAG, `revokeVisitorAgreementRecord err: ${JSON.stringify(e)}`);
    // }
    // updateIsAgreeState(ctx, false);
    return res;
  }

  /**
   * 更新是否同意隐私声明标志位
   */
  export function updateIsAgreeState(context: Context, isAgree: boolean) {
    try {
      settings.setValueSync(context, Constants.APP_STORAGE_KEY_IS_AGREE, isAgree ? 'true' : 'false');
      Log.info(TAG, `updateIsAgreeState isAgreeValue: ${isAgree}`);
    } catch (e) {
      Log.error(TAG, `updateIsAgreeState err: ${e?.code}`);
    }
  }
  /**
   * 签署协议
   * @param ctx 应用上下文
   * @param userInfo 账号信息
   * @param protocol 协议号
   * @returns 是否签署成功
   */
  export async function signAgreementRecord(ctx: Context, userInfo: UserInfo, protocol: number): Promise<boolean> {
    // Log.info(TAG, `signAgreementRecord start, protocol: ${protocol}`);
    // handleIsFirstUseAICreation(ctx);
    // let res: boolean = false;
    // try {
    //   let client: Agreement = await getClient(ctx);
    //   let request: consent.SignRequest = new consent.SignRequest(protocol.toString());
    //   request.userId = userInfo.userId;
    //   request.accessToken = userInfo.accessToken;
    //   request.country = 'cn';
    //   let consentRequest: consent.SignSingleRequest = new consent.SignSingleRequest();
    //   consentRequest.agrType = protocol;
    //   request.requests.push(consentRequest);
    //   let response: consent.SignResponse = await client.sign(request);
    //   Log.info(TAG, `signAgreementRecord RESPONSE isSuccess: ${response.isSuccess()}`);
    //   if (response.isSuccess()) {
    //     res = true;
    //     updateIsAgreeState(ctx, true);
    //   }
    // } catch (e) {
    //   Log.error(TAG, `signAgreementRecord err: ${JSON.stringify(e)}`);
    // }
    // Log.info(TAG, 'signAgreementRecord end');
    // // 账号模式隐私协议签署状态无法继承给游客模式(consentSDK机制问题)，顾账号模式需同步签署游客模式隐私协议
    // await signVisitorAgreementRecord(ctx, protocol, false);
    // return res;
    return false
  }

  /**
   * 获取是否首次使用AI编创隐私协议状态
   * @param ctx 应用上下文
   */
  function getIsFirstUseAICreation(context: Context) {
    Log.info(TAG, `getIsFirstUseAICreation context: ${context}`);
    try {
      const isFirstUseAICreation =
        settings.getValueSync(context, Constants.APP_STORAGE_KEY_IS_FIRST_USE_AI_CREATION, 'true');
      Log.info(TAG, `getIsFirstUseAICreation isFirstUseAICreation: ${isFirstUseAICreation}`);
      return isFirstUseAICreation;
    } catch (e) {
      Log.error(TAG, `handleIsFirstUseAICreation err: ${e?.code}`);
      return 'false';
    }
  }

  /**
   * 获取签署结果
   * @param ctx
   * @param userInfo
   * @param protocol
   * @returns 是否签署过该协议
   */
  export async function queryAgreementRecord(ctx: Context, userInfo: UserInfo, protocol: number): Promise<boolean> {
    // Log.info(TAG, 'queryAgreementRecord start');
    // let res: boolean = false;
    // if (!userInfo?.userId) {
    //   Log.error(TAG, 'queryAgreementRecord userId is null!');
    //   return false;
    // }
    // const isFirstUseAICreation = getIsFirstUseAICreation(ctx);
    // if (isFirstUseAICreation === 'true') {
    //   return false;
    // }
    // try {
    //   let client: Agreement = await getClient(ctx);
    //   let transId = protocol.toString() + new Date().getTime();
    //   let requestLocal: consent.QueryLocalRecordsRequest = new consent.QueryLocalRecordsRequest(transId);
    //   requestLocal.transId = transId;
    //   requestLocal.country = 'cn';
    //   requestLocal.userId = userInfo.userId;
    //   requestLocal.accessNetwork = true;
    //   let reqLocal: consent.QueryLocalRecordsSingleRequest = new consent.QueryLocalRecordsSingleRequest();
    //   reqLocal.agrType = protocol;
    //   requestLocal.requests.push(reqLocal);
    //   let responseLocal: consent.QueryLocalRecordsResponse = await client.queryLocalRecords(requestLocal);
    //   Log.info(TAG, `queryAgreementRecord RESPONSE, agreed number: ${responseLocal.agreed.size()}`);
    //   if (responseLocal.agreed.size()) {
    //     res = true;
    //   }
    // } catch (e) {
    //   Log.error(TAG, `queryAgreementRecord err: ${JSON.stringify(e)}`);
    // }
    // return res;
    return false
  }

  /**
   * 获取云侧签署结果
   * @param ctx
   * @param userInfo
   * @param protocol
   * @returns 是否签署过该协议
   */
  export async function queryAgreementRecordCloud(ctx: Context, userInfo: UserInfo, protocol: number): Promise<void> {
    // Log.info(TAG, 'queryAgreementRecordCloud start');
    // let res: boolean = false;
    // if (!userInfo?.userId) {
    //   Log.error(TAG, 'queryAgreementRecordCloud userId is null!');
    //   return;
    // }
    // try {
    //   let client: Agreement = await getClient(ctx);
    //   let transId = protocol.toString() + new Date().getTime();
    //   let request: consent.QueryRecordsRequest = new consent.QueryRecordsRequest(transId);
    //   request.userId = userInfo.userId;
    //   request.accessToken = userInfo.accessToken;
    //   request.country = 'cn';
    //   let req: consent.QueryRecordsSingleRequest = new consent.QueryRecordsSingleRequest(protocol);
    //   request.requests.push(req);
    //   let response: consent.QueryRecordsResponse = await client.queryRecords(request);
    //   if (response.noUpdated.size() + response.updatedButNoNeedResign.size() === 1) {
    //     res = true;
    //   }
    //   Log.info(TAG, `queryAgreementRecordCloud RESPONSE, noUpdated number: ${response.noUpdated.size()
    //   }, updatedButNoNeedResign number: ${response.updatedButNoNeedResign.size()}`);
    // } catch (e) {
    //   Log.error(TAG, `queryAgreementRecordCloud err: ${e?.code}`);
    // }
    // const isFirstUseAICreation = getIsFirstUseAICreation(ctx);
    // if (isFirstUseAICreation === 'false') {
    //   updateIsAgreeState(ctx, res);
    // }
  }

  export async function queryCloudAgreements(ctx: Context): Promise<void> {
    Log.info(TAG, 'queryCloudAgreements start');
    let token: string = await AccountRepository.getInstance().getAccessToken(false);
    let userId: string = AccountRepository.getInstance().getAccount().userId;
    let userInfo: UserInfo = { userId: '', accessToken: '' };
    userInfo.accessToken = token;
    userInfo.userId = userId;
    if (!userInfo.userId) {
      queryVisitorAgreementRecords(ctx, Privacy.AI_RETOUCH_PRIVACY_PROTOCOL, true);
    } else {
      queryAgreementRecordCloud(ctx, userInfo, Privacy.AI_RETOUCH_PRIVACY_PROTOCOL);
    }
  }

  /**
   * 撤销对某协议的签署
   * @param ctx
   * @param userInfo
   * @param protocol
   * @returns 是否撤销成功
   */
  export async function revokeAgreementRecord(ctx: Context, userInfo: UserInfo, protocol: number): Promise<boolean> {
    Log.info(TAG, 'revokeAgreementRecord start');
    let res: boolean = false;
    // try {
    //   let transId: string = protocol.toString();
    //   let request: consent.RevokeRequest = new consent.RevokeRequest(transId);
    //   request.userId = userInfo.userId;
    //   request.accessToken = userInfo.accessToken;
    //   request.country = 'cn';
    //   let req: consent.RevokeSingleRequest = new consent.RevokeSingleRequest();
    //   req.agrType = protocol;
    //   request.requests.push(req);
      // let client: Agreement = await getClient(ctx);
      //   let response: RevokeResponse = await client.revoke(request);
      //   if (response.isSuccess()) {
      //     res = true;
      //     updateIsAgreeState(ctx, false);
      //   }
      //   Log.info(TAG, `revokeAgreementRecord RESPONSE, isSuccess: ${response.isSuccess()}`);
      // } catch (e) {
      //   Log.info(TAG, `revokeAgreementRecord err: ${JSON.stringify(e)}`);
    // }
    return res;
  }

  /**
   * 开关，控制协议签署方式
   * @param ctx
   * @param win
   * @returns
   */
  export async function initPafAsync(ctx: Context): Promise<void> {
    // Log.warn(TAG, 'isPopup start');
    // TraceControllerUtils.startTrace('PermissionPopup_client');
    // const clientInfoIn: PafClientInfo = await AgreementConfig.clientInfo();
    // clientInfoIn.extendOption.grsClient = getGrsClient(ctx);
    // TraceControllerUtils.finishTrace('PermissionPopup_client');
    // Log.warn(TAG, 'PermissionPopup_client');
    //
    // TraceControllerUtils.startTrace('PermissionPopup_initAsync');
    // let userAccount: PafUserAccount = {
    //   userAccountParam: {
    //     country: 'CN',
    //     region: 'CN',
    //     userId: '',
    //   }
    // }
    // await PafAgreement.initAndQuery(ctx, clientInfoIn, userAccount,
    //   AgreementConfig.getAgreementTypes(), getAgreementCallback());
    // TraceControllerUtils.finishTrace('PermissionPopup_initAsync');
    // Log.warn(TAG, 'PermissionPopup_initAsync');
    // }

    // function getAgreementCallback(): PafCallBack {
    //   return {
    //     signCallBack: new AgreementConfig.SignCallback(),
    //     revokeCallBack: new AgreementConfig.RevokeCallback(),
    //     queryCallBack: queryRecordsCallBack,
    //   }
    // }
  }

  /**
   * true-使用 Grs下沉ROM能力
   * @param context
   * @returns
   */
  // function getGrsClient(context: common.Context = global.uiAbilityContext()): consent.IGrsDomainService {
  //   let grsClient: consentGrsSys.ConsentGrsSysClient = new consentGrsSys.ConsentGrsSysClient(context);
  //   return grsClient;
  // }
}