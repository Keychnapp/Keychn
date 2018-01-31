//
//  IAPSubscription.h
//  Keychn
//
//  Created by Rohit on 04/09/17.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPSubscription : NSObject

@property (copy, nonatomic)   NSNumber *rowId;
@property (copy, nonatomic)   NSNumber *userId;
@property (copy, nonatomic)   NSString *productId;
@property (assign, nonatomic) BOOL     isSynced;
@property (assign, nonatomic) double   purchaseTimeInterval;
@property (assign, nonatomic) double   expirationTimeInterval;
@property (copy, nonatomic)   NSString *transactionId;

- (instancetype)initWithResponse:(NSDictionary *)response;
- (void)saveIAPSubscription;
- (BOOL)doesExist;
- (void)syncComplete;
+ (instancetype)subscriptionForUser:(NSNumber *)userId;
- (NSDictionary*)parameters;


@end
