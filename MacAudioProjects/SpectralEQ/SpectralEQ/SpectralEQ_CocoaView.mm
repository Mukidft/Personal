/*
 
     File: SpectralEQ_CocoaView.m
 Abstract: Audio Unit Cocoa View imlementation.
  Version: 1.0.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2012 Apple Inc. All Rights Reserved.
 
 
*/

#import "SpectralEQ_CocoaView.h"
#include <iostream>

enum {
    kParam_One =0,
    kParam_EQ1_F =1,
    kParam_EQ1_Q =2,
    kParam_EQ1_G =3,
    kParam_EQ2_F =4,
    kParam_EQ2_Q =5,
    kParam_EQ2_G =6,
    kParam_EQ3_F =7,
    kParam_EQ3_Q =8,
    kParam_EQ3_G =9,
    kParam_EQ4_F =10,
    kParam_EQ4_Q =11,
    kParam_EQ4_G =12,
    kParam_EQ5_F =13,
    kParam_EQ5_Q =14,
    kParam_EQ5_G =15,
    kParam_EQ6_F =16,
    kParam_EQ6_Q =17,
    kParam_EQ6_G =18,
    kParam_EQ1_BYPASS = 19,
    kParam_EQ2_BYPASS = 20,
    kParam_EQ3_BYPASS = 21,
    kParam_EQ4_BYPASS = 22,
    kParam_EQ5_BYPASS = 23,
    kParam_EQ6_BYPASS = 24,
    kParam_WINDOW = 25,
	kNumberOfParameters=26
};

#pragma mark ____ LISTENER CALLBACK DISPATCHER ____
void ParameterListenerDispatcher (void *inRefCon, void *inObject, const AudioUnitParameter *inParameter, Float32 inValue) {
	SpectralEQ_CocoaView *SELF = (SpectralEQ_CocoaView *)inRefCon;
    [SELF parameterListener:inObject parameter:inParameter value:inValue];
}

NSString *SpectralEQ_GestureSliderMouseDownNotification = @"CAGestureSliderMouseDownNotification";
NSString *SpectralEQ_GestureSliderMouseUpNotification = @"CAGestureSliderMouseUpNotification";

@implementation SpectralEQ_GestureSlider

/*	We create our own custom subclass of NSSlider so we can do begin/end gesture notification
	We cannot override mouseUp: because it will never be called. Instead we do a clever trick in mouseDown to send mouseUp notifications */
- (void)mouseDown:(NSEvent *)inEvent {
	[[NSNotificationCenter defaultCenter] postNotificationName: SpectralEQ_GestureSliderMouseDownNotification object: self];
	
	[super mouseDown: inEvent];	// this call does not return until mouse tracking is complete
								// once tracking is done, we know the mouse has been released, so we can send our mouseup notification

	[[NSNotificationCenter defaultCenter] postNotificationName: SpectralEQ_GestureSliderMouseUpNotification object: self];
}
	
@end

@implementation SpectralEQ_CocoaView
#pragma mark ____ (INIT /) DEALLOC ____
- (void)dealloc {
    [self removeListeners];
    [super dealloc];
}

#pragma mark ____ PUBLIC FUNCTIONS ____
- (void)setAU:(AudioUnit)inAU {
	// remove previous listeners
	if (mAU) [self removeListeners];
	mAU = inAU;
    
   	mParameter[0].mAudioUnit = inAU;
	mParameter[0].mParameterID = kParam_One;
	mParameter[0].mScope = kAudioUnitScope_Global;
	mParameter[0].mElement = 0;
    
    // Set EQ params
    for(int i = 1; i <= 25; i++)
    {
        mParameter[i].mAudioUnit = inAU;
        mParameter[i].mParameterID = i;
        mParameter[i].mScope = kAudioUnitScope_Global;
        mParameter[i].mElement = 0;
    }

	// add new listeners
	[self addListeners];
    [self addEventListeners];
	
	// initial setup
	[self synchronizeUIWithParameterValues];
}

