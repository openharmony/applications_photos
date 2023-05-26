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
import image from '@ohos.multimedia.image';
import MediaLib from '@ohos.multimedia.mediaLibrary';
import mediaModel from '../model/MediaModel';
import { Log } from '../utils/Log';
import { MediaConstants } from '../constants/MediaConstants';
import { getResourceString } from '../utils/ResourceUtils';
import { SimpleAlbumDataItem } from '../data/SimpleAlbumDataItem';

const TAG = "MediaDataHelper"

export class Rotatable {
    rotatable: boolean
    orientation: number
}

export async function setOrientation(fileAsset: MediaLib.FileAsset, orientation: number): Promise<void> {
    Log.info(TAG, `setOrientation`)
    try {
        let fd: number = await mediaModel.openAsset('RW', fileAsset);
        let imageSourceApi: image.ImageSource = image.createImageSource(fd);
        await imageSourceApi.modifyImageProperty("Orientation", getPropertyValidOrientation(orientation));
        imageSourceApi.release();
        mediaModel.closeAsset(fd, fileAsset);
    } catch (err) {
        Log.error(TAG, `setOrientation err ${JSON.stringify(err)}`);
        fileAsset.orientation = orientation;
        await fileAsset.commitModify();
    }
}

function getPropertyValidOrientation(orientation: number): string {
    Log.info(TAG, `getPropertyValidOrientation ${orientation}`);
    switch (orientation) {
        case MediaConstants.ROTATE_NONE:
            return "1";
        case MediaConstants.ROTATE_THIRD:
            return "8";
        case MediaConstants.ROTATE_TWICE:
            return "3";
        case MediaConstants.ROTATE_ONCE:
            return "6";
        default:
            return "";
    }
}

export async function getAlbumDisplayName(name: string): Promise<string> {
    switch (name) {
        case MediaConstants.ALBUM_ID_ALL:
            return await getResourceString($r('app.string.album_all'));
        case MediaConstants.ALBUM_ID_VIDEO:
            return await getResourceString($r('app.string.album_video'));
        case MediaConstants.ALBUM_ID_RECYCLE:
            return await getResourceString($r('app.string.album_recycle'));
        case MediaConstants.ALBUM_ID_CAMERA:
            return await getResourceString($r('app.string.album_camera'));
        case MediaConstants.ALBUM_ID_FAVOR:
            return await getResourceString($r('app.string.album_favor'));
        case MediaConstants.ALBUM_ID_REMOTE:
            return await getResourceString($r('app.string.album_remote_device'));
        case MediaConstants.ALBUM_ID_SNAPSHOT:
            return await getResourceString($r('app.string.album_screen_shot'));
        default:
            break;
    }
    return null;
}

export async function getFetchOptions(selectType: number, albumId: string, deviceId: string): Promise<MediaLib.MediaFetchOptions> {
    let selections: string = "";
    let selectionArgs: Array<string> = [];
    let order: string = `date_added DESC`;
    if (selectType == MediaConstants.SELECT_TYPE_VIDEO || albumId == MediaConstants.ALBUM_ID_VIDEO) {
        selections = MediaLib.FileKey.MEDIA_TYPE + ' = ?';
        selectionArgs = [MediaLib.MediaType.VIDEO.toString()];
    } else if (selectType == MediaConstants.SELECT_TYPE_IMAGE && albumId != MediaConstants.ALBUM_ID_VIDEO) {
        selections = MediaLib.FileKey.MEDIA_TYPE + ' = ?';
        selectionArgs = [MediaLib.MediaType.IMAGE.toString()];
    } else if (selectType == MediaConstants.SELECT_TYPE_IMAGE && albumId == MediaConstants.ALBUM_ID_VIDEO) {
        return undefined;
    } else {
        selections = MediaLib.FileKey.MEDIA_TYPE + ' = ? or ' + MediaLib.FileKey.MEDIA_TYPE + ' = ?';
        selectionArgs = [MediaLib.MediaType.IMAGE.toString(), MediaLib.MediaType.VIDEO.toString()];
    }
    if (albumId == MediaConstants.ALBUM_ID_CAMERA) {
        let path = await mediaModel.getPublicDirectory(MediaLib.DirectoryType.DIR_CAMERA);
        selections = `(${selections}) and ${MediaLib.FileKey.ALBUM_NAME} = ?`;
        selectionArgs.push(path.substr(0, path.length - 1));
    } else if (albumId == MediaConstants.ALBUM_ID_SNAPSHOT) {
        let path = await mediaModel.getPublicDirectory(MediaLib.DirectoryType.DIR_IMAGE) + "Screenshots/";
        selections = `(${selections}) and ${MediaLib.FileKey.RELATIVE_PATH} = ?`;
        selectionArgs.push(path);
    } else if ((new Number(albumId).valueOf() || 0) > 0) {
        selections = `(${selections}) and ${MediaLib.FileKey.ALBUM_ID} = ?`;
        selectionArgs.push(albumId);
    }

    let fetchOption: MediaLib.MediaFetchOptions = {
        selections: selections,
        selectionArgs: selectionArgs,
        order: order
    };

    if (deviceId.length > 0) {
        fetchOption['networkId'] = deviceId;
    }
    return fetchOption;
}

export async function getFetchOptionsByAlbumItem(item: SimpleAlbumDataItem): Promise<MediaLib.MediaFetchOptions> {
    let selections: string = ``;
    let selectionArgs: string[] = [];

    if (item.displayName.length > 0) {
        selections = `${MediaLib.FileKey.ALBUM_NAME}` + '= ?';
        selectionArgs.push(item.displayName);
    }

    let fetchOption: MediaLib.MediaFetchOptions = {
        selections: selections,
        selectionArgs: selectionArgs,
        order: `date_added DESC`
    };
    return fetchOption;
}

export async function getFetchOptionsByItem(item: SimpleAlbumDataItem): Promise<MediaLib.MediaFetchOptions> {
    let selections: string = `${MediaLib.FileKey.MEDIA_TYPE} = ? or ${MediaLib.FileKey.MEDIA_TYPE} = ?`;
    let selectionArgs: string[] = [MediaLib.MediaType.IMAGE.toString(), MediaLib.MediaType.VIDEO.toString()];

    if (item.displayName.length > 0) {
        selections = `(${selections}) and ${MediaLib.FileKey.DISPLAY_NAME} = ?`;
        selectionArgs.push(item.displayName);
    }

    if (item.relativePath.length > 0) {
        selections = `(${selections}) and ${MediaLib.FileKey.RELATIVE_PATH} = ?`;
        selectionArgs.push(item.relativePath);
    }

    let fetchOption: MediaLib.MediaFetchOptions = {
        selections: selections,
        selectionArgs: selectionArgs,
        order: `date_added DESC`
    };
    return fetchOption;
}
