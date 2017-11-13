//
//  KCUserScheduleDBManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 08/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KCMySchedule;

@interface KCUserScheduleDBManager : NSObject

/**
 @abstract This method will
 @param
 @return
 */
- (void)saveUserScheduleWithResponse:(NSDictionary*)response;

/**
 @abstract This method will get all user schedules from local storage
 @param No Parameters
 @return Array of User Schedules
 */
- (NSArray*)getUserSchedules;

/**
 @abstract This method will return the first upcoming schedule for the user based on the interaction date
 @param No Parameters
 @return NSTimeInterval Timestamp for next Interaction
 */
- (NSTimeInterval)getNextInteractionSchedule;

- (KCMySchedule*)getNextInteraction;

/**
 @abstract This method will delete all user schedule from local database
 @param No Parameters
 @return void
 */
- (void)deleteAllUserSchedules;

/**
 @abstract This method will delete user schedule if user cancels the schedule
 @param Schedule
 @return void
 */
- (void)deleteUserSchedule:(KCMySchedule*)schedule;

/**
 @abstract Sets unread count to the given schedule id
 @param Unread count and Schedule ID
 @return void
 */
- (void)setUnreadCount:(NSInteger)value forScheduleID:(NSNumber*)scheduleID;

@end
