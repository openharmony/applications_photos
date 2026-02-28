import { image } from '@kit.ImageKit';
import { RectValue } from './EditorSDK';

/* instrument ignore file */
@Observed
export class IEditor {
  public editModified: boolean = false; // 当前编辑器是否修改了图片
  public isEditorContextReseting = false; //当前编辑器是是否在进行setSource
  init(): void {
  };

  close(callback: (res: number) => void): void {
  };

  pause(): void {
  };

  resume(): void {
  };

  setInputData(data: image.PixelMap): void {
  };

  getExportData(callback: Function, options?: GetExportDataOptions): void {
  };

  resetData(cb: Function): void {
  };

  undo(): void {
  };

  redo(): void {
  };

  isEdited(): boolean {
    return false
  };

  getCurPreviewRect(): RectValue {
    return new RectValue(0, 0, 0, 0)
  };

  switchStylusMode(reportNum?: number): void {
  };
}

export class GetExportDataOptions {
  private isToAiPage: boolean = false;
  private isOriginColor: boolean = false;
  private needAddWatermark: boolean = false;
  private isSave: boolean = false;
  private sourceFlow: SourceFlowType = SourceFlowType.None;

  public getIsToAiPage(): boolean {
    return this.isToAiPage;
  }

  public setIsToAiPage(isToAiPage: boolean): GetExportDataOptions {
    this.isToAiPage = isToAiPage;
    return this;
  }

  public getIsOriginColor(): boolean {
    return this.isOriginColor;
  }

  public setIsOriginColor(isOriginColor: boolean): GetExportDataOptions {
    this.isOriginColor = isOriginColor;
    return this;
  }

  public getNeedAddWatermark(): boolean {
    return this.needAddWatermark;
  }

  public setNeedAddWatermark(needAddWatermark: boolean): GetExportDataOptions {
    this.needAddWatermark = needAddWatermark;
    return this;
  }

  public getIsSave(): boolean {
    return this.isSave;
  }

  public setIsSave(isSave: boolean): GetExportDataOptions {
    this.isSave = isSave;
    return this;
  }

  public setSourceFlow(sourceFlow: SourceFlowType): GetExportDataOptions {
    this.sourceFlow = sourceFlow;
    return this;
  }

  public getSourceFlow(): SourceFlowType {
    return this.sourceFlow;
  }
}

export enum SourceFlowType {
  None = 0,
  Ai2Base = 1,
  Base2Ai = 2
}