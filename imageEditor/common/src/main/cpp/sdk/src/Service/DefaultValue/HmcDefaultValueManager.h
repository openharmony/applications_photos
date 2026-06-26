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
#ifndef HMC_DEFAULT_VALUE_MANAGER_H
#define HMC_DEFAULT_VALUE_MANAGER_H

#include <json/json.h>
#include "HmcBase.h"
#include "MediaCreative.h"
#include "./Project/HmcProjectSerializeKey.h"

template <typename T> class PropertyType {
public:
    PropertyType(T value, BOOL enable) : m_value(value), m_enable(enable) {}
    inline T GetValue() const
    {
        return m_value;
    }
    inline BOOL GetEnable() const
    {
        return m_enable;
    }
    inline VOID SetValue(T value)
    {
        m_value = value;
    }
    inline VOID SetEnable(BOOL enable)
    {
        m_enable = enable;
    }

private:
    T m_value;
    BOOL m_enable{ TRUE };
};

class HmcDefaultValueManager {
    DECLARE_SINGLETON(HmcDefaultValueManager);

public:
    PropertyValue GetAllPropData();
    static AssetPropertyValue GetAssetPropData();
    static TransformPropertyValue GetTransformPropData();
    static AdjustPropertyValue GetAdjustPropData();
    static CropPercentPropertyValue GetCropPercentPropData();
    static FilterPropertyValue GetFilterPropData();
    static ChromaPropertyValue GetChromaPropData();
    static AudioPropertyValue GetAudioPropData();

    template <typename T> static Json::Value SerializeProperty(const PropertyType<T> &value);
    template <typename T>
    static VOID DeserializeProperty(const Json::Value &jsonData, const char *propertyName, PropertyType<T> &value);
};

template <typename T> Json::Value HmcDefaultValueManager::SerializeProperty(const PropertyType<T> &value)
{
    Json::Value propJson;
    propJson[PROJECT_KEY_PROPERTY_VALUE] = value.GetValue();
    propJson[PROJECT_KEY_PROPERTY_ENABLE] = value.GetEnable();
    return propJson;
}

template <typename T>
VOID HmcDefaultValueManager::DeserializeProperty(const Json::Value &jsonData, const char *propertyName,
    PropertyType<T> &value)
{
    if (!jsonData[propertyName].isNull()) {
        if (jsonData[propertyName].isObject()) {
            Json::Value propInfo = jsonData[propertyName];
            value.SetValue(propInfo[PROJECT_KEY_PROPERTY_VALUE].as<T>());
            value.SetEnable((BOOL)propInfo[PROJECT_KEY_PROPERTY_ENABLE].asInt());
        } else {
            value.SetValue(jsonData[propertyName].as<T>());
            value.SetEnable(TRUE);
        }
    }
}

#endif // HMC_DEFAULT_VALUE_MANAGER_H