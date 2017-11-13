//
//  KCGroupSession.m
//  Keychn
//
//  Created by Keychn Experience SL on 22/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCGroupSession.h"

@implementation KCGroupSession

- (instancetype)initWithResponse:(NSDictionary*)response {
    // Get model from response
    self = [super init];
    if(self) {
        // Intialize properties
        if([KCUtility getiOSDeviceType] == iPad) {
           self.masterChefImageURL = [response objectForKey:kImageURLiPad];
            self.videoPlaceholderImageURL = [response objectForKey:kVideoPlaceholderiPad];
        }
        else {
            self.masterChefImageURL = [response objectForKey:kImageURLiPhone];
            self.videoPlaceholderImageURL = [response objectForKey:kVideoPlaceholderiPhone];
        }
        self.chefName       = [response objectForKey:kName];
        self.scheduleDate   = [response objectForKey:kScheduleOnDate];
        self.videoURL       = [response objectForKey:kVideoURL];
        self.sessionID      = [response objectForKey:kIdentifier];
        self.webLink        = [response objectForKey:kWebsiteLink];
        self.twitterLink    = [response objectForKey:kTwitterLink];
        self.facebookLink   = [response objectForKey:kFacebookLink];
        self.instagramLink  = [response objectForKey:kInstagramLink];
        self.chefLocation   = [response objectForKey:kLocation];
        self.chefAttribute  = [response objectForKey:kAboutUser];
        self.isBooked       = [[response objectForKey:kIsSelected] boolValue];
        self.isFullCapacity = [[response objectForKey:kIsFull] boolValue];
        self.amount         = [response objectForKey:kAmount];
    }
    return self;
}

- (instancetype)initWithMasterclassDetail:(NSDictionary*)response {
    // Get model from response
    self = [super init];
    if(self) {
        // Intialize properties
        if([KCUtility getiOSDeviceType] == iPad) {
            self.masterChefImageURL = [response objectForKey:kImageURLiPad];
            self.videoPlaceholderImageURL = [response objectForKey:kVideoPlaceholderiPad];
        }
        else {
            self.masterChefImageURL = [response objectForKey:kImageURLiPhone];
            self.videoPlaceholderImageURL = [response objectForKey:kVideoPlaceholderiPhone];
        }
        self.chefName       = [response objectForKey:kName];
        self.scheduleDate   = [response objectForKey:kScheduleDate];
        self.videoURL       = [response objectForKey:kVideoURL];
        self.sessionID      = [response objectForKey:kMasterClassID];
        
        self.webLink        = [response objectForKey:kWebsiteLink];
        self.twitterLink    = [response objectForKey:kTwitterLink];
        self.facebookLink   = [response objectForKey:kFacebookLink];
        self.instagramLink  = [response objectForKey:kInstagramLink];
        self.chefLocation   = [response objectForKey:kLocation];
        self.chefAttribute  = [response objectForKey:kAboutUser];
        self.isBooked       = [[response objectForKey:kIsBooked] boolValue];
        self.isFullCapacity = [[response objectForKey:kIsFull] boolValue];
        self.amount         = [response objectForKey:kAmount];
    }
    return self;
}

@end