#pragma mark ____ INTERFACE ACTIONS ____

- (IBAction)iaParam1Changed:(id)sender {
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[0], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam1Changed:] AUParameterSet()");
    
    if (sender == uiParam1Slider) {
        [uiParam1TextField setFloatValue:floatValue];
    } else {
        [uiParam1Slider setFloatValue:floatValue];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// EQ 1 F
- (IBAction)iaParam_eq1_f_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[1], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq1_f_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq1_f) {
        [uiParam_eq1_f_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq1_f setFloatValue:floatValue];
    }
}

// EQ 1 Q
- (IBAction)iaParam_eq1_q_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[2], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq1_q_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq1_q) {
        [uiParam_eq1_q_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq1_q setFloatValue:floatValue];
    }
}

// EQ 1 G
- (IBAction)iaParam_eq1_g_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[3], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq1_g_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq1_g) {
        [uiParam_eq1_g_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq1_g setFloatValue:floatValue];
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// EQ 2 F
- (IBAction)iaParam_eq2_f_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[4], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq2_f_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq2_f) {
        [uiParam_eq2_f_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq2_f setFloatValue:floatValue];
    }
}

// EQ 2 Q
- (IBAction)iaParam_eq2_q_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[5], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq2_q_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq2_q) {
        [uiParam_eq2_q_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq2_q setFloatValue:floatValue];
    }
}

// EQ 2 G
- (IBAction)iaParam_eq2_g_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[6], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq2_g_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq2_g) {
        [uiParam_eq2_g_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq2_g setFloatValue:floatValue];
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// EQ 3 F
- (IBAction)iaParam_eq3_f_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[7], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq3_f_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq3_f) {
        [uiParam_eq3_f_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq3_f setFloatValue:floatValue];
    }
}

// EQ 3 Q
- (IBAction)iaParam_eq3_q_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[8], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq3_q_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq3_q) {
        [uiParam_eq3_q_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq3_q setFloatValue:floatValue];
    }
}

// EQ 3 G
- (IBAction)iaParam_eq3_g_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[9], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq3_g_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq3_g) {
        [uiParam_eq3_g_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq3_g setFloatValue:floatValue];
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// EQ 4 F
- (IBAction)iaParam_eq4_f_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[10], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq4_f_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq4_f) {
        [uiParam_eq4_f_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq4_f setFloatValue:floatValue];
    }
}

// EQ 4 Q
- (IBAction)iaParam_eq4_q_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[11], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq4_q_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq4_q) {
        [uiParam_eq4_q_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq4_q setFloatValue:floatValue];
    }
}

// EQ 4 G
- (IBAction)iaParam_eq4_g_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[12], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq4_g_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq4_g) {
        [uiParam_eq4_g_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq4_g setFloatValue:floatValue];
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// EQ 5 F
- (IBAction)iaParam_eq5_f_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[13], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq5_f_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq5_f) {
        [uiParam_eq5_f_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq5_f setFloatValue:floatValue];
    }
}

// EQ 5 Q
- (IBAction)iaParam_eq5_q_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[14], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq5_q_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq5_q) {
        [uiParam_eq5_q_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq5_q setFloatValue:floatValue];
    }
}

// EQ 5 G
- (IBAction)iaParam_eq5_g_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[15], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq5_g_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq5_g) {
        [uiParam_eq5_g_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq5_g setFloatValue:floatValue];
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// EQ 6 F
- (IBAction)iaParam_eq6_f_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[16], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq6_f_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq6_f) {
        [uiParam_eq6_f_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq6_f setFloatValue:floatValue];
    }
}

// EQ 6 Q
- (IBAction)iaParam_eq6_q_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[17], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq6_q_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq6_q) {
        [uiParam_eq6_q_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq6_q setFloatValue:floatValue];
    }
}

