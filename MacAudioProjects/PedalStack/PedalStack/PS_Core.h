/*****************************************************************************/
/*!
 \file   PS_Core.h
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the interface for CoreAudio and managing the audio graph
 */
/*****************************************************************************/

#include <vector>
#include "PS_Effects.h"

@interface PS_Core : NSObject
{
    AUGraph mGraph;
    AUNode outputNode;
    AudioUnit output;
    AudioUnit input;
    AudioComponentDescription mCompDesc;
    AudioStreamBasicDescription mStreamDesc;
    
    std::vector<PS_Effects*> mEffects;
    std::vector<UInt32> mEffectIDs;
    OSStatus result;
    
}

- (void) initializeGraph;
- (void) CreateNewEffect: (UInt32) effect arg2: (AUGraph) graph arg3: (AUNode) outNode;
- (void) AddNewEffect: (UInt32) effect;
- (void) SwapEffect: (UInt32) effect arg2: (unsigned) index;
- (void) RemoveEffect;
- (void) PrintStreamDescription;
- (PS_Effects*) GetEffectFromID: (UInt32) id;
- (PS_Effects*) GetEffectFromIndex: (unsigned) index;
- (std::vector<UInt32>) GetEffects;
@end

