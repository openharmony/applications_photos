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
#ifndef HMCJPEGMETADATA_H
#define HMCJPEGMETADATA_H

#include "HmcBase.h"
#include <string>

struct HmcJpegGPSLocation_t {
    UINT32 degrees;
    UINT32 minutes;
    UINT32 seconds;
};

struct HmcJpegGPSTimeStamp_t {
    UINT32 hours_numerator;
    UINT32 hours_denominator;
    UINT32 minutes_numerator;
    UINT32 minutes_denominator;
    UINT32 seconds_numerator;
    UINT32 seconds_denominator;
};

struct HmcJpegRational_t {
    UINT32 numerator;
    UINT32 denominator;
};

struct HmcJpegSRational_t {
    INT32 numerator;
    INT32 denominator;
};

struct HmcJpegMakerNote_t {
    void *note;
    UINT32 len;
};

struct HmcJpegIFD0Entry_t {
    UINT32 width;
    UINT32 height;
    UINT32 orientation;
    UINT32 xResolution;
    UINT32 yResolution;
    UINT16 resolutionUnit;
    UINT16 YCbCrPosition;
    std::string title;
    std::string make;
    std::string model;
    std::string software;
    std::string datetime;
    std::string artist;
};

struct HmcJpegEixfEntry_t {
    HmcJpegRational_t exposureTime;
    HmcJpegRational_t fNumber;
    UINT16 program;
    UINT16 sensitivity;
    HmcJpegSRational_t shutterSpeed;
    HmcJpegRational_t apeture;
    HmcJpegSRational_t brightness;
    HmcJpegSRational_t exposureBias;
    INT16 metringMode;
    INT16 light;
    UINT16 flash;
    HmcJpegRational_t focalLength;
    HmcJpegMakerNote_t note1{ 0 };
    HmcJpegMakerNote_t note2{ 0 };
    UINT16 colorSpace;
    INT32 pixelXDimension;
    INT32 pixelYDdimension;
    UINT16 sensingMethod;
    UINT32 fileSource;
    UINT32 sceneType;
    UINT16 customRendered;
    UINT16 exposureMode;
    UINT16 whiteBalance;
    UINT16 focalLengthInFilm;
    UINT16 sceneCaptureType;
    UINT16 gainControl;
    UINT16 contrast;
    UINT16 saturation;
    UINT16 sharpness;
    UINT16 subjectDistance;
    std::string datetimeOriginal;
    std::string datetimeDigitized;
    std::string subSecTime;
    std::string subSecTimeOrignal;
    std::string subSecTimeDigitized;
    std::string flashpixVersion;
};

struct HmcJpegGPSEntry_t {
    INT8 latitudeRef;
    HmcJpegGPSLocation_t latitude;
    INT8 longtitudeRef;
    HmcJpegGPSLocation_t longtitude;
    UINT8 altitudeRef;
    HmcJpegRational_t altitude;
    HmcJpegGPSTimeStamp_t timestamp;
    std::string processingMethod;
    std::string datestamp;
};

class HmcJpegMetadataDict {
public:
    HmcJpegMetadataDict();
    ~HmcJpegMetadataDict();

    int FromAVDictionary();

    // IFD 0 data
    int GetWidth(UINT32 &width) const;
    int GetHeight(UINT32 &height) const;
    int GetOrientation(UINT32 &orientation) const;
    int GetXResolution(UINT32 &resolution) const;
    int GetYResolution(UINT32 &resolution) const;
    int GetResolutionUnit(UINT16 &unit) const;
    int GetYCbCrPostion(UINT16 &position) const;
    int GetTitle(std::string &title) const;
    int GetMake(std::string &make) const;
    int GetModel(std::string &model) const;
    int GetSoftware(std::string &software) const;
    int GetDatetime(std::string &datetime) const;
    int GetArtist(std::string &artist) const;

    int SetWidth(UINT32 width);
    int SetHeight(UINT32 height);
    int SetOrientation(UINT32 orientation);
    int SetXResolution(UINT32 resolution);
    int SetYResolution(UINT32 resolution);
    int SetResolutionUnit(UINT16 unit);
    int SetYCbCrPostion(UINT16 position);
    int SetTitle(const std::string &title);
    int SetMake(const std::string &make);
    int SetModel(const std::string &model);
    int SetSoftware(const std::string &software);
    int SetDatetime(const std::string &datetime);
    int SetArtist(const std::string &artist);

