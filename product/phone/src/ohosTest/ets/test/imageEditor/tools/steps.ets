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
import { Component, Driver, MatchPattern, On, ON, PointerMatrix } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import { TestConstants } from '@ohos/tools/src/ohosTest/ets/TestConstants';
import {
  EditorTestType,
  PhotoMap,
  PhotoType,
  EditorAlbum,
  trustListMap,
  ReplaceAlbum,
  EditorPhoto,
  TakePhotos
} from './constants';
import { WindowUtil } from '@ohos/common/src/main/ets/default/utils/WindowUtil';
import window from '@ohos.window';
import { Dt } from '@ohos/tools/src/ohosTest/ets/Dt';
import { deviceInfo } from '@kit.BasicServicesKit';
import wifiManager from '@ohos.wifiManager';

const TAG = 'EditorCommonStep';
const MAX_BACK_RETRIES = 8;

const abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let __driver: Driver | undefined = undefined;
const getDriver = () => {
  if (!__driver) {
    __driver = Driver.create();
  }
  return __driver;
};

const FIRST_PHOTO_ID = 'TimelinePage_GridItem0';

type Task = (_driver: Driver) => Promise<void>;

let currentPhotoType = 'default';

let wifiName: string;

const testDeviceSupport = (): boolean => {
  if (currentPhotoType === 'default') {
    return true;
  }
  if (trustListMap.has(currentPhotoType as PhotoType)) {
    return trustListMap.get(currentPhotoType as PhotoType)!.includes(deviceInfo.productSeries);
  }
  return true;
};

export function getTask(task: Task, type: EditorTestType = 'default') {
  return async (dt: Dt): Promise<void> => {
    currentPhotoType = type;
    await beforeTask(type);
    await loggedTask(task)(dt);
    await BackToGridView(getDriver());
  };
}

export async function UpdateOrientation() {
  // 设为横屏
  WindowUtil.setOrientation(window.Orientation.LANDSCAPE);
  await getDriver().delayMs(TestConstants.DELAY_THREE_SECOND);

  // 设为竖屏
  WindowUtil.setOrientation(window.Orientation.PORTRAIT);
  await getDriver().delayMs(TestConstants.DELAY_THREE_SECOND);
}

export function loggedTask(task: Task) {
  return async (dt: Dt): Promise<void> => {
    Log.info(TAG, `${dt.tag} start`);
    if (testDeviceSupport()) {
      await task(getDriver());
    }
    Log.info(TAG, `${dt.tag} end`);
  };
}

export function startTask(task: Task, type: EditorTestType = 'default') {
  return async (dt: Dt): Promise<void> => {
    currentPhotoType = type;
    await beforeTask(type);
    await loggedTask(task)(dt);
  };
}

export function endTask(task: Task) {
  return async (dt: Dt): Promise<void> => {
    await loggedTask(task)(dt);
    await BackToGridView(getDriver());
  };
}

async function beforeTask(type: EditorTestType) {
  if (!testDeviceSupport()) {
    return;
  }
  await KillAccessibility();
  await BackToGridView(getDriver());
  await ConfirmPhotosOpened();
  await getDriver().delayMs(TestConstants.DELAY_ONE_SECOND);
  switch (type) {
    case 'default':
      await EnterEditor(getDriver(), type);
      break;
    case PhotoType.StaticImage:
    case PhotoType.DynamicImage:
      await EnterEditorAlbum(getDriver(), type, TakePhotos);
      break;
    case PhotoType.AIRemove:
    case PhotoType.RefineImage:
    case PhotoType.ApertureImage:
      // 进入图片编辑组相册中，依据传入的类型 打开对应的照片编辑界面
      await EnterEditorAlbum(getDriver(), type, EditorAlbum);
      break;
    case PhotoType.AIReplace:
      await EnterReplaceAlbum(getDriver(), type);
      break;
    default:
      break;
  }
  if (type === PhotoType.DynamicImage) {
    await getDriver().waitForComponent(ON.id('videoEditor_tabsDefine'), TestConstants.DELAY_TEN_SECOND);
  } else {
    await getDriver().waitForComponent(ON.id('petalclip_AiRetouch'), TestConstants.DELAY_TEN_SECOND);
  }
}

