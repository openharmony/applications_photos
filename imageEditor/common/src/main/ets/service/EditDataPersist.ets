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
import { HiLog } from '../common/util/HiLog';

import { JSON } from '@kit.ArkTS';

const TAG: string = 'EditDataPersist';

const PERSIST_INFO_KEY = 'persist_info';

const EXTRA_INFO_KEY = 'extra_info';

const IMAGE_EFFECT_KEY = 'imageEffect';

const FILTER_XT_DEFINITION = 'FILTER_XT_DEFINITION';

const FILTER_STICKER_DEFINITION = 'FILTER_STICKER_DEFINITION';

const FILTERS_KEY = 'filters';

const NAME_KEY = 'name';

const VALUES_KEY = 'values';

const ALL_STICKER_NAMES: string[] =
  ['InplaceSticker', 'TimingSticker', 'FrameSticker', 'XtStyleSticker', 'PersonalizedStickerStyle1',
    'PersonalizedStickerStyle2', 'FestivalSticker'];

export class PersistInfoNode {
  public FILTER_XT_DEFINITION: string = '';
  public FILTER_STICKER_DEFINITION: string = '';
}

export class PersistInfoResult {
  public data:PersistInfo = new PersistInfo();
  public hasPersistInfo = false;
  public reFormatEditData = '';
}

export class PersistInfo {
  public filterXtDefinition: string = '';
  public filterStickerDefinition: string = '';

  public toString() {
    return 'filterXtDefinition:' + this.filterXtDefinition;
  }

  public toJSON(): PersistInfoNode {
    return {
      FILTER_XT_DEFINITION: this.filterXtDefinition,
      FILTER_STICKER_DEFINITION: this.filterStickerDefinition,
    };
  }
}

/**
 * 此工具用来解析edit_data中的 persistInfo 数据
 * */
export class PersistInfoUtils {

  public static parsePersistInfo(editData: string): PersistInfoResult {
    let persistInfo = new PersistInfo();
    // 没有编辑数据 默认可以写 persistInfo
    if (editData === undefined || editData === '') {
      HiLog.i(TAG, 'no editData allow merge persistInfo')
      return {
        hasPersistInfo: true,
        data: persistInfo,
        reFormatEditData : editData
      };
    }
    let editDataJson = JSON.parse(editData) as Object;
    try {
      if (Reflect.has(editDataJson, EXTRA_INFO_KEY)) {
        let extraInfoJson = Reflect.get(editDataJson, EXTRA_INFO_KEY) as Object;
        if (Reflect.has(extraInfoJson, PERSIST_INFO_KEY)) {
          PersistInfoUtils.setBasePersistInfo(persistInfo, Reflect.get(extraInfoJson, PERSIST_INFO_KEY));
          let keys = Reflect.ownKeys(extraInfoJson);
          let isOnlyPersistInfo =  keys && keys.length === 1 && keys[0] === PERSIST_INFO_KEY;
          if (isOnlyPersistInfo) {
            Reflect.set(editDataJson, EXTRA_INFO_KEY, undefined);
          }
          return {
            hasPersistInfo: true,
            data: persistInfo,
            reFormatEditData : JSON.stringify(editDataJson)
          };
        }
      }
    } catch (ignored) {
      HiLog.i(TAG, 'setBasePersistInfo fail');
    }
    return {
      hasPersistInfo: false,
      data: persistInfo,
      reFormatEditData : editData
    };
  }

  private static onlyContains(keys:string[],key:string){
    if (keys && keys.length === 1) {
      return keys[0] === key;
    }
    return false;
  }

  public static setPersistInfoFromImageEffect(persistInfo: PersistInfo, imageEffect: Object): void {
    if (!Reflect.has(imageEffect, FILTERS_KEY)) {
      return;
    }
    let filters = Reflect.get(imageEffect, FILTERS_KEY) as Array<Object>;
    for (let item of filters) {
      if (!Reflect.has(item, NAME_KEY) || !Reflect.has(item, VALUES_KEY)) {
        HiLog.i(TAG, 'not has name or values skip');
        continue;
      }
      ImageEffectWatermarkUtils.setPersistInfo(persistInfo, item);
    }
  }

  public static setBasePersistInfo(persistInfo: PersistInfo, persistInfoJson: Object) {
    if (Reflect.has(persistInfoJson, FILTER_XT_DEFINITION)) {
      persistInfo.filterXtDefinition = Reflect.get(persistInfoJson, FILTER_XT_DEFINITION);
    }
    if (Reflect.has(persistInfoJson, FILTER_STICKER_DEFINITION)) {
      persistInfo.filterStickerDefinition = Reflect.get(persistInfoJson, FILTER_STICKER_DEFINITION);
    }
  }

  /***
   * 将 persistInfo 合并到 编辑数据中
   * */
  public static merge(sourceEditData: string, persistInfo: PersistInfo): string {
    if (sourceEditData) {
      HiLog.i(TAG, 'merge editData' + sourceEditData);
      try {
        let editJson = JSON.parse(sourceEditData) as Object;
        let extraInfo: object;
        if (Reflect.has(editJson, EXTRA_INFO_KEY)) {
          extraInfo = Reflect.get(editJson, EXTRA_INFO_KEY) as object;
        } else {
          extraInfo = JSON.parse('{}') as object
          Reflect.set(editJson, EXTRA_INFO_KEY, extraInfo);
        }
        Reflect.set(extraInfo, PERSIST_INFO_KEY, persistInfo.toJSON());
        return JSON.stringify(editJson);
      } catch (ignored) {
        HiLog.i(TAG, 'set persist_info error:' + ignored);
        return sourceEditData;
      }
    }
    return sourceEditData;
  }
}

export class ImageEffectWatermarkUtils {
  /**
   * 从编辑数据中提取的 FILTER_XT_DEFINITION 到 PersistInfo 中
   * */
  public static setPersistInfo(persistInfo: PersistInfo, item: Object) {
    let name: string = Reflect.get(item, NAME_KEY) as string;
    if (!ALL_STICKER_NAMES.includes(name)) {
      return;
    }
    let values = Reflect.get(item, VALUES_KEY) as Object;
    if (!Reflect.has(values, FILTER_XT_DEFINITION)) {
      HiLog.i(TAG, 'not has FILTER_XT_DEFINITION ');
      return;
    }
    let filterXtDefinition = Reflect.get(values, FILTER_XT_DEFINITION) as string;
    if (filterXtDefinition !== undefined && filterXtDefinition !== '') {
      persistInfo.filterXtDefinition = filterXtDefinition;
    }
  }
}