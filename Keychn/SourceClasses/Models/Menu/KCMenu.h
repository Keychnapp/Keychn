//
//  KCMenu.h
//  Keychn
//
//  Created by Keychn Experience SL on 15/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCMenu : NSObject

/**
 @abstract This method will prepare model from dictionary
 @param Response
 @return void
*/
- (void) getModelFromDictionary:(NSDictionary*)responseDictionary;

@property (nonatomic,copy)  NSString *title;
@property (nonatomic,copy)  NSString *imageURL;
@property (nonatomic,copy)  NSString *menuIdentfier;
@property (nonatomic,copy)  NSString *createdDate;
@property                   BOOL     isShown;
@property NSInteger         labelWidth;

@end
