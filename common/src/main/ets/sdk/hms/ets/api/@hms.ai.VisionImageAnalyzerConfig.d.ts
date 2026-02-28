/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import { BusinessError } from '@kit.BasicServicesKit';
import image from '@ohos.multimedia.image';

declare interface VisionImageAnalyzerConfig extends ImageAnalyzerConfig {
  /**
   * 是否展示AIButton
   */
  showAIButton?: boolean;

  /**
   * AIButton偏移量
   */
  aiButtonOffset?: AIButtonOffset;

  /**
   * 文字识别参数
   */
  textOptions?: ImageAnalyzerTextOptions;

  /**
   * 主题识别参数
   */
  subjectOptions?: ImageAnalyzerSubjectOptions;

  /**
   * overlay visibility
   */
  overlayVisible?: boolean;

  /**
   * ai overlay visibility
   */
  aiOverlayVisible?: boolean;
  onOverlayStatusChanged?: (status: Status) => void; // 24
  isUseCache?: boolean; //控制是否使用缓存 
  decodingInfo?: DecodingInfo; //区域解码信息
  onAIButtonStatusChanged?: (status: Status) => void; // 24
  selectedStatus?: Status; // 24 取消选中（文字+主题）
  onSelectedStatusChanged?: (status: Status) => void; // 24 取消选中（文字+主题）
  onLookupPanelStatusChange?: (status: Status) => void;
}


declare interface ImageAnalyzerTextOptions {
  isAutoDetectText?: boolean;
  onAnalyzed?: (tag: string, data: string) => void;
  analyzedData?: string;
  onTextSelected?: (tag: string, data: string, lines: number) => void;
  customTextMenuList?: CustomTextMenu[];
  textAnalyzedData?: string; // 25
  onTextAnalyzedCacheData?: (data: string) => void; // 25
}

export interface CustomTextMenu {
  content: string | Resource;
  action: (text: string) => void;
}

declare interface ImageAnalyzerSubjectOptions {
  isAutoDetectSubject?: boolean,
  analyzedData?: Uint8Array;
  onAnalyzed?: (tag: string, data: Uint8Array) => void;
  customSubjectMenuList?: CustomSubjectMenu[];

  /**
   * 如果设置此接口，则第一次抠图有数据时，会将所有的主题信息返回， 上限6个
   */
  onSubjectAnalyzed?: (data: Subject[]) => void;

  /**
   * 传入id数组，高亮对应id的抠图主题
   */
  selectedSubjects?: number[];

  /**
   * 返回当前选中的主题信息
   */
  onSelectedSubjectsChanged?: (data: Subject[]) => void;

  /**
   * 传入针对图片的点位置，返回点位置的抠图信息
   */
  analyzeSubjectPoint?: SubjectPointAction,

  /**
   * 传入多个主题信息id, 返回多个主题信息id聚合成的pixelmap
   */
  createPicOfSubjects?: SubjectSelectAction,

  // 抠图缓存结果
  subjectAnalyzedData?: SubjectData; // 25

  // 抠图缓存回调
  onSubjectAnalyzedCacheData?: (data: SubjectData) => void; // 25

  sourceUri?: string; //高清图uri 25
  isEnableSkinSmoothing?: Boolean; // 26
  skinSmoothingState?: string; // 美颜状态, 默认未美颜 // 26
  skinSmoothingMenus?: SkinSmoothingMenu[]; // 26
  onFaceAnalyzed?: (faces: string) => void; // 26
}

export interface SubjectData {
  cacheData: Uint8Array;
}

export interface SkinSmoothingMenu {
  name?: Resource | string;
  handler?: () => void;
}

export interface SubjectPointAction {
  point?: Point,
  callback?: (data: Subject) => void
}

export interface SubjectSelectAction {
  subjects: number[],
  callback: (data: image.PixelMap) => void
}

export interface AIButtonOffset {
  left?: number,
  top?: number,
  right?: number,
  bottom?: number
}

export interface SegMaskInfo {
  maskNum: number,

  /**
   * @default Indicates the maskList
   */
  maskList: Array<Int32Array>,

  /**
   * @default Indicates the contourList
   */
  contourList: Array<Int32Array>,
}

export declare interface TextCustomMenu {
  name: string | Resource;
  handler: (name: string, data: string) => void;
}

declare interface SubjectCustomMenu {
  name: string | Resource;
  handler: (name: string | Resource, data: Subject[]) => void
}

export declare interface DecodingInfo {
  originPicSize: Size,
  decodingRegion: Region,
}

export interface Size {
  width: number,
  height: number
}

export declare interface Subject {
  /**
   * 抠图id
   */
  id: number,

  /**
   * 抠图pixelmap
   */
  image: image.PixelMap,

  /**
   * 抠图外界矩形框
   */
  bounds: Region
}

export interface CustomSubjectMenu {
  content: string | Resource;
  action: (content: SegMaskInfo) => void;
}

declare interface Point {
  x: string | number,
  y: string | number,
}

export interface Region {
  left: number,
  top: number,
  right: number,
  bottom: number
}

export interface CreatePicOfSubjectsAction {
  subjects: number[];
  callback: (data?: image.PixelMap) => void;
}

export interface AnalyzeSubjectPointAction {
  point: Point;
  callback: (data?: Subject) => void;
}

export declare enum Status {
  STATUS_NONE = 0,
  OVERLAY_NONE = 1,
  OVERLAY_SHOW = 2,
  OVERLAY_HIDE = 3,
  AIBUTTON_SELECTED = 4,
  AIBUTTON_UNSELECTED = 5,
  AIBUTTON_HIDE = 6,
  SELECTED_TO_UNSELECTED = 7,
  UNSELECTED_TO_SELECTED = 8,
  LOOKUP_PANEL_SHOW = 9,
  LOOKUP_PANEL_HIDE = 10,
  LOOKUP_PANEL_LOW = 11,
  LOOKUP_PANEL_MEDIUM = 12,
  LOOKUP_PANEL_HIGH = 13
}

export {
  VisionImageAnalyzerConfig, ImageAnalyzerTextOptions, ImageAnalyzerSubjectOptions
}