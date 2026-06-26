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
  SelectMode
} from '@ohos.file.PhotoPickerComponent';
import lazy { AlbumPickerOptions } from '@ohos.file.AlbumPickerComponent';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { Log } from '../utils/Log';
import lazy { CustomContentDialog } from '@ohos.arkui.advanced.Dialog';
import lazy common from '@ohos.app.ability.common';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy ability from '@ohos.ability.ability';

//add
const SAVE_DIALOG_ICON_OUTSIDE: number = 32;
const SAVE_DIALOG_ICON_INSIDE: number = 20;
const TITLE_MAX_LINE: number = 2;
const TITLE_MAX_SCALE: number = 2;
const MEDIA_URL_PREFIX_STR: string = 'datashare:///media/';
const IMAGE_URL_PREFIX_STR_V10: string = 'file://media/image/';
const VIDEO_URL_PREFIX_STR_V10: string = 'file://media/video/';
const IMAGE_VIDEO_URL_PREFIX_STR_V10: string = 'file://media/Photo/';
const TAG: string = 'SaveUIExtensionLog';
const SAVE_RESULT_SUCCESS: number = 0;
const SAVE_RESULT_FAILED: number = -1;

@Entry
@Component
struct PhotoComponentPage {
  @State pickerController: PickerController = new PickerController();
  albumPickerOptions: AlbumPickerOptions = new AlbumPickerOptions();
  pickerOptions: PickerOptions = new PickerOptions();
  pickerOptions1: PickerOptions = new PickerOptions();
  pickerOptions2: PickerOptions = new PickerOptions();
  @State selectedUris: Array<string> = [];
  @State allBackGroundColor: number = 0xf1f3f5;
  @State videoBackGroundColor: number = 0xffffff;
  @State photoBackGroundColor: number = 0xffffff;
  @State isShowAll: boolean = true;
  @State isShowVideo: boolean = false;
  @State isShowPhoto: boolean = false;
  @State width: string = '100%';
  @State height: string = '100%';
  @State selectMode: number = 1;
  @State isRepeatSelectSupported: boolean = false;
  //add
  private context: common.UIExtensionContext | null = getContext(this) as common.UIExtensionContext;
  private session: UIExtensionContentSession | undefined;
  private srcFileUris: Array<photoAccessHelper.PhotoCreationConfig> = [];
  private uris: Array<string> = [];
  private bundleName: string = '';
  private appName: string = '';
  private appId: string = '';
  private isPc: boolean = false;
  @State message: string = '我是picker页面';
  @State selectedUri: string = '';
  private title: string = '是否同意“xx”应用保存图片/视频到图库？';
  private tokenId: number = 0;

