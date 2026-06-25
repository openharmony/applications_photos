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
  DataType,
  ItemInfo,
  PhotoBrowserInfo,
  AnimatorParams,
  MaxSelected,
  ItemType,
  ClickType,
  PickerOrientation,
  SelectMode,
  PickerColorMode,
  ReminderMode,
  MaxCountType,
} from '@ohos.file.PhotoPickerComponent';
import lazy { AlbumPickerComponent, AlbumPickerOptions, AlbumInfo } from '@ohos.file.AlbumPickerComponent';
import lazy { cameraPicker as picker } from '@kit.CameraKit';
import lazy { camera } from '@kit.CameraKit';
import lazy { common } from '@kit.AbilityKit';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { fileIo } from '@kit.CoreFileKit';

let mContext = getContext(this) as common.Context;
let flag: number = 0;

@Entry
@Component
struct NewPhotoPickerComponent {
  @State pickerController: PickerController = new PickerController();
  pickerOptions: PickerOptions = new PickerOptions();
  pickerOptions1: PickerOptions = new PickerOptions();
  pickerOptions2: PickerOptions = new PickerOptions();
  pickerOptions0: PickerOptions = new PickerOptions();
  albumOptions: AlbumPickerOptions = new AlbumPickerOptions();
  @State selectedUris: Array<string> = [];
  @State allBackGroundColor: number = 0xf1f3f5;
  @State videoBackGroundColor: number = 0xffffff;
  @State photoBackGroundColor: number = 0xffffff;
  @State isShowAll: boolean = true;
  @State isShowVideo: boolean = false;
  @State isShowPhoto: boolean = false;
  @State pickerWidth: string = '100%';
  @State pickerHeight: string = '87%';
  @State isShowAlbum: boolean = true;
  private isBlock: boolean = false;
  @State isInPhotoBrowser: boolean = false;
  @State isShow: boolean = true;
  @State text: string = '';
  flag2: boolean = false;
  @State fontColor: string = '#182431222'
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  private tabsController: HdsTabsController = new HdsTabsController();

