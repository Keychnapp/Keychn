//
//  KCMenuWebManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 15/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCMenuWebManager.h"
#import "KCMenu.h"
#import "KCItem.h"


@implementation KCMenuWebManager

- (void)getMenusListWithParameters:(NSDictionary*)params withCompletionHandler:(void(^)(NSArray *menusArray, NSNumber *totalPages, NSNumber *pageIndex))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    
    //fetch menus from server
    [self sendDataToServerWithAction:getMenuListAction withParameters:params success:^(NSDictionary *response) {
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
            if(DEBUGGING) NSLog(@"Menu List %@",response);
           NSArray *menuArray    = [self parseMenusWithResponseDictionary:response];
            NSNumber *pageIndex  = [response objectForKey:kPageIndex];
            NSNumber *totalPages = [response objectForKey:kTotalPages];
            success(menuArray,totalPages,pageIndex);
        }
    } failure:^(NSString *response) {
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

- (void)getMenuItemsListWithParameters:(NSDictionary*)params withCompletionHandler:(void(^)(NSArray *itemsListArray, NSNumber *totalPages, NSNumber *pageIndex , NSString *menuImageURL, NSArray *courseList))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    //fetch items list from server
    //fetch menus from server
    [self sendDataToServerWithAction:getItemsListAction withParameters:params success:^(NSDictionary *response) {
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
            if(DEBUGGING) NSLog(@"Menu Items List %@",response);
            NSArray *itemsListArray          = [self parseItemsWithResponseDictionary:response];
            NSNumber *pageIndex              = [response objectForKey:kPageIndex];
            NSNumber *totalPages             = [response objectForKey:kTotalPages];
            NSArray  *courseListArray        = [response objectForKey:kItemDetails];
            NSString *menuImageURL           = nil;
            success(itemsListArray,totalPages,pageIndex, menuImageURL,courseListArray);
        }
    } failure:^(NSString *response) {
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

- (void)getItemsDetailsWithParametres:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *itemsDetailDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    //Get items details from server with Async request
    [self sendDataToServerWithAction:getItemDetailsAction withParameters:parameters success:^(NSDictionary *response) {
        //completed with success
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //Requested completed with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            //Item details fetched
            if(DEBUGGING) NSLog(@"Items Details %@",response);
            NSDictionary *itemDetailsDictionary = [response objectForKey:kItemDetails];
            success(itemDetailsDictionary);
        }
    } failure:^(NSString *response) {
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

- (void)addItemsToFavoriteWithParameters:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    //Add items to Favorite
    [self sendDataToServerWithAction:addItemToFavoriteAction withParameters:parameters success:^(NSDictionary *response) {
        //completed with success
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //Requested completed with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            //Item details fetched
            if(DEBUGGING) NSLog(@"Items Liked Successfully %@",response);
            success(response);
        }
    } failure:^(NSString *response) {
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}

- (void)searchItemsWithParameters:(NSDictionary*)parameters withCompletionHandler:(void(^)(NSDictionary *responseDictionary))success andFailure:(void(^)(NSString *title, NSString *message))failed {
    // Search items request
    [self sendDataToServerWithAction:searchItemAction withParameters:parameters success:^(NSDictionary *response) {
        //completed with success
        BOOL status = [self isFinishedWithError:response];
        if(status) {
            //Requested completed with error
            NSDictionary *errorDictionary = [response objectForKey:kErrorDetails];
            NSString *title   = [errorDictionary objectForKey:kTitle];
            NSString *message = [errorDictionary objectForKey:kMessage];
            failed(title,message);
        }
        else {
            //Item details fetched
            if(DEBUGGING) NSLog(@"Item search completed with  %@",response);
            success(response);
        }
    } failure:^(NSString *response) {
        failed(AppLabel.errorTitle, AppLabel.unexpectedErrorMessage);
    }];
}


- (BOOL)isFinishedWithError:(NSDictionary*)responseDictionary {
    //verify that the server returns some error
    if(responseDictionary) {
        NSString *status = [responseDictionary objectForKey:kStatus];
        return [status isEqualToString:kErrorCode];
    }
    return YES;
}


- (NSArray*)parseMenusWithResponseDictionary:(NSDictionary*)response {
    //parse the response and create models of Menu
    NSMutableArray *menusArray          = [[NSMutableArray alloc] init];
    NSArray        *menuDetailsArray    = [response objectForKey:kMenuDetails];
    if(menuDetailsArray && [menuDetailsArray count] > 0) {
        for (NSDictionary *menuDictionary in menuDetailsArray) {
            KCMenu *menu = [KCMenu new];
            [menu getModelFromDictionary:menuDictionary];
            [menusArray addObject:menu];
        }
        return menusArray;
    }
    return nil;
}

- (NSArray*)parseItemsWithResponseDictionary:(NSDictionary*)response {
    //Parse the response and create models of items
    if(DEBUGGING) NSLog(@"Response for items list %@",response);
    NSArray   *itemsListArray      = [response objectForKey:kItemDetails];
    NSMutableArray *itemModelArray = [[NSMutableArray alloc] init];
    @autoreleasepool {
        for (NSDictionary *itemDictionary in itemsListArray) {
            KCItem *item = [KCItem new];
            [item getModelFromDictionary:itemDictionary];
            //Add Items to the Array
            [itemModelArray addObject:item];
        }
    }
    return itemModelArray;
}


@end
