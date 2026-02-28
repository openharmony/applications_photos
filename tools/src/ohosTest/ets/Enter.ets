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

import { AppStart } from './AppStart.test';
import { CommonOperate } from './CommonOperate';

export class Enter extends CommonOperate {
  /**
   * 进入时间线宫格
   * @returns
   */
  public async timeline(): Promise<void> {
    this.log.i('Enter clickTimeline');
    await AppStart.photos();
    await this.skipBootPage();
    await this.clickTimeline();
  }

  /**
   * 进入大图预览
   * @returns
   */
  public async browser(): Promise<void> {
    this.log.i('Enter browser');
    await this.skipBootPage();
    await this.clickTimeline();
    await this.clickGridItem();
    await this.mustAtBrowser();
  }

  /**
   * 进入相册页宫格
   * @returns
   */
  public async albumList(): Promise<void> {
    this.log.i('Enter albumList');
    await this.skipBootPage();
    await this.clickTimeline();
    await this.tabIndex();
    await this.tabAlbums();
  }

  /**
   * 进入视频播放预览
   * @returns
   */
  public async videoBrowser(): Promise<void> {
    this.log.i('Enter videoBrowser');
    await this.skipBootPage();
    await this.clickTimeline();
    await this.tabIndex();
    await this.clickVideoBrowser();
  }

  /**
   * 进入相机拍照界面
   * @returns
   */
  public async cameraShoot(): Promise<void> {
    await AppStart.camera();
    this.log.i('Enter cameraShoot');
    await this.skipCameraBootPage();
    await this.shoot();
  }
}