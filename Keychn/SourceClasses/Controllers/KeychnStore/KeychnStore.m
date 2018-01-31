//
//  KeychnStore.m
//  Keychn
//
//  Created by Keychn Experience SL on 05/05/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KeychnStore.h"
#import <StoreKit/StoreKit.h>
#import "KCWebConnection.h"
#import "KCUserProfileDBManager.h"
#import "IAPSubscription.h"

#define kSharedSecret @"a0a0ddd374fe448392a735a91b10f3aa"

@interface KeychnStore ()  <SKProductsRequestDelegate,SKPaymentTransactionObserver,SKRequestDelegate> {
    SKProductsRequest  *productsRequest;
    NSArray            *validProducts;
    NSString           *requestedProduct;
    KCWebConnection    *_webConnection;
    SKReceiptRefreshRequest *_receiptRequest;
}

@property (nonatomic,copy) void (^completionHandler) (BOOL status);

@end

@implementation KeychnStore

+ (instancetype)getSharedInstance {
    static KeychnStore *keychnStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keychnStore = [KeychnStore new];
    });
    
    return keychnStore;
}

-(void)fetchAvailableProducts:(NSString*)productToPurchase withCompletionHandler:(void(^)(BOOL status))finished {
    if(DEBUGGING) NSLog(@"fetchAvailableProducts %@",productToPurchase);
    if(!self.isPurchaseInProgress) {
        [KCProgressIndicator showNonBlockingIndicator];
        self.completionHandler    = finished;
        self.isPurchaseInProgress = YES;
        NSSet *productIdentifiers = [NSSet
                                     setWithObjects:productToPurchase , nil];
        
        productsRequest = [[SKProductsRequest alloc]
                           initWithProductIdentifiers:productIdentifiers];
        productsRequest.delegate = self;
        requestedProduct    = productToPurchase;
        
        if(DEBUGGING) NSLog(@"fetchAvailableProducts %@",productsRequest);
        
        [productsRequest start];
    }
}

- (BOOL)canMakePurchases {
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseMyProduct:(SKProduct*)product {
    
    if(DEBUGGING) NSLog(@"purchaseMyProduct %@",product);
    
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
        if(DEBUGGING) NSLog(@"purchase purhcase started %@",product);
    }
}


#pragma mark - Store Kit Delegate

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    if(DEBUGGING) NSLog(@"didFailWithError %@",error.description);
    self.isPurchaseInProgress = NO;
    [KCProgressIndicator hideActivityIndicator];
}

- (void)requestDidFinish:(SKRequest *)requestDidFinish {
    if(DEBUGGING) NSLog(@"requestDidFinish %@",requestDidFinish);
    self.isPurchaseInProgress = NO;
    [KCProgressIndicator hideActivityIndicator];
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    if(DEBUGGING) NSLog(@"paymentQueue updatedTransactions %@",transactions);
    [KCProgressIndicator hideActivityIndicator];
    for (SKPaymentTransaction *transaction in transactions) {
        if(DEBUGGING) NSLog(@"Update Transaction %@",transaction);
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                //Purchase initiated
                if(DEBUGGING) NSLog(@"paymentQueue --> updatedTransactions --> Purchase initiated");
                break;
                
            case SKPaymentTransactionStatePurchased:
                //Purchase comleted
                if(DEBUGGING) NSLog(@"paymentQueue --> updatedTransactions --> Purchase completed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self updateIAP];
                [self verifyAndRestorePurchaseForProductId:requestedProduct];
                break;
                
            case SKPaymentTransactionStateRestored:
                //Purchase restored
                if(DEBUGGING) NSLog(@"paymentQueue --> updatedTransactions --> Purchase restored");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                //Purchase failed
                if(DEBUGGING) NSLog(@"paymentQueue --> updatedTransactions --> Purchase failed");
                self.completionHandler(NO);
                [KCProgressIndicator hideActivityIndicator];
                break;
            default:
                break;
        }
    }
    self.isPurchaseInProgress = NO;
}


-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse*)response {
    SKProduct *validProduct = nil;
    [KCProgressIndicator hideActivityIndicator];
    if(DEBUGGING) NSLog(@"productsRequest didReceiveResponse %@",response);
    if(response && [response.products count] > 0) {
        validProducts = response.products;
        validProduct = [response.products objectAtIndex:0];
        if([validProduct.productIdentifier isEqualToString:requestedProduct]) {
            //Requested Product is ready to purchase
            if(DEBUGGING) NSLog(@"Requested product %@ can be purchased.",requestedProduct);
            [self purchaseMyProduct:validProduct];
        }
        else {
            //Requested Product is not available to purchase
            if(DEBUGGING) NSLog(@"Requested product %@ cannot be purchased.",requestedProduct);
        }
    }
}

#pragma mark - Restore IAP

- (void)restoreAppReceiptsForProductId:(NSString *)productId {
    [KCProgressIndicator showNonBlockingIndicator];
    requestedProduct = productId;
    _receiptRequest             = [[SKReceiptRefreshRequest alloc] init];
    _receiptRequest.delegate    = self;
    [_receiptRequest start];
}

#pragma mark - Update Local Database

