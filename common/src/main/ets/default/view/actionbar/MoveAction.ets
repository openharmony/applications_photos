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
import lazy { ActionButtonProp, DefaultActionButtonProp } from './ActionButton';
import lazy { Action } from '../browserOperation/Action';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionModel, ActionViewModel, MenuConstants, OperationListener, ParamsWrapper } from './Menu';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { MediaOperationBasePage, Params } from '../browserOperation/MediaOperationBasePage';
import type { BroadCast } from '../../utils/BroadCast';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { BroadCastConstants } from '../../model/common/BroadCastConstants';
import lazy { AlbumSetDataSourceManager } from '../../model/browser/album/AlbumSetDataSourceManager';
import lazy { JumpSourceToMain } from '../../model/browser/photo/JumpSourceToMain';
import lazy { MenuOperationFactory } from '../../interface/MenuOperationFactory';
import lazy { AlbumCreateListener, AlbumSetNewMenuOperation } from '../browserOperation/AlbumSetNewMenuOperation';
import lazy { MediaOperationType } from '../../model/common/MediaOperationType';
import lazy { MediaItem } from '../../model/browser/photo/MediaItem';
import lazy { ConfigurationConstant } from '@kit.AbilityKit';
import lazy { NavigationConstants } from '../../model/common/NavigationConstants';
import lazy { NavigationBroadCastManager } from '../../model/common/NavigationBroadCastManager';
import lazy { WindowUtil } from '../../utils/WindowUtil';
import lazy { Constants, SelectMediaType } from '../../model/common/Constants';
import lazy { SelectManager } from '../../model/browser/SelectManager';
import lazy { MoveMenuOperation } from '../browserOperation/MoveMenuOperation';
import lazy { MediaTypeChecker } from '../../model/browser/SelectManager';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';

const TAG: string = 'common_MoveAction';

/**
 * 分享按钮属性，手机平板等场景使用
 */
@Observed
export class MoveActionProp extends DefaultActionButtonProp {
  public action = Action.MOVE;
  public icon = Action.MOVE.iconRes;
  public text = Action.MOVE.textRes;
  public key = 'ActionButton_' + Action.MOVE.componentKey;
}

/**
 * 分享Action注册类
 */
export class MoveActionRegister extends ActionRegister {
  public static readonly LISTENER: string = 'com.ohos.photos.move.listener';
  public static readonly SELECTED_PARSE_RESULT: string = 'com.ohos.photos.move.selected_parse_result';

  public getActions(): Action[] {
    return [Action.MOVE];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new MoveActionViewModel();
  }

  protected buildModel(action: Action, params: ParamsWrapper): ActionModel | undefined {
    return {
      produce: () => {
        let menuContext: MenuContext = new MenuContext();
        menuContext.withBroadCast(params.get<BroadCast>(MenuConstants.KEY_BROADCAST))
          .set(MenuConstants.KEY_NAV_PATH_STACK, params.get(MenuConstants.KEY_NAV_PATH_STACK))
          .set(MenuConstants.KEY_SELECTION_MANAGER, params.get(MenuConstants.KEY_SELECTION_MANAGER))
          .set(MoveActionRegister.SELECTED_PARSE_RESULT, params.get(MoveActionRegister.SELECTED_PARSE_RESULT))
          .set(MoveActionRegister.LISTENER, params.get(MoveActionRegister.LISTENER))
          .set(MenuConstants.KEY_ALBUM_INFO, params.get(MenuConstants.KEY_ALBUM_INFO));
        return menuContext;
      }
    };
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return new MoveActionProp();
  }
}

/**
 * 点击搜索VM层
 */
export class MoveActionViewModel implements ActionViewModel {
  public doAction(menuContext?: MenuContext): void {
    if (!menuContext) {
      Log.error(TAG, 'invalid menuContext');
      return;
    }
    let parseResult: ParamsWrapper =
      menuContext.get<ParamsWrapper>(MoveActionRegister.SELECTED_PARSE_RESULT) ?? new ParamsWrapper();
    let pageType: string = MediaOperationType.MOVE;
    let mediaType: number = parseResult.get<number>(MediaTypeChecker.KEY_SELECT_MEDIA_TYPE) ?? SelectMediaType.INVALID;
    let albumInfo: AlbumInfo | undefined = menuContext?.get<AlbumInfo>(MenuConstants.KEY_ALBUM_INFO);
    MediaOperationBasePage.judgeIsEmptyAlbumsAndCallbackByMediaType(albumInfo?.uri,
      (): void => this.showPromptNewAlbumDialog(menuContext),
      (blackUris?: string[]): void => this.routeToSelectAlbumPage(menuContext, pageType, [], mediaType, blackUris),
      mediaType);
  }

