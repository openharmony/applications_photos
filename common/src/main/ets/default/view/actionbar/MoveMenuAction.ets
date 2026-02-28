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

import lazy { SymbolGlyphModifier } from '@kit.ArkUI';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import type { BroadCast } from '../../utils/BroadCast';
import lazy { Constants } from '../../model/common/Constants';
import lazy { SelectMediaType } from '../../model/common/Constants';
import lazy { AlbumSetDataInfo } from '../../model/common/AlbumSetDataInfo';
import lazy { MediaOperationType } from '../../model/common/MediaOperationType';
import lazy { SelectManager, MediaTypeChecker } from '../../model/browser/SelectManager';
import lazy { AlbumSetDataSourceManager, } from '../../model/browser/album/AlbumSetDataSourceManager';
import lazy { SourceTypeAlbumDataSource, } from '../../model/browser/album/SourceTypeAlbumDataSource';
import type { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import lazy { AlbumSetDataSource } from '../../model/browser/album/AlbumSetDataSource';
import lazy { JumpSourceToMain } from '../../model/browser/photo/JumpSourceToMain';
import lazy { MenuOperationFactory } from '../../interface/MenuOperationFactory';
import lazy { Action } from '../../view/browserOperation/Action';
import lazy {
  AlbumCreateListener,
  AlbumSetNewMenuOperation,
} from '../../view/browserOperation/AlbumSetNewMenuOperation';
import lazy {
  AlbumSetNewWithoutDialogMenuOperation,
} from '../../view/browserOperation/AlbumSetNewWithoutDialogMenuOperation';
import lazy { MenuContext } from '../../view/browserOperation/MenuContext';
import lazy { MoveMenuOperation } from '../../view/browserOperation/MoveMenuOperation';
import lazy {
  ActionModel,
  ActionViewModel,
  MenuConstants,
  ParamsWrapper,
  MenuHelper,
  OperationListener,
} from '../../view/actionbar/Menu';
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles, } from '../../view/actionbar/ActionButton';
import lazy { AppBarElementBuilder } from '../../view/actionbar/AppBar';
import lazy { MoveActionRegister } from '../../view/actionbar/MoveAction';
import lazy { BrowserControlInterface } from '../../interface/BrowserControlInterface';

type MoveClickParam = [mediaOperationType: MediaOperationType, albumName?: string, albumUri?: string];

const TAG: string = 'MoveMenuAction';
const MENU_WIDTH: number = 224;

/**
 * Prop 的 customMenuItemBuilder
 */
const SubMenuBuilder: WrappedBuilder<[ActionButtonProp]> = wrapBuilder(buildSubMenu);

@Builder
function buildSubMenu(prop: ActionButtonProp) {
  SubMenuComponent({ prop: prop as MoveMenuActionProp });
}

@Component
struct SubMenuComponent {
  @State public prop: MoveMenuActionProp = new MoveMenuActionProp();
  // 子菜单数据
  private albums: AlbumSetDataSource = AlbumSetDataSourceManager.getInstance().getDataSource();
  private sourceTypeAlbumsDataSource: SourceTypeAlbumDataSource =
    new SourceTypeAlbumDataSource(getContext(this), Constants.SOURCE_ALBUM_MIN_COUNT);
  private selectMediaType: SelectMediaType = SelectMediaType.INVALID;

  @Styles
  menuItemCommArr() {
    .height(Constants.MENU_ITEM_HEIGHT_PC)
    .width('auto')
    .constraintSize({ minWidth: Constants.FORTH_MENU_ITEM_WIDTH_PC })
  }

  @Builder
  buildAlbumMenu(albumInfo?: AlbumInfo, index?: number) {
    if (albumInfo && !albumInfo?.isSystemAlbum &&
      albumInfo?.uri !== AppStorage.get<string>(Constants.KEY_OF_ALBUM_URI) && !this.moveMenuBlock(albumInfo)) {
      MenuItem({
        content: albumInfo?.albumName,
      })
        .key(`AlbumMenu_${albumInfo?.albumName}`)
        .contentFont({ weight: 'medium' })
        .menuItemCommArr()
        .onClick((): void => {
          Log.info(TAG, `SubMenuComponent MenuItem click:${albumInfo?.albumName}`);
          const params: ParamsWrapper = new ParamsWrapper().set(MenuConstants.KEY_MENU_HELPER_CLICK_PARAM,
            [MediaOperationType.MOVE, albumInfo.albumName, albumInfo.uri]);
          this.prop.menuHelper?.onMenuClicked(this.prop.action, params);
        })
    } else {
      MenuItem()
        .visibility(Visibility.None)
        .height(Constants.MENU_ITEM_HEIGHT_PC)
    }
  }

