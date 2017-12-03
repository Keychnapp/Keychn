//
//  KCDatabaseOperation.h
//  Keychn
//
//  Created by Keychn Experience SL on 31/12/15.
//  Copyright © 2015 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCDatabaseOperation : NSObject

/**
 @abstract Get the shared instance of the database operation class to avoid the thread conflict
 @param No Parameter
 @return instance type
*/
+(instancetype)sharedInstance;


/**
 @abstract Opens the SQLite Connection
 @param    No Parameter
 @return BOOL YES if opened correctly else NO
 */
- (BOOL) openConnection;

/**
 @abstract Closes the SQLite Connection
 @param    No Parameter
 @return BOOL YES if opened correctly else NO
 */
- (BOOL)closeConnection;

/**
 @abstract Execute a raw sql query
 @param Query as String
 @return YES if executed successfully else NO
 */
- (BOOL)executeSQLQuery:(NSString*)query;

/**
 @abstract Fetch all column from database for the given table
 @param table name and an optional clause
 @return array of database rows
 */
- (NSArray*)fetchDataFromTable:(NSString*)tableName withClause: (NSString*)clause;


/**
 @abstract Fetch a column from database for the given table
 @param Table name and an optional clause
 @return Array of database rows
 */
- (NSArray*)fetchColumnDataFromTable:(NSString*)tableName andColumnName:(NSString*)columnName withClause: (NSString*)clause;


/**
 @abstract Fetch all column from database for the given table in UTF8 String format
 @param table name and an optional clause
 @return array of database rows
 */
- (NSArray*)fetchDataInUTFStringFormatFromTable:(NSString*)tableName withClause:(NSString*)clause;

@end
