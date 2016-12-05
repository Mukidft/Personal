//
//  PS_UI_Delay.m
//  PedalStack
//
//  Created by Poppy on 11/30/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import "PS_UI_Delay.h"
#import "PS_UI_Manager.h"

@implementation PS_UI_Delay

- (void) awakeFromNib
{
    [label_wetdrymix setIntegerValue: 50.0f];
    [label_delaytime setFloatValue: 1.0f];
    [label_feedback setIntegerValue: 50.0f];
    [label_lowpasscutoff setIntegerValue: 15000.0f];
}

-(IBAction)Delay_WetDryMix:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Delay arg3:kDelayParam_WetDryMix];
    [label_wetdrymix setIntegerValue: value];
}

-(IBAction)Delay_DelayTime:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Delay arg3:kDelayParam_DelayTime];
    [label_delaytime setFloatValue: value];
}

-(IBAction)Delay_Feedback:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Delay arg3:kDelayParam_Feedback];
    [label_feedback setIntegerValue: value];
}

-(IBAction)Delay_LowPassCutoff:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Delay arg3:kDelayParam_LopassCutoff];
    [label_lowpasscutoff setIntegerValue: value];
}

@end

