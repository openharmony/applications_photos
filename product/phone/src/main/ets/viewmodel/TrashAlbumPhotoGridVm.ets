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

import lazy { FormIndex } from '@ohos/timeline/src/main/ets/photogrid/statemanager/constants/GridDefine';
import lazy { OperateStateTypeUtils } from '@ohos/timeline/src/main/ets/photogrid/statemanager/GridOperateFsm';
import lazy { AlbumPhotoGridVm } from '@ohos/timeline/src/main/ets/albumgrid/viewmodel/AlbumPhotoGridVm';

export class TrashAlbumPhotoGridVm extends AlbumPhotoGridVm {
  private callback:(_oldState: boolean)=>void = ()=>{
  };

  public constructor(callback:(_oldState: boolean)=>void) {
    super();
    this.callback = callback;
  }

  protected override doInit(persistentId: number): void {
    super.doInit(persistentId);
    this.observerAndUpdateBottomAvoidHeight();
    this.getOperateState((oldState, newState)=>{
      this.callback(OperateStateTypeUtils.isInNotDataState(newState))
    });
  }

  protected override observerAndUpdateBottomAvoidHeight(): void {
    this.toolbarObserverProxy.getToolbarPosition(() => this.updateBottomAvoidHeight());
    this.getOperateState(() => this.updateBottomAvoidHeight());
  }

  protected override updateBottomAvoidHeight() {
    let avoidHeight: number = this.displayStateManager.config?.bottomAvoidHeight ?? 0;
    if (this.albumObserverProxy.getAlbumInfo()?.isTrashAlbum && !OperateStateTypeUtils.isInSelectState(this.getOperateState())) {
      avoidHeight += this.gridObserverProxy.getGridImageHeight(FormIndex.DAY);
      this.stateProxy.displayStateManager.bottomAvoidHeightAsm.updateState(avoidHeight, this.tag);
      return;
    }
    super.updateBottomAvoidHeight();
  }
}
