/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import {MediaLibraryAccess} from '../../access/MediaLibraryAccess.ets';

export class AlbumDefine {
    static readonly ALBUM_NAME_ALL = 'default_all';
    static readonly ALBUM_NAME_CAMERA = 'default_camera';
    static readonly ALBUM_NAME_VIDEO = 'default_video';
    static readonly ALBUM_NAME_RECYCLE = 'default_recycle';
    static readonly ALBUM_NAME_FAVOR = 'default_favor';
    static readonly ALBUM_NAME_SNAPSHOT = 'default_snapshot';
    static readonly ALBUM_NAME_REMOTE = 'FromOtherDevices';

    static readonly ALBUM_DISABLE_COPY_LIST = new Set ([
        AlbumDefine.ALBUM_NAME_ALL,
        AlbumDefine.ALBUM_NAME_VIDEO,
        AlbumDefine.ALBUM_NAME_RECYCLE,
        AlbumDefine.ALBUM_NAME_FAVOR
    ]);

    static readonly ALBUM_DISABLE_DELETE_LIST = new Set ([
        AlbumDefine.ALBUM_NAME_ALL,
        AlbumDefine.ALBUM_NAME_CAMERA,
        AlbumDefine.ALBUM_NAME_VIDEO,
        AlbumDefine.ALBUM_NAME_RECYCLE,
        AlbumDefine.ALBUM_NAME_FAVOR,
        AlbumDefine.ALBUM_NAME_SNAPSHOT
    ]);

    static readonly ALBUM_DISABLE_RENAME_LIST = new Set ([
        AlbumDefine.ALBUM_NAME_ALL,
        AlbumDefine.ALBUM_NAME_CAMERA,
        AlbumDefine.ALBUM_NAME_VIDEO,
        AlbumDefine.ALBUM_NAME_RECYCLE,
        AlbumDefine.ALBUM_NAME_FAVOR,
        AlbumDefine.ALBUM_NAME_SNAPSHOT
    ]);

    static readonly ALBUM_DEFAULT_SORT_LIST = [
        AlbumDefine.ALBUM_NAME_CAMERA,
        AlbumDefine.ALBUM_NAME_ALL,
        AlbumDefine.ALBUM_NAME_VIDEO,
        AlbumDefine.ALBUM_NAME_FAVOR
    ];

    static readonly QUERY_ORDER_BASE = 'date_added DESC';  // TODO dateTaken is not supported, use dateAdded

    private static readonly DEFAULT_ALBUM_FETCH_OPTIONS = new Map([
        [
            AlbumDefine.ALBUM_NAME_ALL,
            {
                selections: `${MediaLibraryAccess.FILE_KEY_MEDIA_TYPE} =? OR ${MediaLibraryAccess.FILE_KEY_MEDIA_TYPE} =?`,
                selectionArgs: [MediaLibraryAccess.MEDIA_TYPE_IMAGE.toString(), MediaLibraryAccess.MEDIA_TYPE_VIDEO.toString()],
                order: AlbumDefine.QUERY_ORDER_BASE
            }
        ],
        [
            AlbumDefine.ALBUM_NAME_VIDEO,
            {
                selections: `${MediaLibraryAccess.FILE_KEY_MEDIA_TYPE} =?`,
                selectionArgs: [MediaLibraryAccess.MEDIA_TYPE_VIDEO.toString()],
                order: AlbumDefine.QUERY_ORDER_BASE
            }
        ],
        [
            AlbumDefine.ALBUM_NAME_FAVOR,
            {
                selections: '',
                selectionArgs: [],
                order: AlbumDefine.QUERY_ORDER_BASE
            }
        ],
        [
            AlbumDefine.ALBUM_NAME_RECYCLE,
            {
                selections: '',
                selectionArgs: [],
                order: 'date_trashed DESC'
            }
        ],
        [
            AlbumDefine.ALBUM_NAME_CAMERA,
            {
                selections: 'relative_path =? AND bucket_display_name =?',
                selectionArgs: [MediaLibraryAccess.PUBLIC_PATH_IMAGE, "Camera"],
            }
        ]
    ]);

    static getFetchOpt(albumName: string, deviceId?) {
        let opt = AlbumDefine.DEFAULT_ALBUM_FETCH_OPTIONS.get(albumName);
        let fetchOpt = {
            selections: '',
            selectionArgs: [],
            order: ''
        };

        if (opt){
            fetchOpt = {
                selections: opt.selections,
                selectionArgs: opt.selectionArgs,
                order: opt.order
            };
        } else {
            fetchOpt = {
                selections: `bucket_display_name =?`,
                selectionArgs: [`${albumName}`],
                order: AlbumDefine.QUERY_ORDER_BASE
            };
        }

        if (deviceId != undefined && deviceId != ''){
            fetchOpt['networkId'] = deviceId;
        }

        return fetchOpt;
    }

    static getFileFetchOpt(fileId, deviceId?) {
        let fetchOpt = {
            selections : 'file_id =?',
            selectionArgs : [`${fileId}`],
            order: ''
        };

        if (deviceId != undefined && deviceId != ''){
            fetchOpt['networkId'] = deviceId;
        }

        return fetchOpt;
    }

    static getFileFetchOptByName(displayName){
        let fetchOpt = {
            selections: 'display_name =?',
            selectionArgs: [`${displayName}`],
        }

        return fetchOpt;
    }

    static getAlbumFetchOpt(displayName?, deviceId?){
        let fetchOpt = {
            selections: '',
            selectionArgs: []
        };

        if (displayName != undefined && displayName != '') {
            fetchOpt.selections = `bucket_display_name =?`,
            fetchOpt.selectionArgs = [`${displayName}`]
        }

        if (displayName == AlbumDefine.ALBUM_NAME_CAMERA) {
            let opt = AlbumDefine.DEFAULT_ALBUM_FETCH_OPTIONS.get(AlbumDefine.ALBUM_NAME_CAMERA);
            fetchOpt.selections = opt.selections;
            fetchOpt.selectionArgs = opt.selectionArgs;
        }

        if (deviceId != undefined && deviceId != "") {
            fetchOpt["networkId"] = deviceId;
        }

        return fetchOpt;
    }
}