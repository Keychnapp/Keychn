//
//  KCUserScheduleDBManager.m
//  Keychn
//
//  Created by Keychn Experience SL on 08/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCUserScheduleDBManager.h"
#import "KCDatabaseOperation.h"
#import "KCMySchedule.h"
#import "EventStore.h"
#import <UserNotifications/UserNotifications.h>

#define kMaxBufferTimeForCall 3600 // 60 Minutes to join

@interface KCUserScheduleDBManager() {
    EventStore  *_eventStore;
}
@end

@implementation KCUserScheduleDBManager

- (void)saveUserScheduleWithResponse:(NSDictionary *)response {
    // Save user scheules in local database
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    IOSDevices          deviceType   = [KCUtility getiOSDeviceType];
    _eventStore                      = [EventStore sharedInstance];
    if(response && [response isKindOfClass:[NSDictionary class]]) {
        @autoreleasepool {
            
            // Save group session i.e. MasterClass
            NSArray *groupSessionScheduleArray = [response objectForKey:kGroupSession];
            if(groupSessionScheduleArray && [groupSessionScheduleArray isKindOfClass:[NSArray class]] && [groupSessionScheduleArray count] > 0) {
                for (NSDictionary *groupSessionDictoinary in groupSessionScheduleArray) {
                    NSNumber *sessionID    = [groupSessionDictoinary objectForKey:kMasterClassID];
                    NSString *scheduleDate = [groupSessionDictoinary objectForKey:kScheduleDate];
                    NSString *sessionType  = [groupSessionDictoinary objectForKey:kMasterClassType];
                    NSString *conferenceID = [groupSessionDictoinary objectForKey:kConferenceID];
                    NSString *userID       = [groupSessionDictoinary objectForKey:kUserID];
                    NSTimeInterval timeInterval = [NSDate getSecondsFromDate:scheduleDate] + [NSDate getGMTOffSet];
                    NSNumber *isHosting     = [groupSessionDictoinary objectForKey:kIsHosting];
                    NSString *hostName      = [groupSessionDictoinary objectForKey:kOtherUsername];
                    NSNumber *isSelected    = [groupSessionDictoinary objectForKey:kIsSelected];
                    NSNumber *isListner     = [groupSessionDictoinary objectForKey:kIsListner];
                    NSString *status        = kOpenStatus;
                    NSString *imageURL       = nil;
                    // Image URL for iPhone and iPad are diffrent
                    if(deviceType == iPad) {
                        imageURL = [groupSessionDictoinary objectForKey:kImageURLiPad];
                    }
                    else {
                        imageURL = [groupSessionDictoinary objectForKey:kImageURLiPhone];
                    }
                    if([isSelected boolValue] == YES) {
                        // Schedule a local notification for Masterclass and Chew/It Session
                        status              = kMatchStatus;
                    }
                    sessionType = masterClassLabel;
                    
                    KCMySchedule *mySchedule = [self scheduleWithIdentifier:sessionID];
                    if (mySchedule) {
                        // Update user schedule if the time is updated
                        if (mySchedule.scheduleDate != timeInterval) {
                            // Update the iCalendar event and Reschedule notitificaion
                            [self rescheduleLocalNotificationWithTimeInterval:timeInterval scheduleId:sessionID andMasterchefName:hostName chefUserId:userID conferenceId:conferenceID isHostingMasterclass:[isHosting boolValue]];
                            if ([NSString validateString:mySchedule.eventId]) {
                                // Edit event
                                mySchedule.eventId =  [_eventStore editEvent:mySchedule.eventId withTimeInterval:timeInterval andChefName:hostName];
                            }
                            else {
                                // Create event
                                [_eventStore addEventWithTimerInterval:timeInterval chefName:hostName];
                            }
                        }
                        
                        // Update user data
                        NSString *updateQuery  = [NSString stringWithFormat:@"UPDATE user_schedule SET schedule_date = '%f', item_name = '%@', image_url = '%@', conference_id = '%@', second_user_name = '%@', is_hosting = '%@', status = '%@', second_user_id = '%@', event_id = '%@', is_listener = '%@' WHERE schedule_id = %@",timeInterval, sessionType, imageURL, conferenceID, hostName, isHosting, status, userID, mySchedule.eventId, isListner, sessionID];
                        [dbOperation executeSQLQuery:updateQuery];
                    }
                    else {
                        // Schedule a local notifaction for this Masterclass
                        [self scheduleMasterclassWithTimeInterval:timeInterval scheduleId:sessionID andMasterchefName:hostName chefUserId:userID conferenceId:conferenceID isHostingMasterclass:[isHosting boolValue]];
                        
                        // Create calendar event
                        NSString *eventIdentifier = [_eventStore addEventWithTimerInterval:timeInterval chefName:hostName];
                        
                        // SQL Insertion
                        NSString *insertQuery  = [NSString stringWithFormat:@"INSERT INTO user_schedule (schedule_date, item_name, image_url, schedule_id, conference_id, second_user_name, is_hosting, status, second_user_id, event_id, is_listener) VALUES ('%f', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')",timeInterval, sessionType, imageURL, sessionID, conferenceID, hostName, isHosting, status, userID, eventIdentifier, isListner];
                        [dbOperation executeSQLQuery:insertQuery];
                    }
                }
            }
        }
    }
}

