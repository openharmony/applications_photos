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

#include "HmcJpegMetadata.h"
#include "log/HmcLog.h"

static const int TIFF_HEADER_LEN = 10;
static const int SIZE_DIRECTORY_ENTRY = 12;

HmcJpegMetadataEncoder::HmcJpegMetadataEncoder(const HmcJpegMetadataDict &metadataDict)
    : m_buffer(nullptr), m_size(0), m_maxSize(0), m_metadataDict(metadataDict)
{}

HmcJpegMetadataEncoder::~HmcJpegMetadataEncoder()
{
    if (m_buffer) {
        delete[] m_buffer;
        m_buffer = nullptr;
    }
    m_size = 0;
    m_maxSize = 0;
}

bool HmcJpegMetadataEncoder::Init()
{
    m_maxSize = 0x10000;
    m_buffer = new (std::nothrow) UINT8[m_maxSize];
    if (m_buffer == nullptr) {
        return false;
    }
    return true;
}

int HmcJpegMetadataEncoder::Encode()
{
    PutMarker();
    PutShort((UINT16)m_size);
    PutExifDescription();
    PutTiffHeader();
    PutIFD0();
    PutExifIFD();
    PutGPSIFD();
    PutSize();
    return 0;
}

/**
 * IFD0 structure
 * ( 1) 0x100 ImageWidth
 * ( 2) 0x101 ImageHeight
 * ( 3) 0x102 BitsPerSample
 * ( 4) 0x103 title
 * ( 5) 0x10f Make
 * ( 6) 0x110 Model
 * ( 7) 0x112 Orientation
 * ( 8) 0x11A XResolution
 * ( 9) 0x11B YResolution
 * (10) 0x128 ResolutionUnit
 * (11) 0x131 Software
 * (12) 0x132 Datetime
 * (13) 0x13B Artist
 * (14) 0x213 YCbCrPostion
 * (15) 0x8769 Exif sub IFD
 * (16) 0x8825 GPS sub IFD
 */
int HmcJpegMetadataEncoder::PutIFD0()
{
    // Image data structure
    UINT16 ifdCount = 16;
    PutIfdCount(ifdCount);
    m_bufferOffset = m_attrOffset + ifdCount * SIZE_DIRECTORY_ENTRY + sizeof(UINT32); // Every entry is 12 bytes
    m_dataOffset = m_bufferOffset - TIFF_HEADER_LEN; // Data offset starts from TIFF header
    // IFD 0
    //  0x100 ImageWidth
    UINT32 width = 0;
    m_metadataDict.GetWidth(width);
    PutImageWidth(width);
    //  0x101 ImageHeight
    UINT32 height = 0;
    m_metadataDict.GetHeight(height);
    PutImageHeight(height);
    //  0x102 BitsPerSample
    PutBitsPerSample(8, 8, 8);
    //  0x103 title
    std::string title;
    m_metadataDict.GetTitle(title);
    PutTitle(title.c_str());
    //  0x10f Make
    std::string make;
    m_metadataDict.GetMake(make);
    PutMake(make.c_str());
    //  0x110 Model
    std::string model;
    m_metadataDict.GetModel(model);
    PutModel(model.c_str());
    //  0x112 Orientation
    UINT32 orientation = 0;
    m_metadataDict.GetOrientation(orientation);
    PutOrientation(0);
    //  0x11A XResolution
    UINT32 dpi = 0;
    m_metadataDict.GetXResolution(dpi);
    PutXResolution(dpi);
    //  0x11B YResolution
    m_metadataDict.GetYResolution(dpi);
    PutYResolution(dpi);
    //  0x128 ResolutionUnit
    UINT16 resolutionUnit = 0;
    m_metadataDict.GetResolutionUnit(resolutionUnit);
    PutResolutionUnit(resolutionUnit);
    //  0x131 Software
    std::string software;
    PutSoftware(software.c_str());
    //  0x132 Datetime
    std::string datetime;
    m_metadataDict.GetDatetime(datetime);
    PutDatetime(datetime.c_str());
    //  0x13B Artist
    std::string artist;
    m_metadataDict.GetArtist(artist);
    PutArtist(artist.c_str());
    //  0x213 YCbCrPostion
    UINT16 postion = 0;
    m_metadataDict.GetYCbCrPostion(postion);
    PutYCbCrPostion(postion);
    //  0x8769 Exif sub IFD
    PutExifTag();
    //  0xA005 Interoperability sub IFD
    // Ignore
    //  0x8825 GPS IFD
    PutGpsTag();
    //  align?
    PutLong(0x0);
    PutIfd0Data();
    return 0;
}

/**
 * Exif sub IFD structure
 * ( 1) 0x010D unknown
 * ( 2) 0x829A ExposureTime
 * ( 3) 0x829D FNumber
 * ( 4) 0x8822 ExposureProgram
 * ( 5) 0x8827 PhotographicSensitivity
 * ( 6) 0x9000 ExifVersion
 * ( 7) 0x9003 DatetimeOriginal
 * ( 8) 0x9004 DatetimeDigitized
 * ( 9) 0x9101 ComponentsConfiguration
 * (10) 0x9201 ShutterSpeed
 * (11) 0x9202 Apeture
 * (12) 0x9203 Brightness
 * (13) 0x9204 ExposureBias
 * (14) 0x9207 MeteringMode
 * (15) 0x9208 LightSource
 * (16) 0x9209 Flash
 * (17) 0x920A FocalLength
 * (18) 0x927C MakerNote
 * (19) 0x9290 SubSecTime
 * (20) 0x9291 SubSecTimeOrignal
 * (21) 0x9292 SubSecTimeDigitized
 * (22) 0xA000 FlashpixVersion
 * (23) 0xA001 ColorSpace
 * (24) 0xA002 PixelXDimension
 * (25) 0xA003 PixelYDimension
 * (26) 0xA217 SensingMethod
 * (27) 0xA300 FileSource
 * (28) 0xA301 SceneType
 * (29) 0xA401 CustomRendered
 * (30) 0xA402 ExposureMode
 * (31) 0xA403 WhiteBalance
 * (32) 0xA405 FocalLengthIn35mmFilm
 * (33) 0xA406 SceneCaptureType
 * (34) 0xA407 Gain control
 * (35) 0xA408 Contrast
 * (36) 0xA409 Saturation
 * (37) 0xA40A Sharpness
 * (38) 0xA40C SubjectDistanceRange
 */
