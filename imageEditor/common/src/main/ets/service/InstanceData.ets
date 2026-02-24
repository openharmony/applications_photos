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
import window from '@ohos.window';
import { HiLog } from '../common/util/HiLog';

const TAG: string = 'InstanceData';

export class InstanceData {
  public context: Context;
  public previewComponentId: string = 'xcomponentId';
  public windowStage: window.WindowStage;
  public onBaseEditorBackPress: (() => boolean) | undefined = undefined;
  public onStylusBackPress: (() => boolean) | undefined = undefined;
  public onAiEditorBackPress: (() => boolean) | undefined = undefined;

  constructor(context: Context, windowStage: window.WindowStage) {
    this.context = context;
    this.windowStage = windowStage;
    let instanceId = this.guid();
    this.previewComponentId = `xcomponentId-${instanceId}`;
    HiLog.i(TAG, `init instance data: ${instanceId}`);
  }

  private S4(): string {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
  }

  private guid(): string {
    return (this.S4() + this.S4() + `-${this.S4()}` + '-' + this.S4() + '-' + this.S4() + '-' + this.S4() + this.S4() +
    this.S4());
  }
}