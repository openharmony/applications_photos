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
import deviceInfo from '@ohos.deviceInfo';
import window from '@ohos.window';
import createOrGet from '../utils/SingleInstanceUtils';
import { Log } from '../utils/Log';
import { BroadcastConstants } from '../constants/BroadcastConstants';
import { WindowConstants } from '../constants/WindowConstants';
import { getResourceString } from '../utils/ResourceUtils';
import { Broadcast } from '../utils/Broadcast';

export enum ColumnSize {
    COLUMN_TWO = 2,
    COLUMN_FOUR = 4,
    COLUMN_SIX = 6,
    COLUMN_EIGHT = 8,
    COLUMN_TWELVE = 12
}

enum ScreenWidth {
    WIDTH_MEDIUM = 520,
    WIDTH_LARGE = 840
}

enum WindowMode {
    UNDEFINED = 1,
    FULL_SCREEN,
    PRIMARY,
    SECONDARY,
    FLOATING
}

const TAG = "ScreenManager"

const APP_KEY_SCREEN_MANAGER = 'app_key_screen_manager';

const SCREEN_ORIENTATION_HORIZONTAL: string = 'isHorizontal';
const SCREEN_SIDEBAR: string = 'isSidebar';

const COLUMN_MARGIN: number = 12;
const COLUMN_GUTTER: number = 12;

class ScreenManager {
    readonly ON_WIN_SIZE_CHANGED = 'on_win_size_changed';
    readonly ON_LEFT_BLANK_CHANGED = 'on_left_blank_changed';
    readonly DEFAULT_WIDTH: number = 1920;
    readonly DEFAULT_HEIGHT: number = 1080;
    readonly SPLIT_THRESHOLD = 1.7;
    private winWidth = 0.0;
    private winHeight = 0.0;
    private statusBarHeight = 0;
    private naviBarHeight = 0;
    private leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    private broadcast: Broadcast = new Broadcast();
    private events = [];
    private mainWindow: window.Window = undefined;

    // Default orientation
    private horizontal = deviceInfo.deviceType == 'phone' || deviceInfo.deviceType == 'default' ? false : true;

    // Default sidebar
    private sidebar = deviceInfo.deviceType == 'phone' || deviceInfo.deviceType == 'default' ? false : true;
    private windowMode = WindowMode.UNDEFINED;

    constructor() {
        Log.info(TAG, 'constructor');
    }

    async initializationSize(win): Promise<void> {
        this.mainWindow = win;
        this.setMainWindow(win)
        await this.checkWindowMode();
        this.getWindowProperties(win);
    }

    /**
     * Add Listeners
     *
     * @param event
     * @param fn
     */
    on(event, fn) {
        this.broadcast.on(event, fn);
    }

    /**
     * Delete Listeners
     *
     * @param event
     * @param fn
     */
    off(event, fn) {
        this.broadcast.off(event, fn);
    }

    private emit(event, argument: any[]) {
        this.broadcast.emit(event, argument);
    }

    private isLeftBlankInitialized(): boolean {
        return this.leftBlank[0] != 0 || this.leftBlank[1] != 0 || this.leftBlank[2] != 0 || this.leftBlank[3] != 0;
    }

    // Unit：vp
    getWinWidth(): number {
        return px2vp(this.winWidth);
    }

    // Unit：vp
    getWinHeight(): number {
        return px2vp(this.winHeight);
    }

    getStatusBarHeight(): number {
        return px2vp(this.statusBarHeight);
    }

    getNaviBarHeight(): number {
        return px2vp(this.naviBarHeight);
    }

    async initWindowMode() {
        Log.debug(TAG, `start to initialize photos application window mode: ${this.windowMode}`);
    }

    isSplitMode(): boolean {
        return (WindowMode.PRIMARY == this.windowMode || WindowMode.SECONDARY == this.windowMode)
    }

    async checkWindowMode() {
        let before = this.windowMode;
        let mode = await globalThis.photosWindowStage.getWindowMode();
        Log.info(TAG, `photos application before/current window mode: ${before}/${mode}`);

        if (before == mode) {
            return;
        }
        this.windowMode = mode;
        if (WindowMode.FULL_SCREEN == this.windowMode) {
            await this.setFullScreen();
        } else {
            this.setSplitScreen();
        }
    }

