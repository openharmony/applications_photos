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
import lazy CommonAbility from '@ohos/extensions/src/main/ets/default/CommonAbility';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { TimelineDataSourceManager } from '@ohos/timeline/src/main/ets/model/TimelineDataSourceManager';
import lazy Want from '@ohos.app.ability.Want';
import lazy AbilityConstant from '@ohos.app.ability.AbilityConstant';
import lazy { AlbumSetCacheManager } from '@ohos/common/src/main/ets/default/model/AlbumSetCacheManager';
import lazy data_preferences from '@ohos.data.preferences';
import lazy { Constants, CoursesParams } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { TraceControllerUtils } from '@ohos/common/src/main/ets/default/utils/TraceControllerUtils';
import lazy { taskpool } from '@kit.ArkTS';
import lazy { ReportStorageDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportStorageDataUtil';
import lazy { tryGetRouterParam } from '@ohos/common/src/main/ets/default/utils/RouterUtil';
import lazy backgroundTaskManager from '@ohos.resourceschedule.backgroundTaskManager';
import { DataStoreUtil } from '@ohos/common/src/main/ets/default/utils/DataStoreUtil';
import systemparameter from '@ohos.systemParameterEnhance';

@Concurrent
async function preloadAiVisionImageAnalyzer(): Promise<void> {
  TraceControllerUtils.startTrace('preloadAiVisionImageAnalyzer');
  Log.info('MainAbility', 'preloadAiVisionImageAnalyzer start');
    Log.info('MainAbility', 'preloadAiVisionImageAnalyzer end');
  TraceControllerUtils.finishTrace('preloadAiVisionImageAnalyzer');
}

@Concurrent
async function preloadLibs(): Promise<void> {
  TraceControllerUtils.startTrace('preloadLibs');
  Log.info('MainAbility', 'preloadLibs start');
  Log.info('MainAbility', 'preloadLibs end');
  TraceControllerUtils.finishTrace('preloadLibs');
}

@Concurrent
async function preloadUnusedLibs(): Promise<void> {
  TraceControllerUtils.startTrace('preloadUnusedLibs');
  Log.info('MainAbility', 'preloadUnusedLibs start');

  // unused lib
  await import('@ohos.geoLocationManager');
  await import('@ohos.multimedia.videoProcessingEngine');
  await import('@ohos.file.cloudSync');
  await import('@ohos.wifiManager');
  await import('@ohos.graphics.displaySync');
  await import('@arkts.math.Decimal');
  await import('@ohos.promptAction');
  Log.info('MainAbility', 'preloadUnusedLibs end');
  TraceControllerUtils.finishTrace('preloadUnusedLibs');
}

/**
 *  MainAbility, 配置于 src/main/module.json5
 */
/* instrument ignore file */
const TAG: string = 'MainAbility';

export default class MainAbility extends CommonAbility {

  protected async preload(): Promise<void> {
    super.preload();
    let cacheMgr: AlbumSetCacheManager = new AlbumSetCacheManager(this.context);
    this.storage?.setOrCreate(AlbumSetCacheManager.STORAGE_KEY, cacheMgr);
    cacheMgr.load();
    let preferences: data_preferences.Preferences | undefined =
      this.storage?.get<data_preferences.Preferences>(Constants.LOCAL_KEY_PREFERENCES);
    if (!preferences) {
      Log.warn(TAG, 'invalid preferences');
      return;
    }
    const TASK_ID: number = Date.now();
    TraceControllerUtils.startTraceWithTaskId('getLastPage', TASK_ID);
    preferences.get(Constants.PREFERENCES_KEY_LAST_PAGE, 0).then((value: data_preferences.ValueType) => {
      let pageIndex: number = value as number;
      let param: CoursesParams = tryGetRouterParam() as CoursesParams;
      if (pageIndex !== Constants.TIMELINE_PAGE_INDEX && param.pageFrom !== Constants.ENTRY_FROM.PHOTO_VIEW) {
        TimelineDataSourceManager.getInstance().getDataSource().pause();
      }
      TraceControllerUtils.finishTraceWithTaskId('getLastPage', TASK_ID);
    });
  }

  protected async preloadFaCardLibs() {
    const taskGroup = new taskpool.TaskGroup();
    taskGroup.addTask(preloadAiVisionImageAnalyzer);
    taskGroup.addTask(preloadLibs);
    taskGroup.addTask(preloadUnusedLibs);
    taskpool.execute(taskGroup).then((res): void => {
      Log.info(TAG, `preloadPhotoBrowserLibs res：${res}`);
    }).catch((error: string): void => {
      Log.error(TAG, `preloadPhotoBrowserLibs error：${error}`);
    })
  }

  getTimelineDataSourceManagerInstance(): void {
    TimelineDataSourceManager.getInstance();
    Log.debug(TAG, 'gotTimelineDataSourceManagerInstance');
  }

  onBackground(): void {
    super.onBackground();
    AppStorage.setOrCreate('change_background', true);
    Log.info(TAG, 'onBackground');
    this.releaseEfficiencyResource();
  }

  onForeground(): void {
    super.onForeground();
    AppStorage.setOrCreate('change_background', false);
    ReportStorageDataUtil.reportDataSize();
    Log.info(TAG, 'onForeground');
    this.applyEfficiencyResource();
  }

  onCreate(want: Want, param: AbilityConstant.LaunchParam) {
    Log.info(TAG, 'onCreate in');
    super.onCreate(want, param);
  }

  onDestroy() {
    // super.onDestroy();
  }

  /**
   * 获取媒体库恢复状态(xxx、克隆系统参数)
   * @returns
   */
  getMediaLibraryCloneStatus(): string {
    let cloneFlag: string = '0';
    try {
      // 0 表示媒体库处于 非恢复状态，其他值表示媒体库处于 恢复状态（xxx/克隆）
      cloneFlag = systemparameter.getSync('multimedia.medialibrary.cloneFlag', '0');
    } catch (e) {
      Log.error(TAG, `getMediaLibraryCloneStatus getSync unexpected error message: ${e?.message}, code: ${e?.code}`);
    }
    return cloneFlag;
  }

  /**
   * 图库申请能效资源（豁免冻结）
   */
  async applyEfficiencyResource(): Promise<void> {
    // 1. 获取媒体库恢复状态
    let cloneFlag: string = this.getMediaLibraryCloneStatus();

    // 2. 获取图库申请能效资源记录
    let isApplyEfficiencyResource: boolean =
      await DataStoreUtil.getInstance().getData<boolean>('isApplyEfficiencyResource', false);

    // 如果媒体库处于恢复状态，并且图库没有申请过能效资源，可以进行申请
    if (cloneFlag !== '0' && !isApplyEfficiencyResource) {
      // 处于恢复状态，申请豁免冻结
      let request: backgroundTaskManager.EfficiencyResourcesRequest = {
        resourceTypes: backgroundTaskManager.ResourceType.CPU, // 资源类型是CPU资源，保证应用进程不被挂起
        isApply: true, // 申请资源
        timeOut: 0, // 超时时间，超过超时时间后资源自动释放
        reason: 'apply', // 申请原因
        isPersist: true, // 永久持有资源
        isProcess: false, // 在应用级别申请
      };
      try {
        backgroundTaskManager.applyEfficiencyResources(request);
        // 已申请过能效资源，持久化该操作，避免下次重复申请
        DataStoreUtil.getInstance().putData<boolean>('isApplyEfficiencyResource', true);
        Log.info(TAG, 'applyEfficiencyResource success.');
      } catch (e) {
        Log.error(TAG, `applyEfficiencyResources failed. error message: ${e?.message}, code: ${e?.code}`);
      }
    }
  }

  /**
   * 图库释放/取消申请能效资源（豁免冻结）
   */
  async releaseEfficiencyResource(): Promise<void> {
    // 1. 获取媒体库恢复状态
    let cloneFlag: string = this.getMediaLibraryCloneStatus();

    // 2. 获取图库申请能效资源记录
    let isApplyEfficiencyResource: boolean =
      await DataStoreUtil.getInstance().getData<boolean>('isApplyEfficiencyResource', false);

    try {
      // 如果已经申请过能效资源，且媒体库处于 非恢复状态，将能效资源释放
      if (isApplyEfficiencyResource && cloneFlag === '0') {
        backgroundTaskManager.resetAllEfficiencyResources();
        // 已释放能效资源，持久化该操作，避免下次无法申请
        DataStoreUtil.getInstance().putData<boolean>('isApplyEfficiencyResource', false);
        Log.info(TAG, 'releaseEfficiencyResource success.');
      }
    } catch (e) {
      Log.error(TAG, `releaseEfficiencyResource failed. error message: ${e?.message}, code: ${e?.code}`);
    }
  }
}