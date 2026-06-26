/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import lazy { MediaDataSource } from '../../model/browser/photo/MediaDataSource';
import lazy { Log } from '../../utils/Log';

export enum GridViewMode {
  /**
   * 宫格模式
   */
  GRID = 1,
  /**
   * 分组模式
   */
  GROUP
}

export class PhotoGridViewConstants {
  public static readonly EVENT_KEY_SHOW_GRID_VIEW: string = 'com.ohos.photos_PhotoGridView_show_grid_view';
  /**
   * 首页场景用的PhotoGridView控制器，存到LocalStorage的key
   */
  public static readonly KEY_INDEX_GRID_VIEW_CONTROLLER: string =
    'com.ohos.photos_index_photo_grid_view_controller';
}

@Observed
export class PhotoGridViewController {
  public isShow: boolean = false;
  public dataSource: MediaDataSource | undefined = undefined;
  public setIsShow(tag: string, scene: string, before: boolean, after: boolean): void {
    this.isShow = after;
    Log.info(tag, `is show photo grid view: ${before}->${after}, scene: ${scene}`);
  }
}