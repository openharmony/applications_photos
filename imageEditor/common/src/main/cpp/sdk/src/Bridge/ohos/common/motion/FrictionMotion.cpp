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

#include "FrictionMotion.h"
#include "HmcBase.h"

constexpr float UNIT_CONVERT = 1000.0f;
constexpr float FRICTION_SCALE = -4.2f;
constexpr float DEFAULT_THRESHOLD = 0.75f;

static std::once_flag g_frictionMotionInitFlag;

FrictionMotion *FrictionMotion::m_instance = nullptr;

FrictionMotion *FrictionMotion::GetInstance()
{
    std::call_once(g_frictionMotionInitFlag, [] { m_instance = new FrictionMotion(); });
    return m_instance;
}

void FrictionMotion::Reset(double friction, double initPosition, double initVelocity, double threshold)
{
    if (!IsValid(friction)) {
        return;
    }
    m_friction = friction * FRICTION_SCALE;
    m_initVelocity = std::abs(initVelocity);
    m_currentTime = 0.0;
    m_initPosition = initPosition;
    m_valueThreshold = DEFAULT_THRESHOLD;
    m_velocityThreshold = m_valueThreshold * threshold;

    if (NearZero(m_initVelocity)) {
        m_signum = 0.0;
        m_finalTime = 0.0;
    } else {
        m_signum = GreatNotEqual(initVelocity, 0.0) ? 1.0 : -1.0;
        m_finalTime = UNIT_CONVERT * std::log(m_velocityThreshold / m_initVelocity) / m_friction;
    }
    m_finalTime = std::max(m_finalTime, 0.0);
    m_finalPosition = GetPosition(m_finalTime / UNIT_CONVERT);
    LOGI("[FrictionMotion]Reset success, finalTime=%lf, finalPosition=%lf", m_finalTime, m_finalPosition);
}

void FrictionMotion::Move(float offsetTime)
{
    // change millisecond to second.
    m_currentTime = offsetTime / UNIT_CONVERT;
}

double FrictionMotion::GetPosition(double offsetTime) const
{
    double time = offsetTime / UNIT_CONVERT;
    return m_initPosition + m_signum * (m_initVelocity / m_friction) * std::expm1(m_friction * time);
}

double FrictionMotion::GetVelocityByFinalPosition(double final, double threshold) const
{
    return m_valueThreshold * threshold * m_signum - (final - m_initPosition) * m_friction;
}

double FrictionMotion::GetVelocity(double offsetTime) const
{
    double time = offsetTime / UNIT_CONVERT;
    return m_signum * m_initVelocity * std::exp(m_friction * time);
}

double FrictionMotion::GetCurrentPosition()
{
    return GetPosition(m_currentTime);
}

double FrictionMotion::GetCurrentVelocity()
{
    return GetVelocity(m_currentTime);
}

bool FrictionMotion::IsCompleted()
{
    return NearZero(GetCurrentVelocity(), m_velocityThreshold) || NearEqual(m_finalPosition, GetCurrentPosition(), 1.0);
}

double FrictionMotion::GetFinalPosition() const
{
    return m_finalPosition;
}

bool FrictionMotion::GetTimeByPosition(double position, double &time) const
{
    time = 0.0;
    if (NearZero(m_initVelocity)) {
        return false;
    }

    double rangeStart = 0.0;
    double rangeEnd = m_finalPosition;
    if (m_finalPosition < 0.0) {
        rangeStart = m_finalPosition;
        rangeEnd = 0.0;
    }
    if (position < rangeStart || position > rangeEnd) {
        return false;
    }
    // Deduced by formula of Func(GetPosition)
    time = std::log(position * m_friction / m_initVelocity + 1.0) / m_friction;
    return true;
}

double FrictionMotion::GetFinalTime() const
{
    return m_finalTime;
}

std::string FrictionMotion::GetMotionType() const
{
    return "friction";
}

bool FrictionMotion::IsValid(double friction) const
{
    if (friction < 0.0 || NearZero(friction)) {
        LOGE("[FrictionMotion]Invalid friction:%{public}lf.", friction);
        return false;
    }
    return true;
}
