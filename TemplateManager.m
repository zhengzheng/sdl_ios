//
//  TemplateManager.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/25/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "TemplateManager.h"

@implementation TemplateManager

+ (void)changeTemplateWithManager:(SDLManager *)manager forTemplate:(SDLPredefinedLayout *)template image:(SDLImage *)image {
    if ([template isEqualToEnum:SDLPredefinedLayout.MEDIA]) {
        [self.class sdlex_setTemplate_mediaWithProgressBar:manager image:image];
    } else if ([template isEqualToEnum:SDLPredefinedLayout.LARGE_GRAPHIC_ONLY]) {
        [self.class sdlex_setTemplate_largeGraphicOnly:manager image:image];
    } else {
        [SDLDebugTool logInfo:[NSString stringWithFormat:@"Template: %@", template]];
    }
}

+ (void)sdlex_setTemplate_largeGraphicOnly:(SDLManager *)manager image:(SDLImage *)image {
    [manager sendRequest:[[SDLSetDisplayLayout alloc] initWithPredefinedLayout:SDLPredefinedLayout.LARGE_GRAPHIC_ONLY] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLShow* show = [[SDLShow alloc] init];
        show.graphic = image;
        [manager sendRequest:show withResponseHandler:nil];
    }];
}

+ (void)sdlex_setTemplate_media:(SDLManager *)manager image:(SDLImage *)image {
    [self.class sdlex_sendTemplate_mediaWithManager:manager image:image progressBar:false];
}

+ (void)sdlex_setTemplate_mediaWithProgressBar:(SDLManager *)manager image:(SDLImage *)image {
    [self.class sdlex_sendTemplate_mediaWithManager:manager image:image progressBar:true];
}

// Private
+ (void)sdlex_sendTemplate_mediaWithManager:(SDLManager *)manager image:(SDLImage *)image progressBar:(Boolean)progressBar {
    [manager sendRequest:[[SDLSetDisplayLayout alloc] initWithPredefinedLayout:SDLPredefinedLayout.MEDIA] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (response.resultCode == SDLResult.SUCCESS) {
            // Text, image, and soft buttons
            [manager sendRequest:[self.class sdlex_showWithManager:manager image:image]];

            // Subscribe buttons
            for(SDLSubscribeButton *subscribeButton in [self.class sdlex_mediaTemplateSubscribeButtonsWithManager:manager]) {
                [manager sendRequest:subscribeButton];
            }

            // Progress bar
            if (progressBar) {
                [manager sendRequest:[self.class sdlex_mediaClockTimerWithManager:manager]];
            }
        } else {
            [SDLDebugTool logFormat:@"Media template was not set"];
        }
    }];
}

+ (SDLShow *)sdlex_showWithManager:(SDLManager *)manager image:(SDLImage *)image {
    SDLShow *show = [[SDLShow alloc] init];
    show.mainField1 = @"Main field 1";
    show.mainField2 = @"Main field 2";
    show.mainField3 = @"Main field 3";
    show.mainField4 = @"Main field 4";
    show.mediaTrack = @"Media Track";
    show.graphic = image;
    show.softButtons = [self.class sdlex_softButtonsWithManager:manager];
    return show;
}

+ (NSMutableArray<SDLSoftButton *> *)sdlex_softButtonsWithManager:(SDLManager *)manager {
    NSMutableArray<SDLSoftButton *> *softButtons = [NSMutableArray array];
    for(int i = 0; i < 5; i += 1) {
        [softButtons addObject:[self.class sdlex_createSoftButtonWithText:[NSString stringWithFormat:@"Button%d", i] softButtonId:i manager:manager]];
    }
    return softButtons;
}

+ (NSArray<SDLSubscribeButton *> *)sdlex_mediaTemplateSubscribeButtonsWithManager:(SDLManager *)manager {
    NSMutableArray *subscribeButtons = [NSMutableArray array];
    // Tuneup and Tunedown are hard buttons only, the rest are both hard and soft buttons
    NSArray<SDLButtonName *> *mediaTemplateSubscribeButtons = [[NSArray alloc] initWithObjects:SDLButtonName.OK, SDLButtonName.SEEKLEFT, SDLButtonName.SEEKRIGHT, SDLButtonName.TUNEUP, SDLButtonName.TUNEDOWN, nil];
    for(SDLButtonName *buttonName in mediaTemplateSubscribeButtons) {
        [subscribeButtons addObject:[self.class sdlex_createSubscribeButtonWithName:buttonName withManager:manager]];
    }
    return subscribeButtons;
}

