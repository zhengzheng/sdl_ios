//
//  MediaClockTimerManager.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "MediaClockTimerManager.h"
#import "SDLStartTime.h"

@implementation MediaClockTimerManager

+ (SDLSetMediaClockTimer *)addMediaClockTimerWithManager:(SDLManager *)manager {
    SDLStartTime *startTime = [[SDLStartTime alloc] initWithHours:0 minutes:0 seconds:0];
    SDLStartTime *endTime = [[SDLStartTime alloc] initWithHours:0 minutes:1 seconds:45];
    SDLSetMediaClockTimer *timer = [[SDLSetMediaClockTimer alloc] init];
    timer.startTime = startTime;
    timer.endTime = endTime;
    timer.updateMode = SDLUpdateMode.COUNTUP;
    return timer;
}

+ (SDLSetMediaClockTimer *)removeMediaClockTimer {
    SDLSetMediaClockTimer *timer = [[SDLSetMediaClockTimer alloc] init];
    timer.updateMode = SDLUpdateMode.CLEAR;
    return timer;
}

@end
