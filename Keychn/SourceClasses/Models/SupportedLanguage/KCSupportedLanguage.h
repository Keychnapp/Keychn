//
//  KCSupportedLanguage.h
//  Keychn
//
//  Created by Keychn Experience SL on 05/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCSupportedLanguage : NSObject

//holds multiple reference of KCSupportedLanguage class
@property (nonatomic,strong) NSMutableArray *allSupportedLanguageArray;

//Language Prpoerties
@property (nonatomic,copy) NSString  *languageName;
@property (nonatomic,copy) NSString  *flagURL;
@property (nonatomic,copy) NSNumber  *languageID;
@property (nonatomic,copy) NSArray   *userSpeakingLangugeArray;

/**
 @abstract This method will parse the supported language response from server and initialize models
 @param Response Dictionary
 @return void
*/
- (void)parseAllSupportedLanguages:(NSDictionary*)responseDictionary;

@end
