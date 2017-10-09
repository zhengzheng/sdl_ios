//
//  AlertManager.m
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/9/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "AlertManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AlertManager

+ (void)alertCommand_showText:(NSString *)text softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons duration:(int)duration withManager:(SDLManager *)manager {
    SDLAlert *alert = [[SDLAlert alloc] initWithAlertText1:text alertText2:nil alertText3:nil duration:duration softButtons:softButtons];
    alert.ttsChunks = [SDLTTSChunk textChunksFromString:text];

    [manager sendRequest:alert withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Error showing the alert (%@)", text);
        } else if (![response.resultCode isEqualToEnum:SDLResultSuccess]) {
            SDLLogE(@"The alert was not shown successfully wiht error: %@, (%@)", response.resultCode, text);
        } else {
            SDLLogD(@"Alert shown successfully");
        }
    }];
}

@end

NS_ASSUME_NONNULL_END
