//
//  ImageManager.h
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"

@interface ImageManager : NSObject

+ (NSArray<SDLArtwork *> *)allImagesAndBlankPlaceholder;
+ (NSArray<SDLArtwork *> *)allImages;
+ (NSArray<NSString *> *)allImageNames;
+ (NSArray<SDLArtwork *> *)softButtonImages;
+ (NSArray<NSString *> *)allSoftButtonImageNames;

+ (SDLImage *)mainGraphicImage;
+ (SDLImage *)mainGraphicBlankImage;

+ (NSString *)starImageName;
+ (NSString *)hexagonOnImageName;
+ (NSString *)hexagonOffImageName;
+ (NSString *)mainGraphicImageName;
+ (NSString *)mainGraphicBlankImageName;

+ (UIImage *)mainGraphic;

@end
