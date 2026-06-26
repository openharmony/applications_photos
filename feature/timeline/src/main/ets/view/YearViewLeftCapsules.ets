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
/* instrument ignore file */
import lazy { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import lazy { BroadCastConstants } from '@ohos/common/src/main/ets/default/model/common/BroadCastConstants';
import lazy { TimeController } from '@ohos/common/src/main/ets/default/utils/TimeController';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { TimelineScrollBarManager } from '@ohos/common/src/main/ets/default/model/common/TimelineScrollBarManager';
import lazy { YearMonthGroupInfo } from '@ohos/common/src/main/ets/default/access/UserFileManagerAccess';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { AsyncCallback } from '@ohos/common/src/main/ets/default/model/common/AsyncCallback';
import lazy { Constants } from '@ohos/common/src/main/ets/default/model/common/Constants';
import lazy { i18n } from '@kit.LocalizationKit';
import lazy { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo';
import lazy { getScreen } from '@ohos/common/src/main/ets/default/model/common/ScreenManager';
import lazy { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';

const TAG: string = 'timeline_YearViewLeftCapsules';

interface DateCapsule {
  gap: number;
  yearTime: string;
  top: number;
  rowCount: number;
};

// YearViewLeftCapsules
@Component
export struct YearViewLeftCapsules {
  @Prop @Watch('updateTotalNumAndCapsulePosition') private yearGroupInfo: YearMonthGroupInfo[] = [];
  @State private yearViewLeftCapsuleArr: DateCapsule[] = [];
  @State private allRowNum: number = -1;
  @Link private imageGridItemHeight: number;
  @Prop private actionBarHeight: number = 0;
  private yearTimelineScrollBarManager: TimelineScrollBarManager = new TimelineScrollBarManager();
  private currentGridMaxOffset: number = 0; // 当前视图宫格极限偏移量
  @Prop @Watch('countOrHeightChange') private gridRowCount: number;
  private scrollZIndex: number = 2;
  private scroller: Scroller = new Scroller();
  private activeScroller: Scroller = new Scroller();
  @State private topIndex: number = 0;
  @State private topItemOpacity: number = 1;
  private endIndex: number = 0;
  @Link @Watch('countOrHeightChange') private gridHeight: number;
  private timerId: number = -1;
  private lineHeight: number = 19;
  private textWidth: number = 71;
  @Prop private timeController: TimeController;
  @Prop private actionBarPaddingTop: number = 36;
  private paddingLevelFour: number =
    px2vp(new RscGetter(getContext().resourceManager).getNumber($r('sys.float.padding_level4')));
  @State private firstGapsExtend: number = this.actionBarHeight - this.actionBarPaddingTop - this.paddingLevelFour;
  private bigCapsuleHeight: number =
    px2vp(new RscGetter(getContext().resourceManager).getNumber($r('app.float.scroll_bar_side_text_height')));
  private static readonly PLACEHOLDER_ITEM_HEIGHT: number = 1000;
  @State private firstPlaceHolderHeight: number = YearViewLeftCapsules.PLACEHOLDER_ITEM_HEIGHT;
  @State private listChildrenSize: ChildrenMainSize =
    new ChildrenMainSize(YearViewLeftCapsules.PLACEHOLDER_ITEM_HEIGHT);
  private static readonly LIST_MARGIN_LEFT: number = 16;
  private static readonly LIST_DISTANCE_FROM_STATUS_BAR: number = 8;
  private static readonly THRESHOLD: number = 8;
  private static readonly PLACE_ITEM_TITLE: string = '';
  private static readonly TIME_OUT_DURATION: number = 20;
  private static readonly UPDATE_CAPSULE_POSITION_DURATION: number = 20;
  @StorageProp('timelinePageActionBarPaddingLeft') timelinePageActionBarPaddingLeft: number = 0;
  @StorageProp('titlePaddingLeft') titlePaddingLeft: number = 0;
  @StorageLink('currentLanguage') @Watch('updateCurrentLanguage') currentLanguage: string | undefined = undefined;
  private onUpdateYearFunc: Function = (yearGroupInfo: YearMonthGroupInfo[]): void =>
  this.onUpdateYearDate(yearGroupInfo);
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

  aboutToAppear(): void {
    this.currentLanguage = i18n.System.getSystemLanguage();
    this.updateTotalNum();
    this.updateYearViewLeftDateCapsule();
    this.appBroadCast.on(BroadCastConstants.YEAR_UPDATE, this.onUpdateYearFunc);
  }

  updateTotalNum(): void {
    let totalCount = 0;
    for (let year of this.yearGroupInfo) {
      totalCount = totalCount + (year.count as number);
    }
    this.allRowNum = Math.ceil(totalCount / this.gridRowCount);
  }

  private updateYearViewLeftDateCapsule(callBack?: AsyncCallback<String>): void {
    let yearGroupInfo: string = JSON.stringify(this.yearGroupInfo);
    this.updateYearDateCapsule(yearGroupInfo, callBack);
  }

  private updateYearDateCapsule(yearGroupInfo: string, callBack?: AsyncCallback<String>): void {
    // 添加维测日志定位年份胶囊分布问题原因
    Log.info(TAG, `updateYearViewLeftDateCapsule yearGroupInfo:${yearGroupInfo}`);
    this.currentGridMaxOffset = this.imageGridItemHeight * this.allRowNum;
    this.yearTimelineScrollBarManager.setParams(yearGroupInfo, this.allRowNum, this.gridRowCount,
      this.currentGridMaxOffset, 0, 0, this.bigCapsuleHeight);
    this.yearTimelineScrollBarManager.isYearLeft = true;
    this.yearTimelineScrollBarManager.eachRowHeight = this.imageGridItemHeight;
    this.yearTimelineScrollBarManager.dateYearDataTask().then((res: DateCapsule[] | void): void => {
      if (res) {
        this.yearViewLeftCapsuleArr = res;
        this.listChildrenSize = new ChildrenMainSize(YearViewLeftCapsules.PLACEHOLDER_ITEM_HEIGHT);
        this.updateChildrenSizeAndFirstItemHeight(res);
        callBack?.callback();
        // 添加维测日志定位年份胶囊分布问题原因
        Log.info(TAG, `updateYearViewLeftDateCapsule:${JSON.stringify(this.yearViewLeftCapsuleArr)}`);
      }
    })
  }

  private updateChildrenSizeAndFirstItemHeight(dateCapsuleList: DateCapsule[]): void {
    dateCapsuleList.forEach((item: DateCapsule, index: number) => {
      if (index !== 0) {
        this.listChildrenSize.update(index + 1, item.gap + this.bigCapsuleHeight);
      } else {
        if (item.top !== 0) {
          this.firstPlaceHolderHeight = YearViewLeftCapsules.PLACEHOLDER_ITEM_HEIGHT + item.top +
          this.firstGapsExtend;
          this.listChildrenSize.update(index, this.firstPlaceHolderHeight);
          this.listChildrenSize.update(index + 1, item.gap + this.bigCapsuleHeight);
        } else {
          this.firstPlaceHolderHeight = YearViewLeftCapsules.PLACEHOLDER_ITEM_HEIGHT;
          this.listChildrenSize.update(index, this.firstPlaceHolderHeight);
          this.listChildrenSize.update(index + 1, item.gap + this.bigCapsuleHeight + this.firstGapsExtend);
        }
      }
    })
  }

  // 照片数量及宫格可视区域高度变化时触发
  countOrHeightChange(): void {
    clearTimeout(this.timerId);
    this.timerId = setTimeout((): void => {
      this.updateTotalNumAndCapsulePosition();
      clearTimeout(this.timerId);
    }, YearViewLeftCapsules.UPDATE_CAPSULE_POSITION_DURATION);
  }

  private updateTotalNumAndCapsulePosition(): void {
    this.updateTotalNum();
    let firstPatchDataCallback: AsyncCallback<String> = {
      callback: (): void => {
        this.scrollToYearDateCapsule();
      }
    };
    this.updateYearViewLeftDateCapsule(firstPatchDataCallback);
  }

  private scrollToYearDateCapsule(): void {
    // 时间胶囊刷新时需要重新跳转到对应位置
    setTimeout((): void => {
      let offY: number = this.activeScroller.currentOffset()?.yOffset ?? 0;
      this.scroller.scrollTo({ xOffset: 0, yOffset: offY + YearViewLeftCapsules.PLACEHOLDER_ITEM_HEIGHT });
    }, YearViewLeftCapsules.TIME_OUT_DURATION);
  }

  @Builder
  itemHead(text: string) {
    Stack() {
      Text(text)
        .fontSize($r('sys.float.Body_M'))
        .maxFontScale(1.0)
        .minFontScale(1.0)
        .fontWeight('SemiBold')
        .fontFamily('HarmonyHeiTi')
        .lineHeight(this.lineHeight)
        .fontColor($r('sys.color.font_primary'))
    }
    .backgroundBlurStyle(BlurStyle.Regular)
    .borderRadius($r('app.float.scroll_bar_side_text_radio'))
    .height($r('app.float.scroll_bar_side_text_height'))
    .width(this.textWidth)
  }

  @Builder
  itemHeadPlaceHolder(text: string) {
    Stack() {
      Text(text)
        .fontSize($r('sys.float.Body_M'))
        .fontWeight('SemiBold')
        .fontFamily('HarmonyHeiTi')
        .lineHeight(0)
    }
    .height(0)
    .width(this.textWidth)
  }

  private changeTopItemOpacity(): void {
    Log.info(TAG, `changeTopItemOpacity:${this.topIndex} ${this.yearViewLeftCapsuleArr.length}`);
    if (this.topIndex <= this.yearViewLeftCapsuleArr.length) {
      let nextItemOffY: number | undefined = 0;
      try {
        nextItemOffY = this.scroller.getItemRect(this.topIndex + 1).y;
      } catch (e) {
        Log.error(TAG, `getItemRect error, stack ${e?.stack}, code ${e?.code}`);
      }
      //下一项不在界面上时nextItemOffY = 0, 但此时不需要更新topIndex这一项的透明度
      if (this.topIndex + 1 > this.endIndex) {
        return;
      }
      if (nextItemOffY) {
        let opacity: number = (nextItemOffY - this.bigCapsuleHeight) / YearViewLeftCapsules.THRESHOLD;
        this.topItemOpacity = opacity > Constants.OPAQUE ? Constants.OPAQUE :
          opacity < Constants.TRANSPARENT ? Constants.TRANSPARENT : opacity;
      }
      Log.info(TAG, `changeTopItemOpacity:${nextItemOffY} ${this.topItemOpacity} ${this.bigCapsuleHeight}`);
    }
  }

  @Builder
  capsuleList() {
    List({ scroller: this.scroller }) {
      // 顶部占位，用于回弹
      ListItemGroup({ header: this.itemHeadPlaceHolder(YearViewLeftCapsules.PLACE_ITEM_TITLE) }) {
        ListItem()
          .height(this.firstPlaceHolderHeight)
          .width(this.textWidth)
      }.opacity(Constants.OPAQUE)

      ForEach(this.yearViewLeftCapsuleArr, (item: DateCapsule, index: number) => {
        ListItemGroup({ header: this.itemHead(item.yearTime) }) {
          ListItem()
            .height(index === 0 && item.top === 0 ? item.gap + this.firstGapsExtend : item.gap)
            .width(this.textWidth)
        }.opacity(this.topIndex === index + 1 ? this.topItemOpacity : Constants.OPAQUE)
      })
      // 底部占位,用于触底回弹
      ListItemGroup({ header: this.itemHeadPlaceHolder(YearViewLeftCapsules.PLACE_ITEM_TITLE) }) {
        ListItem()
          .height(YearViewLeftCapsules.PLACEHOLDER_ITEM_HEIGHT)
          .width(this.textWidth)
      }.opacity(Constants.OPAQUE)
    }
    // 第一项ListItem高度>=1000vp, 有1000vp只起占位回弹作用, List组件第一次需要从偏移1000vp后开始布局
    .contentStartOffset(YearViewLeftCapsules.PLACEHOLDER_ITEM_HEIGHT)
    .childrenMainSize(this.listChildrenSize)
    .onScrollIndex((start: number, end: number, center: number) => {
      if (this.topIndex != start) {
        this.topItemOpacity = Constants.OPAQUE;
      }
      this.topIndex = start;
      this.endIndex = end;
    })
    .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
      this.changeTopItemOpacity();
    })
    .onWillScroll((offset: number, state: ScrollState, source: ScrollSource): void | ScrollResult => {
      if (source === ScrollSource.DRAG || source === ScrollSource.FLING) {
        return { offsetRemain: 0 };
      }
    })
    .scrollBar(BarState.Off)
    .sticky(StickyStyle.Header)
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.None)
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      this.capsuleList()
    }
    .opacity(this.timeController ? this.timeController.yearViewLeftCapsulesOpacity : Constants.TRANSPARENT)
    .accessibilityLevel('no-hide-descendants')
    .hitTestBehavior(HitTestMode.None)
    .width(this.textWidth)
    .zIndex(this.scrollZIndex)
    .height(this.gridHeight)
    .position({
      x: this.currentLanguage?.indexOf('ug') !== -1 ? this.getUyghurPosition() :
        this.timelinePageActionBarPaddingLeft + this.titlePaddingLeft,
      y: DeviceInfo.isVerdeFoldable() ? 4 : 0,
    })
    .padding({ top: this.actionBarPaddingTop + YearViewLeftCapsules.LIST_DISTANCE_FROM_STATUS_BAR })
  }

  private getUyghurPosition(): number {
    let paddingLeft: number = this.timelinePageActionBarPaddingLeft + this.titlePaddingLeft;
    let winWidth: number = getScreen().getWinWidth();
    Log.info(TAG, `getUyghurPosition:${winWidth}, ${paddingLeft}, ${this.textWidth}`);
    // 设备宽度减去边界宽度再减去胶囊宽度即为胶囊距离设备左边界距离
    return winWidth - paddingLeft - this.textWidth;
  }

  /**
   * currentLanguage发生变化时候触发
   */
  private updateCurrentLanguage(): void {
    Log.info(TAG, 'updateCurrentLanguage');
    this.updateYearViewLeftDateCapsule();
  }

  /**
   * 监听年日期实时变化
   * @param yearGroupInfoArray 年日期数组
   */
  onUpdateYearDate(yearGroupInfoArray: YearMonthGroupInfo[]): void {
    let yearGroupInfo: string = JSON.stringify(yearGroupInfoArray);
    Log.info(TAG, `onUpdateYearDate yearGroupInfo:${yearGroupInfo}`);
    let totalCount = 0;
    for (let year of yearGroupInfoArray) {
      totalCount = totalCount + (year.count as number);
    }
    this.allRowNum = Math.ceil(totalCount / this.gridRowCount);
    let firstPatchDataCallback: AsyncCallback<String> = {
      callback: (): void => {
        this.scrollToYearDateCapsule();
      }
    };
    this.updateYearDateCapsule(yearGroupInfo, firstPatchDataCallback);
  }

  aboutToDisappear(): void {
    this.appBroadCast.off(BroadCastConstants.YEAR_UPDATE, this.onUpdateYearFunc);
  }
}