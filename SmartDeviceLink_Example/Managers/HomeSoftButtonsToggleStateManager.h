//
//  HomeSoftButtonsToggleStateManager.h
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeSoftButtonsToggleStateManager : NSObject

@property (assign, nonatomic, getter=isTextOn) BOOL textOn;
@property (assign, nonatomic, getter=areImagesVisible) BOOL imagesVisible;
@property (assign, nonatomic, getter=isHexagonOn) BOOL hexagonOn;

+ (instancetype)sharedManager;

@end
