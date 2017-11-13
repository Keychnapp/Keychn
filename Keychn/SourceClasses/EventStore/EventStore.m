//
//  EventStore.m
//  Keychn
//
//  Created by Rohit Kumar on 02/11/2017.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "EventStore.h"
#import <EventKit/EventKit.h>
#import "KCDatabaseOperation.h"

@implementation EventStore

+ (instancetype)sharedInstance {
    static EventStore *eventStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        eventStore = [EventStore new];
        eventStore.store = [EKEventStore new];
    });
    return eventStore;
}

- (NSString*)addEventWithTimerInterval:(NSTimeInterval)timeInterval chefName:(NSString *)chefName {
    // Create iCalendar events and return with event id
    NSDate *startDate   = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDate *endDate     = [startDate dateByAddingTimeInterval:3600];  //set 1 hour meeting
    NSPredicate *predicate = [self.store predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    NSArray *theEvents = [self.store eventsMatchingPredicate:predicate];
    if(theEvents.count > 0) {
        EKEvent *lastEvent = theEvents.lastObject;
        return lastEvent.eventIdentifier;
    }
    EKEvent *event  = [EKEvent eventWithEventStore:self.store];
    event.title     = [NSString stringWithFormat:@"Masterclass with %@", chefName];
    event.startDate = startDate;
    event.endDate   = endDate;
    event.calendar  = [self.store defaultCalendarForNewEvents];
    NSError *err    = nil;
    [self.store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
    return event.eventIdentifier;
}

- (NSString*)editEvent:(NSString*)eventid withTimeInterval:(NSTimeInterval)timeInterval andChefName:(NSString *)chefName {
    // Edit iCalenar event
    EKEvent *event  = [self.store eventWithIdentifier:eventid];
    if(!event) {
        // If event is deleted by user then recreate it
        NSString *eventIdenifier =  [self addEventWithTimerInterval:timeInterval chefName:chefName];
        return eventIdenifier;
    }
    event.startDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    event.endDate   = [event.startDate dateByAddingTimeInterval:3600];  //set 1 hour meeting;
    event.calendar  = [self.store defaultCalendarForNewEvents];
    NSError *err    = nil;
    [self.store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
    return event.eventIdentifier;
}

- (void)askPermissionForEvent {
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        
    }];
}

- (void)removeEventWithIdentifier:(NSString *)eventIdentifier {
    // Remove iCalendar Event
    EKEventStore* store = [EKEventStore new];
    EKEvent* eventToRemove = [store eventWithIdentifier:eventIdentifier];
    if (eventToRemove) {
        NSError* error = nil;
        [store removeEvent:eventToRemove span:EKSpanFutureEvents commit:YES error:&error];
    }
}

- (void)removeAllEvents {
    // Remove iCalendar Events
    KCDatabaseOperation *operation = [KCDatabaseOperation new];
    NSArray *eventIdentifierArray = [operation fetchColumnDataFromTable:@"user_schedule" andColumnName:@"event_id" withClause:nil];
    if (eventIdentifierArray.count > 0) {
        for (NSString *eventIdentifier in eventIdentifierArray) {
            EKEvent* eventToRemove = [self.store eventWithIdentifier:eventIdentifier];
            eventToRemove.calendar = [self.store defaultCalendarForNewEvents];
            if (eventToRemove) {
                NSError* error = nil;
                if(DEBUGGING)NSLog(@"Removed event with identifier %@", eventIdentifier);
                [self.store removeEvent:eventToRemove span:EKSpanThisEvent commit:YES error:&error];
            }
        }
    }
}

@end
