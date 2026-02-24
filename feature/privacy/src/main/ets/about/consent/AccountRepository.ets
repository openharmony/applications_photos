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
import lazy AccountInfo from './AccountInfo';
import type common from '@ohos.app.ability.common';
import lazy emitter from '@ohos.events.emitter';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy Bundles from '@ohos/tools/src/main/utils/Bundle';

/* instrument ignore file */
const TAG = 'AccountRepository';

interface StartAccountError {
  code: number;
  message: string;
}

// class MyTokenListener implements OnTokenListener {
  // private onChangedCallback: (tokenSnapshot: TokenSnapshot) => void;
  //
  // constructor(callback: (tokenSnapshot: TokenSnapshot) => void) {
  //   this.onChangedCallback = callback;
  // }
  //
  // onChanged(tokenSnapshot: TokenSnapshot): void {
  //   this.onChangedCallback(tokenSnapshot);
  // }
// }

/**
 * 账号仓储库
 */
export class AccountRepository {
  private static accountRepository?: AccountRepository;
  // private tokenProvider: ITokenProvider = auth.create<ITokenProvider>(TYPES.iTokenProvider);
  // private authProvider: IAuthProvider = auth.create<IAuthProvider>(TYPES.iAuthProvider);
  /**
   * 登录上下文
   */
  private accountContext?: common.Context;
  /**
   * 用户账号信息
   */
  private accountInfo: AccountInfo = new AccountInfo();
  /**
   * 用户登录的状态
   * true：代表已登录
   * false：代表未登录
   * 通过scripts/replace_config/mirror/nologin/replace-config.json5可以在打包时替换跳过登陆，如需修改请同步更新该文件
   */
  private isLogin: boolean = DeviceInfo.isPc() ? true : false;
  private isInit: boolean = false;
  // private onChangedCallback = (tokenSnapshot: TokenSnapshot): void => {
  //   const state = tokenSnapshot?.state;
  //   const context = this.getCurrentContext();
  //   Log.info(TAG, 'token changed, state is %s', TokenState[state]);
  //   if (state === TokenState.SIGNED_IN) {
  //     // 触发场景。a，应用冷启动，账号已登录；b，应用热启动，后台由登出状态变为登录状态。任何时候登录成功都会触发该回调，所以由这里来发送登录成功事件。
  //     // 在sign方法里面登录不发送登录事件，避免重复发送事件导致事件接收方处理异常
  //     this.authProvider.getCurrentUser(context).then((user: User): void => {
  //       this.accountInfo.serviceCountryCode = user.getServiceCountryCode();
  //       this.accountInfo.userId = user.getUid();
  //       Log.info(TAG, 'TokenState.SIGNED_IN get accountInfo');
  //       this.isLogin = true;
  //
  //       // 关闭游客模式弹窗
  //       Log.info(TAG, this.accountInfo.serviceCountryCode + TokenState[state]);
  //     }).catch((err: Error): void => {
  //       Log.warn(TAG, 'getCurrentUser err, %s', err?.name);
  //     });
  //     return;
  //   }
  //   if (state === TokenState.SIGNED_OUT) {
  //     // 触发场景。a，应用热启动，登出账号。b，应用冷启动，之前登录过账号A，冷启动时登出了账号A(可能没登录，也可能登录了账号B)
  //     Log.info(TAG, 'TokenState.SIGNED_OUT');
  //     this.clearAccount();
  //     // 触发游客模式弹窗
  //     return;
  //
  //   }
  //   if (state === TokenState.TOKEN_INVALID) {
  //     // 触发场景。异常场景本地不存在sessionId，重新触发账号登录
  //     this.signIn();
  //     return;
  //   }
  // };
  // private tokenListener: OnTokenListener = new MyTokenListener(this.onChangedCallback);

  constructor() {
    // this.authProvider.setTokenProvider(this.tokenProvider);
  }

  destroy(): void {
    // this.tokenProvider.removeTokenListener(this.tokenListener);
  }

  private async initSignIn(): Promise<boolean> {
    let isSucceed: boolean = true;
    // try {
    //   let option: AuthServiceOptions = {
    //     appContext: this.getCurrentContext(),
    //   };
    //   await new AuthenticateServiceInitTask(option).run();
    // } catch (err) {
    //   Log.error(TAG, 'AuthenticateServiceInitTaskFailed:%o', err);
    //   isSucceed = false;
    // }
    // addressService.init(this.getCurrentContext(), 'CN');
    // // 登录状态变化会回调
    // this.tokenProvider.addTokenListener(this.tokenListener);
    return isSucceed;
  }

  private getCurrentContext(): common.Context {
    return this.accountContext || global.uiAbilityContext();
  }

  /**
   * 获取AccountRepository唯一实例
   */
  public static getInstance(): AccountRepository {
    if (!AccountRepository.accountRepository) {
      AccountRepository.accountRepository = new AccountRepository();
    }
    return AccountRepository.accountRepository;
  }

