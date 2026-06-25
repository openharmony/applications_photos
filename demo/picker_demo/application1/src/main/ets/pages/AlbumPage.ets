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

import lazy {
  PhotoPickerComponent,
  PickerController,
  PickerOptions,
  DataType,
  ItemInfo,
  ItemType,
  PhotoBrowserInfo,
  ClickType,
  PickerColorMode,
  MaxSelected,
  MaxCountType,
  ReminderMode,
  PickerOrientation,
  BaseItemInfo,
  PhotoBrowserRange,
  PhotoBrowserUIElement,
  ItemsDeletedCallback,
  ExceedMaxSelectedCallback,
  CurrentAlbumDeletedCallback,
  SelectMode,
} from '@ohos.file.PhotoPickerComponent';
import lazy { AlbumPickerComponent, AlbumPickerOptions, AlbumInfo } from '@ohos.file.AlbumPickerComponent';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy {
  RecentPhotoOptions,
  PhotoSource,
  RecentPhotoComponent,
  RecentPhotoClickCallback,
  RecentPhotoCheckResultCallback,
  RecentPhotoCheckInfoCallback,
  RecentPhotoInfo,
} from '@ohos.file.RecentPhotoComponent';


@Entry
@Component
struct AlbumPage {
  @State pickerController: PickerController = new PickerController();
  @State pickerOptions: PickerOptions = new PickerOptions();
  pickerOptions1: PickerOptions = new PickerOptions();
  pickerOptions2: PickerOptions = new PickerOptions();
  @State selectedUris: string[] = [];
  @State allBackGroundColor: number = 0xf1f3f5;
  @State videoBackGroundColor: number = 0xffffff;
  @State photoBackGroundColor: number = 0xffffff;
  @State isShowAll: boolean = true;
  @State isShowVideo: boolean = false;
  @State isShowPhoto: boolean = false;
  @State pickerWidth: string = '100%';
  @State pickerHeight: string = '100%';
  @State isShowAlbum: boolean = false;
  private isBlock: boolean = false;
  @State fontColor: string = '#182431222';
  @State selectedFontColor: string = '#007DFF'
  @State currentIndex: number = 0
  private controller: TabsController = new TabsController();
  @State currentUri: string = ''
  // 控制缩略图是否显示
  @State private isBrowserShow: boolean = false;
  private selectedItemsDeletedCallback: ItemsDeletedCallback =
    (baseItemInfos: Array<BaseItemInfo>) => this.onSelectedItemsDeleted(baseItemInfos);
  private exceedMaxSeletedCallback: ExceedMaxSelectedCallback =
    (exceedMaxCountType: MaxCountType) => this.onExceedMaxSelected(exceedMaxCountType);
  private currentAlbumDeletedCallback: CurrentAlbumDeletedCallback = () => this.onCurrentAlbumDeleted();
  // albumPickerComponent
  private albumOptions: AlbumPickerOptions = new AlbumPickerOptions();
  private albumOptions1: AlbumPickerOptions = new AlbumPickerOptions();
  private albumOptions2: AlbumPickerOptions = new AlbumPickerOptions();
  // recentPhotoComponent
  private recentPhotoOptions: RecentPhotoOptions = new RecentPhotoOptions();
  private recentPhotoClickCallback: RecentPhotoClickCallback =
    (recentPhotoInfo: BaseItemInfo): boolean => this.onRecentPhotoClick(recentPhotoInfo);
  private checkResultCallback: RecentPhotoCheckResultCallback =
    (recentPhotoExists: boolean) => this.onRecentPhotoCheckResult(recentPhotoExists);
  private checkInfoCallback: RecentPhotoCheckInfoCallback = (recentPhotoExists: boolean,
    info: RecentPhotoInfo): void => this.onCheckInfoCallback(recentPhotoExists, info);
  @State uri: string = '无效URI';

