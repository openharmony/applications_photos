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
chcp 65001
echo [xxx脚本]HAP 白屏, 一键xpm修复 
@echo on
hdc shell mount -o remount,rw /
hdc file recv /system/etc/init/key_enable.cfg
echo 查询到值xpm_mode后，先remount设备

FOR /f "delims=" %%i in ('hdc shell "sysctl kernel.xpm.xpm_mode"') DO (set xpm_mode=%%i)
set xpm_mode=%xpm_mode:~-1%
if %xpm_mode% EQU 0 (
    echo 当前xpm_mode值为0，无需关闭！
) else (
    echo 当前xpm_mode值为%xpm_mode%,正在尝试修改为0...
    call node .\tools\node\xpm.js

    hdc target mount
    hdc shell mount -o remount,rw /
    hdc file send key_enable.cfg /system/etc/init/key_enable.cfg
    echo 将xpm关闭。xpm_mode的值为0就表示关闭了xpm。

    ping -n 3 127.1;
    hdc shell reboot
echo 执行完上述命令之后重启手机，再点击安装的hap，界面显示就正常了。
)