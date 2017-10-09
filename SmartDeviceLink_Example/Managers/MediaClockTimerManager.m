//
//  MediaClockTimerManager.m
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "MediaClockTimerManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation MediaClockTimerManager

+ (SDLSetMediaClockTimer *)addMediaClockTimerWithManager:(SDLManager *)manager {
    SDLStartTime *startTime = [[SDLStartTime alloc] initWithHours:0 minutes:0 seconds:0];
    SDLStartTime *endTime = [[SDLStartTime alloc] initWithHours:0 minutes:1 seconds:45];
    SDLSetMediaClockTimer *timer = [[SDLSetMediaClockTimer alloc] init];
    timer.startTime = startTime;
    timer.endTime = endTime;
    timer.updateMode = SDLUpdateModeCountUp;
    return timer;
}

+ (SDLSetMediaClockTimer *)removeMediaClockTimer {
    SDLSetMediaClockTimer *timer = [[SDLSetMediaClockTimer alloc] init];
    timer.updateMode = SDLUpdateModeClear;
    return timer;
}

@end

NS_ASSUME_NONNULL_END
