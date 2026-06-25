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
import lazy { Action } from '../browserOperation/Action';
import lazy { MenuContext } from '../browserOperation/MenuContext';
import lazy { ActionViewModel, MenuConstants, ParamsWrapper } from './Menu';
import lazy { ActionRegister } from './ActionRegister';
import lazy { ActionButtonProp, DefaultActionButtonProp, applyPcStyles } from './ActionButton';
import lazy { AlbumInfo } from '../../model/browser/album/AlbumInfo';
import lazy { Log } from '@ohos/tools/src/main/utils/Log';
import lazy { Constants } from '../../model/common/Constants';
import lazy { NavigationConstants } from '../../model/common/NavigationConstants';
import lazy { BroadCast } from '../../utils/BroadCast';
import lazy { SelectParams } from '../../model/common/SelectParams';
import lazy { AlbumDefine } from '../../model/browser/AlbumDefine';
import lazy { UiUtil } from '../../utils/UiUtil';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';

/* instrument ignore file */
const TAG = 'AddAction';

@Observed
export class AddActionProp extends DefaultActionButtonProp {
  public action = Action.ADD_PHOTO;
  public icon = $r('sys.symbol.plus');
  public text = $r('app.string.action_add_photo');
  public key = 'ActionButton_Add_Photo';
}

/**
 * 添加按钮属性，PC场景使用
 */
@Observed
export class PcAddActionProp extends AddActionProp {
  public constructor() {
    super();
    applyPcStyles(this);
  }
}

/**
 * Action注册类
 */
export class AddActionRegister extends ActionRegister {
  public getActions(): Action[] {
    return [Action.ADD_PHOTO];
  }

  protected buildViewModel(action: Action, params: ParamsWrapper): ActionViewModel | undefined {
    return new AddActionViewModel(params);
  }

  public buildViewProp(action: Action, params: ParamsWrapper): ActionButtonProp {
    return DeviceInfo.isPc() ? new PcAddActionProp() : new AddActionProp();
  }
}

/**
 * VM层
 */
export class AddActionViewModel implements ActionViewModel {
  public static readonly ADD: string = 'add';
  private readonly navigationPageInfos: NavPathStack;
  public albumInfo: AlbumInfo;
  public broadCast: BroadCast;
  public navigationBroadCast: BroadCast;
  public addActionOperate: Function = (): void => {
  };

  /**
   * 构造函数
   * @param navigationPageInfos 导航栈
   */
  public constructor(params: ParamsWrapper) {
    this.navigationPageInfos = params?.get<NavPathStack>(MenuConstants.KEY_NAV_PATH_STACK) as NavPathStack;
    this.albumInfo = params?.get<AlbumInfo>(MenuConstants.KEY_ALBUM_INFO) as AlbumInfo;
    this.broadCast = params?.get<BroadCast>(MenuConstants.KEY_BROADCAST) as BroadCast;
    this.navigationBroadCast = params?.get<BroadCast>(MenuConstants.KEY_NAVIGATION_BROADCAST) as BroadCast;
    if (DeviceInfo.isPc()) {
      this.addActionOperate = params?.get<Function>(AddActionViewModel.ADD) as Function;
    }
  }

  public doAction(menuContext?: MenuContext): void {
    Log.info(TAG, `doAction album: ${this.albumInfo?.uri}`)
    const params: SelectParams = new SelectParams();
    params.bundleName = Constants.PHOTO_BUNDLE_NAME;
    params.isMultiPick = true;
    params.filterMediaType = AlbumDefine.FILTER_MEDIA_TYPE_ALL;
    params.isFirstEnter = true;
    params.maxSelectCount = Constants.LIMIT_MAX_THIRD_SELECT_COUNT;
    params.uri = '';
    params.cameraAble = false;
    params.editAble = false;
    if (DeviceInfo.isPc()) {
      this.addActionOperate(params, this.albumInfo);
      return;
    }
    params.albumName =
      this.albumInfo.isSystemAlbum && !this.albumInfo.isSystemAlbum ?
        (UiUtil.getResourceStringSync(this.albumInfo.albumName as Resource)) : (this.albumInfo.albumName as string);
    params.albumUri = this.albumInfo.uri;
    params.isNewAlbum = false;
    this.navigationBroadCast.emitAsync(
      NavigationConstants.LOAD_PAGE, [NavigationConstants.NAVIGATION_PICKER_BASE_PAGE]).then(() => {
      this?.navigationPageInfos?.pushPath(
        new NavPathInfo(NavigationConstants.NAVIGATION_PICKER_BASE_PAGE, params), false);
    });
  }
}