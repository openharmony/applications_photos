/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

/**
 * @file
 * @kit FormKit
 */

import { AsyncCallback } from './@ohos.base';
import { Callback } from './@ohos.base';
import Want from './@ohos.app.ability.Want';
import formInfo from './@ohos.app.form.formInfo';

/**
 * Interface of formHost.
 *
 * @namespace formHost
 * @syscap SystemCapability.Ability.Form
 * @systemapi
 * @since 9
 */
declare namespace formHost {
  /**
   * Add a form.
   * <p>You can use this method to create a theme form.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Want } want - Indicates want of the form.
   * @returns { Promise<formInfo.RunningFormInfo> } Return the form info.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @stagemodelonly
   * @since 12
   */
  function addForm(want: Want): Promise<formInfo.RunningFormInfo>;

  /**
   * Deletes an obtained form by its ID.
   * <p>After this method is called, the form won't be available for use by the application and the Form Manager
   * Service no longer keeps the cache information about the form.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the form ID.
   * @param { AsyncCallback<void> } callback - The callback of deleteForm.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function deleteForm(formId: string, callback: AsyncCallback<void>): void;

  /**
   * Deletes an obtained form by its ID.
   * <p>After this method is called, the form won't be available for use by the application and the Form Manager
   * Service no longer keeps the cache information about the form.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the form ID.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function deleteForm(formId: string): Promise<void>;

  /**
   * Releases an obtained form by its ID.
   * <p>After this method is called, the form won't be available for use by the application, but the Form Manager
   * Service still keeps the cache information about the form, so that the application can quickly obtain it based on
   * the {@code formId}.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the form ID
   * @param { AsyncCallback<void> } callback - The callback of releaseForm.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function releaseForm(formId: string, callback: AsyncCallback<void>): void;

  /**
   * Releases an obtained form by its ID.
   * <p>After this method is called, the form won't be available for use by the application, but the Form Manager
   * Service still keeps the cache information about the form, so that the application can quickly obtain it based on
   * the {@code formId}.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the form ID
   * @param { boolean } isReleaseCache - Indicates whether release cache or not.
   * @param { AsyncCallback<void> } callback - The callback of releaseForm.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function releaseForm(formId: string, isReleaseCache: boolean, callback: AsyncCallback<void>): void;

  /**
   * Releases an obtained form by its ID.
   * <p>After this method is called, the form won't be available for use by the application, but the Form Manager
   * Service still keeps the cache information about the form, so that the application can quickly obtain it based on
   * the {@code formId}.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the form ID
   * @param { boolean } [isReleaseCache] - Indicates whether release cache or not.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function releaseForm(formId: string, isReleaseCache?: boolean): Promise<void>;

  /**
   * Requests for form update.
   * <p>This method must be called when the application has detected that a system setting item (such as the language,
   * resolution, or screen orientation) being listened for has changed. Upon receiving the update request, the form
   * provider automatically updates the form data (if there is any update) through the form framework, with the update
   * process being unperceivable by the application.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the ID of the form to update.
   * @param { AsyncCallback<void> } callback - The callback of requestForm.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function requestForm(formId: string, callback: AsyncCallback<void>): void;

  /**
   * Requests for form update.
   * <p>This method must be called when the application has detected that a system setting item (such as the language,
   * resolution, or screen orientation) being listened for has changed. Upon receiving the update request, the form
   * provider automatically updates the form data (if there is any update) through the form framework, with the update
   * process being unperceivable by the application.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the ID of the form to update.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function requestForm(formId: string): Promise<void>;

  /**
   * Requests for form update.
   * <p>This method must be called when the application has detected that a system setting item (such as the language,
   * resolution, or screen orientation) being listened for has changed. Upon receiving the update request, the form
   * provider automatically updates the form data (if there is any update) through the form framework, with the update
   * process being unperceivable by the application.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the ID of the form to update.
   * @param { Record<string, Object> } [wantParams] - Indicates want params of the form to update.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 12
   */
  function requestFormWithParams(formId: string, wantParams?: Record<string, Object>): Promise<void>;

