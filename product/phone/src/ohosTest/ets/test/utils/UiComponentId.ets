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

export namespace UiComponentId {
  /** 公共id配置 **/
  // 照片页
  export const TAB_PHOTOS: string = 'TabPhotos'

  // 相册页
  export const TAB_ALBUMS: string = 'TabAlbums'

  // 时刻页
  export const TAB_HIGHLIGHTS: string = 'TabHighlights'

  // 相册宫格页返回相册页面
  export const GRID_BACK_ALBUMS: string = 'ActionButton_Back'

  // 相册宫格页-新增相册按钮
  export const GRID_NEW_ALBUM: string = 'AccessibilityComponentNewAlbum';

  // 相册宫格页-更多
  export const GRID_ACTION_MORE: string = 'ActionBarButtonTimelineActionMore';

  // 相册宫格页-更多-设置
  export const GRID_MORE_SETTING: string = 'ActionBarButton_Text_GallerySettings';

  // 相册宫格页-更多-设置-账号
  export const GRID_MORE_SETTING_ACCOUNT: string = 'AccountListCard';

  // 照片-更多
  export const PHOTOS_MORE: string = 'ActionButton_More'

  // 照片-更多-设置
  export const PHOTOS_MORE_SETTING: string = 'ActionBarButton_Text_ActionButton_GallerySetting';

  // 照片-更多-设置-自动播放动态照片
  export const AUTO_PLAY_MOVING_PHOTO_SETTING: string = 'autoPlayMovingPhotoToggle';

  // 照片-更多-关于
  export const PHOTOS_MORE_ABOUT: string = 'ActionBarButton_Text_ActionButton_About';

  // 照片-搜索
  export const PHOTOS_SEARCH: string = 'ActionButton_Search';

  // 下拉截图
  export const SCREENSHOT: string = 'transition_toggletoggle_screenshot';

  // 照片-今天
  export const PHOTOS_MAIN_TITLE: string = 'MainTitle';

  // 照片
  export const PHOTOS_SWITCH: string = 'switch';

  // 照片-元素item
  export const PHOTOS_GRID_VIEW_ITEM: string = 'photoGridView_gird_1';

  // 大图-browser_ActionBarView
  export const PHOTOS_BROWSER_ACTIONBARVIEW: string = 'browser_ActionBarView';

  // 大图-返回
  export const PHOTOS_BROWSER_BACK: string = 'More_Image_Back';

  // 大图-返回,button
  export const PHOTOS_BROWSER_BACK_BUTTON: string = 'AccessibilityComponent_BrowserBack';

  // 大图-日期
  export const PHOTOS_BROWSER_DATE_TITLE: string = 'PhotoBrowserDateTitle';

  // 大图-时间
  export const PHOTOS_BROWSER_TIME_LOCATION: string = 'PhotoBrowserTimeLocationTitle';

  // 大图-中间动态照片组件
  export const PHOTOS_BROWSER_MOVING_PHOTO: string = 'movingPhoto';

  // 大图-视频截图
  export const PHOTOS_BROWSER_VIDEOSCREENSHOT_BUTTON: string = 'PhotoBrowserActionBarButtonvideoScreenshot';

  // 大图-视频截图
  export const PHOTOS_BROWSER_VIDEOSCREENSHOT: string = 'More_Image_videoScreenshot';

  // 大图-更多
  export const PHOTOS_BROWSER_MORE: string = 'More_Image_More';

  // 大图-更多按钮
  export const PHOTOS_BROWSER_MORE_BUTTON: string = 'PhotoBrowserActionBarButtonMore';

  // 大图-播放按钮
  export const PHOTOS_BROWSER_VIDEOPLAY_BUTTON: string = 'VideoPlayButton';

  // 大图-播放后toolbar暂停按钮
  export const PHOTOS_BROWSER_TOOLBAR_PAUSE: string = 'ToolBarButtonvideoPlay';

  // 大图-播放后暂停后toolbar播放按钮
  export const PHOTOS_BROWSER_TOOLBAR_PLAY: string = 'ToolBarButtonvideoPause';

