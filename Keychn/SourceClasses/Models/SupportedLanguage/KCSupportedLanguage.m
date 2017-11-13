//
//  KCSupportedLanguage.m
//  Keychn
//
//  Created by Keychn Experience SL on 05/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "KCSupportedLanguage.h"

@implementation KCSupportedLanguage

- (void)parseAllSupportedLanguages:(NSDictionary *)responseDictionary {
    //parse server response
    self.allSupportedLanguageArray = [[NSMutableArray alloc] init];
    NSString *status               = [responseDictionary objectForKey:kStatus];
    self.userSpeakingLangugeArray  = [responseDictionary objectForKey:kUserSpeakingLanguage];
    if([status isEqualToString:kSuccessCode]) {
        NSArray *languageArray = [responseDictionary objectForKey:kLanguageDetails];
        for (NSDictionary *languageDictionary in languageArray) {
            //convert dictionary to model and add to the array
            [self.allSupportedLanguageArray addObject:[self getModelFromDictionary:languageDictionary]];
        }
    }
}

- (instancetype) getModelFromDictionary:(NSDictionary*)languageDictionary {
    //get model from Dictionary
    KCSupportedLanguage *supportedLanguageModel = [KCSupportedLanguage new];
    supportedLanguageModel.languageID   = [languageDictionary objectForKey:kIdentifier];
    supportedLanguageModel.languageName = [languageDictionary objectForKey:kName];
    supportedLanguageModel.flagURL      = [languageDictionary objectForKey:kFlagImageURL];
    return supportedLanguageModel;
}

@end
