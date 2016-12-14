/*****************************************************************************/
/*!
 \file   PS_UI_Equalizer.h
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the interface for the Equalizer Effects Pedal
 */
/*****************************************************************************/

#import <Cocoa/Cocoa.h>


@interface PS_UI_Equalizer : NSObject
{
    IBOutlet NSTextField *label_CenterFreq;
    IBOutlet NSTextField *label_Q;
    IBOutlet NSTextField *label_Gain;
}

@end
