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
import { BaseEditor, TabName, App, MenuChangeType } from '../../App';
import { Asset } from '../../Asset';
import { RectValue } from '../../EditorSDK';
import { ButtonItem, } from '../../../feature/basic/common/view/SelectableProgressButton';
import { HiLog } from '../../../common/util/HiLog';
import { BroadCastManager } from '@ohos/common/src/main/ets/default/model/common/BroadCastManager';
import { TextInterval } from '../tabTextEdit/util/TextConst';
import { ScreenManager } from '../../../common/util/ScreenManager';
import { MenuAttr } from './MenuAttr';
import { ComposeUtil } from '../../../common/util/ComposeUtil';
import { BroadCast } from '@ohos/common/src/main/ets/default/utils/BroadCast';

const TAG = 'TextEditAttr';

let appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();

@Observed
export class TextEditAttr extends MenuAttr {
  public pageName: string = 'textedit_textEditPage';
  public textRect: RectValue = new RectValue(0, 0, 0, 0);
  public tabIndex: number = 0;
  public isInTextTab: boolean = false;
  public isComparing: boolean = false;
  public textNum: number = 0;
  public operationRectInited: boolean = false;
  public textTabs = [
    new ButtonItem($r('app.string.add_text_imageEdit'),
      $r('sys.symbol.character_textbox'), true, 'default', -1, -1, 1),
    new ButtonItem($r('app.string.style_imageEdit'),
      $r('sys.symbol.textstyle'), true, 'style', -1, -1, 1)
  ];

  constructor(editor: BaseEditor, asset: Asset) {
    super(editor, asset);
  }

  enterMenu() {
    super.enterMenu();
    if ((TabName.TabTextEdit === this.changeTabIndex || this.editor.tabIndex === this.changeTabIndex) &&
      (this.editor.tabIndex != TabName.TabCrop) && !ScreenManager.getInstance().isScreenPortrait()) {
      App.getInstance().screenClass.screenChangeType = MenuChangeType.NO_CROP_TO_NO_CROP;
      HiLog.i(TAG, `change screen type: ${App.getInstance().screenClass.screenChangeType}`)
    }
    HiLog.i(TAG, 'textEditAttr enterMenu');
    this.textNum = 0;
    this.isInTextTab = true;
    appBroadCast.emit('initTextEditView', [TextInterval.INIT]);
  }

  leaveMenu(index: TabName) {
    HiLog.i(TAG, 'textEditAttr leaveMenu');

    // 离开标注页时恢复VideoSizer
    this.editor.isInTextArea = false;
    this.operationRectInited = false;
    this.isInTextTab = false;
  }

  public composeBeforeEnter = (dstTab: number, rect: RectValue, reportNum: number, callback: Function) => {
    this.asset.adjusts().isResetSelected = true;
    ComposeUtil.prepare(this.pageName, this.editor, dstTab, reportNum, callback);
  }

  public save = (dstTab: number, rect: RectValue, num: number, callback?: Function) => {
    ComposeUtil.save(this.pageName, this.editor, dstTab, num, callback);
  }
}