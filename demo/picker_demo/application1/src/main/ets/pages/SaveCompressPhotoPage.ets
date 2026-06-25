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

import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { fileIo, fileUri } from '@kit.CoreFileKit';
import lazy { image } from '@kit.ImageKit';
import lazy { resourceManager } from '@kit.LocalizationKit';
import lazy { hilog } from '@kit.PerformanceAnalysisKit';
import lazy { util } from '@kit.ArkTS';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';

const TAG = 'IMAGE_COMPRESSION';
const TAG2 = 'IMAGE_COMPRESSION_2';

class CompressedImageInfo {
  public imageUri: string = '';
  public imageByteLength: number = 0;
}

async function compressedImage(sourcePixelMap: image.PixelMap,
  maxCompressedImageSize: number): Promise<CompressedImageInfo> {
  const imagePackerApi = image.createImagePacker();
  const IMAGE_QUALITY = 0;
  const packOpts: image.PackingOption = { format: 'image/jpeg', quality: IMAGE_QUALITY };
  let compressedImageData: ArrayBuffer = await imagePackerApi.packing(sourcePixelMap, packOpts);
  const maxCompressedImageByte = maxCompressedImageSize * 8;
  if (maxCompressedImageByte > compressedImageData.byteLength) {
    compressedImageData =
      await packingImage(compressedImageData, sourcePixelMap, IMAGE_QUALITY, maxCompressedImageByte);
  } else {
    let imageScale = 1;
    const REDUCE_SCALE = 8;
    while (compressedImageData.byteLength > maxCompressedImageByte) {
      if (imageScale > 0) {
        imageScale = imageScale - REDUCE_SCALE;
        await sourcePixelMap.scale(imageScale, imageScale);
        compressedImageData = await packing(sourcePixelMap, IMAGE_QUALITY);
      } else {
        break;
      }
    }
  }
  const compressedImageInfo: CompressedImageInfo = await saveImage(compressedImageData);
  return compressedImageInfo;
}

async function packing(sourcePixelMap: image.PixelMap, imageQuality: number): Promise<ArrayBuffer> {
  const imagePackerApi = image.createImagePacker();
  const packOpts: image.PackingOption = { format: 'image/jpeg', quality: imageQuality };
  const data: ArrayBuffer = await imagePackerApi.packing(sourcePixelMap, packOpts);
  return data;
}

async function packingImage(compressedImageData: ArrayBuffer, sourcePixelMap: image.PixelMap,
  imageQuality: number, maxCompressedImageByte: number): Promise<ArrayBuffer> {
  const packingArray: number[] = [];
  for (let i = 0; i <= 1024; i += 8) {
    packingArray.push(i);
  }
  let left = 0;
  let right = packingArray.length - 1;
  while (left <= right) {
    const mid = Math.floor((left + right) / 2);
    imageQuality = packingArray[mid];
    compressedImageData = await packing(sourcePixelMap, imageQuality);
    if (compressedImageData.byteLength <= maxCompressedImageByte) {
      left = mid + 1;
      if (mid === packingArray.length - 1) {
        break;
      }
      compressedImageData = await packing(sourcePixelMap, packingArray[mid + 1]);
      if (compressedImageData.byteLength > maxCompressedImageByte) {
        compressedImageData = await packing(sourcePixelMap, packingArray[mid]);
        break;
      }
    } else {
      right = mid - 1;
    }
  }
  return compressedImageData;
}

