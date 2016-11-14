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

- (void) CreateNewEffect: (UInt32) effect arg2: (AUGraph) graph arg3: (AUNode) outNode
{
    PS_Effects *NewEffect = new PS_Effects(effect, mGraph, outNode, mStreamDesc);
    mEffects.push_back(NewEffect);
}

- (void) AddNewEffect: (UInt32) effect
{
    [self CreateNewEffect:effect arg2:mGraph arg3:outputNode];
    
    AUGraphStop(mGraph);
    
    AUGraphDisconnectNodeInput(mGraph, outputNode, 0);
    
    mEffects[mEffects.size() - 2]->ConnectEffectIO(mEffects[mEffects.size() - 2]->GetEffectNode(), mEffects[mEffects.size() - 1]->GetEffectNode());
    mEffects[mEffects.size() - 1]->ConnectEffectIO(mEffects[mEffects.size() - 1]->GetEffectNode(), outputNode);
    
    mEffects[mEffects.size() - 2]->GetEffectInfo();
    mEffects[mEffects.size() - 1]->GetEffectInfo();
    
    AUGraphStart(mGraph);
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

- (void) initializeGraph
{
    OSStatus result = noErr;
    
    result = NewAUGraph(&mGraph);
    
    // Initialize Base Effects
    mEffectIDs = {kAudioUnitSubType_Delay};
    
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
        [self CreateNewEffect : effectID arg2 : mGraph arg3 : outputNode];
    }
    
    
    result = AUGraphConnectNodeInput(mGraph, outputNode, 1, mEffects[0]->GetEffectNode(), 0);
    
    if (result)
    {
        printf("AUGraphAddNode result %d\n", result);
        return;
    }
    
    result = AUGraphConnectNodeInput(mGraph, mEffects[0]->GetEffectNode(), 0, outputNode, 0);
    
    if (result)
    {
        printf("AUGraphAddNode result %d\n", result);
        return;
    }
    
    /*
    if(mEffects.size() == 1)
    {
        mEffects[0]->ConnectEffectIO(mEffects[0]->GetEffectNode(), outputNode);
    }
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
     */
                                
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
    
    //[self PrintStreamDescription];
    
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
    
    //[self PrintStreamDescription];
    
    if (result)
    {
        printf("StreamFormat result %u %4.4s\n", (unsigned int)result, (char*)&result);
        return;
    }
    
    mEffects[0]->SetStreamDescription(output);
    
#if 0
    result = AudioUnitSetProperty(output,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  1,
                                  &mStreamDesc,
                                  sizeof(mStreamDesc) );
    if (result)
    {
        printf("StreamFormat result %u %4.4s\n", (unsigned int)result, (char*)&result);
        return;
    }
    
#endif

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
