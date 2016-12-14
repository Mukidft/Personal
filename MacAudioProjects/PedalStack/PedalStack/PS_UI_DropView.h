/*****************************************************************************/
/*!
 \file   PS_UI_DropView.h
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the interface for a Custom Drop View class for Drag & Drop
 */
/*****************************************************************************/

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
