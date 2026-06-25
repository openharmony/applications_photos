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
/**
 * @file Defines the capabilities of HDS Visual Component
 * @kit UIDesignKit
 */
import { hdsEffect } from '@ohos.hds.hdsBaseComponent';
/**
 * Declare scene types for harmony OS visual effect
 *
 * @enum { number }
 * @syscap SystemCapability.UIDesign.HDSComponent.Core
 * @since 6.0.0(20)
 */
export declare enum HdsSceneType {
    /**
     * The scenario for dual edge flow light with background mask
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @since 6.0.0(20)
     */
    DUAL_EDGE_FLOW_LIGHT_WITH_BACKGROUND_MASK = 0,
    /**
     * The start ID for system scenes, for system scenes that not for 2D, start after this
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    SYSTEM_SCENE_TYPE_START_INVALID = 10000,
    /**
     * The scenario for edge flowlight pushtotalk scene
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    EDGE_FLOWLIGHT_PUSH_TO_TALK_SCENE = 10001,
    /**
     * The scenario for edge flowlight capsule scene
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    EDGE_FLOWLIGHT_CAPSULE_SCENE = 10002,
    /**
     * The scenario for diagonal flowlight scene.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    EDGE_FLOWLIGHT_DIAGONAL_SCENE = 10003,
    /**
     * The scenario for hookline flowlight scene.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    EDGE_FLOWLIGHT_HOOKLINE_SCENE = 10004,
    /**
     * The scenario for keyboard uv flowlight in light mode.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    UV_FLOWLIGHT_KEYBOARD_LIGHT = 10010,
    /**
     * The scenario for keyboard uv flowlight in dark mode.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    UV_FLOWLIGHT_KEYBOARD_DARK = 10011,
    /**
     * The scenario for card uv in light mode.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    UV_FLOWLIGHT_CARD_LIGHT = 10012,
    /**
     * The scenario for card uv in dark mode.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    UV_FLOWLIGHT_CARD_DARK = 10013,
    /**
     * The scenario for spreading ripple scene.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    UV_FLOWLIGHT_SPREADING_RIPPLE = 10014,
    /**
     * The scenario for capsule uv flowlight.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    UV_FLOWLIGHT_CAPSULE = 10015,
    /**
     * The scenario for ai bar flowlight.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    UV_FLOWLIGHT_AI_BAR = 10016,
    /**
     * The scenario for spreading ripple with mask scene.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    UV_FLOWLIGHT_SPREADING_RIPPLE_WITH_MASK = 10017,
    /**
     * The scenario for normal uv flowlight with mask scene.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    UV_FLOWLIGHT_NORMAL_WITH_MASK = 10018,
    /**
     * The scenario for polaris flowlight with mask scene.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    UV_FLOWLIGHT_POLARIS_WITH_MASK = 10019,
    /**
     * The scenario for polaris flowlight with edge light scene.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    UV_FLOWLIGHT_POLARIS_WITH_EDGE_LIGHT = 10020,
    /**
     * The scenario for polaris flowlight scene.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    UV_FLOWLIGHT_POLARIS = 10021,
    /**
     * The scenario for spreading ripple with distort scene.
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    DOUBLE_SPREADING_RIPPLE_WITH_DISTORT = 10030
}
/**
 * Declare effect animation type
 *
 * @enum { number }
 * @syscap SystemCapability.UIDesign.HDSComponent.Core
 * @systemapi
 * @since 6.0.0(20)
 */
export declare enum HdsEffectAnimationType {
    /**
     * continue current animation
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    CONTINUE_ANIMATION = 0,
    /**
     * start new animation
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    START_NEW_ANIMATION = 1
}
/**
 * Defines the effect(animation) controller
 *
 * @syscap SystemCapability.UIDesign.HDSComponent.Core
 * @systemapi
 * @since 6.0.0(20)
 */
export class HdsEffectController {
    /**
     * constructor
     *
     * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    constructor();
    /**
     * set the Params of effect animation
     *
     * @param { Map<string, Array<number> |  Array<string>> } map - set the params for
     * the effect(shader) string or number array
     * @param { HdsEffectAnimationType } [animationType] - indicate HdsEffectAnimationType
     * @returns { HdsEffectController } The HdsEffectController
     * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    setEffectParams(map: Map<string, Array<number> | Array<string>>,
        animationType?: HdsEffectAnimationType): HdsEffectController;
}
/**
 * function for scene animation finish call back;
 *
 * @typedef { function } HdsSceneFinishCallback
 * @syscap SystemCapability.UIDesign.HDSComponent.Core
 * @since 6.0.0(20)
 */
declare type HdsSceneFinishCallback = () => void;
/**
 * rovides the definition of DualEdgeFlowLightWithMaskParam.
 *
 * @typedef DualEdgeFlowLightWithMaskParam
 * @syscap SystemCapability.UIDesign.HDSComponent.Core
 * @since 6.0.0(20)
 */
export declare interface DualEdgeFlowLightWithMaskParam {
    /**
     * Indicates backgroundMask Colors.
     *
     * @type { Array<ResourceColor> }
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @since 6.0.0(20)
     */
    backgroundMaskColors: Array<ResourceColor>;
    /**
     * Indicates firstEdgeFlowLight Param.
     *
     * @type { hdsEffect.EdgeFlowLightParam }
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @since 6.0.0(20)
     */
    firstEdgeFlowLight: hdsEffect.EdgeFlowLightParam;
    /**
     * Indicates secondEdgeFlowLight Param.
     *
     * @type { hdsEffect.EdgeFlowLightParam }
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @since 6.0.0(20)
     */
    secondEdgeFlowLight: hdsEffect.EdgeFlowLightParam;
}
/**
 * Scene Params for SceneType
 *
 * @typedef { DualEdgeFlowLightWithMaskParam } SceneParams
 * @syscap SystemCapability.UIDesign.HDSComponent.Core
 * @since 6.0.0(20)
 */
declare type SceneParams = DualEdgeFlowLightWithMaskParam;
/**
 * Defines the scene controller
 *
 * @syscap SystemCapability.UIDesign.HDSComponent.Core
 * @since 6.0.0(20)
 */
export class HdsSceneController {
    /**
     * constructor
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @since 6.0.0(20)
     */
    constructor();
    /**
     * start the scene animation
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @since 6.0.0(20)
     */
    start(): void;
    /**
     * pause the scene animation
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @since 6.0.0(20)
     */
    pause(): void;
    /**
     * resume the scene animation
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @since 6.0.0(20)
     */
    resume(): void;
    /**
     * stop the scene animation
     *
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @since 6.0.0(20)
     */
    stop(): void;
    /**
     * go to specific effects
     *
     * @param { number } order - the order value of effects
     * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    goToEffects(order: number): void;
    /**
     * set the scene Parameters
     *
     * @param { Map<string, Object> } map - the input parameter for this scene, refer the corresponding HdsSceneType for
     * detail map information, refer the specific scene in HdsSceneType for detail of the scene parameters
     * @returns { HdsSceneController } The HdsSceneController
     * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    setSceneParams(map: Map<string, Object>): HdsSceneController;
    /**
     * set the scene Parameters
     *
     * @param { SceneParams } params - the input parameter for this scene
     * @returns { HdsSceneController } The HdsSceneController
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @since 6.0.0(20)
     */
    setSceneParams(params: SceneParams): HdsSceneController;
    /**
     * set the EffectType and EffectController
     *
     * @param { hdsEffect.EffectType } effectType - the effectType
     * @param { HdsEffectController } controller - the controller for this effectType
     * @returns { HdsSceneController } The HdsSceneController
     * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    setEffectController(effectType: hdsEffect.EffectType, controller: HdsEffectController): HdsSceneController;
    /**
     * set the effect finish callbacks
     *
     * @param { hdsEffect.EffectType } effectType - the effectType
     * @param { hdsEffect.OnFinishCallback } finishCallBack - the finish callback for this effect
     * @returns { HdsSceneController } The HdsSceneController
     * @throws { BusinessError } 202 - Non-system applications are not allowed to use system APIs
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @systemapi
     * @since 6.0.0(20)
     */
    setEffectCallback(effectType: hdsEffect.EffectType, finishCallBack: hdsEffect.OnFinishCallback): HdsSceneController;
}
/**
 * Defines the hds visual component attribute functions
 *
 * @extends CommonMethod<HdsVisualComponentAttribute>
 * @syscap SystemCapability.UIDesign.HDSComponent.Core
 * @since 6.0.0(20)
 */
export declare class HdsVisualComponentAttribute extends CommonMethod<HdsVisualComponentAttribute> {
    /**
     * Called to set the scenes with related parameters, all effect will run parallel in this mode
     *
     * @param { HdsSceneType } sceneType - set the scene type
     * @param { HdsSceneController } controller - scene controller
     * @param { HdsSceneFinishCallback} [callback] - callback when scene finished
     * @param { hdsEffect.ExpectedFrameRateRange} [frameRateRange] - expected FrameRateRange
     * @returns { HdsVisualComponentAttribute }
     * @syscap SystemCapability.UIDesign.HDSComponent.Core
     * @since 6.0.0(20)
     */
    scene(sceneType: HdsSceneType, controller: HdsSceneController, callback?: HdsSceneFinishCallback,
        frameRateRange?: hdsEffect.ExpectedFrameRateRange): HdsVisualComponentAttribute;
}
/**
 * Defines the Hds Visual Component interface
 *
 * @typedef { function } HdsVisualComponentInterface
 * @returns { HdsVisualComponentAttribute } Returns the instance of the HdsVisualComponentAttribute.
 * @syscap SystemCapability.UIDesign.HDSComponent.Core
 * @since 6.0.0(20)
 */
declare type HdsVisualComponentInterface = () => HdsVisualComponentAttribute;
/**
 * Defines hds visual component
 *
 * @type { HdsVisualComponentInterface }
 * @syscap SystemCapability.UIDesign.HDSComponent.Core
 * @uicomponent
 * @since 6.0.0(20)
 */
export declare const HdsVisualComponent: HdsVisualComponentInterface;
/**
 * Defines hds visual component instance
 *
 * @type { HdsVisualComponentAttribute }
 * @syscap SystemCapability.UIDesign.HDSComponent.Core
 * @since 6.0.0(20)
 */
export declare const HdsVisualComponentInstance: HdsVisualComponentAttribute;
