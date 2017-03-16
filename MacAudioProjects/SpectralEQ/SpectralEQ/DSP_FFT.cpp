//
//  DSP_FFT.cpp
//  SpectralEQ
//
//  Created by Owl on 2/2/17.
//  Copyright (c) 2017 DeepakChennakkadan. All rights reserved.
//

#include "DSP_FFT.h"
#include <iostream>

#define kHannFactor -3.2
#define kHammingFactor 1.0
#define kBlackmanFactor 2.37

DSP_FFT::DSP_FFT(): mSetupStatus(false), mFFTSize(0), mNumChannels(0), mRingBufferPosRead(0), mRingBufferPosWrite(0), mRingBufferCount(0)
{

}

DSP_FFT::~DSP_FFT()
{
    if(mSetupStatus)
        vDSP_destroy_fftsetup(mFFTSetup);
}

void DSP_FFT::Allocate(UInt32 inNumChannels, UInt32 capacity)
{
    mNumChannels = inNumChannels;
    mRingBufferCapacity = NextPowerOfTwo(capacity);
    mRingBufferCount = (mRingBufferPosRead = ( mRingBufferPosWrite = 0));
    
    mChannels.alloc(mNumChannels);
    
    for(UInt32 i = 0; i < mNumChannels; ++i)
    {
        mChannels[i].mRingBufferData.alloc(capacity);
    }
}

void DSP_FFT::SetupFFT(UInt32 size, UInt32 log2Size, UInt32 bins)
{
    if(mSetupStatus)
        vDSP_destroy_fftsetup(mFFTSetup);
    
    // Initialize data
    mFFTSetup = vDSP_create_fftsetup(log2Size, FFT_RADIX2);
    mSetupStatus = true;
    mFFTSize = size;
    
    for(UInt32 i = 0; i < mNumChannels; ++i)
    {
        mChannels[i].mInputData.alloc(size, true);
        mChannels[i].mOutputData.alloc(size, true);
        mChannels[i].mSplitData.alloc(size, true);
        mChannels[i].mDSPSplitComplex.alloc(1);
        mChannels[i].mDSPSplitComplex->realp = mChannels[i].mSplitData();
        mChannels[i].mDSPSplitComplex->imagp = mChannels[i].mSplitData() + bins;
    }
    
    mWindowData.alloc(size);
}

bool DSP_FFT::ApplyFFT(UInt32 inNumFrames, Window w)
{
    inNumFrames = NextPowerOfTwo(inNumFrames);
    
    // If data is not enough
    if(inNumFrames > mRingBufferCount)
        return false;
    
    UInt32 log2FFTSize = Log2Ceil(inNumFrames);
    UInt32 bins = inNumFrames >> 1;
    
    if(!mSetupStatus || mFFTSize != inNumFrames)
        SetupFFT(inNumFrames, log2FFTSize, bins);
    
    ConvertRingBuffer(inNumFrames);
    
    ApplyWindow(w);
    
    for (UInt32 i=0; i<mNumChannels; ++i)
    {
        vDSP_ctoz((DSPComplex*)mChannels[i].mInputData(), 2, mChannels[i].mDSPSplitComplex(), 1, bins);
        vDSP_fft_zrip(mFFTSetup, mChannels[i].mDSPSplitComplex(), 1, log2FFTSize, FFT_FORWARD);
        
        // zero DC
        *(mChannels[i].mDSPSplitComplex->realp) = 0;
        *(mChannels[i].mDSPSplitComplex->imagp) = 0;
    }
    
    return true;
}

void DSP_FFT::ApplyWindow(Window w)
{
    if(w == Rectangular)
        return;
    
    switch (w)
    {
        case Hann:
            vDSP_hann_window(mWindowData(), mFFTSize, vDSP_HANN_NORM);
            break;
        case Hamming:
            vDSP_hamm_window(mWindowData(), mFFTSize, 0);
            break;
        case Blackman:
            vDSP_blkman_window(mWindowData(), mFFTSize, 0);
            break;
        default:
            break;
    }
    
    for (UInt32 i = 0; i < mNumChannels; ++i)
    {
        vDSP_vmul(mChannels[i].mInputData(), 1, mWindowData(), 1, mChannels[i].mInputData(), 1, mFFTSize);
    }
}

