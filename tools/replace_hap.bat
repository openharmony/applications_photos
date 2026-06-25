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
@echo off&setlocal enabledelayedexpansion

hdc shell kill $(pidof com.ohos.photos)
hdc shell bm clean -n com.ohos.photos -d

hdc target mount

hdc shell rm -rf /system/app/PhotosHm
hdc shell rm -rf /system/app/shared_bundles/PhotoBrowser/PhotoBrowser.hsp

hdc file recv /system/etc/app/install_list.json ./

echo modifing config file of PhotosHm......
set match=0
set target=PhotosHm
set nexttarget=removable
set old=false
set new=true
set filename=install_list.json
set finish=0

for /f "delims=" %%i in (%filename%) do (
	if "!finish!" == "1" (
		echo %%i>>$
	) else (
		set line=%%i
		echo %%i | findstr %target% >nul && set match=1

		if "!match!" == "1" (
			echo %%i | findstr %nexttarget% >nul && set "line=!line:%old%=%new%!" && set finish=1
			echo !line!
		)

		echo !line!>>$
	)
)
move $ %filename%

hdc file send install_list.json /system/etc/app/install_list.json
hdc shell chmod 777 /system/etc/app/install_list.json
del install_list.json
hdc shell rm -rf /data/service/el1/public/bms/bundle_manager_service/*

hdc shell sync
hdc shell reboot
@pause