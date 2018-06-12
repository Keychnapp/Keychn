//
//  KCUserSchedule.m
//  Keychn
//
//  Created by Keychn Experience SL on 05/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCUserScheduleWebManager.h"
#import "KCUserScheduleDBManager.h"

@implementation KCUserScheduleWebManager

- (void)getUserSchedulesWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    //Get user schedules from server
    [self sendDataToServerWithAction:getUserSchedulesAction withParameters:parameters success:^(NSDictionary *response) {
        //completed with success
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //requested completed with error
            if([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
                NSString *title   = [errorDictionary objectForKey:kTitle];
                NSString *message = [errorDictionary objectForKey:kMessage];
                if(DEBUGGING) NSLog(@"Failed with response %@",errorDictionary);
                failed(title,message);
            }
        }
        else {
            //User scheduled fetched
            if(DEBUGGING) NSLog(@"User schedule time slot response %@",response);
            if([response isKindOfClass:[NSDictionary class]]) {
              NSDictionary *userScheduleDictionary = [response objectForKey:kUserSchedule];
              success(userScheduleDictionary);
            }
        }
    } failure:^(NSString *response) {
        if(DEBUGGING) NSLog(@"Failed with response %@",response);
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)getUserDataWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Get user data from server (MasterClass, Chew/It session, User Interaction, MySchedule)
    //Get user schedules from server
    [self sendDataToServerWithAction:getUserDataAction withParameters:parameters success:^(NSDictionary *response) {
        //completed with success
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //requested completed with error
            if([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
                NSString *title   = [errorDictionary objectForKey:kTitle];
                NSString *message = [errorDictionary objectForKey:kMessage];
                if(DEBUGGING) NSLog(@"Failed with response %@",errorDictionary);
                failed(title,message);
            }
        }
        else {
            //User scheduled fetched
            if(DEBUGGING) NSLog(@"User Data fetched with response %@",response);
            
            // Save my schedule in local database
            if([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *mySchedules = [response objectForKey:kMySchedules];
                KCUserScheduleDBManager *userScheduleDBManager = [KCUserScheduleDBManager new];
                [userScheduleDBManager saveUserScheduleWithResponse:mySchedules];
            }
            success(response);
        }
    } failure:^(NSString *response) {
        if(DEBUGGING) NSLog(@"Failed with response %@",response);
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)getMasterClassAndScheduledCallsWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Get MasterClass and Scheduled Calls
    [self sendDataToServerWithAction:masterClassAndCallsAction withParameters:parameters success:^(NSDictionary *response) {
        //completed with success
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //requested completed with error
            if([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
                NSString *title   = [errorDictionary objectForKey:kTitle];
                NSString *message = [errorDictionary objectForKey:kMessage];
                if(DEBUGGING) NSLog(@"Failed with response %@",errorDictionary);
                failed(title,message);
            }
        }
        else {
            // User scheduled calls and MasterClasses are fetched
            if(DEBUGGING) NSLog(@"User scheduled calls and MasterClasses are fetched %@",response);
            success(response);
        }
    } failure:^(NSString *response) {
        if(DEBUGGING) NSLog(@"Failed with response %@",response);
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)getMasterClassWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Get MasterClass
    [self sendDataToServerWithAction:masterClassAction withParameters:parameters success:^(NSDictionary *response) {
        //completed with success
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //requested completed with error
            if([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
                NSString *title   = [errorDictionary objectForKey:kTitle];
                NSString *message = [errorDictionary objectForKey:kMessage];
                if(DEBUGGING) NSLog(@"Failed with response %@",errorDictionary);
                failed(title,message);
            }
        }
        else {
            // User scheduled calls and MasterClasses are fetched
            if(DEBUGGING) NSLog(@"MasterClasses fetched %@",response);
            success(response);
        }
    } failure:^(NSString *response) {
        if(DEBUGGING) NSLog(@"Failed with response %@",response);
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)getMasterClassVideoWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Get MasterClass
    [self sendDataToServerWithAction:masterClassVideoAction withParameters:parameters success:^(NSDictionary *response) {
        //completed with success
        success(response);
    } failure:^(NSString *response) {
        if(DEBUGGING) NSLog(@"Failed with response %@",response);
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)getMasterChefVideosWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Get MasterClass
    [self sendDataToServerWithAction:masterChefVideoAction withParameters:parameters success:^(NSDictionary *response) {
        //completed with success
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //requested completed with error
            if([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
                NSString *title   = [errorDictionary objectForKey:kTitle];
                NSString *message = [errorDictionary objectForKey:kMessage];
                if(DEBUGGING) NSLog(@"Failed with response %@",errorDictionary);
                failed(title,message);
            }
        }
        else {
            // User scheduled calls and MasterClasses are fetched
            if(DEBUGGING) NSLog(@"MasterClasses fetched %@",response);
            success(response);
        }
    } failure:^(NSString *response) {
        if(DEBUGGING) NSLog(@"Failed with response %@",response);
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)requestACallScheduleWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Schedule a call for the selected user's schedule
    [self sendDataToServerWithAction:scheduleACallWithUserAction withParameters:parameters success:^(NSDictionary *response) {
        // Completed with success
        if(DEBUGGING) NSLog(@"Scheduled a call %@",response);
        success(response);
    } failure:^(NSString *response) {
        if(DEBUGGING) NSLog(@"Failed with response %@",response);
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)getMySchedulesWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    //Get user schedules from server
    static BOOL isProcessing = false;
    if(isProcessing) {
        return;
    }
    isProcessing = true;
    [self sendDataToServerWithAction:getMySchedulesAction withParameters:parameters success:^(NSDictionary *response) {
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
            //User scheduled fetched
            if(DEBUGGING) NSLog(@"My Schedule fetched %@",response);
            if([response isKindOfClass:[NSDictionary class]]) {
                KCUserScheduleDBManager *userScheduleDBManager = [KCUserScheduleDBManager new];
                [userScheduleDBManager saveUserScheduleWithResponse:response];
            }
            success(response);
        }
        isProcessing = false;
    } failure:^(NSString *response) {
        isProcessing = false;
        if(DEBUGGING) NSLog(@"Failed with response %@",response);
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)refreshUseScheduleWithParameters:(NSDictionary *)parameters {
    [self getMySchedulesWithParameter:parameters withCompletionHandler:^(NSDictionary *responseDictionary) {
        //
    } andFailure:^(NSString *title, NSString *message) {
       // Request failed
    }];
}


- (void)scheduleUserCallWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    //Schedule a user for the selected day and time slot
    
    NSString *action = [parameters objectForKey:kAPIAction];
    
    [self sendDataToServerWithAction:action withParameters:parameters success:^(NSDictionary *response) {
        //completed with success
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //requested completed with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            //menus fetched
            if(DEBUGGING) NSLog(@"Schedule a call %@",response);
            success(response);
        }
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];

}

- (void)findUserForConnectionWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *))success andFailure:(void (^)(NSString *, NSString *))failed {
    //Find other user for video call connection
    
    NSString *action = [parametrs objectForKey:kAPIAction];
    
    [self sendDataToServerWithAction:action withParameters:parametrs success:^(NSDictionary *response) {
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            // Requested completed with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            // Menus fetched
            if(DEBUGGING) NSLog(@"Fetched user for connection %@",response);
            success(response);
        }
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)cancelUserSchduleWithParametes:(NSDictionary*)parameters withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed {
    // Cancel user interaction of all type, for MasterClass the amount will be refunded
    [self sendDataToServerWithAction:cancelUserScheduleAction withParameters:parameters success:^(NSDictionary *response) {
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            // Requested completed with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            if([NSString validateString:title] && [NSString validateString:message]) {
               failed(title,message);
            }
            else {
                failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
            }
            
        }
        else {
            // Menus fetched
            if(DEBUGGING) NSLog(@"User Interaction cancelled %@",response);
            success(response);
        }
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)verifyNotificationWithScheduleDate:(NSDictionary*)params withCompletionHandler:(void (^)(BOOL))validated {
    //Verify notification timestamp
    [self sendDataToServerWithAction:verifyNotificationAction withParameters:params success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"Notification validated %@",response);
        NSNumber *value = [response objectForKey:kNotificationStatus];
        if([value integerValue ] == 1) {
            validated(YES);
        }
        else {
            validated(NO);
        }
    } failure:^(NSString *response) {
        validated(NO);
    }];
}

- (void)closeConferenceWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed {
    //Close the active conference for further match
    [self sendDataToServerWithAction:closeConferenceAction withParameters:parametrs success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"Close user confernce with response %@",response);
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)reconnectUserForWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed {
    //Try reconnectin user
    [self sendDataToServerWithAction:reconnectUserAction withParameters:parametrs success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"Reconnect user with response %@",response);
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)cancelUserNowScheduleWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed {
    //Cancels user schedule for curren request
    [self sendDataToServerWithAction:cancelNowScheduleAction withParameters:parametrs success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"Cancel user now schedule %@",response);
        success(response);
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)flagUserWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed {
    //Flag user for abuse
    [self sendDataToServerWithAction:flagAUserAction withParameters:parametrs success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"User flagged %@",response);
        success(response);
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)rateAnItemWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed {
    //Rate an item based on user rating
    [self sendDataToServerWithAction:rateAnItemAction withParameters:parametrs success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"Item rating saved with response %@",response);
        success(response);
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void) saveFreeRideUserDetailWithParamaters:(NSDictionary*)parameters andImage:(UIImage*)image withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed {
    // Save Free/Ride item details on server with optional image data, if image data is not there then that means that user has already uploaded the image and then the image_url will be provided in the api request
    NSData *imageData = nil;
    if(image) {
        imageData = [UIImage compressImageInBytes:image];
    }
    [self sendMultipartData:parameters onAction:saveFreeRideDetailAction withFileData:imageData success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"Free Ride Details saved on server %@",response);
        success(response);
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)saveChewItItemAndRatingWithParameters:(NSDictionary *)parametrs withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed {
    //Rate an item based on user rating
    [self sendDataToServerWithAction:saveChewItRatingAction withParameters:parametrs success:^(NSDictionary *response) {
        if(DEBUGGING) NSLog(@"Chew/It rating saved with response %@",response);
        success(response);
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)uploadFoodImageWithParametes:(NSDictionary *)parametrs andImage:(UIImage*)clickedImage withCompletionHandler:(void (^)(NSDictionary *response))success andFailure:(void (^)(NSString *title, NSString *message))failed {
    //Upload user's image and share with another user
    NSData *imageData = UIImagePNGRepresentation(clickedImage);
    [self sendMultipartData:parametrs onAction:shareImageAction withFileData:imageData success:^(NSDictionary *response) {
        //Upload image on server successfull
        success(response);
    } failure:^(NSString *response) {
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
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