int HmcJpegMetadataEncoder::PutExifIFD()
{
    UINT32 u_numerator = 0, u_denominator = 0;
    INT32 numerator = 0, denominator = 0;

    PutExifIFD_OneToTen(u_numerator, u_denominator, numerator, denominator);
    PutExifIFD_ElevenToTwenty(u_numerator, u_denominator, numerator, denominator);
    PutExifIFD_TwentyOneToThirty(u_numerator, u_denominator, numerator, denominator);
    PutExifIFD_ThirtyOneToForty(u_numerator, u_denominator, numerator, denominator);
    
    return 0;
}

void HmcJpegMetadataEncoder::PutExifIFD_OneToTen(UINT32 &u_numerator, UINT32 &u_denominator, INT32 &numerator,
    INT32 &denominator)
{
    // Fix IFD attribute offset
    m_attrOffset = m_bufferOffset;
    UINT16 ifdCount = 40;
    PutIfdCount(ifdCount);
    // Fix data offset
    m_bufferOffset = m_attrOffset + ifdCount * SIZE_DIRECTORY_ENTRY + sizeof(UINT32);
    m_dataOffset = m_bufferOffset - TIFF_HEADER_LEN;
    //  0x10D unknown
    PutUndefined();
    //  0x829A Exposure Time
    m_metadataDict.GetExposureTime(u_numerator, u_denominator);
    PutExposureTime(u_numerator, u_denominator);
    //  0x829D F Number
    m_metadataDict.GetFNumber(u_numerator, u_denominator);
    PutFNumber(u_numerator, u_denominator);
    //  0x8822 Exposure Program
    UINT16 program = 0;
    m_metadataDict.GetExposureProgram(program);
    PutExposureProgram(program);
    //  0x8827 Photographic Sensitivity
    UINT16 sensitivity = 0;
    m_metadataDict.GetSensitivity(sensitivity);
    PutSensitivity(sensitivity);
    //  0x9000 Exif Version
    PutExifVersion("0210");
    //  0x9003 Datetime Original
    std::string datetime;
    m_metadataDict.GetDatetimeOriginal(datetime);
    PutDatetimeOriginal(datetime.c_str());
    //  0x9004 Datetime Digitized
    m_metadataDict.GetDatetimeDigitized(datetime);
    PutDatetimeDigitized(datetime.c_str());
    //  0x9101 Components Configuration
    PutConfiguration();
    //  0x9201 Shutter Speed
    m_metadataDict.GetShutterSpeed(numerator, denominator);
    PutShutterSpeed(numerator, denominator);
}

void HmcJpegMetadataEncoder::PutExifIFD_ElevenToTwenty(UINT32 &u_numerator, UINT32 &u_denominator, INT32 &numerator,
    INT32 &denominator)
{
    //  0x9202 Apeture
    m_metadataDict.GetApeture(u_numerator, u_denominator);
    PutApeture(u_numerator, u_denominator);
    //  0x9203 Brightness
    m_metadataDict.GetBrightness(numerator, denominator);
    PutBrightness(numerator, denominator);
    //  0x9204 Exposure Bias
    m_metadataDict.GetExposureBias(numerator, denominator);
    PutExposureBias(numerator, denominator);
    //  0x9207 Metering mode
    INT16 meteringMode = 0;
    m_metadataDict.GetMeteringMode(meteringMode);
    PutMeteringMode(meteringMode);
    //  0x9208 Light source
    INT16 lightSource = 0;
    m_metadataDict.GetLightSource(lightSource);
    PutLightSource(lightSource);
    //  0x9209 Flash
    UINT16 flash;
    m_metadataDict.GetFlash(flash);
    PutFlash(flash);
    //  0x920A Focal Length
    m_metadataDict.GetFocalLength(u_numerator, u_denominator);
    PutFocalLength(u_numerator, u_denominator);
    //  0x927C Maker Note
    //  Later we may add one more maker note
    void *note1 = nullptr;
    UINT32 note1_len = 0;
    m_metadataDict.GetMakerNote1(note1, note1_len);
    PutMakerNote(note1, note1_len);
    //  0x9290 SubSecTime
    std::string subSecTime;
    m_metadataDict.GetSubSecTime(subSecTime);
    PutSubSecTime(subSecTime.c_str());
    //  0x9291 SubSecTimeOrignal
    m_metadataDict.GetSubSecTimeOrignal(subSecTime);
    PutSubSecTimeOrignal(subSecTime.c_str());
    //  0x9292 SubSecTimeDigitized
    m_metadataDict.GetSubSecTimeDigitized(subSecTime);
    PutSubSecTimeDigitized(subSecTime.c_str());
}

