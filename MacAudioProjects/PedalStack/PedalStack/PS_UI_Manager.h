//
//  PS_UI_Manager.h
//  PedalStack
//
//  Created by Lipstick on 10/10/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#ifndef PS_UI_Manager_h
#define PS_UI_Manager_h

#include "PS_Headers.h"
#import "PS_Core.h"

@class PS_Core;

@interface PS_UI_Manager : NSObject <NSApplicationDelegate>
{
    IBOutlet NSWindow *window;
    IBOutlet PS_Core *core;
    IBOutlet NSImageView *UI_Effect;
};

@end

#endif /* PS_UI_Manager_h */
