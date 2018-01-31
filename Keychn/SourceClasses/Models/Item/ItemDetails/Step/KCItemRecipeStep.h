//
//  KCItemRecipeStep.h
//  Keychn
//
//  Created by Keychn Experience SL on 01/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCItemRecipeStep : NSObject

@property (nonatomic,strong) NSNumber *stepPosition;
@property (nonatomic,strong) NSString *recipeStep;
@property (nonatomic,strong) NSString *imageURL;

@end
