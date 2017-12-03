//
//  KCContactUsWebManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 16/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCContactUsWebManager.h"


@implementation KCContactUsWebManager

- (void)submitQueryWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Sumbit a query to web admin
    [self sendDataToServerWithAction:submitAQueryAction withParameters:parameters success:^(NSDictionary *response) {
        //Completed with success
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //Requested completed with error
            if([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
                NSString *title   = [errorDictionary objectForKey:kTitle];
                NSString *message = [errorDictionary objectForKey:kMessage];
                if(DEBUGGING) NSLog(@"Failed with response %@",errorDictionary);
                failed(title,message);
            }
        }
        else {
            // Query submitted successfully
            if(DEBUGGING) NSLog(@"Query submitted successfully %@",response);
            success(response);
        }
        
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

@end
