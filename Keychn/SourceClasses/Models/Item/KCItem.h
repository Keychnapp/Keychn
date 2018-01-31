//
//  KCItem.h
//  Keychn
//
//  Created by Keychn Experience SL on 19/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCItem : NSObject

@property (nonatomic,copy) NSNumber *itemIdentifier;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imageURL;
@property                  BOOL     isScheduled;
@property                  BOOL     isShown;

/**
 @abstract This method will prepare Item model from dictionary
 @param Response Dictionary
 @return void
*/
- (void) getModelFromDictionary:(NSDictionary*)responseDictionary;

@end
