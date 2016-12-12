//
//  PS_UI_Equalizer.m
//  PedalStack
//
//  Created by Poppy on 11/30/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import "PS_UI_Equalizer.h"
#import "PS_UI_Manager.h"

@implementation PS_UI_Equalizer

- (void) awakeFromNib
{
    [label_CenterFreq setIntegerValue: 2000];
    [label_Q setIntegerValue: 1];
    [label_Gain setIntegerValue: 0];
}

-(IBAction)Reverb_CenterFreq:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_ParametricEQ arg3:kParametricEQParam_CenterFreq];
    [label_CenterFreq setIntegerValue: value];
}

-(IBAction)Reverb_Q:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_ParametricEQ arg3:kParametricEQParam_Q];
    [label_Q setIntegerValue: value];
}

-(IBAction)Reverb_Gain:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_ParametricEQ arg3:kParametricEQParam_Gain];
    [label_Gain setIntegerValue: value];
}

@end

