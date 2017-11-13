//
//  KCUserData.m
//  Keychn
//
//  Created by Keychn Experience SL on 22/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCUserData.h"

@implementation KCUserData

- (void)getModelFromWithResponse:(NSDictionary *)response {
    // Parse the response and prepare model
    
    // Get unread count
    self.unReadCount = [response objectForKey:kUnreadCount];
    
    // Chop Chop
    NSDictionary *chopChopDictionary = [response objectForKey:kChopChop];
    self.chopChopInteractions        = [chopChopDictionary objectForKey:kTotalInteraction];
    NSArray *masterClassArray        = [chopChopDictionary objectForKey:kMasterClass];
    
    NSDictionary *chewItDictionary   = [response objectForKey:kChewIt];
    self.chewItInteractions          = [chewItDictionary objectForKey:kTotalInteraction];
    NSArray *chewItSessionArray      = [chewItDictionary objectForKey:kChewItSession];
    
    //Prepare MasterClass Models
    if([masterClassArray isKindOfClass:[NSArray class]] && [masterClassArray count] > 0) {
        self.masterClassArray = [[NSMutableArray alloc] init];
        @autoreleasepool {
            for (NSDictionary *masterClassDictionary in masterClassArray) {
                KCGroupSession *masterClass = [[KCGroupSession alloc] initWithResponse:masterClassDictionary];
                [self.masterClassArray addObject:masterClass];
            }
        }
    }
    
    //Prepare Chew/It Session Models
    if([chewItSessionArray isKindOfClass:[NSArray class]] && [chewItSessionArray count] > 0) {
        self.chewItSessionArray = [[NSMutableArray alloc] init];
        @autoreleasepool {
            for (NSDictionary *chewITSessionDictionary in chewItSessionArray) {
                KCGroupSession *chewItSession = [[KCGroupSession alloc] initWithResponse:chewITSessionDictionary];
                [self.chewItSessionArray addObject:chewItSession];
            }
        }
    }
}

@end
