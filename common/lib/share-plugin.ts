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
// @ts-ignore
import type { HvigorPlugin, HvigorPluginTask, HvigorTaskContext } from '@ohos/hvigor';

declare const require: any;

const path = require('path');
const fs = require('fs');
const json5 = require('json5');

/**
 *  可以参考下压缩包中的demo1来写，之后插件运行的时候可以获取到moduleName和path,
 *  根据path拼接出来在打包hap之前的module.json,之后按照json的格式去操作文件，并且更新这个文件
 *  moduleName：sharelibrary
 *  modulePath：D:\PJT\AppShareProvider\sharelibrary
 */
export function sharePlugin(): HvigorPlugin {
  return {
    //必须的配置，插件的id
    pluginId: 'sharePluginId',
    //必须的配置，hvigor生命周期中调用这个函数方法
    apply(pluginContext: HvigorPluginTask): void {
      const hapContext = pluginContext.getContext('com.ohos.hap');

      const moduleName = hapContext.getModuleName();

      hapContext.targets(target => {
        const targetName = target.getTargetName();
        // 注册任务
        pluginContext.registerTask({
          // 任务名称
          name: `${targetName}sharePluginTask`,
          // 任务执行体
          run: (taskContext: HvigorTaskContext) => {
            updateModuleConfig(taskContext.moduleName, taskContext.modulePath, targetName);
          },
          // 任务前置依赖，先执行default@CompileArkTS，再执行sharePluginTask
          dependencies: [`${targetName}@CompileArkTS`],
          // 任务后置依赖，先执行sharePluginTask，再执行default@PackageHsp
          postDependencies: [`${targetName}@PackageHap`]
        });
      });

    }
  };
}

function updateModuleConfig(moduleName, modulePath, targetName): void {
  let sharedInfos = getSharedInfos(modulePath);
  updateSharedInfo(modulePath, sharedInfos, targetName);
}

function getSharedInfos(modulePath): Array<object> {
  let sharedInfos = [];
  // 本地包总目录
  let moduleFilePath = path.resolve(modulePath, 'oh_modules');
  const moduleFileNames = fs.readdirSync(moduleFilePath);
  moduleFileNames.forEach((moduleFileName) => {
    if (moduleFileName && !moduleFileName.startsWith('.')) {
      if (moduleFileName.startsWith('@')) {
        // 远程仓库或本地应用内共享库
        let cloudModuleFilePath = path.resolve(modulePath, `oh_modules/${moduleFileName}`);
        const cloudModuleFileNames = fs.readdirSync(cloudModuleFilePath);
        cloudModuleFileNames.forEach((cloudModuleFileName) => {
          let srcPath = path.resolve(cloudModuleFilePath, `${cloudModuleFileName}/src/main/module.json`);
          if (!checkFileExists(srcPath)) {
            srcPath = path.resolve(cloudModuleFilePath, `${cloudModuleFileName}/src/main/module.json5`);
          }
          if (checkFileExists(srcPath)) {
            let srcData = fs.readFileSync(srcPath);
            let srcModuleJson = json5.parse(srcData);

            let srcBundleName = srcModuleJson?.app?.bundleName ?? '';
            let srcVersionCode = srcModuleJson?.app?.versionCode ?? 0;
            let srcModuleName = srcModuleJson?.module?.name ?? '';
            let srcModuleType = srcModuleJson?.module?.type ?? '';
            if (srcModuleType === 'shared' && srcBundleName && srcVersionCode !== 0 && srcModuleName) {
              let shareInfo = {
                'bundleName': srcBundleName,
                'moduleName': srcModuleName,
                'versionCode': srcVersionCode
              };
              sharedInfos.push(shareInfo);
            } else if (srcModuleType === 'shared' && !srcBundleName && srcVersionCode === 0 && srcModuleName) {
              let shareInfo = {
                'moduleName': srcModuleName,
              };
              sharedInfos.push(shareInfo);
            }
          }
        });
      } else {
        // 本地仓库
        let srcPath = path.resolve(moduleFilePath, `${moduleFileName}/src/main/module.json`);
        if (checkFileExists(srcPath)) {
          let srcData = fs.readFileSync(srcPath);
          let srcModuleJson = JSON.parse(srcData);
          let srcBundleName = srcModuleJson?.app?.bundleName ?? '';
          let srcVersionCode = srcModuleJson?.app?.versionCode ?? 0;
          let srcModuleName = srcModuleJson?.module?.name ?? '';
          let srcModuleType = srcModuleJson?.module?.type ?? '';
          if (srcModuleType === 'shared' && srcBundleName && srcVersionCode !== 0 && srcModuleName) {
            let shareInfo = {
              'bundleName': srcBundleName,
              'moduleName': srcModuleName,
              'versionCode': srcVersionCode
            };
            sharedInfos.push(shareInfo);
          }
        }
      }
    }
  });
  return sharedInfos;
}

function updateSharedInfo(modulePath, dependenciesSrc, targetName): void {
  let buildFilePath = path.resolve(modulePath, 'build');
  if (checkFileExists(buildFilePath)) {
    const buildFileNames = fs.readdirSync(buildFilePath);
    buildFileNames.forEach((productName) => {
      let filePath = path.resolve(buildFilePath, `${productName}/intermediates/res/${targetName}/module.json`);
      if (checkFileExists(filePath)) {
        let rawData = fs.readFileSync(filePath);
        let moduleJson = JSON.parse(rawData);
        moduleJson.module.dependencies = dependenciesSrc;
        let data = JSON.stringify(moduleJson, null, 2);
        fs.writeFileSync(filePath, data);
      }
    });
  }
}

function checkFileExists(filePath: string): boolean {
  try {
    fs.accessSync(filePath, fs.constants.F_OK);
    return true;
  } catch (err) {
    return false;
  }
}