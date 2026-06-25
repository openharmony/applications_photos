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

#ifndef HMCDIR_H
#define HMCDIR_H

HMC_API BOOL HmcIsDirExist(const STRING &dir);

HMC_API INT32 HmcMakeDir(const STRING &dir);

HMC_API INT32 HmcMakeDirTree(const STRING &dir);

HMC_API INT32 HmcRemoveDir(const STRING &dir);

HMC_API INT32 HmcRemoveDirTree(const STRING &dir);

HMC_API INT32 HmcGetDirContents(const STRING &dir, STRING_LIST &entries);

/**
 * 获取目录最后修改的UTC时间戳
 * @param dir       目录
 * @return          最后修改的UTC时间戳，-1表示获取失败
 */
HMC_API INT64 HmcGetDirLastModifiedTimestamp(const STRING &dir);

HMC_API INT32 HmcGetCanonicalizedPath(const STRING &filePath, STRING &canonicalized);
HMC_API INT32 HmcGetCanonicalizedPath(INT32 fd, STRING &canonicalized);

HMC_API STRING HmcGetPathWithSystemSeparator(STRING filePath);

/**
 * 获取APP应用所在的目录
 * @return STRING
 */
HMC_API STRING HmcGetAppPath();

#endif // HMCDIR_H