- (NSArray*)getUserSchedules {
    // Get all user schedules from local database
    KCDatabaseOperation *dbOperation    = [KCDatabaseOperation sharedInstance];
    NSTimeInterval  currentTimeInterval = [[NSDate date] timeIntervalSince1970] - kMaxBufferTimeForCall;
    NSString *orderbyClause             = [NSString stringWithFormat:@"WHERE schedule_date >= %f ORDER BY schedule_date", currentTimeInterval];
    NSArray *userScheduleArray          = [dbOperation fetchDataInUTFStringFormatFromTable:@"user_schedule" withClause:orderbyClause];
    return userScheduleArray;
}

- (KCMySchedule*)scheduleWithIdentifier:(NSNumber *)identifier {
    KCDatabaseOperation *dbOperation    = [KCDatabaseOperation sharedInstance];
    NSString *whereClause               = [NSString stringWithFormat:@"WHERE schedule_id = %@", identifier];
    NSArray *userScheduleArray          = [dbOperation fetchDataInUTFStringFormatFromTable:@"user_schedule" withClause:whereClause];
    if(userScheduleArray.count > 0) {
        KCMySchedule *mySchedule            = [[KCMySchedule alloc] initWithResponse:userScheduleArray.firstObject];
        return mySchedule;
    }
    return nil;
}

- (NSTimeInterval)getNextInteractionSchedule {
    // Get latest schedules
    KCDatabaseOperation *dbOperation    = [KCDatabaseOperation sharedInstance] ;
    NSTimeInterval  currentTimeStamp    = [[NSDate date] timeIntervalSince1970] - kMaxBufferTimeForCall;
    NSString *orderbyClause             = [NSString stringWithFormat:@"WHERE schedule_date > %f ORDER BY schedule_date limit 1", currentTimeStamp];
    NSArray *userScheduleArray          = [dbOperation fetchColumnDataFromTable:@"user_schedule" andColumnName:@"schedule_date" withClause:orderbyClause];
    if(userScheduleArray && [userScheduleArray count] > 0) {
        //Return the first schedule timestamp
        NSString *scheduleTimestamp = [userScheduleArray objectAtIndex:0];
        return [scheduleTimestamp doubleValue];
    }
    return 0;
}

