//
//  SubscribeButtonManager.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLSubscribeButton.h"
#import "SDLManager.h"
#import "SDLUnsubscribeButton.h"

@interface SubscribeButtonManager : NSObject

+ (SDLSubscribeButton *)createSubscribeButtonWithName:(SDLButtonName *)subscribeButtonName withManager:(SDLManager *)manager;
+ (SDLUnsubscribeButton *)removeSubscribeButtonWithName:(SDLButtonName *)subscribeButtonName ;

+ (NSArray<SDLSubscribeButton *> *)mediaTemplateSubscribeButtonsWithManager:(SDLManager *)manager;
+ (NSArray<SDLSubscribeButton *> *)anyTemplateSubscribeButtonsWithManager:(SDLManager *)manager;

@end
