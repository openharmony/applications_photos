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
import lazy { BigDataConstants, ReportToBigDataUtil } from './ReportToBigDataUtil';
import type { AlbumInfo } from '../model/browser/album/AlbumInfo';

/* instrument ignore file */
const TAG: string = 'ReportSmartAlbumDataUtil';

/**
 * 拍摄模式&&分类相册打点&&来源相册
 */
export class ReportSmartAlbumDataUtil {
  /**
   * 分类相册入口
   *
   * @param classifyOneName:top1的分类类别 string
   * @param count:数量 int
   *
   * @param classifyTwoName:top2的分类类别 string
   * @param count:数量 int
   *
   * @param classifyThreeName:top3的分类类别 string
   * @param count:数量 int
   *
   * @param classifyFourName:top4的分类类别 string
   * @param count:数量 int
   *
   */
  public static categoryEntry(albumInfoList: AlbumInfo[]): void {
    const msg: Record<string, number | string | Resource> = {
      'classifyOneName': albumInfoList?.[0]?.albumName ?? '',
      'classifyOneCount': albumInfoList?.[0]?.count ?? 0,
      'classifyTwoName': albumInfoList?.[1]?.albumName ?? '',
      'classifyTwoCount': albumInfoList?.[1]?.count ?? 0,
      'classifyThreeName': albumInfoList?.[2]?.albumName ?? '',
      'classifyThreeCount': albumInfoList?.[2]?.count ?? 0,
      'classifyFourName': albumInfoList?.[3]?.albumName ?? '',
      'classifyFourCount': albumInfoList?.[3]?.count ?? 0,
    };
    ReportToBigDataUtil.report(BigDataConstants.CLASSIFY_ALBUMS_ID, msg);
  }

  /**
   * 进入分类相册 ENTER_CLASSIFY_ALBUMS_ID
   *
   */
  public static goToTheCategoryAlbum(): void {
    ReportToBigDataUtil.report(BigDataConstants.ENTER_CLASSIFY_ALBUMS_ID, {});
  }

  /**
   * 进入具体分类 SPECIFIC_CLASSIFY_GRID_ID
   * @param classifyNameId: id分类类别int count:数量 int
   */
  public static enterTheSpecificCategory(id: number, count: number): void {
    const msg: Record<string, number | string | boolean> = {
      'classifyNameId': id,
      'classifyNameCount': count
    };
    ReportToBigDataUtil.report(BigDataConstants.SPECIFIC_CLASSIFY_GRID_ID, msg);
  }

  /**
   * 打点来源相册入口-进入来源相册
   *
   * @param sourceAlbumName  from:来源相册名 string
   * @param count count:数量 int
   *
   */
  public static enterSourceAlbums(from: string, count: number): void {
    const msg: Record<string, number | string | boolean> = {
      'sourceAlbumName': from,
      'count': count
    };
    ReportToBigDataUtil.report(BigDataConstants.SOURCE_ALBUM_ID, msg);
  }

  /**
   * 拍摄相册入口进入拍摄模式相册
   *
   * @param ENTER_SHOOTING_ALBUMS_ID
   * @param count拍摄模式相册数量 int
   *
   */
  public static shootingEntrance(count: number): void {
    const msg: Record<string, number | string | boolean> = {
      'count': count
    };
    ReportToBigDataUtil.report(BigDataConstants.ENTER_SHOOTING_ALBUMS_ID, msg);
  }

  /**
   * 拍摄模式相册进入图片宫格
   *
   * @param SPECIFIC_SHOOTING_GRID_ID
   * @param count图片数量 int
   *
   */
  public static shootingGrid(count: number): void {
    const msg: Record<string, number | string | boolean> = {
      'count': count
    };
    ReportToBigDataUtil.report(BigDataConstants.SPECIFIC_SHOOTING_GRID_ID, msg);
  }
}