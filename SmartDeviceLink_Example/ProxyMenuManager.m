//
//  ProxyMenuManager.m
//  SmartDeviceLink-Example
//
//  Created by Nicole on 10/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "ProxyMenuManager.h"
#import "AddCommandManager.h"
#import "AlertManager.h"
#import "ImageManager.h"
#import "SDLNames.h"
#import "ShowManager.h"
#import "SoftButtonManager.h"
#import "TemplateManager.h"

NS_ASSUME_NONNULL_BEGIN

@implementation ProxyMenuManager

+ (void)sendMenuItemsWithManager:(SDLManager *)manager {
    int commandId = 1000;

    // Home
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Home" handler:^{
        [ShowManager showHomeTextAndImagesWithManager:manager];
    }]];

    // Change Template menu & submenu
    int parentMenuId = (commandId++);
    [manager sendRequest:[self.class sdlex_changeTemplateAddSubmenuWithManager:manager commandId:parentMenuId] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if([response.resultCode isEqualToEnum:SDLResultSuccess]) {
            for (SDLAddCommand *addCommand in [self.class sdlex_templateNamesAddCommandWithManager:manager parentCommandId:parentMenuId startingCommandId:(parentMenuId + 1)]) {
                [manager sendRequest:addCommand];
            }
        } else {
            SDLLogE(@"The template submenu was not created successfully (%@)", error);
        }
    }];
    commandId += [self.class sdlex_predefinedLayouts].count;

    // Slider
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Show Slider" handler:^{
        [self.class sdlex_createSliderWithManager:manager];
    }] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
    }];

    // Perform interaction choice set
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Perform Interaction" handler:^{
        [self.class sdlex_sendPerformOnlyChoiceInteractionWithManager:manager];
    }] withResponseHandler:nil];

    // Alert maneuver - this only works with app type NAVIGATION
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Alert Maneuver" handler:^{
        [self.class sdlex_createAlertManeuverWithManager:manager];
    }] withResponseHandler:nil];

    // Alert
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Alert" handler:^{
        [AlertManager defaultAlertWithManager:manager];
    }] withResponseHandler:nil];

    // Scrollable message
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Scrollable Message" handler:^{
        [self.class sdlex_createScrollableMessageWithManager:manager];
    }] withResponseHandler:nil];

    // Change registration
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Change Registration" handler:^{
        [self.class sdlex_changeRegistrationWithManager:manager];
    }]];

    // Delete file
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Delete File" handler:^{
        [self.class sdlex_deleteFileWithManager:manager];
    }]];

    // Diagnostic message
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Diagnostic Message" handler:^{
        [self.class sdlex_diagnosticMessage:manager];
    }]];

    // Dial number
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Dial Number" handler:^{
        [self.class sdlex_dialNumber:manager];
    }]];

    // Diagnostic trouble codes
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Get DTCs" handler:^{
        [self.class sdlex_getDTCs:manager];
    }]];

    // Get system capabilities
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Get System Capability" handler:^{
        [self.class sdlex_getSystemCapability:manager];
    }]];

    // Get waypoints
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Get Waypoints" handler:^{
        [self.class sdlex_getWaypoints:manager];
    }]];

    // Subscribe waypoints
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Subscribe Waypoints" handler:^{
        [self.class sdlex_subscribeWaypoints:manager];
    }]];

    // Unsubscribe waypoints
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Unsubscribe Waypoints" handler:^{
        [self.class sdlex_unsubscribeWaypoints:manager];
    }]];

    // Unregister app interface
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Unregister App Interface" handler:^{
        [self.class sdlex_unRegisterAppInterface:manager];
    }]];

    // Update turn list
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Update Turn List" handler:^{
        [self.class sdlex_updateTurnList:manager];
    }]];

    // Sync P Data
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Sync P Data" handler:^{
        [self.class sdlex_syncPData:manager];
    }]];

    // Sync P Encoded Data
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Encoded Sync P Data" handler:^{
        [self.class sdlex_encodedSyncPData:manager];
    }]];

    // End Audio Pass Thru
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"End Audio Pass Thru" handler:^{
        [self.class sdlex_endAudioPassThru:manager];
    }]];

    // Send Location
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Send Location" handler:^{
        [self.class sdlex_sendLocation:manager];
    }]];

    // Get Vehicle Data
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Get Vehicle Data" handler:^{
        [self.class sdlex_sendGetVehicleDataWithManager:manager];
    }] withResponseHandler:nil];

    // Subscribe Vehicle Data
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Subscribe Vehicle Data" handler:^{
        [self.class sdlex_subscribeVehicleData:manager];
    }]];

    // Unsubscribe Vehicle Data
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Unsubscribe Vehicle Data" handler:^{
        [self.class sdlex_unsubscribeVehicleData:manager];
    }]];

    // Show Constant Turn-by-Turn
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Show Constant TBT" handler:^{
        [self.class sdlex_showConstantTBT:manager];
    }]];

    // Reset Global Properties
    [manager sendRequest:[AddCommandManager addCommandWithManager:manager commandId:(commandId++) menuName:@"Reset Global Properties" handler:^{
        [self.class sdlex_resetGlobalProperties:manager];
    }]];

    //    [self.sdlManager sendRequest:[AddCommandManager addCommandWithManager:self.sdlManager commandId:(commandId++) menuName:@"Show Read DID" handler:^{
    //        [self.class sdlex_showReadDID:self.sdlManager];
    //    }]];
    //
    //    [self.sdlManager sendRequest:[AddCommandManager addCommandWithManager:self.sdlManager commandId:(commandId++) menuName:@"Set Global Properties" handler:^{
    //        [self.class sdlex_setGlobalProperties:self.sdlManager];
    //    }]];

    //    commandId += [manager sdlex_predefinedLayouts].count;

    //    [self.sdlManager sendRequest:[AddCommandManager addCommandWithManager:self.sdlManager commandId:(commandId++) menuName:@"Speak App Name" handler:^{
    //        [self.sdlManager sendRequest:[self.class sdlex_appNameSpeak]];
    //    }] withResponseHandler:nil];
    //
    //
    //    dispatch_group_t dataDispatchGroup = dispatch_group_create();
    //    dispatch_group_enter(dataDispatchGroup);


    //    dispatch_group_enter(dataDispatchGroup);
    //    [self.sdlManager.fileManager uploadFile:[self.class sdlex_pointingSoftButtonArtwork] completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
    //        dispatch_group_leave(dataDispatchGroup);
    //
    //        if (success == NO) {
    //            NSLog(@"Something went wrong, image could not upload: %@", error);
    //            return;
    //        }
    //    }];

    //    dispatch_group_enter(dataDispatchGroup);
    //    [self.sdlManager sendRequest:[self.class sdlex_createOnlyChoiceInteractionSet] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
    //        // Interaction choice set ready
    //        dispatch_group_leave(dataDispatchGroup);
    //    }];

    //    dispatch_group_leave(dataDispatchGroup);
    //    dispatch_group_notify(dataDispatchGroup, dispatch_get_main_queue(), ^{
    //
    //    });

    //    self.initialShowState = SDLHMIInitialShowStateDataAvailable;
    //    [self sdlex_showInitialData];

}

