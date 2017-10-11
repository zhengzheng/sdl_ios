//
//  SoftButtonManager.m
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SoftButtonManager.h"
#import "AddCommandManager.h"
#import "AlertManager.h"
#import "HomeSoftButtonsToggleStateManager.h"
#import "ImageManager.h"
#import "MediaClockTimerManager.h"
#import "ShowManager.h"
#import "SubscribeButtonManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SoftButtonManager

+ (SDLSoftButton *)createSoftButtonWithText:(NSString *)text softButtonId:(int)softButtonId manager:(nullable SDLManager *)manager handler:(nullable void (^)(void))handler {
    return [self sdlex_createSoftButton:text softButtonId:softButtonId imageName:nil buttonType:SDLSoftButtonTypeText manager:manager handler:handler];
}

+ (SDLSoftButton *)createSoftButtonWithImageName:(NSString *)imageName softButtonId:(int)softButtonId manager:(nullable SDLManager *)manager handler:(nullable void (^)(void))handler {
    return [self sdlex_createSoftButton:@"" softButtonId:softButtonId imageName:imageName buttonType:SDLSoftButtonTypeImage manager:manager handler:handler];
}

+ (SDLSoftButton *)createSoftButtonWithTextAndImage:(NSString *)text imageName:(NSString *)imageName softButtonId:(int)softButtonId manager:(nullable SDLManager *)manager handler:(nullable void (^)(void))handler {
    return [self sdlex_createSoftButton:text softButtonId:softButtonId imageName:imageName buttonType:SDLSoftButtonTypeBoth manager:manager handler:handler];
}

+ (SDLSoftButton *)sdlex_createSoftButton:(NSString *)text softButtonId:(int)softButtonId imageName:(nullable NSString *)imageName buttonType:(SDLSoftButtonType)buttonType manager:(SDLManager *)manager handler:(void (^)(void))handler {

    SDLSoftButton *softButton = [[SDLSoftButton alloc] initWithHandler:^(SDLOnButtonPress * _Nullable buttonPress, SDLOnButtonEvent * _Nullable buttonEvent) {

        if (![buttonEvent.buttonEventMode isEqualToEnum:SDLButtonEventModeButtonDown]) { return; }
        if (handler == nil) {
//            SDLAlert* alert = [[SDLAlert alloc] init];
//            alert.alertText1 = [NSString stringWithFormat:@"You tapped the soft button: %@", text];
//            [manager sendRequest:alert];
        } else {
            handler();
        }
    }];

    if (![text isEqualToString:@""]) {
        softButton.text = text;
    }

    softButton.softButtonID = @(softButtonId);
    softButton.type = buttonType;

    if ([buttonType isEqualToEnum:SDLSoftButtonTypeImage] || [buttonType isEqualToEnum:SDLSoftButtonTypeBoth]) {
        SDLImage* image = [[SDLImage alloc] init];
        image.imageType = SDLImageTypeDynamic;
        image.value = imageName;
        softButton.image = image;
    }

    return softButton;
}

+ (NSMutableArray<SDLSoftButton *> *)softButtonsWithManager:(SDLManager *)manager {
    NSMutableArray<SDLSoftButton *> *softButtons = [NSMutableArray array];
    void (^softButtonHandler)(void);
    for(int i = 1; i < 9; i += 1) {
        softButtonHandler = ^{
            [AlertManager
             alertCommand_showText:[NSString stringWithFormat:@"Button %d Pressed", i]
             softButtons:[SoftButtonManager alertButtons]
             duration:5
             withManager:manager];
        };
        [softButtons addObject:[self.class createSoftButtonWithText:[NSString stringWithFormat:@"Button%d", i] softButtonId:i manager:manager handler:softButtonHandler]];
    }
    return softButtons;
}

+ (void)sdlex_subscribeButtonStateWithManager:(SDLManager *)manager subscribeButtonName:(SDLButtonName)subscribeButtonName isSubscribed:(Boolean)isSubscribed image:(SDLImage *)image {
    if (isSubscribed) {
        [manager sendRequest:[SubscribeButtonManager removeSubscribeButtonWithName:subscribeButtonName] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (![response.resultCode isEqualToEnum:SDLResultSuccess]) { return; }
            [ShowManager updateShowAll_mediaTemplate_withManager:manager image:image];
        }];
    } else {
        [manager sendRequest:[SubscribeButtonManager createSubscribeButtonWithName:subscribeButtonName withManager:manager] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            if (![response.resultCode isEqualToEnum:SDLResultSuccess]) { return; }
            [ShowManager updateShowAll_mediaTemplate_withManager:manager image:image];
        }];
    }
}

+ (NSArray<SDLSoftButton *> *)alertButtons {
    return @[[self.class createSoftButtonWithText:@"Close Alert" softButtonId:200 manager:nil handler:nil]];
}

#pragma mark - Individual buttons

#pragma mark Default buttons

