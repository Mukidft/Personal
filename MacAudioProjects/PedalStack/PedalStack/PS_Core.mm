//
//  PS_Core.mm
//  PedalStack
//
//  Created by Lipstick on 10/10/16.
//  Copyright (c) 2016 Deepak Chennakkadan. All rights reserved.
//

#define TEST 0

#import "PS_Core.h"
#include <iostream>

@implementation PS_Core

- (void) awakeFromNib
{
    [self initializeGraph];
}

- (void) CreateNewEffect: (UInt32) effect arg2: (AUGraph) graph arg3: (AUNode) outNode
{
    PS_Effects *NewEffect = new PS_Effects(effect, mGraph, outNode, mStreamDesc);
    mEffects.push_back(NewEffect);
    mEffectIDs.push_back(effect);
}

- (void) AddNewEffect: (UInt32) effect
{
    [self CreateNewEffect:effect arg2:mGraph arg3:outputNode];
    
    // Stop the graph
    AUGraphStop(mGraph);
    
    // Disconnect the output node
    AUGraphDisconnectNodeInput(mGraph, outputNode, 0);
    
    if(mEffects.size() == 1)
    {
        // If only one effect is in the signal chain
        mEffects[mEffects.size() - 1]->ConnectEffectIO(outputNode, mEffects[mEffects.size() - 1]->GetEffectNode(), 1);
    }
    else
    {
        // If more than one effects are present in the signal chain
        mEffects[mEffects.size() - 2]->ConnectEffectIO(mEffects[mEffects.size() - 2]->GetEffectNode(), mEffects[mEffects.size() - 1]->GetEffectNode());
        mEffects[mEffects.size() - 2]->GetEffectInfo();
        mEffects[mEffects.size() - 2]->SetStreamDescription(output);
    }
    
    // Route the effect to the output
    mEffects[mEffects.size() - 1]->ConnectEffectIO(mEffects[mEffects.size() - 1]->GetEffectNode(), outputNode);
    
    mEffects[mEffects.size() - 1]->GetEffectInfo();
    mEffects[mEffects.size() - 1]->SetStreamDescription(output);
    
    // Start the graph
    AUGraphStart(mGraph);
    
    // Print out signal chain
    CAShow(mGraph);
}

- (void) RemoveEffect
{
    // Stop the graph
    AUGraphStop(mGraph);
    
    // Disconnect the output node
    AUGraphDisconnectNodeInput(mGraph, outputNode, 0);
    
    // Disconnect the last node
    mEffects[mEffects.size() - 1]->DisconnectEffectIO();
    
    // Remove effects from the containers
    mEffects.pop_back();
    mEffectIDs.pop_back();
    
    if(mEffects.size() != 0)
    {
        // Route the effect to the output
        mEffects[mEffects.size() - 1]->ConnectEffectIO(mEffects[mEffects.size() - 1]->GetEffectNode(), outputNode);
        mEffects[mEffects.size() - 1]->GetEffectInfo();
        mEffects[mEffects.size() - 1]->SetStreamDescription(output);
    }
    else
    {
        result = AUGraphConnectNodeInput(mGraph, outputNode, 1, outputNode, 0);
        
        if (result)
        {
            printf("AUGraphAddNode result %d\n", result);
            return;
        }
    }
    
    // Start the graph
    AUGraphStart(mGraph);
    
    // Print out signal chain
    //CAShow(mGraph);
}


- (void) SwapEffect: (UInt32) effect arg2: (unsigned) index
{

}

- (PS_Effects*) GetEffectFromID: (UInt32) id;
{
    for(int i = 0; i < mEffects.size(); ++i)
    {
        if(mEffects[i]->GetEffectID() == id)
            return mEffects[i];
    }
    
    return nullptr;
}


- (std::vector<UInt32>) GetEffects
{
    return mEffectIDs;
}

