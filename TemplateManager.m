//
//  TemplateManager.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/25/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "TemplateManager.h"
#import "SoftButtonManager.h"
#import "SubscribeButtonManager.h"
#import "MediaClockTimerManager.h"
#import "AddCommandManager.h"
#import "ShowManager.h"
#import "SDLAlert.h"
#import "SDLSetDisplayLayout.h"
#import "SDLDebugTool.h"
#import "SDLResult.h"
#import "SDLRPCResponse.h"

@implementation TemplateManager

+ (void)changeTemplateWithManager:(SDLManager *)manager toTemplate:(SDLPredefinedLayout *)template image:(SDLImage *)image {
    void (^templateChangedHandler)(void);

    if ([template isEqualToEnum:SDLPredefinedLayout.MEDIA]) {
        templateChangedHandler = ^{
            [ShowManager showAll_mediaTemplate_withManager:manager image:image];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayout.NON_MEDIA]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:YES showMediaTrack:NO showSoftButtons:YES showImage:image withManager:manager]];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayout.TEXT_WITH_GRAPHIC] || [template isEqualToEnum:SDLPredefinedLayout.GRAPHIC_WITH_TEXT]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:YES showMediaTrack:NO showSoftButtons:NO showImage:image withManager:manager] withResponseHandler:nil];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayout.TILES_ONLY]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:YES showImage:nil withManager:manager] withResponseHandler:nil];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayout.TILES_WITH_GRAPHIC] || [template isEqualToEnum:SDLPredefinedLayout.GRAPHIC_WITH_TILES]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:YES showImage:image withManager:manager] withResponseHandler:nil];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayout.TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC] || [template isEqualToEnum:SDLPredefinedLayout.GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:YES showMediaTrack:NO showSoftButtons:YES showImage:image withManager:manager]];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayout.DOUBLE_GRAPHIC_WITH_SOFTBUTTONS]) {
        templateChangedHandler = ^{
            SDLShow* show = [ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:YES showImage:image withManager:manager];
            show.secondaryGraphic = image;
            [manager sendRequest:show withResponseHandler:nil];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayout.TEXTBUTTONS_WITH_GRAPHIC] || [template isEqualToEnum:SDLPredefinedLayout.GRAPHIC_WITH_TEXTBUTTONS]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:YES showImage:image withManager:manager]];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayout.TEXTBUTTONS_ONLY]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:YES showImage:nil withManager:manager]];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayout.LARGE_GRAPHIC_WITH_SOFTBUTTONS]) {
        templateChangedHandler = ^{
            [manager sendRequest:[ShowManager showCommand_showText:NO showMediaTrack:NO showSoftButtons:YES showImage:image withManager:manager]];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayout.LARGE_GRAPHIC_ONLY]) {
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

+ (void)sdlex_setTemplate:(SDLPredefinedLayout *)template manager:(SDLManager *)manager image:(SDLImage *)image handler:(void (^)(void))handler {
    [manager sendRequest:[[SDLSetDisplayLayout alloc] initWithPredefinedLayout:template] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if([[response resultCode] isEqualToEnum:SDLResult.SUCCESS]) {
            handler();
        } else {
            [SDLDebugTool logInfo:@"The template was not changed successfully"];
        }
    }];
}

@end
