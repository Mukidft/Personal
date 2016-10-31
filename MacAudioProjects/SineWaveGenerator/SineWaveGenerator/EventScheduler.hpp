//
//  EventScheduler.hpp
//  EventScheduler
//
//  Created by Lipstick on 9/19/16.
//  Copyright © 2016 Lipstick. All rights reserved.
//

#ifndef EventScheduler_hpp
#define EventScheduler_hpp

#include <stdio.h>
#include <queue>
#include <chrono>

using namespace std;

class EventScheduler
{
public:    
    
    enum EventType
    {
        SingleShot = 1,
        None = 0
    };
    
    EventScheduler();
    ~EventScheduler();
    
    void ScheduleEvents();
    void SetBPM(unsigned bpm);
    void ScheduleOneShot();
    void StartMetronome(bool state);
    void SetHostTime(int64_t hosttime);
    queue<int64_t> GetEventList();
    
private:
    
    unsigned mSampleRate;
    unsigned mBPM;
    unsigned mSeconds;
    float mFrequency;
    float mDuration;
   
    bool metronomeStarted;
    
    bool timerStarted;    
    void start(void);
    template <typename duration_type>
    const duration_type time_elapsed(void);
    chrono::high_resolution_clock::time_point epoch;
    int64_t mHostTime;
    
    queue<int64_t> EventList;
    
};

#endif /* EventScheduler_hpp */
