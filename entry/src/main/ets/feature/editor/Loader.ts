/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import MediaLib from '@ohos.multimedia.mediaLibrary';
import { Log } from '@ohos/base/src/main/ets/utils/Log';
import { MediaDataItem } from '@ohos/base/src/main/ets/data/MediaDataItem';
import type { Size } from '../../common/model/common/DataTypes';
import { PixelMapWrapper } from './base/PixelMapWrapper';
import { MathUtils } from './crop/MathUtils';
import { CropAngle } from './crop/CropType';
import { computeSampleSize } from '@ohos/base/src/main/ets/utils/ImageUtil';
import screenManager from '@ohos/base/src/main/ets/manager/ScreenManager';

const TAG = "Loader"

export class Loader {
    private static readonly MIN_PIXEL_MAP_SIZE: number = 1024;

    private static getPixelMapPreviewSize(size: Size) {
        let width = screenManager.getWinWidth();
        let height = screenManager.getWinHeight();
        Log.debug(TAG, `picture real size: ${size.width} ${size.height}`);
        let scale = computeSampleSize(size.width, size.height, Loader.MIN_PIXEL_MAP_SIZE, width * height * 2);
        size.width = Math.ceil(size.width / scale);
        size.height = Math.ceil(size.height / scale);
        Log.debug(TAG, `picture scale: ${scale} size: ${JSON.stringify(size)}`);
    }

    static async loadPixelMapWrapper(mediaItem: MediaDataItem, isPreview: boolean = false): Promise<PixelMapWrapper> {
        Log.debug(TAG, `Photo: loadPixelMap id = ${mediaItem.id}`);
        let fileAsset: MediaLib.FileAsset = await mediaItem.loadFileAsset()
        let size = {
            width: fileAsset.width,
            height: fileAsset.height
        };
        isPreview && Loader.getPixelMapPreviewSize(size);

        let thumbnail = await fileAsset.getThumbnail(size);
        let wrapper = new PixelMapWrapper(thumbnail, px2vp(size.width), px2vp(size.height));
        Log.info(TAG, `Photo: loadPixelMap: size[${JSON.stringify(size)}] wrapper[${JSON.stringify(wrapper)}]`);

        let orientation = mediaItem.orientation || 0;
        await Loader.translatePixelMap(wrapper, orientation);
        Log.info(TAG, `Photo: loadPixelMap: final wrapper[${JSON.stringify(wrapper)}]`);
        return wrapper;
    }

    private static translatePixelMap(image: PixelMapWrapper, orientation: number) {
        if (0 == orientation % CropAngle.CIRCLE_ANGLE) {
            return image;
        }

        let size = Loader.swapSize(image, orientation);
        let offWidth = size.width;
        let offHeight = size.height;
        let setting = new RenderingContextSettings(true)
        let context = new OffscreenCanvasRenderingContext2D(offWidth, offHeight, setting);

        context.save();
        context.drawImage(image.pixelMap, 0, 0, offWidth, offHeight);
        context.restore();

        image.pixelMap && image.pixelMap.release();
        image.pixelMap = context.getPixelMap(0, 0, offWidth, offHeight);
        image.width = size.width;
        image.height = size.height;
    }

    private static swapSize(image: PixelMapWrapper, orientation: number): Size {
        let angle = orientation % CropAngle.HALF_CIRCLE_ANGLE;
        let size = {
            width: image.width,
            height: image.height
        };
        if (0 != angle) {
            size.width = image.height;
            size.height = image.width;
        }
        return size;
    }
}