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

import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy {
  FavoriteChecker,
  MediaTypeChecker,
  SelectedItemsParser,
  SelectListener,
  SelectManager,
} from '@ohos/common/src/main/ets/default/model/browser/SelectManager';
import lazy { SelectMediaType } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { DataListener, LoadingResult } from '@ohos/common/src/main/ets/default/model/DataSource';
import lazy { IStateChangeObserver } from '@ohos/common/src/main/ets/default/model/StateObserverManager';
import lazy { GridAppBarManager } from '@ohos/common/src/main/ets/default/viewmodel/GridAppBarManager';
import lazy { MenuConstants, ParamsWrapper } from '@ohos/common/src/main/ets/default/view/actionbar/Menu';
import lazy { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';
import lazy { FocusUtil } from '@ohos/common/src/main/ets/default/utils/FocusUtil';
import lazy { GridStateProxy } from '../statemanager/GridStateProxy';
import lazy { FormEventType, FormStateType } from '../statemanager/GridFormFsm';

const TAG: string = 'TimelineAppBarBaseManager';

/**
 * GridAppBarManager 负责接入宫格selectManger相关处理 子类对接具体业务
 */
export class TimelineAppBarBaseManager extends GridAppBarManager {
  protected appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  protected selectManager: SelectManager | undefined;
  protected selectedItemsParser: SelectedItemsParser | undefined;
  protected readonly selectedParseResult: ParamsWrapper = new ParamsWrapper();
  // 已选中的是否有未收藏的
  protected hasUnFavoriteStatus: boolean = false;
  // 已选中的媒体类型
  protected selectMediaType: SelectMediaType = SelectMediaType.INVALID;
  // 已选中的是否有不可打印的
  protected hasNotPrintable: boolean = false;
  protected gridStateProxy: GridStateProxy | undefined;
  /**
   * 宫格形态变化
   */
  private readonly formStateObserver: IStateChangeObserver<FormStateType, FormEventType> = {
    onStateChange: (oldState: FormStateType, newState: FormStateType, event?: FormEventType): void => {
      Log.info(TAG, `formStateObserver. oldState:${oldState} newState:${newState}`);
      this.updateLayout();
    }
  };
  /**
   * 选择态事件
   */
  private readonly selectListener: SelectListener = {
    onModeChanged: (newMode: boolean) => {
      Log.info(TAG, `selectListener onModeChanged. newMode:${newMode}`);
      // 这里需要通知首页index 把搜索下树
      this.appBroadCast.emit(BroadCastConstants.SELECT, [newMode]);
      this.updateLayout();
    },
    onSelectCountChanged: (newCount: number) => {
      Log.info(TAG, `selectListener onSelectCountChanged. newCount:${newCount}`);
      this.selectedItemsParser?.notifyDirty();
    },
  };
  private readonly rightClickMenuStateObserver: IStateChangeObserver<ParamsWrapper, string> = {
    onStateChange: (oldState: ParamsWrapper, newState: ParamsWrapper, event?: string | undefined): void => {
      let action = newState.get<Action>(MenuConstants.KEY_ACTION);
      Log.info(TAG, `rightClickMenuStateObserver action: ${action?.actionID}`);
      if (this.uiContext) {
        FocusUtil.clearFocus(this.uiContext.getFocusController());
      }
      AppStorage.setOrCreate<boolean>('isPhotoGridFocused', true);
      this.menuHelper.onMenuClicked(action, newState);
    }
  }
  private readonly favorCountChecker: FavoriteChecker = new FavoriteChecker();
  private readonly mediaTypeChecker: MediaTypeChecker = new MediaTypeChecker();
  /**
   * 解析事件
   */
  private readonly selectedItemsCheckerListener: DataListener<ParamsWrapper> = {
    onLoadingFinished: (result: LoadingResult<ParamsWrapper>) => {
      Log.info(TAG, 'selectedItemsCheckerListener onLoadingFinished.');
      this.updateCheckerResult(result);
    },
  };

  /**
   * 初始化 init之后 updateLayout之前
   */
  public extraInit(): void {
    super.extraInit();
    this.gridStateProxy = GridStateProxy.getInstance(this.instanceId);
    this.selectManager = this.gridStateProxy.selectManager;
    this.selectedItemsParser = new SelectedItemsParser(this.selectManager);
    this.selectManager.addListener(this.selectListener);
    this.selectedItemsParser.addChecker(this.favorCountChecker);
    this.selectedItemsParser.addChecker(this.mediaTypeChecker);
    this.selectedItemsParser.addListener(this.selectedItemsCheckerListener);
    this.gridStateProxy.formFsm.registerObserver(this.formStateObserver);
    this.gridStateProxy.gridStateManager.rightClickMenuAsm.registerObserver(this.rightClickMenuStateObserver);
  }

  /**
   * 卸载
   */
  public release(): void {
    super.release();
    this.selectManager?.removeListener(this.selectListener);
    this.selectedItemsParser?.removeAllCheckers();
    this.selectedItemsParser?.removeListener(this.selectedItemsCheckerListener);
    this.gridStateProxy?.formFsm.unRegisterObserver(this.formStateObserver);
    this.gridStateProxy?.gridStateManager.rightClickMenuAsm.unRegisterObserver(this.rightClickMenuStateObserver);
  }

  /**
   * 传入selectManager 相关参数
   */
  protected buildCommonParams(): ParamsWrapper {
    return super.buildCommonParams()
      .set(MenuConstants.KEY_SELECTION_MANAGER, this.selectManager)
      .set(MenuConstants.KEY_SELECTION_PARSE_RESULT, this.selectedParseResult);
  }

  /**
   * 根据 ActionBar onAreaChange 设置相册区域避让高度
   */
  public onAppBarAreaChange(oldValue: Area, newValue: Area): void {
    super.onAppBarAreaChange(oldValue, newValue);
    let newHeight: number = newValue.height as number;
    Log.info(TAG, `onAppBarAreaChange. titleBarStateManager.titleBarHeightAsm.updateState. newHeight:${newHeight}`);
    GridStateProxy.getInstance(this.instanceId)
      .titleBarStateManager
      .titleBarHeightAsm
      .updateState(newHeight, 'onActionBarAreaChange');
  };

  /**
   * 更新勾选解析结果
   */
  protected updateCheckerResult(result: LoadingResult<ParamsWrapper>): void {
    let checkResult: ParamsWrapper | undefined = result.newPageData.data[0];
    if (!checkResult) {
      return;
    }
    // 如果没有key，默认存在未选择的元素
    this.hasUnFavoriteStatus = checkResult.get<boolean>(FavoriteChecker.KEY_HAS_UN_FAVORITE);
    this.selectMediaType = checkResult.get<SelectMediaType>(MediaTypeChecker.KEY_SELECT_MEDIA_TYPE);
    Log.info(TAG,
      `updateCheckerResult. hasUnFavoriteStatus:${this.hasUnFavoriteStatus} selectMediaType:${this.selectMediaType} hasNotPrintable:${this.hasNotPrintable}`);
    this.selectedParseResult.params.clear();
    for (let key of checkResult.params.keys()) {
      this.selectedParseResult.set(key, checkResult.params.get(key));
    }
    this.gridStateProxy?.selectStateManager
      .selectedParseResultAsm.updateState(new ParamsWrapper(this.selectedParseResult), 'update checker result')
    this.updateAppBar();
  }
}