// EQ 6 G
- (IBAction)iaParam_eq6_g_Changed:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[18], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq6_g_Changed:] AUParameterSet()");
    
    if (sender == uiParam_eq6_g) {
        [uiParam_eq6_g_Label setFloatValue:floatValue];
    } else {
        [uiParam_eq6_g setFloatValue:floatValue];
    }
}

// BYPASS
- (IBAction)iaParam_eq1_bypass:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[19], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq1_bypass:] AUParameterSet()");
    
    if (sender != uiParam_eq1_bypass) {
    } else {
        [uiParam_eq1_bypass setFloatValue:floatValue];
    }
}

- (IBAction)iaParam_eq2_bypass:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[20], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq2_bypass:] AUParameterSet()");
    
    if (sender != uiParam_eq2_bypass) {
    } else {
        [uiParam_eq2_bypass setFloatValue:floatValue];
    }
}

- (IBAction)iaParam_eq3_bypass:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[21], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq3_bypass:] AUParameterSet()");
    
    if (sender != uiParam_eq3_bypass) {
    } else {
        [uiParam_eq3_bypass setFloatValue:floatValue];
    }
}

- (IBAction)iaParam_eq4_bypass:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[22], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq4_bypass:] AUParameterSet()");
    
    if (sender != uiParam_eq4_bypass) {
    } else {
        [uiParam_eq4_bypass setFloatValue:floatValue];
    }
}

- (IBAction)iaParam_eq5_bypass:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[23], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq5_bypass:] AUParameterSet()");
    
    if (sender != uiParam_eq5_bypass) {
    } else {
        [uiParam_eq5_bypass setFloatValue:floatValue];
    }
}

- (IBAction)iaParam_eq6_bypass:(id)sender
{
    float floatValue = [sender floatValue];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[24], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_eq6_bypass:] AUParameterSet()");
    
    if (sender != uiParam_eq6_bypass) {
    } else {
        [uiParam_eq6_bypass setFloatValue:floatValue];
    }
}

- (IBAction)iaParam_window:(id)sender
{
    float floatValue = [uiParam_Window indexOfSelectedItem];
    
    OSStatus result = AUParameterSet(mParameterListener, sender, &mParameter[25], (Float32)floatValue, 0);
    NSAssert(result == noErr, @"[SpectralEQ_CocoaView iaParam_window:] AUParameterSet()");
    
    if (sender != uiParam_Window) {
    } else {
        [uiParam_Window setFloatValue:floatValue];
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark ____ NOTIFICATIONS ____

// This routine is called when the user has clicked on the slider. We need to send a begin parameter change gesture to alert hosts that the parameter may be changing value
-(void) handleMouseDown: (NSNotification *) aNotification {
	if ([aNotification object] == uiParam1Slider) {
		AudioUnitEvent event;
		event.mArgument.mParameter = mParameter[0];
		event.mEventType = kAudioUnitEvent_BeginParameterChangeGesture;
		
		AUEventListenerNotify (NULL, self, &event);		// NOTE, if you have an AUEventListenerRef because you are listening to event notification, 
														// pass that as the first argument to AUEventListenerNotify instead of NULL 
	}
}

-(void) handleMouseUp: (NSNotification *) aNotification {
	if ([aNotification object] == uiParam1Slider) {
		AudioUnitEvent event;
		event.mArgument.mParameter = mParameter[0];
		event.mEventType = kAudioUnitEvent_EndParameterChangeGesture;
	
		AUEventListenerNotify (NULL, self, &event);		// NOTE, if you have an AUEventListenerRef because you are listening to event notification, 
														// pass that as the first argument to AUEventListenerNotify instead of NULL 
	}
}


#pragma mark ____ PRIVATE FUNCTIONS ____
- (void)addListeners {
    OSStatus result = AUListenerCreate(	ParameterListenerDispatcher, self, 
                                    CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0.100, // 100 ms
                                    &mParameterListener	);
	NSAssert(result == noErr, @"[SpectralEQ_CocoaView _addListeners] AUListenerCreate()");
	
    int i;
    for (i = 0; i < kNumberOfParameters; ++i) {
        mParameter[i].mAudioUnit = mAU;
        result = AUListenerAddParameter (mParameterListener, NULL, &mParameter[i]);
        NSAssert(result == noErr, @"[SpectralEQ_CocoaView _addListeners] AUListenerAddParameter()");
    }
    
   	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleMouseDown:) name:SpectralEQ_GestureSliderMouseDownNotification object: uiParam1Slider];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleMouseUp:) name:SpectralEQ_GestureSliderMouseUpNotification object: uiParam1Slider];
    
}

