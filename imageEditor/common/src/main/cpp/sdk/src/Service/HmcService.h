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

#ifndef HMCSERVICE_H
#define HMCSERVICE_H

#include "../Engine/HmcEngine.h"
#include "HmcServiceDefaultValue.h"
#include "./DefaultValue/HmcDefaultValueManager.h"

#include "./Editor/HmcEventHandler.h"
#include "./Editor/HmcUidAdmin.h"

#include "./Effect/Utils/HmcEffectUtils.h"
#include "./Effect/HmcEffect.h"
#include "./Effect/HmcEffectAdjust.h"
#include "./Effect/HmcEffectTransform.h"

#include "./Asset/HmcAsset.h"

#include "./Asset/HmcVisionAsset.h"
#include "./Asset/HmcImageAsset.h"
#include "./Asset/Utils/HmcAssetUtils.h"
#include "./Asset/Utils/HmcTimeUtil.h"

#include "./Lane/HmcLane.h"
#include "./Lane/HmcLaneManager.h"

#include "./Editor/Export/HmcEncoderManager.h"
#include "./Editor/HmcStateMachine.h"
#include "./Editor/HmcEditorImp.h"
#include "./Editor/HmcEditorSetterGuard.h"

#include "./Project/HmcProjectSerializeKey.h"
#include "./Project/HmcProjectEntity.h"

#include "./Material/HmcMaterialManager.h"

#endif // HMCSERVICE_H
