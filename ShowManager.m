//
//  ShowManager.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "ShowManager.h"
#import "SDLShow.h"
#import "SoftButtonManager.h"
#import "SDLButtonName.h"
#import "MediaClockTimerManager.h"
#import "SDLSubscribeButton.h"
#import "SubscribeButtonManager.h"

@implementation ShowManager

+ (SDLShow *)showCommand_showText:(Boolean)showText showMediaTrack:(Boolean)showMediaTrack showSoftButtons:(Boolean)showSoftButtons showImage:(SDLImage *)showImage withManager:(SDLManager *)manager {
    SDLShow *show = [[SDLShow alloc] init];

    if (showText) {
        show.mainField1 = @"Main field 1";
        show.mainField2 = @"Main field 2";
        show.mainField3 = @"Main field 3";
        show.mainField4 = @"Main field 4";
    }
    if (showMediaTrack) {
        show.mediaTrack = @"Media Track";
    }
    if (showSoftButtons) {
        show.softButtons = [SoftButtonManager softButtonsWithManager:manager];
    }
    if (showImage != nil) {
        show.graphic = showImage;
    }

    return show;
}

+ (void)showAll_mediaTemplate_withManager:(SDLManager *)manager image:(SDLImage *)image withSubscribeButtons:(Boolean)withSubscribeButtons withMediaTimer:(Boolean)withMediaTimer {
    // Text, soft buttons, image
    [self.class sdlex_showMediaWithManager:manager image:image];

    // Subscribe buttons
    if (withSubscribeButtons) {
        for(SDLSubscribeButton *subscribeButton in [SubscribeButtonManager mediaTemplateSubscribeButtonsWithManager:manager]) {
            [manager sendRequest:subscribeButton];
        }
    }

    // Progress bar
    if (withMediaTimer) {
        [manager sendRequest:[MediaClockTimerManager addMediaClockTimerWithManager:manager]];
    }
}

+ (void)showAll_mediaTemplate_withManager:(SDLManager *)manager image:(SDLImage *)image {
    [self.class showAll_mediaTemplate_withManager:manager image:image withSubscribeButtons:YES withMediaTimer:YES];
}

+ (void)updateShowAll_mediaTemplate_withManager:(SDLManager *)manager image:(SDLImage *)image {
    [self.class showAll_mediaTemplate_withManager:manager image:image withSubscribeButtons:NO withMediaTimer:NO];
}

+ (void)sdlex_showMediaWithManager:(SDLManager *)manager image:(SDLImage *)image {
    SDLShow *show = [self.class showCommand_showText:YES showMediaTrack:YES showSoftButtons:NO showImage:image withManager:manager];
    //    show.graphic = image; TODO: - create a blank image via code?
    show.softButtons = [SoftButtonManager mediaTemplate_SoftButtons_withManager:manager image:image];

    [manager sendRequest:show];
}


@end
