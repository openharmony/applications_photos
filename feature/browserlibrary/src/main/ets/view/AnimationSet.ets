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

import lazy { AnimatorResult } from '@ohos.animator';

/**
 * AnimationSet
 */
export class AnimationSet {
  private animationList: AnimatorResult[] = [];
  private currentIndex: number = 0;
  private isSequent: boolean = true; // true 顺序播放动画,false 同时播放动画
  private isStop: boolean = false;

  setSequent(isSequent: boolean) {
    this.isSequent = isSequent;
  }

  stop() {
    this.isStop = true;
    this.animationList.forEach(anim => {
      anim.cancel();
    })
  }

  addAnimation(animator: AnimatorResult, finishCallback?: () => void) {
    animator.onfinish = () => {
      finishCallback?.();
      this.onFinish();
    };
    this.animationList.push(animator);
  }

  play() {
    if (this.isStop) {
      return;
    }

    if (!this.isSequent) {
      this.animationList.forEach(animation => {
        animation.play();
      })
    } else {
      if (this.currentIndex < this.animationList.length) {
        this.animationList[this.currentIndex].play();
        this.currentIndex++;
      } else {
        this.currentIndex = 0;
      }
    }
  }

  loopAnimation(delay?: number) {
    if (delay && delay > 0) {
      setTimeout((): void => {
        this.play();
      }, delay);
    } else {
      this.play();
    }
  }

  private onFinish() {
    if (this.isSequent) {
      this.play();
    }
  }
}