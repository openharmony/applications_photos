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

import display from '@ohos.display'
import {Logger} from '../../utils/Logger.ets'
import {Constants} from './Constants'
import {UiUtil} from '../../utils/UiUtil.ets';

export enum ColumnSize {
    COLUMN_FOUR = 4,
    COLUMN_SIX = 6,
    COLUMN_EIGHT = 8,
    COLUMN_TWELVE = 12
}

enum ScreenWidth {
    WIDTH_MEDIUM = 520,
    WIDTH_LARGE = 840
}

export class ScreenManager {
    static readonly ON_WIN_SIZE_CHANGED = 'on_win_size_changed';
    static readonly ON_SPLIT_MODE_CHANGED = 'on_split_mode_changed';
    static readonly ON_LEFT_BLANK_CHANGED = 'on_left_blank_changed';
    private static readonly SPLIT_THRESHOLD = 1.7;
    private logger: Logger = new Logger('ScreenManager');
    private winWidth = 0.0;
    private winHeight = 0.0;
    private statusBarHeight = 0;
    private naviBarHeight = 0;
    private leftBlank: [number, number, number, number] = [0, 0, 0, 0];
    private events = [];

    private columns: number = ColumnSize.COLUMN_FOUR;

    // Default orientation
    private horizontal = false;

    // Default sidebar
    private sidebar = false;

    private constructor() {
        this.logger.info('constructor');
    }

    static getInstance(): ScreenManager {
        if (AppStorage.Get(Constants.APP_KEY_SCREEN_MANAGER) == null) {
            AppStorage.SetOrCreate(Constants.APP_KEY_SCREEN_MANAGER, new ScreenManager());
        }

        let manager: ScreenManager = AppStorage.Get(Constants.APP_KEY_SCREEN_MANAGER);

        // TODO: use display to replace window Temporarily
        if (0 == manager.winWidth || 0 == manager.winHeight) {
            display.getDefaultDisplay().then(retDisplay => {
                if (retDisplay.height <= retDisplay.width) {
                    manager.winWidth = px2vp(retDisplay.height);
                    manager.winHeight = px2vp(retDisplay.width);
                } else {
                    manager.winWidth = px2vp(retDisplay.width);
                    manager.winHeight = px2vp(retDisplay.height);
                }
            });
        }
        if (manager.winWidth < ScreenWidth.WIDTH_MEDIUM) {
            manager.columns = ColumnSize.COLUMN_FOUR;
        } else if (manager.winWidth >= ScreenWidth.WIDTH_MEDIUM && manager.winWidth < ScreenWidth.WIDTH_LARGE) {
            manager.columns = ColumnSize.COLUMN_EIGHT;
        } else {
            manager.columns = ColumnSize.COLUMN_TWELVE;
        }
        return manager;
    }

    /**
     * Add Listeners
     *
     * @param event
     * @param fn
     */
    on(event, fn) {
        if (Array.isArray(event)) {
            for (let i = 0, l = event.length; i < l; i++) {
                this.on(event[i], fn);
            }
        } else {
            (this.events[event] || (this.events[event] = [])).push(fn);
        }
    }

    /**
     * Delete Listeners
     *
     * @param event
     * @param fn
     */
    off(event, fn) {
        if (event == null || event == undefined) {
            return;
        }
        if (Array.isArray(event)) {
            for (let i = 0, l = event.length; i < l; i++) {
                this.off(event[i], fn);
            }
        }
        const cbs = this.events[event];
        if (!cbs) {
            return;
        }
        if (fn == null || fn == undefined) {
            return;
        }
        let cb;
        let i = cbs.length;
        while (i--) {
            cb = cbs[i];
            if (cb === fn || cb.fn === fn) {
                cbs.splice(i, 1);
                break;
            }
        }
    }

    private emit(event, argument: any[]) {
        let _self = this;
        if (!this.events[event]) {
            return;
        }
        let cbs = [...this.events[event]];
        if (cbs) {
            for (let i = 0, l = cbs.length; i < l; i++) {
                let ref = cbs[i];
                if (ref) {
                    try {
                        ref.apply(_self, argument);
                    } catch (e) {
                        new Error(e);
                    }
                }
            }
        }
    }

    private isLeftBlankInitialized(): boolean {
        return this.leftBlank[0] != 0 || this.leftBlank[1] != 0 || this.leftBlank[2] != 0 || this.leftBlank[3] != 0;
    }

    // Unit：vp
    getWinWidth(): number {
        return this.winWidth;
    }

    // Unit：vp
    getWinHeight(): number {
        return this.winHeight;
    }

    getStatusBarHeight(): number {
        return this.statusBarHeight;
    }

    getNaviBarHeight(): number {
        return this.naviBarHeight;
    }

    isSplitMode(): boolean {
        return this.winWidth != 0 && this.winHeight != 0
            && this.winWidth / this.winHeight < ScreenManager.SPLIT_THRESHOLD;
    }

    setMainWindow(win) {
        this.logger.debug('setMainWindow');
        win.on('windowSizeChange', (data) => {
            this.logger.debug(`windowSizeChange ${JSON.stringify(data)}`);
            this.onWinSizeChanged(data);
        })
    }

