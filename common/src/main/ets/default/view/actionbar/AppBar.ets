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

import lazy { Constants } from '../../model/common/Constants';
import lazy { Log } from '../../utils/Log';
import lazy { WindowUtil } from '../../utils/WindowUtil';

/**
 * AppBar属性
 */
export const APP_BAR_OPTIONS: FlexOptions = {
  direction: FlexDirection.Row,
  wrap: FlexWrap.NoWrap,
  alignItems: ItemAlign.Center,
  justifyContent: FlexAlign.Center,
};

/**
 * ToolBar属性
 */
export const TOOL_BAR_OPTIONS: FlexOptions = {
  direction: FlexDirection.Row,
  wrap: FlexWrap.NoWrap,
  alignItems: ItemAlign.Center,
  justifyContent: FlexAlign.SpaceAround,
};

export const TOOLBAR_ANIMATE_DURATION: number = 350;

const DEFAULT_ACTION_BAR_Z_INDEX: number = 3;
/* instrument ignore file */
const TAG = 'AppBar';

/**
 * AppBar元素构造器
 */
export interface AppBarElementBuilder {
  builder: (params: Object | undefined) => void,
  builderParams: Object,
  key: string,
}

/**
 * 元素封装
 */
@Component
struct AppBarElement {
  params?: Object;
  @BuilderParam builder: (params: Object | undefined) => void;

  build() {
    this.builder(this.params);
  }
}

export interface AppBarStyler {
  readonly controller: AppBarController;
  register?: () => void;
  unregister?: () => void;
}

/**
 * Appbar控制器，用于刷新属性/构造新appbar等
 */
@Observed
export class AppBarController {
  private static uuid: number = 0;
  /**
   * 唯一id
   */
  public readonly id: number;
  /**
   * Flex布局选项
   */
  public options: FlexOptions = APP_BAR_OPTIONS;
  /**
   * 背景颜色
   */
  public backgroundColor: ResourceColor = $r('app.color.transparent');
  /**
   * 背景模糊
   */
  public backgroundBlurStyle: BlurStyle = BlurStyle.COMPONENT_THICK;
  /**
   * 透明度
   */
  public opacity: number | Resource = 1.0;
  /**
   * 可见性
   */
  public visibility: Visibility = Visibility.Visible;
  /**
   * 组件键值
   */
  public key: string = 'photos_app_bar';
  /**
   * 组件动效
   */
  public transitionEffect: TransitionEffect = TransitionEffect
    .move(TransitionEdge.TOP).animation({ duration: 0, curve: Curve.Friction });
  /**
   * padding设置
   */
  public padding: Padding | LocalizedPadding = {
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  };
  /**
   * margin设置
   */
  public margin: Margin | LocalizedMargin = {
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  };
  /**
   * border设置
   */
  public border: BorderOptions = {};
  /**
   * 对齐方式
   */
  public alignRules: AlignRuleOption | undefined = undefined;
  /**
   * 高度
   */
  public height: Length = Constants.ActionBarHeight;
  /**
   * 层级
   */
  public zIndex: number = DEFAULT_ACTION_BAR_Z_INDEX;
  /**
   * 布局变化回调设置
   */
  public onAreaChange: (oldValue: Area, newValue: Area) => void = (oldValue: Area, newValue: Area) => {
  };
  /**
   * 锚点
   */
  public markAnchor: Position | LocalizedPosition | undefined = undefined;
  /**
   * appbar内容构造器，重新赋值时刷新appbar内容
   */
  public builders: AppBarElementBuilder[] = [];
  /**
   * 元素间间隙
   */
  public gapWidth: Length | undefined = $r('sys.float.padding_level4');
  /**
   *  是否使用双击事件
   */
  public isUseDoubleClick: boolean = false;
  /**
   * 构造函数
   */
  public constructor() {
    AppBarController.uuid++;
    this.id = AppBarController.uuid;
    this.key = this.key + `_${this.id}`;
  }

  /**
   * 通过key获取ActionBar中的元素
   * @param key 标识符
   * @returns Prop/Controller
   */
  public get(key: string): Object | undefined {
    for (let builder of this.builders) {
      if (builder.key === key) {
        return builder.builderParams;
      }
    }
    return undefined;
  }

  public put(builder: AppBarElementBuilder | undefined) {
    if (!builder) {
      return;
    }
    this.builders.push(builder);
  }

  /**
   * 执行双击事件
   *
   * @param context
   */
  public onDoubleClickAction(context: Context) {
    Log.info(TAG, `onDoubleClickAction, isUseDoubleClick: ${this.isUseDoubleClick}`);
    if (this.isUseDoubleClick) {
      WindowUtil.handleWinTopBarToggle(context);
    }
  }
}

@Component
export struct AppBar {
  @ObjectLink @Watch('onControllerChanged') controller: AppBarController;

  private onControllerChanged(): void {
    Log.info(TAG, `onControllerChanged ${this.controller.id}`);
  }

  @Builder
  buildElements() {
    ForEach(this.controller.builders, (element: AppBarElementBuilder, index: number): void => {
      AppBarElement({ builder: element.builder, params: element.builderParams })
      if (index < this.controller.builders.length - 1 && this.controller.gapWidth) {
        Column().width(this.controller.gapWidth).height('100%').focusable(false)
      }
    }, (element: AppBarElementBuilder): string => element.key)
  }

  build() {
    Column() {
      Flex(this.controller.options) {
        this.buildElements();
      }.height(this.controller.height)
    }
    .zIndex(this.controller.zIndex)
    .backgroundColor(this.controller.backgroundColor)
    .backgroundBlurStyle(this.controller.backgroundBlurStyle, {}, {disableSystemAdaptation: true})
    .position({ x: 0, y: 0 })
    .opacity(this.controller.opacity)
    .padding(this.controller.padding)
    .margin(this.controller.margin)
    .border(this.controller.border)
    .key(this.controller.key)
    .visibility(this.controller.visibility)
    .transition(this.controller.transitionEffect)
    .accessibilityLevel('no')
    .alignRules(this.controller.alignRules)
    .onAreaChange((oldValue: Area, newValue: Area) => this.controller.onAreaChange(oldValue, newValue))
    .markAnchor(this.controller.markAnchor)
    .gesture(GestureGroup(GestureMode.Exclusive,
      TapGesture({ count: 2 }).onAction(
        () => {
          this.controller.onDoubleClickAction(getContext(this));
        }),
      TapGesture({ count: 1 }).onAction(
        () => {
          // pc 需要给个空的点击事件 避免点击透传到宫格页面
          Log.info(TAG, 'single click');
        })
      )
    )
  }
}