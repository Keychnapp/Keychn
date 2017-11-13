//
//  KCTutorial.m
//  Keychn
//
//  Created by Keychn Experience SL on 18/03/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCTutorial.h"

@implementation KCTutorial

- (instancetype)initWithResponse:(NSDictionary *)response {
    // Prepare model from Dictionary
    self = [super init];
    if(self) {
        if([KCUtility getiOSDeviceType] == iPad) {
            self.placholderImageURL = [response objectForKey:kImageURLiPad];
        }
        else {
            self.placholderImageURL = [response objectForKey:kImageURLiPhone];
        }
        self.videoURL = [response objectForKey:kVideoURL];
        self.title    = [response objectForKey:kLabelName];
    }
    return self;
}

@end
