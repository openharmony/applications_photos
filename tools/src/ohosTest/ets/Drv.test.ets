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

import { Component, Driver, MatchPattern, On, ON, Point, Rect, DisplayRotation } from '@ohos.UiTest';
import { KeyCode } from '@kit.InputKit';
import { DELAY } from './Config.test';
import { Swipes } from './Swipes';
import { expect } from '@ohos/hypium';
import { TestConstants } from './TestConstants';

/* instrument ignore file  */
/**
 * Describes the attribute requirements for the target Components.
 */
enum CompAttribute {
  ID,
  TEXT,
  TYPE,
  IN_WINDOW,
  WITHIN,
}

/**
 *   测试通用工具类
 */
export class Drv extends Swipes {
  constructor(tag: string, driver?: Driver) {
    if (!driver) {
      driver = Driver.create();
    }
    super(tag, driver);
  }

  /**
   * 适用于不确定是否存在的组件，若存在则对其进行点击操作，按text查找
   */
  public async clickIfExistByText(text: string, time: number = DELAY.default): Promise<boolean> {
    if (await this.driver.findComponent(ON.text(text))) {
      return await this.assertTextClick(text, false, time);
    }
    this.log.e(text + ' text not find');
    return false;
  }

  /**
   * 适用于不确定是否存在的组件，若存在则对其进行点击操作，按id查找
   */
  public async clickIfExist(id: string, time: number = DELAY.default): Promise<boolean> {
    if (await this.driver.findComponent(ON.id(id))) {
      return await this.assertClick(id, false, time);
    }
    this.log.e(id + ' id not find');
    return false;
  }

  /**
   * 适用于不确定是否存在的组件，若存在则对其进行点击操作，按id查找
   */
  public async clickIfExistOn(identifier: On, time: number = DELAY.default): Promise<boolean> {
    if (await this.driver.findComponent(identifier)) {
      return await this.assertClickOn(identifier, false, time);
    }
    this.log.e(JSON.stringify(identifier) + ' identifier not find');
    return false;
  }

  /**
   * 获取当前所有存在id的comp
   * @param id
   * @returns
   */
  public async showComponentsWithin(id?: string): Promise<string[]> {
    let array: Component[] = [];
    if (!id) {
      id = 'PageTitle.index';
      return [];
    }
    this.log.i('finding the component PageTitle.index');
    const comp = await this.driver.findComponent(ON.id(id));
    if (!comp) {
      this.log.i(`showComponents: no such id: ${id}`);
      return [];
    } else {
      await this.driver.assertComponentExist(ON.id(id));
      array = await this.driver.findComponents(ON.within(ON.id(id)));
    }
    if (!array?.length) {
      return [];
    }
    let names: string[] = [];
    const length = Math.min(array.length, 5);
    for (let i = 0; i < length; i++) {
      const element = array[i];
      const member = await element.getId();
      if (member) {
        names.push(member);
      }
    }
    this.log.i(`showComponents: ${names}`);
    await this.sleep(DELAY.rapid);
    return names;
  }

  /**
   * 多写expect/assert, 增加DT拦截功能
   * @param id
   * @param isUniq
   * @returns
   */
  public async assertComponent(id: string, isUniq: boolean = false): Promise<Component> {
    return await this.assertComponentBy(CompAttribute.ID, id, isUniq);
  }

  /**
   * 多写expect/assert, 增加DT拦截功能
   * @param id
   * @param isUniq
   * @returns
   */
  public async assertComponentByText(id: string, isUniq: boolean = false, pattern?: MatchPattern): Promise<Component> {
    return await this.assertComponentBy(CompAttribute.TEXT, id, isUniq, pattern);
  }

  /**
   *
   * @param attribute CompAttribute
   * @param id compid
   * @param isUniq 为true时, 对象唯一
   * @returns
   */
  private async assertComponentBy(attribute: CompAttribute, id: string, isUniq: boolean = false,
    pattern?: MatchPattern): Promise<Component> {
    this.log.i(`断言该组件存在: ${id}`);
    const identifier: On = this.toIdentifier(attribute, id, pattern);
    return this.assertComponentOn(identifier, id, isUniq);
  }

  public async assertComponentOn(identifier: On, id: string = '请加入维测',
    isUniq: boolean = false): Promise<Component> {
    const comps = await this.driver.findComponents(identifier);
    this.log.w(JSON.stringify(identifier) + id + ' assert comps length: ' + comps?.length);
    if (this.debug) {
      return comps?.[0];
    }
    await this.driver.assertComponentExist(identifier);
    expect(comps?.[0]).not().assertUndefined();
    this.log.w(JSON.stringify(identifier) + id + ' isClickable: ' + await comps[0].isClickable() + ' isEnabled: ' +
      await comps[0].isEnabled());
    if (isUniq) {
      expect(comps?.length).assertEqual(1);
    }
    expect(await comps[0].isEnabled()).assertTrue();
    return comps[0];
  }