async function ConfirmPhotosOpened() {
  await abilityDelegator.getCurrentTopAbility().then(async ability => {
    Log.info(TAG, ability.context.abilityInfo.bundleName);
    if (ability.context.abilityInfo.bundleName !== TestConstants.PHOTO_BUNDLE_NAME) {
      await StartPhotos();
      await getDriver().delayMs(TestConstants.DELAY_TWO_SECOND);
      await SkipBootPage();
    }
  }).catch(async () => {
    Log.error(TAG, 'getCurrentTopAbility error');
    await StartPhotos();
    await getDriver().delayMs(TestConstants.DELAY_TWO_SECOND);
    await SkipBootPage();
  });
}

export async function assertClickById(id: string, longClick = false): Promise<Component> {
  const component = await getDriver().waitForComponent(ON.id(id), TestConstants.DELAY_TEN_SECOND);
  if (!component) {
    Log.info(TAG, 'id component is empty');
    await screenshot(id);
  }
  await getDriver().delayMs(TestConstants.DELAY_ONE_SECOND);
  await getDriver().assertComponentExist(ON.id(id));
  const button = await getDriver().findComponent(ON.id(id));
  if (longClick) {
    await button.longClick();
  } else {
    await button.click();
  }
  await getDriver().delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, `${id} clicked`);
  return button;
}

export async function assertClickByText(text: string, longClick = false): Promise<Component> {
  await getDriver().waitForComponent(ON.text(text), TestConstants.DELAY_TEN_SECOND);
  await getDriver().delayMs(TestConstants.DELAY_ONE_SECOND);
  await getDriver().assertComponentExist(ON.text(text));
  const button = await getDriver().findComponent(ON.text(text));
  if (longClick) {
    await button.longClick();
  } else {
    await button.click();
  }
  await getDriver().delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, `${text} clicked`);
  return button;
}

export async function testClickById(driver: Driver, id: string, logInfo: string,
  needDoubleClock: boolean = false): Promise<void> {
  await getDriver().waitForComponent(ON.id(id), TestConstants.DELAY_TEN_SECOND);
  await getDriver().delayMs(TestConstants.DELAY_ONE_SECOND);
  await driver.assertComponentExist(ON.id(id));
  const button = await driver.findComponent(ON.id(id));
  if (!button) {
    Log.info(TAG, `there is no ${id}`);
    return;
  }
  if (needDoubleClock) {
    await button.doubleClick();
  } else {
    await button.click();
  }
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, logInfo);
}

export async function testClickByText(text: string) {
  await getDriver().waitForComponent(ON.text(text), TestConstants.DELAY_TEN_SECOND);
  await getDriver().delayMs(TestConstants.DELAY_ONE_SECOND);
  await getDriver().assertComponentExist(ON.text(text));
  const cmp = await getDriver().findComponent(ON.text(text));
  await cmp.click();
  await getDriver().delayMs(TestConstants.DELAY_ONE_SECOND);
  Log.info(TAG, `${text} clicked`);
}

export async function EnterEditor(driver: Driver, type: PhotoType | 'default') {
  Log.info(TAG, `photo type is:${type}`);
  await assertClickById('TabAlbums');
  await assertClickByText(EditorPhoto);
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  await assertClickById('photoGridView_gird_0');
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  let button = await driver.findComponent(ON.id('ToolBarButtonMotionPicture'));
  if (button) {
    Log.info(TAG, 'ToolBarButtonMotionPicture is existential');
  }
  await testClickById(driver, 'ToolBarButtonEdit', 'ToolBarButtonEdit clicked');
  Log.info(TAG, 'Enter editor successfully');
}

// 对于有特殊照片需求的，进入拍照预制的相册中
async function EnterEditorAlbum(driver: Driver, type: PhotoType, album: string) {
  Log.info(TAG, '进入拍照预制组,type is：' + type);
  await assertClickById('TabAlbums');
  // 点击图拍照预制组相册
  await swipeSearch(ON.type('Grid'), ON.text(album), 'bottom');
  await testClickByText(album);
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  // 根据数据顺序 点击对应照片
  const photoId = PhotoMap.get(type);
  await assertClickById(photoId!);
  await driver.waitForComponent(ON.id('ToolBarButtonEdit'), TestConstants.DELAY_TEN_SECOND);
  await assertClickById('ToolBarButtonEdit');
  await RevertPhoto();
  Log.info(TAG, 'Enter editorAlbum successfully');
}

