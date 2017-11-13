//
//  KCUserFacebookProfile.m
//  Keychn
//
//  Created by Keychn Experience SL on 14/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCUserFacebookProfile.h"

@implementation KCUserFacebookProfile

- (NSDictionary *)getSocialUserProfileDictionary {
    //get user social profile dictionary
    NSMutableDictionary *socialProfileDictionary = [[NSMutableDictionary alloc] init];
    //name, email_id, social_id, image_url, access_token, acc_type
    if(self.username) {
      [socialProfileDictionary setObject:self.username forKey:kName];
    }
    [socialProfileDictionary setObject:self.accessToken forKey:kAcessToken];
    if(!self.emailID) {
        //if email id is not there, create a symbolic email id
        self.emailID = [self.username stringByAppendingString:@"@facebook.com"];
    }
    [socialProfileDictionary setObject:self.emailID forKey:kEmailID];
    if(self.imageURL) {
      [socialProfileDictionary setObject:self.imageURL forKey:kImageURL];
    }
    if(self.location) {
        [socialProfileDictionary setObject:self.location forKey:kLocation];
    }
    
    [socialProfileDictionary setObject:self.facebookID forKey:kSocialID];
    [socialProfileDictionary setObject:kFacebook forKey:kSocialAccountType];
    [socialProfileDictionary setObject:[NSNumber numberWithBool:self.isActive] forKey:kIsActive];
    
    //Push notification parameters
    if(keychnDeviceToken) {
        [socialProfileDictionary setObject:keychnDeviceToken forKey:kDeviceToken];
    }
    if(keychnVoIPToken) {
        [socialProfileDictionary setObject:keychnVoIPToken forKey:kVoIPToken];
    }
    [socialProfileDictionary setObject:DEVICE_UDID forKey:kDeviceID];
    [socialProfileDictionary setObject:IOS_DEVICE forKey:kDeviceType];
    return socialProfileDictionary;
}

- (void) getModelFromDictionary:(NSDictionary*)responseDictionary withType:(ResponseType)type {
    self.facebookID     = [responseDictionary objectForKey:kSocialID];
    self.emailID        = [responseDictionary objectForKey:kEmailID];
    self.accessToken    = [responseDictionary objectForKey:kAcessToken];
    self.imageURL       = [responseDictionary objectForKey:kImageURL];
    self.location       = [responseDictionary objectForKey:kLocation];
    self.isActive       = [[responseDictionary objectForKey:kIsActive] boolValue];
}

@end
