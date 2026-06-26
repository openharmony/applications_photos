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
#include <memory>
#include <cstring>
#include "HmcJpegMetadata.h"

HmcJpegMetadataDict::HmcJpegMetadataDict() {}

HmcJpegMetadataDict::~HmcJpegMetadataDict() {}

int HmcJpegMetadataDict::FromAVDictionary()
{
    return 0;
}

// IFD 0 data
int HmcJpegMetadataDict::GetWidth(UINT32 &width) const
{
    width = m_IFD0Entry.width;
    return 0;
}

int HmcJpegMetadataDict::GetHeight(UINT32 &height) const
{
    height = m_IFD0Entry.height;
    return 0;
}

int HmcJpegMetadataDict::GetOrientation(UINT32 &orientation) const
{
    orientation = m_IFD0Entry.orientation;
    return 0;
}

int HmcJpegMetadataDict::GetXResolution(UINT32 &resolution) const
{
    resolution = m_IFD0Entry.xResolution;
    return 0;
}

int HmcJpegMetadataDict::GetYResolution(UINT32 &resolution) const
{
    resolution = m_IFD0Entry.yResolution;
    return 0;
}

int HmcJpegMetadataDict::GetResolutionUnit(UINT16 &unit) const
{
    unit = m_IFD0Entry.resolutionUnit;
    return 0;
}

int HmcJpegMetadataDict::GetYCbCrPostion(UINT16 &position) const
{
    position = m_IFD0Entry.YCbCrPosition;
    return 0;
}

int HmcJpegMetadataDict::GetTitle(std::string &title) const
{
    title = m_IFD0Entry.title;
    return 0;
}

int HmcJpegMetadataDict::GetMake(std::string &make) const
{
    make = m_IFD0Entry.make;
    return 0;
}

int HmcJpegMetadataDict::GetModel(std::string &model) const
{
    model = m_IFD0Entry.model;
    return 0;
}

int HmcJpegMetadataDict::GetSoftware(std::string &software) const
{
    software = m_IFD0Entry.software;
    return 0;
}

int HmcJpegMetadataDict::GetDatetime(std::string &datetime) const
{
    datetime = m_IFD0Entry.datetime;
    return 0;
}

int HmcJpegMetadataDict::GetArtist(std::string &artist) const
{
    artist = m_IFD0Entry.artist;
    return 0;
}


// Exif data
int HmcJpegMetadataDict::GetExposureTime(UINT32 &numerator, UINT32 &denominator) const
{
    numerator = m_ExifEntry.exposureTime.numerator;
    denominator = m_ExifEntry.exposureTime.denominator;
    return 0;
}

int HmcJpegMetadataDict::GetFNumber(UINT32 &numerator, UINT32 &denominator) const
{
    numerator = m_ExifEntry.fNumber.numerator;
    denominator = m_ExifEntry.fNumber.denominator;
    return 0;
}

int HmcJpegMetadataDict::GetExposureProgram(UINT16 &program) const
{
    program = m_ExifEntry.program;
    return 0;
}

int HmcJpegMetadataDict::GetSensitivity(UINT16 &sensitivity) const
{
    sensitivity = m_ExifEntry.sensitivity;
    return 0;
}

int HmcJpegMetadataDict::GetShutterSpeed(INT32 &numerator, INT32 &denominator) const
{
    numerator = m_ExifEntry.shutterSpeed.numerator;
    denominator = m_ExifEntry.shutterSpeed.denominator;
    return 0;
}

int HmcJpegMetadataDict::GetApeture(UINT32 &numerator, UINT32 &denominator) const
{
    numerator = m_ExifEntry.apeture.numerator;
    denominator = m_ExifEntry.apeture.denominator;
    return 0;
}

int HmcJpegMetadataDict::GetBrightness(INT32 &numerator, INT32 &denominator) const
{
    numerator = m_ExifEntry.brightness.numerator;
    denominator = m_ExifEntry.brightness.denominator;
    return 0;
}

int HmcJpegMetadataDict::GetExposureBias(INT32 &numerator, INT32 &denominator) const
{
    numerator = m_ExifEntry.exposureBias.numerator;
    denominator = m_ExifEntry.exposureBias.denominator;
    return 0;
}

