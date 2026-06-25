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

import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { SubjectObject } from '../view/ImageAnalyzerOverlayAdapter';

/* instrument ignore file */
const TAG: string = 'CalcSubjectUtilOld';

interface FaceInfo {
  faceRect: FaceRect;
}

interface FaceRect {
  faceNum: number,
  faceRects: FaceArea[]
  imageSize?: Size
}

interface FaceArea {
  x: number,
  y: number,
  width: number,
  height: number,
}

export class CalcSubjectUtilOld {
  // 判断单张人脸是否在多主体内
  public static isWithinSubjects(centerX: number, centerY: number, subjectObject: SubjectObject[]): boolean {
    for (let i: number = 0; i < subjectObject.length; i++) {
      Log.info(TAG, `subjectObject: ${subjectObject[i]}`);
      let top: number = subjectObject[i].rect.top;
      let left: number = subjectObject[i].rect.left;
      let right: number = subjectObject[i].rect.right;
      let bottom: number = subjectObject[i].rect.bottom;
      Log.info(TAG, `isWithinSubjects index: ${i} top: ${top} left: ${left} bottom: ${bottom} right: ${right}`);
      return centerX > left && centerX < right && centerY > top && centerY < bottom;
    }
    return false;
  }

  /**
   * 基于多个主体的位置,返回包围所有主体的矩形框
   *
   * @param faces：所有人脸信息
   * @param subjectObject：主体信息
   * @param imageWidth: 原始图片宽度
   * @param imageHeight: 原始图片高度
   *
   * @returns 矩形框
   */
  public static getSubjectsRect(
    faces: string, subjectObject: SubjectObject[], imageWidth: number, imageHeight: number): number[] {
    let jsonObject: FaceInfo = JSON.parse(faces) as FaceInfo;
    let overlayWidthScale: number = 1;
    let overlayHeightScale: number = 1;
    if (jsonObject.faceRect.imageSize !== undefined) {
      overlayWidthScale = Number(jsonObject.faceRect.imageSize.width) / imageWidth;
      overlayHeightScale = Number(jsonObject.faceRect.imageSize.height) / imageHeight;
      Log.info(
        TAG, `getSubjectsRect imageSize: ${Number(jsonObject.faceRect.imageSize.width)}, ${
      Number(jsonObject.faceRect.imageSize.height)}`
      );
    }

    // 依据AI控件中图片的尺寸计算
    let faceNum: number = jsonObject.faceRect.faceNum;
    let xMax: number = 0;
    let yMax: number = 0;
    let xMin: number = Number.MAX_VALUE;
    let yMin: number = Number.MAX_VALUE;
    for (let i = 0; i < faceNum; i++) {
      let x: number = Number(jsonObject.faceRect.faceRects[i].x);
      let y: number = Number(jsonObject.faceRect.faceRects[i].y);
      let width: number = Number(jsonObject.faceRect.faceRects[i].width);
      let height: number = Number(jsonObject.faceRect.faceRects[i].height);
      let centerX = x + width / 2;
      let centerY = y + height / 2;
      Log.info(TAG, `getSubjectsRect index: ${i}, faceRect: ${x}, ${y}, ${width}, ${height}`);
      if (CalcSubjectUtilOld.isWithinSubjects(centerX, centerY, subjectObject)) {
        xMin = Math.min(xMin, x);
        yMin = Math.min(yMin, y);
        xMax = Math.max(xMax, x + width);
        yMax = Math.max(yMax, y + height);
      }
      Log.info(TAG, `xMin: ${xMin}, yMin: ${yMin}, xMax: ${xMax}, yMax: ${yMax}`);
    }

    // 将AI控件中图片的尺寸恢复到原图
    let faceCenterX: number = (xMin + xMax) / overlayWidthScale / 2;
    let faceCenterY: number = (yMin + yMax) / overlayHeightScale / 2;
    Log.info(TAG, `faceCenterX: ${faceCenterX}, faceCenterY: ${faceCenterY}`);
    let rectWidth: number = (xMax - xMin) / overlayWidthScale;
    let rectHeight: number = (yMax - yMin) / overlayHeightScale;
    Log.info(TAG, `rectWidth: ${rectWidth}, rectHeight: ${rectHeight}`);
    return [faceCenterX, faceCenterY, rectWidth, rectHeight];
  }
}
