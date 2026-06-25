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

/* instrument ignore file */

import { SwitchType } from '../statemanager/common/SwitchStartInfo';
import { PullDownState, ShowMode } from '../statemanager/constants/GridDefine';
import { IrregularVm } from '../viewmodel/IrregularVm';
import { AbstractVc, BaseAttributeUpdater } from './AbstractVc';
import { ViewId, ViewZIndex } from './constants/ViewDefine';
import { IrregularVc, IrregularViewAttributeUpdater } from './IrregularVc'
import { DataSourceListener, DataSourceManager } from '../model/DataSourceManager';
import { GridStateProxy } from '../statemanager/GridStateProxy';
import { PhotoAlbum } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';

/**
 * 不规则区域视图控制器
 */
@Observed
// export class ClassifyVc extends AbstractVc<IrregularVm, IrregularViewAttributeUpdater> {

 export class ClassifyVc extends IrregularVc{
  /**
   * 是否显示分类二级标签
   */
  @Track public isShowClassify: boolean = false;
  public dataSourceManager: DataSourceManager | undefined;

  public constructor() {
    super(new IrregularViewAttributeUpdater(), 'ClassifyVc', ShowMode.VISIBLE);
  }


  protected override initStates(): void {
    super.initStates();

  }
}