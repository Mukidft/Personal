/*****************************************************************************/
/*!
 \file   PS_UI_Whammy.mm
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the implementation for the Whammy Effects Pedal
 */
/*****************************************************************************/

#import "PS_UI_Whammy.h"
#import "PS_UI_Manager.h"

@implementation PS_UI_Whammy

- (void) awakeFromNib
{
    [label_Rate setIntegerValue: 1];
    [label_Pitch setIntegerValue: 1];
    [label_EffectBlend setIntegerValue: 50];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Whammy Rate
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Whammy_Rate:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Pitch arg3:kTimePitchParam_Rate];
    [label_Rate setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Whammy Pitch
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Whammy_Pitch:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Pitch arg3:kTimePitchParam_Pitch];
    [label_Pitch setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Whammy Effect Blend
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Whammy_EffectBlend:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Pitch arg3:kTimePitchParam_EffectBlend];
    [label_EffectBlend setIntegerValue: value];
}

@end

