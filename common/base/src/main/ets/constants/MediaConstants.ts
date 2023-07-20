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

export class MediaConstants {
    // Media item status
    static readonly UNDEFINED = 0;
    static readonly PART_LOADED = 1
    static readonly LOADED = 2;
    static readonly TRASHED = 3;
    // Media type
    static readonly MEDIA_TYPE_IMAGE: string = 'image';
    static readonly MEDIA_TYPE_VIDEO: string = 'video';
    static readonly MEDIA_TYPE_ALBUM: string = 'album';
    static readonly MEDIA_TYPE_DEVICE: string = 'device';
    static readonly MEDIA_TYPE_REMOTE: string = 'remote';

    static readonly DEVICE_STATE_ONLINE: string = 'online';
    static readonly DEVICE_STATE_OFFLINE: string = 'offline';
    static readonly DEVICE_STATE_CHANGE: string = 'change';
    static readonly ROTATE_NONE = 0;
    static readonly ROTATE_ONCE = 90;
    static readonly ROTATE_TWICE = 180;
    static readonly ROTATE_THIRD = 270;
    static readonly ROTATE_AROUND = 360;
    static readonly DEFAULT_SIZE = 256;
    static readonly DEFAULT_THUMBNAIL_SIZE = 1920;
    // select type
    static readonly SELECT_TYPE_ALL = 0;
    static readonly SELECT_TYPE_VIDEO = 1;
    static readonly SELECT_TYPE_IMAGE = 2;
    // album id
    static readonly ALBUM_ID_ALL = 'default_all';
    static readonly ALBUM_ID_CAMERA = 'default_camera';
    static readonly ALBUM_ID_VIDEO = 'default_video';
    static readonly ALBUM_ID_RECYCLE = 'default_recycle';
    static readonly ALBUM_ID_FAVOR = 'default_favor';
    static readonly ALBUM_ID_SNAPSHOT = 'default_snapshot';
    static readonly ALBUM_ID_REMOTE = 'default_remote';
    static readonly ALBUM_DISABLE_COPY_LIST = new Set([
        MediaConstants.ALBUM_ID_CAMERA,
        MediaConstants.ALBUM_ID_ALL,
        MediaConstants.ALBUM_ID_VIDEO,
        MediaConstants.ALBUM_ID_RECYCLE,
        MediaConstants.ALBUM_ID_FAVOR,
        MediaConstants.ALBUM_ID_SNAPSHOT
    ]);
    static readonly ALBUM_DISABLE_DELETE_LIST = new Set([
        MediaConstants.ALBUM_ID_ALL,
        MediaConstants.ALBUM_ID_CAMERA,
        MediaConstants.ALBUM_ID_VIDEO,
        MediaConstants.ALBUM_ID_RECYCLE,
        MediaConstants.ALBUM_ID_FAVOR,
        MediaConstants.ALBUM_ID_SNAPSHOT
    ]);
    static readonly ALBUM_DISABLE_NEW_LIST = new Set([
        MediaConstants.ALBUM_ID_ALL,
        MediaConstants.ALBUM_ID_CAMERA,
        MediaConstants.ALBUM_ID_VIDEO,
        MediaConstants.ALBUM_ID_RECYCLE,
        MediaConstants.ALBUM_ID_FAVOR,
        MediaConstants.ALBUM_ID_SNAPSHOT
    ]);
    static readonly ALBUM_DISABLE_RENAME_LIST = new Set([
        MediaConstants.ALBUM_ID_ALL,
        MediaConstants.ALBUM_ID_CAMERA,
        MediaConstants.ALBUM_ID_VIDEO,
        MediaConstants.ALBUM_ID_RECYCLE,
        MediaConstants.ALBUM_ID_FAVOR,
        MediaConstants.ALBUM_ID_SNAPSHOT
    ]);
    static readonly ALBUM_DEFAULT_SORT_LIST = [
        MediaConstants.ALBUM_ID_CAMERA,
        MediaConstants.ALBUM_ID_ALL,
        MediaConstants.ALBUM_ID_VIDEO,
        MediaConstants.ALBUM_ID_SNAPSHOT,
        MediaConstants.ALBUM_ID_FAVOR
    ];
    static readonly CAMERA_ALBUM_PATH = 'Camera'
    static readonly REMOTE_ALBUM_PATH = 'FromOtherDevices'
    static readonly SNAPSHOT_ALBUM_PATH = 'Screenshots'

    // 需要过滤的媒体文件类型
    static readonly FILTER_MEDIA_TYPE_ALL: string = 'FILTER_MEDIA_TYPE_ALL';
    static readonly FILTER_MEDIA_TYPE_IMAGE: string = 'FILTER_MEDIA_TYPE_IMAGE';
    static readonly FILTER_MEDIA_TYPE_VIDEO: string = 'FILTER_MEDIA_TYPE_VIDEO';
}