// 对于有特殊照片需求的，进入图片编辑组的相册中
async function EnterReplaceAlbum(driver: Driver, type: PhotoType) {
  Log.info(TAG, '进入图片编辑组,type is：' + type);
  await assertClickById('TabAlbums');
  // 点击图片编辑组相册
  await swipeSearch(ON.type('Grid'), ON.text(ReplaceAlbum), 'bottom');
  await testClickByText(ReplaceAlbum);
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  // 根据数据顺序 点击对应照片
  const photoId = PhotoMap.get(type);
  await assertClickById(photoId!);
  await assertClickById('ToolBarButtonEdit');
  await RevertPhoto();
  Log.info(TAG, 'Enter replaceAlbum successfully');
}

async function RevertPhoto() {
  // 点击Revert按钮
  let button = await getDriver().findComponent(ON.id('petalClip_topToolBar_topTool_recover').enabled(true));
  if (button) {
    await testClickById(getDriver(), 'petalClip_topToolBar_topTool_recover',
      'petalClip_topToolBar_topTool_recover clicked');
    await getDriver().delayMs(TestConstants.DELAY_ONE_SECOND);
    // 确定
    await testClickById(getDriver(), 'advanced_dialog_button_1', 'advanced_dialog_button_1 clicked');
    await getDriver().delayMs(TestConstants.DELAY_ONE_SECOND);
    await assertClickById('ToolBarButtonEdit');
  }
}

export async function StartCamera(): Promise<boolean> {
  try {
    await abilityDelegator.executeShellCommand(`aa force-stop ${TestConstants.CAMERA_BUNDLE_NAME}`);
    await abilityDelegator.executeShellCommand(`aa start -a ${TestConstants.CAMERA_MAIN_ABILITY_NAME} -b ${TestConstants.CAMERA_BUNDLE_NAME}`);
    return true;
  } catch (exception) {
    Log.info(TAG, `start failed :${exception.code} ${exception.message}`);
  } finally {
    Log.info(TAG, 'start camera application');
  }
  return false;
}

export async function StartPhotos(): Promise<boolean> {
  let success = false;
  await abilityDelegator.executeShellCommand(`aa start -a ${TestConstants.PHOTO_MAIN_ABILITY_NAME} -b ${TestConstants.PHOTO_BUNDLE_NAME}`)
    .then(() => {
      Log.info(TAG, 'start photo application');
      success = true;
    }).catch(() => {
      Log.info(TAG, 'start photo failed');
    });
  return success;
}

export async function StopFiles(): Promise<boolean> {
  let success = false;
  await abilityDelegator.executeShellCommand(`aa force-stop ${TestConstants.FILES_BUNDLE_NAME}`)
    .then(() => {
      Log.info(TAG, 'stop files application');
      success = true;
    }).catch(() => {
      Log.info(TAG, 'stop files failed');
    });
  return success;
}

export async function StartFiles(): Promise<boolean> {
  let success = false;
  await abilityDelegator.executeShellCommand(`aa start -b ${TestConstants.FILES_BUNDLE_NAME} -a ${TestConstants.FILES_ABILITY_NAME}`)
    .then(() => {
      Log.info(TAG, 'start files application');
      success = true;
    }).catch(() => {
      Log.error(TAG, 'start files failed');
    });
  await getDriver().delayMs(600);
  let component = await getDriver().findComponent(ON.text('同意'));
  if (component) {
    await component.click();
    await getDriver().delayMs(600);
  }
  component = await getDriver().findComponent(ON.text('跳过'));
  if (component) {
    await component.click();
    await getDriver().delayMs(600);
  }
  return success;
}


// hdc shell killall accessibility
export async function KillAccessibility() {
  await abilityDelegator.executeShellCommand('killall accessibility')
    .then(() => {
      Log.info(TAG, 'killall accessibility success');
    }).catch(() => {
      Log.error(TAG, 'killall accessibility failed');
    });
}

