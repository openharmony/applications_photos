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
#include "MediaCreative.h"
#include "HmcService.h"

static char uidStr[HMC_UID_STR_LEN] = {0};

static HmcEffect *CheckEffectPara(HmcEditor *editor, HmcUid effectUid, int &result)
{
    if (editor == nullptr) {
        LOGE("Invalid editor.");
        result = HMC_ERR_PARAM;
        return nullptr;
    }

    HmcEffect *effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
    if (effect == nullptr) {
        LOGE("get effect by effect uid failed, please check you effect uid");
        result = HMC_ERR;
        return nullptr;
    }

    return effect;
}

static inline VOID PreviewStateControl(HmcEditor *editor)
{
    auto editorImp = static_cast<HmcEditorImp *>(editor);
    if (editorImp != nullptr && editorImp->GetLastState() == HMC_EDITOR_STATE_PLAY) {
        HMC_EDITOR_SETTER(editor, false);
    } else {
        HMC_EDITOR_SETTER(editor);
    }
}

int HmcEffectAdd(HmcEditor *editor, HmcUid assetUid, HmcDict *dict, HmcUid *poutEffectUid)
{
    INT32 type;
    HmcDictGetInt32(dict, DICT_KEY_EFFECT_TYPE, &type);
    HMC_EDITOR_SETTER(editor, type != HMC_EFFECT_COMPOSE ? false : true);

    if (!editor || !dict || !poutEffectUid) {
        LOGE("invalid parameter.");
        return HMC_ERR_PARAM;
    }

    char uidStr[HMC_UID_STR_LEN] = {0};
    LOGD("add effect to asset: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not version type, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    HmcUid effectUid = ((HmcVisionAsset *)asset)->AddEffect(dict);
    if (HmcUidIsNull(&effectUid)) {
        return HMC_ERR;
    }
    *poutEffectUid = effectUid;

    return HMC_OK;
}

int64_t HmcEffectGetDuration(HmcEditor *editor, HmcUid effectUid)
{
    HMC_UNUSED(editor);

    HmcEffect *effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
    if (!effect) {
        LOGE("effect is invalid, please check your effect id");
        return 0;
    }

    LOGD("Effect duration: %d", effect->GetDuration());

    return effect->GetDuration();
}

int64_t HmcEffectGetStartTime(HmcEditor *editor, HmcUid effectUid)
{
    HMC_UNUSED(editor);

    HmcEffect *effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
    if (!effect) {
        LOGE("effect is invalid, please check your effect id");
        return 0;
    }

    LOGD("Effect duration: %d", effect->GetStartTime());

    return effect->GetStartTime();
}

unsigned int HmcEffectGetEffectCount(HmcEditor *editor, HmcUid assetUid, HmcEffectType type)
{
    HMC_UNUSED(editor);

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return 0;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not an vision asset entity, please check your asset id");
        return 0;
    }

    return ((HmcVisionAsset *)asset)->GetEffectCount(type);
}

int HmcEffectGetEffects(HmcEditor *editor, HmcUid assetUid, HmcEffectType type, HmcUid *effectBuffer,
    unsigned int count)
{
    HMC_UNUSED(editor);
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return HMC_ERR_PARAM;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not an vision asset entity, please check your asset id");
        return HMC_ERR;
    }

    unsigned int realCount = ((HmcVisionAsset *)asset)->GetEffectCount(type);
    if (count < realCount) {
        LOGE("buffer is not enough");
        return HMC_ERR_PARAM;
    }

    std::vector<HmcUid> effectList;
    ((HmcVisionAsset *)asset)->GetEffectList(effectList, type);

    int index = 0;
    for (const auto &effectUid : effectList) {
        HmcUidCopy(effectBuffer + index, &effectUid);
        index++;
    }

    return HMC_OK;
}

