//
//  KCUserData.h
//  Keychn
//
//  Created by Keychn Experience SL on 22/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCGroupSession.h"

@interface KCUserData : NSObject

/**
 @abstract This method will parse server response for InstaAction Screen and create model from it.
 @param Server Response in NSDictionary
 @return void
 */
- (void)getModelFromWithResponse:(NSDictionary *)response;

@property (copy,nonatomic)   NSNumber           *chewItInteractions;
@property (copy,nonatomic)   NSNumber           *chopChopInteractions;
@property (copy,nonatomic)   NSNumber           *unReadCount;
@property (strong,nonatomic) NSMutableArray     *masterClassArray;
@property (strong,nonatomic) NSMutableArray     *chewItSessionArray;


@end
