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
import lazy {
  UserGuideConstants,
  UserGuideDataSource,
  UserGuideInfo
} from '@ohos/common/src/main/ets/default/model/common/UserGuideConstants';
import lazy { Protocol } from '@ohos/tools/src/main/variables/PrivacyGlobal';
import lazy { FontUtil } from '@ohos/common/src/main/ets/default/utils/FontUtil';

/* instrument ignore file */
const TAG: string = 'UserGuidePage';

@Entry
@Component
export struct UserGuidePage {
  private readonly photoFullViewing: UserGuideInfo = {
    illustration: $r('app.media.PhotoFullViewing'),
    title: $r('app.string.grid_layout_tips'),
    subTitle: $r('app.string.grid_layout_description_tips'),
    buttonText: $r('app.string.skip_action'),
    buttonType: 0,
  };
  private readonly albumSorting: UserGuideInfo = {
    illustration: $r('app.media.AlbumSorting'),
    title: $r('app.string.intelligent_classification_tips'),
    subTitle: $r('app.string.intelligent_classification_description_tips'),
    buttonText: $r('app.string.skip_action'),
    buttonType: 0,
  };
  private readonly imageAiEditing: UserGuideInfo = {
    illustration: $r('app.media.ImageAiEditing'),
    title: $r('app.string.easy_editing_tips'),
    subTitle: $r('app.string.easy_editing_description_tips'),
    buttonText: $r('app.string.experienc_tips'),
    buttonType: 1,
  };
  private swiperController: SwiperController = new SwiperController();
  // 数据
  private data: UserGuideDataSource = new UserGuideDataSource([]);
  private reSizeFunc = (): void => this.updateSize();
  private columnMargin: number = 0;
  // 垂直状态照片的宽度
  @State private horizontalPhotoWidth: number = 0;
  @State private horizontalTextButtonWidth: number = 0;
  // 图片大小
  @State private imageSize: number = 0;
  @State private isHorizontalImageSize: number = 0;
  @State private buttonVerticalWidth: number = 0;
  // 当前位置
  @State private currentIndex: number = 0;
  @State private buttonColor: ResourceColor = 0x0A59F7;
  @State private isSplitCover: boolean = false;
  @StorageLink('navigationBarHeight') private navigationBarHeight: number = 0;
  @StorageLink('isHorizontal') isHorizontal: boolean = isOrientationHorizontal();
  @StorageLink('getFoldStatus') private isFoldExpanded: boolean = DeviceInfo.isFoldable();
  @StorageProp('currentColorMode') @Watch('onColorModeChange') currentMode: ConfigurationConstant.ColorMode =
    ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  @StorageLink('statusBarHeight') statusBarHeight: number = 0;
  // 当前是否安装云空间
  @StorageLink('IsCloudDriveInstalled') isCloudDriveInstalled: boolean = false;
  // 是否展示云空间引导开启海报
  private isShowEnableSplash: boolean = false;
  // verde外屏适配
  @State private isVerdeFoldable: boolean = DeviceInfo.isVerdeFoldable();
  // 获取系统字体
  @StorageProp('currentFontSizeScale') private currentFontSizeScale: number = 1;
  @State buttonHeight: number = 0;
  @StorageLink('isOpenTouchGuide') private isOpenTouchGuide: boolean = false;
  // 深浅色模式适配
  private onColorModeChange() {
    Log.info(TAG, `currentMode is ${this.currentMode}`)
    if (this.currentMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.buttonColor = UserGuideConstants.BUTTON_LIGHT_COLOR;
    } else {
      this.buttonColor = UserGuideConstants.BUTTON_DARK_COLOR;
    }
  }

  aboutToAppear(): void {
    //横屏进入更新
    getScreen()?.initOrientation();
    getScreen()?.on(ScreenManager.ON_WIN_SIZE_CHANGED, this.reSizeFunc);
    //页面ui部分控件长度获取
    this.getSize();
    //数据初始化
    let propList: UserGuideInfo[] = [this.photoFullViewing, this.albumSorting, this.imageAiEditing];
    this.data = new UserGuideDataSource(propList);
  }

