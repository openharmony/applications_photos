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
import lazy { FormConstants } from '@ohos/common/src/main/ets/default/model/common/FormConstants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy {
  PayloadData,
  PhotoProcessHandler
} from '@ohos/dataprovider/src/main/ets/database/service/PhotoProcessHandler';
import { IsShowAlbumName } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/FaCardTable';


export enum widgetCardType {
  WIDGET_CARD_2x2 = 'WidgetCard',
  WIDGET_CARD_2x4 = 'WidgetCard2x4',
  WIDGET_CARD_4x4 = 'WidgetCard4x4'
}

export class WidgetCardViewModel {
  private tag: string = '';
  private widgetCardContext: Object;
  private agendaObjList: Array<PayloadData> = [];
  private formId: string = '';
  public pixel: PixelMap | ResourceStr = FormConstants.DEFAULT_IMAGE;
  public otherPixel?: PixelMap | ResourceStr = FormConstants.DEFAULT_IMAGE;
  public showOtherImage: boolean = false;
  public currentUri: string = '';
  public otherUri: string = '';
  private setTimeout: boolean = false;
  private albumUri: string = '';
  private index: number = 2;
  private hasAppear = false;
  private inAnimation: boolean = false;
  private defaultImage: Resource = $r('app.media.form_default_bg');
  private lastCallTime: number = 0;
  public isShowAlbumName: number = 1;
  public albumName:string = '';
  public albumNameTmp:string = '';

  constructor(context: Object, widgetCardType: string) {
    this.widgetCardContext = context;
    this.tag = widgetCardType;
  }

  public aboutToAppear(): void {
    this.hasAppear = true;
    Log.info(this.tag, `WidgetCard aboutToAppear, formId = ${this.formId}`);
  }

  public formIdChange(formId: string) {
    this.formId = formId;
    Log.info(this.tag, `WidgetCard formIdChange = ${this.formId}`)
  }

  public aboutToDisappear(): void {
    Log.info(this.tag, `WidgetCard aboutToDisappear, formId = ${this.formId}`);
  }

  public parseFirstObj(is2x4: boolean = false): void {
    try {
      // 解析第一张
      Log.info(this.tag, `parseFirstObj in.`)
      this.index--;
      let dataPayload: PayloadData;
      if (this.showOtherImage) {
        dataPayload = this.agendaObjList[1];
      } else {
        dataPayload = this.agendaObjList[0];
      }
      this.formId = String(dataPayload.form_id);
      this.pixel = PhotoProcessHandler.getPixelFromPayload(dataPayload, is2x4);
      this.albumUri = dataPayload.album_uri;
      Log.info(this.tag, 'parseFirstObj currentUri before' + this.currentUri);
      this.albumName = dataPayload.album_name ?? '';
      this.isShowAlbumName = dataPayload.is_show_album_name ?? IsShowAlbumName.OFF;
      this.currentUri = dataPayload.image_uri;
      Log.info(this.tag, 'parseFirstObj currentUri after' + this.currentUri);
      Log.info(this.tag, `parseFirstObj end.`)
      return;
    } catch (error) {
      Log.error(this.tag, `parseFirstObj with error: ${error.code}, ${error.message}`);
    }
  }

  public parseNextObj(is2x4: boolean = false): void {
    try {
      // 解析下一张
      Log.info(this.tag, `parseNextObj in.`)
      this.index--;
      let nextDataPayload: PayloadData = this.agendaObjList[1];
      this.albumUri = nextDataPayload.album_uri;
      this.albumName = nextDataPayload.album_name ?? '';
      this.isShowAlbumName = nextDataPayload.is_show_album_name ?? IsShowAlbumName.OFF;
      Log.info(this.tag,
        'parseNextObj showOtherImage: ' + this.showOtherImage + ', parseNextObj albumUri: ' + this.albumUri);
      let curPixel: PixelMap | ResourceStr = PhotoProcessHandler.getPixelFromPayload(nextDataPayload, is2x4);
      if (this.showOtherImage) {
        this.pixel = curPixel;
        this.currentUri = nextDataPayload.image_uri;
      } else {
        this.otherPixel = curPixel;
        this.otherUri = nextDataPayload.image_uri;
      }
      Log.info(this.tag, `parseNextObj end. [${this.currentUri}, ${this.otherUri}]`)
      return;
    } catch (error) {
      Log.error(this.tag, `parseNextObj with error: ${error?.code}, ${error?.message}`);
    }
  }

