//
//  SoftButtonManager.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SoftButtonManager.h"
#import "SDLOnButtonEvent.h"
#import "SDLButtonEventMode.h"
#import "SDLAlert.h"
#import "SubscribeButtonManager.h"
#import "ShowManager.h"
#import "SDLResult.h"
#import "SDLRPCResponse.h"
#import "MediaClockTimerManager.h"
#import "SDLDeleteSubMenu.h"
#import "SDLAddSubMenu.h"
#import "AddCommandManager.h"
#import "SDLSoftButtonType.h"

@implementation SoftButtonManager

+ (SDLSoftButton *)createSoftButtonWithText:(NSString *)text softButtonId:(int)softButtonId manager:(SDLManager *)manager handler:(void (^)(void))handler {
    return [self sdlex_createSoftButton:text softButtonId:softButtonId imageName:nil buttonType:SDLSoftButtonType.TEXT manager:manager handler:handler];
}

+ (SDLSoftButton *)createSoftButtonWithImage:(NSString *)text imageName:(NSString *)imageName softButtonId:(int)softButtonId manager:(SDLManager *)manager handler:(void (^)(void))handler {
    return [self sdlex_createSoftButton:text softButtonId:softButtonId imageName:imageName buttonType:SDLSoftButtonType.IMAGE manager:manager handler:handler];
}

+ (SDLSoftButton *)createSoftButtonWithTextAndImage:(NSString *)text imageName:(NSString *)imageName softButtonId:(int)softButtonId manager:(SDLManager *)manager handler:(void (^)(void))handler {
    return [self sdlex_createSoftButton:text softButtonId:softButtonId imageName:imageName buttonType:SDLSoftButtonType.BOTH manager:manager handler:handler];
}

+ (SDLSoftButton *)sdlex_createSoftButton:(NSString *)text softButtonId:(int)softButtonId imageName:(NSString *)imageName buttonType:(SDLSoftButtonType *)buttonType manager:(SDLManager *)manager handler:(void (^)(void))handler {
    SDLSoftButton* softButton = [[SDLSoftButton alloc] initWithHandler:^(__kindof SDLRPCNotification *notification) {
        if ([notification isKindOfClass:[SDLOnButtonEvent class]]) {
            if ([[(SDLOnButtonEvent *)notification buttonEventMode] isEqualToEnum:SDLButtonEventMode.BUTTONDOWN]) {
                if (handler == nil) {
                    SDLAlert* alert = [[SDLAlert alloc] init];
                    alert.alertText1 = [NSString stringWithFormat:@"You tapped the soft button: %@", text];
                    [manager sendRequest:alert];
                    return;
                } else {
                    handler();
                }
            }
        }
    }];

    softButton.text = text;
    softButton.softButtonID = @(softButtonId);
    softButton.type = buttonType;

    if ([buttonType isEqualToEnum:SDLSoftButtonType.IMAGE] || [buttonType isEqualToEnum:SDLSoftButtonType.BOTH]) {
        SDLImage* image = [[SDLImage alloc] init];
        image.imageType = SDLImageType.DYNAMIC;
        image.value = imageName;
        softButton.image = image;
    }

    return softButton;
}

+ (NSMutableArray<SDLSoftButton *> *)softButtonsWithManager:(SDLManager *)manager {
    NSMutableArray<SDLSoftButton *> *softButtons = [NSMutableArray array];
    for(int i = 1; i < 9; i += 1) {
        [softButtons addObject:[self.class createSoftButtonWithText:[NSString stringWithFormat:@"Button%d", i] softButtonId:i manager:manager handler:nil]];
    }
    return softButtons;
}

+ (void)sdlex_subscribeButtonStateWithManager:(SDLManager *)manager subscribeButtonName:(SDLButtonName *)subscribeButtonName isSubscribed:(Boolean)isSubscribed image:(SDLImage *)image {
    if (isSubscribed) {
        [manager sendRequest:[self.class removeSubscribeButtonWithName:subscribeButtonName] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if ([response.resultCode isEqualToEnum:SDLResult.SUCCESS]) {
                [ShowManager showAll_mediaTemplate_withManager:manager image:image];
            }
        }];
    } else {
        [manager sendRequest:[SubscribeButtonManager createSubscribeButtonWithName:subscribeButtonName withManager:manager] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if ([response.resultCode isEqualToEnum:SDLResult.SUCCESS]) {
                [ShowManager showAll_mediaTemplate_withManager:manager image:image];
            }
        }];
    }
}

#pragma mark - Individual buttons

