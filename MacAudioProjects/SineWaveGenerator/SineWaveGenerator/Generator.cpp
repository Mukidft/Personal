//
//  Generator.cpp
//  SineWaveGenerator
//
//  Created by Lipstick on 9/19/16.
//  Copyright © 2016 Lipstick. All rights reserved.
//

#include "Generator.hpp"
#include <iostream>
#include "math.h"

#define SAFETY 8192

Generator::Generator(unsigned SampleRate) : mSampleRate(SampleRate), mFrequency(440), naive(false), mBPM(120), mDuration(0.5f), oneShot(false), mShotSize(0.1f)
{

}

Generator::~Generator()
{

}

void Generator::start(void) {
    epoch = std::chrono::high_resolution_clock::now();
}

void Generator::startShot(void) {
    epoch2 = std::chrono::high_resolution_clock::now();
}
template <typename duration_type>
const duration_type Generator::time_elapsed(void)
{
    return std::chrono::duration_cast<duration_type>(std::chrono::high_resolution_clock::now() - epoch);
}

template <typename duration_type>
const duration_type Generator::time_elapsed2(void)
{
    return std::chrono::duration_cast<duration_type>(std::chrono::high_resolution_clock::now() - epoch2);
}

unsigned Generator::GetSampleRate()
{
    return mSampleRate;
}

void Generator::SetSampleRate(unsigned rate)
{
    mSampleRate = rate;
}

void Generator::Generate(float* &left, float* &right, float sample, float indexSize)
{
    if(naive)
    {
        mSeconds = sample / mSampleRate;
        std::chrono::milliseconds elapsed = time_elapsed<std::chrono::milliseconds>();
        
        if(timerStarted)
        {
            start();
            timerStarted = false;
        }
        
        if(float(elapsed.count()) / 1000.0f <= mDuration)
        {
            for(unsigned i = 0; i < indexSize; i++)
            {
                float tone = sin(2 * M_PI * (mFrequency * (sample + i)/mSampleRate));
                left[i] = tone;
                right[i] = tone;
            }
        }
        else
        {
            for(unsigned i = 0; i < indexSize; i++)
            {
                left[i] = 0.0f;
                right[i] = 0.0f;
            }
            
            if(float(elapsed.count()) / 1000.0f <= (2 * mDuration))
                start();
        }
    }
    else
    {
        for(unsigned i = 0; i < indexSize; i++)
        {
            left[i] = 0.0f;
            right[i] = 0.0f;
        }
    }
    
    if(oneShot)
    {
        mSeconds = sample / mSampleRate;
        std::chrono::milliseconds elapsed = time_elapsed2<std::chrono::milliseconds>();
        
        if(timerStarted2)
        {
            start();
            timerStarted2 = false;
        }
        
        if(float(elapsed.count()) / 1000.0f <= mShotSize)
        {
            for(unsigned i = 0; i < indexSize; i++)
            {
                float tone = sin(2 * M_PI * (1000 * (sample + i)/mSampleRate));
                left[i] = tone;
                right[i] = tone;
            }
        }
        else
        {
            oneShot = false;
        }
    }
}

void Generator::GenerateOneShot(float* &left, float* &right, float sample, float indexSize)
{
    if(!eventFinished)
    {
        mSeconds = sample / mSampleRate;
        std::chrono::milliseconds elapsed = time_elapsed2<std::chrono::milliseconds>();
        
        if(timerStarted2)
        {
            start();
            timerStarted2 = false;
        }
        
        if(float(elapsed.count()) / 1000.0f <= mShotSize)
        {
            for(unsigned i = 0; i < indexSize; i++)
            {
                float tone = sin(2 * M_PI * (1000 * (sample + i)/mSampleRate));
                left[i] = tone;
                right[i] = tone;
            }
        }
        else
        {
            eventFinished = true;
        }
    }
}





void Generator::SetFrequency(float frequency)
{
    mFrequency = frequency;
}

void Generator::SetBPM(unsigned bpm)
{
    mBPM = bpm;
    mDuration = 1.0f / (float(mBPM) / 60.0f);
    
}

void Generator::TriggerOneShot()
{
    oneShot = true;
    startShot();
    timerStarted2 = true;
}

void Generator::SetRenderStyle(bool state)
{
    naive = state;
    start();
    
    if(naive == true)
        timerStarted = true;
}