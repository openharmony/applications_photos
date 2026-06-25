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

#ifndef oh_BlockQueue_H
#define oh_BlockQueue_H

#include <mutex>
#include <deque>
#include <condition_variable>
#include <chrono>

template <class T> class BlockQueue {
public:
    explicit BlockQueue(size_t maxCapacity = 1024);

    ~BlockQueue();

    void close();

    void flush();

    void clear();

    T front();

    T back();

    size_t get_size();

    size_t get_capacity();

    void push_back(const T &item);

    void push_front(const T &item);

    bool empty();

    bool full();

    bool pop(T &item);

    bool pop(T &item, int timeout);

private:
    std::deque<T> deq;

    size_t capacity;

    std::mutex mtx;

    bool isClose;

    std::condition_variable Consumer;

    std::condition_variable Producer;
};


template <class T> BlockQueue<T>::BlockQueue(size_t maxCapacity) : capacity(maxCapacity)
{
    isClose = false;
}

template <class T> BlockQueue<T>::~BlockQueue()
{
    close();
};

template <class T> void BlockQueue<T>::close()
{
    {
        std::lock_guard<std::mutex> locker(mtx);
        deq.clear();
        isClose = true;
    }
    Producer.notify_all();
    Consumer.notify_all();
};

template <class T> void BlockQueue<T>::flush()
{
    Consumer.notify_one();
}

template <class T> void BlockQueue<T>::clear()
{
    std::lock_guard<std::mutex> lock(mtx);
    deq.clear();
}

template <class T> T BlockQueue<T>::front()
{
    std::lock_guard<std::mutex> lock(mtx);
    return deq.front();
}

template <class T> T BlockQueue<T>::back()
{
    std::lock_guard<std::mutex> lock(mtx);
    return deq.back();
}

template <class T> size_t BlockQueue<T>::get_size()
{
    std::lock_guard<std::mutex> lock(mtx);
    return deq.size();
}

template <class T> size_t BlockQueue<T>::get_capacity()
{
    std::lock_guard<std::mutex> lock(mtx);
    return capacity;
}

template <class T> void BlockQueue<T>::push_back(const T &item)
{
    std::unique_lock<std::mutex> lock(mtx);
    while (deq.size() >= capacity) {
        Producer.wait(lock);
    }
    deq.push_back(item);
    Consumer.notify_one();
}

template <class T> void BlockQueue<T>::push_front(const T &item)
{
    std::unique_lock<std::mutex> lock(mtx);
    while (deq.size() >= capacity) {
        Producer.wait(lock);
    }
    deq.push_front(item);
    Consumer.notify_one();
}

template <class T> bool BlockQueue<T>::empty()
{
    std::lock_guard<std::mutex> lock(mtx);
    return deq.empty();
}

template <class T> bool BlockQueue<T>::full()
{
    std::lock_guard<std::mutex> lock(mtx);
    return deq.size() >= capacity;
}

template <class T> bool BlockQueue<T>::pop(T &item)
{
    std::unique_lock<std::mutex> lock(mtx);
    while (deq.empty()) {
        Consumer.wait(lock);
        if (isClose)
            return false;
    }
    item = deq.front();
    deq.pop_front();
    Producer.notify_one();
    return true;
}

template <class T> bool BlockQueue<T>::pop(T &item, int timeout)
{
    std::unique_lock<std::mutex> lock(mtx);
    while (deq.empty()) {
        if (Consumer.wait_for(lock, std::chrono::microseconds(timeout)) == std::cv_status::timeout)
            return false;
        if (isClose)
            return false;
    }
    item = deq.front();
    deq.pop_front();
    Producer.notify_one();
    return true;
}

#endif // oh_BlockQueue_H
