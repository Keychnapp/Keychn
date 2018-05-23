//
//  KCRecipeDBManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 01/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCRecipeDBManager : NSObject

/**
 @abstract This method will save item ingredients selection list for user
 @param Item Ingredient, Item ID and User ID
 @return void
*/
- (void) saveItemIngredientAvailability:(NSNumber*)itemIngredientID forUser:(NSNumber*)userID andItem:(NSNumber*)itemID isMasterclass:(BOOL)masterclass;

/**
 @abstract This method will remove item ingredients selection list for user
 @param Item Ingredient, Item ID and User ID
 @return void
 */
- (void) removeItemIngredientAvailability:(NSNumber*)itemIngredientID forUser:(NSNumber*)userID andItem:(NSNumber*)itemID isMasterclass:(BOOL)masterclass;


/**
 @abstract This method will get item ingredients selection list for user
 @param User ID and Item ID
 @return Ingredient Selection List
 */
- (NSArray*) getItmesIngredinetsArrayForUser:(NSNumber*)userID forItem:(NSNumber*)itemID isMasterclass:(BOOL)masterclass;

@end
