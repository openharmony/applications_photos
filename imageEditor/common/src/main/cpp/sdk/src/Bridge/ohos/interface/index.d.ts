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
 * Description: 自动生成的ts文件
 **/

import { image } from '@kit.ImageKit';

// void appCreate ()
export const appCreate: () => void;

// void InitEnv ()
export const InitEnv: () => void;

// void UnInitEnv ()
export const UnInitEnv: () => void;

// void appDestory ()
export const appDestory: () => void;

// void appShow ()
export const appShow: () => void;

// void appHide ()
export const appHide: () => void;

// void editorShow ()
export const editorShow: () => void;

// void editorHide ()
export const editorHide: () => void;

// void regNativeOpenMedia (std::function<void(std::string const &url, std::string const &mode, int64_t callId)> cb)
export const regNativeOpenMedia: (cb: (url: string, mode: string, callId: number) => void) => void;

// void setMediaFd (int64_t callId, int64_t fd)
export const setMediaFd: (callId: number, fd: number) => void;

// void checkEditData (std::string const editdata)
export const EditorContext_checkEditData: (editdata: string) => void;

// void callEmpty (std::function<void(int64_t val)> cb)
export const EditorContext_callEmpty: (cb: (val: number) => void) => void;

// void createTimeline (std::string const &projectId,int mediaType, std::function<void(std::string const &jsonPos)> sdkCallback,
// std::function<void(std::string const &jsonPos)> createResult)
export const EditorContext_createTimeline: (projectId: string, mediaType: number, isHdrShowOpen: boolean,
  sdkCallback: (jsonPos: string) => void, createResult: (jsonPos: string) => void, editData: string) => void;

// std::string modifyTimeline (int timelineId, std::string const &jsonAttr)
export const EditorContext_modifyTimeline: (timelineId: number, jsonAttr: string) => string;

// void bindTimelineWithXComponent (int timelineId, std::string xComponentId, double canvasWidth, double canvasHeight, std::function<void(int width,
// int height)> cb)
export const EditorContext_bindTimelineWithXComponent: (timelineId: number, xComponentId: string, canvasWidth: number, canvasHeight: number,
                                                        cb: (width: number, height: number) => void) => void;

// void playTimeline (int timelineId, int64_t startTime, int64_t endTime)
export const EditorContext_playTimeline: (timelineId: number, startTime: number, endTime: number) => void;

// void pauseTimeline (int timelineId)
export const EditorContext_pauseTimeline: (timelineId: number) => void;

// void seekTimeline (int timelineId, int64_t timeMs, boolean isExactMode)
export const EditorContext_seekTimeline: (timelineId: number, timeMs: number, isExactMode: boolean) => void;

export const EditorContext_getExportRect: (timelineId: number, assetId: string, cb: (width: number, height: number) => void) => void;
// void compileTimeline (int timelineId, std::string path, std::string const &assetId, mediaType: number,
// std::function<void(std::string const &json)> callback)
export const EditorContext_compileTimeline: (timelineId: number, path: string, assetId: string, mediaType: number, mimeType: string,
                                             callback: (json: string, type: string) => void) => void;

export const EditorContext_compileTimelinePixelMap: (timelineId: number, path: string, isOriginColor: boolean,
  assetId: string, mediaType: number, callback: (pixelMap: image.PixelMap) => void, isToAiPage: boolean,
  needAddWatermark: boolean, isSave: boolean) => void;

// void cancelCompileTimeline (int timelineId,std::function<void()> callback)
export const EditorContext_cancelCompileTimeline: (timelineId: number, cb: () => void) => void;

// void setThumbnailCallback (int timelineId, std::function<void(const std::string &laneId, const std::string &assetId, int64_t pts,
// ArrayBuffer const &buffer, int width, int height)> cb)
export const EditorContext_setThumbnailCallback: (timelineId: number, cb: (laneId: string, assetId: string, pts: number, buffer: ArrayBuffer,
                                                                           width: number, height: number) => void) => void;

// void setFilterThumbnailCallback (int timelineId, std::function<void(const std::string &laneId, const std::string &assetId, const std::string &filterId,
// int64_t pts, ArrayBuffer const &buffer, int width, int height)> cb)
export const EditorContext_setFilterThumbnailCallback: (timelineId: number, cb: (laneId: string, assetId: string, filterId: string, pts: number,
                                                                                 pixelMap: image.PixelMap, width: number, height: number) => void) => void;

// void EditorContext_setPreviewPeriodRange (int timelineId, int64_t startTime, int64_t endTime)
export const EditorContext_setPreviewPeriodRange: (timelineId: number, startTime: number, endTime: number) => void;

// void saveProject (int timelineId, std::function<void(std::string const &jsonPos)> cb)
export const EditorContext_saveProject: (timelineId: number, cb: (jsonPos: string) => void) => void;