  /**
   * 断言组件不存在
   * 多写expect/assert, 增加DT拦截功能
   * @param id
   * @param isUniq
   * @returns
   */
  public async negateComponent(id: string, isUniq: boolean = false): Promise<void> {
    await this.negateComponentBy(CompAttribute.ID, id, isUniq);
  }

  /**
   * 断言组件不存在ByText
   * 多写expect/assert, 增加DT拦截功能
   * @param id
   * @param isUniq
   * @returns
   */
  public async negateComponentByText(id: string, isUniq: boolean = false, pattern?: MatchPattern): Promise<void> {
    await this.negateComponentBy(CompAttribute.TEXT, id, isUniq, pattern);
  }

  /**
   * 断言组件不存在
   * @param attribute CompAttribute
   * @param id compid
   * @param isUniq 为true时, 对象唯一
   * @returns
   */
  private async negateComponentBy(attribute: CompAttribute, id: string, isUniq: boolean = false,
    pattern?: MatchPattern): Promise<void> {
    this.log.i(`断言该组件不存在: ${id}`);
    const identifier: On = this.toIdentifier(attribute, id, pattern);
    const comps = await this.driver.findComponents(identifier);
    this.log.i(id + ' negate comps length: ' + comps?.length);
    expect(comps?.length).assertUndefined();
    if (comps?.length) {
      this.log.e(id + ' unexpected, negate comps length: ' + comps?.length);
      await this.screenCapture(`/data/storage/el2/base/cache/negateComponentBy${id}.png`);
    }
  }

  private toIdentifier(attribute: CompAttribute, id: string, pattern?: MatchPattern): On {
    this.log.i(attribute + ' ' + id);
    let identifier: On = ON.id(id);
    switch (attribute) {
      case CompAttribute.ID:
        identifier = ON.id(id);
        break;
      case CompAttribute.TEXT:
        identifier = ON.text(id, pattern);
        break;
    }
    return identifier;
  }

  private debug = false;

  /**
   * 多写expect/assert, 增加DT拦截功能
   * @param id
   * @param isUniq
   * @returns
   */
  public async assertComponentClickable(id: string, isUniq: boolean = false): Promise<Component> {
    const comps = await this.driver.findComponents(ON.id(id));
    this.log.w(id + ' comps length: ' + comps?.length);
    this.log.w(id + ' isClickable: ' + await comps[0]?.isClickable() + ' isEnabled: ' + await comps[0]?.isEnabled());
    if (this.debug) {
      return comps?.[0];
    }
    await this.driver.assertComponentExist(ON.id(id));
    expect(comps?.[0]).not().assertUndefined();
    if (isUniq) {
      expect(comps?.length).assertEqual(1);
    }
    expect(await comps[0].isClickable()).assertTrue();
    this.log.w(id + ' exits');
    return comps[0];
  }

  /**
   * 断言组件存在并点击
   * @param id compid
   * @param isUniq 为true时, 对象唯一
   * @param time
   * @returns
   */
  public async assertClick(id: string, isUniq: boolean = false, time: number = DELAY.default): Promise<boolean> {
    const button = await this.assertComponent(id, isUniq);
    if (!button) {
      await this.screenCapture('/data/storage/el2/base/cache/1.png');
      this.log.w(`${id} button not exist`);
      return false;
    }
    await button.click();
    await this.sleep(time);
    this.log.i(`${id} clicked`);
    return true;
  }

  public async assertTextClick(text: string, isUniq: boolean = false, time: number = DELAY.default,
    pattern?: MatchPattern): Promise<boolean> {
    const button = await this.assertComponentByText(text, isUniq, pattern);
    if (!button) {
      this.log.w(`${text} button not exist`);
      return false;
    }
    await button.click();
    await this.sleep(time)
    this.log.i(`${text} clicked`);
    return true;
  }

  public async assertClickOn(identifier: On, isUniq: boolean = false, time: number = DELAY.default): Promise<boolean> {
    const button = await this.assertComponentOn(identifier, JSON.stringify(identifier), isUniq);
    if (!button) {
      await this.screenCapture('/data/storage/el2/base/cache/1.png');
      this.log.w(`identifier ${JSON.stringify(identifier)} button not exist`);
      return false;
    }
    await button.click();
    await this.sleep(time)
    this.log.i(`identifier ${JSON.stringify(identifier)} clicked`);
    return true;
  }

  /* instrument ignore next */
  public async assertDoubleClickById(id: string, time: number = DELAY.default,): Promise<void> {
    await this.driver.assertComponentExist(ON.id(id));
    const component = await this.driver.findComponent(ON.id(id));
    await component.doubleClick();
    await this.driver.delayMs(time);
  }

  // 长按
  /* instrument ignore next */
  public async assertLongClickById(id: string, time: number = DELAY.default): Promise<void> {
    await this.driver.assertComponentExist(ON.id(id));
    const component = await this.driver.findComponent(ON.id(id));
    await component.longClick();
    await this.driver.delayMs(time);
    this.log.w('assertLongClickById');
  }

