//
//  IAPSubscription.m
//  Keychn
//
//  Created by Rohit on 04/09/17.
//  Copyright © 2017 Keychn Experience. All rights reserved.
//

#import "IAPSubscription.h"
#import "KCDatabaseOperation.h"

@implementation IAPSubscription

- (instancetype)initWithResponse:(NSDictionary *)subscriptionDictoinary {
    self = [super init];
    if([subscriptionDictoinary isKindOfClass:[NSDictionary class]]) {
        self.productId = [subscriptionDictoinary objectForKey:@"product_id"];
        self.userId    = [subscriptionDictoinary objectForKey:@"user_id"];
        self.transactionId = [subscriptionDictoinary objectForKey:@"transaction_id"];
        self.isSynced  = [[subscriptionDictoinary objectForKey:@"is_synced"] boolValue];
        self.expirationTimeInterval    = [[subscriptionDictoinary objectForKey:@"expiration_time_interval"] doubleValue];
        self.purchaseTimeInterval      = [[subscriptionDictoinary objectForKey:@"purchase_time_interval"] doubleValue];
    }
    return self;
}

- (void)saveIAPSubscription {
    // Insert Update Subscription Purhcase to local database
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *insertQuery            = [NSString stringWithFormat:@"INSERT INTO purchase_history (user_id, product_id, expiration_time_interval, purchase_time_interval, is_synced, transaction_id) VALUES ('%@', '%@', %f, %f, %d, '%@')", self.userId, self.productId, self.expirationTimeInterval, self.purchaseTimeInterval, self.isSynced, self.transactionId];
    [dbOperation executeSQLQuery:insertQuery];
}

- (BOOL)doesExist {
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *clause = [NSString stringWithFormat:@"WHERE user_id = %@ AND product_id = '%@'",self.userId,self.productId];
    NSArray *resultArray   = [dbOperation fetchDataFromTable:@"purchase_history" withClause:clause];
    if(DEBUGGING) NSLog(@"Saved In-App Purchase %@", resultArray);
    return [resultArray count] > 0;
}

- (void)syncComplete {
    // Set sync complete
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSString *updateQuery            = [NSString stringWithFormat:@"UPDATE purchase_history SET is_synced = 1 WHERE user_id = %@",self.userId];
    [dbOperation executeSQLQuery:updateQuery];
    self.isSynced   = YES;
}

+ (instancetype)subscriptionForUser:(NSNumber  *)userId {
    // Fetch subscription information
    NSString *clause = [NSString stringWithFormat:@"WHERE user_id = %@ ORDER BY expiration_time_interval DESC LIMIT 1", userId];
    KCDatabaseOperation *dbOperation = [KCDatabaseOperation sharedInstance];
    NSArray *subscriptionArray =  [dbOperation fetchDataFromTable:@"purchase_history" withClause:clause];
    if([subscriptionArray count] > 0) {
        IAPSubscription *subscription = [IAPSubscription new];
        NSDictionary *subscriptionDictoinary = [subscriptionArray firstObject];
        subscription.rowId     = [subscriptionDictoinary objectForKey:@"row_id"];
        subscription.productId = [subscriptionDictoinary objectForKey:@"product_id"];
        subscription.userId    = [subscriptionDictoinary objectForKey:@"user_id"];
        subscription.transactionId = [subscriptionDictoinary objectForKey:@"transaction_id"];
        subscription.isSynced  = [[subscriptionDictoinary objectForKey:@"is_synced"] boolValue];
        subscription.expirationTimeInterval    = [[subscriptionDictoinary objectForKey:@"expiration_time_interval"] doubleValue];
        subscription.purchaseTimeInterval      = [[subscriptionDictoinary objectForKey:@"purchase_time_interval"] doubleValue];
        return subscription;
    }
    return nil;
}

- (NSDictionary *)parameters {
    // Get parameters to update on server
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:self.productId forKey:@"product_id"];
    [parameters setObject:self.userId forKey:@"user_id"];
    [parameters setObject:self.transactionId forKey:@"transaction_id"];
    [parameters setObject:[NSNumber numberWithDouble:self.purchaseTimeInterval] forKey:@"purchase_time_interval"];
    [parameters setObject:[NSNumber numberWithDouble:self.expirationTimeInterval] forKey:@"expiration_time_interval"];
    return parameters;
}

@end