  /**
   * Converts a specified temporary form that has been obtained by the application into a normal form.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the ID of the temporary form to convert.
   * @param { AsyncCallback<void> } callback - The callback of castToNormalForm.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501002 - The number of forms exceeds the maximum allowed.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function castToNormalForm(formId: string, callback: AsyncCallback<void>): void;

  /**
   * Converts a specified temporary form that has been obtained by the application into a normal form.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the ID of the temporary form to convert.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501002 - The number of forms exceeds the maximum allowed.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function castToNormalForm(formId: string): Promise<void>;

  /**
   * Sends a notification to the form framework to make the specified forms visible.
   * <p>After this method is successfully called, onVisibilityChange will be called to notify the form provider of
   * the form visibility change event.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the IDs of the forms to be made visible.
   * @param { AsyncCallback<void> } callback - The callback of notifyVisibleForms.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function notifyVisibleForms(formIds: Array<string>, callback: AsyncCallback<void>): void;

  /**
   * Sends a notification to the form framework to make the specified forms visible.
   * <p>After this method is successfully called, onVisibilityChange will be called to notify the form provider of
   * the form visibility change event.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the IDs of the forms to be made visible.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function notifyVisibleForms(formIds: Array<string>): Promise<void>;

  /**
   * Sends a notification to the form framework to make the specified forms invisible.
   * <p>After this method is successfully called, onVisibilityChange will be called to notify the form provider of
   * the form visibility change event.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the IDs of the forms to be made invisible.
   * @param { AsyncCallback<void> } callback - The callback of notifyInvisibleForms.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function notifyInvisibleForms(formIds: Array<string>, callback: AsyncCallback<void>): void;

  /**
   * Sends a notification to the form framework to make the specified forms invisible.
   * <p>After this method is successfully called, onVisibilityChange will be called to notify the form provider of
   * the form visibility change event.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the IDs of the forms to be made invisible.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function notifyInvisibleForms(formIds: Array<string>): Promise<void>;

  /**
   * Notify the form framework to make the specified forms updatable.
   * <p>You can use this method to set form refresh state to true, the form can receive new
   * update from service.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the IDs of the forms to be made invisible.
   * @param { AsyncCallback<void> } callback - The callback of enableFormsUpdate.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function enableFormsUpdate(formIds: Array<string>, callback: AsyncCallback<void>): void;

  /**
   * Notify the form framework to make the specified forms updatable.
   * <p>You can use this method to set form refresh state to true, the form can receive new
   * update from service.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the IDs of the forms to be made invisible.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function enableFormsUpdate(formIds: Array<string>): Promise<void>;

  /**
   * Notify the form framework to make the specified forms non-updatable.
   * <p>You can use this method to set form refresh state to false, the form do not receive
   * new update from service.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the IDs of the forms to be made invisible.
   * @param { AsyncCallback<void> } callback - The callback of disableFormsUpdate.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function disableFormsUpdate(formIds: Array<string>, callback: AsyncCallback<void>): void;

  /**
   * Notify the form framework to make the specified forms non updatable.
   * <p>You can use this method to set form refresh state to false, the form do not receive
   * new update from service.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the IDs of the forms to be made invisible.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function disableFormsUpdate(formIds: Array<string>): Promise<void>;

  /**
   * Checks whether the system is ready.
   * <p>You can use this method to obtain the system is ready.</p>
   *
   * @param { AsyncCallback<void> } callback - The callback of isSystemReady.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function isSystemReady(callback: AsyncCallback<void>): void;

  /**
   * Checks whether the system is ready.
   * <p>You can use this method to obtain the system is ready.</p>
   *
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function isSystemReady(): Promise<void>;

  /**
   * Obtains the FormInfo objects provided by all applications on the device.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { AsyncCallback<Array<formInfo.FormInfo>> } callback - The callback is used to return the FormInfo.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function getAllFormsInfo(callback: AsyncCallback<Array<formInfo.FormInfo>>): void;

  /**
   * Obtains the FormInfo objects provided by all applications on the device.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @returns { Promise<Array<formInfo.FormInfo>> } Returns the FormInfo.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function getAllFormsInfo(): Promise<Array<formInfo.FormInfo>>;

  /**
   * Obtains the FormInfo objects provided by a specified application on the device.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { AsyncCallback<Array<formInfo.FormInfo>> } callback - The callback is used to return the FormInfo.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16500100 - Failed to obtain the configuration information.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function getFormsInfo(bundleName: string, callback: AsyncCallback<Array<formInfo.FormInfo>>): void;

  /**
   * Obtains the FormInfo objects provided by a specified application on the device.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { string } moduleName - Indicates the module name of the application.
   * @param { AsyncCallback<Array<formInfo.FormInfo>> } callback - The callback is used to return the FormInfo.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16500100 - Failed to obtain the configuration information.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function getFormsInfo(
    bundleName: string,
    moduleName: string,
    callback: AsyncCallback<Array<formInfo.FormInfo>>
  ): void;

  /**
   * Obtains the FormInfo objects provided by a specified application on the device.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { string } bundleName - Indicates the bundle name of the application.
   * @param { string } [moduleName] - Indicates the module name of the application.
   * @returns { Promise<Array<formInfo.FormInfo>> } Returns the FormInfo.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16500100 - Failed to obtain the configuration information.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function getFormsInfo(bundleName: string, moduleName?: string): Promise<Array<formInfo.FormInfo>>;

  /**
   * Obtains the FormInfo objects provided by all application with filter on the device.
   *
   * @permission ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { formInfo.FormInfoFilter } filter - Indicates the requirements the forms that the formInfos belong to have
   *     to meet.
   * @returns { Promise<Array<formInfo.FormInfo>> } Returns the FormInfo.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16500100 - Failed to obtain the configuration information.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 12
   */
  function getFormsInfo(filter: formInfo.FormInfoFilter): Promise<Array<formInfo.FormInfo>>;

