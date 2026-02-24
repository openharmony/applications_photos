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

#ifndef OH_FRICTIONMOTION_H
#define OH_FRICTIONMOTION_H

#include <string>

constexpr float DEFAULT_MULTIPLIER = 60.0f;

class FrictionMotion {
public:
    static FrictionMotion *GetInstance();

public:
    // Called when do a new friction motion
    void Reset(double friction, double initPosition, double initVelocity, double threshold = DEFAULT_MULTIPLIER);

    double GetCurrentPosition();
    double GetCurrentVelocity();
    bool IsCompleted();

    double GetVelocityByFinalPosition(double final, double threshold = DEFAULT_MULTIPLIER) const;
    // Get the Position and Velocity by offsetTime(Unit:millisecond).
    double GetPosition(double offsetTime) const;
    double GetVelocity(double offsetTime) const;

    // Trigger motion in each vsync timestamp(Unit:millisecond).
    void Move(float offsetTime);

    double GetFinalPosition() const;
    bool GetTimeByPosition(double position, double &time) const;

    double GetFinalTime() const;

    std::string GetMotionType() const;

private:
    FrictionMotion() = default;
    ~FrictionMotion() = default;

    bool IsValid(double friction) const;

    inline bool NearZero(double number) const
    {
        return std::fabs(number) < 1e-6;
    }

    inline bool NearZero(double number, double threshold) const
    {
        return number < threshold;
    }

    inline bool GreatNotEqual(double num1, double num2) const
    {
        return num1 > num2;
    }

    inline bool NearEqual(double num1, double num2, double accuracy) const
    {
        return std::fabs(num1 - num2) < accuracy;
    }

private:
    double m_friction{ 1.0 };
    double m_initVelocity{ 0.0 };
    double m_signum{ 0.0 }; // Rules: V < 0 [-1], V = 0 [0], V > 0 [1].
    double m_currentTime{ 0.0 };
    double m_valueThreshold{ 0.0 };
    double m_velocityThreshold{ 0.0 };
    double m_finalTime{ 0.0 };
    double m_finalPosition{ 0.0 };
    double m_initPosition{ 0.0 };

    static FrictionMotion *m_instance;
};

#endif // OH_FRICTIONMOTION_H
