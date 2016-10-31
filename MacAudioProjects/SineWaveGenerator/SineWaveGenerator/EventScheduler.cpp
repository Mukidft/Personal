//
//  EventScheduler.cpp
//  EventScheduler
//
//  Created by Lipstick on 9/19/16.
//  Copyright © 2016 Lipstick. All rights reserved.
//

#include "EventScheduler.hpp"
#include <iostream>
#include "math.h"

EventScheduler::EventScheduler() : mBPM(120), mDuration(0.5f), metronomeStarted(false)
{
    
}

EventScheduler::~EventScheduler()
{
    
}

void EventScheduler::start(void) {
    epoch = chrono::high_resolution_clock::now();
}

template <typename duration_type>
const duration_type EventScheduler::time_elapsed(void)
{
    return chrono::duration_cast<duration_type>(chrono::high_resolution_clock::now() - epoch);
}

void EventScheduler::ScheduleEvents()
{
    std::chrono::milliseconds elapsed = time_elapsed<chrono::milliseconds>();
    
    if(timerStarted)
    {
        start();
        timerStarted = false;
    }
    
    if(!metronomeStarted)
    {
        if(float(elapsed.count()) / 1000.0f <= mDuration)
        {
            EventList.push(mHostTime);
        }
        else
        {
            if(float(elapsed.count()) / 1000.0f <= (2 * mDuration))
                start();
        }
    }
    else
    {
    }
}

queue<int64_t> EventScheduler::GetEventList()
{
    return EventList;
}

void EventScheduler::SetBPM(unsigned bpm)
{
    mBPM = bpm;
    mDuration = 1.0f / (float(mBPM) / 60.0f);
}

void EventScheduler::ScheduleOneShot()
{
}

void EventScheduler::StartMetronome(bool state)
{
    metronomeStarted = state;
    
    if(metronomeStarted == false)
    {
        start();
        timerStarted = true;   
    }
}

void EventScheduler::SetHostTime(int64_t hosttime)
{
    mHostTime = hosttime;
}