//
//  PS_UI_DragView.h
//  PedalStack
//
//  Created by Poppy on 11/16/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

// Framework
#import <Cocoa/Cocoa.h>

@interface PS_UI_DragView : NSImageView <NSDraggingSource, NSPasteboardItemDataProvider>
{
    //highlight the drop zone
    BOOL highlight;
    NSString *effect_name;
}

- (id)initWithCoder:(NSCoder *)coder;
- (void)setName: (NSString *) name;
+ (NSString*)pasteboardType;
+ (NSArray*)pasteboardTypes;

@end
