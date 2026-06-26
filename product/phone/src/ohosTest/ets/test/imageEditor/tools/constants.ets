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

export enum PhotoType {
  RefineImage = 'RefineImage',
  XTStyleEdit = 'XTStyleEdit',
  AIRemove = 'AIRemove',
  ApertureImage = 'ApertureImage',
  DynamicImage = 'DynamicImage',
  Watermark = 'Watermark',
  AIReplace = 'ReplaceEmo',
  StaticImage = 'StaticImage',
}

type PhotoMapItem = [PhotoType, string];
const getId = (index: number) => `photoGridView_gird_${index}`;

// 后续有新增的无须拍摄的照片，在此处依序增加
const PHOTO_MAP_DATA: Array<PhotoMapItem> = [
// setup脚本预制照片
  PhotoType.RefineImage,
  PhotoType.AIRemove,
  PhotoType.ApertureImage,
  PhotoType.AIReplace,
].map((key, index) => [key, getId(index)]);

const TAKE_PHOTOS: Array<PhotoMapItem> = [
// setup脚本拍摄照片
  PhotoType.DynamicImage,
  PhotoType.StaticImage,
].map((key, index) => [key, getId(index)]);

export type EditorTestType = PhotoType | 'default';

// 组内相册名称
export const EditorAlbum = '图片编辑组';

export const EditorPhoto = '图片';

// 组内相册名称
export const ReplaceAlbum = '最佳表情';

export const TakePhotos = '拍照预制';

export const PhotoMap = new Map([...PHOTO_MAP_DATA, ...TAKE_PHOTOS]);

export const trustListMap = new Map([
  [PhotoType.ApertureImage, ['LMR']],
  [PhotoType.XTStyleEdit, ['LMR']],
]);