    private setMainWindow(win: window.Window) {
        Log.debug(TAG, 'setMainWindow');
        win.on('windowSizeChange', (data) => {
            Log.debug(TAG, `windowSizeChange ${JSON.stringify(data)}`);
            this.checkWindowMode()
            this.onWinSizeChanged(data);
        })
    }

    private getWindowProperties(win: window.Window) {
        Log.debug(TAG, 'getWindowProperties');
        try {
            let properties = win.getWindowProperties();
            if(properties.windowRect.width !== 0 && properties.windowRect.height !== 0){
                this.winWidth = properties.windowRect.width;
                this.winHeight = properties.windowRect.height;
            }
            Log.debug(TAG, `this.winWidth = ${this.winWidth} this.winHeight = ${this.winHeight}`);
        } catch (exception) {
            console.error('Failed to obtain the window properties. Cause: ' + JSON.stringify(exception));
        }
    }

    private async setFullScreen() {
        let topWindow: any = AppStorage.Get(WindowConstants.MAIN_WINDOW);
        Log.debug(TAG, 'getTopWindow start');
        try {
            await topWindow.setLayoutFullScreen(true)
            Log.debug(TAG, 'setFullScreen true Succeeded');
            await this.hideStatusBar(topWindow);
        } catch (err) {
            Log.error(TAG, `setFullScreen err: ${err}`);
        }
    }

    setSplitScreen() {
        try {
            this.statusBarHeight = 0;
            this.naviBarHeight = 0;
            this.leftBlank = [0, 0, 0, 0];
            AppStorage.SetOrCreate(BroadcastConstants.LEFT_BLANK, this.leftBlank);
        } catch (err) {
            Log.error(TAG, `setSplitScreen err: ${err}`);
        }
    }

    private async hideStatusBar(topWindow: any) {
        Log.debug(TAG, 'hideStatusBar start');
        let names = ['navigation'];
        Log.debug(TAG, `getTopWindow names: ${names} end`);
        try {
            await topWindow.setSystemBarEnable(names)
            Log.debug(TAG, 'hideStatusBar Succeeded');
            let data = await topWindow.getAvoidArea(0)
            Log.debug(TAG, `Succeeded in obtaining the area. Data: ${JSON.stringify(data)}`);
            this.onLeftBlankChanged(data);
            let barColor = await getResourceString($r('app.color.default_background_color'));
            let barContentColor = await getResourceString($r('app.color.default_bar_content_color'));
            if (!barColor) {
                barColor = '#00FFFFFF';
            }
            if (!barContentColor) {
                barContentColor = '#FF000000';
            }
            await topWindow.setSystemBarProperties({
                navigationBarColor: barColor,
                navigationBarContentColor: barContentColor
            });
            Log.info(TAG, 'setStatusBarColor done');
        } catch (err) {
            Log.error(TAG, `hideStatusBar err: ${err}`);
        }
    }

    async setNavigationBarColor(barColor: string, barContentColor: string) {
        Log.debug(TAG, 'setNavigationBarColor start');
        let topWindow: any = AppStorage.Get(WindowConstants.MAIN_WINDOW);
        try {
            topWindow.setSystemBarProperties(
                {
                    navigationBarColor: barColor,
                    navigationBarContentColor: barContentColor
                },
                () => Log.info(TAG, 'setStatusBarColor done')
            );
        } catch (err) {
            Log.error(TAG, `setNavigationBarColor err: ${err}`);
        }
    }

    setSystemUi(isShowBar: boolean): void {
        Log.debug(TAG, 'setSystemUi start');
        let topWindow: any = AppStorage.Get(WindowConstants.MAIN_WINDOW);
        Log.debug(TAG, 'getTopWindow start');
        let names = ["navigation"];
        if (!isShowBar) {
            names = [];
        }
        Log.debug(TAG, `getTopWindow names: ${names} end`);
        try {
            topWindow.setSystemBarEnable(names, () => {
                Log.debug(TAG, 'setFullScreen Succeeded');
                if (isShowBar) {
                    topWindow.getAvoidArea(0, (err, data) => {
                        Log.info(TAG, 'Succeeded in obtaining the area. Data:' + JSON.stringify(data));
                        this.onLeftBlankChanged(data);
                    });
                }
            })
        } catch (err) {
            Log.error(TAG, `setSystemUi err: ${err}`);
        }
    }

