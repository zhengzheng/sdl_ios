//
//  SoftButtonManager.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLManager.h"
#import "SDLSoftButton.h"

@interface SoftButtonManager : NSObject

+ (SDLSoftButton *)createSoftButtonWithText:(NSString *)text softButtonId:(int)softButtonId manager:(SDLManager *)manager handler:(void (^)(void))handler;

+ (SDLSoftButton *)createSoftButtonWithImage:(NSString *)text imageName:(NSString *)imageName softButtonId:(int)softButtonId manager:(SDLManager *)manager handler:(void (^)(void))handler;

+ (SDLSoftButton *)createSoftButtonWithTextAndImage:(NSString *)text imageName:(NSString *)imageName softButtonId:(int)softButtonId manager:(SDLManager *)manager handler:(void (^)(void))handler;

+ (NSMutableArray<SDLSoftButton *> *)softButtonsWithManager:(SDLManager *)manager;
+ (NSMutableArray<SDLSoftButton *> *)mediaTemplate_SoftButtons_withManager:(SDLManager *)manager image:(SDLImage *)image;

@end
