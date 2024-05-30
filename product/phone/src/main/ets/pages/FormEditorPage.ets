/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import {
  AlbumDefine,
  BigDataConstants,
  BroadCast,
  BroadCastConstants,
  BroadCastManager,
  ColumnSize,
  Constants as Cons,
  DataStoreUtil,
  Log,
  ReportToBigDataUtil,
  ScreenManager,
  UiUtil,
  UserFileManagerAccess,
  WindowUtil
} from '@ohos/common';
import { Constants, FormControllerManager } from '@ohos/formAbility';
import formBindingData from '@ohos.application.formBindingData';
import formProvider from '@ohos.application.formProvider';
import userFileManager from '@ohos.filemanagement.userFileManager';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import { Router } from '@ohos.arkui.UIContext';


const TAG: string = 'FormEditorPage';
declare type UnionType = number | boolean | string;
declare type DisplayNameUnionType = Resource | string;

@Entry
@Component
struct FormEditorPage {
  @StorageLink('FASetting_FormId') formId: string = '0';
  @StorageLink('isHorizontal') isHorizontal: boolean = ScreenManager.getInstance().isHorizontal();
  @StorageLink('isSidebar') isSidebar: boolean = ScreenManager.getInstance().isSidebar();
  @StorageLink('leftBlank') leftBlank: number[] =
    [0, ScreenManager.getInstance().getStatusBarHeight(), 0, ScreenManager.getInstance().getNaviBarHeight()];
  currentIndex: number = 0;
  @State isShowName: boolean = true;
  isShowAlbums: boolean = true;
  fd: number = Constants.FA_FD_NULL;
  fileAsset: userFileManager.FileAsset | null = null;
  displayName: string = '';
  albumUri: string = '';
  uri: string = '';
  @State time: number = 30;
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private saveDataFunc = async (
    albumName: string, albumUri: string, displayName: DisplayNameUnionType, uri: string, isShowAlbums: boolean
  ): Promise<void> => await this.saveData(albumName, albumUri, displayName, uri, isShowAlbums);
  private indexValue: number = 0;
  @State private selectAlbumsStr: string = '';

