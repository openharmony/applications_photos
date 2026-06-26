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

import lazy { Log } from './Log';
import lazy { AlbumInfo } from '../model/browser/album/AlbumInfo';
import type { PhotoAlbum } from '../access/PhotoAccessHelperAccess';
import lazy {
  FileAssetEx,
  FetchOptions,
  UserFileManagerAccess,
  AlbumCountAndPhotoAsset
} from '../access/UserFileManagerAccess';
import type { PhotoAsset } from '../access/PhotoAccessHelperAccess';
import lazy { ImageUtil } from './ImageUtil';
import lazy { AlbumDefine } from '../model/browser/AlbumDefine';
import lazy { Constants, } from '../model/common/Constants';
import type { QueryParam } from '../../default/interface/BrowserDataInterface';
import lazy { MediaItem } from '../model/browser/photo/MediaItem';
import lazy photoAccessHelper from '@ohos.file.photoAccessHelper';


const TAG: string = 'common_UnionAlbumsUtil';

/**
 * 将融合相册转换为AlbumInfo
 * @param unionAlbums
 * @param filterMediaType
 * @param userFileManagerAccess
 * @returns
 */
export async function buildUnionAlbumInfo(unionAlbums: PhotoAlbum[], filterMediaType?: string,
  userFileManagerAccess?: UserFileManagerAccess): Promise<AlbumInfo> {
  const unionAlbumInfo: AlbumInfo = new AlbumInfo(unionAlbums[0]);
  unionAlbumInfo.setAlbumName(unionAlbums[0].albumName)

  // 处理count, videoCount, cover
  const count: number = unionAlbums.reduce((count: number, album: PhotoAlbum): number => count + album.count, 0);
  const videoCount: number = unionAlbums.reduce((count: number, album: PhotoAlbum):
    number => count + (album.videoCount ?? 0), 0);
  // picker存在仅需要图片或者视频的场景
  if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_IMAGE) {
    unionAlbumInfo.setCount(count - videoCount);
  } else if (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO) {
    unionAlbumInfo.setCount(videoCount);
  } else {
    unionAlbumInfo.setCount(count);
  }

  unionAlbumInfo.setVideoCount(videoCount);
  unionAlbumInfo.setFilterMediaType(filterMediaType ?? '');
  await setAlbumCoverFromUnionAlbums(unionAlbums, unionAlbumInfo, filterMediaType, userFileManagerAccess);

  unionAlbumInfo.setAlbumCount(unionAlbums.length);
  const unionAlbumUris: string[] = unionAlbums.map((album: PhotoAlbum): string => album.albumUri);
  unionAlbumInfo.setUnionAlbumUris(unionAlbumUris);

  return unionAlbumInfo;
}

/**
 * picker需要根据过滤条件构建融合相册
 * @param unionAlbums
 * @param param
 * @param userFileManagerAccess
 * @returns
 */
export async function buildUnionAlbumInfoWithFilter(unionAlbums: PhotoAlbum[],
  userFileManagerAccess: UserFileManagerAccess, param?: QueryParam):
  Promise<AlbumInfo> {

  const unionAlbumInfo: AlbumInfo = new AlbumInfo(unionAlbums[0]);
  unionAlbumInfo.setAlbumName(unionAlbums[0].albumName)

  // 处理count, videoCount, cover，特别是 filterMediaType 存在的情况
  let count = 0;
  let coverUris: string[] = [];
  let photoAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
  // 根据过滤条件筛选相册里面的图片/视频资产
  for (let unionAlbum of unionAlbums) {
    let albumCountAndPhotoAsset: AlbumCountAndPhotoAsset =
      await userFileManagerAccess.getAlbumAssetCountAndPhotoAsset(unionAlbum, param);
    let tmpCount = albumCountAndPhotoAsset.getCount();
    count += tmpCount;
    let photoAssets = albumCountAndPhotoAsset.getAsset();
    coverUris.push(photoAssets?.uri ?? '');
  }
  photoAsset = await userFileManagerAccess.getPhotoAssetByUri(coverUris[0]);
  unionAlbumInfo.setCount(count);
  unionAlbumInfo.setFilterMediaType(param?.filterMediaType ?? '');
  unionAlbumInfo.setSubtype(param?.filterConditions?.mediaType ?? 0);
  if (photoAsset) {
    setAlbumCover(unionAlbumInfo, photoAsset);
  }

  unionAlbumInfo.setAlbumCount(unionAlbums.length);
  const unionAlbumUris: string[] = unionAlbums.map((album: PhotoAlbum): string => album.albumUri);
  unionAlbumInfo.setUnionAlbumUris(unionAlbumUris);

  return unionAlbumInfo;
}


