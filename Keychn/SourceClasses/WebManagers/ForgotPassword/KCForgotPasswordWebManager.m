//
//  KCForgotPasswordWebManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 07/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCForgotPasswordWebManager.h"
#include "KCWebConnection.h"

@implementation KCForgotPasswordWebManager

- (void) requestNewPasswordWithDetails:(NSDictionary*)params withCompletionHandler:(void(^)(NSDictionary *userProfile))success failure:(void (^)(NSString *title, NSString *message))failed {
//    Request a new password from server
    KCWebConnection *webConnection = [[KCWebConnection alloc] init];
    [webConnection sendDataToServerWithAction:forgotPasswordAction withParameters:params success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"Requesting New password --> Response %@",response);
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //finished with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            //finished with no error
            success(response);
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

@end