  private onEnterPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    this.isInPhotoBrowser = true;
    console.info('onEnterPhotoBrowser' + JSON.stringify(photoBrowserInfo));
    return false;
  }

  private onExitPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    this.isInPhotoBrowser = false;
    console.info('onExitPhotoBrowser' + JSON.stringify(photoBrowserInfo));
    return false;
  }

  private onPickerControllerReady(): void {
    this.isShow = false;
    console.info('onPickerControllerReady');
  }

  private onAlbumClick(albumInfo: AlbumInfo): boolean {
    this.isShowAlbum = false;
    this.text = albumInfo?.albumName ? albumInfo?.albumName : '';
    console.info('onAlbumClick' + JSON.stringify(albumInfo?.albumName));
    if (albumInfo?.uri) {
      this.pickerController.setData(DataType.SET_ALBUM_URI, albumInfo.uri);
      console.info('onAlbumClick' + JSON.stringify(albumInfo.uri));
    }
    return true;
  }

  private onSelect(uri: string): void {
    this.pickerOptions.preselectedUris = [...this.selectedUris];
    this.pickerOptions1.preselectedUris = [...this.selectedUris];
    this.pickerOptions2.preselectedUris = [...this.selectedUris];
    this.pickerOptions0.preselectedUris = [...this.selectedUris];
    console.info('onSelect ' + JSON.stringify(this.selectedUris));
  }

  private onDeselect(uri: string): void {
    this.pickerOptions.preselectedUris = [...this.selectedUris];
    this.pickerOptions1.preselectedUris = [...this.selectedUris];
    this.pickerOptions2.preselectedUris = [...this.selectedUris];
    this.pickerOptions0.preselectedUris = [...this.selectedUris];
    console.info('onDeselect ' + JSON.stringify(this.selectedUris));
  }

  private onItemClicked(itemInfo: ItemInfo, clickType: ClickType): boolean {
    if (!itemInfo) {
      return false;
    }
    console.log('itemInfo: ' + JSON.stringify(itemInfo));
    let type: ItemType | undefined = itemInfo.itemType;
    let uri: string | undefined = itemInfo.uri;
    if (type === ItemType.CAMERA) {
      console.info('onCameraClick enter');
      try {
        let pickerProfile: picker.PickerProfile = {
          cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK,
        };
        console.info('try camera enter');
        picker.pick(mContext,
          [picker.PickerMediaType.PHOTO, picker.PickerMediaType.VIDEO], pickerProfile).then((result) => {
          console.log(`result=${result}`);
          let pickerResult: picker.PickerResult = result;
          console.log(`pickerResult=${pickerResult},22=${JSON.stringify(pickerResult)}`);
        });
        console.log('camera success');
      } catch (error) {
        let err = error as BusinessError;
        console.error(`the pick call failed. error code: ${err.code}`);
      }
      console.log(`this.selectedUris 00:${this.selectedUris}`);
      return false;
    } else if (type === ItemType.THUMBNAIL) {
      if (clickType === ClickType.SELECTED) {
        console.info('uri: ' + JSON.stringify(uri));
        if (this.isBlock) {
          return false;
        }

        if (uri) {
          this.selectedUris.push(uri)
          this.pickerOptions.preselectedUris = [...this.selectedUris];
          this.pickerOptions1.preselectedUris = [...this.selectedUris];
          this.pickerOptions2.preselectedUris = [...this.selectedUris];
          this.pickerOptions0.preselectedUris = [...this.selectedUris];
        }
      } else {
        if (uri) {
          this.selectedUris = this.selectedUris.filter((item: string) => {
            return item !== uri;
          })
          this.pickerOptions.preselectedUris = [...this.selectedUris];
          this.pickerOptions1.preselectedUris = [...this.selectedUris];
          this.pickerOptions2.preselectedUris = [...this.selectedUris];
          this.pickerOptions0.preselectedUris = [...this.selectedUris];
        }
      }
      console.log(`this.selectedUris 1:${this.selectedUris}`);
    } else {
      console.log(`this.selectedUris 2:${this.selectedUris}`);
    }
    console.info('onItemClicked ' + JSON.stringify(itemInfo));
    return true;
  }

  private onSelectedItemsDeleted(itemInfos: Array<ItemInfo>): void {
    console.info('onSelectedItemsDeleted ' + JSON.stringify(itemInfos));
  }

  private onExceedMaxSelected(maxCountType: MaxCountType): void {
    console.info('onExceedMaxSelected ' + JSON.stringify(maxCountType));
  }

  private onCurrentAlbumDeleted(): void {
    console.info('onExceedMaxSelected ');
  }

  private onEmptyAreaClick(): void {
    console.info('onEmptyAreaClick ');
    console.info('onEmptyAreaClick ');
  }

  aboutToAppear() {
    this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    this.pickerOptions.maxSelectNumber = 99;
    this.pickerOptions.maxVideoSelectNumber = 1;

    this.pickerOptions.isPreviewForSingleSelectionSupported = false;
    this.pickerOptions.isSlidingSelectionSupported = true;
    this.pickerOptions.isRepeatSelectSupported = true;
    this.pickerOptions.maxSelectedReminderMode = ReminderMode.MASK
    this.pickerOptions1.MIMEType = photoAccessHelper.PhotoViewMIMETypes.MOVING_PHOTO_IMAGE_TYPE;
    this.pickerOptions1.maxSelectNumber = 5;
    this.pickerOptions1.isRepeatSelectSupported = false;
    this.pickerOptions1.maxSelectedReminderMode = ReminderMode.MASK

    this.pickerOptions0.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE;
    this.pickerOptions0.maxSelectNumber = 99;
    this.pickerOptions0.isRepeatSelectSupported = false;
    this.pickerOptions0.maxSelectedReminderMode = ReminderMode.MASK

    this.pickerOptions2.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    this.pickerOptions2.maxSelectNumber = 5;
    this.pickerOptions2.isRepeatSelectSupported = false;
    this.pickerOptions2.maxSelectedReminderMode = ReminderMode.MASK
  }

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.currentIndex === index ? this.selectedFontColor : this.fontColor)
        .fontSize(16)
        .fontWeight(this.currentIndex === index ? 500 : 400)
        .lineHeight(22)
        .margin({ top: 17, bottom: 7 })
      Divider()
        .strokeWidth(2)
        .opacity(this.currentIndex === index ? 1 : 0)
    }.width('100%')
  }

  build() {
    Row() {
      Stack() {
        Column() {
          HdsTabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.tabsController }) {
            TabContent() {
              PhotoPickerComponent({
                pickerOptions: this.pickerOptions,
                onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean => this.onItemClicked(itemInfo,
                  clickType),
                onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                this.onEnterPhotoBrowser(photoBrowserInfo),
                onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                this.onExitPhotoBrowser(photoBrowserInfo),
                onPickerControllerReady: (): void => this.onPickerControllerReady(),
                onSelectedItemsDeleted: (itemInfos: Array<ItemInfo>): void => this.onSelectedItemsDeleted(itemInfos),
                onExceedMaxSelected: (maxCountType: MaxCountType): void => this.onExceedMaxSelected(maxCountType),
                onCurrentAlbumDeleted: (): void => this.onCurrentAlbumDeleted(),
                pickerController: this.pickerController,
              }).height(this.pickerHeight).width(this.pickerWidth).defaultFocus(true)
            }.tabBar(this.tabBuilder(0, '全部'))

            TabContent() {
              PhotoPickerComponent({
                pickerOptions: this.pickerOptions0,
                onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean => this.onItemClicked(itemInfo,
                  clickType),
                onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                this.onEnterPhotoBrowser(photoBrowserInfo),
                onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                this.onExitPhotoBrowser(photoBrowserInfo),
                onPickerControllerReady: (): void => this.onPickerControllerReady(),
                onSelectedItemsDeleted: (itemInfos: Array<ItemInfo>): void =>
                this.onSelectedItemsDeleted(itemInfos),
                onExceedMaxSelected: (maxCountType: MaxCountType): void =>
                this.onExceedMaxSelected(maxCountType),
                onCurrentAlbumDeleted: (): void => this.onCurrentAlbumDeleted(),
                pickerController: this.pickerController,
              }).height(this.pickerHeight).width(this.pickerWidth).defaultFocus(true)
            }.tabBar(this.tabBuilder(1, '动图'))

            TabContent() {
              PhotoPickerComponent({
                pickerOptions: this.pickerOptions1,
                onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean =>
                this.onItemClicked(itemInfo,
                  clickType),
                onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                this.onEnterPhotoBrowser(photoBrowserInfo),
                onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                this.onExitPhotoBrowser(photoBrowserInfo),
                onPickerControllerReady: (): void => this.onPickerControllerReady(),
                pickerController: this.pickerController,
              }).height(this.pickerHeight).width(this.pickerWidth).defaultFocus(true)
            }.tabBar(this.tabBuilder(2, '视频'))

            TabContent() {
              PhotoPickerComponent({
                pickerOptions: this.pickerOptions2,
                onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean => this.onItemClicked(itemInfo,
                  clickType),
                onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                this.onEnterPhotoBrowser(photoBrowserInfo),
                onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                this.onExitPhotoBrowser(photoBrowserInfo),
                onPickerControllerReady: (): void => this.onPickerControllerReady(),
                pickerController: this.pickerController,
              }).height(this.pickerHeight).width(this.pickerWidth).defaultFocus(true)
            }.tabBar(this.tabBuilder(3, '图片'))
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
            console.info(' onChange' + JSON.stringify(this.selectedUris));
            this.pickerController.setData(DataType.SET_SELECTED_URIS, this.selectedUris);
          })
          .width('100%')
          .height('90%')
          .backgroundColor(this.allBackGroundColor)
          .scrollable(!this.isInPhotoBrowser)

          Row() {
            ForEach(this.selectedUris, (uri: string) => {
              Image(uri).height('100%').width('20%').backgroundColor(this.allBackGroundColor).onClick(() => {
                console.info(' delet0: ' + JSON.stringify(this.selectedUris));
                this.selectedUris = this.selectedUris.slice(0, this.selectedUris.length - 1);
                console.info(' delet1: ' + JSON.stringify(this.selectedUris));
                this.pickerController.setData(DataType.SET_SELECTED_URIS, this.selectedUris);
                let maxSelect: MaxSelected = new MaxSelected();
                maxSelect.data =
                  new Map<MaxCountType, number>([[MaxCountType.TOTAL_MAX_COUNT, 10], [MaxCountType.PHOTO_MAX_COUNT, 5],
                    [MaxCountType.VIDEO_MAX_COUNT, 5]]);
              })
            }, (uri: string) => JSON.stringify(uri))
          }.width('100%').height('10%')
        }.width('100%').height('100%')
      }
    }
  }
}
