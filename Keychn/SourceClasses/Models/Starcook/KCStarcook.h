//
//  KCStarcook.h
//  Keychn
//
//  Created by Keychn Experience SL on 08/04/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCStarcook : NSObject

- (instancetype)initWithResponse:(NSDictionary*)response;

@property (nonatomic,copy) NSNumber *friendID;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *imageURL;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSNumber *unreadCount;
@property BOOL                      isPending;


@end
