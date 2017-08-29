//
//  MediaClockTimerManager.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLSetMediaClockTimer.h"
#import "SDLManager.h"

@interface MediaClockTimerManager : NSObject

+ (SDLSetMediaClockTimer *)addMediaClockTimerWithManager:(SDLManager *)manager;
+ (SDLSetMediaClockTimer *)removeMediaClockTimer;

@end
