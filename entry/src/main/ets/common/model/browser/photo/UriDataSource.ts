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

import { Logger } from '../../../utils/Logger'
import { PhotoDataSource } from './PhotoDataSource';
import { MediaItem } from './MediaItem'
import { Constants as PhotoConstants } from './Constants'
import { MediaLibraryAccess } from '../../../access/MediaLibraryAccess';
import { ScreenManager } from '../../common/ScreenManager'

class InnerMediaItem extends MediaItem {
    static readonly MEDIA_ABILITY = 'dataAbility';
    isHttp: boolean;

    constructor(uri: string) {
        super({
            id: 0,
            mediaType: MediaLibraryAccess.MEDIA_TYPE_IMAGE,
            uri: uri,
            duration: 0,
            title: "",
            size: PhotoConstants.DEFAULT_SIZE,
            thumbnail: uri,
            dateTaken: 0,
            dateModified: 0,
            orientation: 0,
            width: vp2px(ScreenManager.getInstance().getWinWidth()),
            height: vp2px(ScreenManager.getInstance().getWinHeight()),
            isFavor: false,
            type: "",
            displayName: "",
            filePath: uri,
            path: uri
        })
        this.isHttp = !uri.startsWith(InnerMediaItem.MEDIA_ABILITY);
    }
}

export class UriDataSource extends PhotoDataSource {
    protected logger: Logger = new Logger('UriDataSource');
    private mItems: InnerMediaItem[] = [];
    private static readonly URL_TAG = '-UriDataSource';

    constructor(uriArr: string[]) {
        super()
        this.mItems = uriArr.map((uri) => {
            let item = new InnerMediaItem(uri);
            if (uri.startsWith(InnerMediaItem.MEDIA_ABILITY)) {
                item.setThumbnail(this.photoDataImpl.getThumbnail(item.uri, {
                    height: item.height,
                    width: item.width
                }));
            } else {
                item.setThumbnail(item.uri);
            }
            item.uri = item.uri + UriDataSource.URL_TAG;
            return item;
        })
        this.logger.debug(`create items: ${JSON.stringify(this.mItems)}`);
    }

    initData() {
    }

    totalCount(): number {
        return this.mItems.length;
    }

    getData(index: number): {
        data: MediaItem,
        pos: number,
        thumbnail: string
    } {
        return {
            data: this.mItems[index],
            pos: index,
            thumbnail: this.mItems[index].thumbnail
        };
    }

    getRawData(index: number): any {
        return {
            data: index < this.mItems.length ? this.mItems[index] : new MediaItem(null),
            pos: index
        };
    }

    registerDataChangeListener(listener: DataChangeListener): void {
        this.logger.info('registerDataChangeListener');
    }

    unregisterDataChangeListener(listener: DataChangeListener): void {
        this.logger.info('unregisterDataChangeListener');
    }
}