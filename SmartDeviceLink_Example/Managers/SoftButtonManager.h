//
//  SoftButtonManager.h
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface SoftButtonManager : NSObject

#pragma mark - Soft button init

+ (SDLSoftButton *)createSoftButtonWithText:(NSString *)text softButtonId:(int)softButtonId manager:(nullable SDLManager *)manager handler:(nullable void (^)(void))handler;

+ (SDLSoftButton *)createSoftButtonWithImageName:(NSString *)imageName softButtonId:(int)softButtonId manager:(nullable SDLManager *)manager handler:(nullable void (^)(void))handler;

+ (SDLSoftButton *)createSoftButtonWithTextAndImage:(NSString *)text imageName:(NSString *)imageName softButtonId:(int)softButtonId manager:(nullable SDLManager *)manager handler:(nullable void (^)(void))handler;

#pragma mark - Soft button groups

+ (NSMutableArray<SDLSoftButton *> *)softButtonsWithManager:(SDLManager *)manager;
+ (NSMutableArray<SDLSoftButton *> *)mediaTemplateSoftButtonsWithManager:(SDLManager *)manager image:(SDLImage *)image;
+ (NSArray<SDLSoftButton *> *)alertButtons;
+ (NSArray<SDLSoftButton *> *)homeSoftButtonsWithManager:(SDLManager *)manager;

@end

NS_ASSUME_NONNULL_END
