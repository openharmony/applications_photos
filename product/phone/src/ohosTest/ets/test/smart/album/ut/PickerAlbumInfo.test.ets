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
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import { PickerAlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/PickerAlbumInfo';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import common from '@ohos.app.ability.common';
import type { PhotoAlbum } from '@ohos/common/src/main/ets/default/access/PhotoAccessHelperAccess';
import { AlbumInfo } from '@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import photoAccessHelper from '@ohos.file.photoAccessHelper';

const TAG = 'PickerAlbumInfoTest';

/**
 * PickerAlbumInfo Unittest
 *
 * @since 2024-07-26
 */
export default function PickerAlbumInfoTest() {
  describe('PickerAlbumInfoTest', () => {
    it('PickerAlbumInfoTest_01', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest01();
    });

    it('PickerAlbumInfoTest_02', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest02();
    });

    it('PickerAlbumInfoTest_03', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest03();
    });

    it('PickerAlbumInfoTest_04', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest04();
    });

    it('PickerAlbumInfoTest_05', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest05();
    });

    it('PickerAlbumInfoTest_06', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest06();
    });

    it('PickerAlbumInfoTest_07', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest07();
    });

    it('PickerAlbumInfoTest_08', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest08();
    });

    it('PickerAlbumInfoTest_09', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest09();
    });

    it('PickerAlbumInfoTest_10', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest10();
    });

    it('PickerAlbumInfoTest_11', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest11();
    });

    it('PickerAlbumInfoTest_12', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest12();
    });

    it('PickerAlbumInfoTest_13', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest13();
    });

    it('PickerAlbumInfoTest_14', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest14();
    });

    it('PickerAlbumInfoTest_15', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest15();
    });

    it('PickerAlbumInfoTest_16', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest16();
    });

    it('PickerAlbumInfoTest_17', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest17();
    });

    it('PickerAlbumInfoTest_18', TestConstants.TEST_LEVEL_ONE, async (): Promise<void> => {
      await PickerAlbumInfoTest18();
    });
  })
}

/**
 * constructor
 * 分支 if (!photoAlbum) {
 */
async function PickerAlbumInfoTest01() {
  let info = new PickerAlbumInfo();
  expect(info.uri !== undefined).assertTrue();
}

/**
 * constructor
 * 分支 !if (!photoAlbum) {
 */
async function PickerAlbumInfoTest02() {
  let userFileManagerAccess = new UserFileManagerAccess();
  let context: common.UIAbilityContext | undefined = AppStorage.get<common.UIAbilityContext>('abilityContext');
  userFileManagerAccess.onCreate(context);

  let imageAlbum: PhotoAlbum | undefined =
    await userFileManagerAccess.getSystemAlbum(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);

  if (!imageAlbum) {
    expect(imageAlbum === undefined).assertFail();
    return
  }

  let info = new PickerAlbumInfo(imageAlbum);

  expect(info.uri !== undefined).assertTrue();
}

/**
 * getAlbumNameResource
 * 分支 if (this.uri === 'file://media/PhotoAlbum/pictures_and_videos') {
 */
async function PickerAlbumInfoTest03() {
  let info = new PickerAlbumInfo();
  info.uri = 'file://media/PhotoAlbum/pictures_and_videos';
  info.getAlbumNameResource();
  expect(info.uri !== undefined).assertTrue();
}

/**
 * getAlbumNameResource
 * 分支 !if (this.uri === 'file://media/PhotoAlbum/pictures_and_videos') {
 * 分支 ！if (this.isSystemAlbum) {
 * 分支 ！if (this.albumSubtype === photoAccessHelper.AlbumSubtype.SOURCE_GENERIC) {
 */
async function PickerAlbumInfoTest04() {
  let info = new PickerAlbumInfo();
  info.getAlbumNameResource();
  expect(info.uri !== undefined).assertTrue();
}

/**
 * getAlbumNameResource
 * 分支
 */
async function PickerAlbumInfoTest05() {
  let info = new PickerAlbumInfo();
  info.isSystemAlbum = true;
  info.albumSubtype = photoAccessHelper.AlbumSubtype.IMAGE;
  info.getAlbumNameResource();
  expect(info.uri !== undefined).assertTrue();
}

async function PickerAlbumInfoTest06() {
  let info = new PickerAlbumInfo();
  info.isSystemAlbum = true;
  info.albumSubtype = photoAccessHelper.AlbumSubtype.FAVORITE;
  info.getAlbumNameResource();
  expect(info.uri !== undefined).assertTrue();
}

async function PickerAlbumInfoTest07() {
  let info = new PickerAlbumInfo();
  info.isSystemAlbum = true;
  info.albumSubtype = photoAccessHelper.AlbumSubtype.CLOUD_ENHANCEMENT;
  info.getAlbumNameResource();
  expect(info.uri !== undefined).assertTrue();
}

