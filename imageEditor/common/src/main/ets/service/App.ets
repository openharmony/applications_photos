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
import { BaseEditor, Timeline } from './BaseEditor';
import { GetExportDataOptions, IEditor, SourceFlowType } from './IEditor';
import { ImageMediaLibraryProxy } from '../common/proxy/MediaLibraryProxy';
import { InstanceData } from './InstanceData';
import window from '@ohos.window';
import { GlobalThisUtil } from '../common/util/GlobalThisUtil';
import { HiLog } from '../common/util/HiLog';
import { AiTabName, EditorType, TabName } from './model/Enum';
import uiExtensionHost from '@ohos.uiExtensionHost';
import { LightWeightMap } from '@kit.ArkTS';
import { RedoMap, RedoModel } from './RedoClass';
import { image } from '@kit.ImageKit';
import { PHOTO_BUNDLE_NAME, AVOID_LEFT_OFFSET } from '../common/const';
import { EditorParams } from './EditorSDK';
import { Trace } from '../common/util/Trace';
import { performanceMonitor } from '@kit.ArkUI';
import { ScreenManager } from '../common/util/ScreenManager';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { ComposeUtil } from '../common/util/ComposeUtil';
import { PixelMapUtil } from '../common/util/PixelMapUtil';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';
import { TextAreaManager } from './model/tabTextEdit/viewModel/TabTextAreaManager';

/* instrument ignore file */
let _baseEditor: BaseEditor | null = null;
const TAG: string = 'Project';
const KEY_IMAGE_EDITOR_PROJECT: string = 'key_image_editor_project';

let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

export enum MenuChangeType {
  NO_CHANGE,
  CROP_TO_NO_CROP,
  NO_CROP_TO_CROP,
  NO_CROP_TO_NO_CROP
}

@Observed
export class ScreenClass {
  // 标识画布切换类型，用于制作动效；0：菜单未切换；1：裁剪跳非裁剪；2：非裁剪跳裁剪；3：非裁剪跳非裁剪
  public screenChangeType: MenuChangeType = MenuChangeType.NO_CHANGE;
  public avoidLeft: number = 0;
  public avoidRight: number = 0;
  public avoidTop: number = 0;
  public avoidBottom: number = 0;
  public isAvoidAreaChanged: boolean = true;

  public setAvoidInfo(avoidLeft: number, avoidRight: number, avoidTop: number, avoidBottom: number, from: number = -1) {
    let isAvoidAreaChanged = this.avoidLeft !== avoidLeft || this.avoidRight !== avoidRight ||
      this.avoidTop !== avoidTop || this.avoidBottom !== (avoidBottom ? avoidBottom : 0);
    HiLog.i(TAG,
      `setAvoidInfo avoidLeft: ${avoidLeft}_${this.avoidLeft}, avoidRight:${avoidRight}_${this.avoidRight}` +
        ` avoidTop:${avoidTop}_${this.avoidTop}, avoidBottom: ${avoidBottom}_${this.avoidBottom}, from: ${from}, isAvoidAreaChanged： ${isAvoidAreaChanged}`)
    this.avoidLeft = avoidLeft;
    this.avoidRight = avoidRight;
    this.avoidTop = avoidTop;
    this.avoidBottom = avoidBottom ? avoidBottom : 0;
    AppStorage.setOrCreate<number>(AVOID_LEFT_OFFSET, avoidLeft);
  }
}

@Observed
class Project {
  public undoRedoInfo: UndoRedoInfo = new UndoRedoInfo();
  public preUndoRedoInfo: UndoRedoInfo = new UndoRedoInfo();
  public screenClass: ScreenClass = new ScreenClass();
  public editorParams: EditorParams | undefined = undefined;
  private _instanceData: InstanceData | null = null;
  private _curType: EditorType = EditorType.Base;
  private isProjectClosed: boolean = false;
  private aiMoveDialogCallback: Function | undefined;

  public static getInstance(localStorage?: LocalStorage): Project {
    let storage = localStorage ? localStorage : LocalStorage.getShared();
    let project = storage?.get<Project>(KEY_IMAGE_EDITOR_PROJECT);
    if (!project) {
      HiLog.i(TAG, 'project is null.and create new project');
      project = new Project();
      storage?.setOrCreate(KEY_IMAGE_EDITOR_PROJECT, project);
    }
    return project;
  }

  myEditor(): BaseEditor {
    if (_baseEditor == null) {
      _baseEditor = new BaseEditor()
      _baseEditor.init();
    }
    return _baseEditor;
  }

  needConfirmBack() {
    return this.myEditor().isEdited() || TextAreaManager.getInstance().getTextAreaList().length > 0;
  }

  curEditor(): IEditor {
    switch (this._curType) {
      case EditorType.Base:
        return this.myEditor();
      default:
        break;
    }
    return this.myEditor();
  }

  hasBaseEditorExist(): boolean {
    return _baseEditor !== null;
  }

