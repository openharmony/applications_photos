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
@echo on
chcp 65001

ping -n 3 127.1;
rem 监听设备连接
echo waiting for device...
:queryDevices
rem 开启变量延迟扩展
setlocal EnableDelayedExpansion

rem hdc要改成对应设备的
for /F "delims=" %%i in ('hdc list targets') do (
    echo %%i | findstr "[0-9A-Z][2]" > nul && (
        set device=%%i
        echo find a device: %%i
    )
)
if "%device%"=="" (
    adb kill-server
    @timeout 1
    goto queryDevices
)

rem 检测到设备后开始安装运行
ping -n 3 127.1;

hdc shell uinput -K -d 2 -u 2
hdc shell bm disable -n com.ohos.hwstartupguide
hdc file send settingsdata.db /data/app/el1/0/database/com.ohos.settingsdata/entry/rdb
hdc shell reboot
echo done
pause