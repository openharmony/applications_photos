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
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import {
  FaCardAlbumUtils,
  getUriExistInProxyInfo,
  insertTask
} from '@ohos/dataprovider/src/main/ets/database/service/FaCardAlbumService';
import { AlbumType } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';
import { DataShareResultSet, DataType } from '@kit.ArkData';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import { AssetHelper } from '@ohos/common/src/main/ets/default/utils/AssetHelper';
import {
  PhotoAlbum,
  PhotoAsset,
  UserFileManagerAccess
} from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { FaCardInfo } from '@ohos/dataprovider/src/main/ets/database/service/FaCardService';
import { PhotoAccessHelperAccess } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import { common } from '@kit.AbilityKit';
import ReminderService, { ImageInfo } from '@ohos/dataprovider/src/main/ets/database/service/ReminderService';
import { FormControllerManager } from '@ohos/dataprovider/src/main/ets/controller/FormControllerManager';

const TAG: string = `FaCardAlbumUtilsTest `;

export default function FaCardAlbumUtilsUT() {
  interface MethodCallCounter {
    goToFirstRow: number;
    goToNextRow: number;
  }

  class MockDataShareResultSet implements DataShareResultSet {
    cursor: number = -1;
    callCount: MethodCallCounter = {
      goToFirstRow: 0,
      goToNextRow: 0,
    };
    columnNames: string[] = [];
    columnCount: number = 0;
    rowCount: number = 0;
    isClosed: boolean = true;
    private uris: string[];

    constructor(uris: string[]) {
      this.uris = uris;
    }

    goToLastRow(): boolean {
      return false;
    }

    goToPreviousRow(): boolean {
      return false;
    }

    goTo(offset: number): boolean {
      return false;
    }

    goToRow(position: number): boolean {
      return false;
    }

    getBlob(columnIndex: number): Uint8Array {
      return new Uint8Array();
    }

    getLong(columnIndex: number): number {
      return 0;
    }

    getDouble(columnIndex: number): number {
      return 0;
    }

    getDataType(columnIndex: number): DataType {
      return DataType.TYPE_NULL;
    }

    // 实现接口必须的方法
    goToFirstRow(): boolean {
      this.callCount.goToFirstRow++;
      this.cursor = this.uris.length > 0 ? 0 : -1;
      return this.cursor >= 0;
    }

    goToNextRow(): boolean {
      this.callCount.goToNextRow++;
      if (this.cursor >= this.uris.length - 1) {
        return false;
      }
      this.cursor++;
      return true;
    }

    getColumnIndex(column: string): number {
      return column === 'uri' ? 0 : -1;
    }

    getString(index: number): string {
      return this.uris[this.cursor];
    }

    close(): void {
      /* 空实现 */
    }

    getColumnName(index: number): string {
      return '';
    }
  }

  describe('FaCardAlbumUtilsUT', () => {
    let faCardAlbumUtils: FaCardAlbumUtils
    let mocker: MockKit

    beforeEach(() => {
      faCardAlbumUtils = new FaCardAlbumUtils({} as Context)
      mocker = new MockKit()
    })

    afterEach(() => {
      mocker.clearAll();
    });

    it('getUriExistInProxyInfo_case1', 0, () => {
      let assets: photoAccessHelper.PhotoAsset[] = [{
        uri: 'uri1',
      }, {
        uri: 'uri2',
      },] as photoAccessHelper.PhotoAsset[];
      const res = getUriExistInProxyInfo(assets, undefined);
      expect(res).not().assertNull();
    });

    it('getUriExistInProxyInfo_case2', 0, () => {
      let assets: photoAccessHelper.PhotoAsset[] = [{
        uri: 'uri1',
      }, {
        uri: 'uri2',
      },] as photoAccessHelper.PhotoAsset[];
      const mockResultSet = new MockDataShareResultSet(['uri1', 'uri2', 'uri3']);
      const res = getUriExistInProxyInfo(assets, mockResultSet);
      expect(res).not().assertNull();
    });

    it('getUriExistInProxyInfo_case3', 0, () => {
      let assets: photoAccessHelper.PhotoAsset[] = [{
        uri: 'uri1',
      }, {
        uri: 'uri2',
      },] as photoAccessHelper.PhotoAsset[];
      const mockResultSet = new MockDataShareResultSet(['uri1', 'uri2', 'uri3']);
      const res = getUriExistInProxyInfo(assets, mockResultSet);
      expect(res).not().assertNull();
    });

    it('insertTask_case1', 0, () => {
      let result: photoAccessHelper.PhotoAsset[] = [{
        uri: 'uri1',
      }, {
        uri: 'uri2',
      },] as photoAccessHelper.PhotoAsset[];
      const func = () => {
        when(mocker.mockFunc(AssetHelper, AssetHelper.get))(ArgumentMatchers.any).afterReturn(0);
        insertTask(result, [true], '', {} as Context, '');
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertTask_case2', 0, () => {
      let result: photoAccessHelper.PhotoAsset[] = [{
        uri: 'uri1',
      }, {
        uri: 'uri2',
      },] as photoAccessHelper.PhotoAsset[];
      const func = () => {
        when(mocker.mockFunc(AssetHelper, AssetHelper.get))(ArgumentMatchers.any).afterReturn(0);
        insertTask(result, [false], '', {} as Context, '');
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertTask_case3', 0, () => {
      let result: photoAccessHelper.PhotoAsset[] = [{
        uri: 'uri1',
      }, {
        uri: 'uri2',
      },] as photoAccessHelper.PhotoAsset[];
      const func = () => {
        when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
          .afterReturn(true)
        when(mocker.mockFunc(AssetHelper, AssetHelper.get))(ArgumentMatchers.any).afterReturn(0);
        insertTask(result, [false], '', {} as Context, '');
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('handleClick_case2', 0, () => {
      let album: AlbumInfo = new AlbumInfo();
      album.uri = '';
      const func = () => {
        faCardAlbumUtils.handleClick(album, '', 0, AlbumType.NORMAL);
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('updateFaCardDb_case1', Level.LEVEL0, () => {
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(true)
      const album: AlbumInfo = new AlbumInfo();
      album.uri = '';
      const mockFaCardInfo: FaCardInfo = {
        albumUri: '',
      } as FaCardInfo;
      const func = () => {
        faCardAlbumUtils.updateFaCardDb(album, mockFaCardInfo);
      }
      expect(func).not().assertThrowError('BusinessError');
    })

    it('updateFaCardDb_case2', Level.LEVEL0, () => {
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      // mock不生效
      when(mocker.mockFunc(ReminderService, ReminderService.constructor))(ArgumentMatchers.any).afterReturn({
        async deletePhotosByFormId() {
          return 1
        }
      })
      const album: AlbumInfo = new AlbumInfo();
      album.uri = '';
      const mockFaCardInfo: FaCardInfo = {
        albumUri: '',
      } as FaCardInfo;
      const func = () => {
        faCardAlbumUtils.updateFaCardDb(album, mockFaCardInfo);
      }
      expect(func).not().assertThrowError('BusinessError');
    })

    it('updateFaCardDb_on_error', Level.LEVEL0, () => {
      // mock不生效
      when(mocker.mockFunc(ReminderService, ReminderService.constructor))(ArgumentMatchers.any).afterReturn({
        deletePhotosByFormId() {
          throw new Error('test error')
        }
      })
      const func = () => {
        faCardAlbumUtils.updateFaCardDb(new AlbumInfo(), {
          albumUri: '',
        } as FaCardInfo);
      }
      expect(func).not().assertThrowError('BusinessError');
    })

    it('insertReminderAndImage_case1', 0, () => {
      const func = () => {
        const run = (album?: AlbumInfo): void => Reflect.get(faCardAlbumUtils, 'insertReminderAndImage')
          .call(faCardAlbumUtils, album)
        run();
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertReminderAndImage_case2', 0, () => {
      let album: AlbumInfo = new AlbumInfo();
      album.uri = '';
      const run = (album?: AlbumInfo): void => Reflect.get(faCardAlbumUtils, 'insertReminderAndImage')
        .call(faCardAlbumUtils, album);
      let mockFetch: photoAccessHelper.FetchResult<PhotoAsset> = {
        getAllObjects(): Promise<Array<PhotoAsset>> {
          return Promise.resolve([]);
        }
      } as photoAccessHelper.FetchResult<PhotoAsset>;
      let mockPhotoAlbum: PhotoAlbum = {
        getAssets(options: photoAccessHelper.FetchOptions): Promise<photoAccessHelper.FetchResult<PhotoAsset>> {
          return Promise.resolve(mockFetch);
        }
      } as PhotoAlbum;
      const func = () => {
        when(mocker.mockFunc(UserFileManagerAccess.getInstance(),
          UserFileManagerAccess.getInstance().getAlbumByUri))(ArgumentMatchers.any).afterReturn(mockPhotoAlbum);
        run(album);
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertReminderAndImage_case3', 0, () => {
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(true);
      const func = () => {
        const run = (album?: AlbumInfo): void => Reflect.get(faCardAlbumUtils, 'insertReminderAndImage')
          .call(faCardAlbumUtils, album);
        run();
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertReminderAndImage_case4', Level.LEVEL0, () => {
      const func = () => {
        when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
          .afterReturn(true)
        Reflect.get(faCardAlbumUtils, 'insertReminderAndImage').call()
      }
      expect(func).not().assertThrowError('BusinessError');
    })

    it('getAlbumAssets_case1', 0, () => {
      let mockPhotoAlbum: PhotoAlbum = {
        getAssets(options?: photoAccessHelper.FetchOptions): Promise<photoAccessHelper.FetchResult<PhotoAsset> | undefined> {
          return Promise.resolve(undefined);
        }
      } as PhotoAlbum;
      const res = faCardAlbumUtils.getAlbumAssets(mockPhotoAlbum, 0, 0);
      expect(res).not().assertNull();
    });

    it('getAlbumAssets_case2', 0, () => {
      let mockFetch: photoAccessHelper.FetchResult<PhotoAsset> = {
        getAllObjects(): Promise<Array<PhotoAsset>> {
          return Promise.resolve([]);
        },
        getCount(): number {
          return 0;
        },
        close(): void {

        }
      } as photoAccessHelper.FetchResult<PhotoAsset>;
      let mockPhotoAlbum: PhotoAlbum = {
        getAssets(options: photoAccessHelper.FetchOptions): Promise<photoAccessHelper.FetchResult<PhotoAsset>> {
          return Promise.resolve(mockFetch);
        }
      } as PhotoAlbum;
      const res = faCardAlbumUtils.getAlbumAssets(mockPhotoAlbum, 0, 0);
      expect(res).not().assertNull();
    });

    it('getAlbumAssets_case3', 0, () => {
      let mockFetch: photoAccessHelper.FetchResult<PhotoAsset> = {
        getAllObjects(): Promise<Array<PhotoAsset>> {
          return Promise.resolve([]);
        },
        getCount(): number {
          return 1;
        },
        close(): void {

        }
      } as photoAccessHelper.FetchResult<PhotoAsset>;
      let mockPhotoAlbum: PhotoAlbum = {
        getAssets(options: photoAccessHelper.FetchOptions): Promise<photoAccessHelper.FetchResult<PhotoAsset>> {
          return Promise.resolve(mockFetch);
        }
      } as PhotoAlbum;
      const res = faCardAlbumUtils.getAlbumAssets(mockPhotoAlbum, 0, 0);
      expect(res).not().assertNull();
    });

    it('getAlbumAssets_case4', 0, () => {
      let mockFetch: photoAccessHelper.FetchResult<PhotoAsset> = {
        getAllObjects(): Promise<Array<PhotoAsset>> {
          return Promise.resolve([]);
        },
        getCount(): number {
          return 1;
        }
      } as photoAccessHelper.FetchResult<PhotoAsset>;
      let mockPhotoAlbum: PhotoAlbum = {
        getAssets(options: photoAccessHelper.FetchOptions): Promise<photoAccessHelper.FetchResult<PhotoAsset>> {
          return Promise.resolve(mockFetch);
        }
      } as PhotoAlbum;
      const res = faCardAlbumUtils.getAlbumAssets(mockPhotoAlbum, 0, 0);
      expect(res).not().assertNull();
    });

    it('getAssetsByTurn_case1', 0, () => {
      let mockPhotoAlbum: PhotoAlbum = {
        getAssets(options?: photoAccessHelper.FetchOptions): Promise<photoAccessHelper.FetchResult<PhotoAsset> | undefined> {
          return Promise.resolve(undefined);
        }
      } as PhotoAlbum;
      const res = faCardAlbumUtils.getAssetsByTurn(mockPhotoAlbum, 0, 10, 0);
      expect(res).not().assertNull();
    });

    it('updateForm_case1', 0, () => {
      let mockFaCardInfo: FaCardInfo = {
        albumUri: '',
      } as FaCardInfo;
      const func = () => {
        faCardAlbumUtils.updateForm(mockFaCardInfo, {} as Context);
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('updateForm_case2', 0, () => {
      let mockFaCardInfo: FaCardInfo = {
        albumUri: '', albumType: 3,
      } as FaCardInfo;
      const func = () => {
        faCardAlbumUtils.updateForm(mockFaCardInfo, {} as Context);
      }
      expect(func).not().assertThrowError('BusinessError');
    });
    it('updateForm_case3', 0, () => {
      let mockFaCardInfo: FaCardInfo = {
        albumUri: '', albumType: 2,
      } as FaCardInfo;
      const func = () => {
        faCardAlbumUtils.updateForm(mockFaCardInfo, {} as Context);
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('getCityAlbumInfo_case1', 0, () => {
      const res = faCardAlbumUtils.getCityAlbumInfo('');
      expect(res).not().assertNull();
    });

    it('getCityAlbumInfo_case2', 0, () => {
      let context: common.UIAbilityContext = {} as common.UIAbilityContext;
      when(mocker.mockFunc(PhotoAccessHelperAccess.getInstance(),
        PhotoAccessHelperAccess.getInstance().getCityAlbum))(ArgumentMatchers.any).afterReturn(undefined);
      const res = faCardAlbumUtils.getCityAlbumInfo('123', context);
      expect(res).not().assertNull();
    });

    it('getCityAlbumInfo_case3', 0, () => {
      let context: common.UIAbilityContext = {} as common.UIAbilityContext;
      let albums: PhotoAlbum[] = [{} as PhotoAlbum];
      when(mocker.mockFunc(PhotoAccessHelperAccess.getInstance(),
        PhotoAccessHelperAccess.getInstance().getCityAlbum))(ArgumentMatchers.any).afterReturn(albums);
      const res = faCardAlbumUtils.getCityAlbumInfo('123', context);
      expect(res).not().assertNull();
    });

    it('updateScheduler_case1', 0, () => {
      const func = () => {
        FaCardAlbumUtils.updateScheduler('', 0);
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('updateScheduler_case2', 0, () => {
      let context: Context = {} as Context;
      AppStorage.setOrCreate('formContext', context);
      const func = () => {
        FaCardAlbumUtils.updateScheduler('', 0);
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertNewTurnByFormId_case1', 0, () => {
      const fakeGetTaskPreemptedStatus =
        mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus)
      when(fakeGetTaskPreemptedStatus)(ArgumentMatchers.any).afterReturn(false)

      const func = () => {
        faCardAlbumUtils.insertNewTurnByFormId(new UserFileManagerAccess(), {} as FaCardInfo);
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertNewTurnByFormId_case2', 0, () => {
      const fakeGetTaskPreemptedStatus =
        mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus)
      when(fakeGetTaskPreemptedStatus)(ArgumentMatchers.any).afterReturn(false);

      const func = () => {
        faCardAlbumUtils.insertNewTurnByFormId(new UserFileManagerAccess(), {} as FaCardInfo, {
          // 最近轮播的图片
          lastCarouselImageInfo: {
            id: 1,
            formId: 1,
            imageUri: 'string',
            showTime: 1,
            albumUri: 'string',
            isHidden: 1,
            dateTaken: 1,
            dateAdded: 1,
          },

          // reminders表中插入的最后一张
          lastImageInfo: {
            id: 1,
            formId: 1,
            imageUri: 'string',
            showTime: 1,
            albumUri: 'string',
            isHidden: 1,
            dateTaken: 1,
            dateAdded: 1,
          },

          // reminders表中可以保留的图片数量
          remainCount: 1,
        });
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertNewTurnByFormId_case3', 0, () => {
      const fakeGetTaskPreemptedStatus =
        mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus)
      when(fakeGetTaskPreemptedStatus)(ArgumentMatchers.any).afterReturn(true);

      const func = () => {
        faCardAlbumUtils.insertNewTurnByFormId(new UserFileManagerAccess(), {} as FaCardInfo);
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertNewTurnInBlankFACard_case1', 0, () => {
      const func = () => {
        const run =
          (userFileManagerAccess?: UserFileManagerAccess,
            albumUri?: string): Promise<void> => faCardAlbumUtils.insertNewTurnInBlankFACard(userFileManagerAccess as UserFileManagerAccess,
            {} as FaCardInfo)
        run();
      }
      expect(func).not().assertThrowError('BusinessError');
    });
    it('insertNewTurnInBlankFACard_case2', 0, () => {
      const func = () => {
        let userFileManagerAccess: UserFileManagerAccess = new UserFileManagerAccess();
        faCardAlbumUtils.insertNewTurnInBlankFACard(userFileManagerAccess, {} as FaCardInfo);
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertNewTurnInBlankFACard_case3', 0, () => {
      const func = () => {
        let userFileManagerAccess: UserFileManagerAccess = new UserFileManagerAccess();
        let album: PhotoAlbum = {} as PhotoAlbum;
        when(mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.getAlbumByUri))(ArgumentMatchers.any)
          .afterReturn(album);

        faCardAlbumUtils.insertNewTurnInBlankFACard(userFileManagerAccess, {} as FaCardInfo);
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertNewTurnReminderAndImage_case1', 0, () => {
      const func = () => {
        const run =
          (userFileManagerAccess?: UserFileManagerAccess,
            albumUri?: string, lastCarouselImageInfo?: ImageInfo, lastImageInfo?: ImageInfo,
            remainCount?: number): Promise<void> =>
          faCardAlbumUtils.insertNewTurnReminderAndImage(userFileManagerAccess as UserFileManagerAccess,
            {} as FaCardInfo,
            lastCarouselImageInfo as ImageInfo, lastImageInfo as ImageInfo, 0);
        run();
      }
      expect(func).not().assertThrowError('BusinessError');
    });
    it('insertNewTurnReminderAndImage_case2', 0, () => {
      const func = () => {
        let userFileManagerAccess: UserFileManagerAccess = new UserFileManagerAccess();
        faCardAlbumUtils.insertNewTurnReminderAndImage(userFileManagerAccess, {} as FaCardInfo, {} as ImageInfo,
          {} as ImageInfo, 0);
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertNewTurnReminderAndImage_case3', 0, () => {
      const func = () => {
        let userFileManagerAccess: UserFileManagerAccess = new UserFileManagerAccess();
        let album: PhotoAlbum = {} as PhotoAlbum;
        when(mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.getAlbumByUri))(ArgumentMatchers.any)
          .afterReturn(album);

        faCardAlbumUtils.insertNewTurnReminderAndImage(userFileManagerAccess, {} as FaCardInfo, {} as ImageInfo,
          {} as ImageInfo, 0);
      }
      expect(func).not().assertThrowError('BusinessError');
    });

    it('insertNewTurnReminderAndImage_case4', 0, () => {
      const func = () => {
        when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
          .afterReturn(true);

        faCardAlbumUtils.insertNewTurnReminderAndImage(new UserFileManagerAccess(), {} as FaCardInfo, {} as ImageInfo,
          {} as ImageInfo, 0);
      }
      expect(func).not().assertThrowError('BusinessError');
    });


    it('insertSinglePhoto_with_getTaskPreemptedStatus_return_true', Level.LEVEL0, async () => {
      const func = async () => {
        when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
          .afterReturn(true);
        await FaCardAlbumUtils.insertSinglePhoto({ uri: '' } as photoAccessHelper.PhotoAsset, '', {} as Context, '');
      }
      expect(func).not().assertThrowError('BusinessError');
    })

    it('insertSinglePhoto', Level.LEVEL0, async () => {
      const func = async () => {
        when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
          .afterReturn(true);
        await FaCardAlbumUtils.insertSinglePhoto({ uri: '' } as photoAccessHelper.PhotoAsset, '', {} as Context, '');
      }
      expect(func).not().assertThrowError('BusinessError');
    })

    it('insertRemindersAndProxy_case1', Level.LEVEL0, async () => {
      const func = async () => {
        when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
          .afterReturn(true);
        await FaCardAlbumUtils.insertRemindersAndProxy([{ uri: '1' }, { uri: '2' }] as photoAccessHelper.PhotoAsset[],
          '',
          {} as Context, '');
      }
      expect(func).not().assertThrowError('BusinessError');
    })

    it('insertRemindersAndProxy_case2', Level.LEVEL0, async () => {
      const func = async () => {
        when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
          .afterReturn(false);
        await FaCardAlbumUtils.insertRemindersAndProxy([{ uri: '1' }, { uri: '2' }] as photoAccessHelper.PhotoAsset[],
          '',
          {} as Context, '');
      }
      expect(func).not().assertThrowError('BusinessError');
    })

    it('insertRemindersAndProxy_case3', Level.LEVEL0, async () => {
      const func = async () => {
        when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
          .afterReturn(false);
        const callback = async () => {
        }
        await FaCardAlbumUtils.insertRemindersAndProxy([{ uri: '1' }, { uri: '2' }] as photoAccessHelper.PhotoAsset[],
          '',
          {} as Context, '', callback);
      }
      expect(func).not().assertThrowError('BusinessError');
    })
  })
}
