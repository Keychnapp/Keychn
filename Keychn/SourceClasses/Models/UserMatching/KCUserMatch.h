//
//  KCUserMatch.h
//  Keychn
//
//  Created by Keychn Experience SL on 16/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCUserMatch : NSObject

/**
 @abstract This method will prepare model from the response dictionary
 @param Response Dictionary
 @return void
 */
- (void) getModelFromDictionary:(NSDictionary*)responseDictionary;

@property (nonatomic,copy) NSNumber *scheduleID;
@property (nonatomic,copy) NSString *conferenceID;
@property (nonatomic,copy) NSString *otherUsername;
@property (nonatomic,copy) NSNumber *otherUserID;
@property (nonatomic,copy) NSString *otherUserEmailID;
@property                  BOOL isMatched;
@property                  BOOL isUserBusy;

@end
