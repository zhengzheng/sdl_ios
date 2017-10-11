//
//  AlertManager.m
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "AlertManager.h"
#import "SoftButtonManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AlertManager

+ (void)alertCommand_showText:(NSString *)text softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons duration:(int)duration withManager:(SDLManager *)manager {
    int durationInMilliseconds = duration * 1000;
    SDLAlert *alert = [[SDLAlert alloc] initWithAlertText1:text alertText2:nil alertText3:nil duration:durationInMilliseconds softButtons:softButtons];
    alert.ttsChunks = [SDLTTSChunk textChunksFromString:text];

    [manager sendRequest:alert withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error showing the alert (%@)", error);
        } else if (![response.resultCode isEqualToEnum:SDLResultSuccess]) {
            SDLLogE(@"The alert was not shown successfully (%@)", response.resultCode);
        } else {
            SDLLogD(@"Alert shown successfully");
        }
    }];
}

+ (void)defaultAlertWithManager:(SDLManager *)manager {
    SDLAlert* alert = [[SDLAlert alloc] init];
    alert.alertText1 = @"This is an alert";
    alert.alertText2 = @"alert text 2";
    alert.alertText3 = @"alert text 3";
    alert.ttsChunks = [SDLTTSChunk textChunksFromString:@"Alert example"];
    alert.duration = @(10000);
    alert.playTone = @(YES);
    alert.progressIndicator = @(YES);
    SDLSoftButton *cancelButton = [SoftButtonManager createSoftButtonWithText:@"Cancel" softButtonId:300 manager:manager handler:^{
        // Alert will be dismissed
    }];
    alert.softButtons = [@[cancelButton] mutableCopy];
    [manager sendRequest:alert];
}

@end

NS_ASSUME_NONNULL_END
