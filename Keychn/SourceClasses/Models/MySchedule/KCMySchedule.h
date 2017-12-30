//
//  KCMySchedule.h
//  Keychn
//
//  Created by Keychn Experience SL on 04/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCMySchedule : NSObject

@property                  NSTimeInterval scheduleDate;
@property (nonatomic,copy) NSString *itemName;
@property (nonatomic,copy) NSString *itemImageURL;
@property (nonatomic,copy) NSNumber *secondUserID;
@property (nonatomic,copy) NSString *secondUsername;
@property (nonatomic,copy) NSString *conferenceID;
@property                  BOOL     isOpen;
@property                  BOOL     isHosting;
@property (nonatomic,copy) NSNumber *itemID;
@property (nonatomic,copy) NSNumber *scheduleID;
@property (nonatomic,copy) NSNumber *unreadCount;
@property (nonatomic, copy) NSString *eventId;
@property                  BOOL     isListner;

@property RecipeType                recipeType;

/**
 @abstract This method will prepare models from array
 @param Array that conists table rows in form of dictionary
 @return NSArray - Arrays of MySchedule model instance
 */
- (NSArray*)getModelsFromArray:(NSArray*)myScheduleArray;

- (instancetype)initWithResponse:(NSDictionary *)response;


@end
