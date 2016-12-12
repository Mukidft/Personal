//
//  PS_UI_Compressor.h
//  PedalStack
//
//  Created by Poppy on 11/30/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PS_UI_Compressor : NSObject
{
    IBOutlet NSTextField *label_Threshold;
    IBOutlet NSTextField *label_Headroom;
    IBOutlet NSTextField *label_ExpansionRatio;
    IBOutlet NSTextField *label_AttackTime;
    IBOutlet NSTextField *label_ReleaseTime;
    IBOutlet NSTextField *label_MasterGain;
}

@end
