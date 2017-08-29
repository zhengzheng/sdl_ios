//
//  TemplateManager.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/25/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLManager.h"
#import "SDLPredefinedLayout.h"
#import "SDLImage.h"

@interface TemplateManager : NSObject

+ (void)changeTemplateWithManager:(SDLManager *)manager toTemplate:(SDLPredefinedLayout *)template image:(SDLImage *)image;

@end
