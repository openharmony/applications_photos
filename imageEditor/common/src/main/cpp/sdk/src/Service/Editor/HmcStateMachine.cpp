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
#include "HmcStateMachine.h"

static MAP<HmcEditorAction, STRING> HMC_ACTION_MAP = {
    { HMC_EDITOR_ACTION_INIT, "init" },           { HMC_EDITOR_ACTION_PLAY, "play" },
    { HMC_EDITOR_ACTION_PLAYEND, "play end" },    { HMC_EDITOR_ACTION_PAUSE, "pause" },
    { HMC_EDITOR_ACTION_SEEK, "seek" },           { HMC_EDITOR_ACTION_SEEK_END, "seek end" },
    { HMC_EDITOR_ACTION_EXPORT, "export" },       { HMC_EDITOR_ACTION_CANCEL_EXPORT, "cancel export" },
    { HMC_EDITOR_ACTION_EXPORTEND, "export end" }
};

static MAP<HmcEditorState, STRING> HMC_STATE_MAP = { { HMC_EDITOR_STATE_INIT, "init" },
                                                     { HMC_EDITOR_STATE_IDLE, "idle" },
                                                     { HMC_EDITOR_STATE_PLAY, "play" },
                                                     { HMC_EDITOR_STATE_EXPORT, "export" } };

HmcStateMachine::HmcStateMachine(HmcEventHandler *handler) : m_handler(handler) {}

VOID HmcStateMachine::Init()
{
    m_lastState = HMC_EDITOR_STATE_INIT;
    m_state = HMC_EDITOR_STATE_INIT;
}

BOOL HmcStateMachine::DoAction(HmcEditorAction action)
{
    BOOL ret = TRUE;
    {
        std::lock_guard<std::mutex> lk(m_idleTaskMutex);
        ret = ActionJudge(action);
    }

    m_action = action;
    if (m_state == HMC_EDITOR_STATE_IDLE && m_action != HMC_EDITOR_ACTION_SEEK) {
        m_idleTaskCV.notify_all();
    }

    if (m_lastState == m_state) {
        // seek 场景状态一致也要返回TRUE,支持下一步动作
        // pause 创景 状态一致 返回FALSE,
        LOGI("HsmDoAction state not change, last_state=%s, state=%s, action=%s", HMC_STATE_MAP[m_lastState].c_str(),
            HMC_STATE_MAP[m_state].c_str(), HMC_ACTION_MAP[action].c_str());
    } else {
        LOGI("HsmDoAction state change, last_state=%s, state=%s, action=%s", HMC_STATE_MAP[m_lastState].c_str(),
            HMC_STATE_MAP[m_state].c_str(), HMC_ACTION_MAP[action].c_str());
        m_lastState = m_state;
    }

    return ret;
}

BOOL HmcStateMachine::ActionJudge(HmcEditorAction action)
{
    BOOL ret = TRUE;
    switch (action) {
        case HMC_EDITOR_ACTION_INIT:
            if (m_state == HMC_EDITOR_STATE_INIT) {
                    m_state = HMC_EDITOR_STATE_IDLE;
            }
            break;
    
        case HMC_EDITOR_ACTION_PLAY:
            if (m_state == HMC_EDITOR_STATE_IDLE) {
                    m_state = HMC_EDITOR_STATE_PLAY;
            }
            break;
    
        case HMC_EDITOR_ACTION_PLAYEND:
        case HMC_EDITOR_ACTION_SEEK_END:
        case HMC_EDITOR_ACTION_PAUSE:
            if (m_state == HMC_EDITOR_STATE_PLAY) {
                    m_state = HMC_EDITOR_STATE_IDLE;
            }
            break;
    
        case HMC_EDITOR_ACTION_SEEK:
            if (m_state == HMC_EDITOR_STATE_PLAY || m_state == HMC_EDITOR_STATE_IDLE) {
                    m_state = HMC_EDITOR_STATE_IDLE;
            }
            break;
    
        case HMC_EDITOR_ACTION_EXPORT:
            if (m_state == HMC_EDITOR_STATE_PLAY || m_state == HMC_EDITOR_STATE_IDLE) {
                    m_state = HMC_EDITOR_STATE_EXPORT;
            }
            break;
    
        case HMC_EDITOR_ACTION_EXPORTEND:
        case HMC_EDITOR_ACTION_CANCEL_EXPORT:
            if (m_state == HMC_EDITOR_STATE_EXPORT) {
                    m_state = HMC_EDITOR_STATE_IDLE;
            }
            break;
    
        default:
            ret = FALSE;
            break;
    }
    return ret;
}

HmcEditorState HmcStateMachine::GetState() const
{
    return m_state;
}

HmcEditorState HmcStateMachine::GetLastState() const
{
    return m_lastState;
}

void HmcStateMachine::WaitForIdleToRunTask()
{
    std::unique_lock<std::mutex> lk(m_idleTaskMutex);
    m_idleTaskCV.wait(lk, [&] { return m_state == HMC_EDITOR_STATE_IDLE && m_action != HMC_EDITOR_ACTION_SEEK; });

    return;
}