//
//  KCUserProfile.m
//  Keychn
//
//  Created by Keychn Experience SL on 14/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCUserProfile.h"
#import "KCUserProfileDBManager.h"

@implementation KCUserProfile

+ (instancetype)sharedInstance {
    //Get shared instance of the class, will be used throught the app
    static KCUserProfile *userProfile = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userProfile                     = [[KCUserProfile alloc] init];
        userProfile.facebookProfile     = [[KCUserFacebookProfile alloc] init];
        userProfile.twitterProfile      = [[KCUserTwitterProfile alloc] init];
    });
    return userProfile;
}

- (void)releseSharedInstance {
    //Set user profile to nil
    self.userID                 = 0;
    self.username               = nil;;
    self.emailID                = nil;
    self.password               = nil;
    self.accessToken            = nil;
    self.credits                = nil;
    self.receiveNewsletter      = nil;
    self.languageID             = nil;
    
    //Reallocate instances
    self.facebookProfile        = [[KCUserFacebookProfile alloc] init];
    self.twitterProfile         = [[KCUserTwitterProfile alloc] init];
}

- (NSDictionary*) getUserProfileDictionary {
    //Returns user profile dictionary from user model
    NSMutableDictionary *userProfileDictionary = [[NSMutableDictionary alloc] init];
    [userProfileDictionary setObject:self.emailID forKey:kEmailID];
    [userProfileDictionary setObject:self.password forKey:kPassword];
    
    if(self.userID) {
      [userProfileDictionary setObject:self.userID forKey:kIdentifier];
    }
    if(self.location) {
      [userProfileDictionary setObject:self.location forKey:kLocation];
    }
    if(self.languageID) {
      [userProfileDictionary setObject:self.languageID forKey:kLanguageID];
    }
    else {
      [userProfileDictionary setObject:@1 forKey:kLanguageID];
    }
    if(self.receiveNewsletter) {
        [userProfileDictionary setObject:self.receiveNewsletter forKey:kReceiveNewsletter];
    }
    if(self.username) {
        [userProfileDictionary setObject:self.username forKey:kName];
    }
    
    //Push notification parameters
    if(keychnDeviceToken) {
      [userProfileDictionary setObject:keychnDeviceToken forKey:kDeviceToken];
    }
    if(keychnVoIPToken) {
      [userProfileDictionary setObject:keychnVoIPToken forKey:kVoIPToken];
    }
    [userProfileDictionary setObject:DEVICE_UDID forKey:kDeviceID];
    [userProfileDictionary setObject:IOS_DEVICE forKey:kDeviceType];
    return userProfileDictionary;
}

- (void) getModelFromDictionary:(NSDictionary*)response withType:(ResponseType)type{
    //Get user profile model from dictionary
    self.password   = [response objectForKey:kPassword];
    self.emailID    = [response objectForKey:kEmailID];
    self.accessToken  = [response objectForKey:kAcessToken];
    self.imageURL   = [response objectForKey:kImageURL];
    self.location   = [response objectForKey:kLocation];
    self.isActive   = [response objectForKey:kIsActive];
    self.userType   = [response objectForKey:kUserType];
    self.credits    = [response objectForKey:kCredit];
    
    if(type == local) {
        self.userID     = [response objectForKey:kUserID];
        self.receiveNewsletter = [response objectForKey:kNewsletterPrefs];
        self.username   = [response objectForKey:kUsername];
        self.languageID = [response objectForKey:kLanguageID];
    }
    else {
      self.userID     = [response objectForKey:kIdentifier];
      self.receiveNewsletter = [response objectForKey:kReceiveNewsletter];
      self.username   = [response objectForKey:kName];
      self.languageID = [response objectForKey:kSupportedLanguageID];
        if(![NSString validateString:self.languageID]) {
           self.languageID = [response objectForKey:kLanguageID];
        }
    }
    if([self.languageID integerValue] == 0) {
        self.languageID = @1;
    }
    defaultLanguage = self.languageID;
}

- (void)updateKeychnPoints:(NSNumber*)keychnPoints {
    // Update Keychn credit in local database
    KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
    self.credits = keychnPoints;
    [userProfileDBManager updateUserProfile:self];
}

- (void)deductMasterClassAmount {
    // Deduct Masterclass amount when user book a spot
    KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
    self.credits      = [NSNumber numberWithInteger:[self.credits integerValue] - 25];
    [userProfileDBManager updateUserProfile:self];
}

@end
