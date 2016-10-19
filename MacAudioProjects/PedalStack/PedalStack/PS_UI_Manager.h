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

@interface PS_UI_Manager : NSObject <NSApplicationDelegate>
{
    IBOutlet NSWindow *window;
    IBOutlet NSButton* button;
    IBOutlet NSScrollView* scroller;
};

- (IBAction)test:(id)sender;

@end

#endif /* PS_UI_Manager_h */