  build() {
    Menu() {
      MenuItemGroup() {
        MenuItem({
          content: Action.NEW_ALBUM.textRes,
        })
          .key(`AlbumMenu_${Action.NEW_ALBUM.textRes}`)
          .contentFont({ weight: 'medium' })
          .menuItemCommArr()
          .onClick((): void => {
            Log.info(TAG, `SubMenuComponent MenuItem click:NEW_ALBUM`);
            const params: ParamsWrapper =
              new ParamsWrapper().set(MenuConstants.KEY_MENU_HELPER_CLICK_PARAM, [MediaOperationType.NEW]);
            this.prop.menuHelper?.onMenuClicked(this.prop.action, params);
          })
      }
      .width('auto')
      .constraintSize({ minWidth: Constants.FORTH_MENU_ITEM_WIDTH_PC })

      MenuItemGroup() {
        LazyForEach(this.albums as AlbumSetDataSource, (albumSetDataInfo: AlbumSetDataInfo, index?: number) => {
          this.buildAlbumMenu(albumSetDataInfo?.data, index);
        }, (item: AlbumSetDataInfo, index?: number): string => this.getAlbumHashCode(item, index));

        LazyForEach(this.sourceTypeAlbumsDataSource, (albumSetDataInfo: AlbumSetDataInfo, index?: number) => {
          this.buildAlbumMenu(albumSetDataInfo?.data, index);
        }, (item: AlbumSetDataInfo, index?: number): string => this.getAlbumHashCode(item, index));
      }
      .margin({ top: $r('sys.float.padding_level2') })
      .width('auto')
      .constraintSize({ minWidth: Constants.FORTH_MENU_ITEM_WIDTH_PC })
    }
    .width(MENU_WIDTH)
  }

  aboutToAppear(): void {
    this.selectMediaType =
      this.prop.selectedParseResult?.get<SelectMediaType>(MediaTypeChecker.KEY_SELECT_MEDIA_TYPE) ??
      SelectMediaType.INVALID;
    Log.info(TAG, `SubMenuComponent aboutToAppear. selectMediaType:${this.selectMediaType}`);
  }

  private moveMenuBlock(albumInfo?: AlbumInfo): boolean {
    let videoFlag: boolean = (albumInfo?.lpath === '/Pictures/Screenrecords' &&
      (this.selectMediaType === SelectMediaType.IMAGE ||
        this.selectMediaType === SelectMediaType.IMAGE_VIDEO)); // 只有图片或图片视频都有，视频录制相册不显示；
    let screenshotsFlag: boolean = (albumInfo?.lpath === '/Pictures/Screenshots' &&
      (this.selectMediaType === SelectMediaType.VIDEO ||
        this.selectMediaType === SelectMediaType.IMAGE_VIDEO)); // 只有视频或视频图片都有，截图相册不显示；
    return videoFlag || screenshotsFlag;
  }

  private getAlbumHashCode(item: AlbumSetDataInfo, index?: number): string {
    if (!item?.data) {
      return TAG + String(index);
    }
    if (item.data.mediaItem) {
      return item.data.getHashCode() + item.data.mediaItem.getHashCode();
    }
    return item.data.getHashCode();
  }
}

/**
 * 移动到Action 属性
 */