void HmcJpegMetadataEncoder::PutExifIFD_TwentyOneToThirty(UINT32 &u_numerator, UINT32 &u_denominator, INT32 &numerator,
    INT32 &denominator)
{
    //  0xA000 FlashpixVersion
    std::string flashpixVersion;
    m_metadataDict.GetFlashpixVersion(flashpixVersion);
    PutFlashpixVersion(flashpixVersion.c_str());
    //  0xA001 ColorSpace
    UINT16 colorSpace = 0;
    m_metadataDict.GetColorSpace(colorSpace);
    PutColorSpace(colorSpace);
    //  0xA002 PixelXDimension
    INT32 dimension = 0;
    m_metadataDict.GetPixelXDimension(dimension);
    PutPixelXDimension(dimension);
    //  0xA003 PixelYDimension
    m_metadataDict.GetPixelYDimension(dimension);
    PutPixelYDimension(dimension);
    //  0xA217 SensingMethod
    UINT16 method = 0;
    m_metadataDict.GetSensingMethod(method);
    PutSensingMethod(method);
    //  0xA300 FileSource
    UINT32 fileSource = 0;
    m_metadataDict.GetFileSource(fileSource);
    PutFileSource(fileSource);
    //  0xA301 SceneType
    UINT32 sceneType = 0;
    m_metadataDict.GetSceneType(sceneType);
    PutSceneType(sceneType);
    //  0xA401 Custom rendered
    UINT16 customRendered = 0;
    m_metadataDict.GetCustomRendered(customRendered);
    PutCustomRendered(customRendered);
    //  0xA402 Exposure mode
    UINT16 exposureMode = 0;
    m_metadataDict.GetExposureMode(exposureMode);
    PutExposureMode(exposureMode);
}

void HmcJpegMetadataEncoder::PutExifIFD_ThirtyOneToForty(UINT32 &u_numerator, UINT32 &u_denominator, INT32 &numerator,
    INT32 &denominator)
{
    //  0xA403 White balance
    UINT16 wb = 0;
    m_metadataDict.GetWhiteBalance(wb);
    PutWhiteBalance(wb);
    //  0xA405 Focal length in 35mm film
    UINT16 focalLength = 0;
    m_metadataDict.GetFocalLengthInfilm(focalLength);
    PutFocalLengthInfilm(focalLength);
    //  0xA406 Scene capture type
    UINT16 sceneCaptureType = 0;
    m_metadataDict.GetSceneCaptureType(sceneCaptureType);
    PutSceneCaptureType(sceneCaptureType);
    //  0xA407 Gain control
    UINT16 gainControl = 0;
    m_metadataDict.GetGainControl(gainControl);
    PutGainControl(gainControl);
    //  0xA408 Contrast
    UINT16 contrast = 0;
    m_metadataDict.GetContrast(contrast);
    PutContrast(contrast);
    //  0xA409 Saturation
    UINT16 saturation = 0;
    m_metadataDict.GetSaturation(saturation);
    PutSaturation(saturation);
    //  0xA40A Sharpness
    UINT16 sharpness = 0;
    m_metadataDict.GetSharpness(sharpness);
    PutSharpness(sharpness);
    //  0xA40C Subject distance range
    UINT16 distance = 0;
    m_metadataDict.GetSubjectDistanceRange(distance);
    PutSubjectDistanceRange(distance);
    //  align?
    PutLong(0x0);
}

/**
 * GPS sub IFD structure
 * ( 1) 0x000 GPSVersionId
 * ( 2) 0x001 GPSLatitudeRef
 * ( 3) 0x002 GPSLatitude
 * ( 4) 0x003 GPSLongtitudeRef
 * ( 5) 0x004 GPSLongtitude
 * ( 6) 0x005 GPSAltitudeRef
 * ( 7) 0x006 GPSAltitude
 * ( 8) 0x007 TimeStamp
 * ( 9) 0x01B ProcessingMethod
 * (10) 0x01D DateStamp
 *    */
int HmcJpegMetadataEncoder::PutGPSIFD()
{
    // Fix IFD attribute offset
    m_attrOffset = m_bufferOffset;
    FixGPSOffset();
    UINT16 ifdCount = 10;
    PutIfdCount(ifdCount);
    // Fix data offset
    m_bufferOffset = m_attrOffset + ifdCount * SIZE_DIRECTORY_ENTRY + sizeof(UINT32);
    m_dataOffset = m_bufferOffset - TIFF_HEADER_LEN;
    //  0x000 GPS Version Id
    PutGPSVersionId(0);
    //  0x001 GPS LatitudeRef
    INT8 ref = 0;
    m_metadataDict.GetGPSLatitudeRef(ref);
    PutLatitudeRef(ref);
    //  0x002 GPS Latitude
    struct HmcJpegGPSLocation_t latitude = { 0 };
    m_metadataDict.GetGPSLatitude(latitude);
    PutLatitude(latitude);
    //  0x003 GPS LongtitudeRef
    m_metadataDict.GetGPSLongtitudeRef(ref);
    PutLongtitudeRef(ref);
    //  0x004 GPS Latitude
    struct HmcJpegGPSLocation_t longtitude = { 0 };
    m_metadataDict.GetGPSLongtitude(longtitude);
    PutLongtitude(longtitude);
    //  0x005 GPS AltitudeRef
    UINT8 altitudeRef = 0;
    m_metadataDict.GetAltitudeRef(altitudeRef);
    PutAltitudeRef(altitudeRef);
    //  0x006 GPS Altitude
    UINT32 numerator = 0, denominator = 0;
    m_metadataDict.GetAltitude(numerator, denominator);
    PutAltitude(numerator, denominator);
    //  0x007 TimeStamp
    HmcJpegGPSTimeStamp_t timestamp = { 0 };
    m_metadataDict.GetGPSTimeStamp(timestamp);
    PutGPSTimeStamp(timestamp);
    //  0x01B ProcessingMethod
    std::string method;
    m_metadataDict.GetProcessingMethod(method);
    PutGPSProcessingMethod(method.c_str());
    //  0x01D DateStamp
    std::string datestamp;
    m_metadataDict.GetGPSDateStamp(datestamp);
    PutGPSDateStamp(datestamp.c_str());
    //  align?
    PutLong(0x0);

    return 0;
}

