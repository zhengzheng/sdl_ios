//
//  AddCommandManager.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLAddCommand.h"
#import "SDLDeleteCommand.h"
#import "SDLManager.h"

@interface AddCommandManager : NSObject

+ (SDLAddCommand *)addCommandWithManager:(SDLManager *)manager commandId:(int)commandId menuName:(NSString *)menuName handler:(void (^)(void))handler;
+ (SDLDeleteCommand *)deleteCommandWithId:(int)commandId;

@end