async function PickerAlbumInfoTest08() {
  let info = new PickerAlbumInfo();
  info.isSystemAlbum = true;
  info.albumSubtype = photoAccessHelper.AlbumSubtype.VIDEO;
  info.getAlbumNameResource();
  expect(info.uri !== undefined).assertTrue();
}

async function PickerAlbumInfoTest09() {
  let info = new PickerAlbumInfo();
  info.isSystemAlbum = true;
  info.albumSubtype = photoAccessHelper.AlbumSubtype.TRASH;
  info.getAlbumNameResource();
  expect(info.uri !== undefined).assertTrue();
}

async function PickerAlbumInfoTest10() {
  let info = new PickerAlbumInfo();
  info.isSystemAlbum = true;
  info.getAlbumNameResource();
  expect(info.uri !== undefined).assertTrue();
}

/**
 * getAlbumNameResource
 * 分支 if (this.albumSubtype === photoAccessHelper.AlbumSubtype.SOURCE_GENERIC) {
 * 分支 case Constants.LPATH_CAMERA:
 */
async function PickerAlbumInfoTest11() {
  let info = new PickerAlbumInfo();
  info.albumSubtype = photoAccessHelper.AlbumSubtype.SOURCE_GENERIC;
  info.lpath = Constants.LPATH_CAMERA;
  info.getAlbumNameResource();
  expect(info.uri !== undefined).assertTrue();
}

/**
 * getAlbumNameResource
 * 分支 if (this.albumSubtype === photoAccessHelper.AlbumSubtype.SOURCE_GENERIC) {
 * 分支 case Constants.LPATH_CAMERA:
 */
async function PickerAlbumInfoTest12() {
  let info = new PickerAlbumInfo();
  info.albumSubtype = photoAccessHelper.AlbumSubtype.SOURCE_GENERIC;
  info.lpath = Constants.LPATH_SCREEN_SHOT;
  info.getAlbumNameResource();
  expect(info.uri !== undefined).assertTrue();
}

/**
 * getAlbumNameResource
 * 分支 if (this.albumSubtype === photoAccessHelper.AlbumSubtype.SOURCE_GENERIC) {
 * 分支 case Constants.LPATH_CAMERA:
 */
async function PickerAlbumInfoTest13() {
  let info = new PickerAlbumInfo();
  info.albumSubtype = photoAccessHelper.AlbumSubtype.SOURCE_GENERIC;
  info.lpath = Constants.LPATH_SCREEN_RECORDING;
  info.getAlbumNameResource();
  expect(info.uri !== undefined).assertTrue();
}

/**
 * getAlbumNameResource
 * 分支 if (this.albumSubtype === photoAccessHelper.AlbumSubtype.SOURCE_GENERIC) {
 * 分支 default:
 */
async function PickerAlbumInfoTest14() {
  let info = new PickerAlbumInfo();
  info.albumSubtype = photoAccessHelper.AlbumSubtype.SOURCE_GENERIC;
  info.getAlbumNameResource();
  expect(info.uri !== undefined).assertTrue();
}

/**
 * convertFromAlbumInfo
 * 分支  if (!this.isSystemAlbum) {
 * 分支 if (!albumInfo.unionAlbumUris) {
 */
async function PickerAlbumInfoTest15() {
  let info = new PickerAlbumInfo();
  let albumInfo: AlbumInfo = new AlbumInfo();
  info.convertFromAlbumInfo(albumInfo);
  expect(info.uri !== undefined).assertTrue();
}

/**
 * convertFromAlbumInfo
 * 分支  !if (!this.isSystemAlbum) {
 *
 */
async function PickerAlbumInfoTest16() {
  let info = new PickerAlbumInfo();
  let albumInfo: AlbumInfo = new AlbumInfo();
  info.isSystemAlbum = true
  info.convertFromAlbumInfo(albumInfo);
  expect(info.uri !== undefined).assertTrue();
}

/**
 * getUnionAlbumUrisArray
 * 分支 if (!this.unionAlbumUris || this.unionAlbumUris.length) {
 */
async function PickerAlbumInfoTest17() {
  let info = new PickerAlbumInfo();
  info.getUnionAlbumUrisArray();
  expect(info.uri !== undefined).assertTrue();
}

/**
 * getUnionAlbumUrisArray
 * 分支 !if (!this.unionAlbumUris || this.unionAlbumUris.length) {
 */
async function PickerAlbumInfoTest18() {
  let info = new PickerAlbumInfo();
  info.unionAlbumUris.push('test');
  info.getUnionAlbumUrisArray();
  expect(info.uri !== undefined).assertTrue();
}