/**
 * Interoperability sub IFD structure
 * (1) 0x001 InteroperabilityIndex
 * (2) 0x002 InteroperabilityVersion
 */
int HmcJpegMetadataEncoder::PutInteroperabilityIFD()
{
    return 0;
}

int HmcJpegMetadataEncoder::PutExifDescription()
{
    PutString("Exif");
    PutShort(0x0);
    return 0;
}

int HmcJpegMetadataEncoder::PutMarker()
{
    PutShort(0xFFE1); // marker: APP1
    return 0;
}

int HmcJpegMetadataEncoder::PutTiffHeader()
{
    PutEndian();
    PutShort(0x002A);
    PutLong(8); // first IFD offset
    return 0;
}

int HmcJpegMetadataEncoder::PutEndian()
{
    return PutShort(0x4D4D); // MM stands for Big endian
}

int HmcJpegMetadataEncoder::PutSize()
{
    *(UINT16 *)(m_buffer + 2) = htons(m_bufferOffset);
    return 0;
}

int HmcJpegMetadataEncoder::PutIfdCount(UINT16 sh)
{
    return PutShort(sh);
}

int HmcJpegMetadataEncoder::PutExifTag()
{
    PutShort(0x8769); //   tag: Exif IFD
    PutShort(0x04);   //  type: long
    PutLong(1);       // count: 1
    PutOffset();      // offset
    return 0;
}

int HmcJpegMetadataEncoder::PutGpsTag()
{
    PutShort(0x8825); //   tag: GPS IFD
    PutShort(0x04);   //  type: long
    PutLong(1);       // count: 1
    m_gpsOffset = m_attrOffset;
    PutOffset(); //  calculate offset
    return 0;
}

int HmcJpegMetadataEncoder::PutImageWidth(UINT16 w)
{
    PutShort(0x100); //   tag: image width
    PutShort(0x03);  //  type: short
    PutLong(1);      // count: 1
    PutShort(w);     // value
    PutShort(0);     // value offset align
    return 0;
}

int HmcJpegMetadataEncoder::PutImageHeight(UINT16 h)
{
    PutShort(0x101); //   tag: image height
    PutShort(0x03);  //  type: short
    PutLong(1);      // count: 1
    PutShort(h);     // value
    PutShort(0);     // value offset align
    return 0;
}

int HmcJpegMetadataEncoder::PutBitsPerSample(UINT16 r, UINT16 g, UINT16 b)
{
    PutShort(0x102); //   tag: bits per sample
    PutShort(0x03);  //  type: short
    PutLong(3);      // count: 3
    PutOffset();     // value offset
    PutBpsData(r, g, b);
    return 0;
}

int HmcJpegMetadataEncoder::PutTitle(const char *title)
{
    UINT32 len = strlen(title);
    PutShort(0x10E); //   tag: make
    PutShort(0x02);  //  type: ascii
    PutStrData(title, len);
    return 0;
}

int HmcJpegMetadataEncoder::PutMake(const char *make)
{
    UINT32 len = strlen(make);
    PutShort(0x10F); //   tag: make
    PutShort(0x02);  //  type: ascii
    PutStrData(make, len);
    return 0;
}

int HmcJpegMetadataEncoder::PutModel(const char *model)
{
    UINT32 len = strlen(model);
    PutShort(0x110); //   tag: model
    PutShort(0x02);  //  type: ascii
    PutStrData(model, len);
    return 0;
}

int HmcJpegMetadataEncoder::PutOrientation(UINT32 orientation)
{
    PutShort(0x112);      //   tag: orientation
    PutShort(0x03);       //  type: short
    PutLong(1);           // count: 1
    PutLong(orientation); // value
    return 0;
}

int HmcJpegMetadataEncoder::PutXResolution(UINT32 dpi)
{
    PutShort(0x11A); //   tag: XResolution
    PutShort(0x05);  //  type: RATIONAL
    PutLong(1);      // count: 1
    PutOffset();     // value offset
    PutResolutionData(dpi);
    return 0;
}

int HmcJpegMetadataEncoder::PutYResolution(UINT32 dpi)
{
    PutShort(0x11B); //   tag: XResolution
    PutShort(0x05);  //  type: RATIONAL
    PutLong(1);      // count: 1
    PutOffset();     // value offset
    PutResolutionData(dpi);
    return 0;
}

int HmcJpegMetadataEncoder::PutResolutionUnit(UINT16 unit)
{
    PutShort(0x128); //   tag: ResolutionUnit
    PutShort(0x03);  //  type: short
    PutLong(1);      // count: 1
    PutShort(unit);  // value
    PutShort(0);     // value offset align
    return 0;
}

int HmcJpegMetadataEncoder::PutSoftware(const char *software)
{
    UINT32 len = strlen(software);
    PutShort(0x131); //   tag: software
    PutShort(0x02);  //  type: ascii
    PutStrData(software, len);
    return 0;
}