  // 进入大图页回调
  private onEnterPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    console.info('onEnterPhotoBrowser' + JSON.stringify(photoBrowserInfo));
    this.isBrowserShow = true;
    return false;
  }

  // 退出大图页回调
  private onExitPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    console.info('onExitPhotoBrowser' + JSON.stringify(photoBrowserInfo));
    this.isBrowserShow = false;
    return false;
  }

  // 大图页图片切换回调事件处理
  private onPhotoBrowserChanged(photoBrowserItemInfo: BaseItemInfo): boolean {
    console.info('onPhotoBrowserChanged' + JSON.stringify(photoBrowserItemInfo));
    this.currentUri = photoBrowserItemInfo.uri ?? '';
    return true;
  }

  // 接收到该回调后，便可通过pickerController相关接口向picker发送数据，在此之前不生效。
  private onPickerControllerReady(): void {
    let elements: number[] = [PhotoBrowserUIElement.CHECKBOX, PhotoBrowserUIElement.BACK_BUTTON];
    /**
     * 设置大图页 checkbox和返回按钮是否可见
     * element:  可选CHECKBOX、BACK_BUTTON
     * param2：是否可见
     */
    this.pickerController.setPhotoBrowserUIElementVisibility(elements, true);
    console.info('onPickerControllerReady');
  }

  // 已勾选图片被删除时的回调
  private onSelectedItemsDeleted(baseItemInfos: Array<BaseItemInfo>): void {
    console.info('onSelectedItemsDeleted');
  }

  // 超过最大选择数量再次点击时的回调
  private onExceedMaxSelected(exceedMaxCountType: MaxCountType): void {
    console.info('onExceedMaxSelected');
  }

  // 当前相册被删除时的回调
  private onCurrentAlbumDeleted(): void {
    console.info('onCurrentAlbumDeleted');
  }

  /**
   * 最近图片点击事件
   * BaseItemInfo（uri, mimeType, width, height, size, duration）
   * return 返回值为true时才会给url授权，才可以显示
   */
  private onRecentPhotoClick(recentPhotoInfo: BaseItemInfo): boolean {
    if (!recentPhotoInfo) {
      return false;
    }
    console.info('RecentPhotoOptions' + JSON.stringify(recentPhotoInfo));
    this.uri = recentPhotoInfo.uri ?? '无效URI';
    console.info('onRecentPhotoClick uri = ' + this.uri);
    return true;
  }

  // 判断是否存在最近图片。存在最近图片的话，可以实现业务需求， 如去控制RecentPhotoComponent是否显示
  private onRecentPhotoCheckResult(recentPhotoExists: boolean): void {
    console.info('Check photo, recentPhotoExists = ' + recentPhotoExists);
  }

  private onCheckInfoCallback(recentPhotoExists: boolean, info: RecentPhotoInfo): void {
    console.info('onCheckInfoCallback recentPhotoInfo dateToken ' + info.dateTaken);
    console.info('onCheckInfoCallback recentPhotoInfo identifier ' + info.identifier);
  }

  /**
   *相册被选中回调，返回相册信息
   * AlbumInfo（uri）
   */
  private onAlbumClick(albumInfo: AlbumInfo): boolean {
    this.isShowAlbum = false;
    console.info('onAlbumClick' + JSON.stringify(albumInfo));
    if (albumInfo?.uri) {
      // albumInfo.uri传''显示所有的相册，默认进入宫格是显示的所有相册
      this.pickerController.setData(DataType.SET_ALBUM_URI, albumInfo.uri);
    }
    return true;
  }

  // 图片/视频被取消勾选的回调，返回的url只有只读权限，不能用url直接去打开
  private onDeselect(uri: string): void {
    if (uri) {
      this.selectedUris = this.selectedUris.filter((item: string) => {
        return item !== uri;
      })
    }
    // 排除反勾选uri，并保证切换不同的宫格页组件时保持选中项一致
    this.pickerOptions.preselectedUris = [...this.selectedUris];
    this.pickerOptions1.preselectedUris = [...this.selectedUris];
    this.pickerOptions2.preselectedUris = [...this.selectedUris];
    console.info('onDeselect' + JSON.stringify(this.selectedUris));
  }

  /**
   * 图片/视频被选中回调，返回资源的信息，以及选中方式
   * ItemInfo 图片、视频相关信息
   * ClickType（SELECTED：勾选， DESELECTED： 反选）
   * return 返回值为true时才会给url授权（返回的uri权限是只读权限）
   */
  private onItemClicked(itemInfo: ItemInfo, clickType: ClickType): boolean {
    if (!itemInfo) {
      return false;
    }
    let type: ItemType | undefined = itemInfo.itemType;
    let uri: string | undefined = itemInfo.uri;
    if (type === ItemType.CAMERA) { // 点击相机item
      console.info('onCameraClick');
      if (this.isBlock) {
        return false;
      }
      // 返回true则拉起系统相机，若应用需要自行处理则返回false。
      return true;
    } else if (type === ItemType.THUMBNAIL) { //点击图片、视频item（缩略图item）
      if (clickType === ClickType.SELECTED) { //选中
        if (this.isBlock) {
          return false;
        }
        // 将uri保存起来，并保证切换不同的宫格页组件时保持选中项一致
        if (uri) {
          this.selectedUris.push(uri ?? '');
          this.pickerOptions.preselectedUris = [...this.selectedUris];
          this.pickerOptions1.preselectedUris = [...this.selectedUris];
          this.pickerOptions2.preselectedUris = [...this.selectedUris];
        }
      } else { //反选
        if (uri) {
          // 排除反勾选uri，并保证切换不同的宫格页组件时保持选中项一致
          this.selectedUris = this.selectedUris.filter((item: string) => {
            return item !== uri;
          })
          this.pickerOptions.preselectedUris = [...this.selectedUris];
          this.pickerOptions1.preselectedUris = [...this.selectedUris];
          this.pickerOptions2.preselectedUris = [...this.selectedUris];
        }
      }
    } else {
    }
    console.info('onItemClicked' + JSON.stringify(itemInfo));
    return true;
  }

  aboutToAppear() {
    // 设置picker宫格页数据类型
    this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;

    // 是否展示搜索框，默认false
    this.pickerOptions.isSearchSupported = true;

    // 是否支持拍照，默认false
    this.pickerOptions.isPhotoTakingSupported = true;

    // 是否支持重复选择
    this.pickerOptions.isRepeatSelectSupported = false;

    // 最大选择数量
    this.pickerOptions.maxSelectNumber = 8;

    // 最大图片选择数量
    this.pickerOptions.maxPhotoSelectNumber = 8;

    // 最大视频选择数量
    this.pickerOptions.maxVideoSelectNumber = 8;

    // 超出最大选择数量时
    this.pickerOptions.maxSelectedReminderMode = ReminderMode.TOAST;

    // 设置大图背景色
    this.pickerOptions.photoBrowserBackgroundColorMode = PickerColorMode.AUTO;

    // 设置checkbox选中颜色
    this.pickerOptions.checkBoxColor = '#000000';

    // 设置checkbox颜色
    this.pickerOptions.checkboxTextColor = '#000000';

    // 设置宫格页背景色
    this.pickerOptions.backgroundColor = '#FF0000';

    // 设置宫格页的横竖屏（当前暂未支持）
    this.pickerOptions.orientation = PickerOrientation.HORIZONTAL;

    // 设置选择模式(SINGLE_SELECT/MULTI_SELECT，默认：MULTI_SELECT)
    this.pickerOptions.selectMode = SelectMode.MULTI_SELECT;

    // 支持滑动多选
    this.pickerOptions.isSlidingSelectionSupported = true;

    // 同上
    this.pickerOptions1.MIMEType = photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE;
    this.pickerOptions1.isSearchSupported = false;
    this.pickerOptions1.isPhotoTakingSupported = false;
    this.pickerOptions1.isRepeatSelectSupported = false;
    this.pickerOptions1.maxSelectNumber = 8;
    this.pickerOptions1.maxSelectedReminderMode = 2;
    this.pickerOptions1.maxPhotoSelectNumber = 8;
    this.pickerOptions1.maxVideoSelectNumber = 8;
    this.pickerOptions1.photoBrowserBackgroundColorMode = PickerColorMode.LIGHT;
    this.pickerOptions2.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    this.pickerOptions2.isSearchSupported = false;
    this.pickerOptions2.isPhotoTakingSupported = false;
    this.pickerOptions2.isRepeatSelectSupported = false;
    this.pickerOptions2.maxSelectNumber = 8;
    this.pickerOptions2.maxSelectedReminderMode = 2;
    this.pickerOptions2.maxPhotoSelectNumber = 8;
    this.pickerOptions2.maxVideoSelectNumber = 8;
    this.pickerOptions2.photoBrowserBackgroundColorMode = PickerColorMode.DARK;

    /**
     * 设置相册页颜色模式， 默认AUTO。
     * AUTO：跟随系统的模式， LIGHT：浅色模式， DARK：深色模式
     */
    this.albumOptions.themeColorMode = PickerColorMode.AUTO;
    this.albumOptions1.themeColorMode = PickerColorMode.LIGHT;
    this.albumOptions2.themeColorMode = PickerColorMode.DARK;

    // 设置数据类型， IMAGE_VIDEO_TYPE：图片和视频（默认值）  IMAGE_TYPE：图片   VIDEO_TYPE：视频  MOVING_PHOTO_IMAGE_TYPE 动态图片
    this.recentPhotoOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;

    // 设置最近图片的时间范围，单位（秒）， 0表示所有时间。
    this.recentPhotoOptions.period = 0;

    // 设置资源的来源 ALL：所有 CAMERA：相机  SCREENSHOT：截图
    this.recentPhotoOptions.photoSource = PhotoSource.ALL;
  }

  // 设置导航栏的样式
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
    Stack() {
      Column() {
        Row() {
          Button('全部相册').width('50%').height('8%').onClick(() => {
            this.isShowAlbum = true;
          })

          //模拟动态设置最大数量
          Button('扩大选择数量').width('50%').height('8%').onClick(() => {
            this.pickerOptions.maxSelectNumber = 2 * (this.pickerOptions.maxSelectNumber ?? 25);
            this.pickerOptions.maxPhotoSelectNumber = 2 * (this.pickerOptions.maxPhotoSelectNumber ?? 25);
            this.pickerOptions.maxVideoSelectNumber = 2 * (this.pickerOptions.maxVideoSelectNumber ?? 25);
            let maxSelect: MaxSelected = new MaxSelected();
            maxSelect.data =
              new Map<MaxCountType, number>([[MaxCountType.TOTAL_MAX_COUNT, this.pickerOptions.maxSelectNumber],
                [MaxCountType.PHOTO_MAX_COUNT, this.pickerOptions.maxPhotoSelectNumber],
                [MaxCountType.VIDEO_MAX_COUNT, this.pickerOptions.maxVideoSelectNumber]]);
            this.pickerController.setMaxSelected(maxSelect);
          })
        }.margin({ top: 40 })

        if (this.isShowAll) {
          Column() {
            // 使用3个组件 以便更好展示不同效果
            Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
              TabContent() {
                PhotoPickerComponent({
                  pickerOptions: this.pickerOptions,
                  onDeselect: (uri: string): void => this.onDeselect(uri),
                  onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean =>
                  this.onItemClicked(itemInfo, clickType),
                  onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                  this.onEnterPhotoBrowser(photoBrowserInfo),
                  onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                  this.onExitPhotoBrowser(photoBrowserInfo),
                  onPhotoBrowserChanged: (photoBrowserItemInfo: BaseItemInfo): boolean =>
                  this.onPhotoBrowserChanged(photoBrowserItemInfo),
                  onPickerControllerReady: (): void => this.onPickerControllerReady(),
                  onSelectedItemsDeleted: this.selectedItemsDeletedCallback,
                  onExceedMaxSelected: this.exceedMaxSeletedCallback,
                  onCurrentAlbumDeleted: this.currentAlbumDeletedCallback,
                  pickerController: this.pickerController,
                }).height(this.pickerHeight).width(this.pickerWidth)
              }.tabBar(this.tabBuilder(0, '全部'))

              TabContent() {
                PhotoPickerComponent({
                  pickerOptions: this.pickerOptions1,
                  onDeselect: (uri: string): void => this.onDeselect(uri),
                  onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean => this.onItemClicked(itemInfo,
                    clickType),
                  onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                  this.onEnterPhotoBrowser(photoBrowserInfo),
                  onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                  this.onExitPhotoBrowser(photoBrowserInfo),
                  onPhotoBrowserChanged: (photoBrowserItemInfo: BaseItemInfo): boolean =>
                  this.onPhotoBrowserChanged(photoBrowserItemInfo),
                  onPickerControllerReady: (): void => this.onPickerControllerReady(),
                  pickerController: this.pickerController,
                }).height(this.pickerHeight).width(this.pickerWidth)
              }.tabBar(this.tabBuilder(1, '图片'))

              TabContent() {
                PhotoPickerComponent({
                  pickerOptions: this.pickerOptions2,
                  onDeselect: (uri: string): void => this.onDeselect(uri),
                  onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean =>
                  this.onItemClicked(itemInfo, clickType),
                  onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                  this.onEnterPhotoBrowser(photoBrowserInfo),
                  onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                  this.onExitPhotoBrowser(photoBrowserInfo),
                  onPhotoBrowserChanged: (photoBrowserItemInfo: BaseItemInfo): boolean =>
                  this.onPhotoBrowserChanged(photoBrowserItemInfo),
                  onPickerControllerReady: (): void => this.onPickerControllerReady(),
                  pickerController: this.pickerController,
                }).height(this.pickerHeight).width(this.pickerWidth)
              }.tabBar(this.tabBuilder(2, '视频'))
            }
            .vertical(false)
            .barMode(BarMode.Fixed)
            .barWidth('100%')
            .barHeight(56)
            .scrollable(false)
            .animationDuration(100)
            .onChange((index: number) => {
              this.currentIndex = index;
              console.info('onChange' + JSON.stringify(this.selectedUris));
              this.pickerController.setData(DataType.SET_SELECTED_URIS, this.selectedUris);
            })
            .width('100%')
            .height('100%')
            .margin({ top: 8 })
            .backgroundColor('#F1F3F5')
          }.width('100%').height('70%').alignItems(HorizontalAlign.Center)
        }

        Row() {
          // 计数并跳转到大图预览
          Text('已选' + this.selectedUris.length + ' / ' + this.pickerOptions.maxSelectNumber)
            .draggable(false)
            .fontColor('blue')
            .textAlign(TextAlign.Start)
            .width('100%')
            .margin({ top: '16vp' })
            .onClick((): void => {
              if (this.selectedUris.length > 0) {
                this.pickerController.setPhotoBrowserItem(this.selectedUris[0], PhotoBrowserRange.SELECTED_ONLY);
                this.isBrowserShow = true;
              }
            })
        }
      }

      if (this.isShowAlbum) {
        Row() {
          Stack() {
            Column() {
              // 使用3个组件 以便更好展示不同效果
              Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
                TabContent() {
                  AlbumPickerComponent({
                    albumPickerOptions: this.albumOptions,
                    onAlbumClick: (albumInfo: AlbumInfo): boolean => this.onAlbumClick(albumInfo),
                  }).height('100%').width('100%')
                }.tabBar(this.tabBuilder(0, '系统'))

                TabContent() {
                  AlbumPickerComponent({
                    albumPickerOptions: this.albumOptions1,
                    onAlbumClick: (albumInfo: AlbumInfo): boolean => this.onAlbumClick(albumInfo),
                  }).height('100%').width('100%')
                }.tabBar(this.tabBuilder(1, '浅色'))

                TabContent() {
                  AlbumPickerComponent({
                    albumPickerOptions: this.albumOptions2,
                    onAlbumClick: (albumInfo: AlbumInfo): boolean => this.onAlbumClick(albumInfo),
                  }).height('100%').width('100%')
                }.tabBar(this.tabBuilder(2, '深色'))
              }
              .vertical(false)
              .barMode(BarMode.Fixed)
              .barWidth('100%')
              .barHeight(56)
              .animationDuration(100)
              .onChange((index: number) => {
                this.currentIndex = index;
                console.info('onChange' + JSON.stringify(this.selectedUris));
                this.pickerController.setData(DataType.SET_SELECTED_URIS, this.selectedUris);
              })
              .width('100%')
              .height('100%')
              .backgroundColor('#F1F3F5')
            }.width('100%').height('100%').justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)
          }.alignContent(Alignment.Center)
        }
      }

      if (this.isBrowserShow) {
        // 这里就是模拟选中图片的缩略图展示
        Row() {
          ForEach(this.selectedUris, (uri: string) => {
            if (uri === this.currentUri) {
              Image(uri)
                .height('10%')
                .width('20%')
                .backgroundColor(this.allBackGroundColor)
                .onClick(() => {
                  console.log('uri = ' + uri + ', currentUri = ' + this.currentUri);
                })
                .borderWidth(1)
                .borderColor('red')
            } else {
              Image(uri).height('10%').width('20%').backgroundColor(this.allBackGroundColor).onClick(() => {
                console.log('uri = ' + uri);
                this.pickerController.setPhotoBrowserItem(uri, PhotoBrowserRange.ALL);
              })
            }
          }, (uri: string) => JSON.stringify(uri))
        }
        .offset({
          y: 380,
        })
      } else {
        Column() {
          RecentPhotoComponent({
            // 设置最近图片组件选择选项实例
            recentPhotoOptions: this.recentPhotoOptions,

            // 检查是否存在最近的资源
            onRecentPhotoCheckResult: this.checkResultCallback,

            /**
             * 最近图片点击事件
             * BaseItemInfo（uri, mimeType, width, height, size, duration）
             * return 返回值为true时才会给url授权，才可以显示
             */
            onRecentPhotoClick: this.recentPhotoClickCallback,

            onRecentPhotoCheckInfo: this.checkInfoCallback,
          }).height('50vp').width('50vp').id('recentPhoto')

          Text('这是最近的一张图片').margin({ top: '8vp' })
        }.offset({
          x: 100,
          y: 360,
        })
      }
    }
  }
}