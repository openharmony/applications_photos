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

export class DialogUtils {
    // simple Dialog，only one confirm button
    static showSimpleDialog(contentText: Resource, confirmText: Resource,
                            confirmCallback: Function, cancelCallback: Function) {
        AlertDialog.show({
            message: contentText,
            autoCancel: false,
            confirm: {
                value: confirmText,
                action: () => {
                    confirmCallback && confirmCallback();
                }
            },
            // Click the callback of the mask layer
            cancel: () => {
                cancelCallback && cancelCallback();
            }
        });
    }

    // standard Dialog，two button
    static showDialog(contentText: Resource, confirmText: Resource,
                      cancelText: Resource, confirmCallback: Function, cancelCallback: Function) {
        AlertDialog.show({
            message: contentText,
            autoCancel: true,
            alignment: DialogAlignment.Bottom,
            offset: { dx: 0, dy: $r('app.float.dialog_content_margin_bottom') },
            primaryButton: {
                value: cancelText,
                action: () => {
                    cancelCallback && cancelCallback();
                }
            },
            secondaryButton: {
                value: confirmText,
                action: () => {
                    confirmCallback && confirmCallback();
                }
            },
            // Click the callback of the mask layer
            cancel: () => {
                cancelCallback && cancelCallback();
            }
        });
    }

    static showSimpleDialogWithTitle(title: Resource, contentText: Resource, confirmText: Resource,
                                     confirmCallback: Function, cancelCallback: Function) {
        AlertDialog.show({
            title: title,
            message: contentText,
            autoCancel: false,
            confirm: {
                value: confirmText,
                action: () => {
                    confirmCallback && confirmCallback();
                }
            },
            cancel: () => {
                cancelCallback && cancelCallback();
            }
        });
    }

    static showDialogWithTitle(title: Resource, contentText: Resource, confirmText: Resource,
                               cancelText: Resource, confirmCallback: Function, cancelCallback: Function) {
        AlertDialog.show({
            title: title,
            message: contentText,
            autoCancel: false,
            primaryButton: {
                value: cancelText,
                action: () => {
                    cancelCallback && cancelCallback();
                }
            },
            secondaryButton: {
                value: confirmText,
                action: () => {
                    confirmCallback && confirmCallback();
                }
            },
            cancel: () => {
                cancelCallback && cancelCallback();
            }
        });
    }
}