//
//  KCTutorial.h
//  Keychn
//
//  Created by Keychn Experience SL on 18/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCTutorial : NSObject

/**
 @abstract This method will prepare tutorial model from NSDitionary;
 @param NSDictionary Response
 @return Tutorial Model
 */
- (instancetype)initWithResponse:(NSDictionary*)response;

@property (copy,nonatomic) NSString *placholderImageURL;
@property (copy,nonatomic) NSString *videoURL;
@property (copy,nonatomic) NSString *title;


@end
