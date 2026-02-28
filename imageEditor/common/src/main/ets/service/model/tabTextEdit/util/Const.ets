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

export class Constants {
  public static readonly DEFAULT_TEXTAREA_WIDTH: number = 128;
  public static readonly DEFAULT_TEXTAREA_HEIGHT: number = 48;
  public static readonly DEFAULT_TEXTAREA_BORDER_WIDTH: number = 2;
  public static readonly DEFAULT_TEXTAREA_TOP_MENU_WIDTH: number = 168;
  public static readonly DEFAULT_TEXTAREA_TOP_MENU_HEIGHT: number = 40;
  public static readonly DEFAULT_TEXTAREA_TOP_MENU_MARGIN: number = 12;
  public static readonly DEFAULT_TEXTAREA_FONT_COLOR: Color | string | Resource = Color.White;
  public static readonly DEFAULT_TEXTAREA_FONT_STYLE: FontStyle = FontStyle.Normal;
  public static readonly DEFAULT_TEXTAREA_FONT_WEIGHT: string = '400';
  public static readonly DEFAULT_TEXTAREA_FONT_SIZE: number = 16;
  public static readonly DEFAULT_TEXTAREA_FONT_FAMILY: string = '鸿蒙黑体';
  public static readonly DEFAULT_TEXTAREA_MARGIN_LEFT: number = 18;
  public static readonly DEFAULT_TEXT_INPUT_ITEM_FONT_COLOR: Resource = $r('sys.color.ohos_id_color_text_primary');
  public static readonly DEFAULT_TEXT_INPUT_ITEM_LEFT_MARGIN: number = 16;
  public static readonly DEFAULT_TEXT_INPUT_ITEM_RIGHT: number = 54;
  public static readonly DEFAULT_TEXT_INPUT_ITEM_SPACE_WIDTH: number =
    this.DEFAULT_TEXT_INPUT_ITEM_LEFT_MARGIN + this.DEFAULT_TEXT_INPUT_ITEM_RIGHT;
  public static readonly DASHED_EFFECT = 0.5;
  public static readonly PADDING_TOP = 15;
  public static readonly PADDING_TOP_PAD = 18;
  public static readonly SHADOW_IMAGE_BORDER_WIDTH = 22;
  public static readonly SHADOW_IMAGE_EFFECT_WIDTH = 9;
  public static readonly LEFT_TOP_POSITION = 11;
  public static readonly STYLUS: number = -1;
  public static readonly DELETE_TEXTAREA: number = 0;
  public static readonly CREATE_TEXTAREA: number = 1;
  public static readonly MOVE_TEXTAREA: number = 2;
  public static readonly UPDATE_FONTSIZE: number = 3;
  public static readonly UPDATE_FONTCOLOR: number = 4;
  public static readonly UPDATE_CONTENT: number = 5;
  public static readonly ROTATE: number = 6;
  public static readonly UPDATE_FONT: number = 7;
  // 调色板字体调节最大值
  public static readonly MAX_FONT_SIZE: number = 56;
  // 调色板字体调节最小值
  public static readonly MIN_FONT_SIZE: number = 10;
  // 获焦状态
  public static readonly ONFOCUS: number = 1;
  // 失焦状态
  public static readonly ONBLUR: number = 0;
  /**
   * 缩放图标宽度
   */
  public static readonly RESIZE_ICON_WIDTH: number = 8;
  /**
   * 缩放图标高度
   */
  public static readonly RESIZE_ICON_HEIGHT: number = 8;
  /**
   * 文本框最大宽度
   */
  public static readonly TEXT_MAX_WIDTH: number = 1000;
  /**
   * 文本框最大高度
   */
  public static readonly TEXT_MAX_HEIGHT: number = 10000;
  /**
   * 菜单高度和间距
   */
  public static readonly MENU_HEIGHT: number =
    this.DEFAULT_TEXTAREA_TOP_MENU_MARGIN + this.DEFAULT_TEXTAREA_TOP_MENU_HEIGHT;
  /**
   * 底部输入框出来的时候透明度
   */
  public static readonly TEXT_EDIT_OPACITY: number = 0.1;
  /**
   * 点击菜单编辑
   */
  public static readonly CLICK_MENU_EDIT: string = 'CLICK_MENU_EDIT';
  /**
   * 点击菜单样式
   */
  public static readonly CLICK_MENU_STYLE: string = 'CLICK_MENU_STYLE';
  /**
   * 点击菜单复制
   */
  public static readonly CLICK_MENU_COPY: string = 'CLICK_MENU_COPY';
  /**
   * 修改字体大小
   */
  public static readonly CHANGE_FONT_SIZE: string = 'CHANGE_FONT_SIZE';
  /**
   * 修改字体颜色
   */
  public static readonly CHANGE_FONT_COLOR: string = 'CHANGE_FONT_COLOR';
  /**
   * 修改文本对齐方式
   */
  public static readonly CHANGE_TEXT_ALIGN: string = 'CHANGE_TEXT_ALIGN';
  /**
   * 修改字体加粗
   */
  public static readonly CHANGE_FONT_BOLD: string = 'CHANGE_FONT_BOLD';
  /**
   * 修改字体斜体
   */
  public static readonly CHANGE_FONT_ITALIC: string = 'CHANGE_FONT_ITALIC';
  /**
   * 修改字体下划线
   */
  public static readonly CHANGE_FONT_UNDERLINE: string = 'CHANGE_FONT_UNDERLINE';
  /**
   * 修改字体背景
   */
  public static readonly SET_FONT_BACKGROUND: string = 'SET_FONT_BACKGROUND';
  /**
   * 修改字体阴影
   */
  public static readonly SET_FONT_SHADOW: string = 'SET_FONT_SHADOW';
  /**
   * 修改字体无效果
   */
  public static readonly SET_FONT_NONE: string = 'SET_FONT_NONE';
  /**
   * 点击菜单删除
   */
  public static readonly CLICK_MENU_DELETE: string = 'CLICK_MENU_DELETE';
  /**
   * 输入框提交
   */
  public static readonly SUBMIT_EDITED_TEXT: string = 'SUBMIT_EDITED_TEXT';
  /**
   * 点击添加文本框
   */
  public static readonly ADD_TEXT_EDIT_BOX: string = 'ADD_TEXT_EDIT_BOX';
  /**
   * 点击复制文本框
   */
  public static readonly COPY_TEXT_EDIT_BOX: string = 'COPY_TEXT_EDIT_BOX';
  /**
   * 完成文本编辑
   */
  public static readonly FINISH_TEXT_EDIT: string = 'FINISH_TEXT_EDIT';
  /**
   * 缩放文本框
   */
  public static readonly ZOOM_TEXT_BOX: string = 'ZOOM_TEXT_BOX';
  /**
   * 旋转文本框
   */
  public static readonly ROTATE_TEXT_BOX: string = 'ROTATE_TEXT_BOX';
  /**
   * 移动文本框
   */
  public static readonly MOVE_TEXT_BOX: string = 'MOVE_TEXT_BOX';
  /**
   * 输入框最大字数
   */
  public static readonly INPUT_TEXT_LENGTH: number = 140;
  /**
   * 吸附的角度
   */
  public static readonly ADSORPTION_ANGLE: number = 1.5;
  /**
   * 旋转按钮的长度
   */
  public static readonly rotateIconWidth: number = 39.25;
  /**
   * 默认图片涂鸦、文本UI刷新之后合成时延
   */
  public static readonly DEFAULT_DELAY_UI_COMPOSE: number = 50;
  /**
   * 高像素图片涂鸦、文本UI刷新之后合成时延
   */
  public static readonly HIGH_PIXEL_DELAY_UI_COMPOSE: number = 200;
  /**
   * 高像素图片像素阈值
   */
  public static readonly HIGH_PIXEL_VALUE: number = 8192;
  /**
   * 菜单距离屏幕的最小距离
   */
  public static readonly MIN_MENU_TO_SCREEN: number = 8;
  /**
   * 文本标注复制偏移距离
   */
  public static readonly TEXT_COPY_OFFSET: number = 24;
  /**
   * 图标的尺寸
   */
  public static readonly iconSize: number = 24;
  /**
   * 初始菜单和文本框的宽度差
   */
  public static readonly MENU_BOX_DIFFERENCE_VALUE: number = 20;
  public static readonly textShadow: ShadowOptions = {
    radius: 7,
    type: ShadowType.COLOR,
    color: 'rgba(0, 0, 0, 0.3)',
  }
  public static readonly borderShadow: ShadowOptions = {
    radius: 10,
    type: ShadowType.COLOR,
    color: 'rgba(0, 0, 0, 0.2)',
    fill: true,
  }
  public static readonly imageSlice: EdgeWidths = {
    left: '230px',
    top: '100px',
    right: '230px',
    bottom: '110px',
  }
}

/**
 * 文本框缩放时，四个角点的方向
 */
export const enum ResizeDirectionEdit {
  TOP_LEFT = 0,
  TOP_RIGHT = 1,
  BOTTOM_RIGHT = 2,
  BOTTOM_LEFT = 3,
}

/**
 * 移动类型
 */
export enum TouchMoveType {
  DEFAULT = 0,
  MOVE = 1,
  RESIZE = 2,
  ROTATE = 3,
}

/*
 * Description: 页面滚动状态
 */
export enum ScrollStates {
  DEFAULT = 0,
  FORBID = 1,
  READY = 2,
}




