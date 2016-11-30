//
//  PS_UI_Manager.m
//  PedalStack
//
//  Created by Lipstick on 10/19/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import "PS_UI_Manager.h"

@implementation PS_UI_Manager

- (void) awakeFromNib
{
    [EffectA setName: EffectA.identifier];
    [EffectB setName: EffectB.identifier];
}


- (void)setUIParam:(float)value arg2: (UInt32)type arg3: (UInt32) param
{
    if([core GetEffects].size() != 0)
        [core GetEffectFromID: type]->SetEffectParameter(param, value);
}


- (void)drawControls:(NSString *)name
{
    if(name != currentSelection)
    {
        if([name isEqualToString: @"Delay"])
        {
            std::cout << "Showing controls for Delay" << std::endl;
            [control addSubview:controlA];
        }
        else if ([name isEqualToString: @"BandPassFilter"])
            std::cout << "Showing controls for BandPassFilter" << std::endl;
        else if ([name isEqualToString: @"Distortion"])
            std::cout << "Showing controls for Distortion" << std::endl;
    }
    
    currentSelection = name;
}

- (void)addNewEffect:(NSString *)name
{
    UInt32 effectID;
    
    if([name isEqualToString: @"Delay"])
        effectID = kAudioUnitSubType_Delay;
    else if ([name isEqualToString: @"Distortion"])
        effectID = kAudioUnitSubType_Distortion;
    else if ([name isEqualToString: @"BandPassFilter"])
        effectID = kAudioUnitSubType_BandPassFilter;
    
    [core AddNewEffect: effectID];
}

-(NSImage*)getEffectImage:(NSString *)name
{
    if([name isEqualToString: @"Delay"])
        return PedalA.image;
    else if ([name isEqualToString: @"BandPassFilter"])
        return PedalB.image;
    
    std::cout << "Error: Image not found!" << std::endl;
    
    return nil;
}


- (PS_Core *)getCore
{
    return core;
}

@end