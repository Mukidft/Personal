//
//  PS_UI_Distortion.h
//  PedalStack
//
//  Created by Poppy on 11/30/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PS_UI_Reverb : NSObject
{
    IBOutlet NSTextField *label_DryWetMix;
    IBOutlet NSTextField *label_SmallLargeMix;
    IBOutlet NSTextField *label_PreDelay;
    IBOutlet NSTextField *label_ModulationRate;
    IBOutlet NSTextField *label_ModulationDepth;
    
    IBOutlet NSTextField *label_SmallSize;
    IBOutlet NSTextField *label_SmallDensity;
    IBOutlet NSTextField *label_SmallBrightness;
    IBOutlet NSTextField *label_SmallDelayRange;
    
    IBOutlet NSTextField *label_LargeSize;
    IBOutlet NSTextField *label_LargeDelay;
    IBOutlet NSTextField *label_LargeDensity;
    IBOutlet NSTextField *label_LargeDelayRange;
    IBOutlet NSTextField *label_LargeBrightness;
}

@end