// void closeProject (int timelineId, std::function<void(std::string const &jsonPos)> cb)
export const EditorContext_closeProject: (timelineId: number, cb: (jsonPos: string) => void) => void;

// string updateEditData (std::string data)
export const EditorContext_updateEditData: (data: string) => string;

// bool isSystemEditData (std::string data)
export const EditorContext_isSystemEditData: (data: string) => boolean;

export const EditorContext_isThirdEditData: (data: string) => boolean;

export const EditorContext_IsOldFilterEditData: (data: string) => boolean;

export const EditorContext_HasWatermarkEffect: (data: string, cb: (jsonStr: string) => void) => boolean;

export const EditorContext_GetCropRotation: (data: string) => number;

// void applyEditData (int timelineId, int sourceFileFd, std::string editdata, int mediaType, std::function<void(std::string const &jsonPos)> cb)
export const EditorContext_applyEditData: (timelineId: number, sourceFileFd: number, editdata: string, mediaType: number,
                                           cb: (jsonStr: string) => void) => void;

export const EditorContext_UndoRedoManagerClear: () => void;

// void reset (int timelineId, std::function<void(std::string const &jsonPos)> cb)
export const EditorContext_reset: (timelineId: number, cb: (jsonStr: string) => void) => void;

// void setConfigChangeCallback (int timelineId, std::function<void(bool)> cb)
export const EditorContext_setConfigChangeCallback: (timelineId: number, cb: (bool: boolean) => void) => void;

// bool isDefaultConfig (int timelineId)
export const EditorContext_isDefaultConfig: (timelineId: number) => boolean;

// int64_t getCacheSize ()
export const EditorContext_getCacheSize: () => number;

// void clearCache ()
export const EditorContext_clearCache: () => void;

// void initWordContext (int timelineId, std::string const &text)
export const EditorContext_initWordContext: (timelineId: number, text: string) => void;

// std::string; Undo();
export const EditorContext_undo: () => string;

// std::string; Redo();
export const EditorContext_redo: () => string;

// std::string; Undo();
export const EditorContext_Start: () => void;

// std::string; Redo();
export const EditorContext_Stop: () => void;

// void RegUndoRedoStateChangeCb(int timelineId, std::function<void(bool undoEnable, bool redoEnable)> undoRedoStateChangeCb)
export const EditorContext_RegUndoRedoStateChangeCb: (undoRedoStateChangeCb: (undoEnable: boolean, redoEnable: boolean) => void) => void;

export const EditorContext_SetAutoFlush: () => void;

// void CalConfigChangeCallback(int timelineId)
export const EditorContext_CalConfigChangeCallback: (timelineId: number) => void;

// std::string getVideoLane (int timelineId)
export const Timeline_getVideoLane: (timelineId: number) => string;

// std::string getWordLanes (int timelineId)
export const Timeline_getWordLanes: (timelineId: number) => string;

// std::string appendVideoLane (int timelineId)
export const Timeline_appendVideoLane: (timelineId: number) => string;

// std::string appendVisionLane (int timelineId)
export const Timeline_appendVisionLane: (timelineId: number) => string;

// void removeLane (int timelineId, std::string const &laneId)
export const Timeline_removeLane: (timelineId: number, laneId: string) => void;

// void setLaneVisible (int timelineId, std::string const &laneId, bool visible)
export const Timeline_setLaneVisible: (timelineId: number, laneId: string, visible: boolean) => void;

// std::string GetWordAssetByPosition (int timelineId, double positionX, double positionY)
export const Timeline_GetWordAssetByPosition: (timelineId: number, positionX: number, positionY: number) => string;

// void appendAsset (int timelineId, std::string const &laneId, std::string const &path,int mediaType,
// lcdPixelMap: image.PixelMap, std::function<void(std::string const &jsonStr)> cb)
export const Lane_appendAsset: (timelineId: number, laneId: string, path: string, mediaType: number,
  lcdPixelMap: image.PixelMap, cb: (jsonStr: string) => void, editData: string, isMediaSource: boolean,
  isSupportWaterMark: boolean) => void;

export const Lane_replaceSource: (timelineId: number, laneId: string, path: string, cb: (res: number) => void) => void;

// void getAsset (int timelineId, std::string const &laneId, std::function<void(std::string const &jsonStr)> cb)
export const Lane_getAsset: (timelineId: number, laneId: string, cb: (jsonStr: string) => void) => void;

// void getWordAsset (int timelineId, std::string const &laneId, std::function<void(std::string const &jsonStr)> cb)
export const Lane_getWordAsset: (timelineId: number, laneId: string, cb: (jsonStr: string) => void) => void;

// void removeAllAssets (int timelineId, std::string const &laneId)
export const Lane_removeAllAssets: (timelineId: number, laneId: string) => void;

