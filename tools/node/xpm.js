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

'use strict';
Error.stackTraceLimit = 100;
const x = require('./src/utils/xport');

const replace = require('./replace');

const parameter = {};
parameter.problem = 'xpm_mode n->0';
parameter.regular = /xpm_mode \d"/;
parameter.newText = 'xpm_mode 0"';
replace.single('./key_enable.cfg', parameter);
x.z(11);
x.z(replace.single);
