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

#include "HveBridgeUtil.h"

void HveBridgeUtil::GetCenterInsideRectUnderRatio(float dstRatio, const HmcRectD &rect, HmcRectD *outputRect)
{
    if (outputRect == nullptr) {
        return;
    }
    float rectRatio = rect.Width() / rect.Height();

    float assetWidth;
    float assetHeight;
    if (dstRatio > rectRatio) {
        assetWidth = rect.Width();
        assetHeight = assetWidth / dstRatio;
    } else {
        assetHeight = rect.Height();
        assetWidth = assetHeight * dstRatio;
    }

    float offsetX = (rect.Width() - assetWidth) / 2;
    float offsetY = (rect.Height() - assetHeight) / 2;
    outputRect->left = rect.left + offsetX;
    outputRect->top = rect.top + offsetY;
    outputRect->right = rect.right - offsetX;
    outputRect->bottom = rect.bottom - offsetY;
}

std::string HveBridgeUtil::BuildCommonResult(int result, const std::string& msg, const Json::Value& data)
{
    Json::Value ret;
    ret["result"] = result;
    ret["msg"] = msg.c_str();
    ret["data"] = data;

    Json::FastWriter fastWriter;

    return fastWriter.write(ret);
}

std::string HveBridgeUtil::BuildCropRectResult(const HmcRectD &cropRect)
{
    Json::Value json;
    Json::FastWriter fastWriter;
    json["left"] = cropRect.left;
    json["top"] = cropRect.top;
    json["right"] = cropRect.right;
    json["bottom"] = cropRect.bottom;
    return fastWriter.write(json);
}