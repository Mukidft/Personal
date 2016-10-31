//
//  Generator.hpp
//  SineWaveGenerator
//
//  Created by Lipstick on 9/19/16.
//  Copyright © 2016 Lipstick. All rights reserved.
//

#ifndef Generator_hpp
#define Generator_hpp

#include <stdio.h>
#include <queue>
#include <chrono>

class Generator
{
public:
    
    Generator(unsigned SampleRate = 44100);
    ~Generator();
    
    void Generate(float* &left, float* &right, float sample, float indexSize);
    void GenerateOneShot(float* &left, float* &right, float sample, float indexSize);
    
    unsigned GetSampleRate();
    
    void SetSampleRate(unsigned rate);
    void SetBPM(unsigned bpm);
    void SetFrequency(float frequency);
    void TriggerOneShot();
    void SetRenderStyle(bool state);
    void AddEvent();
    bool GetOneShot(){return oneShot;};
    
private:
    
    unsigned mSampleRate;
    unsigned mBPM;
    unsigned mSeconds;
    float mFrequency;
    float mDuration;
    float mShotSize;
    
    bool naive;
    bool oneShot;
    bool eventFinished = true;
    bool timerStarted;
    bool timerStarted2;
    
    void start(void);
    void startShot(void);
    template <typename duration_type>
    const duration_type time_elapsed(void);
    template <typename duration_type>
    const duration_type time_elapsed2(void);
    std::chrono::high_resolution_clock::time_point epoch;
    std::chrono::high_resolution_clock::time_point epoch2;
    
};

#endif /* Generator_hpp */