  /**
   * Deletes invalid forms of the application in the Form Manager Service based on the list of.
   * <p>You can use this method to delete invalid forms of the application.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the specified form id.
   * @param { AsyncCallback<number> } callback - The callback is used to return the number of invalid forms deleted
   *     by the Form Manager Service.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function deleteInvalidForms(formIds: Array<string>, callback: AsyncCallback<number>): void;

  /**
   * Deletes invalid forms of the application in the Form Manager Service based on the list of.
   * <p>You can use this method to delete invalid forms of the application.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the specified form id.
   * @returns { Promise<number> } Returns the number of invalid forms deleted by the Form Manager Service.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function deleteInvalidForms(formIds: Array<string>): Promise<number>;

  /**
   * Obtains the Form state.
   * <p>You can use this method to obtains the form state.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM and ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { Want } want - Indicates want of the form.
   * @param { AsyncCallback<formInfo.FormStateInfo> } callback - The callback is used to return the form state.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16500100 - Failed to obtain the configuration information.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function acquireFormState(want: Want, callback: AsyncCallback<formInfo.FormStateInfo>): void;

  /**
   * Obtains the Form state.
   * <p>You can use this method to obtains the form state.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM and ohos.permission.GET_BUNDLE_INFO_PRIVILEGED
   * @param { Want } want - Indicates want of the form.
   * @returns { Promise<formInfo.FormStateInfo> } Returns the form state.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16500100 - Failed to obtain the configuration information.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function acquireFormState(want: Want): Promise<formInfo.FormStateInfo>;

  /**
   * Listens to the event of uninstall form.
   * <p>You can use this method to listen to the event of uninstall form.</p>
   *
   * @param { 'formUninstall' } type - Indicates event type.
   * @param { Callback<string> } callback - The callback of formUninstall.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function on(type: 'formUninstall', callback: Callback<string>): void;

  /**
   * Cancels listening to the event of uninstall form.
   * <p>You can use this method to cancel listening to the event of uninstall form.</p>
   *
   * @param { 'formUninstall' } type - Indicates event type.
   * @param { Callback<string> } [callback] - The callback of formUninstall.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function off(type: 'formUninstall', callback?: Callback<string>): void;

  /**
   * Listens to the event of form's overflow.
   * <p>You can use this method to listen to the event of form's overflow.</p>
   *
   * @param { 'formOverflow' } type - Indicates event type.
   * @param { Callback<formInfo.OverflowRequest> } callback - The callback of formOverflow.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 801 - Capability not supported.function formOverflow can not work correctly
   *     due to limited device capabilities.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 20
   */
  function on(type: 'formOverflow', callback: Callback<formInfo.OverflowRequest>): void;