    // Exif data
    int GetExposureTime(UINT32 &numerator, UINT32 &denominator) const;
    int GetFNumber(UINT32 &numerator, UINT32 &denominator) const;
    int GetExposureProgram(UINT16 &program) const;
    int GetSensitivity(UINT16 &sensitivity) const;
    int GetShutterSpeed(INT32 &numerator, INT32 &denominator) const;
    int GetApeture(UINT32 &numerator, UINT32 &denominator) const;
    int GetBrightness(INT32 &numerator, INT32 &denominator) const;
    int GetExposureBias(INT32 &numerator, INT32 &denominator) const;
    int GetMeteringMode(INT16 &mode) const;
    int GetLightSource(INT16 &light) const;
    int GetFlash(UINT16 &flash) const;
    int GetFocalLength(UINT32 &numerator, UINT32 &denominator) const;
    int GetMakerNote1(void *note, UINT32 len) const;
    int GetMakerNote2(void *note, UINT32 len) const;
    int GetColorSpace(UINT16 &colorSpace) const;
    int GetPixelXDimension(INT32 &dimension) const;
    int GetPixelYDimension(INT32 &dimension) const;
    int GetSensingMethod(UINT16 &method) const;
    int GetFileSource(UINT32 &source) const;
    int GetSceneType(UINT32 &sceneType) const;
    int GetCustomRendered(UINT16 &rendered) const;
    int GetExposureMode(UINT16 &mode) const;
    int GetWhiteBalance(UINT16 &wb) const;
    int GetFocalLengthInfilm(UINT16 &focalLength) const;
    int GetSceneCaptureType(UINT16 &sceneCaptureType) const;
    int GetGainControl(UINT16 &gainControl) const;
    int GetContrast(UINT16 &contrast) const;
    int GetSaturation(UINT16 &saturation) const;
    int GetSharpness(UINT16 &sharpness) const;
    int GetSubjectDistanceRange(UINT16 &distance) const;
    int GetDatetimeOriginal(std::string &datetime) const;
    int GetDatetimeDigitized(std::string &datetime) const;
    int GetSubSecTime(std::string &time) const;
    int GetSubSecTimeOrignal(std::string &time) const;
    int GetSubSecTimeDigitized(std::string &time) const;
    int GetFlashpixVersion(std::string &version) const;

    int SetExposureTime(UINT32 numerator, UINT32 denominator);
    int SetFNumber(UINT32 numerator, UINT32 denominator);
    int SetExposureProgram(UINT16 program);
    int SetSensitivity(UINT16 sensitivity);
    int SetShutterSpeed(INT32 numerator, INT32 denominator);
    int SetApeture(UINT32 numerator, UINT32 denominator);
    int SetBrightness(INT32 numerator, INT32 denominator);
    int SetExposureBias(INT32 numerator, INT32 denominator);
    int SetMeteringMode(INT16 mode);
    int SetLightSource(INT16 light);
    int SetFlash(UINT16 flash);
    int SetFocalLength(UINT32 numerator, UINT32 denominator);
    int SetMakerNote1(const void *note, UINT32 len);
    int SetMakerNote2(const void *note, UINT32 len);
    int SetColorSpace(UINT16 colorSpace);
    int SetPixelXDimension(INT32 dimension);
    int SetPixelYDimension(INT32 dimension);
    int SetSensingMethod(UINT16 method);
    int SetFileSource(UINT32 source);
    int SetSceneType(UINT32 sceneType);
    int SetCustomRendered(UINT16 rendered);
    int SetExposureMode(UINT16 mode);
    int SetWhiteBalance(UINT16 wb);
    int SetFocalLengthInfilm(UINT16 focalLength);
    int SetSceneCaptureType(UINT16 sceneCaptureType);
    int SetGainControl(UINT16 gainControl);
    int SetContrast(UINT16 contrast);
    int SetSaturation(UINT16 saturation);
    int SetSharpness(UINT16 sharpness);
    int SetSubjectDistanceRange(UINT16 distance);
    int SetDatetimeOriginal(const std::string &datetime);
    int SetDatetimeDigitized(const std::string &datetime);
    int SetSubSecTime(const std::string &time);
    int SetSubSecTimeOrignal(const std::string &time);
    int SetSubSecTimeDigitized(const std::string &time);
    int SetFlashpixVersion(const std::string &version);

