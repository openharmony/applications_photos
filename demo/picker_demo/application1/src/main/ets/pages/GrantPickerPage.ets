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

import lazy { photoAccessHelper } from '@kit.MediaLibraryKit'
import lazy { BusinessError } from '@kit.BasicServicesKit'

@Entry
@Component
struct GrantPickerPage {
  @State allBackGroundColor: number = 0xf1f3f5;
  private uris: string[] = [];
  @State private results: string[] = [];
  @State private isShowWithoutGrant: boolean = false;

  build() {
    Row() {
      Column() {
        Button('先拉picker选择图片构造传入的uri')
          .width('100%')
          .height('10%')
          .margin({ top: 50 })
          .onClick(() => {
            this.uris = [];
            let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
            photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
            photoSelectOptions.maxSelectNumber = 200;
            let photoPicker = new photoAccessHelper.PhotoViewPicker();
            console.info('PhotoViewPicker.select start');
            photoPicker.select(photoSelectOptions).then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
              this.uris = photoSelectResult.photoUris;
            }).catch((err: BusinessError) => {
              console.error('PhotoViewPicker.select failed with err: ' + JSON.stringify(err));
            });
            console.info('PhotoViewPicker.select end');
          })
          .margin(10)

        Button('未拉授权直接渲染')
          .width('100%')
          .height('10%')
          .margin({ top: 100 })
          .onClick(() => {
            this.isShowWithoutGrant = true;
          })
          .margin(10)

        Button('再拉授权界面选择后进行渲染')
          .width('100%')
          .height('10%')
          .margin({ top: 150 })
          .onClick(() => {
            this.results = [];

            let phAccessHelper: photoAccessHelper.PhotoAccessHelper =
              photoAccessHelper.getPhotoAccessHelper(getContext(this));
            phAccessHelper.requestPhotoUrisReadPermission(this.uris).then((result: Array<string>) => {
              console.log(`requestPhotoUrisReadPermission,pxy,,result=${JSON.stringify(result)}`);
              if (result) {
                this.results = result;
                this.isShowWithoutGrant = true;
              }
            })
          })
          .margin(10)

        Button('再次操作时先清除')
          .width('100%')
          .height('10%')
          .margin({ top: 200 })
          .onClick(() => {
            this.results = [];
            this.uris = [];
            this.isShowWithoutGrant = false;
          })
          .margin(10)

        Text('未授权渲染区域').width('100%').height('3%')
        if (this.isShowWithoutGrant) {
          Row() {
            ForEach(this.uris, (uri: string) => {
              Image(uri).height('100%').width('20%');
            }, (uri: string) => JSON.stringify(uri))
          }.width('100%').height('10%')
        }

        Text('已授权渲染区域').width('100%').height('3%')
        Row() {
          ForEach(this.results, (uri: string) => {
            Image(uri).height('100%').width('20%');
          }, (uri: string) => JSON.stringify(uri))
        }.width('100%').height('10%')
      }
      .width('100%')
    }
    .height('100%')
  }
}
