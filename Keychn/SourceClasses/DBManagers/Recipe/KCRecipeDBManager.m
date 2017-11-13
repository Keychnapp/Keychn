//
//  KCRecipeDBManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 01/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCRecipeDBManager.h"
#import "KCDatabaseOperation.h"

@implementation KCRecipeDBManager

- (void)saveItemIngredientAvailability:(NSNumber*)itemIngredientID forUser:(NSNumber *)userID andItem:(NSNumber *)itemID {
    //Save Ingredient selection list
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO ingredient_selection (ingredient_id, user_id, item_id) VALUES ('%@', '%@', '%@')",itemIngredientID, userID, itemID];
    [dbOperation executeSQLQuery:insertQuery];
}

- (void) removeItemIngredientAvailability:(NSNumber*)itemIngredientID forUser:(NSNumber*)userID andItem:(NSNumber*)itemID {
    //Remove Ingredient selection list
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM ingredient_selection WHERE user_id='%@' AND item_id='%@' AND ingredient_id='%@'",userID,itemID,itemIngredientID];
    [dbOperation executeSQLQuery:deleteQuery];
}

- (NSArray *)getItmesIngredinetsArrayForUser:(NSNumber *)userID forItem:(NSNumber *)itemID {
    //Get Ingredient selectionlist
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *clause  = [NSString stringWithFormat:@"WHERE user_id = '%@' AND item_id = '%@'",userID,itemID];
    NSArray *itemIngredientSelectionArray = [dbOperation fetchColumnDataFromTable:@"ingredient_selection" andColumnName:@"ingredient_id" withClause:clause];
    return itemIngredientSelectionArray;
}

@end
