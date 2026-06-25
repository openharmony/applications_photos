/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
 * Description: NAPI参数封装能力，方便使用，注意：未完成全部封装，根据需要自行添加吧。另外是否考虑将结果回填也放到这个对象中？
 * Version: 0.1
 * Create: 2022-05-06
 * 2022-8-25
 * 添加回调参数分析，并且可异步回调
 */

#ifndef OH_JSARGUMENTS_H
#define OH_JSARGUMENTS_H

#include <js_native_api.h>
#include <js_native_api_types.h>
#include <napi/native_api.h>
#include <uv.h>
#include <string>
#include <list>
#include <thread>
#include <vector>

#include <mutex>
#include <condition_variable>

#include "ArrayBuffer.hpp"
#include "../../../../libs/SecureC/include/securec.h"
#include "ohos/common/NapiCommon.h"
#include "log/HmcLog.h"

class Semaphore {
public:
    explicit Semaphore(long count = 0) : count(count) {}
    //V操作，唤醒
    void Signal()
    {
        std::unique_lock<std::mutex> unique(mt);
        ++count;
        if (count <= 0) {
            cond.notify_one();
        }
    }
    //P操作，阻塞
    void Wait()
    {
        std::unique_lock<std::mutex> unique(mt);
        --count;
        if (count < 0) {
            cond.wait(unique, [&] { return (count >= 0); });
        }
    }

private:
    std::mutex mt;
    std::condition_variable cond;
    long count;
};

class AutoLocker {
public:
    explicit AutoLocker(std::recursive_mutex &mtx) : mtx(mtx)
    {
        mtx.lock();
    }
    ~AutoLocker()
    {
        mtx.unlock();
    }

private:
    std::recursive_mutex &mtx;
};

class JSValue {
public:
    explicit JSValue(napi_env env) : env(env)
    {
        napi_get_undefined(env, &value);
    }
    JSValue(napi_env env, napi_value value) : env(env), value(value) {}
    JSValue(napi_env env, int32_t val) : env(env)
    {
        *this = val;
    }
    JSValue(napi_env env, int64_t val) : env(env)
    {
        *this = val;
    }
    JSValue(napi_env env, double val) : env(env)
    {
        *this = val;
    }
    JSValue(napi_env env, bool val) : env(env)
    {
        *this = val;
    }
    JSValue(napi_env env, const char *val) : env(env)
    {
        *this = val;
    }
    JSValue(napi_env env, const std::string &val) : env(env)
    {
        *this = val;
    }

    template <typename T>
    JSValue(napi_env env, std::list<T> const &val) : env(env)
    {
        napi_create_array_with_length(env, val.size(), &value);
        int index = 0;
        for (T const &t : val) {
            napi_set_element(env, value, index, (napi_value)JSValue(env, t));
            index++;
        }
    }

    JSValue(napi_env env, ArrayBuffer const &buf) : env(env)
    {
        void *data = nullptr;
        if (napi_ok == napi_create_arraybuffer(env, buf.Size(), &data, &value)) {
            memcpy_s(data, buf.Size(), buf.Data(), buf.Size());
        }
    }
    template <typename T>
    JSValue(napi_env env, std::vector<T> const &val) : env(env)
    {
        napi_create_array_with_length(env, val.size(), &value);
        int index = 0;
        for (T const &t : val) {
            napi_set_element(env, value, index, (napi_value)JSValue(env, t));
            index++;
        }
    }
    JSValue(JSValue const &b)
    {
        *this = b;
    }
    ~JSValue()
    {
        delete[] buf;
    }

    JSValue &operator=(JSValue const &b)
    {
        env = b.env;
        value = b.value;
        buf = b.buf;
        b.Detch();
        return *this;
    }
    napi_env getEnv() const
    {
        return env;
    }
    void Detch() const
    {
        buf = nullptr;
    }
    void operator=(int32_t val)
    {
        napi_create_int32(env, val, &value);
    }
    void operator=(int64_t val)
    {
        napi_create_int64(env, val, &value);
    }
    void operator=(double val)
    {
        napi_create_double(env, val, &value);
    }
    void operator=(bool val)
    {
        napi_get_boolean(env, val, &value);
    }
    void operator=(const char *val)
    {
        napi_create_string_utf8(env, val, strlen(val), &value);
    }
    void operator=(const std::string &val)
    {
        napi_create_string_utf8(env, val.c_str(), val.length(), &value);
    }

