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
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import type { MenuOperationCallback } from './MenuOperationCallback';
import type { MenuOperation } from './MenuOperation';
import type { MenuContext } from './MenuContext';
import lazy { JumpSourceToMain } from '../../model/browser/photo/JumpSourceToMain';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import type { PhotoAlbum } from '../../access/UserFileManagerAccess';
import lazy { UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import type common from '@ohos.app.ability.common';
import lazy { AlbumSetDataSourceManager } from '../../model/browser/album/AlbumSetDataSourceManager';
import lazy { DeviceInfo } from '../../utils/DeviceInfo';
import lazy { Rsc } from '@ohos/tools/src/main/global/RscString';
import lazy { global } from '@ohos/tools/src/main/global/Contexts';
import type { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { Action } from './Action';
import lazy { TraceControllerUtils } from '../../utils/TraceControllerUtils';
import lazy { AlbumDefine } from '../../model/browser/AlbumDefine';
import lazy { MediaOperationType } from '../../model/common/MediaOperationType';
import type { AlbumInfo } from '../../../default/model/browser/album/AlbumInfo';
import lazy {
  AlbumCreateListener,
  AlbumSetNewMenuOperation,
} from '../../view/browserOperation/AlbumSetNewMenuOperation';
import lazy { Constants } from '../../model/common/Constants';

/* instrument ignore file */
const TAG: string = 'AlbumSetNewWithoutDialogMenuOperation';

export class AlbumSetNewWithoutDialogMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;
  private defaultAlbumName: string = '';
  private onOperationEnd: Function = (): void => {
  };

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  public async doAction(): Promise<void> {
    if (!this.menuContext) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    let albumInfo: AlbumInfo | undefined = this.menuContext?.albumInfo;
    let msg: Record<string, number | string | boolean | undefined> = {
      'albumType': albumInfo?.subType,
      'type': BigDataConstants.ALBUM_CREATE,
    };
    ReportToBigDataUtil.report(BigDataConstants.ALBUM_OPERATION_ID, msg);

    let isFromPhotoBrowserViewPC: boolean = this.menuContext.fromPage === Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER;
    let logMsg: string[] = ['doAction'];
    logMsg.push(`menuContext.fromPage: ${this.menuContext.fromPage}`);
    logMsg.push(`isFromPhotoBrowserViewPC: ${isFromPhotoBrowserViewPC}`);
    Log.info(TAG, logMsg.join(', '));
    let createAlbumStringResource: Resource = $r('app.string.album_new_album');
    Log.info(TAG, `The display name from resource ${JSON.stringify(createAlbumStringResource)}`);
    this.defaultAlbumName = '';
    try {
      let context: common.UIAbilityContext = global.uiAbilityContext();
      if (!context) {
        Log.info(TAG, 'context is null!');
        return;
      }
      this.defaultAlbumName = isFromPhotoBrowserViewPC && DeviceInfo.isPc() ?
      Rsc.toString(createAlbumStringResource) : await context.resourceManager.getString(createAlbumStringResource.id);
      Log.info(TAG, `The display name is ${AlbumDefine.getAnonymizeAlbumName(this.defaultAlbumName)}`);
      let newAlbumDisplayName: string = await this.getNewAlbumDefaultName(this.defaultAlbumName);
      Log.info(TAG, `The display name of new album is ${AlbumDefine.getAnonymizeAlbumName(newAlbumDisplayName)}`);
      this.confirmCallback(newAlbumDisplayName);
    } catch (error) {
      let msg: Record<string, number | string | boolean> = {
        'type': BigDataConstants.ALBUM_CREATE_ERROR,
        'errMsg': error,
      };
      ReportToBigDataUtil.errEventReport(BigDataConstants.ALBUM_OPERATION_ERROR_ID, msg);
      Log.info(TAG, `The display name error, code: ${error?.code}, message: ${error?.message}`);
    }
  }

  public onCompleted(): void {
    Log.info(TAG, 'onCompleted: Creat album finish. -> Try refreshing ForEach data and opening album.');
    this.menuContext.broadCast?.emit(
      BroadCastConstants.SIDEBAR_VIEW_SWITCH, [this.menuContext.albumInfo, Action.NEW_WITHOUT_DIALOG.actionID]);
    this.onOperationEnd?.();
  }

  public onError(): void {
    Log.error(TAG, 'new album data failed!');
    this.onOperationEnd?.();
  }

  private async confirmCallback(displayName: string): Promise<boolean> {
    return await this.confirmCallbackBindImpl(displayName);
  }

  private async confirmCallbackBindImpl(displayName: string): Promise<boolean> {
    Log.info(TAG, `AlbumSet new album confirm and the new name is: ${AlbumDefine.getAnonymizeAlbumName(displayName)},` +
      ` jumpSourceToMain = ${this.menuContext.jumpSourceToMain}`);
    if (!displayName || !displayName.trim()) {
      UiUtil.showToast($r('app.string.please_enter_name'));
      return false;
    }
    if (displayName) {
      // 过滤用户相册和来源相册
      let startTime: number = Date.now();
      TraceControllerUtils.startTraceWithTaskId('getAlbumByName', startTime);
      let targetAlbum: photoAccessHelper.Album | undefined =
        await UserFileManagerAccess.getInstance().getAlbumByName(displayName);
      TraceControllerUtils.finishTraceWithTaskId('getAlbumByName', startTime);
      Log.info(TAG, `getAlbumByName cost ${Date.now() - startTime} ms`);
      if (targetAlbum) {
        UiUtil.showToast($r('app.string.name_already_use'));
        this.onOperationEnd = this.menuContext.onOperationFail;
        this.onOperationEnd?.();
        return false;
      }
    }
    this.onOperationEnd = this.menuContext.onOperationEnd;
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart?.();

    let album: PhotoAlbum | undefined = await UserFileManagerAccess.getInstance().createUserAlbum(displayName);
    if (this.menuContext.jumpSourceToMain === JumpSourceToMain.ALBUM) {
      let isAlbumSetActive: boolean = AlbumSetDataSourceManager.getInstance().getDataSource().isActive;
      Log.info(TAG, `go back to photo grid isAlbumSetActive: ${isAlbumSetActive}`);
      if (!isAlbumSetActive) {
        AlbumSetDataSourceManager.getInstance().getDataSource().resume();
      }
      AlbumSetDataSourceManager.getInstance().getDataSource().notifyDirty();

      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        this.menuContext.broadCast?.emit(BroadCastConstants.PC_SET_NEW_ALBUM_FOCUS_STATE_OPERATION,
          [this.menuContext.isNewAlbumRequestFocus]);
        let logMsg: string[] = ['confirmCallbackBindImpl'];
        logMsg.push(`isFromPhotoBrowser: ${this.menuContext.isFromPhotoBrowser}`);
        Log.info(TAG, logMsg.join(', '));
        if (this.menuContext.isFromPhotoBrowser) {
          this.menuContext.broadCast?.emit(BroadCastConstants.PC_MEDIA_OPERATION_BROWSER,
            [MediaOperationType.MOVE, displayName, album?.albumUri, (): void => this.onCompleted()]);
        } else {
          this.menuContext.broadCast?.emit(BroadCastConstants.PC_MEDIA_OPERATION,
            [MediaOperationType.MOVE, displayName, album?.albumUri, (): void => this.onCompleted()]);
        }
        // 新架构action走回调逻辑 不走上面broadCast事件
        let listener: AlbumCreateListener | undefined =
          this.menuContext.get<AlbumCreateListener>(AlbumSetNewMenuOperation.LISTENER);
        listener?.onCompleted(displayName, album?.albumUri);
      } else {
        this.menuContext.broadCast?.emit(BroadCastConstants.MEDIA_OPERATION,
          [displayName, album?.albumUri, (): void => this.onCompleted()]);
      }
    } else {
      /* instrument ignore next */
      if (DeviceInfo.isPc()) {
        Log.info(TAG, 'go back to albumSetPage');
        this.onCompleted();
        return true;
      }
      Log.info(TAG, 'go to PickerBasePage');
      AlbumSetDataSourceManager.getInstance().getDataSource().resume();
      this.menuContext.broadCast?.emit(BroadCastConstants.PICKER_OPERATION,
        [displayName, album?.albumUri, (): void => this.onCompleted()]);
    }
    return true;
  }

  private cancelCallback(): void {
    this.cancelCallbackBindImpl();
  }

  private cancelCallbackBindImpl(): void {
    Log.info(TAG, 'AlbumSet new album cancel');
  }

  /**
   * 过滤出所有“新建相册 XXX”后的数字集合，以便生成新相册名时避开
   *
   * @param albumName 相册名称
   * @param prefixName 相册名称前缀
   * @param numbers 过滤出的数字放入numbers作为输出
   */
  private checkAndAddNumber(albumName: Resource | string, prefixName: string, numbers: number[]): void {
    if (!albumName) {
      Log.warn(TAG, 'album is empty');
      return;
    }
    let res: RegExpMatchArray | null | undefined =
      Rsc.toString(albumName)?.match(new RegExp(`^${prefixName}` + ' ' + '[1-9][0-9]*$'));
    Log.info(TAG, `check name res ${res}`);
    if (res) {
      let matchedNumber: RegExpMatchArray | null = res[0].match(new RegExp('[1-9][0-9]*'));
      if (matchedNumber?.[0]) {
        numbers.push(Number.parseInt(matchedNumber[0]));
      }
    }
  }

  /**
   * 获取创建新相册的相册名
   *
   * @param prefixName 相册名前缀
   * @returns Promise<string> 新相册名称
   */
  private async getNewAlbumDefaultName(prefixName: string): Promise<string> {
    let numbers: number[] = await this.fetchAndFilterOutExistedNumbersToBeAdded(prefixName);
    Log.debug(TAG, `before sort ${JSON.stringify(numbers)}`);

    if (numbers.length <= 0) {
      return `${prefixName} 1`;
    }
    if (numbers.length === 1) {
      if (numbers[0] - 1 > 0) {
        return `${prefixName} 1`;
      }
      return `${prefixName} ${numbers[0] + 1}`;
    }

    numbers.sort((a: number, b: number): number => {
      return a - b;
    });

    Log.debug(TAG, `after sort ${JSON.stringify(numbers)}`);

    if (numbers[0] - 1 > 0) {
      return `${prefixName} 1`;
    }

    for (let i: number = 1; i < numbers.length; i++) {
      let res: number = numbers[i - 1] + 1;
      if (res < numbers[i]) {
        return `${prefixName} ${res}`;
      }
    }
    return `${prefixName} ${numbers[numbers.length - 1] + 1}`;
  }

  /**
   * 查询媒体库接口，获取并过滤出所有“新建相册 XXX”后的数字集合，以便生成新相册名时避开
   *
   * @param prefixName 文件夹名称前缀：“新建相册”
   * @returns Promise<void>
   */
  private async fetchAndFilterOutExistedNumbersToBeAdded(prefixName: string): Promise<number[]> {
    let numbers: number[] = [];
    let existedAlbums: PhotoAlbum[] | undefined =
      await UserFileManagerAccess.getInstance().getExistedSourceAndUserAlbums();
    if (existedAlbums) {
      for (let i: number = 0; i < (existedAlbums.length ?? Number.NaN); i++) {
        let sourceAlbum: PhotoAlbum = existedAlbums[i];
        Log.debug(TAG, `fetchAndFilterOutExistedNumbersToBeAdded albumName = ${AlbumDefine.getAnonymizeAlbumName(
          sourceAlbum?.albumName)}`);
        this.checkAndAddNumber(sourceAlbum?.albumName ?? '', prefixName, numbers);
      }
    }
    if (this.menuContext && this.menuContext.albumInfo) {
      this.checkAndAddNumber(this.menuContext.albumInfo?.albumName, prefixName, numbers);
    }
    return numbers;
  }
}