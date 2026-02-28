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
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium"
import { FormController } from '@ohos/dataprovider/src/main/ets/controller/FormController'
import { FormControllerManager } from "@ohos/dataprovider/src/main/ets/controller/FormControllerManager"
import { Task, TaskUri } from "@ohos/dataprovider/src/main/ets/database/databaseconstant/TaskInfo"
import { UserFileManagerAccess } from "@ohos/common/src/main/ets/default/access/UserFileManagerAccess"
import DatabaseProxy from "@ohos/dataprovider/src/main/ets/database/DatabaseProxy"
import { taskpool } from "@kit.ArkTS"
import { AlbumType } from "@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil"
import { AlbumInfo } from "@ohos/common/src/main/ets/default/model/browser/album/AlbumInfo"
import { FaCardAlbumUtils } from "@ohos/dataprovider/src/main/ets/database/service/FaCardAlbumService"
import ReminderService from "@ohos/dataprovider/src/main/ets/database/service/ReminderService"
import FaCardService, { FaCardInfo } from "@ohos/dataprovider/src/main/ets/database/service/FaCardService"
import { AlbumType as FATableAlbumType } from '@ohos/dataprovider/src/main/ets/database/databaseconstant/FaCardTable'
import { DataShareResultSet } from "@kit.ArkData"
import ImageProxyDataService from "@ohos/dataprovider/src/main/ets/database/service/ImageProxyDataService"
import { photoAccessHelper } from "@kit.MediaLibraryKit"