export async function BackToGridView(driver: Driver) {
  let retries = MAX_BACK_RETRIES;
  while (retries--) {
    const first = await driver.findComponent(ON.id('TabPhotos'));
    if (first) {
      Log.info(TAG, 'has TabPhotos');
      return;
    } else {
      await driver.pressBack();
      Log.info(TAG, 'pressBack to grid view');
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      const cancel = await driver.findComponent(ON.id('advanced_dialog_button_1'));
      if (cancel) {
        Log.info(TAG, 'click advanced_dialog_button_1');
        await cancel.click();
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      }
    }
  }
}

export async function BackToHome() {
  const driver = getDriver();
  await driver.pressHome().catch(() => {
    Log.i(TAG, 'BackToHome err');
  });
}

async function clickIfExistById(id: string) {
  await getDriver().delayMs(TestConstants.DELAY_ONE_SECOND);
  const component = await getDriver().findComponent(ON.id(id))
    .catch(() => {
      Log.e(TAG, 'clickIfExistById-findComponent error');
    });
  Log.i(TAG, 'clickIfExistById-component: ' + component);
  if (component) {
    await assertClickById(id);
  }
}

export async function clickTextIfExist(text: string, driver: Driver) {
  try {
    await driver.assertComponentExist(ON.text(text));
    const component = await driver.findComponent(ON.text(text));
    await component.click();
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  } catch (err) {
    Log.i(TAG, 'text not find or click error');
  }
}

export async function skipCameraBoot() {
  const cameraConfirmBtn = 'Paf.Permission.button_confirm';
  const cameraSkipBtn = 'STARTUP_GUIDANCE_BTN';
  await clickIfExistById(cameraConfirmBtn);
  await clickIfExistById(cameraSkipBtn);
  let driver = getDriver();
  await clickTextIfExist('仅使用期间允许', driver)
}

/**
 * 拍一张静态照片
 * **/
export async function ShootStaticPhoto(): Promise<boolean> {
  let success = false;
  try {
    await KillAccessibility();
    const driver = getDriver();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    const dynamicBtn = await driver.findComponent(ON.id('TAB_BAR_LIVE_PHOTO_TAB_BAR_OPEN'));
    if (dynamicBtn) {
      await dynamicBtn.click();
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }
    await driver.waitForComponent(ON.id('TAB_BAR_LIVE_PHOTO_TAB_BAR_CLOSE'), TestConstants.DELAY_FIVE_SECOND);
    const dynamicBtnIsClose =
      await driver.findComponent(ON.id('TAB_BAR_LIVE_PHOTO_TAB_BAR_CLOSE', MatchPattern.EQUALS));
    if (!dynamicBtnIsClose) {
      Log.info(TAG, 'ShootStaticPhoto TAB_BAR_LIVE_PHOTO_TAB_BAR is open');
      await dynamicBtn.click();
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      await ClickShootBtn(driver);
    } else {
      Log.info(TAG, 'ShootStaticPhoto TAB_BAR_LIVE_PHOTO_TAB_BAR is close');
      await ClickShootBtn(driver);
      success = true;
    }
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  } catch (e) {
    Log.error(TAG, 'ShootStaticPhoto failed: ' + e);
  }
  return success;
}

/**
 * 拍一张动态照片
 * **/
export async function ShootMovingPhoto(): Promise<boolean> {
  let success = false;
  try {
    await KillAccessibility();
    const driver = getDriver();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    await driver.waitForComponent(ON.id('TAB_BAR_LIVE_PHOTO_TAB_BAR_CLOSE'), TestConstants.DELAY_FIVE_SECOND);
    const dynamicBtn = await driver.findComponent(ON.id('TAB_BAR_LIVE_PHOTO_TAB_BAR_CLOSE', MatchPattern.EQUALS));
    if (dynamicBtn) {
      await dynamicBtn.click();
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }
    await driver.waitForComponent(ON.id('TAB_BAR_LIVE_PHOTO_TAB_BAR_OPEN'), TestConstants.DELAY_FIVE_SECOND);
    const dynamicBtnIsOpen = await driver.findComponent(ON.id('TAB_BAR_LIVE_PHOTO_TAB_BAR_OPEN', MatchPattern.EQUALS));
    if (!dynamicBtnIsOpen) {
      Log.info(TAG, 'ShootMovingPhoto TAB_BAR_LIVE_PHOTO_TAB_BAR is not open');
      await dynamicBtn.click();
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
      await ClickShootBtn(driver);
    } else {
      Log.info(TAG, 'ShootMovingPhoto TAB_BAR_LIVE_PHOTO_TAB_BAR is open');
      await ClickShootBtn(driver);
      success = true;
    }
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  } catch (e) {
    Log.error(TAG, 'ShootMovingPhoto failed: ' + e);
  }
  return success;
}

