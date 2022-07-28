/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { BrowserOperationInterface } from '../../../interface/BrowserOperationInterface'
import { Logger } from '../../../utils/Logger'

export class AlbumOperationImpl implements BrowserOperationInterface {
    logger: Logger = new Logger('AlbumOperationImpl');

    setName(album: any, name: string): void {
        album.albumName = name;
    }

    async commitChanges(album: any) {
        await album.commitModify();
    }

    favor(uri: string, isFavor: boolean): void{
    }

    delete(uri: string): any{
    }

    copy(source: any, target: any): any{
    }

    trash(uri: string, isTrash: boolean): void{
    }

    create(param: any): any{
    }

    setOrientation(source: any, orientation: number): void{
    }

    setRelativePath(source: any, relativePath: string): void{
    }
}