// 试听&背景音乐素材滑动调用
// void slideAsset (int timelineId, std::string const &assetId, std::string const &AudioAssetId, int64_t leftOffset)
export const Lane_slideAsset: (timelineId: number, assetId: string, AudioAssetId: string, leftOffset: number) => void;

// void appendWordAsset (int timelineId, std::string const &laneId, std::function<void(std::string const &jsonStr)> cb)
export const Lane_appendWordAsset: (timelineId: number, laneId: string, cb: (jsonStr: string) => void) => void;

// void removeWordAsset (int timelineId, std::string const &assetId)
export const Lane_removeWordAsset: (timelineId: number, assetId: string) => void;

//  没见实现，是否要去除？
// void getDuration (int timelineId, const std::string &assetId)
export const Asset_getDuration: (timelineId: number, assetId: string) => void;

//  没见实现，是否要去除？
// void getPath (int timelineId, std::string const &assetId)
export const Asset_getPath: (timelineId: number, assetId: string) => void;

// void requestThumbnail (int timelineId, std::string const &assetId, int64_t startMs, int64_t durationMs, int64_t intervalMs)
export const Asset_requestThumbnail: (timelineId: number, assetId: string, startMs: number, durationMs: number, intervalMs: number) => void;

// void requestThumbnailList (int timelineId, std::string const &assetId, std::vector<int64_t> requestList)
export const Asset_requestThumbnailList: (timelineId: number, assetId: string, requestList: number[]) => void;

// void SwitchCropPage (int timelineId, std::string const &assetId, int64_t pageId)
export const Asset_SwitchCropPage: (timelineId: number, assetId: string, pageId: number) => void;

// void FinishAnimation (int timelineId, std::string const &assetId)
export const Asset_FinishAnimation: (timelineId: number, assetId: string) => void;

// void Asset_CalculateFrameSize (int width, int height, cb: (jsonPos: string) => void)
export const Asset_CalculateFrameSize: (width: number, height: number, filterName: string,
  cb: (jsonPos: string) => void) => void;

// void requestFilterThumbnail (int timelineId, std::string const &assetId)
export const Asset_requestFilterThumbnail: (timelineId: number, assetId: string) => void;

// void cancelThumbnail (int timelineId, std::string const &assetId)
export const Asset_cancelThumbnail: (timelineId: number, assetId: string) => void;

// void setDeviceType (int timelineId, std::string const &assetId, std::string const &devType)
export const Asset_setDeviceType: (timelineId: number, assetId: string, devType: string) => void;

export const Asset_setSupportNewWatermark: (timelineId: number, assetId: string, supportNewWatermark: boolean) => void;

export const Asset_setEditDataType: (timelineId: number, assetId: string, editDataType: string) => void;

// void setRotation (int timelineId, std::string const &assetId, double rotation, int axis)
export const Asset_setRotation: (timelineId: number, assetId: string, rotation: number, axis: number) => void;

// void rotate90Acw (int timelineId, std::string const &assetId, std::function<void(std::string const &jsonPos)> cb)
export const Asset_rotate90Acw: (timelineId: number, assetId: string, frame: number, cb: (jsonPos: string) => void) => void;

// void initCropOperationArea (int timelineId, std::string const &assetId, std::vector<double> inputCropRect,
// std::vector<double> boundarySize, std::function<void(std::string const &jsonPos)> cb)
export const Asset_initCropOperationArea: (timelineId: number, assetId: string, inputCropRect: Array<number>,
                                           boundarySize: Array<number>, cb: (jsonPos: string) => void) => void;


// void UpdateCropOperationArea (int timelineId, std::string const &assetId, double left, double top, double right, double bottom, double canvasWidth,
// double canvasHeight, bool isDeviceVertical, int updateCropAreaType, std::function<void(std::string const &jsonPos)> cb)
export const Asset_UpdateCropOperationArea: (timelineId: number, assetId: string, left: number, top: number, right: number, bottom: number,
                                             canvasWidth: number, canvasHeight: number, isDeviceVertical: boolean, updateCropAreaType: number,
                                             cb: (jsonPos: string) => void) => void;

// void resetPosition (int timelineId, std::string const &assetId, std::function<void(std::string const &jsonPos)> cb)
export const Asset_resetPosition: (timelineId: number, assetId: string, cb: (jsonPos: string) => void) => void;

export const Asset_getCanvasPosition: (timelineId: number, assetId: string) => string;

// bool setCropRect (int timelineId, std::string const &assetId, double left, double top, double right, double bottom, double animMs, int clipRatioType,
// std::string const &chooseRatio,std::function<void(std::string const &jsonPos)> cb)
export const Asset_setCropRect: (timelineId: number, assetId: string, left: number, top: number, right: number, bottom: number, animMs: number,
                                 clipRatioType: number, chooseRatio: string, cb: (jsonPos: string) => void) => boolean;

