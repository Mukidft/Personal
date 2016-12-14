/*****************************************************************************/
/*!
 \file   PS_UI_Equalizer.mm
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

#import "PS_UI_Equalizer.h"
#import "PS_UI_Manager.h"

@implementation PS_UI_Equalizer

- (void) awakeFromNib
{
    [label_CenterFreq setIntegerValue: 2000];
    [label_Q setIntegerValue: 1];
    [label_Gain setIntegerValue: 0];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Equalizer Center Frequency
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Equalizer_CenterFreq:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_ParametricEQ arg3:kParametricEQParam_CenterFreq];
    [label_CenterFreq setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Equalizer Q
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Equalizer_Q:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_ParametricEQ arg3:kParametricEQParam_Q];
    [label_Q setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Equalizer Gain
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Equalizer_Gain:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_ParametricEQ arg3:kParametricEQParam_Gain];
    [label_Gain setIntegerValue: value];
}

@end