async function saveImage(compressedImageData: ArrayBuffer): Promise<CompressedImageInfo> {
  const context: Context = getContext();
  const compressedImageUri: string = context.filesDir + '/' + 'afterCompression.jpeg';
  try {
    const res = fileIo.accessSync(compressedImageUri);
    if (res) {
      fileIo.unlinkSync(compressedImageUri);
    }
  } catch (err) {
    hilog.error(0x0000, TAG, JSON.stringify(err));
  }
  const file: fileIo.File = fileIo.openSync(compressedImageUri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
  fileIo.writeSync(file.fd, compressedImageData);
  fileIo.closeSync(file);
  let compressedImageInfo: CompressedImageInfo = new CompressedImageInfo();
  compressedImageInfo.imageUri = compressedImageUri;
  compressedImageInfo.imageByteLength = compressedImageData.byteLength;
  return compressedImageInfo;
}

@Entry
@Component
struct Index {
  @State compressedImageSrc: string | Resource = '';
  @State beforeCompressionSize: string = '';
  @State afterCompressionSize: string = '';
  private sourceImageByteLength: number = 0;
  private compressedByteLength: number = 0;
  private maxCompressedImageSize: number = 0;
  private context: Context = getContext(this);

  base64DecodeSync(array: Uint8Array | string, options?: util.Type): Uint8Array {
    let base64 = new util.Base64Helper();
    let result = base64.decodeSync(array, options);
    return result;
  }

  imgBase64ToArryBuffer(base64: string): ArrayBuffer {
    // 将base64字符串转变为通用base64字符串（过滤base64前缀问题）
    const reg = new RegExp('data:image/\\w+;base64,');
    const base64Str: string = base64.replace(reg, '');

    // 将通用base64转换为arrayBuffer
    let arrayBuffer = this.base64DecodeSync(base64Str)
    return arrayBuffer.buffer;
  }

  aboutToAppear(): void {
    const context: Context = getContext(this);
    const resourceMgr: resourceManager.ResourceManager = context.resourceManager;
    resourceMgr.getRawFileContent('beforeCompression.jpeg').then((fileData: Uint8Array) => {
      const buffer = fileData.buffer.slice(0);
      this.sourceImageByteLength = buffer.byteLength;
      this.beforeCompressionSize = (this.sourceImageByteLength / 8).toFixed(1);
    }).catch((err: BusinessError) => {
      hilog.error(0x0000, TAG, JSON.stringify(err));
    });
  }

  imageCompression(): void {
    const resourceMgr: resourceManager.ResourceManager = this.context.resourceManager;
    resourceMgr.getRawFileContent('beforeCompression.jpeg').then((fileData: Uint8Array) => {
      const buffer = fileData.buffer.slice(0);
      const imageSource: image.ImageSource = image.createImageSource(buffer);
      const decodingOptions: image.DecodingOptions = {
        editable: true,
        desiredPixelFormat: 3,
      }
      imageSource.createPixelMap(decodingOptions).then((originalPixelMap: image.PixelMap) => {
        compressedImage(originalPixelMap, this.maxCompressedImageSize).then((showImage: CompressedImageInfo) => {
          this.compressedImageSrc = fileUri.getUriFromPath(showImage.imageUri);
          this.compressedByteLength = showImage.imageByteLength;
          this.afterCompressionSize = (this.compressedByteLength / 8).toFixed(1);
        }
        ).catch((err: BusinessError) => {
          hilog.error(0x0000, TAG, JSON.stringify(err));
        });
      }).catch((err: BusinessError) => {
        hilog.error(0x0000, TAG, JSON.stringify(err));
      });
    })
  }

  build() {
    Column() {
      Row() {
        TextInput()
          .type(InputType.Number)
          .onChange((value: string) => {
            this.maxCompressedImageSize = Number(value);
          })
      }

      Button('image_compression').onClick(() => {
        if (this.maxCompressedImageSize === 0) {
          AlertDialog.show({
            message: 'prompt enter value greater than 0',
            alignment: DialogAlignment.Center,
          });
          return;
        }
        if (this.maxCompressedImageSize * 8 > this.sourceImageByteLength) {
          if (this.sourceImageByteLength === 0) {
            AlertDialog.show({
              message: 'image get failed',
              alignment: DialogAlignment.Center,
            });
          } else {
            AlertDialog.show({
              message: 'aprompt_not_require_compression',
              alignment: DialogAlignment.Center,
            });
          }
          return;
        }
        this.compressedImageSrc = '';
        this.imageCompression();
      })

      Row() {
        Text('image siz before compression')
        Text(this.beforeCompressionSize)
      }

      Row() {
        Text('image size after compression')
        Text(this.afterCompressionSize)
      }

      Image(this.compressedImageSrc)

      Button('saveBase64ToPhoto').onClick(async () => {
        const uicontext: Context = getContext()
        let base64Str: string =
          'iVBORw0KGgoAAAANSUhEUgAAADwAAAA8CAYAAAA6/NlyAAAABGdBTUEAALGPC/xhBQAABEBJREFUaAXtmluITVEYx+e4jHEft1wicsukjHIrHggpvGiYF09TSPKIJ5qSS/JClHggl5IX4kUooVxCjAeaJAzGMBmKXEaY4/ef9jptp3O2fdacvc8c1le/WWvtvdf6Lmvtb6+z95SUOHERcBFwEXARcBFwEXARiCkCiZj0pNQkk8mBNEbAIGiBF4lE4jPlvyU42g2q4DK8gm/wEi7CXOjyz3iMM31gB7RAJmnm4EYoLXqncWIYHIdWkPyAm3AC7kAbSD7CbuhTtE5jfAVcAiOfqOyFvnKKshwOgwmGyiMwpOicxuiFUAdGmqhsgD+WLe3eoJlVMCS/4CyMLgqnMVTJaTU0gJF6Kssh41OB46WwCXQvG7lGZXKndhoDlZy2w3swcoPKjL8ZzjVdoAb8gdIKmfu3vgU5j2FKTsfA3I9KTqchp6XJ9YvhIRh5QqUaMq6OQjmr5KTnqcm4uh/3wQAbg+g3DW6BkddU1kM3m/Hy2gcjFkCm5NSjI4oYczxcACMfqGyFXh0Z17ovipWcVsFzMBKYnHJVxqDD4STo9pB8hQNgtXJy1Z+6HoVKTtsg5+SUGiRkBR16Vu+HLyCR86dA+/HoBUVKTkfBn5zO0B4TlXbGLoNa8AdYG5qJUelsHxcFk0CK/MlJ0Y98iaGjK6yDRjBym8qsSJxm4Plw32ii1M5JG/4OJadcjUVfFTwGI6ovzXWcwOsZcAS8NRoolZxWQEGejeidA/fAiJzO3/JmsNnwzhtdO6eZgRGK4SQ26Nl/BSRa5ovCqA01QwymH+droT+c4g1FA2XBBbtGYkQ1PIHz2NWWV6NQkAoQ9SlwEKJJGhksR5f228vgEAzOcEk0h1Cmn3Ta40ruQiw/2tEzD7TNlOy08c72PVI/lH31FJZSqh2HdEWJ2XCMtVFo67CNrk7R579zOJafW9xv45jeChiaZZqbOV5Pln2a5XzeDkfuMM5Ox9qDUAnZ9P3k3AuuXYnTd6hHJpEuaRxQMjsB0yCbs3JO57QKdnl9dCwSCTIiHwpHMUhvb6CPlNdBn1f80p3GEiiHCaA+jyASidphvX/WtyTJd9jCkn3Q3vL+MKNa6gu9pq7Vbi4yiXRJW1qdtOwXqltndDiU4bYXOYdtI1cs/dwMh5wpbeKNlFHxt83xKEqT8TX2NxsFtjPchLJGT6E+pQR9Ckn9hrYx0PTh8SVna0ybss5XD121eg7rzQIGXETLPNCXgM2gLxBvKP1B7Ek7l9nXtfqksobSLwraHBjjHWygvOrV4ykwqhf4vwrQDJRmzk5Nt45jlaBzYUX/NlGbPk7YttUMa3BmWZ89VlHVLx190tT7paAv90Gvc4POMWyJNiOv4RnsgXNgJfm6v3Qf69+Q2v+VIc0SGSs9rQTpdtq59iaB03sxJb9sooAob7xhjPfZLnLHXQRcBFwEXARcBFwEXARcBFwEYozAb+B+OVoLuFimAAAAAElFTkSuQmCC';
        const imgArrBuff: ArrayBuffer = this.imgBase64ToArryBuffer(base64Str);
        const tmpUri: string = uicontext.filesDir + '/afterCompression.png';
        try {
          const file: fileIo.File = fileIo.openSync(tmpUri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
          let writeResult: number = fileIo.writeSync(file.fd, imgArrBuff);
          hilog.error(0x0000, TAG2, '保存到沙数据长度' + writeResult);
          fileIo.closeSync(file);
        } catch (e) {
          hilog.error(0x0000, TAG2, '保存到沙盒失败' + JSON.stringify(e));
        }
        try {
          let srcFileUri: string = fileUri.getUriFromPath(tmpUri);
          let srcFileUris: string[] = [srcFileUri];
          let photoCreationConfigs: photoAccessHelper.PhotoCreationConfig[] = [
            {
              title: '保存图片',
              fileNameExtension: 'png',
              photoType: photoAccessHelper.PhotoType.IMAGE,
              subtype: photoAccessHelper.PhotoSubtype.DEFAULT,
            }
          ];
          let phAccHelper = photoAccessHelper.getPhotoAccessHelper(uicontext)
          // 将来源于应用沙箱的照片内容写入媒体库的目标uri
          let desFileUris: string[] = await phAccHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs)
          let desFile: fileIo.File = fileIo.openSync(desFileUris[0], fileIo.OpenMode.WRITE_ONLY);
          let srcFile: fileIo.File = fileIo.openSync(srcFileUri, fileIo.OpenMode.READ_ONLY);
          fileIo.copyFileSync(srcFile.fd, desFile.fd);
          fileIo.closeSync(srcFile);
          fileIo.closeSync(desFile);
          hilog.error(0x0000, TAG2, '成功');
        } catch (err) {
          hilog.error(0x0000, TAG2, '保存到相册失败' + JSON.stringify(err));
        }
      })
    }.alignItems(HorizontalAlign.Start)
  }
}