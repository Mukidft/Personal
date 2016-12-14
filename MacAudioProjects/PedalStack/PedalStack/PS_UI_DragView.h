/*****************************************************************************/
/*!
 \file   PS_UI_DragView.h
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the interface for a Custom Drag View class for Drag & Drop
 */
/*****************************************************************************/

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
