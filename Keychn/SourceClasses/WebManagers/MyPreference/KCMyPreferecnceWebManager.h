//
//  KCMyPreferecnceWebManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 11/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCWebConnection.h"

@interface KCMyPreferecnceWebManager : KCWebConnection

/**
 @abstract This method will fetch MyPreferences Data from server.
 @param User Profile Parameters
 @return void
 */
- (void)getMyPreferencesWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will fetch recent cooked recipes by user from server page by page.
 @param User Profile Parameters
 @return void
 */
- (void) getRecentRecipeListWithParameters:(NSDictionary*)params withCompletionHandler:(void(^)(NSArray *itemsArray, NSNumber *totalPages, NSNumber *pageIndex))success andFailure:(void(^)(NSString *title, NSString *message))failed;

- (void)getBannerImagesWithParameter:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

@end
