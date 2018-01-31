//
//  KCMenu.m
//  Keychn
//
//  Created by Keychn Experience SL on 15/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCMenu.h"

@implementation KCMenu

- (void)getModelFromDictionary:(NSDictionary *)responseDictionary {
    //get model from response dictionnary
    self.title          = [responseDictionary objectForKey:kLabelName];
    if([KCUtility getiOSDeviceType] == iPad) {
      self.imageURL       = [responseDictionary objectForKey:kImageURLiPad];
    }
    else {
      self.imageURL       = [responseDictionary objectForKey:kImageURLiPhone];
    }
    self.menuIdentfier  = [responseDictionary objectForKey:kIdentifier];
    self.createdDate    = [responseDictionary objectForKey:kDateCreated];
    
    self.labelWidth     = [NSString getWidthForText:self.title withViewHeight:27 withFontSize:15];
}

@end
