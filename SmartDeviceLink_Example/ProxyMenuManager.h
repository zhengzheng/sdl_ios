//
//  ProxyMenuManager.h
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLManager.h"
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProxyMenuManager : NSObject

+ (void)sendMenuItemsWithManager:(SDLManager *)manager;
+ (void)sendChoiceSetWithManager:(SDLManager *)manager;

@end

NS_ASSUME_NONNULL_END