/**
 * 点击快门拍照
 * */
async function ClickShootBtn(driver: Driver) {
  try {
    const shootBtn = await driver.findComponent(ON.id('COMPONENT_ID_SHUTTER_PHOTO_1'));
    if (shootBtn) {
      await shootBtn.click();
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND * 2);
    }
  } catch (e) {
    Log.error(TAG, 'ClickShootBtn failed: ' + e);
  }
}

/**
 * 拍一张XXX照片
 * **/
export async function ShootXTStylePhoto() {
  await KillAccessibility();
  let driver = Driver.create();
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  const dynamicBtn = await driver.findComponent(ON.id('TAB_BAR_LIVE_PHOTO_TAB_BAR_OPEN'));
  if (dynamicBtn) {
    await dynamicBtn.click();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  }

  // 打开百宝箱
  const treasureBoxBtn = await driver.findComponent(ON.id('TREASURE_BOX_ARROW'));
  if (treasureBoxBtn) {
    await treasureBoxBtn.click();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  }

  // 打开设置
  const settingBtn = await driver.findComponent(ON.id('TREASURE_BOX_SETTING_BUTTON'));
  if (settingBtn) {
    await settingBtn.click();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  }

  // 打开照片格式
  const photoTypeBtn = await driver.findComponent(ON.id('COMPONENT_ID_SETTING_PHOTO_FORMAT_0'));
  if (photoTypeBtn) {
    await photoTypeBtn.click();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  }

  // 选择HEIF格式
  const heifTypeBtn = await driver.findComponent(ON.id('COMPONENT_ID_SETTING_DIALOG_ITEM_PHOTO_FORMAT_HEIF'));
  if (heifTypeBtn) {
    await heifTypeBtn.click();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  }

  // 点击返回按钮
  await testClickById(driver, 'NAV_DESTINATION_TITLE_BACK_1', 'NAV_DESTINATION_TITLE_BACK_1 clicked');

  // 打开个性风格
  const xtStyleBtn = await driver.findComponent(ON.id('TREASURE_BOX_CUSTOM_FILTER_CARD_BUTTON'));
  if (xtStyleBtn) {
    await xtStyleBtn.click();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  }

  const shootBtn = await driver.findComponent(ON.id('COMPONENT_ID_SHUTTER_PHOTO_1'));
  if (shootBtn) {
    await shootBtn.click();
    await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
  }
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
}

export async function RevertCamera() {
  let driver = Driver.create();
  // 打开百宝箱
  const treasureBoxBtn = await driver.findComponent(ON.id('TREASURE_BOX_ARROW'));
  if (treasureBoxBtn) {
    await treasureBoxBtn.click();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  }

  // 打开设置
  const settingBtn = await driver.findComponent(ON.id('TREASURE_BOX_SETTING_BUTTON'));
  if (settingBtn) {
    await settingBtn.click();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  }

  // 点击重置
  await swipeSearch(ON.type('Scroll'), ON.id('COMPONENT_ID_SETTING_DEFAULT_BUTTON_1'), 'bottom');
  await assertClickById('COMPONENT_ID_SETTING_DEFAULT_BUTTON_1');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击确认
  await assertClickById('SETTING_RESTORE_DEFAULT_CONFIRM');
  await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
  // 点击禁止
  await assertClickById('SETTING_RESTORE_DEFAULT_CANCEL');
}

/**
 * 跳过引导页
 */
