//
//  KCSignUpWebManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 30/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCSignUpWebManager.h"
#import "KCWebConnection.h"

@implementation KCSignUpWebManager

- (void)signUpUserWithDetails:(NSDictionary *)userDetailDictionary withCompletionHandler:(void (^)(NSDictionary *response))success failure:(void (^)(NSString *, NSString *))failed {
    //Register a user and notify with success and failure
    KCWebConnection *webConnection = [[KCWebConnection alloc] init];
    [webConnection sendDataToServerWithAction:emailSignUpAction withParameters:userDetailDictionary success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"signUpUserWithDetails --> Response %@",response);
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            // Finished with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            // Finished with no error
            NSDictionary *userProfileResponse = [response objectForKey:kUserDetails];
            if(DEBUGGING) NSLog(@"User Profile Response after filter %@",userProfileResponse);
            success(userProfileResponse);
        }
    } failure:^(NSString *response) {
        [KCProgressIndicator hideActivityIndicator];
        failed(AppLabel.errorTitle,AppLabel.unexpectedErrorMessage);
    }];
}

- (void)signUpWithSocialAccount:(NSDictionary*)userDetailDictionary withCompletionHandler:(void (^)(NSDictionary *response))success failure:(void (^)(NSString *title, NSString *message, BOOL shouldMerge))failed {
    //Register or login a user using social account ie: Twitter and Facebook
    KCWebConnection *webConnection = [[KCWebConnection alloc] init];
    [KCProgressIndicator showProgressIndicatortWithText:AppLabel.activityLoggigngInWithFacebook];
    [webConnection sendDataToServerWithAction:socialSignUpAction withParameters:userDetailDictionary success:^(NSDictionary *response) {
        BOOL status = [self isFinishedWithError:response];
        if(DEBUGGING) NSLog(@"signUpWithSocialAccount --> Response %@",response);
        [KCProgressIndicator hideActivityIndicator];
        if(status) {
            //Finished with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title               = [errorDictionary objectForKey:kTitle];
            NSString *message             = [errorDictionary objectForKey:kMessage];
            NSString *errorDetail         = [errorDictionary objectForKey:kErrorDetails];
            if([errorDetail isEqualToString:kSocialAccountType]) {
               failed(title,message,YES);
            }
            else {
               failed(title,message,NO);
            }
        }
        else {
            //Finished with no error
            success(response);
        }
    } failure:^(NSString *response) {
        failed(AppLabel.errorTitle,AppLabel.unexpectedErrorMessage,NO);
        [KCProgressIndicator hideActivityIndicator];
    }];
}

- (void) mergeSocialAccount:(NSDictionary*)userDetailDictionary withCompletionHandler:(void (^)(NSDictionary *))success failure:(void (^)(NSString *title, NSString *message))failed {
    //Merge social account with user's Keychn account
    KCWebConnection *webConnection = [[KCWebConnection alloc] init];
    [KCProgressIndicator showProgressIndicatortWithText:AppLabel.activityMergingFacebookAccount];
    [webConnection sendDataToServerWithAction:mergeSocialAccountAction withParameters:userDetailDictionary success:^(NSDictionary *response) {
        BOOL status = [self isFinishedWithError:response];
        [KCProgressIndicator hideActivityIndicator];
        if(status) {
            //Finished with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            //Finished with no error
            success(response);
        }
    } failure:^(NSString *response) {
        [KCProgressIndicator hideActivityIndicator];
        failed(AppLabel.errorTitle,AppLabel.unexpectedErrorMessage);
    }];
}

- (void) linkFacebookAccount:(NSDictionary*)userDetailDictionary withCompletionHandler:(void (^)(NSDictionary *))success failure:(void (^)(NSString *title, NSString *message))failed {
    // Link Facebook account with user's Keychn account
    KCWebConnection *webConnection = [[KCWebConnection alloc] init];
    [KCProgressIndicator showProgressIndicatortWithText:AppLabel.activityMergingFacebookAccount];
    [webConnection sendDataToServerWithAction:linkFacebookAccountAction withParameters:userDetailDictionary success:^(NSDictionary *response) {
        BOOL status = [self isFinishedWithError:response];
        [KCProgressIndicator hideActivityIndicator];
        if(status) {
            //Finished with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            //Finished with no error
            if(DEBUGGING) NSLog(@"Linking facebook account with response %@",response);
            success(response);
        }
    } failure:^(NSString *response) {
        [KCProgressIndicator hideActivityIndicator];
        failed(AppLabel.errorTitle,AppLabel.unexpectedErrorMessage);
    }];
}

- (void) changeStatusForFacebookAccountWithParameters:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *))success failure:(void (^)(NSString *title, NSString *message))failed {
    // Mark facebook account active/inactive
    KCWebConnection *webConnection = [[KCWebConnection alloc] init];
    [webConnection sendDataToServerWithAction:updateSocialAccountAction withParameters:parameters success:^(NSDictionary *response) {
        BOOL status = [self isFinishedWithError:response];
        [KCProgressIndicator hideActivityIndicator];
        if(status) {
            //Finished with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            //Finished with no error
            success(response);
        }
    } failure:^(NSString *response) {
        [KCProgressIndicator hideActivityIndicator];
        failed(AppLabel.errorTitle,AppLabel.unexpectedErrorMessage);
    }];
}

- (void) logOutUserWithParameters:(NSDictionary*)parameters CompletinHandler:(void(^)(BOOL status))loggedOut {
    // Log out user from Server session so that he won't receive notifications after loggin out
    KCWebConnection *webConnection = [[KCWebConnection alloc] init];
    [webConnection sendDataToServerWithAction:logOutUserAction withParameters:parameters success:^(NSDictionary *response) {
        loggedOut(YES);
    } failure:^(NSString *response) {
        loggedOut(NO);
    }];
}

- (BOOL) isFinishedWithError:(NSDictionary*)responseDictionary {
    //Verify that the server returns some error
    if(responseDictionary) {
        NSString *status = [responseDictionary objectForKey:kStatus];
        return [status isEqualToString:kErrorCode];
    }
    return YES;
}



@end
