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
import { HiLog } from '../../../common/util/HiLog';
import { SCALE_RATIO } from './const';
import { MosaicController } from './MosaicController';

const TAG = 'MosaicPaintController';

export enum PaintType {
  Erase = 0,
  Mosaic = 1,
  Img_2 = 2,
  Img_3 = 3,
  Img_4 = 4,
  Img_5 = 5,
  Img_6 = 6,
  Img_7 = 7,
  Img_8 = 8,
  Img_9 = 9,
}

interface PathDetail {
  type: PaintType,
  size: number,
  path: Path2D,
};

export class PaintController {
  private context: CanvasRenderingContext2D;
  private type: PaintType = PaintType.Erase;
  private size: number = 15;
  private mosaicController: MosaicController;
  private paths: Array<PathDetail> = [];
  private currentPaintIndex: number = -1;
  private currentPath: Path2D | null = null;
  private currentData: PathDetail | null = null;
  private cacheBitmap?: ImageBitmap;
  private patterns: Map<PaintType, CanvasPattern> = new Map();
  // 确认是否开始绘制的标记
  private drawStarted: boolean = false;

  constructor(context: CanvasRenderingContext2D, mosaicController: MosaicController) {
    this.context = context;
    this.mosaicController = mosaicController;
  }

  getContext() {
    return this.context;
  }

  setPaintSize(size: number) {
    this.size = size;
  }

  setType(type: PaintType) {
    this.type = type;
  }

  clear() {
    this.context.clearRect(0, 0, this.context.width, this.context.height);
  }

  clearCache() {
    this.cacheBitmap = undefined;
  }

  clearPaths() {
    this.paths = [];
    this.currentPaintIndex = -1;
  }

  canUndo() {
    return this.currentPaintIndex >= 0;
  }

  undo() {
    HiLog.i(TAG, `undo: index${this.currentPaintIndex}  paths.length = ${this.paths.length}`);
    if (this.currentPaintIndex < 0) {
      return;
    }
    this.clear();
    this.currentPaintIndex--;
    for (let i = 0; i <= this.currentPaintIndex; i++) {
      this.drawInit(this.paths[i].type, this.paths[i].size);
      this.context.stroke(this.paths[i].path);
    }
  }

  canRedo() {
    return this.currentPaintIndex < this.paths.length - 1;
  }

  redo() {
    HiLog.i(TAG, `redo: index${this.currentPaintIndex} paths.length = ${this.paths.length}`);
    if (this.currentPaintIndex === this.paths.length - 1) {
      return;
    }
    this.currentPaintIndex++;
    this.drawInit(this.paths[this.currentPaintIndex].type, this.paths[this.currentPaintIndex].size);
    this.context.stroke(this.paths[this.currentPaintIndex].path);
  }

  drawInit(type: PaintType, size: number) {
    this.context.globalCompositeOperation = type === PaintType.Erase ? 'destination-out' : 'source-over';
    this.context.lineJoin = 'round';
    this.context.lineCap = 'round';
    this.context.lineWidth = size;

    if (type === PaintType.Erase) {
      this.context.strokeStyle = 0;
    } else if (type === PaintType.Mosaic) {
      if (this.cacheBitmap === undefined && this.mosaicController.getMosaicImg()) {
        this.cacheBitmap = new ImageBitmap(this.mosaicController.getMosaicImg()!);
        const pattern = this.context.createPattern(this.cacheBitmap, 'no-repeat');
        const matrix: Matrix2D = new Matrix2D();
        matrix.scaleY = SCALE_RATIO;
        matrix.scaleX = SCALE_RATIO;
        pattern?.setTransform?.(matrix);
        pattern && this.patterns.set(PaintType.Mosaic, pattern);
      }
      this.context.strokeStyle = this.patterns.get(PaintType.Mosaic) || 0;
    } else {
      if (this.patterns.has(type)) {
        this.context.strokeStyle = this.patterns.get(type)!;
      } else {
        if (this.mosaicController.getPathBg(type).code !== 0) {
          const bitmap = new ImageBitmap(this.mosaicController.getPathBg(type).data!);
          this.context.strokeStyle = this.context.createPattern(bitmap, 'repeat')!;
        }
      }
    }
  }

  drawStart(x: number, y: number) {
    this.drawInit(this.type, this.size);
    this.drawStarted = true;
  }

  draw(x: number, y: number) {
    if (!this.currentPath) {
      this.currentPath = new Path2D();
      this.currentPath.moveTo(x, y);
      this.currentData = {
        size: this.size,
        type: this.type,
        path: this.currentPath,
      };
    }
    this.currentPath.lineTo(x, y);
    if (!this.drawStarted || !this.currentPath || !this.currentData) {
      return;
    }
    // 确认触发绘制手势 而非放大缩小后，再开始绘制，前置只记录绘制的path
    this.context.stroke(this.currentPath);
    // 在入栈前 如果当前index 不是最后一个路径，需要将后续路径删除
    if (this.currentPaintIndex !== this.paths.length - 1) {
      HiLog.i(TAG, `paintIndex: ${this.currentPaintIndex} pathsLen: ${this.paths.length}`);
      this.paths = this.paths.slice(0, this.currentPaintIndex + 1);
    }
    if (this.paths[this.paths.length - 1] !== this.currentData) {
      this.currentPaintIndex++;
      this.paths.push(this.currentData);
    }
  }

  drawEnd() {
    this.currentPath = null;
    this.currentData = null;
    this.drawStarted = false;
  }
}