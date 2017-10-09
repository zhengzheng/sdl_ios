//
//  TemplateManager.h
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface TemplateManager : NSObject

+ (void)changeTemplateWithManager:(SDLManager *)manager toTemplate:(SDLPredefinedLayout)template image:(SDLImage *)image;

@end

NS_ASSUME_NONNULL_END
