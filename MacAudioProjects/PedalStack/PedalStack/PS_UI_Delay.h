/*****************************************************************************/
/*!
 \file   PS_UI_Delay.h
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the interface for the Delay Effects Pedal
 */
/*****************************************************************************/

#import <Cocoa/Cocoa.h>


@interface PS_UI_Delay : NSObject
{
    IBOutlet NSTextField *label_delaytime;
    IBOutlet NSTextField *label_wetdrymix;
    IBOutlet NSTextField *label_feedback;
    IBOutlet NSTextField *label_lowpasscutoff;
}

@end