// int translate (int timelineId, std::string const &assetId, double offsetX, double offsetY, int screenOperationType)
export const Asset_translate: (timelineId: number, assetId: string, offsetX: number, offsetY: number, screenOperationType: number) => number;

// void scale (int timelineId, std::string const &assetId, double scale, double centerX, double centerY)
export const Asset_scale: (timelineId: number, assetId: string, scale: number, centerX: number, centerY: number) => void;

export const Asset_calculateCropSize: (timelineId: number, assetId: string, cb: (width: number, height: number) => void) => void;

// void switchPreviewMode (int timelineId, std::string const &assetId)
export const Asset_getPreviewMaxScale: (timelineId: number, assetId: string) => number;

// bool fillCropRect (int timelineId, std::string const &assetId, int cropType, int aniDuration, double left, double top, double right, double bottom,
// std::function<void(std::string const &jsonPos)> cb)
export const Asset_fillCropRect: (timelineId: number, assetId: string, cropType: number, aniDuration: number, left: number, top: number, right: number,
                                  bottom: number, cb: (jsonPos: string) => void) => boolean;

// void switchPreviewMode (int timelineId, std::string const &assetId)
export const Asset_switchPreviewMode: (timelineId: number, assetId: string) => void;

// void switchCropMode (int timelineId, std::string const &assetId, std::function<void(std::string const &jsonPos)> cb)
export const Asset_switchCropMode: (timelineId: number, assetId: string) => void;

export const Asset_switchPageRender: (timelineId: number, assetId: string) => void;

// void switchTextMode (int timelineId, std::string const &assetId)
export const Asset_switchTextMode: (timelineId: number, assetId: string) => void;

// std::string calcOptimalRectUnderRatio (int timelineId, std::string const &assetId, double left, double top, double right, double bottom, double ratio)
export const Asset_calcOptimalRectUnderRatio: (timelineId: number, assetId: string, left: number, top: number, right: number, bottom: number,
                                               ratio: number) => string;

// std::string getReachableCropRect (int timelineId, std::string const &assetId, double left, double top, double right, double bottom, double ratio,
// int dleft, int dtop, int dright, int dbottom, std::function<void(std::string const &jsonPos)> cb)
export const Asset_getReachableCropRect: (timelineId: number, assetId: string, left: number, top: number, right: number, bottom: number, ratio: number,
                                          dleft: number, dtop: number, dright: number, dbottom: number, cb: (jsonPos: string) => void) => string;

// std::string ReverseCrop (int timelineId, std::string const &assetId, std::vector<double> inputCropRect, double ratio,
// std::vector<int> direction, double pressure)
export const Asset_ReverseCrop: (timelineId: number, assetId: string, inputCropRect: Array<number>, ratio: number, direction: Array<number>,
                                 pressure: number) => string;


// void setMirror (int timelineId, std::string const &assetId, int mirrorFlag, int mirrorType, std::function<void(std::string const &jsonPos)> cb)
export const Asset_setMirror: (timelineId: number, assetId: string, mirrorFlag: number, mirrorType: number, cb: (jsonPos: string) => void) => void;

// void SetAdjustValue (int timelineId, std::string const &assetId, std::string const &adjustName, int value)
export const Asset_SetAdjustValue: (timelineId: number, assetId: string, adjustName: string, value: number, cb: (jsonStr: string) => void) => void;

// void Asset_GetRefreshThumbnails: (timelineId: number, assetId)
export const Asset_GetRefreshThumbnails: (timelineId: number, assetId) => boolean;

// void SetAdjustEnable (int timelineId, std::string const &assetId, std::string const &adjustName, bool enabled)
export const Asset_SetAdjustEnable: (timelineId: number, assetId: string, adjustName: string, enabled: boolean, cb: (jsonStr: string) => void) => void;

// void PreloadAdjustResource (int timelineId, std::string const &assetId)
export const Asset_PreloadAdjustResource: (timelineId: number, assetId: string) => void;

// std::string GetAdjustProperty (int timelineId, std::string const &assetId)
export const Asset_GetAdjustProperty: (timelineId: number, assetId: string) => string;

// void ResetAdjustProperty (int timelineId, std::string const &assetId)
export const Asset_ResetAdjustProperty: (timelineId: number, assetId: string) => void;

// void SetCropBlurEnable (int timelineId, std::string const &assetId, bool enabled)
export const Asset_SetCropBlurEnable: (timelineId: number, assetId: string, enabled: boolean) => void;

// void SetRefreshRate (int timelineId, std::string const &assetId, int refreshRate)
export const Asset_SetRefreshRate: (timelineId: number, assetId: string, refreshRate: number) => void;