#pragma mark - Templates menu and submenu

+ (SDLAddSubMenu *)sdlex_changeTemplateAddSubmenuWithManager:(SDLManager *)manager commandId:(int)commandId {
    return [[SDLAddSubMenu alloc] initWithId:commandId menuName:@"Change the Template"];
}

+ (NSArray<SDLAddCommand *> *)sdlex_templateNamesAddCommandWithManager:(SDLManager *)manager parentCommandId:(int)parentCommandId startingCommandId:(int)startingCommandId {
    int commandId = startingCommandId;
    NSMutableArray<SDLAddCommand *> *templatesAddCommands = [NSMutableArray array];
    for (SDLPredefinedLayout template in [self.class sdlex_predefinedLayouts]) {
        SDLMenuParams *commandMenuParams = [[SDLMenuParams alloc] init];
        commandMenuParams.menuName = [NSString stringWithFormat:@"%@", template];
        commandMenuParams.parentID = @(parentCommandId);

        SDLAddCommand *changeTemplateCommand = [[SDLAddCommand alloc] init];
        changeTemplateCommand.vrCommands = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%@", template]];
        changeTemplateCommand.menuParams = commandMenuParams;
        changeTemplateCommand.cmdID = @(commandId++);

        changeTemplateCommand.handler = ^(__kindof SDLRPCNotification * _Nonnull notification) {
            [TemplateManager changeTemplateWithManager:manager toTemplate:template image:[ImageManager mainGraphicImage]];
        };

        [templatesAddCommands addObject:changeTemplateCommand];
    }
    return templatesAddCommands;
}

