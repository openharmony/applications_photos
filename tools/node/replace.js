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
const fs = require('fs');
const x = require('./src/utils/xport');
const { isInList } = require('./src/utils/xport');

exports.project = project;
exports.batch = batch;
exports.single = single;

function project(path, parameters, suffix = 'ts', blacklist = [], isSeek) {
    walk(
        path,
        function (err, results) {
            if (err) {
                throw err;
            }
            results.forEach((filename) => {
                if (isInList(blacklist, filename)) {
                    return;
                }
                batch(filename, parameters, suffix);
            });
        },
        suffix
    );
}

function batch(path, parameters) {
    parameters.forEach((p) => {
        single(path, p);
    });
}

function single(path, parameter) {
    const text = fs.readFileSync(path, 'utf8');
    if (!text.match(parameter.regular) || !parameter.problem) {
        // x.z(text.slice(0, 50), parameter.problem)
        return;
    }
    const rep = (text) => text.replace(parameter.regular, parameter.newText);
    fs.writeFileSync(x.c(path), rep(text), 'utf8');
    console.log('problem: ' + parameter.problem);
    text
        .match(parameter.regular)
        .slice(0, 10)
        .map((v) => [x.c(v), x.c(rep(v))]);
}
