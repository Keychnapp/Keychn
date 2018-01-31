//
//  EventStore.h
//  Keychn
//
//  Created by Rohit Kumar on 02/11/2017.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventStore : NSObject

+(instancetype)sharedInstance;

- (NSString*)addEventWithTimerInterval:(NSTimeInterval)timeInterval chefName:(NSString *)chefName;
- (void)removeEventWithIdentifier:(NSString *)eventIdentifier;
- (void)askPermissionForEvent;
- (void)removeAllEvents;
- (NSString*)editEvent:(NSString*)eventid withTimeInterval:(NSTimeInterval)timeInterval andChefName:(NSString *)chefName;

@property (nonatomic, strong) EKEventStore *store;

@end