void EventListenerDispatcher(void *inRefCon, void *inObject, const AudioUnitEvent *inEvent, UInt64 inHostTime, Float32 inValue)
{
    SpectralEQ_CocoaView *SELF = (SpectralEQ_CocoaView *) inRefCon;
    [SELF priv_eventListener:inObject event: inEvent value: inValue];
}

// CALLBACK DISPATCHEE
- (void)priv_eventListener:(void *) inObject event:(const AudioUnitEvent *)inEvent value:(Float32)inValue
{
    if(mAU)
    {
        if(inEvent->mEventType == kAudioUnitEvent_PropertyChange)
        {
            if(inEvent->mArgument.mProperty.mPropertyID == kAudioUnitProperty_SpectrumGraphData_Wet)
            {
                [self performSelector:@selector(drawSpectrumGraph:) withObject:self afterDelay:0];
            }
            
            if(inEvent->mArgument.mProperty.mPropertyID == kAudioUnitProperty_SpectrumGraphData_Dry)
            {
                [self performSelector:@selector(drawSpectrumGraph:) withObject:self afterDelay:0];
            }
        }
    }
}

- (void) addEventListeners
{
    if(mAU)
    {
        verify_noerr(AUEventListenerCreate(EventListenerDispatcher, self, CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0.05, 0.05, &mAUEventListener));
        
        AudioUnitEvent auEvent;
        auEvent.mEventType = kAudioUnitEvent_PropertyChange;
        auEvent.mArgument.mProperty.mAudioUnit = mAU;
        auEvent.mArgument.mProperty.mPropertyID = kAudioUnitProperty_SpectrumGraphData_Wet;
        auEvent.mArgument.mProperty.mScope = kAudioUnitScope_Global;
        auEvent.mArgument.mProperty.mElement = 0;
        verify_noerr(AUEventListenerAddEventType(mAUEventListener, self, &auEvent));
        
        AudioUnitEvent auEvent2;
        auEvent2.mEventType = kAudioUnitEvent_PropertyChange;
        auEvent2.mArgument.mProperty.mAudioUnit = mAU;
        auEvent2.mArgument.mProperty.mPropertyID = kAudioUnitProperty_SpectrumGraphData_Dry;
        auEvent2.mArgument.mProperty.mScope = kAudioUnitScope_Global;
        auEvent2.mArgument.mProperty.mElement = 0;
        verify_noerr(AUEventListenerAddEventType(mAUEventListener, self, &auEvent2));
    }
}

- (void) removeEventListeners
{
    if(mAUEventListener) verify_noerr(AUListenerDispose(mAUEventListener));
    
    mAUEventListener = NULL;
    mAU = NULL;
}

- (void)removeListeners {
    OSStatus result;
    int i;
    for (i = 0; i < kNumberOfParameters; ++i) {
        result = AUListenerRemoveParameter(mParameterListener, NULL, &mParameter[i]);
        NSAssert(result == noErr, @"[SpectralEQ_CocoaView _removeListeners] AUListenerRemoveParameter()");
    }
    
    result = AUListenerDispose(mParameterListener);
	NSAssert(result == noErr, @"[SpectralEQ_CocoaView _removeListeners] AUListenerDispose()");
    
    [[NSNotificationCenter defaultCenter] removeObserver: self name:SpectralEQ_GestureSliderMouseDownNotification object: uiParam1Slider];
	[[NSNotificationCenter defaultCenter] removeObserver: self name:SpectralEQ_GestureSliderMouseUpNotification object: uiParam1Slider];
}

