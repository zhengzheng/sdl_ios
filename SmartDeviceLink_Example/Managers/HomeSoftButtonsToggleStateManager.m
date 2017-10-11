//
//  HomeSoftButtonsToggleStateManager.m
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "HomeSoftButtonsToggleStateManager.h"

@implementation HomeSoftButtonsToggleStateManager

+ (instancetype)sharedManager {
    static HomeSoftButtonsToggleStateManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[HomeSoftButtonsToggleStateManager alloc] init];
    });

    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    _textOn = YES;
    _imagesVisible = YES;
    _hexagonOn = YES;
    
    return self;
}

@end
