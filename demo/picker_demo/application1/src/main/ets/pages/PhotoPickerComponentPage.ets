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
  BaseItemInfo,
  ItemInfo,
  PhotoBrowserInfo,
  ItemType,
  ClickType,
  MaxCountType,
  ReminderMode,
} from '@ohos.file.PhotoPickerComponent';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';

@Entry
@Component
struct Index {
  // 组件初始化时设置参数信息
  pickerOptions: PickerOptions = new PickerOptions();
  // 组件初始化完成后，可控制组件部分行为
  @State pickerController: PickerController = new PickerController();
  // 已选择的图片
  @State selectUris: string[] = [];
  //目前选择的图片
  @State currentUri: string = '';
  //是否显示大图
  @State isBrowserShow: boolean = false;

  aboutToAppear() {
    // 设置picker宫格页数据类型
    this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE // 图片和照片都显示;
    // 最大选择数量
    this.pickerOptions.maxSelectNumber = 5;
    // 超出最大选择数量时
    this.pickerOptions.maxSelectedReminderMode = ReminderMode.TOAST;
    // 是否展示搜索框，默认false
    this.pickerOptions.isSearchSupported = true;
    // 是否支持拍照，默认false
    this.pickerOptions.isPhotoTakingSupported = true;

    this.pickerOptions.orientation = 1;

  }

  // 资源被选中回调，返回资源的信息，以及选中方式
  private onItemClicked(itemInfo: ItemInfo, clickType: ClickType): boolean {
    if (!itemInfo) {
      return false;
    }
    let type: ItemType | undefined = itemInfo.itemType;
    let uri: string | undefined = itemInfo.uri;
    if (type === ItemType.CAMERA) {
      // 点击相机item
      return true; // 返回true则拉起系统相机，若应用需要自行处理则返回false。
    } else {
      if (clickType === ClickType.SELECTED) {
        // 应用做自己的业务处理
        if (uri) {
          this.selectUris.push(uri);
          this.pickerOptions.preselectedUris = [...this.selectUris];
        }
        return true; // 返回true则勾选，否则则不响应勾选。
      } else {
        if (uri) {
          this.selectUris = this.selectUris.filter((item: string) => {
            return item != uri;
          });
          this.pickerOptions.preselectedUris = [...this.selectUris];
        }
      }
      return true;
    }
  }

  // 进入大图的回调
  private onEnterPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    this.isBrowserShow = true;
    return true;
  }

  // 退出大图的回调
  private onExitPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    this.isBrowserShow = false;
    return true;
  }

  // 接收到该回调后，便可通过pickerController相关接口向picker发送数据，在此之前不生效。
  private onPickerControllerReady(): void {
  }

  // 大图左右滑动的回调
  private onPhotoBrowserChanged(browserItemInfo: BaseItemInfo): boolean {
    this.currentUri = browserItemInfo.uri ?? '';
    return true;
  }

  // 已勾选图片被删除时的回调
  private onSelectedItemsDeleted(baseItemInfos: Array<BaseItemInfo>): void {
  }

  // 超过最大选择数量再次点击时的回调
  private onExceedMaxSelected(exceedMaxCountType: MaxCountType): void {
  }

  // 当前相册被删除时的回调
  private onCurrentAlbumDeleted(): void {
  }

  build() {
    Flex({
      direction: FlexDirection.Column,
      alignItems: ItemAlign.Start,
    }) {
      Tabs() {
        TabContent() {
          Text('首页的内容').fontSize(30)
        }
        .tabBar('首页')

        TabContent() {
          PhotoPickerComponent({
            pickerOptions: this.pickerOptions,
            onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean =>
              this.onItemClicked(itemInfo, clickType),
            onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
              this.onEnterPhotoBrowser(photoBrowserInfo),
            onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
              this.onExitPhotoBrowser(photoBrowserInfo),
            onPickerControllerReady: (): void => this.onPickerControllerReady(),
            onPhotoBrowserChanged: (browserItemInfo: BaseItemInfo): boolean =>
              this.onPhotoBrowserChanged(browserItemInfo),
            onSelectedItemsDeleted: (baseItemInfo: Array<BaseItemInfo>) => this.onSelectedItemsDeleted(baseItemInfo),
            onExceedMaxSelected: (exceedMaxCountType: MaxCountType) => this.onExceedMaxSelected(exceedMaxCountType),
            onCurrentAlbumDeleted: () => this.onCurrentAlbumDeleted(),
            pickerController: this.pickerController,
          })
        }
        .tabBar('推荐')

        TabContent() {
          Text('发现的内容').fontSize(30)
        }
        .tabBar('发现')

        TabContent() {
          Text('我的内容').fontSize(30)
        }
        .tabBar('我的')
      }
    }
  }
}