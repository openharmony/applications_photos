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
echo push hsp and haps
echo "直接运行本脚本(./tools/redo_sync_build_push.bat) 即可清空所有缓存并重出包"

echo "将下面的变量设为true, 即可推大图组件(需要重启)"
@echo on
set "hsp=false"

hdc shell mount -o remount,rw /;
if "%hsp%" == "true" (
  echo "push hsp (NEED ROOT FIRST) %hsp%"
  hdc file send feature\browserlibrary\build\default\outputs\default\PhotoBrowser.hsp system/app/shared_bundles/PhotoBrowser/PhotoBrowser.hsp;
  ping -n 3 127.1;
  hdc shell reboot;
)

echo "uninstall hap"
hdc uninstall com.ohos.photos
echo "出现 uninstall system app error. 运行脚本(./tools/replace_hap.bat) 即可替换图库"

echo "push phone hap"
hdc install product\phone\build\default\outputs\default\phone_photos-default-signed.hap

echo "push pc hap"
hdc install product\pc\build\default\outputs\default\pc_photos-default-signed.hap
echo "出现 install entry already exist 表示机器型号错误, 这里一定会报错, 因为25行安装了phone包, 需要安装pc把25行注释掉"

@echo "如果此文件执行失败, 出现 install version downgrade, install release type not same, debug type not same问题"
@echo "直接运行脚本(./tools/replace_hap.bat) 即可"
@echo push hsp and hap done