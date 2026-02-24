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
import type { Router } from '@ohos.arkui.UIContext';
import lazy { errors, } from '../../utils/errors';
import lazy { Log } from '../../utils/Log';
import type { router } from '@kit.ArkUI';
import type { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import lazy { global } from '../Contexts';
import lazy { PageTitle } from './PageTitle';

/* instrument ignore file */
const TAG: string = 'Routers';

//全局路由
export namespace Routers {
  export interface IUrl {
    url?: string;
  }

  /**
   * 全局应用主窗口的路由
   *
   * 这个函数后面禁止加?判空,
   * 出现空报错说明commonAbility里的mainWindow还没有拿到, 排查入口创建时序正向解决
   *
   * @returns Router 全局路由
   */
  export function instance(): Router {
    return global.UIContext().getRouter();
  }

  export function getParam(): Object {
    return Routers.instance().getParams();
  }

  export function getRouterInterface<T = Routers.IUrl>(): T {
    return Routers.getParam() as T;
  }

  export function getUrl(): string {
    return Routers.getRouterInterface()?.url ?? '';
  }

  export function isCurrentPage(pageTitle: string): boolean {
    return Routers.instance().getState().name === pageTitle;
  }

  export function replace(url: string, callback?: AsyncCallback<void, void>): void {
    if (!url) {
      return;
    }
    callback = callback || ((err: BusinessError): void => {
      if (err) {
        Log.error(TAG, `RouterReplace err:${errors.toString(err)}` + url);
      }
    });
    const pushUrl = (url: string): void => {
      const options: router.RouterOptions = {
        url
      };
      Routers.instance().replaceUrl(options, callback);
    };
    errors.tryFunc((): void => pushUrl(url));
  }

  /**
   * replaceWithCheck
   * @param title
   * @param callback
   */
  export function softReplace(title: string, callback?: AsyncCallback<void, void>): void {
    if (isCurrentPage(title)) {
      Log.warn(TAG, `RouterReplace warn: title has already been replaced: ${title}`);
      return;
    }
    replace(PageTitle.prefix + title, callback);
  }

  export function browse(url: string, callback?: AsyncCallback<void, void>): void {
    if (!url) {
      return;
    }
    callback = callback || ((err: BusinessError): void => {
      if (err) {
        Log.error(TAG, url + `pushHtm err: ${errors.toString(err)}`);
      }
    });
    const pushUrl = (url: string): void => {
      Routers.instance().pushUrl({
        url: 'MainAbility/view/WebBrowser',
        params: { url },
      }, callback);
    };
    errors.tryFunc((): void => pushUrl(url));
  }

  export function push(url: string, callback?: AsyncCallback<void, void>): void {
    if (!url) {
      return;
    }
    callback = callback || ((err: BusinessError): void => {
      if (err) {
        Log.error(TAG, url + `urlPush err: ${errors.toString(err)}`);
      }
    });
    const pushUrl = (url: string): void => {
      const options: router.RouterOptions = { url };
      Routers.instance().pushUrl(options, callback);
    };
    errors.tryFunc((): void => pushUrl(url));
  }

  export function back(url: string): void {
    errors.tryFunc((): void => Routers.instance().back({ url }));
  }

  export function escapeWelcomePage(): void {
    if (Routers.isCurrentPage(PageTitle.permissionNormal)) {
      Routers.softReplace(PageTitle.index);
    }
  }

  export function escapeWelcomePageEnterUserGuide(): void {
    if (Routers.isCurrentPage(PageTitle.permissionNormal)) {
      Routers.softReplace(PageTitle.userGuide);
    }
  }
}