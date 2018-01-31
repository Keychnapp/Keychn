//
//  KCUserMatch.m
//  Keychn
//
//  Created by Keychn Experience SL on 16/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCUserMatch.h"

@implementation KCUserMatch

- (void)getModelFromDictionary:(NSDictionary *)responseDictionary {
    //Get User Match model from server response
    NSDictionary *userMatchingDictionary = [responseDictionary objectForKey:kMatchDetails];
    self.otherUserEmailID                = [userMatchingDictionary objectForKey:kEmailID];
    self.otherUsername                   = [userMatchingDictionary objectForKey:kName];
    self.conferenceID                    = [userMatchingDictionary objectForKey:kConferenceID];
    self.scheduleID                      = [responseDictionary objectForKey:kScheduleID];
    self.otherUserID                     = [userMatchingDictionary objectForKey:kUserID];
    NSString *matchsStatus               = [userMatchingDictionary objectForKey:kMatchStatus];
    self.isUserBusy                      = [[responseDictionary objectForKey:kMatchStatus] boolValue];
    
    if([matchsStatus isEqualToString:kUserMatched]) {
        self.isMatched = YES;
    }
    else {
        self.isMatched = NO;
    }
}

@end