- (void)synchronizeUIWithParameterValues {
    OSStatus result;
	Float32 value;
    int i;
    
    for (i = 0; i < kNumberOfParameters; ++i) {
        // only has global parameters
        result = AudioUnitGetParameter(mAU, mParameter[i].mParameterID, kAudioUnitScope_Global, 0, &value);
        NSAssert(result == noErr, @"[SpectralEQ_CocoaView synchronizeUIWithParameterValues] (x.1)");
        
        result = AUParameterSet (mParameterListener, self, &mParameter[i], value, 0);
        NSAssert(result == noErr, @"[SpectralEQ_CocoaView synchronizeUIWithParameterValues] (x.2)");
        
        result = AUParameterListenerNotify (mParameterListener, self, &mParameter[i]);
        NSAssert(result == noErr, @"[SpectralEQ_CocoaView synchronizeUIWithParameterValues] (x.3)");
    }
}

#pragma mark ____ LISTENER CALLBACK DISPATCHEE ____
- (void)parameterListener:(void *)inObject parameter:(const AudioUnitParameter *)inParameter value:(Float32)inValue {
    //inObject ignored in this case.
    
	switch (inParameter->mParameterID)
    {
        // Output
		case kParam_One:
            [uiParam1Slider setFloatValue:inValue];
            [uiParam1TextField setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        
        // EQ 1
        case kParam_EQ1_F:
            [uiParam_eq1_f setFloatValue:inValue];
            [uiParam_eq1_f_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        case kParam_EQ1_Q:
            [uiParam_eq1_q setFloatValue:inValue];
            [uiParam_eq1_q_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        case kParam_EQ1_G:
            [uiParam_eq1_g setFloatValue:inValue];
            [uiParam_eq1_g_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
            
        // EQ 2
        case kParam_EQ2_F:
            [uiParam_eq2_f setFloatValue:inValue];
            [uiParam_eq2_f_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        case kParam_EQ2_Q:
            [uiParam_eq2_q setFloatValue:inValue];
            [uiParam_eq2_q_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        case kParam_EQ2_G:
            [uiParam_eq2_g setFloatValue:inValue];
            [uiParam_eq2_g_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
            
        // EQ 3
        case kParam_EQ3_F:
            [uiParam_eq3_f setFloatValue:inValue];
            [uiParam_eq3_f_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        case kParam_EQ3_Q:
            [uiParam_eq3_q setFloatValue:inValue];
            [uiParam_eq3_q_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        case kParam_EQ3_G:
            [uiParam_eq3_g setFloatValue:inValue];
            [uiParam_eq3_g_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
            
        // EQ 4
        case kParam_EQ4_F:
            [uiParam_eq4_f setFloatValue:inValue];
            [uiParam_eq4_f_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        case kParam_EQ4_Q:
            [uiParam_eq4_q setFloatValue:inValue];
            [uiParam_eq4_q_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        case kParam_EQ4_G:
            [uiParam_eq4_g setFloatValue:inValue];
            [uiParam_eq4_g_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
            
        // EQ 5
        case kParam_EQ5_F:
            [uiParam_eq5_f setFloatValue:inValue];
            [uiParam_eq5_f_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        case kParam_EQ5_Q:
            [uiParam_eq5_q setFloatValue:inValue];
            [uiParam_eq5_q_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        case kParam_EQ5_G:
            [uiParam_eq5_g setFloatValue:inValue];
            [uiParam_eq5_g_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
            
        // EQ 6
        case kParam_EQ6_F:
            [uiParam_eq6_f setFloatValue:inValue];
            [uiParam_eq6_f_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        case kParam_EQ6_Q:
            [uiParam_eq6_q setFloatValue:inValue];
            [uiParam_eq6_q_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
        case kParam_EQ6_G:
            [uiParam_eq6_g setFloatValue:inValue];
            [uiParam_eq6_g_Label setStringValue:[[NSNumber numberWithFloat:inValue] stringValue]];
            break;
            
        // BYPASS
        case kParam_EQ1_BYPASS:
            [uiParam_eq1_bypass setIntegerValue:inValue];
            break;
        case kParam_EQ2_BYPASS:
            [uiParam_eq2_bypass setIntegerValue:inValue];
            break;
            
        case kParam_EQ3_BYPASS:
            [uiParam_eq3_bypass setIntegerValue:inValue];
            break;
            
        case kParam_EQ4_BYPASS:
            [uiParam_eq4_bypass setIntegerValue:inValue];
            break;
            
        case kParam_EQ5_BYPASS:
            [uiParam_eq5_bypass setIntegerValue:inValue];
            break;
            
        case kParam_EQ6_BYPASS:
            [uiParam_eq6_bypass setIntegerValue:inValue];
            break;
        
        // WINDOW
        case kParam_WINDOW:
            [uiParam_Window setIntegerValue:inValue];
            break;

	}
}


-(void)drawSpectrumGraph:(id)sender
{
    struct SpectrumGraphInfo graphInfo_Wet;
    graphInfo_Wet.mNumBins = 0;
    
    UInt32 sizeOfResult_Wet = sizeof(graphInfo_Wet);
    
    ComponentResult result_Wet = AudioUnitGetProperty(mAU,
                                                  kAudioUnitProperty_SpectrumGraphInfo_Wet,
                                                  kAudioUnitScope_Global,
                                                  0,
                                                  &graphInfo_Wet,
                                                  &sizeOfResult_Wet);
    
    struct SpectrumGraphInfo graphInfo_Dry;
    graphInfo_Dry.mNumBins = 0;
    
    UInt32 sizeOfResult_Dry = sizeof(graphInfo_Dry);
    
    ComponentResult result_Dry = AudioUnitGetProperty(mAU,
                                                  kAudioUnitProperty_SpectrumGraphInfo_Dry,
                                                  kAudioUnitScope_Global,
                                                  0,
                                                  &graphInfo_Dry,
                                                  &sizeOfResult_Dry);
    
    if(result_Wet == noErr && graphInfo_Wet.mNumBins > 0)
    {
        size_t mBins_Wet = graphInfo_Wet.mNumBins;
        sizeOfResult_Wet = graphInfo_Wet.mNumBins * sizeof(Float32);
        
        Float32 graphData_Wet[mBins_Wet];
        memset(graphData_Wet, 0, sizeOfResult_Wet);
        
        result_Wet = AudioUnitGetProperty(mAU,
                                      kAudioUnitProperty_SpectrumGraphData_Wet,
                                      kAudioUnitScope_Global,
                                      0,
                                      graphData_Wet,
                                      &sizeOfResult_Wet);
        
        size_t mBins_Dry = graphInfo_Dry.mNumBins;
        sizeOfResult_Dry = graphInfo_Dry.mNumBins * sizeof(Float32);
        
        Float32 graphData_Dry[mBins_Dry];
        memset(graphData_Dry, 0, sizeOfResult_Dry);
        
        result_Dry = AudioUnitGetProperty(mAU,
                                          kAudioUnitProperty_SpectrumGraphData_Dry,
                                          kAudioUnitScope_Global,
                                          0,
                                          graphData_Dry,
                                          &sizeOfResult_Dry);
        
        [graphView plotData:graphData_Wet WetInfos:graphInfo_Wet DryData:graphData_Dry DryInfos:graphInfo_Dry];
    }
}


@end
