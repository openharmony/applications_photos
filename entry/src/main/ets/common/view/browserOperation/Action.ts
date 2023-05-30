/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

enum ActionID {
    NONE,
    OK,
    OK_DISABLE,
    CANCEL,
    BACK,
    INFO,
    INFO_INVALID,
    DELETE,
    DELETE_RECYCLE,
    CLEAR_RECYCLE,
    DELETE_INVALID,
    RECOVER,
    RECOVER_INVALID,
    FAVORITE,
    NOT_FAVORITE,
    UN_SELECTED,
    SELECTED,
    SELECT_ALL,
    DESELECT_ALL,
    SETTING,
    NAVIGATION,
    MATERIAL_SELECT,
    GOTO_PHOTOS,
    SHARE,
    SHARE_INVALID,
    EDIT,
    EDIT_INVALID,
    MORE,
    NEW,
    RENAME,
    RENAME_INVALID,
    ADD_NOTES,
    ROTATE,
    MOVE,
    MOVE_INVALID,
    COPY,
    COPY_INVALID,
    NAVIGATION_ALBUMS,
    DOWNLOAD,
    DOWNLOAD_INVALID,
    CLEAR_RECYCLE_INVALID
}

interface ActionOptions {
    id: number;
    textRes: Resource;
    iconRes?: Resource;
    isAutoTint?: boolean;
    fillColor?: Resource;
    actionType?: Resource;
}

