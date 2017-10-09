//
//  TemplateManager.m
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "TemplateManager.h"
#import "AddCommandManager.h"
#import "MediaClockTimerManager.h"
#import "ShowManager.h"
#import "SoftButtonManager.h"
#import "SubscribeButtonManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TemplateManager

+ (void)changeTemplateWithManager:(SDLManager *)manager toTemplate:(SDLPredefinedLayout)template image:(SDLImage *)image {
    void (^templateChangedHandler)(void);

    if ([template isEqualToEnum:SDLPredefinedLayoutMedia]) {
        templateChangedHandler = ^{
            [ShowManager showAll_mediaTemplate_withManager:manager image:image];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayoutNonMedia]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:YES showMediaTrack:NO showSoftButtons:YES showImage:image withManager:manager]];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayoutTextWithGraphic] || [template isEqualToEnum:SDLPredefinedLayoutGraphicWithText]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:YES showMediaTrack:NO showSoftButtons:NO showImage:image withManager:manager] withResponseHandler:nil];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayoutTilesOnly]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:YES showImage:nil withManager:manager] withResponseHandler:nil];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayoutTilesWithGraphic] || [template isEqualToEnum:SDLPredefinedLayoutGraphicWithTiles]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:YES showImage:image withManager:manager] withResponseHandler:nil];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayoutTextAndSoftButtonsWithGraphic] || [template isEqualToEnum:SDLPredefinedLayoutGraphicWithTextAndSoftButtons]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:YES showMediaTrack:NO showSoftButtons:YES showImage:image withManager:manager]];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayoutDoubleGraphicWithSoftButtons]) {
        templateChangedHandler = ^{
            SDLShow* show = [ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:YES showImage:image withManager:manager];
            show.secondaryGraphic = image;
            [manager sendRequest:show withResponseHandler:nil];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayoutTextButtonsWithGraphic] || [template isEqualToEnum:SDLPredefinedLayoutGraphicWithTextButtons]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:YES showImage:image withManager:manager]];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayoutTextButtonsOnly]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:YES showImage:nil withManager:manager]];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayoutLargeGraphicWithSoftButtons]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:YES showImage:image withManager:manager]];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayoutLargeGraphicOnly]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:NO showImage:image withManager:manager]];
        };
    } else {
        SDLAlert* alert = [[SDLAlert alloc] init];
        alert.alertText1 = [NSString stringWithFormat:@"No template for: %@", template];
        [manager sendRequest:alert];
        return;
    }

    [self.class sdlex_setTemplate:template manager:manager image:image handler:templateChangedHandler];
}

+ (void)sdlex_setTemplate:(SDLPredefinedLayout)template manager:(SDLManager *)manager image:(SDLImage *)image handler:(void (^)(void))handler {
    [manager sendRequest:[[SDLSetDisplayLayout alloc] initWithPredefinedLayout:template] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if([[response resultCode] isEqualToEnum:SDLResultSuccess]) {
            handler();
        } else {
            SDLLogE(@"The template was not changed successfully");
        }
    }];
}

@end

NS_ASSUME_NONNULL_END
