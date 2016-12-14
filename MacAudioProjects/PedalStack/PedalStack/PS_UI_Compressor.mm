/*****************************************************************************/
/*!
 \file   PS_UI_Compressor.mm
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the implementation for the Compressor Effects Pedal
 */
/*****************************************************************************/

#import "PS_UI_Compressor.h"
#import "PS_UI_Manager.h"

@implementation PS_UI_Compressor

- (void) awakeFromNib
{
    [label_Threshold setIntegerValue: -20];
    [label_Headroom setIntegerValue: 5];
    [label_ExpansionRatio setIntegerValue: 2];
    [label_AttackTime setFloatValue: 0.001f];
    [label_ReleaseTime setFloatValue: 0.05f];
    [label_MasterGain setIntegerValue: 0];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Compressor Threshold
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Compressor_Threshold:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_DynamicsProcessor arg3:kDynamicsProcessorParam_Threshold];
    [label_Threshold setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Compressor Headroom
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Compressor_Headroom:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_DynamicsProcessor arg3:kDynamicsProcessorParam_HeadRoom];
    [label_Headroom setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Compressor Expansion Ratio
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Compressor_ExpansionRatio:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_DynamicsProcessor arg3:kDynamicsProcessorParam_ExpansionRatio];
    [label_ExpansionRatio setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Compressor Attack Time
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Compressor_AttackTime:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_DynamicsProcessor arg3:kDynamicsProcessorParam_AttackTime];
    [label_AttackTime setFloatValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Compressor Release Time
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Compressor_ReleaseTime:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_DynamicsProcessor arg3:kDynamicsProcessorParam_ReleaseTime];
    [label_ReleaseTime setFloatValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Compressor Master Gain
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Compressor_MasterGain:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_DynamicsProcessor arg3:kDynamicsProcessorParam_MasterGain];
    [label_MasterGain setIntegerValue: value];
}

@end

