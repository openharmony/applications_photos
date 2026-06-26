/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2023. All rights reserved.
 */
import { hapTasks } from '@ohos/hvigor-ohos-plugin';

// 模块名获取
// const mModule = getHvigorNode(__filename);
// 配置需要进行签名 + 测试的模块
// const config = {
//   hvigor: hvigor,
//   packageConfig: {
//     // 自定义测试包的名称，当前与模块名一致
//     appName: 'photos',
//     // hvigor 命令行参数
//     commandParams: hvigor.getExtraConfig(),
//     // 当前模块对象
//     module: mModule
//   },
//   signConfig: {
//     p7bFilePath: 'signature/PhotosHm.p7b', // p7b签名文件路径,支持全路径或基于新项目文件夹的相对路径
//     keyAlias: 'HmosPhotos' // 可以不填，默认是'HOS Application Provision Debug'
//   }
// }

export default {
  system: hapTasks,
  plugins:[
    // sharePlugin(),
    // dtPipelinePackagePlugin(config)
  ]
}
