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
echo push hsp and hap
echo "直接运行本脚本(./tools/redo_sync_build_push.bat) 即可清空所有缓存并重出包"
echo "推大图组件(需要重启)"
@echo on
hdc target mount
hdc shell mount -o remount,rw /
echo "push hsp (NEED ROOT FIRST) %hsp%"
hdc file send feature\browserlibrary\build\default\outputs\default\PhotoBrowser.hsp system/app/shared_bundles/PhotoBrowser/PhotoBrowser.hsp;
ping -n 3 127.1;
hdc shell reboot;

@echo push hsp done