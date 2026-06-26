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

set hdc_path=hdc.exe
hdc target mount
hdc shell mount -o remount,rw /
hdc shell rm -rf /data/misc_de/0/mdds/0/default/bundle_manager_service
hdc shell rm -rf /data/accounts
hdc shell mount -o remount,rw /
hdc shell hilog -G 10240000 param set persist.ace.debug.enable 1
hdc shell rm -rf /system/app/PhotosHm/PhotosHm.hap
set /p var=please input LOCAL PATH of your HAP----
echo your HAP: %var%
hdc file send %var% /system/app/PhotosHm/PhotosHm.hap

hdc shell rm -rf /data/*
hdc shell sync
hdc shell /system/bin/udevadm trigger
hdc shell hilog -Q pidoff

hdc shell reboot
pause