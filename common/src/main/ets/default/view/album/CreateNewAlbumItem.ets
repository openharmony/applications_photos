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
import lazy { Log } from '../../../default/utils/Log';
import lazy { MenuContext } from '../../../default/view/browserOperation/MenuContext';
import lazy { MenuOperationFactory } from '../../../default/interface/MenuOperationFactory';
import lazy { AlbumSetDataSourceManager } from '../../../default/model/browser/album/AlbumSetDataSourceManager';
import lazy { Action } from '../../../default/view/browserOperation/Action';
import lazy { AlbumSetDataSource } from '../../../default/model/browser/album/AlbumSetDataSource';
import lazy { BroadCast } from '../../../default/utils/BroadCast';
import lazy { AlbumInfo } from '../../../default/model/browser/album/AlbumInfo';
import lazy { AlbumSetInlineRenameMenuOperation } from '../../../default/view/album/AlbumSetInlineRenameMenuOperation';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy { BroadCastManager } from '../../../default/model/common/BroadCastManager';
import lazy { Constants } from '../../../default/model/common/Constants';
import lazy { SideBarVariables } from '@ohos/tools/src/main/global/HapVariables';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { BroadCastConstants } from '../../../default/model/common/BroadCastConstants';
import lazy { AppBarStyles } from '../../../default/view/actionbar/AppBarStyles';
import lazy { UiUtil } from '../../../default/utils/UiUtil';

/* instrument ignore file */
const TAG: string = 'CreateNewAlbumItem';
const CREATE_NEW_ALBUM_BUFFER_TIME: number = 400;

/**
 * CreateNewAlbumItem
 */
@Component
export struct CreateNewAlbumItem {
  // 默认资源加载
  private readonly rsc: RscGetter = new RscGetter(getContext().resourceManager);
  private onOperationStart: Function = (): void => {
  };
  private onOperationEnd: Function = (): void => {
  };
  private switchItemAuto: Function = (album: AlbumInfo, actionId: number): void => {
  };
  private resetIsNewCreated: Function = (): void => {
  };
  private deSelect: Function = (isCreatingNewAlbum: boolean): void => {
  };
  private broadCast: BroadCast = AlbumSetDataSourceManager.getInstance().getBroadCast();
  @Link private isCreatingNewAlbum: boolean;
  @State private textInputText: string = '';
  @State private bufferText: string = '';
  private albumSetInlineRenameMenuOperation: AlbumSetInlineRenameMenuOperation | undefined = undefined;
  private albumInfo: AlbumInfo | undefined = undefined;
  private defaultName: string = '';
  private textInputController: TextInputController = new TextInputController();
  private appBroadCast: BroadCast = BroadCastManager.getInstance().getBroadCast();
  private onTextInputSubmitFunc: Function = (): void => this.onTextInputSubmit(this.textInputText);
  @Link private isSideBarItemAniOpen: boolean;
  @Link private isNewCreated: boolean;
  @State private isSelected: boolean = true;
  @State private isBuffering: boolean = false;
  private isSubmitting: boolean = false;
  @Prop private selectedItemBackgroundColor: number = 0;
  private timeoutID: number = -1;
  @Prop private index: number = -1;

  @Styles
  focusedStyle() {
    .borderStyle(BorderStyle.Solid)
    .borderWidth(2)
    .borderColor($r('sys.color.ohos_id_color_activated'))
    .borderRadius($r('sys.float.corner_radius_level4'))
  }

  @Styles
  normalStyle() {
    .borderWidth(2)
    .borderColor(Color.Transparent)
  }

  aboutToAppear(): void {
    if (this.albumInfo?.albumName) { // 取出新相册默认名
      if (typeof this.albumInfo?.albumName === 'string') {
        this.textInputText = this.albumInfo.albumName;
        this.defaultName = this.albumInfo.albumName;
      } else {
        this.textInputText = this.rsc.toString(this.albumInfo?.albumName);
        this.defaultName = this.rsc.getString(this.albumInfo?.albumName);
      }
    }
    this.createInlineRenameMenuOperation();
    this.bindBroadCast();
  }

