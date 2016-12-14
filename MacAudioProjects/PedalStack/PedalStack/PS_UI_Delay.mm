/*****************************************************************************/
/*!
 \file   PS_UI_Delay.mm
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the implementation for the Delay Effects Pedal
 */
/*****************************************************************************/

#import "PS_UI_Delay.h"
#import "PS_UI_Manager.h"

@implementation PS_UI_Delay

- (void) awakeFromNib
{
    [label_wetdrymix setIntegerValue: 50.0f];
    [label_delaytime setFloatValue: 1.0f];
    [label_feedback setIntegerValue: 50.0f];
    [label_lowpasscutoff setIntegerValue: 15000.0f];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Delay Wet/Dry Mix
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Delay_WetDryMix:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Delay arg3:kDelayParam_WetDryMix];
    [label_wetdrymix setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Delay Time
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Delay_DelayTime:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Delay arg3:kDelayParam_DelayTime];
    [label_delaytime setFloatValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Delay Feedback
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Delay_Feedback:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Delay arg3:kDelayParam_Feedback];
    [label_feedback setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Delay Low Pass Cutoff
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Delay_LowPassCutoff:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Delay arg3:kDelayParam_LopassCutoff];
    [label_lowpasscutoff setIntegerValue: value];
}

@end

