//
//  KCItemDetail.m
//  Keychn
//
//  Created by Keychn Experience SL on 01/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCItemDetail.h"

@implementation KCItemDetail

- (void)getModelFromDictionary:(NSDictionary *)responseDictionary {
    
    IOSDevices deviceType = [KCUtility getiOSDeviceType];
    //Get Item details Model from Dictionary
    if(responseDictionary && [responseDictionary isKindOfClass:[NSDictionary class]]) {
        //Item details
        self.receipeVisibility = [[responseDictionary objectForKey:kRecipeVisibility] boolValue];
        self.duration          = [responseDictionary objectForKey:kDuration];
        self.servings          = [responseDictionary objectForKey:kServings];
        self.videoLink         = [responseDictionary objectForKey:@"video_link"];
        self.trailerLink       = [responseDictionary objectForKey:@"trailer_link"];
        self.itemIdentifier    = [responseDictionary objectForKey:kIdentifier];
        self.menuIdentifier    = [responseDictionary objectForKey:kMenuID];
        self.courseIdentifier  = [responseDictionary objectForKey:kCourseID];
        self.difficulty        = [responseDictionary objectForKey:kDifficulty];
        self.title             = [responseDictionary objectForKey:kLabelName];
        self.likeCounter       = [responseDictionary objectForKey:kLikeCounter];
        self.cookCounter       = [responseDictionary objectForKey:kCookedCounter];
        self.ratings           = [responseDictionary objectForKey:kItemRatings];
        self.popUpDuration     = [[responseDictionary objectForKey:kPopUpDuration] integerValue];
        if(self.popUpDuration == 0) {
            // Assign default value as 90 seconds
            self.popUpDuration = 90;
        }
        self.isItemFavorite    = [[responseDictionary objectForKey:kIsFavorite] boolValue];
       
        //Item Preferences
        self.isMenuPreferencesOn    = [[responseDictionary objectForKey:kMenuPreferences] boolValue];
        self.isCoursePreferencesOn  = [[responseDictionary objectForKey:kCoursePreferences] boolValue];
        self.isLanguagePreferencesOn = [[responseDictionary objectForKey:kLanguagePreference] boolValue];
        
        if(deviceType == iPad) {
            self.imageURL      = [responseDictionary objectForKey:kImageURLiPad];
        }
        else {
            self.imageURL      = [responseDictionary objectForKey:kImageURLiPhone];
        }
        
        //Item Ingredients
        NSArray *itemIngredientsArray = [responseDictionary objectForKey:kIngredients];
        if(itemIngredientsArray) {
            self.itemIngredientArray = [[NSMutableArray alloc] init];
            for (NSDictionary *itemIngredientDictionary in itemIngredientsArray) {
                KCItemIngredient *itemIngredient = [KCItemIngredient new];
                itemIngredient.ingredientTitle = [itemIngredientDictionary objectForKey:kLabelName];
                itemIngredient.ingredientIdentifer = [itemIngredientDictionary objectForKey:kIdentifier];
                [self.itemIngredientArray addObject:itemIngredient];
            }
        }
        
        //Recipe Steps
        NSArray *itemRecipeStepsArray = [responseDictionary objectForKey:kRecipeSteps];
        if(itemRecipeStepsArray) {
            self.itemRecipeStepArray = [[NSMutableArray alloc] init];
            for (NSDictionary *itemRecipeStepDictionary in itemRecipeStepsArray) {
                KCItemRecipeStep *itemRecipeStep = [KCItemRecipeStep new];
                itemRecipeStep.recipeStep   = [itemRecipeStepDictionary objectForKey:kLabelName];
                itemRecipeStep.stepPosition = [itemRecipeStepDictionary objectForKey:kStepPosition];
                if(deviceType == iPad) {
                    itemRecipeStep.imageURL = [itemRecipeStepDictionary objectForKey:kImageURLiPad];
                }
                else {
                    itemRecipeStep.imageURL = [itemRecipeStepDictionary objectForKey:kImageURLiPhone];
                }
                [self.itemRecipeStepArray addObject:itemRecipeStep];
            }
        }
    }
}

@end
