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

import lazy { Log } from '../../utils/Log';
import type { SelectManager } from '../../model/browser/SelectManager';
import type { MenuContext } from './MenuContext';
import lazy { BrowserOperationFactory } from '../../interface/BrowserOperationFactory';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { ProcessMenuOperation } from './ProcessMenuOperation';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import lazy { Constants } from '../../model/common/Constants';
import type { MediaItem } from '../../model/browser/photo/MediaItem';
import type { PhotoAsset } from '../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import lazy { display } from '@kit.ArkUI';
import lazy { NavigationBroadCastManager } from '../../model/common/NavigationBroadCastManager';

const TAG: string = 'AddPeopleTagMenuOperation';


export class AddPeopleTagMenuOperation extends ProcessMenuOperation {
  private navigationBroadCast = NavigationBroadCastManager.getInstance().getBroadCast();

  constructor(menuContext: MenuContext) {
    super(menuContext);
  }

  public doAction(): void {

  }
}