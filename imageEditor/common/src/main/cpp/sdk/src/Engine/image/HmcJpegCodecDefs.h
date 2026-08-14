#ifndef HMC_JPEG_CODEC_DEFS_H
#define HMC_JPEG_CODEC_DEFS_H

typedef void *HmcJpegCodecHandle;

enum HmcJpegPixelFormat {
    HMC_JPEG_PF_RGB  = 0,
    HMC_JPEG_PF_BGR  = 1,
    HMC_JPEG_PF_RGBX = 2,
    HMC_JPEG_PF_BGRX = 3,
    HMC_JPEG_PF_XBGR = 4,
    HMC_JPEG_PF_XRGB = 5,
    HMC_JPEG_PF_RGBA = 6,
    HMC_JPEG_PF_BGRA = 7,
    HMC_JPEG_PF_ABGR = 8,
    HMC_JPEG_PF_ARGB = 9,
    HMC_JPEG_PF_CMYK = 10
};

enum HmcJpegChromSubsamp {
    HMC_JPEG_CS_444  = 0,
    HMC_JPEG_CS_422  = 1,
    HMC_JPEG_CS_420  = 2,
    HMC_JPEG_CS_440  = 3,
    HMC_JPEG_CS_411  = 4,
    HMC_JPEG_CS_GRAY = 5
};

inline HmcJpegCodecHandle HmcJpegInitCompress() { return nullptr; }
inline HmcJpegCodecHandle HmcJpegInitDecompress() { return nullptr; }
inline int HmcJpegDestroy(HmcJpegCodecHandle) { return 0; }
inline int HmcJpegCompress2(HmcJpegCodecHandle, const unsigned char *, int, int, int, int, unsigned char **, unsigned long *, int, int, int) { return -1; }
inline int HmcJpegCompressFromYUV(HmcJpegCodecHandle, const unsigned char *, int, int, int, int, unsigned char **, unsigned long *, int, int) { return -1; }
inline int HmcJpegDecompressHeader3(HmcJpegCodecHandle, const unsigned char *, unsigned long, int *, int *, int *, int *) { return -1; }
inline int HmcJpegDecompress2(HmcJpegCodecHandle, const unsigned char *, unsigned long, unsigned char *, int, int, int, int, int) { return -1; }
inline int HmcJpegDecompressToYUV2(HmcJpegCodecHandle, const unsigned char *, unsigned long, unsigned char *, int, int, int, int) { return -1; }
inline unsigned long HmcJpegBufSizeYUV2(int, int, int, int) { return 0; }
inline void HmcJpegFree(unsigned char *) {}
inline int HmcJpegGetErrorCode(HmcJpegCodecHandle) { return 0; }
inline char *HmcJpegGetErrorStr(HmcJpegCodecHandle) { static char e[1] = {0}; return e; }

#endif
