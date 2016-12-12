//
//  PS_UI_Equalizer.h
//  PedalStack
//
//  Created by Poppy on 11/30/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PS_UI_Equalizer : NSObject
{
    IBOutlet NSTextField *label_CenterFreq;
    IBOutlet NSTextField *label_Q;
    IBOutlet NSTextField *label_Gain;
}

@end
