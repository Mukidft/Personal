//
//  PS_UI_Manager.h
//  PedalStack
//
//  Created by Lipstick on 10/10/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import "PS_Core.h"
// Framework
#import <Cocoa/Cocoa.h>

// Project
#import "PS_UI_DragView.h"

@class PS_Core;

@interface PS_UI_Manager : NSObject <NSApplicationDelegate>
{
    IBOutlet NSWindow *window;
    IBOutlet PS_Core *core;
    IBOutlet PS_UI_DragView *EffectA;
    IBOutlet PS_UI_DragView *EffectB;
    IBOutlet NSImageView *PedalA;
    IBOutlet NSImageView *PedalB;
    
    IBOutlet NSView *control;
    IBOutlet NSView *controlA;
    
    
    NSString *currentSelection;
};

- (void)addNewEffect:(NSString *)name;
- (NSImage*)getEffectImage:(NSString *)name;
- (PS_Core *)getCore;
- (void)setUIParam:(float)value arg2: (UInt32)type arg3: (UInt32) param;
- (void)drawControls:(NSString *)name;

@end