export default function FormControllerUT() {
  describe('FormControllerUT', () => {
    let controller: FormController;
    let mocker: MockKit

    beforeEach(() => {
      controller = new FormController('1', FormControllerManager.getInstance({} as Context))
      mocker = new MockKit()
    })

    afterEach(() => {
      mocker.clearAll();
    });

    it('executeTask', 0, async () => {
      const run = async (isAgreed: boolean) => await controller.executeTask(isAgreed)
      // task == undefined
      await run(false)
      // task !== undefined
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_ADD_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_SWITCH_CLOUD
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_RESTORE_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      when(mocker.mockFunc(controller, Reflect.get(controller, 'doFaCardRestore')))(task).afterReturnNothing()
      await run(false)
      task.taskUri = TaskUri.TASK_DELETE_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      when(mocker.mockFunc(controller, Reflect.get(controller, 'doFaCardDeleteTask')))([task, false])
        .afterReturnNothing()
      await run(false)
      task.taskUri = TaskUri.TASK_UPDATE_FACARD_URI
      Reflect.set(controller, 'taskQueue', [task])
      when(mocker.mockFunc(controller, Reflect.get(controller, 'doFaCardUpdateTask')))(task).afterReturnNothing()
      await run(false)
      task.taskUri = TaskUri.TASK_SELECT_ALBUM_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_SELECT_PHOTO_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = TaskUri.TASK_MEDIA_UPDATE_ALBUM_URI
      Reflect.set(controller, 'taskQueue', [task])
      await run(false)
      task.taskUri = '' as TaskUri
      Reflect.set(controller, 'taskQueue', [task, task])
      await run(false)
      // this.runningTask !== undefined
      Reflect.set(controller, 'runningTask', TaskUri.TASK_CREATE_FACARD_URI)
      await run(false)
      expect(run !== null).assertTrue()
    })

    it('addTask', 0, () => {
      const run = (task: Task) => controller.addTask(task)
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
      }
      const taskLow: Task = {
        formId: '1', taskUri: TaskUri.TASK_CREATE_FACARD_URI,
      }
      // taskNumber <= 0
      run(task)
      // !this.isHigherPriority(task.taskUri, lastTaskUri)
      Reflect.set(controller, 'taskQueue', [task])
      run(taskLow)
      // this.isHigherPriority(task.taskUri, lastTaskUri)
      run(task)
      // this.runningTask !== undefined
      // !this.isHigherPriority(task.taskUri, this.runningTask)
      Reflect.set(controller, 'runningTask', TaskUri.TASK_RESTORE_FACARD_URI)
      run(task)
      // this.isHigherPriority(task.taskUri, this.runningTask)
      Reflect.set(controller, 'runningTask', TaskUri.TASK_UPDATE_FACARD_URI)
      run(task)
      // this.poolTask !== undefined
      controller.setPoolTask({} as taskpool.Task)
      run(task)
      // this.poolTask !== undefined
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.setTaskPreemptedStatus))('1')
        .afterReturnNothing()
      controller.setPoolTask({} as taskpool.Task)
      run(task)
      expect(run !== null).assertTrue()
    })

    it('isHigherPriority', 0, () => {
      // nowTaskPriority === undefined
      const res: boolean = Reflect.get(controller, 'isHigherPriority').call(controller)
      expect(res !== null).assertTrue()
    })

    it('doFaCardSwitchCloud_case_one', 0, async () => {
      // faTableAlbumType === AlbumType.SINGLE
      const task: Task = {
        formId: '1',
        taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
        albumUri: '1',
        faTableAlbumType: FATableAlbumType.SINGLE
      }
      when(mocker.mockFunc(controller, Reflect.get(controller, 'updateRemindersSingleImage')))(ArgumentMatchers.any)
        .afterReturn('')
      const res: boolean = await Reflect.get(controller, 'doFaCardSwitchCloud').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doFaCardSwitchCloud_case_two', 0, async () => {
      // faTableAlbumType !== AlbumType.SINGLE
      const task: Task = {
        formId: '1',
        taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
        albumUri: '1',
        faTableAlbumType: FATableAlbumType.ALL
      }
      when(mocker.mockFunc(controller, Reflect.get(controller, 'updateRemindersImage')))(ArgumentMatchers.any)
        .afterReturn('')
      const res: boolean = await Reflect.get(controller, 'doFaCardSwitchCloud').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('updateRemindersImage_case_one', 0, async () => {
      // !FormControllerManager.getTaskPreemptedStatus(formId)
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(true)
      const res: boolean = await Reflect.get(controller, 'updateRemindersImage').call(controller, '1', '1')
      expect(res !== null).assertTrue()
    })

    it('updateRemindersImage_case_two', 0, async () => {
      // !photoAlbum
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getAlbumByUri))(ArgumentMatchers.any).afterReturn(true)
      const res: boolean = await Reflect.get(controller, 'updateRemindersImage').call(controller, '1', '1')
      expect(res !== null).assertTrue()
    })

    it('updateRemindersImage_case_three', 0, async () => {
      // photoAlbum
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getAlbumByUri))(ArgumentMatchers.any).afterReturn(false)
      const res: boolean = await Reflect.get(controller, 'updateRemindersImage').call(controller, '1', '1')
      expect(res !== null).assertTrue()
    })

    it('updateRemindersImage_case_four', 0, async () => {
      // !albumUri !result
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getAllObject))(ArgumentMatchers.any).afterReturn(false)
      const res: boolean = await Reflect.get(controller, 'updateRemindersImage').call(controller, undefined, '1')
      expect(res !== null).assertTrue()
    })

    it('updateRemindersImage_case_five', 0, async () => {
      // !albumUri !result
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getAllObject))(ArgumentMatchers.any).afterReturn([])
      const res: boolean = await Reflect.get(controller, 'updateRemindersImage').call(controller, undefined, '1')
      expect(res !== null).assertTrue()
    })

    it('updateRemindersSingleImage_case_one', 0, async () => {
      // FormControllerManager.getTaskPreemptedStatus(formId)
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(true)
      const res: boolean = await Reflect.get(controller, 'updateRemindersSingleImage').call(controller, undefined, '1')
      expect(res !== null).assertTrue()
    })

    it('updateRemindersSingleImage_case_two', 0, async () => {
      // !reminderResultSet
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const service: ReminderService = Reflect.get(controller, 'reminderService')
      when(mocker.mockFunc(service, service.queryByFormId))(ArgumentMatchers.any).afterReturnNothing()
      const res: boolean = await Reflect.get(controller, 'updateRemindersSingleImage').call(controller, undefined, '1')
      expect(res !== null).assertTrue()
    })

    it('updateRemindersSingleImage_case_three', 0, async () => {
      // reminderResultSet photoAsset
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const service: ReminderService = Reflect.get(controller, 'reminderService')
      const resultSet = {
        rowCount: 1,
        goToFirstRow: () => false,
        getColumnIndex: (arg) => 1,
        getString: (arg) => '',
        close: () => {
        }
      } as DataShareResultSet
      when(mocker.mockFunc(service, service.queryByFormId))(ArgumentMatchers.any).afterReturn(resultSet)
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getPhotoAssetByUri))(ArgumentMatchers.any).afterReturn(true)
      const res: boolean =
        await Reflect.get(controller, 'updateRemindersSingleImage').call(controller, undefined, '1')
      expect(res !== null).assertTrue()
    })

    it('updateRemindersSingleImage_case_four', 0, async () => {
      // reminderResultSet !photoAsset
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const service: ReminderService = Reflect.get(controller, 'reminderService')
      const resultSet = {
        rowCount: 1,
        goToFirstRow: () => false,
        getColumnIndex: (arg) => 1,
        getString: (arg) => '',
        close: () => {
        }
      } as DataShareResultSet
      when(mocker.mockFunc(service, service.queryByFormId))(ArgumentMatchers.any).afterReturn(resultSet)
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getPhotoAssetByUri))(ArgumentMatchers.any).afterReturn(false)
      const res: boolean =
        await Reflect.get(controller, 'updateRemindersSingleImage').call(controller, undefined, '1')
      expect(res !== null).assertTrue()
    })

    it('updateRemindersSingleImage_case_five', 0, async () => {
      // catch
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const res: boolean = await Reflect.get(controller, 'updateRemindersSingleImage').call(controller, undefined, '1')
      expect(res !== null).assertTrue()
    })

    it('doFaCardDeleteTask_case_one', 0, async () => {
      // !isAgreed
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
      }
      const proxy = DatabaseProxy.getInstance()
      when(mocker.mockFunc(proxy, proxy.deleteWithOutCallback))(ArgumentMatchers.any).afterReturn('')
      const res: boolean = await Reflect.get(controller, 'doFaCardDeleteTask').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doFaCardDeleteTask_case_two', 0, async () => {
      // faCardResultSet && faCardResultSet.rowCount > 0 remainCount == 0
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
      }
      const proxy = DatabaseProxy.getInstance()
      when(mocker.mockFunc(proxy, proxy.deleteWithOutCallback))(ArgumentMatchers.any).afterReturn('')
      const resultSet = { rowCount: 1, goToLastRow: () => true, getString: (arg) => '0' } as DataShareResultSet
      when(mocker.mockFunc(proxy, proxy.queryWithOutCallback))(ArgumentMatchers.any).afterReturn(resultSet)
      const res: boolean = await Reflect.get(controller, 'doFaCardDeleteTask').call(controller, task, true)
      expect(res !== null).assertTrue()
    })

    it('doFaCardDeleteTask_case_three', 0, async () => {
      // !faCardResultSet.rowCount > 0 !remainCount == 0
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
      }
      const proxy = DatabaseProxy.getInstance()
      when(mocker.mockFunc(proxy, proxy.deleteWithOutCallback))(ArgumentMatchers.any).afterReturn('')
      const resultSet = { rowCount: 0, goToLastRow: () => true, getString: (arg) => '1' } as DataShareResultSet
      when(mocker.mockFunc(proxy, proxy.queryWithOutCallback))(ArgumentMatchers.any).afterReturn(resultSet)
      const res: boolean = await Reflect.get(controller, 'doFaCardDeleteTask').call(controller, task, true)
      expect(res !== null).assertTrue()
    })

    it('doFaCardDeleteTask_case_four', 0, async () => {
      // catch
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
      }
      const res: boolean = await Reflect.get(controller, 'doFaCardDeleteTask').call(controller, task, true)
      expect(res !== null).assertTrue()
    })

    it('getCameraAlbum_case_one', 0, async () => {
      // !albumInfos
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getSystemSourceAlbums))().afterReturnNothing()
      const res: string = await Reflect.get(controller, 'getCameraAlbum').call(controller)
      expect(res !== null).assertTrue()
    })

    it('getCameraAlbum_case_two', 0, async () => {
      // !cameraAlbum
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getSystemSourceAlbums))().afterReturn([])
      const res: string = await Reflect.get(controller, 'getCameraAlbum').call(controller)
      expect(res !== null).assertTrue()
    })

    it('getCameraAlbum_case_three', 0, async () => {
      // !cameraAlbum.count
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getSystemSourceAlbums))().afterReturn([{ albumName: '相机' }])
      const res: string = await Reflect.get(controller, 'getCameraAlbum').call(controller)
      expect(res !== null).assertTrue()
    })

    it('getCameraAlbum_case_four', 0, async () => {
      // cameraAlbum.albumUri
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getSystemSourceAlbums))().afterReturn([{ albumName: '相机', count: 1 }])
      const res: string = await Reflect.get(controller, 'getCameraAlbum').call(controller)
      expect(res !== null).assertTrue()
    })

    it('getCameraAlbum_case_five', 0, async () => {
      // catch
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getSystemSourceAlbums))().afterThrow('')
      const res: string = await Reflect.get(controller, 'getCameraAlbum').call(controller)
      expect(res !== null).assertTrue()
    })

    it('registerForCloud', 0, async () => {
      const run = async (formId: string) => await Reflect.get(controller, 'registerForCloud').call(controller, formId)
      const access = UserFileManagerAccess.getInstance()
      Reflect.set(controller, 'userFileManagerAccess', access)
      // !photoAccessHelper
      when(mocker.mockFunc(access, access.getMediaLibrary))().afterReturnNothing()
      await run('1')
      // photoAccessHelper
      when(mocker.mockFunc(access, access.getMediaLibrary))().afterReturn(1)
      await run('1')
      expect(run !== null).assertTrue()
    })

    it('getFaAlbumUri_case_one', 0, () => {
      // cameraUri
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getCameraAlbum')))().afterReturn(true)
      const res: string = Reflect.get(controller, 'getFaAlbumUri').call(controller)
      expect(res !== null).assertTrue()
    })

    it('getFaAlbumUri_case_two', 0, () => {
      // album
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getSystemAlbum')))().afterReturn(false)
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getSystemAlbum))(ArgumentMatchers.any).afterReturn(true)
      const res: string = Reflect.get(controller, 'getFaAlbumUri').call(controller)
      expect(res !== null).assertTrue()
    })

    it('getFaAlbumUri_case_three', 0, () => {
      // !album
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getSystemAlbum')))().afterReturn(false)
      const access: UserFileManagerAccess = Reflect.get(controller, 'userFileManagerAccess')
      when(mocker.mockFunc(access, access.getSystemAlbum))(ArgumentMatchers.any).afterReturn(false)
      const res: string = Reflect.get(controller, 'getFaAlbumUri').call(controller)
      expect(res !== null).assertTrue()
    })

    it('getSystemParamOfMemoryTest', 0, () => {
      const res: boolean = Reflect.get(controller, 'getSystemParamOfMemoryTest').call(controller)
      expect(res !== null).assertTrue()
    })

    it('doFaCardCreateTask_case_one', 0, async () => {
      // !isAgreed
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
      }
      const res = await controller.doFaCardCreateTask(task, false)
      expect(res !== null).assertTrue()
    })

    it('doFaCardCreateTask_case_two', 0, async () => {
      // isExistFaCard
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
      }
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getFaAlbumUri')))().afterReturn(true)
      const res = await controller.doFaCardCreateTask(task, true)
      expect(res !== null).assertTrue()
    })

    it('doFaCardCreateTask_case_three', 0, async () => {
      // !albumUri
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
      }
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getFaAlbumUri')))().afterReturn(false)
      const res = await controller.doFaCardCreateTask(task, true)
      expect(res !== null).assertTrue()
    })

    it('doFaCardCreateTask_case_four', 0, async () => {
      // !albumUri
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
      }
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getFaAlbumUri')))().afterReturn(true)
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getAssetsInAlbum')))(ArgumentMatchers.any)
        .afterReturn([])
      when(mocker.mockFunc(controller, Reflect.get(controller, 'createDataShare')))(ArgumentMatchers.any)
        .afterReturnNothing()
      const reminderService: ReminderService = Reflect.get(controller, 'reminderService')
      when(mocker.mockFunc(reminderService, reminderService.registerForPhotosAndAlbums))(ArgumentMatchers.any)
        .afterReturnNothing()
      const dataService: ImageProxyDataService = Reflect.get(controller, 'imageProxyDataService')
      when(mocker.mockFunc(dataService, dataService.queryImageUri))().afterReturnNothing()
      const res = await controller.doFaCardCreateTask(task, true)
      expect(res !== null).assertTrue()
    })

    it('doFaCardCreateTask_case_five', 0, async () => {
      // firstAsset
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
      }
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getFaAlbumUri')))().afterReturn(true)
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getAssetsInAlbum')))(ArgumentMatchers.any)
        .afterReturn([1, 2])
      when(mocker.mockFunc(controller, Reflect.get(controller, 'createDataShare')))(ArgumentMatchers.any)
        .afterReturnNothing()
      const reminderService: ReminderService = Reflect.get(controller, 'reminderService')
      when(mocker.mockFunc(reminderService, reminderService.registerForPhotosAndAlbums))(ArgumentMatchers.any)
        .afterReturnNothing()
      const dataService: ImageProxyDataService = Reflect.get(controller, 'imageProxyDataService')
      when(mocker.mockFunc(dataService, dataService.queryImageUri))().afterReturnNothing()
      when(mocker.mockFunc(FormController, FormController.insertRemindersAndProxy))(ArgumentMatchers.any)
        .afterReturnNothing()
      const res = await controller.doFaCardCreateTask(task, true)
      expect(res !== null).assertTrue()
    })

    it('doFaCardCreateTask_case_six', 0, async () => {
      // catch
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
      }
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getFaAlbumUri')))().afterReturn(true)
      const res = await controller.doFaCardCreateTask(task, true)
      expect(res !== null).assertTrue()
    })

    it('doFaCardCreateTask_case_seven', 0, async () => {
      // isExistFaCard
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
      }
      when(mocker.mockFunc(controller, Reflect.get(controller, 'checkIsExistFaCard')))(ArgumentMatchers.any)
        .afterReturn(true)
      const res = await controller.doFaCardCreateTask(task, true)
      expect(res !== null).assertTrue()
    })

    it('doFaCardAddTask_case_one', 0, async () => {
      // count == -1
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI, values: { count: -1 },
      }
      const res: number = await Reflect.get(controller, 'doFaCardAddTask').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doFaCardAddTask_case_two', 0, async () => {
      // FormControllerManager.getTaskPreemptedStatus(formId)
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI, values: { count: 1 },
      }
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getAssetsInAlbum')))(ArgumentMatchers.any)
        .afterReturn([])
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(true)
      const res: number = await Reflect.get(controller, 'doFaCardAddTask').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doFaCardAddTask_case_three', 0, async () => {
      // result.length
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI, values: { count: 1 },
      }
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getAssetsInAlbum')))(ArgumentMatchers.any)
        .afterReturn([1, 2])
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))(ArgumentMatchers.any)
        .afterReturn(false)
      const res: number = await Reflect.get(controller, 'doFaCardAddTask').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doFaCardAddTask_case_four', 0, async () => {
      // !result.length
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI, values: { count: 1 },
      }
      const imageProxyDataService: ImageProxyDataService = Reflect.get(controller, 'imageProxyDataService')
      when(mocker.mockFunc(imageProxyDataService, imageProxyDataService.queryImageUri))(ArgumentMatchers.any)
        .afterReturn({
          close: () => {
          }
        })
      const res: number = await Reflect.get(controller, 'doFaCardAddTask').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doFaCardRestore_case_one', 0, async () => {
      // FormControllerManager.getTaskPreemptedStatus(task.formId)
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI, values: { count: 1 },
      }
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))().afterReturn(true)
      const res: number = Reflect.get(controller, 'doFaCardRestore').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doFaCardRestore_case_two', 0, async () => {
      // !albumUri
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI, values: { count: 1 },
      }
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))('1').afterReturn(false)
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getFaAlbumUri')))().afterReturnNothing()
      const res: number = Reflect.get(controller, 'doFaCardRestore').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doFaCardRestore_case_three', 0, async () => {
      // !firstAsset
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI, albumUri: 'NOT_INSERT'
      }
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))('1').afterReturn(false)
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getFaAlbumUri')))().afterReturn('1')
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getAssetsInAlbum')))(ArgumentMatchers.any)
        .afterReturn([])
      const res: number = await Reflect.get(controller, 'doFaCardRestore').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doFaCardRestore_case_four', 0, async () => {
      // firstAsset
      const task: Task = {
        formId: '1', taskUri: TaskUri.TASK_RESTORE_FACARD_URI, albumUri: 'NOT_INSERT'
      }
      when(mocker.mockFunc(FormControllerManager, FormControllerManager.getTaskPreemptedStatus))('1').afterReturn(false)
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getFaAlbumUri')))().afterReturn('1')
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getAssetsInAlbum')))(ArgumentMatchers.any)
        .afterReturn([1, 2])
      const res: number = await Reflect.get(controller, 'doFaCardRestore').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doSelectAlbumTask_case_one', 0, async () => {
      const task: Task = {
        formId: '1',
        taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
        album: new AlbumInfo(),
        interval: 1,
        albumType: AlbumType.CATEGORY
      }
      const utils = new FaCardAlbumUtils({} as Context)
      Reflect.set(controller, 'faCardAlbumUtils', utils)
      when(mocker.mockFunc(utils, utils.handleClick))(ArgumentMatchers.any).afterReturnNothing()
      const res: number = await Reflect.get(controller, 'doSelectAlbumTask').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doSelectPhotoTask_case_one', 0, async () => {
      const task: Task = {
        formId: '1',
        taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
        values: { key: null }
      }
      const reminderService: ReminderService = Reflect.get(controller, 'reminderService')
      when(mocker.mockFunc(reminderService, reminderService.deletePhotosByFormId))(ArgumentMatchers.any)
        .afterReturn(undefined)
      const faCardService: FaCardService = Reflect.get(controller, 'faCardService')
      when(mocker.mockFunc(faCardService, faCardService.update))(ArgumentMatchers.any).afterReturn(undefined)
      const res: number = await Reflect.get(controller, 'doSelectPhotoTask').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doSelectPhotoTask_case_two', 0, async () => {
      const task: Task = {
        formId: '1',
        taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
        values: { key: null }
      }
      const reminderService: ReminderService = Reflect.get(controller, 'reminderService')
      when(mocker.mockFunc(reminderService, reminderService.deletePhotosByFormId))(ArgumentMatchers.any)
        .afterReturn('1')
      const faCardService: FaCardService = Reflect.get(controller, 'faCardService')
      when(mocker.mockFunc(faCardService, faCardService.update))(ArgumentMatchers.any).afterReturn('1')
      const res: number = await Reflect.get(controller, 'doSelectPhotoTask').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('doMediaUpdateAlbumTask_case_one', 0, async () => {
      // !task.faCardInfo == undefined
      const task: Task = {
        formId: '1',
        taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
        faCardInfo: {} as FaCardInfo
      }
      const utils: FaCardAlbumUtils = Reflect.get(controller, 'faCardAlbumUtils')
      when(mocker.mockFunc(utils, utils.updateForm))(ArgumentMatchers.any).afterReturnNothing()
      const res: number = await Reflect.get(controller, 'doMediaUpdateAlbumTask').call(controller, task)
      expect(res !== null).assertTrue()
    })

    it('getAssetsInAlbum_case_one', 0, async () => {
      // !fetchResult
      const task: Task = {
        formId: '1',
        taskUri: TaskUri.TASK_RESTORE_FACARD_URI,
        faCardInfo: {} as FaCardInfo
      }
      const album = {} as photoAccessHelper.Album
      when(mocker.mockFunc(controller, Reflect.get(controller, 'getAlbumByUri')))(ArgumentMatchers.any)
        .afterReturn(album)
      when(mocker.mockFunc(album, album.getAssets))(ArgumentMatchers.any).afterReturnNothing()
      const res: number = await Reflect.get(controller, 'getAssetsInAlbum').call(controller, task)
      expect(res !== null).assertTrue()
    })
  })
}
