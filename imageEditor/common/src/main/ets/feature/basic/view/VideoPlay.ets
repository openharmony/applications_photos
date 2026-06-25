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
import { HiLog } from '../../../common/util/HiLog';
import { Rectangle } from '../../../common/util/types';
import { App, BaseEditor } from '../../../service/App';
import { CropAttr, TabName ,OperationArea} from '../../../service/BaseEditor';
import { ScreenMask } from '../../../common/components/FrostedGlass';
import { EditorStatus } from '../../../service/EditorSDK';
import { DeviceUtil } from '../../../common/util/DeviceUtil';
import { DeviceInfo } from '@ohos/common/src/main/ets/default/utils/DeviceInfo'
import { ApsUtil, APS_SCENE_STATE_OFF, PHOTO_BUNDLE_NAME, PHOTO_IN_EDIT_CROP } from '../../../common/util/ApsUtil';

const TAG: string = 'VideoPlay'

class BgColorModifier implements AttributeModifier<XComponentAttribute> {
  applyNormalAttribute(instance: XComponentAttribute): void {
    if (DeviceInfo.isSupportLiteVisualEffect()) {
      HiLog.i(TAG, 'set color rgba 0000');
      instance.backgroundColor('rgba(0, 0, 0, 0)');
    } else {
      HiLog.i(TAG, 'default');
    }
  }
}

@Component
export struct VideoPlay {
  @State editor: BaseEditor = App.getInstance().myEditor();
  @State oper: OperationArea = App.getInstance().myEditor().operationArea;
  @State pos: Rectangle = this.editor.asset.crops().cropRect;
  @State crop: CropAttr = App.getInstance().myEditor().asset.crops();
  @State modifier: BgColorModifier = new BgColorModifier();
  @Prop status: EditorStatus = new EditorStatus();
  @BuilderParam aiView: () => void;
  @BuilderParam textEditView: () => void;
  @BuilderParam mosaicView: () => void;
  @BuilderParam apertureView: () => void;

  aboutToAppear(): void {
  }

  /* instrument ignore file */
  build() {
    Stack() {
      ScreenMask({
        clipSize: this.crop.cropRect,
      }) {
        XComponent({
          id: App.getInstance().instanceData().previewComponentId,
          type: 'texture',
          libraryname: 'ImageEditor',
        })
          .attributeModifier(this.modifier)
          .position({ x: 0, y: 0 })
          .width('100%')
          .height('100%')
          .id('photos_xc')
          .onLoad((): void => {
            HiLog.i('VideoPlay', 'XComponent::onLoad begin')
            this.editor.previewStarter.onXComponentLoad(App.getInstance().instanceData().previewComponentId);
          })
          .onDestroy((): void => {
            this.editor.previewStarter.onXComponentDestroy();
            HiLog.i('VideoPlay', 'XComponent::onDestroy');
            HiLog.i(TAG, 'onDestroy XComponent, close setApsSceneState begin.');
            ApsUtil.setApsSceneState(PHOTO_BUNDLE_NAME, PHOTO_IN_EDIT_CROP, APS_SCENE_STATE_OFF);
            HiLog.i(TAG, 'onDestroy XComponent, close setApsSceneState end.');
          })
        if (this.status.isPreviewHidden) {
          Column()
            .position({ x: 0, y: 0 })
            .width('100%')
            .height('100%')
            .id('hideXcMask')
            .backgroundColor(Color.Black)
        }
      }

      if (!DeviceUtil.isPc()) {
        this.textEditView();
        this.mosaicView();
      }
    }
  }
}