  /**
   * Cancels listening to the event of form's overflow.
   * <p>You can use this method to cancel listening to the event of form's overflow.</p>
   *
   * @param { 'formOverflow' } type - Indicates event type.
   * @param { Callback<formInfo.OverflowRequest> } callback - The callback of formOverflow.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 801 - Capability not supported.function formOverflow can not work correctly
   *     due to limited device capabilities.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 20
   */
  function off(type: 'formOverflow', callback?: Callback<formInfo.OverflowRequest>): void;

  /**
   * Listens to the event of change scene animation state.
   * <p>You can use this method to listen to the event of change scene animation state.</p>
   *
   * @param { 'changeSceneAnimationState' } type - Indicates event type.
   * @param { Callback<formInfo.ChangeSceneAnimationStateRequest> } callback - The callback of
   *     change scene animation state.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 801 - Capability not supported.function changeSceneAnimationState can not work correctly
   *     due to limited device capabilities.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 20
   */
  function on(type: 'changeSceneAnimationState',
    callback: Callback<formInfo.ChangeSceneAnimationStateRequest>): void;

  /**
   * Cancels listening to the event of change scene animation state.
   * <p>You can use this method to cancel listening to the event of change scene animation state.</p>
   *
   * @param { 'changeSceneAnimationState' } type - Indicates event type.
   * @param { Callback<formInfo.ChangeSceneAnimationStateRequest> } callback - The callback of
   *     change scene animation state.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 801 - Capability not supported.function changeSceneAnimationState can not work correctly
   *     due to limited device capabilities.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 20
   */
  function off(type: 'changeSceneAnimationState',
    callback?: Callback<formInfo.ChangeSceneAnimationStateRequest>): void;

  /**
   * Notify form is Visible
   * <p>You can use this method to notify form visible state.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the specified form id.
   * @param { boolean } isVisible - Indicates whether visible.
   * @param { AsyncCallback<void> } callback - The callback of notifyFormsVisible.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function notifyFormsVisible(formIds: Array<string>, isVisible: boolean, callback: AsyncCallback<void>): void;

  /**
   * Notify form is Visible
   * <p>You can use this method to notify form visible state.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the specified form id.
   * @param { boolean } isVisible - Indicates whether visible.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function notifyFormsVisible(formIds: Array<string>, isVisible: boolean): Promise<void>;

  /**
   * Notify form enable update state.
   * <p>You can use this method to notify form enable update state.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the specified form id.
   * @param { boolean } isEnableUpdate - Indicates whether enable update.
   * @param { AsyncCallback<void> } callback - The callback of notifyFormsEnableUpdate.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function notifyFormsEnableUpdate(
    formIds: Array<string>,
    isEnableUpdate: boolean,
    callback: AsyncCallback<void>
  ): void;

  /**
   * Notify form enable update state.
   * <p>You can use this method to notify form enable update state.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the specified form id.
   * @param { boolean } isEnableUpdate - Indicates whether enable update.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function notifyFormsEnableUpdate(formIds: Array<string>, isEnableUpdate: boolean): Promise<void>;

  /**
   * Share form by formId and deviceId.
   *
   * @permission ohos.permission.REQUIRE_FORM and ohos.permission.DISTRIBUTED_DATASYNC
   * @param { string } formId - Indicates the form ID.
   * @param { string } deviceId - Indicates the remote device ID.
   * @param { AsyncCallback<void> } callback - The callback of shareForm.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function shareForm(formId: string, deviceId: string, callback: AsyncCallback<void>): void;

  /**
   * Share form by formId and deviceId.
   *
   * @permission ohos.permission.REQUIRE_FORM and ohos.permission.DISTRIBUTED_DATASYNC
   * @param { string } formId - Indicates the form ID.
   * @param { string } deviceId - Indicates the remote device ID.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function shareForm(formId: string, deviceId: string): Promise<void>;

  /**
   * Notify form that privacy whether to be protected.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the specified form id.
   * @param { boolean } isProtected - Indicates whether to be protected.
   * @param { AsyncCallback<void> } callback - The callback of notifyFormsPrivacyProtected.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function notifyFormsPrivacyProtected(
    formIds: Array<string>,
    isProtected: boolean,
    callback: AsyncCallback<void>
  ): void;

  /**
   * Notify form that privacy whether to be protected.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the specified form id.
   * @param { boolean } isProtected - Indicates whether to be protected.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 9
   */
  function notifyFormsPrivacyProtected(formIds: Array<string>, isProtected: boolean): Promise<void>;