int HmcJpegMetadataEncoder::PutDatetime(const char *datetime)
{
    UINT32 len = strlen(datetime);
    PutShort(0x132); //   tag: datetime
    PutShort(0x02);  //  type: ascii
    PutStrData(datetime, len);
    return 0;
}

int HmcJpegMetadataEncoder::PutArtist(const char *artist)
{
    UINT32 len = strlen(artist);
    PutShort(0x13B); //   tag: artist
    PutShort(0x02);  //  type: ascii
    PutStrData(artist, len);
    return 0;
}

int HmcJpegMetadataEncoder::PutYCbCrPostion(UINT16 pos)
{
    PutShort(0x213); //   tag: YCbCrPostion
    PutShort(0x03);  //  type: short
    PutLong(1);      // count: 1
    PutShort(pos);   // value
    PutShort(0);     // value offset align
    return 0;
}

int HmcJpegMetadataEncoder::PutIfd0Data()
{
    return 0;
}

int HmcJpegMetadataEncoder::PutUndefined()
{
    PutShort(0x10D); //   tag: (unknown)
    PutShort(0x07);  //  type: undefined
    PutLong(0);      // count: 1
    PutLong(0);      // value
    return 0;
}

int HmcJpegMetadataEncoder::PutExposureTime(UINT32 numerator, UINT32 denominator)
{
    PutShort(0x829A); //   tag: Exposure Time
    PutShort(0x05);   //  type: RATIONAL
    PutLong(1);       // count: 1
    PutOffset();      // value offset
    // Exposure time data
    PutRationalData(numerator, denominator);
    return 0;
}


int HmcJpegMetadataEncoder::PutFNumber(UINT32 numerator, UINT32 denominator)
{
    PutShort(0x829D); //   tag: F Number
    PutShort(0x05);   //  type: RATIONAL
    PutLong(1);       // count: 1
    PutOffset();      // value offset
    // F number data
    PutRationalData(numerator, denominator);
    return 0;
}


int HmcJpegMetadataEncoder::PutExposureProgram(UINT16 program)
{
    PutShort(0x8822);  //   tag: Exposure program
    PutShort(0x03);    //  type: short
    PutLong(1);        // count: 1
    PutShort(program); // value
    PutShort(0);       // align
    return 0;
}


int HmcJpegMetadataEncoder::PutSensitivity(UINT16 sensitivity)
{
    PutShort(0x8827);      //   tag: Photographic Sensitivity
    PutShort(0x03);        //  type: short
    PutLong(1);            // count: 1
    PutShort(sensitivity); // value
    PutShort(0);           // align
    return 0;
}


int HmcJpegMetadataEncoder::PutExifVersion(const char *version)
{
    UINT32 len = strlen(version);
    if (len != 4) {
        return -1;
    }
    PutShort(0x9000);    //   tag: Exif Version
    PutShort(0x07);      //  type: undefined
    PutLong(4);          // count: 4
    PutByte(version[0]); // value
    PutByte(version[1]);
    PutByte(version[2]);
    PutByte(version[3]);
    return 0;
}


int HmcJpegMetadataEncoder::PutDatetimeOriginal(const char *datetime)
{
    UINT32 len = strlen(datetime);
    PutShort(0x9003); //   tag: Datetime Original
    PutShort(0x02);   //  type: ascii
    PutStrData(datetime, len);
    return 0;
}


int HmcJpegMetadataEncoder::PutDatetimeDigitized(const char *datetime)
{
    UINT32 len = strlen(datetime);
    PutShort(0x9004); //   tag: Datetime Digitized
    PutShort(0x02);   //  type: ascii
    PutStrData(datetime, len);
    return 0;
}


int HmcJpegMetadataEncoder::PutConfiguration()
{
    PutShort(0x9101);    //   tag: Components Configuration
    PutShort(0x07);      //  type: undefined
    PutLong(4);          // count
    PutLong(0x01020300); // value: YCbCr
    return 0;
}


int HmcJpegMetadataEncoder::PutShutterSpeed(INT32 numerator, INT32 denominator)
{
    PutShort(0x9201); //   tag: Shutter Speed
    PutShort(0x0A);   //  type: sRATIONAL
    PutLong(1);       // count
    PutOffset();      // value: offset
    PutSRationalData(numerator, denominator);
    return 0;
}


int HmcJpegMetadataEncoder::PutApeture(UINT32 numerator, UINT32 denominator)
{
    PutShort(0x9202); //   tag: Apeture
    PutShort(0x05);   //  type: RATIONAL
    PutLong(1);       // count
    PutOffset();      // value: offset
    PutRationalData(numerator, denominator);
    return 0;
}


int HmcJpegMetadataEncoder::PutBrightness(INT32 numerator, INT32 denominator)
{
    PutShort(0x9203); //   tag: Brightness
    PutShort(0x0A);   //  type: sRATIONAL
    PutLong(1);       // count
    PutOffset();      // value: offset
    PutSRationalData(numerator, denominator);
    return 0;
}


int HmcJpegMetadataEncoder::PutExposureBias(INT32 numerator, INT32 denominator)
{
    PutShort(0x9204); //   tag: Exposure Bias
    PutShort(0x0A);   //  type: sRATIONAL
    PutLong(1);       // count
    PutOffset();      // value: offset
    PutSRationalData(numerator, denominator);
    return 0;
}


int HmcJpegMetadataEncoder::PutMeteringMode(INT16 mode)
{
    PutShort(0x9207); //   tag: Metering mode
    PutShort(0x03);   //  type: short
    PutLong(1);       // count
    PutShort(mode);   // value
    PutShort(0);      // align
    return 0;
}


