//
//  SpectralEQDefinitions.h
//  SpectralEQ
//
//  Created by Owl on 2/9/17.
//  Copyright (c) 2017 DeepakChennakkadan. All rights reserved.
//

#ifndef SpectralEQ_SpectralEQDefinitions_h
#define SpectralEQ_SpectralEQDefinitions_h

enum
{
    kSpectrumParam_BlockSize = 0,
    kSpectrumParam_SelectChannel = 1,
    kSpectrumParam_Window = 2
};

#pragma mark ___SimpleSpectrum Properties
enum
{
    kAudioUnitProperty_SpectrumGraphInfo_Wet = 65536,
    kAudioUnitProperty_SpectrumGraphData_Wet = 65537,
    kAudioUnitProperty_SpectrumGraphInfo_Dry = 65538,
    kAudioUnitProperty_SpectrumGraphData_Dry = 65539,
};

typedef struct SpectrumGraphInfo
{
    Float64 mSamplingRate;
    SInt32 mNumBins;
    SInt32 mNumChannels;
} SpectrumGraphInfo;

#endif