export async function SkipBootPage() {
  const dt = new Dt('SkipBootPage');
  let driver = dt.driver;
  await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
  const steps = ['同意', '跳过', '立即体验', '稍后升级', '暂不登录', '暂不开启', '暂不升级'];
  // 两层循环 确保每一个引导操作都被点到
  outer: for (const _ of steps) {
    for (const item of steps) {
      await dt.clickIfExistByText(item, TestConstants.DELAY_ONE_SECOND);
      Log.info(TAG, item);
      if (await driver.findComponent(ON.id('TabPhotos'))) {
        // 相册页出现 跳出
        break outer;
      }
    }
  }
  // 查找云空间登录之后的关闭组件，并点击关闭
  if (await driver.findComponent(ON.text('登录云空间', MatchPattern.CONTAINS))) {
    try {
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND / 2);
      let component1 = await driver.findComponent(ON.text('登录云空间', MatchPattern.CONTAINS));
      let component2 = await driver.findComponent(ON.isAfter(ON.id(await component1.getId())).type('Blank'));
      let component3 = await driver.findComponent(ON.isAfter(ON.id(await component2.getId())).type('Image'));
      await component3.click();
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND / 2);
    } catch (e) {
      Log.error(TAG, '登录云空间 failed: ' + e);
    }
  }
  // 点击放大镜，用于后续跳过小艺输入法, 当前相册页和照片页放大镜key不同, 暂作此兼容
  let searchButton = await driver.findComponent(ON.id(TestConstants.TIMELINE_ACTION_BUTTON_SEARCH));
  if (!searchButton) {
    // 两次点击照片页，第一次用于消除气泡影响，第二次点击才真实有效
    await dt.assertClick('TabPhotos');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND / 2);
    await dt.assertClick('TabPhotos');
    await driver.delayMs(TestConstants.DELAY_ONE_SECOND / 2);
  }

  await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_SEARCH);
  await dt.clickIfExistByText('同意', TestConstants.DELAY_ONE_SECOND);
  if (await driver.findComponent(ON.text('请选择中文键盘布局'))) {
    await dt.assertTextClick('下一步');
  }
  await dt.clickIfExist(TestConstants.SEARCH_BACK_BUTTON);
  dt.log.i('SkipBootPage');
}

/**
 * 删除新建相册
 */
export async function deletNewAlbums() {
  const dt = new Dt('deleteNewAlbums');
  let driver = dt.driver;
  let components = await driver.findComponents(ON.text('新建相册', MatchPattern.CONTAINS));
  if (!components || !components.length) {
    dt.log.i('no new albums');
    return;
  }
  Log.info(TAG, `find ${components.length} new albums`);
  for (let i = 0; i < components.length; i++) {
    try {
      await components[i].click();
      await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      dt.log.i(`deleteNewAlbums ${components[i]} clicked`);
      // 如果多选按钮存在
      if (await driver.findComponent(ON.text('多选'))) {
        dt.log.i('doing delete albums');
        // 点击多选按钮
        await dt.clickIfExistByText('多选', TestConstants.DELAY_ONE_SECOND / 2);
        // 点击全选
        await dt.clickIfExistByText('全选', TestConstants.DELAY_ONE_SECOND / 2);
        // 点击更多
        await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
        // 移动到
        await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE_MOVE);
        // 移动到第一个相册
        await dt.assertClick('MediaOperationPageAlbum0');
        await dt.clickIfExistByText('替换为新文件', TestConstants.DELAY_ONE_SECOND)
        // 退出该相册
        await driver.pressBack();
        await driver.delayMs(TestConstants.DELAY_ONE_SECOND);
      } else {
        dt.log.i('album is null, could be delete');
      }
      // 全部移除后点击右上角四个点按钮
      await dt.assertClick(TestConstants.TIMELINE_ACTION_BUTTON_MORE);
      // 点击删除相册
      await dt.assertClick(TestConstants.ALBUMS_ACTION_BUTTON_MORE_DELETE_ALBUM);
      // 点击确认
      await dt.assertClick(TestConstants.DIALOG_BUTTON_SECOND);
    } catch (e) {
      dt.log.e(`delete albums error: e.stack=${e.stack}`);
    }
  }
  dt.log.i('deleteNewAlbums end');
}

interface RelativeMove {
  dx: number;
  dy: number;
}

type Direction = 'left' | 'right' | 'top' | 'bottom' | 'center';

export async function swipeTo(cmp: On, relativePoint: RelativeMove): Promise<Component> {
  await getDriver().assertComponentExist(cmp);
  const origin = await getDriver().findComponent(cmp);
  const center = await origin.getBoundsCenter();
  await getDriver().swipe(center.x, center.y, center.x + relativePoint.dx, center.y + relativePoint.dy);
  return origin;
}

