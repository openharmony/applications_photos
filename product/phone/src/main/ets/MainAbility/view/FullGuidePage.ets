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
import lazy {
  getScreen,
  isOrientationHorizontal,
  ScreenManager,
  WindowMode
} from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy router from '@ohos.router';
import lazy ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { BusinessError } from '@kit.BasicServicesKit';
import lazy { UserGuideConstants } from '@ohos/common/src/main/ets/default/model/common/UserGuideConstants';
import lazy { Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';


/* instrument ignore file */
const TAG: string = 'FullGuidePage';

@Entry
@Component
export struct FullGuidePage {
  private readonly illustration: Resource | string = $r('app.media.FullGuidePage');
  private readonly title: Resource | string = $r('app.string.enable_sync_title_31');
  private readonly subTitle: Resource | string = $r('app.string.enable_sync_content_31');
  private readonly buttonText: Resource | string = $r('app.string.start_enabled_now');
  private readonly buttonSubText: Resource | string = $r('app.string.no');
  private reSizeFunc = (): void => this.updateSize();
  private columnMargin: number = 0;
  // 垂直状态照片的宽度
  @State private horizontalPhotoWidth: number = 0;
  @State private horizontalTextButtonWidth: number = 0;
  // 图片大小
  @State private imageSize: number = 0;
  @State private isHorizontalImageSize: number = 0;
  @State private buttonVerticalWidth: number = 0;
  @State private buttonColor: ResourceColor = 0x0A59F7;
  @State private isSplitCover: boolean = false;
  @StorageLink('navigationBarHeight') private navigationBarHeight: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;

  // 深浅色模式适配
  private onColorModeChange() {
    Log.info(TAG, `currentMode is ${this.currentMode}`);
    if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.buttonColor = UserGuideConstants.BUTTON_LIGHT_COLOR;
    } else {
      this.buttonColor = UserGuideConstants.BUTTON_DARK_COLOR;
    }
  }

  aboutToAppear(): void {
    Log.info(TAG, 'fullGuidePage aboutToAppear');
    //横屏进入更新
    getScreen()?.initOrientation();
    getScreen()?.on(ScreenManager.ON_WIN_SIZE_CHANGED, this.reSizeFunc);
    //页面ui部分控件长度获取
    this.getSize();
  }

  aboutToDisappear(): void {
    Log.info(TAG, 'fullGuidePage aboutToDisappear');
    getScreen()?.off(ScreenManager.ON_WIN_SIZE_CHANGED, this.reSizeFunc);
  }

  onPageShow(): void {
    // xxx屏蔽，防止用户展开进入xxx展示引导页，此时直接跳转图库首页
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      this.jumpToPageIndex(false);
    }
  }

  /**
   * abouttoAppear获取页面控件长度
   */
  private getSize(): void {
    // xxx屏蔽，防止用户展开进入xxx展示引导页，此时直接跳转图库首页
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      this.jumpToPageIndex(false);
    }
    Log.info(TAG, 'FullGuidePage aboutToAppear get Image Size ');
    let screenWidth: number = getScreen()?.getWinWidth();
    let screenHeight: number = getScreen()?.getWinHeight();
    // 相对设备而言的绝对的宽和高
    let winWidth = this.isHorizontal ? screenHeight : screenWidth;
    let winHeight = this.isHorizontal ? screenWidth : screenHeight;
    let winHeightHalf = winHeight / UserGuideConstants.CAL_HEIGHT_DIV_NUM;
    Log.info(TAG, 'FullGuidePage getSize ab width:' + winWidth + `height:${winHeight}`);
    let winWidthHorizontalScreenPhone = (winHeight - UserGuideConstants.IMAGE_LEFT_PLUS_RIGHT) *
    UserGuideConstants.IMAGE_SCREEN_RATIO_LEFT;
    let winHeightHorizontalScreenPhone = winWidth;
    // 手机分上下和左右布局，上下布局是一定是长边的一半和短边比较计算imageSize
    // 平板只有上下布局，所以不一定是上面的计算方法，是直接根据screen接口的getWinHeight和getWinWidth计算imageSize
    if (!DeviceInfo.isPhoneUx()) {
      let screenHeightHalf: number = screenHeight / UserGuideConstants.CAL_HEIGHT_DIV_NUM;
      this.imageSize = screenWidth < screenHeightHalf ?
        screenWidth * UserGuideConstants.IMAGE_SCREEN_RATIO : screenHeightHalf * UserGuideConstants.IMAGE_SCREEN_RATIO;
    } else {
      this.imageSize = winWidth < winHeightHalf ? winWidth * UserGuideConstants.IMAGE_SCREEN_RATIO :
        winHeightHalf * UserGuideConstants.IMAGE_SCREEN_RATIO;
    }
    this.isHorizontalImageSize = (winHeightHorizontalScreenPhone > winWidthHorizontalScreenPhone) ?
      (winWidthHorizontalScreenPhone * UserGuideConstants.IMAGE_SCREEN_RATIO) :
      (winHeightHorizontalScreenPhone * UserGuideConstants.IMAGE_SCREEN_RATIO);

    // 竖屏单按钮宽度计算
    this.buttonVerticalWidth = this.getVerticalButtonWidth();
    Log.info(TAG, `getSize buttonVertical Width${this.buttonVerticalWidth}`);
    // 栅格布局得到左右的padding值
    this.columnMargin = getScreen()?.getColumnMargin();
    // 主题获取更改按钮颜色
    this.onColorModeChange();
    // 分屏遮挡模式适配
    if (this.isSplitModeCover()) {
      this.isSplitCover = true;
      this.splitModeCoverUpdateSize();
    } else {
      this.isSplitCover = false;
    }
  }

  // 分屏模式ui组件宽度计算
  private splitModeCoverUpdateSize(): void {
    Log.info(TAG, `updateSize-splitModeCoverUpdateSize Orientation: ${this.isHorizontal}`);
    // imageSize计算
    let winWidth = getScreen().getWinWidth();
    let winHeight = getScreen().getWinHeight();
    let winWidthHorizontalScreenPhone = (winWidth - UserGuideConstants.IMAGE_LEFT_PLUS_RIGHT) *
    UserGuideConstants.IMAGE_SCREEN_RATIO_LEFT;
    let winHeightHorizontalScreenPhone = winHeight;
    this.isHorizontalImageSize = (winHeightHorizontalScreenPhone > winWidthHorizontalScreenPhone) ?
      (winWidthHorizontalScreenPhone * UserGuideConstants.IMAGE_SCREEN_RATIO) :
      (winHeightHorizontalScreenPhone * UserGuideConstants.IMAGE_SCREEN_RATIO);
    // 40%和60%宽度计算
    Log.info(TAG, `splitModeCover-getPhotoWidth orientation isHorization: ${this.isHorizontal}
      winWidth: ${getScreen()?.getWinWidth()} winHeight ${getScreen()?.getWinHeight()}`);
    let width: number = getScreen()?.getWinWidth();
    this.horizontalPhotoWidth = (width - UserGuideConstants.HORIZONTAL_PADDING *
    UserGuideConstants.HORIZONTAL_COLUMN_NUM) * UserGuideConstants.IMAGE_SCREEN_RATIO_LEFT;
    this.horizontalTextButtonWidth = (width - UserGuideConstants.HORIZONTAL_PADDING *
    UserGuideConstants.HORIZONTAL_COLUMN_NUM) *
      (1 - UserGuideConstants.IMAGE_SCREEN_RATIO_LEFT);
    Log.info(TAG, `splitModeCover-getPartWidth 40%: ${this.horizontalPhotoWidth}`);
  }

  /**
   * 处理分屏模式下出现的遮挡问题，判断是否为分屏模式且出现了按钮和文字的遮挡
   * 全屏引导因文字过多导致横屏分屏模式也许计算
   * @returns true:有遮挡问题; false:无遮挡问题
   */
  private isSplitModeCover(): boolean {
    if (getScreen().getWinMode() === WindowMode.FULLSCREEN) {
      return false;
    }

    let upperHalfHeight: number = UserGuideConstants.ACTIONBAR_HEIGHT + px2vp(this.statusBarHeight) +
    this.imageSize + UserGuideConstants.IMAGE_TEXT_PADDING + UserGuideConstants.TITLE_SUBTITLE_PADDING +
    UserGuideConstants.TITLE_TEXT_SIZE + UserGuideConstants.SUBTITLE_TEXT_SIZE *
    UserGuideConstants.CAL_BUTTON_WIDTH_MUL_NUM;

    let lowerHalfHeight: number = px2vp(this.navigationBarHeight) + UserGuideConstants.NAVIGATION_BUTTON_SPACE +
      UserGuideConstants.BUTTON_HEIGHT * UserGuideConstants.CAL_BUTTON_WIDTH_MUL_NUM +
    UserGuideConstants.BUTTON_INDICATOR_SPACE;
    Log.info(TAG, 'updateSize isSplitMode upperHeight: ' +
      upperHalfHeight + ' lowerHeight: ' + lowerHalfHeight + ' winHeight: ' + getScreen().getWinHeight());
    if (upperHalfHeight + lowerHalfHeight >= getScreen().getWinHeight()) {
      return true;
    }
    return false;
  }

  /**
   * 区分分屏悬浮窗模式按钮宽度计算方法，分屏悬浮窗下默认竖屏计算
   * @returns 屏幕宽度
   */
  private getScreenWidth(): number {
    let screenWidth: number = 0;
    if (getScreen().getWinMode() !== WindowMode.FLOATING && getScreen().getWinMode() !== WindowMode.UNDEFINED) {
      screenWidth = this.isHorizontal ? getScreen()?.getWinHeight() : getScreen()?.getWinWidth();
    } else {
      screenWidth = getScreen().getWinWidth();
    }
    return screenWidth;
  }

  /**
   * 获取垂直态按钮宽度
   * @returns
   */
  private getVerticalButtonWidth(): number {
    let buttonWidth: number = this.getScreenWidth() -
      UserGuideConstants.CAL_BUTTON_WIDTH_MUL_NUM * getScreen()?.getColumnMargin();
    Log.info(TAG, `getVerticalPhotoWidth orientation isHorization: ${this.isHorizontal}
      bWidth: ${buttonWidth} winWidth:${getScreen()?.getWinWidth()}
      winHeight: ${getScreen()?.getWinHeight()} columnMargin: ${getScreen()?.getColumnMargin()}`);
    return buttonWidth > UserGuideConstants.MAX_BUTTON_WIDTH ? UserGuideConstants.MAX_BUTTON_WIDTH : buttonWidth;
  }

  /**
   * 页面刷新更新组件宽高
   */
  updateSize(): void {
    // xxx屏蔽，防止用户展开进入xxx展示引导页，此时直接跳转图库首页
    /* instrument ignore next */
    if (DeviceInfo.isVerdeFoldable()) {
      this.jumpToPageIndex(false);
    }
    // 初始化设备方向
    getScreen()?.initOrientation();
    Log.info(TAG, `updateSize Orientation: ${this.isHorizontal}`);
    let screenWidth: number = getScreen()?.getWinWidth();
    let screenHeight: number = getScreen()?.getWinHeight();
    // 相对设备而言的绝对的宽和高
    let winWidth = this.isHorizontal ? screenHeight : screenWidth;
    let winHeight = this.isHorizontal ? screenWidth : screenHeight;
    let winHeightHalf = winHeight / UserGuideConstants.CAL_HEIGHT_DIV_NUM;
    Log.info(TAG, 'FullGuide getSize ab width:' + winWidth + `height:${winHeight}`);
    let winWidthHorizontalScreenPhone = (winHeight - UserGuideConstants.IMAGE_LEFT_PLUS_RIGHT) *
    UserGuideConstants.IMAGE_SCREEN_RATIO_LEFT;
    let winHeightHorizontalScreenPhone = winWidth;
    // 手机分上下和左右布局，上下布局是一定是长边的一半和短边比较计算imageSize
    // 平板只有上下布局，所以不一定是上面的计算方法，是直接根据screen接口的getWinHeight和getWinWidth计算imageSize
    if (!DeviceInfo.isPhoneUx()) {
      let screenHeightHalf: number = screenHeight / UserGuideConstants.CAL_HEIGHT_DIV_NUM;
      this.imageSize = screenWidth < screenHeightHalf ?
        screenWidth * UserGuideConstants.IMAGE_SCREEN_RATIO : screenHeightHalf * UserGuideConstants.IMAGE_SCREEN_RATIO;
    } else {
      this.imageSize = winWidth < winHeightHalf ?
        winWidth * UserGuideConstants.IMAGE_SCREEN_RATIO : winHeightHalf * UserGuideConstants.IMAGE_SCREEN_RATIO;
    }
    this.isHorizontalImageSize = (winHeightHorizontalScreenPhone > winWidthHorizontalScreenPhone) ?
      (winWidthHorizontalScreenPhone * UserGuideConstants.IMAGE_SCREEN_RATIO) :
      (winHeightHorizontalScreenPhone * UserGuideConstants.IMAGE_SCREEN_RATIO);
    //栅格布局得到左右的padding值
    this.columnMargin = getScreen()?.getColumnMargin();
    getScreen()?.initOrientation();
    this.buttonVerticalWidth = this.getVerticalButtonWidth();
    Log.info(TAG, `updateSize buttonVerticalWidth: ${this.buttonVerticalWidth}`);
    // 横屏40%和60%宽度计算
    this.getHorizontalPartWidth();
    if (this.isSplitModeCover()) {
      this.isSplitCover = true;
      this.splitModeCoverUpdateSize();
    } else {
      this.isSplitCover = false;
    }
  }

  /**
   * 横屏宽度计算
   */
  private getHorizontalPartWidth() {
    Log.info(TAG, `getHorizontalPhotoWidth orientation isHorization: ${this.isHorizontal}
      winWidth: ${getScreen()?.getWinWidth()} winHeight ${getScreen()?.getWinHeight()}`);
    let width: number = this.isHorizontal ? getScreen()?.getWinWidth() : getScreen()?.getWinHeight();
    this.horizontalPhotoWidth = (width - UserGuideConstants.HORIZONTAL_PADDING *
    UserGuideConstants.HORIZONTAL_COLUMN_NUM) * UserGuideConstants.IMAGE_SCREEN_RATIO_LEFT;
    this.horizontalTextButtonWidth = (width - UserGuideConstants.HORIZONTAL_PADDING *
    UserGuideConstants.HORIZONTAL_COLUMN_NUM) *
      (1 - UserGuideConstants.IMAGE_SCREEN_RATIO_LEFT);
    Log.info(TAG, `getHorizontalPartWidth 40%: ${this.horizontalPhotoWidth}`);
  }

  build() {
    Stack() {
      Column() {
        if (this.isSplitCover) {
          this.buildCoverVerticalMain();
        } else if ((DeviceInfo.isFoldablePhone() && (DeviceInfo.isFoldable() ||
          (!DeviceInfo.isFoldable() && !this.isHorizontal))) || DeviceInfo.isTablet() ||
          (DeviceInfo.isPhoneUx() && !this.isHorizontal)) {
          this.buildVerticalMain();
        } else {
          this.buildHorizontalMain();
        }
      }
      .height(Constants.PERCENT_100).width(Constants.PERCENT_100).borderWidth(1)
    }
    .height(Constants.PERCENT_100)
    .width(Constants.PERCENT_100)
    .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    .backgroundColor($r('sys.color.background_secondary'))
  }

  @Builder
  buildCover() {
    Column() {
      this.buildHorizontalMainPagePic();
    }
    .height(Constants.PERCENT_100)
    .width(this.horizontalPhotoWidth)
    .borderWidth(0)
    .margin({ left: UserGuideConstants.HORIZONTAL_PADDING })
    .justifyContent(FlexAlign.Center)

    Column() {
    }.width(UserGuideConstants.HORIZONTAL_PADDING).height(Constants.PERCENT_100).borderWidth(0)

    this.buildHorizontalTextAndButton();
  }

  @Builder
  buildCoverVerticalMain() {
    Row() {
      this.buildCover();
    }
    .margin({ bottom: px2vp(this.navigationBarHeight) })
    .alignItems(VerticalAlign.Center)
    .borderWidth(0)
  }

  @Builder
  buildHorizontalPhoto() {
    Image(this.illustration)
      .draggable(false)
      .width(this.isHorizontalImageSize)
      .height(this.isHorizontalImageSize)
      .onComplete((): void => {
        Log.info(TAG, `buildVerticalPhotoIco onComplete imageSize:${this.imageSize}`);
      })
  }

  @Builder
  buildHorizontalButton() {
    Column() {
      Button() {
        Row() {
          Text(this.buttonText)
            .fontColor(Color.White).maxFontScale(2);
        }.alignItems(VerticalAlign.Center)
      }
      .onClick((): void => {
        // 跳转首页展示设置页
        this.jumpToPageIndex(true);
      })
      .width(this.horizontalTextButtonWidth)
      .height(UserGuideConstants.BUTTON_HEIGHT)
      .margin({
        bottom: this.isSplitCover ? UserGuideConstants.ZERO_WIDTH : UserGuideConstants.BUTTON_BOTTOM,
      })
      .backgroundColor(this.buttonColor)
      .borderRadius(UserGuideConstants.BUTTON_RADIUS)

      Button() {
        Row() {
          Text(this.buttonSubText)
            .fontColor(this.buttonColor).maxFontScale(2);
        }.alignItems(VerticalAlign.Center)
      }
      .onClick((): void => {
        // 跳转首页
        this.jumpToPageIndex()
      })
      .width(this.horizontalTextButtonWidth)
      .height(UserGuideConstants.BUTTON_HEIGHT)
      .backgroundColor(Color.Transparent)
      .borderRadius(UserGuideConstants.BUTTON_RADIUS)
      .margin({
        bottom: this.isSplitCover ?
        UserGuideConstants.ZERO_WIDTH : UserGuideConstants.BUTTON_BOTTOM_NAVIGATION
      })
    }
    .justifyContent(FlexAlign.Center)
    .position({ bottom: 0 })
    .width(Constants.PERCENT_100)
  }

  @Builder
  buildHorizontalMainPagePic() {
    Column() {
      this.buildHorizontalPhoto();
    }
    .width(this.horizontalPhotoWidth)
    .height(Constants.PERCENT_100)
    .justifyContent(FlexAlign.Center)
    .borderWidth(0)
  }

  @Builder
  buildHorizontalTextAndButton() {
    Column() {
      Text(this.title)
        .fontWeight(FontWeight.Medium)
        .draggable(false)
        .maxFontScale(2)
        .fontSize(this.isSplitCover ? $r('sys.float.Caption_M') : $r('sys.float.Title_S'))
        .fontFamily($r('app.string.id_text_font_family_medium'))
        .fontColor($r('sys.color.font_primary'))
        .textAlign(TextAlign.Center)
        .margin({ bottom: $r('sys.float.padding_level4'), })

      Text(this.subTitle)
        .fontWeight(FontWeight.Regular)
        .draggable(false)
        .maxFontScale(2)
        .fontSize(this.isSplitCover ? $r('sys.float.Caption_M') : $r('sys.float.Body_M'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.font_secondary'))
        .textAlign(TextAlign.Center)

      this.buildHorizontalButton();
    }
    .width(this.horizontalTextButtonWidth)
    .height(Constants.PERCENT_100)
    .margin({ right: UserGuideConstants.HORIZONTAL_PADDING })
    .borderWidth(0)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  buildHorizontalPage() {
    Column() {
      this.buildHorizontalMainPagePic();
    }
    .height(Constants.PERCENT_100)
    .width(this.horizontalPhotoWidth)
    .borderWidth(0)
    .margin({ left: UserGuideConstants.HORIZONTAL_PADDING })
    .justifyContent(FlexAlign.Center)

    Column() {
    }.width(UserGuideConstants.HORIZONTAL_PADDING).height(Constants.PERCENT_100).borderWidth(0)

    this.buildHorizontalTextAndButton();
  }

  @Builder
  buildHorizontalMain() {
    Row() {
      this.buildHorizontalPage();
    }
    .margin({ bottom: px2vp(this.navigationBarHeight) })
    .alignItems(VerticalAlign.Center)
    .borderWidth(0)
  }

  @Builder
  buildVerticalMain() {
    Column() {
      this.buildVerticalPhotoAndButton();
    }
    .borderWidth(0)
    .margin({
      top: UserGuideConstants.ACTIONBAR_HEIGHT + px2vp(this.statusBarHeight),
      bottom: px2vp(this.navigationBarHeight),
    })
  }

  @Builder
  buildVerticalPhotoAndButton() {
    Column() {
      Column() {
        this.buildVerticalPhoto();
        this.buildVerticalText();
      }
      .position({ top: 0 })
      .width(Constants.PERCENT_100)
      .borderWidth(0)

      this.buildVerticalButton();
    }
    .height(Constants.PERCENT_100)
    .width(Constants.PERCENT_100)
    .borderWidth(0)
  }

  @Builder
  buildVerticalPhoto() {
    Column() {
      Image(this.illustration)
        .draggable(false)
        .width(this.imageSize)
        .height(this.imageSize)
        .onComplete((): void => {
          Log.info(TAG, `buildVerticalPhotoIco onComplete:${this.imageSize}`);
        })
    }
    .margin({
      bottom: $r('app.float.image_margin_horizontal'),
    })
  }

  @Builder
  buildVerticalText() {
    Column() {
      Text(this.title)
        .fontWeight(FontWeight.Medium)
        .draggable(false)
        .maxFontScale(2)
        .fontSize($r('sys.float.Title_S'))
        .fontFamily($r('app.string.id_text_font_family_medium'))
        .fontColor($r('sys.color.font_primary'))
        .textAlign(TextAlign.Center)
        .margin({
          bottom: $r('sys.float.padding_level4'),
          left: this.columnMargin,
          right: this.columnMargin,
        })
      Text(this.subTitle)
        .fontWeight(FontWeight.Regular)
        .draggable(false)
        .maxFontScale(2)
        .fontSize($r('sys.float.Body_M'))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.font_secondary'))
        .textAlign(TextAlign.Center)
        .margin({
          left: this.columnMargin,
          right: this.columnMargin,
        })
    }
  }

  @Builder
  buildVerticalButton() {
    Column() {
      Button() {
        Row() {
          Text(this.buttonText)
            .fontColor(Color.White).maxFontScale(2)
        }.alignItems(VerticalAlign.Center)
      }
      .onClick((): void => {
        this.jumpToPageIndex(true)
      })
      .width(this.buttonVerticalWidth)
      .height(UserGuideConstants.BUTTON_HEIGHT)
      .margin({
        left: this.columnMargin,
        right: this.columnMargin,
        bottom: UserGuideConstants.BUTTON_INDICATOR_SPACE,
      })
      .backgroundColor(this.buttonColor)
      .borderRadius(UserGuideConstants.BUTTON_RADIUS)

      Button() {
        Row() {
          Text(this.buttonSubText)
            .fontColor(this.buttonColor).maxFontScale(2)
        }.alignItems(VerticalAlign.Center)
      }
      .onClick((): void => {
        this.jumpToPageIndex()
      })
      .width(this.buttonVerticalWidth)
      .height(UserGuideConstants.BUTTON_HEIGHT)
      .margin({
        left: this.columnMargin,
        right: this.columnMargin,
        bottom: UserGuideConstants.NAVIGATION_BUTTON_SPACE,
      })
      .backgroundColor(Color.Transparent)
      .borderRadius(UserGuideConstants.BUTTON_RADIUS)
    }
    .position({ bottom: 0 })
    .width(Constants.PERCENT_100)
    .justifyContent(FlexAlign.Center)
    .borderWidth(0)
  }

  // 跳转首页
  jumpToPageIndex(isShowSettingPage?: boolean) {
    clickFullGuide(true);
    if (isShowSettingPage) {
      Log.info(TAG, 'FullGuidePage showsettingPage');
      AppStorage.setOrCreate<boolean>('enterSettingPage', true);
    }
    router.replaceUrl({
      url: 'MainAbility/view/index',
    })
  }
}

async function clickFullGuide(isGuided: boolean) {
  await Protocol.set(Constants.FULL_SCREEN_GUIDE, isGuided);
}