    operator int32_t() const
    {
        int32_t result = 0;
        napi_get_value_int32(env, value, &result);
        return result;
    }
    operator int64_t() const
    {
        int64_t result = 0;
        napi_get_value_int64(env, value, &result);
        return result;
    }
    operator double() const
    {
        double result;
        napi_get_value_double(env, value, &result);
        return result;
    }
    operator bool() const
    {
        bool result = false;
        napi_get_value_bool(env, value, &result);
        return result;
    }
    operator void *() const
    {
        int64_t val = (int64_t)(*this);
        return (void *)val;
    }
    operator const char *() const
    {
        if (buf != nullptr) {
            return buf;
        }
        size_t len = 0;
        napi_get_value_string_utf8(env, value, nullptr, 0, &len);
        if (len + 1 == 0) {
            return nullptr;
        }
        buf = new char[len + 1];
        napi_get_value_string_utf8(env, value, buf, len + 1, &len);
        buf[len] = 0;

        return buf;
    }
    operator std::string() const
    {
        return std::string(static_cast<const char*>(*this));
    }

    template <typename T>
    operator std::list<T>() const
    {
        std::list<T> ret;
        uint32_t len;
        napi_get_array_length(env, value, &len);

        for (auto i = 0; i < len; i++) {
            napi_value item = nullptr;
            napi_get_element(env, value, i, &item);
            ret.push_back((T)JSValue(env, item));
        }
        return ret;
    }

    operator ArrayBuffer() const
    {
        size_t len = 0;
        void *buffer = nullptr;
        if (napi_ok != napi_get_arraybuffer_info(env, value, &buffer, &len)) {
            return ArrayBuffer(nullptr, 0);
        }

        return ArrayBuffer(buffer, len);
    }

    template <typename T>
    operator std::vector<T>() const
    {
        std::vector<T> ret;
        uint32_t len;
        napi_get_array_length(env, value, &len);

        for (uint32_t i = 0; i < len; i++) {
            napi_value item = nullptr;
            napi_get_element(env, value, i, &item);
            ret.push_back((T)JSValue(env, item));
        }
        return ret;
    }
    operator napi_value() const
    {
        return value;
    }

protected:
    napi_env env = nullptr;
    napi_value value = nullptr;
    mutable char *buf = nullptr;
};

class JSWorker {
public:
    JSWorker(napi_env env, std::function<void()> runable) : env(env), runable(runable)
    {
    }
    ~JSWorker()
    {
    }

    static void addRef(napi_env env, napi_ref ref)
    {
        addOrRemoveRef(env, ref, true);
    }
    static void unRef(napi_env env, napi_ref ref)
    {
        addOrRemoveRef(env, ref, false);
    }

    void Start()
    {
        uv_loop_s *loop = nullptr;
        napi_get_uv_event_loop(env, &loop);
        uv_work_t *work = new (std::nothrow) uv_work_t;
        work->data = this;
        uv_queue_work(
            loop, work,
            [](uv_work_t *work) {},
            [](uv_work_t *work, int status) {
            napi_handle_scope scope = nullptr;
            JSWorker *w = (JSWorker *)work->data;
            napi_open_handle_scope(w->env, &scope);
            if (scope == nullptr) {
                w->sem.Signal();
                delete work;
                return;
            }
            JSWorker::autoRef(w->env);

            w->runable();
            napi_close_handle_scope(w->env, scope);
            w->sem.Signal();
            delete work;
        });
        sem.Wait();
    }

protected:
    struct JSRef {
        JSRef(napi_env env, napi_ref ref, bool add) : env(env), ref(ref), add(add) {}
        napi_env env = nullptr;
        napi_ref ref = nullptr;
        bool add = true;
    };

    static void autoRef(napi_env env)
    {
        AutoLocker locker(Mtx());
        auto it = refs().begin();
        while (it != refs().end()) {
            JSRef &r = *it;
            if (r.env == env) {
                uint32_t val = 0;
                r.add ? napi_reference_ref(env, r.ref, &val) : napi_reference_unref(env, r.ref, &val);
                it = refs().erase(it);
            } else {
                ++it;
            }
        }
    }

protected:
    static void addOrRemoveRef(napi_env env, napi_ref ref, bool add)
    {
        AutoLocker locker(Mtx());
        refs().push_back({ env, ref, add });
    }
    static std::list<JSRef> &refs()
    {
        static std::list<JSRef> ret;
        return ret;
    };
    static std::recursive_mutex &Mtx()
    {
        static std::recursive_mutex ret;
        return ret;
    }

    napi_env env = nullptr;
    std::function<void()> runable = nullptr;
    Semaphore sem{ 0 };
};

