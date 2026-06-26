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

#ifndef HMC_CACHE_MANAGER_HPP
#define HMC_CACHE_MANAGER_HPP

#include "HmcBase.h"

const int ELEMENT_HANDLE_TIME_INTERVAL_MILLISEC = 5000; // 每次处理的时间间隔, 单位毫秒
const int ELEMENT_HANDLE_NUM_PER_INTERVAL = 50;         // 每次时间间隔处理的元素数量

template <typename T> class HmcCacheManager : public HmcThreadMain {
public:
    using TPair = PAIR<T, UINT64>;
    using TMapPair = MAP<STRING, TPair>;

public:
    HmcCacheManager(STRING name, INT32 capacity, bool activateThread);
    virtual ~HmcCacheManager();

    /* *
     * 添加元素
     * @param key, key 值
     * @param elem, 要添加的元素
     * @param ttl, 该元素要存活的 TTL, 单位为秒
     * @return 0 -> OK, !0 -> NOK
     */
    INT32 Add(const STRING &key, const T &elem, UINT32 ttl);

    /* *
     * 查询元素
     * @param key, key 值
     * @param elem, 返回 key 值对应的元素
     * @return 0 -> OK, !0 -> NOK
     */
    INT32 Get(const STRING &key, T &elem);

    /* *
     * 删除元素
     * @param key, key 值
     * @return 0 -> OK, !0 -> NOK
     */
    INT32 Del(const STRING &key);

    /* *
     * 销毁缓存管理器
     */
    VOID Destroy();

private:
    VOID ThreadMain(HmcThread *selfThread, VOID *userData);

    VOID CheckTtlAndRemove();

private:
    HmcMutex m_mutex;
    HmcThread *m_thread = NULL;

    HmcEvent m_event;

    TMapPair m_elems;     // 元素
    DEQUE<STRING> m_keys; // 所有键值
    INT32 m_capacity;     // 容量

    STRING m_name;
};

template <typename T>
HmcCacheManager<T>::HmcCacheManager(STRING name, INT32 capacity, bool activateThread)
    : HmcThreadMain(), m_mutex((name + "_cache_mutex")), m_event(name + "cacheEvent"), m_capacity(capacity)
{
    m_keys.clear();
    m_elems.clear();
    m_name = "HmcCacheManager_" + name;
    m_thread = nullptr;
}

template <typename T> HmcCacheManager<T>::~HmcCacheManager()
{
    Destroy();
}

template <typename T> VOID HmcCacheManager<T>::Destroy()
{
    LOGD("%s: ready to destroy", m_name.c_str());
    if (m_thread) {
        m_thread->RequestForStop();
        m_event.SetSignaled();
        HmcThread::Destroy(m_thread);
        m_thread = nullptr;
    }
    LOGD("%s: destroyed", m_name.c_str());
    m_keys.clear();
    m_elems.clear();
}

template <typename T> INT32 HmcCacheManager<T>::Add(const STRING &key, const T &elem, UINT32 ttl)
{
    if (ttl == 0) {
        return HMC_OK;
    }

    if (ttl > (std::numeric_limits<UINT32>::max() / 1000)) {
        return HMC_ERR;
    }

    UINT64 expiredTime = HmcGetCurrTimeMillSec() + ttl * 1000; // 1000ms
    TPair elemPair(elem, expiredTime);
    HMC_MUTEX_LOCK(m_mutex);
    if ((INT32)m_elems.size() >= m_capacity) {
        LOGD("%s: exceed capacity, start to remove the front elem, key: %s.", m_name.c_str(), m_keys.front().c_str());
        // 如果超出容量, 则删除最早添加的元素
        m_elems.erase(m_keys.front());
        m_keys.pop_front();
    }
    m_elems[key] = elemPair;
    DEQUE<STRING>::iterator iter = find(m_keys.begin(), m_keys.end(), key);
    if (iter != m_keys.end()) {
        m_keys.erase(iter); // add 要么添加, 要么更新, 都把其放到末尾
    }
    m_keys.push_back(key);
    HMC_MUTEX_UNLOCK(m_mutex);

    return HMC_OK;
}

template <typename T> INT32 HmcCacheManager<T>::Get(const STRING &key, T &elem)
{
    // 为了防止查询期间被清理掉，加锁保护
    HMC_MUTEX_GUARD(m_mutex);
    if (m_elems.count(key) > 0) {
        // 懒式删除
        if (m_elems[key].second <= HmcGetCurrTimeMillSec()) {
            LOGD("%s: key(%s) expired.", m_name.c_str(), key.c_str());
            m_elems.erase(key);
            DEQUE<STRING>::iterator iter = find(m_keys.begin(), m_keys.end(), key);
            if (iter != m_keys.end()) {
                m_keys.erase(iter);
            }
            return HMC_ERR;
        }
        elem = m_elems[key].first;
        return HMC_OK;
    }

    return HMC_ERR;
}

template <typename T> INT32 HmcCacheManager<T>::Del(const STRING &key)
{
    // 为了防止查询期间被清理掉，加锁保护
    HMC_MUTEX_GUARD(m_mutex);
    if (m_elems.count(key) > 0) {
        LOGD("delete %s: key(%s).", m_name.c_str(), key.c_str());
        m_elems.erase(key);
        DEQUE<STRING>::iterator iter = find(m_keys.begin(), m_keys.end(), key);
        if (iter != m_keys.end()) {
            m_keys.erase(iter);
        } else {
            // element 存在，key 没找到
            LOGE("err find key, %s", m_name.c_str());
            return HMC_ERR;
        }
        return HMC_OK;
    }

    return HMC_ERR;
}

template <typename T> VOID HmcCacheManager<T>::CheckTtlAndRemove()
{
    if (m_elems.empty()) {
        return;
    }
    MAP<UINT8, STRING> tmpMap;
    UINT8 randData = 0;

    HMC_MUTEX_LOCK(m_mutex);
    int size = (int)m_keys.size();
    int checkNum = HMC_MIN(ELEMENT_HANDLE_NUM_PER_INTERVAL, size); // 最多50条
    for (int idx = 0; idx < checkNum; idx++) {
        SINGLETON(HmcRandomGenerator)->GetBytes(&randData, sizeof(randData));
        unsigned int index = (unsigned int)(randData % size);
        // 随机取一个小于size的 随机数
        if (m_elems[m_keys[index]].second <= HmcGetCurrTimeMillSec()) {
            if (tmpMap.count(index) == 0) {
                tmpMap[index] = m_keys[index];
            }
        }
    }
    for (auto iterMap = tmpMap.begin(); iterMap != tmpMap.end(); iterMap++) {
        auto element = iterMap->second;
        m_elems.erase(element);
        DEQUE<STRING>::iterator iter = find(m_keys.begin(), m_keys.end(), element);
        if (iter != m_keys.end()) {
            m_keys.erase(iter);
        }
        LOGD("%s: removed the expired key(%s).", m_name.c_str(), element.c_str());
    }
    HMC_MUTEX_UNLOCK(m_mutex);
}

template <typename T> VOID HmcCacheManager<T>::ThreadMain(HmcThread *selfThread, VOID * /* userData */)
{
    if (selfThread == nullptr) {
        LOGW("%s: thread is NULL.", m_name.c_str());
        return;
    }

    while (!selfThread->IsStopping()) {
        m_event.Wait(ELEMENT_HANDLE_TIME_INTERVAL_MILLISEC);

        // 定期删除
        CheckTtlAndRemove();
    }
    LOGD("%s: ready to exit", m_name.c_str());
}

#endif // HMC_CACHE_MANAGER_HPP