//
//  PS_Effects.m
//  PedalStack
//
//  Created by Lipstick on 10/24/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#include "PS_Effects.h"

PS_Effects::PS_Effects(UInt32 effect, AUGraph graph, AUNode outNode) : _effectID(effect), _graph(graph), _output(outNode)
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

void PS_Effects::ConnectEffectIO(AUNode input, AUNode output)
{
    _result = AUGraphConnectNodeInput(_graph, input, 0, output, 0);
    
    ErrorCheck(NodeConnected);
}

AUNode PS_Effects::GetEffectNode()
{
    return _effectNode;
}

AudioUnit PS_Effects::GetEffectAU()
{
    return _effectAU;
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
                printf("Effect Node Added result %lu %4.4s\n", (unsigned long)_result, (char*)&_result);
                break;
            case NodeConnected:
                
                printf("Effect Node Connected result %lu %4.4s\n", (unsigned long)_result, (char*)&_result);
                break;
            case NodeInfo:
                printf("AUGraphNodeInfo result %u %4.4s\n", (unsigned int)_result, (char*)&_result);
                break;
                
            default:
                break;
        
        }
    }
}