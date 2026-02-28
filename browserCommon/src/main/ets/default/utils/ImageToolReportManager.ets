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

import lazy { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import lazy { ImageToolReportParams } from '@ohos/common/src/main/ets/default/model/common/ImageToolConstants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';

const TAG: string = 'ImageToolBigDataReport';

export class ImageToolBigDataReport {
  public static reportEnterInnerPhoto(params: ImageToolReportParams): void {
    Log.info(TAG,
      `enterInnerPhoto uri:${params.uri} width:${params.imageWidth} height:${params.imageHeight}
        enterInnerPicWay:${params.enterInnerPicWay} scale:${params.curScale} `);
    const msg: Record<string, number | string | boolean> = {
      'uri': ReportToBigDataUtil.urlAnonymize(params.uri),
      'imageWidth': params.imageWidth,
      'imageHeight': params.imageHeight,
      'enterInnerPicWay': params.enterInnerPicWay,
      'imageScale': params.curScale,
    };
    ReportToBigDataUtil.report(BigDataConstants.ENTER_IMAGE_INNER_PHOTO, msg);
  }
}