+ (NSMutableArray<SDLSoftButton *> *)mediaTemplateSoftButtonsWithManager:(SDLManager *)manager image:(SDLImage *)image {
    return [[NSMutableArray alloc] initWithObjects:
            [self.class seekLeft_SoftButton_withManager:manager image:image buttonId:1],
            [self.class play_SoftButton_withManager:manager image:image buttonId:2],
            [self.class seekRight_SoftButton_withManager:manager image:image buttonId:3],
            [self.class timer_SoftButton_withManager:manager image:image buttonId:4],
            [self.class subMenu_SoftButton_withManager:manager image:image buttonId:5],
            [self.class menu_SoftButton_withManager:manager image:image buttonId:6],
            nil];
}


static Boolean isSubscribedToSkipBackwardsButton = true;
+ (SDLSoftButton *)seekLeft_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isSubscribedToSkipBackwardsButton ? @"➖ <<" : @"➕ <<") softButtonId:buttonId manager:manager handler:^{
        [self.class sdlex_subscribeButtonStateWithManager:manager subscribeButtonName:SDLButtonNameSeekLeft isSubscribed:isSubscribedToSkipBackwardsButton image:image];
        isSubscribedToSkipBackwardsButton = !isSubscribedToSkipBackwardsButton;
    }];
}

static Boolean isSubscribedToSkipForwardButton = true;
+ (SDLSoftButton *)seekRight_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isSubscribedToSkipForwardButton ? @"➖ >>" : @"➕ >>") softButtonId:buttonId manager:manager handler:^{
        [self.class sdlex_subscribeButtonStateWithManager:manager subscribeButtonName:SDLButtonNameSeekRight isSubscribed:isSubscribedToSkipForwardButton image:image];
        isSubscribedToSkipForwardButton = !isSubscribedToSkipForwardButton;
    }];
}

static Boolean isSubscribedToPlayButton = true;
+ (SDLSoftButton *)play_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isSubscribedToPlayButton ? @"➖ Play" : @"➕ Play") softButtonId:buttonId manager:manager handler:^{
        [self sdlex_subscribeButtonStateWithManager:manager subscribeButtonName:SDLButtonNameOk
                                       isSubscribed:isSubscribedToPlayButton image:image];
        isSubscribedToPlayButton = !isSubscribedToPlayButton;
    }];
}

static Boolean isSubscribedToMediaTimer = true;
+ (SDLSoftButton *)timer_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isSubscribedToMediaTimer ? @"➖ Timer" : @"➕ Timer") softButtonId:buttonId manager:manager handler:^{
        if (isSubscribedToMediaTimer) {
            [manager sendRequest:[MediaClockTimerManager removeMediaClockTimer] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                [ShowManager updateShowAll_mediaTemplate_withManager:manager image:image];
            }];
        } else {
            [manager sendRequest:[MediaClockTimerManager addMediaClockTimerWithManager:manager] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                [ShowManager updateShowAll_mediaTemplate_withManager:manager image:image];
            }];
        }

        isSubscribedToMediaTimer = !isSubscribedToMediaTimer;;
    }];
}

static Boolean isTextVisible = false;
+ (SDLSoftButton *)text_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isTextVisible ? @"➖ Text" : @"➕ Text") softButtonId:buttonId manager:manager handler:^{
        isTextVisible = !isTextVisible;
        [ShowManager updateShowAll_mediaTemplate_withManager:manager image:image];
    }];
}

static Boolean isSubmenuVisible = false;
+ (SDLSoftButton *)subMenu_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isSubmenuVisible ? @"➖ Submenu" : @"➕ Submenu") softButtonId:buttonId manager:manager handler:^{
        int commandId = 200;
        NSString *menuName = @"Submenu Example: Use sofbutton to add/delete";
        if (isSubmenuVisible) {
            [manager sendRequest:[[SDLDeleteSubMenu alloc] initWithId:commandId] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                [ShowManager updateShowAll_mediaTemplate_withManager:manager image:image];
            }];
        } else {
            [manager sendRequest:[[SDLAddSubMenu alloc] initWithId:commandId menuName:menuName] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                [ShowManager updateShowAll_mediaTemplate_withManager:manager image:image];
            }];
        }
        isSubmenuVisible = !isSubmenuVisible;
    }];
}

static Boolean isAddCommandVisible = false;
+ (SDLSoftButton *)menu_SoftButton_withManager:(SDLManager *)manager image:(SDLImage *)image buttonId:(int)buttonId {
    return [self.class createSoftButtonWithText:(isAddCommandVisible ? @"➖ Menu" : @"➕ Menu") softButtonId:buttonId manager:manager handler:^{
        int commandId = 201;
        NSString *menuName = @"Add Command Example: Use softbutton to add/delete";
        if (isAddCommandVisible) {
            [manager sendRequest:[AddCommandManager deleteCommandWithId:commandId] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                [ShowManager updateShowAll_mediaTemplate_withManager:manager image:image];
            }];
        } else {
            [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:commandId menuName:menuName handler:^{
                SDLAlert* alert = [[SDLAlert alloc] init];
                alert.alertText1 = [NSString stringWithFormat:@"You tapped the Add Command: %@", menuName];
                [manager sendRequest:alert];
            }] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                [ShowManager updateShowAll_mediaTemplate_withManager:manager image:image];
            }];
        }
        isAddCommandVisible = !isAddCommandVisible;
    }];
}

