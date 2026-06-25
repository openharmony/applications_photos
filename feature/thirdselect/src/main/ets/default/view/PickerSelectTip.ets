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
import lazy { process } from '@kit.ArkTS';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { SelectParams } from '@ohos/common/src/main/ets/default/model/common/SelectParams';
import lazy { AlbumDefine } from '@ohos/common/src/main/ets/default/model/browser/AlbumDefine';

/* instrument ignore file */
const TAG: string = 'PickerSelectTip';

const PICKER_SELECT_TIPS_COL_HEIGHT: number = 28;

/**
 * 清除安全提示动效播放记录
 * @param storage
 */
export function clearAnimatePlayHistory(storage: LocalStorage) {
  storage.delete(Constants.PICKER_SHIELD_ANIMATE_PLAYED_FLAG)
}

@Component
/**
 * 安全访问动效，主要用于picker半模态底部展示，图库内需要展示安全访问的页面也在使用。
 * 播放控制有两套机制：
 * 1. PickerSelectTip层级的play与playEveryTime根据storage内的播放历史去控制showAnimate。
 * 2. showAnimate为true时，PickerShieldAnimate内部根据拉起方信息控制其在拉起方回话周期内仅播放一次
 */
export struct PickerSelectTip {
  @LocalStorageLink(Constants.IS_PICKER_USED_SUBWINDOW) isPickerUsedSubwindow: boolean = false;
  /**
   * 忽略播放控制，每次渲染都播放动效并更新播放记录，优先级高于play
   */
  @Prop playEveryTime: boolean = false;
  /**
   * 是否播放动效，有播放历史或设为false则不播放
   */
  @Prop play: boolean = true;
  /**
   * ability启动参数， 默认使用commonPickerUiExtensionAbility启动参数
   */
  private abilityStartParams?: SelectParams;
  private animatePlayed = false;
  private sharedStorage = this.getUIContext().getSharedLocalStorage();
  // 决定安全组件文字内容
  // private pickerType = PickerType.GALLERY_PICKER;

  aboutToAppear() {
    if (!this.abilityStartParams) {
      this.abilityStartParams = this.sharedStorage?.get<SelectParams>(
        Constants.PHOTO_PICKER_PARAMS_KEY
      );
    }
    this.pickerTypeCtl();
    this.animatePlayCtl();
  }

  private pickerTypeCtl() {
    // switch (this.abilityStartParams?.filterMediaType) {
    //   case AlbumDefine.FILTER_MEDIA_TYPE_IMAGE:
    //     this.pickerType = PickerType.PHOTO_PICKER;
    //     break;
    //   case AlbumDefine.FILTER_MEDIA_TYPE_VIDEO:
    //     this.pickerType = PickerType.VIDEO_PICKER;
    //     break;
    //   default:
    //     this.pickerType = PickerType.GALLERY_PICKER
    // }
  }

  private animatePlayCtl() {
    if (this.playEveryTime) {
      this.animatePlayed = false;
      this.sharedStorage?.setOrCreate(Constants.PICKER_SHIELD_ANIMATE_PLAYED_FLAG, true)
      return;
    }
    if (!this.play) {
      this.animatePlayed = true;
      return;
    }
    // 图库内场景picker没有单独进程，sharedStorage不会在关闭后销毁，需要在入口页aboutToAppear中手动清理播放记录
    this.animatePlayed = Boolean(
      this.sharedStorage?.get<boolean>(Constants.PICKER_SHIELD_ANIMATE_PLAYED_FLAG)
    );
    Log.i(TAG, `animatePlayCtl animatePlayed ${this.animatePlayed}`)
    if (!this.animatePlayed) {
      this.sharedStorage?.setOrCreate(Constants.PICKER_SHIELD_ANIMATE_PLAYED_FLAG, true)
    }
  }

  build() {
    Row() {
      // PickerShieldAnimate({
      //   pickerType: this.pickerType,
      //   callerBundleName: this.abilityStartParams?.bundleName || Constants.PHOTO_BUNDLE_NAME,
      //   callerPid: this.abilityStartParams?.callerPid || String(process.pid),
      //   showAnimate: !this.animatePlayed,
      // })
    }
    .padding({
      left: this.isPickerUsedSubwindow ? Constants.ActionBarButtonHeight : 0,
      right: this.isPickerUsedSubwindow ? Constants.ActionBarButtonHeight : 0,
    })
    .height(PICKER_SELECT_TIPS_COL_HEIGHT)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .hitTestBehavior(HitTestMode.None)
  }
}