// 在元素内滑动
export async function swipeIn(cmp: On, direction: Direction = 'right', offset: number = 0): Promise<Component> {
  await getDriver().assertComponentExist(cmp);
  const scrollCmp = await getDriver().findComponent(cmp);
  const center = await scrollCmp.getBoundsCenter();
  const bounds = await scrollCmp.getBounds();
  const left = (bounds.left + center.x) >> 1;
  const top = (bounds.top + center.y) >> 1;
  const bottom = (bounds.bottom + center.y) >> 1;
  const right = (bounds.right + center.x) >> 1;
  switch (direction) {
    case 'right':
      await getDriver().swipe(right, center.y, left, center.y);
      break;
    case 'left':
      await getDriver().swipe(left, center.y, right, center.y);
      break;
    case 'top':
      await getDriver().swipe(center.x, top, center.x, bottom);
      break;
    case 'bottom':
      await getDriver().swipe(center.x, bottom, center.x, top);
      break;
    case 'center':
      await getDriver().swipe(center.x - offset, center.y, center.x + offset, center.y);
      break;
    default:
      break;
  }
  return scrollCmp;
}

// 滑动并寻找元素
export async function swipeSearch(scroll: On, target: On, direction: Direction = 'right',
  retries: number = 5): Promise<Component> {
  await getDriver().waitForComponent(scroll, TestConstants.DELAY_FIVE_SECOND);
  await getDriver().assertComponentExist(scroll);
  const scrollCmp = await getDriver().findComponent(scroll);
  const center = await scrollCmp.getBoundsCenter();
  const bounds = await scrollCmp.getBounds();
  const left = (bounds.left + center.x) >> 1;
  const top = (bounds.top + center.y) >> 1;
  const bottom = (bounds.bottom + center.y) >> 1;
  const right = (bounds.right + center.x) >> 1;
  let targetCmp = await getDriver().findComponent(target);
  Log.info(TAG, `bounds:${JSON.stringify(bounds)} center: ${JSON.stringify(center)}`);
  while (retries--) {
    if (targetCmp) {
      return targetCmp;
    }
    Log.info(TAG, `scroll ${direction}`);
    switch (direction) {
      case 'right':
        await getDriver().swipe(right, center.y, left, center.y);
        break;
      case 'left':
        await getDriver().swipe(left, center.y, right, center.y);
        break;
      case 'top':
        await getDriver().swipe(center.x, top, center.x, bottom);
        break;
      case 'bottom':
        await getDriver().swipe(center.x, bottom, center.x, top);
        break;
      default:
        break;
    }
    targetCmp = await getDriver().findComponent(target);
  }
  return targetCmp;
}

// 双指放大
export async function simulateIn(
  driver: Driver,
  cmp: On,
  offset: number, // 初始手指与中心的偏移量（像素）
  duration = 1000 // 动作持续时间（毫秒）
): Promise<Component> {
  const element = await getDriver().findComponent(cmp);
  const center = await element.getBoundsCenter();
  const pointers = PointerMatrix.create(2, 3);
  const leftX = center.x - offset;
  const rightX = center.x + offset;
  const startY = center.y;

  pointers.setPoint(0, 0, { x: leftX, y: startY }); // 初始位置
  pointers.setPoint(0, 1, { x: leftX - offset, y: startY - offset }); // 中间位置
  pointers.setPoint(0, 2, { x: leftX - offset * 2, y: startY - offset * 2 }); // 最终位置
  pointers.setPoint(1, 0, { x: rightX, y: startY }); // 初始位置
  pointers.setPoint(1, 1, { x: rightX + offset, y: startY + offset }); // 中间位置
  pointers.setPoint(1, 2, { x: rightX + offset * 2, y: startY + offset * 2 }); // 最终位置
  await driver.injectMultiPointerAction(pointers, duration);
  return element;
}

