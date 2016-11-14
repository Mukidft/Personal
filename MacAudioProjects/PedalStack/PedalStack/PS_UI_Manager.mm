//
//  PS_UI_Manager.m
//  PedalStack
//
//  Created by Lipstick on 10/19/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import "PS_UI_Manager.h"

@implementation PS_UI_Manager

-(IBAction)OnValueChangeA:(id)sender
{
    float value = [sender floatValue];
    
    [core GetEffectFromID: kAudioUnitSubType_BandPassFilter]->SetEffectParameter(kBandpassParam_CenterFrequency, value);
}


- (IBAction)AddNewEffect:(id)sender
{
    NSString *name = UI_Effect.identifier;
    UInt32 effectID;
    
    if([name isEqualToString: @"Delay"])
        effectID = kAudioUnitSubType_Delay;
    else if ([name isEqualToString: @"Distortion"])
        effectID = kAudioUnitSubType_Distortion;
    else if ([name isEqualToString: @"BandPassFilter"])
        effectID = kAudioUnitSubType_BandPassFilter;
    
    [core AddNewEffect: effectID];
}

@end