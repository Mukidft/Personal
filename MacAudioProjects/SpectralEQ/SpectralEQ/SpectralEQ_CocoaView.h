/*
 
     File: SpectralEQ_CocoaView.h
 Abstract: Audio Unit Cocoa View Factory definition.
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

#import <Cocoa/Cocoa.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>
#include "UI_GraphView.h"

/************************************************************************************************************/
/* NOTE: It is important to rename ALL ui classes when using the Xcode Audio Unit with Cocoa View template	*/
/*		 Cocoa has a flat namespace, and if you use the default filenames, it is possible that you will		*/
/*		 get a namespace collision with classes from the cocoa view of a previously loaded audio unit.		*/
/*		 We recommend that you use a unique prefix that includes the manufacturer name and unit name on		*/
/*		 all objective-C source files. You may use an underscore in your name, but please refrain from		*/
/*		 starting your class name with an undescore as these names are reserved for Apple.					*/
/*  Example  : AppleDemoFilter_UIView AppleDemoFilter_ViewFactory											*/
/************************************************************************************************************/

@interface SpectralEQ_GestureSlider : NSSlider {}
@end

@interface SpectralEQ_CocoaView : NSView
{
    IBOutlet UI_GraphView * graphView;
    
    // IB Members
    IBOutlet NSSlider * uiParam1Slider;
    IBOutlet NSTextField *			uiParam1TextField;
    
    // EQ1
    IBOutlet NSSlider * uiParam_eq1_f;
    IBOutlet NSSlider * uiParam_eq1_q;
    IBOutlet NSSlider * uiParam_eq1_g;
    
    
    IBOutlet NSTextField * uiParam_eq1_f_Label;
    IBOutlet NSTextField * uiParam_eq1_q_Label;
    IBOutlet NSTextField * uiParam_eq1_g_Label;
    
    IBOutlet NSSegmentedControl * uiParam_eq1_bypass;
    
    // EQ2
    IBOutlet NSSlider * uiParam_eq2_f;
    IBOutlet NSSlider * uiParam_eq2_q;
    IBOutlet NSSlider * uiParam_eq2_g;
    
    
    IBOutlet NSTextField * uiParam_eq2_f_Label;
    IBOutlet NSTextField * uiParam_eq2_q_Label;
    IBOutlet NSTextField * uiParam_eq2_g_Label;
    
    IBOutlet NSSegmentedControl * uiParam_eq2_bypass;
    
    // EQ3
    IBOutlet NSSlider * uiParam_eq3_f;
    IBOutlet NSSlider * uiParam_eq3_q;
    IBOutlet NSSlider * uiParam_eq3_g;
    
    
    IBOutlet NSTextField * uiParam_eq3_f_Label;
    IBOutlet NSTextField * uiParam_eq3_q_Label;
    IBOutlet NSTextField * uiParam_eq3_g_Label;
    
    IBOutlet NSSegmentedControl * uiParam_eq3_bypass;
    
    // EQ4
    IBOutlet NSSlider * uiParam_eq4_f;
    IBOutlet NSSlider * uiParam_eq4_q;
    IBOutlet NSSlider * uiParam_eq4_g;
    
    
    IBOutlet NSTextField * uiParam_eq4_f_Label;
    IBOutlet NSTextField * uiParam_eq4_q_Label;
    IBOutlet NSTextField * uiParam_eq4_g_Label;
    
    IBOutlet NSSegmentedControl * uiParam_eq4_bypass;
    
    // EQ5
    IBOutlet NSSlider * uiParam_eq5_f;
    IBOutlet NSSlider * uiParam_eq5_q;
    IBOutlet NSSlider * uiParam_eq5_g;
    
    
    IBOutlet NSTextField * uiParam_eq5_f_Label;
    IBOutlet NSTextField * uiParam_eq5_q_Label;
    IBOutlet NSTextField * uiParam_eq5_g_Label;
    
    IBOutlet NSSegmentedControl * uiParam_eq5_bypass;
    
    // EQ6
    IBOutlet NSSlider * uiParam_eq6_f;
    IBOutlet NSSlider * uiParam_eq6_q;
    IBOutlet NSSlider * uiParam_eq6_g;
    
    
    IBOutlet NSTextField * uiParam_eq6_f_Label;
    IBOutlet NSTextField * uiParam_eq6_q_Label;
    IBOutlet NSTextField * uiParam_eq6_g_Label;
    
    IBOutlet NSSegmentedControl * uiParam_eq6_bypass;
    
    IBOutlet NSPopUpButton * uiParam_Window;
	
    // Other Members
    AudioUnit 				mAU;
	AudioUnitParameter		mParameter[26];
    AUParameterListenerRef	mParameterListener;
    AUEventListenerRef      mAUEventListener;
}

#pragma mark ____ PUBLIC FUNCTIONS ____
- (void)setAU:(AudioUnit)inAU;

#pragma mark ____ INTERFACE ACTIONS ____
- (IBAction)iaParam1Changed:(id)sender;

// EQ 1
- (IBAction)iaParam_eq1_f_Changed:(id)sender;
- (IBAction)iaParam_eq1_q_Changed:(id)sender;
- (IBAction)iaParam_eq1_g_Changed:(id)sender;

- (IBAction)iaParam_eq1_bypass:(id)sender;

// EQ 2
- (IBAction)iaParam_eq2_f_Changed:(id)sender;
- (IBAction)iaParam_eq2_q_Changed:(id)sender;
- (IBAction)iaParam_eq2_g_Changed:(id)sender;

- (IBAction)iaParam_eq2_bypass:(id)sender;

// EQ 3
- (IBAction)iaParam_eq3_f_Changed:(id)sender;
- (IBAction)iaParam_eq3_q_Changed:(id)sender;
- (IBAction)iaParam_eq3_g_Changed:(id)sender;

- (IBAction)iaParam_eq3_bypass:(id)sender;

// EQ 4
- (IBAction)iaParam_eq4_f_Changed:(id)sender;
- (IBAction)iaParam_eq4_q_Changed:(id)sender;
- (IBAction)iaParam_eq4_g_Changed:(id)sender;

- (IBAction)iaParam_eq4_bypass:(id)sender;

// EQ 5
- (IBAction)iaParam_eq5_f_Changed:(id)sender;
- (IBAction)iaParam_eq5_q_Changed:(id)sender;
- (IBAction)iaParam_eq5_g_Changed:(id)sender;

- (IBAction)iaParam_eq5_bypass:(id)sender;

// EQ 6
- (IBAction)iaParam_eq6_f_Changed:(id)sender;
- (IBAction)iaParam_eq6_q_Changed:(id)sender;
- (IBAction)iaParam_eq6_g_Changed:(id)sender;

- (IBAction)iaParam_eq6_bypass:(id)sender;

- (IBAction)iaParam_window:(id)sender;

#pragma mark ____ PRIVATE FUNCTIONS
- (void)synchronizeUIWithParameterValues;
- (void)addListeners;
- (void)removeListeners;
- (void)addEventListeners;
- (void)removeEventListeners;

#pragma mark ____ LISTENER CALLBACK DISPATCHEE ____
- (void)parameterListener:(void *)inObject parameter:(const AudioUnitParameter *)inParameter value:(Float32)inValue;
- (void)priv_eventListener:(void *) inObject event:(const AudioUnitEvent *)inEvent value:(Float32)inValue;

@end
