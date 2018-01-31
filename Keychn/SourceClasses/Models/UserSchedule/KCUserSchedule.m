//
//  KCUserSchedule.m
//  Keychn
//
//  Created by Keychn on 05/09/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCUserSchedule.h"

@implementation KCUserSchedule

- (instancetype)initWithResponse:(NSDictionary *)response {
    // Create a new instance
    self = [super init];
    self.courseID       = [response objectForKey:kCourseID];
    self.itemID         = [response objectForKey:kItemID];
    self.itemName       = [response objectForKey:kItemName];
    self.menuID         = [response objectForKey:kMenuID];
    self.scheduleDate   = [response objectForKey:kScheduleDate];
    self.scheduleID     = [response objectForKey:kScheduleID];
    self.scheduleType   = [response objectForKey:kScheduleType];
    self.userID         = [response objectForKey:kUserID];
    self.eventID        = [response objectForKey:kEventId];
    if([self.scheduleType isEqualToString:kFreeRideSchedule] || [self.scheduleType isEqualToString:kFreeRideNowSchedule]) {
        if([KCUtility getiOSDeviceType] == iPad) {
            self.imageURL       = [response objectForKey:kFreeRideImageiPad];
        }
        else {
            self.imageURL       = [response objectForKey:kFreeRideImageiPhone];
        }
    }
    else {
        if([KCUtility getiOSDeviceType] == iPad) {
            self.imageURL       = [response objectForKey:kSmallImageURLiPad];
        }
        else {
            self.imageURL       = [response objectForKey:kSmallImageURLiPhone];
        }
    }
    return self;
}

@end
