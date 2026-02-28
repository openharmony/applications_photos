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
#include <stdio.h>
#include <gtest/gtest.h>

#include "HmcEngine.h"
#include "render/graphic/GLUtils.h"
#include <native_window/external_window.h>

#ifndef GL_TEXTURE_EXTERNAL_OES
#define GL_TEXTURE_EXTERNAL_OES 0x8D65
#endif

using namespace testing::ext;

class HmcThumbnailCallbackTest : public HmcThumbnailCallback {
    void OnThumbnailCallback(UINT64 timestamp, HmcImage *thumbnail) override
    {
        printf("OnThumbnailCallback timestamp=%lu\n", timestamp);
    }
};

static HmcVideoEngine* g_engine;
static OH_NativeImage* g_nativeImage;
static OHNativeWindow* g_nativeWindow;
static GLuint g_texId;
static HmcThumbnailCallbackTest* g_callback;

class HmcVideoEngineTest : public testing::Test {
protected:
    static void SetUpTestSuite();

    static void TearDownTestSuite();

    void SetUp() override;

    void TearDown() override;
};

void HmcVideoEngineTest::SetUpTestSuite()
{
    printf("HmcVideoEngineTest run before first case...\n");
    std::string path = "/data/test/001.mp4"; // 视频文件
    UINT32 options = HMC_ENABLE_PREVIEW;
    g_texId = GLUtils::CreateTexNoStorage(GL_TEXTURE_EXTERNAL_OES);
    g_nativeImage = OH_NativeImage_Create(g_texId, GL_TEXTURE_EXTERNAL_OES);
    g_nativeWindow = OH_NativeImage_AcquireNativeWindow(g_nativeImage);
    g_callback = new HmcThumbnailCallbackTest();
    g_engine = HmcVideoEngine::Create(path, g_nativeWindow, options, g_callback);
    EXPECT_NE(g_engine, nullptr);
}


void HmcVideoEngineTest::TearDownTestSuite()
{
    printf("HmcVideoEngineTest run after last case...\n");
    HmcVideoEngine::Destroy(g_engine);
    OH_NativeWindow_DestroyNativeWindow(g_nativeWindow);
    OH_NativeImage_Destroy(&g_nativeImage);
    glDeleteTextures(1, &g_texId);
    delete g_callback;
    g_callback = nullptr;
}

void HmcVideoEngineTest::SetUp()
{
    printf("HmcVideoEngineTest SetUp\n");
}

void HmcVideoEngineTest::TearDown()
{
    printf("HmcVideoEngineTest TearDown\n");
}

HWTEST_F(HmcVideoEngineTest, Create_001, TestSize.Level1)
{
    auto engine = HmcVideoEngine::Create("", g_nativeWindow, HMC_ENABLE_PREVIEW, g_callback);
    EXPECT_EQ(engine, nullptr);
}