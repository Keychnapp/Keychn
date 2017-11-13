//
//  KCItem.m
//  Keychn
//
//  Created by Keychn Experience SL on 19/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCItem.h"

@implementation KCItem

- (void)getModelFromDictionary:(NSDictionary *)responseDictionary {
    //get model from server response dictionary
    if(responseDictionary && [responseDictionary isKindOfClass:[NSDictionary class]]) {
        self.itemIdentifier = [responseDictionary objectForKey:kIdentifier];
        if(!self.itemIdentifier) {
          self.itemIdentifier = [responseDictionary objectForKey:kItemID];
        }
        if([KCUtility getiOSDeviceType] == iPad) {
            self.imageURL      = [responseDictionary objectForKey:kImageURLiPad];
        }
        else {
            self.imageURL = [responseDictionary objectForKey:kImageURLiPhone];
        }
        self.title        = [responseDictionary objectForKey:kLabelName];
        self.isScheduled  = [[responseDictionary objectForKey:kIsScheduled] boolValue];
    }
}

@end
