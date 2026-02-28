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
import lazy { PayloadData } from '@ohos/dataprovider/src/main/ets/database/service/PhotoProcessHandler';
import lazy { WidgetCardView } from 'facard/src/main/ets/formability/view/WidgetCardView';
import lazy { WidgetCardViewModel } from 'facard/src/main/ets/formability/view/WidgetCardViewModel';

/* instrument ignore file */
const TAG: string = 'WidgetCard2x4';

let storage = new LocalStorage();

@Entry(storage)
@Component
struct WidgetCard {
  @LocalStorageProp('agendaObjList') @Watch('onAgendaObjListChange') agendaObjList: Array<PayloadData> = [];
  @LocalStorageProp('formId') @Watch('formIdChange') formId: string = '';
  @State widgetCardViewModel: WidgetCardViewModel = new WidgetCardViewModel(this, TAG);

  aboutToAppear(): void {
    this.widgetCardViewModel.aboutToAppear();
  }

  aboutToDisappear(): void {
    this.widgetCardViewModel.aboutToDisappear();
  }

  onAgendaObjListChange(): void {
    this.widgetCardViewModel.onAgendaObjListChange(this.agendaObjList, true);
  }

  formIdChange(): void {
    this.widgetCardViewModel.formIdChange(this.formId);
  }

  build() {
    Stack() {
      WidgetCardView({
        cardType: TAG,
        widgetCardViewModel: this.widgetCardViewModel
      })
    }
  }
}
