//
//  AlertManager.h
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"
#import "SDLManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlertManager : NSObject

+ (void)alertCommand_showText:(NSString *)text softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons duration:(int)duration withManager:(SDLManager *)manager;
+ (void)alertCommand_showText:(NSString *)text1 text2:(NSString *)text2 softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons duration:(int)duration withManager:(SDLManager *)manager;

+ (void)defaultAlertWithManager:(SDLManager *)manager;

@end

NS_ASSUME_NONNULL_END