export const Asset_AddStylus: (timelineId: number, assetId: string, dstPixelMap: image.PixelMap,
                               x: number, y: number, width: number, height: number,
                               callback: (pixelMap: image.PixelMap) => void) => void;

export const Asset_IsSupportEffect: (name: string) => boolean;

// int SetOriginalColorMode (int timelineId, std::string const &assetId, int mode)
export const Asset_SetOriginalColorMode: (timelineId: number, assetId: string, mode: number) => number;

// int GetOriginalColorMode (int timelineId, std::string const &assetId)
export const Asset_GetOriginalColorMode: (timelineId: number, assetId: string) => number;

// void SetWordText (int timelineId, std::string const &assetId, std::string const &text, std::function<void(std::string const &jsonPos)> cb)
export const Asset_SetWordText: (timelineId: number, assetId: string, text: string, cb: (jsonPos: string) => void) => void;

// void SetWordTextStyle (int timelineId, std::string const &assetId, int fontColor, int type, int styleColor)
export const Asset_SetWordTextStyle: (timelineId: number, assetId: string, fontColor: number, type: number, styleColor: number) => void;

// void TranslateWordAsset (int timelineId, std::string const &assetId, double offsetX, double offsetY, std::function<void(std::string const &jsonPos)> cb)
export const Asset_TranslateWordAsset: (timelineId: number, assetId: string, offsetX: number, offsetY: number, cb: (jsonPos: string) => void) => void;

// void ScaleWordAsset (int timelineId, std::string const &assetId, double scale, std::function<void(std::string const &jsonPos)> cb)
export const Asset_ScaleWordAsset: (timelineId: number, assetId: string, scale: number, cb: (jsonPos: string) => void) => void;

// void RotationWordAsset (int timelineId, std::string const &assetId, double rotation, std::function<void(std::string const &jsonPos)> cb)
export const Asset_RotationWordAsset: (timelineId: number, assetId: string, rotation: number, cb: (jsonPos: string) => void) => void;

// void SetWordFontSize (int timelineId, std::string const &assetId, int fontSize, std::function<void(std::string const &jsonPos)> cb)
export const Asset_SetWordFontSize: (timelineId: number, assetId: string, fontSize: number, cb: (jsonPos: string) => void) => void;

// void SetWordPositionChangeCallback (int timelineId, std::string const &assetId, std::function<void(std::string const &assetId,
// std::string const &jsonPos)> cb)
export const Asset_SetWordPositionChangeCallback: (timelineId: number, assetId: string, cb: (assetId: string, jsonPos: string) => void) => void;

// void SetWordTimePosChangeCallback (int timelineId, std::string const &assetId, std::function<void(std::string const &assetId,
// std::string const &jsonPos)> cb)
export const Asset_SetWordTimePosChangeCallback: (timelineId: number, assetId: string, cb: (assetId: string, jsonPos: string) => void) => void;

// void SetWordBoxWidthRatio (int timelineId, std::string const &assetId, double boxWidthRatio, double offsetX,
// std::function<void(std::string const &jsonPos)> cb)
export const Asset_SetWordBoxWidthRatio: (timelineId: number, assetId: string, boxWidthRatio: number, offsetX: number, cb: (jsonPos: string) => void) => void;

// void SetWordFont (int timelineId, std::string const &assetId, int index, std::function<void(std::string const &jsonPos)> cb)
export const Asset_SetWordFont: (timelineId: number, assetId: string, index: number, cb: (jsonPos: string) => void) => void;

// void ModifyWordAssetTimePos (int timelineId, std::string const &assetId, int startTime, int endTime, std::function<void(std::string const &jsonPos)> cb)
export const Asset_ModifyWordAssetTimePos: (timelineId: number, assetId: string, startTime: number, endTime: number, cb: (jsonPos: string) => void) => void;

// void SetUserData (int timelineId, std::string const &assetId, std::string const &key, double value)
export const Asset_SetUserData: (timelineId: number, assetId: string, key: string, value: number) => void;

// double GetUserData (int timelineId, std::string const &assetId, std::string const &key)
export const Asset_GetUserData: (timelineId: number, assetId: string, key: string) => number;

export const Asset_SetSourceByPixelMap: (timelineId: number, assetId: string, pixelMap: image.PixelMap) => number;

// double ResetFrictionMotion(double friction, double initPosition, double initVelocity)
export const Motion_ResetFrictionMotion: (friction: number, initPosition: number, initVelocity: number) => number;

// double GetPosition(double offsetTime)
export const Motion_GetPosition: (offsetTime: number) => number;

// double GetVelocity(double offsetTime)
export const Motion_GetVelocity: (offsetTime: number) => number;

// void InitEnv (std::string const &version)
export const NAPIMaterial_InitEnv: (version: string) => void;

// void SetUrls (std::string const &urls)
export const NAPIMaterial_SetUrls: (urls: string) => void;

