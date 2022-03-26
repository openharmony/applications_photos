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

import {Logger} from './utils/Logger'
import {MediaItem} from '../../common/model/browser/photo/MediaItem'
import {MediaLibraryAccess} from '../../common/access/MediaLibraryAccess'
import image from '@ohos.multimedia.image'
import {Size} from '../../common/model/common/DataTypes'
import {PixelMapWrapper} from './base/PixelMapWrapper'
import {MathUtils} from './crop/MathUtils'
import {CropAngle} from './crop/CropType'
import {ImageUtil} from '../../common/utils/ImageUtil'
import {ScreenManager} from '../../common/model/common/ScreenManager'

export class Loader {
    private static logger: Logger = new Logger('Loader');
    private static readonly MIN_PIXEL_MAP_SIZE: number = 1024;

    static getPixelMapPreviewSize(size: Size) {
        let width = ScreenManager.getInstance().getWinWidth();
        let height = ScreenManager.getInstance().getWinHeight();
        this.logger.debug(`picture real size: ${size.width} ${size.height}`);
        let scale = ImageUtil.computeSampleSize(size.width, size.height, Loader.MIN_PIXEL_MAP_SIZE, width * height * 2);
        size.width = Math.ceil(size.width / scale);
        size.height = Math.ceil(size.height / scale);
        this.logger.debug(`picture scale: ${scale} size: ${JSON.stringify(size)}`);
    }

    static async loadPixelMapWrapper(mediaItem: MediaItem, isPreview: boolean = false): Promise<PixelMapWrapper> {
        this.logger.debug(`Photo: loadPixelMap id = ${mediaItem.id}`);
        let fetchOpt = {
            selections: 'file_id =?',
            selectionArgs: [`${mediaItem.id}`]
        };

        let result = await MediaLibraryAccess.getFirstObject(fetchOpt);
        if (!result.obj) {
            this.logger.error('get file asset failed.');
            return null;
        }

        let fileAsset = result.obj;
        let size = {
            width: fileAsset.width,
            height: fileAsset.height
        };
        isPreview && Loader.getPixelMapPreviewSize(size);

        let thumbnail = await fileAsset.getThumbnail(size);
        let wrapper = new PixelMapWrapper(thumbnail, px2vp(size.width), px2vp(size.height));
        this.logger.debug(`Photo: loadPixelMap: size[${JSON.stringify(size)}] wrapper[${JSON.stringify(wrapper)}]`);

        let orientation = mediaItem.orientation || 0;
        wrapper = Loader.translatePixelMap(wrapper, orientation);
        return wrapper;
    }

    private static translatePixelMap(image: PixelMapWrapper, orientation: number): PixelMapWrapper {
        if (0 == orientation % CropAngle.CIRCLE_ANGLE) {
            return image;
        }

        let size = Loader.swapSize(image, orientation);
        let offWidth = vp2px(size.width); // Apply to the case that offscreen canvas is constructed with px
        let offHeight = vp2px(size.height); // Apply to the case that offscreen canvas is constructed with px
        let setting = new RenderingContextSettings(true)
        let context = new OffscreenCanvasRenderingContext2D(offWidth, offHeight, setting);

        context.save();
        context.translate(offWidth / 2, offHeight / 2);
        context.rotate(MathUtils.formulaAngle(orientation));
        context.translate(-image.width / 2, -image.height / 2);
        context.drawImage(image.pixelMap, 0, 0, image.width, image.height);
        context.restore();

        image.pixelMap && image.pixelMap.release();
        image.pixelMap = context.getPixelMap(0, 0, offWidth, offHeight);
        image.width = size.width;
        image.height = size.height;
        return image;
    }

    private static swapSize(image: PixelMapWrapper, orientation: number): Size {
        let angle = orientation % CropAngle.HALF_CIRCLE_ANGLE;
        let size = {
            width: image.width,
            height: image.height
        }
        if (0 != angle) {
            size.width = image.height;
            size.height = image.width;
        }
        return size;
    }
}