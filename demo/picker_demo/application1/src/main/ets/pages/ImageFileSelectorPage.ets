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
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { dataSharePredicates } from '@kit.ArkData';
import lazy { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct ImageFileSelectorPage {
  uris: Array<string> = [];
  @State url: string = '';

  build() {
    Column() {
      // 问题一，唤起picker退出后，结果响应偏慢，导致其他点击事件失效，这里可以这样操作 点击选择——》弹出picker后取消-》马上再次点击选择（此时失效了，要稍等一会再点击才能弹出picker）
      Button('选择')
        .onClick(() => {
          this.pickSystemPhoto();
          console.log('pxy, pickSystemPhoto, uri:' + this.url)
        })
      // 问题二，这里选完系统图片后，手动修改名字，然后去判断文件是否存在时依然能判断出文件存在
      // 例如 选完后图片返回 file://media/Photo/270/IMG_1734056093_263/c59f011064014c76aa5513e42fe32448.jpg
      // 修改成file://media/Photo/270/IMG_1734056093_263/c59.jpg
      TextInput({
        text: this.url,
      }).onChange((value) => {
        this.url = value;
      })

      Button('判断该文件是否存在')
        .onClick(() => {
          this.uriGetAssets()
        })
    }
    .alignItems(HorizontalAlign.Center)
    .margin({
      top: 30,
    })
    .width('100%')
  }

  pickSystemPhoto() {
    const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
    photoSelectOptions.maxSelectNumber = 1; // 选择媒体文件的最大数目
    photoSelectOptions.preselectedUris = this.uris
    const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
    photoViewPicker.select(photoSelectOptions).then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
      this.uris = photoSelectResult.photoUris;
      if (this.uris.length > 0) {
        this.url = this.uris[0]
      } else {
        this.url = ''
      }
    }).catch((err: BusinessError) => {
      console.error(`Invoke photoViewPicker.select failed, code is ${err.code}, message is ${err.message}`);
    })
  }

  async uriGetAssets() {
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> | undefined = undefined;
    try {
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      // 配置查询条件，使用PhotoViewPicker选择图片返回的uri进行查询
      predicates.equalTo('uri', this.url);
      let fetchOption: photoAccessHelper.FetchOptions = {
        fetchColumns: [photoAccessHelper.PhotoKeys.TITLE],
        predicates: predicates,
      };
      fetchResult = await phAccessHelper.getAssets(fetchOption);
      // 得到uri对应的PhotoAsset对象，读取文件的部分信息
      const asset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
      console.log('pxy, uri:' + this.url + 'fetchOption=' + JSON.stringify(fetchOption) + ', fetchResult=' +
      JSON.stringify(fetchResult));
      promptAction.showToast({
        message: '文件存在'
      })
    } catch (error) {
      promptAction.showToast({
        message: '文件不存在'
      })
      console.error('uriGetAssets failed with err: ' + JSON.stringify(error));
    } finally {
      fetchResult?.close();
      phAccessHelper?.release();
      Log.info(TAG, `fetchResult is close.`);
    }
  }
}