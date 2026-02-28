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

#include "HmcService.h"

HmcEditorSetterGuard::HmcEditorSetterGuard(VOID *editor, bool enable) : m_enable(enable)
{
    if (enable) {
        LOGD("HmcEditorSetterGuard1 enable");
        m_editor = static_cast<HmcEditorImp *>(editor);
        if (m_editor != nullptr && m_editor->GetState() == HMC_EDITOR_STATE_PLAY) {
            m_editor->Pause(TRUE);
        }
    }
}

HmcEditorSetterGuard::HmcEditorSetterGuard(HmcEditorImp *editor, bool enable) : m_enable(enable)
{
    if (enable) {
        LOGD("HmcEditorSetterGuard2 enable");
        m_editor = editor;
        if (m_editor != nullptr && m_editor->GetState() == HMC_EDITOR_STATE_PLAY) {
            m_editor->Pause(TRUE);
        }
    }
}

HmcEditorSetterGuard::~HmcEditorSetterGuard()
{
    if (m_enable) {
        if (m_editor != nullptr) {
            if (m_editor->GetAutoFlush()) {
                m_editor->Flush();
            } else {
                m_editor->IncreaseWaitAutoFlushCnt();
            }
        }
    }
}
