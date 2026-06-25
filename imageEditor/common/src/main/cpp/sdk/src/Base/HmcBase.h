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

#ifndef HMCBASE_H
#define HMCBASE_H

///////////////////////////////////////////////////////////////////////////////
// Part-1 依赖的基础数据类型定义
///////////////////////////////////////////////////////////////////////////////
#include "./HmcBaseType.h"

///////////////////////////////////////////////////////////////////////////////
// Part-2 依赖的base头文件
///////////////////////////////////////////////////////////////////////////////
#include "../../include/CompileParam.h"
#include "../../include/MediaCreative/HmcError.h"
#include "../../include/MediaCreative/HmcUid.h"
#include "../../include/MediaCreative/HmcDict.h"
#include "../../include/MediaCreative/HmcConfig.h"
#include "../../include/MediaCreative/HmcConfigName.h"
#include "../../include/ffrt/ffrt.h"
#include "../SecureC/include/securec.h"
#include "../SecureC/include/securectype.h"

#include "./HmcBaseConfigurations.h"
#include "./system/HmcSystem.h"
#include "./file/HmcFile.h"
#include "./file/HmcDir.h"
#include "./string/HmcString.h"
#include "./string/HmcSimpleString.h"
#include "./mutex/HmcMutex.h"
#include "./mutex/HmcMutexGuard.h"
#include "./mutex/HmcEvent.h"
#include "./common/HmcBaseCommon.h"
#include "./common/HmcSingleton.h"
#include "./config/HmcConfigManager.h"
#include "./dictionary/HmcDictionaryValue.h"
#include "./dictionary/HmcDictionary.h"
#include "./thread/HmcThread.h"
#include "./algorithm/HmcBase16.h"
#include "./random/HmcRandomGenerator.h"
#include "./system/ohos/HmcOhos.h"
#include "./log/HmcLog.h"
#include "./log/HmcLogChannel.h"
#include "./log/HmcStdoutLogChannel.h"
#include "./log/HmcOhosHiLogChannel.h"
#include "./log/HmcLocalFileLogChannel.h"
#include "./log/HmcLogManager.h"
#include "./util/HmcTriangle.h"
#include "./util/HmcRectangle.h"
#include "./util/HmcDelayStat.h"
#include "./util/JsonValueUtil.h"
#include "./task/HmcTaskManager.h"

#endif // HMCBASE_H
