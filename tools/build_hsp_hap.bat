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
echo assemble build
echo "清空所有缓存并重新编译, 若编译仍然报错, 检查SDK是否有更新"
echo "直接运行脚本(./tools/redo_sync_build_push.bat) 即可清空所有缓存并重出包"

echo "编译 assembleHsp"
@echo on
call hvigorw assembleHsp --mode module -p product=default -p debuggable=false;
echo "确认assembleHsp (大图组件)编译结果: > hvigor BUILD SUCCESSFUL"
pause

echo DT
call hvigorw --mode module -p module=phone_photos@ohosTest -p product=default -p buildMode=test -p ohos-test-coverage=true assembleHap --analyze --parallel --incremental -p debuggable=false packageTesting;

echo "确认DT结果: > hvigor BUILD SUCCESSFUL"
pause

echo "编译 assembleHap"
call hvigorw --mode module -p debuggable=false product=default assembleHap --parallel --incremental --daemon;
echo "确认assembleHap 编译结果: > hvigor BUILD SUCCESSFUL"

echo build done