// void SetCountryCode (std::string const &countryCode)
export const NAPIMaterial_SetCountryCode: (countryCode: string) => void;

// void InitNetwork (std::function<void(int result, const std::string& msg)> cb)
export const NAPIMaterial_InitNetwork: (cb: (result: number, msg: string) => void) => void;

// void GetHWMusicColumn (std::function<void(int result, const std::string& msg)> cb)
export const NAPIMaterial_GetHWMusicColumn: (cb: (result: number, msg: string) => void) => void;

// void GetHWMusicList (std::string const &columnUid, int offset, int count, std::function<void(int result, const std::string& msg)> cb)
export const NAPIMaterial_GetHWMusicList: (columnUid: string, offset: number, count: number, cb: (result: number, msg: string) => void) => void;

// void DownloadHWMusic (std::string const &columnUid, std::function<void(int result, const std::string& msg)> cb)
export const NAPIMaterial_DownloadHWMusic: (columnUid: string, cb: (result: number, msg: string) => void) => void;

export const aiEditorContextInitEditor: (importPixelMap: image.PixelMap, enableDownSampling: boolean,
                                         useAiRemove: boolean, resultCb: (res: boolean) => void) =>void;

export const aiEditorContextDeinitEditor: () =>void;

export const aiEditorContextGetCurFusionCount: () =>number;

export const aiEditorContextUploadMoveExtraPatch: (pixelMap: image.PixelMap, pixelMapIndex: string,
  resultCb: (res: boolean) => void) =>void;

export const aiEditorContextRefreshEditor: (importPixelMap: image.PixelMap, resultCb: (res: boolean) => void) =>void;

export const aiEditorContextChangeEditorType: (type: string, resultCb: (res: boolean) => void) =>void;

export const aiEditorContextSegObject: (
  resultCb: (res: boolean, hasObject: boolean, outputMask: Array<number>, contourJson: string) => void) =>void;

export const aiEditorContextClickObjectWithPoint: (selectX: number, selectY: number,
  imageWidth: number, imageHeight: number, resultCb: (res: boolean, isObject: boolean, hasObject: boolean,
    outputMask: Array<number>, contourJson: string) => void) => void;

export const aiEditorContextDoBackgroundBlur: (blur: number, blurFlag: boolean, recordFlag: boolean,
                                               resultCb: (res: boolean, displayPixelMap: image.PixelMap) => void) =>void;

export const aiEditorContextEnableBackgroundBlur: (blurEnable: boolean,
                                                   resultCb: (res: boolean, displayPixelMap: image.PixelMap) => void) =>void;

export const aiEditorContextEnableBackgroundDecolorization: (decolorizationEnable: boolean,
                                                             resultCb: (res: boolean, displayPixelMap: image.PixelMap) => void) =>void;

export const aiEditorContextReprocessBackground: (
  resultCb: (res: boolean, displayPixelMap: image.PixelMap) => void) =>void;

export const aiEditorContextDoInteractionSeg: (maskPixelMap: image.PixelMap, segType: string,
                                               resultCb: (res: boolean, outputMaskPixelMap: image.PixelMap) => void) =>void;

export const aiEditorContextDoObjectSeg: (maskPixelMap: image.PixelMap, segType: string,
  resultCb: (res: boolean, outputMaskPixelMap: image.PixelMap) => void) =>void;

export const aiEditorContextDoObjectMoveOperation: (info: string, objectEditType: string,
  beginX: number, beginY: number, endX: number, endY: number, beginAngle: number, endAngle: number, beginScale: number,
  endScale: number, beginIndexInLinkedList: number, resultCb: (res: boolean) => void) => void;

export const aiEditorContextGetMoveObjectMaskInfo: (resultCb: (res: string) => void) =>void;

export const aiEditorContextDoObjectRemove: (resultCb: (res: boolean, outputTypeStr: string, removePolicy: number,
                                                        displayPixelMap: image.PixelMap) => void) =>void;

export const aiEditorContextDoObjectMoveAI2Remove: (resultCb: (res: boolean, outputTypeStr: string, removePolicy: number,
  displayPixelMap: image.PixelMap) => void) =>void;

export const aiEditorContextAiMoveSegmentOneStep: (maskPixelMap: image.PixelMap,
  resultCb: (res: boolean, outputMaskPixelMap: image.PixelMap) => void) =>void;

export const aiEditorContextAiMoveCutoutOneStep: (resultCb: (res: boolean, outputTypeStr: string, removePolicy: number,
  displayPixelMap: image.PixelMap) => void) =>void;

export const aiEditorContextDoObjectFusion: (selectPixelMap: Array<image.PixelMap>, selectedMaskBbox: Array<String>,
  extraObject: Array<image.PixelMap>, editedInfo: Array<String>, originWidth: number, originHeight: number,
  originChannel: number, resultCb: (res: boolean, outputTypeStr: string, outputMaskPixelMap: image.PixelMap) => void) => void;

