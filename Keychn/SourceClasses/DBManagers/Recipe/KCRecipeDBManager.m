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

- (void)saveItemIngredientAvailability:(NSNumber*)itemIngredientID forUser:(NSNumber *)userID andItem:(NSNumber *)itemID isMasterclass:(BOOL)masterclass {
    //Save Ingredient selection list
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO ingredient_selection (ingredient_id, user_id, item_id, is_masterclass) VALUES ('%@', '%@', '%@', '%@')",itemIngredientID, userID, itemID, [NSNumber numberWithBool:masterclass]];
    [dbOperation executeSQLQuery:insertQuery];
}

- (void) removeItemIngredientAvailability:(NSNumber*)itemIngredientID forUser:(NSNumber*)userID andItem:(NSNumber*)itemID isMasterclass:(BOOL)masterclass {
    //Remove Ingredient selection list
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM ingredient_selection WHERE user_id='%@' AND item_id='%@' AND ingredient_id='%@' AND is_masterclass = %@",userID,itemID,itemIngredientID, [NSNumber numberWithBool:masterclass]];
    [dbOperation executeSQLQuery:deleteQuery];
}

- (NSArray *)getItmesIngredinetsArrayForUser:(NSNumber *)userID forItem:(NSNumber *)itemID isMasterclass:(BOOL)masterclass {
    //Get Ingredient selectionlist
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *clause  = [NSString stringWithFormat:@"WHERE user_id = '%@' AND item_id = '%@' AND is_masterclass = %@",userID,itemID, [NSNumber numberWithBool:masterclass]];
    NSArray *itemIngredientSelectionArray = [dbOperation fetchColumnDataFromTable:@"ingredient_selection" andColumnName:@"ingredient_id" withClause:clause];
    return itemIngredientSelectionArray;
}

@end