+ (NSArray<SDLSubscribeButton *> *)sdlex_anyTemplateSubscribeButtonsWithManager:(SDLManager *)manager {
    NSMutableArray *subscribeButtons = [NSMutableArray array];
    // Hard buttons only (i.e. no corresponding soft button will show up on the screen)
    NSArray<SDLButtonName *> *allTemplateSubscribeButtons = [[NSArray alloc] initWithObjects:SDLButtonName.SEARCH, SDLButtonName.CUSTOM_BUTTON, SDLButtonName.PRESET_0, SDLButtonName.PRESET_1, SDLButtonName.PRESET_2, SDLButtonName.PRESET_3, SDLButtonName.PRESET_4, SDLButtonName.PRESET_5, SDLButtonName.PRESET_6, SDLButtonName.PRESET_7, SDLButtonName.PRESET_8, SDLButtonName.PRESET_9, nil];
    for(SDLButtonName *buttonName in allTemplateSubscribeButtons) {
        [subscribeButtons addObject:[self.class sdlex_createSubscribeButtonWithName:buttonName withManager:manager]];
    }
    return subscribeButtons;
}

+ (SDLSoftButton *)sdlex_createSoftButtonWithText:(NSString *)text softButtonId:(int)softButtonId manager:(SDLManager *)manager {
    SDLSoftButton* softButton = [[SDLSoftButton alloc] initWithHandler:^(__kindof SDLRPCNotification *notification) {
//        if ([notification isKindOfClass:[SDLOnButtonPress class]]) {
//            SDLAlert* alert = [[SDLAlert alloc] init];
//            alert.alertText1 = [NSString stringWithFormat:@"You pushed the button for %@", text];
//            [manager sendRequest:alert];
//        }
    }];

    softButton.text = text;
    softButton.softButtonID = @(softButtonId);
    softButton.type = SDLSoftButtonType.TEXT;
    return softButton;
}

/*
 
 2017-08-25 17:43:15.800 SDL Example[8498:3041862] [4] OnButtonEvent (notification)
 {
 buttonEventMode = BUTTONUP;
 buttonName = OK;
 }
 2017-08-25 17:43:17.463 SDL Example[8498:3041862] [4] OnButtonPress (notification)
 {
 buttonName = OK;
 buttonPressMode = SHORT;
 }
 2017-08-25 17:43:18.249 SDL Example[8498:3039492] -[SDLOnButtonPress buttonEventMode]: unrecognized selector sent to instance 0x608000246f90
 2017-08-25 17:43:18.253 SDL Example[8498:3039492] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[SDLOnButtonPress buttonEventMode]: unrecognized selector sent to instance 0x608000246f90'
 
 */
+ (SDLSubscribeButton *)sdlex_createSubscribeButtonWithName:(SDLButtonName *)subscribeButtonName withManager:(SDLManager *)manager {
    return [[SDLSubscribeButton alloc] initWithButtonName:subscribeButtonName handler:^(__kindof SDLRPCNotification * _Nonnull notification) {
        SDLOnButtonEvent *buttonPress = (SDLOnButtonEvent *)notification;
        if (buttonPress != nil) {
            SDLButtonEventMode *buttonMode = [buttonPress buttonEventMode];
            if (buttonMode != nil) {
                if ([buttonMode isEqualToEnum:SDLButtonEventMode.BUTTONDOWN]) {
                    SDLAlert* alert = [[SDLAlert alloc] init];
                    alert.alertText1 = [NSString stringWithFormat:@"You tapped the subscribe button for %@", subscribeButtonName];
                    [manager sendRequest:alert];
                }
            }
        }
    }];
}

+ (SDLSetMediaClockTimer *)sdlex_mediaClockTimerWithManager:(SDLManager *)manager {
    SDLStartTime *startTime = [[SDLStartTime alloc] initWithHours:0 minutes:0 seconds:0];
    SDLStartTime *endTime = [[SDLStartTime alloc] initWithHours:0 minutes:1 seconds:45];
    SDLSetMediaClockTimer *timer = [[SDLSetMediaClockTimer alloc] init];
    timer.startTime = startTime;
    timer.endTime = endTime;
    timer.updateMode = SDLUpdateMode.COUNTUP;
    return timer;
}

@end