- (void)updateIAP {
    // Save to local database first
    KCUserProfile *userProfile               = [KCUserProfile sharedInstance];
    __block IAPSubscription *iapSubscription = [IAPSubscription subscriptionForUser:userProfile.userID];
    if(!iapSubscription) {
        iapSubscription.userId                   = userProfile.userID;
        iapSubscription.isSynced                 = NO;
        iapSubscription.productId                = requestedProduct;
        [iapSubscription saveIAPSubscription];
    }
}

#pragma mark - Verify Purchase

- (void)verifyAndRestorePurchaseForProductId:(NSString *)productId {
    // Update on server that user has purhcased the subscription with valid dates
    [KCProgressIndicator showNonBlockingIndicator];
    [self verifyInAppPurcaseStatusForProductId:productId withCompletionHandler:^(BOOL isValid, double expirationTimeInterval, NSString *productId, double requestTimeInterval, NSString *transactionId) {
        if(isValid) {
            KCUserProfile *userProfile       = [KCUserProfile sharedInstance];
            IAPSubscription *iapSubscription = [IAPSubscription new];
            iapSubscription.userId           = userProfile.userID;
            iapSubscription.isSynced         = NO;
            iapSubscription.productId        = productId;
            iapSubscription.expirationTimeInterval = expirationTimeInterval;
            iapSubscription.purchaseTimeInterval   = requestTimeInterval;
            iapSubscription.transactionId          = transactionId;
            [iapSubscription saveIAPSubscription];
            
            // Update on Server
            [self requestUpdateSubscriptionPurchase:iapSubscription];
        }
        [KCProgressIndicator hideActivityIndicator];
    }];
}

#pragma mark - Server End Code

- (void)requestUpdateSubscriptionPurchase:(IAPSubscription *)subscription {
    // Update Keychn Subscription Purchase on server
    [KCProgressIndicator showNonBlockingIndicator];
    NSDictionary *paremters                 = [subscription parameters];
    _webConnection                          = [KCWebConnection new];
   __block IAPSubscription *iapSubscription = subscription;
    [_webConnection sendDataToServerWithAction:updateSubscriptionAction withParameters:paremters success:^(NSDictionary *response) {
        // Update Sync status on local database
        [iapSubscription syncComplete];
        if(self.completionHandler) {
            self.completionHandler(YES);
        }
        [KCProgressIndicator hideActivityIndicator];
    } failure:^(NSString *response) {
        [KCProgressIndicator hideActivityIndicator];
    }];
}

#pragma mark - iTunes Verification

- (void)verifyInAppPurcaseStatusForProductId:(NSString *)productId withCompletionHandler:(void(^)(BOOL isValid, double expirationTimeInterval, NSString *productId, double requestDate, NSString *transactionId))finished {
    // Retrieve In-App purchase records and send it to iTunes for In-App purchase verification. It is required to check if user has renewed the subscription or not
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt   = [NSData dataWithContentsOfURL:receiptURL];
    __block  NSString *purchasedProductId = productId;
    if(receipt) {
        NSDictionary *parameters = @{@"receipt-data":[receipt base64EncodedStringWithOptions:0], @"password":kSharedSecret};
        _webConnection  = [KCWebConnection new];
        NSString *storeURL = @"https://buy.itunes.apple.com/verifyReceipt";
        BOOL sandbox       = [[receiptURL lastPathComponent] isEqualToString:@"sandboxReceipt"];
        if (sandbox) {
            storeURL = @"https://sandbox.itunes.apple.com/verifyReceipt";
        }
        [_webConnection httpPOSTRequestWithURL:storeURL andParameters:parameters success:^(NSDictionary *response) {
            // Fetched in App Purhcas Record
            NSDictionary *inAppPurchaseReceipt = [response objectForKey:@"receipt"];
            NSArray      *inAppPurchaseRecords = [inAppPurchaseReceipt objectForKey:@"in_app"];
            BOOL didPurchaseThisItem           = NO;
            for (NSDictionary *purchasedRecord in inAppPurchaseRecords) {
                NSString *iapProductId = [purchasedRecord objectForKey:@"product_id"];
                if([iapProductId isEqualToString:purchasedProductId]) {
                    // Get the expiration date for this product id
                    didPurchaseThisItem = YES;
                    double requestTimeInterval    = [[purchasedRecord objectForKey:@"purchase_date_ms"] doubleValue];
                    double expirationTimeInterval = [[purchasedRecord objectForKey:@"expires_date_ms"] doubleValue];
                    NSString *transactionId       = [purchasedRecord objectForKey:@"transaction_id"];
                    finished(YES, expirationTimeInterval, purchasedProductId, requestTimeInterval,transactionId);
                    break;
                }
            }
            
            if(!didPurchaseThisItem) {
                // User has never purchased this item
                finished(NO,0.0f, purchasedProductId, 0.0f, nil);
            }
        } failure:^(NSString *response) {
           // Request failed
        }];
    }
    else {
        finished(NO,0.0f, purchasedProductId, 0.0f, nil); // No App Store receipt found. Alert user if they should Purchase or restore the purchases if already bought.
    }
}

@end
