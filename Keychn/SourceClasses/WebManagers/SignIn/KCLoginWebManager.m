//
//  KCLoginWebManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 07/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCLoginWebManager.h"
#import "KCWebConnection.h"

@implementation KCLoginWebManager

- (void)signInUserWithDetails:(NSDictionary *)userDetailDictionary withCompletionHandler:(void (^)(NSDictionary *response))success failure:(void (^)(NSString *, NSString *))failed {
    //Login a user and notify with success and failure
    KCWebConnection *webConnection = [[KCWebConnection alloc] init];
    [KCProgressIndicator showProgressIndicatortWithText:AppLabel.activitySigningIn];
    [webConnection sendDataToServerWithAction:userLoginAction withParameters:userDetailDictionary success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"signInUserWithDetails --> Response %@",response);
        [KCProgressIndicator hideActivityIndicator];
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //finished with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            if(title) {
              failed(title,message);
            }
            else {
               failed(AppLabel.errorTitle,AppLabel.unexpectedErrorMessage);
            }
            
        }
        else {
            //finished with no error
            if(DEBUGGING) NSLog(@"User Profile Response Sign In %@",response);
            success(response);
        }
    } failure:^(NSString *response) {
        [KCProgressIndicator hideActivityIndicator];
        failed(AppLabel.errorTitle,AppLabel.unexpectedErrorMessage);
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

@end