@Observed
export class MoveMenuActionProp extends DefaultActionButtonProp {
  public action = Action.MOVE;
  public icon = Action.MOVE.iconRes;
  public text = Action.MOVE.textRes;
  public key = 'ActionButton_' + Action.MOVE.componentKey;
  // 子菜单相关
  public hasSubMenu: boolean = true;
  public symbolEndIcon = new SymbolGlyphModifier($r('sys.symbol.chevron_right')).fontSize($r('sys.float.Title_M'));
  public customMenuItemBuilder = SubMenuBuilder;
  // 菜单点击工具类
  public menuHelper: MenuHelper | undefined = undefined;
  public selectedParseResult: ParamsWrapper = new ParamsWrapper();

  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * 移动到Action 注册类
 */
export class MoveMenuActionRegister extends MoveActionRegister {
  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new MoveMenuActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    let currentPhoto: BrowserControlInterface =
      params.get<BrowserControlInterface>(MenuConstants.KEY_BROWSER_CONTROLLER);
    return {
      produce: () => {
        let menuContext: MenuContext = new MenuContext();
        let listener: OperationListener | undefined = params?.get<OperationListener>(MoveActionRegister.LISTENER);
        menuContext.withSelectManager(params.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
          .withOperationStartCallback((): void => listener?.onOperationStart?.())
          .withOperationEndCallback((): void => listener?.onOperationEnd?.())
          .withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .withMediaItem(currentPhoto?.getCurrentPhoto())
          .set(MoveActionRegister.SELECTED_PARSE_RESULT, params.get(MoveActionRegister.SELECTED_PARSE_RESULT));
        Log.info(TAG, `buildModel, isThirdScene: ${params.get<boolean>(MenuConstants.KEY_IS_THIRD_SCENE)}`);
        if (params.get<boolean>(MenuConstants.KEY_IS_THIRD_SCENE)) {
          menuContext.withOriginalAlbumUri('file://media/PhotoAlbum/2');
        }
        return menuContext;
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new MoveMenuActionProp();
  }

  /**
   * 处理 MoveActionPropPc 特有参数
   */
  public buildView(action: Action, params: ParamsWrapper): AppBarElementBuilder | undefined {
    let prop: MoveMenuActionProp = this.buildViewProp(action, params) as MoveMenuActionProp;
    prop.menuHelper = params.get<MenuHelper>(MenuConstants.KEY_MENU_HELPER);
    prop.selectedParseResult = params.get<ParamsWrapper>(MenuConstants.KEY_SELECTION_PARSE_RESULT);
    return {
      builder: this.buildActionBuilder(action, params),
      builderParams: prop,
      key: prop?.key ?? new Date().getTime().toString(),
    };
  }
}

/**
 * 移动到Action VM层
 */
export class MoveMenuActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    const clickParams: MoveClickParam | undefined =
      menuContext?.get<MoveClickParam>(MenuConstants.KEY_MENU_HELPER_CLICK_PARAM);
    if (!menuContext || !clickParams) {
      Log.info(TAG, `doAction. clickParams is null`);
      return;
    }
    const mediaOperationType: MediaOperationType = clickParams[0];
    Log.info(TAG, `doAction. mediaOperationType:${mediaOperationType}`);
    if (menuContext.mediaItem) {
      menuContext.withFromPage(Constants.MEDIA_OPERATION_FROM_PHOTO_BROWSER);
    }
    // 新增
    if (mediaOperationType === MediaOperationType.NEW) {
      this.moveToNewAlbum(menuContext);
    }
    // 移动到指定相册
    if (mediaOperationType === MediaOperationType.MOVE) {
      const albumName: string = clickParams[1] || '';
      const albumUri: string = clickParams[2] || '';
      this.moveToAlbum(menuContext, albumName, albumUri);
    }
  }

  /**
   * 移动到文件到指定相册
   */
  private moveToAlbum(menuContext: MenuContext, albumName: string, albumUri?: string): void {
    menuContext.withTargetAlbumName(albumName)
      .withAlbumUri(albumUri);
    new MoveMenuOperation(menuContext).doAction();
  }

  /**
   * 新建相册后移动文件
   */
  private moveToNewAlbum(menuContext: MenuContext): void {
    let createAlbumContext = new MenuContext()
      .withNewAlbumFocusState(false)
      .withJumpSourceToMain(JumpSourceToMain.ALBUM)
      .set(AlbumSetNewMenuOperation.LISTENER, {
        onCompleted: (albumName: string, albumUri?: string) => this.moveToAlbum(menuContext, albumName, albumUri),
      } as AlbumCreateListener);
    if (menuContext.broadCast) {
      createAlbumContext.withBroadCast(menuContext.broadCast);
    }
    if (menuContext?.fromPage) {
      createAlbumContext.withFromPage(menuContext?.fromPage);
    }
    let logMsg: string[] = ['moveToNewAlbum'];
    logMsg.push(`menuContext.fromPage: ${menuContext?.fromPage}`);
    logMsg.push(`createAlbumContext.fromPage: ${createAlbumContext?.fromPage}`);
    Log.info(TAG, logMsg.join(', '));
    let menuOperation: AlbumSetNewWithoutDialogMenuOperation =
      MenuOperationFactory.getInstance().createMenuOperation(AlbumSetNewWithoutDialogMenuOperation, createAlbumContext);
    menuOperation.doAction();
  }
}