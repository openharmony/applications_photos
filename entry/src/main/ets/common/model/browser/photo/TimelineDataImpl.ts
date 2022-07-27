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
import { BrowserDataImpl } from '../BrowserDataImpl'
import { AsyncCallback } from '../../common/AsyncCallback'
import { AlbumDefine } from '../AlbumDefine'
import { TimelineData } from './TimelineData'
import { DateUtil } from '../../../utils/DateUtil';
import { MediaItem } from './MediaItem'

export class TimelineDataImpl extends BrowserDataImpl {
    getData(callback: AsyncCallback<TimelineData[]>, param): void{
        this.logger.info(`loadGroupData start ${param}`);
        if (callback == null) {
            this.logger.info('loadGroupData with empty args');
            return;
        }

        let groupDataList: TimelineData[] = [];
        let start: number = undefined;
        let count: number = undefined;
        if (param) {
            start = param.start;
            count = param.count;
        }
        this.getItems(AlbumDefine.ALBUM_ID_ALL, start, count).then((dataList) => {
            if (dataList != null) {
                if (dataList.length) {
                    let groupCount = 1;
                    let startTime = dataList[0].dateAdded * DateUtil.MILLISECONDS_PER_SECOND; // TODO dateTaken is not supported, use dateAdded
                    let endTime = dataList[0].dateAdded * DateUtil.MILLISECONDS_PER_SECOND;
                    for (let i = 1; i < dataList.length; i++) {
                        let dateTaken = dataList[i].dateAdded * DateUtil.MILLISECONDS_PER_SECOND;
                        if (DateUtil.isTheSameDay(startTime, dateTaken)) {
                            groupCount++;
                            endTime = dateTaken;
                        } else {
                            let groupData = new TimelineData(startTime, endTime, groupCount);
                            groupDataList.push(groupData);
                            groupCount = 1;
                            startTime = dateTaken;
                            endTime = dateTaken;
                        }
                    }
                    let groupData = new TimelineData(startTime, endTime, groupCount);
                    groupDataList.push(groupData);
                } else {
                    this.logger.error(`getGroupData item size: ${groupDataList.length}`);
                }
            }

            callback.callback(groupDataList);
        })
    }

    getDataCount(callback: AsyncCallback<number>, param): void {
        this.getItemsCount(param.id).then((count) => {
            this.logger.info(`getMediaItemCount callback: ${count}`);
            callback.callback(count);
        });
    }

    getDataById(id: any, deviceId?: any): any{
    }

    getDataByName(name: string, albumInfo: any): any{
    }
}