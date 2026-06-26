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
#ifndef MEDIACREATIVE_RENDERTASKITF_H
#define MEDIACREATIVE_RENDERTASKITF_H

#include <memory>
#include <future>

template <typename RETURNTYPE, typename... ARGSTYPE> class RenderTaskItf {
public:
    typedef RETURNTYPE ReturnType;

    RenderTaskItf() = default;
    virtual ~RenderTaskItf() = default;

    virtual void Run(ARGSTYPE...) = 0;

    virtual bool operator < (const RenderTaskItf &other)
    {
        return this->m_id < other.m_id;
    };

    void SetTag(uint64_t tag)
    {
        m_tag = tag;
    }

    uint64_t GetTag()
    {
        return m_tag;
    }

    void SetId(uint64_t id)
    {
        m_id = id;
    }

    uint64_t GetId()
    {
        return m_id;
    }

    void SetSequenceId(uint64_t id)
    {
        m_sequenceId = id;
    }

    uint64_t GetSequenceId()
    {
        return m_sequenceId;
    }

    virtual void Wait() = 0;

    virtual RETURNTYPE GetReturn() = 0;

    virtual std::shared_future<RETURNTYPE> GetFuture() = 0;

protected:
    uint64_t m_id;
    uint64_t m_tag;
    uint64_t m_sequenceId;
};

template <typename RETURNTYPE, typename... ARGSTYPE>
using RenderTaskPtr = std::shared_ptr<RenderTaskItf<RETURNTYPE, ARGSTYPE...>>;

template <typename RETURNTYPE, typename... ARGSTYPE> class TaskCompare {
public:
    bool operator () (const RenderTaskPtr<RETURNTYPE, ARGSTYPE...> &a, const RenderTaskPtr<RETURNTYPE, ARGSTYPE...> &b)
    {
        return !((*(a.get())) < (*(b.get()))); // 先弹出较小者
    }
};

template <typename RETURNTYPE, typename... ARGSTYPE> uint64_t GetTag(const RenderTaskPtr<RETURNTYPE, ARGSTYPE...> &a)
{
    return (*(a.get())).GetTag();
}


using RenderCommonTaskPtr = RenderTaskPtr<void>;
using RenderTaskWithIdPtr = RenderTaskPtr<void, uint64_t>;

#endif // MEDIACREATIVE_RENDERTASKITF_H
