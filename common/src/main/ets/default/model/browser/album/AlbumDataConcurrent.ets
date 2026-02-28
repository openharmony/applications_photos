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

import type { QueryAlbumParam } from '../../../interface/BrowserDataInterface';
import lazy { TraceControllerUtils } from '../../../utils/TraceControllerUtils';
import lazy { AlbumDataImplAsync, AlbumResult } from './AlbumDataImplAsync';
import lazy { MovePageAlbumDataImplAsync } from './MovePageAlbumDataImplAsync';
import lazy { AlbumInfo } from './AlbumInfo';

/* instrument ignore file */
/**
 * 查询相册信息的异步线程函数
 *
 * @param queryParam 查询参数
 * @param context 上下文
 * @returns 返回对象
 */
/* instrument ignore next */
@Concurrent
export async function getAlbumsTask(queryParam: QueryAlbumParam, context: Context): Promise<AlbumResult> {
  let requestTime = Date.now();
  TraceControllerUtils.startTraceWithTaskId('AlbumDataConcurrent getAlbumsTask', requestTime);
  let albumDataImplAsync: AlbumDataImplAsync = new AlbumDataImplAsync();
  albumDataImplAsync.onCreate(context);
  let result = await albumDataImplAsync.getAlbumsAsync(queryParam);
  TraceControllerUtils.finishTraceWithTaskId('AlbumDataConcurrent getAlbumsTask', requestTime);
  return result;
}

/**
 * 查询相册数量的异步线程函数
 *
 * @param queryParam 查询参数
 * @param context 上下文
 * @returns 返回对象
 */
/* instrument ignore next */
@Concurrent
export async function getAlbumsCountTask(queryParam: QueryAlbumParam, context: Context): Promise<AlbumResult> {
  let requestTime = Date.now();
  TraceControllerUtils.startTraceWithTaskId('AlbumDataConcurrent getAlbumsCountTask', requestTime);
  let albumDataImplAsync: AlbumDataImplAsync = new AlbumDataImplAsync();
  albumDataImplAsync.onCreate(context);
  let result = await albumDataImplAsync.getAlbumsCountAsync(queryParam);
  TraceControllerUtils.finishTraceWithTaskId('AlbumDataConcurrent getAlbumsCountTask', requestTime);
  return result;
}

/**
 * 查询移动到页面所需相册信息的异步线程函数
 * @param param 查询参数
 * @param context 上下文
 * @returns 返回对象
 */
@Concurrent
export async function getMovePageAlbumsTask(param: QueryAlbumParam, context: Context): Promise<AlbumInfo[]> {
  let requestTime = Date.now();
  TraceControllerUtils.startTraceWithTaskId('AlbumDataConcurrent getMovePageAlbumsTask', requestTime);
  let albumDataImpl = new MovePageAlbumDataImplAsync();
  albumDataImpl.onCreate(context);
  let result = await albumDataImpl.getMovePageAlbumsAsync(param);
  TraceControllerUtils.finishTraceWithTaskId('AlbumDataConcurrent getMovePageAlbumsTask', requestTime);
  return result;
}