//
//  TemplateManager.m
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "TemplateManager.h"
#import "AddCommandManager.h"
#import "AlertManager.h"
#import "MediaClockTimerManager.h"
#import "ShowManager.h"
#import "SoftButtonManager.h"
#import "SubscribeButtonManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TemplateManager

+ (void)changeTemplateWithManager:(SDLManager *)manager toTemplate:(SDLPredefinedLayout)template image:(SDLImage *)image {
    void (^templateChangedHandler)(void);
    if (![manager.registerResponse.displayCapabilities.templatesAvailable containsObject:template]) {

        // For SDLCore - only supports DEFAULT template
       [manager sendRequest:[[SDLSetDisplayLayout alloc] initWithPredefinedLayout:SDLPredefinedLayoutDefault]];

        [AlertManager
         alertCommand_showText:[NSString stringWithFormat:@"This template, %@, is not supported on this head unit (%@)", template, manager.registerResponse.displayCapabilities.displayType]
         softButtons:[SoftButtonManager alertButtons]
         duration:5
         withManager:manager];
        return;
    }

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
    } else if ([template isEqualToEnum:SDLPredefinedLayoutDefault]) {
        templateChangedHandler = ^{
            // TODO: not sure what default does...
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayoutOnscreenPresets]) {
        templateChangedHandler = ^{
            [ShowManager showCommand_showPresets_withManager:manager image:image];
        };
    } else if ([template isEqualToEnum:SDLPredefinedLayoutNavigationList] ||
               [template isEqualToEnum:SDLPredefinedLayoutNavigationKeyboard] ||
               [template isEqualToEnum:SDLPredefinedLayoutNavigationFullscreenMap]) {
        if (![manager.configuration.lifecycleConfig.appType isEqualToEnum:SDLAppHMITypeNavigation]) {
            SDLLogW(@"The template, %@, can only be shown when the app type is NAVIGATION. The app type is: %@", template, manager.configuration.lifecycleConfig.appType);
            // Navigation templates can only be used when the appType has been set to NAVIGATION
            [AlertManager alertCommand_showText:[NSString stringWithFormat:@"Navigation templates can only be used when the appType has been set to NAVIGATION. The appType has been set to %@ for this app", manager.configuration.lifecycleConfig.appType] softButtons:[SoftButtonManager alertButtons] duration:5 withManager:manager];
            return;
        } else {
            templateChangedHandler = ^{
                // TODO: show buttons/etc for navigation
            };
        }
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