  // 双指捏合放大
  /* instrument ignore next */
  public async assertPinchOutById(id: string, time: number = DELAY.default): Promise<void> {
    await this.driver.assertComponentExist(ON.id(id));
    const component = await this.driver.findComponent(ON.id(id));
    await component.pinchOut(2);
    await this.driver.delayMs(time);
  }

  // 双指捏合缩小
  /* instrument ignore next */
  public async assertPinchInById(id: string, time: number = DELAY.default): Promise<void> {
    await this.driver.assertComponentExist(ON.id(id));
    const component = await this.driver.findComponent(ON.id(id));
    await component.pinchIn(0.5);
    await this.driver.delayMs(time);
  }

  // 从左边屏幕侧滑返回
  public async keyBack(): Promise<void> {
    this.log.i('slide left from screen');
    await this.driver.triggerKey(KeyCode.KEYCODE_BACK);
    this.log.i('keyBack from screen');
    await this.sleep()
  }

  // 返回
  public async pressBack(): Promise<void> {
    await this.driver.pressBack();
    this.log.i('pressBack from screen');
    await this.sleep();
  }

  /**
   * 录屏, 录屏期间屏幕锁定会触发异常
   * @param videoTime 录屏时间
   */
  public async prepareVideo(videoTime: number): Promise<void> {
    await this.videoRecordStart();
    await this.driver.delayMs(videoTime);
    await this.videoRecordEnd();
    this.log.i(`prepareVideo end`);
  }


  public async videoRecordStart(): Promise<void> {
    try {
      let rotation = await this.driver.getDisplayRotation();
      switch (rotation) {
        case DisplayRotation.ROTATION_0:
        case DisplayRotation.ROTATION_180:
          await this.driver.swipe(900, 30, 900, 600, 900);
          break;
        case DisplayRotation.ROTATION_90:
        case DisplayRotation.ROTATION_270:
          // 横屏需要下拉两次
          await this.driver.swipe(2000, 30, 2000, 100, 900);
          await this.driver.swipe(2000, 30, 2000, 600, 900);
          break;
      }
      await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      this.log.i(`videoRecordStart begin`);
      await this.assertClick('transition_toggletoggle_screen_recorder');
      await this.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    } catch (e) {
      this.log.e('videoRecordStart error');
    }
    this.log.i(`videoRecordStart end`);
  }

  /**
   * 录屏结束, 录屏期间屏幕锁定会触发异常
   */
  public async videoRecordEnd(): Promise<void> {
    try {
      let rotation = await this.driver.getDisplayRotation();
      switch (rotation) {
        case DisplayRotation.ROTATION_0:
        case DisplayRotation.ROTATION_180:
          await this.driver.swipe(900, 30, 900, 600, 900);
          break;
        case DisplayRotation.ROTATION_90:
        case DisplayRotation.ROTATION_270:
          // 横屏需要下拉两次
          await this.driver.swipe(2000, 30, 2000, 100, 900);
          await this.driver.swipe(2000, 30, 2000, 600, 900);
          break;
      }
      await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      await this.assertClick('transition_toggletoggle_screen_recorder');
      await this.driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    } catch (e) {
      this.log.e('videoRecordEnd error');
    }
    this.log.i(`videoRecordEnd end`);
  }

  /**
   * 截屏
   * @param savePath 需要保存的路径, 如 `/data/storage/el2/base/cache/findComponentBy${id}.png`
   * @param rect
   * @returns
   */
  /* instrument ignore next */
  async screenCapture(savePath: string, rect?: Rect): Promise<void> {
    await this.driver.screenCapture(savePath, rect);
  }

  /* instrument ignore next */
  async getDisplaySize(): Promise<Point> {
    return await this.driver.getDisplaySize();
  }

  // 下拉 上滑
  async swipeUp(): Promise<void> {
    await this.driver.swipe(800, 540, 800, 1200, 800);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 540, 800, 1200, 800);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 540, 800, 1200, 800);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 540, 800, 1200, 800);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 540, 800, 1200, 800);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  }

  //上拉 下滑
  async swipeDown(): Promise<void> {
    await this.driver.swipe(800, 2300, 800, 300, 2000);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 2300, 800, 300, 2000);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 2300, 800, 300, 2000);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 2300, 800, 300, 2000);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 2300, 800, 300, 2000);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 2300, 800, 300, 2000);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 2300, 800, 300, 2000);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 2300, 800, 300, 2000);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 2300, 800, 300, 2000);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
    await this.driver.swipe(800, 2300, 800, 300, 2000);
    await this.driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  }


  public async isLivePhoto(): Promise<boolean> {
    let button: Component = await this.driver.findComponent(ON.id('movingPhoto'));
    return !!button;
  }
}