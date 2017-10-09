//
//  ShowManager.h
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowManager : NSObject

+ (SDLShow *)showCommand_showText:(Boolean)showText showMediaTrack:(Boolean)showMediaTrack showSoftButtons:(Boolean)showSoftButtons showImage:(nullable SDLImage *)showImage withManager:(SDLManager *)manager;
+ (void)showAll_mediaTemplate_withManager:(SDLManager *)manager image:(nullable SDLImage *)image;
+ (void)updateShowAll_mediaTemplate_withManager:(SDLManager *)manager image:(nullable SDLImage *)image;

@end

NS_ASSUME_NONNULL_END
