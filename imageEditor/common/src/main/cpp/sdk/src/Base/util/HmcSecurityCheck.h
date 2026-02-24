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

#ifndef oh_HmcSecurityCheck_H
#define oh_HmcSecurityCheck_H

#define INVALID_POINT_CHECK_WITHOUT_RETURNCODE(p) \
    {                                             \
        if ((p) == nullptr) {                     \
            LOGE("%s is nullptr", #p);            \
            return;                               \
        }                                         \
    }

#define INVALID_POINT2_CHECK_WITHOUT_RETURNCODE(p1, p2) \
    INVALID_POINT_CHECK_WITHOUT_RETURNCODE(p1)          \
    INVALID_POINT_CHECK_WITHOUT_RETURNCODE(p2)

#define INVALID_POINT3_CHECK_WITHOUT_RETURNCODE(p1, p2, p3) \
    INVALID_POINT_CHECK_WITHOUT_RETURNCODE(p1)              \
    INVALID_POINT_CHECK_WITHOUT_RETURNCODE(p2)              \
    INVALID_POINT_CHECK_WITHOUT_RETURNCODE(p3)

#define INVALID_POINT4_CHECK_WITHOUT_RETURNCODE(p1, p2, p3, p4) \
    INVALID_POINT_CHECK_WITHOUT_RETURNCODE(p1)                  \
    INVALID_POINT_CHECK_WITHOUT_RETURNCODE(p2)                  \
    INVALID_POINT_CHECK_WITHOUT_RETURNCODE(p3)                  \
    INVALID_POINT_CHECK_WITHOUT_RETURNCODE(p4)

#define INVALID_POINT_CHECK_WITH_RETURNCODE(p, retcode) \
    {                                                   \
        if ((p) == nullptr) {                           \
            LOGE("%s is nullptr", #p);                  \
            return retcode;                             \
        }                                               \
    }

#define INVALID_POINT2_CHECK_WITH_RETURNCODE(p1, p2, retcode) \
    INVALID_POINT_CHECK_WITH_RETURNCODE(p1, retcode)          \
    INVALID_POINT_CHECK_WITH_RETURNCODE(p2, retcode)

#define INVALID_POINT3_CHECK_WITH_RETURNCODE(p1, p2, p3, retcode) \
    INVALID_POINT_CHECK_WITH_RETURNCODE(p1, retcode)              \
    INVALID_POINT_CHECK_WITH_RETURNCODE(p2, retcode)              \
    INVALID_POINT_CHECK_WITH_RETURNCODE(p3, retcode)

#define INVALID_POINT4_CHECK_WITH_RETURNCODE(p1, p2, p3, p4, retcode) \
    INVALID_POINT_CHECK_WITH_RETURNCODE(p1, retcode)                  \
    INVALID_POINT_CHECK_WITH_RETURNCODE(p2, retcode)                  \
    INVALID_POINT_CHECK_WITH_RETURNCODE(p3, retcode)                  \
    INVALID_POINT_CHECK_WITH_RETURNCODE(p4, retcode)

#endif // oh_HmcSecurityCheck_H
