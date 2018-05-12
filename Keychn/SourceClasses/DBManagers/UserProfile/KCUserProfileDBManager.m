//
//  KCUserProfileDBManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCUserProfileDBManager.h"
#import "KCDatabaseOperation.h"
#import "IAPSubscription.h"

@implementation KCUserProfileDBManager

- (void)saveCurrentUserWithCompletionHandler:(void(^)(void))finished {
    //insert update user profile
    KCUserProfile *userProfile = [KCUserProfile sharedInstance];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //prepare raw query
        NSString *query = [NSString stringWithFormat:@"INSERT INTO user_profile (user_id, username, email_id, location, image_url, credit, is_active, user_type, access_token, newsletter_preference, password, banner_url) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",userProfile.userID,userProfile.username,userProfile.emailID,userProfile.location,userProfile.imageURL,userProfile.credits,userProfile.isActive,userProfile.userType,userProfile.accessToken,userProfile.receiveNewsletter,userProfile.password, userProfile.bannerImageURL];
        
        if(DEBUGGING) NSLog(@"User Profile Insert Query %@",query);
        
        //insert into datbase
        KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
        [dbOperation executeSQLQuery:query];
        finished();
    });
}

- (void)saveUserWithSocialProfile:(NSDictionary*)response {
    //seperate user profile and social profile dictionary
    NSDictionary *userDetailDictionary    = [response objectForKey:kUserDetails];
    NSDictionary *userProfileDictionary   = [userDetailDictionary objectForKey:kAppUsers];
    NSDictionary *socialProfileDictionary = [userDetailDictionary objectForKey:kSocialAccount];
    // Save user In-App Purhcase too
    NSDictionary *iapHistory = [response objectForKey:kSubscriptionPurhcase];
    if([iapHistory isKindOfClass:[NSDictionary class]]) {
        IAPSubscription *subscription  = [[IAPSubscription alloc] initWithResponse:iapHistory];
        [subscription saveIAPSubscription];
    }
    //save user basic profile
    KCUserProfile *userProfile            = [KCUserProfile sharedInstance];
    [userProfile getModelFromDictionary:userProfileDictionary withType:server];
    [self saveCurrentUserWithCompletionHandler:^{
        //save user facebook profile
        [userProfile.facebookProfile getModelFromDictionary:socialProfileDictionary withType:server];
        [self saveFacebookProfileWithUserID:userProfile.userID];
        
    }];
}

- (void) saveFacebookProfileWithUserID:(NSNumber*)userID {
    //save facebook profile with userID
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        KCUserProfile *userProfile        = [KCUserProfile sharedInstance];
        
        // Delete previous data if exists
        KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
        NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM social_profile WHERE 1"];
        [dbOperation executeSQLQuery:deleteQuery];
        
        KCUserFacebookProfile *fbProfile  = userProfile.facebookProfile;
        NSString *query = [NSString stringWithFormat:@"INSERT INTO social_profile (user_id, social_id, email_id, account_type, access_token, image_url, is_active) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@')",userID,fbProfile.facebookID, fbProfile.emailID, kFacebook, fbProfile.accessToken,fbProfile.imageURL,[NSNumber numberWithBool:fbProfile.isActive]];
        
        // Insert into datbase
        [dbOperation executeSQLQuery:query];
    });
}


- (void) getLoggedInUserProfile {
    // Get user from local database
    if(DEBUGGING) NSLog(@"Home Directory %@", NSHomeDirectory());
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSArray *userProfileArray        =  [dbOperation fetchDataInUTFStringFormatFromTable:@"user_profile" withClause:nil];
    if(userProfileArray && [userProfileArray count] > 0) {
        KCUserProfile *userProfle = [KCUserProfile sharedInstance];
        NSDictionary *userProfileDictionary = [userProfileArray objectAtIndex:0];
        [userProfle getModelFromDictionary:userProfileDictionary withType:local];
        
        NSString *clause = [NSString stringWithFormat:@"WHERE %@='%@'",kUserID,userProfle.userID];
        //get social profile
        NSArray *userSocialProfileArray = [dbOperation fetchDataFromTable:@"social_profile" withClause:clause];
        if(userSocialProfileArray && [userSocialProfileArray count] > 0) {
            NSDictionary *userSocialProfileDictionary = [userSocialProfileArray objectAtIndex:0];
            [userProfle.facebookProfile getModelFromDictionary:userSocialProfileDictionary withType:local];
        }
    }
}

- (void)deleteUserProfile {
    //delete user profile
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    @autoreleasepool {
        NSArray *tableNames          = @[@"user_profile", @"social_profile", @"user_schedule", @"text_message", @"purchase_history"];
        for (NSString *tableName in tableNames) {
            NSString *deleteQuery    = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
            [dbOperation executeSQLQuery:deleteQuery];
        }
    }
    
}

- (void)updateUserProfile:(KCUserProfile*)userProfile {
    // Update user profile in local database
    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE user_profile SET location = '%@', image_url = '%@', credit = '%@', is_active = '%@', user_type = '%@', access_token = '%@', banner_url = '%@' WHERE user_id='%@'",userProfile.location,userProfile.imageURL,userProfile.credits,userProfile.isActive,userProfile.userType,userProfile.accessToken, userProfile.bannerImageURL, userProfile.userID];
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    [dbOperation executeSQLQuery:updateQuery];
}

- (BOOL)isMasterchef {
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSArray *values                  = [dbOperation fetchColumnDataFromTable:@"user_schedule" andColumnName:@"schedule_id" withClause:@"WHERE is_hosting = 1"];
    return values.count > 0;
}


@end
