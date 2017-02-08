//
//  DSP_FFT.h
//  SpectralEQ
//
//  Created by Owl on 2/2/17.
//  Copyright (c) 2017 DeepakChennakkadan. All rights reserved.
//

#ifndef __SpectralEQ__DSP_FFT__
#define __SpectralEQ__DSP_FFT__

#include <Accelerate/Accelerate.h>
#include "CAAutoDisposer.h"
#include "CABitOperations.h"
#include <CoreAudio/CoreAudioTypes.h>

class DSP_FFT
{
public:
    
    enum Window
    {
        Rectangular = 1,
        Hann = 2,
        Hamming = 3,
        Blackman = 4
    };
    
    
    DSP_FFT();
    ~DSP_FFT();
    
    void Allocate(UInt32 inNumChannels, UInt32 capacity);
    bool CopyInputToRingBuffer(UInt32 inNumFrames, AudioBufferList* inInput);
    bool ApplyFFT(UInt32 inNumFrames, Window w = Rectangular);
    bool GetMagnitudes(Float32 *result, const Window w, const UInt32 channelSelect);
    
protected:
    
    
    void SetupFFT(UInt size, UInt32 log2Size, UInt32 bins);
    void ConvertRingBuffer(UInt32 inNumFrames);
    void ApplyWindow(Window w);
    
private:
    
    struct Buffers
    {
        CAAutoFree<Float32> mRingBufferData;
        CAAutoFree<Float32> mInputData;
        CAAutoFree<Float32> mOutputData;
        CAAutoFree<Float32> mSplitData;
        CAAutoFree<DSPSplitComplex> mDSPSplitComplex;
    };
    
    bool mSetupStatus;
    FFTSetup mFFTSetup;
    UInt32 mFFTSize;
    
    UInt32 mNumChannels;
    UInt32 mRingBufferCapacity;
    UInt32 mRingBufferPosRead;
    UInt32 mRingBufferPosWrite;
    UInt32 mRingBufferCount;
    
    CAAutoArrayDelete<Buffers> mChannels;
    CAAutoFree<Float32> mWindowData;
};

#endif /* defined(__SpectralEQ__DSP_FFT__) */
