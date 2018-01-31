//
//  KCItemDetail.h
//  Keychn
//
//  Created by Keychn Experience SL on 01/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCItemIngredient.h"
#import "KCItemRecipeStep.h"

@interface KCItemDetail : NSObject

//Item Ingredient List
@property (nonatomic,strong) NSMutableArray *itemIngredientArray;
//Item Recipe Steps
@property (nonatomic,strong) NSMutableArray *itemRecipeStepArray;
//Item Details
@property (nonatomic,copy) NSString *difficulty;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imageURL;
@property (nonatomic,copy) NSNumber *servings;
@property (nonatomic,copy) NSNumber *ratings;
@property (nonatomic,copy) NSNumber *duration;
@property (nonatomic,copy) NSNumber *itemIdentifier;
@property (nonatomic,copy) NSNumber *menuIdentifier;
@property (nonatomic,copy) NSNumber *courseIdentifier;
@property (nonatomic,copy) NSNumber *likeCounter;
@property (nonatomic,copy) NSNumber *cookCounter;
@property                  BOOL     receipeVisibility;
@property                  BOOL     isItemFavorite;
@property                  NSInteger popUpDuration;
@property                  BOOL     isMenuPreferencesOn;
@property                  BOOL     isCoursePreferencesOn;
@property                  BOOL     isLanguagePreferencesOn;

/**
 @abstract This method will prepare Item details dictionary from server response
 @param Response Dictionary
 @return
 */
- (void) getModelFromDictionary:(NSDictionary*)responseDictionary;

@end