class JSRawCallback {
public:
    JSRawCallback() {}
    explicit JSRawCallback(JSValue const &value)
    {
        *this = value;
    }
    explicit JSRawCallback(JSRawCallback const &cb)
    {
        this->env = cb.env;
        this->func = cb.func;
        this->thisId = cb.thisId;
        if (cb.func != nullptr) {
            JSWorker::addRef(env, func);
        }
    }
    virtual ~JSRawCallback()
    {
        if (nullptr != func) {
            JSWorker::unRef(env, func);
            func = nullptr;
        }
    }

    void operator=(JSValue const &param)
    {
        env = param.getEnv();
        napi_value value = param;

        napi_valuetype result;
        napi_typeof(env, value, &result);
        if (result != napi_function) {
            return;
        }

        napi_create_reference(env, value, 1, &func);
        thisId = std::this_thread::get_id();
    }

protected:
    void buildParams(std::list<JSValue> &params) const {}
    template <typename T>
    void buildParams(std::list<JSValue> &params, T first) const
    {
        params.push_back(JSValue(env, first));
    }
    template <typename T, typename... Args>
    void buildParams(std::list<JSValue> &params, T first, Args... args) const
    {
        params.push_back(JSValue(env, first));
        buildParams(params, args...);
    }

    template <typename... Arg>
    void Run(Arg... args) const
    {
        if (nullptr == func) {
            return;
        }
        if (IsJsThread()) {
            napi_handle_scope scope = nullptr;
            napi_open_handle_scope(env, &scope);
            std::list<JSValue> params;
            buildParams(params, args...);
            safeCallback(params);
            napi_close_handle_scope(env, scope);
        } else {
            JSWorker worker(env, [&] {
                std::list<JSValue> params;
                buildParams(params, args...);
                safeCallback(params);
            });
            worker.Start();
        }
    }
    void safeCallback(std::list<JSValue> &params) const
    {
        int argc = (int)params.size();
        napi_value *argv = new napi_value[argc];
        int i = 0;
        for (JSValue &item : params) {
            argv[i] = item;
            i++;
        }

        napi_value callback = nullptr;
        napi_get_reference_value(env, func, &callback);
        napi_value ret;
        napi_call_function(env, nullptr, callback, argc, argv, &ret);
        doCallbackResult(ret);
        delete[] argv;
    }

    virtual void doCallbackResult(napi_value ret) const {};
    bool IsJsThread() const
    {
        return thisId == std::this_thread::get_id();
    }

    napi_env env = nullptr;
    napi_ref func = nullptr;
    std::thread::id thisId;
};

class JSCallback : public JSRawCallback {
public:
    JSCallback() {}
    explicit JSCallback(JSValue const &value) : JSRawCallback(value) {}
    explicit JSCallback(JSCallback const &cb) : JSRawCallback(cb) {}
    template <typename... Args>
    void operator()(Args... args) const
    {
        Run(args...);
    }
};

template <typename R>
class JSCallbackWithReturn : public JSRawCallback {
public:
    JSCallbackWithReturn() {}
    explicit JSCallbackWithReturn(JSValue const &value) : JSRawCallback(value) {}
    explicit  JSCallbackWithReturn(JSCallback const &cb) : JSRawCallback(cb) {}
    ~JSCallbackWithReturn() override {}
    template <typename... Args>
    R operator()(Args... args) const
    {
        Run(args...);
        return r;
    }

protected:
    R r;
    virtual void doCallbackResult(napi_value ret) const
    {
        r = JSValue(env, ret);
    }
};

class JSArguments {
public:
    JSArguments(napi_env env, napi_callback_info info) : env(env), info(info)
    {
        g_napiEnv = env;
        LOGD("Init");
        napi_get_cb_info(env, info, &argc, nullptr, nullptr, nullptr);
        if (argc != 0) {
            argv = new napi_value[argc];
            napi_get_cb_info(env, info, &argc, argv, nullptr, &cbdata);
        }
    }
    ~JSArguments()
    {
        delete[] argv;
    }
    JSValue operator[](int index)
    {
        JSValue ret(env, argv[index < (int)argc ? index : argc - 1]);
        return ret;
    }
    size_t Size()
    {
        return argc;
    }
    void *GetCbdata()
    {
        return cbdata;
    }

protected:
    napi_env env = nullptr;
    napi_callback_info info = nullptr;
    size_t argc = 0;
    napi_value *argv = nullptr;
    void *cbdata = nullptr;
};
#endif // OH_JSARGUMENTS_H