int HmcJpegMetadataDict::GetMeteringMode(INT16 &mode) const
{
    mode = m_ExifEntry.metringMode;
    return 0;
}

int HmcJpegMetadataDict::GetLightSource(INT16 &light) const
{
    light = m_ExifEntry.light;
    return 0;
}

int HmcJpegMetadataDict::GetFlash(UINT16 &flash) const
{
    flash = m_ExifEntry.flash;
    return 0;
}


int HmcJpegMetadataDict::GetFocalLength(UINT32 &numerator, UINT32 &denominator) const
{
    numerator = m_ExifEntry.focalLength.numerator;
    denominator = m_ExifEntry.focalLength.denominator;
    return 0;
}

int HmcJpegMetadataDict::GetMakerNote1(void *note, UINT32 len) const
{
    note = m_ExifEntry.note1.note;
    len = m_ExifEntry.note1.len;
    return 0;
}

int HmcJpegMetadataDict::GetMakerNote2(void *note, UINT32 len) const
{
    note = m_ExifEntry.note2.note;
    len = m_ExifEntry.note2.len;
    return 0;
}

int HmcJpegMetadataDict::GetColorSpace(UINT16 &colorSpace) const
{
    colorSpace = m_ExifEntry.colorSpace;
    return 0;
}

int HmcJpegMetadataDict::GetPixelXDimension(INT32 &dimension) const
{
    dimension = m_ExifEntry.pixelXDimension;
    return 0;
}

int HmcJpegMetadataDict::GetPixelYDimension(INT32 &dimension) const
{
    dimension = m_ExifEntry.pixelYDdimension;
    return 0;
}

int HmcJpegMetadataDict::GetSensingMethod(UINT16 &method) const
{
    method = m_ExifEntry.sensingMethod;
    return 0;
}

int HmcJpegMetadataDict::GetFileSource(UINT32 &source) const
{
    source = m_ExifEntry.fileSource;
    return 0;
}


int HmcJpegMetadataDict::GetSceneType(UINT32 &sceneType) const
{
    sceneType = m_ExifEntry.sceneType;
    return 0;
}

int HmcJpegMetadataDict::GetCustomRendered(UINT16 &rendered) const
{
    rendered = m_ExifEntry.customRendered;
    return 0;
}

int HmcJpegMetadataDict::GetExposureMode(UINT16 &mode) const
{
    mode = m_ExifEntry.exposureMode;
    return 0;
}

int HmcJpegMetadataDict::GetWhiteBalance(UINT16 &wb) const
{
    wb = m_ExifEntry.whiteBalance;
    return 0;
}

int HmcJpegMetadataDict::GetFocalLengthInfilm(UINT16 &focalLength) const
{
    focalLength = m_ExifEntry.focalLengthInFilm;
    return 0;
}

int HmcJpegMetadataDict::GetSceneCaptureType(UINT16 &sceneCaptureType) const
{
    sceneCaptureType = m_ExifEntry.sceneCaptureType;
    return 0;
}

int HmcJpegMetadataDict::GetGainControl(UINT16 &gainControl) const
{
    gainControl = m_ExifEntry.gainControl;
    return 0;
}

int HmcJpegMetadataDict::GetContrast(UINT16 &contrast) const
{
    contrast = m_ExifEntry.contrast;
    return 0;
}

int HmcJpegMetadataDict::GetSaturation(UINT16 &saturation) const
{
    saturation = m_ExifEntry.saturation;
    return 0;
}

int HmcJpegMetadataDict::GetSharpness(UINT16 &sharpness) const
{
    sharpness = m_ExifEntry.sharpness;
    return 0;
}

int HmcJpegMetadataDict::GetSubjectDistanceRange(UINT16 &distance) const
{
    distance = m_ExifEntry.subjectDistance;
    return 0;
}


int HmcJpegMetadataDict::GetDatetimeOriginal(std::string &datetime) const
{
    datetime = m_ExifEntry.datetimeOriginal;
    return 0;
}

int HmcJpegMetadataDict::GetDatetimeDigitized(std::string &datetime) const
{
    datetime = m_ExifEntry.datetimeDigitized;
    return 0;
}

