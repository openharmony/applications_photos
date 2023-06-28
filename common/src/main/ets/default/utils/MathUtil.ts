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

export class MathUtil {
  static readonly TWO = 2;

  /**
   * The internal calculation has only 6-bit accuracy, so if the two values are less than the threshold,
   * they represent equality
   */
  static readonly EQUALITY_THRESHOLD = 0.00001;

  static distance(x1: number, y1: number, x2: number, y2: number): number {
    let dstX = x1 - x2;
    let dstY = y1 - y2;
    return Math.sqrt(dstX * dstX + dstY * dstY);
  }

  static clamp(num: number, min: number, max: number): number {
    return Math.min(Math.max(num, min), max);
  }

  /**
   * Two numbers are equal
   * @param lhs lhs
   * @param rhs rhs
   * @returns Are they equal
   */
  static equals(lhs: number, rhs: number): boolean {
    return Math.abs(lhs - rhs) < MathUtil.EQUALITY_THRESHOLD;
  }

  // Matrix multiplication, matrix column first； MxN * NxO => MxO
  static multiple(mat1: number[], mat2: number[], m: number, n: number, o: number): Array<number> {
    let result = new Array(m * o); // Result matrix, column first
    for (let i = 0; i < m; i++) { // row
      for (let j = 0; j < o; j++) { // column
        /*
         * [i, j]subscript = i + j * m
         * => mat[i, j] = mat1 i Row * mat2 j Column = mat1(i,0)->(i,n-1) * mat2(0, j)->(n-1, j)
         * = mat1[i + 0 * m] * mat2[j * m + 0] + ... + mat1[i + (n - 1) * m] * mat2[j * m + n - 1]
         */
        let tmp = 0;
        for (let k = 0; k < n; k++) {
          tmp += mat1[i + k * m] * mat2[j * m + k];
        }
        result[i + j * m] = tmp;
      }
    }
    return result;
  }
}