    private onLeftBlankChanged(area) {
        if (area == null || area == undefined || area.bottomRect.height == 0) {
            return;
        }
        let leftBlankBefore = {
            status: this.statusBarHeight,
            navi: this.naviBarHeight
        };
        this.statusBarHeight = 0;
        this.naviBarHeight = area.bottomRect.height;
        this.leftBlank = [this.leftBlank[0], this.leftBlank[1], this.leftBlank[2], area.bottomRect.height];
        if (leftBlankBefore.status != this.statusBarHeight || leftBlankBefore.navi != this.naviBarHeight) {
            Log.info(TAG, `leftBlank changed: ${JSON.stringify(leftBlankBefore)}-${JSON.stringify(this.leftBlank)}`)
            AppStorage.SetOrCreate(BroadcastConstants.LEFT_BLANK, this.leftBlank);
        }
    }

    private onWinSizeChanged(size) {
        Log.info(TAG, `onWinSizeChanged ${JSON.stringify(size)}`);
        if (size == null || size == undefined) {
            return;
        }
        let sizeBefore = {
            width: this.winWidth,
            height: this.winHeight
        };
        this.winWidth = size.width;
        this.winHeight = size.height;


        if (sizeBefore.width != this.winWidth || sizeBefore.height != this.winHeight) {
            Log.info(TAG, `winSize changed: ${JSON.stringify(sizeBefore)} -> ${JSON.stringify(size)}`);
            this.emit(screenManager.ON_WIN_SIZE_CHANGED, [size]);
        }
    }

    private onRotationAngleChanged(angle) {
        if (angle == null || angle == undefined) {
            return;
        }

        if (angle == 0) {
            this.horizontal = false;
        } else {
            this.horizontal = true;
        }
        AppStorage.SetOrCreate(SCREEN_ORIENTATION_HORIZONTAL, this.horizontal);
    }

    isHorizontal(): boolean {
        if (AppStorage.Get(SCREEN_ORIENTATION_HORIZONTAL) == null) {
            AppStorage.SetOrCreate(SCREEN_ORIENTATION_HORIZONTAL, this.horizontal);
        }
        return AppStorage.Get(SCREEN_ORIENTATION_HORIZONTAL);
    }

    isSidebar(): boolean {
        if (AppStorage.Get(SCREEN_SIDEBAR) == null) {
            AppStorage.SetOrCreate(SCREEN_SIDEBAR, this.sidebar);
        }
        return AppStorage.Get(SCREEN_SIDEBAR);
    }

    getColumnsWidth(count: number): number {
        let columns = this.getScreenColumns()
        Log.info(TAG, `getColumnsWidth count is ${count} colunms is ${columns}`);
        let columnWidth = (px2vp(this.winWidth) - COLUMN_MARGIN) / columns;
        return columnWidth * count - COLUMN_GUTTER;
    }

    getScreenColumns(): number {
        let width = px2vp(this.winWidth)
        if (width < ScreenWidth.WIDTH_MEDIUM) {
            return ColumnSize.COLUMN_FOUR;
        } else if (width >= ScreenWidth.WIDTH_MEDIUM && width < ScreenWidth.WIDTH_LARGE) {
            return ColumnSize.COLUMN_EIGHT;
        } else {
            return ColumnSize.COLUMN_TWELVE;
        }
    }

    setKeepScreenOn() {
        Log.info(TAG, 'setKeepScreenOn start');
        let topWindow: any = AppStorage.Get('mainWindow');
        try {
            topWindow.setKeepScreenOn(true, () => Log.info(TAG, 'setKeepScreenOn Succeeded'))
        } catch (err) {
            Log.error(TAG, `setKeepScreenOn err: ${err}`);
        }
    }

    setKeepScreenOff() {
        Log.info(TAG, 'setKeepScreenOff start');
        let topWindow: any = AppStorage.Get('mainWindow');
        try {
            topWindow.setKeepScreenOn(false, () => Log.info(TAG, 'setKeepScreenOff Succeeded'))
        } catch (err) {
            Log.error(TAG, `setKeepScreenOff err: ${err}`);
        }
    }
}

let screenManager = createOrGet(ScreenManager, TAG);

export default screenManager as ScreenManager;
