/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import { Log } from '../../utils/Log';
import { BroadCastConstants } from '../../model/common/BroadCastConstants';
import { MenuOperationCallback } from './MenuOperationCallback';
import { MenuOperation } from './MenuOperation';
import { MenuContext, SourceSceneType } from './MenuContext';
import { JumpSourceToMain } from '../../model/browser/photo/JumpSourceToMain';
import { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import router from '@ohos.router';
import { UiUtil } from '../../utils/UiUtil';
import { AlbumDefine } from '../../model/browser/AlbumDefine';
import { BrowserDataFactory } from '../../interface/BrowserDataFactory';
import { BigDataConstants, ReportToBigDataUtil } from '../../utils/ReportToBigDataUtil';
import { Album, UserFileManagerAccess } from '../../access/UserFileManagerAccess';
import common from '@ohos.app.ability.common';

const TAG: string = 'common_AlbumSetNewMenuOperation';

export class AlbumSetNewMenuOperation implements MenuOperation, MenuOperationCallback {
  private menuContext: MenuContext;
  private defaultAlbumName: string = '';
  private onOperationEnd: Function = (): void => {};

  constructor(menuContext: MenuContext) {
    this.menuContext = menuContext;
  }

  async doAction(): Promise<void> {
    if (this.menuContext == null) {
      Log.error(TAG, 'menuContext is null, return');
      return;
    }
    interface Msg1 {
      type: string
    }
    let msg: Msg1 = {
      type: BigDataConstants.ALBUM_CREATE
    };
    ReportToBigDataUtil.report(BigDataConstants.ALBUM_OPERATION_ID, msg);

    let a = $r('app.string.album_new_album');
    Log.info(TAG, `The display name from resource ${JSON.stringify(a)}`);
    this.defaultAlbumName = '';
    try {
      let contextName: string = this.menuContext.sourceScene === SourceSceneType.BIG_PHOTO_COMPONENT ?
        'photoLibraryContext' : 'photosAbilityContext';
      let context: common.UIAbilityContext =
        AppStorage.get<common.UIAbilityContext>(contextName) as common.UIAbilityContext;
      if (context == null || context === undefined) {
        Log.info(TAG, 'context is null!');
      } else {
        this.defaultAlbumName = await context.resourceManager.getString(a.id);
        Log.info(TAG, `The display name is ${this.defaultAlbumName}`);
        let newAlbumDisplayName =
          this.getNewAlbumDefaultName(this.defaultAlbumName);
        Log.info(TAG, `The display name of new album is ${newAlbumDisplayName}`);

        this.menuContext.broadCast.emit(BroadCastConstants.SHOW_NEW_ALBUM_PHOTO_DIALOG,
          [newAlbumDisplayName, async (displayName: string): Promise<boolean> =>
          await this.confirmCallbackBindImpl(displayName),
            (): void => this.cancelCallbackBindImpl()]);
      }
    } catch (error) {
      interface Msg2 {
        type: string
        errMsg: string
      }
      let msg: Msg2 = {
        type: BigDataConstants.ALBUM_CREATE_ERROR,
        errMsg: JSON.stringify(error)
      };
      ReportToBigDataUtil.errEventReport(BigDataConstants.ALBUM_OPERATION_ERROR_ID, msg);
      Log.info(TAG, `The display name error ${error}`);
    }
  }

  onCompleted(): void {
    Log.info(TAG, 'new album data succeed!');
    this.onOperationEnd && this.onOperationEnd();
  }

  onError(): void {
    Log.error(TAG, 'new album data failed!');
    this.onOperationEnd && this.onOperationEnd();
  }

  private async confirmCallback(displayName: string): Promise<boolean> {
    return await this.confirmCallbackBindImpl(displayName);
  }

  private async confirmCallbackBindImpl(displayName: string): Promise<boolean> {
    Log.info(TAG, `AlbumSet new album confirm and the new name is: ${displayName}`);
    if (displayName) {
      // 过滤用户相册
      let targetAlbum: Album = await UserFileManagerAccess.getInstance().getAlbumByName(displayName);
      // 过滤系统相册
      let isAlbumNameExistInSystemAlbums: boolean = await UserFileManagerAccess.getInstance()
        .isAlbumNameExistInSystemAlbums(displayName);
      if (targetAlbum || isAlbumNameExistInSystemAlbums) {
        UiUtil.showToast($r('app.string.name_already_use'));
        return false;
      }
    }
    this.onOperationEnd = this.menuContext.onOperationEnd;
    let onOperationStart: Function = this.menuContext.onOperationStart;
    onOperationStart && onOperationStart();

    let album: Album = await UserFileManagerAccess.getInstance().createUserAlbum(displayName);
    if (this.menuContext.jumpSourceToMain == JumpSourceToMain.ALBUM) {
      Log.info(TAG, 'go back to photo grid');
      this.menuContext.broadCast.emit(BroadCastConstants.MEDIA_OPERATION,
        [displayName, album.albumUri, (): void => this.onCompleted()]);
    } else {
      router.pushUrl({
        url: 'pages/AlbumSelect',
        params: {
          albumName: displayName,
          albumUri: album.albumUri,
          isNewAlbum: true
        }
      });
      this.onCompleted();
    }
    return true;
  }

  private cancelCallback(): void {
    this.cancelCallbackBindImpl();
  }

  private cancelCallbackBindImpl(): void {
    Log.info(TAG, 'AlbumSet new album cancel');
  }

  private checkAndAddNumber(albumInfo: AlbumInfo, prefixName: string, numbers: number[]): void {
    if (!albumInfo || !albumInfo.albumName) {
      Log.warn(TAG, 'album is empty');
      return;
    }
    let res: string[] = albumInfo.albumName.match(new RegExp('^' + prefixName + '[1-9][0-9]*$')) as string[];
    Log.info(TAG, `check name res ${res}`)
    if (res) {
      let number: string[] = res[0].match(new RegExp('[1-9][0-9]*')) as string[];
      if (number != null && number[0] != null) {
        numbers.push(Number.parseInt(number[0]));
      }
    }
  }

  private getNewAlbumDefaultName(prefixName: string): string {
    let numbers: number[] = [];
    for (let i = 0; i < this.menuContext.albumSetDataSource.totalCount(); i++) {
      this.checkAndAddNumber(this.menuContext.albumSetDataSource.getData(i).data, prefixName, numbers);
    }
    let currentAlbum = this.menuContext.albumInfo;
    if (currentAlbum != null) {
      this.checkAndAddNumber(currentAlbum, prefixName, numbers);
    }

    Log.debug(TAG, `${JSON.stringify(numbers)}`);

    if (numbers.length <= 0) {
      return `${prefixName}1`;
    } else if (numbers.length == 1) {
      if (numbers[0] - 1 > 0) {
        return `${prefixName}1`;
      } else {
        return `${prefixName}${numbers[0] + 1}`;
      }
    }

    numbers.sort((a: number, b: number) => {
      return a - b;
    });

    if (numbers[0] - 1 > 0) {
      return `${prefixName}1`;
    }

    for (let i = 1; i < numbers.length; i++) {
      let res = numbers[i - 1] + 1;
      if (res < numbers[i]) {
        return `${prefixName}${res}`;
      }
    }
    return `${prefixName}${numbers[numbers.length - 1] + 1}`;
  }
}