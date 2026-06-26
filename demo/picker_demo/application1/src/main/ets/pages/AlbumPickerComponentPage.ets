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
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy {
  PhotoPickerComponent,
  PickerController,
  PickerOptions,
  ItemInfo,
  PhotoBrowserInfo,
  ItemType,
  ClickType,
  MaxCountType,
  BaseItemInfo,
  SaveMode,
} from '@ohos.file.PhotoPickerComponent';
import lazy { AlbumPickerComponent, AlbumPickerOptions, AlbumInfo } from '@ohos.file.AlbumPickerComponent';
import lazy { common } from '@kit.AbilityKit';
import lazy { AsyncCallback } from '@kit.BasicServicesKit';

import lazy { fileUri } from '@kit.CoreFileKit';

@Entry
@Component
struct AlbumPickerComponentPage {
  private context = getContext(this) as common.UIAbilityContext;
  @State pickerController: PickerController = new PickerController();
  pickerOptions: PickerOptions = new PickerOptions();
  albumOptions: AlbumPickerOptions = new AlbumPickerOptions();
  @State selectedUris: string[] = [];
  @State allBackGroundColor: number = 0xf1f3f5;
  @State videoBackGroundColor: number = 0xffffff;
  @State photoBackGroundColor: number = 0xffffff;
  @State isShowAll: boolean = true;
  @State isShowVideo: boolean = false;
  @State isShowPhoto: boolean = false;
  @State pickerWidth: string = '100%';
  @State pickerHeight: string = '87%';
  @State isShowAlbum: boolean = false;
  private isBlock: boolean = false;
  @State isInPhotoBrowser: boolean = false;
  @State isShow: boolean = true;
  @State text: string = '';
  @State titlebar: string = '所有相册';
  @State originUrl: string = '';
  @State replaceUrl: string = '';
  @State imageUrl: string = '';
  @State trustedUris: string[] = [];
  selectFlag: boolean = true;
  selectCount: number = 0;