  public doAnimation(): void {
    Log.info(this.tag, 'doAnimation start:' + this.inAnimation);
    if (this.inAnimation) {
      return;
    }
    this.inAnimation = true;
    const start = new Date().getTime();
    animateTo({
      duration: FormConstants.DELAY_DURATION,
      curve: Curve.Smooth,
      onFinish: () => {
        animateTo({
          duration: FormConstants.ANIMATION_DURATION,
          curve: Curve.Sharp,
          expectedFrameRateRange: {
            min: 60,
            max: 120,
            expected: 60
          },
          onFinish: () => {
            this.inAnimation = false;
            const end = new Date().getTime();
            Log.info(this.tag, `doAnimation end: ${this.inAnimation}, cost ${end - start}ms`);
            this.startLightGlimpse();
          }
        }, (): void => {
          this.showOtherImage = !this.showOtherImage;
        })
      }
    }, (): void => {
      this.setTimeout = !this.setTimeout;
    })
  }

  private startLightGlimpse(): void {
    return;
  }

  // 卡片接受到数据，但是不处理，就会展示默认图片
  public onAgendaObjListChange(agendaObjList: Array<PayloadData>, is2x4: boolean = false): void {
    this.agendaObjList = agendaObjList;
    try {
      if (!this.agendaObjList?.length) {
        Log.info(this.tag, 'agendaObjList is null');
        this.currentUri = '';
        this.otherUri = '';
        this.pixel = this.defaultImage;
        this.otherPixel = this.defaultImage;
        return;
      }

      Log.info(this.tag, `agendaObjList size ${this.agendaObjList.length};` +
        ` showOtherImage: ${this.showOtherImage}; this.index: ${this.index}`);
      for (let i = 0; i < this.agendaObjList.length; i++) {
        Log.info(this.tag,
          `index = ${i} id = ${this.agendaObjList[i]._id} formId = ${this.agendaObjList[i].form_id} image_data.length = ${this.agendaObjList[i].image_data?.length}}`)
      }
      Log.info(this.tag, `agendObjList1: ${this.agendaObjList[0]?.image_uri?.split('/')}`);
      Log.info(this.tag, `agendObjList2: ${this.agendaObjList[1]?.image_uri?.split('/')}`);

      if (this.agendaObjList.length === 2) {
        // TODO fa 依赖两个隐藏逻辑：1、Card会在10s销毁。2、每次都会触发两次watch事件
        if (this.hasAppear) {
          this.parseNextObj(is2x4);
          // 为了避免截图下树之后，组件上树仍未渲染完成，卡片截图下树时间会推迟300毫秒。卡片切换动效相应推迟
          // 因为卡片组件不支持定时器，使用动效时长来实现推迟效果
          this.doAnimation();
        } else {
          this.parseFirstObj(is2x4);
        }
      } else if (this.agendaObjList.length === 1) {
        // 单张图片直接解析return
        const dataPayload: PayloadData = this.agendaObjList[0];
        this.formId = String(dataPayload.form_id);
        this.albumUri = dataPayload.album_uri;
        this.albumName = dataPayload.album_name ?? '';
        this.isShowAlbumName = dataPayload.is_show_album_name ?? IsShowAlbumName.OFF;
        let curPixel: PixelMap | ResourceStr = PhotoProcessHandler.getPixelFromPayload(dataPayload, is2x4);
        if (this.showOtherImage) {
          this.otherPixel = curPixel;
          this.otherUri = dataPayload.image_uri;
        } else {
          this.pixel = curPixel;
          this.currentUri = dataPayload.image_uri;
        }
        if (this.agendaObjList[0]?.is_hidden) {
          Log.info(this.tag, `agendaObjList[0] is_hidden = ${this.agendaObjList[0]?.is_hidden}`);
          this.currentUri = '';
          this.otherUri = '';
          this.pixel = this.defaultImage;
          this.otherPixel = this.defaultImage;
        }
        this.startLightGlimpse();
      }
    } catch (error) {
      Log.error(this.tag, `onAgendaObjListChange with error: ${error.code}, ${error.message}`);
    }
  }

  public getFormLinkParams(isCurrent: boolean): FormLinkOptions {
    const optionUri = isCurrent ? this.currentUri : this.otherUri;
    const options: FormLinkOptions = {
      action: 'router',
      abilityName: 'com.ohos.photos.MainAbility',
      params: {
        currentUri: optionUri,
        uri: optionUri.length > 0 ? 'formAbility' : 'formAbilityNone',
        albumUri: this.albumUri,
        cardType: 'normalCard',
        formId: this.formId,
      }
    }
    Log.info(this.tag, `getFormLinkParams: [${isCurrent},${this.formId},${optionUri},${this.albumUri}]`);
    return options;
  }
}
