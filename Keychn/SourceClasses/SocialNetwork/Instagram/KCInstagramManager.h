//
//  KCInstagramManager.h
//  Keychn
//
//  Created by Keychn Experience SL on 24/02/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCInstagramManager : NSObject

/**
 @abstract This method will share image on Instagram
 @param Image to be shared, Presentation View, Completion Handler
 @return void
 */
- (void)shareImageOnInstagramWithErrorHandler:(UIImage*)image withPresentationViewController:(UIViewController*)controller withErrorHandler:(void (^)(void))failed;


@end