export class Action {
    public static NONE = new Action({
        id: ActionID.NONE,
        iconRes: null,
        textRes: null
    });
    public static OK = new Action({
        id: ActionID.OK,
        iconRes: $r('app.media.ic_gallery_public_ok'),
        textRes: $r('app.string.action_ok')
    });
    public static OK_DISABLE = new Action({
        id: ActionID.OK_DISABLE,
        iconRes: $r('app.media.ic_gallery_public_ok'),
        textRes: $r('app.string.action_ok'),
        fillColor: $r('app.color.icon_disabled_color')
    });
    public static CANCEL = new Action({
        id: ActionID.CANCEL,
        iconRes: $r('app.media.ic_gallery_public_cancel'),
        textRes: $r('app.string.action_cancel')
    });
    public static BACK = new Action({
        id: ActionID.BACK,
        iconRes: $r('app.media.ic_gallery_public_back'),
        textRes: $r('app.string.action_back')
    });
    public static INFO = new Action({
        id: ActionID.INFO,
        iconRes: $r('app.media.ic_gallery_public_details'),
        textRes: $r('app.string.action_info')
    });
    public static INFO_INVALID = new Action({
        id: ActionID.INFO,
        iconRes: $r('app.media.ic_gallery_public_details'),
        textRes: $r('app.string.action_info'),
        fillColor: $r('app.color.icon_disabled_color')
    });
    public static DELETE = new Action({
        id: ActionID.DELETE,
        iconRes: $r('app.media.ic_gallery_public_delete_line'),
        textRes: $r('app.string.action_delete'),
        actionType: $r('app.string.action_delete')
    });
    public static DELETE_RECYCLE = new Action({
        id: ActionID.DELETE_RECYCLE,
        iconRes: $r('app.media.ic_gallery_public_delete_line'),
        textRes: $r('app.string.action_delete'),
        actionType: $r('app.string.action_delete')
    });
    public static CLEAR_RECYCLE = new Action({
        id: ActionID.CLEAR_RECYCLE,
        iconRes: $r('app.media.ic_gallery_public_delete_line'),
        textRes: $r('app.string.action_clear_recycle'),
        actionType: $r('app.string.action_clear_recycle')
    });
    public static CLEAR_RECYCLE_INVALID = new Action({
        id: ActionID.CLEAR_RECYCLE_INVALID,
        iconRes: $r('app.media.ic_gallery_public_delete_line'),
        textRes: $r('app.string.action_clear_recycle'),
        fillColor: $r('app.color.icon_disabled_color'),
        actionType: $r('app.string.action_delete')
    });
    public static DELETE_INVALID = new Action({
        id: ActionID.DELETE_INVALID,
        iconRes: $r('app.media.ic_gallery_public_delete_line'),
        textRes: $r('app.string.action_delete'),
        fillColor: $r('app.color.icon_disabled_color'),
        actionType: $r('app.string.action_delete_invalid')
    });
    public static RECOVER = new Action({
        id: ActionID.RECOVER,
        iconRes: $r('app.media.ic_gallery_public_undo'),
        textRes: $r('app.string.action_recover'),
        actionType: $r('app.string.action_recover')
    });
    public static RECOVER_INVALID = new Action({
        id: ActionID.RECOVER_INVALID,
        iconRes: $r('app.media.ic_gallery_public_undo'),
        textRes: $r('app.string.action_recover'),
        fillColor: $r('app.color.icon_disabled_color'),
        actionType: $r('app.string.action_recover')
    });
    public static FAVORITE = new Action({
        id: ActionID.FAVORITE,
        iconRes: $r('app.media.ic_gallery_public_Favorite_filled'),
        textRes: $r('app.string.action_favorite'),
        fillColor: $r('app.color.color_system_highlight'),
        actionType: $r('app.string.action_favorite')
    });
    public static NOT_FAVORITE = new Action({
        id: ActionID.NOT_FAVORITE,
        iconRes: $r('app.media.ic_gallery_public_favorite_line'),
        textRes: $r('app.string.action_not_favorite'),
        actionType: $r('app.string.action_not_favorite')
    });
    public static UN_SELECTED = new Action({
        id: ActionID.UN_SELECTED,
        iconRes: $r('app.media.ic_checkbox_off'),
        textRes: $r('app.string.action_unselected'),
        actionType: $r('app.string.action_unselected')
    });
    public static SELECTED = new Action({
        id: ActionID.SELECTED,
        iconRes: $r('app.media.ic_gallery_public_checkbox_filled'),
        textRes: $r('app.string.action_selected'),
        isAutoTint: false,
        actionType: $r('app.string.action_selected')
    });
    public static SELECT_ALL = new Action({
        id: ActionID.SELECT_ALL,
        iconRes: $r('app.media.ic_gallery_public_select_all'),
        textRes: $r('app.string.action_select_all'),
        actionType: $r('app.string.action_select_all')
    });
    public static DESELECT_ALL = new Action({
        id: ActionID.DESELECT_ALL,
        iconRes: $r('app.media.ic_gallery_public_select_all_action'),
        textRes: $r('app.string.action_deselect_all'),
        actionType: $r('app.string.action_deselect_all')
    });
    public static SETTING = new Action({
        id: ActionID.SETTING,
        textRes: $r('app.string.action_setting')
    });
    public static NAVIGATION = new Action({
        id: ActionID.NAVIGATION,
        textRes: $r('app.string.action_navigation')
    });
    public static MATERIAL_SELECT = new Action({
        id: ActionID.MATERIAL_SELECT,
        iconRes: $r('app.media.ic_checkbox_off_overlay'),
        textRes: $r('app.string.action_material_select'),
        isAutoTint: false,
        actionType: $r('app.string.action_selected')
    });
    public static GOTO_PHOTOS = new Action({
        id: ActionID.GOTO_PHOTOS,
        iconRes: $r('app.media.ic_goto_photos'),
        textRes: $r('app.string.action_goto_photos')
    });
    public static SHARE = new Action({
        id: ActionID.SHARE,
        iconRes: $r('app.media.ic_gallery_public_share'),
        textRes: $r('app.string.action_share'),
        actionType: $r('app.string.action_share')
    });
    public static SHARE_INVALID = new Action({
        id: ActionID.SHARE_INVALID,
        iconRes: $r('app.media.ic_gallery_public_share'),
        fillColor: $r('app.color.icon_disabled_color'),
        textRes: $r('app.string.action_share'),
        actionType: $r('app.string.action_share')
    });
    public static EDIT = new Action({
        id: ActionID.EDIT,
        iconRes: $r('app.media.ic_gallery_public_edit'),
        textRes: $r('app.string.action_edit')
    });
    public static EDIT_INVALID = new Action({
        id: ActionID.EDIT_INVALID,
        iconRes: $r('app.media.ic_gallery_public_edit_disable'),
        textRes: $r('app.string.action_edit'),
        fillColor: $r('app.color.icon_disabled_color')
    });
    public static MORE = new Action({
        id: ActionID.MORE,
        iconRes: $r('app.media.ic_gallery_public_more'),
        textRes: $r('app.string.action_more')
    });
    public static NEW = new Action({
        id: ActionID.NEW,
        iconRes: $r('app.media.ic_gallery_public_new'),
        textRes: $r('app.string.action_new')
    });
    public static RENAME = new Action({
        id: ActionID.RENAME,
        iconRes: $r('app.media.ic_gallery_public_rename'),
        textRes: $r('app.string.action_rename'),
        actionType: $r('app.string.action_rename')
    });
    public static RENAME_INVALID = new Action({
        id: ActionID.RENAME_INVALID,
        iconRes: $r('app.media.ic_gallery_public_rename'),
        textRes: $r('app.string.action_rename'),
        fillColor: $r('app.color.icon_disabled_color'),
        actionType: $r('app.string.action_deRename')
    });
    public static ROTATE = new Action({
        id: ActionID.ROTATE,
        iconRes: $r('app.media.ic_edit_photo_crop_rotate'),
        textRes: $r('app.string.rotate_text'),
        actionType: $r('app.string.rotate_text')
    });
    public static ADD_NOTES = new Action({
        id: ActionID.ADD_NOTES,
        iconRes: null,
        textRes: $r('app.string.add_notes')
    });
    public static MOVE = new Action({
        id: ActionID.MOVE,
        textRes: $r('app.string.action_move_to_album')
    });
    public static MOVE_INVALID = new Action({
        id: ActionID.MOVE_INVALID,
        textRes: $r('app.string.action_move_to_album'),
        fillColor: $r('app.color.icon_disabled_color')
    });
    public static COPY = new Action({
        id: ActionID.COPY,
        textRes: $r('app.string.action_copy_to_album')
    });
    public static COPY_INVALID = new Action({
        id: ActionID.COPY_INVALID,
        textRes: $r('app.string.action_copy_to_album'),
        fillColor: $r('app.color.icon_disabled_color')
    });
    public static NAVIGATION_ALBUMS = new Action({
        id: ActionID.NAVIGATION_ALBUMS,
        iconRes: $r('app.media.ic_navigation_albums_line'),
        textRes: $r('app.string.rotate_text')
    });
    public static DOWNLOAD = new Action({
        id: ActionID.DOWNLOAD,
        iconRes: $r('app.media.download'),
        textRes: $r('app.string.save_to_local')
    });
    public static DOWNLOAD_INVALID = new Action({
        id: ActionID.DOWNLOAD_INVALID,
        iconRes: $r('app.media.download'),
        textRes: $r('app.string.save_to_local'),
        fillColor: $r('app.color.icon_disabled_color')
    });
    public static ICON_DEFAULT_COLOR: Resource = $r('app.color.icon_default_color');
    public static ICON_DEFAULT_COLOR_CONTRARY: Resource = $r('app.color.icon_default_color_contrary');
    readonly actionID: number;
    readonly textRes: Resource;
    readonly iconRes: Resource = $r('app.media.ic_gallery_public_more');
    readonly isAutoTint: boolean = true;
    readonly fillColor: Resource = $r('app.color.icon_default_color');
    readonly actionType: Resource; // It is used to distinguish whether it is the same type of action

    constructor(options: ActionOptions) {
        this.actionID = options.id;
        this.textRes = options.textRes;
        if (options.iconRes != undefined) {
            this.iconRes = options.iconRes;
        }
        if (options.isAutoTint != undefined) {
            this.isAutoTint = options.isAutoTint;
        }
        if (options.fillColor != undefined) {
            this.fillColor = options.fillColor;
        }
        if (options.actionType != undefined) {
            this.actionType = options.actionType;
        }
    }

    public equals(action: Action): boolean {
        return (action) ? (action.actionID === this.actionID) : false;
    }
}
