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
@rem Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.

@echo off
echo CLEAR ALL CACHES
echo Clear all caches and perform compilation again. If the error persists, check whether the SDK is updated.
echo "Run this script directly (./tools/redo_sync_build_push.bat) command to clear all buffers and re-build hap packets."

echo Canceling Log Flow Control (LOGS OVER PROC QUOTA)
@echo on
hdc shell hilog -Q pidoff

echo Disable Screen Off
hdc shell power-shell setmode 602

echo Show Layout Boundaries
hdc shell param set persist.ace.debug.boundary.enabled true
echo Hide Layout Boundaries
hdc shell param set persist.ace.debug.boundary.enabled false

echo Clear all caches
call ./tools/clear_caches.bat

echo sync
call ./tools/sync.bat;
echo sync done please continue while no any error
where ohpm.*;
echo "make sure ohpm version is 5.0.2; current ver:"
call ohpm -v;
echo "Please wait for the progress bar to complete before proceeding, or the compilation will fail!"
echo If an error occurs after the execution, see 
pause

echo build_hsp_hap
call ./tools/build_hsp_hap.bat;
echo "If an error occurs after the execution, there is a high probability that the cache fails to be cleared (an error is reported earlier) or the local code is modified."

call ./tools/push.bat;
@echo off
echo push_hsp_hap
echo "If an error occurs, indicates that the gallery HAP is not replaced. Run the script (./tools/replace_hap.bat) directly."
echo You can skip OOBE (the startup wizard) by referring to

echo gallery environment FAQs: 