  aboutToDisappear(): void {
    getScreen()?.off(ScreenManager.ON_WIN_SIZE_CHANGED, this.reSizeFunc);
  }

  /**
   * abouttoAppear获取页面控件长度
   */
  private getSize(): void {
    Log.info(TAG, 'UserGuidePage aboutToAppear get Image Size ')
    let screenWidth: number = getScreen()?.getWinWidth();
    let screenHeight: number = getScreen()?.getWinHeight();
    // 相对设备而言的绝对的宽和高
    let winWidth = this.isHorizontal ? screenHeight : screenWidth;
    let winHeight = this.isHorizontal ? screenWidth : screenHeight;
    let winHeightHalf = winHeight / UserGuideConstants.CAL_HEIGHT_DIV_NUM;
    Log.info(TAG, 'welcome getSize ab width:' + winWidth + `height:${winHeight}`)
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
    // 横屏40%和60%宽度计算
    this.getHorizontalPartWidth();
    // 栅格布局得到左右的padding值
    this.columnMargin = getScreen()?.getColumnMargin();
    // 主题获取更改按钮颜色
    this.onColorModeChange();
    // xxx适配
    if (this.isSplitModeCover()) {
      this.isSplitCover = true;
      this.splitModeCoverUpdateSize();
    } else {
      this.isSplitCover = false;
    }
  }

