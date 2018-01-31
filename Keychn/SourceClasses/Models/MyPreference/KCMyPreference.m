//
//  KCMyPreference.m
//  Keychn
//
//  Created by Keychn Experience SL on 11/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCMyPreference.h"

@implementation KCMyPreference

- (instancetype)initWithResponse:(NSDictionary*)response {
    // Get MyPreference Model with server response
    self = [super init];
    if(self) {
        self.credits        = [response objectForKey:kCredit];
        self.interactions   = [response objectForKey:kInteraction];
        self.favorites      = [response objectForKey:kFavorite];
        self.starCook       = [response objectForKey:kStarCook];
        
        // Dish of the week
        NSDictionary *dishOfTheWeekDictionary = [response objectForKey:kDishofTheWeek];
        if([dishOfTheWeekDictionary isKindOfClass:[NSDictionary class]]) {
            self.dishofTheWeekItemID   = [dishOfTheWeekDictionary objectForKey:kIdentifier];
            self.dishofTheWeekItemName = [dishOfTheWeekDictionary objectForKey:kLabelName];
            if([KCUtility getiOSDeviceType] == iPad) {
                // Image URL for iPad
                self.dishofTheWeekImageURL = [dishOfTheWeekDictionary objectForKey:kImageURLiPad];
            }
            else {
                // Image URL for iPhone
                self.dishofTheWeekImageURL = [dishOfTheWeekDictionary objectForKey:kImageURLiPhone];
            }
        }
        
    }
    return self;
}

@end
