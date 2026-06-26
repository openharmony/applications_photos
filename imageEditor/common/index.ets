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
import PhotoAssetUtil from './src/main/ets/common/util/PhotoAssetUtil';

/**
 * 此文件已管控,禁止任何合入
 * 责任田: 性能
 * 原因: 在此export 引用对象, 将允许开发人员使用非精准导入, 影响冷启动
 *
 * 另外, 在视图文件中import大so文件的时候, 推荐使用懒加载而不是在开头import:
 * (): void {
 *   import('@ohos/common/src/main/ets/default/xxx').then((ns) => {
 *   ns.xxx(getContext(), records);
 * }
 *
 * 已有代码将被陆续删除, 所有非管控合入将被回退并追溯
 */
export { EditorSDK,
  SwitchAnimator,
  RectValue,
  EditorMsg,
  EditorParams,
  EditorStatus,
  WinSize,
  EffectDetail,
  ImageEffectState,
  ImageEffectChangeParams,
  ImageEffectChangeMsg } from './src/main/ets/service/EditorSDK'

export { RulerBar } from './src/main/ets/common/components/RulerBar';

export { HiLog } from './src/main/ets/common/util/HiLog';

export { TabName, App, BaseEditor, MediaType, UndoRedoInfo } from './src/main/ets/service/App';

export { CropAttr,
  AdjustAttr,
  MosaicAttr,
  Timeline,
  OperationTip } from './src/main/ets/service/BaseEditor';

export { CropScaleClass, Action, DownPos, DragObj } from './src/main/ets/service/model/CropModel';

export { Event, lpx } from './src/main/ets/common/jul';

export { DeviceUtil } from './src/main/ets/common/util/DeviceUtil';

export { Asset } from './src/main/ets/service/Asset';

export { UiUtil } from './src/main/ets/common/util/UiUtil';

export { FormatUtil } from './src/main/ets/common/util/FormatUtil';

export { ScreenUtil } from './src/main/ets/common/util/ScreenUtil';

export { PermissionUtil } from './src/main/ets/common/util/PermissionUtil';

export { GlobalThisUtil, preferencesGet, preferencesPut } from './src/main/ets/common/util/GlobalThisUtil';

export { Constants } from './src/main/ets/common/util/Constants';

export { Rectangle, RectangleAnimated } from './src/main/ets/common/util/types';

export { PathUtils } from './src/main/ets/common/util/PathUtils';

export {
  ApsUtil,
  APS_SCENE_STATE_ON,
  APS_SCENE_STATE_OFF,
  PHOTO_IN_EDIT_CROP,
  PHOTO_BUNDLE_NAME
} from './src/main/ets/common/util/ApsUtil';

export { ScrollerUtil } from './src/main/ets/common/util/ScrollerUtil';

export { Service } from './src/main/ets/common/util/Service'

export { Trace } from './src/main/ets/common/util/Trace'

export { NullUtil } from './src/main/ets/common/util/NullUtil'

export { VideoSizer } from './src/main/ets/feature/basic/view/VideoSizer';

export { StrengthBar } from './src/main/ets/common/components/StrengthBar';

export { AppColor,
  SCREEN_ORIENTATION_PORTRAIT,
  SCREEN_FOLD_ORIENTATION_PORTRAIT,
  EDITOR_STATUS_BAR_HEIGHT_KEY,
  TOOL_CONTAINER_HEIGHT,
  WIN_HEIGHT_KEY,
  WIN_WIDTH_KEY,
  WINDOW_STATUS_KEY,
  TOP_OFFSET_PHONE,
  LANDSCAPE_TOP_MARGIN,
  BOTTOM_AVOID_HEIGHT,
  LANDSCAPE_LENGTH_RATIO,
  WINDOW_MODE_DECOR_BAR,
  BOTTOM_NAVIGATION_HEIGHT,
  BOTTOM_LANDSCAPE_OFFSET_PHONE_FOR_IMAGE,
  THIRD_TOOL_BAR_HEIGHT,
  DEVICE_FOLD_STATUS,
  FIRST_FRAME_STATUS,
  CANVAS_RECT,
  DOWNLOAD_STATUS,
  CONTAINER_WIDTH } from './src/main/ets/common/const';

export { TopBarModel } from './src/main/ets/feature/basic/model/menu/TopBarModel';

export { VideoCropTool } from './src/main/ets/feature/basic/view/tabs/VideoCropTool';

export { VideoAdjustTool } from './src/main/ets/feature/basic/view/tabs/VideoAdjustTool';

export { VideoTextTool } from './src/main/ets/feature/basic/view/tabs/VideoTextTool';

export { TabType, ButtonBubble, UnSupportDialog } from './src/main/ets/feature/basic/model/menu/data/TabType';

export { VideoPlay } from './src/main/ets/feature/basic/view/VideoPlay';

export { ButtonItem, ResourceButtonItem } from './src/main/ets/feature/basic/common/view/SelectableProgressButton';

export { copyAttrTo } from './src/main/ets/common/util/misc';

export { CustomScroll } from './src/main/ets/common/components/CustomScroll';

export { BreakPointSystem } from './src/main/ets/common/util/BreakPointSystem';

export { ScreenManager, ColumnSize } from './src/main/ets/common/util/ScreenManager';

export { AccessibilityManager } from './src/main/ets/common/util/AccessibilityManager';

export { CropType } from './src/main/ets/service/model/CropModel';

export { EditorPixelMapManager } from './src/main/ets/common/EditorPixelMapManager';

export { PhotoAssetUtil }

export { Effects } from './src/main/ets/common/effects/Effects';