  init(): void {
    let storage = LocalStorage.getShared();
    let mainWin = storage?.get<window.Window>('mainWindow');
    let windowStage = storage?.get<window.WindowStage>('photosWindowStage');
    let context = storage?.get<Context>('photosAbilityContext');
    let uiExtensionHost = storage?.get<uiExtensionHost.UIExtensionHostWindowProxy>('photosUiExtensionStage') as
    uiExtensionHost.UIExtensionHostWindowProxy;
    if ((!mainWin && !windowStage && !uiExtensionHost) || !context) {
      HiLog.e(TAG, 'initPetalClip: mainWindow&&windowStage&&uiExtensionHost or context is null!')
      return;
    }
    if (!this._instanceData) {
      this._instanceData = this.getInstanceData();
    }
    GlobalThisUtil.setProperty('image_editor_MediaLibraryProxy', ImageMediaLibraryProxy.getInstance(context))
    if (mainWin) {
      storage?.setOrCreate('editor_mainWindow', mainWin);
    } else {
      windowStage?.getMainWindow().then((mainWindow: window.Window) => {
        storage?.setOrCreate('editor_mainWindow', mainWindow);
      })
    }
    if (uiExtensionHost) {
      HiLog.i(TAG, `initPetalClip: set uiExtensionHost = ${uiExtensionHost}`)
      storage?.setOrCreate('editor_UiExtensionStage', uiExtensionHost);
    }
  }

  clearAppData(): void {
    HiLog.i(TAG, 'do clearAppData');
    this._curType = EditorType.Base;
    _baseEditor = null;
    this.undoRedoInfo.canUndo = false;
    this.undoRedoInfo.canRedo = false;
    this.undoRedoInfo.isShowUnRedoButton = false;
    this.preUndoRedoInfo.canUndo = false;
    this.preUndoRedoInfo.canRedo = false;
    this.preUndoRedoInfo.isShowUnRedoButton = false;
    this.undoRedoInfo = new UndoRedoInfo();
  }

  instanceData(): InstanceData {
    if (this._instanceData === null) {
      HiLog.e(TAG, 'instanceData is null');
      this._instanceData = this.getInstanceData();
      this.init();
      return this._instanceData;
    }
    return this._instanceData;
  }

  private getInstanceData(): InstanceData {
    let windowStage = GlobalThisUtil.getLocalProperty('photosWindowStage') as window.WindowStage;
    let context = GlobalThisUtil.getLocalProperty('photosAbilityContext') as Context;
    return new InstanceData(context, windowStage);
  }

  openProject(callBack: Function): void {
    callBack();
  }

  closeProject(callBack: Function): void {
    this.isProjectClosed = true;
    callBack();
  }

  saveProject(callBack: Function): void {
    switch (this._curType) {
      case EditorType.Base:
        callBack();
        break;
      case EditorType.AI:
        callBack();
        break;
      default:
        break;
    }
  }

  setExportResultCallback(callback: Function | undefined): void {
    HiLog.i(TAG, 'setExportResultCallback');
    switch (this._curType) {
      case EditorType.Base:
        this.myEditor().setExportResultCallback(callback);
        break;
      default:
        break;
    }
  }

  setExportProgressCallback(callback: Function | undefined): void {
    HiLog.i(TAG, 'setExportProgressCallback');
    switch (this._curType) {
      case EditorType.Base:
        this.myEditor().setExportProgressCallback(callback);
        break;
      default:
        break;
    }
  }

  public saveEditedFile(timeline: Timeline, startTime: number, endTime: number, outputPath:
    string, assertUid: string, mediaType: MediaType, mimeType: string,
    callback: (exportInfo: string, type: string) => void): void {
    HiLog.i(TAG, `saveEditedFile curEditType: ${this._curType}`);
    switch (this._curType) {
      case EditorType.Base:
        this.myEditor()
          .compileTimeline(timeline, startTime, endTime, outputPath, assertUid, mediaType, mimeType, callback);
        break;
      default:
        break;
    }
  }

  public cancelSaveEditedFile(timeline: Timeline, assertUid: string,
    callback: () => void): void {
    switch (this._curType) {
      case EditorType.Base:
        this.myEditor().cancelCompileTimeline(timeline, assertUid, callback);
        break;
      default:
        break;
    }
  }

  setType(type: EditorType, onChanged: Function) {
    HiLog.i(TAG, `setType type=${type}, this._curType=${this._curType}`);
    if (this._curType === type) {
      HiLog.i(TAG, 'setType same with curType and return');
      ScreenManager.getInstance().setIsQueryUserLogin(false);
      return;
    }
    if (type === EditorType.Base) {
      ScreenManager.getInstance().setIsQueryUserLogin(false);
      // 如果切换至基础编辑页面，将AI修图页面BackPress方法释放掉
      this.changeToBaseEditor(type);
    } else if (type === EditorType.AI) {
      // 设置ai修图的侧边栏返回事件
      Project.getInstance().instanceData().onAiEditorBackPress = (): boolean => {
        HiLog.i(TAG, 'enter onAiEditorBackPress callback');
        Project.getInstance().setType(EditorType.Base, () => {
          HiLog.i(TAG, 'setType Base back');
        });
        return true;
      };
      this.setAiType(type);
    }
    onChanged();
  }

