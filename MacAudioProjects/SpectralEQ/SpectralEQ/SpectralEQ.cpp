/*
 
     File: SpectralEQ.cpp
 Abstract: Audio Unit class implementation.
  Version: 1.0.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 
*/

#include "SpectralEQ.h"
#include <iostream>

#define kMaxBlockSize 16384

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// COMPONENT_ENTRY(SpectralEQ) deprecated on MacOS X 10.7 see TN2276 

AUDIOCOMPONENT_ENTRY(AUBaseFactory, SpectralEQ)


OSStatus renderInput(void *inRefCon,
                     AudioUnitRenderActionFlags *ioActionFlags,
                     const AudioTimeStamp *inTimeStamp,
                     UInt32 inBusNumber,
                     UInt32 inNumberFrames,
                     AudioBufferList *ioData)
{
    
    SpectralEQ *This = (SpectralEQ *)inRefCon;
    
    memcpy((float*)ioData->mBuffers[0].mData, This->mSource, ioData->mBuffers[0].mDataByteSize);
    
    // Compute FFT for the dry signal
    
    This->mDSP_FFT_Dry.CopyInputToRingBuffer(inNumberFrames, ioData);
    
    UInt32 currentBlockSize = 1024;
    
    DSP_FFT::Window currentWindow = DSP_FFT::Window::Blackman;
    
    switch((int)This->GetParameter(kParam_WINDOW))
    {
        case 0:
            currentWindow = DSP_FFT::Window::Rectangular;
            break;
        case 1:
            currentWindow = DSP_FFT::Window::Hann;
            break;
        case 2:
            currentWindow = DSP_FFT::Window::Hamming;
            break;
        case 3:
            currentWindow = DSP_FFT::Window::Blackman;
            break;
            
    }
    
    
    if(This->mDSP_FFT_Dry.ApplyFFT(currentBlockSize, currentWindow))
    {
        This->mInfos_Dry.mNumBins = currentBlockSize >> 1;
        
        UInt32 channelSelect = 1;
        
        if(This->mDSP_FFT_Dry.GetMagnitudes(This->mComputedMagnitudes_Dry, currentWindow, channelSelect))
        {
            This->PropertyChanged(kAudioUnitProperty_SpectrumGraphData_Dry, kAudioUnitScope_Global, 0);
        }
    }

    
    return noErr;
}

