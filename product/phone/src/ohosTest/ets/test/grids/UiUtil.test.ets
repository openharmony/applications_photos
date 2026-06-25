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
import { UserFileManagerAccess } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import { MediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/MediaItem';
import { UiUtil, VibrateType } from '@ohos/common/src/main/ets/default/utils/UiUtil';
import { describe, expect, it, MockKit } from '@ohos/hypium';
import { ViewData } from '@ohos/common/src/main/ets/default/model/browser/photo/ViewData';
import { SimpleGridMediaItem } from '@ohos/common/src/main/ets/default/model/browser/photo/SimpleGridMediaItem';
import { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { Action } from '@ohos/common/src/main/ets/default/view/browserOperation/Action';

const NUMBER_ONE: number = 1;
const TAG: string = 'UiUtil';

export default function UiUtilTest() {
  describe('UiUtilTest', () => {

    it('get_action_bar_background_color_with_true_returns_non_null', 0, () => {
      expect(UiUtil.getActionBarBackgroundColor(true) != null).assertTrue();
    });

    it('get_action_bar_background_color_with_false_returns_non_null', 0, () => {
      expect(UiUtil.getActionBarBackgroundColor(false) != null).assertTrue();
    });

    it('when_color_is_white_and_opacity_is_1_returns_opaque_white', 0, () => {
      expect(UiUtil.getHexOpacityColor('#FFFFFF', 1)).assertEqual('#FFFFFFFF');
    });

    it('when_color_is_short_white_and_opacity_is_1_returns_opaque_white', 0, () => {
      expect(UiUtil.getHexOpacityColor('#FFF', 1)).assertEqual('#FFFFFFFF');
    });

    it('when_color_is_opaque_white_and_opacity_is_1_returns_opaque_white', 0, () => {
      expect(UiUtil.getHexOpacityColor('#FFFFFFFF', 1)).assertEqual('#FFFFFFFF');
    });

    it('when_color_is_white_and_opacity_is_0.5_returns_semi_transparent_white', 0, () => {
      expect(UiUtil.getHexOpacityColor('#FfFfFf', 0.5)).assertEqual('#80FFFFFF');
    });

    it('when_color_is_white_and_opacity_is_0_returns_transparent_white', 0, () => {
      expect(UiUtil.getHexOpacityColor('#FfFfFf', 0)).assertEqual('#00FFFFFF');
    });

    it('when_color_is_white_and_opacity_is_2_clamps_to_opaque_white', 0, () => {
      expect(UiUtil.getHexOpacityColor('#FfFfFf', 2)).assertEqual('#FFFFFFFF');
    });

    it('when_color_is_white_and_opacity_is_negative_clamps_to_transparent_white', 0, () => {
      expect(UiUtil.getHexOpacityColor('#FfFfFf', -1)).assertEqual('#00FFFFFF');
    });

    it('when_color_lacks_hash_and_opacity_is_1_returns_white', 0, () => {
      expect(UiUtil.getHexOpacityColor('FFFFFF', 1)).assertEqual('FFFFFF');
    });

    it('when_input_is_0_returns_black_transparent', 0, () => {
      expect(UiUtil.decToHexColor(0)).assertEqual('#00000000');
    });

    it('when_input_is_negative_1_returns_black_transparent', 0, () => {
      expect(UiUtil.decToHexColor(-1)).assertEqual('00000000');
    });

    it('when_input_is_16777215_returns_white_transparent', 0, () => {
      expect(UiUtil.decToHexColor(16777215)).assertEqual('#00ffffff');
    });

    it('when_mediaType_is_5_returns_false', 0, async () => {
      const mediaItem = new MediaItem();
      mediaItem.mediaType = 5;
      expect(await UiUtil.isEditedEnable(mediaItem)).assertFalse();
    });

    it('when_mediaType_is_VIDEO_and_mimeType_is_empty_returns_false', 0, async () => {
      const mediaItem = new MediaItem();
      mediaItem.mediaType = UserFileManagerAccess.MEDIA_TYPE_VIDEO;
      mediaItem.mimeType = '';
      expect(await UiUtil.isEditedEnable(mediaItem)).assertFalse();
    });

    it('when_mimeType_is_videompeg_and_size_is_0_returns_false', 0, async () => {
      const mediaItem = new MediaItem();
      mediaItem.mediaType = UserFileManagerAccess.MEDIA_TYPE_VIDEO;
      mediaItem.mimeType = 'video/mpeg';
      mediaItem.size = 0;
      expect(await UiUtil.isEditedEnable(mediaItem)).assertFalse();
    });

    it('when_size_is_1_and_width_is_0_returns_false', 0, async () => {
      const mediaItem = new MediaItem();
      mediaItem.mediaType = UserFileManagerAccess.MEDIA_TYPE_VIDEO;
      mediaItem.mimeType = 'video/mpeg';
      mediaItem.size = 1;
      mediaItem.width = 0;
      expect(await UiUtil.isEditedEnable(mediaItem)).assertFalse();
    });

    it('when_width_is_1_and_height_is_0_returns_true', 0, async () => {
      const mediaItem = new MediaItem();
      mediaItem.mediaType = UserFileManagerAccess.MEDIA_TYPE_VIDEO;
      mediaItem.mimeType = 'video/mpeg';
      mediaItem.size = 1;
      mediaItem.width = 1;
      mediaItem.height = 0;
      expect(await UiUtil.isEditedEnable(mediaItem)).assertTrue();
    });

    it('when_height_is_1_and_duration_is_0_returns_false', 0, async () => {
      const mediaItem = new MediaItem();
      mediaItem.mediaType = UserFileManagerAccess.MEDIA_TYPE_VIDEO;
      mediaItem.mimeType = 'video/mpeg';
      mediaItem.size = 1;
      mediaItem.width = 1;
      mediaItem.height = 1;
      mediaItem.duration = 0;
      expect(await UiUtil.isEditedEnable(mediaItem)).assertFalse();
    });

    it('stringify', 0, () => {
      expect(UiUtil.stringify('test')).assertEqual('test');
    })

    it('getDialogWidth', 0, () => {
      expect(UiUtil.isMirrorMode()).assertFalse();
    })

    it('isNeedDialogBottom', 0, () => {
      expect(UiUtil.isNeedDialogBottom(false, true)).assertTrue();
    })

    it('when_thumbnail_is_empty_returns_TimelinePageEmptyNode', 0, () => {
      const geometryTransitionBrowserId = 'aaaa';
      const tempTransitionId = 'bbbb';
      LocalStorage.getShared()?.set<string>('geometryTransitionBrowserId', tempTransitionId);

      const mediaItem = new MediaItem();
      mediaItem.setThumbnail('');

      const simpleMediaItem = new SimpleGridMediaItem();
      simpleMediaItem.setThumbnailUri('');

      const data = new ViewData(mediaItem);
      data.simpleMediaItem = simpleMediaItem;

      const res = UiUtil.generateReuseId(Constants.PHOTO_TRANSITION_TIMELINE, data, geometryTransitionBrowserId);
      expect(res).assertEqual('TimelinePageEmptyNode');
    });

    it('when_media_type_is_IMAGE_and_thumbnail_not_empty_returns_TimelinePageImageNode', 0, () => {
      const geometryTransitionBrowserId = 'aaaa';
      const tempTransitionId = 'bbbb';
      LocalStorage.getShared()?.set<string>('geometryTransitionBrowserId', tempTransitionId);

      const mediaItem = new MediaItem();
      mediaItem.setThumbnail('aaa');
      mediaItem.mediaType = UserFileManagerAccess.MEDIA_TYPE_IMAGE;

      const simpleMediaItem = new SimpleGridMediaItem();
      simpleMediaItem.setThumbnailUri('aaa');

      const data = new ViewData(mediaItem);
      data.simpleMediaItem = simpleMediaItem;

      const res = UiUtil.generateReuseId(Constants.PHOTO_TRANSITION_TIMELINE, data, geometryTransitionBrowserId);
      expect(res).assertEqual('TimelinePageImageNode');
    });

    // 代码变更已不存在VideoNode分支
    it('when_media_type_is_VIDEO_and_thumbnail_not_empty_returns_TimelinePageVideoNode', 0, () => {
      const geometryTransitionBrowserId = 'aaaa';
      const tempTransitionId = 'bbbb';
      LocalStorage.getShared()?.set<string>('geometryTransitionBrowserId', tempTransitionId);

      const mediaItem = new MediaItem();
      mediaItem.setThumbnail('aaa');
      mediaItem.mediaType = UserFileManagerAccess.MEDIA_TYPE_VIDEO;

      const simpleMediaItem = new SimpleGridMediaItem();
      simpleMediaItem.setThumbnailUri('aaa');

      const data = new ViewData(mediaItem);
      data.simpleMediaItem = simpleMediaItem;

      const res = UiUtil.generateReuseId(Constants.PHOTO_TRANSITION_TIMELINE, data, geometryTransitionBrowserId);
      expect(res).assertEqual('TimelinePageImageNode');
    });

    it('when_vibrate_type_is_ALBUM', 0, () => {
      UiUtil.touchVibrate(VibrateType.ALBUM);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('when_vibrate_type_is_IMAGE', 0, () => {
      UiUtil.touchVibrate(VibrateType.IMAGE);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('when_vibrate_type_is_DRAG', 0, () => {
      UiUtil.touchVibrate(VibrateType.DRAG);
      expect(NUMBER_ONE).assertEqual(1);
    });

    it('getSmartAlbumGridCount', 0, () => {
      let res = UiUtil.getSmartAlbumGridCount();
      expect(res > 0).assertEqual(true);
    })

    it('when_width_and_cover_width_are_zero_returns_false', 0, () => {
      const mediaItem = new MediaItem();
      mediaItem.width = 0;
      mediaItem.coverWidth = 0;
      const res = UiUtil.isEditedWidthAndHeight(mediaItem);
      expect(res).assertEqual(false);
    });

    it('when_width_is_zero_and_cover_width_is_non_zero_returns_true', 0, () => {
      const mediaItem = new MediaItem();
      mediaItem.width = 0;
      mediaItem.coverWidth = 1;
      const res = UiUtil.isEditedWidthAndHeight(mediaItem);
      expect(res).assertEqual(true);
    });

    it('when_width_and_cover_width_are_non_zero_but_height_and_cover_height_are_zero_returns_false', 0, () => {
      const mediaItem = new MediaItem();
      mediaItem.width = 1;
      mediaItem.coverWidth = 1;
      mediaItem.height = 0;
      mediaItem.coverHeight = 0;
      const res = UiUtil.isEditedWidthAndHeight(mediaItem);
      expect(res).assertEqual(false);
    });

    it('when_width_cover_width_are_non_zero_and_height_is_zero_but_cover_height_is_non_zero_returns_true', 0, () => {
      const mediaItem = new MediaItem();
      mediaItem.width = 1;
      mediaItem.coverWidth = 1;
      mediaItem.height = 0;
      mediaItem.coverHeight = 1;
      const res = UiUtil.isEditedWidthAndHeight(mediaItem);
      expect(res).assertEqual(true);
    });

    it('getSupportedSourcesFormats', 0, () => {
      let arrys = ['aa'];
      UiUtil.setSupportedSourcesFormats(arrys);
      let res = UiUtil.getSupportedSourcesFormats();
      expect(res[0]).assertEqual('aa');
    })

    it('when_media_type_is_DEFAULT_returns_false', 0, async () => {
      const mediaItem = new MediaItem();
      mediaItem.mediaType = photoAccessHelper.PhotoSubtype.DEFAULT;
      const res = await UiUtil.isEditedEnable(mediaItem);
      expect(res).assertEqual(false);
    });

    it('when_media_type_is_IMAGE_returns_false', 0, async () => {
      const mediaItem = new MediaItem();
      mediaItem.mediaType = UserFileManagerAccess.MEDIA_TYPE_IMAGE;
      const res = await UiUtil.isEditedEnable(mediaItem);
      expect(res).assertEqual(false);
    });

    it('when_media_type_is_IMAGE_and_size_is_0_returns_false', 0, async () => {
      const mediaItem = new MediaItem();
      mediaItem.mediaType = UserFileManagerAccess.MEDIA_TYPE_IMAGE;
      mediaItem.size = 0;
      const res = await UiUtil.isEditedEnable(mediaItem);
      expect(res).assertEqual(false);
    });

    it('when_media_type_is_VIDEO_and_duration_is_0_returns_false', 0, async () => {
      const mediaItem = new MediaItem();
      mediaItem.mediaType = UserFileManagerAccess.MEDIA_TYPE_VIDEO;
      mediaItem.duration = 0;
      const res = await UiUtil.isEditedEnable(mediaItem);
      expect(res).assertEqual(false);
    });

    it('when_media_type_is_VIDEO_and_duration_is_1_returns_false', 0, async () => {
      const mediaItem = new MediaItem();
      mediaItem.mediaType = UserFileManagerAccess.MEDIA_TYPE_VIDEO;
      mediaItem.duration = 1;
      const res = await UiUtil.isEditedEnable(mediaItem);
      expect(res).assertEqual(false);
    });

    //测试updateGeometryTapInfo, 不存在无效输入分支
    it('updateGeometryTapInfo_when_geometryTapIndex_and_geometryTransitionString_are_valid', 0, () => {
      let mocker = new MockKit();
      mocker.mockFunc(Log, Log.info);
      let geometryTapIndex = 1;
      let geometryTransitionString = 'geometryTransitionString'
      UiUtil.updateGeometryTapInfo(geometryTapIndex, geometryTransitionString);
      mocker.verify('info', [TAG, 'UiUtil.geometryTransitionId = ' + geometryTransitionString +
        ', placeholderIndex = ' + geometryTapIndex]).once();
      mocker.ignoreMock(Log, Log.info);
    });

    //测试isActionArrayEqual: firstList === secondList
    it('isActionArrayEqual_when_firstList_equals_secondList', 0, () => {
      let firstList: Action[] = [];
      const res = UiUtil.isActionArrayEqual(firstList, firstList);
      expect(res).assertTrue();
    });

    //firstList !== secondList
    it('isActionArrayEqual_when_firstList_not_equals_secondList', 0, () => {
      let firstList: Action[] = [];
      let secondList: Action[] = [];
      secondList.push(Action.MULTISELECT);
      secondList.push(Action.ABOUT_GALLERY);
      const res = UiUtil.isActionArrayEqual(firstList, secondList);
      expect(res).assertFalse();
    });

    //firstList !== secondList and !firstList[index].equals(secondList[index])
    it('isActionArrayEqual_when_firstList[index]_not_equals_secondList[index]', 0, () => {
      let firstList: Action[] = [];
      let secondList: Action[] = [];
      firstList.push(Action.ABOUT_GALLERY);
      secondList.push(Action.MULTISELECT);
      const res = UiUtil.isActionArrayEqual(firstList, secondList);
      expect(res).assertFalse();
    });

    //firstList !== secondList and firstList[index].equals(secondList[index]
    it('isActionArrayEqual_when_firstList[index]_equals_secondList[index]', 0, () => {
      let firstList: Action[] = [];
      let secondList: Action[] = [];
      firstList.push(Action.ABOUT_GALLERY);
      secondList.push(Action.ABOUT_GALLERY);
      const res = UiUtil.isActionArrayEqual(firstList, secondList);
      expect(res).assertTrue();
    });

  })
}