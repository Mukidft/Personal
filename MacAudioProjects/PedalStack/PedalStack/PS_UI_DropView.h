//
//  PS_UI_DropView.h
//  PedalStack
//
//  Created by Poppy on 11/16/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

// Framework
#import <Cocoa/Cocoa.h>

@interface PS_UI_DropView : NSImageView <NSDraggingDestination>
{
    //highlight the drop zone
    BOOL highlight;
    NSString *effectType;
}

- (id)initWithCoder:(NSCoder *)coder;

@end
