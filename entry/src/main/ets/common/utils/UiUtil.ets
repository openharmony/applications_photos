/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import {MathUtil} from './MathUtil'
import {Logger} from './Logger'
import {Constants} from '../model/common/Constants';
import resourceManager from '@ohos.resourceManager';
import prompt from '@system.prompt';
import {ScreenManager} from '../model/common/ScreenManager';

export class UiUtil {

    /**
     * Status bar height
     */
    static readonly STATUS_BAR_HEIGHT = 45;

    /**
     * Navigation bar height
     */
    static readonly NAVI_BAR_HEIGHT = 45;

    /**
     * Hexadecimal Radix
     */
    static readonly HEX_BASE = 16;

    /**
     * Maximum order of color
     */
    static readonly MAX_COLOR_ORDER = 255;

    /**
     * 3-bit length hex color
     */
    private static readonly HEX_COLOR_LENGTH_THREE = 3;

    /**
     * 8-bit length hex color
     */
    private static readonly HEX_COLOR_LENGTH_EIGHT = 8;

    /**
     * Opacity length of hex color
     */
    private static readonly HEX_COLOR_OPACITY_LENGTH = 2;

    public static readonly TOAST_DURATION = 3000;

    /**
     * Hexadecimal array
     */
    private static readonly HEX_ARRAY = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];

    /**
     * logger
     */
    private static logger: Logger = new Logger('UiUtil');

    /**
     * Set full screen immersion
     *
     * @param window window
     * @param isFullScreen isFullScreen
     */
    static setLayoutFullScreen(paramWindow: any, isFullScreen: boolean): void {
        paramWindow.getTopWindow().then((data) => {
            this.logger.info(`WindowPlugin getTopWindow promise success data: ${data}`);
            data.setLayoutFullScreen(isFullScreen).then(() => {
                this.logger.info('finish to set full screen');
            });
        }).catch((error) => {
            this.logger.error(`WindowPlugin getTopWindow promise failed because ${error}`);
        });
    }

    /**
     * Set system status bar / navigation bar display / hide
     *
     * @param window window
     * @param systemBars ["status", "navigation"] ["status"] ["navigation"] []
     */
    static setSystemUi(isShowBar: boolean): void {
        this.logger.debug('setSystemUi start');
        let topWindow: any = AppStorage.Get(Constants.MAIN_WINDOW);
        this.logger.debug('getTopWindow start');
        let names = ["status", "navigation"];
        if (!isShowBar) {
            names = [];
        }
        this.logger.debug(`getTopWindow names: ${names} end`);
        try{
            topWindow.setSystemBarEnable(names, () => {
                this.logger.debug('setFullScreen Succeeded');
            })
        }catch(err) {
            this.logger.error(`setSystemUi err: ${err}`);
        }
    }

    /**
     * Get system status bar height
     *
     * @param window window
     * @returns Promise<number> height
     */
    static getStatusBarHeight(paramWindow: any): Promise<number> {
        return paramWindow.getTopWindow().then((data) => {
            this.logger.info(`WindowPlugin getTopWindow promise success data: ${data}`);
            return data.getAvoidArea(0);
        }).then((area) => {
            this.logger.info(`getStatusBarHeight: ${JSON.stringify(area)}, height: ${px2vp(area.topRect.height)}`);
            return px2vp(area.topRect.height);
        }).catch((error) => {
            this.logger.error(`getStatusBarHeight failed: ${error}`);
        });
    }

    /**
     * Get navigation status bar height
     *
     * @param window window
     * @returns Promise<number> height
     */
    static getNaviBarHeight(paramWindow: any): Promise<number> {
        return paramWindow.getTopWindow().then((data) => {
            this.logger.info(`WindowPlugin getTopWindow promise success data: ${data}`);
            return data.getAvoidArea(0);
        }).then((area) => {
            this.logger.info(`getNaviBarHeight: ${JSON.stringify(area)}, height: ${px2vp(area.bottomRect.height)}`);
            return px2vp(area.bottomRect.height);
        }).catch((error) => {
            this.logger.error(`getStatusBarHeight failed: ${error}`);
        });
    }

    /**
     * Set navigation bar color
     *
     * @param window window
     * @param navigationBarColor navigationBarColor
     */
    static setNavigationBarColor(paramWindow: any, navigationBarColor: string): void {
        paramWindow.getTopWindow((err, resWindow) => {
            if (err) {
                this.logger.error(`WindowPlugin failed to setNavigationBarColor because ${err}`);
                return;
            }
            let navigationBar = {
                navigationBarColor: navigationBarColor,
                isNavigationBarLightIcon: false
            };
            resWindow.setSystemBarProperties(navigationBar, (error, data) => {
                if (error) {
                    this.logger.error(`WindowPlugin failed to setNavigationBarColor because ${error}`);
                    return;
                }
                this.logger.info(` setNavigationBarColor ${data}`);
            });
        })
    }

    /**
     * Set status bar color
     *
     * @param statusBarColor statusBarColor
     */
    static setStatusBarColor(topWindow): void {
        topWindow.setSystemBarProperties({navigationBarColor: '#FFF1F3F5', navigationBarContentColor: '#FF000000'},
            () => { this.logger.info('setStatusBarColor done'); });
    }

    /**
     * Gets the hexadecimal color with opacity
     *
     * @param color Original hex color
     * @param opacity Opacity
     * @returns Hex color with opacity
     */
    static getHexOpacityColor(paramColor: string, paramOpacity: number): string {
        let colorReg = /^\#([0-9a-fA-f]{3}|[0-9a-fA-f]{6}|[0-9a-fA-f]{8})$/;
        // The input must be # the first 3-bit / 6-bit / 8-bit hex color
        if (paramColor.match(colorReg) == null) {
            this.logger.error(`getHexOpacityColor failed because of invalid input, color:  ${paramColor}`);
            return paramColor;
        }
        let color = paramColor.replace(/\#/g, '').toUpperCase();
        let opacity = MathUtil.clamp(0, 1, paramOpacity);
        // If it is an abbreviated 3-digit color, complete the 3-digit characters to 6-digit characters
        if (color.length === UiUtil.HEX_COLOR_LENGTH_THREE) {
            let arr = color.split('');
            color = '';
            for (let i = 0; i < arr.length; i++) {
                color += (arr[i] + arr[i]);
            }
        }
        // If it is an 8-bit color, the original opacity will be removed
        if (color.length === UiUtil.HEX_COLOR_LENGTH_EIGHT) {
            color = color.slice(UiUtil.HEX_COLOR_OPACITY_LENGTH, color.length);
        }
        let opacityNum = Math.round(UiUtil.MAX_COLOR_ORDER * opacity); // rounding
        let opacityStr = '';
        while (opacityNum > 0) {
            let mod = opacityNum % UiUtil.HEX_BASE;
            opacityNum = (opacityNum - mod) / UiUtil.HEX_BASE;
            opacityStr = UiUtil.HEX_ARRAY[mod] + opacityStr;
        }
        if (opacityStr.length == 1) {
            opacityStr = `0${opacityStr}`;
        }
        if (opacityStr.length == 0) {
            opacityStr = '00';
        }
        return `#${opacityStr + color}`;
    }

    /**
     * Get the content of the resource reference
     *
     * @param resource resource reference
     * @returns resource Corresponding content string
     */
    static async getResourceString(resource: Resource) {
        try {
            this.logger.info(`getResourceString: ${JSON.stringify(resource)}`);
            let mgr:resourceManager.ResourceManager = await resourceManager.getResourceManager(globalThis.photosAbilityContext);
            if (mgr != null || mgr != undefined) {
                return await mgr.getString(resource.id);
            } else {
                this.logger.error(`getResourceManager instance is none`);
                return null;
            }
        } catch (error) {
            this.logger.error(`getResourceString error: ${error}`);
            return null;
        }
    }

    static async showToast(resource: Resource) {
        let message = await UiUtil.getResourceString(resource);
        let naviBarHeight = ScreenManager.getInstance().getNaviBarHeight()
        this.logger.debug(`showToast: ${message}`);
        prompt.showToast({
            message: message,
            duration: UiUtil.TOAST_DURATION,
            bottom: `${64 + naviBarHeight}vp`
        });
    }
}