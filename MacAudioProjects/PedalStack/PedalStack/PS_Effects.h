//
//  PS_AudioUnits.h
//  PedalStack
//
//  Created by Lipstick on 10/24/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import "PS_Headers.h"

#ifndef PS_Effects_h
#define PS_Effects_h

class PS_Effects
{
public:
    ~PS_Effects(){}
    PS_Effects(){}
    
    PS_Effects(UInt32 effect, AUGraph graph, AUNode outNode, AudioStreamBasicDescription streamDesc);
    
    // Getters
    AUNode GetEffectNode();
    AudioComponentDescription GetEffectDescription();
    UInt32 GetEffectID();
    AudioUnit GetEffectAU();
    void GetEffectInfo();
    
    void SetEffectParameter(AudioUnitParameterID paramID, AudioUnitParameterValue paramVal);
    void SetStreamDescription(AudioUnit outAU);
    
    void ConnectEffectIO(AUNode input, AUNode output);
    void DisconnectEffectIO();
    
    
private:
    
    enum ErrorType
    {
      NodeAdded,
      NodeConnected,
      NodeInfo,
      NodeParameter,
      NodeSetProperty,
      NodeGetProperty    
    } _ErrorType;
    
    
    
    UInt32 _effectID;
    AUGraph _graph;
    AUNode _output;
    
    AudioUnit _effectAU;
    AUNode _effectNode;
    AudioComponentDescription _effectDesc;
    AudioStreamBasicDescription _streamDesc;
    
    void FillDescription();
    void AddEffectNode();
    
    OSStatus _result;
    void ErrorCheck(ErrorType error);
    void PrintStreamDescription();
    
};


#endif /* PS_Effects_h */
