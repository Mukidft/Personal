//
//  PS_UI_Whammy.m
//  PedalStack
//
//  Created by Poppy on 11/30/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import "PS_UI_Whammy.h"
#import "PS_UI_Manager.h"

@implementation PS_UI_Whammy

- (void) awakeFromNib
{
    [label_Rate setIntegerValue: 1];
    [label_Pitch setIntegerValue: 1];
    [label_EffectBlend setIntegerValue: 50];
}

-(IBAction)Reverb_Rate:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Pitch arg3:kTimePitchParam_Rate];
    [label_Rate setIntegerValue: value];
}

-(IBAction)Reverb_Pitch:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Pitch arg3:kTimePitchParam_Pitch];
    [label_Pitch setIntegerValue: value];
}

-(IBAction)Reverb_EffectBlend:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Pitch arg3:kTimePitchParam_EffectBlend];
    [label_EffectBlend setIntegerValue: value];
}

@end