- (KCMySchedule*)getNextInteraction {
    // Get latest schedules
    KCDatabaseOperation *dbOperation    = [KCDatabaseOperation sharedInstance] ;
    NSTimeInterval  currentTimeStamp    = [[NSDate date] timeIntervalSince1970] - kMaxBufferTimeForCall;
    NSString *clause                    = [NSString stringWithFormat:@"WHERE schedule_date > %f ORDER BY schedule_date limit 1", currentTimeStamp];
    NSArray *userScheduleArray          = [dbOperation fetchDataFromTable:@"user_schedule" withClause:clause];
    if(userScheduleArray && [userScheduleArray count] > 0) {
        //Return the first schedule
        NSDictionary *userScheduleDictionary  = [userScheduleArray objectAtIndex:0];
        KCMySchedule *mySchedule = [[KCMySchedule alloc] initWithResponse:userScheduleDictionary];
        return mySchedule;
    }
    return nil;
}

- (void)deleteAllUserSchedules {
    // Cancel all Events
    [_eventStore removeAllEvents];
    
    // Delete all schedules from local database
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *deleteQuery = @"DELETE FROM user_schedule WHERE 1";
    [dbOperation executeSQLQuery:deleteQuery];
    
    // Delete all scheduled local notifications
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];
}

- (void)deleteUserSchedule:(KCMySchedule*)schedule {
    // Delete user schedule with schedule id
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM user_schedule WHERE schedule_id = '%@'",schedule.scheduleID];
    [dbOperation executeSQLQuery:deleteQuery];
    
    // Remove notification with Schedule Id
    [self cancelLocalNotificationWithScheduleId:schedule.scheduleID];
    
    // Cancel iCalendar event
    _eventStore = [EventStore sharedInstance];
    [_eventStore removeEventWithIdentifier:schedule.eventId];
}

- (void)setUnreadCount:(NSInteger)value forScheduleID:(NSNumber*)scheduleID {
    // Set unread count for the schedule id
    NSString *query = [NSString stringWithFormat:@"UPDATE user_schedule SET unread_count='%@' WHERE schedule_id='%@'", [NSNumber numberWithInteger:value], scheduleID];
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    [dbOperation executeSQLQuery:query];
}

- (void)cancelLocalNotificationWithScheduleId:(NSNumber *)scheduleId {
    // Cancel masterclass local notification
    UNUserNotificationCenter *center            = [UNUserNotificationCenter currentNotificationCenter];
    __block NSNumber *sessionId                 = scheduleId;
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * requests) {
        NSMutableArray *identifiers = [[NSMutableArray alloc] init];
        for (UNNotificationRequest *request in requests) {
            NSDictionary *userInfoDictionary = request.content.userInfo;
            if(userInfoDictionary) {
                NSNumber *identifier = [userInfoDictionary objectForKey:kScheduleID];
                if(identifier.integerValue == sessionId.integerValue) {
                    // Add notification identifer to the array to cancel this notification
                    [identifiers addObject:request.identifier];
                }
            }
        }
        
        // Cancel local notification
        if(identifiers.count > 0) {
            [center removePendingNotificationRequestsWithIdentifiers:identifiers];
        }
    }];
}

- (void)rescheduleLocalNotificationWithTimeInterval:(NSTimeInterval)timeinterval scheduleId:(NSNumber *)scheduleId andMasterchefName:(NSString *)name chefUserId:(NSString *)chefUserId conferenceId:(NSString *)conferenceId isHostingMasterclass:(BOOL)isHosting {
    // Cancel Masterclass Local Notificaion
    UNUserNotificationCenter *center            = [UNUserNotificationCenter currentNotificationCenter];
    __block NSNumber *sessionId                 = scheduleId;
    __block NSTimeInterval sessionTimerInteval  = timeinterval;
    __block NSString *chefName                  = name;
    __block BOOL isHostingMasterclass           = isHosting;
    __block NSString *userId                    = chefUserId;
    __block NSString *keychnConferenceId        = conferenceId;
    __weak id weakSelf = self;
     [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * requests) {
         NSMutableArray *identifiers = [[NSMutableArray alloc] init];
         for (UNNotificationRequest *request in requests) {
             NSDictionary *userInfoDictionary = request.content.userInfo;
             if(userInfoDictionary) {
                 NSNumber *identifier = [userInfoDictionary objectForKey:kScheduleID];
                 if(identifier.integerValue == sessionId.integerValue) {
                     // Add notification identifer to the array to cancel this notification
                     [identifiers addObject:request.identifier];
                 }
             }
         }
         
         // Cancel local notification
         if(identifiers.count > 0) {
             [center removePendingNotificationRequestsWithIdentifiers:identifiers];
         }
         // Reschedule Masterclass
         [weakSelf scheduleMasterclassWithTimeInterval:sessionTimerInteval scheduleId:sessionId andMasterchefName:chefName chefUserId:userId conferenceId:keychnConferenceId isHostingMasterclass:isHostingMasterclass];
     }];
}

