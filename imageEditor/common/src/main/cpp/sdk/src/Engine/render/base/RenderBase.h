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

#ifndef RENDERBASE_H
#define RENDERBASE_H

#include "HmcBase.h"
#include <cassert>

// Some switches.
#define R_BENCHMARK_SWITCH (1)
#define R_BENCHMARK_WAIT_FINISH (0)
#define R_ASSERT_SWITCH (0)
#define R_FILTER_SWITCH (1)
#define R_HMC_RENDER_SWITCH (0)

// Some definitions

// Some processes.
#ifdef DEBUG
#define R_DEBUG (1)
#else
#define R_DEBUG (0)
#endif

#define R_ENABLE_BENCHMARK (R_BENCHMARK_SWITCH && R_DEBUG)

#if R_ENABLE_BENCHMARK
#include <chrono>
#define BENCHMARKTIME(name) auto name = std::chrono::high_resolution_clock::now()
#define BENCHMARKDURATION(name1, name2) ((std::chrono::duration<double, std::milli>(name2 - name1)).count())
#else
#define BENCHMARKTIME(name) ((void)0)
#define BENCHMARKDURATION(name1, name2) ((void)0)
#endif

#if R_ASSERT_SWITCH
#define RENDER_ASSERT(x) (assert((x)))
#else
#define RENDER_ASSERT(x) ((void)0)
#endif

#endif // RENDERBASE_H