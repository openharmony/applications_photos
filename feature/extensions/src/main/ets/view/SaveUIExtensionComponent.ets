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

import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy fs from '@ohos.file.fs';
import lazy { image } from '@kit.ImageKit';
import lazy display from '@ohos.display';
import lazy media from '@ohos.multimedia.media';
import lazy ability from '@ohos.ability.ability';
import lazy common from '@ohos.app.ability.common';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy systemParameterEnhance from '@ohos.systemParameterEnhance';
import lazy { mediaquery } from '@kit.ArkUI';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { CustomContentDialog } from '@ohos.arkui.advanced.Dialog';
import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { JSON } from '@kit.ArkTS';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy { PickerUtil } from '@ohos/common/src/main/ets/default/utils/PickerUtil';
import lazy { fileUri } from '@kit.CoreFileKit';

const TAG: string = 'SaveUIExtensionLog';
const listener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(orientation: landscape)');
/* instrument ignore file */
const SAVE_RESULT_SUCCESS: number = 0;
const SAVE_RESULT_FAILED: number = -1;
const SAVE_DIALOG_ICON_OUTSIDE: number = 32;
const TITLE_MAX_LINE: number = 2;
const TITLE_MAX_SCALE: number = 2;

@Component
export struct SaveUIExtensionComponent {
  private context: common.UIExtensionContext | null = getContext(this) as common.UIExtensionContext;
  private uris: string[] = [];
  private bundleName: string = '';
  private appName: string = '';
  private appId: string = '';
  private isPc: boolean = false;
  private photoTypeArray: photoAccessHelper.PhotoType[] = [];
  private photoCreateConfigs: photoAccessHelper.PhotoCreationConfig[] = [];
  private title: string = 'app.plural.third_save_picture_and_video';
  private session: UIExtensionContentSession | undefined;
  private wantParam: Record<string, Object> | undefined;
  @State private imageMaps: (string | image.PixelMap)[] = ['', ''];
  // 判断是否为横屏
  @State private transverse: boolean = false;
  // 是否调用短时授权接口
  private shortTerm: boolean = false;
  private tokenId: number = 0;
  // 授权模式
  private authorizationMode: number = 0;
  private grantAssetLength: number = 0;
  private dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomContentDialog({
      contentBuilder: () => {
        this.buildContent();
      },
      contentAreaPadding: { right: 0 },
      buttons: [
        {
          value: $r('app.string.dialog_ban'),
          buttonStyle: this.isPc ? ButtonStyleMode.NORMAL : ButtonStyleMode.TEXTUAL,
          action: () => {
            this.setSaveResult(false);
          }
        },
        {
          value: $r('app.string.dialog_allow'),
          buttonStyle: this.isPc ? ButtonStyleMode.NORMAL : ButtonStyleMode.TEXTUAL,
          action: () => {
            this.setSaveResult(true);
          }
        }
      ],
    }),
    autoCancel: false,
    cancel: () => {
      Log.warn(TAG, 'dialog cancel terminateSelfWithResult');
      let abilityResult: ability.AbilityResult = {
        resultCode: SAVE_RESULT_FAILED,
      };
      this.session?.terminateSelfWithResult(abilityResult);
    }
  });

  @Builder
  saveIcon(): void {
    Shape() {
      Circle({ width: SAVE_DIALOG_ICON_OUTSIDE, height: SAVE_DIALOG_ICON_OUTSIDE })
        .fill($r('sys.color.multi_color_03'))
      Row() {
        SymbolGlyph($r('sys.symbol.picture_fill'))
          .fontSize($r('app.float.save_dialog_icon_inside'))
          .fontColor([$r('sys.color.ohos_id_color_primary_contrary')])
          .draggable(false)
      }
      .offset({ x: $r('app.float.offset_6'), y: $r('app.float.offset_6') })
    }
  }

  @Builder
  saveImage(): void {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.uris.length > 1) {
        Column() {
          Image(this.imageMaps[1])
            .objectFit(ImageFit.Cover)
            .border({
              radius: $r('app.float.radius_24'),
              color: $r('sys.color.ohos_id_color_click_effect'),
              width: $r('app.float.save_image_border_width'),
            })
            .height('100%')
            .width('100%')
            .opacity(0.4)
            .autoResize(true)
        }
        .padding({ left: $r('app.float.padding_16'), right: $r('app.float.padding_16') })
      }

      Image(this.imageMaps[0])
        .objectFit(ImageFit.Cover)
        .border({
          radius: $r('app.float.radius_24'),
          color: $r('sys.color.ohos_id_color_click_effect'),
          width: $r('app.float.save_image_border_width'),
        })
        .height(this.uris.length > 1 ? $r('app.float.save_dialog_ico_height_multi') : '100%')
        .width('100%')
        .margin({ top: this.uris.length > 1 ? $r('app.float.margin_8') : 0 })
        .autoResize(true)
    }
    .width('100%')
    .height($r('app.float.save_dialog_ico_height'))
    .alignContent(Alignment.Top)
  }

  @Builder
  buildIconView(): void {
    Stack() {
      Stack() {
        Image($r('app.media.ic_public_privacy'))
          .draggable(false)
          .objectFit(ImageFit.Cover)
          .height(28)
          .width(28)
          .fillColor($r('sys.color.ohos_id_color_activated'));
      }
      .height(48)
      .width(48)
      .backgroundColor($r('sys.color.ohos_id_color_background'))
      .borderColor($r('sys.color.ohos_id_color_button_normal'))
      .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))
      .borderWidth(1)

      Image($r('app.media.img_gallery_icon'))
        .draggable(false)
        .objectFit(ImageFit.Cover)
        .height(20)
        .width(20)
        .borderColor($r('sys.color.ohos_id_color_hover'))
        .borderRadius($r('sys.float.ohos_id_corner_radius_default_xs'))
        .borderWidth(0.1)
        .offset({
          x: 14,
          y: 14,
        });
    }
    .height(48)
    .width(48)
    .margin({
      top: 24,
      bottom: 16,
    })
  }

  @Builder
  buildShortTermTitle(): void {
    Text($r(this.title, this.appName))
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

  @Builder
  buildOtherTitle(): void {
    Text($r(this.title, this.uris.length, this.appName, this.uris.length))
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

  @Builder
  buildIcon(): void {
    if (this.shortTerm) {
      this.buildIconView();
    } else {
      this.saveIcon();
    }
  }

  @Builder
  buildTitle(): void {
    if (this.shortTerm) {
      this.buildShortTermTitle();
    } else {
      this.buildOtherTitle();
    }
  }

  @Builder
  buildContent(): void {
    Scroll() {
      Column() {
        this.buildIcon()

        Column() {
          this.buildTitle()
        }
        .constraintSize({ minHeight: $r('app.float.dialog_title_height') })
        .justifyContent(FlexAlign.Center)
        .padding({
          top: $r('app.float.padding_12'),
          bottom: $r('app.float.padding_12'),
        })

        if (this.isShowThumbnail() && !this.shortTerm) {
          this.saveImage();
        }
      }
      .clip(true)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .padding({
        top: $r('app.float.padding_24'),
        left: $r('app.float.dialog_content_padding_left'),
        right: $r('app.float.dialog_content_padding_right'),
      })
    }
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: false })
  }

  build() {
  }

  aboutToAppear() {
    Log.info(TAG, 'SaveUIExtensionComponent appear.');
    this.screenListener();
    this.uris = this.wantParam?.['ability.params.stream'] as string[];
    this.shortTerm = this.wantParam?.shortTerm as boolean ?? false;
    Log.info(TAG, `shortTerm: ${this.shortTerm}`);
    if (!this.shortTerm && !PickerUtil.isArrayValid(this.uris)) {
      Log.info(TAG, 'uris parameter is invalid.');
      this.session?.terminateSelf();
      return;
    }
    this.bundleName = this.wantParam?.bundleName as string;
    this.appName = this.wantParam?.appName as string;
    this.appId = this.wantParam?.appId as string;
    this.tokenId = this.wantParam?.['ohos.aafwk.param.callerToken'] as number;
    let titleArray: string[] = this.wantParam?.titleArray as string[];
    let extensionArray: string[] = this.wantParam?.extensionArray as string[];
    let photoTypeArray: photoAccessHelper.PhotoType[] = this.wantParam?.photoTypeArray as photoAccessHelper.PhotoType[];
    let photoSubtypeArray: photoAccessHelper.PhotoSubtype[] =
      this.wantParam?.photoSubTypeArray as photoAccessHelper.PhotoSubtype[];
    this.photoTypeArray = photoTypeArray;
    if (!this.shortTerm && !PickerUtil.isArrayValid(this.photoTypeArray)) {
      Log.info(TAG, 'photoTypeArray parameter is invalid.');
      this.session?.terminateSelf();
      return;
    }
    if (!this.shortTerm) {
      this.grantAssetLength = Math.min(this.uris.length, photoTypeArray.length);
      Log.info(TAG, `grantAssetLength length is: ${this.grantAssetLength}`);
    }
    this.getImageMaps(0);
    this.getImageMaps(1);
    try {
      if (!this.shortTerm) {
        let imageArray = photoTypeArray.filter(type => type === photoAccessHelper.PhotoType.IMAGE);
        if (imageArray.length === photoTypeArray.length) {
          this.title = 'app.plural.third_save_picture';
        } else if (imageArray.length === 0) {
          this.title = 'app.plural.third_save_video';
        }

        for (let index = 0; index < this.grantAssetLength; index++) {
          let photoCreateConfig: photoAccessHelper.PhotoCreationConfig = {
            title: titleArray[index],
            fileNameExtension: extensionArray[index],
            photoType: photoTypeArray[index],
            subtype: photoSubtypeArray[index],
          };
          this.photoCreateConfigs.push(photoCreateConfig);
        }
      } else {
        this.title = 'app.string.short_term_title';
        let photoCreateConfig: photoAccessHelper.PhotoCreationConfig = {
          title: this.wantParam?.title as string,
          fileNameExtension: this.wantParam?.extension as string,
          photoType: this.wantParam?.photoType as photoAccessHelper.PhotoType,
          subtype: this.wantParam?.photoSubType as photoAccessHelper.PhotoSubtype,
        };
        this.photoCreateConfigs.push(photoCreateConfig);
      }
      Log.info(TAG, `photoCreateConfigs length is: ${this.photoCreateConfigs.length}`);
      Log.info(TAG, 'data collection success.');
      this.dialogController?.open();
    } catch (err) {
      Log.error(TAG, `data collection failure. err: ${err.code}, ${err.message}`);
      this.session?.terminateSelf();
    }
  }

  aboutToDisappear() {
    Log.info(TAG, 'aboutToDisappear');
    listener.off('change', this.changeFunc);
    this.dialogController = null;
  }

  private async setSaveResult(isSave: boolean) {
    Log.info(TAG, `setSaveResult terminateSelfWithResult isSave: ${isSave}`);
    let result: string[] = [];
    if (isSave) {
      result = await this.saveBox();
    }
    if (result?.length > 0) {
      let abilityResult: ability.AbilityResult = {
        resultCode: SAVE_RESULT_SUCCESS,
        want: {
          parameters: {
            'desFileUris': result
          }
        }
      };
      const msg: Record<string, number | string | boolean> = {
        'saveStatus': SAVE_RESULT_SUCCESS,
      };
      ReportToBigDataUtil.report(BigDataConstants.SAVE_DIALOG_STATUS, msg);
      this.session?.terminateSelfWithResult(abilityResult).then((result: void) => {
        Log.info(TAG, `session terminateSelfWithResult result: ${result}, abilityResult: ${
        JSON.stringify(abilityResult)}`);
      });
    } else {
      let abilityResult: ability.AbilityResult = {
        resultCode: SAVE_RESULT_FAILED,
        want: {
          parameters: {
            'desFileUris': ''
          }
        }
      };
      const msg: Record<string, number | string | boolean> = {
        'saveStatus': SAVE_RESULT_FAILED,
      };
      ReportToBigDataUtil.report(BigDataConstants.SAVE_DIALOG_STATUS, msg);
      this.session?.terminateSelfWithResult(abilityResult).then((result: void) => {
        Log.info(TAG, `session terminateSelfWithResult result: ${result}, abilityResult ${
        JSON.stringify(abilityResult)}`);
      });
    }
  }

  private async saveBox(): Promise<string[]> {
    try {
      let phAccessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.context);
      let result: string[] = this.shortTerm
        ? await phAccessHelper.createAssetsForAppWithMode(
          this.bundleName,
          this.appName,
          this.appId,
          this.tokenId,
          this.authorizationMode,
          this.photoCreateConfigs
        )
        : await phAccessHelper.createAssetsForApp(
          this.bundleName,
          this.appName,
          this.tokenId,
          this.photoCreateConfigs
        );
      Log.info(TAG, 'Photo createAssetsForApp success.');
      return result;
    } catch (err) {
      Log.error(TAG, `Photo createAssetsForApp failed with error: ${err.code}, ${err.message}`);
      return [];
    }
  }

  private async getImageMaps(index: number) {
    Log.info(TAG, `index: ${index},this.grantAssetLength:${this.grantAssetLength}`);
    if (!this.uris) {
      return;
    }
    if (index > this.grantAssetLength - 1) {
      return;
    }
    let uri: string = this.uris[index];
    const hiddenFileAsset = await UserFileManagerAccess.getInstance().getHiddenFileAsset(uri);
    if (hiddenFileAsset) {
      Log.info(TAG, '[getImageMaps] media is in hidden album');
      return;
    }
    let type: photoAccessHelper.PhotoType = this.photoTypeArray[index];
    let imgFile: fs.File | undefined;
    let imageSource: image.ImageSource | undefined;
    let avImageGenerator: media.AVImageGenerator | undefined;
    try {
      if (type === photoAccessHelper.PhotoType.IMAGE) {
        this.imageMaps[index] = uri;
      } else {
        avImageGenerator = await media.createAVImageGenerator();
        avImageGenerator.fdSrc = await fs.open(uri);
        this.imageMaps[index] =
          await avImageGenerator.fetchFrameByTime(0, media.AVImageQueryOptions.AV_IMAGE_QUERY_CLOSEST_SYNC, {});
      }
    } catch (err) {
      Log.error(TAG, `get PixelMap failed. error code: ${err?.code}, error message: ${err?.message}`);
    } finally {
      if (type === photoAccessHelper.PhotoType.IMAGE) {
        imageSource?.release();
        Log.info(TAG, `[fd flag] getImageMaps ,fs close imgFile.fd: ${imgFile?.fd}`);
        fs.closeSync(imgFile?.fd);
      } else {
        Log.info(TAG, `[fd flag] getImageMaps ,fs close fdSrc.fd: ${avImageGenerator?.fdSrc?.fd}`);
        fs.closeSync(avImageGenerator?.fdSrc?.fd);
        avImageGenerator?.release();
      }
    }
  }

  private getFontSizeScale(): number {
    const FONT_SIZE_SCALE_PARAM: string = 'persist.sys.font_scale_for_user0';
    let fontSizeScale: number = Number.parseFloat(systemParameterEnhance.getSync(FONT_SIZE_SCALE_PARAM, '1'));
    return fontSizeScale;
  }

  private isShowThumbnail(): boolean {
    if (!this.transverse) {
      return true;
    }
    if (!DeviceInfo.isPhoneUx()) {
      return true;
    }
    /* instrument ignore next */
    if (DeviceInfo.isFoldable()) {
      return true;
    }
    return false;
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

  private screenListener() {
    try {
      // 初始化获取设备横竖屏状态
      let displayInfo: display.Display = display.getDefaultDisplaySync();
      let orientation: display.Orientation = displayInfo.orientation;
      this.transverse =
        orientation === display.Orientation.LANDSCAPE || orientation === display.Orientation.LANDSCAPE_INVERTED;
    } catch (error) {
      Log.error(TAG, `get displayInfo failed. error code: ${error?.code}, error message: ${error?.message}`);
    }

    listener.on('change', this.changeFunc)
  }

  private changeFunc: Callback<mediaquery.MediaQueryResult> = (mediaQueryResult: mediaquery.MediaQueryResult) => {
    Log.info(TAG, `landscape state: ${mediaQueryResult.matches}`);
    this.transverse = mediaQueryResult.matches;
  };
}