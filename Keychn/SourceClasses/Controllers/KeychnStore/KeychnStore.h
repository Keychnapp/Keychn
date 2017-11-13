//
//  KeychnStore.h
//  Keychn
//
//  Created by Keychn Experience SL on 05/05/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychnStore : NSObject

+ (instancetype)getSharedInstance;
@property (nonatomic, assign) BOOL isPurchaseInProgress;

-(void)fetchAvailableProducts:(NSString*)productToPurchase withCompletionHandler:(void(^)(BOOL status))finished;
- (void)verifyAndRestorePurchaseForProductId:(NSString *)productId;
- (void)restoreAppReceiptsForProductId:(NSString *)productId;

@end
