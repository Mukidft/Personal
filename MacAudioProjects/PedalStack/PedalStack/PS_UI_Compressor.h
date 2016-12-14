/*****************************************************************************/
/*!
 \file   PS_UI_Compressor.h
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the interface for the Compressor Effects Pedal
 */
/*****************************************************************************/

#import <Cocoa/Cocoa.h>


@interface PS_UI_Compressor : NSObject
{
    IBOutlet NSTextField *label_Threshold;
    IBOutlet NSTextField *label_Headroom;
    IBOutlet NSTextField *label_ExpansionRatio;
    IBOutlet NSTextField *label_AttackTime;
    IBOutlet NSTextField *label_ReleaseTime;
    IBOutlet NSTextField *label_MasterGain;
}

@end