  /**
   * Acquire form data by formId.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the form ID.
   * @param { AsyncCallback<{ [key: string]: Object }> } callback - The callback of acquireFormData.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - An IPC connection error happened.
   * @throws { BusinessError } 16500060 - A service connection error happened, please try again later.
   * @throws { BusinessError } 16500100 - Failed to obtain the configuration information.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   *                                      invalid input parameter during form operation
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @StageModelOnly
   * @since 10
   */
  /**
   * Acquire form data by formId.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the form ID.
   * @param { AsyncCallback<Record<string, Object>> } callback - The callback of acquireFormData.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16500100 - Failed to obtain the configuration information.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   *                                      invalid input parameter during form operation
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @StageModelOnly
   * @since 11
   */
  function acquireFormData(formId: string, callback: AsyncCallback<Record<string, Object>>): void;

  /**
   * Acquire form data by formId.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the form ID.
   * @returns { Promise<{ [key: string]: Object }> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - An IPC connection error happened.
   * @throws { BusinessError } 16500060 - A service connection error happened, please try again later.
   * @throws { BusinessError } 16500100 - Failed to obtain the configuration information.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   *                                      invalid input parameter during form operation
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @StageModelOnly
   * @since 10
   */
  /**
   * Acquire form data by formId.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the form ID.
   * @returns { Promise<Record<string, Object>> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16500100 - Failed to obtain the configuration information.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   *                                      invalid input parameter during form operation
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @StageModelOnly
   * @since 11
   */
  function acquireFormData(formId: string): Promise<Record<string, Object>>;
  /**
   * Notify the form framework to set a router proxy for the specified cards.
   * <p>Once a card sets up a router proxy, the form framework will no longer invoke its onRouter callback,
   * and FMS will not trigger the actual jump.</p>
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the IDs of the forms that requires setting up a router proxy.
   * @param { Callback<Want> } proxy - Indicates the router proxy to be set up.
   * @param { AsyncCallback<void> } callback - The callback of setRouterProxy.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @since 11
   */
  function setRouterProxy(formIds: Array<string>, proxy: Callback<Want>, callback: AsyncCallback<void>): void;

   /**
    * Notify the form framework to set a router proxy for the specified cards.
    * <p>Once a card sets up a router proxy, the form framework will no longer invoke its onRouter callback,
    * and FMS will not trigger the actual jump.</p>
    *
    * @permission ohos.permission.REQUIRE_FORM
    * @param { Array<string> } formIds - Indicates the IDs of the forms that requires setting up a router proxy.
    * @param { Callback<Want> } proxy - Indicates the router proxy to be set up.
    * @returns { Promise<void> } The promise returned by the function.
    * @throws { BusinessError } 201 - Permissions denied.
    * @throws { BusinessError } 202 - The application is not a system application.
    * @throws { BusinessError } 401 - Parameter error. Possible causes:
    *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
    * @throws { BusinessError } 16500050 - IPC connection error.
    * @throws { BusinessError } 16500060 - Service connection error.
    * @throws { BusinessError } 16501000 - An internal functional error occurred.
    * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
    * @syscap SystemCapability.Ability.Form
    * @systemapi
    * @since 11
    */
  function setRouterProxy(formIds: Array<string>, proxy: Callback<Want>): Promise<void>;

   /**
    * Notify the form framework to clear the router proxy set for the specified cards.
    *
    * @permission ohos.permission.REQUIRE_FORM
    * @param { Array<string> } formIds - Indicates the IDs of the forms that requires clearing of router proxy.
    * @param { AsyncCallback<void> } callback - The callback of clearRouterProxy.
    * @throws { BusinessError } 201 - Permissions denied.
    * @throws { BusinessError } 202 - The application is not a system application.
    * @throws { BusinessError } 401 - Parameter error. Possible causes:
    *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
    * @throws { BusinessError } 16500050 - IPC connection error.
    * @throws { BusinessError } 16500060 - Service connection error.
    * @throws { BusinessError } 16501000 - An internal functional error occurred.
    * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
    * @syscap SystemCapability.Ability.Form
    * @systemapi
    * @since 11
    */
  function clearRouterProxy(formIds: Array<string>, callback: AsyncCallback<void>): void;

