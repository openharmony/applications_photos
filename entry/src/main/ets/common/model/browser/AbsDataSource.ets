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

import {Logger} from '../../utils/Logger'
import {LoadingListener} from './LoadingListener'

// Abs DataSource
export abstract class AbsDataSource implements IDataSource {
    // logger
    logger: Logger = new Logger('AbsDataSource');

    // Last data change time
    lastChangeTime = 0;

    // Last refresh time
    lastUpdateTime = 0;

    // Data change monitoring
    listeners: DataChangeListener[] = [];

    // callbacks
    mCallbacks = {};

    // Is data initialized
    isInitData: boolean;

    // Are there any new data changes
    hasNewChange = false;

    // Freeze data refresh
    isFreezeDataUpdate = false;

    // Whether the page is in the foreground, and the data can be refreshed in the foreground
    isActive = true;

    // Data loading listener
    private loadingListeners: Array<LoadingListener> = new Array<LoadingListener>();

    constructor() {
        this.registerObserver();
    }

    abstract initData(): void;

    abstract loadData(): void;

    abstract totalCount(): number;

    abstract getData(index: number): any;

    initialize(): void {
        if (!this.isInitData) {
            this.initData();
            this.isInitData = true;
        }
    }

    registerDataChangeListener(listener: DataChangeListener): void {
        this.logger.info('registerDataChangeListener');
        if (this.listeners.indexOf(listener) < 0) {
            this.listeners.push(listener);
            this.logger.info(`registerDataChangeListener, add listener, length: ${this.listeners.length}`);
        }
        this.initialize();
    }

    unregisterDataChangeListener(listener: DataChangeListener): void {
        this.logger.info('unregisterDataChangeListener');
        const pos = this.listeners.indexOf(listener);
        if (pos >= 0) {
            this.listeners.splice(pos, 1);
            this.logger.info(`registerDataChangeListener, remove listener, length: ${this.listeners.length}`);
        }
        this.unregisterObserver();
    }

    /**
     * Overall refresh of notification framework
     */
    onDataReloaded(): void {
        if (this.isFreezeDataUpdate) {
            return;
        }
        this.logger.info(`onDataReloaded listeners size ${this.listeners.length}`)
        this.listeners.forEach(listener => {
            listener.onDataReloaded();
        })
    }

    /**
     * Notification frame refresh by index
     *
     * @param layoutIndex index
     */
    onDataChanged(layoutIndex: number): void {
        if (this.isFreezeDataUpdate) {
            return;
        }
        this.listeners.forEach(listener => {
            listener.onDataChanged(layoutIndex);
        })
    }

    /**
     * Delete frame refresh by index
     *
     * @param layoutIndex index
     */
    onDataDeleted(layoutIndex: number): void {
        if (this.isFreezeDataUpdate) {
            return;
        }
        this.listeners.forEach(listener => {
            listener.onDataDeleted(layoutIndex);
        })
    }

    public registerObserver(): void {
    }

    public unregisterObserver(): void {
    }

    registerCallback(name: string, cb: Function) {
        this.mCallbacks[name] = cb;
    }

    unregisterCallback(name) {
        this.mCallbacks[name] = undefined;
    }

    addLoadingListener(listener: LoadingListener): void {
        if (listener == null) {
            this.logger.error('listener is null');
            return;
        }
        if (this.loadingListeners.indexOf(listener) > -1) {
            return;
        }
        this.loadingListeners.push(listener);
    }

    removeLoadingListener(listener: LoadingListener): void {
        if (listener == null) {
            this.logger.error('listener is null');
            return;
        }
        let index = this.loadingListeners.indexOf(listener);
        if (index > -1) {
            this.loadingListeners.splice(index, 1);
        }
    }

    notifyDataChanged(dataIndex: number): void {
        this.logger.debug(`notifyDataChanged,loadingListeners size:${this.loadingListeners.length},index:${dataIndex}`);
        for (let listener of this.loadingListeners) {
            listener.onDataChanged(dataIndex);
        }
    }

    notifyDataLoadingFinished(): void {
        this.logger.info(`notifyDataLoadingFinished, loadingListeners size:${this.loadingListeners.length}`);
        for (let listener of this.loadingListeners) {
            listener.onDataLoadingFinished();
        }
    }

    notifySizeLoadingFinished(size: number): void {
        this.logger.info(`notifySizeLoadingFinished, loadingListeners size: ${this.loadingListeners.length}`);
        for (let listener of this.loadingListeners) {
            listener.onSizeLoadingFinished(size);
        }
    }

    onActive(): void {
        this.logger.info('onActive');
        this.isActive = true;
        if (this.lastUpdateTime < this.lastChangeTime) {
            // Page back to the foreground, if there is a refresh media library reload refresh.
            this.loadData();
        }
    }

    onInActive(): void {
        this.logger.info('onInActive');
        this.isActive = false;
    }

    freeze(): void {
        this.logger.info('freeze')
        this.isFreezeDataUpdate = true;
    }

    unfreeze(): void {
        this.logger.info('unfreeze')
        this.isFreezeDataUpdate = false;
    }

    onChange(mediaType) {
        this.lastChangeTime = Date.now();
        this.logger.debug(`onChange mediaType: ${mediaType} ${this.hasNewChange} ${this.isActive}`);
        if (!this.hasNewChange) {
            this.hasNewChange = true;
            if (this.isActive) {
                this.loadData();
            }
        }
    }
}