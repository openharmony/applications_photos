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

import lazy { ExtendedServicesPage } from '@ohos/privacy/src/main/ets/components/extendedService/ExtendedServicesPage';
import lazy { GallerySettingsBasePage } from '@ohos/privacy/src/main/ets/setting/GallerySettingsBasePage';
import lazy { MediaOperationBasePage } from '@ohos/common/src/main/ets/default/view/browserOperation/MediaOperationBasePage';
import lazy { NavigationConstants } from '@ohos/common/src/main/ets/default/model/common/NavigationConstants';
import lazy { PickerBasePage } from '../../pickerability/view/PickerBasePage';
import lazy { PhotoGridBasePage } from './PhotoGridBasePage';
import lazy { StatementsCards } from '@ohos/privacy/src/main/ets/components/extendedService/StatementsCards';
import lazy { ServiceAgreementsCards } from '@ohos/privacy/src/main/ets/components/extendedService/ServiceAgreementsCards';
import lazy { MoviePage } from './MoviePage';

/* instrument ignore file */
@Builder
export default function MainPageMap(name: string, param: Object) {
  if (name === NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION) {
    MediaOperationBasePage()
  } else if (name === NavigationConstants.NAVIGATION_DESTINATION_GALLERY_SETTINGS) {
    GallerySettingsBasePage()
  } else if (name === NavigationConstants.NAVIGATION_DESTINATION_PICKER_OPERATION) {
    PickerBasePage()
  } else if (name === NavigationConstants.NAVIGATION_DESTINATION_PHOTO_GRID_VIEW) {
    PhotoGridBasePage()
  } else if (name === NavigationConstants.NAVIGATION_MOVIE_PAGE) {
    MoviePage()
  } else if (name === NavigationConstants.NAVIGATION_DESTINATION_EXTENDED_SERVICES) {
    ExtendedServicesPage()
  } else if (name === NavigationConstants.NAVIGATION_DESTINATION_STATEMENTS_CARDS) {
    StatementsCards()
  } else if (name === NavigationConstants.NAVIGATION_DESTINATION_SERVICE_AGREEMENTS_CARDS) {
    ServiceAgreementsCards()
  }
}