// 双指缩小
export async function simulateOut(
  driver: Driver,
  cmp: On,
  offset: number, // 初始手指与中心的偏移量（像素）
  duration = 1000 // 动作持续时间（毫秒）
): Promise<Component> {
  const element = await getDriver().findComponent(cmp);
  const center = await element.getBoundsCenter();
  const pointers = PointerMatrix.create(2, 3);
  const leftX = center.x - offset;
  const rightX = center.x + offset;
  const startY = center.y;

  pointers.setPoint(0, 0, { x: leftX, y: startY }); // 初始位置
  pointers.setPoint(0, 1, { x: center.x - offset / 2, y: center.y - offset / 2 }); // 中间位置
  pointers.setPoint(0, 2, { x: center.x, y: center.y }); // 最终位置
  pointers.setPoint(1, 0, { x: rightX, y: startY }); // 初始位置
  pointers.setPoint(1, 1, { x: center.x + offset / 2, y: center.y + offset / 2 }); // 中间位置
  pointers.setPoint(1, 2, { x: center.x, y: center.y }); // 最终位置
  await driver.injectMultiPointerAction(pointers, duration);
  return element;
}

//获取连接wifi的名称
export async function getWifiConnectionName(): Promise<string> {
  wifiManager.getLinkedInfo()
    .then((linkedInfo) => {
      let len = linkedInfo.ssid.length
      wifiName = linkedInfo.ssid.substring(0, len - 1)
      Log.info(TAG, `wifiName is${wifiName}`);
    });
  return wifiName;
}

//打开设置，连接wifi
export async function ConnectionWifiClickButton(): Promise<boolean> {
  let success = false;
  try {
    await KillAccessibility();
    const driver = getDriver();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    const wifiBtn = await driver.findComponent(ON.id('wifi_entry'));
    if (wifiBtn) {
      await wifiBtn.click();
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }
    const switchBtn = await driver.findComponent(ON.id('Setting.Wlan.WlanConfig.WlanSwitch.result'));
    if (switchBtn) {
      await switchBtn.click();
      await driver.delayMs(TestConstants.DELAY_THREE_SECOND);
    }
    if (await getWifiConnectionName() !== 'WLAN') {
      Log.info(TAG, 'wifi connect success');
    }
    success = true;
  } catch (e) {
    Log.error(TAG, 'connectionWifi failed: ' + e);
  }
  return success;
}

export async function ConnectionWifi(): Promise<boolean> {
  let success = false;
  try {
    await KillAccessibility();
    const driver = getDriver();
    await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    const wifiBtn = await driver.findComponent(ON.id('wifi_entry'));
    if (wifiBtn) {
      await wifiBtn.click();
      await driver.delayMs(TestConstants.DELAY_TWO_SECOND);
    }
    if (await getWifiConnectionName() !== 'WLAN') {
      Log.info(TAG, 'open wifi connect success');
    }
    success = true;
  } catch (e) {
    Log.error(TAG, 'connectionWifi failed: ' + e);
  }
  return success;
}

export async function StartSetting(): Promise<boolean> {
  let success = false;
  try {
    await abilityDelegator.executeShellCommand(`aa force-stop ${TestConstants.SETTING_BUNDLE_NAME}`);
    await abilityDelegator.executeShellCommand(`aa start -a ${TestConstants.SETTING_MAIN_ABILITY_NAME} -b ${TestConstants.SETTING_BUNDLE_NAME}`);
    success = true;
  } catch (exception) {
    Log.info(TAG, `start failed :${exception.code} ${exception.message}`);
  } finally {
    Log.info(TAG, 'start camera application');
  }
  return success;
}

export async function screenshot(id: String): Promise<void> {
  try {
    Log.info(TAG, 'start screenshot');
    const data = new Date();
    const dateYear = data.getFullYear();
    const dateMonth = data.getMonth() + 1;
    const dateDay = data.getDate();
    const date = `${dateYear}${dateMonth < 10 ? 0 : ''}${dateMonth}${dateDay < 10 ? 0 : ''}${dateDay}`
    Log.info(TAG, 'screenshot date is:' + date);
    await abilityDelegator.executeShellCommand(`uitest screenCap -p /data/local/tmp/${date}_${id}_${Date.now()}.png`)
      .catch(() => {
        Log.error(TAG, `screenCap failed`);
      });
  } catch (exception) {
    Log.error(TAG, `screenshot failed :${exception.code}, ${exception.message}`);
  }
}