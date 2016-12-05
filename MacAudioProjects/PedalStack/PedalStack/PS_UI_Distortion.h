//
//  PS_UI_Distortion.h
//  PedalStack
//
//  Created by Poppy on 11/30/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PS_UI_Distortion : NSObject
{
    IBOutlet NSTextField *label_Delay;
    IBOutlet NSTextField *label_Decay;
    IBOutlet NSTextField *label_DelayMix;
    IBOutlet NSTextField *label_Decimation;
    IBOutlet NSTextField *label_Rounding;
    IBOutlet NSTextField *label_DecimationMix;
    IBOutlet NSTextField *label_LinearTerm;
    IBOutlet NSTextField *label_SquaredTerm;
    IBOutlet NSTextField *label_CubicTerm;
    IBOutlet NSTextField *label_PolynomialMix;
    IBOutlet NSTextField *label_RingModFreq1;
    IBOutlet NSTextField *label_RingModFreq2;
    IBOutlet NSTextField *label_RingModBalance;
    IBOutlet NSTextField *label_RingModMix;
    IBOutlet NSTextField *label_SoftClipGain;
    IBOutlet NSTextField *label_FinalMix;
}

@end