+ (NSArray<SDLPredefinedLayout> *)sdlex_predefinedLayouts {
    return @[SDLPredefinedLayoutDefault,
             SDLPredefinedLayoutMedia,
             SDLPredefinedLayoutNonMedia,
             SDLPredefinedLayoutOnscreenPresets,
             SDLPredefinedLayoutNavigationFullscreenMap,
             SDLPredefinedLayoutNavigationList,
             SDLPredefinedLayoutNavigationKeyboard,
             SDLPredefinedLayoutGraphicWithText,
             SDLPredefinedLayoutTextWithGraphic,
             SDLPredefinedLayoutTilesOnly,
             SDLPredefinedLayoutTextButtonsOnly,
             SDLPredefinedLayoutGraphicWithTiles,
             SDLPredefinedLayoutTilesWithGraphic,
             SDLPredefinedLayoutGraphicWithTextAndSoftButtons,
             SDLPredefinedLayoutTextAndSoftButtonsWithGraphic,
             SDLPredefinedLayoutGraphicWithTextButtons,
             SDLPredefinedLayoutTextButtonsWithGraphic,
             SDLPredefinedLayoutLargeGraphicWithSoftButtons,
             SDLPredefinedLayoutDoubleGraphicWithSoftButtons,
             SDLPredefinedLayoutLargeGraphicOnly];
}

#pragma mark - Perform Interaction Choice Sets
+ (SDLCreateInteractionChoiceSet *)sdlex_createChoiceInteractionSetWithChoiceSetId:(NSNumber *)choiceSetId choiceId:(NSNumber *)choiceId {
    SDLCreateInteractionChoiceSet *createInteractionSet = [[SDLCreateInteractionChoiceSet alloc] init];
    createInteractionSet.interactionChoiceSetID = choiceSetId;

    NSString *theOnlyChoiceName = @"The Only Choice";
    SDLChoice *theOnlyChoice = [[SDLChoice alloc] init];
    theOnlyChoice.choiceID = choiceId;
    theOnlyChoice.menuName = theOnlyChoiceName;
    theOnlyChoice.vrCommands = [NSMutableArray arrayWithObject:theOnlyChoiceName];
    createInteractionSet.choiceSet = [NSMutableArray arrayWithArray:@[theOnlyChoice]];

    return createInteractionSet;
}

+ (SDLPerformInteraction *)sdlex_createPerformInteractionWithChoiceSetId:(NSNumber *)choiceSetId {
    SDLPerformInteraction *performInteraction = [[SDLPerformInteraction alloc] init];
    performInteraction.interactionChoiceSetIDList = @[choiceSetId];
//    performInteraction.initialText = @"Select";

//    performInteraction.initialText = @"Choose the only choice";
//    performInteraction.interactionMode = SDLInteractionModeBoth;
//    performInteraction.timeout = @3000;
//    performInteraction.interactionLayout = SDLLayoutModeListOnly;

    // Prompts
//    performInteraction.initialPrompt = [SDLTTSChunk textChunksFromString:@"Select a choice item"];
//    performInteraction.helpPrompt = [SDLTTSChunk textChunksFromString:@"Select a choice item from the list"];
//    performInteraction.vrHelp = @[[[SDLVRHelpItem alloc] initWithText:@"Tap row" image:nil]];
//    performInteraction.timeoutPrompt = [SDLTTSChunk textChunksFromString:@"Closing the menu"];

    return performInteraction;
}

