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
import lazy { MediaItem } from './browser/photo/MediaItem';
import lazy { SelectParams } from './common/SelectParams';
import lazy { Constants } from './common/Constants';
import lazy { MediaItemUtil } from '../utils/MediaItemUtil';
import lazy { UIExtensionContentSession } from '@kit.AbilityKit';

/* instrument ignore file */
export class ReplaceUriManager {
  private replaceMap: Map<MediaItem, MediaItem> = new Map<MediaItem, MediaItem>();
  private videoCoverMap: Map<string, string> = new Map<string, string>();
  private createUris: string[] = [];

  public setReplaceMap(originMediaItem: MediaItem, replaceMediaItem: MediaItem): void {
    this.replaceMap.set(originMediaItem, replaceMediaItem);
    this.createUris.push(replaceMediaItem.uri);
  }

  public setVideoCoverMap(oriUri: string, coverUri: string) {
    this.videoCoverMap.set(oriUri, coverUri);
    this.createUris.push(coverUri);
  }

  public hasReplaceUri(uri: string): boolean {
    for (let it of this.replaceMap) {
      if (it[1].uri === uri) {
        return true;
      }
    }
    return false;
  }

  public getAllCreateUris(): string[] {
    return this.createUris;
  }

  public getReplaceOriAndReplaceMediaItem(replaceUri: string): MediaItem[] {
    for (let it of this.replaceMap) {
      if (it[1].uri === replaceUri) {
        return [it[0], it[1]];
      }
    }
    return [];
  }

  public deleteByUri(replaceUri: string) {
    for (let it of this.replaceMap) {
      if (it[1].uri === replaceUri) {
        this.replaceMap.delete(it[0]);
        this.videoCoverMap.delete(replaceUri);
        return;
      }
    }
  }

  public getVideoCoverUri(originVideoUri: string): string | undefined {
    if (!originVideoUri) {
      return undefined;
    }
    if (this.videoCoverMap.has(originVideoUri)) {
      return this.videoCoverMap.get(originVideoUri);
    }
    return undefined;
  }

  public getOriginMediaItem(originUri: string): MediaItem | undefined {
    if (originUri === undefined) {
      return undefined;
    }
    for (let it of this.replaceMap) {
      if (it[0].uri === originUri) {
        return it[0];
      }
    }
    return undefined;
  }

  public getReplaceMediaItem(originMediaItem: MediaItem | undefined): MediaItem | undefined {
    if (originMediaItem === undefined) {
      return undefined;
    }
    if (this.replaceMap.has(originMediaItem)) {
      return this.replaceMap.get(originMediaItem);
    }
    for (let it of this.replaceMap) {
      if (it[0].uri === originMediaItem.uri) {
        return it[1];
      }
    }
    return undefined;
  }

  public hasReplaceMediaItem(originMediaItem: MediaItem | undefined): boolean {
    if (originMediaItem === undefined) {
      return false;
    }
    if (this.replaceMap.has(originMediaItem)) {
      return true;
    }
    for (let it of this.replaceMap) {
      if (it[0].uri === originMediaItem.uri) {
        return true;
      }
    }
    return false;
  }

  public isEditorImage(mediaItem: MediaItem): boolean {
    for (let it of this.replaceMap) {
      if (it[0].uniqueId == mediaItem.uniqueId) {
        return true;
      }
    }
    return this.replaceMap.has(mediaItem);
  }

  public createAndGrantFile(invalid: boolean, createUri: string, fileDir: string, date: number) {
    if (invalid) {
      this.sendCreateResult(date, '', 14000002, 'Invalid URI');
      return;
    }
    let params = LocalStorage.getShared()?.get<SelectParams>(Constants.PHOTO_PICKER_PARAMS_KEY);
    if (!params) {
      this.sendCreateResult(date, '', 14000011, 'System inner fail');
      return;
    }
    MediaItemUtil.createFileAndGrant(createUri, fileDir, params.bundleName, params.appCloneIndex, (a, grantUri) => {
      this.sendCreateResult(date, grantUri, a.code, a.message);
    })
  }

  private sendCreateResult(date: number, grantUri: string, code: number, message: string) {
    let session: UIExtensionContentSession | undefined =
      LocalStorage.getShared()?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
    session?.sendData({
      'dataType': 'createCallback',
      'grantUri': grantUri,
      'date': date,
      'code': code,
      'message': message
    });
  }

  public sendReplaceResult(date: number, code: number, message: string) {
    let session: UIExtensionContentSession | undefined =
      LocalStorage.getShared()?.get<UIExtensionContentSession>(Constants.PHOTO_PICKER_SESSION_KEY);
    session?.sendData({
      'dataType': 'replaceCallback',
      'code': code,
      'date': date,
      'message': message
    });
  }

  public parseMediaItemByVideo(videoUri: string): Promise<MediaItem> {
    return MediaItemUtil.parseMediaItemByVideo(videoUri);
  }
}