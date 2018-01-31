//
//  KCUserSchedule.h
//  Keychn
//
//  Created by Keychn on 05/09/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCUserSchedule : NSObject

/**
 @abstract Creates a model object for this class.
 @param NSDictionary Response
 @return instancetype Model object
 */
- (instancetype)initWithResponse:(NSDictionary *)response;

@property (nonatomic, copy) NSNumber *courseID;
@property (nonatomic, copy) NSNumber *itemID;
@property (nonatomic, copy) NSNumber *menuID;
@property (nonatomic, copy) NSNumber *scheduleID;
@property (nonatomic, copy) NSNumber *userID;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *eventID;
@property (nonatomic, copy) NSString *scheduleType;
@property (nonatomic, copy) NSString *scheduleDate;
@property (nonatomic, copy) NSString *imageURL;

@end