  /**
   * 获取账号信息
   * 要获取账号服务地、昵称、头像等都通过该方法获取
   * 接口返回不会为undefined
   */
  public getAccount(): AccountInfo {
    return this.accountInfo;
  }

  /**
   * 获取账号AccessToken
   *
   * @param forceRefresh 是否强制刷新token，默认不刷新
   * @returns 账号sessionId
   */
  public async getAccessToken(forceRefresh: boolean = false): Promise<string> {
    if (!this.isLogin) {
      return '';
    }
    // try {
    //   // const token = await this.tokenProvider.getToken(forceRefresh);
    //   // return token?.tokenString;
    // } catch (err) {
    //   Log.error(TAG, 'get accessToken failed');
    //   return '';
    // }
    return '';
  }

  /**
   * 清除账号信息
   * 比如在监听到账号退出后，需要清空
   */
  private clearAccount(): void {
    if (!DeviceInfo.isPc()) {
      this.isLogin = false;
    }
    this.accountInfo = new AccountInfo();
  }

  /**
   * 账号是否登录
   * 需要校验账号的场景调用
   */
  public hasLogin(): boolean {
    return this.isLogin;
  }

  /**
   * 调用鉴权组件进行(静默)登录
   *
   * @param silent 是否静默登录，默认是
   * @returns 登录的Token信息
   */
  // public async signIn(silent: boolean = true): Promise<Token> {
  //   if (!this.isInit) {
  //     this.isInit = await this.initSignIn();
  //   }
  //   Log.info(TAG, 'signIn. isLogin:' + this.isLogin + ` isInit:${this.isInit}`);
  //     .setAgeRangeScope()
  //     .setClientId(Bundles.APP_ID)
  //     .setCountryCodeScope()
  //     .enableSilent(silent);
  //   return new Promise((resolve: (value: Token | PromiseLike<Token>) => void, reject: Function): void => {
  //     Log.info(TAG, 'signInWithProvider begin');
  //     this.authProvider.signInWithProvider(this.getCurrentContext(), authParamProvider).then((token: Token): void => {
  //       this.handleSignIn(resolve, reject, token);
  //     }).catch((err: SignInResultException): void => {
  //       // 切换账号后，首次登录会报错，这里判断如果是切换账号场景，则重新登录一次
  //       if (err?.getCode() !== SignInResultException.USER_NOT_SAME.getCode()) {
  //         Log.error(TAG, `signIn err: ${err?.getData()}` + err?.getCode());
  //         reject(err);
  //         return;
  //       }
  //       this.authProvider.signInWithProvider(this.getCurrentContext(), authParamProvider).then((token: Token): void => {
  //         this.handleSignIn(resolve, reject, token);
  //       }).catch((err: SignInResultException): void => {
  //         Log.error(TAG, `signIn again err, ${err?.getData()}` + err?.getCode());
  //         reject(err);
  //       });
  //     });
  //   });
  // }

  public setAccountContext(context: common.Context): void {
    this.accountContext = context;
  }

  public releaseAccountContext(): void {
    this.accountContext = undefined;
    this.isInit = false;
  }

  // private handleSignIn(resolve: (token: Token) => void, reject: Function, token: Token): void {
  //   Log.info(TAG, 'signInWithProvider end');
    // this.authProvider.getCurrentUser(this.getCurrentContext()).then((user: User): void => {
    //   let country = user.getServiceCountryCode();
    //   if (!country) {
    //     Log.error(TAG, 'signInWithProvider get country failure');
    //     country = 'cn';
    //   }
    //   this.accountInfo.serviceCountryCode = country;
    //   this.accountInfo.userId = user.getUid();
    //   this.isLogin = true;
    //   resolve(token);
    //   Log.info(TAG, 'handleSignIn get accountInfo');
    // }).catch((err: Error): void => {
    //   Log.error(TAG, `${err}getCurrentUser err, %s`, err?.name);
    //   reject(err);
    // });
  // }

  /**
   * 发布登录/退出事件
   *
   * @param eventId 登录/退出事件id
   */
  public emitterLoginEvent(eventId: number, data: object, delay: number = 0): void {
    let event: emitter.InnerEvent = {
      eventId: eventId,
      priority: emitter.EventPriority.IMMEDIATE,
    };
    let eventData: emitter.EventData = {
      data
    };
    // 冷启动登录后还未进入首页，支持延迟500ms发送消息
    if (delay > 0) {
      let timerId = setTimeout((): void => {
        emitter.emit(event, eventData);
        clearTimeout(timerId);
      }, delay);
    } else {
      emitter.emit(event, eventData);
    }
  }

  /**
   * 获取authProvider
   * @returns 当前authProvider
   */
  // public getAuthProvider(): IAuthProvider {
  //   return this.authProvider;
  // }

  /**
   * 获取tokenProvider
   * @returns 当前tokenProvider
   */
  // public getTokenProvider(): ITokenProvider {
  //   return this.tokenProvider;
  // }
}