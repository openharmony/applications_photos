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


import { UiUtil } from '../../utils/UiUtil'
import { Logger } from '../../utils/Logger'
import { Constants } from './Constants'

export enum StatusBarColorMode {
    NORMAL,
    TRANSPARENT,
    PHOTO_BROWSER
}

export class StatusBarColorController {
    private logger: Logger = new Logger('StatusBarColorController');
    private mode: StatusBarColorMode;
    private statusBarColor: string;

    private constructor() {
        this.logger.info('constructor');
        UiUtil.getResourceString($r('app.color.default_background_color')).then((value) => {
            this.statusBarColor = value;
            this.logger.info(`statusBarColor: ${value}`);
        }).catch((error) => {
            this.logger.error(`getResourceString error: ${error}`);
        })
    }

    public static getInstance(): StatusBarColorController {
        if (AppStorage.Get(Constants.APP_KEY_STATUS_BAR_COLOR_CONTROLLER) == null) {
            AppStorage.SetOrCreate(
                Constants.APP_KEY_STATUS_BAR_COLOR_CONTROLLER, new StatusBarColorController());
        }
        return AppStorage.Get(Constants.APP_KEY_STATUS_BAR_COLOR_CONTROLLER);
    }

    public setMode(mode: StatusBarColorMode): void {
        this.mode = mode;
        this.invalidate();
    }

    private invalidate(): void {
        this.logger.info(`invalidate mode: ${this.mode}`);
        switch (this.mode) {
            case StatusBarColorMode.TRANSPARENT:
                UiUtil.getResourceString($r('app.color.transparent')).then(() => {
                }).catch((error) => {
                    this.logger.error(`getResourceString for transparent color error: ${error}`);
                })
                break;
            case StatusBarColorMode.PHOTO_BROWSER:
                this.checkColorAvailable();
                break;
            default:
                this.checkColorAvailable();
                break;
        }
    }

    private async checkColorAvailable() {
        if (this.statusBarColor) {
            return true;
        } else {
            try {
                let color = await UiUtil.getResourceString($r('app.color.default_background_color'));
                this.statusBarColor = color;
                this.logger.info(`statusBarColor: ${color}`);
                return color != null;
            } catch (error) {
                this.logger.error(`getResourceString error: ${error}`);
                return false;
            }
        }
    }

    public release() {
        AppStorage.Delete(Constants.APP_KEY_STATUS_BAR_COLOR_CONTROLLER);
    }
}