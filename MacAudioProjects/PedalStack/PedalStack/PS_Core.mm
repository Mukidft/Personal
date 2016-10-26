//
//  PS_Core.mm
//  PedalStack
//
//  Created by Lipstick on 10/10/16.
//  Copyright (c) 2016 Deepak Chennakkadan. All rights reserved.
//

#import "PS_Core.h"

@implementation PS_Core

- (void) awakeFromNib
{
    [self initializeGraph];
}

- (void) initializeGraph
{
    OSStatus result = noErr;
    
    result = NewAUGraph(&mGraph);
    
    AUNode outputNode;
    
    // Initialize Base Effects
    mEffectIDs = {kAudioUnitSubType_BandPassFilter, kAudioUnitSubType_Delay};
    
    // Store Output Description and add the node
    mCompDesc = {kAudioUnitType_Output, kAudioUnitSubType_HALOutput, kAudioUnitManufacturer_Apple, 0, 0};
    
    result = AUGraphAddNode(mGraph, &mCompDesc, &outputNode);
    
    if (result)
    {
        printf("AUGraphAddNode 1 result %lu %4.4s\n", (unsigned long)result, (char*)&result);
        return;
    }
    
    for(UInt32 effectID : mEffectIDs)
    {
        PS_Effects *NewEffect = new PS_Effects(effectID, mGraph, outputNode);
        mEffects.push_back(NewEffect);
    }
    
    if(mEffects.size() == 1)
        mEffects[0]->ConnectEffectIO(mEffects[0]->GetEffectNode(), outputNode);
    else
    {
        for(int i = 0; i < mEffects.size(); ++i)
        {
            if(i == mEffects.size() - 1)
            {
                mEffects[i]->ConnectEffectIO(mEffects[i]->GetEffectNode(), outputNode);
                break;
            }
                
            mEffects[i]->ConnectEffectIO(mEffects[i]->GetEffectNode(), mEffects[i + 1]->GetEffectNode());
        }
    }
                                
    // Open The Graph
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
    
    // Get The Node Info
    for(PS_Effects *effect : mEffects)
        effect->GetEffectInfo();
    
    UInt32 size;
    
    AURenderCallbackStruct renderObj;
    renderObj.inputProc = &renderInput;
    //renderObj.inputProcRefCon = &modules;
    
    
    result = AudioUnitSetProperty(mEffects[0]->GetEffectAU(),
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
    
    
    float *outA = (float*)ioData->mBuffers[0].mData;
    float *outB = (float*)ioData->mBuffers[1].mData;
    
    for(unsigned i = 0; i < inNumberFrames; i++)
    {
        float tone = (float)drand48() * 2.0 - 1.0;;
        outA[i] = tone;
        outB[i] = tone;
    }
    
    
    
    return noErr;
}

@end
