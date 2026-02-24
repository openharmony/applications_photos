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

#ifndef OH_JSONVALUEUTIL_H
#define OH_JSONVALUEUTIL_H

#include <json/json.h>
#include "HmcBase.h"

#define CHECK_JSON_VALUE_RETURN_IF_NULL(jsonValue)                                                                     \
    do {                                                                                                               \
        if ((jsonValue).isNull()) {                                                                                    \
            LOGW("json value is null.");                                                                               \
            return false;                                                                                              \
        }                                                                                                              \
    } while (0)

class JsonValueUtil {
public:
    /**
     * 判断json指定key是否存在，并且类型为double
     *
     * @param jsonValue json
     * @param key key
     * @return true/false
     */
    inline static bool IsDouble(const Json::Value& jsonValue, const std::string& key)
    {
        CHECK_JSON_VALUE_RETURN_IF_NULL(jsonValue);
        if (jsonValue.isMember(key) && jsonValue[key].isDouble()) {
            return true;
        }
        LOGW("There is no key(%s), or the key is not an double.", key.c_str());
        return false;
    }

    /**
     * 判断json指定key是否存在，并且类型为string
     *
     * @param jsonValue json
     * @param key key
     * @return true/false
     */
    inline static bool IsString(const Json::Value& jsonValue, const std::string& key)
    {
        CHECK_JSON_VALUE_RETURN_IF_NULL(jsonValue);
        if (jsonValue.isMember(key) && jsonValue[key].isString()) {
            return true;
        }
        LOGW("There is no key(%s), or the key is not an string.", key.c_str());
        return false;
    }

    /**
     * 判断json指定key是否存在，并且值不为空
     *
     * @param jsonValue json
     * @param key key
     * @return true/false
     */
    inline static bool IsMemberAndNotNull(const Json::Value& jsonValue, const std::string& key)
    {
        CHECK_JSON_VALUE_RETURN_IF_NULL(jsonValue);
        if (jsonValue.isMember(key) && !jsonValue[key].isNull()) {
            return true;
        }
        LOGW("There is no key(%s) in json", key.c_str());
        return false;
    }

    /**
     * 从json指定key中获取 float, 添加可靠性校验
     *
     * @param jsonValue json
     * @param key key
     * @param outValue key对应的值
     * @return true/false
     */
    inline static bool ParseFloatIfHas(const Json::Value& jsonValue, const std::string& key, float& outValue)
    {
        // json cpp 没有isFloat()方法, 使用isDouble代替
        if (IsDouble(jsonValue, key)) {
            outValue = jsonValue[key].asFloat();
            return true;
        }
        return false;
    }

    /**
     * 从json指定key中获取对应类型的值（Json没有isFloat()方法，不能使用模板函数，使用@ParseFloatIfHas）
     *
     * @param jsonValue json
     * @param key key
     * @param outValue key对应的值
     * @return 成功/失败
     */
    template <typename T>
    inline static bool ParseValueIfHas(const Json::Value& jsonValue, const std::string& key, T& outValue)
    {
        CHECK_JSON_VALUE_RETURN_IF_NULL(jsonValue);
        if (jsonValue.isMember(key) && jsonValue[key].is<T>()) {
            outValue = jsonValue[key].as<T>();
            return true;
        }
        LOGW("There is no key(%s), or incorrect data type.", key.c_str());
        return false;
    }
};
#endif // OH_JSONVALUEUTIL_H
