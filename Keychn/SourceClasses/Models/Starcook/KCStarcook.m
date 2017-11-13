//
//  KCStarcook.m
//  Keychn
//
//  Created by Keychn Experience SL on 08/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCStarcook.h"

@implementation KCStarcook

- (instancetype)initWithResponse:(NSDictionary *)response {
    self = [super init];
    if(self) {
        // Prepare model from server response
        self.username       = [response objectForKey:kName];
        self.friendID       = [response objectForKey:kUserID];
        self.imageURL       = [response objectForKey:kImageURL];
        self.location       = [response objectForKey:kLocation];
        self.unreadCount    = [response objectForKey:kUnreadCount];
    }
    return self;
}

@end
