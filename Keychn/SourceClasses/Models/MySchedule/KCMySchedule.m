//
//  KCMySchedule.m
//  Keychn
//
//  Created by Keychn Experience SL on 04/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCMySchedule.h"

@implementation KCMySchedule

- (instancetype)initWithResponse:(NSDictionary *)response {
    self = [super init];
    // Intantiate model with Dictionary
    self.secondUserID         = [response objectForKey:kOtherUserID];
    self.secondUsername       = [response objectForKey:kOtherUsername];
    self.itemName             = [response objectForKey:kItemName];
    self.scheduleDate         = [[response objectForKey:kScheduleDate] doubleValue];
    self.scheduleID           = [response objectForKey:kScheduleID];
    self.isOpen               = [[response objectForKey:kStatus] isEqualToString:kOpenStatus];
    self.itemImageURL         = [response objectForKey:kImageURL];
    self.conferenceID         = [response objectForKey:kConferenceID];
    self.unreadCount          = [response objectForKey:kUnreadCount];
    self.recipeType           = masterClass;
    self.isHosting            = [[response objectForKey:kIsHosting] boolValue];
    self.eventId              = [response objectForKey:kEventId];
    self.isListner            = [[response objectForKey:kIsListner] boolValue];
    
    return self;
}

- (NSArray*)getModelsFromArray:(NSArray *)myScheduleArray {
    // Returns the models for MySchedules
    if([myScheduleArray count] > 0) {
        NSMutableArray *myScheduleModelsArray = [[NSMutableArray alloc] init];
        @autoreleasepool {
            for (NSDictionary *myScheduleDictionary in myScheduleArray) {
                KCMySchedule *mySchedule        = [[KCMySchedule alloc] initWithResponse:myScheduleDictionary];
                //Add models to array
                [myScheduleModelsArray addObject:mySchedule];
            }
        }
        return myScheduleModelsArray;
    }
    return nil;
}

@end
