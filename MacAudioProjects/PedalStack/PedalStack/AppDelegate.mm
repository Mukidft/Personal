//
//  AppDelegate.m
//  PedalStack
//
//  Created by Lipstick on 10/10/16.
//  Copyright (c) 2016 Deepak Chennakkadan. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioUnit/AudioUnitParameters.h>
#import <AudioUnit/AudioUnitProperties.h>


#include <iostream>

#define L_HZ 440
#define R_HZ 1760
#define BPM 120

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)awakeFromNib
{
    [self initializeGraph];
}


- (IBAction)test:(id)sender
{
}

- (void) initializeGraph
{
    OSStatus result = noErr;
    
    result = NewAUGraph(&mGraph);
    
    AUNode outputNode;
    
    mCompDesc.componentType = kAudioUnitType_Output;
    mCompDesc.componentSubType = kAudioUnitSubType_DefaultOutput;
    mCompDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    mCompDesc.componentFlagsMask = 0;
    mCompDesc.componentFlags = 0;
    
    result = AUGraphAddNode(mGraph, &mCompDesc, &outputNode);
    
    if (result)
    {
        printf("AUGraphAddNode 1 result %lu %4.4s\n", (unsigned long)result, (char*)&result);
        return;
    }
    
    result = AUGraphOpen(mGraph);
    
    if (result)
    {
        printf("AUGraphOpen result %u %4.4s\n", (unsigned int)result, (char*)&result);
        return;
    }
    
    result = AUGraphNodeInfo(mGraph, outputNode, NULL, &output);
    
    if (result) {
        printf("AUGraphNodeInfo result %u %4.4s\n", (unsigned int)result, (char*)&result);
        return;
    }
    
    UInt32 size;
    
    AURenderCallbackStruct renderObj;
    renderObj.inputProc = &renderInput;
    //renderObj.inputProcRefCon = &modules;
    
    
    result = AudioUnitSetProperty(output,
                                  kAudioUnitProperty_SetRenderCallback,
                                  kAudioUnitScope_Input,
                                  0,
                                  &renderObj,
                                  sizeof(renderObj) );
    
    size = sizeof(mStreamDesc);
    result = AudioUnitGetProperty(output,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Input,
                                  0,
                                  &mStreamDesc,
                                  &size );
    
    result = AudioUnitSetProperty(output,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  0,
                                  &mStreamDesc,
                                  sizeof(mStreamDesc) );
    
    //modules.generator.SetSampleRate(mStreamDesc.mSampleRate);
    
    AUGraphInitialize(mGraph);
    CAShow(mGraph);
    
    AUGraphStart(mGraph);
    
}

OSStatus renderInput(void *inRefCon,
                     AudioUnitRenderActionFlags *ioActionFlags,
                     const AudioTimeStamp *inTimeStamp,
                     UInt32 inBusNumber,
                     UInt32 inNumberFrames,
                     AudioBufferList *ioData)
{
    
    /*
     float *outA = (float*)ioData->mBuffers[0].mData;
    float *outB = (float*)ioData->mBuffers[1].mData;
    
    for(unsigned i = 0; i < inNumberFrames; i++)
    {
        float tone = sin(2 * M_PI * (440.0f) * (inTimeStamp->mSampleTime + i)/ 44100.0f);
        outA[i] = tone;
        outB[i] = tone;
    }
    */
    
    
    return noErr;
}

@end