export const aiEditorContextCancelObjectOperation: () =>void;

export const aiEditorContextRedo: (resultCb: (res: boolean, optType: string) => void) =>void;

export const aiEditorContextUndo: (resultCb: (res: boolean, optType: string) => void) =>void;

export const aiEditorContextMoveEnterReSegment: (resultCb: (res: boolean, optType: string) => void) =>void;

export const aiEditorContextGetPreOptType: () =>string;

export const aiEditorContextGetUndoStepType: () =>string;

export const aiEditorContextGetCurMaskPixelMap: () =>image.PixelMap;

export const aiEditorContextGetCurBlurLevel: () =>number;

export const aiEditorContextGetCurBlurEnable: () =>boolean;

export const aiEditorContextGetCurDecolorizationEnable: () =>boolean;

export const aiEditorContextGetCurObjectMask: () =>Array<number>;

export const aiEditorContextGetCurObjectContourJson: () =>string;

export const aiEditorContextGetBackgroundStatJson: () =>string;

export const aiEditorContextGetCurOutputPixelMap: () =>image.PixelMap;

export const aiEditorContextGetCurCutoutPixelMap: () =>image.PixelMap;

export const aiEditorContextGetRedoSize: () =>number;

export const aiEditorContextGetUndoSize: () =>number;

export const aiEditorContextIsAiEdited: () =>boolean;

export const aiEditorContextIsAiEditedInCurEditor: () =>boolean;

export const aiEditorContextIsAiLableNeeded: () =>boolean;

export const aiEditorContextIsUndoMove: () =>boolean;

export const aiEditorContextGetExportPixelMap: (
  resultCb: (res: boolean, isAiEdited: boolean, exportPixelMap: image.PixelMap) => void, sourceFlowType: number) =>void;

export const aiEditorContextSaveExportFile: (outputPath: string, quality: number,
                                             resultCb: (res: boolean) => void) =>void;

export const aiEditorContextGetMaskContours: (maskArray: ArrayBuffer, width: number, height: number) => string;

export const aiEditorContextGetHSDMaskContours: (maskArray: ArrayBuffer, picSize: [], compSize: []) => string;

export const aiEditorContextGetHSDPreprocessData: (maskArray: ArrayBuffer, picSize: [], compSize: [],
  resultCb: (maskPixelMapBuffer: ArrayBuffer, newOverlay: image.PixelMap, pathPoints: string,
    ctrlPoints: string) => void) => string;

export const aiEditorContextCreateMaskBuffer: (maskArray: ArrayBuffer, width: number, height: number, isNeedSetOpacity: boolean) => ArrayBuffer;

export const aiEditorContextGaussianBlurMask: (imageArray: ArrayBuffer, maskArray: ArrayBuffer, width: number, height: number) => ArrayBuffer;

export const aiEditorContextExtractImageByMask: (imageArray: ArrayBuffer, maskArray: ArrayBuffer, width: number, height: number, resultCb: (buffer: ArrayBuffer,
  maskBuffer: ArrayBuffer, width: number, height: number, posX: number, posY: number) => void) => void;

export const aiEditorContextPixelMapToMask: (imageArray: ArrayBuffer, width: number, height: number, maskWidth: number, maskHeight: number) => ArrayBuffer;

export const AIEditorContext_PixelMapToMask: (imageArray: ArrayBuffer, width: number, height: number, maskWidth: number,
  maskHeight: number) => ArrayBuffer;

export const AIEditorContext_CancelReflectionUpload: () => boolean;

export const AIEditorContext_SaveExpandOperation: (iLeft: number, iTop: number, iRight: number, iBottom: number,
  eLeft: number, eTop: number, eRight: number, eBottom: number, ratio: number, mirror: boolean) => boolean;

export const AIEditorContext_SaveRawExpandRect: (eLeft: number, eTop: number, eRight: number,
  eBottom: number) => boolean;

export const AIEditorContext_GetExpandOperation: (resultCb: (res: string, pixelMap: image.PixelMap) => void) => void;

export const AIEditorContext_GetRemoveReflectOperation: (resultCb: (pixelMap: image.PixelMap) => void) => void;

export const AIEditorContext_GetInitExpandImageInfo: (isCompose: boolean,
  resultCb: (res: boolean, infos: string) => void) => number;

export const AIEditorContext_CancelInitExpandImageInfo: (initComposeTaskId: number) => boolean;

export const AIEditorContext_DoImageExpand: (x: number, y: number, width: number, height: number, ratio: number,
  mirror: boolean, resultCb: (res: string, pixelMap: image.PixelMap) => void) => void;

export const AIEditorContext_CancelImageExpand: () => boolean;

