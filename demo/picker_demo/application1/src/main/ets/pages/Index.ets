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
import lazy { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Button('AlbumPickerComponentPage')
        .onClick(() => {
          router.pushUrl({ url: 'pages/AlbumPickerComponentPage' })
        })
      Button('AlbumPickerComponentPage')
        .onClick(() => {
          router.pushUrl({ url: 'pages/PhotoPickerComponentPage' })
        })
      Button('BindSheetPicker')
        .onClick(() => {
          router.pushUrl({ url: 'pages/BindSheetPicker' })
        })
      Button('HalfModalPage')
        .onClick(() => {
          router.pushUrl({ url: 'pages/HalfModalPage' })
        })
      Button('PhotoComponentPage').onClick(() => {
        router.pushUrl({ url: 'pages/PhotoComponentPage' })
      }).margin({ top: 30, bottom: 30 })
      Button('GrantPickerPage').onClick(() => {
        router.pushUrl({ url: 'pages/GrantPickerPage' })
      }).margin({ top: 30, bottom: 30 })
      Button('BindSheetPickerPage').onClick(() => {
        router.pushUrl({ url: 'pages/BindSheetPickerPage' })
      })
      Button('CameraPage')
        .onClick(() => {
          router.pushUrl({ url: 'pages/CameraPage' })
        })
      Button('AlbumPage')
        .onClick(() => {
          router.pushUrl({ url: 'pages/AlbumPage' })
        })
      Button('AssetCreationDialogPage')
        .onClick(() => {
          router.pushUrl({ url: 'pages/AssetCreationDialogPage' })
        })
      Button('ImageFileSelectorPage')
        .onClick(() => {
          router.pushUrl({ url: 'pages/ImageFileSelectorPage' })
        })
      Button('RecentPhotoComponentPage')
        .onClick(() => {
          router.pushUrl({ url: 'pages/RecentPhotoComponentPage' })
        })
      Button('SaveCompressPhotoPage')
        .onClick(() => {
          router.pushUrl({ url: 'pages/SaveCompressPhotoPage' })
        })
    }
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.SpaceAround)
  }
}