  private showPromptNewAlbumDialog(menuContext?: MenuContext): void {
    let broadcast: BroadCast | undefined = menuContext?.broadCast;
    if (!broadcast) {
      Log.error(TAG, 'invalid broadcast');
      return;
    }
    broadcast.emit(BroadCastConstants.PROMPT_NEW_ALBUMS_DIALOG, [
      (): void => {
        Log.info(TAG, 'new albums cancel');
      },
      (): void => {
        Log.info(TAG, 'createNewAlbum');
        let createAlbumContext = new MenuContext();
        createAlbumContext
          .withAlbumInfo(undefined)
          .withBroadCast(broadcast)
          .withJumpSourceToMain(JumpSourceToMain.ALBUM)
          .set(AlbumSetNewMenuOperation.LISTENER, {
            onCompleted: (albumName: string, albumUri: string | undefined) => this.onAlbumChosen(menuContext,
              albumName, albumUri),
          } as AlbumCreateListener);
        let menuOperation =
          MenuOperationFactory.getInstance().createMenuOperation(AlbumSetNewMenuOperation, createAlbumContext);
        menuOperation.doAction();
      }
    ]);
  }

  private onAlbumChosen(menuContext: MenuContext | undefined, albumName: string, albumUri: string | undefined,
    callback?: Function): void {
    // 相册创建/选择完毕后，将文件复制/移动过去
    let listener: OperationListener | undefined = menuContext?.get<OperationListener>(MoveActionRegister.LISTENER);

    let moveContext: MenuContext = new MenuContext()
      .withSelectManager(menuContext?.get<SelectManager>(MenuConstants.KEY_SELECTION_MANAGER))
      .withOperationStartCallback((): void => listener?.onOperationStart?.())
      .withOperationEndCallback((): void => listener?.onOperationEnd?.())
      .withNavigationPageFunc(callback)
      .withTargetAlbumName(albumName)
      .withAlbumUri(albumUri);
    if (!menuContext?.broadCast) {
      Log.warn(TAG, 'no valid broadcast');
    } else {
      moveContext.withBroadCast(menuContext.broadCast);
    }
    new MoveMenuOperation(moveContext).doAction();
  }

  private routeToSelectAlbumPage(menuContext: MenuContext | undefined, pageType: string,
    selectedItems: MediaItem[], mediaType: number, blackUris?: string[]): void {
    let colorMode: ConfigurationConstant.ColorMode =
      AppStorage.get<ConfigurationConstant.ColorMode>('currentColorMode') ??
      ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
    Log.info(TAG, `Route to select album page ${colorMode},${ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT}`);
    let albumInfo: AlbumInfo | undefined = menuContext?.get<AlbumInfo>(MenuConstants.KEY_ALBUM_INFO);
    NavigationBroadCastManager.getInstance().targetName = NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION;
    if (colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      WindowUtil.updateWindowSystemBarProperties(Constants.STATUS_BAR_CONTENT_COLOR);
    } else {
      WindowUtil.updateWindowSystemBarProperties(Constants.RULER_FILL_STYLE_100);
    }

    /*
     * 有可移动的目标相册时，先跳转到选择相册页面（MediaOperationBasePage）
     * 在选择完成时，MediaOperationBasePage会发出NAVIGATION_DESTINATION_MEDIA_OPERATION_BACK广播，
     * 并且在广播里把 相册信息、文件操作完成回调 带回来，需要宿主完成后续的文件操作
     * 当宿主文件操作完成时，再调用广播里的 文件操作完成回调 ，以关掉MediaOperationBasePage
     * 但是操作是有明确上下文的，如果使用广播方式可能跟其他操作混杂在一起
     * 所以这里改成可选listener方式，不需要宿主监听广播，只需要对接后续操作即可
     */
    const params: Params = {
      pageFrom: Constants.MEDIA_OPERATION_FROM_TIMELINE,
      pageType: pageType,
      selectedItems: selectedItems,
      albumInfo: albumInfo,
      mediaType: mediaType,
      blackUriList: blackUris,
      listener: {
        onAlbumChosen: (displayName: string, albumUri: string,
          navigationPageFunc: () => void) => this.onAlbumChosen(menuContext, displayName, albumUri, navigationPageFunc),
      },
    };
    let broadcast: BroadCast = NavigationBroadCastManager.getInstance().getBroadCast();
    broadcast.emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION]).then(() => {
      let navPathStack: NavPathStack | undefined = menuContext?.get<NavPathStack>(MenuConstants.KEY_NAV_PATH_STACK);
      navPathStack?.pushPath(new NavPathInfo(NavigationConstants.NAVIGATION_DESTINATION_MEDIA_OPERATION, params));
    });
  }
}