int HmcJpegMetadataDict::GetSubSecTime(std::string &time) const
{
    time = m_ExifEntry.subSecTime;
    return 0;
}

int HmcJpegMetadataDict::GetSubSecTimeOrignal(std::string &time) const
{
    time = m_ExifEntry.subSecTimeOrignal;
    return 0;
}

int HmcJpegMetadataDict::GetSubSecTimeDigitized(std::string &time) const
{
    time = m_ExifEntry.subSecTimeDigitized;
    return 0;
}

int HmcJpegMetadataDict::GetFlashpixVersion(std::string &version) const
{
    version = m_ExifEntry.flashpixVersion;
    return 0;
}


// GPS data
int HmcJpegMetadataDict::GetGPSLatitudeRef(INT8 &ref) const
{
    ref = m_GPSEntry.latitudeRef;
    return 0;
}

int HmcJpegMetadataDict::GetGPSLatitude(HmcJpegGPSLocation_t &latitude) const
{
    latitude = m_GPSEntry.latitude;
    return 0;
}

int HmcJpegMetadataDict::GetGPSLongtitudeRef(INT8 &ref) const
{
    ref = m_GPSEntry.longtitudeRef;
    return 0;
}

int HmcJpegMetadataDict::GetGPSLongtitude(HmcJpegGPSLocation_t &longtitude) const
{
    longtitude = m_GPSEntry.longtitude;
    return 0;
}

int HmcJpegMetadataDict::GetAltitudeRef(UINT8 &ref) const
{
    ref = m_GPSEntry.altitudeRef;
    return 0;
}

int HmcJpegMetadataDict::GetAltitude(UINT32 &numerator, UINT32 &denominator) const
{
    numerator = m_GPSEntry.altitude.numerator;
    denominator = m_GPSEntry.altitude.denominator;
    return 0;
}

int HmcJpegMetadataDict::GetGPSTimeStamp(HmcJpegGPSTimeStamp_t &timestamp) const
{
    timestamp = m_GPSEntry.timestamp;
    return 0;
}

int HmcJpegMetadataDict::GetProcessingMethod(std::string &method) const
{
    method = m_GPSEntry.processingMethod;
    return 0;
}

int HmcJpegMetadataDict::GetGPSDateStamp(std::string &datestamp) const
{
    datestamp = m_GPSEntry.datestamp;
    return 0;
}


// IFD 0 data
int HmcJpegMetadataDict::SetWidth(UINT32 width)
{
    m_IFD0Entry.width = width;
    return 0;
}

int HmcJpegMetadataDict::SetHeight(UINT32 height)
{
    m_IFD0Entry.height = height;
    return 0;
}

int HmcJpegMetadataDict::SetOrientation(UINT32 orientation)
{
    m_IFD0Entry.orientation = orientation;
    return 0;
}

int HmcJpegMetadataDict::SetXResolution(UINT32 resolution)
{
    m_IFD0Entry.xResolution = resolution;
    return 0;
}

int HmcJpegMetadataDict::SetYResolution(UINT32 resolution)
{
    m_IFD0Entry.yResolution = resolution;
    return 0;
}

int HmcJpegMetadataDict::SetResolutionUnit(UINT16 unit)
{
    m_IFD0Entry.resolutionUnit = unit;
    return 0;
}

int HmcJpegMetadataDict::SetYCbCrPostion(UINT16 position)
{
    m_IFD0Entry.YCbCrPosition = position;
    return 0;
}


int HmcJpegMetadataDict::SetTitle(const std::string &title)
{
    m_IFD0Entry.title = title;
    return 0;
}

int HmcJpegMetadataDict::SetMake(const std::string &make)
{
    m_IFD0Entry.make = make;
    return 0;
}

int HmcJpegMetadataDict::SetModel(const std::string &model)
{
    m_IFD0Entry.model = model;
    return 0;
}

int HmcJpegMetadataDict::SetSoftware(const std::string &software)
{
    m_IFD0Entry.software = software;
    return 0;
}

int HmcJpegMetadataDict::SetDatetime(const std::string &datetime)
{
    m_IFD0Entry.datetime = datetime;
    return 0;
}

