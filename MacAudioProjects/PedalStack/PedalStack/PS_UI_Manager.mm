/*****************************************************************************/
/*!
 \file   PS_UI_Manager.mm
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the implementation for the UI manager that handles the 
 app's UI
 */
/*****************************************************************************/

#import "PS_UI_Manager.h"
#include <iostream>
#include <string>

@implementation PS_UI_Manager

- (void) awakeFromNib
{
    // Initialize drop well ids
    [EffectA setName: EffectA.identifier];
    [EffectB setName: EffectB.identifier];
    [EffectC setName: EffectC.identifier];
    [EffectD setName: EffectD.identifier];
    [EffectE setName: EffectE.identifier];
    [EffectF setName: EffectF.identifier];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Prints out the signal chain for the pedals
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (void) printSignalChain
{
    std::cout << std::endl;
    
    std::cout << "-------------------------------- SIGNAL CHAIN --------------------------------" << std::endl;
    
    for(auto pedal : pedals)
    {
        std::cout << std::string([pedal UTF8String]);
        std::cout << " --> ";
    }
    
    std::cout << std::endl;
    
    std::cout << "------------------------------------------------------------------------------" << std::endl;
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Adds a new effect pedal
 
 \param name
 (Name of the effect pedal)
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (void) addPedal:(NSString *)name
{
    pedals.push_back(name);
    
    [self printSignalChain];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Removes an effect pedal
 
 \param index
 (Index of the effect pedal that needs to be removed)
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (void) removePedal:(unsigned)index
{
    pedals.erase(pedals.begin() + index);
    [self printSignalChain];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Swaps an existing pedal with a new one
 
 \param name
 (Name of the new effect pedal)
 
 \param index
 (Position of the old pedal)
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (void) swapPedal: (NSString *)name arg2: (unsigned)index;
{
    pedals[index] = name;
    [self printSignalChain];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Gets the next empty slot for new pedals
 
 \return
 Returns a string with the empty slot index
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (NSString*) getEmptyPedalIndex
{
    return [NSString stringWithFormat:@"%d",(unsigned)pedals.size()];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Gets the last pedal in the signal chain
 
 \return
 Returns a string with the position of the last pedal
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (NSString*) getLastPedalIndex
{
    return [NSString stringWithFormat:@"%d",(unsigned)pedals.size() - 1];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets parameters corresponding to the effect pedal
 
 \param value
 (Parameter value that needs to be set)
 
 \param type
 (Type of pedal)
 
 \param param
 (Type of parameter)
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (void)setUIParam:(float)value arg2: (UInt32)type arg3: (UInt32) param
{
    if([core GetEffects].size() != 0)
        [core GetEffectFromID: type]->SetEffectParameter(param, value);
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Picks the control tab based on pedal selection
 
 \param name
 (Name of the pedal selected)
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (void)drawControls:(NSString *)name
{
    [control selectTabViewItemAtIndex:1];
        if([name isEqualToString: @"Delay"])
        {
            std::cout << "Showing controls for Delay" << std::endl;
            [controls selectTabViewItemAtIndex:0];
        }
        else if ([name isEqualToString: @"Distortion"])
        {
            std::cout << "Showing controls for Distortion" << std::endl;
            [controls selectTabViewItemAtIndex:1];
        }
        else if ([name isEqualToString: @"Equalizer"])
        {
            std::cout << "Showing controls for Equalizer" << std::endl;
            [controls selectTabViewItemAtIndex:2];
        }
        else if ([name isEqualToString: @"Reverb"])
        {
            std::cout << "Showing controls for Reverb" << std::endl;
            [controls selectTabViewItemAtIndex:3];
        }
        else if ([name isEqualToString: @"Compressor"])
        {
            std::cout << "Showing controls for Compressor" << std::endl;
            [controls selectTabViewItemAtIndex:4];
        }
        else if ([name isEqualToString: @"Whammy"])
        {
            std::cout << "Showing controls for Whammy" << std::endl;
            [controls selectTabViewItemAtIndex:5];
        }
    
    currentSelection = name;
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Adds a new effect based on which pedal is dragged in
 
 \param name
 (Name of the pedal)
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (void)addNewEffect:(NSString *)name
{
    UInt32 effectID;
    
    if([name isEqualToString: @"Delay"])
        effectID = kAudioUnitSubType_Delay;
    else if ([name isEqualToString: @"Distortion"])
        effectID = kAudioUnitSubType_Distortion;
    else if ([name isEqualToString: @"Equalizer"])
        effectID = kAudioUnitSubType_ParametricEQ;
    else if ([name isEqualToString: @"Reverb"])
        effectID = kAudioUnitSubType_MatrixReverb;
    else if ([name isEqualToString: @"Compressor"])
        effectID = kAudioUnitSubType_DynamicsProcessor;
    else if ([name isEqualToString: @"Whammy"])
        effectID = kAudioUnitSubType_Pitch;
    
    [core AddNewEffect: effectID];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Removes and disconnectes the last pedal in the signal chain
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (void)removeEffect
{
    [core RemoveEffect];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Swaps an existing pedal with a new one
 
 \param name
 (Name of the new pedal)
 
 \param index
 (Position of the old pedal)
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (void)swapEffect: (NSString *)name arg2: (unsigned)index
{

}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Gets the image corresponding to the effect pedal
 
 \param name
 (Name of the effect pedal)
 
 \return
 Returns the image for the effect pedal
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
-(NSImage*)getEffectImage:(NSString *)name
{
    if([name isEqualToString: @"Delay"])
        return PedalA.image;
    else if ([name isEqualToString: @"Distortion"])
        return PedalB.image;
    else if ([name isEqualToString: @"Equalizer"])
        return PedalC.image;
    else if ([name isEqualToString: @"Reverb"])
        return PedalD.image;
    else if ([name isEqualToString: @"Compressor"])
        return PedalE.image;
    else if ([name isEqualToString: @"Whammy"])
        return PedalF.image;
    
    std::cout << "Error: Image not found!" << std::endl;
    
    return nil;
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Gets the core singleton
 
 \return
 Returns the core singleton
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (PS_Core *)getCore
{
    return core;
}

@end