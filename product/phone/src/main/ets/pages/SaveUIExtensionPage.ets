/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import fs from '@ohos.file.fs';
import image from '@ohos.multimedia.image';
import media from '@ohos.multimedia.media';
import ability from '@ohos.ability.ability';
import { Constants, Log } from '@ohos/common';
import common from '@ohos.app.ability.common';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { CustomContentDialog } from '@ohos.arkui.advanced.Dialog';

const TAG: string = 'SaveUIExtension';
let storage = LocalStorage.getShared();

@Entry(storage)
@Component
export struct SaveUIExtensionPage {
  private context = getContext(this) as common.UIExtensionContext;
  private uris: Array<string> = [];
  private bundleName: string = '';
  private appName: string = '';
  private appId: string = '';
  private photoTypeArray: photoAccessHelper.PhotoType[] = [];
  private srcFileUris: Array<photoAccessHelper.PhotoCreationConfig> = [];
  private title: string = 'app.string.third_save_dialog_picture_and_video';
  private wantParam: Record<string, Object> = storage.get('wantParam') as Record<string, Object>;
  private session: UIExtensionContentSession =
    storage.get<UIExtensionContentSession>('session') as UIExtensionContentSession;
  @State private imageMaps: (string | image.PixelMap)[] = ['', ''];

  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.buildContent();
      },
      contentAreaPadding: { right: 0 },
      buttons: [
        {
          value: $r('app.string.dialog_ban'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            this.setSaveResult(false);
          }
        },
        {
          value: $r('app.string.dialog_allow'),
          buttonStyle: ButtonStyleMode.TEXTUAL,
          action: () => {
            this.setSaveResult(true);
          }
        }
      ],
    }),
    autoCancel: false,
    cancel: () => {
      this.context.terminateSelf();
    }
  });

  @Builder
  buildContent(): void {
    Column() {
      Shape() {
        Circle({ width: Constants.NUMBER_32, height: Constants.NUMBER_32 })
          .fill($r('sys.color.multi_color_03'))
        Row() {
          SymbolGlyph($r('sys.symbol.picture_fill'))
            .fontSize(Constants.NUMBER_20)
            .fontColor([$r('sys.color.ohos_id_color_primary_contrary')])
            .draggable(false)
        }
        .offset({ x: $r('app.float.offset_6'), y: $r('app.float.offset_6') })
      }

      Column() {
        Text($r(this.title, this.appName, this.uris.length))
          .textAlign(TextAlign.Center)
          .fontSize($r('sys.float.Title_S'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'))
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(Constants.NUMBER_2)
          .minFontSize($r('sys.float.Subtitle_M'))
          .maxFontSize($r('sys.float.Title_S'))
          .heightAdaptivePolicy(TextHeightAdaptivePolicy.MIN_FONT_SIZE_FIRST)
      }
      .height($r('app.float.dialog_title_height'))
      .justifyContent(FlexAlign.Center)

      Stack({ alignContent: Alignment.Bottom }) {
        if (this.uris.length > 1) {
          Column() {
            Image(this.imageMaps[1])
              .objectFit(ImageFit.Cover)
              .border({
                radius: $r('app.float.radius_24'),
                color: $r('sys.color.ohos_id_color_click_effect'),
                width: $r('app.float.save_image_border')
              })
              .height('100%')
              .width('100%')
              .opacity(0.4)
          }
          .padding({ left: $r('app.float.padding_16'), right: $r('app.float.padding_16') })
        }

        Image(this.imageMaps[0])
          .objectFit(ImageFit.Cover)
          .border({
            radius: $r('app.float.radius_24'),
            color: $r('sys.color.ohos_id_color_click_effect'),
            width: $r('app.float.save_image_border')
          })
          .height(this.uris.length > 1 ? $r('app.float.third_delete_dialog_ico_height_multi') : '100%')
          .width('100%')
          .margin({ top: this.uris.length > 1 ? $r('app.float.margin_8') : 0 })
      }
      .width('100%')
      .height($r('app.float.third_delete_dialog_ico_height'))
      .alignContent(Alignment.Top)
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .padding({
      top: $r('app.float.padding_24'),
      bottom: $r('app.float.padding_8'),
      left: $r('app.float.dialog_content_padding_left'),
      right: $r('app.float.dialog_content_padding_right')
    })
  }

  build() {}

  onPageShow() {
    this.session.setWindowBackgroundColor('#00000000');
  }

  aboutToAppear() {
    this.uris = this.wantParam?.['ability.params.stream'] as string[];
    this.bundleName = this.wantParam?.bundleName as string;
    this.appName = this.wantParam?.appName as string;
    this.appId = this.wantParam?.appId as string;
    let titleArray = this.wantParam?.titleArray as string[];
    let extensionArray = this.wantParam?.extensionArray as string[];
    let photoTypeArray = this.wantParam?.photoTypeArray as photoAccessHelper.PhotoType[];
    let photoSubtypeArray = this.wantParam?.photoSubTypeArray as photoAccessHelper.PhotoSubtype[];
    this.photoTypeArray = photoTypeArray;
    this.getImageMaps(0);
    this.getImageMaps(1);
    try {
      let imageArray = photoTypeArray.filter(type => type === photoAccessHelper.PhotoType.IMAGE);
      if (imageArray.length === photoTypeArray.length) {
        this.title = 'app.string.third_save_dialog_picture';
      } else if (imageArray.length === 0) {
        this.title = 'app.string.third_save_dialog_video';
      }
      titleArray.forEach((title, idx) => {
        let photoCreateConfig = {
          title,
          fileNameExtension: extensionArray[idx],
          photoType: photoTypeArray[idx],
          subtype: photoSubtypeArray[idx]
        } as photoAccessHelper.PhotoCreationConfig;
        this.srcFileUris.push(photoCreateConfig);
      })
      Log.info(TAG, `srcFileUris: ${JSON.stringify(this.srcFileUris)}.`);
      this.dialogController?.open();
    } catch (err) {
      Log.error(TAG, `aboutToAppear data collection failure. err: ${JSON.stringify(err)}`);
      this.session.terminateSelf();
    }
  }

  private async setSaveResult(isSave: boolean) {
    if (isSave) {
      let result = await this.saveBox();
      let abilityResult: ability.AbilityResult = {
        resultCode: 0,
        want: {
          parameters: {
            'desFileUris': result
          }
        }
      };
      Log.info(TAG, 'terminateSelfWithResult start, abilityResult:' + JSON.stringify(abilityResult));
      this.session.terminateSelfWithResult(abilityResult);
    } else {
      let abilityResult: ability.AbilityResult = {
        resultCode: -1
      };
      Log.info(TAG, 'terminateSelfWithResult start, isSave:' + isSave);
      this.session.terminateSelfWithResult(abilityResult);
    }
  }

  async saveBox(): Promise<Array<string>> {
    try {
      let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
      let result: string[] =
        await phAccessHelper.createAssetsForApp(this.bundleName, this.appName, this.appId, this.srcFileUris);
      Log.info(TAG, `Photo agentCreateAssets: ${JSON.stringify(result)}`);
      return result;
    } catch (err) {
      Log.error(TAG, `Photo agentCreateAssets failed with error: ${err.code}, ${err.message}.`);
      return [];
    }
  }

  private async getImageMaps(index: number) {
    if (!this.uris) {
      return;
    }
    if (index > this.uris.length - 1) {
      return;
    }
    let uri: string = this.uris[index];
    let type: photoAccessHelper.PhotoType = this.photoTypeArray[index];
    let imgFile: fs.File | undefined;
    let imageSource: image.ImageSource | undefined;
    let avImageGenerator: media.AVImageGenerator | undefined;
    try {
      if (type === photoAccessHelper.PhotoType.IMAGE) {
        imgFile = fs.openSync(uri);
        imageSource = image.createImageSource(imgFile.fd);
        this.imageMaps[index] = imageSource.createPixelMapSync();
      } else {
        avImageGenerator = await media.createAVImageGenerator();
        avImageGenerator.fdSrc = fs.openSync(uri);
        this.imageMaps[index] =
          await avImageGenerator.fetchFrameByTime(0, media.AVImageQueryOptions.AV_IMAGE_QUERY_CLOSEST_SYNC, {});
      }
    } catch (err) {
      Log.error(TAG, `get PixelMap failed with error: ${err.code}, ${err.message}.`);
    } finally {
      if (type === photoAccessHelper.PhotoType.IMAGE) {
        imageSource?.release();
        fs.closeSync(imgFile?.fd);
      } else {
        fs.closeSync(avImageGenerator?.fdSrc?.fd);
        avImageGenerator?.release();
      }
    }
  }
}