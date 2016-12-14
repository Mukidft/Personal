/*****************************************************************************/
/*!
 \file   PS_UI_Manager.h
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the interface for the UI manager that handles the app's UI
 */
/*****************************************************************************/

#import "PS_Core.h"
// Framework
#import <Cocoa/Cocoa.h>

// Project
#import "PS_UI_DragView.h"
#include <vector>

@class PS_Core;

@interface PS_UI_Manager : NSObject <NSApplicationDelegate>
{
    IBOutlet NSWindow *window;
    IBOutlet PS_Core *core;
    IBOutlet PS_UI_DragView *EffectA;
    IBOutlet PS_UI_DragView *EffectB;
    IBOutlet PS_UI_DragView *EffectC;
    IBOutlet PS_UI_DragView *EffectD;
    IBOutlet PS_UI_DragView *EffectE;
    IBOutlet PS_UI_DragView *EffectF;
    IBOutlet NSImageView *PedalA;
    IBOutlet NSImageView *PedalB;
    IBOutlet NSImageView *PedalC;
    IBOutlet NSImageView *PedalD;
    IBOutlet NSImageView *PedalE;
    IBOutlet NSImageView *PedalF;
    
    IBOutlet NSTabView *control;
    IBOutlet NSTabView *controls;
    NSString *currentSelection;
    std::vector<NSString *> pedals;    
    
    @public unsigned currentIndex;
};

- (void)addNewEffect:(NSString *)name;
- (void)removeEffect;
- (void)swapEffect: (NSString *)name arg2: (unsigned)index;
- (NSImage*)getEffectImage:(NSString *)name;
- (PS_Core *)getCore;
- (void)setUIParam:(float)value arg2: (UInt32)type arg3: (UInt32) param;
- (void)drawControls:(NSString *)name;
- (void) addPedal:(NSString *)name;
- (void) removePedal:(unsigned)index;
- (void) swapPedal: (NSString *)name arg2: (unsigned)index;
- (NSString*) getEmptyPedalIndex;
- (NSString*) getLastPedalIndex;
- (void) printSignalChain;
- (void) setIndex:(NSString *) name;

@end
