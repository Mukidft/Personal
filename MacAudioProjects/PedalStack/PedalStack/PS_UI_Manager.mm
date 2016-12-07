//
//  PS_UI_Manager.m
//  PedalStack
//
//  Created by Lipstick on 10/19/16.
//  Copyright © 2016 Deepak Chennakkadan. All rights reserved.
//

#import "PS_UI_Manager.h"
#include <iostream>
#include <string>

@implementation PS_UI_Manager

- (void) awakeFromNib
{
    [EffectA setName: EffectA.identifier];
    [EffectB setName: EffectB.identifier];
    [EffectC setName: EffectC.identifier];
    [EffectD setName: EffectD.identifier];
    [EffectE setName: EffectE.identifier];
    [EffectF setName: EffectF.identifier];
}

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

- (void) addPedal:(NSString *)name
{
    pedals.push_back(name);
    
    [self printSignalChain];
}

- (void) removePedal:(unsigned)index
{
    pedals.erase(pedals.begin() + index);
    [self printSignalChain];
}

- (void) swapPedal: (NSString *)name arg2: (unsigned)index;
{
    pedals[index] = name;
    [self printSignalChain];
}

- (NSString*) getEmptyPedalIndex
{
    return [NSString stringWithFormat:@"%d",(unsigned)pedals.size()];
}


- (NSString*) getLastPedalIndex
{
    return [NSString stringWithFormat:@"%d",(unsigned)pedals.size() - 1];
}

- (void)setUIParam:(float)value arg2: (UInt32)type arg3: (UInt32) param
{
    if([core GetEffects].size() != 0)
        [core GetEffectFromID: type]->SetEffectParameter(param, value);
}


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

- (void)addNewEffect:(NSString *)name
{
    UInt32 effectID;
    
    if([name isEqualToString: @"Delay"])
        effectID = kAudioUnitSubType_Delay;
    else if ([name isEqualToString: @"Distortion"])
        effectID = kAudioUnitSubType_Distortion;
    else if ([name isEqualToString: @"Equalizer"])
        effectID = kAudioUnitSubType_GraphicEQ;
    else if ([name isEqualToString: @"Reverb"])
        effectID = kAudioUnitSubType_MatrixReverb;
    else if ([name isEqualToString: @"Compressor"])
        effectID = kAudioUnitSubType_DynamicsProcessor;
    else if ([name isEqualToString: @"Whammy"])
        effectID = kAudioUnitSubType_Pitch;
    
    [core AddNewEffect: effectID];
}

- (void)removeEffect
{
    [core RemoveEffect];
}


- (void)swapEffect: (NSString *)name arg2: (unsigned)index
{

}

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


- (PS_Core *)getCore
{
    return core;
}

@end