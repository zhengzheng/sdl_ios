//
//  AddCommandManager.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "AddCommandManager.h"
#import "SDLMenuParams.h"
#import "SDLOnCommand.h"

@implementation AddCommandManager

+ (SDLAddCommand *)addCommandWithManager:(SDLManager *)manager commandId:(int)commandId menuName:(NSString *)menuName handler:(void (^)(void))handler {
    SDLMenuParams *commandMenuParams = [[SDLMenuParams alloc] init];
    commandMenuParams.menuName = menuName;

    SDLAddCommand *addCommand = [[SDLAddCommand alloc] init];
    addCommand.vrCommands = [NSMutableArray arrayWithObject:menuName];
    addCommand.menuParams = commandMenuParams;
    addCommand.cmdID = @(commandId);

    addCommand.handler = ^void(SDLOnCommand *notification) {
        if (handler == nil) { return; }
        handler();
    };

    return addCommand;
}

+ (SDLDeleteCommand *)deleteCommandWithId:(int)commandId {
    return [[SDLDeleteCommand alloc] initWithId:commandId];
}

@end