  private onEnterPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    this.isInPhotoBrowser = true;
    this.context.resourceDir;
    return false;
  }

  private onExitPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    this.isInPhotoBrowser = false;
    return false;
  }

  private onPickerControllerReady(): void {
    this.isShow = false;
  }

  private onAlbumClick(albumInfo: AlbumInfo): boolean {
    this.isShowAlbum = false;
    return true;
  }

  private onSelect(uri: string): void {
    this.pickerOptions.preselectedUris = [...this.selectedUris];
    this.originUrl = uri;
  }

  private onDeselect(uri: string): void {
    this.pickerOptions.preselectedUris = [...this.selectedUris];
  }

  private onItemClicked(itemInfo: ItemInfo, clickType: ClickType): boolean {
    if (!itemInfo) {
      return false;
    }
    let type: ItemType | undefined = itemInfo.itemType;
    let uri: string | undefined = itemInfo.uri;
    if (type === ItemType.CAMERA) {
      return true;
    } else if (type === ItemType.THUMBNAIL) {
      if (clickType === ClickType.SELECTED) {
        if (this.isBlock) {
          return false;
        }
        if (uri) {
          this.selectedUris.push(uri);
          this.pickerOptions.preselectedUris = [...this.selectedUris];
        }
      } else {
        if (uri) {
          this.selectedUris = this.selectedUris.filter((item: string) => {
            return item !== uri;
          })
          this.pickerOptions.preselectedUris = [...this.selectedUris];
        }
      }
    } else {
    }
    return true;
  }

  private onSelectedItemsDeleted(baseItemInfos: Array<BaseItemInfo>): void {
    for (let info of baseItemInfos) {
      if (info?.uri) {
        this.selectedUris = this.selectedUris.filter((item: string) => {
          return info?.uri != item;
        })
      }
    }
  }

  private onExceedMaxSelected(exceedMaxCountType: MaxCountType): void {
  }

  private onCurrentAlbumDeleted(): void {
    this.titlebar = '所有相册';
  }

  aboutToAppear() {
    this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    this.pickerOptions.isPreviewForSingleSelectionSupported = false;
    this.pickerOptions.isSlidingSelectionSupported = false;
    this.pickerOptions.isRepeatSelectSupported = false;
  }

  @State fontColor: string = '#182431222';
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController();

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
        .zIndex(1)
      Divider()
        .strokeWidth(2)
        .opacity(this.currentIndex === index ? 1 : 0)
    }.width('100%')
  }

  handle(callback: AsyncCallback<number>): Promise<number> {
    let num = 1
    return new Promise((resolve, reject) => {
      if (num == 1) {
        resolve(100);
      } else {
        reject(100);
      }
    })
  }

  build() {
    Row() {
      Stack() {
        Column() {
          Row() {
            Button('另存为')
              .width('25%')
              .height('50%')
              .margin({ top: 10 })
              .onClick(() => {
                let replaceUris: string[] = [];
                this.trustedUris.forEach((uri: string) => {
                  replaceUris.push(uri);
                });
                this.trustedUris.splice(0, this.trustedUris.length);
                this.pickerController.saveTrustedPhotoAssets(replaceUris, (a, b) => {
                }, undefined, SaveMode.SAVE_AS);
              })
              .margin(10)

            Button('覆盖保存')
              .width('25%')
              .height('50%')
              .margin({ top: 10 })
              .onClick(() => {
                let replaceUris: string[] = [];
                this.trustedUris.forEach((uri: string) => {
                  replaceUris.push(uri);
                });
                this.trustedUris.splice(0, this.trustedUris.length);
                this.pickerController.saveTrustedPhotoAssets(replaceUris, (a, b) => {
                }, undefined, SaveMode.OVERWRITE);
              })
              .margin(10)

            Button('replace url')
              .width('25%')
              .height('50%')
              .margin({ top: 10 })
              .onClick(() => {
                let mediaType = this.originUrl.split('.')[this.originUrl.split('.').length - 1];
                let boxPath = this.getReplaceUri(mediaType);
                this.trustedUris.push(boxPath);
                this.pickerController.replacePhotoPickerPreview(this.originUrl, boxPath, (a, b) => {
                })
              })
              .margin(10)
          }.height(this.pickerHeight).width(this.pickerWidth).defaultFocus(true)

          Row() {
            ForEach(this.selectedUris, (uri: string) => {
              Image(uri).height('95%').width('20%').backgroundColor(this.allBackGroundColor).onClick(() => {
              })
            }, (uri: string) => JSON.stringify(uri))
          }.width('100%').height('15%')

          Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
            TabContent() {
              PhotoPickerComponent({
                pickerOptions: this.pickerOptions,
                onSelect: (uri: string): void => this.onSelect(uri),
                onDeselect: (uri: string): void => this.onDeselect(uri),
                onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean => this.onItemClicked(itemInfo,
                  clickType),
                onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                this.onEnterPhotoBrowser(photoBrowserInfo),
                onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                this.onExitPhotoBrowser(photoBrowserInfo),
                onPickerControllerReady: (): void => this.onPickerControllerReady(),
                onSelectedItemsDeleted: (baseItemInfos: Array<BaseItemInfo>): void =>
                this.onSelectedItemsDeleted(baseItemInfos),
                onExceedMaxSelected: (maxCountType: MaxCountType): void => this.onExceedMaxSelected(maxCountType),
                onCurrentAlbumDeleted: (): void => this.onCurrentAlbumDeleted(),
                pickerController: this.pickerController,
              }).height(this.height).width(this.width).defaultFocus(true)
            }.tabBar(this.tabBuilder(0, '全部'))
          }
          .vertical(false)
          .barMode(BarMode.Fixed)
          .barWidth('100%')
          .barHeight(56)
          .animationDuration(100)
          .onChange((index: number) => {
            if (index === 1) {
              this.isShow = true;
            }
            this.currentIndex = index;
          })
          .width('100%')
          .height('84%')
          .backgroundColor('#F1F3F5')
          .scrollable(!this.isInPhotoBrowser)
        }.width('100%').height('100%')

        if (this.isShowAlbum) {
          AlbumPickerComponent({
            albumPickerOptions: this.albumOptions,
            onAlbumClick: (albumInfo: AlbumInfo): boolean => this.onAlbumClick(albumInfo),
          }).height('100%').width('100%')
        }
      }
    }
  }

  private getReplaceUri(mediaType: string) {
    let boxPath = fileUri.getUriFromPath(this.context.filesDir + '/test1.jpg');
    if (this.selectCount === 0) {
      if (mediaType === 'mp4') {
        boxPath = fileUri.getUriFromPath(this.context.filesDir + '/file1.mp4');
      } else {
        boxPath = fileUri.getUriFromPath(this.context.filesDir + '/test1.jpg');
      }
      this.selectCount++;
    } else if (this.selectCount === 1) {
      if (mediaType === 'mp4') {
        boxPath = fileUri.getUriFromPath(this.context.filesDir + '/file2.mp4');
      } else {
        boxPath = fileUri.getUriFromPath(this.context.filesDir + '/test2.jpg');
      }
      this.selectCount++;
    } else if (this.selectCount === 2) {
      if (mediaType === 'mp4') {
        boxPath = fileUri.getUriFromPath(this.context.filesDir + '/file3.mp4');
      } else {
        boxPath = fileUri.getUriFromPath(this.context.filesDir + '/test3.jpg');
      }
      this.selectCount++;
    } else if (this.selectCount === 3) {
      if (mediaType === 'mp4') {
        boxPath = fileUri.getUriFromPath(this.context.filesDir + '/file4.mp4');
      } else {
        boxPath = fileUri.getUriFromPath(this.context.filesDir + '/test4.jpg');
      }
      this.selectCount++;
    } else if (this.selectCount === 4) {
      if (mediaType === 'mp4') {
        boxPath = fileUri.getUriFromPath(this.context.filesDir + '/file5.mp4');
      } else {
        boxPath = fileUri.getUriFromPath(this.context.filesDir + '/test5.jpg');
      }
      this.selectCount++;
    } else if (this.selectCount === 5) {
      if (mediaType === 'mp4') {
        boxPath = fileUri.getUriFromPath(this.context.filesDir + '/file6.mp4');
      } else {
        boxPath = fileUri.getUriFromPath(this.context.filesDir + '/test6.jpg');
      }
      this.selectCount = 0;
    }
    return boxPath;
  }
}