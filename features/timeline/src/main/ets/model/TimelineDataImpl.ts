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
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { WindowConstants } from '@ohos/base/src/main/ets/constants/WindowConstants';
import mediaModel from '@ohos/base/src/main/ets/model/MediaModel';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';
import { TimelineDataItem } from '../data/TimelineDataItem';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';

const TAG = "TimelineDataImpl"

export class TimelineDataImpl {
    async getTimelineItemData(): Promise<TimelineDataItem[]> {
        Log.info(TAG, "getTimelineItemData");
        let fileAssets: Array<MediaLib.FileAsset> = await this.getTimelineItemFileAssets();

        let count = this.getCount();
        let mediaFileAsset: Array<MediaLib.FileAsset> = await this.getMediaItemFileAssets(0, count);
        let itemGroup: TimelineDataItem[] = [];
        let index = 0;
        fileAssets.forEach((fileAsset: MediaLib.FileAsset) => {
            let item: TimelineDataItem = new TimelineDataItem(fileAsset, mediaFileAsset, index);
            index += item.groupChild.length;
            itemGroup.push(item);
        })

        // do not use await to avoid load cost too much time
        this.loadReset(itemGroup, count);
        return itemGroup;
    }

    private async getTimelineItemFileAssets(): Promise<MediaLib.FileAsset[]> {
        let selections: string = MediaLib.FileKey.MEDIA_TYPE + ' = ? or ' + MediaLib.FileKey.MEDIA_TYPE + ' = ?';
        let selectionArgs: Array<string> = [MediaLib.MediaType.IMAGE.toString(), MediaLib.MediaType.VIDEO.toString()];
        let fetchOption: MediaLib.MediaFetchOptions = {
            selections: selections,
            selectionArgs: selectionArgs,
            extendArgs: 'DATE(date_added,"unixepoch")',
            order: `date_added DESC`
        };
        return await mediaModel.getAllMediaItems(fetchOption);
    }

    private async getMediaItemFileAssets(start: number, count: number): Promise<MediaLib.FileAsset[]> {
        let selections: string = MediaLib.FileKey.MEDIA_TYPE + ' = ? or ' + MediaLib.FileKey.MEDIA_TYPE + ' = ?';
        let selectionArgs: Array<string> = [MediaLib.MediaType.IMAGE.toString(), MediaLib.MediaType.VIDEO.toString()];
        let fetchOption: MediaLib.MediaFetchOptions = {
            selections: selections,
            selectionArgs: selectionArgs,
            order: `date_added DESC LIMIT ${start},${count}`
        };
        return await mediaModel.getAllMediaItems(fetchOption);
    }

    private getCount(): number {
        let sideBarWidth = screenManager.isSidebar() ? WindowConstants.TAB_BAR_WIDTH : 0;
        let contentWidth = screenManager.getWinWidth() - sideBarWidth;
        let maxThumbWidth = px2vp(WindowConstants.GRID_IMAGE_SIZE) * WindowConstants.GRID_MAX_SIZE_RATIO;
        let columns = Math.max(WindowConstants.GRID_MIN_COUNT, Math.ceil((contentWidth + WindowConstants.GRID_GUTTER) / (maxThumbWidth + WindowConstants.GRID_GUTTER)));
        let contentHeight = screenManager.getWinHeight() - WindowConstants.ACTION_BAR_HEIGHT - screenManager.getNaviBarHeight();
        let rows = Math.ceil((contentHeight + WindowConstants.GRID_GUTTER) / (maxThumbWidth + WindowConstants.GRID_GUTTER)) + 4;
        return columns * rows
    }

    private async loadReset(itemGroup: TimelineDataItem[], count) {
        let items: MediaDataItem[] = [];
        itemGroup.forEach((group: TimelineDataItem) => {
            group.groupChild.forEach((child: MediaDataItem) => {
                items.push(child);
            })
        })
        let itemLen = items.length;
        let countLen = Math.ceil(itemLen / count);
        for (let i = 1;i < countLen; i++) {
            let mediaFileAsset: Array<MediaLib.FileAsset> = await this.getMediaItemFileAssets(i * count, count)
            for (let j = 0;j < count; j++) {
                if (i * count + j >= itemLen) {
                    return;
                }
                items[i * count+j].update(mediaFileAsset[j]);
            }
        }
    }
}