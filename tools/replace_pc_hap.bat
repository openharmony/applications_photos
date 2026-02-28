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
echo "替换图库, 解决  uninstall system app error 问题"
echo "xxx硬push(删本地数据)Hap包脚本, 解决 install version downgrade, install release type not same, debug type not same问题"
echo "直接运行脚本(./tools/replace_pc_hap.bat) 即可"
echo "运行后可以参考"
@echo on
set hdc_path=hdc.exe
hdc target mount
hdc shell mount -o remount,rw /
hdc shell rm -rf /data/misc_de/0/mdds/0/default/bundle_manager_service
hdc shell rm -rf /data/accounts
hdc shell mount -o remount,rw /
hdc shell hilog -G 10240000 param set persist.ace.debug.enable 1
hdc shell rm -rf /system/app/PhotosHm/PhotosHm.hap
echo "确保 pc_photos-default-signed.hap文件存在, 否则将进入机器重置页面, 需要输入'yes'恢复系统设置才能进系统"
hdc file send product\pc\build\default\outputs\default\pc_photos-default-signed.hap /system/app/PhotosHm/PhotosHm.hap
ping -n 3 127.1;

hdc shell rm -rf /data/*
hdc shell sync
hdc shell /system/bin/udevadm trigger
hdc shell hilog -Q pidoff

hdc shell reboot

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

hdc target mount
hdc shell mount -o remount,rw /
hdc shell rm -rf /data/misc_de/0/mdds/0/default/bundle_manager_service
hdc shell rm -rf /data/accounts
hdc shell mount -o remount,rw /
hdc shell hilog -G 10240000 param set persist.ace.debug.enable 1
hdc shell rm -rf /system/app/PhotosHm/PhotosHm.hap
echo "确保 pc_photos-default-signed.hap文件存在, 否则将进入机器重置页面, 需要输入'yes'恢复系统设置才能进系统"
hdc file send product\pc\build\default\outputs\default\pc_photos-default-signed.hap /system/app/PhotosHm/PhotosHm.hap
ping -n 3 127.1;

hdc shell rm -rf /data/*
hdc shell sync
hdc shell /system/bin/udevadm trigger
hdc shell hilog -Q pidoff

hdc shell reboot

echo done
pause