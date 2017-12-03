//
//  KCUserProfileUpdateManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 06/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCUserProfileUpdateManager.h"
#import "KCWebConnection.h"
#import "KCUserProfileDBManager.h"


@implementation KCUserProfileUpdateManager

- (void) updateUserProfileWithImageData:(NSData*)fileData andParams:(NSDictionary*)params withCompletionHandler:(void(^)(NSDictionary *userProfile))success failure:(void (^)(NSString *title, NSString *message))failed {
    KCWebConnection *webConnection = [KCWebConnection new];
    [KCProgressIndicator showProgressIndicatortWithText:NSLocalizedString(@"updatingProfile", nil)];
    [webConnection sendMultipartData:params onAction:setProfileImageAction withFileData:fileData success:^(NSDictionary *response) {
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //request failed with error details
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            //request completed
            [self updateUserPrfileWithResponse:response];
            success(response);
            if(DEBUGGING) NSLog(@"Profile Picture uploaded successfully %@",response);
        }
        [KCProgressIndicator hideActivityIndicator];
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
        [KCProgressIndicator hideActivityIndicator];
    }];
}

- (void)updateUserPasswordWithParameters:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSString *title, NSString *message))success failure:(void (^)(NSString *title, NSString *message))failed {
    // Update user password on server
    KCWebConnection *webConnection = [KCWebConnection new];
    [webConnection sendDataToServerWithAction:updatePasswordAction withParameters:parameters success:^(NSDictionary *response) {
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //request completed with error details
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            //Request completed
            success(NSLocalizedString(@"resetPassword", nil), NSLocalizedString(@"passwordResetSuccessfully", nil));
            if(DEBUGGING) NSLog(@"User password updated successfully %@",response);
        }
        
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (BOOL) isFinishedWithError:(NSDictionary*)responseDictionary {
    //verify that the server returns some error
    if(responseDictionary) {
        NSString *status = [responseDictionary objectForKey:kStatus];
        return [status isEqualToString:kErrorCode];
    }
    return YES;
}

- (void) updateUserPrfileWithResponse:(NSDictionary*)response {
    KCUserProfile *userProfile = [KCUserProfile sharedInstance];
    NSString *imageURL         = [response objectForKey:kImageURL];
    userProfile.imageURL       = imageURL;
    KCUserProfileDBManager *userProfileDBManager = [KCUserProfileDBManager new];
    [userProfileDBManager updateUserProfile:userProfile];
}

@end