char *HmcEffectGetMaterialCloudId(HmcEditor *editor, HmcUid effectUid)
{
    HMC_UNUSED(editor);

    auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
    if (effect == nullptr) {
        LOGE("get effect by effect uid failed, please check you effect uid");
        return nullptr;
    }

    return HmcStrDup(effect->GetMaterialCloudId().c_str());
}

int HmcEffectAdvance(HmcEditor *editor, HmcUid effectUid, int distance)
{
    HMC_EDITOR_SETTER(editor);

    auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
    if (!effect) {
        LOGE("effect is invalid, please check your effect id");
        return HMC_ERR_PARAM;
    }

    HmcUid assetUid = effect->GetAssetUid();

    auto asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not an asset entity, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    if (((HmcVisionAsset *)asset)->AdvanceEffect(effectUid, distance) == FALSE) {
        return HMC_ERR;
    }

    return HMC_OK;
}

int HmcEffectSetProperty(HmcEditor *editor, HmcUid effectUid, HmcDict *dict)
{
    HMC_EDITOR_SETTER(editor);

    if (dict == nullptr) {
        LOGE("invalid parameter, dict is nullptr");
        return HMC_ERR_PARAM;
    }

    HmcEffect *effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
    if (effect == nullptr) {
        LOGE("get effect by effect uid failed, please check you effect uid");
        return HMC_ERR;
    }

    effect->SetEffectParameter(dict);

    return HMC_OK;
}

int HmcEffectGetProperty(HmcEditor *editor, HmcUid effectUid, HmcDict *dict)
{
    HMC_UNUSED(editor);
    if (dict == nullptr) {
        LOGE("invalid parameter, dict is nullptr");
        return HMC_ERR_PARAM;
    }

    HmcEffect *effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
    if (effect == nullptr) {
        LOGE("get effect by effect uid failed, please check you effect uid");
        return HMC_ERR;
    }

    effect->GetEffectParameter(dict);

    return HMC_OK;
}

int HmcEffectRemove(HmcEditor *editor, HmcUid assetUid, HmcUid effectUid)
{
    HMC_EDITOR_SETTER(editor);

    if (!editor) {
        LOGE("Invalid editor.");
        return HMC_ERR_PARAM;
    }

    char uidStr[HMC_UID_STR_LEN] = {0};
    LOGD("remove effect{%s} of asset{%s}", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN),
        HmcUidToString(&effectUid, uidStr, HMC_UID_STR_LEN));

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not version type, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    ((HmcVisionAsset *)asset)->RemoveEffect(effectUid);

    return HMC_OK;
}

int HmcEffectDestroy(HmcEditor *editor, HmcUid assetUid, HmcUid effectUid)
{
    HMC_EDITOR_SETTER(editor);

    int result = HmcEffectRemove(editor, assetUid, effectUid);
    if (result == HMC_OK) {
        auto effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
        delete effect;
    }

    return result;
}

int HmcEffectInsert(HmcEditor *editor, HmcUid assetUid, HmcUid effectUid, unsigned int index)
{
    HMC_EDITOR_SETTER(editor);

    if (!editor) {
        LOGE("Invalid editor.");
        return HMC_ERR_PARAM;
    }

    char uidStr[HMC_UID_STR_LEN] = {0};
    LOGD("insert effect{%s} to asset{%s}", HmcUidToString(&effectUid, uidStr, HMC_UID_STR_LEN),
        HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not version type, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    return ((HmcVisionAsset *)asset)->InsertEffect(effectUid, index);
}

int HmcEffectGetIndex(HmcEditor *editor, HmcUid assetUid, HmcUid effectUid, unsigned int *index)
{
    if (!editor || !index) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not version type, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    unsigned int indexTemp = 0;
    if (!((HmcVisionAsset *)asset)->GetEffectIndex(effectUid, indexTemp)) {
        return HMC_ERR;
    }

    *index = indexTemp;
    return HMC_OK;
}

int HmcEffectRemoveAll(HmcEditor *editor, HmcUid assetUid)
{
    HMC_EDITOR_SETTER(editor);

    if (!editor) {
        LOGE("Invalid editor.");
        return HMC_ERR_PARAM;
    }

    char uidStr[HMC_UID_STR_LEN] = {0};
    LOGD("remove all effects of assetUid: %s", HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN));

    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not an asset entity, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }

    ((HmcVisionAsset *)asset)->RemoveAllEffects();

    return HMC_OK;
}