  async getItems(albumUri?: string, startIndex?: number, count?: number, filterMediaType?: string):
    Promise<Array<userFileManager.FileAsset>> {
    let result: userFileManager.FileAsset[] = [];

    // Get from target album if albumUri is not undefined, otherwise getAllObject
    if (albumUri) {
      let album: userFileManager.Album =
        await UserFileManagerAccess.getInstance().getAlbumByUri(albumUri) as userFileManager.Album;
      let fetchOpt = AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType);
      let fetchResult = await album.getPhotoAssets(fetchOpt);
      result = await fetchResult.getAllObject();
      fetchResult.close();
    } else {
      let fetchOpt = AlbumDefine.getFileFetchOpt(startIndex, count, filterMediaType);
      Log.debug(TAG, `getMediaItem start ${JSON.stringify(fetchOpt)}`);
      result = await UserFileManagerAccess.getInstance().getAllObject(fetchOpt);
    }
    return result;
  }

  async GetMediaData(albumUri: string, uri: string): Promise<void> {
    Log.debug(TAG, `GetMediaData start uri: ${uri} albumUri: ${albumUri}`);
    let dataList = await this.getItems(albumUri);
    if (uri != '') {
      for (let i = 0; i < dataList.length; i++) {
        let temUri = dataList[i].uri;
        if (temUri === uri) {
          this.currentIndex = i;
          break;
        }
      }
    } else {
      this.currentIndex = 0;
    }
    this.fileAsset = dataList[this.currentIndex];
    Log.debug(TAG, 'GetMediaData fileAsset: ' + JSON.stringify(this.fileAsset));
  }

  async openCurrentFd(): Promise<void> {
    this.fd = (this.fileAsset != null) ? await UserFileManagerAccess.getInstance().openAsset('R', this.fileAsset) as number
      : Constants.FA_FD_NULL;
  }

  bindFormData(): formBindingData.FormBindingData {
    Log.debug(TAG, `bindFormData start formId: ${this.formId}`);
    let image: string = 'image_' + this.fd + '_formId_' + this.formId + '_uri_' + this.uri;
    interface DataObjectType {
      fd: boolean;
      image0: string;
      image1: string;
      albumName: string;
      currentIndex: number;
      isShow: boolean;
      formImages: object;
      uri: string;
      albumUri: string;
      currentUri: string;
    }
    let dataObj1: DataObjectType = {
      fd: this.fd != Constants.FA_FD_NULL,
      image0: 'memory://' + image,
      image1: 'memory://' + image,
      albumName: this.displayName,
      currentIndex: this.currentIndex,
      isShow: Boolean(this.isShowName) && Boolean(this.isShowAlbums),
      formImages: JSON.parse(`{ "${image}": ${this.fd} }`) as object,
      uri: (this.uri != '') ? Cons.ACTION_URI_FORM_ABILITY : Cons.ACTION_URI_FORM_ABILITY_NONE,
      albumUri: `${this.albumUri}`,
      currentUri: this.uri
    };
    Log.debug(TAG, `bindFormData, createFormBindingData dataObj2.data: ${JSON.stringify(dataObj1)}`);
    let obj = formBindingData.createFormBindingData(JSON.stringify(dataObj1));
    Log.debug(TAG, `bindFormData, createFormBindingData obj2.data: ${JSON.stringify(obj.data)}`);
    return obj;
  }

  terminate(): void {
    let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
    context.terminateSelf((result: BusinessError<void>) => {
      Log.info(TAG, `terminateSelf result: ${JSON.stringify(result)}`);
    })
  }

  async updateFormData(): Promise<void> {
    Log.debug(TAG, `updateFormData formId: ${JSON.stringify(this.formId)}`);
    let dataStore = DataStoreUtil.getInstance();
    await dataStore.init();
    let temp: number = await dataStore.getData(Constants.FA_INDEX_VALUE, 0) as number;
    this.indexValue = (temp + 1) % 2;
    await dataStore.putData(Constants.FA_INDEX_VALUE, this.indexValue);
    await dataStore.flush();
    let obj3 = this.bindFormData();
    Log.debug(TAG, `updateFormData obj: ${JSON.stringify(obj3)}`);
    formProvider.updateForm(this.formId, obj3)
      .then((): void => {
        Log.debug(TAG, 'updateFormData, success');
        this.terminate();
      }).catch((error: BusinessError) => {
      Log.error(TAG, `updateForm failed. Cause: ${JSON.stringify(error)}`);
      interface Msg {
        err: string;
      }
      let msg: Msg = {
        err: JSON.stringify(error)
      }
      ReportToBigDataUtil.errEventReport(BigDataConstants.CHANGE_FA_CARD_IMAGE_ERROR, msg);
      this.terminate();
    });
  }

  async saveData(albumName: string, albumUri: string, displayName: DisplayNameUnionType,
                 uri: string, isShowAlbums: boolean): Promise<void> {
    Log.debug(TAG, `saveData start! ${albumUri} ${displayName}  ${uri}`);
    ReportToBigDataUtil.report(BigDataConstants.CHANGE_FA_CARD_IMAGE_ID, undefined);
    let msgDisplayName = '';
    if (displayName instanceof Object) {
      Log.debug(TAG, `saveData object ${displayName}`);
      msgDisplayName = await UiUtil.getResourceString(displayName as Resource) as string;
    } else {
      msgDisplayName = displayName as string;
    }
    this.isShowAlbums = isShowAlbums;
    this.displayName = msgDisplayName;
    this.albumUri = albumUri;
    this.uri = uri;
    Log.debug(TAG, `saveData msgDisplayName ${msgDisplayName}`);
    await DataStoreUtil.getInstance().init();
    await this.GetMediaData(albumUri, uri);
    await this.openCurrentFd();
    let formIdKey = 'formId_' + this.formId;
    let hasFormId = await DataStoreUtil.getInstance().hasData(formIdKey);
    Log.debug(TAG, `The value of hasFormId is ${hasFormId}`);
    if (hasFormId) {
      let displayNameKey = 'displayName_' + this.formId;
      await DataStoreUtil.getInstance().putData(displayNameKey, msgDisplayName);
      let albumNameKey = 'albumName_' + this.formId;
      await DataStoreUtil.getInstance().putData(albumNameKey, albumName);
      let albumUriKey = 'albumUri_' + this.formId;
      await DataStoreUtil.getInstance().putData(albumUriKey, albumUri);
      let currentUriKey = 'currentUri_' + this.formId;
      await DataStoreUtil.getInstance().putData(currentUriKey, uri);
      let currentIndexKey = 'currentIndex_' + this.formId;
      await DataStoreUtil.getInstance().putData(currentIndexKey, this.currentIndex);
      await DataStoreUtil.getInstance().flush();
      this.updateFormData();
    } else {
      let context: common.UIAbilityContext = AppStorage.get<common.UIAbilityContext>('photosAbilityContext') as common.UIAbilityContext;
      context.terminateSelf((result: BusinessError<void>) => {
        Log.info(TAG, `terminateSelf result: ${JSON.stringify(result)}`);
      })
    }
    Log.debug(TAG, 'saveData end!');
  }

  routerPhotos(isSelectPhoto: boolean): void {
    let albumUriKey = 'albumUri_' + this.formId;
    DataStoreUtil.getInstance().getData(albumUriKey, '').then((theAlbumUri: UnionType) => {
      let options: router.RouterOptions = {
        url: 'pages/ThirdSelectPhotoGridPage',
        params: {
          itemCoverUri: '',
          uri: theAlbumUri,
          itemCount: 1,
          bundleName: '',
          isMultiPick: false,
          filterMediaType: AlbumDefine.FILTER_MEDIA_TYPE_IMAGE,
          maxSelectCount: 1,
          itemDisplayName: $r('app.string.album_photos'),
          isFromFa: isSelectPhoto,
          isFromFaPhoto: isSelectPhoto,
          isFirstEnter: true
        }
      };
      router.pushUrl(options);
    })
  }

  selectPhoto(): void {
    this.routerPhotos(true);
  }

  aboutToAppear(): void {
    Log.debug(TAG, 'aboutToAppear start!');
    ScreenManager.getInstance().setSystemUi(false);
    this.appBroadCast.on(BroadCastConstants.SAVE_FORM_EDITOR_DATA, this.saveDataFunc);
  }

  aboutToDisappear() {
    this.appBroadCast.off(BroadCastConstants.SAVE_FORM_EDITOR_DATA, this.saveDataFunc);
  }

  onPageShow() {
    BroadCastManager.getInstance().getBroadCast().emit(BroadCastConstants.THIRD_ROUTE_PAGE, []);
  }

  onBackPress() {
    this.terminate();
  }

  build() {
    Column() {
      Row() {
        Row() {
          Image($r('app.media.ic_gallery_public_cancel'))
            .fillColor($r('app.color.white'))
            .width($r('app.float.ic_size_default'))
            .height($r('app.float.ic_size_default'))
            .margin({ left: $r('app.float.FA_back_margin_left') })
        }
        .alignItems(VerticalAlign.Center)
        .height($r('app.float.tab_bar_vertical_height'))
      }
      .padding({
        top: $r('app.float.album_set_page_action_bar_padding_top')
      })
      .width('100%')
      .onClick(() => {
        this.onBackPress();
      })

      Column() {
        Text($r('app.string.fa_title_text'))
          .fontSize($r('sys.float.ohos_id_text_size_headline8'))
          .fontColor($r('app.color.FA_title_text_color'))
          .fontWeight(FontWeight.Medium)

        Text($r('app.string.fa_subTitle_text'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .margin({ top: $r('app.float.tab_bar_padding_top') })
          .fontColor($r('app.color.FA_subTitle_text_color'))
      }
      .margin({ top: $r('app.float.FA_subTitle_margin_top'), bottom: $r('app.float.FA_title_margin_bottom') })

      Row() {
        Row() {
          Text($r('app.string.fa_select_image_text'))
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .fontColor($r('app.color.black'))
            .flexGrow(Constants.FLEX_GROW)
          Row() {
            Image($r('app.media.ic_gallery_form_arrow'))
              .width($r('app.float.form_list_card_more_arrow_w'))
              .height($r('app.float.form_list_card_more_arrow_h'))
              .fillColor($r('sys.color.ohos_id_color_fourth'))
          }
        }
        .height($r('app.float.title_default'))
        .width('100%')
        .key('FASelectPhoto')
        .padding({
          left: $r('app.float.FA_ListCard_padding_left'), right: $r('app.float.FA_ListCard_padding_left'),
        })
        .backgroundColor($r('app.color.white'))
        .borderRadius($r('app.float.FA_ListCard_radius'))
        .onClick((): void => {
          this.selectPhoto();
        })
      }
      .padding({ left: $r('app.float.FA_select_album_padding'), right: $r('app.float.FA_select_album_padding') })
    }
    .backgroundColor($r('app.color.FA_background_color'))
    .width('100%')
    .height('100%')
  }
}