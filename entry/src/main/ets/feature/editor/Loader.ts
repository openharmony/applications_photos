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
import {BrowserDataFactory} from '../../common/interface/BrowserDataFactory'
import {Size} from '../../common/model/common/DataTypes'
import {PixelMapWrapper} from './base/PixelMapWrapper'
import {MathUtils} from './crop/MathUtils'
import {CropAngle} from './crop/CropType'
import {ImageUtil} from '../../common/utils/ImageUtil'
import {ScreenManager} from '../../common/model/common/ScreenManager'

export class Loader {
    private static logger: Logger = new Logger('Loader');
    private static readonly MIN_PIXEL_MAP_SIZE: number = 1024;

    private static getPixelMapPreviewSize(size: Size) {
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
        let dataImpl = BrowserDataFactory.getFeature(BrowserDataFactory.TYPE_PHOTO);

        let result = await dataImpl.getDataById(mediaItem.id);
        if (!result) {
            this.logger.error('get file asset failed.');
            return null;
        }

        let size = {
            width: result.width,
            height: result.height
        };
        isPreview && Loader.getPixelMapPreviewSize(size);

        let thumbnail = await result.getThumbnail(size);
        let wrapper = new PixelMapWrapper(thumbnail, px2vp(size.width), px2vp(size.height));
        this.logger.info(`Photo: loadPixelMap: size[${JSON.stringify(size)}] wrapper[${JSON.stringify(wrapper)}]`);

        let orientation = mediaItem.orientation || 0;
        await Loader.translatePixelMap(wrapper, orientation);
        this.logger.info(`Photo: loadPixelMap: final wrapper[${JSON.stringify(wrapper)}]`);
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
        context.translate(offWidth / 2, offHeight / 2);
        context.rotate(MathUtils.formulaAngle(orientation));
        context.translate(-image.width / 2, -image.height / 2);
        context.drawImage(image.pixelMap, 0, 0, image.width, image.height);
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