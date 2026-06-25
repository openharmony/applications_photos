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

/*
 * 日志TAG
 */
const TAG: string = 'RecommendClearingCard';

/*
 * 设置空间优化卡片信息类
 */
export class RecommendClearingCard {
  /**
   * 卡片是否展示
   */
  private needShow: boolean;
  /**
   * 卡片详细信息
   */
  private cardInfo: CardDetailInfo;

  constructor(needShow: boolean, summaryParam: string) {
    this.needShow = needShow;
    this.cardInfo = new CardDetailInfo($r('app.media.card_icon').id,
      $r('app.string.video_image_cleanup').id, $r('app.string.cleanup_card_description').id,
      [new SingleParam(SummaryParamType.STRING, summaryParam)],
      [new ButtonInfo($r('app.string.card_router').id, CardAction.ROUTER, `common_page`)])
  }

  /**
   * 创建卡片详细信息
   *
   * @param cardStatus 卡片状态
   * @param action 按钮动作类型
   */
  public static createCardInfo(needShow: boolean, summaryParam: string): RecommendClearingCard {
    return new RecommendClearingCard(needShow, summaryParam);
  }

  /**
   * 获取卡片详细信息
   *
   * @param CardDetailInfo 卡片信息
   */
  public getCradInfo(): CardDetailInfo {
    return this.cardInfo;
  }
}

/*
 * 卡片详细信息
 */
class CardDetailInfo {
  /**
   * 图标资源id
   */
  public icon: number;
  /**
   * 标题资源id
   */
  public title: number;
  /**
   * 内容资源Id
   */
  public summary: number;
  /**
   * 内容占位参数
   */
  public summaryParam?: SingleParam[];
  /**
   * 按钮数组
   */
  public buttonList: ButtonInfo[];

  constructor(icon: number, title: number, summary: number, summaryParam: SingleParam[], buttonList: ButtonInfo[]) {
    this.icon = icon;
    this.title = title;
    this.summary = summary;
    this.summaryParam = summaryParam;
    this.buttonList = buttonList;
  }
}

/*
 * 卡片按钮信息
 */
class ButtonInfo {
  /**
   * 按钮文案资源id
   */
  public button: number;
  /**
   * 操作动作类型 router | call
   */
  public action: CardAction;
  /**
   * 跳转页面uri
   */
  public routerUri?: string = '';
  /**
   * dataShare操作uri
   */
  public callUri?: string = '';

  constructor(button: number, action: CardAction, routerUri: string) {
    this.button = button;
    this.action = action;
    this.routerUri = routerUri ?? '';
  }
}

/**
 * 空间优化卡片状态
 */
export enum CardStatus {
  /**
   * 不展示卡片
   */
  HIDE = '0',

  /**
   * 展示卡片
   */
  SHOW = '1',
}

/*
 * 内容占位参数类型
 */
export enum SummaryParamType {
  /**
   * 字符串
   */
  STRING = 'string',

  /**
   * resource
   */
  RES = 'res'
}

/*
* 空间优化卡片'立即优化'按钮动作类型
*/
export enum CardAction {
  /**
   * 跳转到云空间
   */
  ROUTER = 'router',

  /**
   * DataShare调用
   */
  CALL = 'call'
}


/*
 * 占位参数类型
 */
class SingleParam {
  /**
   * 参数类型
   */
  public type: SummaryParamType;
  /**
   * 参数值
   */
  public value: string;

  constructor(type: SummaryParamType, value: string) {
    this.type = type;
    this.value = value;
  }
}

