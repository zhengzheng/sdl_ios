//
//  SubscribeButtonManager.m
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SubscribeButtonManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SubscribeButtonManager

#pragma mark - Individual subscribe buttons

+ (SDLSubscribeButton *)createSubscribeButtonWithName:(SDLButtonName)subscribeButtonName withManager:(SDLManager *)manager {
    return [[SDLSubscribeButton alloc] initWithButtonName:subscribeButtonName handler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {
        if (![buttonEvent.buttonEventMode isEqualToEnum:SDLButtonEventModeButtonDown]) { return; }
        SDLAlert* alert = [[SDLAlert alloc] init];
        alert.alertText1 = [NSString stringWithFormat:@"You tapped the subscribe button: %@", subscribeButtonName];
        [manager sendRequest:alert];
    }];
}

+ (SDLUnsubscribeButton *)removeSubscribeButtonWithName:(SDLButtonName)subscribeButtonName {
    return [[SDLUnsubscribeButton alloc] initWithButtonName:subscribeButtonName];
}

#pragma mark - Subscribe button arrays

// Tuneup and Tunedown are hard buttons only, the rest are both hard and soft buttons
+ (NSArray<SDLButtonName> *)sdlex_mediaTemplateSubscribeButtonNames {
    return [[NSArray alloc] initWithObjects:SDLButtonNameOk, SDLButtonNameSeekLeft, SDLButtonNameSeekRight, SDLButtonNameTuneUp, SDLButtonNameTuneDown, nil];
}

+ (NSArray<SDLSubscribeButton *> *)mediaTemplateSubscribeButtonsWithManager:(SDLManager *)manager {
    NSMutableArray *subscribeButtons = [NSMutableArray array];
    for(SDLButtonName buttonName in [self.class sdlex_mediaTemplateSubscribeButtonNames]) {
        [subscribeButtons addObject:[self.class createSubscribeButtonWithName:buttonName withManager:manager]];
    }
    return subscribeButtons;
}

+ (NSArray<SDLUnsubscribeButton *> *)mediaTemplateUnSubscribeButtons {
    NSMutableArray *unSubscribeButtons = [NSMutableArray array];
    for(SDLButtonName buttonName in [self.class sdlex_mediaTemplateSubscribeButtonNames]) {
        [unSubscribeButtons addObject:[self.class removeSubscribeButtonWithName:buttonName]];
    }
    return unSubscribeButtons;
}

+ (NSArray<SDLSubscribeButton *> *)presetSubscribeButtonsWithManager:(SDLManager *)manager {
    NSMutableArray *subscribeButtons = [NSMutableArray array];
    // Hard buttons only (i.e. no corresponding soft button will show up on the screen)
    NSArray<SDLButtonName> *allTemplateSubscribeButtons = [[NSArray alloc] initWithObjects:SDLButtonNameSearch, SDLButtonNameCustomButton, SDLButtonNamePreset0, SDLButtonNamePreset1, SDLButtonNamePreset2, SDLButtonNamePreset3, SDLButtonNamePreset4, SDLButtonNamePreset5, SDLButtonNamePreset6, SDLButtonNamePreset7, SDLButtonNamePreset8, SDLButtonNamePreset9, nil];
    for(SDLButtonName buttonName in allTemplateSubscribeButtons) {
        [subscribeButtons addObject:[self.class createSubscribeButtonWithName:buttonName withManager:manager]];
    }
    return subscribeButtons;
}

@end

NS_ASSUME_NONNULL_END