#pragma mark Home Soft Buttons

+ (NSArray<SDLSoftButton *> *)homeSoftButtonsWithManager:(SDLManager *)manager {
    return @[[self.class sdlex_softButton1WithManager:manager], [self.class sdlex_softButton2WithManager:manager], [self.class sdlex_softButton3WithManager:manager], [self.class sdlex_softButton4WithManager:manager]];
}

+ (SDLSoftButton *)sdlex_softButton1WithManager:(SDLManager *)manager {
    SDLSoftButton *softButton = nil;
    int softButtonId = 100;
    NSString *softButtonTitle = @"Tap";
    void (^softButtonHandler)(void) = ^{
        [AlertManager alertCommand_showText:@"You pushed the soft button!" softButtons:nil duration:3 withManager:manager];
    };

    if (HomeSoftButtonsToggleStateManager.sharedManager.areImagesVisible) {
        softButton = [self createSoftButtonWithTextAndImage:softButtonTitle imageName:[ImageManager starImageName] softButtonId:softButtonId manager:manager handler:softButtonHandler];
    } else {
        softButton = [self createSoftButtonWithText:softButtonTitle softButtonId:softButtonId manager:manager handler:softButtonHandler];
    }

    return softButton;
}

+ (SDLSoftButton *)sdlex_softButton2WithManager:(SDLManager *)manager {
    SDLSoftButton *softButton = nil;
    int softButtonId = 200;
    void (^softButtonHandler)(void) = ^{
        HomeSoftButtonsToggleStateManager.sharedManager.hexagonOn = !HomeSoftButtonsToggleStateManager.sharedManager.hexagonOn;
        [ShowManager showHomeTextAndImagesWithManager:manager];
    };

    if (HomeSoftButtonsToggleStateManager.sharedManager.areImagesVisible) {
        softButton = [self createSoftButtonWithImageName:HomeSoftButtonsToggleStateManager.sharedManager.isHexagonOn ? [ImageManager hexagonOnImageName] : [ImageManager hexagonOffImageName] softButtonId:softButtonId manager:manager handler:softButtonHandler];
    } else {
        softButton = [self createSoftButtonWithText:HomeSoftButtonsToggleStateManager.sharedManager.isHexagonOn ? @"➖Hex" : @"➕Hex" softButtonId:softButtonId manager:manager handler:softButtonHandler];
    }

    return softButton;
}

+ (SDLSoftButton *)sdlex_softButton3WithManager:(SDLManager *)manager {
    int softButtonId = 300;
    void (^softButtonHandler)(void) = ^{
        HomeSoftButtonsToggleStateManager.sharedManager.textOn = !HomeSoftButtonsToggleStateManager.sharedManager.textOn;
        [ShowManager showHomeTextAndImagesWithManager:manager];
    };

    SDLSoftButton *softButton = [self createSoftButtonWithText:HomeSoftButtonsToggleStateManager.sharedManager.isTextOn ? @"➖Text" : @"➕Text" softButtonId:softButtonId manager:manager handler:softButtonHandler];

    return softButton;
}

+ (SDLSoftButton *)sdlex_softButton4WithManager:(SDLManager *)manager {
    int softButtonId = 400;
    void (^softButtonHandler)(void) = ^{
        if (HomeSoftButtonsToggleStateManager.sharedManager.areImagesVisible) {
            [manager.fileManager deleteRemoteFilesWithNames:[ImageManager allImageNames] completionHandler:^(NSError * _Nullable error) {
                if (error == nil) {
                    SDLLogD(@"All images deleted successfully");
                    HomeSoftButtonsToggleStateManager.sharedManager.imagesVisible = !HomeSoftButtonsToggleStateManager.sharedManager.imagesVisible;
                    [ShowManager showHomeTextAndImagesWithManager:manager];
                } else {
                    SDLLogW(@"Some or all images were not deleted successfully (%@)", error);
                    [AlertManager alertCommand_showText:@"Error deleting some images" softButtons:nil duration:3 withManager:manager];
                }
            }];
        } else {
            [manager.fileManager uploadFiles:[ImageManager allImages] completionHandler:^(NSError * _Nullable error) {
                if (error == nil) {
                    SDLLogD(@"All images uploaded successfully");
                    HomeSoftButtonsToggleStateManager.sharedManager.imagesVisible = !HomeSoftButtonsToggleStateManager.sharedManager.imagesVisible;
                    [ShowManager showHomeTextAndImagesWithManager:manager];
                } else {
                    SDLLogW(@"Some or all images were not uploaded successfully (%@)", error);
                    [AlertManager alertCommand_showText:@"Error uploading some images" softButtons:nil duration:3 withManager:manager];
                }
            }];
        }
    };

    // FIXME: add "loading..." to main text field?
    SDLSoftButton *softButton = [self createSoftButtonWithText:HomeSoftButtonsToggleStateManager.sharedManager.areImagesVisible ? @"➖Icons" : @"➕Icons" softButtonId:softButtonId manager:manager handler:softButtonHandler];

    return softButton;
}

@end

NS_ASSUME_NONNULL_END

