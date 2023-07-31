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

import { Log } from '../../../utils/Log';
import { PhotoDataSource } from './PhotoDataSource';
import { MediaItem } from './MediaItem';
import { Constants as PhotoConstants } from './Constants';
import { UserFileManagerAccess } from '../../../access/UserFileManagerAccess';
import { ScreenManager } from '../../common/ScreenManager';

const MEDIA_ABILITY = 'dataability';
const URL_TAG = '-UriDataSource';
const TAG: string = 'common_UriDataSource';

class InnerMediaItem extends MediaItem {
  isHttp: boolean;

  constructor(uri: string) {
    //后期需要修改这个接口
    super(undefined);
    this.uri = uri;
    this.width = 0;
    this.height = 0;
    this.isHttp = !uri.startsWith(MEDIA_ABILITY);
  }
}

export class UriDataSource extends PhotoDataSource {
  private mItems: InnerMediaItem[] = [];

  constructor(uriArr: string[]) {
    super()
    this.mItems = uriArr.map((uri) => {
      let item = new InnerMediaItem(uri);
      if (uri.startsWith(MEDIA_ABILITY)) {
        item.setThumbnail(this.photoDataImpl.getThumbnail(item.uri, item.path, {
          height: item.height,
          width: item.width
        }));
      } else {
        item.setThumbnail(item.uri);
      }
      return item;
    })
    Log.debug(TAG, `create items: ${JSON.stringify(this.mItems)}`);
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
    Log.info(TAG, 'registerDataChangeListener');
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    Log.info(TAG, 'unregisterDataChangeListener');
  }
}