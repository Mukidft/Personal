//
//  AppDelegate.h
//  PedalStack
//
//  Created by Lipstick on 10/10/16.
//  Copyright (c) 2016 Deepak Chennakkadan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreAudio/CoreAudio.h>
#import <AudioToolbox/AudioToolbox.h>


@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    AUGraph mGraph;
    AudioUnit output;
    AudioComponentDescription mCompDesc;
    AudioStreamBasicDescription mStreamDesc;
    
    IBOutlet NSWindow *window;
    IBOutlet NSButton* button;
}

- (IBAction)test:(id)sender;

@end

