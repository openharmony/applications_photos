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
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import {
  describe,
  beforeEach,
  afterEach,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { CommonUtil } from '@ohos/common/src/main/ets/default/utils/CommonUtil';
import { Context } from '@ohos.abilityAccessCtrl';
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { PhotoConfig } from '@ohos/common/src/main/ets/default/config/PhotoConfig';

const NUMBER_ONE: number = 1;
export enum Environment {
  ENV_LIBRARY,
  ENV_COMMON
}

export default function CommonUtilTest() {
  describe('CommonUtilTest', () => {

    it('should_return_false_when_bundleName_is_null', 0, () => {
      let bundleName: string = '';
      const result = CommonUtil.isPhotoApp(bundleName);
      expect(result).assertFalse();
    });

    it('should_return_false_when_bundleName_is_not_equal_to_Constants.PHOTO_BUNDLE_NAME', 0, () => {
      let bundleName: string = "someOtherBundleName";
      const result = CommonUtil.isPhotoApp(bundleName);
      expect(result).assertFalse();
    });

    it('should_return_true_when_bundleName_is_equal_to_Constants.PHOTO_BUNDLE_NAME', 0, () => {
      let bundleName: string = Constants.PHOTO_BUNDLE_NAME;
      const result = CommonUtil.isPhotoApp(bundleName);
      expect(result).assertTrue();
    });

    it('should_return_false_when_storage_has_photo_picker_session_key', 0, () => {
      expect(CommonUtil.isContextSupport()).assertTrue();
    });

    it('should_return_true_when_albumUri_is_empty_string', 0, () => {
      let albumUri: string = '';
      const result = CommonUtil.isAllPhotoAlbum(albumUri);
      expect(result).assertTrue();
    });

    it('should_return_true_when_albumUri_is_system_album_uri_for_image', 0, () => {
      let albumUri: string = UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.IMAGE_ALBUM_SUB_TYPE);
      const result = CommonUtil.isAllPhotoAlbum(albumUri);
      expect(result).assertTrue();
    });

    it('should_return_true_when_albumUri_is_system_album_uri_for_video', 0, () => {
      let albumUri: string = UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.VIDEO_ALBUM_SUB_TYPE);
      const result = CommonUtil.isAllPhotoAlbum(albumUri);
      expect(result).assertTrue();
    });

    it('should_return_true_when_albumUri_is_system_album_uri_for_favorite', 0, () => {
      let albumUri: string = UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE);
      const result = CommonUtil.isAllPhotoAlbum(albumUri);
      expect(result).assertTrue();
    });

    it('should_return_true_when_albumUri_is_system_album_uri_for_cloud_enhance', 0, () => {
      let albumUri: string = UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.CLOUD_ENHANCE_ALBUM_SUB_TYPE);
      const result = CommonUtil.isAllPhotoAlbum(albumUri);
      expect(result).assertTrue();
    });

    it('should_return_true_when_albumUri_is_all_duplicate_assets', 0, () => {
      let albumUri: string = Constants.ALL_DUPLICATE_ASSETS;
      const result = CommonUtil.isAllPhotoAlbum(albumUri);
      expect(result).assertTrue();
    });

    it('should_return_false_when_albumUri_is_not_system_album_uri_and_not_all_duplicate_assets', 0, () => {
      let albumUri: string = 'some_random_uri';
      const result = CommonUtil.isAllPhotoAlbum(albumUri);
      expect(result).assertFalse();
    });

    it('should_return_true_when_albumUri_is_system_album_uri_for_image_subType', 0, () => {
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockFunc: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
      when(mockFunc)(ArgumentMatchers.any).afterReturn("imageUri");

      let result = CommonUtil.isSystemAlbum("imageUri");
      expect(result).assertTrue();

      mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
    });

    it('should_return_true_when_albumUri_is_system_album_uri_for_video_subType', 0, () => {
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockFunc: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
      when(mockFunc)(ArgumentMatchers.any).afterReturn("videoUri");

      let result = CommonUtil.isSystemAlbum("videoUri");
      expect(result).assertTrue();

      mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
    });

    it('should_return_true_when_albumUri_is_system_album_uri_for_favorite_subType', 0, () => {
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockFunc: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
      when(mockFunc)(ArgumentMatchers.any).afterReturn("favoriteUri");

      let result = CommonUtil.isSystemAlbum("favoriteUri");
      expect(result).assertTrue();

      mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
    });

    it('should_return_true_when_albumUri_is_system_album_uri_for_cloud_enhance_subType', 0, () => {
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockFunc: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
      when(mockFunc)(ArgumentMatchers.any).afterReturn("cloudUri");

      let result = CommonUtil.isSystemAlbum("cloudUri");
      expect(result).assertTrue();

      mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
    });

    it('should_return_true_when_albumUri_is_system_album_uri_for_trash_subType', 0, () => {
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockFunc: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
      when(mockFunc)(ArgumentMatchers.any).afterReturn("trashUri");

      let result = CommonUtil.isSystemAlbum("trashUri");
      expect(result).assertTrue();

      mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
    });

    it('should_return_true_when_albumUri_is_system_album_uri_for_hidden_subType', 0, () => {
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockFunc: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
      when(mockFunc)(ArgumentMatchers.any).afterReturn("hiddenUri");

      let result = CommonUtil.isSystemAlbum("hiddenUri");
      expect(result).assertTrue();

      mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
    });

    it('should_return_true_when_albumUri_is_system_album_uri_for_camera_subType', 0, () => {
      let mocker: MockKit = new MockKit();
      let userFileManagerAccess: UserFileManagerAccess = UserFileManagerAccess.getInstance();
      let mockFunc: Function = mocker.mockFunc(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
      when(mockFunc)(ArgumentMatchers.any).afterReturn("cameraUri");

      let result = CommonUtil.isSystemAlbum("cameraUri");
      expect(result).assertTrue();

      mocker.ignoreMock(userFileManagerAccess, userFileManagerAccess.getSystemAlbumUri);
    });

    it('should_return_false_when_albumUri_is_not_system_album_uri', 0, () => {
      let result = CommonUtil.isSystemAlbum("regularUri");
      expect(result).assertFalse();
    });

    it('should_return_true_when_albumUri_is_favorite_album_uri', 0, () => {
      let albumUri: string = UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.FAVORITE_ALBUM_SUB_TYPE);
      const result = CommonUtil.isFavoriteAlbum(albumUri);
      expect(result).assertTrue();
    });

    it('should_return_false_when_albumUri_is_not_favorite_album_uri', 0, () => {
      let albumUri: string = 'others';
      const result = CommonUtil.isFavoriteAlbum(albumUri);
      expect(result).assertFalse();
    });

    it('should_return_true_when_albumUri_is_cloud_enhance_album', 0, () => {
      let albumUri: string = UserFileManagerAccess.getInstance()
        .getSystemAlbumUri(UserFileManagerAccess.CLOUD_ENHANCE_ALBUM_SUB_TYPE);
      const result = CommonUtil.isCloudEnhanceAlbum(albumUri);
      expect(result).assertTrue();
    });

    it('should_return_false_when_albumUri_is_not_cloud_enhance_album', 0, () => {
      let albumUri: string = 'others';
      const result = CommonUtil.isCloudEnhanceAlbum(albumUri);
      expect(result).assertFalse();
    });

    it('should_return_true_when_fileName_is_video_file', 0, () => {
      let fileName: string = "test.mp4";
      const result = CommonUtil.isVideoFile(fileName);
      expect(result).assertTrue();
    });

    it('should_return_true_when_fileName_is_video_file_with_capital_extension', 0, () => {
      let fileName: string = "test.MP4";
      const result = CommonUtil.isVideoFile(fileName);
      expect(result).assertTrue();
    });

    it('should_return_true_when_fileName_is_video_file_with_lowercase_extension', 0, () => {
      let fileName: string = "test.mp4";
      const result = CommonUtil.isVideoFile(fileName);
      expect(result).assertTrue();
    });

    it('should_return_false_when_fileName_is_not_video_file', 0, () => {
      let fileName: string = "test.txt";
      const result = CommonUtil.isVideoFile(fileName);
      expect(result).assertFalse();
    });

    it('should_return_false_when_fileName_is_video_file_with_unknown_extension', 0, () => {
      let fileName: string = "test.unknown";
      const result = CommonUtil.isVideoFile(fileName);
      expect(result).assertFalse();
    });

    it('should_return_incremented_uuid_when_uuid_is_called_multiple_times', 0, () => {
      let result1 = CommonUtil.uuid;
      let result2 = CommonUtil.uuid;
      expect(result1).assertEqual(1);
      expect(result2).assertEqual(2);
    });

    it('should_return_uuid_greater_than_zero', 0, () => {
      let result = CommonUtil.uuid;
      expect(result).assertLarger(0);
    });

    it('should_return_uuid_equals_to_one_when_uuidInner_is_zero', 0, () => {
      Reflect.set(CommonUtil, 'uuidInner', 0)
      let result = CommonUtil.uuid;
      expect(result).assertEqual(1);
    });

    it('should_return_uuid_equals_to_uuidInner_plus_one_when_uuidInner_is_greater_than_zero', 0, () => {
      Reflect.set(CommonUtil, 'uuidInner', 5)
      let result = CommonUtil.uuid;
      expect(result).assertEqual(6);
    });

    it('should_set_hdr_picture_switch_to_true_when_context_is_null', 0, () => {
      CommonUtil.queryHdrSwitchStatus();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_set_prog_disp_switch_to_true_when_context_is_null', 0, () => {
      CommonUtil.queryProgDispSwitchStatus();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_register_hdr_switch_observer_with_context', 0, () => {
      let mockContext: Context = {} as Context;
      CommonUtil.registerHdrSwitchObserver(mockContext);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_register_prog_disp_switch_observer_with_context', 0, () => {
      let mockContext: Context = {} as Context;
      CommonUtil.registerProgDispSwitchObserver(mockContext);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_register_hdr_switch_observer_without_context', 0, () => {
      CommonUtil.registerHdrSwitchObserver();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_register_prog_disp_switch_observer_without_context', 0, () => {
      CommonUtil.registerProgDispSwitchObserver();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_log_error_when_context_is_null', 0, () => {
      CommonUtil.unregisterHdrSwitchObserver();
      CommonUtil.unregisterProgDispSwitchObserver();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_unregister_observer_when_context_is_provided', 0, () => {
      let mockContext: Context = {} as Context;
      CommonUtil.unregisterHdrSwitchObserver(mockContext);
      CommonUtil.unregisterProgDispSwitchObserver(mockContext);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_unregister_observer_when_context_is_not_provided_and_photoConfig_is_library', 0, () => {
      PhotoConfig.environment = Environment.ENV_LIBRARY;
      CommonUtil.unregisterHdrSwitchObserver();
      CommonUtil.unregisterProgDispSwitchObserver();
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('should_unregister_observer_when_context_is_not_provided_and_photoConfig_is_not_library', 0, () => {
      PhotoConfig.environment = Environment.ENV_COMMON;
      CommonUtil.unregisterHdrSwitchObserver();
      CommonUtil.unregisterProgDispSwitchObserver();
      expect(NUMBER_ONE).assertEqual(1);
    });
  });
}
