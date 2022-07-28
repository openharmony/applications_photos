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
import { MediaLibraryAccess } from '../../../access/MediaLibraryAccess';
import fileio from '@ohos.fileio';
import { AlbumDefine } from '../AlbumDefine'
import { StringUtil } from '../../../utils/StringUtil'
import { TraceControllerUtils } from '../../../utils/TraceControllerUtils';

export class OperationImpl implements BrowserOperationInterface {
    logger: Logger = new Logger('OperationImpl');

    async favor(id, isFavor) {
        this.logger.info('favor');
        try {
            let fileAsset = (await MediaLibraryAccess.getInstance().getFirstObject(AlbumDefine.getFileFetchOptById(id))).obj
            fileAsset.favorite(isFavor);
            return true;
        } catch (e) {
            this.logger.error(`favor error ${e}`);
            return false;
        }
    }

    async delete(uri: string) {
        await MediaLibraryAccess.getInstance().deleteAsset(uri);
    }

    async copy(source: any, target: any) {
        this.logger.info(`copy start: src:${source.uri} target: ${target.uri}`);

        TraceControllerUtils.startTrace('openAssetR')
        let fd = await MediaLibraryAccess.getInstance().openAsset('R', source);
        TraceControllerUtils.finishTrace('openAsset')
        if (fd <= 0) {
            throw 'fd is invalid'
            return;
        }

        TraceControllerUtils.startTrace('openAssetRW')
        let targetFd = await MediaLibraryAccess.getInstance().openAsset('RW', target);
        TraceControllerUtils.finishTrace('openAssetRW')
        if (targetFd <= 0) {
            throw 'targetFd is invalid'
            return;
        }

        TraceControllerUtils.startTrace('readAndWriteData')
        await this.readAndWriteData(fd, targetFd);
        TraceControllerUtils.finishTrace('readAndWriteData')

        TraceControllerUtils.startTrace('sourceClose')
        await source.close(fd);
        TraceControllerUtils.finishTrace('sourceClose')
        TraceControllerUtils.startTrace('targetClose')
        await target.close(targetFd);
        TraceControllerUtils.finishTrace('targetClose')

        this.logger.debug('copy end')
    }

    async trash(uri: string, isTrash: boolean) {
        this.logger.debug(`trash start ${JSON.stringify(uri)}`);

        let fileId = StringUtil.getIdFromUri(uri);

        let fileAsset;
        if (isTrash) {
            fileAsset = (await MediaLibraryAccess.getInstance().getFirstObject(AlbumDefine.getFileFetchOptById(fileId))).obj;
        } else {
            fileAsset = (await MediaLibraryAccess.getInstance().getTrashObject(AlbumDefine.getFileFetchOptById(fileId)))[0];
        }

        await MediaLibraryAccess.getInstance().trashAsset(isTrash, fileAsset);
        this.logger.debug(`trash end: ${isTrash}`);
    }

    async create(param: any) {
        return await MediaLibraryAccess.getInstance().createAsset(param.mediaType, param.name, param.path);
    }

    async commitChanges(file) {
        await file.commitModify();
    }

    setName(source: any, name: string): void {
        let displayName = source.displayName;
        let index = displayName.lastIndexOf('.');
        displayName = name + displayName.slice(index);

        source.displayName = displayName;
        source.title = name;

        this.logger.info(`setName title: ${name}, displayName: ${displayName}`);
    }

    setOrientation(source: any, orientation: number): void {
        source.orientation = orientation;
    }

    setRelativePath(source: any, relativePath: string): void {
        source.relativePath = relativePath;
    }

    async readAndWriteData(srcFd: number, targetFd: number) {
        this.logger.debug('readAndWriteData start!')
        let stat = await fileio.fstat(srcFd);
        this.logger.debug(`readAndWriteData read stat.size ${stat.size}`)
        if (stat.size == 0) {
            return;
        }
        let step = 10000000;
        let last = stat.size % step;
        let count = (stat.size - last) / step;
        if (last > 0) {
            count = count + 1;
        }
        this.logger.debug(`readAndWriteData read count ${count} last ${last}`)

        for (let i = 0; i < count; i++) {
            let rwSize = 0;
            if (i == (count - 1)) {
                rwSize = last;
            } else {
                rwSize = step;
            }
            let buf = new ArrayBuffer(rwSize);
            let readOptions = {
                offset: 0,
                length: rwSize,
                position: i * step
            }
            await fileio.read(srcFd, buf, readOptions);
            let writeOptions = {
                offset: 0,
                length: rwSize,
                position: i * step,
                encoding: 'utf-8'
            }
            await fileio.write(targetFd, buf, writeOptions);
        }
        this.logger.debug('readAndWriteData end!')
    }
}