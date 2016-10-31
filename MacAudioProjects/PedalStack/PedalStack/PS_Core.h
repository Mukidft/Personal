//
//  PS_Core.h
//  PedalStack
//
//  Created by Lipstick on 10/10/16.
//  Copyright (c) 2016 Deepak Chennakkadan. All rights reserved.
//

#include "PS_Headers.h"

@interface PS_Core : NSObject <NSApplicationDelegate>
{
    AUGraph mGraph;
    AUNode outputNode;
    AudioUnit output;
    AudioUnit input;
    AudioComponentDescription mCompDesc;
    AudioStreamBasicDescription mStreamDesc;
    
    vector<PS_Effects*> mEffects;
    vector<UInt32> mEffectIDs;
    
    // test
    IBOutlet NSSlider *frequency;
    IBOutlet NSButton *button;
    
}

- (void) initializeGraph;
- (void) CreateNewEffect: (UInt32) effect arg2: (AUGraph) graph arg3: (AUNode) outNode;
- (PS_Effects*) GetEffectFromID: (UInt32) id;
@end

