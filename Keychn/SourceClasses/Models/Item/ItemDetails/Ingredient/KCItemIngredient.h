//
//  KCItemIngredient.h
//  Keychn
//
//  Created by Keychn Experience SL on 01/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCItemIngredient : NSObject

@property (nonatomic,copy) NSString *ingredientTitle;
@property (nonatomic,copy) NSNumber *ingredientIdentifer;
@property (nonatomic,copy) NSString *amount;

@end
