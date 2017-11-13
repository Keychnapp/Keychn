//
//  KCStarCookWebManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 08/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCStarCookWebManager.h"
#import "KCStarcook.h"

@implementation KCStarCookWebManager

- (void)searchStarCookWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Search Starcook with name or email address
    [self sendDataToServerWithAction:searchStarcookAction withParameters:parameters success:^(NSDictionary *response) {
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
            // User fetched with response
            if(DEBUGGING) NSLog(@"Starcook search result %@",response);
            success(response);
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

- (void)sendFriendRequestWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Send friend request
    [self sendDataToServerWithAction:sendFriendRequestAction withParameters:parameters success:^(NSDictionary *response) {
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
            // Friend request sent successfully
            if(DEBUGGING) NSLog(@"Friend Request sent successfully %@",response);
            success(response);
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

- (void)getFriendListWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Get friend list from server
    [self sendDataToServerWithAction:getUserFriendAction withParameters:parameters success:^(NSDictionary *response) {
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
            // Friend list fetched successfully
            if(DEBUGGING) NSLog(@"Friend list fetched successfully %@",response);
            success(response);
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

- (void)getPendingFriendRequestWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Get pending friend request from server
    [self sendDataToServerWithAction:getPendingRequest withParameters:parameters success:^(NSDictionary *response) {
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
            // Pending request fetched
            if(DEBUGGING) NSLog(@"Pending request fetched successfully %@",response);
            success(response);
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

- (void)acceptDenyFriendRequestWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Accpet or Deny Friend Request
    [self sendDataToServerWithAction:acceptDenyRequestAction withParameters:parameters success:^(NSDictionary *response) {
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
            // Friend Request Accepted/Denied successfully
            if(DEBUGGING) NSLog(@"Friend Request Accepted/Denied successfully %@",response);
            success(response);
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

- (void)blockRemoveFriendWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Block or Remove a friend from frient list
    [self sendDataToServerWithAction:blockRemoveUserAction withParameters:parameters success:^(NSDictionary *response) {
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
            // Friend Blocked/Removed successfully
            if(DEBUGGING) NSLog(@"Friend Blocked/Removed successfully %@",response);
            success(response);
        }
        
    } failure:^(NSString *response) {
        // Network request failed
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

- (NSArray*)getStarCookModelsWithResponse:(NSArray*)responseArray {
    // Parse starcook models
    NSMutableArray *starCookModelArray = [[NSMutableArray alloc] init];
    if([responseArray isKindOfClass:[NSArray class]]) {
        @autoreleasepool {
            for (NSDictionary *starcookDictionary in responseArray) {
                KCStarcook *starCook = [[KCStarcook alloc] initWithResponse:starcookDictionary];
                [starCookModelArray addObject:starCook];
            }
        }
    }
    return starCookModelArray;
}


@end
