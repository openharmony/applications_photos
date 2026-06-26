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
import lazy { BrowserController } from '@ohos/common/src/main/ets/default/view/BrowserController';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { ActionBarController } from '@ohos/common/src/main/ets/default/view/ActionBarController';
import lazy { MediaDataSource } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaDataSource';
import lazy {
  UnionAlbumMediaDataSource
} from '@ohos/common/src/main/ets/default/model/browser/photo/UnionAlbumMediaDataSource'
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy {
  SelectManager,
  TimelineSelectManager
} from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { AlbumDataSource } from '@ohos/common/src/main/ets/default/model/AlbumDataSource';
import lazy { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { PhotosHmBrowserController } from '@ohos/browserlibrary';

import lazy { BindSheetController } from '@ohos/timeline/src/main/ets/albumgrid/view/AlbumPhotoGridView';
import lazy { AlbumTabletGirdLoader } from './AlbumTabletGirdLoader';

/* instrument ignore file */
const TAG = 'PhotoGridViewBuilder';

@Component
export struct PhotoGridViewBuilder {
  @Prop private isShowPhotoGridView: boolean;
  @Prop private pageStatus: boolean = false;
  @Consume private browserController: PhotosHmBrowserController;
  @Link private isSelectedMode: boolean;
  @State actionBarController: ActionBarController = new ActionBarController();
  private dataSource?: MediaDataSource;
  private importDataSource?: MediaDataSource;
  private mSelectManager: SelectManager = new SelectManager();
  @State private isUnionAlbumPage: boolean = false;
  @Link private navigationPageInfos: NavPathStack;
  @State useOldPhotoGridView: boolean = false

  aboutToAppear() {
    this.checkUseOldPhotoGridView()
    this.refreshPhotoGridView();
  }

  private checkUseOldPhotoGridView(): void {
    let params: object | undefined = AppStorage.get(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM);
    if (params && params['item']) {
      try {
        let item: object | undefined = JSON.parse(params['item']);
        if (item &&
          (Number(item?.['subType']) === Number(photoAccessHelper.AlbumSubtype.SHOOTING_MODE) ||
            item?.['subType']) === Number(photoAccessHelper.AlbumSubtype.CLASSIFY)) {
          this.useOldPhotoGridView = true;
          Log.info(TAG, `useOldPhotoGridView${this.useOldPhotoGridView}`)
        } else {
          this.useOldPhotoGridView = false;
          Log.info(TAG, `useOldPhotoGridView${this.useOldPhotoGridView}`)
        }
      } catch (e) {
        this.useOldPhotoGridView = false;
        Log.info(TAG, `useOldPhotoGridView${this.useOldPhotoGridView}`)
      }
    }
  }

  private isAlbumSupported(item: object | undefined): boolean {
    if (Number(item?.['subType']) === Number(photoAccessHelper.AlbumSubtype.SHOOTING_MODE) ||
      Number(item?.['subType']) === Number(photoAccessHelper.AlbumSubtype.USER_GENERIC) ||
      Number(item?.['subType']) === Number(photoAccessHelper.AlbumSubtype.SOURCE_GENERIC) ||
      Number(item?.['subType']) === Number(photoAccessHelper.AlbumSubtype.FAVORITE) ||
      Number(item?.['subType']) === Number(photoAccessHelper.AlbumSubtype.VIDEO) ||
      Number(item?.['subType']) === Number(photoAccessHelper.AlbumSubtype.SCREENSHOT) ||
      Number(item?.['subType']) === Number(photoAccessHelper.AlbumSubtype.CAMERA) ||
      Number(item?.['subType']) === Number(photoAccessHelper.AlbumSubtype.IMAGE) ||
      Number(item?.['subType']) === Number(photoAccessHelper.AlbumSubtype.GEOGRAPHY_LOCATION)) {
      return true;
    } else {
      return false;
    }
  }

  private refreshPhotoGridView(): void {
    this.importDataSource = undefined;
    let params: object | undefined = AppStorage.get(Constants.KEY_OF_PHOTO_GRID_VIEW_ALBUM_ITEM);
    if (params && params['item']) {
      let item: object | undefined = JSON.parse(params['item']);
      try {
        if (this.isAlbumSupported(item)) {
          Log.info(TAG, 'trash or shoot album create AlbumDataSource');
          this.importDataSource = new AlbumDataSource({
            context: getContext(),
            albumInfo: item as AlbumInfo,
            isAccurateNotify: true,
          });
          if (Number(item?.['subType']) === Number(photoAccessHelper.AlbumSubtype.SHOOTING_MODE)) {
            this.mSelectManager = new TimelineSelectManager();
            this.mSelectManager.setPhotoDataImpl();
          } else {
            this.mSelectManager.setPhotoDataImpl();
          }
          return;
        }
      } catch (err) {
        Log.error(TAG, `trash album create AlbumDataSource error: ${JSON.stringify(err)}`);
      }


      if (!item || !item['isSourceAlbum'] || !item['unionAlbumUris'] || !(item['unionAlbumUris'] instanceof Array) ||
        item['unionAlbumUris'].length === 0) {
        // using PhotoGridView default dataSource
        this.dataSource = undefined;
        this.isUnionAlbumPage = false;
        this.mSelectManager.setPhotoDataImpl();
        return;
      }
      Log.info(TAG, 'It is an union album, create UnionAlbumMediaDataSource');
      let newDataSource: UnionAlbumMediaDataSource = new UnionAlbumMediaDataSource(Constants.DEFAULT_SLIDING_WIN_SIZE);
      newDataSource.setAlbumUris(item['unionAlbumUris']);
      newDataSource.isUnionAlbum = true;
      this.dataSource = newDataSource;
      this.isUnionAlbumPage = true;
      this.mSelectManager.setPhotoDataImpl(newDataSource.unionPhotoDataImpl);
      return;
    }
    this.dataSource = undefined;
  }

  @State bindSheetController: BindSheetController = new BindSheetController();

  build() {
    Column() {
      AlbumTabletGirdLoader({
        pageStatus: this.pageStatus,
        actionBarController: this.actionBarController,
        isLevelOneHeadTitle: true,
        isSelectedMode: this.isSelectedMode,
        dataSource: this.dataSource,
        importDataSource: this.importDataSource,
        mSelectManager: this.mSelectManager,
        isUnionAlbumPage: this.isUnionAlbumPage,
        bindSheetController: this.bindSheetController,
        navPathStack: this.navigationPageInfos,
      })
    }
    .transition(TransitionEffect.opacity(0.99))
    .focusable(this.isShowPhotoGridView)
    .visibility(!this.browserController.isBrowserShow &&
      !this.browserController.isSelectBrowserShow ? Visibility.Visible : Visibility.Hidden)
  }
}