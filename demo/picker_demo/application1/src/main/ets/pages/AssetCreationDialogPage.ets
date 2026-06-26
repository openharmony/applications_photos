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

import lazy picker from '@ohos.multimedia.cameraPicker'
import lazy camera from '@ohos.multimedia.camera';
import lazy common from '@ohos.app.ability.common';
import lazy { BusinessError } from '@ohos.base';
import lazy fileuri from '@ohos.file.fileuri';
import lazy fs from '@ohos.file.fs';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';
import lazy { hilog } from '@kit.PerformanceAnalysisKit';
import lazy { promptAction } from '@kit.ArkUI';
import lazy { fileIo } from '@kit.CoreFileKit';
import lazy { dataSharePredicates } from '@kit.ArkData';

let context = getContext(this) as common.Context;


class CameraPosition {
  public cameraPosition: camera.CameraPosition
  public saveUri: string

  constructor(cameraPosition: camera.CameraPosition, saveUri: string) {
    this.cameraPosition = cameraPosition
    this.saveUri = saveUri
  }
}

let pathDir = getContext().filesDir;
//沙箱路径地址
console.log('保存路径为' + pathDir)
let filePath = pathDir + '/picture.jpg'
fs.createRandomAccessFileSync(filePath, fs.OpenMode.CREATE);
let uri = fileuri.getUriFromPath(filePath);

async function photo() {
  try {
    let pickerProfile = new CameraPosition(camera.CameraPosition.CAMERA_POSITION_BACK, uri)
    let pickerResult: picker.PickerResult = await picker.pick(context,
      [picker.PickerMediaType.PHOTO, picker.PickerMediaType.VIDEO], pickerProfile);
    console.log('the pick pickerResult is:' + JSON.stringify(pickerResult));
  } catch (error) {
    let err = error as BusinessError;
    console.error(`the pick call failed. error code: ${err.code}`);
  }
}

async function picture() {
  let photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
  photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
  photoSelectOptions.maxSelectNumber = 1;
  let photoPicker = new photoAccessHelper.PhotoViewPicker();
  photoPicker.select(photoSelectOptions).then((potoSelectResult: photoAccessHelper.PhotoSelectResult) => {
    let photouri: string[] = potoSelectResult.photoUris
    let file = fs.openSync(photouri[0], fs.OpenMode.READ_ONLY)
    let file2 = fs.openSync(pathDir + '/picture2.jpg', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
    fs.copyFileSync(file.fd, file2.fd)
    fs.closeSync(file);
    fs.closeSync(file2);
  })
}

const TAG: string = 'pxy';
const DOMAIN_NUMBER: number = 0xFF00;

@Entry
@Component
export struct AssetCreationDialogPage {
  private context = getContext(this) as common.UIAbilityContext;
  private srcUris: string[] = [];

  build() {
    Column() {
      Button('选择并保存').onClick(() => {
        picture();

        let tempDir = this.context.tempDir;
        // 获取应用文件路径
        hilog.info(DOMAIN_NUMBER, TAG, `tempDir 0: ${tempDir}`);
        let filePath = tempDir + 'temptest.txt';
        this.srcUris = [filePath];
        hilog.info(DOMAIN_NUMBER, TAG, `filePath 1: ${filePath}`);


      })
      Button('拍照并保存').onClick(() => {
        photo()
      })

      Button('保存沙箱路径文件').onClick(async () => {
        try {
          // 获取需要保存到媒体库的位于应用沙箱的图片/视频uri
          let srcFileUris: string[] = [
            'file://media/Photo/1/IMG_1737631191_000/screenshot_20250123_191811.jpg',
            //storage/cloud/files/Photo/16/IMG_1737631191_000.jpg
            'file://media/Photo/2/IMG_1737631204_001/IMG_20250123_191824.jpg',
            //storage/cloud/files/Photo/1/IMG_1737631204_001.jpg
            'file://media/Photo/1111/111/111.jpg', ///storage/cloud/files/Photo/16/IMG_1737183586_000.jpg
            'file://media/Photo/2/IMG_1737183586_001/IMG_20250118_145806_1.jpg', //storage/cloud/files/Photo/1/IMG_1737183586_001.jpg
          ];
          let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);

          console.info(TAG, 'ShowAssetsCreationDialogDemo.');

          let photoCreationConfigs: photoAccessHelper.PhotoCreationConfig[] = [
            {
              title: '', // 可选
              fileNameExtension: 'jpg',
              photoType: photoAccessHelper.PhotoType.IMAGE,
              subtype: photoAccessHelper.PhotoSubtype.DEFAULT, // 可选
            },
            {
              title: 'abc', // 可选
              fileNameExtension: 'jpg',
              photoType: photoAccessHelper.PhotoType.IMAGE,
              subtype: photoAccessHelper.PhotoSubtype.DEFAULT, // 可选
            },
            {
              title: 'cc', // 可选
              fileNameExtension: 'jpg',
              photoType: photoAccessHelper.PhotoType.IMAGE,
              subtype: photoAccessHelper.PhotoSubtype.DEFAULT, // 可选
            },
            {
              title: 'ee', // 可选
              fileNameExtension: 'jpg',
              photoType: photoAccessHelper.PhotoType.IMAGE,
              subtype: photoAccessHelper.PhotoSubtype.DEFAULT, // 可选
            }
          ];

          console.info(TAG, 'srcFileUris' + srcFileUris);
          let desFileUris: string[] =
            await phAccessHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs);

          console.info(TAG, 'showAssetsCreationDialog success, data is ' + desFileUris);

          let file = fileIo.openSync(desFileUris[1], fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);


          let buffer = new ArrayBuffer(4096);
          let view = new Uint8Array(buffer);

          console.log(TAG, `read pic head data is ${view}`);

          fileIo.closeSync(file);

        } catch (err) {
          console.error(TAG, 'showAssetsCreationDialog failed, errCode is ' + err.code + ', errMsg is ' + err.message);
        }

      })
    }
  }
}