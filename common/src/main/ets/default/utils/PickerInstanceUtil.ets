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
import lazy { Constants } from '../model/common/Constants';

export class PickerInstanceUtil {
  public static readonly DEFAULT_PICKER_ID: string = '';
  private static uuid: number = 1000;
  public readonly id: number;

  /* instrument ignore next */
  private constructor() {
    PickerInstanceUtil.uuid++;
    this.id = PickerInstanceUtil.uuid;
  }

  /* instrument ignore next */
  public static createPickerInstance(storage: LocalStorage) {
    let pickerInstanceId = new PickerInstanceUtil().id;
    storage?.setOrCreate(Constants.PHOTO_PICKER_UUID, String(pickerInstanceId));
  }

  public static getPickerId(): string {
    let uuid = LocalStorage.getShared()?.get<string>(Constants.PHOTO_PICKER_UUID) as string;
    if (uuid === undefined) {
      return PickerInstanceUtil.DEFAULT_PICKER_ID;
    }
    /* instrument ignore next */
    return uuid;
  }
}