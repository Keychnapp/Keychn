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

+ (void)shareLinkWithTitle:(NSString *)title content:(NSString *)text canonicalURL:(NSString *)url imageURL:(NSString *)imageURL controller:(NSString *)controller identfier:(NSNumber *)identifier presentOn:(UIViewController *)viewController;

@end