+ (NSMutableArray<SDLSoftButton *> *)mediaTemplate_SoftButtons_withManager:(SDLManager *)manager image:(SDLImage *)image {
    int buttonId = 1;
    return [[NSMutableArray alloc] initWithObjects:
    [self.class seekLeft_SoftButton_withManager:manager image:image buttonId:(buttonId += 1)],
    [self.class play_SoftButton_withManager:manager image:image buttonId:(buttonId += 1)],
    [self.class seekRight_SoftButton_withManager:manager image:image buttonId:(buttonId += 1)],
    [self.class timer_SoftButton_withManager:manager image:image buttonId:(buttonId += 1)],
    [self.class subMenu_SoftButton_withManager:manager image:image buttonId:(buttonId += 1)],
    [self.class menu_SoftButton_withManager:manager image:image buttonId:(buttonId += 1)],
    nil];
}


static Boolean isSubscribedToSkipBackwardsButton = true;
+ (SDLSoftButton *)seekLeft_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isSubscribedToSkipBackwardsButton ? @"- <<" : @"+ <<") softButtonId:buttonId manager:manager handler:^{
        [self.class sdlex_subscribeButtonStateWithManager:manager subscribeButtonName:SDLButtonName.SEEKLEFT isSubscribed:isSubscribedToSkipBackwardsButton image:image];
        isSubscribedToSkipBackwardsButton = !isSubscribedToSkipBackwardsButton;
    }];
}

static Boolean isSubscribedToSkipForwardButton = true;
+ (SDLSoftButton *)seekRight_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isSubscribedToSkipForwardButton ? @"- >>" : @"+ >>") softButtonId:buttonId manager:manager handler:^{
        [self.class sdlex_subscribeButtonStateWithManager:manager subscribeButtonName:SDLButtonName.SEEKRIGHT isSubscribed:isSubscribedToSkipForwardButton image:image];
        isSubscribedToSkipForwardButton = !isSubscribedToSkipForwardButton;
    }];
}

static Boolean isSubscribedToPlayButton = true;
+ (SDLSoftButton *)play_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isSubscribedToPlayButton ? @"- Play" : @"+ Play") softButtonId:buttonId manager:manager handler:^{
        [self sdlex_subscribeButtonStateWithManager:manager subscribeButtonName:SDLButtonName.OK isSubscribed:isSubscribedToPlayButton image:image];
        isSubscribedToPlayButton = !isSubscribedToPlayButton;
    }];
}

static Boolean isSubscribedToMediaTimer = true;
+ (SDLSoftButton *)timer_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isSubscribedToMediaTimer ? @"- Timer" : @"+ Timer") softButtonId:4 manager:manager handler:^{
        if (isSubscribedToMediaTimer) {
            [manager sendRequest:[MediaClockTimerManager removeMediaClockTimer] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                [ShowManager showAll_mediaTemplate_withManager:manager image:image];
            }];
        } else {
            [manager sendRequest:[MediaClockTimerManager addMediaClockTimerWithManager:manager] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                [ShowManager showAll_mediaTemplate_withManager:manager image:image];
            }];
        }

        isSubscribedToMediaTimer = !isSubscribedToMediaTimer;;
    }];
}

static Boolean isTextVisible = false;
+ (SDLSoftButton *)text_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isTextVisible ? @"- Text" : @"+ Text") softButtonId:5 manager:manager handler:^{
        isTextVisible = !isTextVisible;
        [ShowManager showAll_mediaTemplate_withManager:manager image:image];
    }];
}

static Boolean isSubmenuVisible = false;
+ (SDLSoftButton *)subMenu_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isSubmenuVisible ? @"- Submenu" : @"+ Submenu") softButtonId:6 manager:manager handler:^{
        int commandId = 200;
        NSString *menuName = @"Submenu Example: Use sofbutton to add/delete";
        if (isSubmenuVisible) {
            [manager sendRequest:[[SDLDeleteSubMenu alloc] initWithId:commandId] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                [ShowManager showAll_mediaTemplate_withManager:manager image:image];
            }];
        } else {
            [manager sendRequest:[[SDLAddSubMenu alloc] initWithId:commandId menuName:menuName] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                [ShowManager showAll_mediaTemplate_withManager:manager image:image];
            }];
        }
        isSubmenuVisible = !isSubmenuVisible;
    }];
}

static Boolean isAddCommandVisible = false;
+ (SDLSoftButton *)menu_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isAddCommandVisible ? @"- Menu" : @"+ Menu") softButtonId:7 manager:manager handler:^{
        int commandId = 201;
        NSString *menuName = @"Add Command Example: Use softbutton to add/delete";
        if (isAddCommandVisible) {
            [manager sendRequest:[AddCommandManager deleteCommandWithId:commandId] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                [ShowManager showAll_mediaTemplate_withManager:manager image:image];
            }];
        } else {
            [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:commandId menuName:menuName handler:^{
                SDLAlert* alert = [[SDLAlert alloc] init];
                alert.alertText1 = [NSString stringWithFormat:@"You tapped the Add Command: %@", menuName];
                [manager sendRequest:alert];
            }] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                [ShowManager showAll_mediaTemplate_withManager:manager image:image];
            }];
        }
        isAddCommandVisible = !isAddCommandVisible;
    }];
}

@end
