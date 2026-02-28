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

#ifndef MEDIACREATIVE_RENDERTASK_H
#define MEDIACREATIVE_RENDERTASK_H

#include "RenderTaskItf.h"

#include <memory>
#include <map>
#include <iostream>
#include <functional>
#include <future>


template <typename RETURNTYPE = void, typename... ARGSTYPE>
class RenderTask : public RenderTaskItf<RETURNTYPE, ARGSTYPE...> {
public:
    RenderTask(std::function<RETURNTYPE(ARGSTYPE...)> run, uint64_t tag = 0, uint64_t id = 0)
        : m_runFunc(run), m_barrier(), m_barrierFuture(m_barrier.get_future())
    {
        RenderTaskItf<RETURNTYPE, ARGSTYPE...>::SetTag(tag);
        RenderTaskItf<RETURNTYPE, ARGSTYPE...>::SetId(id);
        RenderTaskItf<RETURNTYPE, ARGSTYPE...>::SetSequenceId(0);
    }
    ~RenderTask() = default;

    void Run(ARGSTYPE... args) override
    {
        RunImpl<decltype(this), RETURNTYPE, ARGSTYPE...> impl(this);
        impl(args...);
    };

    void Wait() override
    {
        m_barrierFuture.wait();
    };

    RETURNTYPE GetReturn() override
    {
        return m_barrierFuture.get();
    };

    std::shared_future<RETURNTYPE> GetFuture() override
    {
        return m_barrierFuture;
    };

private:
    template <typename THISPTYTPE, typename RUNRETURNTYPE, typename... RUNARGSTYPE> class RunImpl {
    public:
        explicit RunImpl(THISPTYTPE p)
        {
            m_p = p;
        }
        void operator () (RUNARGSTYPE... args)
        {
            m_p->m_barrier.set_value(m_p->m_runFunc(args...));
        }
        THISPTYTPE m_p;
    };

    template <typename THISPTYTPE, typename... RUNARGSTYPE> struct RunImpl<THISPTYTPE, void, RUNARGSTYPE...> {
        explicit RunImpl(THISPTYTPE p)
        {
            m_p = p;
        }
        void operator () (RUNARGSTYPE... args)
        {
            m_p->m_runFunc(args...);
            m_p->m_barrier.set_value();
        }
        THISPTYTPE m_p;
    };

    std::function<RETURNTYPE(ARGSTYPE...)> m_runFunc;
    std::promise<RETURNTYPE> m_barrier;
    std::shared_future<RETURNTYPE> m_barrierFuture;
};


#endif // MEDIACREATIVE_RENDERTASK_H
