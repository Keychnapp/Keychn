//
//  KCTutorialWebManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 18/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCTutorialWebManager.h"

@implementation KCTutorialWebManager

- (void)fetchTutorialsWithParameter:(NSDictionary*)parameters
              withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success
                         andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Fetch tutorial from server
    [self sendDataToServerWithAction:getTutorialsAction withParameters:parameters success:^(NSDictionary *response) {
        // Network request completed
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
            if(DEBUGGING) NSLog(@"Tutorials fetched %@",response);
            success(response);
        }
        
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

@end