int HmcEffectRename(HmcEditor *editor, HmcUid effectUid, const char *name)
{
    HMC_EDITOR_SETTER(editor);

    if (!editor || !name) {
        LOGE("Invalid parameter.");
        return HMC_ERR_PARAM;
    }

    HmcEffect *effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
    if (effect == nullptr) {
        LOGE("get effect by effect uid failed, please check you effect uid");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }

    effect->SetName(name);

    return HMC_OK;
}

int HmcEffectSetEnable(HmcEditor *editor, HmcUid effectUid, bool enable)
{
    int result = HMC_OK;
    BOOL isEnable = enable ? TRUE : FALSE;
    HmcEffect *effect = CheckEffectPara(editor, effectUid, result);
    if (effect == nullptr) {
        return result;
    }
    if (effect->IsEnable() != isEnable) {
        PreviewStateControl(editor);
        effect->SetEnable(isEnable);
    }
    return HMC_OK;
}

int HmcEffectIsEnable(HmcEditor *editor, HmcUid effectUid)
{
    HMC_UNUSED(editor);

    HmcEffect *effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
    if (effect == nullptr) {
        LOGE("get effect by effect uid failed, please check you effect uid");
        return FALSE;
    }

    return effect->IsEnable();
}

int HmcEffectMove(HmcEditor *editor, HmcUid assetUid, HmcUid laneUid, HmcUid effectUid, int64_t timeStamp)
{
    HMC_EDITOR_SETTER(editor);

    if (editor == nullptr) {
        LOGE("error, editor is NULL");
        return HMC_ERR_PARAM;
    }
    LOGD("effectUid: %s, assetUid: %s, laneUid: %s, timestamp: %lld",
        HmcUidToString(&assetUid, uidStr, HMC_UID_STR_LEN), HmcUidToString(&effectUid, uidStr, HMC_UID_STR_LEN),
        HmcUidToString(&laneUid, uidStr, HMC_UID_STR_LEN), timeStamp);

    HmcLaneManager *manager = (HmcLaneManager *)(SINGLETON(HmcUidAdmin)->GetAsset(assetUid));
    if (manager == nullptr) {
        LOGE("actor is null");
        return HMC_ERR;
    }

    HmcEffect *effect = SINGLETON(HmcUidAdmin)->GetEffect(effectUid);
    if (effect == nullptr) {
        LOGE("can not get effect by effect uid, please check your effect uid");
        return HMC_ERR_SERVICE_EFFECT_INVALID;
    }

    if (manager->MoveEffect(effectUid, assetUid, timeStamp) == FALSE) {
        return HMC_ERR;
    }

    return HMC_OK;
}

int HmcUpdateDownSimplerDisplayInfo(HmcEditor *editor, HmcUid assetUid, INT32 width, INT32 height)
{
    HMC_UNUSED(editor);
    LOGI("HmcUpdateDisplayInfo width: %d height: %d", width, height);
    IHmcAsset *asset = SINGLETON(HmcUidAdmin)->GetAsset(assetUid);
    if (!asset) {
        LOGE("asset is invalid, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_INVALID;
    }
    if (!HmcAssetUtils::IsVisionAsset(asset->GetType())) {
        LOGE("asset is not vision type, please check your asset id");
        return HMC_ERR_SERVICE_ASSET_TYPE_ERR;
    }
    ((HmcImageAsset *)asset)->UpdateDownSimplerDisplayInfos(width, height);
    return HMC_OK;
}