    // GPS data
    int GetGPSLatitudeRef(INT8 &ref) const;
    int GetGPSLatitude(HmcJpegGPSLocation_t &latitude) const;
    int GetGPSLongtitudeRef(INT8 &ref) const;
    int GetGPSLongtitude(HmcJpegGPSLocation_t &longtitude) const;
    int GetAltitudeRef(UINT8 &ref) const;
    int GetAltitude(UINT32 &numerator, UINT32 &denominator) const;
    int GetGPSTimeStamp(HmcJpegGPSTimeStamp_t &timestamp) const;
    int GetProcessingMethod(std::string &method) const;
    int GetGPSDateStamp(std::string &datestamp) const;

    int SetGPSLatitudeRef(INT8 ref);
    int SetGPSLatitude(HmcJpegGPSLocation_t latitude);
    int SetGPSLongtitudeRef(INT8 ref);
    int SetGPSLongtitude(HmcJpegGPSLocation_t longtitude);
    int SetAltitudeRef(UINT8 ref);
    int SetAltitude(UINT32 numerator, UINT32 denominator);
    int SetGPSTimeStamp(const HmcJpegGPSTimeStamp_t &timestamp);
    int SetProcessingMethod(const std::string &method);
    int SetGPSDateStamp(const std::string &datestamp);

private:
    HmcJpegIFD0Entry_t m_IFD0Entry{};
    HmcJpegEixfEntry_t m_ExifEntry{};
    HmcJpegGPSEntry_t m_GPSEntry{};
};

class HmcJpegMetadataEncoder {
public:
    explicit HmcJpegMetadataEncoder(const HmcJpegMetadataDict &metadataDict);
    ~HmcJpegMetadataEncoder();

    /* *
     * Get encoded buffer and size.
     * @param size [out] the encoded buffer size
     * @return the encoded buffer
     */
    const UINT8 *GetBuffer(UINT32 &size) const
    {
        size = m_bufferOffset;
        return m_buffer;
    }

    /* **
     * Initialize encoder, such as allocating memory.
     * @return true if succeeded; false otherwise.
     */
    bool Init();

    /* **
     * Start to encode metadata.
     * @return 0 if succeeded; non-zero otherwise.
     */
    int Encode();

private:
    int PutIFD0();
    int PutExifIFD();
    void PutExifIFD_OneToTen(UINT32 &u_numerator, UINT32 &u_denominator, INT32 &numerator, INT32 &denominator);
    void PutExifIFD_ElevenToTwenty(UINT32 &u_numerator, UINT32 &u_denominator, INT32 &numerator, INT32 &denominator);
    void PutExifIFD_TwentyOneToThirty(UINT32 &u_numerator, UINT32 &u_denominator, INT32 &numerator, INT32 &denominator);
    void PutExifIFD_ThirtyOneToForty(UINT32 &u_numerator, UINT32 &u_denominator, INT32 &numerator, INT32 &denominator);
    int PutGPSIFD();
    int PutInteroperabilityIFD();

    // description
    int PutExifDescription();

    // IFD 0 attributes
    int PutMarker();
    int PutTiffHeader();
    int PutEndian();
    int PutSize();
    int PutIfdCount(UINT16 count);
    int PutExifTag();
    int PutGpsTag();
    int PutImageWidth(UINT16 w);
    int PutImageHeight(UINT16 h);
    int PutBitsPerSample(UINT16 r, UINT16 g, UINT16 b);
    int PutTitle(const char *title);
    int PutMake(const char *make);
    int PutModel(const char *model);
    int PutOrientation(UINT32 orientation);
    int PutXResolution(UINT32 dpi);
    int PutYResolution(UINT32 dpi);
    int PutResolutionUnit(UINT16 unit);
    int PutSoftware(const char *software);
    int PutDatetime(const char *datetime);
    int PutArtist(const char *artist);
    int PutYCbCrPostion(UINT16 pos);
    int PutIfd0Data();
    int PutResolutionData(UINT32 dpi);

