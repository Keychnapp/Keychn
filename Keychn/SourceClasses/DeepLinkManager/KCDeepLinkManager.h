//
//  KCDeepLinkManager.h
//  Keychn
//
//  Created by Rohit Kumar on 10/06/2018.
//  Copyright © 2018 Keychn Experience. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCDeepLinkManager : NSObject

+ (void)navigateLinkWithParameter:(NSDictionary *)parameters;

@end