  /**
   * 页面刷新更新组件宽高
   */
  updateSize(): void {
    // 初始化设备方向
    getScreen()?.initOrientation();
    Log.info(TAG, `updateSize Orientation: ${this.isHorizontal}`);
    let screenWidth: number = getScreen()?.getWinWidth();
    let screenHeight: number = getScreen()?.getWinHeight();
    // 相对设备而言的绝对的宽和高
    let winWidth = this.isHorizontal ? screenHeight : screenWidth;
    let winHeight = this.isHorizontal ? screenWidth : screenHeight;
    let winHeightHalf = winHeight / UserGuideConstants.CAL_HEIGHT_DIV_NUM;
    Log.info(TAG, 'welcome getSize ab width:' + winWidth + `height:${winHeight}`);
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
    Log.info(TAG, `updateSize isCover?:${this.isSplitModeCover()}`);
    // 横屏40%和60%宽度计算
    this.getHorizontalPartWidth();
    if (this.isSplitModeCover()) {
      this.isSplitCover = true;
      this.splitModeCoverUpdateSize();
    } else {
      this.isSplitCover = false;
    }
    // veder状态更新
    this.isVerdeFoldable = DeviceInfo.isVerdeFoldable();
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
      winWidth: ${getScreen()?.getWinWidth()} winHeight ${getScreen()?.getWinHeight()}`)
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
   * @returns true:有遮挡问题; false:无遮挡问题
   */
  private isSplitModeCover(): boolean {
    if (this.isHorizontal || getScreen().getWinMode() !== WindowMode.PRIMARY) {
      return false;
    }

    let upperHalfHeight: number = UserGuideConstants.ACTIONBAR_HEIGHT + px2vp(this.statusBarHeight) +
    this.imageSize + UserGuideConstants.IMAGE_TEXT_PADDING + UserGuideConstants.TITLE_SUBTITLE_PADDING +
    UserGuideConstants.TITLE_TEXT_SIZE + UserGuideConstants.SUBTITLE_TEXT_SIZE;

    let lowerHalfHeight: number = px2vp(this.navigationBarHeight) + UserGuideConstants.NAVIGATION_BUTTON_SPACE +
    UserGuideConstants.BUTTON_HEIGHT + UserGuideConstants.BUTTON_INDICATOR_SPACE + UserGuideConstants.INDICATOR_WIDTH;
    Log.info(TAG, 'updateSize isSplitMode upperHeight: ' +
      upperHalfHeight + ' lowerHeight: ' + lowerHalfHeight + ' winHeight: ' + getScreen().getWinHeight());
    if (upperHalfHeight + lowerHalfHeight >= getScreen().getWinHeight()) {
      return true;
    }
    return false;
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
   * 横屏宽度计算
   */
  private getHorizontalPartWidth() {
    Log.info(TAG, `getHorizontalPhotoWidth orientation isHorization: ${this.isHorizontal}
      winWidth: ${getScreen()?.getWinWidth()} winHeight ${getScreen()?.getWinHeight()}`)
    let width: number = this.isHorizontal ? getScreen()?.getWinWidth() : getScreen()?.getWinHeight();
    this.horizontalPhotoWidth = (width - UserGuideConstants.HORIZONTAL_PADDING *
    UserGuideConstants.HORIZONTAL_COLUMN_NUM) * UserGuideConstants.IMAGE_SCREEN_RATIO_LEFT;
    this.horizontalTextButtonWidth = (width - UserGuideConstants.HORIZONTAL_PADDING *
    UserGuideConstants.HORIZONTAL_COLUMN_NUM) *
      (1 - UserGuideConstants.IMAGE_SCREEN_RATIO_LEFT);
    Log.info(TAG, `getHorizontalPartWidth 40%: ${this.horizontalPhotoWidth}`);
  }

  @Builder
  buildVerticalPhoto(item: UserGuideInfo) {
    Column() {
      Image(item.illustration)
        .draggable(false)
        .width(this.imageSize)
        .height(this.imageSize)
        .onComplete((): void => {
          Log.info(TAG, `buildVerticalPhotoIco onComplete:${this.imageSize}`)
        })
    }
    .margin({
      bottom: this.isVerdeFoldable ? UserGuideConstants.PHOTO_TEXT_MARGIN : $r('app.float.image_margin_horizontal'),
    })
  }

  @Builder
  buildVerticalText(item: UserGuideInfo) {
    Column() {
      Text(item.title)
        .fontWeight(FontWeight.Medium)
        .draggable(false)
        .fontSize(FontUtil.getLimitedTextMagnification(this.currentFontSizeScale, FontUtil.LARGE_FONT_SIZE,
          $r('sys.float.Title_S')))
        .fontFamily($r('app.string.id_text_font_family_medium'))
        .fontColor($r('sys.color.font_primary'))
        .textAlign(TextAlign.Center)
        .margin({
          bottom: this.isVerdeFoldable ? UserGuideConstants.PHOTO_TEXT_MARGIN : $r('sys.float.padding_level4'),
          left: this.isVerdeFoldable ? UserGuideConstants.ZERO_WIDTH : this.columnMargin,
          right: this.isVerdeFoldable ? UserGuideConstants.ZERO_WIDTH : this.columnMargin,
        })
      Text(item.subTitle)
        .fontWeight(FontWeight.Regular)
        .draggable(false)
        .fontSize(FontUtil.getLimitedTextMagnification(this.currentFontSizeScale, FontUtil.LARGE_FONT_SIZE,
          $r('sys.float.Body_M')))
        .fontFamily($r('app.string.id_text_font_family_regular'))
        .fontColor($r('sys.color.font_secondary'))
        .textAlign(TextAlign.Center)
        .margin({
          left: this.isVerdeFoldable ? UserGuideConstants.ZERO_WIDTH : this.columnMargin,
          right: this.isVerdeFoldable ? UserGuideConstants.ZERO_WIDTH : this.columnMargin,
        })
    }
  }

  @Builder
  buildVerticalSwiperAndButton() {
    Column() {
      Swiper(this.swiperController) {
        LazyForEach(this.data, (item: UserGuideInfo) => {
          this.buildVerticalSwiperAndButtonMain(item);
        }, (item: string) => item)
      }
      .index(this.currentIndex)
      .indicator(
        new DotIndicator()
          .itemWidth(UserGuideConstants.INDICATOR_WIDTH)
          .itemHeight(UserGuideConstants.INDICATOR_WIDTH)
          .selectedItemWidth(UserGuideConstants.INDICATOR_SELECTED_WIDTH)
          .selectedItemHeight(UserGuideConstants.INDICATOR_WIDTH)
          .color(Color.Grey)
          .selectedColor(this.buttonColor)
          .bottom(this.buttonHeight + UserGuideConstants.BUTTON_INDICATOR_SPACE))
      .onChange((index: number) => {
        this.currentIndex = index;
      })
      .autoPlay(this.isOpenTouchGuide ? false : true)
      .loop(false)
      .width(Constants.PERCENT_100)
      .interval(UserGuideConstants.SWIPER_AUTOPLAY_INTERVAL)
      .curve(Curve.Friction)
      .duration(UserGuideConstants.SWIPER_DURATION)

      this.buildVerticalButton();
    }
    .height(Constants.PERCENT_100).borderWidth(0)
  }

  @Builder
  buildVerticalSwiperAndButtonMain(item: UserGuideInfo) {
    Column() {
      Column() {
        this.buildVerticalPhoto(item);
        this.buildVerticalText(item);
      }
      .position({ top: 0 })
      .width(Constants.PERCENT_100)
    }
    .buildPercentHundred()
    .justifyContent(FlexAlign.Center)
  }

  @Styles
  buildPercentHundred() {
    .height(Constants.PERCENT_100)
    .width(Constants.PERCENT_100)
  }

  @Builder
  buildVerticalButton() {
    Column() {
      Button() {
        Row() {
          Text((this.currentIndex == 2 ? this.imageAiEditing.buttonText : this.albumSorting.buttonText) as string)
            .fontColor(this.currentIndex == 2 ? Color.White : this.buttonColor)
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.Body_L'))
            .maxFontScale(2.0)
        }.alignItems(VerticalAlign.Center)
      }
      .onClick((): void => {
        // 展示引导开启海报, 屏蔽模拟器/隐私空间/演示样机
        // if (this.isShowEnableSplash && !DeviceInfo.isEmulator() && this.isCloudDriveInstalled &&
        //   !DeviceInfo.isPrototypeAdu() && !DeviceInfo.isPrototypeLdu()) {
        //   this.jumpToPageCloudSplash();
        // } else {
          // 否则跳转首页
          this.jumpToPageIndex();
        // }
      })
      .width(this.buttonVerticalWidth)
      .constraintSize({ minHeight: UserGuideConstants.BUTTON_HEIGHT })
      .margin({
        left: $r('app.float.dialog_double_buttons_margin_right'),
        right: $r('app.float.dialog_double_buttons_margin_left'),
        bottom: UserGuideConstants.NAVIGATION_BUTTON_SPACE,
      })
      .backgroundColor(this.currentIndex == 2 ? this.buttonColor : Color.Transparent)
      .borderRadius(UserGuideConstants.BUTTON_RADIUS)
    }
    .onAreaChange((_, newValue) => {
      this.buttonHeight = newValue.height as number
    })
    .position({ bottom: 0 })
    .width(Constants.PERCENT_100)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  buildHorizontalPhoto(item: UserGuideInfo) {
    Image(item.illustration)
      .draggable(false)
      .width(this.isHorizontalImageSize)
      .height(this.isHorizontalImageSize)
      .onComplete((): void => {
        Log.info(TAG, `buildVerticalPhotoIco onComplete imageSize:${this.imageSize}`)
      })
  }

  @Builder
  buildHorizontalSwiper() {
    Column() {
      this.buildHorizontalMainSwiper();
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
  buildHorizontalMainSwiper() {
    Swiper(this.swiperController) {
      LazyForEach(this.data, (item: UserGuideInfo) => {
        this.buildHorizontalSwiperMain(item);
      }, (item: string) => item)
    }
    .index(this.currentIndex)
    .indicator(new DotIndicator()
      .itemWidth(UserGuideConstants.INDICATOR_WIDTH)
      .itemHeight(UserGuideConstants.INDICATOR_WIDTH)
      .selectedItemWidth(UserGuideConstants.INDICATOR_SELECTED_WIDTH)
      .selectedItemHeight(UserGuideConstants.INDICATOR_WIDTH)
      .color(Color.Grey)
      .selectedColor(this.buttonColor)
      .bottom(UserGuideConstants.INDICATOR_HORIZONTAL_BOTTOM_PADDING))
    .onChange((index: number) => {
      this.currentIndex = index;
    })
    .autoPlay(this.isOpenTouchGuide ? false : true)
    .loop(false)
    .borderWidth(0)
    .interval(UserGuideConstants.SWIPER_AUTOPLAY_INTERVAL)
    .curve(Curve.Friction)
    .duration(UserGuideConstants.SWIPER_DURATION)
  }

  @Builder
  buildHorizontalSwiperMain(item: UserGuideInfo) {
    Column() {
      this.buildHorizontalPhoto(item);
    }
    .width(this.horizontalPhotoWidth)
    .height(Constants.PERCENT_100)
    .justifyContent(FlexAlign.Center)
    .borderWidth(0)
  }

  @Builder
  buildHorizontalTextAndButton() {
    Column() {
      Text(this.data.getData(this.currentIndex).title)
        .fontWeight(FontWeight.Medium)
        .draggable(false)
        .fontSize(FontUtil.getLimitedTextMagnification(this.currentFontSizeScale, FontUtil.LARGE_FONT_SIZE,
          $r('sys.float.Title_S')))
        .fontFamily($r('app.string.id_text_font_family_medium'))
        .fontColor($r('sys.color.font_primary'))
        .textAlign(TextAlign.Center)
        .margin({ bottom: $r('sys.float.padding_level4'), })

      Text(this.data.getData(this.currentIndex).subTitle)
        .fontWeight(FontWeight.Regular)
        .draggable(false)
        .fontSize(FontUtil.getLimitedTextMagnification(this.currentFontSizeScale, FontUtil.LARGE_FONT_SIZE,
          $r('sys.float.Body_M')))
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
  buildHorizontalButton() {
    Row() {
      Button() {
        Row() {
          Text(this.data.getData(this.currentIndex).buttonText as string)
            .fontColor(this.currentIndex == 2 ? Color.White : this.buttonColor)
            .fontSize(FontUtil.getLimitedTextMagnification(this.currentFontSizeScale, FontUtil.LARGE_FONT_SIZE,
              $r('sys.float.Body_L')))
        }.alignItems(VerticalAlign.Center)
      }
      .onClick((): void => {
        // 展示引导开启海报, 屏蔽模拟器/演示样机
        if (this.isShowEnableSplash && !DeviceInfo.isEmulator() && this.isCloudDriveInstalled &&
          !DeviceInfo.isPrototypeAdu() && !DeviceInfo.isPrototypeLdu()) {
          this.jumpToPageCloudSplash();
        } else {
          // 否则跳转首页
          this.jumpToPageIndex();
        }
      })
      .width(this.horizontalTextButtonWidth)
      .height(UserGuideConstants.BUTTON_HEIGHT)
      .margin({
        bottom: UserGuideConstants.NAVIGATION_BUTTON_SPACE,
      })
      .backgroundColor(this.currentIndex == 2 ? this.buttonColor : Color.Transparent)
      .borderRadius(UserGuideConstants.BUTTON_RADIUS)
    }
    .justifyContent(FlexAlign.Center)
    .position({ bottom: 0 })
    .width(Constants.PERCENT_100)
  }

  @Builder
  buildCoverVerticalMain() {
    Row() {
      this.buildCoverSwiper();
    }
    .margin({ bottom: px2vp(this.navigationBarHeight) })
    .alignItems(VerticalAlign.Center)
    .borderWidth(0)
  }

  @Builder
  buildCoverSwiper() {
    Column() {
      this.buildHorizontalMainSwiper();
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

  build() {
    Stack() {
      Column() {
        if (this.isVerdeFoldable) {
          this.buildVerdeMain();
        } else if (this.isSplitCover) {
          this.buildCoverVerticalMain();
        } else if ((DeviceInfo.isFoldablePhone() && (DeviceInfo.isFoldable() ||
          (!DeviceInfo.isFoldable() && !this.isHorizontal))) || DeviceInfo.isTablet() ||
          (DeviceInfo.isPhoneUx() && !this.isHorizontal)) {
          this.buildVerticalMain();
        } else {
          this.buildHorizontalMain();
        }
      }
      .height(Constants.PERCENT_100).width(Constants.PERCENT_100).borderWidth(0)
    }
    .expandSafeArea([SafeAreaType.KEYBOARD, SafeAreaType.SYSTEM])
    .height(Constants.PERCENT_100)
    .width(Constants.PERCENT_100)
    .borderWidth(0)
    .backgroundColor($r('sys.color.background_secondary'))
  }

  @Builder
  buildVerdeMain() {
    Column() {
      this.buildVerdeSwiperAndButton();
    }
    .borderWidth(0)
    .margin({
      left: UserGuideConstants.VERDE_LEFT_RIGHT_MARGIN,
      right: UserGuideConstants.VERDE_LEFT_RIGHT_MARGIN,
      bottom: UserGuideConstants.VERDE_BUTTON_BOTTOM,
    })
  }

  @Builder
  buildVerdeSwiperAndButton() {
    Swiper(this.swiperController) {
      LazyForEach(this.data, (item: UserGuideInfo) => {
        this.buildVerticalSwiperAndButtonMain(item);
      }, (item: string) => item)
    }
    .index(this.currentIndex)
    .indicator(
      new DotIndicator()
        .itemWidth(UserGuideConstants.INDICATOR_WIDTH)
        .itemHeight(UserGuideConstants.INDICATOR_WIDTH)
        .selectedItemWidth(UserGuideConstants.INDICATOR_SELECTED_WIDTH)
        .selectedItemHeight(UserGuideConstants.INDICATOR_WIDTH)
        .color(Color.Grey)
        .selectedColor(this.buttonColor)
        .bottom(UserGuideConstants.BUTTON_HEIGHT))
    .onChange((index: number) => {
      this.currentIndex = index;
    })
    .autoPlay(this.isOpenTouchGuide ? false : true)
    .loop(false)
    .width(Constants.PERCENT_100)
    .interval(UserGuideConstants.SWIPER_AUTOPLAY_INTERVAL)
    .curve(Curve.Friction)
    .duration(UserGuideConstants.SWIPER_DURATION)

    this.buildVerderButton();
  }

  @Builder
  buildVerderButton() {
    Row() {
      Button() {
        Row() {
          Text((this.currentIndex == 2 ? this.imageAiEditing.buttonText : this.albumSorting.buttonText) as string)
            .fontColor(this.currentIndex == 2 ? Color.White : this.buttonColor)
        }.alignItems(VerticalAlign.Center)
      }
      .onClick((): void => {
        this.jumpToPageIndex();
      })
      .width(Constants.PERCENT_100)
      .height(UserGuideConstants.BUTTON_HEIGHT)
      .backgroundColor(this.currentIndex == 2 ? this.buttonColor : Color.Transparent)
      .borderRadius(UserGuideConstants.BUTTON_RADIUS)
    }
    .position({ bottom: 0 })
    .width(Constants.PERCENT_100)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  buildVerticalMain() {
    Column() {
      this.buildVerticalSwiperAndButton();
    }
    .borderWidth(0)
    .margin({
      top: UserGuideConstants.ACTIONBAR_HEIGHT + px2vp(this.statusBarHeight),
      bottom: px2vp(this.navigationBarHeight),
    })
  }

  @Builder
  buildHorizontalMain() {
    Row() {
      this.buildHorizontalSwiper();
    }
    .margin({ bottom: px2vp(this.navigationBarHeight) })
    .alignItems(VerticalAlign.Center)
    .borderWidth(0)
  }

  // 跳转首页
  jumpToPageIndex() {
    clickUserGuide(true);
    router.replaceUrl({
      url: 'MainAbility/view/index',
    })
  }

  // 跳转云图库引导海报
  jumpToPageCloudSplash() {
    clickUserGuide(true);
    router.replaceUrl({
      url: 'MainAbility/view/EnableSyncSplashPage',
    })
  }

  pageTransition() {
    PageTransitionEnter({
      type: RouteType.Pop,
      duration: UserGuideConstants.PAGE_TRANSITION_DURATION,
    })
      .opacity(1)
    PageTransitionExit({
      type: RouteType.Push,
      duration: UserGuideConstants.PAGE_TRANSITION_DURATION,
    })
      .opacity(1)
  }
}

async function clickUserGuide(isGuided: boolean) {
  await Protocol.set(Constants.USER_GUIDE, isGuided);
}