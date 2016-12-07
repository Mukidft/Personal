//
//  PS_Core.h
//  PedalStack
//
//  Created by Lipstick on 10/10/16.
//  Copyright (c) 2016 Deepak Chennakkadan. All rights reserved.
//

//#import "PS_Headers.h"
#include <vector>
#include "PS_Effects.h"

@interface PS_Core : NSObject
{
    AUGraph mGraph;
    AUNode outputNode;
    AudioUnit output;
    AudioUnit input;
    AudioComponentDescription mCompDesc;
    AudioStreamBasicDescription mStreamDesc;
    
    std::vector<PS_Effects*> mEffects;
    std::vector<UInt32> mEffectIDs;
    OSStatus result;
    
}

- (void) initializeGraph;
- (void) CreateNewEffect: (UInt32) effect arg2: (AUGraph) graph arg3: (AUNode) outNode;
- (void) AddNewEffect: (UInt32) effect;
- (void) SwapEffect: (UInt32) effect arg2: (unsigned) index;
- (void) RemoveEffect;
- (void) PrintStreamDescription;
- (PS_Effects*) GetEffectFromID: (UInt32) id;
- (std::vector<UInt32>) GetEffects;
@end

