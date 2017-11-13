//
//  KCMyPreferecnceWebManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 11/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCMyPreferecnceWebManager.h"

@implementation KCMyPreferecnceWebManager

- (void)getMyPreferencesWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Fetch my preferences data from server
    [self sendDataToServerWithAction:fetchMyPreferencesAction withParameters:parameters success:^(NSDictionary *response) {
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
            //User Preferences fetched
            if(DEBUGGING) NSLog(@"My Preferences fetched %@",response);
            NSNumber *userCredits = [response objectForKey:kCredit];
            KCUserProfile *userProfile = [KCUserProfile sharedInstance];
            [userProfile updateKeychnPoints:userCredits];
            success(response);
        }
    } failure:^(NSString *response) {
        if(DEBUGGING) NSLog(@"Failed with response %@",response);
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

- (void) getRecentRecipeListWithParameters:(NSDictionary*)params withCompletionHandler:(void(^)(NSArray *itemsArray, NSNumber *totalPages, NSNumber *pageIndex))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Get recently cooked recipes from server
    [self sendDataToServerWithAction:getRecentRecipesAction withParameters:params success:^(NSDictionary *response) {
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
            //User recently cooked recipes fetched
            if(DEBUGGING) NSLog(@"Recently cooked recipes fetch %@",response);
            NSArray  *recentRecipeArray = [response objectForKey:kCookedDetails];
            NSNumber *pageIndex         = [response objectForKey:kPageIndex];
            NSNumber *totalPages        = [response objectForKey:kTotalPages];
            success(recentRecipeArray, totalPages, pageIndex);
        }
    } failure:^(NSString *response) {
        if(DEBUGGING) NSLog(@"Failed with response %@",response);
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

@end