   /**
    * Notify the form framework to clear the router proxy set for the specified cards.
    *
    * @permission ohos.permission.REQUIRE_FORM
    * @param { Array<string> } formIds - Indicates the IDs of the forms that requires clearing of router proxy.
    * @returns { Promise<void> } The promise returned by the function.
    * @throws { BusinessError } 201 - Permissions denied.
    * @throws { BusinessError } 202 - The application is not a system application.
    * @throws { BusinessError } 401 - Parameter error. Possible causes:
    *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
    * @throws { BusinessError } 16500050 - IPC connection error.
    * @throws { BusinessError } 16500060 - Service connection error.
    * @throws { BusinessError } 16501000 - An internal functional error occurred.
    * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
    * @syscap SystemCapability.Ability.Form
    * @systemapi
    * @since 11
    */
  function clearRouterProxy(formIds: Array<string>): Promise<void>;

  /**
   * Set result of publish form.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the form id.
   * @param { formInfo.PublishFormResult } result - The result of publish form.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @stagemodelonly
   * @since 12
   */
  function setPublishFormResult(formId: string, result: formInfo.PublishFormResult): void;

  /**
   * Set permanent dynamic ArkTS forms recyclable, they will be recycled when memory is low.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the form id list of permanent dynamic ArkTS forms.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - caller is not system app.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @stagemodelonly
   * @since 11
   */
  function setFormsRecyclable(formIds: Array<string>): Promise<void>;

  /**
   * Set permanent dynamic ArkTS forms recyclable, they will be recycled when memory is low.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the form id list of permanent dynamic ArkTS forms.
   * @param { AsyncCallback<void> } callback - The callback of setFormsRecyclable.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - caller is not system app.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @stagemodelonly
   * @since 11
   */
  function setFormsRecyclable(formIds: Array<string>, callback: AsyncCallback<void>): void;

  /**
   * Recycle permanent dynamic ArkTS forms.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the IDs of the forms to be recycled.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - The application is not a system application.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @stagemodelonly
   * @since 12
   */
  function recycleForms(formIds: Array<string>): Promise<void>;

  /**
   * Recover recycled permanent dynamic ArkTS forms.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the form id list of recycled permanent dynamic ArkTS forms.
   * @returns { Promise<void> } The promise returned by the function.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - caller is not system app.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @stagemodelonly
   * @since 11
   */
  function recoverForms(formIds: Array<string>): Promise<void>;

  /**
   * Recover recycled permanent dynamic ArkTS forms.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { Array<string> } formIds - Indicates the form id list of recycled permanent dynamic ArkTS forms.
   * @param { AsyncCallback<void> } callback - The callback of recoverForms.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - caller is not system app.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @stagemodelonly
   * @since 11
   */
  function recoverForms(formIds: Array<string>, callback: AsyncCallback<void>): void;

  /**
   * Update location of the form.
   *
   * @permission ohos.permission.REQUIRE_FORM
   * @param { string } formId - Indicates the form id.
   * @param { formInfo.FormLocation } location - The location of the form.
   * @throws { BusinessError } 201 - Permissions denied.
   * @throws { BusinessError } 202 - caller is not system app.
   * @throws { BusinessError } 401 - Parameter error. Possible causes:
   *     1.Mandatory parameters are left unspecified; 2.Incorrect parameter types; 3.Parameter verification failed.
   * @throws { BusinessError } 16500050 - IPC connection error.
   * @throws { BusinessError } 16500060 - Service connection error.
   * @throws { BusinessError } 16501000 - An internal functional error occurred.
   * @throws { BusinessError } 16501001 - The ID of the form to be operated does not exist.
   * @throws { BusinessError } 16501003 - The form cannot be operated by the current application.
   * @syscap SystemCapability.Ability.Form
   * @systemapi
   * @stagemodelonly
   * @since 12
   */
  function updateFormLocation(formId: string, location: formInfo.FormLocation): void;
}
export default formHost;
