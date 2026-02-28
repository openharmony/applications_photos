# photos

#### 介绍

****
图库应用是OpenHarmony标准系统中预置的系统应用，为用户提供基础的图库功能，包括静态图片编辑-接续编辑&一键还原&对比、相册宫格、图库应用开源资料、PhotoPicker、服务卡片、设置页、静态图片编辑-基础功能、相册页浏览、大图浏览-增强、大图浏览-基础、照片页浏览等功能。
****

#### 软件架构

软件架构说明
****

#### 目录

```
├── product
│    ├── src
│        └── main
│            ├── ets    
│                ├── MainAbility 
│                    ├── view                    # 页面组件存放目录 
│                    ├── MainAbility             # MainAbility
│                    ├── PrivacyStatementAbility # APP隐私声明Ability
│                    ├── SettingAbility          # APP设置Ability
│            ├── resources                       # 资源文件存放目录
│        
├── browserCommon                               # 图片浏览通用模块 
├── browserCommonPC                             # 图片浏览PC模块    
├── browserCommonPhone                          # 图片浏览Phone模块
├── tools                                       # 工具模块
├── imageEditor                                 # 图片编辑模块
├─ signature                                    # 证书文件目录              
```

#### 相关仓

1. https://gitcode.com/openharmony/applications_photos