int HmcJpegMetadataDict::SetArtist(const std::string &artist)
{
    m_IFD0Entry.artist = artist;
    return 0;
}


// Exif data
int HmcJpegMetadataDict::SetExposureTime(UINT32 numerator, UINT32 denominator)
{
    m_ExifEntry.exposureTime.numerator = numerator;
    m_ExifEntry.exposureTime.denominator = denominator;
    return 0;
}

int HmcJpegMetadataDict::SetFNumber(UINT32 numerator, UINT32 denominator)
{
    m_ExifEntry.fNumber.numerator = numerator;
    m_ExifEntry.fNumber.denominator = denominator;
    return 0;
}

int HmcJpegMetadataDict::SetExposureProgram(UINT16 program)
{
    m_ExifEntry.program = program;
    return 0;
}

int HmcJpegMetadataDict::SetSensitivity(UINT16 sensitivity)
{
    m_ExifEntry.sensitivity = sensitivity;
    return 0;
}

int HmcJpegMetadataDict::SetShutterSpeed(INT32 numerator, INT32 denominator)
{
    m_ExifEntry.shutterSpeed.numerator = numerator;
    m_ExifEntry.shutterSpeed.denominator = denominator;
    return 0;
}

int HmcJpegMetadataDict::SetApeture(UINT32 numerator, UINT32 denominator)
{
    m_ExifEntry.apeture.numerator = numerator;
    m_ExifEntry.apeture.denominator = denominator;
    return 0;
}

int HmcJpegMetadataDict::SetBrightness(INT32 numerator, INT32 denominator)
{
    m_ExifEntry.brightness.numerator = numerator;
    m_ExifEntry.brightness.denominator = denominator;
    return 0;
}

int HmcJpegMetadataDict::SetExposureBias(INT32 numerator, INT32 denominator)
{
    m_ExifEntry.exposureBias.numerator = numerator;
    m_ExifEntry.exposureBias.denominator = denominator;
    return 0;
}

int HmcJpegMetadataDict::SetMeteringMode(INT16 mode)
{
    m_ExifEntry.metringMode = mode;
    return 0;
}

int HmcJpegMetadataDict::SetLightSource(INT16 light)
{
    m_ExifEntry.light = light;
    return 0;
}

int HmcJpegMetadataDict::SetFlash(UINT16 flash)
{
    m_ExifEntry.flash = flash;
    return 0;
}

int HmcJpegMetadataDict::SetFocalLength(UINT32 numerator, UINT32 denominator)
{
    m_ExifEntry.focalLength.numerator = numerator;
    m_ExifEntry.focalLength.denominator = denominator;
    return 0;
}

int HmcJpegMetadataDict::SetMakerNote1(const void *note, UINT32 len)
{
    note = m_ExifEntry.note1.note;
    len = m_ExifEntry.note1.len;
    return 0;
}

int HmcJpegMetadataDict::SetMakerNote2(const void *note, UINT32 len)
{
    note = m_ExifEntry.note2.note;
    len = m_ExifEntry.note2.len;
    return 0;
}

int HmcJpegMetadataDict::SetColorSpace(UINT16 colorSpace)
{
    m_ExifEntry.colorSpace = colorSpace;
    return 0;
}

int HmcJpegMetadataDict::SetPixelXDimension(INT32 dimension)
{
    m_ExifEntry.pixelXDimension = dimension;
    return 0;
}

int HmcJpegMetadataDict::SetPixelYDimension(INT32 dimension)
{
    m_ExifEntry.pixelYDdimension = dimension;
    return 0;
}

int HmcJpegMetadataDict::SetSensingMethod(UINT16 method)
{
    m_ExifEntry.sensingMethod = method;
    return 0;
}

int HmcJpegMetadataDict::SetFileSource(UINT32 fileSource)
{
    m_ExifEntry.fileSource = fileSource;
    return 0;
}

int HmcJpegMetadataDict::SetSceneType(UINT32 sceneType)
{
    m_ExifEntry.sceneType = sceneType;
    return 0;
}

int HmcJpegMetadataDict::SetCustomRendered(UINT16 rendered)
{
    m_ExifEntry.customRendered = rendered;
    return 0;
}

