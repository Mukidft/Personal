//
//  AppDelegate.m
//  SineWaveGenerator
//
//  Created by Lipstick on 9/12/16.
//  Copyright (c) 2016 Lipstick. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioUnit/AudioUnitParameters.h>
#import <AudioUnit/AudioUnitProperties.h>


#include <iostream>

#define L_HZ 440
#define R_HZ 1760
#define BPM 120

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)awakeFromNib
{
    std::cout << "Nib has been awaken!" << std::endl;
    
    modules.ui.isClicked = false;
    modules.ui.isChecked = false;
    
    
    [self initializeGraph];
}

- (IBAction)click:(id)sender
{
    modules.ui.isClicked = !modules.ui.isClicked;
    modules.generator.TriggerOneShot();
    modules.eventScheduler.ScheduleOneShot();
}

-(IBAction)OnCheck:(id)sender
{
    modules.ui.isChecked = !modules.ui.isChecked;
    modules.generator.SetRenderStyle(modules.ui.isChecked);
    modules.eventScheduler.StartMetronome(modules.ui.isChecked);
}

-(IBAction)OnValueChangeA:(id)sender
{
    float value = [sender floatValue];
    modules.generator.SetFrequency(value);
    
    if(sender == frequency)
        [frequencyLabel setIntegerValue: (int)value];
}

-(IBAction)OnValueChangeB:(id)sender
{
    unsigned value = [sender intValue];
    modules.generator.SetBPM(value);
    modules.eventScheduler.SetBPM(value);
    
    if(sender == bpm)
        [bpmLabel setIntegerValue: (int)value];
}

- (void) initializeGraph
{    
    OSStatus result = noErr;
    
    result = NewAUGraph(&mGraph);
    
    AUNode outputNode;
    
    std::cout << "Creating AUGraph" << std::endl;
    
    mCompDesc.componentType = kAudioUnitType_Output;
    mCompDesc.componentSubType = kAudioUnitSubType_DefaultOutput;
    mCompDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    mCompDesc.componentFlagsMask = 0;
    mCompDesc.componentFlags = 0;
    
    result = AUGraphAddNode(mGraph, &mCompDesc, &outputNode);
    
    if (result)
    {
        printf("AUGraphAddNode 1 result %lu %4.4s\n", (unsigned long)result, (char*)&result);
        return;
    }
    
    result = AUGraphOpen(mGraph);
    
    if (result)
    {
        printf("AUGraphOpen result %u %4.4s\n", (unsigned int)result, (char*)&result);
        return;
    }
    
    result = AUGraphNodeInfo(mGraph, outputNode, NULL, &output);
    
    if (result) {
        printf("AUGraphNodeInfo result %u %4.4s\n", (unsigned int)result, (char*)&result);
        return;
    }
    
    UInt32 size;
    
    std::cout << "Setting Render Callback" << std::endl;
    
    AURenderCallbackStruct renderObj;
    renderObj.inputProc = &renderInput;
    renderObj.inputProcRefCon = &modules;
    
    
    result = AudioUnitSetProperty(output,
                                  kAudioUnitProperty_SetRenderCallback,
                                  kAudioUnitScope_Input,
                                  0,
                                  &renderObj,
                                  sizeof(renderObj) );
    
    size = sizeof(mStreamDesc);
    result = AudioUnitGetProperty(output,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Input,
                                  0,
                                  &mStreamDesc,
                                  &size );
    
    result = AudioUnitSetProperty(output,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  0,
                                  &mStreamDesc,
                                  sizeof(mStreamDesc) );
    
    modules.generator.SetSampleRate(mStreamDesc.mSampleRate);
    
    AUGraphInitialize(mGraph);
    CAShow(mGraph);
    
    AUGraphStart(mGraph);
    
}

OSStatus renderInput(void *inRefCon,
                     AudioUnitRenderActionFlags *ioActionFlags,
                     const AudioTimeStamp *inTimeStamp,
                     UInt32 inBusNumber,
                     UInt32 inNumberFrames,
                     AudioBufferList *ioData)
{
    float *outA = (float*)ioData->mBuffers[0].mData;
    float *outB = (float*)ioData->mBuffers[1].mData;
    
    Modules* modules = (Modules*) inRefCon;
    
    modules->eventScheduler.SetHostTime(inTimeStamp->mHostTime);
    modules->generator.Generate(outA, outB, inTimeStamp->mSampleTime, inNumberFrames);
    
    if(modules->ui.isChecked == false)
        modules->eventScheduler.ScheduleEvents();
    
    if(!modules->eventScheduler.GetEventList().empty())
    {
        if(modules->generator.GetOneShot() == true)
            modules->eventScheduler.GetEventList().pop(); 
        
        if(modules->eventScheduler.GetEventList().front() >= inTimeStamp->mHostTime)
        {
            modules->generator.GenerateOneShot(outA, outB, inTimeStamp->mSampleTime, inNumberFrames);
            modules->eventScheduler.GetEventList().pop();            
        }
    }
    
    return noErr;
}

@end
