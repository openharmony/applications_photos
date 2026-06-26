@rem
@rem Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem     http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@echo off
echo CLEAR ALL CACHES
echo Clear all caches. If the error persists, check whether the SDK is updated.
echo Run this script directly (./tools/clear_caches.bat) command to clear all buffers and re-build hap packets.
@echo on
call hvigorw clean --no-daemon;

for /d /r .\ %%b in (*_modules*) do rd /s /q "%%b"
for /d /r .\ %%b in (.cxx) do rd /s /q "%%b"
for /d /r .\ %%b in (build) do rd /s /q "%%b"
for /f "delims=" %%i in ('dir /b /a-d /s "oh-package-lock.json5"') do del %%i
for /f "delims=" %%i in ('dir /b /a-d /s "BuildProfile.ets"') do del %%i

call npm cache clean --force