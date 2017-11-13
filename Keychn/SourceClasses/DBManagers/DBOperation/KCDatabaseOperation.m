//
//  KCDatabaseOperation.m
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import "KCDatabaseOperation.h"
#import "sqlite3.h"

@interface KCDatabaseOperation () {
    sqlite3                *_dbConnection;
    NSString               *_databasePath;
}

@end

@implementation KCDatabaseOperation

+(instancetype)sharedInstance {
    //get the shared instance of the this class
    static KCDatabaseOperation *dbOperation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbOperation = [[KCDatabaseOperation alloc] init];
    });
    return dbOperation;
}

- (BOOL)openConnection {
    //open the database connection
    NSString *homeDirectory =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    _databasePath = [homeDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",DATABASE_DIRECTORY_NAME,KEYCHN_DATABASE_FILE]];
    if(DEBUGGING) NSLog(@"Databas Path %@",_databasePath);
    if(sqlite3_open([_databasePath UTF8String], & (_dbConnection) ) ==  SQLITE_ERROR) {
        if(DEBUGGING) NSLog(@"Problem in opening SQLite connection");
        return NO;
    }
    return  YES;
}


- (BOOL)closeConnection {
    //close the database connection
    if(sqlite3_close(_dbConnection) == SQLITE_ERROR) {
        return NO;
    }
    return YES;
}


- (BOOL)executeSQLQuery:(NSString*)query {
    //execute a sql query
    @try {
        if(DEBUGGING) NSLog(@"Last Query %@",query);
        char *errorMessage;
        if( [self openConnection]) {
            sqlite3_exec(_dbConnection, [query UTF8String], nil, nil, &errorMessage);
            if(DEBUGGING) NSLog(@"Error in executing statement %s",errorMessage);
        }
        if(!errorMessage) {
            return true;
        }
    }
    @catch (NSException *exception) {
        //Log the database exception here
    }
    @finally {
        [self closeConnection];
    }
    return false;
}

- (NSArray*)fetchDataFromTable:(NSString*)tableName withClause:(NSString*)clause {
    //fetch data from table
    NSMutableString *selectQuery = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ ",@"SELECT * FROM",tableName]];
    if(clause) {
        [selectQuery appendString:[NSString stringWithFormat:@" %@",clause]];
    }
    
    if(DEBUGGING) NSLog(@"Last query executed %@",selectQuery);
    
    sqlite3_stmt            *statement         = nil;
    NSMutableArray          *allRows           = [[NSMutableArray alloc] init];
    
    @try {
        if([self openConnection]) {
            sqlite3_prepare_v2(_dbConnection, [selectQuery UTF8String], -1, &statement, nil);
            if(statement) {
                int columnCount = sqlite3_column_count(statement);
                while(sqlite3_step(statement) == SQLITE_ROW) {
                    NSMutableDictionary     *rows              = [[NSMutableDictionary alloc] init];
                    
                    for(int i=0; i<columnCount;i++) {
                        
                        NSString *columName = [NSString stringWithFormat:@"%s",sqlite3_column_name(statement, i)];
                        NSString *value     = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement, i)];
//                        NSString *value    = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, i)];
                        [rows setObject:value forKey:columName];
                    }
                    
                    [allRows addObject:rows];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
        if(statement){
            sqlite3_finalize(statement);
        }
        [self closeConnection];
    }
    return allRows;
}

- (NSArray*)fetchDataInUTFStringFormatFromTable:(NSString*)tableName withClause:(NSString*)clause {
    //fetch data from table
    NSMutableString *selectQuery = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ ",@"SELECT * FROM",tableName]];
    if(clause) {
        [selectQuery appendString:[NSString stringWithFormat:@" %@",clause]];
    }
    
    if(DEBUGGING) NSLog(@"Last query executed %@",selectQuery);
    
    sqlite3_stmt            *statement         = nil;
    NSMutableArray          *allRows           = [[NSMutableArray alloc] init];
    
    @try {
        if([self openConnection]) {
            sqlite3_prepare_v2(_dbConnection, [selectQuery UTF8String], -1, &statement, nil);
            if(statement) {
                int columnCount = sqlite3_column_count(statement);
                while(sqlite3_step(statement) == SQLITE_ROW) {
                    NSMutableDictionary     *rows              = [[NSMutableDictionary alloc] init];
                    
                    for(int i=0; i<columnCount;i++) {
                        
                        NSString *columName = [NSString stringWithFormat:@"%s",sqlite3_column_name(statement, i)];
                        NSString *value     = nil;
                        @try {
                            value    = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, i)];
                            //
                        } @catch (NSException *exception) {
                             value     = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement, i)];
                        }
                        
                        [rows setObject:value forKey:columName];
                    }
                    
                    [allRows addObject:rows];
                }
            }
        }
    }
    @catch (NSException *exception) {
        if(DEBUGGING) NSLog(@"SQL Query Exception %@",exception.reason);
    }
    @finally {
        if(statement){
            sqlite3_finalize(statement);
        }
        [self closeConnection];
    }
    return allRows;
}


- (NSArray*) fetchColumnDataFromTable:(NSString*)tableName andColumnName:(NSString*)columnName withClause: (NSString*)clause {
    //fetch data from table
    NSMutableString *selectQuery = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"SELECT %@ FROM %@", columnName,tableName]];
    if(clause) {
        [selectQuery appendString:[NSString stringWithFormat:@" %@",clause]];
    }
    
    if(DEBUGGING) NSLog(@"Last query executed %@",selectQuery);
    
    sqlite3_stmt            *statement         = nil;
    NSMutableArray          *allRows           = [[NSMutableArray alloc] init];
    
    @try {
        if([self openConnection]) {
            sqlite3_prepare_v2(_dbConnection, [selectQuery UTF8String], -1, &statement, nil);
            if(statement) {
                while(sqlite3_step(statement) == SQLITE_ROW) {
//                    NSString *value     = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];
                    NSString *value    = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
                    [allRows addObject:value];
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
        if(statement){
            sqlite3_finalize(statement);
        }
        [self closeConnection];
    }
    return allRows;
}

- (void) fetchAppLabelWithLanguageID:(NSNumber*)langugeID {
    //fetch app labels from local database
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT label, label_text FROM app_language_text WHERE %@='%@'",kLanguageID,langugeID];
    sqlite3_stmt  *statement         = nil;
    KCAppLabel    *appLabel         = [KCAppLabel sharedInstance];
    @try {
        if([self openConnection]) {
            sqlite3_prepare_v2(_dbConnection, [selectQuery UTF8String], -1, &statement, nil);
            if(statement) {
                while(sqlite3_step(statement) == SQLITE_ROW) {
                    
                    NSString *variableName     = [NSString stringWithFormat:@"%s",sqlite3_column_text(statement, 0)];
                    NSString *variableValue    = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
                    
                    @try {
                        //assign property by Key-Value pair using KVC
                        [appLabel setValue:variableValue forKey:variableName];
                    }
                    @catch (NSException *exception) {
                        if(DEBUGGING) NSLog(@"Label not found for name: %@",variableName);
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
        if(statement){
            sqlite3_finalize(statement);
        }
        [self closeConnection];
    }
}

@end