  aboutToDisappear(): void {
    clearTimeout(this.timeoutID);
    this.isCreatingNewAlbum = false;
    this.resetIsNewCreated();
    this.isNewCreated = false;
    this.unBindBroadCast();
  }

  private bindBroadCast(): void {
    this.appBroadCast.on(BroadCastConstants.CLICK_SIDE_BAR_CONTAINER, this.onTextInputSubmitFunc);
  }

  private unBindBroadCast(): void {
    this.appBroadCast.off(BroadCastConstants.CLICK_SIDE_BAR_CONTAINER, this.onTextInputSubmitFunc);
  }

  private deleteInlineNewAlbum(currentAlbum: AlbumInfo | undefined): void {
    if (!currentAlbum) {
      return;
    }
    let menuContext: MenuContext;
    menuContext = new MenuContext();
    menuContext
      .withFromSelectMode(false)
      .withAlbumInfo(currentAlbum)
      .withOperationStartCallback(this.onOperationStart())
      .withOperationEndCallback((): void => {
        this.onOperationEnd();
        this.deSelect(false);
      })
      .withBroadCast(this.broadCast)
      .operate(Action.DELETE_ALBUM_WITHOUT_DIALOG.actionID);
  }

  private async createInlineRenameMenuOperation(): Promise<void> {
    Log.info(TAG, 'createInlineRenameMenuOperation');
    let menuContext: MenuContext;
    menuContext = new MenuContext();
    menuContext
      .withAlbumInfo(this.albumInfo)
      .withFromSelectMode(false)
      .withOperationStartCallback((): void => this.onOperationStart())
      .withOperationEndCallback((): void => {
        this.resetIsNewCreated();
        this.onOperationEnd();
      })
      .withBroadCast(this.broadCast);
    let albumSetInlineRenameMenuOperation: AlbumSetInlineRenameMenuOperation =
      MenuOperationFactory.getInstance().createMenuOperation(AlbumSetInlineRenameMenuOperation, menuContext);
    if (albumSetInlineRenameMenuOperation) {
      this.albumSetInlineRenameMenuOperation = albumSetInlineRenameMenuOperation;
    }
  }

  private onDestroyTextInput(isRenameSucceed: boolean): void {
    this.resetIsNewCreated();
    this.isSelected = this.isSelected && isRenameSucceed;
    this.albumSetInlineRenameMenuOperation = undefined;
    this.isCreatingNewAlbum = false;
    if (isRenameSucceed) {
      this.timeoutID = setTimeout((): void => {
        this.isNewCreated = false;
        this.textInputText = '';
        this.defaultName = '';
      }, CREATE_NEW_ALBUM_BUFFER_TIME);
    } else {
      this.textInputText = '';
      this.defaultName = '';
      this.isNewCreated = false;
      this.deSelect(false);
    }
    return;
  }

  private onTextInputSubmit(textInput: string, isSelect: boolean = true) {
    Log.info(TAG, `onTextInputSubmit ${textInput} isSubmitting ${this.isSubmitting}, isSelected ${this.isSelected}`);
    if (this.isSubmitting) {
      return;
    }
    this.bufferText = this.textInputText;
    this.isSelected = isSelect;
    this.isSubmitting = true;
    let textInputLocal: string = textInput;
    if (textInput !== undefined && textInput.length === 0) {
      this.bufferText = this.defaultName;
      textInputLocal = this.defaultName;
    }
    this.isBuffering = true;
    if (this.albumInfo) {
      this.albumInfo.albumName = textInputLocal;
    }
    // If use default name, skip renaming process
    if (textInputLocal === this.defaultName) {
      this.isSideBarItemAniOpen = false;
      this.onDestroyTextInput(true);
      return;
    }
    if (!this.albumSetInlineRenameMenuOperation) {
      Log.info(TAG, 'onTextInputSubmit noMenuOperation');
      this.onDestroyTextInput(false);
      return;
    }
    AlbumSetInlineRenameMenuOperation.checkIsNameValid(textInputLocal, this.defaultName).then((res: boolean): void => {
      if (res) {
        this.albumSetInlineRenameMenuOperation?.onInlineRenameSubmit(textInputLocal);
        this.isSideBarItemAniOpen = false;
        this.onDestroyTextInput(true);
        return;
      }
      Log.info(TAG, `checkIsNameValid return false ${textInput}`);
      this.deleteInlineNewAlbum(this.albumInfo);
    });
  }