- (void)scheduleMasterclassWithTimeInterval:(NSTimeInterval)timeinterval scheduleId:(NSNumber *)scheduleId andMasterchefName:(NSString *)name chefUserId:(NSString *)chefUserId conferenceId:(NSString *)conferenceId isHostingMasterclass:(BOOL)isHosting {
    
    // Conference id, host name, schedule id, chef_user_id, isHosting
    
    // Notification for 20 minutes prior to the Masterclass
    
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title     = [NSString localizedUserNotificationStringForKey:@"Ready for Masterclass" arguments:nil];
    content.userInfo  = @{kScheduleID:scheduleId, kUserID:chefUserId, kConferenceID:conferenceId, kMasterChefName: name, kIsHosting:[NSNumber numberWithBool:isHosting]};
    NSString *message = [NSString stringWithFormat:@"%@ is preparing for your class! Don’t forget to attend in 20 mins!", name];
    if(isHosting) {
        message       = [NSString stringWithFormat:@"All the best %@! Your Masterclass is scheduled in 20 minutes.", name];
    }
    content.body      = message;
    
    NSTimeInterval offsetTime = 1200; // (In Seconds) Notification will be fired 20 minutes before schedule
    NSTimeInterval scheduleInetval  = timeinterval - offsetTime - [[NSDate date] timeIntervalSince1970];
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    if(scheduleInetval > 0) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:scheduleInetval  repeats:NO];
        
        // Create the request object.
        UNNotificationRequest* request = [UNNotificationRequest
                                          requestWithIdentifier:beforeMasteclass content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    
    // Notification for when Masterclass has started
    UNMutableNotificationContent *masterclassContent = [[UNMutableNotificationContent alloc] init];
    masterclassContent.title     = [NSString localizedUserNotificationStringForKey:@"Ready for Masterclass" arguments:nil];
    masterclassContent.userInfo  = @{kScheduleID:scheduleId, kUserID:chefUserId, kConferenceID:conferenceId, kMasterChefName: name, kIsHosting:[NSNumber numberWithBool:isHosting], kScheduleDate:[NSNumber numberWithDouble:timeinterval]};
    masterclassContent.categoryIdentifier = joinActionCategory;
    NSString *masterclassMessage = [NSString stringWithFormat:@"%@ is waiting for you. Start Your Masterclass Now!.", name];
    if(isHosting) {
        masterclassMessage       = [NSString stringWithFormat:@"Hey %@, all the Starcooks are waiting for you. Start Your Masterclass Now!", name];
    }
    masterclassContent.body      = masterclassMessage;
    
    timeinterval              = timeinterval - [[NSDate date] timeIntervalSince1970];
    if(timeinterval > 0) {
        UNTimeIntervalNotificationTrigger *masterclassTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeinterval  repeats:NO];
        
        
        // Create the request object.
        UNNotificationRequest *masterClassrequest = [UNNotificationRequest
                                                     requestWithIdentifier:joinMasteclass content:masterclassContent trigger:masterclassTrigger];
        [center addNotificationRequest:masterClassrequest withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
}

@end
