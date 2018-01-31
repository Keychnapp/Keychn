//
//  KCSearchResult.m
//  Keychn
//
//  Created by Keychn Experience SL on 07/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCSearchResult.h"

@implementation KCSearchResult

- (instancetype)initWithResponse:(NSDictionary*)response {
    // Prepare model from server response
    self = [super init];
    if(self) {
        self.itemsByRecipeArray     = [[NSMutableArray alloc] init];
        self.itemsByIngredientArray = [[NSMutableArray alloc] init];
//        self.itemsByCategoriesArray = [[NSMutableArray alloc] init];
        NSMutableArray *itemIdArray = [[NSMutableArray alloc] init];
        // Parse server response
        
        // For recipes (Menu) list
        NSArray *recipesArray = [response objectForKey:kMenuDetails];
        if([recipesArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *itemDetails in recipesArray) {
                KCItem *item = [KCItem new];
                [item getModelFromDictionary:itemDetails];
                [self.itemsByRecipeArray addObject:item];
                [itemIdArray addObject:item.itemIdentifier];
            }
        }
        
        // For ingredient list
        NSArray *ingredientArray = [response objectForKey:kIngredientDetails];
        if([ingredientArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *itemDetails in ingredientArray) {
                NSNumber *itemId = [itemDetails objectForKey:kItemID];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.integerValue == %d",itemId.integerValue];
                BOOL canAddItenm   = [itemIdArray filteredArrayUsingPredicate:predicate].count == 0;
                if(canAddItenm) {
                    KCItem *item = [KCItem new];
                    [item getModelFromDictionary:itemDetails];
                    [self.itemsByIngredientArray addObject:item];
                }
            }
        }
        
       /* // For categories list
        NSArray *categoriesArray = [response objectForKey:kItemDetails];
        if([categoriesArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *itemDetails in categoriesArray) {
                KCItem *item = [KCItem new];
                [item getModelFromDictionary:itemDetails];
                [self.itemsByCategoriesArray addObject:item];
            }
        } */
        
    }
    return self;
}

@end
