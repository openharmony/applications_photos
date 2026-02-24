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
import { AppUtil } from '../../../../common/util/AppUtil';
import { HiLog } from '../../../../common/util/HiLog';
import { PermissionUtil } from '../../../../common/util/PermissionUtil';
import { UiUtil } from '../../../../common/util/UiUtil';
import { App, BaseEditor, MediaType } from '../../../../service/App';
import { EditorMsg } from '../../../../service/EditorSDK';
import { ExportInfo, ImgInfo, MediaSaveManager } from '../common/MediaSaveManager';
import fs from '@ohos.file.fs';
import { dataSharePredicates } from '@kit.ArkData';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy settings from '@ohos.settings';
import { image } from '@kit.ImageKit';
import { Trace } from '../../../../common/util/Trace';
import { TabName } from '../../../../service/BaseEditor';
import { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import { DeviceUtil } from '../../../../common/util/DeviceUtil';
import { Service } from '../../../../common/util/Service';
import { window } from '@kit.ArkUI';
import { PixelMapUtil } from '../../../../common/util/PixelMapUtil';
import { EditorType } from '../../../../service/model/Enum';
import { GetExportDataOptions } from '../../../../service/IEditor';
import sdk from '../../../../service/native';

/* instrument ignore file */
const TAG = 'TopBarModel';

export class TopBarModel {
  private saveProgress: number = 0;
  private openProgressDialog: Function;
  public closeProgressDialog: Function;
  private onMessageCallback: (msg: EditorMsg) => boolean
  private onProgressChanged: (progress: number) => void
  private overrideMode: boolean = false;
  private editor: BaseEditor = App.getInstance().myEditor();
  private mediaManager: MediaSaveManager;
  private isCompileCancelling: boolean = false;
  private isSaveCanceled: boolean = false;
  private delayFinishTimerId: number = -1;
  private exportInfo: ExportInfo = new ExportInfo();
  private saveStartTime: number = 0;

  constructor(editor: BaseEditor, openProgressDialog: Function, closeProgressDialog: Function, onMessageCallback:
    (msg: EditorMsg) => boolean, onProgressChanged: (progress: number) => void) {
    this.editor = editor;
    this.mediaManager = new MediaSaveManager(this.editor);
    this.openProgressDialog = openProgressDialog;
    this.closeProgressDialog = closeProgressDialog;
    this.onMessageCallback = onMessageCallback;
    this.onProgressChanged = onProgressChanged;
  }

  public async onSaveClick(isOverride: boolean) {
    HiLog.i(TAG, `onSaveClick isOverride: ${isOverride}`);
    // 检查权限
    let isGranted = await PermissionUtil.checkWritePermission();
    if (!isGranted) {
      HiLog.e(TAG, 'checkWritePermission no permission');
      return;
    }
    if (this.editor.tabIndex === TabName.TabAperture) {
    }
    HiLog.i(TAG, 'sync xtStyle to watermark by onSaveClick');
    if (this.editor.interrupt) {
      this.editor.setCropReactInterrupt();
    }
    this.overrideMode = isOverride;
    this.setExportRelatedVariables();
    this.openProgressDialog();
    this.exportCallback(isOverride);
    this.isSaveCanceled = false;
    Trace.begin('ImageEditorSaveOperation');
    Trace.begin('createTemplateMediaFile');
    this.mediaManager.createMediaFile(isOverride).then((imgInfo: ImgInfo) => {
      Trace.end('createTemplateMediaFile');
      let fdPath = 'fd://' + imgInfo.fileFd;
      HiLog.i(TAG, 'createTempFile fd and mimeType = %{public}i, %{public}s', imgInfo.fileFd, imgInfo.mimeType);
      this.saveExportFile(0, 0, fdPath, this.editor.mediaType, imgInfo.mimeType);
    }).catch((e: String) => {
      Trace.end('createTemplateMediaFile');
      this.exportFailed();
    })
  }

  public setSaveStartTime(startTime: number) {
    this.saveStartTime = startTime;
  }

  public progressDialogClose(): void {
    HiLog.i(TAG, 'progress Dialog Close');
    this.editorClose();
  }

  closeClick(): void {
    HiLog.i(TAG, 'closeClick  isSave : ' +
    this.editor.isSaveVideoDialog + ` ,isCompileCancelling :${this.isCompileCancelling}`)
    if (!this.editor.isSaveVideoDialog && !this.isCompileCancelling) {
      return;
    }
    this.cancelCompile(() => {
      HiLog.i(TAG, 'cancelCompile success');
      this.closeProgressDialog();
      this.editor.isSaveVideoDialog = false;
      this.saveProgress = 0;
      AppUtil.keepScreenOn(false);
    });
  }

  private exportCallback(isOverride: boolean) {
    App.getInstance().setExportResultCallback((message: number) => {
      if (message !== 0) {
        HiLog.e(TAG, `exportCallback error, message: ${message}`);
        this.exportFailed();
        return;
      }
    });
    App.getInstance().setExportProgressCallback((progress: number) => {
      HiLog.i(TAG, `setExportProgressCallback progress=${progress}`);
      this.saveProgress = progress;
      this.onProgressChanged(progress);
      if (this.saveProgress >= 100) {
        this.onCompileFinished(isOverride);
        AppUtil.keepScreenOn(false);
      }
    });
  }

  sendExitCallback(uri: string, isOverride: boolean): void {
    let msg: EditorMsg = new EditorMsg(EditorMsg.MSG_ID_ON_EXIT, uri);
    msg.isOverride = isOverride;
    LocalStorage.getShared()?.setOrCreate<number | undefined>('exitRatio', this.editor.asset.crops().getExitRatio());
    let sendRs: boolean = this.onMessageCallback(msg);
    HiLog.i(TAG, `send MSG_ID_ON_EXIT uri=${uri} complete, processed=${sendRs}`);
  }

  private onCompileFinished(isOverride: boolean): void {
    HiLog.i(TAG, 'onCompileFinished');
    this.delayFinishTimerId = setTimeout(async (): Promise<void> => {
      if (this.isSaveCanceled) {
        HiLog.i(TAG, 'onCompileFinished bug save canceled.');
        return;
      }
      // uri 保存图片的uri
      let uri = isOverride ? this.editor.mediaUri : this.mediaManager.getUri();
      HiLog.i(TAG, `mediaManagerUriTest ${uri}`);
      let isDoAiRefine: boolean = this.editor.aiMasterGetIsDoRefineMasterValue();
      //获取XtStyle Exif信息
      let jsonString = this.editor.getCurrentXtStyleParams();

      this.mediaManager.compileFinish(isOverride, this.exportInfo, isDoAiRefine)
        .then(async (path: string) => {
          HiLog.i(TAG, 'mediaManager compileFinish success');
          this.closeDialog();
          if (this.isSaveCanceled) {
            HiLog.i(TAG, 'mediaManager compileFinish bug save canceled.');
            return;
          }
          this.sendExitCallback(uri, isOverride);
          await this.mediaManager.submitEdit(this.exportInfo.editData, this.exportInfo.editDataType, isOverride);
          this.editor.isPageBackLoading = true;
          App.getInstance().myEditor().cancel();
          App.getInstance().myEditor().close((code: number) => {
            HiLog.i(TAG, `project closed(${code}` + '), reason=compileFinishToPhoto');
          });
          if (!DeviceInfo.isPc()) {
          }
          fs.unlink(path);
          HiLog.i(TAG, 'template file deleted');
        })
        .catch((message: string) => {
          HiLog.e(TAG, `operate file error:${message}`)
          this.editor.isSaveVideoDialog = false;
          if (!this.isSaveCanceled) { // 取消时状态改变，不需要提示保存失败
            this.exportFailed();
          }
        })
    }, 0);
  }

  public reportEditorSaveBigData() {
  }

  public async closeDialog() {
    let predicate = new dataSharePredicates.DataSharePredicates();
    predicate.equalTo(photoAccessHelper.PhotoKeys.URI, this.editor.mediaUri);
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicate,
    };
    let phAccessHelper: photoAccessHelper.PhotoAccessHelper | undefined = undefined;
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> | undefined = undefined;
    try {
      phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
      fetchResult = await phAccessHelper.getAssets(fetchOptions);
      let onCallback = (changeData: photoAccessHelper.ChangeData) => {
        // 文件如果有变化，则此处回调执行
        this.closeProgressDialog();
        HiLog.i(TAG, 'closeProgressDialog registerChange');
      }
      // 注册onCallback监听
      phAccessHelper.registerChange(this.editor.mediaUri, false, onCallback);
    } catch (err) {
      HiLog.e(TAG, `closeDialog error: ${err}, code: ${err?.code}`);
    } finally {
      fetchResult?.close();
      phAccessHelper?.release();
      HiLog.i(TAG, `fetchResult is close.`);
    }
  }

  private saveExportFile(startTime: number, endTime: number, outputPath: string, mediaType: MediaType,
    mimeType: string) {
    App.getInstance().saveEditedFile(App.getInstance().myEditor().timeline, startTime, endTime,
      outputPath, App.getInstance().myEditor().asset.uid, mediaType, mimeType, (exportInfo: string, type: string) => {
        HiLog.i(TAG, `saveEditedFile return finish, type = ${type}, exportInfo = ${exportInfo}`);
        this.exportInfo.editData = exportInfo;
        this.exportInfo.editDataType = type;
      });
  }

  private cancelCompile(callback: Function): void {
    if (this.delayFinishTimerId !== -1) {
      clearTimeout(this.delayFinishTimerId);
      this.delayFinishTimerId = -1;
    }
    if (!this.isCompileCancelling) {
      this.isCompileCancelling = true;
      App.getInstance().cancelSaveEditedFile(App.getInstance().myEditor().timeline,
        App.getInstance().myEditor().asset.uid, () => {
          HiLog.i(TAG, 'cancelSaveEditedFile finished.');
          this.isSaveCanceled = true;
          this.isCompileCancelling = false;
          this.mediaManager.deleteMedia(this.overrideMode);
          callback();
        });
    }
  }

  private exportFailed() {
    this.closeProgressDialog();
    UiUtil.showToast($r('app.string.save_failed_imageEdit'), 2000, '15%')
    AppUtil.keepScreenOn(false);
    this.editor.isSaveVideoDialog = false;
    this.mediaManager?.deleteMedia(this.overrideMode);
  }

  private setExportRelatedVariables() {
    this.saveProgress = 0;
    this.onProgressChanged(0);
    AppUtil.keepScreenOn(true);
    this.editor.isSaveVideoDialog = true;
    this.isCompileCancelling = false;
    // 开始保存后 保持当前屏幕旋转状态，待保存结束恢复横竖屏旋转
    this.setOrientationMode(window.Orientation.LOCKED)
  }

  private editorClose() {
    HiLog.i(TAG, 'reset orientation mode');
    let rotateAlways: boolean = false;
    try {
      let type = settings.getValueSync(getContext(this), 'persist.photos.rotate.type', 'TYPE_SYSTEM');
    } catch (err) {
      HiLog.e(TAG, `Set RotateType error: ${err}`);
    }
    if (rotateAlways) {
      this.setOrientationMode(window.Orientation.AUTO_ROTATION);
    } else {
      this.setOrientationMode(window.Orientation.AUTO_ROTATION_RESTRICTED);
    }
  }

  /**
   * 设置横竖屏模式
   *
   * @param mode
   */
  public setOrientationMode(mode: window.Orientation) {
    // instrument ignore if
    if (DeviceUtil.isPc()) {
      return;
    }
    Service.changeOrientationMode(mode);
  }
}