  private changeToBaseEditor(type: EditorType) {
    Project.getInstance().instanceData().onAiEditorBackPress = undefined;
    this.setBaseType(type);
  }

  private setAiType(type: EditorType) {
    performanceMonitor.begin('CUSTOM_ANIMATOR changeType setAiType', performanceMonitor?.ActionType.LAST_UP);
    if (!this.myEditor().isComposedTab()) {
      this.getExportData(type);
    } else {
      const pm = this.myEditor().asset.exportPixelMap;
      if (pm !== undefined) {
        const clonedPm = ComposeUtil.clonePixelMap(pm);
        HiLog.i(TAG, 'switch with existing map');
        PixelMapUtil.setMemoryNameSync(clonedPm, 'AiInputFromExport');
        this.setProperty(type, this.undoRedoInfo.canUndo, this.undoRedoInfo.canRedo,
          this.undoRedoInfo.isShowUnRedoButton, clonedPm, '', '');
      } else {
        this.getExportData(type);
      }
    }
    performanceMonitor.end('CUSTOM_ANIMATOR changeType setAiType');
  }

  private getExportData(type: EditorType) {
    this.myEditor().getExportData((pixelmap: image.PixelMap, exportInfo: string, waterMarkInfo: string) => {
      HiLog.i(TAG, `getExportData exportInfo is ${exportInfo}`);
      pixelmap.getImageInfo().then((imageInfo: image.ImageInfo) => {
        HiLog.i(TAG, `setAiType image info get from pixelmap: ${JSON.stringify(imageInfo)}`);
      });
      this.setProperty(type, this.undoRedoInfo.canUndo, this.undoRedoInfo.canRedo,
        this.undoRedoInfo.isShowUnRedoButton, pixelmap, exportInfo, waterMarkInfo);
    }, new GetExportDataOptions().setIsToAiPage(true));
  }

  private setProperty(type: EditorType, canUndo: boolean, canRedo: boolean, isShowUnRedoButton: boolean,
    pixelMap: image.PixelMap, exportInfo: string, waterMarkInfo: string) {
    HiLog.i(TAG, `setProperty type is ${type}`);
    this._curType = type;
    this.preUndoRedoInfo.canUndo = canUndo;
    this.preUndoRedoInfo.canRedo = canRedo;
    this.preUndoRedoInfo.isShowUnRedoButton = isShowUnRedoButton;
    this.myEditor().getAssetData((mediaAsset) => {
      HiLog.i(TAG, `getReplaceData mediaAsset is ${mediaAsset?.uri}`);
    });
    ScreenManager.getInstance().setIsQueryUserLogin(false);
  }

  public setAiMoveDialogCallback(callback: Function | undefined) {
    this.aiMoveDialogCallback = callback;
  }

  private setBaseType(type: EditorType) {
    HiLog.i(TAG, 'setBaseType');
    // AI修图有修改时，覆盖PixelMap，不修改直接返回不覆盖PixelMap
    if (!this.myEditor().stylusModified) {
      appBroadCast.emit('LeaveAiEditor');
      HiLog.i(TAG, `setBaseType with ai edit un-modified. type = ${type}`);
      this._curType = type;
      this.undoRedoInfo.canUndo = this.preUndoRedoInfo.canUndo;
      this.undoRedoInfo.canRedo = this.preUndoRedoInfo.canRedo;
      this.undoRedoInfo.isShowUnRedoButton = this.preUndoRedoInfo.isShowUnRedoButton;
      this.myEditor().asset.adjusts().isResetSelected = true;
      return;
    }
  }

  getType(): EditorType {
    return this._curType;
  }

  undo() {
    switch (this._curType) {
      case EditorType.Base:
        this.myEditor().undo();
        break;
      default:
        break;
    }
  }

  redo() {
    switch (this._curType) {
      case EditorType.Base:
        this.myEditor().redo();
        break;
      default:
        break;
    }
  }

  switchStylusMode(reportNum?: number) {
    switch (this._curType) {
      case EditorType.Base:
        this.myEditor().switchStylusMode(reportNum);
        break;
      default:
        break;
    }
  }

  public getCurEditorType(): EditorType {
    HiLog.i(TAG, `getCurEditorType is ${this._curType}`);
    return this._curType;
  }

  public isFromMoving(): boolean {
    return !['default', undefined].includes(this.editorParams?.entryType);
  }
}

@Observed
export class UndoRedoInfo {
  public isShowUnRedoButton: boolean = false;
  public canUndo: boolean = false;
  public canRedo: boolean = false;
  public isSaveVideoDialog: boolean = false; //保存视频遮罩弹框
  public redoInfo: Resource = $r('app.string.undo_intercept_imageEdit');
  public redoMap: LightWeightMap<string, RedoModel> = new LightWeightMap();
  public isShowRedoInfo: boolean = false; // 撤销恢复内容展示

  initRedoMap(): void {
    if (this.redoMap.length) {
      return;
    }
    let redoMapClass = new RedoMap();
    this.redoMap = redoMapClass.getRedoMap();
  }
}

export enum MediaType {
  IMAGE
}

export { Project as App, BaseEditor, TabName, InstanceData, }