export const AIEditorContext_GetUndoPixelMapSize: () => number;

export const AIEditorContext_GetRedoPixelMapSize: () => number;

export const AIEditorContext_DoRefine: (configure: string, cb: (res: string) => void) => void;

export const AIEditorContext_UploadImage: () => void;

export const AIEditorContext_ChangeLightOrBlur: (configure: string, cb: (res: boolean) => void) => boolean;

export const AIEditorContext_ChangeStyleOrCompose: (configure: string, cb: (res: boolean) => void) => boolean;

export const AIEditorContext_GetDisplayPixelMapAsync: (cb: (pixelMap: image.PixelMap) => void) => void;

export const AIEditorContext_SetImageConfig: (apertureFlag: boolean, portraitFlag: boolean, cloudCameraFlag: boolean,
  aiPSFlag: boolean) => void;

export const AIEditorContext_CancelDoRefine: () => boolean;

export const AIEditorContext_CancelRefineUpload: () => boolean;

export const AIEditorContext_ReleaseRefineAIGCSource: () => boolean;

export const AIEditorContext_ChangeOutPutPixelMapType: (isHdr: boolean) => boolean;

export const AIEditorContext_GetStyleThumbs: (configure: string, ids: number,
  cb: (pixels: image.PixelMap) => void) => boolean;

export const AIEditorContext_FaceDetection: (cb: (res: boolean) => void) => void;

export const AIEditorContext_DiscardGainMap: () => void;

export const AIEditorContext_GetIsDoRefineMasterValue: () => boolean;

export const aiEditorContextDoReplaceEmo: (faceId: number, imageId: number,
  resultCb: (res: boolean, displayPixelMap: image.PixelMap) => void) => void;

export const aiEditorContextGetReplaceFaceDst: (cb: (dstState: number, faceId: number, x: number,
  y: number, w: number, h: number, width: number, height: number) => void) => void;

export const aiEditorContextSetReplacePixelmap: (imageId: number, pixelMap: image.PixelMap, mapSize: number,
  cb: (replaceState: number, faceId: number, x: number, y: number, w: number, h: number,
    width: number, height: number) => void) => void;

export const aiEditorContextReturnReplaceEmo: (faceId: number, nowTime: number, cb: (isPopupUpdate: boolean,
  imageId: string, x: number, y: number, width: number, height: number, thisTime: number) => void) => void;

export const aiEditorContextGetSrcEmo: (imageId: string) => image.PixelMap;

export const Asset_AddXtStyleParamToWatermark: (timelineId: number, assetId: string, xtStyleTextParams: Array<string>,
  autoFlush: boolean, needInitCache: boolean) => void;

export const EditorContext_HasXTStyleEffect: (data: string) => string;

export const EditorContext_setXTStyleThumbnailCallback: (timelineId: number,
  cb: (pixelMap: image.PixelMap, jsonStr: string) => void) => void;

export const Asset_requestXTStyleThumbnail: (timelineId: number, assetId: string, xtStyleParams: Array<number>) => void;

export const Asset_DoPreviewAvoidanceAnimation: (timelineId: number, assetId: string, canvasSize: number[]) => void;

export const Asset_SetPreviewMode: (timelineId: number, assetId: string, value: boolean) => void;

export const Asset_GetCurrentXtStyleParams: (timelineId: number, assetId: string) => string;

export const Asset_SetShowWatermarkValue: (timelineId: number, assetId: string, value: boolean) => void;

export const Asset_RefreshCompareEffectList: (timelineId: number, assetId: string) => void;

export const Asset_SwitchTabWidthWatermarkAnim: (timelineId: number, assetId: string, type: number) => void;

export const Asset_GetExportSize: (timelineId: number, assetId: string,
  cb: (width: number, height: number) => void) => void;

export const Asset_getIntelligentCorrectionValue: (timelineId: number, assetId: string) => number;

export const IsSupports_DifferentiatedAlgorithms: (editData: string) => number;

export const EditorContext_encodePixelMap: (timelineId: number, path: string, assetId: string, mediaType: number,
  mimeType: string, pixelMap: image.PixelMap, waterMarkInfo: string,
  callback: (json: string, type: string) => void) => void;

export const Asset_GetExifXtStyleParam: (timelineId: number, assetId: string) => Array<number>;

export const AIEditorContext_SetModelCachePath: (cacheModel: string) => void;

export const AIEditorContext_SetFastSegPixmap: (segPixelMap: image.PixelMap) => void;

export const EditorContext_releaseFlowSource: (sourceFlowType: number) => void;

export const Asset_SetProjectConfigValue: (key:string, value: string) => boolean;

export const Asset_GeneratorRfDataB: (timelineId: number, assetId: string, callback: (res: boolean) => void) => void;

export const EditorContext_waitTaskFinish: (timelineId: number, callback: () => void) => void;