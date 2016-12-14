/*****************************************************************************/
/*!
 \file   PS_UI_Whammy.h
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the interface for the Whammy Effects Pedal
 */
/*****************************************************************************/

#import <Cocoa/Cocoa.h>


@interface PS_UI_Whammy : NSObject
{
    IBOutlet NSTextField *label_Rate;
    IBOutlet NSTextField *label_Pitch;
    IBOutlet NSTextField *label_EffectBlend;
}

@end
