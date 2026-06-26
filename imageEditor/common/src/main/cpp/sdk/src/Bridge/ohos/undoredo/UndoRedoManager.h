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

#ifndef UNDOREDOMANAGER_H
#define UNDOREDOMANAGER_H

#include "HveCommand.h"
#include <stack>
#include <functional>

using UndoRedoStateChangeCb = std::function<void(bool undoEnable, bool redoEnable)>;

#define UNDO_REDO_MGR UndoRedoManager::GetInstance()

class UndoRedoManager {
public:
    static UndoRedoManager *GetInstance();

    std::string Undo();
    std::string Redo();
    bool CanUndo() const;
    bool CanRedo() const;
    void Start();
    void Stop();
    void Clear();

    void RegUndoRedoStateChangeCb(UndoRedoStateChangeCb func);
    int Execute(HveCommand *command);
    HveCommand *GetLastCmd(const std::string &type);

private:
    UndoRedoManager() = default;
    ~UndoRedoManager() = default;
    void NotifyStateChange();
    void Merge();
    void StepLimit();

private:
    std::atomic<bool> m_bypass = true;
    bool lastUndoState = false;
    bool lastRedoState = false;
    std::stack<HveCommand *> redoStack;
    HveCommand *transitCommand = nullptr;
    static UndoRedoManager *m_instance;
    std::mutex m_stackMutex;
    UndoRedoStateChangeCb m_undoRedoStateChangeCb{ nullptr };
    std::deque<HveCommand *> undoDeque;
};

#endif