int HmcJpegMetadataEncoder::PutLightSource(INT16 lightSource)
{
    PutShort(0x9208);      //   tag: Light source
    PutShort(0x03);        //  type: short
    PutLong(1);            // count
    PutShort(lightSource); // value
    PutShort(0);           // align
    return 0;
}


int HmcJpegMetadataEncoder::PutFlash(UINT16 flash)
{
    PutShort(0x9209); //   tag: Flash
    PutShort(0x03);   //  type: short
    PutLong(1);       // count
    PutShort(flash);  // value
    PutShort(0);      // align
    return 0;
}


int HmcJpegMetadataEncoder::PutFocalLength(UINT32 numerator, UINT32 denominator)
{
    PutShort(0x920A); //   tag: Flash
    PutShort(0x05);   //  type: RATIONAL
    PutLong(1);       // count
    PutOffset();      // value: offset
    PutRationalData(numerator, denominator);
    return 0;
}


int HmcJpegMetadataEncoder::PutMakerNote(const void *note, UINT32 length)
{
    PutShort(0x927C); //   tag: Flash
    PutShort(0x07);   //  type: undefined
    PutLong(length);  // count
    if ((note == nullptr) || (length == 0)) {
        PutLong(0); // value: offset
    } else {
        PutOffset(); // value: offset
        PutData(note, length);
    }
    return 0;
}

int HmcJpegMetadataEncoder::PutSubSecTime(const char *datetime)
{
    UINT32 len = strlen(datetime);
    PutShort(0x9290); //   tag: SubSecTime
    PutShort(0x02);   //  type: ascii
    PutStrData(datetime, len);
    return 0;
}


int HmcJpegMetadataEncoder::PutSubSecTimeOrignal(const char *datetime)
{
    UINT32 len = strlen(datetime);
    PutShort(0x9291); //   tag: SubSecTimeOrignal
    PutShort(0x02);   //  type: ascii
    PutStrData(datetime, len);
    return 0;
}


int HmcJpegMetadataEncoder::PutSubSecTimeDigitized(const char *datetime)
{
    UINT32 len = strlen(datetime);
    PutShort(0x9292); //   tag: SubSecTimeDigitized
    PutShort(0x02);   //  type: ascii
    PutStrData(datetime, len);
    return 0;
}


int HmcJpegMetadataEncoder::PutFlashpixVersion(const char *version)
{
    UINT32 len = strlen(version);
    if (len != 4) {
        return -1;
    }
    PutShort(0xA000);    //   tag: Flashpix Version
    PutShort(0x07);      //  type: undefined
    PutLong(4);          // count: 4
    PutByte(version[0]); // value
    PutByte(version[1]);
    PutByte(version[2]);
    PutByte(version[3]);
    return 0;
}


int HmcJpegMetadataEncoder::PutColorSpace(UINT16 colorSpace)
{
    PutShort(0xA001);     //   tag: ColorSpace
    PutShort(0x03);       //  type: short
    PutLong(1);           // count
    PutShort(colorSpace); // value
    PutShort(0);          // align
    return 0;
}


int HmcJpegMetadataEncoder::PutPixelXDimension(INT32 dimension)
{
    PutShort(0xA002);   //   tag: PixelXDimension
    PutShort(0x04);     //  type: Long
    PutLong(1);         // count
    PutLong(dimension); // value
    return 0;
}


int HmcJpegMetadataEncoder::PutPixelYDimension(INT32 dimension)
{
    PutShort(0xA003);   //   tag: PixelYDimension
    PutShort(0x04);     //  type: Long
    PutLong(1);         // count
    PutLong(dimension); // value
    return 0;
}


int HmcJpegMetadataEncoder::PutA005()
{
    return 0;
}


int HmcJpegMetadataEncoder::PutSensingMethod(UINT16 method)
{
    PutShort(0xA217); //   tag: SensingMethod
    PutShort(0x03);   //  type: short
    PutLong(1);       // count
    PutShort(method); // value
    PutShort(0);      // align
    return 0;
}


int HmcJpegMetadataEncoder::PutFileSource(UINT32 source)
{
    PutShort(0xA300); //   tag: FileSource
    PutShort(0x07);   //  type: undefined
    PutLong(1);       // count
    PutLong(source);  // value
    return 0;
}


int HmcJpegMetadataEncoder::PutSceneType(UINT32 sceneType)
{
    PutShort(0xA301);   //   tag: FileSource
    PutShort(0x07);     //  type: undefined
    PutLong(1);         // count
    PutLong(sceneType); // value
    return 0;
}


int HmcJpegMetadataEncoder::PutCustomRendered(UINT16 rendered)
{
    PutShort(0xA401);   //   tag: Custom rendered
    PutShort(0x03);     //  type: short
    PutLong(1);         // count
    PutShort(rendered); // value
    PutShort(0);        // align
    return 0;
}


int HmcJpegMetadataEncoder::PutExposureMode(UINT16 mode)
{
    PutShort(0xA402); //   tag: Exposure mode
    PutShort(0x03);   //  type: short
    PutLong(1);       // count
    PutShort(mode);   // value
    PutShort(0);      // align
    return 0;
}


int HmcJpegMetadataEncoder::PutWhiteBalance(UINT16 whiteBalance)
{
    PutShort(0xA403);       //   tag: White balance
    PutShort(0x03);         //  type: short
    PutLong(1);             // count
    PutShort(whiteBalance); // value
    PutShort(0);            // align
    return 0;
}


int HmcJpegMetadataEncoder::PutFocalLengthInfilm(UINT16 focalLength)
{
    PutShort(0xA405);      //   tag: Focal length in 35mm film
    PutShort(0x03);        //  type: short
    PutLong(1);            // count
    PutShort(focalLength); // value
    PutShort(0);           // align
    return 0;
}


