@rem
@rem  Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
@rem  Licensed under the Apache License, Version 2.0 (the "License");
@rem  you may not use this file except in compliance with the License.
@rem  You may obtain a copy of the License at
@rem
@rem      http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem  Unless required by applicable law or agreed to in writing, software
@rem  distributed under the License is distributed on an "AS IS" BASIS,
@rem  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem  See the License for the specific language governing permissions and
@rem  limitations under the License.
@rem

@echo off
chcp 65001
echo 遇到本地环境问题, 请执行本命令debug
@echo 出现乱码问题的话用 ./tools/redo_sync_build_push.bat

echo CLEAR ALL CACHES
echo "清空所有缓存并重新编译, 若编译仍然报错, 检查SDK是否有更新"
echo "直接运行本脚本(./tools/redo_sync_build_push.bat) 即可清空所有缓存并重出包"

echo "解除日志限流 (LOGS OVER PROC QUOTA)"
@echo on
hdc shell hilog -Q pidoff

echo "禁止息屏"
hdc shell power-shell setmode 602

echo "显示布局边界"
hdc shell param set persist.ace.debug.boundary.enabled true
echo "隐藏布局边界"
hdc shell param set persist.ace.debug.boundary.enabled false

echo "清空所有缓存"
call ./tools/clear_caches.bat;

echo "同步缓存"
call ./tools/sync.bat;
echo sync done please continue while no any error
where ohpm;
echo "确认ohpm版本是否为 5.0.2, 当前版本: "
call ohpm -v
echo "这里请等待进度条完成 再按键继续, 否则编不过!"
echo 如果执行到这里出现问题, 参考 
pause

echo "重新编译"
call ./tools/build_hsp_hap.bat;
echo "如果执行到这里出现问题, 大概率是缓存没清成功(前面几号报错)或者本地代码有修改"

call ./tools/push.bat;
@echo off
echo "推包";
echo "如果执行到这里出现问题, 说明未替换图库, 直接运行脚本(./tools/replace_hap.bat) 即可";
echo "运行后可以参考 ";

echo done
echo 图库编译环境问题
pause