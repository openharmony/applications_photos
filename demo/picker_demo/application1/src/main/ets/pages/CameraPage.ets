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

import lazy { webview } from '@kit.ArkWeb';
import lazy { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import lazy { photoAccessHelper } from '@kit.MediaLibraryKit';
import lazy { fileIo as fs } from '@kit.CoreFileKit';
import lazy { util } from '@kit.ArkTS';

@Entry
@Component
struct CameraPage {
  private src: string = '';
  private url: ResourceStr = 'your http resource uri';
  private webview: webview.WebviewController = new webview.WebviewController();

  // 申请相机权限
  aboutToAppear(): void {
    const context = getContext(this) as common.UIAbilityContext;
    const atManager = abilityAccessCtrl.createAtManager();
    const permissions: Permissions[] = ['ohos.permission.CAMERA']
    atManager.requestPermissionsFromUser(context, permissions);
  }

  // base64写文件，返回沙箱uri
  base64ToFile(src: string): string {
    const data = '';
    const base64helper = new util.Base64Helper();
    const buffer = base64helper.decodeSync(data).buffer;

    const context = getContext(this);
    const filesDir = context.filesDir;
    const filePath = filesDir + '/temp.jpeg';
    const file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    fs.writeSync(file.fd, buffer);
    return 'file://com.atomicservice.5765880207855424683' + filePath;
  }

  // 保存沙箱照片到媒体库
  async savePhotoToAlbum(uri: string) {
    const srcFileUris = [uri];
    const photoHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));
    try {
      // 指定待保存照片的创建选项，包括文件后缀和照片类型，标题和照片子类型可选
      let photoCreationConfigs: photoAccessHelper.PhotoCreationConfig[] = [
        {
          title: 'test', // 可选
          fileNameExtension: 'jpeg',
          photoType: photoAccessHelper.PhotoType.IMAGE,
          subtype: photoAccessHelper.PhotoSubtype.DEFAULT, // 可选
        }
      ];
      // 基于弹窗授权的方式获取媒体库的目标uri
      let desFileUris = await photoHelper.showAssetsCreationDialog(srcFileUris, photoCreationConfigs);
      let srcFile = await fs.open(srcFileUris[0], fs.OpenMode.READ_ONLY);
      let desFile = await fs.open(desFileUris[0], fs.OpenMode.WRITE_ONLY);
      await fs.copyFile(srcFile.fd, desFile.fd);
      await fs.close(srcFile);
      await fs.close(desFile);
    } catch (err) {
      console.error(`failed to create asset by dialog successfully errCode is: ${err.code}, ${err.message}`);
    }
  }

  build() {
    Column() {
      Web({ src: this.url, controller: this.webview })
        .onPermissionRequest((event) => {
          AlertDialog.show({
            title: '相机权限请求',
            message: '是否允许访问摄像头',
            primaryButton: {
              value: '拒绝',
              action: () => {
                event.request.deny();
              }
            },
            secondaryButton: {
              value: '允许',
              action: () => {
                event.request.grant(event.request.getAccessibleResource());
              }
            },
            cancel: () => {
              event.request.deny();
            }
          })
        })
        .onContextMenuShow((event) => {
          const param = event.param;
          if (!param.existsImageContents()) {
            // 不是图片，不触发菜单
            return false;
          }
          this.src = param.getSourceUrl();
          return true;
        })
        .bindContextMenu(this.buildContextMenu, ResponseType.LongPress)
    }
  }

  @Builder
  buildContextMenu() {
    Menu() {
      MenuItem({ content: '保存到相册' })
        .onClick(() => {
          const uri = this.base64ToFile(this.src);
          this.savePhotoToAlbum(uri);
        })
    }
    .width('224vp')
  }
}