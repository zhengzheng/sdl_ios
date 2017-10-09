//
//  MediaClockTimerManager.h
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface MediaClockTimerManager : NSObject

+ (SDLSetMediaClockTimer *)addMediaClockTimerWithManager:(SDLManager *)manager;
+ (SDLSetMediaClockTimer *)removeMediaClockTimer;

@end

NS_ASSUME_NONNULL_END
