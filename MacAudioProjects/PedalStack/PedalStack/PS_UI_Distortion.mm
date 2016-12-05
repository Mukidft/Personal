//
//  PS_UI_Distortion.m
//  PedalStack
//
//  Created by Poppy on 11/30/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import "PS_UI_Distortion.h"
#import "PS_UI_Manager.h"

@implementation PS_UI_Distortion

- (void) awakeFromNib
{
    [label_Delay setFloatValue: 0.1];
    [label_Decay setFloatValue: 1.0];
    [label_DelayMix setFloatValue: 50];
    [label_Decimation setFloatValue: 50];
    [label_Rounding setFloatValue: 0];
    [label_DecimationMix setFloatValue: 50];
    [label_LinearTerm setFloatValue: 1];
    [label_SquaredTerm setFloatValue: 0];
    [label_CubicTerm setFloatValue: 0];
    [label_PolynomialMix setFloatValue: 50];
    [label_RingModFreq1 setFloatValue: 100];
    [label_RingModFreq2 setFloatValue: 100];
    [label_RingModBalance setFloatValue: 50];
    [label_RingModMix setFloatValue: 0];
    [label_SoftClipGain setFloatValue: -6];
    [label_FinalMix setFloatValue: 50];
}

-(IBAction)Distortion_Delay:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_Delay];
    [label_Delay setFloatValue: value];
}

-(IBAction)Distortion_Decay:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_Decay];
    [label_Decay setFloatValue: value];
}

-(IBAction)Distortion_DelayMix:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_DelayMix];
    [label_DelayMix setFloatValue: value];
}

-(IBAction)Distortion_Decimation:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_Decimation];
    [label_Decimation setFloatValue: value];
}

-(IBAction)Distortion_Rounding:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_Rounding];
    [label_Rounding setFloatValue: value];
}

-(IBAction)Distortion_DecimationMix:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_DecimationMix];
    [label_DecimationMix setFloatValue: value];
}

-(IBAction)Distortion_LinearTerm:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_LinearTerm];
    [label_LinearTerm setFloatValue: value];
}

-(IBAction)Distortion_SquaredTerm:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_SquaredTerm];
    [label_SquaredTerm setFloatValue: value];
}

-(IBAction)Distortion_CubicTerm:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_CubicTerm];
    [label_CubicTerm setFloatValue: value];
}

-(IBAction)Distortion_PolynomialMix:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_PolynomialMix];
    [label_PolynomialMix setFloatValue: value];
}

-(IBAction)Distortion_RingModFreq1:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_RingModFreq1];
    [label_RingModFreq1 setFloatValue: value];
}

-(IBAction)Distortion_RingModFreq2:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_RingModFreq2];
    [label_RingModFreq2 setFloatValue: value];
}

-(IBAction)Distortion_RingModBalance:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_RingModBalance];
    [label_RingModBalance setFloatValue: value];
}

-(IBAction)Distortion_RingModMix:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_RingModMix];
    [label_RingModMix setFloatValue: value];
}

-(IBAction)Distortion_SoftClipGain:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_SoftClipGain];
    [label_SoftClipGain setFloatValue: value];
}

-(IBAction)Distortion_FinalMix:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_FinalMix];
    [label_FinalMix setFloatValue: value];
}

@end

