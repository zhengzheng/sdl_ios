//
//  AddCommandManager.h
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddCommandManager : NSObject

+ (SDLAddCommand *)addCommandWithManager:(SDLManager *)manager commandId:(int)commandId menuName:(NSString *)menuName handler:(void (^)(void))handler;
+ (SDLDeleteCommand *)deleteCommandWithId:(int)commandId;
+ (SDLDeleteCommand *)deleteSubMenuCommandWithId:(int)commandId;

@end

NS_ASSUME_NONNULL_END