/**
 * 从融合相册信息集合中设置封面
 * @param unionAlbums
 * @param unionAlbumInfo
 * @param filterMediaType
 * @param userFileManagerAccess
 * @returns
 */
async function setAlbumCoverFromUnionAlbums(unionAlbums: PhotoAlbum[], unionAlbumInfo: AlbumInfo,
  filterMediaType?: string, userFileManagerAccess?: UserFileManagerAccess): Promise<void> {
  if (!unionAlbums || unionAlbums.length == 0) {
    Log.error(TAG, 'setAlbumCoverFromUnionAlbums: albums is undefined or empty!');
    return;
  }
  if (!unionAlbumInfo) {
    Log.error(TAG, 'setAlbumCoverFromUnionAlbums: unionAlbumInfo is undefined!');
    return;
  }
  // 空相册无需设置封面
  if (hasNoSpecifiedContent(unionAlbumInfo, filterMediaType)) {
    Log.info(TAG, 'setAlbumCoverFromUnionAlbums: unionAlbumInfo does not have specified content, fast return!');
    return;
  }

  const startIndex: number = 0;
  const count: number = 1;
  const needThumbnailReady: boolean = false;
  const orderProp: string = UserFileManagerAccess.FILE_KEY_DATE_TAKEN_MS;
  let startTime: number = Date.now();

  // 获取 unionAlbums 的 Cover中filterMediaType类型的第一个
  let fetchOpt: FetchOptions =
    AlbumDefine.getFileFetchOptAsync(startIndex, count, filterMediaType, needThumbnailReady, orderProp);
  let coverUris: string[] = unionAlbums.map((album: PhotoAlbum): string => album.coverUri);
  AlbumDefine.modifyPredicatesInPhotoUris(fetchOpt.predicates, coverUris);
  let firstCover: FileAssetEx;
  if (userFileManagerAccess) {
    firstCover = await userFileManagerAccess.getFirstObject(fetchOpt, TAG);
  } else {
    firstCover = await UserFileManagerAccess.getInstance().getFirstObject(fetchOpt, TAG);
  }
  if (firstCover.obj) {
    setAlbumCover(unionAlbumInfo, firstCover.obj);
    Log.info(TAG, `setAlbumCoverFromUnionAlbums from all covers finished, cost time: ${Date.now() - startTime}}`);
    return;
  }

  //  unionAlbums 的 Cover 均不可用，获取 albums 中所有文件中filterMediaType的第一个
  const albumUris: string[] = unionAlbums.map((album: PhotoAlbum): string => album.albumUri);
  let allItemsFetchOpt: FetchOptions =
    AlbumDefine.getFileFetchOptAsync(startIndex, count, filterMediaType, needThumbnailReady, orderProp);
  AlbumDefine.modifyPredicatesInAlbumUris(allItemsFetchOpt.predicates, albumUris);
  let firstItem: FileAssetEx;
  if (userFileManagerAccess) {
    firstItem = await userFileManagerAccess.getFirstObject(allItemsFetchOpt, TAG);
  } else {
    firstItem = await UserFileManagerAccess.getInstance().getFirstObject(allItemsFetchOpt, TAG);
  }
  if (firstItem.obj) {
    setAlbumCover(unionAlbumInfo, firstItem.obj);
    Log.info(TAG, `setAlbumCoverFromUnionAlbums from all items finished, cost time: ${Date.now() - startTime}}`);
  } else {
    Log.error(TAG, `setAlbumCoverFromUnionAlbums from all items failed, cost time: ${Date.now() - startTime}}`);
  }
}

function hasNoSpecifiedContent(albumInfo: AlbumInfo, filterMediaType?: string): boolean {
  return (filterMediaType === AlbumDefine.FILTER_MEDIA_TYPE_VIDEO && albumInfo.videoCount === 0) ||
    albumInfo.count === 0;
}

function setAlbumCover(albumInfo: AlbumInfo, data: PhotoAsset): void {
  if (!albumInfo || !data) {
    return;
  }
  // let mediaItem: MediaItem = new MediaItem(data);
  // mediaItem.setThumbnail(ImageUtil.getThumbnailAstcUri(data.uri, String(data.get(Constants.KEY_FILE_DATA)),
  //   mediaItem.getDateModified()));
  // albumInfo.setMediaItem(mediaItem);
  // albumInfo.setCoverOrientation(mediaItem.orientation);
  // albumInfo.setCoverUri(ImageUtil.getThumbnailAstcUri(data.uri, String(data.get(Constants.KEY_FILE_DATA)),
  //   mediaItem.getDateModified()));
  // albumInfo.setCoverPhotoUri(data.uri);
}



