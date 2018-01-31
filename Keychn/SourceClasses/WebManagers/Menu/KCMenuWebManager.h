//
//  KCMenuWebManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 15/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCWebConnection.h"

@interface KCMenuWebManager : KCWebConnection

/**
 @abstract This method will fetch menus from the server async.
 @param Parameters, Completion Blocks
 @return void
*/
- (void)getMenusListWithParameters:(NSDictionary*)params withCompletionHandler:(void(^)(NSArray *menusArray, NSNumber *totalPages, NSNumber *pageIndex))success andFailure:(void(^)(NSString *title, NSString *message))failed;


/**
 @abstract This method will fetch menu items from the server async.
 @param Parameters, Completion Blocks
 @return void
 */
- (void)getMenuItemsListWithParameters:(NSDictionary*)params withCompletionHandler:(void(^)(NSArray *itemsListArray, NSNumber *totalPages, NSNumber *pageIndex, NSString *menuImageURL, NSArray *courseList))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will fetch item details from server async.
 @param Parameters, Completion Blocks
 @return void
 */
- (void)getItemsDetailsWithParametres:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *itemsDetailDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed ;

/**
 @abstract This method will add items to user's favorite
 @param Parameters, Completion Blocks
 @return void
 */
- (void)addItemsToFavoriteWithParameters:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

/**
 @abstract This method will search Recipe Items on server based on user input search string
 @param User Profile and Search Text with Completion Handlers
 @return void
 */
- (void)searchItemsWithParameters:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed;

@end
