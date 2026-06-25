/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2023. All rights reserved.
 */

import { harTasks } from '@ohos/hvigor-ohos-plugin';
//
// const mModule = getHvigorNode(__filename);
// const ohosPlugin = hspTasks(mModule);
//
// const onlineSignHapTaskName: string = 'onlineSignHap';
// let curTargetName: string = 'default';
// const mModuleName: string = mModule.getName();
// const projectRootPath: string = process.cwd();
// const signHspName: string = 'PhotoBrowser';
//
// ohosPlugin.getNeedExecTargetServiceList().forEach(targetServices => {
//   // 注册在线签名任务和创建任务依赖
//   const onlineSignTask = mModule.task(() => {
//
//     curTargetName = targetServices.getTargetData().getTargetName();
//
//     // 构建的未签名的hsp的输出根目录
//     const moduleBuildOutputDir = path.resolve(projectRootPath, 'feature', mModuleName, `build/default/outputs/${curTargetName}/`);
//
//     // 未签名的hsp包路径
//     const inputFile = path.resolve(moduleBuildOutputDir, `${mModuleName}-${curTargetName}-unsigned.hsp`);
//     // 签名后的hsp包路径
//     const outputFile = path.resolve(moduleBuildOutputDir, `${signHspName}.hsp`);
//
//     executeOnlineSign(inputFile, outputFile);
//   }, onlineSignHapTaskName).dependsOn(`${curTargetName}@PackageHsp`);
//
//   // 使用在线签名,可以把离线签名任务disable掉
//   if (onlineSignTask.getEnabled()) {
//     mModule.getTaskByName(`${curTargetName}@SignHsp`).setEnabled(false);
//   }
// });
//
// // 将在线签名任务挂接在assembleHap任务上,assembleHap任务是固定的
// mModule.getTaskByName('assembleHsp').dependsOn(onlineSignHapTaskName);
//
// module.exports = {
//   ohos: ohosPlugin,
// }
//
// hvigor.nodesEvaluated(() => {
//   const filePath = path.resolve(projectRootPath, './AppScope/app-lib.json5');
//   const node: HvigorNode = hvigor.getRootNode();
//   const appContext = node.getContext(OhosPluginId.OHOS_APP_PLUGIN) as OhosAppContext;
//   if (hvigor.isCommandEntryTask('assembleHsp')) {
//     fs.readFile(filePath, 'utf8', (err, data) => {
//       if (err) {
//         console.error(err);
//         return;
//       }
//
//       try {
//         const jsonData = JSON.parse(data);
//         const appData = jsonData.app;
//         const appJson5: AppJson.AppOptObj = appContext.getAppJsonOpt();
//         appJson5.app = {
//           'bundleName': 'com.ohos.photobrowser',
//           'bundleType': 'shared',
//           'vendor': 'ohos',
//           'versionCode': appData.versionCode,
//           'versionName': appData.versionName,
//           'icon': '$media:ohos_gallery',
//           'label': '$string:app_name',
//           'distributedNotificationEnabled': true,
//           'minAPIVersion': 9,
//           'targetAPIVersion': 10
//         }
//         appContext.setAppJsonOpt(appJson5);
//       } catch (error) {
//         console.error(error);
//       }
//     });
//
//   }
// });

export default {
  system: harTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins:[]         /* Custom plugin to extend the functionality of Hvigor. */
}