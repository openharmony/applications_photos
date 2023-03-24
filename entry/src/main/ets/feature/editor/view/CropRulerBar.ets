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

import { Broadcast } from '@ohos/base/src/main/ets/utils/Broadcast';
import { Constants } from '../../../common/model/common/Constants';

@Component
export struct CropRulerBar {
    @Consume broadCast: Broadcast;
    @Consume('verticalScreen') isVerticalScreen: boolean;
    @Consume screenWidth: number;
    @Consume screenHeight: number;
    private current_def: number = 0;
    private startPos: number = 0;
    @State cWidth: number = 220;
    @State cHeight: number = 60;
    private setting: RenderingContextSettings = new RenderingContextSettings(true);
    private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setting);
    private resetClicked: any = undefined;
    private previous: number = 0;
    private rulerLength: number = 0;
    private rulerWidth: number = 0;

    iniSize() {
        if (this.isVerticalScreen) {
            this.cWidth = this.screenWidth - Constants.PADDING_HORIZONTAL;
            this.cHeight = Constants.LITTLE_CANVAS_SIZE;
            this.rulerLength = this.cWidth
            this.rulerWidth = this.cHeight
        } else {
            this.cWidth = Constants.LITTLE_CANVAS_SIZE;
            this.cHeight = (this.screenWidth - this.screenWidth % Constants.NUMBER_20) - Constants.PADDING_HORIZONTAL;
            this.rulerLength = this.cHeight
            this.rulerWidth = this.cWidth
        }
    }

    multiScreenAdaptation() {
        if (vp2px(Constants.NUMBER_1) == Constants.NUMBER_1) {
            this.context.font = Constants.RULER_CONTEXT_FONT_10PX
        } else if (vp2px(Constants.NUMBER_1) == Constants.NUMBER_2) {
            this.context.font = Constants.RULER_CONTEXT_FONT_20PX
        } else if (vp2px(Constants.NUMBER_1) == Constants.NUMBER_3) {
            this.context.font = Constants.RULER_CONTEXT_FONT_30PX
        } else {
            this.context.font = Constants.RULER_CONTEXT_FONT_20PX
        }
    }

    drawMidLine() {
        const mid_x = Math.floor(this.rulerLength / Constants.NUMBER_2);
        this.context.beginPath();
        this.context.fillStyle = Constants.RULER_FILL_STYLE_100;
        if (this.isVerticalScreen) {
            this.context.fillRect(mid_x - Constants.MID_LINE_WIDTH / 2, this.rulerWidth * Constants.NUMBER_8 / Constants.NUMBER_15,
                Constants.MID_LINE_WIDTH, Constants.MID_LINE_HEIGHT);
        } else {
            this.context.fillRect(this.rulerWidth * Constants.NUMBER_7_5 / Constants.NUMBER_15, mid_x - Constants.MID_LINE_WIDTH / 2,
                Constants.MID_LINE_HEIGHT, Constants.MID_LINE_WIDTH);
        }
        this.context.stroke();
        this.context.closePath();
    }

    drawIntegerLine(cur_x: number, cur_num: number) {
        if (this.isVerticalScreen) {
            this.context.moveTo(cur_x, (this.rulerWidth * Constants.NUMBER_8_5) / Constants.NUMBER_15);
        } else {
            this.context.moveTo((this.rulerWidth * Constants.NUMBER_8) / Constants.NUMBER_15, cur_x);
        }

        if (Math.abs(cur_num) > Constants.EDGE_ANGLE) {
            this.context.strokeStyle = Constants.RULER_FILL_STYLE_40;
            this.context.shadowColor = Constants.RULER_FILL_STYLE_40;
        } else {
            this.context.strokeStyle = Constants.RULER_FILL_STYLE_90;
            this.context.shadowColor = Constants.RULER_FILL_STYLE_90;
        }
        this.context.shadowBlur = Constants.RULER_LINE_WIDTH
        if (Math.round(cur_num) == Math.round(this.current_def)) {
            if (this.isVerticalScreen) {
                this.context.fillText(this.integerAngleToString(Math.round(cur_num)), cur_x,
                    (this.rulerWidth * Constants.NUMBER_6) / Constants.NUMBER_15);
            } else {
                this.context.fillText(this.integerAngleToString(Math.round(cur_num)),
                    (this.rulerWidth * Constants.NUMBER_6_5) / Constants.NUMBER_15, cur_x);
            }
        } else {
            if (this.isVerticalScreen) {
                this.context.fillText(cur_num.toString(), cur_x,
                    (this.rulerWidth * Constants.NUMBER_6) / Constants.NUMBER_15);
            } else {
                this.context.fillText(cur_num.toString(),
                    (this.rulerWidth * Constants.NUMBER_6_5) / Constants.NUMBER_15, cur_x);
            }
        }
        if (this.isVerticalScreen) {
            this.context.lineTo(cur_x, this.rulerWidth * Constants.NUMBER_10_5 / Constants.NUMBER_15);
        } else {
            this.context.lineTo(this.rulerWidth * Constants.NUMBER_10 / Constants.NUMBER_15, cur_x);
        }

    }

    drawLine() {
        let begin_num = this.current_def - (this.rulerLength / Constants.NUMBER_2) / Constants.NUMBER_5;
        let cur_x = 0;
        let cur_num = 0;
        const scale_len = Math.ceil((this.rulerLength) / Constants.NUMBER_5) + Constants.NUMBER_1;
        for (let i = 0; i < scale_len; i++) {
            cur_num = begin_num + i;
            this.context.beginPath();
            this.multiScreenAdaptation()
            this.context.textAlign = 'center';
            if (!this.isVerticalScreen) {
                this.context.textAlign = 'end';
                this.context.textBaseline = 'middle'
            }
            if (Math.abs(cur_num) > Constants.EDGE_ANGLE) {
                this.context.strokeStyle = Constants.RULER_FILL_STYLE_40;
                this.context.fillStyle = Constants.RULER_FILL_STYLE_40;
            } else {
                this.context.strokeStyle = Constants.RULER_FILL_STYLE_90;
                this.context.fillStyle = Constants.RULER_FILL_STYLE_90;
            }
            this.context.shadowBlur = 0;
            cur_x = i * Constants.NUMBER_5
            if (cur_x == 0 || cur_x == this.rulerLength) {
                this.context.lineWidth = (Constants.RULER_LINE_WIDTH / Constants.NUMBER_2);
                if (cur_x < 0) {
                    cur_x = 0;
                }
            } else {
                this.context.lineWidth = Constants.RULER_LINE_WIDTH;
            }
            if (Math.abs(cur_num) % Constants.NUMBER_10 === 0) {
                this.drawIntegerLine(cur_x, cur_num)
            } else {
                if (this.isVerticalScreen) {
                    this.context.moveTo(cur_x, (this.rulerWidth * Constants.NUMBER_9_5) / Constants.NUMBER_15);
                    this.context.lineTo(cur_x, this.rulerWidth * Constants.NUMBER_10_5 / Constants.NUMBER_15);
                } else {
                    this.context.moveTo((this.rulerWidth * Constants.NUMBER_9) / Constants.NUMBER_15, cur_x);
                    this.context.lineTo(this.rulerWidth * Constants.NUMBER_10 / Constants.NUMBER_15, cur_x);
                }
            }
            this.context.stroke();
            this.context.closePath();
        }
    }

    onTouchEvent(event: TouchEvent) {
        if (event.type == TouchType.Down) {
            if (this.isVerticalScreen) {
                this.startPos = (event.touches[0].x);
            } else {
                this.startPos = (event.touches[0].y);
            }
            this.previous = new Date().getTime();
        }

        if (event.type == TouchType.Move) {
            let now = new Date().getTime();
            if (now - this.previous >= Constants.TIMEOUT) {
                this.previous = now;
            } else {
                return;
            }

            let dir = this.isVerticalScreen ? this.startPos - (event.touches[0].x) :
                this.startPos - (event.touches[0].y);
            if (Math.abs(dir / Constants.NUMBER_5) >= Constants.NUMBER_1) {
                this.current_def += parseInt((dir / Constants.NUMBER_5).toFixed(0));
                this.startPos = this.isVerticalScreen ? (event.touches[0].x) : (event.touches[0].y)
                if (Math.abs(this.current_def) > Constants.EDGE_ANGLE) {
                    this.current_def = this.current_def > Constants.EDGE_ANGLE ?
                        Constants.EDGE_ANGLE : -Constants.EDGE_ANGLE;
                }

                this.drawRuler();
                this.broadCast.emit(Constants.RULER_CHANGED, [this.current_def]);
            }
        }
    }

    onResetClicked() {
        this.current_def = 0;
        this.drawRuler();
    }

    integerAngleToString(currentAngle: number): string {
        switch (currentAngle) {
            case -Constants.NUMBER_40:
                return Constants.NEGATIVE_FORTY;
            case -Constants.NUMBER_30:
                return Constants.NEGATIVE_THIRTY;
            case -Constants.NUMBER_20:
                return Constants.NEGATIVE_TWENTY;
            case -Constants.NUMBER_10:
                return Constants.NEGATIVE_TEN;
            case Constants.NUMBER_0:
                return Constants.ZERO_STR;
            case Constants.NUMBER_10:
                return Constants.POSITIVE_TEN;
            case Constants.NUMBER_20:
                return Constants.POSITIVE_TWENTY;
            case Constants.NUMBER_30:
                return Constants.POSITIVE_THIRTY;
            case Constants.NUMBER_40:
                return Constants.POSITIVE_FORTY;
            default:
                break;
        }
    }

    aboutToAppear() {
        this.resetClicked = this.onResetClicked.bind(this);
        this.broadCast.on(Constants.CROP_RESET_CLICKED, this.resetClicked);
        this.iniSize()
    }

    drawRuler() {
        this.context.clearRect(0, 0, this.cWidth, this.cHeight);
        this.drawMidLine()
        this.drawLine()
    }

    aboutToDisappear() {
        this.broadCast.off(Constants.CROP_RESET_CLICKED, this.resetClicked);
    }

    build() {
        Flex({
            direction: this.isVerticalScreen ? FlexDirection.Column : FlexDirection.Row,
            alignItems: ItemAlign.Center,
            justifyContent: FlexAlign.Center
        }) {
            Canvas(this.context)
                .width(this.cWidth)
                .height(this.cHeight)
                .onReady(() => {
                    this.drawRuler()
                })
        }
        .onTouch((event) => {
            this.onTouchEvent(event);
        })
    }
}
