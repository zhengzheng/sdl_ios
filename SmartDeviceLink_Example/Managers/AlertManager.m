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

+ (SDLAlert *)sdlex_defaultAlert:(NSString *)text1 text2:(nullable NSString *)text2 softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons duration:(int)duration {
    int durationInMilliseconds = duration * 1000;
    SDLAlert *alert = [[SDLAlert alloc] initWithAlertText1:text1 alertText2:text2 alertText3:nil duration:durationInMilliseconds softButtons:softButtons];
    alert.ttsChunks = [SDLTTSChunk textChunksFromString:text1];
    return alert;
}

+ (void)sdlex_alertResponse:(nullable SDLRPCResponse *)response error:(nullable NSError *)error {
    if (error != nil) {
        SDLLogE(@"Error showing the alert (%@)", error);
    } else if (![response.resultCode isEqualToEnum:SDLResultSuccess]) {
        SDLLogE(@"The alert was not shown successfully (%@)", response.resultCode);
    } else {
        SDLLogV(@"Alert shown successfully");
    }
}

+ (void)alertCommand_showText:(NSString *)text softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons duration:(int)duration withManager:(SDLManager *)manager {
    SDLAlert *alert = [self.class sdlex_defaultAlert:text text2:nil softButtons:softButtons duration:duration];

    [manager sendRequest:alert withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_alertResponse:response error:error];
    }];
}

+ (void)alertCommand_showText:(NSString *)text1 text2:(NSString *)text2 softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons duration:(int)duration withManager:(SDLManager *)manager {
    SDLAlert *alert = [self.class sdlex_defaultAlert:text1 text2:text2 softButtons:softButtons duration:duration];

    [manager sendRequest:alert withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_alertResponse:response error:error];
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