int HmcJpegMetadataDict::SetExposureMode(UINT16 mode)
{
    m_ExifEntry.exposureMode = mode;
    return 0;
}

int HmcJpegMetadataDict::SetWhiteBalance(UINT16 wb)
{
    m_ExifEntry.whiteBalance = wb;
    return 0;
}

int HmcJpegMetadataDict::SetFocalLengthInfilm(UINT16 focalLength)
{
    m_ExifEntry.focalLengthInFilm = focalLength;
    return 0;
}

int HmcJpegMetadataDict::SetSceneCaptureType(UINT16 sceneCaptureType)
{
    m_ExifEntry.sceneCaptureType = sceneCaptureType;
    return 0;
}

int HmcJpegMetadataDict::SetGainControl(UINT16 gainControl)
{
    m_ExifEntry.gainControl = gainControl;
    return 0;
}

int HmcJpegMetadataDict::SetContrast(UINT16 contrast)
{
    m_ExifEntry.contrast = contrast;
    return 0;
}

int HmcJpegMetadataDict::SetSaturation(UINT16 saturation)
{
    m_ExifEntry.saturation = saturation;
    return 0;
}

int HmcJpegMetadataDict::SetSharpness(UINT16 sharpness)
{
    m_ExifEntry.sharpness = sharpness;
    return 0;
}

int HmcJpegMetadataDict::SetSubjectDistanceRange(UINT16 distance)
{
    m_ExifEntry.subjectDistance = distance;
    return 0;
}


int HmcJpegMetadataDict::SetDatetimeOriginal(const std::string &datetime)
{
    m_ExifEntry.datetimeOriginal = datetime;
    return 0;
}

int HmcJpegMetadataDict::SetDatetimeDigitized(const std::string &datetime)
{
    m_ExifEntry.datetimeDigitized = datetime;
    return 0;
}

int HmcJpegMetadataDict::SetSubSecTime(const std::string &time)
{
    m_ExifEntry.subSecTime = time;
    return 0;
}

int HmcJpegMetadataDict::SetSubSecTimeOrignal(const std::string &time)
{
    m_ExifEntry.subSecTimeOrignal = time;
    return 0;
}

int HmcJpegMetadataDict::SetSubSecTimeDigitized(const std::string &time)
{
    m_ExifEntry.subSecTimeDigitized = time;
    return 0;
}

int HmcJpegMetadataDict::SetFlashpixVersion(const std::string &version)
{
    m_ExifEntry.flashpixVersion = version;
    return 0;
}


// GPS data
int HmcJpegMetadataDict::SetGPSLatitudeRef(INT8 ref)
{
    m_GPSEntry.latitudeRef = ref;
    return 0;
}

int HmcJpegMetadataDict::SetGPSLatitude(HmcJpegGPSLocation_t latitude)
{
    m_GPSEntry.latitude = latitude;
    return 0;
}

int HmcJpegMetadataDict::SetGPSLongtitudeRef(INT8 ref)
{
    m_GPSEntry.longtitudeRef = ref;
    return 0;
}

int HmcJpegMetadataDict::SetGPSLongtitude(HmcJpegGPSLocation_t longtitude)
{
    m_GPSEntry.longtitude = longtitude;
    return 0;
}

int HmcJpegMetadataDict::SetAltitudeRef(UINT8 ref)
{
    m_GPSEntry.altitudeRef = ref;
    return 0;
}

int HmcJpegMetadataDict::SetAltitude(UINT32 numerator, UINT32 denominator)
{
    m_GPSEntry.altitude.numerator = numerator;
    m_GPSEntry.altitude.denominator = denominator;
    return 0;
}

int HmcJpegMetadataDict::SetGPSTimeStamp(const HmcJpegGPSTimeStamp_t &timestamp)
{
    m_GPSEntry.timestamp = timestamp;
    return 0;
}

int HmcJpegMetadataDict::SetProcessingMethod(const std::string &method)
{
    m_GPSEntry.processingMethod = method;
    return 0;
}

int HmcJpegMetadataDict::SetGPSDateStamp(const std::string &datestamp)
{
    m_GPSEntry.datestamp = datestamp;
    return 0;
}
