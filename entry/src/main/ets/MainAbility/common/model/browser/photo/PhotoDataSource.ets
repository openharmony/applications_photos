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

import {Logger} from '../../../utils/Logger.ets'
import {FifoCache} from './FifoCache'
import {MediaDataSource} from './MediaDataSource.ets'
import {LoadingListener} from '../LoadingListener'
import {BroadCast} from '../../../utils/BroadCast'
import {Constants as PhotoConstants} from './Constants'
import {MediaItem} from './MediaItem'
import {Constants} from '../../common/Constants.ets'
import {PixelMapManager} from '../../common/PixelMapManager'
import {Thumbnail} from './Thumbnail'
import {BrowserDataFactory} from '../interface/BrowserDataFactory.ets';

// DataSource
export class PhotoDataSource implements IDataSource, LoadingListener {
    private logger: Logger = new Logger('PhotoDataSource');
    private albumDataSource: MediaDataSource;
    private broadCast: BroadCast;
    private currentIndex = 0;
    private pixelMapManager: PixelMapManager;

    // Data change listener
    private listeners: DataChangeListener[] = [];
    private fifoCache: FifoCache<Thumbnail> = new FifoCache<Thumbnail>(5);
    private albumName: string = 'Camera'
    private deviceId: string = ''
    private photoDataImpl;

    totalCount(): number {
        let totalCount = this.albumDataSource.mediaCount;
        this.logger.info(`totalCount: ${totalCount}`);
        return totalCount || 0;
    }

    // get DataIndex with item
    getDataIndex(item: MediaItem): number {
        return this.albumDataSource.getDataIndex(item);
    }

    constructor(albumName?: string) {
        this.logger.info('bind onMessage.');
        this.pixelMapManager = PixelMapManager.getInstance();
        this.fifoCache = this.pixelMapManager.getFifoCache();
        if (albumName) {
            this.albumName = albumName;
        }

        this.photoDataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_ALBUM);
    }

    setAlbumName(albumName: string) {
        this.albumName = albumName;
    }

    setDeviceId(deviceId: string) {
        this.deviceId = deviceId;
    }

    releaseCache(key: string): void {
        this.fifoCache.release(key);
    }

    initData() {
        let dataSource: MediaDataSource = new MediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
        dataSource.setAlbumName(this.albumName);
        dataSource.initData();
        this.setAlbumDataSource(dataSource);
    }

    // LazyForEach call
    getData(index: number): any {
        this.logger.info(`getData index ${index}`);
        this.albumDataSource.updateSlidingWindow(index);
        let mediaItem: MediaItem = this.albumDataSource.getRawData(index);
        let thumbnail: Thumbnail = this.fifoCache.get(mediaItem.uri);
        if (thumbnail != undefined && thumbnail != null) {
            this.logger.info(`thumbnail exists, uri: ${mediaItem.uri}, thumbnail: ${JSON.stringify(thumbnail)}`);
            return {
                data: mediaItem,
                pos: index,
                thumbnail: thumbnail
            };
        } else {
            this.logger.info(`thumbnail does not exists, uri: ${mediaItem.uri}, try to load pixelmap`)
            this.loadBmp(mediaItem, index);
            return {
                data: mediaItem,
                pos: index,
                thumbnail: new Thumbnail(undefined, 0, 0)
            };
        }
    }

    updatePixMapDataSource(index: number): void {
        this.currentIndex = index;
        // cache load.
    }

    getRawData(index: number): any {
        return {
            data: this.albumDataSource.getRawData(index),
            pos: index
        };
    }

    registerDataChangeListener(listener: DataChangeListener): void {
        this.logger.info('registerDataChangeListener');
        this.albumDataSource && this.albumDataSource.registerObserver();
        if (this.albumDataSource.listeners.indexOf(listener) < 0) {
            this.albumDataSource.listeners.push(listener);
        }
        this.logger.debug(`listener size: ${this.albumDataSource.listeners.length}`);
    }

    unregisterDataChangeListener(listener: DataChangeListener): void {
        this.logger.info('unregisterDataChangeListener');
        const pos = this.albumDataSource.listeners.indexOf(listener);
        if (pos >= 0) {
            this.albumDataSource.listeners.splice(pos, 1);
        }
        this.logger.debug(`unregisterDataChangeListener listener size: ${this.albumDataSource.listeners.length}`);
    }

    setAlbumDataSource(albumDataSource: MediaDataSource): void {
        this.logger.info('setAlbumDataSource');
        this.albumDataSource = albumDataSource;
        this.albumDataSource.addLoadingListener(this);
    }

    setBroadCast(broadCastParam: BroadCast): void {
        this.broadCast = broadCastParam;
    }

    setBroadCastToAlbum(broadCastParam: BroadCast) {
        this.albumDataSource.setPhotoBroadCast(broadCastParam);
    }

    onDataReloaded() {
        this.logger.info(`onDataReloaded start`);
        this.albumDataSource.onDataReloaded();
    }

    onSizeLoadingFinished(size: number): void {
        this.logger.info(`onSizeLoadingFinished, current size: ${size}`);
        this.broadCast && this.broadCast.emit(PhotoConstants.DATA_SIZE_CHANGED, [size]);
    }

    onDataLoadingFinished(): void {
        // after the mediaLib updates the data, it directly calls onDataReloaded.
        // swiper updates only the five mounted items
        this.logger.info(`onDataLoadingFinished listeners size: ${this.albumDataSource.listeners.length}\
            totalCount: ${this.totalCount()}`);
        this.broadCast && this.broadCast.emit(PhotoConstants.DATA_CONTENT_CHANGED, []);
    }

    onDataChanged(dataIndex: number): void {
        this.albumDataSource.listeners.forEach(listener => {
            listener.onDataChanged(dataIndex);
        })
    }

    deleteData(index: number) {
        this.albumDataSource.listeners.forEach(listener => {
            this.logger.info('onDataDeleted');
            listener.onDataDeleted(index);
        })
    }

    private async loadBmp(mediaItem: MediaItem, index: number) {
        let uri = mediaItem.uri;
        this.fifoCache.addPendingPixmap(uri)
        let orientation = mediaItem.orientation || 0;
        let imgWidth = orientation == 0 || orientation == PhotoConstants.ROTATE_TWICE ? mediaItem.width : mediaItem.height;
        let imgHeight = orientation == 0 || orientation == PhotoConstants.ROTATE_TWICE ? mediaItem.height : mediaItem.width;
        let fileAsset = await this.photoDataImpl.getObjectById(mediaItem.id, this.deviceId, (this.albumName == 'Recycle'));
        if (fileAsset == null || fileAsset == undefined) {
            this.logger.error('fileAsset is null');
            return;
        }
        this.logger.debug(`fileId: ${fileAsset.id} getThumbnail begin size: ${mediaItem.height} x ${mediaItem.width}`);
        let resultThumbnail = await this.photoDataImpl.getThumbnail(fileAsset, {height: imgHeight, width: imgWidth});
        this.logger.debug(`getThumbnail height ${mediaItem.height} width ${mediaItem.width}`);
        this.fifoCache.set(uri, new Thumbnail(resultThumbnail, mediaItem.width, mediaItem.height));
        this.onDataChanged(index);
    }

    public release(): void {
        this.fifoCache.releaseAll()
        this.albumDataSource.releasePhotoBroadCast();
        this.albumDataSource.removeLoadingListener(this);
        // cancel the mediaLibrary listening of albumDataSource when the large image is destroyed.
        // cannot cancel it in unregisterDataChangeListener
        this.albumDataSource && this.albumDataSource.unregisterObserver();
    }
}