    // Exif sub IFD attributes
    int PutUndefined();
    int PutExposureTime(UINT32 numerator, UINT32 denominator);
    int PutFNumber(UINT32 numerator, UINT32 denominator);
    int PutExposureProgram(UINT16 program);
    int PutSensitivity(UINT16 sensitivity);
    int PutExifVersion(const char *version);
    int PutDatetimeOriginal(const char *datetime);
    int PutDatetimeDigitized(const char *datetime);
    int PutConfiguration();
    int PutShutterSpeed(INT32 numerator, INT32 denominator);
    int PutApeture(UINT32 numerator, UINT32 denominator);
    int PutBrightness(INT32 numerator, INT32 denominator);
    int PutExposureBias(INT32 numerator, INT32 denominator);
    int PutMeteringMode(INT16 mode);
    int PutLightSource(INT16 lightSource);
    int PutFlash(UINT16 flash);
    int PutFocalLength(UINT32 numerator, UINT32 denominator);
    int PutMakerNote(const void *note, UINT32 length);
    int PutSubSecTime(const char *datetime);
    int PutSubSecTimeOrignal(const char *datetime);
    int PutSubSecTimeDigitized(const char *datetime);
    int PutFlashpixVersion(const char *version);
    int PutColorSpace(UINT16 colorSpace);
    int PutPixelXDimension(INT32 dimension);
    int PutPixelYDimension(INT32 dimension);
    int PutA005();
    int PutSensingMethod(UINT16 method);
    int PutFileSource(UINT32 source);
    int PutSceneType(UINT32 sceneType);
    int PutCustomRendered(UINT16 rendered);
    int PutExposureMode(UINT16 mode);
    int PutWhiteBalance(UINT16 whiteBalance);
    int PutFocalLengthInfilm(UINT16 focalLength);
    int PutSceneCaptureType(UINT16 captureType);
    int PutGainControl(UINT16 gain);
    int PutContrast(UINT16 contrast);
    int PutSaturation(UINT16 saturation);
    int PutSharpness(UINT16 sharpness);
    int PutSubjectDistanceRange(UINT16 distanceRange);
    int FixGPSOffset();

    // GPS sub IFD attributes
    int PutGPSVersionId(UINT32 versionId);
    int PutLatitudeRef(char ref);
    int PutLatitude(struct HmcJpegGPSLocation_t &latitude);
    int PutLongtitudeRef(char ref);
    int PutLongtitude(struct HmcJpegGPSLocation_t &longtitude);
    int PutAltitudeRef(UINT8 altitude);
    int PutAltitude(UINT32 numerator, UINT32 denominator);
    int PutGPSTimeStamp(struct HmcJpegGPSTimeStamp_t &timestamp);
    int PutGPSProcessingMethod(const char *method);
    int PutGPSDateStamp(const char *datestamp);

    // Interoperability sub IFD attributes
    int PutInteroperabilityIndex(const char *index);
    int PutInteroperabilityVersion(const char *index);

    // Common functions
    int PutOffset();
    int PutByte(UINT8 b);
    int PutShort(UINT16 sh);
    int PutLong(UINT32 ul);
    int PutString(const char *s);
    int PutData(const void *data, UINT16 len);
    int PutStrData(const char *str, UINT32 len);
    int PutBpsData(UINT16 r, UINT16 g, UINT16 b);
    int PutRationalData(UINT32 numerator, UINT32 denominator);
    int PutSRationalData(INT32 numerator, INT32 denominator);
    int PutLongData(UINT32 ul);
    int PutSLongData(INT32 sl);

private:
    UINT8 *m_buffer{ nullptr };
    UINT32 m_attrOffset{ 0 };
    UINT32 m_size{ 0 };
    UINT32 m_maxSize{ 0 };
    UINT32 m_bufferOffset{ 0 };
    UINT32 m_dataOffset{ 0 };
    UINT32 m_gpsOffset{ 0 };
    HmcJpegMetadataDict m_metadataDict;
};

#endif
