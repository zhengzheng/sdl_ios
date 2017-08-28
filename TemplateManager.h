//
//  TemplateManager.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/25/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLAlert.h"
#import "SDLButtonPressMode.h"
#import "SDLDebugTool.h"
#import "SDLImage.h"
#import "SDLManager.h"
#import "SDLOnButtonEvent.h"
#import "SDLPredefinedLayout.h"
#import "SDLSetDisplayLayout.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSubscribeButton.h"

#import "SDLSetMediaClockTimer.h"
#import "SDLStartTime.h"
#import "SDLUpdateMode.h"
#import "SDLResult.h"
#import "SDLRPCResponse.h"
#import "SDLButtonEventMode.h"
#import "SDLOnButtonPress.h"

@interface TemplateManager : NSObject

+ (void)changeTemplateWithManager:(SDLManager *)manager forTemplate:(SDLPredefinedLayout *)template image:(SDLImage *)image;

@end