bool DSP_FFT::CopyInputToRingBuffer(UInt32 inNumFrames, AudioBufferList* inInput)
{
    if(inNumFrames > mRingBufferCapacity)
        return false;
    
    UInt32 numBytes = inNumFrames * sizeof(Float32);
    UInt32 firstPart = mRingBufferCapacity - mRingBufferPosWrite;
    
    
    if (firstPart < inNumFrames)
    {
        UInt32 firstPartBytes = firstPart * sizeof(Float32);
        UInt32 secondPartBytes = numBytes - firstPartBytes;
        
        for(UInt32 i = 0; i < mNumChannels; ++i)
        {
            
            memcpy(mChannels[i].mRingBufferData() + mRingBufferPosWrite, inInput->mBuffers[i].mData, firstPartBytes);
            
            memcpy(mChannels[i].mRingBufferData(), (Float32*)inInput->mBuffers[i].mData + firstPart, secondPartBytes);
        }
    }
    else
    {
        for (UInt32 i=0; i<mNumChannels; ++i)
        {
            memcpy(mChannels[i].mRingBufferData() + mRingBufferPosWrite, inInput->mBuffers[i].mData, numBytes);
        }
    }
    
    mRingBufferPosWrite = (mRingBufferPosWrite + inNumFrames) & (mRingBufferCapacity-1);
    mRingBufferCount = MIN(mRingBufferCount + inNumFrames, mRingBufferCapacity);
    
    return true;
}

void DSP_FFT::ConvertRingBuffer(UInt32 inNumFrames)
{
    UInt32 bytes = inNumFrames * sizeof(Float32);
    UInt32 firstPart = mRingBufferCapacity - mRingBufferPosRead;
    
    if(firstPart < inNumFrames)
    {
        UInt32 firstPartBytes = firstPart * sizeof(Float32);
        UInt32 secondPartBytes = bytes - firstPartBytes;
        
        for (UInt32 i = 0; i < mNumChannels; ++i)
        {
            memcpy(mChannels[i].mInputData(), mChannels[i].mRingBufferData() + mRingBufferPosRead, firstPartBytes);
            
            memcpy(mChannels[i].mInputData() + firstPart, mChannels[i].mRingBufferData(), secondPartBytes);
        }
    }
    else
    {
        for (UInt32 i = 0; i < mNumChannels; ++i)
        {
            memcpy(mChannels[i].mInputData(), mChannels[i].mRingBufferData() + mRingBufferPosRead, bytes);
        }
    }
    
    mRingBufferPosRead = (mRingBufferPosRead + inNumFrames) & (mRingBufferCapacity - 1);
    mRingBufferCount -= inNumFrames;
}

bool DSP_FFT::GetMagnitudes(Float32 *result, const Window w, const UInt32 channelSelect)
{
    UInt32 bins = mFFTSize >> 1;
    Float32 one(1), two(2), fBins(bins), fGainOffset;
    
    for (UInt32 i=0; i<mNumChannels; ++i)
    {
        // compute Z magnitude
        vDSP_zvabs(mChannels[i].mDSPSplitComplex(), 1, mChannels[i].mOutputData(), 1, bins);
        vDSP_vsdiv(mChannels[i].mOutputData(), 1, &fBins, mChannels[i].mOutputData(), 1, bins);
        
        // convert to Db
        vDSP_vdbcon(mChannels[i].mOutputData(), 1, &one, mChannels[i].mOutputData(), 1, bins, 1);
        
        // db correction considering window
        switch (w)
        {
            case Hann:
                fGainOffset = kHannFactor;
                break;
            case Hamming:
                fGainOffset = kHammingFactor;
                break;
            case Blackman:
                fGainOffset = kBlackmanFactor;
                break;
            default:
                break;
        }
        
        vDSP_vsadd(mChannels[i].mOutputData(), 1, &fGainOffset, mChannels[i].mOutputData(), 1, bins);
    }
    
    // stereo analysis
    if (channelSelect == 3 && mNumChannels > 1 && mNumChannels < 3)
    {
        vDSP_vadd(mChannels[0].mOutputData(), 1, mChannels[1].mOutputData(), 1, result, 1, bins);
        vDSP_vsdiv(result, 1, &two, result, 1, bins);
        
        return true;
    }
    
    // mono analysis
    if (channelSelect <= mNumChannels)
    {
        memcpy(result, mChannels[channelSelect-1].mOutputData(), bins * sizeof(Float32));
        
        return true;
    }
    
    return false;
}

