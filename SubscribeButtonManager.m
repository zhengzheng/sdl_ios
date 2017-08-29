//
//  SubscribeButtonManager.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SubscribeButtonManager.h"
#import "SDLAlert.h"
#import "SDLOnButtonEvent.h"
#import "SDLButtonEventMode.h"

@implementation SubscribeButtonManager

+ (SDLSubscribeButton *)createSubscribeButtonWithName:(SDLButtonName *)subscribeButtonName withManager:(SDLManager *)manager {
    return [[SDLSubscribeButton alloc] initWithButtonName:subscribeButtonName handler:^(__kindof SDLRPCNotification * _Nonnull notification) {
        if ([notification isKindOfClass:[SDLOnButtonEvent class]]) {
            if ([[(SDLOnButtonEvent *)notification buttonEventMode] isEqualToEnum:SDLButtonEventMode.BUTTONDOWN]) {
                SDLAlert* alert = [[SDLAlert alloc] init];
                alert.alertText1 = [NSString stringWithFormat:@"You tapped the subscribe button: %@", subscribeButtonName];
                [manager sendRequest:alert];
            }
        }
    }];
}

+ (SDLUnsubscribeButton *)removeSubscribeButtonWithName:(SDLButtonName *)subscribeButtonName {
    return [[SDLUnsubscribeButton alloc] initWithButtonName:subscribeButtonName];
}

+ (NSArray<SDLSubscribeButton *> *)mediaTemplateSubscribeButtonsWithManager:(SDLManager *)manager {
    NSMutableArray *subscribeButtons = [NSMutableArray array];
    // Tuneup and Tunedown are hard buttons only, the rest are both hard and soft buttons
    NSArray<SDLButtonName *> *mediaTemplateSubscribeButtons = [[NSArray alloc] initWithObjects:SDLButtonName.OK, SDLButtonName.SEEKLEFT, SDLButtonName.SEEKRIGHT, SDLButtonName.TUNEUP, SDLButtonName.TUNEDOWN, nil];
    for(SDLButtonName *buttonName in mediaTemplateSubscribeButtons) {
        [subscribeButtons addObject:[self.class createSubscribeButtonWithName:buttonName withManager:manager]];
    }
    return subscribeButtons;
}

+ (NSArray<SDLSubscribeButton *> *)anyTemplateSubscribeButtonsWithManager:(SDLManager *)manager {
    NSMutableArray *subscribeButtons = [NSMutableArray array];
    // Hard buttons only (i.e. no corresponding soft button will show up on the screen)
    NSArray<SDLButtonName *> *allTemplateSubscribeButtons = [[NSArray alloc] initWithObjects:SDLButtonName.SEARCH, SDLButtonName.CUSTOM_BUTTON, SDLButtonName.PRESET_0, SDLButtonName.PRESET_1, SDLButtonName.PRESET_2, SDLButtonName.PRESET_3, SDLButtonName.PRESET_4, SDLButtonName.PRESET_5, SDLButtonName.PRESET_6, SDLButtonName.PRESET_7, SDLButtonName.PRESET_8, SDLButtonName.PRESET_9, nil];
    for(SDLButtonName *buttonName in allTemplateSubscribeButtons) {
        [subscribeButtons addObject:[self.class createSubscribeButtonWithName:buttonName withManager:manager]];
    }
    return subscribeButtons;
}


@end