int HmcJpegMetadataEncoder::PutSceneCaptureType(UINT16 captureType)
{
    PutShort(0xA406);      //   tag: Scene capture type
    PutShort(0x03);        //  type: short
    PutLong(1);            // count
    PutShort(captureType); // value
    PutShort(0);           // align
    return 0;
}


int HmcJpegMetadataEncoder::PutGainControl(UINT16 gain)
{
    PutShort(0xA407); //   tag: Gain control
    PutShort(0x03);   //  type: short
    PutLong(1);       // count
    PutShort(gain);   // value
    PutShort(0);      // align
    return 0;
}


int HmcJpegMetadataEncoder::PutContrast(UINT16 contrast)
{
    PutShort(0xA408);   //   tag: Contrast
    PutShort(0x03);     //  type: short
    PutLong(1);         // count
    PutShort(contrast); // value
    PutShort(0);        // align
    return 0;
}


int HmcJpegMetadataEncoder::PutSaturation(UINT16 saturation)
{
    PutShort(0xA409);     //   tag: Saturation
    PutShort(0x03);       //  type: short
    PutLong(1);           // count
    PutShort(saturation); // value
    PutShort(0);          // align
    return 0;
}


int HmcJpegMetadataEncoder::PutSharpness(UINT16 sharpness)
{
    PutShort(0xA40A);    //   tag: Sharpness
    PutShort(0x03);      //  type: short
    PutLong(1);          // count
    PutShort(sharpness); // value
    PutShort(0);         // align
    return 0;
}


int HmcJpegMetadataEncoder::PutSubjectDistanceRange(UINT16 distanceRange)
{
    PutShort(0xA40C);        //   tag: Subject distance range
    PutShort(0x03);          //  type: short
    PutLong(1);              // count
    PutShort(distanceRange); // value
    PutShort(0);             // align
    return 0;
}


// GPS sub IFD attributes
int HmcJpegMetadataEncoder::PutGPSVersionId(UINT32 versionId)
{
    PutShort(0x0000);   //   tag: GPS Version Id
    PutShort(0x01);     //  type: byte
    PutLong(4);         // count
    PutLong(versionId); // value
    return 0;
}

int HmcJpegMetadataEncoder::PutLatitudeRef(char ref)
{
    PutShort(0x0001); //   tag: GPS Latitude Ref
    PutShort(0x02);   //  type: ascii
    PutLong(2);       // count: 2
    if (ref == 'N') {
        PutByte(0x4e); // North
    } else if (ref == 'S') {
        PutByte(0x53); // South
    } else {
        PutByte(0);
    }
    PutByte(0);
    PutByte(0);
    PutByte(0);
    return 0;
}

int HmcJpegMetadataEncoder::PutLatitude(struct HmcJpegGPSLocation_t &latitude)
{
    PutShort(0x0002); //   tag: GPS Latitude
    PutShort(0x05);   //  type: RATIONAL
    PutLong(3);       // count
    PutOffset();      // value
    PutRationalData(latitude.degrees, 1);
    PutRationalData(latitude.minutes, 1);
    PutRationalData(latitude.seconds, 1);
    return 0;
}

int HmcJpegMetadataEncoder::PutLongtitudeRef(char ref)
{
    PutShort(0x0003); //   tag: GPS Longtitude Ref
    PutShort(0x02);   //  type: ascii
    PutLong(2);       // count: 2
    if (ref == 'E') {
        PutByte(0x45); // East
    } else if (ref == 'W') {
        PutByte(0x57); // West
    } else {
        PutByte(0);
    }
    PutByte(0);
    PutByte(0);
    PutByte(0);
    return 0;
}

int HmcJpegMetadataEncoder::PutLongtitude(struct HmcJpegGPSLocation_t &longtitude)
{
    PutShort(0x0004); //   tag: GPS Longtitude
    PutShort(0x05);   //  type: RATIONAL
    PutLong(3);       // count
    PutOffset();      // value
    PutRationalData(longtitude.degrees, 1);
    PutRationalData(longtitude.minutes, 1);
    PutRationalData(longtitude.seconds, 1);
    return 0;
}

int HmcJpegMetadataEncoder::PutAltitudeRef(UINT8 altitudeRef)
{
    PutShort(0x0005);     //   tag: GPS Altitude Ref
    PutShort(0x01);       //  type: byte
    PutLong(1);           // count
    PutByte(altitudeRef); // value
    PutByte(0);           // align
    PutByte(0);           // align
    PutByte(0);           // align
    return 0;
}

int HmcJpegMetadataEncoder::PutAltitude(UINT32 numerator, UINT32 denominator)
{
    PutShort(0x0006); //   tag: GPS Altitude
    PutShort(0x05);   //  type: RATIONAL
    PutLong(1);       // count
    PutOffset();      // value
    PutRationalData(numerator, denominator);
    return 0;
}

int HmcJpegMetadataEncoder::PutGPSTimeStamp(struct HmcJpegGPSTimeStamp_t &timestamp)
{
    PutShort(0x0007); //   tag: GPS TimeStamp
    PutShort(0x05);   //  type: RATIONAL
    PutLong(3);       // count
    PutOffset();      // value
    PutRationalData(timestamp.hours_numerator, timestamp.hours_denominator);
    PutRationalData(timestamp.minutes_numerator, timestamp.minutes_denominator);
    PutRationalData(timestamp.seconds_numerator, timestamp.seconds_denominator);
    return 0;
}

