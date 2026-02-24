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
import lazy { image } from '@kit.ImageKit';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { util } from '@kit.ArkTS';
import lazy { FormConstants } from '@ohos/common/src/main/ets/default/model/common/FormConstants';
import lazy { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import { photoAlbumFileCountReport } from '@ohos/common/src/main/ets/default/utils/StatisticReportUtil';
import { Region } from '@ohos/common/src/main/ets/default/model/common/DataTypes';

/* instrument ignore file */
const TAG: string = 'PhotoProcessHandler';

export interface SaliencyKeypoint {
  saliency_x: string,
  saliency_y: string,
}

const IMAGE_FACE_THRESHOLD: number = 0.7;

export interface ImageFace {
  scale_x: string,
  scale_y: string,
  scale_width: string,
  scale_height: string,
  prob: string,
}

export interface FaceCoordinate {
  left: number,
  top: number,
  right: number,
  bottom: number,
}

export interface PhotoBound {
  x: string,
  y: string,
  width: string,
  height: string,
}

export class PhotoProcessHandler {
  static getStartCoordinate(keypointCoordinate: number, rectLength: number, imageLength: number): number {
    let coordinate: number = Math.round(keypointCoordinate - rectLength / 2);
    coordinate = Math.max(coordinate, 0);
    coordinate = Math.min(coordinate, imageLength - rectLength);
    return coordinate;
  }

  static getDefaultBound(): PhotoBound {
    return {
      x: FormConstants.DEFAULT_SALIENCY,
      y: FormConstants.DEFAULT_SALIENCY,
      width: FormConstants.DEFAULT_RATIO,
      height: FormConstants.DEFAULT_RATIO
    }
  }

  static getPhotoBoundByKeypoint(keypoint: SaliencyKeypoint, imageSize: image.Size, aspectRatio: number): PhotoBound {
    const keypointX: number = Number(keypoint.saliency_x) * imageSize.width;
    const keypointY: number = Number(keypoint.saliency_y) * imageSize.height;
    if (!keypointX && !keypointY) {
      return PhotoProcessHandler.getDefaultBound();
    }
    const rectWidth: number = Math.min(imageSize.height, imageSize.width);
    const rectHeight: number = Math.round(rectWidth / aspectRatio);

    const photoBound: PhotoBound = {
      x: (PhotoProcessHandler.getStartCoordinate(keypointX, rectWidth, imageSize.width) / imageSize.width).toFixed(6),
      y: (PhotoProcessHandler.getStartCoordinate(keypointY, rectHeight, imageSize.height) /
      imageSize.height).toFixed(6),
      width: (rectWidth / imageSize.width).toFixed(6),
      height: (rectHeight / imageSize.height).toFixed(6),
    }
    return photoBound;
  }

  static getSizeByPhotoAsset(photoAsset: photoAccessHelper.PhotoAsset): image.Size {
    const imageSize: image.Size = {
      width: photoAsset.get(photoAccessHelper.PhotoKeys.WIDTH.toString()) as number,
      height: photoAsset.get(photoAccessHelper.PhotoKeys.HEIGHT.toString()) as number,
    };
    const lcdSize = PhotoAccessHelperAccess.getLcdSize(photoAsset, photoAsset.uri);
    const thmSize = PhotoAccessHelperAccess.getThmSize(photoAsset, photoAsset.uri);
    imageSize.width = lcdSize ? lcdSize.width : (thmSize ? thmSize.width : imageSize.width);
    imageSize.height = lcdSize ? lcdSize.height : (thmSize ? thmSize.height : imageSize.height);
    Log.info(TAG, `getSizeByPhotoAsset imageSize: ${JSON.stringify(imageSize)}`);
    return imageSize;
  }

  static getFaceCoordinate(face: ImageFace): FaceCoordinate {
    const x = Number(face.scale_x);
    const y = Number(face.scale_y);
    const width = Number(face.scale_width);
    const height = Number(face.scale_height);
    return {
      left: x,
      top: y,
      right: x + width,
      bottom: y + height
    };
  };

  static coordinateToBound(coordinate: FaceCoordinate): PhotoBound {
    return {
      x: String(coordinate.left),
      y: String(coordinate.top),
      width: String(coordinate.right - coordinate.left),
      height: String(coordinate.bottom - coordinate.top),
    };
  };

  static boundToCoordinate(bound: PhotoBound): FaceCoordinate {
    return {
      left: Number(bound.x),
      top: Number(bound.y),
      right: Number(bound.x) + Number(bound.width),
      bottom: Number(bound.y) + Number(bound.height),
    };
  };

  static boundToSaliencyKeypoint(bound: PhotoBound): SaliencyKeypoint {
    return {
      saliency_x: String(Number(bound.x) + Number(bound.width) / 2),
      saliency_y: String(Number(bound.y) + Number(bound.height) / 2),
    }
  }

  static getFaceBound(faces: ImageFace[]): PhotoBound | undefined {
    faces = faces.filter((f) => {
      return Number(f.prob) > IMAGE_FACE_THRESHOLD
    });

    if (!faces.length) {
      return undefined;
    }

    let faceCoordinate = PhotoProcessHandler.getFaceCoordinate(faces[0]);
    Log.info(TAG, `getFaceBound before combine, faceCoordinate = ${JSON.stringify(faceCoordinate)}`);

    for (let i = 1; i < faces.length; i++) {
      let otherFaceCoordinate = PhotoProcessHandler.getFaceCoordinate(faces[i]);
      Log.info(TAG, `getFaceBound otherFaceCoordinate = ${JSON.stringify(otherFaceCoordinate)}`);
      faceCoordinate.left = Math.min(faceCoordinate.left, otherFaceCoordinate.left);
      faceCoordinate.right = Math.max(faceCoordinate.right, otherFaceCoordinate.right);
      faceCoordinate.top = Math.min(faceCoordinate.top, otherFaceCoordinate.top);
      faceCoordinate.bottom = Math.max(faceCoordinate.bottom, otherFaceCoordinate.bottom);
    }
    Log.info(TAG, `getFaceBound after combine, faceCoordinate = ${JSON.stringify(faceCoordinate)}`);
    return PhotoProcessHandler.coordinateToBound(faceCoordinate);
  }

  static contains(photo: PhotoBound, face: PhotoBound): boolean {
    const photoCoordinate = PhotoProcessHandler.boundToCoordinate(photo);
    const faceCoordinate = PhotoProcessHandler.boundToCoordinate(face);

    Log.info(TAG,
      `contains photoCoordinate = ${JSON.stringify(photoCoordinate)} faceCoordinate = ${JSON.stringify(faceCoordinate)}`);
    return (
      faceCoordinate.left >= photoCoordinate.left &&
        faceCoordinate.top >= photoCoordinate.top &&
        faceCoordinate.right <= photoCoordinate.right &&
        faceCoordinate.bottom <= photoCoordinate.bottom
    );
  }

  static async correctByFace(photoAsset: photoAccessHelper.PhotoAsset, photoBounds: PhotoBound[],
    aspectRatioList: number[],
    imageSize: image.Size): Promise<PhotoBound[]> {
    try {
      const faceStr: string = await photoAsset.getAnalysisData(photoAccessHelper.AnalysisType.ANALYSIS_FACE);
      const faces: ImageFace[] | undefined = JSON.parse(faceStr);
      if (!faces) {
        Log.info(TAG, `correctByFace faces is undefined`);
        return photoBounds;
      }

      const faceBound: PhotoBound | undefined = PhotoProcessHandler.getFaceBound(faces);
      if (!faceBound) {
        Log.info(TAG, `correctByFace faceBound is undefined`);
        return photoBounds;
      }

      for (let i = 0; i < photoBounds.length; i++) {
        if (!PhotoProcessHandler.contains(photoBounds[i], faceBound)) {
          Log.info(TAG, `correctByFace photoBounds[${i}] not contains faceBound`);
          photoBounds[i] = PhotoProcessHandler.getPhotoBoundByKeypoint(PhotoProcessHandler.boundToSaliencyKeypoint(faceBound), imageSize,
            aspectRatioList[i])
          Log.info(TAG, `correctByFace getPhotoBoundByKeypoint after photoBounds[${i}] ${JSON.stringify(photoBounds[i])}`);
        }
      }
    } catch (err) {
      Log.error(TAG, `correctByFace error ${err?.message}}`);
    }
    return photoBounds;
  }

  static async getPhotoBound(
    photoAsset: photoAccessHelper.PhotoAsset,
    aspectRatioList: number[],
    imageSize?: image.Size,
    correct: boolean = true,
  ): Promise<PhotoBound[]> {
    try {
      const keypointStr = await photoAsset.getAnalysisData(photoAccessHelper.AnalysisType.ANALYSIS_SALIENCY);
      const keypoint: SaliencyKeypoint | undefined = JSON.parse(keypointStr)[0];
      Log.info(TAG, `getPhotoBound keypoint is ${keypointStr}`);
      if (!imageSize) {
        imageSize = PhotoProcessHandler.getSizeByPhotoAsset(photoAsset);
      }
      let photoBound: PhotoBound[] = [];
      if (keypoint) {
        photoBound =
          aspectRatioList.map(ratio => PhotoProcessHandler.getPhotoBoundByKeypoint(keypoint, imageSize as image.Size, ratio));
      } else {
        const bound: PhotoBound = PhotoProcessHandler.getDefaultBound();
        photoBound = aspectRatioList.map(() => (bound));
      }

      if (correct) {
        photoBound = await PhotoProcessHandler.correctByFace(photoAsset, photoBound, aspectRatioList, imageSize);
      }
      Log.info(TAG, `getPhotoBound photoBound: ${JSON.stringify(photoBound)}`);
      return photoBound;
    } catch (err) {
      Log.e(TAG, ` getPhotoBound err code:${err?.code},msg:${err?.message} `);
    }
    return [];
  }

  static async getAllPhotoBound(photoAsset: photoAccessHelper.PhotoAsset, correct: boolean = true,
    imageSize?: image.Size): Promise<PhotoBound[]> {
    // 卡片的宽高比有1:1和2:1两种规格
    return await PhotoProcessHandler.getPhotoBound(photoAsset, [1, 2], imageSize, correct);
  }

  static getPixelFromPayload(payloadData: PayloadData, is2x4: boolean = false): PixelMap | ResourceStr {
    let pixel: PixelMap | ResourceStr = FormConstants.DEFAULT_IMAGE;
    const bound: FAPhotoBound[] = PhotoProcessHandler.parseJson(payloadData?.photo_bound);
    Log.info(TAG, `getPixelFromPayload bound:${JSON.stringify(bound)}`)
    if (bound && bound.length > 0) {
      const index: number = is2x4 ? bound.length - 1 : 0;
      pixel = PhotoProcessHandler.getSaliencyPixelMapByString(payloadData.image_data, bound[index]);
    } else {
      pixel = PhotoProcessHandler.base64ToPixelMap(payloadData.image_data);
    }
    return pixel;
  }

  static base64ToPixelMap(base64: string): image.PixelMap {
    try {
      // 使用decodeSync对base64字符串解码时，传入的base64字符串不能有'data:image/jpeg;base64,'这样的前缀
      const tempBase64 = base64.split('base64,').pop();
      const helper: util.Base64Helper = new util.Base64Helper();
      const buffer: ArrayBuffer = helper.decodeSync(tempBase64, util.Type.MIME).buffer as ArrayBuffer;
      const imageSource: image.ImageSource = image.createImageSource(buffer);
      const opts: image.DecodingOptions = { editable: true };
      const pixelMap: image.PixelMap = imageSource.createPixelMapSync(opts);
      return pixelMap;
    } catch (err) {
      Log.e(TAG, ` base64ToPixelMap err code:${err?.code},msg:${err?.message} `);
    }
    return {} as PixelMap;
  }

  static uint8ArrayToPixelMap(array: Uint8Array): image.PixelMap {
    try {
      Log.info(TAG, `uint8ArrayToPixelMap Uint8Array ${array}`);
      const source: image.ImageSource = image.createImageSource(array.buffer.slice(0));
      const opts: image.DecodingOptions = { editable: true };
      const pixelMap: image.PixelMap = source.createPixelMapSync(opts);
      Log.info(TAG, `uint8ArrayToPixelMap pixelMap ${JSON.stringify(pixelMap.getImageInfoSync().size)}`);

      source.release();
      return pixelMap;
    } catch (err) {
      Log.e(TAG, ` uint8ArrayToPixelMap err code:${err?.code},msg:${err?.message} `);
    }
    return {} as PixelMap;
  }

  static getSaliencyPixelMapByString(str: string, photoBound: FAPhotoBound): image.PixelMap {
    try {
      const pixelMap: image.PixelMap = PhotoProcessHandler.base64ToPixelMap(str);
      Log.info(TAG, `getSaliencyPixelMap pixelMap size ${JSON.stringify(pixelMap.getImageInfoSync().size)}`);
      const imageSize: image.Size = pixelMap.getImageInfoSync().size;
      const region: image.Region = {
        x: Math.round(imageSize.width * Number(photoBound.x)),
        y: Math.round(imageSize.height * Number(photoBound.y)),
        size: {
          width: Math.round(imageSize.width * Number(photoBound.width)),
          height: Math.round(imageSize.height * Number(photoBound.height)),
        },
      }
      pixelMap.cropSync(region);
      Log.info(TAG, `getSaliencyPixelMap region size ${JSON.stringify(region)}`);
      return pixelMap;
    } catch (err) {
      Log.e(TAG, ` getSaliencyPixelMap err code:${err?.code},msg:${err?.message} `);
    }
    return {} as PixelMap;
  }

  static parseJson<T>(bound: string): T[] {
    let parsedBound: T[] = [];
    try {
      parsedBound = JSON.parse(bound) as [];
    } catch (err) {
      Log.e(TAG, `  err code:${err?.code},msg:${err?.message} `);
    }
    return parsedBound;
  }
}

export interface FAPhotoBound {
  x: number,
  y: number,
  width: number,
  height: number,
}

export interface PayloadData {
  _id: number;
  form_id: number;
  image_data: string;
  image_uri: string;
  minutes: number;
  album_uri: string;
  cover_uri: string;
  photo_bound: string;
  is_hidden: number;
  is_open: number;
  open_time: number;
  album_name?: string;
  is_show_album_name?: number;
}