+ (void)sdlex_sendPerformOnlyChoiceInteractionWithManager:(SDLManager *)manager {
    NSNumber *choiceSetId = @10000;
    NSNumber *choiceId = @20000;

    [manager sendRequest:[self.class sdlex_createChoiceInteractionSetWithChoiceSetId:choiceSetId choiceId:choiceId] withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (![response.resultCode isEqualToEnum:SDLResultSuccess]) { return; }
        [manager sendRequest:[self.class sdlex_createPerformInteractionWithChoiceSetId:choiceSetId]     withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            SDLPerformInteractionResponse *performInteractionResponse = (SDLPerformInteractionResponse *)response;

            if ((performInteractionResponse == nil) || (error != nil)) {
                SDLLogE(@"Something went wrong, no perform interaction response: %@", error);
            }

            if ([performInteractionResponse.choiceID isEqualToNumber:choiceId]) {
                [manager sendRequest:[self sdlex_goodJobSpeak]];
            } else {
                [manager sendRequest:[self sdlex_youMissedItSpeak]];
            }
        }];
    }];
}

#pragma mark - Vehicle Data

+ (void)sdlex_subscribeVehicleData:(SDLManager *)manager {
    SDLSubscribeVehicleData *subscribeVehicleData = [[SDLSubscribeVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES emergencyEvent:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES wiperStatus:YES];
    [manager sendRequest:subscribeVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Subscribe Vehicle Data RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_unsubscribeVehicleData:(SDLManager *)manager {
    SDLUnsubscribeVehicleData *unsubscribeVehicleData = [[SDLUnsubscribeVehicleData alloc] init];
    [manager sendRequest:unsubscribeVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Unsubscribe Vehicle Data RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_sendGetVehicleDataWithManager:(SDLManager *)manager {
    SDLGetVehicleData *getVehicleData = [[SDLGetVehicleData alloc] initWithAccelerationPedalPosition:YES airbagStatus:YES beltStatus:YES bodyInformation:YES clusterModeStatus:YES deviceStatus:YES driverBraking:YES eCallInfo:YES emergencyEvent:YES engineTorque:YES externalTemperature:YES fuelLevel:YES fuelLevelState:YES gps:YES headLampStatus:YES instantFuelConsumption:YES myKey:YES odometer:YES prndl:YES rpm:YES speed:YES steeringWheelAngle:YES tirePressure:YES vin:YES wiperStatus:YES];

    [manager sendRequest:getVehicleData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLAlert* alert = [[SDLAlert alloc] init];
        alert.alertText1 = [NSString stringWithFormat:@"Get vehicle data RPC sent. Response: %@", response.resultCode];
        [manager sendRequest:alert];

        if ([response.resultCode isEqualToEnum:SDLResultSuccess]) {
            // Parse the data
            NSNumber *pedalPosition = [response valueForKey:SDLNameAccelerationPedalPosition];
            NSLog(@"Acceleration Pedal position: %@", pedalPosition);
            SDLAirbagStatus *airbagStatus = [response valueForKey:SDLNameAirbagStatus];
            NSLog(@"Airbag Status, %@", airbagStatus);
            SDLBeltStatus *beltStatus = [response valueForKey:SDLNameBeltStatus];
            NSLog(@"Belt Status, %@", beltStatus);
            SDLBodyInformation *bodyInformation = [response valueForKey:SDLNameBodyInformation];
            NSLog(@"Body Information, %@", bodyInformation);
            SDLClusterModeStatus *clusterModeStatus = [response valueForKey:SDLNameClusterModeStatus];
            NSLog(@"Cluster Mode Status: %@", clusterModeStatus);
            SDLDeviceStatus *deviceStatus = [response valueForKey:SDLNameDeviceStatus];
            NSLog(@"Device Status: %@", deviceStatus);
            NSNumber *driverBraking = [response valueForKey:SDLNameDriverBraking];
            NSLog(@"Driver Braking: %@", driverBraking);
            SDLECallInfo *eCallInfo = [response valueForKey:SDLNameECallInfo];
            NSLog(@"Emergency Call Info: %@", eCallInfo);
            SDLEmergencyEvent *emergencyEvent = [response valueForKey:SDLNameEmergencyEvent];
            NSLog(@"Emergency Event: %@", emergencyEvent);
            NSNumber *engineTorque = [response valueForKey:SDLNameEngineTorque];
            NSLog(@"Engine Torque: %@", engineTorque);
            NSNumber *externalTemperature = [response valueForKey:SDLNameExternalTemperature];
            NSLog(@"External Temperature %@", externalTemperature);
            NSNumber *fuelLevel = [response valueForKey:SDLNameFuelLevel];
            NSLog(@"Fuel Level: %@", fuelLevel);
            NSNumber *fuelLevelState = [response valueForKey:SDLNameFuelLevelState];
            NSLog(@"Fuel Level State: %@", fuelLevelState);
            SDLGPSData *gpsData = [response valueForKey:SDLNameGPS];
            NSLog(@"GPS Data: %@", gpsData);
            SDLHeadLampStatus *headLampStatus = [response valueForKey:SDLNameHeadLampStatus];
            NSLog(@"Headlamp status: %@", headLampStatus);
            NSNumber *instantFuelConsumption = [response valueForKey:SDLNameInstantFuelConsumption];
            NSLog(@"Instant fuel consumption: %@", instantFuelConsumption);
            SDLMyKey *myKey = [response valueForKey:SDLNameMyKey];
            NSLog(@"My Key: %@", myKey);
            NSNumber *odometer = [response valueForKey:SDLNameOdometer];
            NSLog(@"Odometer: %@", odometer);
            SDLPRNDL prndl = [response valueForKey:SDLNamePRNDL];
            NSLog(@"Park Reverse Neutral Drive: %@", prndl);
            NSNumber *rpm = [response valueForKey:SDLNameRPM];
            NSLog(@"RPM: %@", rpm);
            NSNumber *speed = [response valueForKey:SDLNameSpeed];
            NSLog(@"Speed: %@", speed);
            NSNumber *steeringWheelAngle = [response valueForKey:SDLNameSteeringWheelAngle];
            NSLog(@"Steering Wheel Angle: %@", steeringWheelAngle);
            SDLTireStatus *tireStatus = [response valueForKey:SDLNameTirePressure];
            NSLog(@"Tire Pressure: %@", tireStatus);
            SDLSingleTireStatus *singleTireStatus = tireStatus.leftRear;
            NSLog(@"Left Rear: %@", singleTireStatus.status);
            NSNumber *vin = [response valueForKey:SDLNameVIN];
            NSLog(@"VIN: %@", vin);
            SDLWiperStatus wiperStatus = [response valueForKey:SDLNameWiperStatus];
            NSLog(@"Wiper Status: %@", wiperStatus);
        }

        NSLog(@"vehicle data: %@", response);
        return;
    }];
}

#pragma mark - Waypoints

+ (void)sdlex_subscribeWaypoints:(SDLManager *)manager {
    SDLSubscribeWayPoints *wayPoints = [[SDLSubscribeWayPoints alloc] init];
    [manager sendRequest:wayPoints withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Subscribe Waypoints RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_getWaypoints:(SDLManager *)manager {
    SDLGetWayPoints *wayPoints = [[SDLGetWayPoints alloc] initWithType:SDLWayPointTypeAll];
    [manager sendRequest:wayPoints withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Get Waypoints RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_unsubscribeWaypoints:(SDLManager *)manager {
    SDLUnsubscribeWayPoints *unsubscribeWayPoints = [[SDLUnsubscribeWayPoints alloc] init];
    [manager sendRequest:unsubscribeWayPoints withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Unsubscribe Waypoints RPC sent. Response: %@", response.resultCode]];
    }];
}

#pragma mark - Navigation

+ (void)sdlex_createAlertManeuverWithManager:(SDLManager *)manager {
    SDLAlertManeuver *alertManeuver = [[SDLAlertManeuver alloc] init];
    alertManeuver.ttsChunks = [SDLTTSChunk textChunksFromString:@"Alert maneuver example"];
    SDLSoftButton *cancelButton = [SoftButtonManager createSoftButtonWithText:@"Cancel" softButtonId:300 manager:manager handler:^{
        // Alert will be dismissed
    }];
    alertManeuver.softButtons = [@[cancelButton] mutableCopy];
    [manager sendRequest:alertManeuver withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if (![response.resultCode isEqualToEnum:SDLResultSuccess]) {
            SDLAlert* alert = [[SDLAlert alloc] init];
            alert.alertText1 = [NSString stringWithFormat:@"Alert Maneuver RPC sent. Response: %@", response.resultCode];
            [manager sendRequest:alert];
            return;
        }
    }];
}

+ (void)sdlex_showConstantTBT:(SDLManager *)manager {
    SDLShowConstantTBT *constant = [[SDLShowConstantTBT alloc] init];
    [manager sendRequest:constant withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Show Constant RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_sendLocation:(SDLManager *)manager {
    SDLSendLocation *sendLocation = [[SDLSendLocation alloc] init];
    NSNumber *someLongitude = @123.4567;
    NSNumber *someLatitude = @65.4321;
    NSString *someLocation = @"Livio";
    NSString *someLocationDescription = @"A great place to work";
    NSArray *someAddressLines = @[@"3136 Hilton Rd", @"Ferndale, MI", @"48220"];
    NSString *somePhoneNumber = @"2485910333";
    // SDLImage *someImage = [[SDLImage alloc] init];
    SDLDeliveryMode someDeliveryMode = SDLDeliveryModePrompt;
    // SDLDateTime *someTime = [[SDLDateTime alloc] init];
    // SDLOasisAddress *someAddress = [[SDLOasisAddress alloc] init];

    sendLocation.longitudeDegrees = someLongitude;
    sendLocation.latitudeDegrees = someLatitude;
    sendLocation.locationName = someLocation;
    sendLocation.locationDescription = someLocationDescription;
    sendLocation.addressLines = someAddressLines;
    sendLocation.phoneNumber = somePhoneNumber;
    // sendLocation.locationImage = someImage;
    sendLocation.deliveryMode = someDeliveryMode;
    // sendLocation.timeStamp = someTime;
    // sendLocation.address = someAddress;

    [manager sendRequest:sendLocation withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Send Location RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_updateTurnList:(SDLManager *)manager {
    SDLUpdateTurnList *turnList = [[SDLUpdateTurnList alloc] init];
    SDLTurn *turn = [[SDLTurn alloc] init];
    SDLSoftButton *button = [[SDLSoftButton alloc] init];
    turnList.turnList = [@[turn] mutableCopy];
    turnList.softButtons = [@[button] mutableCopy];

    [manager sendRequest:turnList withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Update turn list RPC sent. Response: %@", response.resultCode]];
    }];
}

#pragma mark - Speech

+ (SDLSpeak *)sdlex_appNameSpeak {
    SDLSpeak *speak = [[SDLSpeak alloc] init];
    speak.ttsChunks = [SDLTTSChunk textChunksFromString:@"S D L Example App"];

    return speak;
}

+ (SDLSpeak *)sdlex_goodJobSpeak {
    SDLSpeak *speak = [[SDLSpeak alloc] init];
    speak.ttsChunks = [SDLTTSChunk textChunksFromString:@"Good Job"];

    return speak;
}

+ (SDLSpeak *)sdlex_youMissedItSpeak {
    SDLSpeak *speak = [[SDLSpeak alloc] init];
    speak.ttsChunks = [SDLTTSChunk textChunksFromString:@"You missed it"];

    return speak;
}

+ (void)sdlex_endAudioPassThru:(SDLManager *)manager {
    SDLEndAudioPassThru *endAudioPassThru = [[SDLEndAudioPassThru alloc] init];
    [manager sendRequest:endAudioPassThru withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"End Audio Pass Thru RPC sent. Response: %@", response.resultCode]];
    }];
}

#pragma mark - Other

+ (void)sdlex_createSliderWithManager:(SDLManager *)manager {
    SDLSlider *slider = [[SDLSlider alloc] init];
    slider.timeout = @10000;
    slider.position = @1;
    slider.numTicks = @8;
    slider.sliderHeader = @"Slider Header";
    slider.sliderFooter = [[NSMutableArray alloc] initWithObjects:@"1 - Start", @"2", @"3", @"4", @"5", @"6", @"7", @"8 - End", nil];
    [manager sendRequest:slider];
}

+ (void)sdlex_sendAlert:(SDLManager *)manager message:(NSString *)message {
    SDLAlert* alert = [[SDLAlert alloc] init];
    alert.alertText1 = message;
    [manager sendRequest:alert];
}

+ (void)sdlex_setGlobalProperties:(SDLManager *)manager {
    SDLSetGlobalProperties *globalProperties = [[SDLSetGlobalProperties alloc] init];

    SDLTTSChunk* chunk1 = [[SDLTTSChunk alloc] init];
    SDLTTSChunk* chunk2 = [[SDLTTSChunk alloc] init];
    SDLVRHelpItem* help = [[SDLVRHelpItem alloc] init];
    SDLImage* image = [[SDLImage alloc] init];
    SDLKeyboardProperties* keyboard = [[SDLKeyboardProperties alloc] init];

    globalProperties.helpPrompt = [@[chunk1] mutableCopy];
    globalProperties.timeoutPrompt = [@[chunk2] mutableCopy];
    globalProperties.vrHelpTitle = @"vr";
    globalProperties.vrHelp = [@[help] mutableCopy];
    globalProperties.menuTitle = @"TheNewMenu";
    globalProperties.menuIcon = image;
    globalProperties.keyboardProperties = keyboard;

    [manager sendRequest:globalProperties withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Set Global Properties RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_showReadDID:(SDLManager *)manager {
    SDLReadDID *readDid = [[SDLReadDID alloc] init];
    readDid.ecuName = @33112;
    readDid.didLocation = [@[@200, @201, @205] mutableCopy];

    [manager sendRequest:readDid withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Show Read DID RPC sent. Response: %@", response.resultCode]];
        NSLog(@"Show Read DID response: %@", response);
    }];
}

+ (void)sdlex_resetGlobalProperties:(SDLManager *)manager {
    SDLResetGlobalProperties *resetGlobalProperties = [[SDLResetGlobalProperties alloc] init];
    resetGlobalProperties.properties = [@[SDLGlobalPropertyMenuName, SDLGlobalPropertyVoiceRecognitionHelpTitle] copy];

    [manager sendRequest:resetGlobalProperties withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Reset Global Properties RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_unRegisterAppInterface:(SDLManager *)manager {
    SDLUnregisterAppInterface *unRegisterAppInterface = [[SDLUnregisterAppInterface alloc] init];
    [manager sendRequest:unRegisterAppInterface withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Unregister App Interface RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_syncPData:(SDLManager *)manager {
    SDLSyncPData *pData = [[SDLSyncPData alloc] init];
    [manager sendRequest:pData withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Sync P Data RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_getSystemCapability:(SDLManager *)manager {
    SDLGetSystemCapability *capability = [[SDLGetSystemCapability alloc] initWithType:SDLSystemCapabilityTypeVideoStreaming];
    [manager sendRequest:capability withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Get System Capability RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_getDTCs:(SDLManager *)manager {
    SDLGetDTCs *dtcs = [[SDLGetDTCs alloc] init];
    dtcs.ecuName = @4321;
    dtcs.dtcMask = @22;

    [manager sendRequest:dtcs withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Get DTCs RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_encodedSyncPData:(SDLManager *)manager {
    SDLEncodedSyncPData *data = [[SDLEncodedSyncPData alloc] init];
    data.data = [@[@2, @2, @2] mutableCopy];
    [manager sendRequest:data withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        [self.class sdlex_sendAlert:manager message:[NSString stringWithFormat:@"Encode Sync P Data RPC sent. Response: %@", response.resultCode]];
    }];
}

+ (void)sdlex_dialNumber:(SDLManager *)manager {
    SDLDialNumber *dialNumber = [[SDLDialNumber alloc] initWithNumber:@"1234567890"];
    [manager sendRequest:dialNumber withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLAlert* alert = [[SDLAlert alloc] init];
        alert.alertText1 = [NSString stringWithFormat:@"Dial Number RPC Sent. Response: %@", response.resultCode];
        [manager sendRequest:alert];
    }];
}

+ (void)sdlex_diagnosticMessage:(SDLManager *)manager {
    SDLDiagnosticMessage *diagnosticMessage = [[SDLDiagnosticMessage alloc] init];
    diagnosticMessage.targetID = @3562;
    diagnosticMessage.messageLength = @55555;
    diagnosticMessage.messageData = [@[@1, @4, @16, @64] mutableCopy];

    [manager sendRequest:diagnosticMessage withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLAlert* alert = [[SDLAlert alloc] init];
        alert.alertText1 = [NSString stringWithFormat:@"Diagnostic Message RPC Sent. Response: %@", response.resultCode];
        [manager sendRequest:alert];
    }];
}

+ (void)sdlex_deleteFileWithManager:(SDLManager *)manager {
    SDLDeleteFile *deleteFile = [[SDLDeleteFile alloc] initWithFileName:@"Test file"];
    [manager sendRequest:deleteFile withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLAlert* alert = [[SDLAlert alloc] init];
        alert.alertText1 = [NSString stringWithFormat:@"Delete File RPC sent. Response: %@", response.resultCode];
        [manager sendRequest:alert];
    }];
}

+ (void)sdlex_changeRegistrationWithManager:(SDLManager *)manager {
    SDLChangeRegistration *changeRegistration = [[SDLChangeRegistration alloc] initWithLanguage:SDLLanguageEnSa hmiDisplayLanguage:SDLLanguageEnSa appName:@"New App Name" ttsName:[SDLTTSChunk textChunksFromString:@"New App Name"] ngnMediaScreenAppName:@"New App" vrSynonyms:[@[@"New App"] mutableCopy]];
    [manager sendRequest:changeRegistration withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        SDLAlert* alert = [[SDLAlert alloc] init];
        alert.alertText1 = [NSString stringWithFormat:@"Change registration RPC sent. Response: %@", response.resultCode];
        [manager sendRequest:alert];
    }];
}

+ (void)sdlex_createScrollableMessageWithManager:(SDLManager *)manager {
    SDLScrollableMessage *scrollableMessage = [[SDLScrollableMessage alloc] init];
    scrollableMessage.scrollableMessageBody = @"Four score and seven years ago our fathers brought forth, upon this continent, a new nation, conceived in liberty, and dedicated to the proposition that all men are created equal. Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived, and so dedicated, can long endure. We are met on a great battle field of that war. We come to dedicate a portion of it, as a final resting place for those who died here, that the nation might live.";
    scrollableMessage.timeout = @(10000);
    SDLSoftButton *cancelButton = [SoftButtonManager createSoftButtonWithText:@"Cancel" softButtonId:300 manager:manager handler:^{
        // Alert will be dismissed
    }];
    scrollableMessage.softButtons = [@[cancelButton] mutableCopy];
    [manager sendRequest:scrollableMessage];
}

@end

NS_ASSUME_NONNULL_END
