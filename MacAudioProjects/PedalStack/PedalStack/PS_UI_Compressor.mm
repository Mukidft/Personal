//
//  PS_UI_Compressor.m
//  PedalStack
//
//  Created by Poppy on 11/30/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import "PS_UI_Compressor.h"
#import "PS_UI_Manager.h"

@implementation PS_UI_Compressor

- (void) awakeFromNib
{
    [label_Threshold setIntegerValue: -20];
    [label_Headroom setIntegerValue: 5];
    [label_ExpansionRatio setIntegerValue: 2];
    [label_AttackTime setFloatValue: 0.001f];
    [label_ReleaseTime setFloatValue: 0.05f];
    [label_MasterGain setIntegerValue: 0];
}

-(IBAction)Delay_Threshold:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_DynamicsProcessor arg3:kDynamicsProcessorParam_Threshold];
    [label_Threshold setIntegerValue: value];
}

-(IBAction)Delay_Headroom:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_DynamicsProcessor arg3:kDynamicsProcessorParam_HeadRoom];
    [label_Headroom setIntegerValue: value];
}

-(IBAction)Delay_ExpansionRatio:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_DynamicsProcessor arg3:kDynamicsProcessorParam_ExpansionRatio];
    [label_ExpansionRatio setIntegerValue: value];
}

-(IBAction)Delay_AttackTime:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_DynamicsProcessor arg3:kDynamicsProcessorParam_AttackTime];
    [label_AttackTime setFloatValue: value];
}

-(IBAction)Delay_ReleaseTime:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_DynamicsProcessor arg3:kDynamicsProcessorParam_ReleaseTime];
    [label_ReleaseTime setFloatValue: value];
}

-(IBAction)Delay_MasterGain:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_DynamicsProcessor arg3:kDynamicsProcessorParam_MasterGain];
    [label_MasterGain setIntegerValue: value];
}

@end

