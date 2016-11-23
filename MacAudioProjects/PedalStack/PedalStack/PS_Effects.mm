//
//  PS_Effects.m
//  PedalStack
//
//  Created by Lipstick on 10/24/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#include "PS_Effects.h"
#include <iostream>

PS_Effects::PS_Effects(UInt32 effect, AUGraph graph, AUNode outNode, AudioStreamBasicDescription streamDesc) : _effectID(effect), _graph(graph), _output(outNode), _streamDesc(streamDesc)
{
    FillDescription();
    AddEffectNode();
}

void PS_Effects::FillDescription()
{
    _effectDesc = {kAudioUnitType_Effect, _effectID, kAudioUnitManufacturer_Apple, 0, 0};
}

void PS_Effects::AddEffectNode()
{
    _result = AUGraphAddNode(_graph, &_effectDesc, &_effectNode);
    
    ErrorCheck(NodeAdded);
}

void PS_Effects::ConnectEffectIO(AUNode input, AUNode output, uint32 inBus, uint32 outBus)
{
    _result = AUGraphConnectNodeInput(_graph, input, inBus, output, outBus);
    
    ErrorCheck(NodeConnected);
}

void PS_Effects::DisconnectEffectIO()
{
    _result = AUGraphDisconnectNodeInput(_graph, _effectNode, 0);
    
    ErrorCheck(NodeConnected);
}

void PS_Effects::SetEffectParameter(AudioUnitParameterID paramID, AudioUnitParameterValue paramVal)
{
    _result = AudioUnitSetParameter(_effectAU, paramID, kAudioUnitScope_Global, 0, paramVal, 0);
    
    ErrorCheck(NodeParameter);
}

void PS_Effects::SetStreamDescription(AudioUnit outAU)
{
    UInt32 size = sizeof(_streamDesc);
    
    _result = AudioUnitGetProperty(outAU,
                                   kAudioUnitProperty_StreamFormat,
                                   kAudioUnitScope_Input,
                                   0,
                                   &_streamDesc,
                                   &size );
    
    ErrorCheck(NodeGetProperty);
    
    
    _result = AudioUnitSetProperty(_effectAU,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  0,
                                  &_streamDesc,
                                  sizeof(_streamDesc) );
    
    ErrorCheck(NodeSetProperty);
}

AUNode PS_Effects::GetEffectNode()
{
    return _effectNode;
}

AudioUnit PS_Effects::GetEffectAU()
{
    return _effectAU;
}


UInt32 PS_Effects::GetEffectID()
{
    return _effectID;
}

AudioComponentDescription PS_Effects::GetEffectDescription()
{
    return _effectDesc;
}

void PS_Effects::GetEffectInfo()
{
    
    _result = AUGraphNodeInfo(_graph, _effectNode, NULL, &_effectAU);
    
    ErrorCheck(NodeInfo);
}

void PS_Effects::ErrorCheck(ErrorType error)
{
    if(_result)
    {
        switch(error)
        {
            case NodeAdded:
                printf("Effect Node could not be added! Result: %d\n", _result);
                break;
            case NodeConnected:
                printf("Effect Node could not be connected! Result: %d\n", _result);
                break;
            case NodeInfo:
                printf("Could not get AU Graph Node information! Result: %d\n", _result);
                break;
            case NodeParameter:
                printf("Could not set parameter! Result: %d\n", _result);
                break;
            case NodeSetProperty:
                printf("Could not set property! Result: %d\n", _result);
                break;
            case NodeGetProperty:
                printf("Could not get property! Result: %d\n", _result);
                break;
            default:
                break;
        
        }
    }
}

void PS_Effects::PrintStreamDescription()
{
    std::cout << "STREAM DESCRIPTION START" << std::endl << std::endl;
    std::cout << "mBitsPerChannel:   " << _streamDesc.mBitsPerChannel << std::endl;
    std::cout << "mBytesPerFrame:    " << _streamDesc.mBytesPerFrame << std::endl;
    std::cout << "mBytesPerPacket:   " << _streamDesc.mBytesPerPacket << std::endl;
    std::cout << "mChannelsPerFrame: " << _streamDesc.mChannelsPerFrame << std::endl;
    std::cout << "mFormateFlags:     " << _streamDesc.mFormatFlags << std::endl;
    std::cout << "mFormatID:         " << _streamDesc.mFormatID << std::endl;
    std::cout << "mFramesPerPacket:  " << _streamDesc.mFramesPerPacket << std::endl;
    std::cout << "mReserved:         " << _streamDesc.mReserved << std::endl;
    std::cout << "mSampelRate:       " << _streamDesc.mSampleRate << std::endl << std::endl << std::endl;
}