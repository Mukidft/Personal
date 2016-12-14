/*****************************************************************************/
/*!
 \file   PS_UI_Distortion.mm
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the implementation for the Distortion Effects Pedal
 */
/*****************************************************************************/

#import "PS_UI_Distortion.h"
#import "PS_UI_Manager.h"

@implementation PS_UI_Distortion

- (void) awakeFromNib
{
    [label_Delay setIntegerValue: 0.1];
    [label_Decay setIntegerValue: 1.0];
    [label_DelayMix setIntegerValue: 50];
    [label_Decimation setIntegerValue: 50];
    [label_Rounding setIntegerValue: 0];
    [label_DecimationMix setIntegerValue: 50];
    [label_LinearTerm setFloatValue: 1];
    [label_SquaredTerm setFloatValue: 0];
    [label_CubicTerm setFloatValue: 0];
    [label_PolynomialMix setIntegerValue: 50];
    [label_RingModFreq1 setIntegerValue: 100];
    [label_RingModFreq2 setIntegerValue: 100];
    [label_RingModBalance setIntegerValue: 50];
    [label_RingModMix setIntegerValue: 0];
    [label_SoftClipGain setIntegerValue: -6];
    [label_FinalMix setIntegerValue: 50];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Delay
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_Delay:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_Delay];
    [label_Delay setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Decay
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_Decay:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_Decay];
    [label_Decay setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Delay Mix
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_DelayMix:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_DelayMix];
    [label_DelayMix setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Decimation
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_Decimation:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_Decimation];
    [label_Decimation setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Rounding
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_Rounding:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_Rounding];
    [label_Rounding setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Decimation Mix
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_DecimationMix:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_DecimationMix];
    [label_DecimationMix setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Linear Term
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_LinearTerm:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_LinearTerm];
    [label_LinearTerm setFloatValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Squared Term
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_SquaredTerm:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_SquaredTerm];
    [label_SquaredTerm setFloatValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Cubic Term
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_CubicTerm:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_CubicTerm];
    [label_CubicTerm setFloatValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Polynomial Mix
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_PolynomialMix:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_PolynomialMix];
    [label_PolynomialMix setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Ring Mod Frequency 1
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_RingModFreq1:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_RingModFreq1];
    [label_RingModFreq1 setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Ring Mod Frequency 2
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_RingModFreq2:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_RingModFreq2];
    [label_RingModFreq2 setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Ring Mod Balance
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_RingModBalance:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_RingModBalance];
    [label_RingModBalance setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Ring Mod Mix
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_RingModMix:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_RingModMix];
    [label_RingModMix setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Soft Clip Gain
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_SoftClipGain:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_SoftClipGain];
    [label_SoftClipGain setIntegerValue: value];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the Distortion Final Mix
 
 \param sender
 (Values from the UI)
 
 \return
 Returns an IBAction
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(IBAction)Distortion_FinalMix:(id)sender
{
    float value = [sender floatValue];
    [(PS_UI_Manager *) [NSApp delegate] setUIParam:value arg2:kAudioUnitSubType_Distortion arg3:kDistortionParam_FinalMix];
    [label_FinalMix setIntegerValue: value];
}

@end

