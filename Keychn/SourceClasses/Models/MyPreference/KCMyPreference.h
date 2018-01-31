//
//  KCMyPreference.h
//  Keychn
//
//  Created by Keychn Experience SL on 11/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCMyPreference : NSObject

/**
 @abstract This method will create an instance of MyPreference Model with server response for preferences
 @param NSDictionary Response
 @return KCMyPreference Object
 */
- (instancetype)initWithResponse:(NSDictionary*)response;

@property (nonatomic,copy) NSNumber  *credits;
@property (nonatomic,copy) NSNumber  *interactions;
@property (nonatomic,copy) NSNumber  *starCook;
@property (nonatomic,copy) NSNumber  *favorites;
@property (nonatomic,copy) NSNumber  *dishofTheWeekItemID;
@property (nonatomic,copy) NSString  *dishofTheWeekImageURL;
@property (nonatomic,copy) NSString  *dishofTheWeekItemName;

@end
