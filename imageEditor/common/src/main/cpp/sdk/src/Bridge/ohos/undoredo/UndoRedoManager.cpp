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

#include "UndoRedoManager.h"

constexpr size_t STEP_LIMIT = 50;

static std::once_flag g_undoRedoMgrInitFlag;
UndoRedoManager *UndoRedoManager::m_instance = nullptr;

UndoRedoManager *UndoRedoManager::GetInstance()
{
    std::call_once(g_undoRedoMgrInitFlag, [] { m_instance = new UndoRedoManager(); });

    return m_instance;
}

void UndoRedoManager::Clear()
{
    LOGI("in clear lock guard begin");
    std::lock_guard<std::mutex> guard(m_stackMutex);
    LOGI("UndoRedoManager Manager Clear begin");
    while (!redoStack.empty()) {
        auto cmd = redoStack.top();
        redoStack.pop();
        delete cmd;
    }
    LOGI("UndoRedoManager Manager Clear redoStack finish");
    while (!undoDeque.empty()) {
        auto cmd = undoDeque.front();
        undoDeque.pop_front();
        delete cmd;
    }
    LOGI("UndoRedoManager Manager Clear undoDeque finish");
    NotifyStateChange();

    transitCommand = nullptr;
    m_bypass = true;
    lastRedoState = false;
    lastUndoState = false;
    LOGI("UndoRedoManager Manager Clear finish");
}


HveCommand *UndoRedoManager::GetLastCmd(const std::string &type)
{
    if (undoDeque.empty()) {
        return nullptr;
    }

    for (const auto &iterate : undoDeque) {
        if (iterate->GetCommandType() == DICT_KEY_ADJUST_AUTO_ENABLE) {
            return iterate;
        }
    }

    return nullptr;
}

int UndoRedoManager::Execute(HveCommand *command)
{
    LOGI("in execute lock guard begin");
    std::lock_guard<std::mutex> guard(m_stackMutex);
    int ret = HMC_ERR;
    ret = command->Execute();
    if (ret != HMC_OK) {
        delete command;
        return ret;
    }
    if (m_bypass.load()) {
        StepLimit();
        undoDeque.push_front(command);
        while (!redoStack.empty()) {
            HveCommand *commandTmp = redoStack.top();
            redoStack.pop();
            delete commandTmp;
        }
        NotifyStateChange();
    } else {
        if (transitCommand == nullptr) {
            transitCommand = command;
        } else {
            delete command;
        }
    }
    return ret;
}

std::string UndoRedoManager::Redo()
{
    LOGI("in Redo lock guard begin");
    // 回调刷新轨道时会造成m_stackMutex死锁。
    std::lock_guard<std::mutex> guard(m_stackMutex);
    std::string ret = "";
    HveCommand *commandTmp = nullptr;

    if (!redoStack.empty()) {
        commandTmp = redoStack.top();
        ret = commandTmp->Redo();
        if (ret != "") {
            redoStack.pop();
            undoDeque.push_front(commandTmp);
        }
        NotifyStateChange();
    }
    return ret;
}

std::string UndoRedoManager::Undo()
{
    LOGI("in undo lock guard begin");
    // 回调刷新轨道时会造成m_stackMutex死锁。
    std::lock_guard<std::mutex> guard(m_stackMutex);
    std::string ret = "";
    HveCommand *commandTmp = nullptr;
    if (!undoDeque.empty()) {
        commandTmp = undoDeque.front();
        ret = commandTmp->Undo();
        if (ret != "") {
            undoDeque.pop_front();
            redoStack.push(commandTmp);
        }
        NotifyStateChange();
    }
    return ret;
}

bool UndoRedoManager::CanUndo() const
{
    return !undoDeque.empty();
}

bool UndoRedoManager::CanRedo() const
{
    return !redoStack.empty();
}

void UndoRedoManager::Start()
{
    LOGD("UndoRedo Manager do start");
    m_bypass = false;
}

void UndoRedoManager::Stop()
{
    LOGD("UndoRedo Manager do stop");
    m_bypass = true;
    Merge();
}

void UndoRedoManager::RegUndoRedoStateChangeCb(UndoRedoStateChangeCb func)
{
    m_undoRedoStateChangeCb = func;
}

void UndoRedoManager::NotifyStateChange()
{
    if (nullptr == m_undoRedoStateChangeCb) {
        return;
    }
    bool redoState = !redoStack.empty();
    bool undoState = !undoDeque.empty();
    if (lastRedoState == redoState && lastUndoState == undoState) {
        return;
    }
    lastRedoState = redoState;
    lastUndoState = undoState;
    m_undoRedoStateChangeCb(undoState, redoState);
}

void UndoRedoManager::Merge()
{
    LOGI("in merge lock guard begin");
    std::lock_guard<std::mutex> guard(m_stackMutex);
    LOGI("UndoRedoManager merge begin");
    if (transitCommand == nullptr) {
        LOGE("UndoRedo Merge transitCommand is nullptr");
        return;
    }
    int ret = transitCommand->Merge();
    if (ret != HMC_OK) {
        delete transitCommand;
        transitCommand = nullptr;
        LOGE("UndoRedo Failed Merge. ret is %d", ret);
        return;
    }
    HveCommand *command = transitCommand;
    StepLimit();
    undoDeque.push_front(command);
    transitCommand = nullptr;
    LOGI("UndoRedoManager clean redoStack begin");
    while (!redoStack.empty()) {
        HveCommand *commandTmp = redoStack.top();
        redoStack.pop();
        delete commandTmp;
    }
    NotifyStateChange();
    LOGI("UndoRedoManager merge end");
}

void UndoRedoManager::StepLimit()
{
    if (undoDeque.size() < STEP_LIMIT) {
        return;
    }
    LOGI("UndoRedo Manager Undo was over 50 steps!");
    HveCommand *backCommand = undoDeque.back();
    undoDeque.pop_back();
    delete backCommand;
}