//
//  PS_UI_Delay.m
//  PedalStack
//
//  Created by Poppy on 11/30/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import "PS_UI_Delay.h"
//#import "PS_UI_Manager.h"

@implementation PS_UI_Delay

-(IBAction)Delay_DelayTime:(id)sender
{
    float value = [sender floatValue];
    //[(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Delay arg3:kDelayParam_DelayTime];
}

@end

