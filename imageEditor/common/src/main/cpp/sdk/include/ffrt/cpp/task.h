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

#ifndef FFRT_API_CPP_TASK_H
#define FFRT_API_CPP_TASK_H
#include <vector>
#include <functional>
#include "ffrt/task.h"

namespace ffrt {
class task_attr : public ffrt_task_attr_t {
public:
    task_attr()
    {
        ffrt_task_attr_init(this);
    }

    ~task_attr()
    {
        ffrt_task_attr_destroy(this);
    }

    task_attr(const task_attr&) = delete;
    task_attr& operator=(const task_attr&) = delete;

    /**
     * @brief Sets a task name by fork.
     *
     * @param name Indicates a pointer to the task name.
     */
    inline task_attr& name(const char* name)
    {
        ffrt_task_attr_set_name(this, name);
        return *this;
    }

    /**
     * @brief Obtains the task name by fork.
     *
     * @return Returns a pointer to the task name.
     */
    inline const char* name() const
    {
        return ffrt_task_attr_get_name(this);
    }

    /**
     * @brief Sets the QoS for this task by fork.
     *
     * @param qos Indicates the QoS.
     */
    inline task_attr& qos(qos qos_)
    {
        ffrt_task_attr_set_qos(this, qos_);
        return *this;
    }

    /**
     * @brief Obtains the QoS of this task by fork.
     *
     * @return Returns the QoS.
     */
    inline int qos() const
    {
        return ffrt_task_attr_get_qos(this);
    }

    /**
     * @brief Sets the delay time for this task by fork.
     *
     * @param delay_us Indicates the delay time, in microseconds.
     */
    inline task_attr& delay(uint64_t delay_us)
    {
        ffrt_task_attr_set_delay(this, delay_us);
        return *this;
    }

    /**
     * @brief Obtains the delay time of this task by fork.
     *
     * @return Returns the delay time.
     */
    inline uint64_t delay() const
    {
        return ffrt_task_attr_get_delay(this);
    }
};

class task_handle {
public:
    task_handle() : p(nullptr)
    {
    }
    task_handle(ffrt_task_handle_t p) : p(p)
    {
    }

    ~task_handle()
    {
        if (p) {
            ffrt_task_handle_destroy(p);
        }
    }

    task_handle(task_handle const&) = delete;
    task_handle& operator=(task_handle const&) = delete;

    inline task_handle(task_handle&& h)
    {
        *this = std::move(h);
    }

    inline task_handle& operator=(task_handle&& h)
    {
        if (this != &h) {
            if (p) {
                ffrt_task_handle_destroy(p);
            }
            p = h.p;
            h.p = nullptr;
        }
        return *this;
    }

    inline operator void* () const
    {
        return p;
    }

private:
    ffrt_task_handle_t p = nullptr;
};

template<class T>
struct function {
    ffrt_function_header_t header;
    T closure;
};

struct dependence : ffrt_dependence_t {
    dependence(const void *d)
    {
        type = ffrt_dependence_data;
        ptr = d;
    }

    dependence(const task_handle &h)
    {
        type = ffrt_dependence_task;
        ptr = h;
    }
};

template<class T>
void exec_function_wrapper(void* t)
{
    auto f = reinterpret_cast<function<std::decay_t<T>>*>(t);
    f->closure();
}

template<class T>
void destroy_function_wrapper(void* t)
{
    auto f = reinterpret_cast<function<std::decay_t<T>>*>(t);
    f->closure = nullptr;
}

template<class T>
inline ffrt_function_header_t* create_function_wrapper(T&& func,
    ffrt_function_kind_t kind = ffrt_function_kind_general)
{
    using function_type = function<std::decay_t<T>>;
    static_assert(sizeof(function_type) <= ffrt_auto_managed_function_storage_size,
        "size of function must be less than ffrt_auto_managed_function_storage_size");

    auto p = ffrt_alloc_auto_managed_function_storage_base(kind);
    auto f = new (p)function_type;
    f->header.exec = exec_function_wrapper<T>;
    f->header.destroy = destroy_function_wrapper<T>;
    f->closure = std::forward<T>(func);
    return reinterpret_cast<ffrt_function_header_t*>(f);
}

/**
 * @brief Submits a task without input and output dependencies by fork.
 *
 * @param func Indicates a task executor function closure.
 */
static inline void submit(std::function<void()>&& func)
{
    return ffrt_submit_base(create_function_wrapper(std::move(func)), nullptr, nullptr, nullptr);
}

/**
 * @brief Submits a task without input and output dependencies, and obtains a task handle by fork.
 *
 * @param func Indicates a task executor function closure.
 * @return Returns a non-null task handle if the task is submitted;
           returns a null pointer otherwise.
 */
static inline task_handle submit_h(std::function<void()>&& func)
{
    return ffrt_submit_h_base(create_function_wrapper(std::move(func)), nullptr, nullptr, nullptr);
}

/**
 * @brief Submits a task without input and output dependencies, and obtains a task handle by fork.
 *
 * @param func Indicates a task executor function closure.
 * @return Returns a non-null task handle if the task is submitted;
           returns a null pointer otherwise.
 */
static inline task_handle submit_h(const std::function<void()>& func)
{
    return ffrt_submit_h_base(create_function_wrapper(func), nullptr, nullptr, nullptr);
}

/**
 * @brief Waits until all submitted tasks are complete by fork.
 *
 */
static inline void wait()
{
    ffrt_wait();
}

/**
 * @brief Waits until dependent tasks are complete by fork.
 *
 * @param deps Indicates a pointer to the dependent tasks.
 */
static inline void wait(const std::vector<dependence> &deps)
{
    ffrt_deps_t d;
    d.len = deps.size();
    d.items = deps.data();
    ffrt_wait_deps(&d);
}

namespace this_task {
static inline int update_qos(qos qos_)
{
    return ffrt_this_task_update_qos(qos_);
}

/**
 * @brief Obtains the ID of this task by fork.
 *
 * @return Returns the task ID.
 */
static inline uint64_t get_id()
{
    return ffrt_this_task_get_id();
}
} // namespace this_task
} // namespace ffrt
#endif
