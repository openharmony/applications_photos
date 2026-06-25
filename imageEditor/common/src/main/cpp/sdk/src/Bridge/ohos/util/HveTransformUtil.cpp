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

#include "HveTransformUtil.h"
#include "MediaCreative/HmcError.h"

static int g_two = 2;
static double g_minScale = 0.001;

void HveTransformUtil::CalcAssetPositionAfterScale(HmcAssetPoint &assetPosition, HmcRectD cropRect, float scale,
                                                   HmcSize *size, HmcEditor *editor)
{
    float canvasWidth, canvasHeight;
    HmcEditorGetCanvasSize(editor, &canvasWidth, &canvasHeight);
    if (fabs(scale - 1.0) > g_minScale) {
        LOGD("origin asset size:%lf, %lf", size->width, size->height);
        size->width = size->width * scale;
        size->height = size->height * scale;

        // 处理旋转后缩放导致的偏移
        HmcRectD assetPos(assetPosition.x - size->width / g_two, -assetPosition.y - size->height / g_two,
                          assetPosition.x + size->width / g_two, -assetPosition.y + size->height / g_two);
        assetPos.Translate(canvasWidth / g_two, canvasHeight / g_two);
        assetPos.Scale(scale, cropRect.CenterX(), cropRect.CenterY());
        assetPosition.x = assetPos.CenterX() - canvasWidth / g_two;
        assetPosition.y = canvasHeight / g_two - assetPos.CenterY();
    }
}

int HveTransformUtil::setTransformEffectParameter(const HmcUid assetUid, HmcDict *dict)
{
    if (dict == nullptr) {
        LOGE("setTransformEffectParameter, dict is null!");
        return HMC_ERR;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    auto visionAsset = dynamic_cast<HmcVisionAsset *>(asset);
    if (visionAsset == nullptr) {
        LOGE("setTransformEffectParameter, visionAsset is null!");
        return HMC_ERR;
    }

    VECTOR<HmcUid> cropEffectList;
    visionAsset->GetEffectList(cropEffectList, HMC_EFFECT_TRANSFORM);
    if (!cropEffectList.empty()) {
        LOGI("setTransformEffectParameter, transform effect is exist");
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(cropEffectList[0]);
        if (effect != nullptr) {
            effect->SetEffectParameter(dict);
        }
    } else {
        HmcUid effectUid = visionAsset->AddEffect(dict);
        if (HmcUidIsNull(&effectUid)) {
            LOGE("setTransformEffectParameter, effectUid is null!");
            return HMC_ERR;
        }
    }
    return HMC_OK;
}