//
//  ImageManager.m
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "ImageManager.h"
#import "HomeSoftButtonsToggleStateManager.h"

@implementation ImageManager

+ (NSArray<SDLArtwork *> *)allImagesAndBlankPlaceholder {
    NSMutableArray<SDLArtwork *> *art = [NSMutableArray array];
    [art addObjectsFromArray:[self.class allImages]];
    [art addObject:[self.class sdlex_mainGraphicBlankImage]];
    return art;
}

+ (NSArray<SDLArtwork *> *)allImages {
    NSMutableArray<SDLArtwork *> *art = [NSMutableArray array];
    [art addObjectsFromArray:[self.class softButtonImages]];
    [art addObject:[self.class sdlex_mainGraphicImage]];
    return art;
}

+ (NSArray<NSString *> *)allImageNames {
    NSMutableArray<NSString *> *fileNames = [NSMutableArray array];
    for (SDLArtwork *art in [self.class allImages]) {
        [fileNames addObject:art.name];
    }
    return fileNames;
}

+ (NSArray<SDLArtwork *> *)softButtonImages {
    return [[NSArray alloc] initWithObjects:[self.class sdlex_starImage], [self.class sdlex_hexagonOnImage], [self.class sdlex_hexagonOffImage], nil];
}

+ (NSArray<NSString *> *)allSoftButtonImageNames {
    NSMutableArray<NSString *> *fileNames = [NSMutableArray array];
    for (SDLArtwork *art in [self.class softButtonImages]) {
        [fileNames addObject:art.name];
    }
    return fileNames;
}

#pragma mark - Individual Image Names

+ (NSString *)starImageName {
    return @"StarSoftButtonIcon";
}

+ (NSString *)hexagonOnImageName {
    return @"HexagonOnSoftButtonIcon";
}

+ (NSString *)hexagonOffImageName {
    return @"HexagonOffSoftButtonIcon";
}

+ (SDLImage *)mainGraphicBlankImage {
    SDLImage* image = [[SDLImage alloc] init];
    image.imageType = SDLImageTypeDynamic;
    image.value = [self.class mainGraphicBlankImageName];
    return image;
}

+ (SDLImage *)mainGraphicImage {
    SDLImage* image = [[SDLImage alloc] init];
    image.imageType = SDLImageTypeDynamic;
    image.value = [self.class mainGraphicImageName];
    return image;
}

+ (NSString *)mainGraphicImageName {
    return @"MainArtwork";
}

+ (NSString *)mainGraphicBlankImageName {
    return @"MainBlankArtwork";
}

#pragma mark - Individual Images

+ (SDLArtwork *)sdlex_starImage {
    return [SDLArtwork artworkWithImage:[UIImage imageNamed:@"star_softbutton_icon"] name:[self.class starImageName] asImageFormat:SDLArtworkImageFormatPNG];
}

+ (SDLArtwork *)sdlex_hexagonOnImage {
    return [SDLArtwork artworkWithImage:[UIImage imageNamed:@"hexagon_on_softbutton_icon"] name:[self.class hexagonOnImageName] asImageFormat:SDLArtworkImageFormatPNG];
}

+ (SDLArtwork *)sdlex_hexagonOffImage {
    return [SDLArtwork artworkWithImage:[UIImage imageNamed:@"hexagon_off_softbutton_icon"] name:[self.class hexagonOffImageName] asImageFormat:SDLArtworkImageFormatPNG];
}

+ (SDLArtwork *)sdlex_mainGraphicImage {
    return [SDLArtwork artworkWithImage:[UIImage imageNamed:@"sdl_logo_green"] name:[self.class mainGraphicImageName] asImageFormat:SDLArtworkImageFormatPNG];
}

+ (SDLArtwork *)sdlex_mainGraphicBlankImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(5, 5), NO, 0.0);
    UIImage *blankImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    SDLArtwork *mainGraphicBlank = [SDLArtwork artworkWithImage:blankImage name:[self.class mainGraphicBlankImageName] asImageFormat:SDLArtworkImageFormatPNG];
    return mainGraphicBlank;
}


@end
