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

#ifndef HMC_MATERIAL_JSON_UTIL_H
#define HMC_MATERIAL_JSON_UTIL_H

#include <json/json.h>
#include "HmcBase.h"

class HmcMaterialJsonUtil {
public:
    static INT32 LoadJsonFromFile(const STRING &filePath, Json::Value &jsonValue);

    static INT32 LoadJsonFromString(const STRING &contentStr, Json::Value &jsonValue);

    static INT32 LoadJsonFromNetString(const STRING &contentStr, Json::Value &jsonValue);

    static INT32 HmcStringDeserializeMaterialPath(const STRING &filePath, STRING &string);
    static const CHAR *HmcReadStringValue(const CHAR *string, const CHAR *name, CHAR *&value);
    static const CHAR *HmcReadIntValue(const CHAR *string, const CHAR *name, INT32 &value);

    /* *
     * json value写文件，覆盖
     * @param filePath
     * @param jsonValue
     * @return
     */
    static INT32 WriteJsonToFile(const STRING &filePath, const Json::Value &jsonValue);

    // 转换为utf-8
    static STRING ConvertJsonToStringUtf8(Json::Value &jsonValue);

    /* *
     * 从json指定key中获取 bool, 添加可靠性校验
     *
     * @param key key
     * @param jsonValue json
     * @param defaultValue 默认值
     * @return key对应的值
     */
    inline static bool GetBool(const STRING &key, const Json::Value &jsonValue, const bool defaultValue)
    {
        if (jsonValue.isMember(key) && jsonValue[key].isBool()) {
            return jsonValue[key].asBool();
        }
        LOGW("There is no key(%s), or the key is not an bool.", key.c_str());
        return defaultValue;
    }

    /* *
     * 从json指定key中获取 INT32, 添加可靠性校验
     *
     * @param key key
     * @param jsonValue json
     * @param defaultValue 默认值
     * @return key对应的值
     */
    inline static INT32 GetInt32(const STRING &key, const Json::Value &jsonValue, const INT32 defaultValue)
    {
        if (jsonValue.isMember(key) && jsonValue[key].isInt()) {
            return jsonValue[key].asInt();
        }
        LOGW("There is no key(%s), or the key is not an int32.", key.c_str());
        return defaultValue;
    }

    /* *
     * 从json指定key中获取 INT64, 添加可靠性校验
     *
     * @param key key
     * @param jsonValue json
     * @param defaultValue 默认值
     * @return key对应的值
     */
    inline static INT64 GetInt64(const STRING &key, const Json::Value &jsonValue, const INT64 defaultValue)
    {
        if (jsonValue.isMember(key) && jsonValue[key].isInt64()) {
            return jsonValue[key].asInt64();
        }
        LOGW("There is no key(%s), or the key is not an int64.", key.c_str());
        return defaultValue;
    }

    /* *
     * 从json指定key中获取 UINT32, 添加可靠性校验
     *
     * @param key key
     * @param jsonValue json
     * @param defaultValue 默认值
     * @return key对应的值
     */
    inline static UINT32 GetUInt32(const STRING &key, const Json::Value &jsonValue, const UINT32 defaultValue)
    {
        if (jsonValue.isMember(key) && jsonValue[key].isUInt()) {
            return jsonValue[key].asUInt();
        }
        LOGW("There is no key(%s), or the key is not an UInt32.", key.c_str());
        return defaultValue;
    }

    /* *
     * 从json指定key中获取 UINT64, 添加可靠性校验
     *
     * @param key key
     * @param jsonValue json
     * @param defaultValue 默认值
     * @return key对应的值
     */
    inline static UINT64 GetUInt64(const STRING &key, const Json::Value &jsonValue, const UINT64 defaultValue)
    {
        if (jsonValue.isMember(key) && jsonValue[key].isUInt64()) {
            return jsonValue[key].asUInt64();
        }
        LOGW("There is no key(%s), or the key is not an UInt64.", key.c_str());
        return defaultValue;
    }

    /* *
     * 从json指定key中获取 float, 添加可靠性校验
     *
     * @param key key
     * @param jsonValue json
     * @param defaultValue 默认值
     * @return key对应的值
     */
    inline static FLOAT GetFloat(const STRING &key, const Json::Value &jsonValue, const FLOAT defaultValue)
    {
        // json cpp 没有isFloat()方法, 使用isDouble代替
        if (jsonValue.isMember(key) && jsonValue[key].isDouble()) {
            return jsonValue[key].asFloat();
        }
        LOGW("There is no key(%s), or the key is not an double.", key.c_str());
        return defaultValue;
    }

    /* *
     * 从json指定key中获取 double, 添加可靠性校验
     *
     * @param key key
     * @param jsonValue json
     * @param defaultValue 默认值
     * @return key对应的值
     */
    inline static DOUBLE GetDouble(const STRING &key, const Json::Value &jsonValue, const DOUBLE defaultValue)
    {
        if (jsonValue.isMember(key) && jsonValue[key].isDouble()) {
            return jsonValue[key].asDouble();
        }
        LOGW("There is no key(%s), or the key is not an double.", key.c_str());
        return defaultValue;
    }

    /* *
     * 从json指定key中获取 String, 添加可靠性校验
     *
     * @param key key
     * @param jsonValue json
     * @param defaultValue 默认值
     * @return key对应的值
     */
    inline static STRING GetString(const STRING &key, const Json::Value &jsonValue, const STRING defaultValue)
    {
        if (jsonValue.isMember(key) && jsonValue[key].isString()) {
            return jsonValue[key].asString();
        }
        LOGW("There is no key(%s), or the key is not an String.", key.c_str());
        return defaultValue;
    }

    inline static HmcSimpleString GetSimpleString(const STRING &key, const Json::Value &jsonValue,
        const CHAR *defaultValue)
    {
        if (jsonValue.isMember(key) && jsonValue[key].isString()) {
            return HmcSimpleString(jsonValue[key].asString().c_str());
        }
        LOGW("There is no key(%s), or the key is not an String.", key.c_str());
        return HmcSimpleString(defaultValue);
    }

    inline static bool GetMemberIfHas(const STRING &key, const Json::Value &jsonValue, Json::Value &outValue)
    {
        if (jsonValue.isMember(key) && !jsonValue[key].isNull()) {
            outValue = jsonValue[key];
            return true;
        }
        return false;
    }

private:
    HmcMaterialJsonUtil() = default;

    ~HmcMaterialJsonUtil() = default;
};

#endif // !HMC_MATERIAL_JSON_UTIL_H
