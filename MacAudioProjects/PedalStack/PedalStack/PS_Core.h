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
    AudioUnit output;
    AudioComponentDescription mCompDesc;
    AudioStreamBasicDescription mStreamDesc;
}

- (void) initializeGraph;

@end

