//
//  AppDelegate.h
//  SineWaveGenerator
//
//  Created by Lipstick on 9/12/16.
//  Copyright (c) 2016 Lipstick. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreAudio/CoreAudio.h>
#import <AudioToolbox/AudioToolbox.h>
#include "Generator.hpp"
#include "EventScheduler.hpp"


@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    AUGraph mGraph;
    AudioUnit output;      
    AudioComponentDescription mCompDesc;
    AudioStreamBasicDescription mStreamDesc;
    
    IBOutlet NSWindow *window;
    IBOutlet NSButton *button;
    IBOutlet NSSlider *frequency;
    IBOutlet NSSlider *bpm;
    IBOutlet NSTextField *frequencyLabel;
    IBOutlet NSTextField *bpmLabel;
    
    struct UI
    {
        bool isClicked;
        bool isChecked;
    };
    
    struct Modules
    {
        Generator generator;
        EventScheduler eventScheduler;
        UI ui;
    };
    
    Modules modules;
}

- (IBAction)click:(id)sender;


@end

