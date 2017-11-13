//
//  KCSearchResult.h
//  Keychn
//
//  Created by Keychn Experience SL on 07/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCItem.h"

@interface KCSearchResult : NSObject

/**
 @abstract This method will prepare Search Result Model from server response
 @param NSDictionary as response
 @return Instance Type
 */
- (instancetype)initWithResponse:(NSDictionary*)response;

@property (nonatomic,strong) NSMutableArray *itemsByIngredientArray;
@property (nonatomic,strong) NSMutableArray *itemsByRecipeArray;
@property (nonatomic,strong) NSMutableArray *itemsByCategoriesArray;

@end
