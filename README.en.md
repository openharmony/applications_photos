# photos

#### Description
The Gallery app is a pre-installed system app in the OpenHarmony standard system, providing users with basic gallery functions, including static image editing - continuation editing & one-click restoration & comparison, album grid, Gallery app open source materials, PhotoPicker, service card, settings page, static image editing - basic functions, album page browsing, large image browsing - enhanced, large image browsing - basic, photo page browsing, and other features.

#### Software Architecture
Software architecture description

#### catalogue


```
├── product
│    ├── src
│        └── main
│            ├── ets    
│                ├── MainAbility 
│                    ├── view                    # Directory for storing page components 
│                    ├── MainAbility             # MainAbility
│                    ├── PrivacyStatementAbility # APP Privacy Statement Ability
│                    ├── SettingAbility          # APP Setting Ability
│            ├── resources                       # Directory for storing resource files
│        
├── browserCommon                               # General Module for Image Viewing
├── browserCommonPC                             # Image browsing PC module    
├── browserCommonPhone                          # Image browsing Phone module
├── tools                                       # Tool module
├── imageEditor                                 # Image Editing Module
├─ signature                                    # Certificate File Directory             
```

#### Related repos

https://gitcode.com/openharmony/applications_photos
