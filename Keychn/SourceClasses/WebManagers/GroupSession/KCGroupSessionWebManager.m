//
//  KCGroupSessionWebManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 22/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCGroupSessionWebManager.h"

@implementation KCGroupSessionWebManager

- (void)getMasterClassDetailsWithParameter:(NSDictionary *)parameters withCompletionHandler:(void (^)(NSDictionary *))success andFailure:(void (^)(NSString *, NSString *))failed {
    // Fetch MasterClass Details from server
    [self sendDataToServerWithAction:getMasterClassDetailAction withParameters:parameters success:^(NSDictionary *response) {
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
            // MasterClass details fetched from server
            if(DEBUGGING) NSLog(@"MasterClass Details %@",response);
            success(response);
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)buyMasterClassSpotWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSString *title, NSString *message))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Buy a spot in MasterClass sessions
    [self sendDataToServerWithAction:bookAMasterClassSpotAction withParameters:parameters success:^(NSDictionary *response) {
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
            // MasterClass spot bought
            if(DEBUGGING) NSLog(@"MasterClass Spot bought successfully %@",response);
            success(NSLocalizedString(@"congrats", nil), NSLocalizedString(@"beReadyForMasterclass", nil));
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)getParticipantNamesWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *response))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Get Participant names from server
    [self sendDataToServerWithAction:getParcipantNamesAction withParameters:parameters success:^(NSDictionary *response) {
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
            // Retrieved particpant names
            if(DEBUGGING) NSLog(@"Retrieved particpant names %@",response);
            success(response);
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)completeGroupSessionWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSString *title, NSString *message))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Complete a Group Session on server
    [self sendDataToServerWithAction:completGroupSessionAction withParameters:parameters success:^(NSDictionary *response) {
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
            // Group session marked as complete
            if(DEBUGGING) NSLog(@"Group Session Marked as completed %@",response);
            success(NSLocalizedString(@"masterclassCompleted", nil), NSLocalizedString(@"thanksForMasterclass", nil));
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

- (void)updateGroupSessionStatusWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSString *title, NSString *message))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Update group session status for user
    [self sendDataToServerWithAction:updateGroupSessoinLog withParameters:parameters success:^(NSDictionary *response) {
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
            // Group session status updated for this user
            if(DEBUGGING) NSLog(@"Group Session Marked as completed %@",response);
            success(NSLocalizedString(@"masterclassCompleted", nil), NSLocalizedString(@"thanksForMasterclass", nil));
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(NSLocalizedString(@"networkError", nil), NSLocalizedString(@"tryReconnecting", nil));
    }];
}

@end