  private onEnterPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    console.info('1111111onEnterPhotoBrowser' + JSON.stringify(photoBrowserInfo));
    return false;
  }

  private onExitPhotoBrowser(photoBrowserInfo: PhotoBrowserInfo): boolean {
    this.dialogController?.close();
    return false;
  }

  private onItemClicked(itemInfo: ItemInfo, clickType: ClickType): boolean {
    if (!itemInfo) {
      return false;
    }
    let type: ItemType | undefined = itemInfo.itemType;
    let uri: string | undefined = itemInfo.uri;
    if (type === ItemType.CAMERA) {
      console.info('1111111onCameraClick');
    } else if (type === ItemType.THUMBNAIL) {
      if (clickType === ClickType.SELECTED) {
        if (uri) {
          this.selectedUris.push(uri)
          this.pickerOptions.preselectedUris = [...this.selectedUris];
          this.pickerOptions1.preselectedUris = [...this.selectedUris];
          this.pickerOptions2.preselectedUris = [...this.selectedUris];
        }
      } else {
        if (uri) {
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
    let length = this.selectedUris.length - 1;
    let uri0: string = this.isMediaLibraryUri(this.selectedUris[length]) ? this.selectedUris[length] : '';
    this.selectedUri = uri0 as string;
    return true;
  }

  aboutToAppear() {
    this.pickerOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE;
    this.pickerOptions.maxSelectNumber = 10;
    this.pickerOptions.isSearchSupported = true;
    this.pickerOptions.isPhotoTakingSupported = true;
    this.pickerOptions.selectMode = SelectMode.MULTI_SELECT;
    this.pickerOptions.isRepeatSelectSupported = true;
  }

  @State fontColor: string = '#182431222'
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
      Divider()
        .strokeWidth(2)
        .opacity(this.currentIndex === index ? 1 : 0)
    }.width('100%')
  }

  build() {
    Row() {
      Stack() {
        Text()
        Column() {
          Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
            TabContent() {
              PhotoPickerComponent({
                pickerOptions: this.pickerOptions,
                onItemClicked: (itemInfo: ItemInfo, clickType: ClickType): boolean => {
                  this.onItemClicked(itemInfo, clickType)
                  console.log(`${itemInfo.uri}`)
                  return true
                },
                onEnterPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean => {
                  this.onEnterPhotoBrowser(photoBrowserInfo)
                  return true
                },
                onExitPhotoBrowser: (photoBrowserInfo: PhotoBrowserInfo): boolean =>
                  this.onExitPhotoBrowser(photoBrowserInfo),
                pickerController: this.pickerController,
              }).height('87%').width('100%')
            }.tabBar(this.tabBuilder(0, '全部'))
          }
          .vertical(false)
          .barMode(BarMode.Fixed)
          .barWidth('100%')
          .barHeight(56)
          .animationDuration(100)
          .onChange((index: number) => {
            this.currentIndex = index;
            this.pickerController.setData(DataType.SET_SELECTED_URIS, this.selectedUris);
          })
          .width('100%')
          .height('100%')
          .margin({ top: 52 })
          .backgroundColor('#F1F3F5')
        }.width('100%').justifyContent(FlexAlign.Center).alignItems(HorizontalAlign.Center)

        Row() {
          ForEach(this.selectedUris, (uri: string) => {
            Image(uri).height('10%').width('20%').backgroundColor(this.allBackGroundColor).onClick(() => {
              this.selectedUris = this.selectedUris.filter((item: string) => {
                return uri != item;
              })
              this.pickerController.setData(DataType.SET_SELECTED_URIS, this.selectedUris);
            })
          }, (uri: string) => JSON.stringify(uri))
        }
      }.alignContent(Alignment.Center)
    }
  }

  private dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.buildContent();
      },
      contentAreaPadding: { right: 0 },
      buttons: [
        {
          value: '禁止',
          buttonStyle: this.isPc ? ButtonStyleMode.NORMAL : ButtonStyleMode.TEXTUAL,
          action: () => {
            this.message = '禁止'
            this.setSaveResult(false);
          }
        },
        {
          value: '允许',
          buttonStyle: this.isPc ? ButtonStyleMode.NORMAL : ButtonStyleMode.TEXTUAL,
          action: () => {
            this.message = '允许'
            this.setSaveResult(true);
          }
        }
      ],
    }),
    autoCancel: false,
    cancel: () => {
      this.message = '退出弹窗'
    }
  });

  @Builder
  buildContent(): void {
    Scroll() {
      Column() {
        this.saveIcon();
        Column() {
          Text(this.title)
            .textAlign(TextAlign.Center)
            .fontSize($r('sys.float.Title_S'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('sys.color.font_primary'))
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(TITLE_MAX_LINE)
            .minFontSize(
              this.getLimitFontSize(
                this.getFontSizeScale(),
                TITLE_MAX_SCALE,
                $r('sys.float.Subtitle_M'),
                $r('sys.float.Title_S'))
            )
            .maxFontSize(
              this.getLimitFontSize(
                this.getFontSizeScale(),
                TITLE_MAX_SCALE,
                $r('sys.float.Title_S'),
                $r('sys.float.Title_S'))
            )
            .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
        }
        .constraintSize({ minHeight: '56vp' })
        .justifyContent(FlexAlign.Center)
      }
      .clip(true)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
    }
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: false })
  }

  @Builder
  saveIcon(): void {
    Shape() {
      Circle({ width: SAVE_DIALOG_ICON_OUTSIDE, height: SAVE_DIALOG_ICON_OUTSIDE })
        .fill($r('sys.color.multi_color_03'))
      Row() {
        SymbolGlyph($r('sys.symbol.picture_fill'))
          .fontSize(SAVE_DIALOG_ICON_INSIDE / this.getFontSizeScale())
          .fontColor([$r('sys.color.ohos_id_color_primary_contrary')])
          .draggable(false)
      }
    }
  }

  @Builder
  saveImage(): void {
    Stack({ alignContent: Alignment.Bottom }) {

      Image(this.selectedUri)
        .objectFit(ImageFit.Cover)
        .width('100%')
    }
    .width('100%')
    .alignContent(Alignment.Top)
  }

  private getFontSizeScale(): number {
    return 1;
  }

  private getLimitFontSize(
    fontSizeScale: number, maxScale: number, resMin: Resource, resMax: Resource
  ): number | string {
    if (fontSizeScale <= 1) {
      return px2vp(getContext().resourceManager.getNumber(resMin.id));
    }
    let fontSize: number = px2vp(getContext().resourceManager.getNumber(resMax.id));
    return fontSizeScale > maxScale ? `${fontSize * maxScale}vp` : fontSize;
  }

  private isMediaLibraryUri(uri: string): boolean {
    return (String(uri).startsWith(MEDIA_URL_PREFIX_STR) ||
    String(uri).startsWith(IMAGE_URL_PREFIX_STR_V10) ||
    String(uri).startsWith(VIDEO_URL_PREFIX_STR_V10) ||
    String(uri).startsWith(IMAGE_VIDEO_URL_PREFIX_STR_V10));
  }

  private async setSaveResult(isSave: boolean) {
    Log.warn(TAG, `setSaveResult terminateSelfWithResult isSave: ${isSave}`);
    if (isSave) {
      let result: string[] = await this.saveBox();
      let abilityResult: ability.AbilityResult = {
        resultCode: SAVE_RESULT_SUCCESS,
        want: {
          parameters: {
            'desFileUris': result
          }
        }
      };
      this.session?.terminateSelfWithResult(abilityResult);
      console.log(`session terminateSelfWithResult result: ${JSON.stringify(abilityResult)}`)
    } else {
      let abilityResult: ability.AbilityResult = {
        resultCode: SAVE_RESULT_FAILED,
      };
      this.session?.terminateSelfWithResult(abilityResult);
      console.log(`session terminateSelfWithResult result: ${JSON.stringify(abilityResult)}`)
    }
  }

  private async saveBox(): Promise<Array<string>> {
    try {
      let phAccessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
      let result: string[] =
        await phAccessHelper.createAssetsForApp(this.bundleName, this.appName, this.tokenId, this.srcFileUris);
      Log.info(TAG, 'Photo createAssetsForApp success.');
      return result;
    } catch (err) {
      Log.error(TAG, `Photo createAssetsForApp failed with error: ${err.code}, ${err.message}`);
      return [];
    }
  }
}