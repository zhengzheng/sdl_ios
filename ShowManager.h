//
//  ShowManager.h
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLManager.h"
#import "SDLImage.h"
#import "SDLShow.h"

@interface ShowManager : NSObject

+ (SDLShow *)showCommand_showText:(Boolean)showText showMediaTrack:(Boolean)showMediaTrack showSoftButtons:(Boolean)showSoftButtons showImage:(SDLImage *)showImage withManager:(SDLManager *)manager;
+ (void)showAll_mediaTemplate_withManager:(SDLManager *)manager image:(SDLImage *)image;
+ (void)updateShowAll_mediaTemplate_withManager:(SDLManager *)manager image:(SDLImage *)image;

@end