void SpectralEQ::initializeGraph()
{
    mResult = noErr;
    
    mResult = NewAUGraph(&mGraph);
    ErrorCheck(NewGraph);
    
    // Store Output Description and add the node
    mCompDesc = {kAudioUnitType_Output, kAudioUnitSubType_GenericOutput, kAudioUnitManufacturer_Apple, 0, 0};
    
    mResult = AUGraphAddNode(mGraph, &mCompDesc, &outputNode);
    ErrorCheck(NodeAdded);
    
    // Open The Graph
    mResult = AUGraphOpen(mGraph);
    ErrorCheck(GraphOpen);
    
    mResult = AUGraphNodeInfo(mGraph, outputNode, NULL, &output);
    ErrorCheck(NodeInfo);
    
    
    AudioComponentDescription eqCompDesc;
    
    // Store Output Description and add the node
    eqCompDesc = {kAudioUnitType_Effect, kAudioUnitSubType_ParametricEQ, kAudioUnitManufacturer_Apple, 0, 0};
    
    mResult = AUGraphAddNode(mGraph, &eqCompDesc, &eq_node[0]);
    ErrorCheck(NodeAdded);
    
    for(int i = 0; i < EQBANDS; i++)
    {
        if(i != EQBANDS - 1)
        {
            mResult = AUGraphAddNode(mGraph, &eqCompDesc, &eq_node[i+1]);
            ErrorCheck(NodeAdded);
        }
        
        // Route incoming audio to the output
        
        if(i != EQBANDS - 1)
        {
            mResult = AUGraphConnectNodeInput(mGraph, eq_node[i], 0, eq_node[i+1], 0);
            ErrorCheck(NodeConnected);
        }
        else
        {
            mResult = AUGraphConnectNodeInput(mGraph, eq_node[i], 0, outputNode, 0);
            ErrorCheck(NodeConnected);
        }
        
        mResult = AUGraphNodeInfo(mGraph, eq_node[i], NULL, &eq_au[i]);
        ErrorCheck(NodeInfo);
        
        setStreamDescription(eq_au[i]);
    }
    
    UInt32 size;
    size = sizeof(mStreamDesc);
    
    AURenderCallbackStruct renderObj;
    renderObj.inputProc = &renderInput;
    renderObj.inputProcRefCon = this;
    
    
    // Render callback
    mResult = AudioUnitSetProperty(eq_au[0],
                                   kAudioUnitProperty_SetRenderCallback,
                                   kAudioUnitScope_Input,
                                   0,
                                   &renderObj,
                                   sizeof(renderObj) );
    
    ErrorCheck(NodeSetProperty);
    
    Boolean valid;
    
    AudioUnitGetPropertyInfo(output, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &size, &valid);
    
    if(valid)
    {
        mResult = AudioUnitGetProperty(output,
                                       kAudioUnitProperty_StreamFormat,
                                       kAudioUnitScope_Output,
                                       0,
                                       &mStreamDesc,
                                       &size );
        
        ErrorCheck(NodeGetProperty);
        
        mStreamDesc.mChannelsPerFrame = 1;
        
        mResult = AudioUnitSetProperty(output,
                                       kAudioUnitProperty_StreamFormat,
                                       kAudioUnitScope_Output,
                                       0,
                                       &mStreamDesc,
                                       size );
        
        ErrorCheck(NodeSetProperty);
    }
    
    mResult = AUGraphInitialize(mGraph);
    ErrorCheck(GraphInitialize);
    
    CAShow(mGraph);
    
    mResult = AUGraphStart(mGraph);
    ErrorCheck(GraphStart);
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	SpectralEQ::SpectralEQ
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SpectralEQ::SpectralEQ(AudioUnit component)	: AUEffectBase(component)
{
	CreateElements();
	Globals()->UseIndexedParameters(kNumberOfParameters);
	SetParameter(kParam_One, kDefaultValue_ParamOne );
    SetParameter(kParam_EQ1_F, kDefaultValue_Param_EQ1_F);
    SetParameter(kParam_EQ1_Q, kDefaultValue_Param_EQ1_Q);
    SetParameter(kParam_EQ1_G, kDefaultValue_Param_EQ1_G);
    SetParameter(kParam_EQ2_F, kDefaultValue_Param_EQ2_F);
    SetParameter(kParam_EQ2_Q, kDefaultValue_Param_EQ2_Q);
    SetParameter(kParam_EQ2_G, kDefaultValue_Param_EQ2_G);
    SetParameter(kParam_EQ3_F, kDefaultValue_Param_EQ3_F);
    SetParameter(kParam_EQ3_Q, kDefaultValue_Param_EQ3_Q);
    SetParameter(kParam_EQ3_G, kDefaultValue_Param_EQ3_G);
    SetParameter(kParam_EQ4_F, kDefaultValue_Param_EQ4_F);
    SetParameter(kParam_EQ4_Q, kDefaultValue_Param_EQ4_Q);
    SetParameter(kParam_EQ4_G, kDefaultValue_Param_EQ4_G);
    SetParameter(kParam_EQ5_F, kDefaultValue_Param_EQ5_F);
    SetParameter(kParam_EQ5_Q, kDefaultValue_Param_EQ5_Q);
    SetParameter(kParam_EQ5_G, kDefaultValue_Param_EQ5_G);
    SetParameter(kParam_EQ6_F, kDefaultValue_Param_EQ6_F);
    SetParameter(kParam_EQ6_Q, kDefaultValue_Param_EQ6_Q);
    SetParameter(kParam_EQ6_G, kDefaultValue_Param_EQ6_G);
    SetParameter(kParam_EQ1_BYPASS, kDefaultValue_Param_EQ1_BYPASS);
    SetParameter(kParam_EQ2_BYPASS, kDefaultValue_Param_EQ2_BYPASS);
    SetParameter(kParam_EQ3_BYPASS, kDefaultValue_Param_EQ3_BYPASS);
    SetParameter(kParam_EQ4_BYPASS, kDefaultValue_Param_EQ4_BYPASS);
    SetParameter(kParam_EQ5_BYPASS, kDefaultValue_Param_EQ5_BYPASS);
    SetParameter(kParam_EQ6_BYPASS, kDefaultValue_Param_EQ6_BYPASS);
    SetParameter(kParam_WINDOW, kDefaultValue_Param_WINDOW);
	
}

OSStatus SpectralEQ::Initialize()
{
    OSStatus result = AUEffectBase::Initialize();
    
    if(result == noErr)
    {
        mDSP_FFT_Wet.Allocate(GetNumberOfChannels(), kMaxBlockSize);
        mComputedMagnitudes_Wet.alloc(kMaxBlockSize >> 1);
        
        mInfos_Wet.mNumBins = 0;
        mInfos_Wet.mNumChannels = GetNumberOfChannels();
        mInfos_Wet.mSamplingRate = GetSampleRate();
        
        mDSP_FFT_Dry.Allocate(GetNumberOfChannels(), kMaxBlockSize);
        mComputedMagnitudes_Dry.alloc(kMaxBlockSize >> 1);
        
        mInfos_Dry.mNumBins = 0;
        mInfos_Dry.mNumChannels = GetNumberOfChannels();
        mInfos_Dry.mSamplingRate = GetSampleRate();
    }
    
    initializeGraph();
    
    return result;
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	SpectralEQ::GetParameterValueStrings
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OSStatus			SpectralEQ::GetParameterValueStrings(AudioUnitScope		inScope,
                                                                AudioUnitParameterID	inParameterID,
                                                                CFArrayRef *		outStrings)
{
        
    return kAudioUnitErr_InvalidProperty;
}



//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	SpectralEQ::GetParameterInfo
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OSStatus			SpectralEQ::GetParameterInfo(AudioUnitScope		inScope,
                                                        AudioUnitParameterID	inParameterID,
                                                        AudioUnitParameterInfo	&outParameterInfo )
{
	OSStatus result = noErr;

	outParameterInfo.flags = 	kAudioUnitParameterFlag_IsWritable + kAudioUnitParameterFlag_IsReadable;
    
    if (inScope == kAudioUnitScope_Global) {
        switch(inParameterID)
        {
            case kParam_One:
                AUBase::FillInParameterName (outParameterInfo, kParameterOneName, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0.0;
                outParameterInfo.maxValue = 1;
                outParameterInfo.defaultValue = kDefaultValue_ParamOne;
                break;
            
            // EQ 1
            case kParam_EQ1_F:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ1_F_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 20;
                outParameterInfo.maxValue = 20000;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ1_F;
                break;
            case kParam_EQ1_Q:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ1_Q_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0.1;
                outParameterInfo.maxValue = 20;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ1_Q;
                break;
            case kParam_EQ1_G:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ1_G_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = -20;
                outParameterInfo.maxValue = 20;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ1_G;
                break;
                
            // EQ 2
            case kParam_EQ2_F:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ2_F_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 20;
                outParameterInfo.maxValue = 20000;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ2_F;
                break;
            case kParam_EQ2_Q:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ2_Q_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0.1;
                outParameterInfo.maxValue = 20;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ2_Q;
                break;
            case kParam_EQ2_G:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ2_G_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = -20;
                outParameterInfo.maxValue = 20;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ2_G;
                break;
                
                // EQ 3
            case kParam_EQ3_F:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ3_F_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 20;
                outParameterInfo.maxValue = 20000;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ3_F;
                break;
            case kParam_EQ3_Q:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ3_Q_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0.1;
                outParameterInfo.maxValue = 20;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ3_Q;
                break;
            case kParam_EQ3_G:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ3_G_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = -20;
                outParameterInfo.maxValue = 20;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ3_G;
                break;
                
                // EQ 4
            case kParam_EQ4_F:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ4_F_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 20;
                outParameterInfo.maxValue = 20000;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ4_F;
                break;
            case kParam_EQ4_Q:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ4_Q_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0.1;
                outParameterInfo.maxValue = 20;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ4_Q;
                break;
            case kParam_EQ4_G:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ4_G_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = -20;
                outParameterInfo.maxValue = 20;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ4_G;
                break;
                
                // EQ 5
            case kParam_EQ5_F:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ5_F_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 20;
                outParameterInfo.maxValue = 20000;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ5_F;
                break;
            case kParam_EQ5_Q:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ5_Q_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0.1;
                outParameterInfo.maxValue = 20;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ5_Q;
                break;
            case kParam_EQ5_G:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ5_G_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = -20;
                outParameterInfo.maxValue = 20;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ5_G;
                break;
                
                // EQ 6
            case kParam_EQ6_F:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ6_F_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 20;
                outParameterInfo.maxValue = 20000;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ6_F;
                break;
            case kParam_EQ6_Q:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ6_Q_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0.1;
                outParameterInfo.maxValue = 20;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ6_Q;
                break;
            case kParam_EQ6_G:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ6_G_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = -20;
                outParameterInfo.maxValue = 20;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ6_G;
                break;
                
                // BYPASS
            case kParam_EQ1_BYPASS:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ1_BYPASS_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0;
                outParameterInfo.maxValue = 1;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ1_BYPASS;
                break;
            case kParam_EQ2_BYPASS:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ2_BYPASS_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0;
                outParameterInfo.maxValue = 1;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ2_BYPASS;
                break;
            case kParam_EQ3_BYPASS:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ3_BYPASS_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0;
                outParameterInfo.maxValue = 1;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ3_BYPASS;
                break;
            case kParam_EQ4_BYPASS:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ4_BYPASS_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0;
                outParameterInfo.maxValue = 1;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ4_BYPASS;
                break;
            case kParam_EQ5_BYPASS:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ5_BYPASS_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0;
                outParameterInfo.maxValue = 1;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ5_BYPASS;
                break;
            case kParam_EQ6_BYPASS:
                AUBase::FillInParameterName (outParameterInfo, kParameter_EQ6_BYPASS_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0;
                outParameterInfo.maxValue = 1;
                outParameterInfo.defaultValue = kDefaultValue_Param_EQ6_BYPASS;
                break;
                
            // WINDOW
            case kParam_WINDOW:
                AUBase::FillInParameterName (outParameterInfo, kParameter_WINDOW_Name, false);
                outParameterInfo.unit = kAudioUnitParameterUnit_LinearGain;
                outParameterInfo.minValue = 0;
                outParameterInfo.maxValue = 1;
                outParameterInfo.defaultValue = kDefaultValue_Param_WINDOW;
                break;
                
            default:
                result = kAudioUnitErr_InvalidParameter;
                break;
            }
	} else {
        result = kAudioUnitErr_InvalidParameter;
    }
    


	return result;
}


// START COCOA UI::
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	SpectralEQ::GetPropertyInfo
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OSStatus			SpectralEQ::GetPropertyInfo (AudioUnitPropertyID	inID,
                                                        AudioUnitScope		inScope,
                                                        AudioUnitElement	inElement,
                                                        UInt32 &		outDataSize,
                                                        Boolean &		outWritable)
{
	if (inScope == kAudioUnitScope_Global) 
	{
		switch (inID) 
		{
			case kAudioUnitProperty_CocoaUI:
				outWritable = false;
				outDataSize = sizeof (AudioUnitCocoaViewInfo);
				return noErr;
            case kAudioUnitProperty_SpectrumGraphInfo_Wet:
                outWritable = false;
                outDataSize = sizeof(SpectrumGraphInfo);
                return noErr;
            case kAudioUnitProperty_SpectrumGraphData_Wet:
                outWritable = false;
                outDataSize = mInfos_Wet.mNumBins * sizeof(Float32);
                return noErr;
            case kAudioUnitProperty_SpectrumGraphInfo_Dry:
                outWritable = false;
                outDataSize = sizeof(SpectrumGraphInfo);
                return noErr;
            case kAudioUnitProperty_SpectrumGraphData_Dry:
                outWritable = false;
                outDataSize = mInfos_Dry.mNumBins * sizeof(Float32);
                return noErr;
					
		}
	}

	return AUEffectBase::GetPropertyInfo (inID, inScope, inElement, outDataSize, outWritable);
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	SpectralEQ::GetProperty
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OSStatus			SpectralEQ::GetProperty(	AudioUnitPropertyID inID,
															AudioUnitScope 		inScope,
															AudioUnitElement 	inElement,
															void *				outData )
{
	if (inScope == kAudioUnitScope_Global) 
	{
		switch (inID) 
		{
			case kAudioUnitProperty_CocoaUI:
			{
				// Look for a resource in the main bundle by name and type.
				CFBundleRef bundle = CFBundleGetBundleWithIdentifier( CFSTR("com.SPEQ.audiounit.SpectralEQ") );
				
				if (bundle == NULL) return fnfErr;
                
				CFURLRef bundleURL = CFBundleCopyResourceURL( bundle, 
                    CFSTR("SpectralEQ_CocoaViewFactory"), 
                    CFSTR("bundle"), 
                    NULL);
                
                if (bundleURL == NULL) return fnfErr;

				AudioUnitCocoaViewInfo cocoaInfo;
				cocoaInfo.mCocoaAUViewBundleLocation = bundleURL;
				cocoaInfo.mCocoaAUViewClass[0] = CFStringCreateWithCString(NULL, "SpectralEQ_CocoaViewFactory", kCFStringEncodingUTF8);
				
				*((AudioUnitCocoaViewInfo *)outData) = cocoaInfo;
				
				return noErr;
            }
            // This property gives infos about the computed magnitudes
            case kAudioUnitProperty_SpectrumGraphInfo_Wet:
            {
                SpectrumGraphInfo* g = (SpectrumGraphInfo*) outData;
                
                g->mNumBins = mInfos_Wet.mNumBins;
                g->mSamplingRate = mInfos_Wet.mSamplingRate;
                g->mNumChannels = mInfos_Wet.mNumChannels;
                
                return noErr;
            }
                // This property sends magnitudes data as Float32
            case kAudioUnitProperty_SpectrumGraphData_Wet:
            {
                Float32* mData = (Float32*) outData;
                
                if(mInfos_Wet.mNumBins > 0)
                {
                    memcpy(mData, mComputedMagnitudes_Wet(), mInfos_Wet.mNumBins * sizeof(Float32));
                }
            }
                // This property gives infos about the computed magnitudes
            case kAudioUnitProperty_SpectrumGraphInfo_Dry:
            {
                SpectrumGraphInfo* g = (SpectrumGraphInfo*) outData;
                
                g->mNumBins = mInfos_Dry.mNumBins;
                g->mSamplingRate = mInfos_Dry.mSamplingRate;
                g->mNumChannels = mInfos_Dry.mNumChannels;
                
                return noErr;
            }
                // This property sends magnitudes data as Float32
            case kAudioUnitProperty_SpectrumGraphData_Dry:
            {
                Float32* mData = (Float32*) outData;
                
                if(mInfos_Dry.mNumBins > 0)
                {
                    memcpy(mData, mComputedMagnitudes_Dry(), mInfos_Dry.mNumBins * sizeof(Float32));
                }
            }
		}
	}

	return AUEffectBase::GetProperty (inID, inScope, inElement, outData);
}

// END COCOA UI

#pragma mark ____SpectralEQEffectKernel


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	SpectralEQ::SpectralEQKernel::Reset()
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void		SpectralEQ::SpectralEQKernel::Reset()
{
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//	SpectralEQ::SpectralEQKernel::Process
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void SpectralEQ::SpectralEQKernel::Process(	const Float32 	*inSourceP,
                                                    Float32		 	*inDestP,
                                                    UInt32 			inFramesToProcess,
                                                    UInt32			inNumChannels, // for version 2 AudioUnits inNumChannels is always 1
                                                    bool			&ioSilence )
{

	//This code will pass-thru the audio data.
	//This is where you want to process data to produce an effect.
    AudioBufferList newList;
    newList.mNumberBuffers = 1;
    newList.mBuffers[0].mNumberChannels = 1;
    newList.mBuffers[0].mDataByteSize = inFramesToProcess * (sizeof(Float32));
    newList.mBuffers[0].mData = inDestP;
    
    ((SpectralEQ*)mAudioUnit)->mSource = inSourceP;
    
	
    OSStatus result = AudioUnitRender(((SpectralEQ*)mAudioUnit)->output, 0, &((SpectralEQ*)mAudioUnit)->timeStamp, 0, inFramesToProcess, &newList);
    
    if (result) {
        printf("AudioUnitRender result %u %4.4s\n", (unsigned int)result, (char*)&result);
        return;
    }
    
	UInt32 nSampleFrames = inFramesToProcess;
	const Float32 *sourceP = inSourceP;
	Float32 *destP = inDestP;
    Float32 gain = GetParameter( kParam_One );
    
    ((SpectralEQ*)mAudioUnit)->SetEQParams(0, GetParameter(kParam_EQ1_F), GetParameter(kParam_EQ1_Q), GetParameter(kParam_EQ1_G));
    ((SpectralEQ*)mAudioUnit)->SetEQParams(1, GetParameter(kParam_EQ2_F), GetParameter(kParam_EQ2_Q), GetParameter(kParam_EQ2_G));
    ((SpectralEQ*)mAudioUnit)->SetEQParams(2, GetParameter(kParam_EQ3_F), GetParameter(kParam_EQ3_Q), GetParameter(kParam_EQ3_G));
    ((SpectralEQ*)mAudioUnit)->SetEQParams(3, GetParameter(kParam_EQ4_F), GetParameter(kParam_EQ4_Q), GetParameter(kParam_EQ4_G));
    ((SpectralEQ*)mAudioUnit)->SetEQParams(4, GetParameter(kParam_EQ5_F), GetParameter(kParam_EQ5_Q), GetParameter(kParam_EQ5_G));
    ((SpectralEQ*)mAudioUnit)->SetEQParams(5, GetParameter(kParam_EQ6_F), GetParameter(kParam_EQ6_Q), GetParameter(kParam_EQ6_G));
    
    ((SpectralEQ*)mAudioUnit)->SetBypass(0, GetParameter(kParam_EQ1_BYPASS));
    ((SpectralEQ*)mAudioUnit)->SetBypass(1, GetParameter(kParam_EQ2_BYPASS));
    ((SpectralEQ*)mAudioUnit)->SetBypass(2, GetParameter(kParam_EQ3_BYPASS));
    ((SpectralEQ*)mAudioUnit)->SetBypass(3, GetParameter(kParam_EQ4_BYPASS));
    ((SpectralEQ*)mAudioUnit)->SetBypass(4, GetParameter(kParam_EQ5_BYPASS));
    ((SpectralEQ*)mAudioUnit)->SetBypass(5, GetParameter(kParam_EQ6_BYPASS));
    
    
	while (nSampleFrames-- > 0) {
		Float32 inputSample = *sourceP;
		
		//The current (version 2) AudioUnit specification *requires* 
	    //non-interleaved format for all inputs and outputs. Therefore inNumChannels is always 1
		
		sourceP += inNumChannels;	// advance to next frame (e.g. if stereo, we're advancing 2 samples);
									// we're only processing one of an arbitrary number of interleaved channels

			// here's where you do your DSP work
                Float32 outputSample = inputSample * gain;
		
		*destP = outputSample;
		destP += inNumChannels;
	}
    
    // Compute FFT for the wet signal
    
    ((SpectralEQ*)mAudioUnit)->mDSP_FFT_Wet.CopyInputToRingBuffer(inFramesToProcess, &newList);
    
    UInt32 currentBlockSize = 1024;
    
    DSP_FFT::Window currentWindow = DSP_FFT::Window::Blackman;
    
    switch((int)GetParameter(kParam_WINDOW))
    {
        case 0:
            currentWindow = DSP_FFT::Window::Rectangular;
            break;
        case 1:
            currentWindow = DSP_FFT::Window::Hann;
            break;
        case 2:
            currentWindow = DSP_FFT::Window::Hamming;
            break;
        case 3:
            currentWindow = DSP_FFT::Window::Blackman;
            break;
            
    }
    
    
    if(((SpectralEQ*)mAudioUnit)->mDSP_FFT_Wet.ApplyFFT(currentBlockSize, currentWindow))
    {
        ((SpectralEQ*)mAudioUnit)->mInfos_Wet.mNumBins = currentBlockSize >> 1;
        
        UInt32 channelSelect = 1;
        
        if(((SpectralEQ*)mAudioUnit)->mDSP_FFT_Wet.GetMagnitudes(((SpectralEQ*)mAudioUnit)->mComputedMagnitudes_Wet, currentWindow, channelSelect))
        {
            ((SpectralEQ*)mAudioUnit)->PropertyChanged(kAudioUnitProperty_SpectrumGraphData_Wet, kAudioUnitScope_Global, 0);
        }
    }
}


void SpectralEQ::SetEQParams(int index, AudioUnitParameterValue F, AudioUnitParameterValue Q, AudioUnitParameterValue G)
{
    mResult = AudioUnitSetParameter(eq_au[index], kParametricEQParam_CenterFreq, kAudioUnitScope_Global, 0, F, 0);
    ErrorCheck(NodeParameter);
    
    mResult = AudioUnitSetParameter(eq_au[index], kParametricEQParam_Q, kAudioUnitScope_Global, 0, Q, 0);
    ErrorCheck(NodeParameter);
    
    mResult = AudioUnitSetParameter(eq_au[index], kParametricEQParam_Gain, kAudioUnitScope_Global, 0, G, 0);
    ErrorCheck(NodeParameter);
}

void SpectralEQ::SetBypass(int index, int state)
{
    UInt32 bypassed = state;
    mResult = AudioUnitSetProperty(eq_au[index], kAudioUnitProperty_BypassEffect, kAudioUnitScope_Global, 0, &bypassed, sizeof(bypassed));
    ErrorCheck(NodeSetProperty);
}

OSStatus SpectralEQ::Render(AudioUnitRenderActionFlags & ioActionFlags,
                           const AudioTimeStamp & inTimeStamp,
                           UInt32 inFramesToProcess )
{
    
    timeStamp = inTimeStamp;
    
    
    UInt32 actionFlags = 0;
    OSStatus err = PullInput(0, actionFlags, inTimeStamp, inFramesToProcess);
    
    if(err)
        return err;
    
    GetOutput(0)->PrepareBuffer(inFramesToProcess);
    
    return AUEffectBase::Render(ioActionFlags, inTimeStamp, inFramesToProcess);
}


void SpectralEQ::setStreamDescription(AudioUnit au)
{
    UInt32 size = sizeof(mStreamDesc);
    
    mResult = AudioUnitGetProperty(output,
                                   kAudioUnitProperty_StreamFormat,
                                   kAudioUnitScope_Input,
                                   0,
                                   &mStreamDesc,
                                   &size );
    
    ErrorCheck(NodeGetProperty);
    
    mResult = AudioUnitSetProperty(au,
                                   kAudioUnitProperty_StreamFormat,
                                   kAudioUnitScope_Output,
                                   0,
                                   &mStreamDesc,
                                   size );
    
    ErrorCheck(NodeSetProperty);

}

void SpectralEQ::ErrorCheck(ErrorType error)
{
    if(mResult)
    {
        switch(error)
        {
            case NewGraph:
                printf("Graph could not be created! Result: %d\n", mResult);
                break;
            case GraphOpen:
                printf("Graph could not be opened! Result: %d\n", mResult);
                break;
            case GraphInitialize:
                printf("Graph could not be initialized! Result: %d\n", mResult);
                break;
            case GraphStart:
                printf("Graph could not be started! Result: %d\n", mResult);
                break;
            case NodeAdded:
                printf("Effect Node could not be added! Result: %d\n", mResult);
                break;
            case NodeConnected:
                printf("Effect Node could not be connected! Result: %d\n", mResult);
                break;
            case NodeInfo:
                printf("Could not get AU Graph Node information! Result: %d\n", mResult);
                break;
            case NodeParameter:
                printf("Could not set parameter! Result: %d\n", mResult);
                break;
            case NodeSetProperty:
                printf("Could not set property! Result: %d\n", mResult);
                break;
            case NodeGetProperty:
                printf("Could not get property! Result: %d\n", mResult);
                break;
            default:
                break;
                
        }
    }
}

