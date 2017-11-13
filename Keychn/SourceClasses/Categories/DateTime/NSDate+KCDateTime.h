//
//  NSDate+KCDateTime.h
//  Keychn
//
//  Created by Keychn Experience SL on 17/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (KCDateTime)

/**
 @abstract This method will convert string to NSDate
 @param Date String
 @return NSDate Instance
 */
+ (NSDate*)getDateFromString:(NSString*)dateString;

/**
 @abstract This mwthod will return the index of the current day in the current week. Sunday has been cosnsidered the first day of the week here.
 @param No Parameters
 @return Index of the day in the week.
*/
+(NSInteger) getWeekDayIndexFromSunday;

/**
 @abstract This mwthod will return the dates of the current week
 @param No Parameters
 @return Dates of the current week starting from Sunday
 */
+(NSArray*)getWeekDates;

/**
 @abstract This method will return the current month and year in String format
 @param No Parameters
 @return Current Month and Year
 */
+ (NSString*) getCurrentMonthAndYear;

/**
 @abstract This method will prepare short week days name eg: SUN for Sunday for the next 7 days
 @param No Parameter
 @return Names of days sorted in the order by current day and the next 6 days
 */
+ (NSArray*) getShortWeekDayNamesByCurrentDate;

/**
 @abstract This method will prepare date from weekday index and time slot
 @param Day Index and Time Slot
 @return Date String
 */
+(NSString*)getDateTimeFromDayIndex:(NSInteger)dayIndex andTimeSlot:(NSInteger)timeSlot;

/**
 @abstract This method will return hour of the current DateTime
 @param No Parameter
 @return Current Hour
 */
+ (NSInteger)getCurrentHour;

/**
 @abstract This method will return current date in string format
 @param No Parmaeters
 @return String of current date
 */
+ (NSString*)getCurrentDate;

/**
 @abstract This method will return current date in string format in UTC Time Zone
 @param No Parmaeters
 @return String of current date
 */
+ (NSString*)getCurrentDateInUTC;

+ (NSString*)getCurrentDateInUTCWithFormat:(NSString *)format;

/**
 @abstract This method will convert date into equivalent seconds
 @param Date to be converted
 @return Time Interval
 */
+ (NSTimeInterval) getSecondsFromDate:(NSString*)date;

/**
 @abstract This method will convert date into equivalent seconds
 @param Date to be converted, Date format
 @return Time Interval
 */
+ (NSTimeInterval) getSecondsFromDate:(NSString*)date withDateFormatter:(NSString*)dateFormat;

/**
 @abstract This method will return short/full day name of the given time interval
 @param Time Interval, YES for full day name, NO for short name
 @return Short/Full Day Name
 */
+ (NSString*)getDayNameFromTimeInterval:(NSTimeInterval)timeInterval fullName:(BOOL)flag;

/**
 @abstract This method will return time in 24 Hour format from the given time interval
 @param Time Interval
 @return Time in 24 hour format
 */
+ (NSString*)getTimeFromTimeInterval:(NSTimeInterval)timeInterval;

/**
 @abstract This method will return time in 12 Hour format from the given time interval
 @param Time Interval
 @return Time in 12 hour format
 */
+ (NSString*)get12HourFormatTimeFromTimeInterval:(NSTimeInterval)timeInterval;


+ (NSString*)getHourAndMinuteFromTimeInterval:(NSTimeInterval)timeInterval;

/**
 @abstract This method will return date part from the time interval
 @param Time Interval
 @return Date part
 */
+ (NSInteger)getDateFromTimeInterval:(NSTimeInterval)timeInterval;

/**
 @abstract This method will return full date from the time interval
 @param Time Interval
 @return Date part
 */
+ (NSString*)getFullDateFromTimeInterval:(NSTimeInterval)timeInterval;


+ (NSString*)getDateAndMonthFromTimeInterval:(NSTimeInterval)timeInterval;

/**
 @abstract This method will return date and time from the time interval
 @param Time Interval
 @return Date and time
 */
+ (NSString*)getDateTimeFromTimeInterval:(NSTimeInterval)timeInterval;

/**
 @abstract This method will return month part from the date interval
 @param Time Interval
 @return Short month name
 */
+ (NSString*)getMonthFromTimeInterval:(NSTimeInterval)timeInterval;

/**
 @abstract This method will return GMT offset as per the System time zone
 @param No Parameter
 @return GMT Offset
 */
+ (NSInteger)getGMTOffSet;

@end