  // 大图-播放后暂停后toolbar静音按钮
  export const PHOTOS_BROWSER_TOOLBAR_SOUND_FILLED: string = 'ToolBarButtonsoundFilled';

  // 大图-播放后暂停后toolbar取消静音按钮
  export const PHOTOS_BROWSER_TOOLBAR_SOUND_OFFFILLED: string = 'ToolBarButtonsound_off_filled';

  // 大图-预览滑动条
  export const PHOTOS_BROWSER_PREVIEW_BAR: string = 'PhotoBrowserPreviewBar';

  // 大图-分享
  export const PHOTOS_BROWSER_TOOL_BAR_SHARE: string = 'ToolBarButtonShare';

  // 大图-收藏
  export const PHOTOS_BROWSER_TOOL_BAR_FAVORITE: string = 'ToolBarButtonFavor';

  // 大图-编辑
  export const PHOTOS_BROWSER_TOOL_BAR_EDIT: string = 'ToolBarButtonEdit';

  // 大图-删除
  export const PHOTOS_BROWSER_TOOL_BAR_DELETE: string = 'ToolBarButtonDelete';

  // 大图-动态照片
  export const PHOTOS_BROWSER_TOOL_BAR_MOTION_PICTURE: string = 'ToolBarButtonMotionPicture';

  // 大图-更多-设置为壁纸
  export const PHOTOS_BROWSER_MORE_SET_WALLPAPER: string = 'ActionBarButton_Text_setWallpaper';

  // 大图-更多-扫描为文档
  export const PHOTOS_BROWSER_MORE_SCANASDOC: string = 'ActionBarButton_Text_DocumentScan';

  // 大图-更多-识别图中二维码
  export const PHOTOS_BROWSER_MORE_SCANQRCODE: string = 'ActionBarButton_Text_Scan_QRCode';

  // 大图-更多-移动到
  export const PHOTOS_BROWSER_MORE_MOVE: string = 'ActionBarButton_Text_Move';

  // 大图-更多-隐藏
  export const PHOTOS_BROWSER_MORE_HIDE: string = 'ActionBarButton_Text_Hide';

  // 大图-更多-重命名
  export const PHOTOS_BROWSER_MORE_RENAME: string = 'ActionBarButton_Text_Rename';

  // 大图-更多-播放幻灯片
  export const PHOTOS_BROWSER_MORE_SLIDE_SHOW: string = 'ActionBarButton_Text_Slideshow';

  // 大图-更多-详细信息
  export const PHOTOS_BROWSER_MORE_DETAIL_INFO: string = 'ActionBarButton_Text_Info';

  // 大图-详细信息-预览
  export const PHOTOS_BROWSER_INFO_FOCUS_COLUMN: string = 'browserFocusColumn';

  // 大图-详细信息-添加备注
  export const PHOTOS_BROWSER_INFO_USER_COMMENT: string = 'TextInput';

  // 大图-详细信息-title
  export const PHOTOS_BROWSER_INFO_TITLE: string = 'PhotoDetailTitle';

  // 大图-详细信息-DateTime
  export const PHOTOS_BROWSER_INFO_DATE_TIME: string = 'PhotoDetailDateTime';

  // 大图-详细信息-分辨率
  export const PHOTOS_BROWSER_INFO_RESOLUTION_AND_SIZE: string = 'PhotoDetailResolutionAndSize';

  // 大图-详细信息-ISO
  export const PHOTOS_BROWSER_INFO_SPEED_RATION: string = 'PhotoDetailISOSpeedRatings';

  // 大图-详细信息-曝光时间
  export const PHOTOS_BROWSER_INFO_EXPOSURE_TIME: string = 'PhotoDetailExposureTime';

  // 大图-详细信息-光圈
  export const PHOTOS_BROWSER_INFO_APERTURE_VALUE: string = 'PhotoDetailApertureValue';