  build() {
    Row() {
      Column() {
        SymbolGlyph(this.isSelected ?
        $r('sys.symbol.rectangle_on_rectangle_fill') : $r('sys.symbol.rectangle_on_rectangle'))
          .fontWeight(FontWeight.Normal)
          .fontSize(24)
          .renderingStrategy(SymbolRenderingStrategy.SINGLE)
          .fontColor(this.isSelected ?
            [$r('sys.color.icon_primary')] : [$r('sys.color.ohos_id_color_text_secondary')])
      }
      .clip(true)

      Stack() {
        if (this.isBuffering) {
          Text(this.bufferText)
            .maxFontScale(AppBarStyles.MAX_FONT_SIZE_SCALE)
            .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
            .fontWeight(this.isSelected ? FontWeight.Bold : FontWeight.Medium)
            .fontColor(this.isSelected ? $r('sys.color.font_primary') :
            $r('sys.color.ohos_id_color_text_primary'))
            .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
            .maxLines(1)
            .margin({ left: $r('sys.float.padding_level4') })
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .height(Constants.SIDE_BAR_ITEM_HEIGHT_PC)
            .draggable(false)
        } else {
          this.creatingNewAlbumTextInput();
        }
      }
      .alignContent(Alignment.Start)
      .layoutWeight(1)
    }
    .stateStyles({
      focused: this.focusedStyle,
      normal: this.normalStyle,
    })
    .backgroundColor(this.isSelected ? this.selectedItemBackgroundColor : Color.Transparent)
    .padding({ left: $r('sys.float.padding_level4'), right: $r('sys.float.padding_level4') })
    .borderRadius($r('sys.float.corner_radius_level4'))
    .width('100%')
    .onClick((): void => {
      Log.info(TAG, 'CreaNewAlbumItem onClick');
      this.onTextInputSubmit(this.textInputText, true);
    })
    .height(Constants.SIDE_BAR_ITEM_HEIGHT_PC)
  }

  @Builder
  creatingNewAlbumTextInput() {
    TextInput({
      controller: this.textInputController,
      text: $$this.textInputText,
    })
      .key('creatingNewAlbum_TextInput')
      .onSubmit((): void => {
        this.onTextInputSubmit(this.textInputText, true);
      })
      .onBlur((): void => {
        Log.info(TAG, `onBlur ${this.defaultName}, ${SideBarVariables.isSideBarDeselected},
          ${SideBarVariables.isDeferCreatingNewAlbum}`);
        this.onTextInputSubmit(this.textInputText,
          SideBarVariables.isSideBarDeselected && !SideBarVariables.isDeferCreatingNewAlbum);
      })
      .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
      .fontWeight(FontWeight.Medium)
      .fontColor($r('sys.color.font_primary'))
      .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
      .height(Constants.SIDE_BAR_ITEM_HEIGHT_PC)
      .barState(BarState.Off)
      .style(TextInputStyle.Inline)
      .maxLines(1)
      .padding({ left: $r('sys.float.padding_level4') })
      .barState(BarState.Off)
      .draggable(false)
      .onAppear((): void => {
        let flag: boolean = focusControl.requestFocus('creatingNewAlbum_TextInput');
        if (!flag) {
          Log.info(TAG, 'request textInput focus error');
        }
      })
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions): void => {
        if (newValue?.width) {
          let flag: boolean = focusControl.requestFocus('creatingNewAlbum_TextInput');
          if (!flag) {
            Log.info(TAG, 'request textInput focus error');
          }
        }
      })
      .maxLength(Constants.RENAME_MAX_LENGTH)
      .onChange((value: string): void => {
        if (value?.length >= Constants.RENAME_MAX_LENGTH) {
          UiUtil.showToast($r('app.string.Maximum_length_reached'));
        }
      })
  }
}