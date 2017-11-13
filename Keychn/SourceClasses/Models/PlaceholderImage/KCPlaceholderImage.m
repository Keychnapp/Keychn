//
//  KCPlaceholerImage.m
//  Keychn
//
//  Created by Keychn Experience SL on 04/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCPlaceholderImage.h"

@implementation KCPlaceholderImage

+ (instancetype)sharedInstance {
    //Get shared instance of the model
    static KCPlaceholderImage *placeholderImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        placeholderImage = [KCPlaceholderImage new];
    });
    return placeholderImage;
}

- (void) getModelFromArrray:(NSArray*)responseArray {
    // Prepare model from response dictionary
    IOSDevices deviceType = [KCUtility getiOSDeviceType];
    for (NSDictionary *placeholderDictionary in responseArray) {
        NSString *variableName = [placeholderDictionary objectForKey:kName];
        @try {
            NSString *imageURL;
            if(deviceType == iPad) {
                imageURL = [placeholderDictionary objectForKey:kImageURLiPad];
            }
            else {
                imageURL = [placeholderDictionary objectForKey:kImageURLiPhone];
            }
            //Set value to property using KVC
            [self setValue:imageURL forKey:variableName];
        }
        @catch (NSException *exception) {
            // Property not found
        }
    }
}

@end