  // 大图-详细信息-光圈
  export const PHOTOS_BROWSER_INFO_FNUMBER: string = 'PhotoDetailFNumber';

  // 大图-详细信息-焦距
  export const PHOTOS_BROWSER_INFO_FOCAL_LENGTH: string = 'PhotoDetailFocalLengthIn35mmFilm';

  // 大图-详细信息-光源
  export const PHOTOS_BROWSER_INFO_LIGHT_SOURCE: string = 'PhotoDetailLightSource';

  // 大图-详细信息-测光模式
  export const PHOTOS_BROWSER_INFO_METERING_MODE: string = 'PhotoDetailMeteringMode';

  // 大图-详细信息-闪光灯
  export const PHOTOS_BROWSER_INFO_FLASH: string = 'PhotoDetailFlash';

  // 大图-详细信息-地图预览
  export const PHOTOS_BROWSER_INFO_MAP_VIEW: string = 'mapview';

  // 大图-更多-扫描为文档，预览编辑页面 返回按钮
  export const SCANASDOC_BACK: string = 'back_button.build.image';

  // 大图-更多-扫描为文档，预览编辑页面 保存按钮
  export const SCANASDOC_SAVE: string = 'saveIconButton';

  // 大图-更多-扫描为文档，预览编辑页面 保存图片按钮
  export const SAVE_OPTION_PIC: string = 'save_option_pic';

  // 大图-更多-扫描为文档，预览编辑页面 保存PDF按钮
  export const SAVE_OPTION_PDF: string = 'save_option_pdf';

  // 大图-更多-扫描为文档，文件保存页面，确认按钮
  export const DIALOG_CONFIRM: string = 'dialog_confirm';

  // 大图-更多-扫描为文档，预览编辑页面 应用到所有页面
  export const SCANASDOC_APPLYALL: string = 'apply_page_com.build.checkbox';

  // 大图-更多-扫描为文档，预览编辑页面 原图
  export const SCANASDOC_RAW: string = 'filter_list.build.image_0';

  // 大图-更多-扫描为文档，预览编辑页面 黑白
  export const SCANASDOC_BLACKANDWHITE: string = 'filter_list.build.image_1';

  // 大图-更多-扫描为文档，预览编辑页面 增强
  export const SCANASDOC_ENHANCE: string = 'filter_list.build.image_2';

  // 大图-更多-扫描为文档，预览编辑页面 裁剪
  export const SCANASDOC_TOOLBAR_ENHANCE: string = 'doc_edit_toolbar.tool_button.icon_button';

  // 大图-更多-扫描为文档，预览编辑页面 滤镜
  export const SCANASDOC_TOOLBAR_FILTER: string = 'doc_edit_toolbar.tool_button.icon_button1';

  // 大图-更多-扫描为文档，预览编辑页面 旋转
  export const SCANASDOC_TOOLBAR_ROTATE: string = 'doc_edit_toolbar.tool_button.icon_button2';

  // 大图-更多-扫描为文档，预览编辑页面 删除
  export const SCANASDOC_TOOLBAR_DELETE: string = 'doc_edit_toolbar.tool_button.icon_button3';

  // 大图-更多-扫描为文档，预览编辑页面 重拍
  export const SCANASDOC_TOOLBAR_RESCAN: string = 'doc_edit_toolbar.tool_button.icon_button4';

  // 悬浮窗状态 大图-更多-扫描为文档，暂不支持悬浮窗页面 关闭按钮
  export const SCANASDOC_FLOAT_CLOSE: string = 'closeButton';

  //录屏相关组件id
  //竖屏状态下 屏幕上方预览条 录屏组件
  export const CAPSULE_STATUSBAR: string = 'StatusBarView_LiveCapsuleListContainer';

  //横屏状态下 屏幕上方预览条 录屏组件
  export const CAPSULE_STATUSBAR_NOHOLE: string = 'CapsuleListWithoutHoleStatusView_LiveCapsuleListContainer';

  export const KEYBOARD_HIDE_BUTTON: string = 'KeyHideKbd';
}