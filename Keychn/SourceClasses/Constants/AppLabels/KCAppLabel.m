//
//  KCAppLabel.m
//  Keychn
//
//  Created by Keychn Experience SL on 06/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCAppLabel.h"

@implementation KCAppLabel

+ (instancetype) sharedInstance {
    //return app singleton instance
    static KCAppLabel *appLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appLabel = [KCAppLabel new];
    });
    return appLabel;
}

@end
