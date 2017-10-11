//
//  ShowManager.m
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "ShowManager.h"
#import "HomeSoftButtonsToggleStateManager.h"
#import "ImageManager.h"
#import "MediaClockTimerManager.h"
#import "SoftButtonManager.h"
#import "SubscribeButtonManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation ShowManager

#pragma mark - Template default shows rpcs

+ (SDLShow *)showCommand_showText:(Boolean)showText showMediaTrack:(Boolean)showMediaTrack showSoftButtons:(Boolean)showSoftButtons showImage:(nullable SDLImage *)showImage withManager:(SDLManager *)manager {
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

+ (void)showAll_mediaTemplate_withManager:(SDLManager *)manager image:(nullable SDLImage *)image withSubscribeButtons:(Boolean)withSubscribeButtons withMediaTimer:(Boolean)withMediaTimer {
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

+ (void)sdlex_showMediaWithManager:(SDLManager *)manager image:(nullable SDLImage *)image {
    SDLShow *show = [self.class showCommand_showText:YES showMediaTrack:YES showSoftButtons:NO showImage:image withManager:manager];
    show.softButtons = [SoftButtonManager mediaTemplateSoftButtonsWithManager:manager image:image];
    [manager sendRequest:show];
}

+ (void)showAll_mediaTemplate_withManager:(SDLManager *)manager image:(nullable SDLImage *)image {
    [self.class showAll_mediaTemplate_withManager:manager image:image withSubscribeButtons:YES withMediaTimer:YES];
}

+ (void)updateShowAll_mediaTemplate_withManager:(SDLManager *)manager image:(nullable SDLImage *)image {
    [self.class showAll_mediaTemplate_withManager:manager image:image withSubscribeButtons:NO withMediaTimer:NO];
}

+ (void)showCommand_showPresets_withManager:(SDLManager *)manager image:(nullable SDLImage *)image {
    SDLShow *show = [self.class showCommand_showText:YES showMediaTrack:YES showSoftButtons:YES showImage:image withManager:manager];
    [manager sendRequest:show];

    // Preset subscribe buttons
    for(SDLSubscribeButton *subscribeButton in [SubscribeButtonManager presetSubscribeButtonsWithManager:manager]) {
        [manager sendRequest:subscribeButton];
    }
}

#pragma mark - Home show rpc

+ (void)showHomeTextWithManager:(SDLManager *)manager {
    [manager sendRequest:[self.class sdlex_showHomeText:HomeSoftButtonsToggleStateManager.sharedManager.isTextOn]];
}

+ (void)showHomeTextAndImagesWithManager:(SDLManager *)manager {
    SDLShow* show = [self.class sdlex_showHomeText:HomeSoftButtonsToggleStateManager.sharedManager.isTextOn];
    show.softButtons = [SoftButtonManager homeSoftButtonsWithManager:manager];
    show.graphic = HomeSoftButtonsToggleStateManager.sharedManager.areImagesVisible ? [ImageManager mainGraphicImage] : [ImageManager mainGraphicBlankImage];
    [manager sendRequest:show];
}

+ (SDLShow *)sdlex_showHomeText:(BOOL)isTextOn {
    NSString *mainField1Text = isTextOn ? @"Smart Device Link" : @"";
    NSString *mainField2Text = isTextOn ? @"Example App" : @"";
    NSString *mainField3Text = isTextOn ? @"Template: Media" : @"";
    NSString *mainField4Text = isTextOn ? @"App Type: Media" : @"";
    NSString *mediaTrackTextField = @"";
    SDLShow *show = [[SDLShow alloc] initWithMainField1:mainField1Text mainField2:mainField2Text mainField3:mainField3Text mainField4:mainField4Text alignment:SDLTextAlignmentLeft];
    show.mediaTrack = mediaTrackTextField;
    return show;
}

@end

NS_ASSUME_NONNULL_END