int HmcJpegMetadataEncoder::PutGPSProcessingMethod(const char *method)
{
    UINT32 len = strlen(method);
    PutShort(0x001B); //   tag: GPS ProcessingMethod
    PutShort(0x02);   //  type: ascii
    PutStrData(method, len);
    return 0;
}

int HmcJpegMetadataEncoder::PutGPSDateStamp(const char *datestamp)
{
    UINT32 len = strlen(datestamp);
    PutShort(0x001D); //   tag: GPS DateStamp
    PutShort(0x02);   //  type: ascii
    PutStrData(datestamp, len);
    return 0;
}


// Interoperability sub IFD attributes
int HmcJpegMetadataEncoder::PutInteroperabilityIndex(const char *opindex)
{
    UINT32 len = strlen(opindex);
    if (len != 3) {
        return -1;
    }
    PutShort(0x0001);    //   tag: InteroperabilityIndex
    PutShort(0x02);      //  type: ascii
    PutLong(4);          // count
    PutByte(opindex[0]); // value
    PutByte(opindex[1]); // value
    PutByte(opindex[2]); // value
    PutByte(0);
    return 0;
}

int HmcJpegMetadataEncoder::PutInteroperabilityVersion(const char *version)
{
    UINT32 len = strlen(version);
    if (len != 4) {
        return -1;
    }
    PutShort(0x0002);    //   tag: InteroperabilityIndex
    PutShort(0x07);      //  type: undefined
    PutLong(4);          // count
    PutByte(version[0]); // value
    PutByte(version[1]); // value
    PutByte(version[2]); // value
    PutByte(version[3]); // value
    return 0;
}


int HmcJpegMetadataEncoder::PutOffset()
{
    return PutLong(m_dataOffset);
}

int HmcJpegMetadataEncoder::PutByte(UINT8 b)
{
    m_buffer[m_attrOffset] = b;
    m_attrOffset++;
    return 0;
}

int HmcJpegMetadataEncoder::PutShort(UINT16 sh)
{
    *(UINT16 *)(m_buffer + m_attrOffset) = htons(sh);
    m_attrOffset += sizeof(UINT16);
    return 0;
}

int HmcJpegMetadataEncoder::PutLong(UINT32 ul)
{
    *(UINT32 *)(m_buffer + m_attrOffset) = htonl(ul);
    m_attrOffset += sizeof(UINT32);
    return 0;
}

int HmcJpegMetadataEncoder::PutString(const char *s)
{
    size_t len = strlen(s);
    strncpy((char *)m_buffer + m_attrOffset, s, m_maxSize - m_attrOffset);
    m_buffer[m_maxSize - 1] = '\0';
    m_attrOffset += len;
    return 0;
}

int HmcJpegMetadataEncoder::PutData(const void *data, UINT16 len)
{
    memcpy(m_buffer + m_bufferOffset, data, len);
    m_bufferOffset += len;
    m_dataOffset += len;
    return 0;
}

int HmcJpegMetadataEncoder::PutBpsData(UINT16 r, UINT16 g, UINT16 b)
{
    *(UINT16 *)(m_buffer + m_bufferOffset) = htons(r);
    m_bufferOffset += sizeof(UINT16);
    *(UINT16 *)(m_buffer + m_bufferOffset) = htons(g);
    m_bufferOffset += sizeof(UINT16);
    *(UINT16 *)(m_buffer + m_bufferOffset) = htons(b);
    m_bufferOffset += sizeof(UINT16);
    m_dataOffset += 3 * sizeof(UINT16);
    return 0;
}

int HmcJpegMetadataEncoder::PutResolutionData(UINT32 dpi)
{
    *(UINT32 *)(m_buffer + m_bufferOffset) = htonl(dpi);
    m_bufferOffset += sizeof(UINT32);
    *(UINT32 *)(m_buffer + m_bufferOffset) = htonl(1);
    m_bufferOffset += sizeof(UINT32);
    m_dataOffset += 2 * sizeof(UINT32);
    return 0;
}

int HmcJpegMetadataEncoder::PutStrData(const char *str, UINT32 len)
{
    PutLong(len); // count:
    if (len == 0) {
        PutLong(0);
    } else {
        PutOffset();           // value offset
        PutData(str, len + 1); // contains '\0'
    }
    return 0;
}

int HmcJpegMetadataEncoder::PutRationalData(UINT32 numerator, UINT32 denominator)
{
    PutLongData(numerator);
    PutLongData(denominator);
    return 0;
}

int HmcJpegMetadataEncoder::PutSRationalData(INT32 numerator, INT32 denominator)
{
    PutSLongData(numerator);
    PutSLongData(denominator);
    return 0;
}

int HmcJpegMetadataEncoder::PutLongData(UINT32 ul)
{
    UINT32 temp = htonl(ul);
    UINT32 len = sizeof(UINT32);
    memcpy(m_buffer + m_bufferOffset, &temp, len);
    m_bufferOffset += len;
    m_dataOffset += len;
    return 0;
}

int HmcJpegMetadataEncoder::PutSLongData(INT32 sl)
{
    INT32 temp = static_cast<INT32>(htonl(static_cast<UINT32>(sl)));
    UINT32 len = sizeof(INT32);
    memcpy(m_buffer + m_bufferOffset, &temp, len);
    m_bufferOffset += len;
    m_dataOffset += len;
    return 0;
}

int HmcJpegMetadataEncoder::FixGPSOffset()
{
    *(UINT32 *)(m_buffer + m_gpsOffset) = htonl(m_attrOffset - TIFF_HEADER_LEN);
    return 0;
}
