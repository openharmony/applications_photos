import AbilityStage from "@ohos.application.AbilityStage"

export default class PhotosAbilityStage extends AbilityStage {
    onCreate() {
        globalThis.photosGlobalContext = this.context;
    }
}