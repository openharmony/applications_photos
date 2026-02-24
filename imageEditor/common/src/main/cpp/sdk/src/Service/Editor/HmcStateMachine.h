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
#ifndef HMCSTATEMACHINE_H
#define HMCSTATEMACHINE_H

#include "HmcBase.h"
#include "HmcEventHandler.h"

using HmcExportState = enum HmcExportState {
    HMC_EXPORT_STATE_IDLE = 0,
    HMC_EXPORT_STATE_FINISH,
};

using HmcEditorState = enum HmcEditorState {
    HMC_EDITOR_STATE_INIT = 0,
    HMC_EDITOR_STATE_IDLE,
    HMC_EDITOR_STATE_PLAY,
    HMC_EDITOR_STATE_EXPORT
};

using HmcEditorAction = enum HmcEditorAction {
    HMC_EDITOR_ACTION_INIT = 0,
    HMC_EDITOR_ACTION_PLAY,
    HMC_EDITOR_ACTION_PLAYEND,
    HMC_EDITOR_ACTION_PAUSE,
    HMC_EDITOR_ACTION_SEEK,
    HMC_EDITOR_ACTION_SEEK_END,
    HMC_EDITOR_ACTION_EXPORT,
    HMC_EDITOR_ACTION_CANCEL_EXPORT,
    HMC_EDITOR_ACTION_EXPORTEND
};

class HmcStateMachine {
public:
    explicit HmcStateMachine(HmcEventHandler *handler);
    virtual ~HmcStateMachine() = default;

public:
    BOOL DoAction(HmcEditorAction action);
    BOOL ActionJudge(HmcEditorAction action);
    HmcEditorState GetState() const;
    HmcEditorState GetLastState() const;
    VOID Init();
    void WaitForIdleToRunTask();

private:
    HmcEventHandler *m_handler;
    HmcEditorState m_state{ HMC_EDITOR_STATE_INIT };
    HmcEditorState m_lastState{ HMC_EDITOR_STATE_INIT };
    std::mutex m_idleTaskMutex;
    std::condition_variable m_idleTaskCV;
    HmcEditorAction m_action{ HMC_EDITOR_ACTION_INIT };
};

#endif // HMCSTATEMACHINE_H