    getAvoidArea() {
        let topWindow: any = AppStorage.Get('mainWindow');
        topWindow.getAvoidArea(0, (err, data) => {
            UiUtil.setStatusBarColor(topWindow);
            this.logger.info('Succeeded in obtaining the area. Data:' + JSON.stringify(data));
            this.onLeftBlankChanged(data);
        });
    }

    setFullScreen() {
        let topWindow: any = AppStorage.Get('mainWindow');
        this.logger.debug('getTopWindow start');
        try {
            topWindow.setLayoutFullScreen(true, () => {
                this.logger.debug('setFullScreen true Succeeded');
                this.hideStatusBar();
            });
        } catch (err) {
            this.logger.error(`setFullScreen err: ${err}`);
        }
    }

    hideStatusBar() {
        this.logger.debug('hideStatusBar start');
        let topWindow: any = AppStorage.Get('mainWindow');
        this.logger.debug('getTopWindow start');
        let names = [];
        this.logger.debug(`getTopWindow names: ${names} end`);
        try {
            topWindow.setSystemBarEnable(names, () => {
                this.logger.debug('hideStatusBar Succeeded');
                names = ["navigation"];
                topWindow.setSystemBarEnable(names, () => {
                    topWindow.getAvoidArea(0, (err, data) => {
                        UiUtil.setStatusBarColor(topWindow);
                        this.logger.info('Succeeded in obtaining the area. Data:' + JSON.stringify(data));
                        this.onLeftBlankChanged(data);
                    });
                });
            });
        } catch (err) {
            this.logger.error(`hideStatusBar err: ${err}`);
        }
    }
    setSystemUi(isShowBar: boolean): void {
        this.logger.debug('setSystemUi start');
        let topWindow: any = AppStorage.Get('mainWindow');
        this.logger.debug('getTopWindow start');
        let names = ["navigation"];
        if (!isShowBar) {
            names = [];
        }
        this.logger.debug(`getTopWindow names: ${names} end`);
        try {
            topWindow.setSystemBarEnable(names, () => {
                this.logger.debug('setFullScreen Succeeded');
                if (isShowBar) {
                    topWindow.getAvoidArea(0, (err, data) => {
                        this.logger.info('Succeeded in obtaining the area. Data:' + JSON.stringify(data));
                        this.onLeftBlankChanged(data);
                    });
                }
            })
        } catch (err) {
            this.logger.error(`setSystemUi err: ${err}`);
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
        this.statusBarHeight = px2vp(area.topRect.height);
        this.naviBarHeight = px2vp(area.bottomRect.height);
        this.leftBlank = [this.leftBlank[0], this.leftBlank[1], this.leftBlank[2], px2vp(area.bottomRect.height)];
        if (leftBlankBefore.status != this.statusBarHeight || leftBlankBefore.navi != this.naviBarHeight) {
            this.logger.info(`leftBlank changed: ${JSON.stringify(leftBlankBefore)}-${JSON.stringify(this.leftBlank)}`);
            this.emit(ScreenManager.ON_LEFT_BLANK_CHANGED, [this.leftBlank]);
        }
    }

    private onWinSizeChanged(size) {
        this.logger.info(`onWinSizeChanged ${JSON.stringify(size)}`);
        if (size == null || size == undefined) {
            return;
        }
        let isSplitModeBefore = this.isSplitMode();
        let sizeBefore = {
            width: this.winWidth,
            height: this.winHeight
        };
        this.winWidth = px2vp(size.width);
        this.winHeight = px2vp(size.height);
        let isSplitModeNow = this.isSplitMode();
        if (isSplitModeBefore != isSplitModeNow) {
            this.logger.info(`splitMode changed: ${isSplitModeBefore} -> ${isSplitModeNow}`);
            this.emit(ScreenManager.ON_SPLIT_MODE_CHANGED, [isSplitModeNow]);
        }
        if (sizeBefore.width != size.width || sizeBefore.height != size.height) {
            this.logger.info(`winSize changed: ${JSON.stringify(sizeBefore)} -> ${JSON.stringify(size)}`);
            this.emit(ScreenManager.ON_WIN_SIZE_CHANGED, [size]);
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
        AppStorage.SetOrCreate(Constants.SCREEN_ORIENTATION_HORIZONTAL, this.horizontal);
    }

    isHorizontal(): boolean {
        if (AppStorage.Get(Constants.SCREEN_ORIENTATION_HORIZONTAL) == null) {
            AppStorage.SetOrCreate(Constants.SCREEN_ORIENTATION_HORIZONTAL, this.horizontal);
        }
        return AppStorage.Get(Constants.SCREEN_ORIENTATION_HORIZONTAL);
    }

    isSidebar(): boolean {
        if (AppStorage.Get(Constants.SCREEN_SIDEBAR) == null) {
            AppStorage.SetOrCreate(Constants.SCREEN_SIDEBAR, this.sidebar);
        }
        return AppStorage.Get(Constants.SCREEN_SIDEBAR);
    }

    getColumnsWidth(count: number): number {
        let columnWidth = (this.winWidth - Constants.COLUMN_MARGIN) / this.columns;
        return columnWidth * count - Constants.COLUMN_GUTTER;
    }

    getScreenColumns(): number {
        return this.columns;
    }
}