- (void) initializeGraph
{
    result = noErr;
    
    result = NewAUGraph(&mGraph);
    
    // Store Output Description and add the node
    mCompDesc = {kAudioUnitType_Output, kAudioUnitSubType_HALOutput, kAudioUnitManufacturer_Apple, 0, 0};
    
    result = AUGraphAddNode(mGraph, &mCompDesc, &outputNode);
    
    if (result)
    {
        printf("AUGraphAddNode 1 result %lu %4.4s\n", (unsigned long)result, (char*)&result);
        return;
    }
    
    // Route incoming audio to the output
    result = AUGraphConnectNodeInput(mGraph, outputNode, 1, outputNode, 0);
    
    if (result)
    {
        printf("AUGraphAddNode result %d\n", result);
        return;
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
    
    UInt32 size;
    
    AURenderCallbackStruct renderObj;
    renderObj.inputProc = &renderInput;
    
    
    // White Noise Testing
    /*result = AudioUnitSetProperty(mEffects[0]->GetEffectAU(),
                                  kAudioUnitProperty_SetRenderCallback,
                                  kAudioUnitScope_Input,
                                  0,
                                  &renderObj,
                                  sizeof(renderObj) );*/
    
    
    size = sizeof(mStreamDesc);
    
    
    UInt32 enableIO = 1;
    
    result = AudioUnitSetProperty(output,
                         kAudioOutputUnitProperty_EnableIO,
                         kAudioUnitScope_Input,
                         1,
                         &enableIO,
                         sizeof(enableIO) );
    if (result)
    {
        printf("EnableIO result %u %4.4s\n", (unsigned int)result, (char*)&result);
        return;
    }
    
    result = AudioUnitSetProperty(output,
                         kAudioOutputUnitProperty_EnableIO,
                         kAudioUnitScope_Output,
                         0,
                         &enableIO,
                         sizeof(enableIO) );
    if (result)
    {
        printf("EnableIO result %u %4.4s\n", (unsigned int)result, (char*)&result);
        return;
    }
    
    result = AudioUnitGetProperty(output,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Input,
                                  1,
                                  &mStreamDesc,
                                  &size );
    
    if (result)
    {
        printf("StreamFormat result %u %4.4s\n", (unsigned int)result, (char*)&result);
        return;
    }
    
    result = AudioUnitGetProperty(output,
                                 kAudioUnitProperty_StreamFormat,
                                 kAudioUnitScope_Output,
                                 0,
                                 &mStreamDesc,
                                 &size );
    
    if (result)
    {
        printf("StreamFormat result %u %4.4s\n", (unsigned int)result, (char*)&result);
        return;
    }

    result = AUGraphInitialize(mGraph);
    
    if (result)
    {
        printf("AUGraphInitialize result %d\n", result);
        return;
    }
    
    CAShow(mGraph);
    
    result = AUGraphStart(mGraph);
    
    if (result)
    {
        printf("AUGraphStart result %u %4.4s\n", (unsigned int)result, (char*)&result);
        return;
    }
    
}

- (void) PrintStreamDescription
{
    std::cout << "STREAM DESCRIPTION START ++++++++++++++++++++++++++++++++++++++++++" << std::endl << std::endl;
    std::cout << "mBitsPerChannel: " << mStreamDesc.mBitsPerChannel << std::endl;
    std::cout << "mBytesPerFrame: " << mStreamDesc.mBytesPerFrame << std::endl;
    std::cout << "mBytesPerPacket: " << mStreamDesc.mBytesPerPacket << std::endl;
    std::cout << "mChannelsPerFrame: " << mStreamDesc.mChannelsPerFrame << std::endl;
    std::cout << "mFormateFlags: " << mStreamDesc.mFormatFlags << std::endl;
    std::cout << "mFormatID: " << mStreamDesc.mFormatID << std::endl;
    std::cout << "mFramesPerPacket: " << mStreamDesc.mFramesPerPacket << std::endl;
    std::cout << "mReserved: " << mStreamDesc.mReserved << std::endl;
    std::cout << "mSampelRate: " << mStreamDesc.mSampleRate << std::endl << std::endl;
    std::cout << "STREAM DESCRIPTION END ++++++++++++++++++++++++++++++++++++++++++++" << std::endl << std::endl;
}

// Testing with White Noise
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
