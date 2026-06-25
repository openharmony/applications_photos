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
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy display from '@ohos.display';
import lazy { abilityAccessCtrl, Context, PermissionRequestResult, common } from '@kit.AbilityKit'
import lazy {
  PhotoPickerComponent,
  PickerController,
  PickerOptions,
  ItemInfo,
  PhotoBrowserInfo,
  ItemType,
  ClickType,
  SelectMode,
  PhotoBrowserUIElement,
} from '@ohos.file.PhotoPickerComponent';

@Entry
@Component
struct HalfModalPage {
  @State message: string = 'PickerDemoApp';
  @State isShowingEmbedView: boolean = false;
  @State currentTabIndex: number = 0;
  @State imageUri: string = '';
  photoSelectOptionsHalf = new photoAccessHelper.PhotoSelectOptions();
  photoSelectOptionsFull: PickerOptions = new PickerOptions();
  @State pickerControllerFull: PickerController = new PickerController();
  // draw background
  canvasSettings: RenderingContextSettings = new RenderingContextSettings(true);
  canvasContext2D: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.canvasSettings);
  canvasPath2D: Path2D = new Path2D();
  @State displayWidth: number = 0;
  @State displayHeight: number = 0;

  aboutToAppear(): void {
    this.displayWidth = display.getDefaultDisplaySync().width;
    this.displayHeight = display.getDefaultDisplaySync().height;

    // 半模态选项
    this.photoSelectOptionsHalf.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    this.photoSelectOptionsHalf.maxSelectNumber = 1;
    this.photoSelectOptionsHalf.isOriginalSupported = true;
    this.photoSelectOptionsHalf.isEditSupported = true;

    console.log('aboutToAppear done');

    // 嵌入式选项
    this.photoSelectOptionsFull.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    this.photoSelectOptionsFull.isSearchSupported = false;
    this.photoSelectOptionsFull.photoBrowserCheckboxPosition = [0.9, 0.9];
  }

  drawBackgroundHexagon() {
    const height = this.displayHeight;
    const width = this.displayWidth;
    const a: number = 2 * Math.PI / 6;
    const r: number = 40;
    for (let y = r; y + r * Math.sin(a) < height; y += r * Math.sin(a)) {
      for (let x = r, j = 0; x + r * (1 + Math.cos(a)) < width;
        x += r * (1 + Math.cos(a)), y += (-1) ** j++ * r * Math.sin(a)) {
        this.canvasPath2D?.moveTo(x + r, y);
        for (let i = 0; i < 6; i++) {
          this.canvasPath2D?.lineTo(x + r * Math.cos(a * i), y + r * Math.sin(a * i));
        }
        this.canvasPath2D?.closePath();
      }
    }
    this.canvasContext2D?.stroke(this.canvasPath2D);
  }

  @Builder
  buildBackground() {
    Flex() {
      Canvas(this.canvasContext2D)
        .onReady(() => {
          this.canvasContext2D.strokeStyle = '#EFF6E0';
          this.canvasContext2D.lineWidth = 1;
          this.drawBackgroundHexagon();
        })
    }
    .height('100%')
    .width('100%')
  }

  onButtonClick() {
    const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
    let uris: string[] = [];
    photoViewPicker.select(this.photoSelectOptionsHalf).then((selectResult: photoAccessHelper.PhotoSelectResult) => {
      uris = selectResult.photoUris;
      console.log(`select count: ${uris.length}`);
      if (uris.length > 0) {
        this.imageUri = uris[0];
        console.log(`select file uri: ${this.imageUri}`);
      }
    })
  }

  // 资源被选中回调，返回资源的信息，以及选中方式
  onItemClicked(itemInfo: ItemInfo, clickType: ClickType): boolean {
    console.log(`onItemClicked callback clickType: ${clickType.toString()}`);
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
          console.log(`fullpage select count, ${this.imageUri}`);
          this.imageUri = uri;
          if (this.photoSelectOptionsFull.selectMode === SelectMode.SINGLE_SELECT) {
            this.isShowingEmbedView = false;
          }
        }
        return true; // 返回true则勾选，否则则不响应勾选。
      }
      return true;
    }
  }

  private onPickerControllerReady(): void {
    // 接收到该回调后，便可通过pickerController相关接口向picker发送数据，在此之前不生效。
    let elements: number[] = [
      PhotoBrowserUIElement.BACK_BUTTON,
    ];
    this.pickerControllerFull.setPhotoBrowserUIElementVisibility(elements, false); // 设置大图页不显示返回按钮
  }

  @Builder
  builderPickerFull() { // 嵌入式
    PhotoPickerComponent({
      pickerOptions: this.photoSelectOptionsFull,
      onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean => this.onItemClicked(itemInfo, clickType),
      pickerController: this.pickerControllerFull,
      onPickerControllerReady: (): void => this.onPickerControllerReady(),
      onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean => {
        return true;
      },
      onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean => {
        return true;
      }
    })
  }

  build() {
    Column() {
      if (this.isShowingEmbedView) {
        Button('关闭')
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .alignSelf(ItemAlign.End)
          .onClick(() => {
            console.log(`click close button`);
            this.isShowingEmbedView = false;
          })
        this.builderPickerFull();
      } else {
        Tabs({ barPosition: BarPosition.Start, index: this.currentTabIndex }) {
          TabContent() {
            this.buildHalfModal();
          }
          .tabBar(new SubTabBarStyle('半模态Picker')
            .labelStyle({ selectedColor: '#01161E' })
            .indicator({ color: '#598392' })
          )

          TabContent() {
            this.buildEmbeddedView();
          }
          .tabBar(new SubTabBarStyle('嵌入式Picker')
            .labelStyle({ selectedColor: '#01161E' })
            .indicator({ color: '#598392' })
          )
        }
        //.barHeight(56)
        .onChange((index: number) => {
          this.imageUri = '';
          this.currentTabIndex = index;
        })
      } // end of if else
    } // end of Column
    .background(this.buildBackground)
  }

  @Builder
  buildHalfModal() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        Row() {
          if (this.imageUri.length > 0) {
            Image(this.imageUri)
              .margin(6)
              .height('100%')
          }
        }
        .height('40%')

        Button('单选半模态&直选')
          .borderRadius(5)
          .backgroundColor('#598392')
          .margin({ 'top': 26, 'bottom': 6 })
          .onClick(() => {
            this.photoSelectOptionsHalf.isPreviewForSingleSelectionSupported = false;
            this.photoSelectOptionsHalf.completeButtonText = 1;
            this.onButtonClick();
          })
        Button('单选半模态&Preview')
          .borderRadius(5)
          .backgroundColor('#598392')
          .margin({ 'top': 6, 'bottom': 6 })
          .onClick(() => {
            this.photoSelectOptionsHalf.isPreviewForSingleSelectionSupported = true;
            this.photoSelectOptionsHalf.completeButtonText = 0;
            this.onButtonClick();
          })
        Button('单选半模态&Hybrid')
          .borderRadius(5)
          .backgroundColor('#598392')
          .margin({ 'top': 6, 'bottom': 6 })
          .onClick(() => {
            this.photoSelectOptionsHalf.isPreviewForSingleSelectionSupported = true;
            this.photoSelectOptionsHalf.completeButtonText = 2;
            this.onButtonClick();
          })
        Button('多选半模态')
          .borderRadius(5)
          .backgroundColor('#598392')
          .margin({ 'top': 6, 'bottom': 5 })
          .onClick(() => {
            this.photoSelectOptionsHalf.isPreviewForSingleSelectionSupported = false;
            this.photoSelectOptionsHalf.maxSelectNumber = 99;
            this.onButtonClick();
          })
      }
    }
  }

  @Builder
  buildEmbeddedView() {
    Column() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        Row() {
          if (this.imageUri.length > 0) {
            Image(this.imageUri)
              .margin(6)
              .height('100%')
          }
        }
        .height('40%')

        Button('单选嵌入式&直选')
          .borderRadius(5)
          .backgroundColor('#598392')
          .margin({ 'top': 26, 'bottom': 6 })
          .onClick(() => {
            this.isShowingEmbedView = true;
            this.photoSelectOptionsFull.selectMode = 1;
            this.photoSelectOptionsFull.selectMode = SelectMode.SINGLE_SELECT;
          })
        Button('单选嵌入式&Preview')
          .borderRadius(5)
          .backgroundColor('#598392')
          .margin({ 'top': 6, 'bottom': 6 })
          .onClick(() => {
            this.isShowingEmbedView = true;
            this.photoSelectOptionsFull.selectMode = SelectMode.SINGLE_SELECT;
            this.photoSelectOptionsFull.selectMode = 0;
          })
        Button('单选嵌入式&Hybrid')
          .borderRadius(5)
          .backgroundColor('#598392')
          .margin({ 'top': 6, 'bottom': 6 })
          .onClick(() => {
            let atm: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
            let context: Context = getContext(this) as common.UIAbilityContext;
            atm.requestPermissionsFromUser(context, [
              'ohos.permission.READ_IMAGEVIDEO'
            ]).then((data: PermissionRequestResult) => {
              console.info('data:' + JSON.stringify(data));
              if (data?.authResults[0] !== 0) {
                console.error('failed of user grant photo\'s permission.');
                return;
              }
              this.isShowingEmbedView = true;
              this.photoSelectOptionsFull.selectMode = SelectMode.SINGLE_SELECT;
              this.photoSelectOptionsFull.selectMode = 2;
            })
          })
        Button('多选嵌入式&点选')
          .borderRadius(5)
          .backgroundColor('#598392')
          .margin({ 'top': 5, 'bottom': 5 })
          .onClick(() => {
            this.isShowingEmbedView = true;
            this.photoSelectOptionsFull.selectMode = SelectMode.MULTI_SELECT;
            this.photoSelectOptionsFull.maxSelectNumber = 99;
            this.photoSelectOptionsFull.isSlidingSelectionSupported = false;
          })
        Button('多选嵌入式&滑动选')
          .borderRadius(5)
          .backgroundColor('#598392')
          .margin({ 'top': 5, 'bottom': 5 })
          .onClick(() => {
            this.isShowingEmbedView = true;
            this.photoSelectOptionsFull.selectMode = SelectMode.MULTI_SELECT;
            this.photoSelectOptionsFull.maxSelectNumber = 99;
            this.photoSelectOptionsFull.isSlidingSelectionSupported = true;
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}