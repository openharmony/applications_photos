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
import { MediaLibraryAccess, FetchOptionBuilder } from '../../access/MediaLibraryAccess'

export class AlbumDefine {
    static readonly ALBUM_ID_ALL = 'default_all';
    static readonly ALBUM_ID_CAMERA = 'default_camera';
    static readonly ALBUM_ID_VIDEO = 'default_video';
    static readonly ALBUM_ID_RECYCLE = 'default_recycle';
    static readonly ALBUM_ID_FAVOR = 'default_favor';
    static readonly ALBUM_ID_SNAPSHOT = 'default_snapshot';
    static readonly ALBUM_ID_REMOTE = 'default_remote';
    static readonly ALBUM_DISABLE_COPY_LIST = new Set([
        AlbumDefine.ALBUM_ID_ALL,
        AlbumDefine.ALBUM_ID_VIDEO,
        AlbumDefine.ALBUM_ID_RECYCLE,
        AlbumDefine.ALBUM_ID_FAVOR
    ]);
    static readonly ALBUM_DISABLE_DELETE_LIST = new Set([
        AlbumDefine.ALBUM_ID_ALL,
        AlbumDefine.ALBUM_ID_CAMERA,
        AlbumDefine.ALBUM_ID_VIDEO,
        AlbumDefine.ALBUM_ID_RECYCLE,
        AlbumDefine.ALBUM_ID_FAVOR
    ]);
    static readonly ALBUM_DISABLE_NEW_LIST = new Set([
        AlbumDefine.ALBUM_ID_ALL,
        AlbumDefine.ALBUM_ID_CAMERA,
        AlbumDefine.ALBUM_ID_VIDEO,
        AlbumDefine.ALBUM_ID_RECYCLE,
        AlbumDefine.ALBUM_ID_FAVOR,
        AlbumDefine.ALBUM_ID_SNAPSHOT
    ]);
    static readonly ALBUM_DISABLE_RENAME_LIST = new Set([
        AlbumDefine.ALBUM_ID_ALL,
        AlbumDefine.ALBUM_ID_CAMERA,
        AlbumDefine.ALBUM_ID_VIDEO,
        AlbumDefine.ALBUM_ID_RECYCLE,
        AlbumDefine.ALBUM_ID_FAVOR,
        AlbumDefine.ALBUM_ID_SNAPSHOT
    ]);
    static readonly ALBUM_DEFAULT_SORT_LIST = [
        AlbumDefine.ALBUM_ID_CAMERA,
        AlbumDefine.ALBUM_ID_ALL,
        AlbumDefine.ALBUM_ID_VIDEO,
        AlbumDefine.ALBUM_ID_SNAPSHOT,
        AlbumDefine.ALBUM_ID_FAVOR
    ];
    static readonly CAMERA_ALBUM_PATH = 'Camera'
    static readonly REMOTE_ALBUM_PATH = 'FromOtherDevices'
    static readonly SNAPSHOT_ALBUM_PATH = 'Screenshots'

    static getFileFetchOpt(albumId: string, deviceId?, startIndex?: number, count?: number) {
        let builder = new FetchOptionBuilder();

        switch (albumId) {
            case AlbumDefine.ALBUM_ID_VIDEO:
                builder
                    .media(MediaLibraryAccess.MEDIA_TYPE_VIDEO.toString())
                    .order(MediaLibraryAccess.FILE_KEY_DATE_TAKEN, false)
                break;
            case AlbumDefine.ALBUM_ID_RECYCLE:
                builder
                    .media(MediaLibraryAccess.MEDIA_TYPE_IMAGE.toString())
                    .logicalOr()
                    .media(MediaLibraryAccess.MEDIA_TYPE_VIDEO.toString())
                    .order(MediaLibraryAccess.FILE_KEY_DATE_TRASHED, false)
                break;
            case AlbumDefine.ALBUM_ID_ALL:
            case AlbumDefine.ALBUM_ID_FAVOR:
            default:
                builder
                    .media(MediaLibraryAccess.MEDIA_TYPE_IMAGE.toString())
                    .logicalOr()
                    .media(MediaLibraryAccess.MEDIA_TYPE_VIDEO.toString())
                    .order(MediaLibraryAccess.FILE_KEY_DATE_TAKEN, false)
                break;
        }

        if (startIndex != undefined && count != undefined && startIndex >= 0 && count >= 0) {
            builder.select(startIndex, count);
        }

        if (deviceId) {
            builder.device(deviceId);
        }

        return builder.build();
    }

    static getFileFetchOptById(fileId: number, deviceId?: string) {
        let builder = new FetchOptionBuilder().fileId(`${fileId}`);

        if (deviceId) {
            builder.device(deviceId);
        }

        return builder.build();
    }

    static getFileFetchOptByName(displayName: string, relativePath?: string) {
        let builder = new FetchOptionBuilder().displayName(displayName);

        if (relativePath) {
            builder.logicalAnd().relativePath(relativePath);
        }

        return builder.build();
    }

    static getAlbumFetchOptByName(name, relativePath) {
        let builder = new FetchOptionBuilder()
            .albumName(name)
            .logicalAnd()
            .relativePath(relativePath);
        ;

        return builder.build();
    }

    static getAlbumFetchOpt(id?, deviceId?) {
        let builder = new FetchOptionBuilder()
            .media(MediaLibraryAccess.MEDIA_TYPE_IMAGE.toString())
            .logicalOr()
            .media(MediaLibraryAccess.MEDIA_TYPE_VIDEO.toString())
            .parentheses();

        if (id) {
            if (id == AlbumDefine.ALBUM_ID_CAMERA) {
                builder
                    .logicalAnd()
                    .relativePath('')
                    .logicalAnd()
                    .albumName(`${MediaLibraryAccess.getInstance().PUBLIC_PATH_CAMERA.substr(0,
                        MediaLibraryAccess.getInstance().PUBLIC_PATH_CAMERA.length - 1)}`)
            } else {
                builder.logicalAnd().albumId(id)
            }
        }

        if (deviceId) {
            builder.device(deviceId);
        }

        return builder.build();
    }

    static genAlbumRelativePath(albumName: string, isOrigin: boolean = false): string {
        if (isOrigin) {
            return MediaLibraryAccess.getInstance().PUBLIC_PATH_CAMERA;
        }
        let path = `${MediaLibraryAccess.getInstance().PUBLIC_PATH_CAMERA}${albumName}/`;
        return path;
    }
}